Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF31A8941
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731311AbfIDPHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:07:23 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39232 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731207AbfIDPHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 11:07:23 -0400
Received: by mail-qt1-f196.google.com with SMTP id n7so24773563qtb.6
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 08:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bjd/DHxyfRBfNYOym7ZeBY5xHPB82GB3Jq5Tu5oVy78=;
        b=jHZXAogLqBHGjDRqzv2BE9ym48eXzz+4o6+zbnl+BwInpdYGrRMShVv8qzdexPoeb/
         vYXQ4ajKw3a/n5aBNC4VhSsCICv9XUxTmuUodSeshCk4Cco25QaHvg6dnhQz8fosfgQW
         GdcmtgH1mepQHwWgJSzdsueMoCHstNRvLxQsljKBxCFAg5cGuLGIs154VmP0Ux4TBYYy
         w7zfMEPdPGk3xYXlT/cpYNjKULaAWUvaGi/iHkRX2uHJFAJX5hHbo0tbzy81ZReiW+07
         hNNIika7P41kvG85V6UeleEL6El+xVcQL5hTfUbrSzmikyiZQQ2jC3RJ6tCSe3DTHqnZ
         pQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bjd/DHxyfRBfNYOym7ZeBY5xHPB82GB3Jq5Tu5oVy78=;
        b=mLn4oP4uf4cEr9D2Ong2rD8dYV0CN68BVHpHXQqeCYj8Ngyga1uAN1eHNE920ExN43
         Ld5l4V8t7E1cPZn7T7WmxUW4wvNRMedOrFQ+0OdHL35uOALuGIyFEaK4bPw1O51oJY6A
         J1zdliRHIaScHmYtobIAUs9opJI2OEKSXedN/ckw9G85kiL1L0QEbFoNz9hX7J5+zKVG
         ZySwY4l6RZ5U/r0map4hY8iFLigUlc/u2EzZhqTi74RiFJDDo3elp27KxMIqPeWFi1Q/
         SO99G5sM6tUYq2kgod22ie2EWzkuuyIC8REfP1na0Vyd9mZnkiMW2v35T+ePParKBw7M
         1zqg==
X-Gm-Message-State: APjAAAVF4K3IP6skcOfH4cqTs7oVv5Y9PGeXQuViU9XSklXdEPAlVO/P
        mSGBMkd3HaMyDVlO2WhUnyZVuDwwwzE=
X-Google-Smtp-Source: APXvYqyUFuGuP1OqyDPej1C7+ccIcKNGMcWn7j0roB5W+o42SqyZvE7l4bW0iAC0eogfNCEovjMcag==
X-Received: by 2002:ac8:295d:: with SMTP id z29mr40394176qtz.168.1567609642691;
        Wed, 04 Sep 2019 08:07:22 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id k54sm1027434qtf.28.2019.09.04.08.07.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 08:07:22 -0700 (PDT)
Message-ID: <1567609639.5576.79.camel@lca.pw>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
From:   Qian Cai <cai@lca.pw>
To:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date:   Wed, 04 Sep 2019 11:07:19 -0400
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

No, I don't use netcon. Just thought to mention it anyway since there could
other people use it.

> 
> If this is the case, then we can stop calling console_driver() under
> printk_safe. I sent a patch a while ago, but we agreed to keep the
> things the way they are, fot the time being.
> 
> Let me think more.
> 
> 	-ss
