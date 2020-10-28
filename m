Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7A629D9B0
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389943AbgJ1XAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387732AbgJ1XAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:00:17 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A59FC0613CF;
        Wed, 28 Oct 2020 16:00:17 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id w25so475554vsk.9;
        Wed, 28 Oct 2020 16:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctARgd5IeefW/xDEFZzb1NY2kFiOmkaVN6jb4VQWnGY=;
        b=PLrzjJzwRFNojRi8jy55qv7BTPweCnOMSMk+Ol7VV2YvxManvupJmNNvMgGaujesOZ
         HRKRAOl+mxj3YnZ1ORrIZ/62yhyrBDRiCG2LY7JDf8SihsNrdcO7MEyYbLjD6QRO7AQq
         KziySVPDyskFCbXY+X7qwOPqVg3ynAcZ0BVimmg8nNPHdhsLd43olWNA3v6ck4SAoi+z
         DLby4KSb1LwgcE0o4KQ0uoRMVr6HYDGGlnwu9aCOB+kbpDf+dvw1bhCJ9lwoMmI6cvEf
         JTCF7m0Myf6inaqlKyjLHDjIB0Yg6MHpB4KzY5NcXF+++ScoO9twHW+C9WziI5d9mSse
         60Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctARgd5IeefW/xDEFZzb1NY2kFiOmkaVN6jb4VQWnGY=;
        b=a+VvTThXg2ZUmRRwZhcRin6rCwPINlVHxVJYjWl3P0YxF2FSXSYNYYXRPXZ33clMlh
         q5xW+irohfhXrf3IcX0x7lQu2hlnOP7p8De8CZSVU/UefkF/JHzLTXmfbzrGOqid1CTY
         /38+QRBggND2vm1NM2gSlP4KQAgYm94XzE4/xAvBPl7lmAnLH6j277TZuz6zqYWHH6xv
         K+iD5ONxsVf13tzMf+P+fI8T2CpPxzcf46uUaMLNdLk0Nkzedm4llgbE6xxvrZJw6ZPh
         GoBijnlv9ezQzEVoO81eKvLmPG9eHHyvYEnuLXNiuI26pNlx7Z9CvZCdrWc12DBQO109
         7Ixg==
X-Gm-Message-State: AOAM530dBSVHcEtFOIwOMfuR0nj52mvo+xSYV4T8vxHw9uvvJGh8sBaC
        foVhFaTsfn2o6VLCRkBq1hhqHi+I/e7tr+i/
X-Google-Smtp-Source: ABdhPJy4JsZnLSuXFGGfGf5z9wYwEIBbyRNvXY0p7TXn6SDylWXjbgKrQDAWfIugPhofnBPsR2d//A==
X-Received: by 2002:a62:7a8f:0:b029:163:d0b3:ac18 with SMTP id v137-20020a627a8f0000b0290163d0b3ac18mr7777212pfc.9.1603892115932;
        Wed, 28 Oct 2020 06:35:15 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q14sm5935393pjp.43.2020.10.28.06.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:35:15 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 2/9] net: add SO_BUSY_POLL_BUDGET socket option
Date:   Wed, 28 Oct 2020 14:34:30 +0100
Message-Id: <20201028133437.212503-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

This option lets a user set a per socket NAPI budget for
busy-polling. If the options is not set, it will use the default of 8.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 arch/alpha/include/uapi/asm/socket.h  |  1 +
 arch/mips/include/uapi/asm/socket.h   |  1 +
 arch/parisc/include/uapi/asm/socket.h |  1 +
 arch/sparc/include/uapi/asm/socket.h  |  1 +
 fs/eventpoll.c                        |  3 ++-
 include/net/busy_poll.h               |  6 ++++--
 include/net/sock.h                    |  1 +
 include/uapi/asm-generic/socket.h     |  1 +
 net/core/dev.c                        | 20 +++++++++-----------
 net/core/sock.c                       | 10 ++++++++++
 10 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/socket.h b/arch/alpha/include/uapi/asm/socket.h
index 0f776668fb09..4ea972b7b711 100644
--- a/arch/alpha/include/uapi/asm/socket.h
+++ b/arch/alpha/include/uapi/asm/socket.h
@@ -125,6 +125,7 @@
 #define SO_DETACH_REUSEPORT_BPF 68
 
 #define SO_BIAS_BUSY_POLL	69
+#define SO_BUSY_POLL_BUDGET	70
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/mips/include/uapi/asm/socket.h b/arch/mips/include/uapi/asm/socket.h
index d23984731504..13eaffbfbe50 100644
--- a/arch/mips/include/uapi/asm/socket.h
+++ b/arch/mips/include/uapi/asm/socket.h
@@ -136,6 +136,7 @@
 #define SO_DETACH_REUSEPORT_BPF 68
 
 #define SO_BIAS_BUSY_POLL	69
+#define SO_BUSY_POLL_BUDGET	70
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/parisc/include/uapi/asm/socket.h b/arch/parisc/include/uapi/asm/socket.h
index 49469713ed2a..036e42dac6b3 100644
--- a/arch/parisc/include/uapi/asm/socket.h
+++ b/arch/parisc/include/uapi/asm/socket.h
@@ -117,6 +117,7 @@
 #define SO_DETACH_REUSEPORT_BPF 0x4042
 
 #define SO_BIAS_BUSY_POLL	0x4043
+#define SO_BUSY_POLL_BUDGET	0x4044
 
 #if !defined(__KERNEL__)
 
diff --git a/arch/sparc/include/uapi/asm/socket.h b/arch/sparc/include/uapi/asm/socket.h
index 009aba6f7a54..bc482dc93bd4 100644
--- a/arch/sparc/include/uapi/asm/socket.h
+++ b/arch/sparc/include/uapi/asm/socket.h
@@ -118,6 +118,7 @@
 #define SO_DETACH_REUSEPORT_BPF  0x0047
 
 #define SO_BIAS_BUSY_POLL	 0x0048
+#define SO_BUSY_POLL_BUDGET	 0x0049
 
 #if !defined(__KERNEL__)
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 4df61129566d..fa00a0640264 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -397,7 +397,8 @@ static void ep_busy_loop(struct eventpoll *ep, int nonblock)
 	unsigned int napi_id = READ_ONCE(ep->napi_id);
 
 	if ((napi_id >= MIN_NAPI_ID) && net_busy_loop_on())
-		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep);
+		napi_busy_loop(napi_id, nonblock ? NULL : ep_busy_loop_end, ep,
+			       BUSY_POLL_BUDGET);
 }
 
 static inline void ep_reset_busy_poll_napi_id(struct eventpoll *ep)
diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 9738923ed17b..c6c413d3824d 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -25,6 +25,7 @@
 
 /* Biased busy-poll watchdog timeout in ms */
 #define BIASED_BUSY_POLL_TIMEOUT 200
+#define BUSY_POLL_BUDGET 8
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 
@@ -46,7 +47,7 @@ bool sk_busy_loop_end(void *p, unsigned long start_time);
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg);
+		    void *loop_end_arg, u16 budget);
 
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
@@ -119,7 +120,8 @@ static inline void sk_busy_loop(struct sock *sk, int nonblock)
 
 	if (napi_id >= MIN_NAPI_ID) {
 		__sk_bias_busy_poll(sk, napi_id);
-		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk);
+		napi_busy_loop(napi_id, nonblock ? NULL : sk_busy_loop_end, sk,
+			       sk->sk_busy_poll_budget ?: BUSY_POLL_BUDGET);
 	}
 #endif
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index cf71834fb601..3caf53b6bd71 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -481,6 +481,7 @@ struct sock {
 	kuid_t			sk_uid;
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	u8			sk_bias_busy_poll;
+	u16			sk_busy_poll_budget;
 #endif
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
diff --git a/include/uapi/asm-generic/socket.h b/include/uapi/asm-generic/socket.h
index 8a2b37ccd9d5..9dc1f35fe77f 100644
--- a/include/uapi/asm-generic/socket.h
+++ b/include/uapi/asm-generic/socket.h
@@ -120,6 +120,7 @@
 #define SO_DETACH_REUSEPORT_BPF 68
 
 #define SO_BIAS_BUSY_POLL	69
+#define SO_BUSY_POLL_BUDGET	70
 
 #if !defined(__KERNEL__)
 
diff --git a/net/core/dev.c b/net/core/dev.c
index a29e4c4a35f6..b34520acaa7f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6496,9 +6496,7 @@ static struct napi_struct *napi_by_id(unsigned int napi_id)
 
 #if defined(CONFIG_NET_RX_BUSY_POLL)
 
-#define BUSY_POLL_BUDGET 8
-
-static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
+static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock, u16 budget)
 {
 	int rc;
 
@@ -6530,14 +6528,14 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 	/* All we really want here is to re-enable device interrupts.
 	 * Ideally, a new ndo_busy_poll_stop() could avoid another round.
 	 */
-	rc = napi->poll(napi, BUSY_POLL_BUDGET);
+	rc = napi->poll(napi, budget);
 	/* We can't gro_normal_list() here, because napi->poll() might have
 	 * rearmed the napi (napi_complete_done()) in which case it could
 	 * already be running on another CPU.
 	 */
-	trace_napi_poll(napi, rc, BUSY_POLL_BUDGET);
+	trace_napi_poll(napi, rc, budget);
 	netpoll_poll_unlock(have_poll_lock);
-	if (rc == BUSY_POLL_BUDGET) {
+	if (rc == budget) {
 		/* As the whole budget was spent, we still own the napi so can
 		 * safely handle the rx_list.
 		 */
@@ -6549,7 +6547,7 @@ static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock)
 
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
-		    void *loop_end_arg)
+		    void *loop_end_arg, u16 budget)
 {
 	unsigned long start_time = loop_end ? busy_loop_current_time() : 0;
 	int (*napi_poll)(struct napi_struct *napi, int budget);
@@ -6591,8 +6589,8 @@ void napi_busy_loop(unsigned int napi_id,
 					      HRTIMER_MODE_REL_PINNED);
 			}
 		}
-		work = napi_poll(napi, BUSY_POLL_BUDGET);
-		trace_napi_poll(napi, work, BUSY_POLL_BUDGET);
+		work = napi_poll(napi, budget);
+		trace_napi_poll(napi, work, budget);
 		gro_normal_list(napi);
 count:
 		if (work > 0)
@@ -6605,7 +6603,7 @@ void napi_busy_loop(unsigned int napi_id,
 
 		if (unlikely(need_resched())) {
 			if (napi_poll)
-				busy_poll_stop(napi, have_poll_lock);
+				busy_poll_stop(napi, have_poll_lock, budget);
 			preempt_enable();
 			rcu_read_unlock();
 			cond_resched();
@@ -6616,7 +6614,7 @@ void napi_busy_loop(unsigned int napi_id,
 		cpu_relax();
 	}
 	if (napi_poll)
-		busy_poll_stop(napi, have_poll_lock);
+		busy_poll_stop(napi, have_poll_lock, budget);
 	preempt_enable();
 out:
 	rcu_read_unlock();
diff --git a/net/core/sock.c b/net/core/sock.c
index 686eb5549b79..799125de4add 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1165,6 +1165,16 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		else
 			sk->sk_bias_busy_poll = valbool;
 		break;
+	case SO_BUSY_POLL_BUDGET:
+		if ((val > sk->sk_busy_poll_budget) && !capable(CAP_NET_ADMIN))
+			ret = -EPERM;
+		else {
+			if (val < 0)
+				ret = -EINVAL;
+			else
+				sk->sk_busy_poll_budget = val;
+		}
+		break;
 #endif
 
 	case SO_MAX_PACING_RATE:
-- 
2.27.0

