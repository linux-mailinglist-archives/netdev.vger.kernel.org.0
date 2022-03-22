Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733BB4E36DE
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbiCVCy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:54:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbiCVCy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:54:56 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A64CDE926;
        Mon, 21 Mar 2022 19:53:29 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d19so17065806pfv.7;
        Mon, 21 Mar 2022 19:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIQAXIraFBo7pp9F+UKiJewbp52XCbv0LyD3lJdVZ6Q=;
        b=KxXY2vNAN0L6r6ID/7fP5rPdTK0ot4c4qYUafbxkqPvjVLZesIguhbN9pOUIuneglJ
         /71Y9uTDnBMb4XNVL3dLStyvMrH1OnieYwzAPVHJAG0wx+WI321Un7+g2n0FlAh0aszr
         tzywYvdaUq0Ux9jFKMJQ6EpBOe+NRzd7STL0/LlIYglZjCcfc3PyxSJfoKdRIqaqohva
         xkyBu98IcxQlb1rAv1KRQM3+yxKZpERLjWI1/oiji4oOJjb4gz/dSP/s6MofG3029g/+
         wgqSiQtN7pnCyBEora6siv9psoUI8sWTkcFgA1PmCbOqytQWtMEmzP6yqZTyzMu2TvH0
         PIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIQAXIraFBo7pp9F+UKiJewbp52XCbv0LyD3lJdVZ6Q=;
        b=B3g1cGHKOu18LKTdZRvCZbuFoLOsem3IdfP7p0r23EjX3MN1st7UZErCoHucwyveya
         uWqjOxKbmnzoYhYLtb/r7k8D42IyZc/Mo5HhY1xmKI6Tf4H1Jco/t3m9knWupiMOMdUQ
         LuSuS3RU27lbAsXH+eU+ESKC7sfs5j9ABMHyW0cu9AoJ3/GD0MjccbDyJYDTbuNzWe37
         fsN5FSuGXAvRTJOySyMo+MjadOC/AlhAYBY0j7VTCZRzr3VMIuvt6wTEnAAmlyPbDkrb
         SNX/cQ/6DaASqf5JBJFX0kPWD82GumiOSStmU8uL5W0x4/bjZ/m1vD1Viz9J4HV4i0jd
         8t0A==
X-Gm-Message-State: AOAM530D+uNrKczL3NnMsxD9Kxwuj2MV53d1nmQNZmQQWUMkMbXdAbaL
        Pb6Kyj0cnON65A3EW4crcSU=
X-Google-Smtp-Source: ABdhPJw3jr9+fBPVG9c3RO8dd3NPYI+b6uUyNDO6JBZZZlzb/x4QJ7EUnFRHJwQadRS5qvkoY8I1Sw==
X-Received: by 2002:a63:2042:0:b0:381:faca:a4d9 with SMTP id r2-20020a632042000000b00381facaa4d9mr20671348pgm.344.1647917609116;
        Mon, 21 Mar 2022 19:53:29 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id g24-20020a17090a579800b001c60f919656sm764687pji.18.2022.03.21.19.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:53:28 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
Subject: [PATCH net-next v4 1/4] net: sock: introduce sock_queue_rcv_skb_reason()
Date:   Tue, 22 Mar 2022 10:52:17 +0800
Message-Id: <20220322025220.190568-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220322025220.190568-1-imagedong@tencent.com>
References: <20220322025220.190568-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In order to report the reasons of skb drops in 'sock_queue_rcv_skb()',
introduce the function 'sock_queue_rcv_skb_reason()'.

As the return value of 'sock_queue_rcv_skb()' is used as the error code,
we can't make it as drop reason and have to pass extra output argument.
'sock_queue_rcv_skb()' is used in many places, so we can't change it
directly.

Introduce the new function 'sock_queue_rcv_skb_reason()' and make
'sock_queue_rcv_skb()' an inline call to it.

Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/net/sock.h |  9 ++++++++-
 net/core/sock.c    | 30 ++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index c4b91fc19b9c..1a988e605f09 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2392,7 +2392,14 @@ int __sk_queue_drop_skb(struct sock *sk, struct sk_buff_head *sk_queue,
 			void (*destructor)(struct sock *sk,
 					   struct sk_buff *skb));
 int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
-int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
+
+int sock_queue_rcv_skb_reason(struct sock *sk, struct sk_buff *skb,
+			      enum skb_drop_reason *reason);
+
+static inline int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	return sock_queue_rcv_skb_reason(sk, skb, NULL);
+}
 
 int sock_queue_err_skb(struct sock *sk, struct sk_buff *skb);
 struct sk_buff *sock_dequeue_err_skb(struct sock *sk);
diff --git a/net/core/sock.c b/net/core/sock.c
index 1180a0cb0110..2cae991f817e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -503,17 +503,35 @@ int __sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 }
 EXPORT_SYMBOL(__sock_queue_rcv_skb);
 
-int sock_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
+int sock_queue_rcv_skb_reason(struct sock *sk, struct sk_buff *skb,
+			      enum skb_drop_reason *reason)
 {
+	enum skb_drop_reason drop_reason;
 	int err;
 
 	err = sk_filter(sk, skb);
-	if (err)
-		return err;
-
-	return __sock_queue_rcv_skb(sk, skb);
+	if (err) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
+		goto out;
+	}
+	err = __sock_queue_rcv_skb(sk, skb);
+	switch (err) {
+	case -ENOMEM:
+		drop_reason = SKB_DROP_REASON_SOCKET_RCVBUFF;
+		break;
+	case -ENOBUFS:
+		drop_reason = SKB_DROP_REASON_PROTO_MEM;
+		break;
+	default:
+		drop_reason = SKB_NOT_DROPPED_YET;
+		break;
+	}
+out:
+	if (reason)
+		*reason = drop_reason;
+	return err;
 }
-EXPORT_SYMBOL(sock_queue_rcv_skb);
+EXPORT_SYMBOL(sock_queue_rcv_skb_reason);
 
 int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
 		     const int nested, unsigned int trim_cap, bool refcounted)
-- 
2.35.1

