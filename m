Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AEA2D7DB3
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 19:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388379AbgLKSJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 13:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729143AbgLKSIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 13:08:53 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948D9C061793;
        Fri, 11 Dec 2020 10:08:13 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id h4so4397831qkk.4;
        Fri, 11 Dec 2020 10:08:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tb0y+vgKZ75r7FvS5QVh1rGnGDYz+mrb7UR1MucpS5w=;
        b=AUs7F4ua1aW9ZopDlCVYQZ6GvmSlovN0hlWDGixtj3frbcGgr4QNT+Ra3lpWARZXJ+
         f4Nw8GgWhumDeCn1ywP5GGnzYP0vGwRIzmYXQa1XvK2YJZqHLc/N3RXUKFdOtf1qry+k
         jMEhOYGOcf7Ric1YLs+0HCb9OEXwRvXZ0sgKcRVOBbi7Skiz+ZMaH5Lk6a/xrpm3yOOd
         UuHzlapcvquwseMbWAahI5MmZPMTAjWCvkJftxW6/2YZA9njqsjT3SNz+jV9kL8mx7op
         Ib8+08PzSXQmMk+Hq8rSYIC+6tpL1cn7nLBpLEr1M+OrkNmqsNj/MPdRE1pMmADvWPNA
         qu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tb0y+vgKZ75r7FvS5QVh1rGnGDYz+mrb7UR1MucpS5w=;
        b=kuMn8Pv6KJcvahQaKIC3uXAtgfjyxRt5AWJHp7Cy6IG/cMpzmpBWuUUpuGub7ReOTj
         6pYJXZfbC44eaWLHSsLQD0UGzUDJoiOgO0bjwtsFZc/ccMuTO3KbF6BTjRZ7WSQMZP5P
         +ZJ5Oj6q1aK5358bTKT9jHIUYVhaCikemq/NoCITuO30Qg9h4p6Pw52knJTYPi28iyXL
         C6ARfgItXBIkwHoPtxZ9Dii/Nvwv0xYsQbevF+ilRAYT3ghfzaVNAvWl/BeBnig0duMY
         Qxpd7rJlX3NUDSkF7hb/FFE/9LP8wm/szuUYzvuQ76wy2HyaZQVziXziewc3saCGdOY8
         7Cjg==
X-Gm-Message-State: AOAM530l3eI7PjkO7wFkrzuBynykAhkPr3kg9Klj0joh3GZTDw3yzgpE
        MARorLiN9YWCnVNoAyQiuTk=
X-Google-Smtp-Source: ABdhPJwvJuRnmcVRNXqpa7e69IuosIRo3bP9ze7lFEvemoSBzlYKUFwNAlUgS46RCQXWVw8VE7FW0w==
X-Received: by 2002:ae9:c01a:: with SMTP id u26mr17800951qkk.372.1607710091170;
        Fri, 11 Dec 2020 10:08:11 -0800 (PST)
Received: from localhost (d27-96-190-162.evv.wideopenwest.com. [96.27.162.190])
        by smtp.gmail.com with ESMTPSA id o21sm6598541qko.9.2020.12.11.10.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 10:08:10 -0800 (PST)
Date:   Fri, 11 Dec 2020 10:08:09 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Pavel Machek <pavel@ucw.cz>, Alex Belits <abelits@marvell.com>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Prasun Kapoor <pkapoor@marvell.com>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "trix@redhat.com" <trix@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "leon@sidebranch.com" <leon@sidebranch.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "pauld@redhat.com" <pauld@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 0/9] "Task_isolation" mode
Message-ID: <20201211180809.GA397355@yury-ThinkPad>
References: <8d887e59ca713726f4fcb25a316e1e932b02823e.camel@marvell.com>
 <20201205204049.GA8578@amd>
 <87h7oz96o6.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7oz96o6.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 06, 2020 at 12:25:45AM +0100, Thomas Gleixner wrote:
> Pavel,
> 
> On Sat, Dec 05 2020 at 21:40, Pavel Machek wrote:
> > So... what kind of guarantees does this aim to provide / what tasks it
> > is useful for?
> >
> > For real time response, we have other approaches.
> 
> Depends on your requirements. Some problems are actually better solved
> with busy polling. See below.
> 
> > If you want to guarantee performnace of the "isolated" task... I don't
> > see how that works. Other tasks on the system still compete for DRAM
> > bandwidth, caches, etc...
> 
> Applications which want to run as undisturbed as possible. There is
> quite a range of those:
> 
>   - Hardware in the loop simulation is today often done with that crude
>     approach of "offlining" a CPU and then instead of playing dead
>     jumping to a preloaded bare metal executable. That's a horrible hack
>     and impossible to debug, but gives them the results they need to
>     achieve. These applications are well optimized vs. cache and memory
>     foot print, so they don't worry about these things too much and they
>     surely don't run on SMI and BIOS value add inflicted machines.
> 
>     Don't even think about waiting for an interrupt to achieve what
>     these folks are doing. So no, there are problems which a general
>     purpose realtime OS cannot solve ever.
> 
>   - HPC computations on large data sets. While the memory foot print is
>     large the access patterns are cache optimized. 
> 
>     The problem there is that any unnecessary IPI, tick interrupt or
>     whatever nuisance is disturbing the carefully optimized cache usage
>     and alone getting rid of the timer interrupt gained them measurable
>     performance. Even very low single digit percentage of runtime saving
>     is valuable for these folks because the compute time on such beasts
>     is expensive.
> 
>   - Realtime guests in KVM. With posted interrupts and a fully populated
>     host side page table there is no point in running host side
>     interrupts or IPIs for random accounting or whatever purposes as
>     they affect the latency in the guest. With all the side effects
>     mitigated and a properly set up guest and host it is possible to get
>     to a zero exit situation after the bootup phase which means pretty
>     much matching bare metal behaviour.
> 
>     Yes, you can do that with e.g. Jailhouse as well, but you lose lots
>     of the fancy things KVM provides. And people care about these not
>     just because they are fancy. They care because their application
>     scenario needs them.
> 
> There are more reasons why people want to be able to get as much
> isolation from the OS as possible but at the same time have a sane
> execution environment, debugging, performance monitoring and the OS
> provided protection mechanisms instead of horrible hacks.
> 
> Isolation makes sense for a range of applications and there is no reason
> why Linux should not support them. 

One good client for the task isolation is Open Data Plane. There are
even some code stubs supposed to enable isolation where needed.

> > If you want to guarantee performnace of the "isolated" task... I don't
> > see how that works. Other tasks on the system still compete for DRAM
> > bandwidth, caches, etc...

My experiments say that typical delay caused by dry IPI or syscall is
2000-20000 'ticks'. Typical delay caused by cache miss is 3-30 ticks.

To guarantee cache / memory bandwidth, one can use resctrl. Linux has
implementation of it for x86 only, but arm64 has support for for
resctrl on CPU side.

Thanks,
Yury

> Thanks,
> 
>         tglx
