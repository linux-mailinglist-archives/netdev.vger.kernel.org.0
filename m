Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4745D4A9F09
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377541AbiBDSaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:30:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38433 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377537AbiBDSaz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:30:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643999454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Hky5DV8TETGJOkKLGTwiJ+rckhbkE1SoswbmzyRxFIg=;
        b=Khey4xciJL0UehHBhJSPvgaDSEoRuyUQ2eC4Ua3BCc+E+l1YNiNtYf4jn5bNEPO0pNThhT
        w8A1W40giUQvm7hMvCSZRtE7ZZSevgQjnlvvCtDlRWF2SqCcRxQVPJr0yZ18DQ82VvtBgu
        Ob7I/qV8nERx1C7KbPgkaDG3XTfh2l4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-XVO30CmnN7i1aUaetiFm4w-1; Fri, 04 Feb 2022 13:30:53 -0500
X-MC-Unique: XVO30CmnN7i1aUaetiFm4w-1
Received: by mail-qt1-f199.google.com with SMTP id h22-20020ac85696000000b002d258f68e98so5256059qta.22
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:30:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Hky5DV8TETGJOkKLGTwiJ+rckhbkE1SoswbmzyRxFIg=;
        b=y6gfzdm6JVThSR/+M6f/vtsEyjt007cdaQqZaeteMsf1nXScJRh4Q1wbisSjCDLJkG
         RxmgrdX6myBcXOx6MVIGFRhycVqy721JplxXEAF3oWTjhK7PMCA50UZqeIZHMChGdOH6
         L7W5eZ2ushqpSHhWE9kBGAYeDJya5pmmZf1D0fqEqcYSoFyUevxZryJUbyjkoxw6rI+f
         qGmEtrvwRx+Aau6vox/YbSfmafLS04S8aGXwXgYYWnNO28kq/LGKYXffC07wSczCimCn
         2cNXdG77xQrh7LuBC5twU+sFU89PGk9SjW2WJ/EiF0bfqU4EmNHzLriMEKOWmY1APzH8
         2iFA==
X-Gm-Message-State: AOAM530tH1NLHLFch7kKfUJdPZffSxjXOguQtIVD5ICqhWaeLiAmq9RV
        +gSD0oBcAQzvcTf5fxdelHV3WO0UShOrEe4qCZpJm2Wv8WpYiAJDyeN700xoebpGBkmUUQoBFht
        6VJeQrVtJIMdGJAK6
X-Received: by 2002:a37:a1c5:: with SMTP id k188mr247384qke.461.1643999452516;
        Fri, 04 Feb 2022 10:30:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyOPY3yoAy87MjHfNDO5xeTaMZyBuP8HYYSVda3BgG9lYhwByyZHrg0XNpqwLCpf5WqlwSz0g==
X-Received: by 2002:a37:a1c5:: with SMTP id k188mr247369qke.461.1643999452261;
        Fri, 04 Feb 2022 10:30:52 -0800 (PST)
Received: from localhost (net-37-182-17-113.cust.vodafonedsl.it. [37.182.17.113])
        by smtp.gmail.com with ESMTPSA id c14sm1585342qtc.31.2022.02.04.10.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 10:30:51 -0800 (PST)
Date:   Fri, 4 Feb 2022 19:30:48 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, andrii@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftest/bpf: check invalid length in
 test_xdp_update_frags
Message-ID: <Yf1w2HRokiYBg8w9@lore-desk>
References: <aff68ca785cae86cd6263355010ceaff24daee1f.1643982947.git.lorenzo@kernel.org>
 <c3858f6b-43d5-18ef-2fc8-b58c13c12b05@fb.com>
 <Yf1nxMWEWy4DSwgN@lore-desk>
 <15f829a2-8556-0545-7408-3fca66eb38b7@fb.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="irYz3dtSM2qqlyd7"
Content-Disposition: inline
In-Reply-To: <15f829a2-8556-0545-7408-3fca66eb38b7@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--irYz3dtSM2qqlyd7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>=20

[...]

> > >=20
> > > In kernel, the nr_frags checking is against MAX_SKB_FRAGS,
> > > but if /proc/sys/net/core/max_skb_flags is 2 or more less
> > > than MAX_SKB_FRAGS, the test won't fail, right?
> >=20
> > yes, you are right. Should we use the same definition used in
> > include/linux/skbuff.h instead? Something like:
> >=20
> > if (65536 / page_size + 1 < 16)
> > 	max_skb_flags =3D 16;
> > else
> > 	max_skb_flags =3D 65536/page_size + 1;
>=20
> The maximum packet size limit 64KB won't change anytime soon.
> So the above should work. Some comments to explain why using
> the above formula will be good.

ack, I will do in v2.

Regards,
Lorenzo

>=20
> >=20
> > Regards,
> > Lorenzo
> >=20
> > >=20
> > > > +
> > > > +	num =3D fscanf(f, "%d", &max_skb_frags);
> > > > +	fclose(f);
> > > > +
> > > > +	if (!ASSERT_EQ(num, 1, "max_skb_frags read failed"))
> > > > +		goto out;
> > > > +
> > > > +	/* xdp_buff linear area size is always set to 4096 in the
> > > > +	 * bpf_prog_test_run_xdp routine.
> > > > +	 */
> > > > +	buf_size =3D 4096 + (max_skb_frags + 1) * sysconf(_SC_PAGE_SIZE);
> > > > +	buf =3D malloc(buf_size);
> > > > +	if (!ASSERT_OK_PTR(buf, "alloc buf"))
> > > > +		goto out;
> > > > +
> > > > +	memset(buf, 0, buf_size);
> > > > +	offset =3D (__u32 *)buf;
> > > > +	*offset =3D 16;
> > > > +	buf[*offset] =3D 0xaa;
> > > > +	buf[*offset + 15] =3D 0xaa;
> > > > +
> > > > +	topts.data_in =3D buf;
> > > > +	topts.data_out =3D buf;
> > > > +	topts.data_size_in =3D buf_size;
> > > > +	topts.data_size_out =3D buf_size;
> > > > +
> > > > +	err =3D bpf_prog_test_run_opts(prog_fd, &topts);
> > > > +	ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
> > > > +	free(buf);
> > > >    out:
> > > >    	bpf_object__close(obj);
> > > >    }
> > >=20
>=20

--irYz3dtSM2qqlyd7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYf1w2AAKCRA6cBh0uS2t
rCxbAP4sAKdKzKqmJ6s28ObVC75VJ40wpNS+Dk8eqCmFaVM4AAD9FV+GejVCGHut
Uro6CvBap+3Dw5XbOuC0jJ8JxzGoCg0=
=vDVZ
-----END PGP SIGNATURE-----

--irYz3dtSM2qqlyd7--

