Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC754DAAB8
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 07:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353923AbiCPGeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 02:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353928AbiCPGd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 02:33:56 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8683460DB5;
        Tue, 15 Mar 2022 23:32:42 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f8so2657348pfj.5;
        Tue, 15 Mar 2022 23:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x7TRtp/82Q95QKIl878MXMJ8ZwWGxgbepH+l4wCu7Io=;
        b=ZBJWxQPuOel0F4vOUMJSLClcMU+P/zCe6kbHx2ewGw2BCaMwAbsbYZLLYAVx9Emgfm
         +5mxDzb/35lRqOGNXU8mXNCjO57iA5FMkoYKq00aLZLz9TgayxiL+SSn9kyZm8uUtHde
         ryD+MHMfuU0A5ATijoTqRuFjec1EaTdEHJVADiAncjwRwkm/aD0dkuN0a/c+q5eYTa5m
         zfiRcMxw4rWXjBM+fNlN/HS9VUjjUQ5iD9JuWTPb4GOvoP+S7eT1G/D7LTm0i6p6Vi2T
         Olr+m5I49sNw1bfGbyUZrLYHJc+EmeHq2n9cDZpDiVIcHam7bDB8vOtwfkbEamdGh0RE
         99NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x7TRtp/82Q95QKIl878MXMJ8ZwWGxgbepH+l4wCu7Io=;
        b=eJ3piglxHy6/UQUKseEbHtYXRuf9pv9YY0xwCcZ0yuZXbrsBdQ36ltBp6eafTN4aHv
         RC0RXlPhAIADPkFni7zKjn6DKl9qNDnO64UIYaLtQUpgsuXoAcuwRaOnNCivz6WbtPxc
         v/m7DHftstf0V4W83cPFK3HrNFkwNGSA+QInpXBl9B3VUOi0xc6w4TSz/S4KYwkBoges
         BiFRVgoO0LQlqkTmzIu9OyfSV1se7tyD8tMoDr3DN9yYipC6FvBkq0FIlX5Z2pqlTgZa
         WQAM58XA8N3NJY2RU442z12TZukoVB0N26iSF8tYT7RlcZE/J3UzUvCewKjVgcOysY/r
         j+5Q==
X-Gm-Message-State: AOAM530FFg/9az+BajN5AK79svzYAxzRKkH1OSnhqo02QYdDx67FE8GV
        Z4C2iMZGnw0aj8WBvYwKpfY=
X-Google-Smtp-Source: ABdhPJxFnjo4rce5O7thUhgBhMXPZfh24UuZYzTPwd66mL3C6D9vqrriuqTHxjmb63vpxwFptZWDFw==
X-Received: by 2002:a62:1787:0:b0:4f6:c5d2:1da7 with SMTP id 129-20020a621787000000b004f6c5d21da7mr32696628pfx.71.1647412362024;
        Tue, 15 Mar 2022 23:32:42 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm1438314pfc.190.2022.03.15.23.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 23:32:41 -0700 (PDT)
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
Subject: [PATCH net-next v3 2/3] net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
Date:   Wed, 16 Mar 2022 14:31:47 +0800
Message-Id: <20220316063148.700769-3-imagedong@tencent.com>
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
v3:
- fix aligenment problem

v2:
- introduce __ping_queue_rcv_skb() instead of change the return value
  of ping_queue_rcv_skb()
---
 net/ipv4/ping.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3ee947557b88..9a1ea6c263f8 100644
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
+	return __ping_queue_rcv_skb(sk, skb) ?: -1;
 }
 EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
 
-- 
2.35.1

