Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B911CA9BE
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgEHLhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726616AbgEHLhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:37:21 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528EFC05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 04:37:20 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t11so766279pgg.2
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 04:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mfR52MDsyjTnA9H4OVuPQexLyhkWHIlQ6KYc6kdbY4w=;
        b=EviDW83F6yoRUNdJ2LuuOOiSQFHnz2Y7NDZYujogmKzSrm0AKwf7Rpin+DLPCVJznP
         fIquQQAblPXtdt0m3Shrgwpmh38zbjQdjKDoyy1LktePbA8yEHytYnIick4nbOFonM84
         vNYOzvRz3sLkqIFtrPQpTk5xYyYlFQJaSbsjXqeJFA4kRgh6rJj42VgOoqpqN/wjFHgl
         6H9VVpSTS5ymywkFZXAWOJ/aISaRAzunRacY+qUoAXfaEvKb7Cw0+DBxBO2Xlc6RJdm4
         bJ175sz/hQ41BupviNaasYlPf7C10FnEI9elosNGheOX+wbV1R0tcKxgRqNnGBVl2YML
         nPrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mfR52MDsyjTnA9H4OVuPQexLyhkWHIlQ6KYc6kdbY4w=;
        b=nA+xGCFakQziJ7u0By9efLG1Ac1BxFn6UoHLl/rQL9coi+WnYNveBmwsEf8ZGv8vng
         KszNyX+3gEWe8PWOhTPJzdHEbYCKN4M0X8xtZ/QZLyVTlo48QcAmiW9Rq/h106HMggB3
         XRPwnPIg3hAjqAUcwgXSQGj3mI7QvwC0jJ1iYO7RX4qnTsyb8nv1vxRoVW+VdDhEKCX5
         hxP5h/5PARLwQlY2Ln4a+F4KaJeocbOngiCV6gFISz7TiIednmyZqit8IxrZ/3t30jF3
         /FV+Vuk4xFPYi649aWJRBPQBuXVPS593FeWJE9QeI0P3c7Lo1tRpdPy4ruhRBCigVH/K
         AoJw==
X-Gm-Message-State: AGi0Pua1koARFmXY37xLkU7i7GVvOZOzhtdb1pG/Z/tVWHeahpkC+i7K
        siiuhVWPBU3JcQho0bwD/1CguucU8Qo=
X-Google-Smtp-Source: APiQypJC924mDNfbRws7or60M1n8mAp5Ewz4rJHjFQDJebMWe6O47woBPEqx8skHXkKVFHMeaSDalg==
X-Received: by 2002:a63:5fc1:: with SMTP id t184mr1864324pgb.48.1588937839730;
        Fri, 08 May 2020 04:37:19 -0700 (PDT)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-123.windriver.com. [147.11.105.123])
        by smtp.gmail.com with ESMTPSA id p7sm1219006pgg.91.2020.05.08.04.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 04:37:18 -0700 (PDT)
Date:   Fri, 8 May 2020 19:37:10 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] octeontx2-pf: Use the napi_alloc_frag() to alloc the
 pool buffers
Message-ID: <20200508113710.GJ3222151@pek-khao-d2.corp.ad.wrs.com>
References: <20200508040728.24202-1-haokexin@gmail.com>
 <CA+sq2CfoY1aRC2BernvqaMGgTgCByM+yq19-Vak0KJqxEU-5Eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IJFRpmOek+ZRSQoz"
Content-Disposition: inline
In-Reply-To: <CA+sq2CfoY1aRC2BernvqaMGgTgCByM+yq19-Vak0KJqxEU-5Eg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IJFRpmOek+ZRSQoz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 08, 2020 at 01:10:00PM +0530, Sunil Kovvuri wrote:
> On Fri, May 8, 2020 at 9:43 AM Kevin Hao <haokexin@gmail.com> wrote:
> >
> > In the current codes, the octeontx2 uses its own method to allocate
> > the pool buffers, but there are some issues in this implementation.
> > 1. We have to run the otx2_get_page() for each allocation cycle and
> >    this is pretty error prone. As I can see there is no invocation
> >    of the otx2_get_page() in otx2_pool_refill_task(), this will leave
> >    the allocated pages have the wrong refcount and may be freed wrongly.
> > 2. It wastes memory. For example, if we only receive one packet in a
> >    NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
> >    to refill the pool buffers and leave the remain area of the allocated
> >    page wasted. On a kernel with 64K page, 62K area is wasted.
> >
> > IMHO it is really unnecessary to implement our own method for the
> > buffers allocate, we can reuse the napi_alloc_frag() to simplify
> > our code.
> >
> > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > ---
> >  .../marvell/octeontx2/nic/otx2_common.c       | 51 ++++++++-----------
> >  .../marvell/octeontx2/nic/otx2_common.h       | 15 +-----
> >  .../marvell/octeontx2/nic/otx2_txrx.c         |  3 +-
> >  .../marvell/octeontx2/nic/otx2_txrx.h         |  4 --
> >  4 files changed, 22 insertions(+), 51 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b=
/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > index f1d2dea90a8c..15fa1ad57f88 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> > @@ -379,40 +379,32 @@ void otx2_config_irq_coalescing(struct otx2_nic *=
pfvf, int qidx)
> >                      (pfvf->hw.cq_ecount_wait - 1));
> >  }
> >
> > -dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *po=
ol,
> > -                          gfp_t gfp)
> > +dma_addr_t _otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *p=
ool)
> >  {
> >         dma_addr_t iova;
> > +       u8 *buf;
> >
> > -       /* Check if request can be accommodated in previous allocated p=
age */
> > -       if (pool->page && ((pool->page_offset + pool->rbsize) <=3D
> > -           (PAGE_SIZE << pool->rbpage_order))) {
> > -               pool->pageref++;
> > -               goto ret;
> > -       }
> > -
> > -       otx2_get_page(pool);
> > -
> > -       /* Allocate a new page */
> > -       pool->page =3D alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> > -                                pool->rbpage_order);
> > -       if (unlikely(!pool->page))
> > +       buf =3D napi_alloc_frag(pool->rbsize);
> > +       if (unlikely(!buf))
> >                 return -ENOMEM;
> >
> > -       pool->page_offset =3D 0;
> > -ret:
> > -       iova =3D (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_of=
fset,
> > -                                     pool->rbsize, DMA_FROM_DEVICE);
> > -       if (!iova) {
> > -               if (!pool->page_offset)
> > -                       __free_pages(pool->page, pool->rbpage_order);
> > -               pool->page =3D NULL;
> > +       iova =3D dma_map_single(pfvf->dev, buf, pool->rbsize, DMA_FROM_=
DEVICE);
> > +       if (unlikely(dma_mapping_error(pfvf->dev, iova)))
> >                 return -ENOMEM;
>=20
> Use DMA_ATTR_SKIP_CPU_SYNC while mapping the buffer.

Sure. V2 is coming.

Thanks,
Kevin

>=20
> Thanks,
> Sunil.

--IJFRpmOek+ZRSQoz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAl61RGYACgkQk1jtMN6u
sXHuowf/SM05rbMyhVLFR3Q1w5bCy8IGTjTa/04u2599Li6EL8xmk+f03U+LmP4L
B93rig06OQaFf/AUlI9xu7BjArKyigEL4YuX60y03It6qx/G0RHBIZgHyz2eFYgj
GvZfMsJV0KWYgaTgysqgSO10UkQwcOo4ctYnAP9BTAeiF2TyqhY4rEDFz4EvOEWZ
S/nnJ4aKl996XVRaH3OxRdK0tV5htuKWfMEBM80QB49ozE8XqvdlvK0wTLufAhXK
uGkfNn+FmFzcosU9oNAy/b1PUn+Ys8uC3xVnm2CNLtfb3ba21uuPEsvEpnYtLTxd
BM2kXvncbwG8mOc2gDqEJWaLA5Ckpg==
=lzrr
-----END PGP SIGNATURE-----

--IJFRpmOek+ZRSQoz--
