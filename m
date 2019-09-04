Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3582A822D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 14:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbfIDMO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 08:14:26 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39449 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbfIDMO0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 08:14:26 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so24068301qtb.6
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 05:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bl6KGDbxyH9xibYLFzb2mGM47IhCp8dCBtbeKfHElvA=;
        b=QnuouqMmL8Ruk+R6jgbyEXsFKtEUI5jAhWEUccMzoIFT3hIMpBl5QgvXmfPajbeZgi
         d2iMXBHvzXkhD7THAH6LnGOC8s/EcsqTzcVeAI3UnGtcjpKZGJt9NPTdmm5cTcnuw2XO
         N7Hi3qrBbJdk3+mwG9Milp6EEDXrhwxY1Uvt0wOyxopI4PH9pLEML/64jmM/Ls+0o47e
         ktXGLGHcIC5QGyLUWDJb1dIU4+DiP5SK1Z8QCMsBF1GWBujQzoXO1C5jS6EoUMD6kApL
         qjrI+wfMsyPkw9IUz1frp0Vpe+I20t/JM75jAVRP8cFXMe71o4zxTvut7gNWwNvoMf5a
         NXkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bl6KGDbxyH9xibYLFzb2mGM47IhCp8dCBtbeKfHElvA=;
        b=T4YW/xjtYSt3OFQ1DtcWr5rrI5f3ALy7PzTgZ1p/90xIfwmlrgticckw0+OEniwCTM
         P8kv33AXj43AjX2Hw0l2E+I/pw8jYRyztcm3pek0lxbMXFpsmq/C8NIXgOz5u+2My7uz
         PnvBwW7uaJhnx0Vb81eWqRnnfsJ45Rv1MmnZiIxo0W7sJwHA6f7v8cIztpE79S4adRgI
         pKmIbmdVDb0oa4NOgPrIwhn/z/tI7lYfMjJxJT7D95c8KaAgwzn7dC9lavrjeVd2lPYg
         BUyPY+REW7ZyCBKY+FSLu7BXGrh8Iec8bGGl9iau+dztgr+WKxRF6ZM9WQ+KPlSZdkCN
         hZNw==
X-Gm-Message-State: APjAAAXYhe9jHw4YpJ98Y0zg0QhbJX4IpVXExWJwhdAzYH2wjXHsfybL
        /UBZjVC2J/Q760ShB0wz4icx4A==
X-Google-Smtp-Source: APXvYqwVMedOXPfbW97QL3Tml18XfuCAjaFmLYqEjgyl13jtOyVoXSys9SE3TEG9CouaQn2bE7sZGw==
X-Received: by 2002:a0c:8ad0:: with SMTP id 16mr14055557qvw.237.1567599265215;
        Wed, 04 Sep 2019 05:14:25 -0700 (PDT)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 29sm7794713qkp.86.2019.09.04.05.14.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 05:14:24 -0700 (PDT)
Message-ID: <1567599263.5576.72.camel@lca.pw>
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
From:   Qian Cai <cai@lca.pw>
To:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Michal Hocko <mhocko@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Date:   Wed, 04 Sep 2019 08:14:23 -0400
In-Reply-To: <20190904074312.GA25744@jagdpanzerIV>
References: <1567178728.5576.32.camel@lca.pw>
         <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
         <20190903132231.GC18939@dhcp22.suse.cz> <1567525342.5576.60.camel@lca.pw>
         <20190903185305.GA14028@dhcp22.suse.cz> <1567546948.5576.68.camel@lca.pw>
         <20190904061501.GB3838@dhcp22.suse.cz> <20190904064144.GA5487@jagdpanzerIV>
         <20190904065455.GE3838@dhcp22.suse.cz>
         <20190904071911.GB11968@jagdpanzerIV> <20190904074312.GA25744@jagdpanzerIV>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-09-04 at 16:43 +0900, Sergey Senozhatsky wrote:
> On (09/04/19 16:19), Sergey Senozhatsky wrote:
> > Hmm. I need to look at this more... wake_up_klogd() queues work only once
> > on particular CPU: irq_work_queue(this_cpu_ptr(&wake_up_klogd_work));
> > 
> > bool irq_work_queue()
> > {
> > 	/* Only queue if not already pending */
> > 	if (!irq_work_claim(work))
> > 		return false;
> > 
> > 	 __irq_work_queue_local(work);
> > }
> 
> Plus one more check - waitqueue_active(&log_wait). printk() adds
> pending irq_work only if there is a user-space process sleeping on
> log_wait and irq_work is not already scheduled. If the syslog is
> active or there is noone to wakeup then we don't queue irq_work.

Another possibility for this potential livelock is that those printk() from
warn_alloc(), dump_stack() and show_mem() increase the time it needs to process
build_skb() allocation failures significantly under memory pressure. As the
result, ksoftirqd() could be rescheduled during that time via a different CPU
(this is a large x86 NUMA system anyway),

[83605.577256][   C31]  run_ksoftirqd+0x1f/0x40
[83605.577256][   C31]  smpboot_thread_fn+0x255/0x440
[83605.577256][   C31]  kthread+0x1df/0x200
[83605.577256][   C31]  ret_from_fork+0x35/0x40

In addition, those printk() will deal with console drivers or even a networking
console, so it is probably not unusual that it could call irq_exit()-
>__do_softirq() at one point and then this livelock.
