Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA91C4E36F3
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235714AbiCVCzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235706AbiCVCzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:55:11 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDFF192362;
        Mon, 21 Mar 2022 19:53:44 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id m22so14614529pja.0;
        Mon, 21 Mar 2022 19:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uzLwDH0T/7R2uuxPhLk/uyD8x3vzGxN4sd3r2UIM55o=;
        b=Evup6FvkfqCnuSvUVW/J4S1NO4T5ksBbL9Adiu9aKm07Z3WcAVID4TL/sB+m/1PDVW
         MKWBcr43ZJ5CKaJ6fj3nesK/YIVy2CFMHLvnS3IrptXJx2yKPmWHcwb1QqpFI68s7ob6
         gB8XOYtFx4GX6D1mb80O7S9PGuUfYfUVy7M1Vk84lqeOZ/TGowK3aDX+LO/77AVS8iDs
         LklUdZg7kpMQO3Eai+BmUVxziLGyeGRnUX14jxTcxqzd4gHDEzW2Gj5Cq+EHHgHrqA5/
         GV1Og5edIqjWtsrOkpfXnEVuoNIEV/86iz5D7OcdVgbxGXVbt9dYorcShiUCrFOqgQT3
         NynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uzLwDH0T/7R2uuxPhLk/uyD8x3vzGxN4sd3r2UIM55o=;
        b=v0CwUxG1xJNupf+hIqiSRgLBO5Wr9lUWbWUPNi8Hx2UtyUzymKjPRR2wELuRMuDFq0
         xboM8awShAI3hAuYFSb79Q3A/yGtN1e0smvt0f8kb9ZeeVRmryIl12h5cktrSAnQXQCe
         7W128c4Liq9x1zTxyXGtvyTleGuvrJWFtZnAN9dl9WrrnWk5EmMOWjvBKCAzdCsX2i3L
         btnlVMRD2ZLhXCe6p7snRKdzQZaH8Sgc7Y8r8xLNRmk8vuCEiO2Yw6da4P23VxL8aIhQ
         HtZAhUehQqxEpVW3AEZ//+NcvWRm1y0Aq8CT//1sLIYt8wdUh49qye/SCyzyGftRr/N8
         AdwQ==
X-Gm-Message-State: AOAM533Hu1dPeSRkA6onqrFZj9/P7JaAzlrrz4mDdVI2Zn2Pal38rub8
        XzrGPQ8d2jCwqo5uV+ZsSwM=
X-Google-Smtp-Source: ABdhPJyesYanpfgfrfarhhj4reCYRrb8K3szJy9ysjOyeIaq1kAlCqeBudHmuUWKpubPRdw+2V2Lxw==
X-Received: by 2002:a17:902:ce09:b0:151:96e2:d4b5 with SMTP id k9-20020a170902ce0900b0015196e2d4b5mr15513629plg.3.1647917623684;
        Mon, 21 Mar 2022 19:53:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id g24-20020a17090a579800b001c60f919656sm764687pji.18.2022.03.21.19.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:53:43 -0700 (PDT)
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
Subject: [PATCH net-next v4 3/4] net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
Date:   Tue, 22 Mar 2022 10:52:19 +0800
Message-Id: <20220322025220.190568-4-imagedong@tencent.com>
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

In order to avoid to change the return value of ping_queue_rcv_skb(),
introduce the function __ping_queue_rcv_skb(), which is able to report
the reasons of skb drop as its return value, as Paolo suggested.

Meanwhile, make ping_queue_rcv_skb() a simple call to
__ping_queue_rcv_skb().

The kfree_skb() and sock_queue_rcv_skb() used in ping_queue_rcv_skb()
are replaced with kfree_skb_reason() and sock_queue_rcv_skb_reason()
now.

Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v4:
- fix the return value problem of ping_queue_rcv_skb()

v3:
- fix aligenment problem

v2:
- introduce __ping_queue_rcv_skb() instead of change the return value
  of ping_queue_rcv_skb()
---
 net/ipv4/ping.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3ee947557b88..877270ad17c9 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -934,16 +934,24 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 }
 EXPORT_SYMBOL_GPL(ping_recvmsg);
 
-int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
+static enum skb_drop_reason __ping_queue_rcv_skb(struct sock *sk,
+						 struct sk_buff *skb)
 {
+	enum skb_drop_reason reason;
+
 	pr_debug("ping_queue_rcv_skb(sk=%p,sk->num=%d,skb=%p)\n",
 		 inet_sk(sk), inet_sk(sk)->inet_num, skb);
-	if (sock_queue_rcv_skb(sk, skb) < 0) {
-		kfree_skb(skb);
+	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
+		kfree_skb_reason(skb, reason);
 		pr_debug("ping_queue_rcv_skb -> failed\n");
-		return -1;
+		return reason;
 	}
-	return 0;
+	return SKB_NOT_DROPPED_YET;
+}
+
+int ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
+{
+	return __ping_queue_rcv_skb(sk, skb) ? -1 : 0;
 }
 EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
 
-- 
2.35.1

