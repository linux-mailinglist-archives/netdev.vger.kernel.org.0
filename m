Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B28DAAA181
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 13:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388530AbfIELcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 07:32:14 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43002 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388518AbfIELcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 07:32:13 -0400
Received: by mail-pf1-f196.google.com with SMTP id w22so1555494pfi.9;
        Thu, 05 Sep 2019 04:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=O2/2/UiNnPo2yFEZQiWQVkrfXLV3W+bgqpQbiqeCV1g=;
        b=Z8+XdGz7F2tDUyCosgkoIQT++5bXAeKZmhLPORlnDKcdVvyoeiYDUAM+Bz+BZrUdXD
         9v50xTLEkfzHJItvhLjlTCfg8cH7NFDUWKGg/JBWiYLP1pbiqciVQVv/kR7H43kpFyxM
         dVznmyxSukLwD3F/fuwtNxUQdtdU1f8qEGtXFZCLXduqzl7Kb/ptZHOOXwo9KHuhZsJt
         tjZCYiHCNiiFwlbMLtqTDMYd7yDm73JuA29rHETz0A9DDSMUuPJNL6ObCtWTpLQY900C
         KLU4y3igDxU+UslXXWebYVKFfqNGd3CRDKSBO6KxXSt9dTtvZhT0qQQykJRr81/FuvXs
         3qPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=O2/2/UiNnPo2yFEZQiWQVkrfXLV3W+bgqpQbiqeCV1g=;
        b=lRhSdyBRUoB0LtCvSC35SNs4Ah7MLQYsJr1jZR3wAnbJcbPodcNmA4HwjZk4tFdZzM
         K4JCQITdg3L5n/Vv75tHHDB6ptxgWwTPeV0EIb+XHQri5W+FrUU4dg++R9gQlrdN7yaG
         2P7PKq/WDfIBlG31Dnja6EiLkOmnNku54H+gGS8br4iiC4dKJm9sZdmt64Wy1eioUBVk
         wrBBjlefbFChg2fViljBgi9deAcs0C7qZzJgIYzD8vnJIoVweIqSonExk9qcOJHuhhmt
         oSJApoH0xkXwaA5ZsjN5CEuwaQJ4lIdeXWSeycJKXUxkbE+NRoE3I4ARyfBBQuHb/ZhO
         7XXA==
X-Gm-Message-State: APjAAAUClQoyX4c4++9PzZkSZe/zVMG2Hli3/HVOAx+uvVPIVWAtoDht
        AuV4cqHToe27WpfEds7GHBc=
X-Google-Smtp-Source: APXvYqwMP3hi30dLG+ZuFVM6jRWm3eBY7wUln0Huh4bzmedKn7U/jTUHn6v2CFn6EGBQZ6I4thMKgQ==
X-Received: by 2002:a17:90a:3462:: with SMTP id o89mr3387204pjb.2.1567683132905;
        Thu, 05 Sep 2019 04:32:12 -0700 (PDT)
Received: from localhost ([175.223.39.227])
        by smtp.gmail.com with ESMTPSA id q2sm3101737pfg.144.2019.09.05.04.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 04:32:12 -0700 (PDT)
Date:   Thu, 5 Sep 2019 20:32:08 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Qian Cai <cai@lca.pw>, Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
Message-ID: <20190905113208.GA521@jagdpanzerIV>
References: <20190903185305.GA14028@dhcp22.suse.cz>
 <1567546948.5576.68.camel@lca.pw>
 <20190904061501.GB3838@dhcp22.suse.cz>
 <20190904064144.GA5487@jagdpanzerIV>
 <20190904065455.GE3838@dhcp22.suse.cz>
 <20190904071911.GB11968@jagdpanzerIV>
 <20190904074312.GA25744@jagdpanzerIV>
 <1567599263.5576.72.camel@lca.pw>
 <20190904144850.GA8296@tigerII.localdomain>
 <1567629737.5576.87.camel@lca.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1567629737.5576.87.camel@lca.pw>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (09/04/19 16:42), Qian Cai wrote:
> > Let me think more.
> 
> To summary, those look to me are all good long-term improvement that would
> reduce the likelihood of this kind of livelock in general especially for other
> unknown allocations that happen while processing softirqs, but it is still up to
> the air if it fixes it 100% in all situations as printk() is going to take more
> time

Well. So. I guess that we don't need irq_work most of the time.

We need to queue irq_work for "safe" wake_up_interruptible(), when we
know that we can deadlock in scheduler. IOW, only when we are invoked
from the scheduler. Scheduler has printk_deferred(), which tells printk()
that it cannot do wake_up_interruptible(). Otherwise we can just use
normal wake_up_process() and don't need that irq_work->wake_up_interruptible()
indirection. The parts of the scheduler, which by mistake call plain printk()
from under pi_lock or rq_lock have chances to deadlock anyway and should
be switched to printk_deferred().

I think we can queue significantly much less irq_work-s from printk().

Petr, Steven, what do you think?

Something like this. Call wake_up_interruptible(), switch to
wake_up_klogd() only when called from sched code.

---
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index cd51aa7d08a9..89cb47882254 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2027,8 +2027,11 @@ asmlinkage int vprintk_emit(int facility, int level,
 	pending_output = (curr_log_seq != log_next_seq);
 	logbuf_unlock_irqrestore(flags);
 
+	if (!pending_output)
+		return printed_len;
+
 	/* If called from the scheduler, we can not call up(). */
-	if (!in_sched && pending_output) {
+	if (!in_sched) {
 		/*
 		 * Disable preemption to avoid being preempted while holding
 		 * console_sem which would prevent anyone from printing to
@@ -2043,10 +2046,11 @@ asmlinkage int vprintk_emit(int facility, int level,
 		if (console_trylock_spinning())
 			console_unlock();
 		preempt_enable();
-	}
 
-	if (pending_output)
+		wake_up_interruptible(&log_wait);
+	} else {
 		wake_up_klogd();
+	}
 	return printed_len;
 }
 EXPORT_SYMBOL(vprintk_emit);
---

> and could deal with console hardware that involve irq_exit() anyway.

printk->console_driver->write() does not involve irq.

> On the other hand, adding __GPF_NOWARN in the build_skb() allocation will fix
> this known NET_TX_SOFTIRQ case which is common when softirqd involved at least
> in short-term. It even have a benefit to reduce the overall warn_alloc() noise
> out there.

That's not up to me to decide.

	-ss
