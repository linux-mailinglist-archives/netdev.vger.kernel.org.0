Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6119949DD93
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238510AbiA0JOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238475AbiA0JOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 04:14:23 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E925C061756;
        Thu, 27 Jan 2022 01:14:22 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id c9so1917061plg.11;
        Thu, 27 Jan 2022 01:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SyLy03L5E+1xwc8EXhn4C+jar44ebU6XLc4ynxHGN9A=;
        b=BO/Mcc8pIwMCzW25cFaSy3yiHSzVzlL2RKtbCvNXHfFQ1VpOguN5+POcqOvQ1bBv9f
         A/0zWWqll8JmJtDECWxq7VEorcDRIoD63hVexckn4ZekdYRkujnm4VwXiaoj6nwT4z/Q
         bW4TJsCM6caroud6yMu4zQvX1twS973ufRUmBL1+12BOfpsvpjbnDvEdJ7Yyvs0mjHWl
         icPbA0Eq78EiBFRnyPKiMBkWyyqkyknyE7Y3W0uiVgfBE1tD6bSMETyHfw8YZSTR0NNF
         ebI9qkbbrIVVZuZL5Cx4FkDtuVXCBxXLfAj99fQ/5UXcDHrfES1nKezWHJ3OUtek6ch5
         p+ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SyLy03L5E+1xwc8EXhn4C+jar44ebU6XLc4ynxHGN9A=;
        b=EHPrLa4zEW+mPVKw5TA25/Bwcjcm6WtgA9SaRQ1OCiOgg0V7agg3c2z0nPTmlkl35/
         1q9XTGabzzXfNFU0Ula5NN1aFp/aSX1iYXqLmgPfqsr4hzdzM2hBlUzAp83JxV2tymT4
         8ci02BZjhGVPHicQ8lXNplzFDZOUMUBiksLeW5XhQhbeai8NY0+PO0xRlT4OtZv19UrB
         wQyoP+IrbN2THAi7GR45tI3puPfB7Md27e+aWR6gIyDHoBWQiBm+p3SkGxIPeZIZjRXK
         NXFIQP7qWVw14ZwjilF7fTyOzLeGrgKbvRi87k+SZODvmjufyjWLkBXr/w9xtdRoOwDD
         x/6g==
X-Gm-Message-State: AOAM532xWsqUgRnH3YujiCkqaAQI6awRqrFhzpwTTqmPZ7TXl5TKfFmB
        oXQRyAwgTu6ZQtU+V1vq07o=
X-Google-Smtp-Source: ABdhPJymQ8bEozBsOrYjt+kKfEnfV0Rl7+mEB7D6Oki0Bd9a6QDZQslTmMnczJtd3blXB4Xmt7LiGA==
X-Received: by 2002:a17:902:ced0:: with SMTP id d16mr2883990plg.47.1643274861649;
        Thu, 27 Jan 2022 01:14:21 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id j11sm2046338pjf.53.2022.01.27.01.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 01:14:21 -0800 (PST)
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
Subject: [PATCH v2 net-next 8/8] net: udp: use kfree_skb_reason() in __udp_queue_rcv_skb()
Date:   Thu, 27 Jan 2022 17:13:08 +0800
Message-Id: <20220127091308.91401-9-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220127091308.91401-1-imagedong@tencent.com>
References: <20220127091308.91401-1-imagedong@tencent.com>
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

