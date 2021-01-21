Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5CF2FE957
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730636AbhAULw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729567AbhAULw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:52:28 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE42C061757
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:51:48 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id q129so3427249iod.0
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zo43UlXf+ZoXXn1xxCr++9QZL5RRkEl+7dR7xniqIfc=;
        b=ILmZv1DetRLRvF38AZIzuqZVDEZOD2uLJ3m4Y5ZWeseJRd1MzanB8gHCK7IClEHFKo
         4D+kdOlq/HDELDIuA+ee22e5ArZLEjQb5iKKOBehCwspFb4BVWpFSvVJUN6VqJGr2xl5
         1H2JDOY40KmL6QkTkd3RneiVNzcJYPniU6X7Zb/Atmf/zMJDHr9o/ruJQMvQeZQMBfof
         ylSqlB1+ash4xrfeHPLECSOmsgzK45tLKJlU8r9zaS99C1bkLn2/oG5t1mjsXfaM4XGS
         pSvL+0asjti1Hi0TDX2Mx9CH91skm19vxPFFkiPriru4CPAuFXb3B4LrvkOkBBACoWPU
         68gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zo43UlXf+ZoXXn1xxCr++9QZL5RRkEl+7dR7xniqIfc=;
        b=R+YcCzyiihahWe8QdaSUhrdKv+T5K5QVGBtJ5z+j0RK/GTkyXOG7CifT/Ry7MoPpNQ
         L/5QW8/Q8KnLAQ+O6pr4cjETfks5E+/jUetXOZU2tzDnYs3v6wTUOMQBLLrKQHRpJwue
         ysRkqJfDDDG2EfohotCf0zhhk2DL50lzQtJGh8/hjOot9hp8yAkzfIoxSXPuROZpE3S3
         kX+UZo4kU4tOi11NxlLxm/0Ff+v8csU1+w8xU6JOl5scpISGtFk0TTOLXUJbi8EVdlKU
         BW8jgfhhMxBXup005KGZDHltmOy+XA9aGfvX1RaE5lowVjnAldtQRKtWjBqywSgE1E26
         xNmA==
X-Gm-Message-State: AOAM533YgGQpTNu4fAFHAahUcf2DWVC5EQ5iXJ8/RDLbIyq5ii+0Djb1
        53SEx3j7RHNtvf54qFdxNmk=
X-Google-Smtp-Source: ABdhPJwsv202K53K3mmMNqtpbzhj+YzNP3OnwFiujlxgbsHRaSSUEiQ4mepWUfbA8s578lE2+gTbMw==
X-Received: by 2002:a92:c567:: with SMTP id b7mr12109103ilj.25.1611229907607;
        Thu, 21 Jan 2021 03:51:47 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id l1sm2822081ilm.16.2021.01.21.03.51.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 03:51:46 -0800 (PST)
Date:   Thu, 21 Jan 2021 19:51:41 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>
Subject: Re: [PATCH] net: octeontx2: Make sure the buffer is 128 byte aligned
Message-ID: <20210121115141.GA472545@pek-khao-d2.corp.ad.wrs.com>
References: <20210121070906.25380-1-haokexin@gmail.com>
 <8a9fdef33fd54340a9b36182fd8dc88e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Content-Disposition: inline
In-Reply-To: <8a9fdef33fd54340a9b36182fd8dc88e@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 21, 2021 at 09:53:08AM +0000, David Laight wrote:
> From: Kevin Hao
> > Sent: 21 January 2021 07:09
> >=20
> > The octeontx2 hardware needs the buffer to be 128 byte aligned.
> > But in the current implementation of napi_alloc_frag(), it can't
> > guarantee the return address is 128 byte aligned even the request size
> > is a multiple of 128 bytes, so we have to request an extra 128 bytes and
> > use the PTR_ALIGN() to make sure that the buffer is aligned correctly.
> >=20
> > Fixes: 7a36e4918e30 ("octeontx2-pf: Use the napi_alloc_frag() to alloc =
the pool buffers")
> > Reported-by: Subbaraya Sundeep <sbhatta@marvell.com>
> > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > ---
> >  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > index bdfa2e293531..5ddedc3b754d 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > @@ -488,10 +488,11 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2_nic *pfv=
f, struct otx2_pool *pool)
> >  	dma_addr_t iova;
> >  	u8 *buf;
> >=20
> > -	buf =3D napi_alloc_frag(pool->rbsize);
> > +	buf =3D napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
> >  	if (unlikely(!buf))
> >  		return -ENOMEM;
> >=20
> > +	buf =3D PTR_ALIGN(buf, OTX2_ALIGN);
> >  	iova =3D dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
> >  				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
> >  	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {
> > --
> > 2.29.2
>=20
> Doesn't that break the 'free' code ?
> Surely it needs the original pointer.

Why do we care about the original pointer? The free code should work with
the mangling poiner. Did I miss something?

>=20
> It isn't obvious that page_frag_free() it correct when the
> allocator is napi_alloc_frag() either.
> I'd have thought it ought to be returned to the pool.

Sorry, I didn't get what you mean. Could you elaborate a bit more?

Thanks,
Kevin

>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1=
 1PT, UK
> Registration No: 1397386 (Wales)
>=20

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmAJas0ACgkQk1jtMN6u
sXFd0AgAuRCNNwkY0xzpZ8yBdKmrnth/FvCGfUl7NpE8o0whypkPuGwQdyYAgtSQ
UKRRy/4HcI7T6pBc0SJoVDQf3R6r0asjq2/8JIJicnnhq0T62r6r2Gg7M7p78SP0
cpJRvA9kB+G4Lsk5dCYAeRn3nMU6f6GO44fx2XBC20wm34PaTOujMo//oaHM6Zw+
nTN2yYOJwKyaAeKulCwo2qAD6ow6BNa5FFwMgHzHm4INwMCv0ZhpOTpD8lO5tP4Y
pf9lyNNapKN962gwhx/Ty7WYAppVyuCm3K0mxpYj3AnoKkxSKtwpU6GrjGbGnZGZ
5BN50N4KlS68Hepj8eWkOSFAFZ/r4A==
=LgAy
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
