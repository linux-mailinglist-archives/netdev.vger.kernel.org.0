Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17D24F75E2
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbiDGGYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241019AbiDGGYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:24:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B3111F623E;
        Wed,  6 Apr 2022 23:22:16 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id bx5so4677094pjb.3;
        Wed, 06 Apr 2022 23:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uzLwDH0T/7R2uuxPhLk/uyD8x3vzGxN4sd3r2UIM55o=;
        b=NaOWB6pVjsjbky4yJCzPQGeziW+NG3COxtix+JXAv1Gl5rb69xc3hwPCsuMPajp2v9
         MF2f05aBa753Jvp9MYaV8j4nmoofE7l0hSfFsj4NjSwpOARaJCm4OQT7ysNWbmTwaQqi
         kz1/BFyjHT3UqCFiCyDmSwB0ysUPbeCmmw2H6krzvFE4erS/rrD/lXu4enQUbSShWDis
         rpgIMhDmFkU0jB5uvZ0nTpYM3spanhvBMvacDkFRPMR0rsDMP4Qy2v218PRc61YoZdOD
         4A8CVCARUxFeE1kwKrqvLwOcZoLfBdVABjgF8VTHT0kEOV8bKA4CfZKx0u23xG4d/J5Y
         /vBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uzLwDH0T/7R2uuxPhLk/uyD8x3vzGxN4sd3r2UIM55o=;
        b=nSNGYU0J++Ulu0mgujQOkVu0Rg9ekanxNmVNyPMOZgIXLkCvgmD+ygw/mok7C1S2gK
         Ukdk4I8zifn6jkxx4WkAJVquw8BrdUlvQ7KFViScqT8jr9bSrJZlXVkMhThXxCxhP0sX
         tw210V1qCfL2i9s0tZJpaC9HBowjTNzsaePKM4bd4lrCJmOenbhk/T/MLKpJCjZbJUV/
         bZX+KQZ/Mh2/MsHwSy9W92sVjjYkMWa4wSdZtP46cDinI+Jima4i0KaCOeaXLuqXxqo4
         K5pa0XrWb/H/3g1pfV5k5OIgGjq1WuY8dpNQXyQJW/3QK3GuldPF7etc7bDiDFiDSgr+
         ZUkg==
X-Gm-Message-State: AOAM532h4JmZ6Tjhf2i5c8ZuQwLh7J40S2FokiEA6NohEsHgzyDTboTX
        11hJ06cigF6jpXOJqG45CsM=
X-Google-Smtp-Source: ABdhPJxjkTYgFCAZvPLSfTLd2yvZsCPY6wR5kWrHJuOpWuISobqUrCLwSSikzVB7NUTsg4IZgoF/hA==
X-Received: by 2002:a17:902:d888:b0:151:6fe8:6e68 with SMTP id b8-20020a170902d88800b001516fe86e68mr12193394plz.158.1649312535428;
        Wed, 06 Apr 2022 23:22:15 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id k92-20020a17090a4ce500b001ca69b5c034sm7522829pjh.46.2022.04.06.23.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 23:22:14 -0700 (PDT)
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
Subject: [PATCH RESEND net-next v5 3/4] net: icmp: introduce __ping_queue_rcv_skb() to report drop reasons
Date:   Thu,  7 Apr 2022 14:20:51 +0800
Message-Id: <20220407062052.15907-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407062052.15907-1-imagedong@tencent.com>
References: <20220407062052.15907-1-imagedong@tencent.com>
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

