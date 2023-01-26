Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D33A67D0EB
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 17:08:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbjAZQIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 11:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjAZQIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 11:08:31 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425B54DE2B;
        Thu, 26 Jan 2023 08:08:29 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id p24so2211386plw.11;
        Thu, 26 Jan 2023 08:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/1kfGCDENEexk/u/WE878S1vFmK7YrVyU78lP11mT4I=;
        b=PnlF2nDNZWM9a8wGfeyk4sR9KjM/JuZN+qOM68O2X3N0Qx6oXKUjKWCc94BQ764Ntv
         nQRLnWozuFit5xJ8fpcquvl9xDTPo7MRBkK83/ET9tqe6PDrlHuYcbDmci3ySujwFYdZ
         0ERraZYpjJAgeZEu8OB4sv+ikChtZNQB9lHON92tF599Auz9GVuLsA/fiP2g07aZUJbL
         U1oxVZu0lJkK9GuY3P/g435Pq7TqqFwBRV/TSdake+nAe+Ss0OwxWi1xz64jdhl5zMdm
         d3xDuw1IlarG+/vBf3WeBPsXiZ++OA9DByp0k06JZ1qZsbbM5uW8mOHIw4KyCZNvhYyh
         kJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/1kfGCDENEexk/u/WE878S1vFmK7YrVyU78lP11mT4I=;
        b=V6t1Q49h2vbSOQQz6pq1mrLtZKpok64or5Uk3MayXvnSa5FTnf7uHISxYNI1+cGa2a
         VAO6xsRF7E1SOcFkArbRq3ZlTNkrbzCWUMyjdB7dMx0/Naw05Gb9JvjxcSK2l13u9RQ7
         x5/vIiWd5dFy1uNZLjFiuhvvyEQ3H5GdWBPIuS/GQEKRLgTcdIdYd3+syYPtBPAid3kN
         G82vj/YfrM72OeBT3hgMdu8LYFqbYvtytYWzs7XxdTSrDW8fgNgfgWI3UJH19BtrKIE+
         DFtRWKi/xwQMuVOGvvVbfze8tRaGTJF+mKiLkSN5LV4fHuMLx3mNHQN+jXIzZg2NrWHa
         z4ew==
X-Gm-Message-State: AO0yUKUP7mJEsB6RWf0A8zOvGWZ10DnBRp4TRvCe4zkT9g7qzRQVzqO/
        LgSRSxNsRZICsmSFoBmS0dJjz1P1FwJRHpFEtvk=
X-Google-Smtp-Source: AK7set/oCtCa19i19oi+AGbTUXy93/4u3edif4nr3Erc0d2CzBKsgse9kUgmJy4Dnnie07xOg8i9utNCx0PUlbeYQX8=
X-Received: by 2002:a17:90a:e50f:b0:22c:113f:116f with SMTP id
 t15-20020a17090ae50f00b0022c113f116fmr740446pjy.175.1674749308243; Thu, 26
 Jan 2023 08:08:28 -0800 (PST)
MIME-Version: 1.0
References: <20230124124300.94886-1-nbd@nbd.name> <CAC_iWjKAEgUB8Z3WNNVgUK8omXD+nwt_VPSVyFn1i4EQzJadog@mail.gmail.com>
 <19121deb-368f-9786-8700-f1c45d227a4c@nbd.name> <cd35316065cfe8d706ca2730babe3e6519df6034.camel@gmail.com>
 <c7f1ade0-a607-2e55-d106-9acc26cbed94@nbd.name> <49703c370e26ae1a6b19a39dc05e262acf58f6aa.camel@gmail.com>
 <9baecde9-d92b-c18c-daa8-e7a96baa019b@nbd.name> <595c5e36b0260ba16833c2a8d9418fd978ca9300.camel@gmail.com>
 <0c0e96a7-1cf1-b856-b339-1f3df36a562c@nbd.name> <a0b43a978ae43064777d9d240ef38b3567f58e5a.camel@gmail.com>
 <9992e7b5-7f2b-b79d-9c48-cf689807f185@nbd.name> <301aa48a-eb3b-eb56-5041-d6f8d61024d1@nbd.name>
 <148028e75d720091caa56e8b0a89544723fda47e.camel@gmail.com>
 <8ec239d3-a005-8609-0724-f1042659791e@nbd.name> <8a331165-4435-4c2d-70e0-20655019dc51@nbd.name>
In-Reply-To: <8a331165-4435-4c2d-70e0-20655019dc51@nbd.name>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 26 Jan 2023 08:08:16 -0800
Message-ID: <CAKgT0Ud8npNtncH-KbMtj_R=UZ=aFA9T8U=TZoLG_94eVUxKPA@mail.gmail.com>
Subject: Re: [PATCH] net: page_pool: fix refcounting issues with fragmented allocation
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org, Yunsheng Lin <linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 1:15 AM Felix Fietkau <nbd@nbd.name> wrote:
>
> On 26.01.23 07:12, Felix Fietkau wrote:
> > On 25.01.23 23:14, Alexander H Duyck wrote:
> >> On Wed, 2023-01-25 at 20:40 +0100, Felix Fietkau wrote:
> >>> On 25.01.23 20:10, Felix Fietkau wrote:
> >>> > On 25.01.23 20:02, Alexander H Duyck wrote:
> >>> > > On Wed, 2023-01-25 at 19:42 +0100, Felix Fietkau wrote:
> >>> > > > On 25.01.23 19:26, Alexander H Duyck wrote:
> >>> > > > > On Wed, 2023-01-25 at 18:32 +0100, Felix Fietkau wrote:
> >>> > > > > > On 25.01.23 18:11, Alexander H Duyck wrote:
> >>> > > > > > > On Tue, 2023-01-24 at 22:30 +0100, Felix Fietkau wrote:
> >>> > > > > > > > On 24.01.23 22:10, Alexander H Duyck wrote:
> >>> > > > > > > > > On Tue, 2023-01-24 at 18:22 +0100, Felix Fietkau wrote:
> >>> > > > > > > > > > On 24.01.23 15:11, Ilias Apalodimas wrote:
> >>> > > > > > > > > > > Hi Felix,
> >>> > > > > > > > > > >
> >>> > > > > > > > > > > ++cc Alexander and Yunsheng.
> >>> > > > > > > > > > >
> >>> > > > > > > > > > > Thanks for the report
> >>> > > > > > > > > > >
> >>> > > > > > > > > > > On Tue, 24 Jan 2023 at 14:43, Felix Fietkau <nbd@nbd.name> wrote:
> >>> > > > > > > > > > > >
> >>> > > > > > > > > > > > While testing fragmented page_pool allocation in the mt76 driver, I was able
> >>> > > > > > > > > > > > to reliably trigger page refcount underflow issues, which did not occur with
> >>> > > > > > > > > > > > full-page page_pool allocation.
> >>> > > > > > > > > > > > It appears to me, that handling refcounting in two separate counters
> >>> > > > > > > > > > > > (page->pp_frag_count and page refcount) is racy when page refcount gets
> >>> > > > > > > > > > > > incremented by code dealing with skb fragments directly, and
> >>> > > > > > > > > > > > page_pool_return_skb_page is called multiple times for the same fragment.
> >>> > > > > > > > > > > >
> >>> > > > > > > > > > > > Dropping page->pp_frag_count and relying entirely on the page refcount makes
> >>> > > > > > > > > > > > these underflow issues and crashes go away.
> >>> > > > > > > > > > > >
> >>> > > > > > > > > > >
> >>> > > > > > > > > > > This has been discussed here [1].  TL;DR changing this to page
> >>> > > > > > > > > > > refcount might blow up in other colorful ways.  Can we look closer and
> >>> > > > > > > > > > > figure out why the underflow happens?
> >>> > > > > > > > > > I don't see how the approch taken in my patch would blow up. From what I
> >>> > > > > > > > > > can tell, it should be fairly close to how refcount is handled in
> >>> > > > > > > > > > page_frag_alloc. The main improvement it adds is to prevent it from
> >>> > > > > > > > > > blowing up if pool-allocated fragments get shared across multiple skbs
> >>> > > > > > > > > > with corresponding get_page and page_pool_return_skb_page calls.
> >>> > > > > > > > > >
> >>> > > > > > > > > > - Felix
> >>> > > > > > > > > >
> >>> > > > > > > > >
> >>> > > > > > > > > Do you have the patch available to review as an RFC? From what I am
> >>> > > > > > > > > seeing it looks like you are underrunning on the pp_frag_count itself.
> >>> > > > > > > > > I would suspect the issue to be something like starting with a bad
> >>> > > > > > > > > count in terms of the total number of references, or deducing the wrong
> >>> > > > > > > > > amount when you finally free the page assuming you are tracking your
> >>> > > > > > > > > frag count using a non-atomic value in the driver.
> >>> > > > > > > > The driver patches for page pool are here:
> >>> > > > > > > > https://patchwork.kernel.org/project/linux-wireless/patch/64abb23f4867c075c19d704beaae5a0a2f8e8821.1673963374.git.lorenzo@kernel.org/
> >>> > > > > > > > https://patchwork.kernel.org/project/linux-wireless/patch/68081e02cbe2afa2d35c8aa93194f0adddbd0f05.1673963374.git.lorenzo@kernel.org/
> >>> > > > > > > >
> >>> > > > > > > > They are also applied in my mt76 tree at:
> >>> > > > > > > > https://github.com/nbd168/wireless
> >>> > > > > > > >
> >>> > > > > > > > - Felix
> >>> > > > > > >
> >>> > > > > > > So one thing I am thinking is that we may be seeing an issue where we
> >>> > > > > > > are somehow getting a mix of frag and non-frag based page pool pages.
> >>> > > > > > > That is the only case I can think of where we might be underflowing
> >>> > > > > > > negative. If you could add some additional debug info on the underflow
> >>> > > > > > > WARN_ON case in page_pool_defrag_page that might be useful.
> >>> > > > > > > Specifically I would be curious what the actual return value is. I'm
> >>> > > > > > > assuming we are only hitting negative 1, but I would want to verify we
> >>> > > > > > > aren't seeing something else.
> >>> > > > > > I'll try to run some more tests soon. However, I think I found the piece
> >>> > > > > > of code that is incompatible with using pp_frag_count.
> >>> > > > > > When receiving an A-MSDU packet (multiple MSDUs within a single 802.11
> >>> > > > > > packet), and it is not split by the hardware, a cfg80211 function
> >>> > > > > > extracts the individual MSDUs into separate skbs. In that case, a
> >>> > > > > > fragment can be shared across multiple skbs, and get_page is used to
> >>> > > > > > increase the refcount.
> >>> > > > > > You can find this in net/wireless/util.c: ieee80211_amsdu_to_8023s (and
> >>> > > > > > its helper functions).
> >>> > > > >
> >>> > > > > I'm not sure if it is problematic or not. Basically it is trading off
> >>> > > > > by copying over the frags, calling get_page on each frag, and then
> >>> > > > > using dev_kfree_skb to disassemble and release the pp_frag references.
> >>> > > > > There should be other paths in the kernel that are doing something
> >>> > > > > similar.
> >>> > > > >
> >>> > > > > > This code also has a bug where it doesn't set pp_recycle on the newly
> >>> > > > > > allocated skb if the previous one has it, but that's a separate matter
> >>> > > > > > and fixing it doesn't make the crash go away.
> >>> > > > >
> >>> > > > > Adding the recycle would cause this bug. So one thing we might be
> >>> > > > > seeing is something like that triggering this error. Specifically if
> >>> > > > > the page is taken via get_page when assembling the new skb then we
> >>> > > > > cannot set the recycle flag in the new skb otherwise it will result in
> >>> > > > > the reference undercount we are seeing. What we are doing is shifting
> >>> > > > > the references away from the pp_frag_count to the page reference count
> >>> > > > > in this case. If we set the pp_recycle flag then it would cause us to
> >>> > > > > decrement pp_frag_count instead of the page reference count resulting
> >>> > > > > in the underrun.
> >>> > > > Couldn't leaving out the pp_recycle flag potentially lead to a case
> >>> > > > where the last user of the page drops it via page_frag_free instead of
> >>> > > > page_pool_return_skb_page? Is that valid?
> >>> > >
> >>> > > No. What will happen is that when the pp_frag_count is exhausted the
> >>> > > page will be unmapped and evicted from the page pool. When the page is
> >>> > > then finally freed it will end up going back to the page allocator
> >>> > > instead of page pool.
> >>> > >
> >>> > > Basically the idea is that until pp_frag_count reaches 0 there will be
> >>> > > at least 1 page reference held.
> >>> > >
> >>> > > > > > Is there any way I can make that part of the code work with the current
> >>> > > > > > page pool frag implementation?
> >>> > > > >
> >>> > > > > The current code should work. Basically as long as the references are
> >>> > > > > taken w/ get_page and skb->pp_recycle is not set then we shouldn't run
> >>> > > > > into this issue because the pp_frag_count will be dropped when the
> >>> > > > > original skb is freed and the page reference count will be decremented
> >>> > > > > when the new one is freed.
> >>> > > > >
> >>> > > > > For page pool page fragments the main thing to keep in mind is that if
> >>> > > > > pp_recycle is set it will update the pp_frag_count and if it is not
> >>> > > > > then it will just decrement the page reference count.
> >>> > > > What takes care of DMA unmap and other cleanup if the last reference to
> >>> > > > the page is dropped via page_frag_free?
> >>> > > >
> >>> > > > - Felix
> >>> > >
> >>> > > When the page is freed on the skb w/ pp_recycle set it will unmap the
> >>> > > page and evict it from the page pool. Basically in these cases the page
> >>> > > goes from the page pool back to the page allocator.
> >>> > >
> >>> > > The general idea with this is that if we are using fragments that there
> >>> > > will be enough of them floating around that if one or two frags have a
> >>> > > temporeary detour through a non-recycling path that hopefully by the
> >>> > > time the last fragment is freed the other instances holding the
> >>> > > additional page reference will have let them go. If not then the page
> >>> > > will go back to the page allocator and it will have to be replaced in
> >>> > > the page pool.
> >>> > Thanks for the explanation, it makes sense to me now. Unfortunately it
> >>> > also means that I have no idea what could cause this issue. I will
> >>> > finish my mt76 patch rework which gets rid of the pp vs non-pp
> >>> > allocation mix and re-run my tests to provide updated traces.
> >>> Here's the updated mt76 page pool support commit:
> >>> https://github.com/nbd168/wireless/commit/923cdab6d4c92a0acb3536b3b0cc4af9fee7c808
> >>
> >> Yeah, so I don't see anything wrong with the patch in terms of page
> >> pool.
> >>
> >>> And here is the trace that I'm getting with 6.1:
> >>> https://nbd.name/p/a16957f2
> >>>
> >>> If you have any debug patch you'd like me to test, please let me know.
> >>>
> >>> - Felix
> >>
> >> So looking at the traces I am assuming what we are seeing is the
> >> deferred freeing from the TCP Rx path since I don't see a driver
> >> anywhere between net_rx_action and napi_consume skb. So it seems like
> >> the packets are likely making it all the way up the network stack.
> >>
> >> Is this the first wireless driver to add support for page pool? I'm
> >> thinking we must be seeing something in the wireless path that is
> >> causing an issue such as the function you called out earlier but I
> >> can't see anything obvious.
> > Yes, it's the first driver with page pool support.
> >
> >> One thing we need to be on the lookout for is cloned skbs. When an skb
> >> is cloned the pp_recycle gets copied over. In that case the reference
> >> is moved over to the skb dataref count. What comes to mind is something
> >> like commit 1effe8ca4e34c ("skbuff: fix coalescing for page_pool
> >> fragment recycling").
> > I suspect that the crash might be related to a bad interaction between
> > the page reuse in A-MSDU rx + skb coalescing on TCP rx.
> > If I change the A-MSDU code to copy data instead of reusing fragments,
> > it doesn't crash anymore.

Which piece did you change? My main interest would be trying to narrow
down the section of this function that is causing this. Did you modify
__ieee80211_amsdu_copy or some other function within the setup?

> > I believe the issue must be specific to that codepath, since most
> > received and processed packets are either not A-MSDU or A-MSDU decap has
> > already been performed by the hardware.
> > If I change my test to use 3 client mode interfaces instead of 4, the
> > hardware is able to offload all A-MSDU rx processing and I don't see any
> > crashes anymore.
> >
> > Could you please take another look at ieee80211_amsdu_to_8023s to see if
> > there's anything in there that could cause these issues?

The thing is I am not sure it is the only cause for this. I am
suspecting we are seeing this triggering an issue when combined with
something else.

If we could add some tracing to dump the skb and list buffers that
might be helpful. We would want to verify the pp_recycle value, clone
flag, and for the frags we would want to frag count and page reference
counts. The expectation would be that the original skb should have the
pp_recycle flag set and the frag counts consistent through the
process, and the list skbs should all have taken page references w/ no
pp_recycle on the skbs in the list.

> Here are clues from a few more tests that I ran:
> - preventing the reuse of the last skb in ieee80211_amsdu_to_8023s does
> not prevent the crashes, so the issue is indeed related to taking page
> references and putting the pages in skb fragments.

You said in the first email it stops it and in the second "does not".
I am assuming that is some sort of typo since you seem to be implying
it does resolve it for you. Is that correct?

> - if I return false in skb_try_coalesce, it still crashes:
> https://nbd.name/p/18cac078

Yeah, I wasn't suspecting skb_try_coalesce since we have exercised the
code. My thought was something like the function you mentioned above
plus cloning or something else.
