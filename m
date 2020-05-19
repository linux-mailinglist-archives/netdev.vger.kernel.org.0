Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50EC31DA530
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 01:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgESXLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 19:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgESXLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 19:11:51 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51801C061A0E
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 16:11:51 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ci23so381523pjb.5
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 16:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qurn0n4Y6IbvY2sEfXURphuvrrh6gfojPnRjnDn7wmQ=;
        b=c+jIAV2c/bV5qZGOszyYayikwXcF7DKN3e/82k14r0BVVXHmikat7+pOCFJrOAu0zL
         RNozuDILbgOwEW8AnXvWsuyfVUC1nwEEm84RLu68+rJNE8HVJ8VeI52CpVPsxMIN8fot
         56y8qb5VURVIT2vodgUGu9JLnt0CQkMLxsmJxbPz5uexuZpBDUeBDO7DD9BXrCV8sZoj
         K50nbJp286ZdjHh8Edcdxj0luEWiIM8eQigudlmQhuXr2mJMocfPP0xGyZiYKa+F6Otv
         YrlS6mwOxFluyF88sYqPJZNC3cOhs+vOGTMQ85HGnoMc4JfIXipn7ql3hYMaNvCgf1KH
         kwOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qurn0n4Y6IbvY2sEfXURphuvrrh6gfojPnRjnDn7wmQ=;
        b=F0WQR7qzCvi7iaaLfhKEN9N/4iWuwDpb1GMPXcamBpXcDdClbtLjIa+RbGS/ogBqui
         hF6qO0TeD7Mrki9v9xEjt3caREElgRfcp3Xfy6ZBBm5WTFdTt5LN0S9VqLYCwd6LhJGO
         qSf4p38AlnUuTkO3+eDzFxASVy32DofDs3BqlOQkLRUL4vWT+Kg5qze6jpXvvrgeIuLS
         ob8iZ7pbMzFO+as4WaizCUYNYzqvC53+0yrMkAwfaiPduweKk6WMKcpfvNSvjFn1tSds
         cZFuwJSthsIlro/L8NrtNMMexOeDky/LLoBf5r63ssg05jy35OECeUa3aSAgKLkdhn5q
         wDOA==
X-Gm-Message-State: AOAM533lKgs3u4XwLpUFSvX2DM6PYUlarVQKIrIheyoeFVhHQofqd0uj
        /4ZW/7nh7U1YCAZYhKgmfPb8jg==
X-Google-Smtp-Source: ABdhPJwWcerbxfvi9Ui7U/h1FcFOUmMVeLA1WEqPpaQ3yyNdQW6PjE8iKL+kelCC2wV+F+ZeFViENw==
X-Received: by 2002:a17:90b:ed2:: with SMTP id gz18mr2004324pjb.22.1589929910813;
        Tue, 19 May 2020 16:11:50 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 131sm397060pgf.49.2020.05.19.16.11.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 16:11:50 -0700 (PDT)
Date:   Tue, 19 May 2020 16:11:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of
 a seqcount
Message-ID: <20200519161141.5fbab730@hermes.lan>
In-Reply-To: <87v9kr5zt7.fsf@nanos.tec.linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
        <20200519214547.352050-2-a.darwish@linutronix.de>
        <20200519150159.4d91af93@hermes.lan>
        <87v9kr5zt7.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 May 2020 00:23:48 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> Stephen Hemminger <stephen@networkplumber.org> writes:
> > On Tue, 19 May 2020 23:45:23 +0200
> > "Ahmed S. Darwish" <a.darwish@linutronix.de> wrote:
> >  
> >> Sequence counters write paths are critical sections that must never be
> >> preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.
> >> 
> >> Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
> >> netdev name retrieval.") handled a deadlock, observed with
> >> CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
> >> infinitely spinning: it got scheduled after the seqcount write side
> >> blocked inside its own critical section.
> >> 
> >> To fix that deadlock, among other issues, the commit added a
> >> cond_resched() inside the read side section. While this will get the
> >> non-preemptible kernel eventually unstuck, the seqcount reader is fully
> >> exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.
> >> 
> >> The fix is also still broken: if the seqcount reader belongs to a
> >> real-time scheduling policy, it can spin forever and the kernel will
> >> livelock.
> >> 
> >> Disabling preemption over the seqcount write side critical section will
> >> not work: inside it are a number of GFP_KERNEL allocations and mutex
> >> locking through the drivers/base/ :: device_rename() call chain.
> >> 
> >> From all the above, replace the seqcount with a rwsem.
> >> 
> >> Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
> >> Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
> >> Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> >> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>  
> >
> > Have your performance tested this with 1000's of network devices?  
> 
> No. We did not. -ENOTESTCASE

Please try, it isn't that hard..

# time for ((i=0;i<1000;i++)); do ip li add dev dummy$i type dummy; done

real	0m17.002s
user	0m1.064s
sys	0m0.375s
