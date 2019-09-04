Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90FCAA93EB
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 22:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729753AbfIDUmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 16:42:22 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:37891 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfIDUmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 16:42:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id b2so78215qtq.5
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 13:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eWOicZgj5Of+wSfvuMxF3nPebfxOImDgPFtP2TA8Hig=;
        b=ZGqEH+6G7pAd8jrzjuGDhWkoWvtaL64D3AW2jvc0zj1/oUJplf2IrF6gHKD5s2FsPw
         Adfze0hKG7/rv+15yzEJjiUX6og3ZyANLD8D4ERpNzpK9YlV6uONlh9xQeKTGv+ZrquI
         hSKMreZSUi810Y6ZWKEeb9LD1PXnDKImDqVZgjLKigfeMpRxfjBMo9OZoosRbYdu8/79
         bC/LvgoUb75NX3rr7WrL9taazuGhCpGAeDkOOoK6nNbcPd9ea3wqJdnrB3QlTAQjQaHv
         uAIhyBb8pqdsGUBbUJ1GvBMJDm22LpVbJdi/xMfxcFKEw56+qyPT7o3odV4a7QNQbRiw
         /B9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eWOicZgj5Of+wSfvuMxF3nPebfxOImDgPFtP2TA8Hig=;
        b=NFq3TuAzBjHTUKuA//WAW91f7v5koxdZ/MTO2hEzhADeigqUVvv0vGYiQKvyrYi9M1
         5lSKZaTbvuFQNOkqGzbMOm8RFv6VI/M8KAgx69aw+r9huFmx5NvTTa5y8wic7g2TLUh/
         /lmzTA65X7bRLHhCG6KQ9ENAVGkQvyMJVQVTV3Dz+5CTRh5E8L80KUNWwJIunCNTSFIM
         fM78KVQUjOKIiNfy9YCkHfON7y/rY6ZOGe+vnPub0Hg0uImFrdFZ2+OR9ekhypQTmC9g
         OiTz5BRrYQ7hlFjxdcFg6gZJopD0IMKJkrnOVehpAyjCb9IyNDYiO3Nvv1zvWiLpkQqp
         h/FA==
X-Gm-Message-State: APjAAAX2U0639a2MwypazMwPPRyQF3BnH6WEszpAL6uOqdvsMwsaKJRT
        P5MSYRhUD4Uel2zYHVqsq0f5uw==
X-Google-Smtp-Source: APXvYqzrVP6ndOunjL/GKt4iRlQLcQKI3XbQbJtOPG0ryuO40Hl4uyz7HZzI+zOrG63rLQ5vi9A3iw==
X-Received: by 2002:a0c:8c0b:: with SMTP id n11mr26275353qvb.66.1567629741114;
        Wed, 04 Sep 2019 13:42:21 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id z200sm87656qkb.5.2019.09.04.13.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 13:42:20 -0700 (PDT)
Message-ID: <1567629737.5576.87.camel@lca.pw>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
From:   Qian Cai <cai@lca.pw>
To:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date:   Wed, 04 Sep 2019 16:42:17 -0400
In-Reply-To: <20190904144850.GA8296@tigerII.localdomain>
References: <20190903132231.GC18939@dhcp22.suse.cz>
         <1567525342.5576.60.camel@lca.pw> <20190903185305.GA14028@dhcp22.suse.cz>
         <1567546948.5576.68.camel@lca.pw> <20190904061501.GB3838@dhcp22.suse.cz>
         <20190904064144.GA5487@jagdpanzerIV> <20190904065455.GE3838@dhcp22.suse.cz>
         <20190904071911.GB11968@jagdpanzerIV> <20190904074312.GA25744@jagdpanzerIV>
         <1567599263.5576.72.camel@lca.pw>
         <20190904144850.GA8296@tigerII.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-04 at 23:48 +0900, Sergey Senozhatsky wrote:
> On (09/04/19 08:14), Qian Cai wrote:
> > > Plus one more check - waitqueue_active(&log_wait). printk() adds
> > > pending irq_work only if there is a user-space process sleeping on
> > > log_wait and irq_work is not already scheduled. If the syslog is
> > > active or there is noone to wakeup then we don't queue irq_work.
> > 
> > Another possibility for this potential livelock is that those printk() from
> > warn_alloc(), dump_stack() and show_mem() increase the time it needs to
> > process
> > build_skb() allocation failures significantly under memory pressure. As the
> > result, ksoftirqd() could be rescheduled during that time via a different
> > CPU
> > (this is a large x86 NUMA system anyway),
> > 
> > [83605.577256][   C31]  run_ksoftirqd+0x1f/0x40
> > [83605.577256][   C31]  smpboot_thread_fn+0x255/0x440
> > [83605.577256][   C31]  kthread+0x1df/0x200
> > [83605.577256][   C31]  ret_from_fork+0x35/0x40
> 
> Hum hum hum...
> 
> So I can, _probably_, think of several patches.
> 
> First, move wake_up_klogd() back to console_unlock().
> 
> Second, move `printk_pending' out of per-CPU region and make it global.
> So we will have just one printk irq_work scheduled across all CPUs;
> currently we have one irq_work per CPU. I think I sent a patch a long
> long time ago, but we never discussed it, as far as I remember.
> 
> > In addition, those printk() will deal with console drivers or even a
> > networking
> > console, so it is probably not unusual that it could call irq_exit()-
> > __do_softirq() at one point and then this livelock.
> 
> Do you use netcon? Because this, theoretically, can open up one more
> vector. netcon allocates skbs from ->write() path. We call con drivers'
> ->write() from printk_safe context, so should netcon skb allocation
> warn we will scedule one more irq_work on that CPU to flush per-CPU
> printk_safe buffer.
> 
> If this is the case, then we can stop calling console_driver() under
> printk_safe. I sent a patch a while ago, but we agreed to keep the
> things the way they are, fot the time being.
> 
> Let me think more.

To summary, those look to me are all good long-term improvement that would
reduce the likelihood of this kind of livelock in general especially for other
unknown allocations that happen while processing softirqs, but it is still up to
the air if it fixes it 100% in all situations as printk() is going to take more
time and could deal with console hardware that involve irq_exit() anyway.

On the other hand, adding __GPF_NOWARN in the build_skb() allocation will fix
this known NET_TX_SOFTIRQ case which is common when softirqd involved at least
in short-term. It even have a benefit to reduce the overall warn_alloc() noise
out there.

I can resubmit with an update changelog. Does it make any sense?
