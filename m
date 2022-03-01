Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8004C93CF
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 20:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237233AbiCATCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 14:02:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiCATCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 14:02:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45B54D9C6;
        Tue,  1 Mar 2022 11:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/tBazeosVX7n1CPUUwf6PzIu6vjJVnHyHOkfjsv2zKo=; b=G2U9nPc+cKcx95Z9ga5OZXchNz
        blxZ0iNm1M+uKQvG5JCjwfBWD2Vqk/JNrOrkTtzRMLvR552E7A4wIdnYTrEx28aAxcIhZIBDk2OhJ
        2mC2hcK77WGdKfwnLWC9xIRW2naQmlD6pg6blozExF50oYyrluLyuDKCR05dvj4lJCUJucJUHaufH
        36UHt4On3fRFJ0YJCkBdWklX7NM/KDi/YeSecU8YxtgD7/WN7ClqH8GnFhU3JjJVUQnhYo8rNzSqS
        E0UBK85SGI9bRQfxw/IXmOle17eRFr0eUMCl1eNz3aBOX0q+MyaB3hvtdfAdZV9rP6eZ0vdNCYptA
        LfRWRgDg==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nP7kD-009r7Z-Q4; Tue, 01 Mar 2022 19:01:09 +0000
Date:   Tue, 1 Mar 2022 19:01:09 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Message-ID: <Yh5tdcNNHw/z7VRZ@casper.infradead.org>
References: <20220228110822.491923-3-jakobkoschel@gmail.com>
 <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <CAHk-=wj8fkosQ7=bps5K+DDazBXk=ypfn49A0sEq+7-nZnyfXA@mail.gmail.com>
 <CAHk-=wiTCvLQkHcJ3y0hpqH7FEk9D28LDvZZogC6OVLk7naBww@mail.gmail.com>
 <Yh0tl3Lni4weIMkl@casper.infradead.org>
 <CAHk-=wgBfJ1-cPA2LTvFyyy8owpfmtCuyiZi4+um8DhFNe+CyA@mail.gmail.com>
 <Yh1aMm3hFe/j9ZbI@casper.infradead.org>
 <CAHk-=wi0gSUMBr2SVF01Gy1xC1w1iGtJT5ztju9BPWYKjdh+NA@mail.gmail.com>
 <202203011008.AA0B5A2D@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202203011008.AA0B5A2D@keescook>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 10:14:07AM -0800, Kees Cook wrote:
> On Mon, Feb 28, 2022 at 04:45:11PM -0800, Linus Torvalds wrote:
> > Really. The "-Wshadow doesn't work on the kernel" is not some new
> > issue, because you have to do completely insane things to the source
> > code to enable it.
> 
> The first big glitch with -Wshadow was with shadowed global variables.
> GCC 4.8 fixed that, but it still yells about shadowed functions. What
> _almost_ works is -Wshadow=local. At first glace, all the warnings
> look solvable, but then one will eventually discover __wait_event()
> and associated macros that mix when and how deeply it intentionally
> shadows variables. :)

Well, that's just disgusting.  Macros fundamentally shouldn't be
referring to things that aren't in their arguments.  The first step to
cleaning this up is ...

I'll take a look at the rest of cleaning this up soon.

From 28ffe35d56223d4242b915832299e5acc926737e Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Tue, 1 Mar 2022 13:47:07 -0500
Subject: [PATCH] wait: Parameterize the return variable to ___wait_event()

Macros should not refer to variables which aren't in their arguments.
Pass the name from its callers.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/swait.h    | 12 ++++++------
 include/linux/wait.h     | 32 ++++++++++++++++----------------
 include/linux/wait_bit.h |  4 ++--
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/swait.h b/include/linux/swait.h
index 6a8c22b8c2a5..5e8e9b13be2d 100644
--- a/include/linux/swait.h
+++ b/include/linux/swait.h
@@ -191,14 +191,14 @@ do {									\
 } while (0)
 
 #define __swait_event_timeout(wq, condition, timeout)			\
-	___swait_event(wq, ___wait_cond_timeout(condition),		\
+	___swait_event(wq, ___wait_cond_timeout(condition, __ret),	\
 		      TASK_UNINTERRUPTIBLE, timeout,			\
 		      __ret = schedule_timeout(__ret))
 
 #define swait_event_timeout_exclusive(wq, condition, timeout)		\
 ({									\
 	long __ret = timeout;						\
-	if (!___wait_cond_timeout(condition))				\
+	if (!___wait_cond_timeout(condition, __ret))			\
 		__ret = __swait_event_timeout(wq, condition, timeout);	\
 	__ret;								\
 })
@@ -216,14 +216,14 @@ do {									\
 })
 
 #define __swait_event_interruptible_timeout(wq, condition, timeout)	\
-	___swait_event(wq, ___wait_cond_timeout(condition),		\
+	___swait_event(wq, ___wait_cond_timeout(condition, __ret),	\
 		      TASK_INTERRUPTIBLE, timeout,			\
 		      __ret = schedule_timeout(__ret))
 
 #define swait_event_interruptible_timeout_exclusive(wq, condition, timeout)\
 ({									\
 	long __ret = timeout;						\
-	if (!___wait_cond_timeout(condition))				\
+	if (!___wait_cond_timeout(condition, __ret))			\
 		__ret = __swait_event_interruptible_timeout(wq,		\
 						condition, timeout);	\
 	__ret;								\
@@ -252,7 +252,7 @@ do {									\
 } while (0)
 
 #define __swait_event_idle_timeout(wq, condition, timeout)		\
-	___swait_event(wq, ___wait_cond_timeout(condition),		\
+	___swait_event(wq, ___wait_cond_timeout(condition, __ret),	\
 		       TASK_IDLE, timeout,				\
 		       __ret = schedule_timeout(__ret))
 
@@ -278,7 +278,7 @@ do {									\
 #define swait_event_idle_timeout_exclusive(wq, condition, timeout)	\
 ({									\
 	long __ret = timeout;						\
-	if (!___wait_cond_timeout(condition))				\
+	if (!___wait_cond_timeout(condition, __ret))			\
 		__ret = __swait_event_idle_timeout(wq,			\
 						   condition, timeout);	\
 	__ret;								\
diff --git a/include/linux/wait.h b/include/linux/wait.h
index 851e07da2583..890cce3c0f2e 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -271,7 +271,7 @@ static inline void wake_up_pollfree(struct wait_queue_head *wq_head)
 		__wake_up_pollfree(wq_head);
 }
 
-#define ___wait_cond_timeout(condition)						\
+#define ___wait_cond_timeout(condition, __ret)					\
 ({										\
 	bool __cond = (condition);						\
 	if (__cond && !__ret)							\
@@ -386,7 +386,7 @@ do {										\
 })
 
 #define __wait_event_timeout(wq_head, condition, timeout)			\
-	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
+	___wait_event(wq_head, ___wait_cond_timeout(condition, __ret),		\
 		      TASK_UNINTERRUPTIBLE, 0, timeout,				\
 		      __ret = schedule_timeout(__ret))
 
@@ -413,13 +413,13 @@ do {										\
 ({										\
 	long __ret = timeout;							\
 	might_sleep();								\
-	if (!___wait_cond_timeout(condition))					\
+	if (!___wait_cond_timeout(condition, __ret))				\
 		__ret = __wait_event_timeout(wq_head, condition, timeout);	\
 	__ret;									\
 })
 
 #define __wait_event_freezable_timeout(wq_head, condition, timeout)		\
-	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
+	___wait_event(wq_head, ___wait_cond_timeout(condition, __ret),		\
 		      TASK_INTERRUPTIBLE, 0, timeout,				\
 		      __ret = freezable_schedule_timeout(__ret))
 
@@ -431,7 +431,7 @@ do {										\
 ({										\
 	long __ret = timeout;							\
 	might_sleep();								\
-	if (!___wait_cond_timeout(condition))					\
+	if (!___wait_cond_timeout(condition, __ret))				\
 		__ret = __wait_event_freezable_timeout(wq_head, condition, timeout); \
 	__ret;									\
 })
@@ -503,7 +503,7 @@ do {										\
 })
 
 #define __wait_event_interruptible_timeout(wq_head, condition, timeout)		\
-	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
+	___wait_event(wq_head, ___wait_cond_timeout(condition, __ret),		\
 		      TASK_INTERRUPTIBLE, 0, timeout,				\
 		      __ret = schedule_timeout(__ret))
 
@@ -531,7 +531,7 @@ do {										\
 ({										\
 	long __ret = timeout;							\
 	might_sleep();								\
-	if (!___wait_cond_timeout(condition))					\
+	if (!___wait_cond_timeout(condition, __ret))				\
 		__ret = __wait_event_interruptible_timeout(wq_head,		\
 						condition, timeout);		\
 	__ret;									\
@@ -698,7 +698,7 @@ do {										\
 } while (0)
 
 #define __wait_event_idle_timeout(wq_head, condition, timeout)			\
-	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
+	___wait_event(wq_head, ___wait_cond_timeout(condition, __ret),		\
 		      TASK_IDLE, 0, timeout,					\
 		      __ret = schedule_timeout(__ret))
 
@@ -725,13 +725,13 @@ do {										\
 ({										\
 	long __ret = timeout;							\
 	might_sleep();								\
-	if (!___wait_cond_timeout(condition))					\
+	if (!___wait_cond_timeout(condition, __ret))				\
 		__ret = __wait_event_idle_timeout(wq_head, condition, timeout);	\
 	__ret;									\
 })
 
 #define __wait_event_idle_exclusive_timeout(wq_head, condition, timeout)	\
-	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
+	___wait_event(wq_head, ___wait_cond_timeout(condition, __ret),		\
 		      TASK_IDLE, 1, timeout,					\
 		      __ret = schedule_timeout(__ret))
 
@@ -762,7 +762,7 @@ do {										\
 ({										\
 	long __ret = timeout;							\
 	might_sleep();								\
-	if (!___wait_cond_timeout(condition))					\
+	if (!___wait_cond_timeout(condition, __ret))				\
 		__ret = __wait_event_idle_exclusive_timeout(wq_head, condition, timeout);\
 	__ret;									\
 })
@@ -932,7 +932,7 @@ extern int do_wait_intr_irq(wait_queue_head_t *, wait_queue_entry_t *);
 })
 
 #define __wait_event_killable_timeout(wq_head, condition, timeout)		\
-	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
+	___wait_event(wq_head, ___wait_cond_timeout(condition, __ret),		\
 		      TASK_KILLABLE, 0, timeout,				\
 		      __ret = schedule_timeout(__ret))
 
@@ -962,7 +962,7 @@ extern int do_wait_intr_irq(wait_queue_head_t *, wait_queue_entry_t *);
 ({										\
 	long __ret = timeout;							\
 	might_sleep();								\
-	if (!___wait_cond_timeout(condition))					\
+	if (!___wait_cond_timeout(condition, __ret))				\
 		__ret = __wait_event_killable_timeout(wq_head,			\
 						condition, timeout);		\
 	__ret;									\
@@ -1107,7 +1107,7 @@ do {										\
 })
 
 #define __wait_event_lock_irq_timeout(wq_head, condition, lock, timeout, state)	\
-	___wait_event(wq_head, ___wait_cond_timeout(condition),			\
+	___wait_event(wq_head, ___wait_cond_timeout(condition, __ret),		\
 		      state, 0, timeout,					\
 		      spin_unlock_irq(&lock);					\
 		      __ret = schedule_timeout(__ret);				\
@@ -1141,7 +1141,7 @@ do {										\
 						  timeout)			\
 ({										\
 	long __ret = timeout;							\
-	if (!___wait_cond_timeout(condition))					\
+	if (!___wait_cond_timeout(condition, __ret))				\
 		__ret = __wait_event_lock_irq_timeout(				\
 					wq_head, condition, lock, timeout,	\
 					TASK_INTERRUPTIBLE);			\
@@ -1151,7 +1151,7 @@ do {										\
 #define wait_event_lock_irq_timeout(wq_head, condition, lock, timeout)		\
 ({										\
 	long __ret = timeout;							\
-	if (!___wait_cond_timeout(condition))					\
+	if (!___wait_cond_timeout(condition, __ret))				\
 		__ret = __wait_event_lock_irq_timeout(				\
 					wq_head, condition, lock, timeout,	\
 					TASK_UNINTERRUPTIBLE);			\
diff --git a/include/linux/wait_bit.h b/include/linux/wait_bit.h
index 7dec36aecbd9..227e6a20a978 100644
--- a/include/linux/wait_bit.h
+++ b/include/linux/wait_bit.h
@@ -292,7 +292,7 @@ do {									\
 })
 
 #define __wait_var_event_timeout(var, condition, timeout)		\
-	___wait_var_event(var, ___wait_cond_timeout(condition),		\
+	___wait_var_event(var, ___wait_cond_timeout(condition, __ret),	\
 			  TASK_UNINTERRUPTIBLE, 0, timeout,		\
 			  __ret = schedule_timeout(__ret))
 
@@ -300,7 +300,7 @@ do {									\
 ({									\
 	long __ret = timeout;						\
 	might_sleep();							\
-	if (!___wait_cond_timeout(condition))				\
+	if (!___wait_cond_timeout(condition, __ret))			\
 		__ret = __wait_var_event_timeout(var, condition, timeout); \
 	__ret;								\
 })
-- 
2.34.1

