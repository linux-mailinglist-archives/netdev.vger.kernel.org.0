Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4231CBBFE
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 02:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728194AbgEIAxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 20:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727959AbgEIAxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 20:53:43 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEBAC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 17:53:42 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id fu13so5053976pjb.5
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 17:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i9YShQ+BanH9M3KoBLMpJiaQQC0GN9gEM4B+t50SqnM=;
        b=BjnsMy5AMMqULYLt18/TcKHnu7kzLw812pSXgsUTqjHY6h0mzOyr6k0865i0Sog/F3
         85umUTYkn4SC2mdARg6mG5iLIr+3HzbdKk+BLymIXqc2dvu/N02v4On4hjjPyugtu1F9
         y7UqNEFiGRTHR8dBvyo+4GwMG+/MicnB+qObUbK9iPLCQnbSeLrwlhJKP4/5Of3WacrB
         NUlzWpWx7xZwJbvNfDUDfA+Du6xHyEoQFtn0nyccavuJ+V8rJiIijTGhZzRgR426xJHJ
         L2f2dGj08C5ASN+0cuV3fTMThAxdU4g8IUc7H2HiFU2y7rVybS3tuXv0gPppgY2XNHiw
         Ui9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i9YShQ+BanH9M3KoBLMpJiaQQC0GN9gEM4B+t50SqnM=;
        b=mHZqdoz+XiiXmaL4i5j8Ain7ZAEZ8rBjBERRSnGp2zMigbG6gIRMDXD7gtl11tpuYT
         A8iWtzd0JnoZwsufrIx71xtp90vXIqit2THy2qlAt1l6mx0QYR/S7ngyRIOL9tfisrTA
         pmNKZpF4CkocmyxxzkTiPqRWdXFq1sRWqYowD6eJKbW4AIRccMYVuOcPH2JRs4lrSmVe
         82iSQOYZCcmwPZJjZmmEbbKbCwywboR0u9gAN/w00u9sAbxOMvHyd70j+RiqB9/siLNd
         iUiBHJKA/qZZu+qisd6AOaC0qmWid4iSdt7BtgQBVUhzcYu0A+wWr/EJKYH10pk/kMs2
         bROw==
X-Gm-Message-State: AGi0PuawlwnkUHZ7xjQyEq1HqGWRmZB/p3a2DJLKvX9lo1ZvfmxqqJKp
        JNY+Gm6/AnuU/TC7s2Rh/ro=
X-Google-Smtp-Source: APiQypLNfQFA8V7tiI4ZQxQG8XgTiajI9BjOX8o/Gxx8J76gK5b++qgtj5RAyrzIYpx5wrbP9H+Ywg==
X-Received: by 2002:a17:902:8496:: with SMTP id c22mr5014787plo.182.1588985622259;
        Fri, 08 May 2020 17:53:42 -0700 (PDT)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id b1sm2922165pfi.140.2020.05.08.17.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 17:53:41 -0700 (PDT)
Date:   Sat, 9 May 2020 08:53:32 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>, davem@davemloft.net,
        Sunil Kovvuri <sunil.kovvuri@gmail.com>
Subject: Re: [PATCH v2] octeontx2-pf: Use the napi_alloc_frag() to alloc the
 pool buffers
Message-ID: <20200509005332.GK3222151@pek-khao-d2.corp.ad.wrs.com>
References: <20200508114953.2753-1-haokexin@gmail.com>
 <20200508173833.0f48cccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XjbSsFHOHxvQpKib"
Content-Disposition: inline
In-Reply-To: <20200508173833.0f48cccc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--XjbSsFHOHxvQpKib
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 08, 2020 at 05:38:33PM -0700, Jakub Kicinski wrote:
> On Fri,  8 May 2020 19:49:53 +0800 Kevin Hao wrote:
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b=
/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > index f1d2dea90a8c..612d33207326 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > @@ -379,40 +379,33 @@ void otx2_config_irq_coalescing(struct otx2_nic *=
pfvf, int qidx)
> >  		     (pfvf->hw.cq_ecount_wait - 1));
> >  }
> > =20
> > -dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *po=
ol,
> > -			   gfp_t gfp)
> > +dma_addr_t _otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *p=
ool)
>=20
> If you need to respin please use double underscore as a prefix, it's
> a far more common style in the kernel.

Sure.

>=20
> >  {
> >  	dma_addr_t iova;
> > +	u8 *buf;
> > =20
> > -	/* Check if request can be accommodated in previous allocated page */
> > -	if (pool->page && ((pool->page_offset + pool->rbsize) <=3D
> > -	    (PAGE_SIZE << pool->rbpage_order))) {
> > -		pool->pageref++;
> > -		goto ret;
> > -	}
> > -
> > -	otx2_get_page(pool);
> > -
> > -	/* Allocate a new page */
> > -	pool->page =3D alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> > -				 pool->rbpage_order);
> > -	if (unlikely(!pool->page))
> > +	buf =3D napi_alloc_frag(pool->rbsize);
> > +	if (unlikely(!buf))
> >  		return -ENOMEM;
> > =20
> > -	pool->page_offset =3D 0;
> > -ret:
> > -	iova =3D (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
> > -				      pool->rbsize, DMA_FROM_DEVICE);
> > -	if (!iova) {
> > -		if (!pool->page_offset)
> > -			__free_pages(pool->page, pool->rbpage_order);
> > -		pool->page =3D NULL;
> > +	iova =3D dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
> > +				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
> > +	if (unlikely(dma_mapping_error(pfvf->dev, iova)))
>=20
> Thanks for doing this, but aren't you leaking the buf on DMA mapping
> error?

Ouch, I missed that. Will fix.

Thanks,
Kevin

>=20
> >  		return -ENOMEM;
> > -	}
> > -	pool->page_offset +=3D pool->rbsize;
> > +
> >  	return iova;
> >  }

--XjbSsFHOHxvQpKib
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAl61/wwACgkQk1jtMN6u
sXFyBAgAqgLdGg7UZkm2Q4T7jWaV1zswTPmmp8f6AJPb1w9GwyVNhbSL2GP+SwXq
KYZi2FxwZ0lIKQq5F/fAIBUYkrxXt0mHt1Ft3z8LBzONk4VBBeZocn05Ywhdfhkc
H/BgNhYS1y31jSFxBzfrQMQX02e1Ha6vNUD/ARO83EH82ZzQH79F9uSoy7H7mboN
UQGSneSb7U+Y9ZOuF/psteNFjRgDXESNcerfnXAmjuxjZtj7/Hdv8Q5YWlcwXGXL
YbyT2GC7+nsW7odq6MmFeQrg2jiIXl8DvY4uhJXxc+gwemEaKwb3swuwBngi+3bc
GHEDQDdHF4xAAJmYMdd765cdSjjHMw==
=MEYf
-----END PGP SIGNATURE-----

--XjbSsFHOHxvQpKib--
