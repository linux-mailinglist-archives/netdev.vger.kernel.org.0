Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 924E7398AAD
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 15:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhFBNdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 09:33:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhFBNdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 09:33:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FCCC06174A;
        Wed,  2 Jun 2021 06:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=Sj4Xan1+3aJ6Po5iAXxX9E8AwNGjzz5eYxQ6hRhen0g=; b=hMlj520jMnvNI6O5tUqcyzOgHW
        EHiJoaUSJQ6hVJ7Wpebgbxf98jjwH5xRoh67t9mLVd2A/HfLxY2Yx4h5lqvgKDYtgGojEvu4IefSN
        3DS6NOM57KiQOuJ7YRpVuKxZsMsiHqnRArRHs23pjdvHMQBl6lq9QREaZLgYa75oH3MWB+gJ1tC1J
        +wH4gCxswnyNBmjCumjXo1vOZE8FBxAebh/yrQhXJi8Y54MOt/nDCRBdOX3lrbMZSfd4Wjc7Ev0IX
        oIeI/gLN/0oqtU5QOuXfbcGteiSWIxBhDz2ucFEF9xi8LFZyzr9Fj0M1df6hbsxkqYJsywFl4l0AK
        rwAquI9Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1loQxe-00B8na-5I; Wed, 02 Jun 2021 13:31:08 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4E49F3004FB;
        Wed,  2 Jun 2021 15:31:05 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 9ED912C189403; Wed,  2 Jun 2021 15:31:04 +0200 (CEST)
Message-ID: <20210602133040.461908001@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 02 Jun 2021 15:12:29 +0200
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
Subject: [PATCH 4/6] sched: Add get_current_state()
References: <20210602131225.336600299@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove yet another few p->state accesses.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 block/blk-mq.c        |    2 +-
 include/linux/sched.h |    2 ++
 kernel/freezer.c      |    2 +-
 kernel/sched/core.c   |    6 +++---
 4 files changed, 7 insertions(+), 5 deletions(-)

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3891,7 +3891,7 @@ int blk_poll(struct request_queue *q, bl
 
 	hctx->poll_considered++;
 
-	state = current->state;
+	state = get_current_state();
 	do {
 		int ret;
 
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -212,6 +212,8 @@ struct task_group;
 
 #endif
 
+#define get_current_state()	READ_ONCE(current->state)
+
 /* Task command name length: */
 #define TASK_COMM_LEN			16
 
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -58,7 +58,7 @@ bool __refrigerator(bool check_kthr_stop
 	/* Hmm, should we be allowed to suspend when there are realtime
 	   processes around? */
 	bool was_frozen = false;
-	long save = current->state;
+	unsigned int save = get_current_state();
 
 	pr_debug("%s entered refrigerator\n", current->comm);
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8273,15 +8273,15 @@ static inline int preempt_count_equals(i
 
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
+	unsigned int state = get_current_state();
 	/*
 	 * Blocking primitives will set (and therefore destroy) current->state,
 	 * since we will exit with TASK_RUNNING make sure we enter with it,
 	 * otherwise we will destroy state.
 	 */
-	WARN_ONCE(current->state != TASK_RUNNING && current->task_state_change,
+	WARN_ONCE(state != TASK_RUNNING && current->task_state_change,
 			"do not call blocking ops when !TASK_RUNNING; "
-			"state=%lx set at [<%p>] %pS\n",
-			current->state,
+			"state=%x set at [<%p>] %pS\n", state,
 			(void *)current->task_state_change,
 			(void *)current->task_state_change);
 


