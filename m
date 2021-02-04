Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E03A30ECAE
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 07:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbhBDGsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 01:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbhBDGsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 01:48:30 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ECE6C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 22:47:50 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t25so1463756pga.2
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 22:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NtuvkU6l0It5xB0ibO5W7LsFNau/jlxl4LYNbar/cr4=;
        b=EeU+ldRby2/VKLA0jYEAiF46szR28q2ws4i/gk7lMjuLANhY72sCD6f3anWHI8VUN4
         WyAqWScIhuU2h7abhlCghUGJTEirR6v0x4ZbzRy497sezaeUeQwWYSf0OZOSdEksN+Td
         Ca8JVf+fsD8FZLLcmlDtyyJ7n0Zwt245t9RnVtTAq+A8QsOMzwO8Wv7ESqt9h+gYWcY1
         wWwtHO5JKBuqEmfycHt7EC9k8hNgY1gI2c1tnkZImH9EjpAEIxezZOHGiQ+16psliTlZ
         x0D44uHmBvQRN+PywtejYFxYL+XA9wPho6E1d2PWKGFc/ARYBx3X5ruou1iuhE22uTP2
         FQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NtuvkU6l0It5xB0ibO5W7LsFNau/jlxl4LYNbar/cr4=;
        b=HEq1I6SJLDAT7M0FvxGIh1qGroMaML/UWT9rr1B2rPGO7N/IKJQphTO0x4RgwA30x0
         5yHkaxxLrZ4bep/jJTo71n3pTeZbsaEfKFBfy97dlbGw9ZOOoIMvisDIra8HTmCSsfyG
         eYZ7F+sW75X+WG16L8xR4dvEcNzLwlE81CqvbZNoZFp+yN2qRt/qkjhm0+0DFP2y/nss
         6MC5yk1W6Uv3hYXZV79QrTjPF0CnkN/KS/prh8KBwIIOd7e9Mk0TZk5++AdIBuw62eaM
         TtsVw4D8/3bqMOeB5ivCAG0XNLsTSrTomRJrhb3avijzy51duy3AGFraBYfI+2S09zcd
         Hw5A==
X-Gm-Message-State: AOAM531Uh9KbxKZp2GXydWq1AqXTsIKikMkc5rOh/y34pal9C3UOMS4R
        R+pPApPnRJTp9ody1rWxkeQ=
X-Google-Smtp-Source: ABdhPJxfD5Nk5HInN7F9bHQ3lMOcRzlXydSLGdXvhkvEKuIg1TROek92UR9bKsU7f3u5ezBXs4oT2g==
X-Received: by 2002:a62:7694:0:b029:1b9:8d43:95af with SMTP id r142-20020a6276940000b02901b98d4395afmr7021893pfc.2.1612421269958;
        Wed, 03 Feb 2021 22:47:49 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id u3sm4893128pfm.144.2021.02.03.22.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 22:47:49 -0800 (PST)
Date:   Thu, 4 Feb 2021 14:47:40 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v2 2/4] net: Introduce
 {netdev,napi}_alloc_frag_align()
Message-ID: <20210204064740.GB76441@pek-khao-d2.corp.ad.wrs.com>
References: <20210131074426.44154-1-haokexin@gmail.com>
 <20210131074426.44154-3-haokexin@gmail.com>
 <CAKgT0UcnqCBWZBZ6ySaV0fhSPAPANbmvxGDZjSNSpEkyUjp5eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jq0ap7NbKX2Kqbes"
Content-Disposition: inline
In-Reply-To: <CAKgT0UcnqCBWZBZ6ySaV0fhSPAPANbmvxGDZjSNSpEkyUjp5eg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jq0ap7NbKX2Kqbes
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02, 2021 at 08:26:19AM -0800, Alexander Duyck wrote:
> On Sun, Jan 31, 2021 at 12:17 AM Kevin Hao <haokexin@gmail.com> wrote:
> >
> > In the current implementation of {netdev,napi}_alloc_frag(), it doesn't
> > have any align guarantee for the returned buffer address, But for some
> > hardwares they do require the DMA buffer to be aligned correctly,
> > so we would have to use some workarounds like below if the buffers
> > allocated by the {netdev,napi}_alloc_frag() are used by these hardwares
> > for DMA.
> >     buf =3D napi_alloc_frag(really_needed_size + align);
> >     buf =3D PTR_ALIGN(buf, align);
> >
> > These codes seems ugly and would waste a lot of memories if the buffers
> > are used in a network driver for the TX/RX. We have added the align
> > support for the page_frag functions, so add the corresponding
> > {netdev,napi}_frag functions.
> >
> > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > ---
> > v2: Inline {netdev,napi}_alloc_frag().
> >
> >  include/linux/skbuff.h | 22 ++++++++++++++++++++--
> >  net/core/skbuff.c      | 25 +++++++++----------------
> >  2 files changed, 29 insertions(+), 18 deletions(-)
> >
> > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> > index 9313b5aaf45b..7e8beff4ff22 100644
> > --- a/include/linux/skbuff.h
> > +++ b/include/linux/skbuff.h
> > @@ -2818,7 +2818,19 @@ void skb_queue_purge(struct sk_buff_head *list);
> >
> >  unsigned int skb_rbtree_purge(struct rb_root *root);
> >
> > -void *netdev_alloc_frag(unsigned int fragsz);
> > +void *netdev_alloc_frag_align(unsigned int fragsz, int align);
> > +
> > +/**
> > + * netdev_alloc_frag - allocate a page fragment
> > + * @fragsz: fragment size
> > + *
> > + * Allocates a frag from a page for receive buffer.
> > + * Uses GFP_ATOMIC allocations.
> > + */
> > +static inline void *netdev_alloc_frag(unsigned int fragsz)
> > +{
> > +       return netdev_alloc_frag_align(fragsz, 0);
> > +}
> >
>=20
> So one thing we may want to do is actually split this up so that we
> have a __netdev_alloc_frag_align function that is called by one of two
> inline functions. The standard netdev_alloc_frag would be like what
> you have here, however we would be passing ~0 for the mask.
>=20
> The "align" version would be taking in an unsigned int align value and
> converting it to a mask. The idea is that your mask value is likely a
> constant so converting the constant to a mask would be much easier to
> do in an inline function as the compiler can take care of converting
> the value during compile time.
>=20
> An added value to that is you could also add tests to the align value
> to guarantee that the value being passed is a power of 2 so that it
> works with the alignment mask generation as expected.

Fair enough. Thanks Alexander.

Kevin

>=20
> >  struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned in=
t length,
> >                                    gfp_t gfp_mask);
> > @@ -2877,7 +2889,13 @@ static inline void skb_free_frag(void *addr)
> >         page_frag_free(addr);
> >  }
> >
> > -void *napi_alloc_frag(unsigned int fragsz);
> > +void *napi_alloc_frag_align(unsigned int fragsz, int align);
> > +
> > +static inline void *napi_alloc_frag(unsigned int fragsz)
> > +{
> > +       return napi_alloc_frag_align(fragsz, 0);
> > +}
> > +
> >  struct sk_buff *__napi_alloc_skb(struct napi_struct *napi,
> >                                  unsigned int length, gfp_t gfp_mask);
> >  static inline struct sk_buff *napi_alloc_skb(struct napi_struct *napi,
>=20
> Same for the __napi_alloc_frag code. You could probably convert the
> __napi_alloc_frag below into an __napi_alloc_frag_align that you pass
> a mask to. Then you could convert the other two functions to either
> pass ~0 or the align value and add align value validation.
>=20
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 2af12f7e170c..a35e75f12428 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -374,29 +374,22 @@ struct napi_alloc_cache {
> >  static DEFINE_PER_CPU(struct page_frag_cache, netdev_alloc_cache);
> >  static DEFINE_PER_CPU(struct napi_alloc_cache, napi_alloc_cache);
> >
> > -static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask)
> > +static void *__napi_alloc_frag(unsigned int fragsz, gfp_t gfp_mask, in=
t align)
> >  {
> >         struct napi_alloc_cache *nc =3D this_cpu_ptr(&napi_alloc_cache);
> >
> > -       return page_frag_alloc(&nc->page, fragsz, gfp_mask);
> > +       return page_frag_alloc_align(&nc->page, fragsz, gfp_mask, align=
);
> >  }
> >
> > -void *napi_alloc_frag(unsigned int fragsz)
> > +void *napi_alloc_frag_align(unsigned int fragsz, int align)
> >  {
> >         fragsz =3D SKB_DATA_ALIGN(fragsz);
> >
> > -       return __napi_alloc_frag(fragsz, GFP_ATOMIC);
> > +       return __napi_alloc_frag(fragsz, GFP_ATOMIC, align);
> >  }
> > -EXPORT_SYMBOL(napi_alloc_frag);
> > +EXPORT_SYMBOL(napi_alloc_frag_align);
> >
> > -/**
> > - * netdev_alloc_frag - allocate a page fragment
> > - * @fragsz: fragment size
> > - *
> > - * Allocates a frag from a page for receive buffer.
> > - * Uses GFP_ATOMIC allocations.
> > - */
> > -void *netdev_alloc_frag(unsigned int fragsz)
> > +void *netdev_alloc_frag_align(unsigned int fragsz, int align)
> >  {
> >         struct page_frag_cache *nc;
> >         void *data;
> > @@ -404,15 +397,15 @@ void *netdev_alloc_frag(unsigned int fragsz)
> >         fragsz =3D SKB_DATA_ALIGN(fragsz);
> >         if (in_irq() || irqs_disabled()) {
> >                 nc =3D this_cpu_ptr(&netdev_alloc_cache);
> > -               data =3D page_frag_alloc(nc, fragsz, GFP_ATOMIC);
> > +               data =3D page_frag_alloc_align(nc, fragsz, GFP_ATOMIC, =
align);
> >         } else {
> >                 local_bh_disable();
> > -               data =3D __napi_alloc_frag(fragsz, GFP_ATOMIC);
> > +               data =3D __napi_alloc_frag(fragsz, GFP_ATOMIC, align);
> >                 local_bh_enable();
> >         }
> >         return data;
> >  }
> > -EXPORT_SYMBOL(netdev_alloc_frag);
> > +EXPORT_SYMBOL(netdev_alloc_frag_align);
> >
> >  /**
> >   *     __netdev_alloc_skb - allocate an skbuff for rx on a specific de=
vice
> > --
> > 2.29.2
> >

--jq0ap7NbKX2Kqbes
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmAbmIwACgkQk1jtMN6u
sXFQyAf/VpWqftKzThipI/qS26Wa4ijwcPmQReQUKikgyErx5pyUU4TXl09u2fSQ
KulOs1sR2nw57IGnM+dDrF+62kLHi/70HkVWSJu97KOmRrPD8kmsR8XyCVcvI+vv
ePc3IrxdYXLVEQ0DvBlbRX92Ihp0N/leYu3lbjPMd20qj/4daDwULPmuyp6gpb4i
d9E1sXHB+xHU75FYYEuZg0vaUbumLWatZR2AtWNduVDOREs/rc2rSdXQEU319QGI
1IT5UqhLIi6YClSnhm6uUhmylWp2rAyIYrf+ET7n7F9x0vQlzkhNhYHmwFFKgBje
q0/Nq2NA0ETiKkbzx3ShJthCd3W25g==
=v0je
-----END PGP SIGNATURE-----

--jq0ap7NbKX2Kqbes--
