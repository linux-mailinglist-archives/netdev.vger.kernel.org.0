Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1112A66BA
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgKDOuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:50:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbgKDOuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 09:50:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604501400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pHkask1NbVbkjtWb4PU5OG+yT5odtETkyXP7R5ySKgY=;
        b=M+MmOxh80lpPEMRLPzNXiT+8nS8WmHp+P2O7OQja+3YjdW0EiHAAKjX+rCX5KZDCu0YJdZ
        aypkWP/LVp7z8Tk4PzrspfCwBBpRA9oehOsgj24T67JKDk1eNYX/85U2REWCS6eDDuws4R
        3CBJubEchLCTHeTozcrG8I3qL9WtchQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-tr1z1zOROXyRELmMoUbuJw-1; Wed, 04 Nov 2020 09:49:58 -0500
X-MC-Unique: tr1z1zOROXyRELmMoUbuJw-1
Received: by mail-wr1-f71.google.com with SMTP id b6so9284699wrn.17
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 06:49:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pHkask1NbVbkjtWb4PU5OG+yT5odtETkyXP7R5ySKgY=;
        b=U7RSIIUgUTZtkx83J0iRh3/nLnqUuAYiflBeu9Ut2/qpGfy91dPpRDYIxdJ+Vn1t+S
         thRDh+Uf23oYKuDbc9tVzm09nEz8pGCiYE2VfQAr9gBLaqfZQIh8DRkIQ3NYGsZYeSgH
         ZZ4q3zz/mYH6eS+cgQek34tR1L5HURboWIrvVfTXzvJaAIGZSzPgW2Ybl4k9l+uoKhN4
         pyx3vcEShi5VEF2hmsLEqFShdqUJDO4CLZm44oUIlxyyzPe3bGbQ8Rq3kFC/1lDRJ/WH
         C82Ugt9qeRRa1rhlXOZiav6Dx87qbprqw2lMmdkCR9ZY6pk1gi4dIuUMudcH6AN+XKiN
         UNDg==
X-Gm-Message-State: AOAM531wGtqnM3p7hUTCbnGRuAyZ5Jak4N0a5rZAR4QmLEdhnH+fL0xe
        E6UGdimpdLnlk38Jo38JYc8IOj3h+NjfDYbInD+HGULYfs+JqOBurH8ClaEer+Zz92RhwkkiLiW
        DCyH9q0xENcEtSyDK
X-Received: by 2002:a1c:f311:: with SMTP id q17mr4888243wmq.28.1604501394225;
        Wed, 04 Nov 2020 06:49:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxsd+upekuKO+E7Wyf5MgFLt9UP70/8aJZVaMZh4mhvGNlmUz14TzRGnADLRv73xoB301dNkA==
X-Received: by 2002:a1c:f311:: with SMTP id q17mr4888227wmq.28.1604501394024;
        Wed, 04 Nov 2020 06:49:54 -0800 (PST)
Received: from localhost ([151.66.8.153])
        by smtp.gmail.com with ESMTPSA id d20sm3081187wra.38.2020.11.04.06.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 06:49:53 -0800 (PST)
Date:   Wed, 4 Nov 2020 15:49:50 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v3 net-next 2/5] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201104144950.GA310976@lore-desk>
References: <cover.1604484917.git.lorenzo@kernel.org>
 <b8638a44f1aee8feb3a1f6b949653e2125eb0867.1604484917.git.lorenzo@kernel.org>
 <20201104132430.73594bb6@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20201104132430.73594bb6@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index ef98372facf6..236c5ed3aa66 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> [...]
> > @@ -408,6 +410,39 @@ void page_pool_put_page(struct page_pool *pool, st=
ruct page *page,
> >  }
> >  EXPORT_SYMBOL(page_pool_put_page);
> > =20
> > +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > +			     int count)
> > +{
> > +	int i, len =3D 0;
> > +
> > +	for (i =3D 0; i < count; i++) {
> > +		struct page *page =3D virt_to_head_page(data[i]);
> > +
> > +		if (likely(page_ref_count(page) =3D=3D 1 &&
> > +			   pool_page_reusable(pool, page))) {
> > +			if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > +				page_pool_dma_sync_for_device(pool, page, -1);
> > +
> > +			/* bulk pages for ptr_ring cache */
> > +			data[len++] =3D page;
> > +		} else {
> > +			page_pool_release_page(pool, page);
> > +			put_page(page);
> > +		}
> > +	}
> > +
> > +	/* Grab the producer spinlock for concurrent access to
> > +	 * ptr_ring page_pool cache
> > +	 */
> > +	page_pool_ring_lock(pool);
> > +	for (i =3D 0; i < len; i++) {
> > +		if (__ptr_ring_produce(&pool->ring, data[i]))
> > +			page_pool_return_page(pool, data[i]);
> > +	}
> > +	page_pool_ring_unlock(pool);
> > +}
> > +EXPORT_SYMBOL(page_pool_put_page_bulk);
>=20
> I don't like that you are replicating the core logic from
> page_pool_put_page() in this function.  This means that we as
> maintainers need to keep both of this places up-to-date.
>=20
> Let me try to re-implement this, while sharing the refcnt logic:
> (completely untested, not even compiled)

ack, I like the approach below, I will integrate it in v4

>=20
> ---
>  net/core/page_pool.c |   58 +++++++++++++++++++++++++++++++++++++++++++-=
------
>  2 files changed, 51 insertions(+), 9 deletions(-)
>=20
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ef98372facf6..c785e9825a0d 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -362,8 +362,9 @@ static bool pool_page_reusable(struct page_pool *pool=
, struct page *page)
>   * If the page refcnt !=3D 1, then the page will be returned to memory
>   * subsystem.

[...]

> =20
> +/* Caller must not use data area after call, as this function overwrites=
 it */
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data, int co=
unt)
> +{
> +	int i, len =3D 0, len2 =3D 0;
> +
> +	for (i =3D 0; i < count; i++) {
> +		struct page *page =3D virt_to_head_page(data[i]);
> +
> +		page =3D __page_pool_put_page(pool, page, -1 , false);
> +
> +		/* Approved for recycling for ptr_ring cache */
> +		if (page)
> +			data[len++] =3D page;
> +	}

I guess we just return here if len is 0 since we will avoid to grab the
ptr_ring lock, agree?

Regards,
Lorenzo

> +
> +	/* Bulk producer into ptr_ring page_pool cache */
> +	page_pool_ring_lock(pool);
> +	for (i =3D 0; i < len; i++) {
> +		if (__ptr_ring_produce(&pool->ring, data[i]))
> +			data[len2++] =3D data[i];
> +	}
> +	page_pool_ring_unlock(pool);
> +
> +	/* Unlikely case of ptr_ring cache full, free pages outside producer
> +	 * lock, given put_page() with refcnt=3D=3D1 can be an expensive operat=
ion.
> +	 */
> +	for (i =3D 0; i < len2; i++) {
> +		page_pool_return_page(pool, data[i]);
> +	}
> +}
> +EXPORT_SYMBOL(page_pool_put_page_bulk);
> +
>  static void page_pool_empty_ring(struct page_pool *pool)
>  {
>  	struct page *page;
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCX6K/iwAKCRA6cBh0uS2t
rJ82AQD5MFnguxmzanv2nLxYuiZ+OUgveR0URCtnktVoBjwYugD/Zppt2GvAYpHD
/8LH8nKBacFmZiyRjSNk6Lnim1PDaQo=
=MR24
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--

