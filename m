Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E818102805
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbfKSPZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:25:53 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30189 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727505AbfKSPZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:25:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574177152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qxTiQ3Yazs9Xe8kESvgTTzKaiwGwMubd7G92cDFW1j8=;
        b=Z5Qt2Iptro5FTkez6dL2F3IxPFowU53s68XawUZWrffaDkdyfdjk4La9Hcms3S1QFbNzKw
        mOCIy9rFzFLvqP3P7KbeyQDAdrCR+HecVk7ZkUitq8Pnie+qMG3Vl/9IIPp7V2baDaE/4M
        Opk6nhlEp25HaWVmUDtlokcxLR0ZZgg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-Y-Wn4iW1Njy1evCTUhX_iQ-1; Tue, 19 Nov 2019 10:25:49 -0500
X-MC-Unique: Y-Wn4iW1Njy1evCTUhX_iQ-1
Received: by mail-wr1-f69.google.com with SMTP id m17so18345524wrb.20
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 07:25:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9swSDx7WVWM2w1Kxn/xQeQ90D+d7hImZulS6NKNF91s=;
        b=Dwne4n6njRMowDOgBVr+opoRtydPm461lCfB7Et8UiL6PAIaXbjqg6jNZZoW728XZv
         3Y0qrUUd1art6U9yZCyMPoazwxJ3lz5AXIANLBjw+kk98w5mL27I/hihoD5w3Z1Bt349
         nMPieeKiLC3v8S2KWXoFGYjtS/FyutvItU7Idf14EYSrl+rYOigyj0rkHJCnQAi9thqb
         7JkQ+SxlHX+8dX8EntPTaj4GjrjxeJq2rV1EB8AAakZQyf1uIFrXd1mUz6pU+sPAmpAc
         6GXbsI3vXu2SiJedPC8MwiIvkEUmp46kVjBFhRy7nZegAvA7+8bl+y14USpjSTZBC721
         rNfw==
X-Gm-Message-State: APjAAAX3qbdeFfpFG3ZePLVfQq3P3xjITnwjPrebaNGn+hRP8fDm8Sq+
        gTsFadcgYFnvyta5HTFk08bV409MGgGX6T2ToQ77oUB/yblJjtvbu2TqmuoH6KUNXQBOugt1dJX
        wWHD+VKmDV+CTFqIX
X-Received: by 2002:a1c:e154:: with SMTP id y81mr6427924wmg.126.1574177147877;
        Tue, 19 Nov 2019 07:25:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqw9MS6arIQ/eWVRhGwKMCdYFkLiIO1SEeQYCDjqrq1zr0R8W042j4RzidGghpDYOlU9f056zQ==
X-Received: by 2002:a1c:e154:: with SMTP id y81mr6427890wmg.126.1574177147554;
        Tue, 19 Nov 2019 07:25:47 -0800 (PST)
Received: from localhost.localdomain ([77.139.212.74])
        by smtp.gmail.com with ESMTPSA id i71sm30356983wri.68.2019.11.19.07.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 07:25:46 -0800 (PST)
Date:   Tue, 19 Nov 2019 17:25:43 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     mcroce@redhat.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        ilias.apalodimas@linaro.org, jonathan.lemon@gmail.com
Subject: Re: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191119152543.GD3449@localhost.localdomain>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
 <20191119122358.12276da4@carbon>
 <20191119121430.GA3449@localhost.localdomain>
 <20191119161332.56faa205@carbon>
MIME-Version: 1.0
In-Reply-To: <20191119161332.56faa205@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Mimecast-Spam-Score: 0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n2Pv11Ogg/Ox8ay5"
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--n2Pv11Ogg/Ox8ay5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Tue, 19 Nov 2019 14:14:30 +0200
> Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:
>=20
> > > On Mon, 18 Nov 2019 15:33:45 +0200
> > > Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> > >  =20
> > > > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > > > index 1121faa99c12..6f684c3a3434 100644
> > > > --- a/include/net/page_pool.h
> > > > +++ b/include/net/page_pool.h
> > > > @@ -34,8 +34,15 @@
> > > >  #include <linux/ptr_ring.h>
> > > >  #include <linux/dma-direction.h>
> > > > =20
> > > > -#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unmap=
 */
> > > > -#define PP_FLAG_ALL=09PP_FLAG_DMA_MAP
> > > > +#define PP_FLAG_DMA_MAP=09=091 /* Should page_pool do the DMA map/=
unmap */
> > > > +#define PP_FLAG_DMA_SYNC_DEV=092 /* if set all pages that the driv=
er gets
> > > > +=09=09=09=09   * from page_pool will be
> > > > +=09=09=09=09   * DMA-synced-for-device according to the
> > > > +=09=09=09=09   * length provided by the device driver.
> > > > +=09=09=09=09   * Please note DMA-sync-for-CPU is still
> > > > +=09=09=09=09   * device driver responsibility
> > > > +=09=09=09=09   */
> > > > +#define PP_FLAG_ALL=09=09(PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV)
> > > >   =20
> > > [...]
> > >=20
> > > Can you please change this to use the BIT(X) api.
> > >=20
> > > #include <linux/bits.h>
> > >=20
> > > #define PP_FLAG_DMA_MAP=09=09BIT(0)
> > > #define PP_FLAG_DMA_SYNC_DEV=09BIT(1) =20
> >=20
> > Hi Jesper,
> >=20
> > sure, will do in v5
> >=20
> > >=20
> > >=20
> > >  =20
> > > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > > index dfc2501c35d9..4f9aed7bce5a 100644
> > > > --- a/net/core/page_pool.c
> > > > +++ b/net/core/page_pool.c
> > > > @@ -47,6 +47,13 @@ static int page_pool_init(struct page_pool *pool=
,
> > > >  =09    (pool->p.dma_dir !=3D DMA_BIDIRECTIONAL))
> > > >  =09=09return -EINVAL;
> > > > =20
> > > > +=09/* In order to request DMA-sync-for-device the page needs to
> > > > +=09 * be mapped
> > > > +=09 */
> > > > +=09if ((pool->p.flags & PP_FLAG_DMA_SYNC_DEV) &&
> > > > +=09    !(pool->p.flags & PP_FLAG_DMA_MAP))
> > > > +=09=09return -EINVAL;
> > > > + =20
> > >=20
> > > I like that you have moved this check to setup time.
> > >=20
> > > There are two other parameters the DMA_SYNC_DEV depend on:
> > >=20
> > >  =09struct page_pool_params pp_params =3D {
> > >  =09=09.order =3D 0,
> > > -=09=09.flags =3D PP_FLAG_DMA_MAP,
> > > +=09=09.flags =3D PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > >  =09=09.pool_size =3D size,
> > >  =09=09.nid =3D cpu_to_node(0),
> > >  =09=09.dev =3D pp->dev->dev.parent,
> > >  =09=09.dma_dir =3D xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> > > +=09=09.offset =3D pp->rx_offset_correction,
> > > +=09=09.max_len =3D MVNETA_MAX_RX_BUF_SIZE,
> > >  =09};
> > >=20
> > > Can you add a check, that .max_len must not be zero.  The reason is
> > > that I can easily see people misconfiguring this.  And the effect is
> > > that the DMA-sync-for-device is essentially disabled, without user
> > > realizing this. The not-realizing part is really bad, especially
> > > because bugs that can occur from this are very rare and hard to catch=
. =20
> >=20
> > I guess we need to check it just if we provide PP_FLAG_DMA_SYNC_DEV.
> > Something like:
> >=20
> > =09if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV) {
> > =09=09if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> > =09=09=09return -EINVAL;
> >=20
> > =09=09if (!pool->p.max_len)
> > =09=09=09return -EINVAL;
> >=09}
>=20
> Yes, exactly.
>=20

ack, I will add it to v5

> > >=20
> > > I'm up for discussing if there should be a similar check for .offset.
> > > IMHO we should also check .offset is configured, and then be open to
> > > remove this check once a driver user want to use offset=3D0.  Does th=
e
> > > mvneta driver already have a use-case for this (in non-XDP mode)? =20
> >=20
> > With 'non-XDP mode' do you mean not loading a BPF program? If so yes, i=
t used
> > in __page_pool_alloc_pages_slow getting pages from page allocator.
> > What would be a right min value for it? Just 0 or
> > XDP_PACKET_HEADROOM/NET_SKB_PAD? I guess here it matters if a BPF progr=
am is
> > loaded or not.
>=20
> I think you are saying, that we need to allow .offset=3D=3D0, because it =
is
> used by mvneta.  Did I understand that correctly?

I was just wondering what is the right value for the min offset, but rethin=
king
about it yes, there is a condition where  mvneta is using offset set 0 (it =
is the
regression reported by Andrew, when mvneta is running on a hw bm device  bu=
t bm
code is not compiled). Do you think we can skip this check for the moment u=
ntil we fix
XDP on that particular board?

Regards,
Lorenzo

>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--n2Pv11Ogg/Ox8ay5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXdQJdAAKCRA6cBh0uS2t
rKKJAQDCGL+xoR3gm83zinkQTttgBJVZJJcfP8cNt472bwkBZQD/XE5khppAvp0x
0t4U5DuMn1s09ZnUvk9hOCQy4z4mxgs=
=YBCt
-----END PGP SIGNATURE-----

--n2Pv11Ogg/Ox8ay5--

