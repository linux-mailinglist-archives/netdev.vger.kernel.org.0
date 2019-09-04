Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29700A88FC
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbfIDOsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:48:55 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46902 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727789AbfIDOsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 10:48:55 -0400
Received: by mail-pg1-f194.google.com with SMTP id m3so11346912pgv.13;
        Wed, 04 Sep 2019 07:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Y0Way3KHGFmyr4IdZ55Bi63R1MS1mhVmJWvvJPi7ufE=;
        b=WqjoJjQ8S4lX609PlOBqGbYMVGDW7BSa431Cl3izLPCn2DMGQleTv8LbHmsWiS7r8y
         3JBCO4Y7rkL3QwMisIOFGqPHMRGV1eYsP2nTVd7+HwuE+3C0R0aiKGrpBfCK60fVcbX2
         he68y1N5zS8z7CyMnvMi5M+U7rBvjYxHV/cj1ewYaH+4V/YN13QxCf2oX0yCS/S5kPt5
         HDYpFbswKqkb6MfUh8lIsVrnwnSBMUUb/2Xj7bVOnd+ieTuy4ee2NK1wYGtdpo1iHMRK
         5pFsIVK7r+xOWL8aIhfOGEVEuZOWvZ6HNWXP9SlgVmFFA8hEu1/HHk4sys20eOt9tLql
         6vHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Y0Way3KHGFmyr4IdZ55Bi63R1MS1mhVmJWvvJPi7ufE=;
        b=amc4aK7FNMxTHqU77ZOucxP5vekC6XzWBMq9w51K31P60UlyGx91KBibpxYZPTRQpf
         GqytsfvgWe5XlGO7nG0en0Cb8MzkJ4iYJ4j3PufuOT1Tj6bEeRQ56eJ3NVj2g3rFHpL8
         RXTHQFPX0TJSsaAGmKr/iivVNRoMeueN5E8EQXN8JOYsMbrRPO0v4dJF4a4ylTr0peFV
         oHlsmf0zcc3U1c90fZd3pTkVDTJWqD7PzQiZmnqCvE53jysu3nwxioKWufx0OoFRI5E6
         k9vvl+l1xl4RTnj/GkRxLwQMnlb3DgH+PbXzjsraQgMh3QZNoZh0wNQOGwBFkD8H0VBx
         rjqQ==
X-Gm-Message-State: APjAAAUp33OBr9rIF9/hN8JyLjSie6hnxTzQlskQnry62z6yqvJMqv2k
        9a2K/NyalrlMkoj6duJ4fTE=
X-Google-Smtp-Source: APXvYqxW6zv9Q8MMQUyy/57EoTj5mk4de72N7EcxPzQhS0BTGdBSndFBF7RHG+eJ6QvAnkqTlGVRzA==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr5434986pjq.143.1567608534744;
        Wed, 04 Sep 2019 07:48:54 -0700 (PDT)
Received: from localhost ([121.137.63.184])
        by smtp.gmail.com with ESMTPSA id m4sm21145034pgs.71.2019.09.04.07.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 07:48:53 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Wed, 4 Sep 2019 23:48:50 +0900
To:     Qian Cai <cai@lca.pw>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190904144850.GA8296@tigerII.localdomain>
References: <20190903132231.GC18939@dhcp22.suse.cz>
 <1567525342.5576.60.camel@lca.pw>
 <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1567599263.5576.72.camel@lca.pw>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/04/19 08:14), Qian Cai wrote:
> > Plus one more check - waitqueue_active(&log_wait). printk() adds
> > pending irq_work only if there is a user-space process sleeping on
> > log_wait and irq_work is not already scheduled. If the syslog is
> > active or there is noone to wakeup then we don't queue irq_work.
> 
> Another possibility for this potential livelock is that those printk() from
> warn_alloc(), dump_stack() and show_mem() increase the time it needs to process
> build_skb() allocation failures significantly under memory pressure. As the
> result, ksoftirqd() could be rescheduled during that time via a different CPU
> (this is a large x86 NUMA system anyway),
> 
> [83605.577256][   C31]  run_ksoftirqd+0x1f/0x40
> [83605.577256][   C31]  smpboot_thread_fn+0x255/0x440
> [83605.577256][   C31]  kthread+0x1df/0x200
> [83605.577256][   C31]  ret_from_fork+0x35/0x40

Hum hum hum...

So I can, _probably_, think of several patches.

First, move wake_up_klogd() back to console_unlock().

Second, move `printk_pending' out of per-CPU region and make it global.
So we will have just one printk irq_work scheduled across all CPUs;
currently we have one irq_work per CPU. I think I sent a patch a long
long time ago, but we never discussed it, as far as I remember.

> In addition, those printk() will deal with console drivers or even a networking
> console, so it is probably not unusual that it could call irq_exit()-
>__do_softirq() at one point and then this livelock.

Do you use netcon? Because this, theoretically, can open up one more
vector. netcon allocates skbs from ->write() path. We call con drivers'
->write() from printk_safe context, so should netcon skb allocation
warn we will scedule one more irq_work on that CPU to flush per-CPU
printk_safe buffer.

If this is the case, then we can stop calling console_driver() under
printk_safe. I sent a patch a while ago, but we agreed to keep the
things the way they are, fot the time being.

Let me think more.

	-ss
