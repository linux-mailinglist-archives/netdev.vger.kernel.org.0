Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18F55B82BE
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 10:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiINIPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 04:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiINIPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 04:15:51 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A828710549;
        Wed, 14 Sep 2022 01:15:50 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id y9so11155665qvo.4;
        Wed, 14 Sep 2022 01:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=E3uwB8CqWVlPJdmYFGu1eVYpx1JpXqpegdhCF2Dn9pA=;
        b=G2z63NBey6mFbnL8i3cvE83J02RhQqveqTl3DsSMswps6rOR1S+R32HI4mouP30Va9
         FPdAZ7eSLooqa+81j0vK4CfzcQMic1WPM/hllalMM0TUO7d5MXvknHP+00ogn8uqIxlw
         FqguQlFwXnV8gNoYShd2TWwXPOPPGXkG6cffddCojrNQeNzv6630pcr1ktrs/Azls8/U
         mYl4XOEZNY1fbAI2JFYW2dHLjsRY3hd7gn0Gje5C2iMCOS9JMW0oAMAwRfPGSIUe2uwW
         uYj9jFT2jPLRa79KEVigywAKb2naNzBZ4cyJ2tMilZEyrI5uslIlqtOK4Yr2NzVyoxpS
         QrNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=E3uwB8CqWVlPJdmYFGu1eVYpx1JpXqpegdhCF2Dn9pA=;
        b=l+M30Tf4Nj0NXqc7pLWNl3MkNZSj2/6JhqjGgxiPg1LG4Ab5Z5sXWZexdNF5A6jGrV
         EN9ymc9++9H3FvXuepID1MZbjP6UN2RqGQhkJGkn0sWnwKFHNbI4cRw6wSXqgkV6Roao
         mogJ8cLiWJxxUGA3eR9va08gmM0JxOXjOQcSKOd70G5iqRwBbnCp/CtKwWmt8nOIKRjd
         iLwnQW+KNYuTRjBOF4mWHBi1wBhhzkPiDsnnEU7LzNISbD5tdZtWHCGKOsHUheEoW9uc
         BEl+Y1btTHGb68l47yxQsB70TiuA1NmqcHbGgsKwgojnQARReIA477AxH9ZpGfRcoaSt
         peHg==
X-Gm-Message-State: ACgBeo0ikN0Sd8hwPKKfbbpPazaZsj2YxzitWG9AxRbKLZvSB3J+IG4F
        AwGrR7+8ssBB45o2cmiMfg==
X-Google-Smtp-Source: AA6agR7rdHdEUwpC6EDdkr/XMbUlHMbf7/uf60vpJEPcZOfplJpDoROA7mtkkbfAddJlh5KQMk38mQ==
X-Received: by 2002:a05:6214:5181:b0:478:69bd:38c5 with SMTP id kl1-20020a056214518100b0047869bd38c5mr30478259qvb.59.1663143349792;
        Wed, 14 Sep 2022 01:15:49 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id r18-20020a05620a299200b006ce7cd81359sm1497995qkp.110.2022.09.14.01.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 01:15:47 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH net-next 2/2] af_unix: Refactor unix_read_skb()
Date:   Wed, 14 Sep 2022 01:15:41 -0700
Message-Id: <6fd03b42db6b44142e517f85902e99c720277586.1663143016.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
References: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
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

From: Peilin Ye <peilin.ye@bytedance.com>

Similar to udp_read_skb(), delete the unnecessary while loop in
unix_read_skb() for readability.  Since recv_actor() cannot return a
value greater than skb->len (see sk_psock_verdict_recv()), remove the
redundant check.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/unix/af_unix.c | 34 ++++++++++------------------------
 1 file changed, 10 insertions(+), 24 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index dea2972c8178..c955c7253d4b 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2536,32 +2536,18 @@ static int unix_dgram_recvmsg(struct socket *sock, struct msghdr *msg, size_t si
 
 static int unix_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	int copied = 0;
-
-	while (1) {
-		struct unix_sock *u = unix_sk(sk);
-		struct sk_buff *skb;
-		int used, err;
-
-		mutex_lock(&u->iolock);
-		skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
-		mutex_unlock(&u->iolock);
-		if (!skb)
-			return err;
+	struct unix_sock *u = unix_sk(sk);
+	struct sk_buff *skb;
+	int err, copied;
 
-		used = recv_actor(sk, skb);
-		if (used <= 0) {
-			if (!copied)
-				copied = used;
-			kfree_skb(skb);
-			break;
-		} else if (used <= skb->len) {
-			copied += used;
-		}
+	mutex_lock(&u->iolock);
+	skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
+	mutex_unlock(&u->iolock);
+	if (!skb)
+		return err;
 
-		kfree_skb(skb);
-		break;
-	}
+	copied = recv_actor(sk, skb);
+	kfree_skb(skb);
 
 	return copied;
 }
-- 
2.20.1

