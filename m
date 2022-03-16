Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426D14DA897
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 03:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353265AbiCPCsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 22:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353254AbiCPCsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 22:48:20 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975715BE6C;
        Tue, 15 Mar 2022 19:47:07 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id i11so18632plr.1;
        Tue, 15 Mar 2022 19:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CN5EY4Vzj9f4po+lekz1OdhgYMqzS6JV0EYIQHmfVaw=;
        b=M5VDF5eafVrERr7ldHhtlGaAlRj5D8lDhUXmumJnICPux9q/WFOTkX+KQSsX4LRozK
         iN5Jsw2JaU2IiLN2N/dlIoXPT/f1xA655wD00zilERD4JB2H8evVCoofo5k3y79Zq7iG
         orsjEPDAvo1bk3fOTTKcykwO7BvZweU1RmMf8SnqzUVcIoIPTFS8zuLcRUBrUI/4R4s6
         vx/LlD75GXVw72SGA58fuTWgZ1kryzd8aknHyCmlA5/3IahGmCsA/Q6bIR1exFVal5R5
         S2PRyqePEZIrPWYCWMhCsRIgjrIuJ55VcQXDNQMVZRVRfkgXzoOHju3Yf/jK0jhOctHt
         C2NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CN5EY4Vzj9f4po+lekz1OdhgYMqzS6JV0EYIQHmfVaw=;
        b=pu/DOayPfJhTwvx/sbkdiQA4r/RMFPk64kBFkXlAxjn9tkuadsLr9KHj5RzES9JFUV
         cuojqZ/pFWF0sMEGUwoUWcZfsXoGXWdwOTLKVoJhugMEVkp5l3qXR59KXWFbXE+Ksvj/
         opTI8zLhX44G/voCS9zGwx+RI/C2g6ve4v1r5IFQ4k9mlr26oz9r47uv4BUjmPVIqcJr
         aRENMRohgkUgRkV4Ud0bYfNqNAluaUmETVd7clwIpzD9lRjpXarvg8txLMFHaSsAjoMP
         +dOa86QHFFV6PEUUab5HS+skPwQpYNNj0AvAPhiAKcj8Na7vK13IEPhsW43zx1jN588l
         N52g==
X-Gm-Message-State: AOAM531bgbo8jqEI4ATG9ix8ZZD6zsjc1SAboo6PBgLSxZsvqAxJ0slU
        OBnqhHN9PIP3J2j0U2BVCy8=
X-Google-Smtp-Source: ABdhPJwhs8da4Sf8sfsUW2yjdud4JnToRSwWlWbB88ZCeIZCXYWWRz6TpGq5YasTcnGrjkt5KgPxLg==
X-Received: by 2002:a17:90b:180b:b0:1bf:27c5:2c51 with SMTP id lw11-20020a17090b180b00b001bf27c52c51mr8056251pjb.142.1647398827137;
        Tue, 15 Mar 2022 19:47:07 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id s3-20020a056a00194300b004f6664d26eesm514630pfk.88.2022.03.15.19.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 19:47:06 -0700 (PDT)
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
Subject: [PATCH net-next v2 1/3] net: sock: introduce sock_queue_rcv_skb_reason()
Date:   Wed, 16 Mar 2022 10:46:04 +0800
Message-Id: <20220316024606.689731-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316024606.689731-1-imagedong@tencent.com>
References: <20220316024606.689731-1-imagedong@tencent.com>
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
Reviewed-by: Biao Jiang <benbjiang@tencent.com>
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

