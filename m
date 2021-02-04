Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50BC330ECA1
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 07:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbhBDGmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 01:42:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbhBDGmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 01:42:08 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1E2C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 22:41:05 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id j12so1471008pfj.12
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 22:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kShjDlDosO7mTgmYWhiH3er7ziR6b2ljFsCadgIpQek=;
        b=WqjP3CIgjYYPYX92rBj/q684igDDF/F+0eKb3r8HA/PjV8LKzgf2UWBEj3asRN9Okj
         6JCMGKzT0wQhCZ1RtVbH7L/GpXzxDjOE9qwlQZpic02TCiow4pNyXZ8DEZh+eTuItFsQ
         QRGLUYJFCMlcd8f4fTIwPJg5ufzsVKl1zBhFuei/0dR7TvTQ17W9vaCdIgqLbqhDXqiU
         f9Xu3xo0wMurzMgqfPxHCxIPHStlKJmIN6wO3rMpeaEBM49zKyvmygNlCQOYwXPPjUQC
         Ild01InkHFMvDUpS+dNHIZ4AH9qrAiLDjck1f0X48xmpMH3xk7up4WZCwbrljruQ/0q9
         Gdcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kShjDlDosO7mTgmYWhiH3er7ziR6b2ljFsCadgIpQek=;
        b=jxdm0u7cobO3oM7FxPiUHWOjqxFmIjbw2YSkJ7TTk1xcoBFJ65f0bgtJZBpkXgjjnS
         npOZiI1+Eb5bt/66va/fSSqO1GmPZHzbpzpC+VGkKGilSIS82bj92z9HP3iLp+jcS3bM
         BQCh4gVn23kySbNQVsbjHx0L0Gv1PYUXRophJjiwKaBAMrv6AyvrWu3n+ca8+QG58n+k
         tMGTKp8M8VF5wCEFa4JRqlmptrQB18tHE9TWTuX1/XjZRSZ38fp5Kzdobg2lpl7BSL6N
         MyJU8q8VbNvt/fEsvTajiQTbfVQYIo/NpL9VIqthIzUxZ9Eio7k6dQkr+8a2O4INK0FG
         5Tbg==
X-Gm-Message-State: AOAM533RC6EtfgRhDnL261nAqMI6JwswY1hhPSVcvr9si8iIL4TYx3xo
        APlpsH6tCgvof3tE+oYg+lUDUMvAXK0fjA==
X-Google-Smtp-Source: ABdhPJyyhYi4l4KC2dFNDaA/7CWKyJ8HVdOXTMlCIp9BwhnFAfO2ZtW/wgVs2V/u/5DXOeEE0ie4lA==
X-Received: by 2002:a63:dc06:: with SMTP id s6mr7517531pgg.358.1612420864882;
        Wed, 03 Feb 2021 22:41:04 -0800 (PST)
Received: from pek-khao-d2.corp.ad.wrs.com (unknown-105-121.windriver.com. [147.11.105.121])
        by smtp.gmail.com with ESMTPSA id s9sm4207609pfd.38.2021.02.03.22.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 22:41:03 -0800 (PST)
Date:   Thu, 4 Feb 2021 14:40:52 +0800
From:   Kevin Hao <haokexin@gmail.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v2 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
Message-ID: <20210204064052.GA76441@pek-khao-d2.corp.ad.wrs.com>
References: <20210131074426.44154-1-haokexin@gmail.com>
 <20210131074426.44154-2-haokexin@gmail.com>
 <CAKgT0Uf2BJ-EHF+Cp+Jp4121xH3ei_L9ZCE1TFVPJVp4Ru9O0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <CAKgT0Uf2BJ-EHF+Cp+Jp4121xH3ei_L9ZCE1TFVPJVp4Ru9O0w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 02, 2021 at 08:19:54AM -0800, Alexander Duyck wrote:
> On Sat, Jan 30, 2021 at 11:54 PM Kevin Hao <haokexin@gmail.com> wrote:
> >
> > In the current implementation of page_frag_alloc(), it doesn't have
> > any align guarantee for the returned buffer address. But for some
> > hardwares they do require the DMA buffer to be aligned correctly,
> > so we would have to use some workarounds like below if the buffers
> > allocated by the page_frag_alloc() are used by these hardwares for
> > DMA.
> >     buf =3D page_frag_alloc(really_needed_size + align);
> >     buf =3D PTR_ALIGN(buf, align);
> >
> > These codes seems ugly and would waste a lot of memories if the buffers
> > are used in a network driver for the TX/RX. So introduce
> > page_frag_alloc_align() to make sure that an aligned buffer address is
> > returned.
> >
> > Signed-off-by: Kevin Hao <haokexin@gmail.com>
> > Acked-by: Vlastimil Babka <vbabka@suse.cz>
> > ---
> > v2:
> >   - Inline page_frag_alloc()
> >   - Adopt Vlastimil's suggestion and add his Acked-by
> >
> >  include/linux/gfp.h | 12 ++++++++++--
> >  mm/page_alloc.c     |  8 +++++---
> >  2 files changed, 15 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index 6e479e9c48ce..39f4b3070d09 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -583,8 +583,16 @@ extern void free_pages(unsigned long addr, unsigne=
d int order);
> >
> >  struct page_frag_cache;
> >  extern void __page_frag_cache_drain(struct page *page, unsigned int co=
unt);
> > -extern void *page_frag_alloc(struct page_frag_cache *nc,
> > -                            unsigned int fragsz, gfp_t gfp_mask);
> > +extern void *page_frag_alloc_align(struct page_frag_cache *nc,
> > +                                  unsigned int fragsz, gfp_t gfp_mask,
> > +                                  int align);
> > +
> > +static inline void *page_frag_alloc(struct page_frag_cache *nc,
> > +                            unsigned int fragsz, gfp_t gfp_mask)
> > +{
> > +       return page_frag_alloc_align(nc, fragsz, gfp_mask, 0);
> > +}
> > +
> >  extern void page_frag_free(void *addr);
> >
> >  #define __free_page(page) __free_pages((page), 0)
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 519a60d5b6f7..4667e7b6993b 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5137,8 +5137,8 @@ void __page_frag_cache_drain(struct page *page, u=
nsigned int count)
> >  }
> >  EXPORT_SYMBOL(__page_frag_cache_drain);
> >
> > -void *page_frag_alloc(struct page_frag_cache *nc,
> > -                     unsigned int fragsz, gfp_t gfp_mask)
> > +void *page_frag_alloc_align(struct page_frag_cache *nc,
> > +                     unsigned int fragsz, gfp_t gfp_mask, int align)
>=20
> I would make "align" unsigned since really we are using it as a mask.
> Actually passing it as a mask might be even better. More on that
> below.
>=20
> >  {
> >         unsigned int size =3D PAGE_SIZE;
> >         struct page *page;
> > @@ -5190,11 +5190,13 @@ void *page_frag_alloc(struct page_frag_cache *n=
c,
> >         }
> >
> >         nc->pagecnt_bias--;
> > +       if (align)
> > +               offset =3D ALIGN_DOWN(offset, align);
> >         nc->offset =3D offset;
> >
> >         return nc->va + offset;
> >  }
> > -EXPORT_SYMBOL(page_frag_alloc);
> > +EXPORT_SYMBOL(page_frag_alloc_align);
> >
> >  /*
> >   * Frees a page fragment allocated out of either a compound or order 0=
 page.
>=20
> Rather than using the conditional branch it might be better to just do
> "offset &=3D align_mask". Then you would be adding at most 1 instruction
> which can likely occur in parallel with the other work that is going
> on versus the conditional branch which requires a test, jump, and then
> the 3 alignment instructions to do the subtraction, inversion, and
> AND.

On arm64:

       if (align)
               offset =3D ALIGN_DOWN(offset, align);

	4b1503e2        neg     w2, w21
	710002bf        cmp     w21, #0x0
	0a020082        and     w2, w4, w2
	1a841044        csel    w4, w2, w4, ne  // ne =3D any


	offset &=3D align_mask

	0a0402a4        and     w4, w21, w4


Yes, we do cut 3 instructions by using align mask.

>=20
> However it would ripple through the other patches as you would also
> need to update you other patches to assume ~0 in the unaligned case,
> however with your masked cases you could just use the negative
> alignment value to generate your mask which would likely be taken care
> of by the compiler.

Will do.

Thanks,
Kevin


--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEHc6qFoLCZqgJD98Zk1jtMN6usXEFAmAblvQACgkQk1jtMN6u
sXFywAf/ST5I/fTz0I/HU7dns9E/dqocQselH+XRVr/as36pn9qQl9VKIpn4+gGC
ZhNEJoo/sA6YSxVQaHrD/i79y2tn6VUK772f5bKKDoy3vk2u89PvleBPOZYQvHEJ
6f+Q3W1Arwus0wXbZE6pUR2eFdR7LdcEWfhO3SuhU5KFDiZSgToRk3cf6a5Cl5T7
VO0+piqEaDn2mnCY+MWAoZHkwV4wd6nSKtMOsuHXoIyaqCtM91abc1DC+L5pJeVl
gFmLM3EkExahEJ41VcxnrSu79/G4nfbSUPDpOvG09zo7c+COZkwgv9Th6Dt3mqXc
jwsBYcn9/Yi2ywos23uQ3yr3WoyTEQ==
=qBGm
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
