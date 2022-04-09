Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDE34FA9CB
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 19:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiDIRTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 13:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbiDIRTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 13:19:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 328618D689
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 10:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649524635;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WY/hulULJIDXwjOlOyV2bjQDxxJiEH2mhDrJRU9nzJs=;
        b=WTW/YSwJOvcheDLlmfhPajK3zDna5BACBB9ag3ofZdVwi/emqVpIke8eOXIEZw1TgsiwTs
        2kdF6DL2NCuVrtcnmPMuxkKVWJaaWs6nId4OmynzYHTfAQp/M2aMbFC25tW4aIB47lHmDD
        CDF47LWWLePuqD3ZBsXMkILXzeF09jg=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-550-g9MGCyzNOby1bTBj5HlgQQ-1; Sat, 09 Apr 2022 13:17:13 -0400
X-MC-Unique: g9MGCyzNOby1bTBj5HlgQQ-1
Received: by mail-lj1-f197.google.com with SMTP id o17-20020a2e0c51000000b0024b484876a8so2624836ljd.21
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 10:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WY/hulULJIDXwjOlOyV2bjQDxxJiEH2mhDrJRU9nzJs=;
        b=GkHPU3KEP0t8o9L7Ywc0YMxlcvMNCqt5hNmSZ9TtC/MlYD6RRH7L10AjhzLCaYc+8U
         XE8y3lfLa5/JAvMZwhyT4UJLeGKJsv8DwMKoMT18zsv+ARQD918w42f3j3as2BqJO/hJ
         DFZtJWcWqE4FOzAcU+gx2EwmcWzIzsdEnOpZiHvmLQh97G8uMgw1NgGr80AocD7xA6fN
         ebgyMITrcB7G7+NQtb66srwJN3VEVtyRkIN98R7OmkN3z3+paEk2HlGpBsvhv68P9uJs
         etL67/TbDYeZ93AIUAChRqwAWCi5Q97C4WAb/J3DZaKN/ObckR9sjHMyK/I6WuRB7Ef+
         Cnjg==
X-Gm-Message-State: AOAM531WptgON+W9kNrja/rU5BylK41IMQrcrmBRdZp92Thw6lo7iSLV
        J/1b1y8nuN6tcjkVSqALrJ08sHBGVzWDrEy7CsBd6zZ5rRx68R4EXvc3i3GW+oa7epQs/UCgmUm
        GgutyVo9wTEc3k+84
X-Received: by 2002:a2e:8e96:0:b0:24a:eac4:7ffe with SMTP id z22-20020a2e8e96000000b0024aeac47ffemr15213905ljk.430.1649524632161;
        Sat, 09 Apr 2022 10:17:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzO6Uh+U4s1jkhjnkCzb2b39qE2A09UMfQreDwOvVRBPs5e6AnIleYsZ34QZypVSKGcWHm37g==
X-Received: by 2002:a2e:8e96:0:b0:24a:eac4:7ffe with SMTP id z22-20020a2e8e96000000b0024aeac47ffemr15213885ljk.430.1649524631845;
        Sat, 09 Apr 2022 10:17:11 -0700 (PDT)
Received: from localhost (net-93-71-56-156.cust.vodafonedsl.it. [93.71.56.156])
        by smtp.gmail.com with ESMTPSA id o22-20020a2e7316000000b002497e14723esm50672ljc.86.2022.04.09.10.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 10:17:11 -0700 (PDT)
Date:   Sat, 9 Apr 2022 19:17:08 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        jbrouer@redhat.com, ilias.apalodimas@linaro.org
Subject: Re: [PATCH net-next] page_pool: Add recycle stats to
 page_pool_put_page_bulk
Message-ID: <YlG/lEFEnuRr5VCo@lore-desk>
References: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
 <20220406231512.GB96269@fastly.com>
 <CAC_iWjJdPvhd5Py5vWqWtbf16eJZfg_NWU=BBM90302mSZA=sQ@mail.gmail.com>
 <20220409052223.GA101563@fastly.com>
 <CAC_iWjJObky2yh_hY3P_5egLLb3oJioozPTrwu_tox8zmZNqfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nHhuPMMpJNxgUYn4"
Content-Disposition: inline
In-Reply-To: <CAC_iWjJObky2yh_hY3P_5egLLb3oJioozPTrwu_tox8zmZNqfA@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--nHhuPMMpJNxgUYn4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Hi Joe,
>=20
> On Sat, 9 Apr 2022 at 08:22, Joe Damato <jdamato@fastly.com> wrote:
> >
> > On Thu, Apr 07, 2022 at 11:14:15PM +0300, Ilias Apalodimas wrote:
> > > Hi Joe,
> > >
> > > On Thu, 7 Apr 2022 at 02:15, Joe Damato <jdamato@fastly.com> wrote:
> > > >
> > > > On Tue, Apr 05, 2022 at 10:52:55PM +0200, Lorenzo Bianconi wrote:
> > > > > Add missing recycle stats to page_pool_put_page_bulk routine.
> > > >
> > > > Thanks for proposing this change. I did miss this path when adding
> > > > stats.
> > > >
> > > > I'm sort of torn on this. It almost seems that we might want to tra=
ck
> > > > bulking events separately as their own stat.
> > > >
> > > > Maybe Ilias has an opinion on this; I did implement the stats, but =
I'm not
> > > > a maintainer of the page_pool so I'm not sure what I think matters =
all
> > > > that much ;)
> > >
> > > It does.  In fact I think people that actually use the stats for
> > > something have a better understanding on what's useful and what's not.
> > > OTOH page_pool_put_page_bulk() is used on the XDP path for now but it
> > > ends up returning pages on a for loop.  So personally I think we are
> > > fine without it. The page will be either returned to the ptr_ring
> > > cache or be free'd and we account for both of those.
> > >
> > > However looking at the code I noticed another issue.
> > > __page_pool_alloc_pages_slow() increments the 'slow' stat by one. But
> > > we are not only allocating a single page in there we allocate nr_pages
> > > and we feed all of them but one to the cache.  So imho here we should
> > > bump the slow counter appropriately.  The next allocations will
> > > probably be served from the cache and they will get their own proper
> > > counters.
> >
> > After thinking about this a bit more... I'm not sure.
> >
> > __page_pool_alloc_pages_slow increments slow by 1 because that one page=
 is
> > returned to the user via the slow path. The side-effect of landing in t=
he
> > slow path is that nr_pages-1 pages will be fed into the cache... but not
> > necessarily allocated to the driver.
>=20
> Well they are in the cache *because* we allocated the from the slow path.
>=20
> >
> > As you mention, follow up allocations will count them properly as fast =
path
> > allocations.
> >
> > It might be OK as it is. If we add nr_pages to the number of slow allocs
> > (even though they were never actually allocated as far as the user is
> > concerned), it may be a bit confusing -- essentially double counting th=
ose
> > allocations as both slow and fast.
>=20
> Those allocations didn't magically appear in the fast cache.  (At
> least) Once in the lifetime of the driver you allocated some packets.
> Shouldn't that be reflected into the stats?  The recycled stats
> packets basically means "How many of the original slow path allocated
> packets did I manage to feed from my cache" isn't it ?
>=20
> >
> > So, I think Lorenzo's original patch is correct as is and my comment on=
 it
> > about __page_pool_alloc_pages_slow was wrong.
>=20
> Me too, I think we need Lorenzo's additions regardless.

Hi Dave, Jakub and Paolo,

since we agreed this patch is fine and it is not related to the ongoing dis=
cussion
and the patch is marked as "change requested' in patchwork, do I need to re=
post or
is it ok to apply the current version?

Regards,
Lorenzo

>=20
> Thanks
> /Ilias
> >
> > > >
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > ---
> > > > >  net/core/page_pool.c | 15 +++++++++++++--
> > > > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > > > index 1943c0f0307d..4af55d28ffa3 100644
> > > > > --- a/net/core/page_pool.c
> > > > > +++ b/net/core/page_pool.c
> > > > > @@ -36,6 +36,12 @@
> > > > >               this_cpu_inc(s->__stat);                           =
                     \
> > > > >       } while (0)
> > > > >
> > > > > +#define recycle_stat_add(pool, __stat, val)                     =
                     \
> > > > > +     do {                                                       =
                     \
> > > > > +             struct page_pool_recycle_stats __percpu *s =3D pool=
->recycle_stats;       \
> > > > > +             this_cpu_add(s->__stat, val);                      =
                     \
> > > > > +     } while (0)
> > > > > +
> > > > >  bool page_pool_get_stats(struct page_pool *pool,
> > > > >                        struct page_pool_stats *stats)
> > > > >  {
> > > > > @@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
> > > > >  #else
> > > > >  #define alloc_stat_inc(pool, __stat)
> > > > >  #define recycle_stat_inc(pool, __stat)
> > > > > +#define recycle_stat_add(pool, __stat, val)
> > > > >  #endif
> > > > >
> > > > >  static int page_pool_init(struct page_pool *pool,
> > > > > @@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_poo=
l *pool, void **data,
> > > > >       /* Bulk producer into ptr_ring page_pool cache */
> > > > >       page_pool_ring_lock(pool);
> > > > >       for (i =3D 0; i < bulk_len; i++) {
> > > > > -             if (__ptr_ring_produce(&pool->ring, data[i]))
> > > > > -                     break; /* ring full */
> > > > > +             if (__ptr_ring_produce(&pool->ring, data[i])) {
> > > > > +                     /* ring full */
> > > > > +                     recycle_stat_inc(pool, ring_full);
> > > > > +                     break;
> > > > > +             }
> > > > >       }
> > > > > +     recycle_stat_add(pool, ring, i);
> > > >
> > > > If we do go with this approach (instead of adding bulking-specific =
stats),
> > > > we might want to replicate this change in __page_pool_alloc_pages_s=
low; we
> > > > currently only count the single allocation returned by the slow pat=
h, but
> > > > the rest of the pages which refilled the cache are not counted.
> > >
> > > Ah yes we are saying the same thing here
> > >
> > > Thanks
> > > /Ilias
> > > >
> > > > >       page_pool_ring_unlock(pool);
> > > > >
> > > > >       /* Hopefully all pages was return into ptr_ring */
> > > > > --
> > > > > 2.35.1
> > > > >
>=20

--nHhuPMMpJNxgUYn4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYlG/lAAKCRA6cBh0uS2t
rKQ2AP9liYq2NMWhhARJ0VfxSAhrb2FPE5QBI/7tDX78iVpRZwEAiArIYrpM+pfl
GapkCSesHr/g8Ln76F7z6Pe7vmk4IQI=
=r5y6
-----END PGP SIGNATURE-----

--nHhuPMMpJNxgUYn4--

