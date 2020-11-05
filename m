Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578842A7BC1
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 11:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729794AbgKEK27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 05:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgKEK26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 05:28:58 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE32C0613CF;
        Thu,  5 Nov 2020 02:28:58 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id c20so1132277pfr.8;
        Thu, 05 Nov 2020 02:28:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q3bRujA0ZEsvdVE3nlPl8w/UbQx3Egjm7KQDsrceDhQ=;
        b=uI17Aq7jATgc2MGuD1Oo73V558Bkwp+JfWCmHbgyU3TEDBQ4BKH4Hj/sQAXo+/dlSq
         o7SXAV1SV0agKvlurxbNACO6f62k+ygulDSZgFx2MU8TEfobQaplu/P8pUVEt8CxhB+x
         tflkJjdo6LYXHaPyFMavj9OSdcl/zSrhqMXjgC0wnSTdsy//rLNBy8fHAUKewa7h2bzN
         XDtFkmqtFwG/kZWkgl1IJhxUVrr5guSWbsrVE2j7fZUg90XjvCMtIAjJnI4lPMHOGKvk
         C6qz++KT/mIQwfIevAgL7oS4NO0j6WC84B/4bJGnh6ZQBSLWPeXqJUnDYfBLBa2MDJEE
         uriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q3bRujA0ZEsvdVE3nlPl8w/UbQx3Egjm7KQDsrceDhQ=;
        b=Il0wGSyuOFhTD9KPGkWDo+08oTVoKnU31+31nY8GcICmWHmxfUelUzfUvDKd+lwPre
         1lXbdSV+W3xE3jwa3rW0iTg3PRoArMkOD2uUkEPlssqvHhOzlaiaSZFCrRt19ZKCexMq
         qXXZZm/HFtgoXkFYDS1fQJwr9DfoZaHHaJD5lfM7qG8ksTFovPPrxsoaqJOWhKkpN72A
         oK3L5BQkkskvaAoFiCzzz4U+Otq1sZUCnLjF5phs0Z8x6/2dO6U8biFuE6CzLMGTcspS
         e2tStCPPOUPB913Fu3wPeej4p+27w8tEkZ3LZ5eZGfEgsnPXE3dX9ISTqpxJsB8RrV/a
         biWw==
X-Gm-Message-State: AOAM5327ivGPyJjV/29PU7Hf5mXSnslB58GiX3HFWu3hpWUVxMwe4qjs
        49zHxcD8b2hDrA5vd6peGJUEhOwfzwrHjOj6
X-Google-Smtp-Source: ABdhPJyS7IkdyRraXLHIRhrweqgSk9iYK4Py7bZeMndru8veJTHua7VNfUMxtyK9ZTLLB+RIcesPxA==
X-Received: by 2002:a17:90b:ec9:: with SMTP id gz9mr1784134pjb.105.1604572137531;
        Thu, 05 Nov 2020 02:28:57 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id 192sm2050117pfz.200.2020.11.05.02.28.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 02:28:56 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next v2 4/9] xsk: check need wakeup flag in sendmsg()
Date:   Thu,  5 Nov 2020 11:28:07 +0100
Message-Id: <20201105102812.152836-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201105102812.152836-1-bjorn.topel@gmail.com>
References: <20201105102812.152836-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Add a check for need wake up in sendmsg(), so that if a user calls
sendmsg() when no wakeup is needed, do not trigger a wakeup.

To simplify the need wakeup check in the syscall, unconditionally
enable the need wakeup flag for Tx. This has a side-effect for poll();
If poll() is called for a socket without enabled need wakeup, a Tx
wakeup is unconditionally performed.

The wakeup matrix for AF_XDP now looks like:

need wakeup | poll()       | sendmsg()   | recvmsg()
------------+--------------+-------------+------------
disabled    | wake Tx      | wake Tx     | nop
enabled     | check flag;  | check flag; | check flag;
            |   wake Tx/Rx |   wake Tx   |   wake Rx

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c           |  6 +++++-
 net/xdp/xsk_buff_pool.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 17d51d1a5752..2e5b9f27c7a3 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -465,13 +465,17 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
+	struct xsk_buff_pool *pool;
 
 	if (unlikely(!xsk_is_bound(xs)))
 		return -ENXIO;
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
-	return __xsk_sendmsg(sk);
+	pool = xs->pool;
+	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
+		return __xsk_sendmsg(sk);
+	return 0;
 }
 
 static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 64c9e55d4d4e..a4acb5e9576f 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -144,14 +144,13 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err)
 		return err;
 
-	if (flags & XDP_USE_NEED_WAKEUP) {
+	if (flags & XDP_USE_NEED_WAKEUP)
 		pool->uses_need_wakeup = true;
-		/* Tx needs to be explicitly woken up the first time.
-		 * Also for supporting drivers that do not implement this
-		 * feature. They will always have to call sendto().
-		 */
-		pool->cached_need_wakeup = XDP_WAKEUP_TX;
-	}
+	/* Tx needs to be explicitly woken up the first time.  Also
+	 * for supporting drivers that do not implement this
+	 * feature. They will always have to call sendto() or poll().
+	 */
+	pool->cached_need_wakeup = XDP_WAKEUP_TX;
 
 	dev_hold(netdev);
 
-- 
2.27.0

