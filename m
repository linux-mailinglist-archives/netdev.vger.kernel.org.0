Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEF4675179
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjATJqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjATJqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:46:48 -0500
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4471D7AF0B
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:46:47 -0800 (PST)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-4b718cab0e4so64527047b3.9
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IXxmtQ6GBtEQA61e2VOIEWFXj+jVmUR7awLQPS90OI8=;
        b=H4uJrakxaZoTz+/GEZMAe5ZRoaktV+femTJl7B40ulG82ju0wr3PnBVqO/UrSvV5gn
         XnnI2Eb6fA1I7VRbxR1GJDjp1IHe7mr20QYSpQtiPczy5tY/JGgoNQpksjnnMrZJZc9i
         BHLWHbemSC8jrWLbaRS2mggiCkxl2632rfhjATjW6o6+EF69vyEq9belLpaGk5gnjerZ
         fazWExuFKjULD6ntE2O64+Yx2KuBzxn+N7Sk/QtC+aiBxVwLNorHP+G62DC26LmxriDO
         ct1Bdtc4+f8BvLGf3m0uBou4pXYoGkVzK+TcuLyEe7Bd1Qfx1O7Zt0Uf4jvJm5vz/rrq
         FPXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXxmtQ6GBtEQA61e2VOIEWFXj+jVmUR7awLQPS90OI8=;
        b=cygJj0zED7GWWlhMTMBf/X/9B36d1yHQgf9b/vk6yO9NyMNtthi1cY1TEYiKTcTDQh
         t7w8cherL9FdkkunuLX38Y4RsxjLS1ACXn5OTC/Pb0WXXKi5b+qHEHixNRFFu3Z6sQnS
         YpEQC1kexKDVKMfHhoAt0CufSV6jUDzYTcd+iTgn/groUvQNTFjBSQAAONmvdKZQgjBY
         xqCMHYabkaC+Rjwhg404Ij9D5Tg47L+EZGlDkShsHBLGpN7DCoGmGZvEmvYrEs6n4XQL
         3xXNvsdidK1cdTy4hRPOjvwkM5zJiZimUaeuuHkGmmROm9E0oNgfvO3QtgooV8O0Ze3i
         KMAg==
X-Gm-Message-State: AFqh2krHrKy4xf+AOf/e7+d3O8C3l3ipSPTfVadWtDohfirkwkYOtgjf
        arYS+mQKxwLWKtfGgNPDLIlsi83aITb4jf193NyOXGhs7AoujaLLsAY=
X-Google-Smtp-Source: AMrXdXvv2Z53OJbMFILAWLQK6/FvY3oynsOHrQIpEycoavDj/1qXNyZCf8MbuztR20NMe5vBVkkLWsDdB2iv5lJiSiY=
X-Received: by 2002:a81:351:0:b0:36c:aaa6:e571 with SMTP id
 78-20020a810351000000b0036caaa6e571mr1267569ywd.467.1674208006214; Fri, 20
 Jan 2023 01:46:46 -0800 (PST)
MIME-Version: 1.0
References: <167415060025.1124471.10712199130760214632.stgit@firesoul>
 <CANn89iJ8Vd2V6jqVdMYLFcs0g_mu+bTJr3mKq__uXBFg1K0yhA@mail.gmail.com>
 <d5c66d86-23e0-b786-5cba-ae9c18a97549@redhat.com> <cc7f2ca7-8d6e-cfcb-98f8-3e3d7152fced@redhat.com>
In-Reply-To: <cc7f2ca7-8d6e-cfcb-98f8-3e3d7152fced@redhat.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 20 Jan 2023 10:46:34 +0100
Message-ID: <CANn89i+wzgAz8Y9Ce4rw6DkcExUW37-UKKn4eL4-umWsAJ_BKQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: fix kfree_skb_list use of skb_mark_not_on_list
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 10:30 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 20/01/2023 10.09, Jesper Dangaard Brouer wrote:
> >
> > On 19/01/2023 19.04, Eric Dumazet wrote:
> >> On Thu, Jan 19, 2023 at 6:50 PM Jesper Dangaard Brouer
> >> <brouer@redhat.com> wrote:
> >>>
> >>> A bug was introduced by commit eedade12f4cb ("net: kfree_skb_list use
> >>> kmem_cache_free_bulk"). It unconditionally unlinked the SKB list via
> >>> invoking skb_mark_not_on_list().
> >>>
> >>> The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
> >>> returns true, meaning the SKB is ready to be free'ed, as it calls/check
> >>> skb_unref().
> >>>
> >>> This is needed as kfree_skb_list() is also invoked on skb_shared_info
> >>> frag_list. A frag_list can have SKBs with elevated refcnt due to cloning
> >>> via skb_clone_fraglist(), which takes a reference on all SKBs in the
> >>> list. This implies the invariant that all SKBs in the list must have the
> >>> same refcnt, when using kfree_skb_list().
> >>
> >> Yeah, or more precisely skb_drop_fraglist() calling kfree_skb_list()
> >>
> >>>
> >>> Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
> >>> Reported-and-tested-by:
> >>> syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
> >>> Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")
> >>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >>> ---
> >>>   net/core/skbuff.c |    6 +++---
> >>>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> >>> index 4e73ab3482b8..1bffbcbe6087 100644
> >>> --- a/net/core/skbuff.c
> >>> +++ b/net/core/skbuff.c
> >>> @@ -999,10 +999,10 @@ kfree_skb_list_reason(struct sk_buff *segs,
> >>> enum skb_drop_reason reason)
> >>>          while (segs) {
> >>>                  struct sk_buff *next = segs->next;
> >>>
> >>> -               skb_mark_not_on_list(segs);
> >>> -
> >>> -               if (__kfree_skb_reason(segs, reason))
> >>> +               if (__kfree_skb_reason(segs, reason)) {
> >>> +                       skb_mark_not_on_list(segs);
> >>
> >> Real question is : Why do we need to set/change/dirt skb->next ?
> >>
> >> I would remove this completely, and save extra cache lines dirtying.
> >
> > First of all, we just read this cacheline via reading segs->next.
> > This cacheline must as minimum be in Shared (S) state.
> >
> > Secondly SLUB will write into this cacheline. Thus, we actually know
> > that this cacheline need to go into Modified (M) or Exclusive (E).
> > Thus, writing into it here should be okay.  We could replace it with a
> > prefetchw() to help SLUB get Exclusive (E) cache coherency state.
>
> I looked it up and SLUB no-longer uses the first cacheline of objects to
> store it's freelist_ptr.  Since April 2020 (v5.7) in commit 3202fa62fb43
> ("slub: relocate freelist pointer to middle of object") (Author: Kees
> Cook) the freelist is moved to the middle for security concerns.
> Thus, my prefetchw idea is wrong (details: there is an internal
> prefetch_freepointer that finds the right location).
>
> Also it could make sense to save the potential (S) to (E) cache
> coherency state transition, as SLUB actually writes into another
> cacheline that I first though.

Anyway, we should not assume anything about slub/slab ways of storing
freelists. They might switch to something less expensive, especially considering
bulk API passes an array of pointers, not a 'list'.


>
>
> >> Before your patch, we were not calling skb_mark_not_on_list(segs),
> >> so why bother ?
> >
> > To catch potential bugs.
>
> For this purpose we could discuss creating skb_poison_list() as you
> hinted in your debugging proposal, this would likely have caused us to
> catch this bug faster (via crash on second caller).
>
> Let me know if you prefer that we simply remove skb_mark_not_on_list() ?

Yes. Setting NULL here might hide another bug somewhere.

skb_poison_list() could be defined for CONFIG_DEBUG_NET=y builds I guess.
