Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE6B52C8D51
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgK3Sxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbgK3Sxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:53:36 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B956C0613D6;
        Mon, 30 Nov 2020 10:52:56 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id hk16so135676pjb.4;
        Mon, 30 Nov 2020 10:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YxY+jVb6DuD2Q2vdVgYXmx6Ypq4tBvL2ZuLpqRZo/Yk=;
        b=UZBDYAGf3Lr9iCEeIKHLoE7/AMHhgOXcVw/smAqPm+CNZmuU+YHI9psuTprGgbzUik
         3sVTevmgThkK8tRegzvVjw190dShXZM8I9IGsidACic/AMo4HjhZtL5/pvIx7VCKErNY
         Lsn2m7dkqoHVrt5Lfm3p82IG3K8Gcrj3fHUTaQc+X6m6p96Vsj1H4rinEljdWsAWv5H/
         VzpN8YJXg/xBkTl+vJBk+cIXjAf9kjCStJBgzte4G1Z1e1ZwARjVurIZtLzlxtVMGnqX
         spjGEamQ7vYBZ/4FrIZTACjotU/zjDlnVusIF6455CjoRc0lPM2MlfJpGUwd8iwH8sXr
         pn8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YxY+jVb6DuD2Q2vdVgYXmx6Ypq4tBvL2ZuLpqRZo/Yk=;
        b=W4tDKPP+QvubWlrU1BkTs/TyKf7gRrnFpXEg9cSlvicMES182xm5iDUbVtaCK0LryR
         vnVdd7fBPuJF55kHHnT12XM0ikEWXHLmpdDxVcM5X2yTtbLD6oQXr1eMRSh2xIn0Lc6w
         zI3g2rsM5TpGWrE3CisWEMWfLnZ0vNbpCc93iuk5MjQKtMNeGwr2qeFo9uGc0zK5V4BS
         kzlcgJjjCif6gh9y178YdL12CsGKL3/8kGRFcqKSF4pKV7mEhPTnkl4+OE964bRghemi
         guuxDG8Ux5nUxdkC+Yya9M3xNEVXrvrWjUTh2/w4UywNCa9uc1kK14aJVneR+CIpbIXA
         2E0Q==
X-Gm-Message-State: AOAM531NBO84NGV4B89vYwvyc/co2bFKVqenlKpkrkoFX0ylykznazlq
        FioX613fRnNrAREGYM2fPSU/oT+F8m4O5dU3
X-Google-Smtp-Source: ABdhPJwoRGJmxX0D2k4SdQnRrskU5crp5uOhAIMO0ZHJqAczz4BuY8kV0UGFxISi+IVFXwr/txldTg==
X-Received: by 2002:a17:902:59dc:b029:da:84c7:f175 with SMTP id d28-20020a17090259dcb02900da84c7f175mr3577991plj.75.1606762375387;
        Mon, 30 Nov 2020 10:52:55 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id i3sm12005978pgq.12.2020.11.30.10.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:52:54 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v4 04/10] xsk: check need wakeup flag in sendmsg()
Date:   Mon, 30 Nov 2020 19:51:59 +0100
Message-Id: <20201130185205.196029-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201130185205.196029-1-bjorn.topel@gmail.com>
References: <20201130185205.196029-1-bjorn.topel@gmail.com>
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

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c           |  6 +++++-
 net/xdp/xsk_buff_pool.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 1d1e0cd51a95..c72b4dba2878 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -522,13 +522,17 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
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
index 8a3bf4e1318e..96bb607853ad 100644
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

