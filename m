Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACE4231FD6
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgG2ODH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbgG2OCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 10:02:47 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DFDC061794;
        Wed, 29 Jul 2020 07:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=EJr1FgNTNT8+qgc4L2CwxW3ZSpTOzwZGvbKqa+w98T8=; b=hXEtrK2+KInUCZR92PdeWQKh2y
        oZyEQ+l+hT/25eX4wyLIOehe0AOiv5JF98NM7zRZcNc5RW+d4aG9HTINoXnz7gLD4w94awp6Mytiu
        hNY/rKEtBj3AWZIijsCJGl2jRFsPGsSZiXkxt2srreLcfoIQ8pKH5wBU/Ho+2q2gwVv48OAAcIYTt
        uGrJalIPaY396LAqQ7YObG+pW16IwCT/CEuxs3CNbel2GK8IEVU05EoyIbSMZhosOwN/Y1gWRkjrx
        E4LeBEOL/hrGx5uyySHM5YelR/C8a3OsUClm3M6v9mMa71lOXJsgO8amGSk2BmTtOY7dKLib1wI50
        MpUkqnIw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k0mfD-0001Dq-DA; Wed, 29 Jul 2020 14:02:35 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D096F306E0D;
        Wed, 29 Jul 2020 16:02:32 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 007642C0EDC75; Wed, 29 Jul 2020 16:02:31 +0200 (CEST)
Message-ID: <20200729140142.552991630@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Jul 2020 15:52:54 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     peterz@infradead.org, mingo@kernel.org, will@kernel.org,
        a.darwish@linutronix.de
Cc:     tglx@linutronix.de, paulmck@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, corbet@lwn.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 5/5] seqcount: More consistent seqprop names
References: <20200729135249.567415950@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attempt uniformity and brevity.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/linux/seqlock.h |   52 ++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -247,9 +247,9 @@ SEQCOUNT_LOCKTYPE(struct ww_mutex,	ww_mu
 	__seqprop_case((s),	mutex,		prop),			\
 	__seqprop_case((s),	ww_mutex,	prop))
 
-#define __to_seqcount_t(s)				__seqprop(s, ptr)
-#define __associated_lock_exists_and_is_preemptible(s)	__seqprop(s, preemptible)
-#define __assert_write_section_is_protected(s)		__seqprop(s, assert)
+#define __seqcount_ptr(s)		__seqprop(s, ptr)
+#define __seqcount_lock_preemptible(s)	__seqprop(s, preemptible)
+#define __seqcount_assert_lock_held(s)	__seqprop(s, assert)
 
 /**
  * __read_seqcount_begin() - begin a seqcount_t read section w/o barrier
@@ -266,7 +266,7 @@ SEQCOUNT_LOCKTYPE(struct ww_mutex,	ww_mu
  * Return: count to be passed to read_seqcount_retry()
  */
 #define __read_seqcount_begin(s)					\
-	__read_seqcount_t_begin(__to_seqcount_t(s))
+	__read_seqcount_t_begin(__seqcount_ptr(s))
 
 static inline unsigned __read_seqcount_t_begin(const seqcount_t *s)
 {
@@ -289,7 +289,7 @@ static inline unsigned __read_seqcount_t
  * Return: count to be passed to read_seqcount_retry()
  */
 #define raw_read_seqcount_begin(s)					\
-	raw_read_seqcount_t_begin(__to_seqcount_t(s))
+	raw_read_seqcount_t_begin(__seqcount_ptr(s))
 
 static inline unsigned raw_read_seqcount_t_begin(const seqcount_t *s)
 {
@@ -305,7 +305,7 @@ static inline unsigned raw_read_seqcount
  * Return: count to be passed to read_seqcount_retry()
  */
 #define read_seqcount_begin(s)						\
-	read_seqcount_t_begin(__to_seqcount_t(s))
+	read_seqcount_t_begin(__seqcount_ptr(s))
 
 static inline unsigned read_seqcount_t_begin(const seqcount_t *s)
 {
@@ -325,7 +325,7 @@ static inline unsigned read_seqcount_t_b
  * Return: count to be passed to read_seqcount_retry()
  */
 #define raw_read_seqcount(s)						\
-	raw_read_seqcount_t(__to_seqcount_t(s))
+	raw_read_seqcount_t(__seqcount_ptr(s))
 
 static inline unsigned raw_read_seqcount_t(const seqcount_t *s)
 {
@@ -353,7 +353,7 @@ static inline unsigned raw_read_seqcount
  * Return: count to be passed to read_seqcount_retry()
  */
 #define raw_seqcount_begin(s)						\
-	raw_seqcount_t_begin(__to_seqcount_t(s))
+	raw_seqcount_t_begin(__seqcount_ptr(s))
 
 static inline unsigned raw_seqcount_t_begin(const seqcount_t *s)
 {
@@ -380,7 +380,7 @@ static inline unsigned raw_seqcount_t_be
  * Return: true if a read section retry is required, else false
  */
 #define __read_seqcount_retry(s, start)					\
-	__read_seqcount_t_retry(__to_seqcount_t(s), start)
+	__read_seqcount_t_retry(__seqcount_ptr(s), start)
 
 static inline int __read_seqcount_t_retry(const seqcount_t *s, unsigned start)
 {
@@ -400,7 +400,7 @@ static inline int __read_seqcount_t_retr
  * Return: true if a read section retry is required, else false
  */
 #define read_seqcount_retry(s, start)					\
-	read_seqcount_t_retry(__to_seqcount_t(s), start)
+	read_seqcount_t_retry(__seqcount_ptr(s), start)
 
 static inline int read_seqcount_t_retry(const seqcount_t *s, unsigned start)
 {
@@ -414,10 +414,10 @@ static inline int read_seqcount_t_retry(
  */
 #define raw_write_seqcount_begin(s)					\
 do {									\
-	if (__associated_lock_exists_and_is_preemptible(s))		\
+	if (__seqcount_lock_preemptible(s))				\
 		preempt_disable();					\
 									\
-	raw_write_seqcount_t_begin(__to_seqcount_t(s));			\
+	raw_write_seqcount_t_begin(__seqcount_ptr(s));			\
 } while (0)
 
 static inline void raw_write_seqcount_t_begin(seqcount_t *s)
@@ -433,9 +433,9 @@ static inline void raw_write_seqcount_t_
  */
 #define raw_write_seqcount_end(s)					\
 do {									\
-	raw_write_seqcount_t_end(__to_seqcount_t(s));			\
+	raw_write_seqcount_t_end(__seqcount_ptr(s));			\
 									\
-	if (__associated_lock_exists_and_is_preemptible(s))		\
+	if (__seqcount_lock_preemptible(s))				\
 		preempt_enable();					\
 } while (0)
 
@@ -456,12 +456,12 @@ static inline void raw_write_seqcount_t_
  */
 #define write_seqcount_begin_nested(s, subclass)			\
 do {									\
-	__assert_write_section_is_protected(s);				\
+	__seqcount_assert_lock_held(s);					\
 									\
-	if (__associated_lock_exists_and_is_preemptible(s))		\
+	if (__seqcount_lock_preemptible(s))				\
 		preempt_disable();					\
 									\
-	write_seqcount_t_begin_nested(__to_seqcount_t(s), subclass);	\
+	write_seqcount_t_begin_nested(__seqcount_ptr(s), subclass);	\
 } while (0)
 
 static inline void write_seqcount_t_begin_nested(seqcount_t *s, int subclass)
@@ -483,12 +483,12 @@ static inline void write_seqcount_t_begi
  */
 #define write_seqcount_begin(s)						\
 do {									\
-	__assert_write_section_is_protected(s);				\
+	__seqcount_assert_lock_held(s);					\
 									\
-	if (__associated_lock_exists_and_is_preemptible(s))		\
+	if (__seqcount_lock_preemptible(s))				\
 		preempt_disable();					\
 									\
-	write_seqcount_t_begin(__to_seqcount_t(s));			\
+	write_seqcount_t_begin(__seqcount_ptr(s));			\
 } while (0)
 
 static inline void write_seqcount_t_begin(seqcount_t *s)
@@ -504,9 +504,9 @@ static inline void write_seqcount_t_begi
  */
 #define write_seqcount_end(s)						\
 do {									\
-	write_seqcount_t_end(__to_seqcount_t(s));			\
+	write_seqcount_t_end(__seqcount_ptr(s));			\
 									\
-	if (__associated_lock_exists_and_is_preemptible(s))		\
+	if (__seqcount_lock_preemptible(s))				\
 		preempt_enable();					\
 } while (0)
 
@@ -558,7 +558,7 @@ static inline void write_seqcount_t_end(
  *      }
  */
 #define raw_write_seqcount_barrier(s)					\
-	raw_write_seqcount_t_barrier(__to_seqcount_t(s))
+	raw_write_seqcount_t_barrier(__seqcount_ptr(s))
 
 static inline void raw_write_seqcount_t_barrier(seqcount_t *s)
 {
@@ -578,7 +578,7 @@ static inline void raw_write_seqcount_t_
  * will complete successfully and see data older than this.
  */
 #define write_seqcount_invalidate(s)					\
-	write_seqcount_t_invalidate(__to_seqcount_t(s))
+	write_seqcount_t_invalidate(__seqcount_ptr(s))
 
 static inline void write_seqcount_t_invalidate(seqcount_t *s)
 {
@@ -604,7 +604,7 @@ static inline void write_seqcount_t_inva
  * checked with read_seqcount_retry().
  */
 #define raw_read_seqcount_latch(s)					\
-	raw_read_seqcount_t_latch(__to_seqcount_t(s))
+	raw_read_seqcount_t_latch(__seqcount_ptr(s))
 
 static inline int raw_read_seqcount_t_latch(seqcount_t *s)
 {
@@ -695,7 +695,7 @@ static inline int raw_read_seqcount_t_la
  *	patterns to manage the lifetimes of the objects within.
  */
 #define raw_write_seqcount_latch(s)					\
-	raw_write_seqcount_t_latch(__to_seqcount_t(s))
+	raw_write_seqcount_t_latch(__seqcount_ptr(s))
 
 static inline void raw_write_seqcount_t_latch(seqcount_t *s)
 {


