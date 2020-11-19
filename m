Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 132482B8D51
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbgKSIbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbgKSIbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:31:20 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B2FC0613CF;
        Thu, 19 Nov 2020 00:31:20 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u2so2540233pls.10;
        Thu, 19 Nov 2020 00:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GyqOMh6PGLNz6ecT/VtZ3NdxdKGdnWxR3GAPJmVJjQA=;
        b=cpCcXCwnU/7j26IEYdH62Nq1gAxPbyo3YThDtRvFOsxagkZh3vGfvfwjeqxFZDVrSN
         DILk/53WuMCDPngqxo5VPmej7RMwmBWPFMfjTA3F5ANlvSJBVgIfdFx4ugAfUWnXE9kY
         N8ojtW4x3FLRelonujD96UB4VD8v4dryVbbfvoWkaxW2yzYutexCyuPdl6ytaQ00zRjK
         QO5R+5ExoNTBWTlESxLuvVR6kXWwP+AlJ5fFAIcskC8f3OGqFlmHu282or8Vj3+CoMoS
         st1W4hoVkrovfIJw6Bq/d7DZ1SOrtcA2oyztIF/78SekkbvcEGtHmfc2vC4UtV05cZ2u
         wVIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GyqOMh6PGLNz6ecT/VtZ3NdxdKGdnWxR3GAPJmVJjQA=;
        b=BZ3P19ZgKX28JqscwxyMZl2lZEbrxfsaEc0QU+CULaWfVwimcWpy/5vaS60a6+Smza
         fLHYK1sVHYn5OWMJezrRMiCKTBU96D1Y46nUJeKCHQHI9HOPyIBzqHp5XsFj8w6+wLY6
         MbO5Q9d2JzrmS2oR1suhqqRJoWxZdoZIDTen3IOyYtulnYrUYMvYPD7dey2mFKfdM3YH
         5kPebj3d3LmYc0v2J9X9L9Cj41VH6dRZyFEi4wNkWMxJr0DlmGZWKvqBZcVCAUY4/0Gu
         Cy5fAjsCDichhS7Y1LxpE+vGnS/wEUnA7+RkmHqOp8ybxPE2h9sxsqNcoOpRivYNj2n3
         /L2Q==
X-Gm-Message-State: AOAM531fbDVhsbXdY41DFlDXWNwmQ8H76rQpkjPWa/ygERzMsCw6E4QL
        cn2EVlCue06dfZPShYB1sB3RvfLHDPnsu0OI
X-Google-Smtp-Source: ABdhPJzPCjIhVAtBagdTyp0CRSxQ6aeGtjNPmBUWynjJAWqp1Fr8ZxYYTz0XpG0pnYe3d/9/Zk97PQ==
X-Received: by 2002:a17:902:7283:b029:d7:e4f5:adc7 with SMTP id d3-20020a1709027283b02900d7e4f5adc7mr8340352pll.20.1605774679056;
        Thu, 19 Nov 2020 00:31:19 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id r2sm5517713pji.55.2020.11.19.00.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 00:31:18 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v3 05/10] xsk: add busy-poll support for {recv,send}msg()
Date:   Thu, 19 Nov 2020 09:30:19 +0100
Message-Id: <20201119083024.119566-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201119083024.119566-1-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Wire-up XDP socket busy-poll support for recvmsg() and sendmsg(). If
the XDP socket prefers busy-polling, make sure that no wakeup/IPI is
performed.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index bf0f5c34af6c..ecc4579e41ee 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <net/xdp_sock_drv.h>
+#include <net/busy_poll.h>
 #include <net/xdp.h>
 
 #include "xsk_queue.h"
@@ -517,6 +518,17 @@ static int __xsk_sendmsg(struct sock *sk)
 	return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
 }
 
+static bool xsk_no_wakeup(struct sock *sk)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	/* Prefer busy-polling, skip the wakeup. */
+	return READ_ONCE(sk->sk_prefer_busy_poll) && READ_ONCE(sk->sk_ll_usec) &&
+		READ_ONCE(sk->sk_napi_id) >= MIN_NAPI_ID;
+#else
+	return false;
+#endif
+}
+
 static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
@@ -529,6 +541,12 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
+	if (sk_can_busy_loop(sk))
+		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+
+	if (xsk_no_wakeup(sk))
+		return 0;
+
 	pool = xs->pool;
 	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
 		return __xsk_sendmsg(sk);
@@ -550,6 +568,12 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
+	if (sk_can_busy_loop(sk))
+		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+
+	if (xsk_no_wakeup(sk))
+		return 0;
+
 	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
 		return xsk_wakeup(xs, XDP_WAKEUP_RX);
 	return 0;
-- 
2.27.0

