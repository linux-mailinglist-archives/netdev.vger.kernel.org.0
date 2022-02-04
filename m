Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772504A9FBE
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiBDTIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:08:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23413 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230302AbiBDTIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:08:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644001700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wvduRcsG0RKlj+VhykPegNKMRjhL3YvSHgG3mnL8SI=;
        b=UEy7nN0dTJyiM56rJbqnIaNqRjJGnMTsytTj5TAkfbGkX9q29JgnQLYe9JPOFuEbqPp5QM
        XEsX3FE2a2adfl95t3Eku/2WzP3/GWI5+7fHEIg9X4SBXZQPy+uL1OegF7DTMTO71tdqPM
        ps4v7h8O3wC0DPDNd8Hf/eZyE5DpgOA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-yLDwH3AQMsSpq-ip_4WDkg-1; Fri, 04 Feb 2022 14:08:19 -0500
X-MC-Unique: yLDwH3AQMsSpq-ip_4WDkg-1
Received: by mail-wm1-f69.google.com with SMTP id c7-20020a1c3507000000b0034a0dfc86aaso7945670wma.6
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 11:08:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7wvduRcsG0RKlj+VhykPegNKMRjhL3YvSHgG3mnL8SI=;
        b=tuOAicqT08P6FJVOTZOwklHBDIyedzMxi4TkY8IYuJMMjMzC4RN/9gIYzaGqWaiLDu
         7X/xPfLq+XQw5f4YK6Jo2MtHWNSOxRYpgNVdbpMTmvmnJBGLmrN0WJemSFlhuHAiyo9L
         EXgBCdHDExju42TappO3FvAkpcJ8H1jqDG98ure/Kc02rrvv3OzEaj89SI1AVmwBv2Lf
         YkKpMALc+jo6QTcAHGg9qYB5yWEQivQkmlXfLymVCogrwC65YFZkC8rqt+xq+br7XBwx
         TqkAhlLzuZAMCK/HakxL8i24GKWJn+Vhfmi8yOZz5muTWjUjALDEJtv9zUY1wCu2SC8/
         45xQ==
X-Gm-Message-State: AOAM531j+JmrbHAg2vAMbNlYuk2VqaKMynbie6F8aQO2wmhZEzUr23Cz
        UCEmkGVPWqs4iqBF0wZmx5yYl7qNnXp/Jd48FZ5aT2LiN+ZR8G5bKU/3RN7Eil5dIt3/TiGUTPY
        ougZaeLKyB2d9FV/f
X-Received: by 2002:a05:600c:4f0b:: with SMTP id l11mr3559518wmq.126.1644001697702;
        Fri, 04 Feb 2022 11:08:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwMqa6IDS3cQXvW84IObygfAYdI7syBBloQs8+MRHbNKTdn45fZkaHmf05xe7xgiiwDqaRjHA==
X-Received: by 2002:a05:600c:4f0b:: with SMTP id l11mr3559503wmq.126.1644001697478;
        Fri, 04 Feb 2022 11:08:17 -0800 (PST)
Received: from localhost (net-37-182-17-113.cust.vodafonedsl.it. [37.182.17.113])
        by smtp.gmail.com with ESMTPSA id m14sm3670513wrp.4.2022.02.04.11.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:08:17 -0800 (PST)
Date:   Fri, 4 Feb 2022 20:08:15 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, brouer@redhat.com,
        toke@redhat.com, andrii@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next] selftest/bpf: check invalid length in
 test_xdp_update_frags
Message-ID: <Yf15n2GJG70JrxX6@lore-desk>
References: <aff68ca785cae86cd6263355010ceaff24daee1f.1643982947.git.lorenzo@kernel.org>
 <c3858f6b-43d5-18ef-2fc8-b58c13c12b05@fb.com>
 <Yf1nxMWEWy4DSwgN@lore-desk>
 <15f829a2-8556-0545-7408-3fca66eb38b7@fb.com>
 <Yf1w2HRokiYBg8w9@lore-desk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cqU2QM2kHP2lKv/L"
Content-Disposition: inline
In-Reply-To: <Yf1w2HRokiYBg8w9@lore-desk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--cqU2QM2kHP2lKv/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> >=20
>=20
> [...]
>=20
> > > >=20
> > > > In kernel, the nr_frags checking is against MAX_SKB_FRAGS,
> > > > but if /proc/sys/net/core/max_skb_flags is 2 or more less
> > > > than MAX_SKB_FRAGS, the test won't fail, right?
> > >=20
> > > yes, you are right. Should we use the same definition used in
> > > include/linux/skbuff.h instead? Something like:
> > >=20
> > > if (65536 / page_size + 1 < 16)
> > > 	max_skb_flags =3D 16;
> > > else
> > > 	max_skb_flags =3D 65536/page_size + 1;
> >=20
> > The maximum packet size limit 64KB won't change anytime soon.
> > So the above should work. Some comments to explain why using
> > the above formula will be good.
>=20
> ack, I will do in v2.

I can see there is a on-going discussion here [0] about increasing
MAX_SKB_FRAGS. I guess we can put on-hold this patch and see how
MAX_SKB_FRAGS will be changed.

Regards,
Lorenzo

[0] https://lore.kernel.org/all/202202031315.B425Ipe8-lkp@intel.com/t/#ma1b=
2c7e71fe9bc69e24642a62dadf32fda7d5f03

>=20
> Regards,
> Lorenzo
>=20
> >=20
> > >=20
> > > Regards,
> > > Lorenzo
> > >=20
> > > >=20
> > > > > +
> > > > > +	num =3D fscanf(f, "%d", &max_skb_frags);
> > > > > +	fclose(f);
> > > > > +
> > > > > +	if (!ASSERT_EQ(num, 1, "max_skb_frags read failed"))
> > > > > +		goto out;
> > > > > +
> > > > > +	/* xdp_buff linear area size is always set to 4096 in the
> > > > > +	 * bpf_prog_test_run_xdp routine.
> > > > > +	 */
> > > > > +	buf_size =3D 4096 + (max_skb_frags + 1) * sysconf(_SC_PAGE_SIZE=
);
> > > > > +	buf =3D malloc(buf_size);
> > > > > +	if (!ASSERT_OK_PTR(buf, "alloc buf"))
> > > > > +		goto out;
> > > > > +
> > > > > +	memset(buf, 0, buf_size);
> > > > > +	offset =3D (__u32 *)buf;
> > > > > +	*offset =3D 16;
> > > > > +	buf[*offset] =3D 0xaa;
> > > > > +	buf[*offset + 15] =3D 0xaa;
> > > > > +
> > > > > +	topts.data_in =3D buf;
> > > > > +	topts.data_out =3D buf;
> > > > > +	topts.data_size_in =3D buf_size;
> > > > > +	topts.data_size_out =3D buf_size;
> > > > > +
> > > > > +	err =3D bpf_prog_test_run_opts(prog_fd, &topts);
> > > > > +	ASSERT_EQ(err, -ENOMEM, "unsupported buffer size");
> > > > > +	free(buf);
> > > > >    out:
> > > > >    	bpf_object__close(obj);
> > > > >    }
> > > >=20
> >=20



--cqU2QM2kHP2lKv/L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYf15nwAKCRA6cBh0uS2t
rAHNAP92BPcpOpjrWrHG5tRydtF5L4ysLp4WGeL2b5fq+NmJsAD/QjuGry+7eGXP
T70x2tMo05OwTlc/+RFUw3yfpn1l/Aw=
=NIAQ
-----END PGP SIGNATURE-----

--cqU2QM2kHP2lKv/L--

