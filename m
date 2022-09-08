Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960D25B26AC
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 21:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbiIHT0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 15:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiIHT0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 15:26:35 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47DFAF0DD
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 12:26:33 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 73so17707896pga.1
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 12:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3Q8WoqiDQoXqAq2ZfUuPIOeZvJ3b3Y7xp4sCg52cV7I=;
        b=PKbTPJt4x4OSpB275d3F/rY/yOAKUov7IqpZCFAOYre5doE+7Cizmyv36elzE/JW/g
         oWKi2WWTyKo6XQfk5PwglrZNLObenyJcFBCw/0K1UhEJGf7P6xjqHvxSnDO5Sgjwy+dj
         yJRkXwSzuZxS+G0TY0e+lnISdT4ft9nEaRYxDRhsErkc39dHSb7wx+0jFcg1bLHkvxqQ
         lrgls7Uquj5iDrjtmVJeLr38oxZj00EojV6FgioQgpcRd0VsBjso/qFZEwFYDYmwbc0D
         0JBuZfTLtVngD7NIZsdY29eH7Zu/MSSGtHgsXec7YApsjRefdgVQl9U9YYgx4E7tpdwC
         9zWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3Q8WoqiDQoXqAq2ZfUuPIOeZvJ3b3Y7xp4sCg52cV7I=;
        b=MnVg0Nr3jk64eFYk94JW9y78mx4QdXV6BnEHwILgfSnqkFMKqwdPpkNZ8M5JUZShdf
         ZT6NgFb0FbtXd3dyyKEemyGx88BwQtRBZFJFvcFVuaSsVvcf4jhk/zWmexWdP3P1++aY
         BXpw45dyhu4658hzmkAvv8UUC03tplvgJcY+Cu89ROFj6zdknpw1+dOMTRKCbVsXbp0B
         vZcFwq55O2ZCouCluOMWngPwPsev1mCuTLiBlRgJH0bM1fAYsMTTrhd7mqzrnkbPdiyL
         YSpraIDArj+0ebwNqMPh4K/Dn/reNCH2X/6BwwCYAzjqO8SlWT9Pdv3ViqtNqJwr16Hq
         KRKA==
X-Gm-Message-State: ACgBeo1qiBcsTZZIVnPwlQCa0TIA7q36E9SBPCdqU8+ZWOj13WesczVX
        eSrLTmmfTtiCIi+OfUhCq1jN+ZQEM9y2Kfs8yG0=
X-Google-Smtp-Source: AA6agR4TbzG6Q7MX2QBLQ06moFObyIx0xDrI2MKFIBJOBoNC6zZ1GbDx+r2WfPxeHAZenlP+A0nZlAakzSJTYX/lafA=
X-Received: by 2002:a63:5b63:0:b0:434:df94:fdf7 with SMTP id
 l35-20020a635b63000000b00434df94fdf7mr9149933pgm.354.1662665193295; Thu, 08
 Sep 2022 12:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210113161819.1155526-1-eric.dumazet@gmail.com>
 <bd79ede94805326cd63f105c84f1eaa4e75c8176.camel@redhat.com>
 <dcffcf6fde8272975e44124f55fba3936833360e.camel@gmail.com>
 <498a25e4f7ba4e21d688ca74f335b28cadcb3381.camel@redhat.com>
 <cf264865cb1613c0e7acf4bbc1ed345533767822.camel@gmail.com> <f3f867cf6814510817b253e6aca997cdd3acc48a.camel@redhat.com>
In-Reply-To: <f3f867cf6814510817b253e6aca997cdd3acc48a.camel@redhat.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 8 Sep 2022 12:26:21 -0700
Message-ID: <CAKgT0UeV9+=AcQ1J+UA=KGWKAV2E4CW566qYHNv_XxQMC3Us-Q@mail.gmail.com>
Subject: Re: [PATCH net] net: avoid 32 x truesize under-estimation for tiny skbs
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 8, 2022 at 11:01 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Thu, 2022-09-08 at 07:53 -0700, Alexander H Duyck wrote:
> > On Thu, 2022-09-08 at 13:00 +0200, Paolo Abeni wrote:
> > > In most build GRO_MAX_HEAD packets are even larger (should be 640)
> >
> > Right, which is why I am thinking we may want to default to a 1K slice.
>
> Ok it looks like there is agreement to force a minimum frag size of 1K.
> Side note: that should not cause a memory usage increase compared to
> the slab allocator as kmalloc(640) should use the kmalloc-1k slab.
>
> [...]
>
> > > >
> > > If the pagecnt optimization should be dropped, it would be probably
> > > more straight-forward to use/adapt 'page_frag' for the page_order0
> > > allocator.
> >
> > That would make sense. Basically we could get rid of the pagecnt bias
> > and add the fixed number of slices to the count at allocation so we
> > would just need to track the offset to decide when we need to allocate
> > a new page. In addtion if we are flushing the page when it is depleted
> > we don't have to mess with the pfmemalloc logic.
>
> Uhmm... it looks like that the existing page_frag allocator does not
> always flush the depleted page:
>
> bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
> {
>         if (pfrag->page) {
>                 if (page_ref_count(pfrag->page) == 1) {
>                         pfrag->offset = 0;
>                         return true;
>                 }

Right, we have an option to reuse the page if the page count is 0.
However in the case of the 4K page with 1K slices scenario it means
you are having to bump back up the count on every 3 pages. So you
would be looking at 1.3 atomic accesses per frag. Just doing the bump
once at the start and using all 4 slices would give you 1.25 atomic
accesses per frag. That is why I assumed it would be better to just
let it go.

> so I'll try adding some separate/specialized code and see if the
> overall complexity would be reasonable.

The other thing to keep in mind is that once you start adding the
recycling you will have best case and worst case scenarios to
consider. The code above is for recycling frag in place it seems like,
or reallocating a new one in its place.

> > > BTW it's quite strange/confusing having to very similar APIs (page_frag
> > > and page_frag_cache) with very similar names and no references between
> > > them.
> >
> > I'm not sure what you are getting at here. There are plenty of
> > references between them, they just aren't direct.
>
> Looking/greping the tree I could not trivially understand when 'struct
> page_frag' should be preferred over 'struct page_frag_cache' and/or
> vice versa, I had to look at the respective implementation details.

The page_frag_cache is mostly there to store a higher order page to
slice up to generate page fragments that can be stored in the
page_frag struct. Honestly I am surprised we still have page_frag
floating around. I thought we replaced that with bio_vec some time
ago. At least that is the structure that skb_frag_t is typdef-ed as.
