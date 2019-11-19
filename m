Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4198102405
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbfKSMOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:14:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28193 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727432AbfKSMOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 07:14:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574165679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GmM0qjPVOwYOi1ZFrw72vVu4WBys7ZFtP6hVw90bfwA=;
        b=Mk04xOLIzhzqfDHCG/LOAl832pJDxmsr0n5rmBZqj+coU0bHe8NYkQe4CPf6BSSBwhJ+Gy
        AFqZ5YUUttBti9tJshfCxKxG63wMzfLZAcbN6JbwmOBG9XJfZMQiXwEWy2145IofOdShvT
        zM9k6BUf9zNISCUmzYLNrxJmSZafvx0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-164-qRwccRMpPTaDzktGxbYqMA-1; Tue, 19 Nov 2019 07:14:36 -0500
X-MC-Unique: qRwccRMpPTaDzktGxbYqMA-1
Received: by mail-wm1-f70.google.com with SMTP id f16so2160681wmb.2
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 04:14:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m6wi0NduF/2NnXjI3cQS7OFfUDiaJyKYXvDC+6fwl1o=;
        b=HSe91qQeIbcxP+g8jhQUx65ayLcGY5W7rOj2zDorHGfKnc2SA/2jJ3qDjv2FQ9fZMq
         g5p0/Vpbpgn24HlSzxuUPkBa9P52SsAUElcgCDG8Dz59ngctutkDzGE1q3GANkQmyQEN
         J5n+1oxEEF4YSoXTIe6FEbr6CoO4krAM4z0imn3iw/dFmDInlUTv1anX/YV3gur+D42o
         6a5MM3tf3Y/K1tHggzP4Vg+2ZP+I8NynODYvB+CmF320wTUATk0XkslllcvZdJjvs16C
         Etg/OusEk3tIANxXlWrc27Jr3tdaOOuCfy9eOHkHzEjlZj+TzcemvEWLM0ryRLe/sJlK
         Zbhg==
X-Gm-Message-State: APjAAAXMLUiyvVcjwirdFoLIKqgJLt1Spxjae3CXrHklxh0Fj5GvAJzc
        GYMRFrnQ4ntA+9iG5ZiKozguP/8G3gm+0VdZSzC1SiG4Kc/FsitYu7LgXWFtOYalu8bgJEly8Sf
        OKe3FK7HG98DEfXW/
X-Received: by 2002:a5d:4381:: with SMTP id i1mr1855340wrq.292.1574165675310;
        Tue, 19 Nov 2019 04:14:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqyHBL/ZRiLSfhSFuntsOHI15jRaibR466QPmLakw9bB881Mo77RobhvA5On0amIw/0tjLBGTA==
X-Received: by 2002:a5d:4381:: with SMTP id i1mr1855302wrq.292.1574165675008;
        Tue, 19 Nov 2019 04:14:35 -0800 (PST)
Received: from localhost.localdomain ([77.139.212.74])
        by smtp.gmail.com with ESMTPSA id z15sm1985061wmi.12.2019.11.19.04.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 04:14:33 -0800 (PST)
Date:   Tue, 19 Nov 2019 14:14:30 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, ilias.apalodimas@linaro.org,
        mcroce@redhat.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191119121430.GA3449@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
 <20191119122358.12276da4@carbon>
MIME-Version: 1.0
In-Reply-To: <20191119122358.12276da4@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 18 Nov 2019 15:33:45 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>=20
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 1121faa99c12..6f684c3a3434 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -34,8 +34,15 @@
> >  #include <linux/ptr_ring.h>
> >  #include <linux/dma-direction.h>
> > =20
> > -#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unmap */
> > -#define PP_FLAG_ALL=09PP_FLAG_DMA_MAP
> > +#define PP_FLAG_DMA_MAP=09=091 /* Should page_pool do the DMA map/unma=
p */
> > +#define PP_FLAG_DMA_SYNC_DEV=092 /* if set all pages that the driver g=
ets
> > +=09=09=09=09   * from page_pool will be
> > +=09=09=09=09   * DMA-synced-for-device according to the
> > +=09=09=09=09   * length provided by the device driver.
> > +=09=09=09=09   * Please note DMA-sync-for-CPU is still
> > +=09=09=09=09   * device driver responsibility
> > +=09=09=09=09   */
> > +#define PP_FLAG_ALL=09=09(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
> > =20
> [...]
>=20
> Can you please change this to use the BIT(X) api.
>=20
> #include <linux/bits.h>
>=20
> #define PP_FLAG_DMA_MAP=09=09BIT(0)
> #define PP_FLAG_DMA_SYNC_DEV=09BIT(1)

Hi Jesper,

sure, will do in v5

>=20
>=20
>=20
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index dfc2501c35d9..4f9aed7bce5a 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -47,6 +47,13 @@ static int page_pool_init(struct page_pool *pool,
> >  =09    (pool->p.dma_dir !=3D DMA_BIDIRECTIONAL))
> >  =09=09return -EINVAL;
> > =20
> > +=09/* In order to request DMA-sync-for-device the page needs to
> > +=09 * be mapped
> > +=09 */
> > +=09if ((pool->p.flags & PP_FLAG_DMA_SYNC_DEV) &&
> > +=09    !(pool->p.flags & PP_FLAG_DMA_MAP))
> > +=09=09return -EINVAL;
> > +
>=20
> I like that you have moved this check to setup time.
>=20
> There are two other parameters the DMA_SYNC_DEV depend on:
>=20
>  =09struct page_pool_params pp_params =3D {
>  =09=09.order =3D 0,
> -=09=09.flags =3D PP_FLAG_DMA_MAP,
> +=09=09.flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>  =09=09.pool_size =3D size,
>  =09=09.nid =3D cpu_to_node(0),
>  =09=09.dev =3D pp->dev->dev.parent,
>  =09=09.dma_dir =3D xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> +=09=09.offset =3D pp->rx_offset_correction,
> +=09=09.max_len =3D MVNETA_MAX_RX_BUF_SIZE,
>  =09};
>=20
> Can you add a check, that .max_len must not be zero.  The reason is
> that I can easily see people misconfiguring this.  And the effect is
> that the DMA-sync-for-device is essentially disabled, without user
> realizing this. The not-realizing part is really bad, especially
> because bugs that can occur from this are very rare and hard to catch.

I guess we need to check it just if we provide PP_FLAG_DMA_SYNC_DEV.
Something like:

=09if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
=09=09if (!(pool->p.flags & PP_FLAG_DMA_MAP))
=09=09=09return -EINVAL;

=09=09if (!pool->p.max_len)
=09=09=09return -EINVAL;
=09}

>=20
> I'm up for discussing if there should be a similar check for .offset.
> IMHO we should also check .offset is configured, and then be open to
> remove this check once a driver user want to use offset=3D0.  Does the
> mvneta driver already have a use-case for this (in non-XDP mode)?

With 'non-XDP mode' do you mean not loading a BPF program? If so yes, it us=
ed
in __page_pool_alloc_pages_slow getting pages from page allocator.
What would be a right min value for it? Just 0 or
XDP_PACKET_HEADROOM/NET_SKB_PAD? I guess here it matters if a BPF program i=
s
loaded or not.

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXdPcpAAKCRA6cBh0uS2t
rDofAQDgLMLIaH8vD8Kl5rFwDAQ96NHMOa7hN59Bv3foaxJAZgD/bapo1IvvP/Tj
C+nv7ykqRbECACWYZmblTqhJhBdxeAU=
=q2VZ
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--

