Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F16398A92
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhFBNdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhFBNc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:32:56 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDDF1C061756;
        Wed,  2 Jun 2021 06:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=xAgXF5452HulRjyD+JrT6Ce1EM30lHGgXf0FUiEeuf8=; b=VvpK7YiNmJCX41zrA8okNEybDp
        eQ6B/no5m3jpzjv3vtsCvj/I+JC23a6uedcV8jgSiowQRskTunxDthNkfNGhTAFIlNg7Mp34lDO1v
        cJi7jUAN8r25x997QWW1iZ1s0mJEO/4TCJLBsUD/Lwvj8V5xmtHLkWqJ3/i+cAuwKhHWJJh3gK3Ih
        vP6xpGukyGIL5aEjAbdHmS9jRaDI483T3jnwPxONjWNDG4udVku6TL780C9Ec0NINGrPz5nI2nlsi
        VM1b+8ilWKuCZZyiB9PWMQ/LkZFJTj3o+rZcyBY6BUTJfo/Lky1rn8D/U1takW/WZq9JTYU9U5iTx
        ooUsJycA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1loQxX-002toZ-ED; Wed, 02 Jun 2021 13:31:06 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B7F0F3002A3;
        Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 950C12016D6C5; Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Message-ID: <20210602133040.271625424@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 02 Jun 2021 15:12:26 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        John Stultz <john.stultz@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        linux-perf-users@vger.kernel.org, linux-pm@vger.kernel.org,
        rcu@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org
Subject: [PATCH 1/6] sched: Unbreak wakeups
References: <20210602131225.336600299@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove broken task->state references and let wake_up_process() DTRT.

The anti-pattern in these patches breaks the ordering of ->state vs
COND as described in the comment near set_current_state() and can lead
to missed wakeups:

	(OoO load, observes RUNNING)<-.
	for (;;) {                    |
	  t->state = UNINTERRUPTIBLE; |
	  smp_mb();          ,-----> ,' (OoO load, observed !COND)
                             |       |
	                     |       |	COND = 1;
			     |	     `- if (t->state != RUNNING)
                             |		  wake_up_process(t); // not done
	  if (COND) ---------'
	    break;
	  schedule(); // forever waiting
	}
	t->state = TASK_RUNNING;

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c |    6 ++----
 drivers/usb/gadget/udc/max3420_udc.c    |   15 +++++----------
 drivers/usb/host/max3421-hcd.c          |    3 +--
 kernel/softirq.c                        |    2 +-
 4 files changed, 9 insertions(+), 17 deletions(-)

--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -653,8 +653,7 @@ qcaspi_intr_handler(int irq, void *data)
 	struct qcaspi *qca = data;
 
 	qca->intr_req++;
-	if (qca->spi_thread &&
-	    qca->spi_thread->state != TASK_RUNNING)
+	if (qca->spi_thread)
 		wake_up_process(qca->spi_thread);
 
 	return IRQ_HANDLED;
@@ -777,8 +776,7 @@ qcaspi_netdev_xmit(struct sk_buff *skb,
 
 	netif_trans_update(dev);
 
-	if (qca->spi_thread &&
-	    qca->spi_thread->state != TASK_RUNNING)
+	if (qca->spi_thread)
 		wake_up_process(qca->spi_thread);
 
 	return NETDEV_TX_OK;
--- a/drivers/usb/gadget/udc/max3420_udc.c
+++ b/drivers/usb/gadget/udc/max3420_udc.c
@@ -509,8 +509,7 @@ static irqreturn_t max3420_vbus_handler(
 			     ? USB_STATE_POWERED : USB_STATE_NOTATTACHED);
 	spin_unlock_irqrestore(&udc->lock, flags);
 
-	if (udc->thread_task &&
-	    udc->thread_task->state != TASK_RUNNING)
+	if (udc->thread_task)
 		wake_up_process(udc->thread_task);
 
 	return IRQ_HANDLED;
@@ -529,8 +528,7 @@ static irqreturn_t max3420_irq_handler(i
 	}
 	spin_unlock_irqrestore(&udc->lock, flags);
 
-	if (udc->thread_task &&
-	    udc->thread_task->state != TASK_RUNNING)
+	if (udc->thread_task)
 		wake_up_process(udc->thread_task);
 
 	return IRQ_HANDLED;
@@ -1093,8 +1091,7 @@ static int max3420_wakeup(struct usb_gad
 
 	spin_unlock_irqrestore(&udc->lock, flags);
 
-	if (udc->thread_task &&
-	    udc->thread_task->state != TASK_RUNNING)
+	if (udc->thread_task)
 		wake_up_process(udc->thread_task);
 	return ret;
 }
@@ -1117,8 +1114,7 @@ static int max3420_udc_start(struct usb_
 	udc->todo |= UDC_START;
 	spin_unlock_irqrestore(&udc->lock, flags);
 
-	if (udc->thread_task &&
-	    udc->thread_task->state != TASK_RUNNING)
+	if (udc->thread_task)
 		wake_up_process(udc->thread_task);
 
 	return 0;
@@ -1137,8 +1133,7 @@ static int max3420_udc_stop(struct usb_g
 	udc->todo |= UDC_START;
 	spin_unlock_irqrestore(&udc->lock, flags);
 
-	if (udc->thread_task &&
-	    udc->thread_task->state != TASK_RUNNING)
+	if (udc->thread_task)
 		wake_up_process(udc->thread_task);
 
 	return 0;
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1169,8 +1169,7 @@ max3421_irq_handler(int irq, void *dev_i
 	struct spi_device *spi = to_spi_device(hcd->self.controller);
 	struct max3421_hcd *max3421_hcd = hcd_to_max3421(hcd);
 
-	if (max3421_hcd->spi_thread &&
-	    max3421_hcd->spi_thread->state != TASK_RUNNING)
+	if (max3421_hcd->spi_thread)
 		wake_up_process(max3421_hcd->spi_thread);
 	if (!test_and_set_bit(ENABLE_IRQ, &max3421_hcd->todo))
 		disable_irq_nosync(spi->irq);
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -76,7 +76,7 @@ static void wakeup_softirqd(void)
 	/* Interrupts are disabled: no need to stop preemption */
 	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
 
-	if (tsk && tsk->state != TASK_RUNNING)
+	if (tsk)
 		wake_up_process(tsk);
 }
 


