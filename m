Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE8749F470
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 08:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346879AbiA1He1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 02:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346875AbiA1He0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 02:34:26 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9451AC061714;
        Thu, 27 Jan 2022 23:34:26 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id o64so5739971pjo.2;
        Thu, 27 Jan 2022 23:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SyLy03L5E+1xwc8EXhn4C+jar44ebU6XLc4ynxHGN9A=;
        b=hs0ZieHX3P+Ur5/kTsSmPWc89YJS76x2Xe8NYGWDN42s3r3hatnAXzyhC6OlelmxKm
         +Zze13DIudgceBjft27kPy1d7D7FkojbV+bqxR/QFDA97JNquJGy6XxjcfJZX6kZKcpf
         WiH4JG19XI6xi276Op0qAlFst8dFTVa5oGEF1Pt6ccAsNu+OPODcCE8bcrCQ1y97unji
         mh7C3BQUvVsW7WYzuqu/jzJK8YjhJtUcCHpvCbM8gLXaVxY/vgKDH4KIs1LCqi6Nao2t
         S57+xncbg2MVKUAyrHXYilaFuRUmlXXzIIYF/WIe4UaibIf1ZJQAzb/k2fn7SzQlmMkQ
         lUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SyLy03L5E+1xwc8EXhn4C+jar44ebU6XLc4ynxHGN9A=;
        b=qBP0TW7lD35BHLpkP125QUl7SrXmhVfKTyiuSWR71shVOfQLg0y7LfpxpGHTDyaR1b
         0XrCgOYXDFQgyeRDSFivKx+qAhDyk1/aKnWaJy8IWh9600mNc6ovf7CXe5cGSBvZ1lsN
         VeIwZ7UdCo3EUaIyIal0cHXgF8FP3XMsITdyD5WmsIiFIZ5aTx+gxiQtkeea2dWEhP49
         jWCV+oDSPGaxEi0h6XyRJOMHxIaEk2TSFBeo2gruHM7JGGp9YdYHJazZH9NuU9ZG3LWa
         A60D5WTLGfLZ8nMNpEGdIVBN4Wxv4rhWjtjLGaa1wKjMi+L2Ql4CGiuIFOdK8jVNOXAv
         NBXg==
X-Gm-Message-State: AOAM530ezODD604rfakCawd5lEo8MhoTH4LepZTKCNENgCJFo3bj9QJ1
        POqQBVHfb+bRwlD55U1noXI=
X-Google-Smtp-Source: ABdhPJxvcDEt15uVKbvRMB+R9pm2JYVGpkpqB9V8hVegbJbYZJKACnh87ITvYs0yF8GDZTmHWNtGyQ==
X-Received: by 2002:a17:90b:118d:: with SMTP id gk13mr8553381pjb.119.1643355266232;
        Thu, 27 Jan 2022 23:34:26 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id q17sm8548846pfu.160.2022.01.27.23.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 23:34:25 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, imagedong@tencent.com, edumazet@google.com,
        alobakin@pm.me, paulb@nvidia.com, keescook@chromium.org,
        talalahmad@google.com, haokexin@gmail.com, memxor@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        cong.wang@bytedance.com, mengensun@tencent.com
Subject: [PATCH v3 net-next 7/7] net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()
Date:   Fri, 28 Jan 2022 15:33:19 +0800
Message-Id: <20220128073319.1017084-8-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220128073319.1017084-1-imagedong@tencent.com>
References: <20220128073319.1017084-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() with kfree_skb_reason() in __udp_queue_rcv_skb().
Following new drop reasons are introduced:

SKB_DROP_REASON_SOCKET_RCVBUFF
SKB_DROP_REASON_PROTO_MEM

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  5 +++++
 include/trace/events/skb.h |  2 ++
 net/ipv4/udp.c             | 10 +++++++---
 3 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4e55321e2fc2..2390f6e230fb 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -341,6 +341,11 @@ enum skb_drop_reason {
 						  */
 	SKB_DROP_REASON_XFRM_POLICY,	/* xfrm policy check failed */
 	SKB_DROP_REASON_IP_NOPROTO,	/* no support for IP protocol */
+	SKB_DROP_REASON_SOCKET_RCVBUFF,	/* socket receive buff is full */
+	SKB_DROP_REASON_PROTO_MEM,	/* proto memory limition, such as
+					 * udp packet drop out of
+					 * udp_memory_allocated.
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 985e481c092d..cfcfd26399f7 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -25,6 +25,8 @@
 	   UNICAST_IN_L2_MULTICAST)				\
 	EM(SKB_DROP_REASON_XFRM_POLICY, XFRM_POLICY)		\
 	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
+	EM(SKB_DROP_REASON_SOCKET_RCVBUFF, SOCKET_RCVBUFF)	\
+	EM(SKB_DROP_REASON_PROTO_MEM, PROTO_MEM)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index e295f7f38398..1f756bb0bb1f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2093,16 +2093,20 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	rc = __udp_enqueue_schedule_skb(sk, skb);
 	if (rc < 0) {
 		int is_udplite = IS_UDPLITE(sk);
+		int drop_reason;
 
 		/* Note that an ENOMEM error is charged twice */
-		if (rc == -ENOMEM)
+		if (rc == -ENOMEM) {
 			UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS,
 					is_udplite);
-		else
+			drop_reason = SKB_DROP_REASON_SOCKET_RCVBUFF;
+		} else {
 			UDP_INC_STATS(sock_net(sk), UDP_MIB_MEMERRORS,
 				      is_udplite);
+			drop_reason = SKB_DROP_REASON_PROTO_MEM;
+		}
 		UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, drop_reason);
 		trace_udp_fail_queue_rcv_skb(rc, sk);
 		return -1;
 	}
-- 
2.34.1

