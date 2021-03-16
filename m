Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C6533D1C5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 11:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhCPK1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 06:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbhCPK1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 06:27:02 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969D8C06175F
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 03:27:00 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id o19so3253417qvu.0
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 03:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=V0BTN/Z2jXatx08nLmn2iGZ7O1WuylzrrulrDON6R9k=;
        b=xCib9ZN+FiOtHqn2f2GIRYRiTffT7uatWQxo/AtFklW7YHFihG2zQ/vTE6gNPQNf+9
         vRO50HskMB8FxFuo2e/yIPiiEjRMNR2akfE/kxzq3hVHcZW6gbBwrXGM/nkazzsBxspT
         IDDzm1pyKpT157y7ETbYQl89HFKamnR3YLguRbBuNUGLzFKgCZyAKpgnaNfuYaC+pVa6
         LpmHEpA95pzB9VWM6M9mop0H7Z1xD8Vy9M7yIxp15Me9nGIHP1oJuFRaG4tLl0wyVweM
         Pvxba1+vGHWQ9Sr05/mHjYuGYAaztxJfRkzf+J9pX0/vBFCFzOae7JoD3GMPcoWagsvR
         gusg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=V0BTN/Z2jXatx08nLmn2iGZ7O1WuylzrrulrDON6R9k=;
        b=JQ5VE+erH26xs3BiQ2yIGQFqyJhKRpi/HYQCRO/uRMZp7S0WjyjaNIgvPi3Rj5lZa3
         +Qgld/st1+P4OLC6Lc4JU6Ul/T9vhASIw4A9fKav06FXLekzlXywrJApauBWWdzgBDDa
         EUys9Tm8rtdeWzuTg8OAAVQDiDKAqiV3iT0ZQV7fmj4FUFWleRVME2otAdrTPssMr6cc
         PP5+XnZwrJiW8TZE0+LWX/uoLe0jKp3aa+0kPtsN08bQ0sGEGRtkGTnekPoCF5CLmtlJ
         H8H+KsDLuo0IlMVkl6Jcrw4l9Rvg5SP5K5uYoeVoLTJVYQhizRgecus56LXPLa+fwnLz
         Q9uQ==
X-Gm-Message-State: AOAM530EE/H/LxyUVTI74OhV/2ecg/gdFZEySQ+eIOK8dJYeMpn21AFF
        WeRMbofoE14p2DDJPyycuoe12A==
X-Google-Smtp-Source: ABdhPJx1Qe12G4sXm6Hq0b39qzz4yiSC2X02eGBokp2+4l6Cg0jAMpo13TlhKMrD8MSowvisz7/VDA==
X-Received: by 2002:a0c:f890:: with SMTP id u16mr15165954qvn.21.1615890419711;
        Tue, 16 Mar 2021 03:26:59 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:7693])
        by smtp.gmail.com with ESMTPSA id c19sm14587625qkl.78.2021.03.16.03.26.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 03:26:59 -0700 (PDT)
Date:   Tue, 16 Mar 2021 06:26:58 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Arjun Roy <arjunroy.kdev@gmail.com>
Cc:     akpm@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org, arjunroy@google.com,
        shakeelb@google.com, edumazet@google.com, soheil@google.com,
        kuba@kernel.org, mhocko@kernel.org, shy828301@gmail.com,
        guro@fb.com
Subject: Re: [mm, net-next v2] mm: net: memcg accounting for TCP rx zerocopy
Message-ID: <YFCH8vzFGmfFRCvV@cmpxchg.org>
References: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316041645.144249-1-arjunroy.kdev@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Mar 15, 2021 at 09:16:45PM -0700, Arjun Roy wrote:
> From: Arjun Roy <arjunroy@google.com>
> 
> TCP zerocopy receive is used by high performance network applications
> to further scale. For RX zerocopy, the memory containing the network
> data filled by the network driver is directly mapped into the address
> space of high performance applications. To keep the TLB cost low,
> these applications unmap the network memory in big batches. So, this
> memory can remain mapped for long time. This can cause a memory
> isolation issue as this memory becomes unaccounted after getting
> mapped into the application address space. This patch adds the memcg
> accounting for such memory.
> 
> Accounting the network memory comes with its own unique challenges.
> The high performance NIC drivers use page pooling to reuse the pages
> to eliminate/reduce expensive setup steps like IOMMU. These drivers
> keep an extra reference on the pages and thus we can not depend on the
> page reference for the uncharging. The page in the pool may keep a
> memcg pinned for arbitrary long time or may get used by other memcg.

The page pool knows when a page is unmapped again and becomes
available for recycling, right? Essentially the 'free' phase of that
private allocator. That's where the uncharge should be done.

For one, it's more aligned with the usual memcg charge lifetime rules.

But also it doesn't add what is essentially a private driver callback
to the generic file unmapping path.

Finally, this will eliminate the need for making up a new charge type
(MEMCG_DATA_SOCK) and allow using the standard kmem charging API.

> This patch decouples the uncharging of the page from the refcnt and
> associates it with the map count i.e. the page gets uncharged when the
> last address space unmaps it. Now the question is, what if the driver
> drops its reference while the page is still mapped? That is fine as
> the address space also holds a reference to the page i.e. the
> reference count can not drop to zero before the map count.
> 
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Co-developed-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> ---
> 
> Changelog since v1:
> - Pages accounted for in this manner are now tracked via MEMCG_SOCK.
> - v1 allowed for a brief period of double-charging, now we have a
>   brief period of under-charging to avoid undue memory pressure.

I'm afraid we'll have to go back to v1.

Let's address the issues raised with it:

1. The NR_FILE_MAPPED accounting. It is longstanding Linux behavior
   that driver pages mapped into userspace are accounted as file
   pages, because userspace is actually doing mmap() against a driver
   file/fd (as opposed to an anon mmap). That is how they show up in
   vmstat, in meminfo, and in the per process stats. There is no
   reason to make memcg deviate from this. If we don't like it, it
   should be taken on by changing vm_insert_page() - not trick rmap
   into thinking these arent memcg pages and then fixing it up with
   additional special-cased accounting callbacks.

   v1 did this right, it charged the pages the way we handle all other
   userspace pages: before rmap, and then let the generic VM code do
   the accounting for us with the cgroup-aware vmstat infrastructure.

2. The double charging. Could you elaborate how much we're talking
   about in any given batch? Is this a problem worth worrying about?

   The way I see it, any conflict here is caused by the pages being
   counted in the SOCK counter already, but not actually *tracked* on
   a per page basis. If it's worth addressing, we should look into
   fixing the root cause over there first if possible, before trying
   to work around it here.

   The newly-added GFP_NOFAIL is especially worrisome. The pages
   should be charged before we make promises to userspace, not be
   force-charged when it's too late.

   We have sk context when charging the inserted pages. Can we
   uncharge MEMCG_SOCK after each batch of inserts? That's only 32
   pages worth of overcharging, so not more than the regular charge
   batch memcg is using.

   An even better way would be to do charge stealing where we reuse
   the existing MEMCG_SOCK charges and don't have to get any new ones
   at all - just set up page->memcg and remove the charge from the sk.

   But yeah, it depends a bit if this is a practical concern.

Thanks,
Johannes
