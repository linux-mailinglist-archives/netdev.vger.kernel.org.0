Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B591C4DAAB9
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 07:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353925AbiCPGd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 02:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353907AbiCPGdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 02:33:50 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FF160DB7;
        Tue, 15 Mar 2022 23:32:37 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b8so1354341pjb.4;
        Tue, 15 Mar 2022 23:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qIQAXIraFBo7pp9F+UKiJewbp52XCbv0LyD3lJdVZ6Q=;
        b=Y5HM6jnjkeSZUSvP8fbzwE8KndpA72qtVsCclyqzhMYuveOC+l+N05YURAT7rOC6RG
         Co6mqSgu1FoN6GMOXjfZEQWhCtYn12/chPREz5yaLK9plQ8BXsVbZiDAiL2U+g32mt9N
         ys17w4YolRTadNNBZDVHvmjhNsBrXUnvQOSFGdAdSXsrnsZ5uWmq3zO9S2896ELtiNYd
         XdNrqAe+liu5v4whPj/Zg63VVWFn9GTLTM7BhCAMZy77F0+xKuGo6ypS6Clkx0Imr6ir
         ZUOa79h7M+TEOd2TyvbjG6/JpVmyN3/xmIkU8yHn+By2EfuBjJVXXShFY/T6TYYNKRYF
         pNqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIQAXIraFBo7pp9F+UKiJewbp52XCbv0LyD3lJdVZ6Q=;
        b=3d1+6ZetFk9flsmeweNNvoKruzqx+iKwanVbi05pFRn8chuEFEWNHMbbKu7hD/IBly
         vjpGp4zvzrRkMns7DIl61MXsLysqd16o6ii0vp7XachixDMzbBOGvWyj5dXZMwb/d44e
         joIK3qzYW4yWYqGdrDG4ke86LmQbRKb7RwHSteP1hnykFDswGTBURS4tDw6Ej3pE4MVB
         wIv2ydX9tevwVPgpbCzw9JmaCf4Q7kyepyFtDw9vqk4cx4USxbzHDCPh3VpJ5sQTRVs5
         EVhKZt459IGqXPSeO5nM1sd3tUDnjABH1nSGk26UqT9tWOqEv+oHn05y3TejnaQuAUFp
         gHzA==
X-Gm-Message-State: AOAM5302Wwq2XmZtLOT4HUSPtZlzBMj7EbenXwC+FXfToT6y6tTUVYMX
        1hR8/uby6lzEsncFXLKiMUE=
X-Google-Smtp-Source: ABdhPJyf78h5VrYPglLbmAvmyWK5lHde66AL3ljC97R+ZMWI4xkXtdQwK++DdJByFw1ZdP31peydBg==
X-Received: by 2002:a17:90b:f87:b0:1bf:77b7:1d40 with SMTP id ft7-20020a17090b0f8700b001bf77b71d40mr8516041pjb.26.1647412356671;
        Tue, 15 Mar 2022 23:32:36 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm1438314pfc.190.2022.03.15.23.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 23:32:36 -0700 (PDT)
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
Subject: [PATCH net-next v3 1/3] net: sock: introduce sock_queue_rcv_skb_reason()
Date:   Wed, 16 Mar 2022 14:31:46 +0800
Message-Id: <20220316063148.700769-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316063148.700769-1-imagedong@tencent.com>
References: <20220316063148.700769-1-imagedong@tencent.com>
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

