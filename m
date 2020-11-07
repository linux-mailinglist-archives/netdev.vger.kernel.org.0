Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B112AA5F7
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 15:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728181AbgKGO31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 09:29:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25118 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbgKGO3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 09:29:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604759362;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MInUkCIO41+rIkeCbKLSVB9OTGimtitA3WjdysKoXLI=;
        b=hJFr1JW0VqzABT88m4KO8Sz/sYpfFu8gw634AooEZDNRvHjFyjyrDNwgTDYsIem7MPMEHj
        KOXaipJSh/pXQjEl3DOSyJ0+paLThhfl2Izil0/LCDXDPV4EHW1MAeSN4VSgutGIaD7ZSU
        gDVXxLdpPePcMFTNPRvI4u78yAV7slM=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-VZPA7OCdNb63FvnTIOdJsg-1; Sat, 07 Nov 2020 09:29:20 -0500
X-MC-Unique: VZPA7OCdNb63FvnTIOdJsg-1
Received: by mail-ej1-f71.google.com with SMTP id e9so1720366ejb.16
        for <netdev@vger.kernel.org>; Sat, 07 Nov 2020 06:29:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MInUkCIO41+rIkeCbKLSVB9OTGimtitA3WjdysKoXLI=;
        b=l9a0Y0sfanKE/ke0lWrtZh7hlkmrdSNI/9rnZpHSGn+Vbow4L47JkC9PwxApUtyrS4
         upvqtBUwhv9EE0FgcxT8O6aB36T8LC7ODbR6KQNizrjeQ53QUPvMh6UM2D8GUmKgDIFh
         NxGVmsMNAfaQmFuTFZPPH4p8k0lprZlPE+WXP9ExKg6s6eVpXXpritQSa1zhUioFPL8W
         S2LJNhW672QUBFjE2uLy4yHHrBIX8Ev0cE3WjpSwfoeZVCnqkOS2WagMCopROCBVgKY0
         w1lcAekRXJ7wdoSJO8PReAMkVD66pGvaXvrWqh3u2Op+cmikCh/v/QNq7DGUnWcDPKEs
         iS3g==
X-Gm-Message-State: AOAM531JLtj8TRp04HL4Jh7Dv5mPQtEQFPxWK7sFyIa7i2dg4KYbwKqs
        j2vu4GZARq0/KkjzJcruLkb0Tyi3lSQpiPZZd4R49pk1/CzevR4lLW1N6dTZxW/OAoBnGWtC9Xb
        5OsQRo34Yr5g88occ
X-Received: by 2002:a17:906:a110:: with SMTP id t16mr6820173ejy.538.1604759359169;
        Sat, 07 Nov 2020 06:29:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxkl9oKzN6NzwTHNl/Pbqp32lc2gFlnVGu4gGbLdcf4kXpM1WXjgVcM2VNP1uVd3F2KxexafA==
X-Received: by 2002:a17:906:a110:: with SMTP id t16mr6820161ejy.538.1604759358861;
        Sat, 07 Nov 2020 06:29:18 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id t22sm3461800edq.64.2020.11.07.06.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 06:29:17 -0800 (PST)
Date:   Sat, 7 Nov 2020 15:29:13 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v4 net-next 2/5] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201107142913.GA2901@lore-desk>
References: <cover.1604686496.git.lorenzo@kernel.org>
 <1a39bf0efb8c2832245216d7ccd41582c408e9f4.1604686496.git.lorenzo@kernel.org>
 <20201106210201.644d722a@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20201106210201.644d722a@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri,  6 Nov 2020 19:19:08 +0100
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
[...]
>=20
> I don't like this comment.  This function is also used by non-bulking
> case.  Reaching this point means the page is ready or fulfill the
> requirement for being recycled into the ptr_ring.
>=20
> I suggest (as before):
> 		/* Page found as candidate for recycling */

ack, I will fix it in v5.

Regards,
Lorenzo

>=20
> > +		return page;
> >  	}
> >  	/* Fallback/non-XDP mode: API user have elevated refcnt.
> >  	 *
> > @@ -405,9 +405,55 @@ void page_pool_put_page(struct page_pool *pool, st=
ruct page *page,
> >  	/* Do not replace this with page_pool_return_page() */
> >  	page_pool_release_page(pool, page);
> >  	put_page(page);
> > +
> > +	return NULL;
> > +}
> > +
> > +void page_pool_put_page(struct page_pool *pool, struct page *page,
> > +			unsigned int dma_sync_size, bool allow_direct)
> > +{
> > +	page =3D __page_pool_put_page(pool, page, dma_sync_size, allow_direct=
);
> > +	if (page && !page_pool_recycle_in_ring(pool, page)) {
> > +		/* Cache full, fallback to free pages */
> > +		page_pool_return_page(pool, page);
> > +	}
> >  }
> >  EXPORT_SYMBOL(page_pool_put_page);
> > =20
> > +/* Caller must not use data area after call, as this function overwrit=
es it */
> > +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > +			     int count)
> > +{
> > +	int i, bulk_len =3D 0, pa_len =3D 0;
> > +
> > +	for (i =3D 0; i < count; i++) {
> > +		struct page *page =3D virt_to_head_page(data[i]);
> > +
> > +		page =3D __page_pool_put_page(pool, page, -1, false);
> > +		/* Approved for bulk recycling in ptr_ring cache */
> > +		if (page)
> > +			data[bulk_len++] =3D page;
> > +	}
> > +
> > +	if (!bulk_len)
> > +		return;
> > +
> > +	/* Bulk producer into ptr_ring page_pool cache */
> > +	page_pool_ring_lock(pool);
> > +	for (i =3D 0; i < bulk_len; i++) {
> > +		if (__ptr_ring_produce(&pool->ring, data[i]))
> > +			data[pa_len++] =3D data[i];
> > +	}
> > +	page_pool_ring_unlock(pool);
> > +
> > +	/* ptr_ring cache full, free pages outside producer lock since
> > +	 * put_page() with refcnt =3D=3D 1 can be an expensive operation
> > +	 */
> > +	for (i =3D 0; i < pa_len; i++)
> > +		page_pool_return_page(pool, data[i]);
> > +}
> > +EXPORT_SYMBOL(page_pool_put_page_bulk);
>=20
> Rest looks okay :-)
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX6avNgAKCRA6cBh0uS2t
rBvWAP9D9/phF5f+JHZqamch58gx6s8E2RwAbjdvJsDSa8gUzgEAzXOk2hXdJ8Xj
x1gdO/tXFWGW3phjPuJfmAqlr8/sow4=
=9mX4
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--

