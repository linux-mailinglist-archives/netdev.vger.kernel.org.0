Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 370074E8D50
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 06:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238046AbiC1EaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 00:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238049AbiC1EaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 00:30:02 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627356341;
        Sun, 27 Mar 2022 21:28:19 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id t4so8239425pgc.1;
        Sun, 27 Mar 2022 21:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uzLwDH0T/7R2uuxPhLk/uyD8x3vzGxN4sd3r2UIM55o=;
        b=VLwISMm7+7uxIyFYaW/zGmkksPCmoXj5EKxr3D+7XXGaO6HqvNUR+W0DDLbmYq4LFv
         i2wU3sa+wU5pz8glEwGHXUAtdgNIHHF6I2MCMMsVciG8pzozdPX6qh4+dvopM3sMFKTe
         2s7VTDCTGWiuhWuFY2zrRcj2671fI24KrvPtwDDDJsawZHsTwzeZr7qV3tcehBFSYNDI
         6E3hFfCMUEOoKdm1IGPh3XNfrqlDnhnYUM+7uLOQvny4+Nss9vrP0vtl25BOX7yjMwRy
         gLNL+1mdhgXb4uX2rpVnSwfHT893e7GeXNb6qfGr5S+t4asc7/ziCvT5b/nAwucrLnqJ
         /lJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uzLwDH0T/7R2uuxPhLk/uyD8x3vzGxN4sd3r2UIM55o=;
        b=1TDhVdDO28uWKGh9ndlRR6mxaH/zv6rbmqawkPQYT75Uo0sKonUhUz+2NKFRO0I78G
         ttLOOcNvqf3RL8lqn2T5+o+wFu1Mq05SzjuwqFtgWbMAPxIW8tjWKPKqaIrnLenG4J+G
         9FBT1AT0tBr22mieParWkVTY759ZRltiJ+d7uy3PdJahfkw90t80jf5sDgiCmISaCF76
         4GGDzQa/DwfIGToqycJhGp55m/uIBsQi4JoJTY9nMWsbdwnQvrjNADQ9yDyOvQXwIzF8
         BN5RTV6sRtDeu3kfgmRNiEJuPKG72IPPsR7eVI2qUe0jd6Gqm/13BBPnbGgLG+ikodcb
         gOWw==
X-Gm-Message-State: AOAM533ddj1ehtbE/iDKWhAdDLbWNr4Pwurajezj1nN7q39N+Pji06Zc
        2jfn25r1EabwTiv0exS/AjE=
X-Google-Smtp-Source: ABdhPJxGM4AuuFr3LASw7U+IXdlKelrwiXux8qTUlQXjt7NmjwCL+zIqb54+Yx1BNJ2JubPQq93rvA==
X-Received: by 2002:a63:5a49:0:b0:382:1ced:330e with SMTP id k9-20020a635a49000000b003821ced330emr8857460pgm.478.1648441698954;
        Sun, 27 Mar 2022 21:28:18 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id o27-20020a63731b000000b0038232af858esm11317715pgc.65.2022.03.27.21.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 21:28:18 -0700 (PDT)
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
Subject: [PATCH net-next v5 3/4] net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
Date:   Mon, 28 Mar 2022 12:27:36 +0800
Message-Id: <20220328042737.118812-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328042737.118812-1-imagedong@tencent.com>
References: <20220328042737.118812-1-imagedong@tencent.com>
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

