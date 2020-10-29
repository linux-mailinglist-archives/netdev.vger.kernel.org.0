Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D45229E91E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgJ2Khz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:37:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29809 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726266AbgJ2Khy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603967872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LoWqcg7RB7Vl+ouPKOXZBLFY3TY7BBMAagHs2ZTvbKM=;
        b=N8QFM7T4hcUgvRMrI8AdBaM/XGR7cVAFh2K/Ncs5xW6mkufvmwP2t2uS0XoaM5Jj2Y9OT0
        k5xKX61KvVuTdYUfOmuAp1nGjSmfKcoEW8+xFui082SKoJkLm635m1dclNQwZVc5TA2sq3
        kKj1FslRD6IN5ar4/X/Hhvvj2w2tBwE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-R_WQhRBANlaoHf3b_ZZ40g-1; Thu, 29 Oct 2020 06:37:50 -0400
X-MC-Unique: R_WQhRBANlaoHf3b_ZZ40g-1
Received: by mail-wm1-f69.google.com with SMTP id f7so181198wmc.0
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 03:37:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LoWqcg7RB7Vl+ouPKOXZBLFY3TY7BBMAagHs2ZTvbKM=;
        b=AFHjMI9SWOpJqSPVi44XKnqLBw2SgJx25QwuvGpxL0lMA9vRFaWEtx9eRb+4VWUIhY
         3rbvKU5iqKX8suMkS+6jzrkuxSSP5N1Irg1AzwFxboUt7v1zexTTOh95ol00pAdL6FQt
         PDha31snEri1Ye642Ry7EQ6G94iAxXXX9RbxhqQXAWeKympJOBuf6Iq5VWULZaHP1UtY
         Bh1hHpC/trkW/4E2U411ZWMwJDk0FuKsU5ZVlGwnevymRk2RU3+PalCjTdVg6MDKHkwu
         lWGcP8n9TNyHTzu4ycZMrovwvUCvFPVwSxp9BEjcEOqtRkahwGMdqSbTAMuRGY5Vc9G4
         ZkBw==
X-Gm-Message-State: AOAM5317EyeNa+JnpUFTPw+5+Sis5bBBm/yT4gZQ+28zlkHRs94YaI0S
        78Vw3P3+ltBDWV7q6v6JNfdJnaqyLaPQ2MAit136GFXwNQtTki5O9/hOa+0MzinwvTY8uZhOkCW
        tNmK8FFteH10fjPwG
X-Received: by 2002:adf:8296:: with SMTP id 22mr2289934wrc.341.1603967869313;
        Thu, 29 Oct 2020 03:37:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhPQBlt1YgAfRRx/1cFMBMl0mGLusGa32leRnQtDsqb7onjoJLse2Cc8qml+J5yhSyWv7flg==
X-Received: by 2002:adf:8296:: with SMTP id 22mr2289910wrc.341.1603967869099;
        Thu, 29 Oct 2020 03:37:49 -0700 (PDT)
Received: from localhost ([151.66.29.159])
        by smtp.gmail.com with ESMTPSA id l3sm4547235wmg.32.2020.10.29.03.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:37:48 -0700 (PDT)
Date:   Thu, 29 Oct 2020 11:37:45 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next 2/4] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201029103745.GC15697@lore-desk>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <cd58ca966fbe11cabbd6160decea6ce748ebce9f.1603824486.git.lorenzo@kernel.org>
 <20201029072526.GA61828@apalos.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
In-Reply-To: <20201029072526.GA61828@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hOcCNbCCxyk/YU74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, Oct 27, 2020 at 08:04:08PM +0100, Lorenzo Bianconi wrote:
> > Introduce the capability to batch page_pool ptr_ring refill since it is
> > usually run inside the driver NAPI tx completion loop.
> >=20
> > Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  include/net/page_pool.h | 26 ++++++++++++++++++++++++++
> >  net/core/page_pool.c    | 33 +++++++++++++++++++++++++++++++++
> >  net/core/xdp.c          |  9 ++-------
> >  3 files changed, 61 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 81d7773f96cd..b5b195305346 100644

[...]

> > +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > +			     int count)
> > +{
> > +	struct page *page_ring[XDP_BULK_QUEUE_SIZE];
> > +	int i, len =3D 0;
> > +
> > +	for (i =3D 0; i < count; i++) {
> > +		struct page *page =3D virt_to_head_page(data[i]);
> > +
> > +		if (unlikely(page_ref_count(page) !=3D 1 ||
> > +			     !pool_page_reusable(pool, page))) {
> > +			page_pool_release_page(pool, page);
> > +			put_page(page);
> > +			continue;
> > +		}
> > +
> > +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > +			page_pool_dma_sync_for_device(pool, page, -1);
> > +
> > +		page_ring[len++] =3D page;
> > +	}
> > +
> > +	page_pool_ring_lock(pool);
> > +	for (i =3D 0; i < len; i++) {
> > +		if (__ptr_ring_produce(&pool->ring, page_ring[i]))
> > +			page_pool_return_page(pool, page_ring[i]);
>=20
> Can we add a comment here on why the explicit spinlock needs to protect=
=20
> page_pool_return_page() as well instead of just using ptr_ring_produce()?

ack, will do in v2.

Regards,
Lorenzo

>=20
> > +	}
> > +	page_pool_ring_unlock(pool);
> > +}
> > +EXPORT_SYMBOL(page_pool_put_page_bulk);
> > +
> >  static void page_pool_empty_ring(struct page_pool *pool)
> >  {
> >  	struct page *page;
> > diff --git a/net/core/xdp.c b/net/core/xdp.c
> > index 93eabd789246..9f9a8d14df38 100644
> > --- a/net/core/xdp.c
> > +++ b/net/core/xdp.c
> > @@ -383,16 +383,11 @@ EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
> >  void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
> >  {
> >  	struct xdp_mem_allocator *xa =3D bq->xa;
> > -	int i;
> > =20
> > -	if (unlikely(!xa))
> > +	if (unlikely(!xa || !bq->count))
> >  		return;
> > =20
> > -	for (i =3D 0; i < bq->count; i++) {
> > -		struct page *page =3D virt_to_head_page(bq->q[i]);
> > -
> > -		page_pool_put_full_page(xa->page_pool, page, false);
> > -	}
> > +	page_pool_put_page_bulk(xa->page_pool, bq->q, bq->count);
> >  	bq->count =3D 0;
> >  }
> >  EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> > --=20
> > 2.26.2
> >=20
>=20
> Thanks
> /Ilias
>=20

--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX5qbdwAKCRA6cBh0uS2t
rPbSAQDV0Nbla02xYvnDQ/pk0LPM6cNtuOKKYd9EFguupAe+uQD+IwBpLxguInNI
gRSok5ptbUBSZ5fDR5y0geCxhoGccAE=
=4+Fo
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--

