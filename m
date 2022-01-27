Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E793B49DD7D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiA0JNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238347AbiA0JNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:13:42 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAA55C06173B;
        Thu, 27 Jan 2022 01:13:42 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id d12-20020a17090a628c00b001b4f47e2f51so6943202pjj.3;
        Thu, 27 Jan 2022 01:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ef3rampF3lcuWy5jM/TCgTjuJoijVWcBHwXWGt8ieT0=;
        b=X80mlviQv8i0F4McGJVKm+/T9HHFhN+7C+agu4OX7BHkpQ2ACSwff9g1ay8Ib91weA
         sbz9iSQYdWMBgTpjq/v4R5U3x2zQVzoQ+wJ+LMO8smuRPKKYVdrNQUMwQ8r69R3JiLNc
         1iibsawypMoKZNiCDvKhXkZH9czYEGXADl2fIYSzMJBmUsoircgHt6P6rTPdGm2CGGFZ
         GfFBYJJkw5gtrSLrQ1ITumnuRTxKKg6edE6hkE0VTmaTBDHN5NWvEwCKPOxItBhIkNTN
         ahOAOBFznZB3oTs9zzjqWzWaNSIk3JdWWmdGEptYT1nO7Iabq+mOuEWHKevaomEIK5wS
         yYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ef3rampF3lcuWy5jM/TCgTjuJoijVWcBHwXWGt8ieT0=;
        b=W8YrDj+Htn89U1vdMMlI7EujpwR5+S6QLmZf0YKnqNyI7TFfTfhaIy1lB9SB4Gvh7E
         1+sJ0a5jyGUEbAJNn8xvBPgZ10tdTXp0nTKgcmTc7dWCp1I4wgCsxaHXtIXO/kvqe08h
         TRnM6jbRfg63Lp7fDGaHcdtoLjDlMpW2blkTyP1YD1ODySOOb/d3cjWJXSHpJ034Pjie
         p5MXzSZjKeySq+dHFBOsvadhzrGMnGkyRzH3RiN0uQRWip9T6Gbjo+s1kPKw3HqSjazc
         7/reqeve5ZMZ05gCFYRLhWZQMWaYY2FUd9zTeCuHcVLHGU3fOVMoYKutFTvUTRNUsT3S
         qM0w==
X-Gm-Message-State: AOAM530tfNJciVFKs7GoxlSqeeSEz95Jj0ETmo+fHtSW8qsbf8kiBVY+
        QF9qhgZba1+npzFAfgQH7YU=
X-Google-Smtp-Source: ABdhPJzrC0Xb/WXWqYF+faO8THxgFSzVI99X8tHb4zkYn+XXCK7EKwyeV1l1Af1ebsDcuhKnBV/Vxw==
X-Received: by 2002:a17:90b:3b4c:: with SMTP id ot12mr3245749pjb.107.1643274822016;
        Thu, 27 Jan 2022 01:13:42 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:13:41 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
Subject: [PATCH v2 net-next 1/8] net: socket: intrudoce SKB_DROP_REASON_SOCKET_FILTER
Date:   Thu, 27 Jan 2022 17:13:01 +0800
Message-Id: <20220127091308.91401-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091308.91401-1-imagedong@tencent.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Introduce SKB_DROP_REASON_SOCKET_FILTER, which is used as the reason
of skb drop out of socket filter. Meanwhile, replace
SKB_DROP_REASON_TCP_FILTER with it.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 2 +-
 include/trace/events/skb.h | 2 +-
 net/ipv4/tcp_ipv4.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index bf11e1fbd69b..8a636e678902 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -318,7 +318,7 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_NO_SOCKET,
 	SKB_DROP_REASON_PKT_TOO_SMALL,
 	SKB_DROP_REASON_TCP_CSUM,
-	SKB_DROP_REASON_TCP_FILTER,
+	SKB_DROP_REASON_SOCKET_FILTER,
 	SKB_DROP_REASON_UDP_CSUM,
 	SKB_DROP_REASON_MAX,
 };
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 3e042ca2cedb..a8a64b97504d 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -14,7 +14,7 @@
 	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
 	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
 	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
-	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
+	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
 	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b3f34e366b27..938b59636578 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2095,7 +2095,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb)) {
-		drop_reason = SKB_DROP_REASON_TCP_FILTER;
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto discard_and_relse;
 	}
 	th = (const struct tcphdr *)skb->data;
-- 
2.34.1

