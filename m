Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D8B4D80BF
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:32:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238950AbiCNLeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238954AbiCNLeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:34:00 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908916316;
        Mon, 14 Mar 2022 04:32:50 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id o8so13488072pgf.9;
        Mon, 14 Mar 2022 04:32:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c0qbe48VVF6udBeUIwiukE1f5l4hiwTH0gkxxO+1NBw=;
        b=M6uP11oot8S0Jzqr6aTU8IO3iBxDHpDOCnZfHij8TJqIWj6IcCLs/lC0cOh0RYLANp
         88ZSan5WDZToaTOOvgfHuWMIvGvjx7Jgog1LkUnJwLf69t2sFasJrAlMYg6SRRClXwha
         dVDeYQg1INxyMjqTPHHmZ0uobL1U5yob6YSK2kk/2SuHYoXFQIm4mvrqeOOn0x57PEkI
         ndafoo+9mFETzFYGH5eii2R3IkBHJKlFkr9IfbiPdvtMeVRb9ZZNbFazH7mTDSEGRA/8
         JxLX7trAQDurlJjm90yJ2FwUZmKW95E4yqPhnoQZDHVkruWTncDJzqJ/ce9/0VrOG8Tz
         0wQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0qbe48VVF6udBeUIwiukE1f5l4hiwTH0gkxxO+1NBw=;
        b=MahCuzhShu/+KitahOXr3hTWm4fGbO5rOage9mn7j8l+MlwHu+CcrL/gNi2MKD80R+
         ZDXoRIHrZsACeOWODDmHUt1tBa2FfekJevYJOSs9bch063A6fbg5DU6dCxIPdeg3hjKV
         1Ip5sPjfDEyFw18x6Ch8OB+6hGuEvKKW80fGEfNVoYnl/uYhWy1MANT7Lob+RCrmYEaE
         fuqlFBY4krzOWVekdjLpWWHZCqxfBIFuEYWwFydgMbklVupHVu5boujlhGGALLKOW9Y7
         sbrvMmQERONwRooHTUmy5Qz6reYfnOuQnUNN9zuFE7qqJECPcKcyA1LIcpvzdrinhpVz
         71FA==
X-Gm-Message-State: AOAM5316NrZ0oKl0L7rWb4YeEi9ixglNrUHzKOYmr0xMUDzS51fJYmqg
        oQ+iuHIldDgkTuHAEB4U/lE=
X-Google-Smtp-Source: ABdhPJzR8U7kj62OsB/f2ds5wd7AArgZ8SCOC/1Yf+BiV2GWUKcuNBfYPVrW5BdihtPUPSmhiaaIqA==
X-Received: by 2002:a63:e215:0:b0:373:9dd6:4b99 with SMTP id q21-20020a63e215000000b003739dd64b99mr19847776pgh.561.1647257570022;
        Mon, 14 Mar 2022 04:32:50 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm2645197pfc.98.2022.03.14.04.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:32:49 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, alobakin@pm.me, dongli.zhang@oracle.com,
        pabeni@redhat.com, maze@google.com, aahringo@redhat.com,
        weiwan@google.com, yangbo.lu@nxp.com, fw@strlen.de,
        tglx@linutronix.de, rpalethorpe@suse.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: sock: introduce sock_queue_rcv_skb_reason()
Date:   Mon, 14 Mar 2022 19:32:23 +0800
Message-Id: <20220314113225.151959-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314113225.151959-1-imagedong@tencent.com>
References: <20220314113225.151959-1-imagedong@tencent.com>
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

