Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE74E7DC7
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiCYTnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiCYTne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:43:34 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF79223209;
        Fri, 25 Mar 2022 12:14:31 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648235669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HY7hmvosRsrWcoJ7IfSk5DODxbeSrNZv4cuKe9J3RJ8=;
        b=baJT4Mi746IscqfQX5IvSvx5jV2kXy13AhZA1/bT7pbmjaNalkX7SeeKIN+931mPdTUNJj
        ceRZWeb/xtwGe9eeCxxdz9jwWOilAPaptfHPxEPlGZwVxN1Y9gbka87tlYPPC3dJGzNpbD
        uqcIqaIPEkRnR4iMovDQYb0UX+wZXijhqXJTxHuxcbNFZ+C7N8q0Lj6iRRAg1p42zOzF42
        9BA3kiEtJTgEBol/ak22g7XIsigCBo7vhQaGiBRRyHJ5iWHWScWF+Ld1JPJ3wVbF04FcpQ
        JnpO/IJorxxLrDafBHIxh6DeaPgmlU3Fxlr+ODo5adeqLuOfuE9Dg6U7cZXv+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648235669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HY7hmvosRsrWcoJ7IfSk5DODxbeSrNZv4cuKe9J3RJ8=;
        b=1bGtsbx48IfJh0tyu9AqnQ3hZYbnfn1sHjxW9kvDApf/N098cIou1RZ1NHFEOExFKzVxWv
        qNowS2+WL2A//SAg==
To:     kernel test robot <oliver.sang@intel.com>,
        Artem Savkov <asavkov@redhat.com>
Cc:     0day robot <lkp@intel.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        Artem Savkov <asavkov@redhat.com>
Subject: Re: [timer]  d41e0719d5:
 UBSAN:shift-out-of-bounds_in_lib/flex_proportions.c
In-Reply-To: <20220325073827.GB8478@xsang-OptiPlex-9020>
References: <20220325073827.GB8478@xsang-OptiPlex-9020>
Date:   Fri, 25 Mar 2022 20:14:27 +0100
Message-ID: <87k0chhmjw.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25 2022 at 15:38, kernel test robot wrote:
> [   42.401895][    C0] UBSAN: shift-out-of-bounds in lib/flex_proportions.c:80:20
> [   42.410963][    C0] shift exponent -1007885658 is negative

Cute.

> [   42.416462][    C0] CPU: 0 PID: 330 Comm: sed Tainted: G          I       5.17.0-rc6-00027-gd41e0719d576 #1
> [   42.426240][    C0] Hardware name: Dell Inc. OptiPlex 7040/0Y7WYT, BIOS 1.1.1 10/07/2015
> [   42.434363][    C0] Call Trace:
> [   42.437516][    C0]  <TASK>
> [ 42.440319][ C0] dump_stack_lvl (lib/dump_stack.c:107) 
> [ 42.444699][ C0] ubsan_epilogue (lib/ubsan.c:152) 
> [ 42.448985][ C0] __ubsan_handle_shift_out_of_bounds.cold (lib/ubsan.c:330) 
> [ 42.455618][ C0] ? cpumask_next (lib/cpumask.c:23) 
> [ 42.459996][ C0] ? __percpu_counter_sum (lib/percpu_counter.c:138) 
> [ 42.465248][ C0] fprop_new_period.cold (lib/flex_proportions.c:80 (discriminator 1)) 
> [ 42.470224][ C0] writeout_period (mm/page-writeback.c:623) 

So it seems a timer fired early. Which then makes writeout_period() go south:

	int miss_periods = (jiffies - dom->period_time) / VM_COMPLETIONS_PERIOD_LEN;

If jiffies < dom->period_time the result is a very large negative
number.

This happens because of:

> @@ -67,7 +67,8 @@ struct timer_list {
>  #define TIMER_DEFERRABLE	0x00080000
>  #define TIMER_PINNED		0x00100000
>  #define TIMER_IRQSAFE		0x00200000
> -#define TIMER_INIT_FLAGS	(TIMER_DEFERRABLE | TIMER_PINNED | TIMER_IRQSAFE)
> +#define TIMER_UPPER_BOUND	0x00400000
> +#define TIMER_INIT_FLAGS	(TIMER_DEFERRABLE | TIMER_PINNED | TIMER_IRQSAFE | TIMER_UPPER_BOUND)
> #define TIMER_ARRAYSHIFT	22
> #define TIMER_ARRAYMASK		0xFFC00000

TIMER_UPPER_BOUND steals a bit from the ARRAYMASK. So if the timer is
armed and the stored arraymask happens to have bit 22 set, then on the
next arming of the timer it will be treated as upper bound timer,
expires early and all hell breaks lose. The same can happen the other
way round. So I really have to ask how this ever "worked".

Thanks,

        tglx
