Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301D55B82BB
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 10:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiINIPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 04:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230250AbiINIPj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 04:15:39 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9D6D422E9;
        Wed, 14 Sep 2022 01:15:38 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id 3so9893496qka.5;
        Wed, 14 Sep 2022 01:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=+wbG6fgMQYUO57P7KRa54jq5kT0uHMNGp+ISOp5Std4=;
        b=BVdW/9lvb4MCtpvq2YiPmv3poClN+V/2D1tsWD0FOgTQf33mx3xSsfh+lrefRHXfgY
         6ynJesxowPfHFkXWEnaF4obCfX6oa24cAKlw89geXK9vj/7+Etrq2RvXVJ6EwQF2Pv5P
         kH3tZ/r0qDSMgN2tU32xCoylwQ2y3rl4fe+w+87xxMR1CDRdN8/2b8swrtvmjWIiB2t/
         1b/BbNxCiD4nnBZygOstkCRifYVDSWgjgyMljUjBbXTGFM69q/eoN0TxZEecrbyLrwSE
         7Quagg2MHpCS6RAHNqpaM00uBbAQqLxi+gTGl6LZjcpHRdhXVMK8k4B3s6SKJhgfnpqD
         ygWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=+wbG6fgMQYUO57P7KRa54jq5kT0uHMNGp+ISOp5Std4=;
        b=vrbh48nZfOxkRePA5/DZUqG39F4ubj+SsMZQPLQyLigFQHNia7bL4OYa+ruTc5Dgxj
         W6dqNJ6Npi6yYT6Wt7b+VlCkfD+xpSp8D6mgd0POkjscOJagLitXBpjFE86Twg+pe1hj
         39flg9JteBkPx5D60CCY7TpOqGjSnn1ooRnOpx0Smxaoej8wZLykpcm+UGfAzm7Ak79P
         jdO9nPydcjoiFan7De7PGPcW/xnIfxtsfacpDg3xVDcAdOYTY3vJZ7CImV5FgbC6r7k/
         jkLGZSvv39Z48q9+xwHjf7HtO6IYHH5lehBZrYs313ubjvMOrgrsXgKd8kprN74IcK3/
         3kPw==
X-Gm-Message-State: ACgBeo0fzaCcEF1we1SeBCJs04bJZ21H64ngYqaEWTCabjTZkzfWc25a
        HcEbSbC7Crtk2JEDrEMAaA==
X-Google-Smtp-Source: AA6agR7CWYMUN5cuud5i1c1eeHLQy7Xu8LpQszP6idvygrLPyCXOtvbyAERwXX+v0iF5INjNVQGZmA==
X-Received: by 2002:a05:620a:284c:b0:6b8:6e70:cd95 with SMTP id h12-20020a05620a284c00b006b86e70cd95mr25052613qkp.247.1663143337943;
        Wed, 14 Sep 2022 01:15:37 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id g26-20020ac842da000000b0035bb4805309sm1191561qtm.42.2022.09.14.01.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 01:15:36 -0700 (PDT)
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
Subject: [PATCH net-next 1/2] udp: Refactor udp_read_skb()
Date:   Wed, 14 Sep 2022 01:15:30 -0700
Message-Id: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
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

Delete the unnecessary while loop in udp_read_skb() for readability.
Additionally, since recv_actor() cannot return a value greater than
skb->len (see sk_psock_verdict_recv()), remove the redundant check.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Depends on:

"[PATCH net v2] net: Use WARN_ON_ONCE() in {tcp,udp}_read_skb()"
https://lore.kernel.org/all/20220913184016.16095-1-yepeilin.cs@gmail.com/

Thanks,
Peilin Ye

 net/ipv4/udp.c | 46 +++++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 29 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 560d9eadeaa5..d63118ce5900 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1801,41 +1801,29 @@ EXPORT_SYMBOL(__skb_recv_udp);
 
 int udp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
 {
-	int copied = 0;
-
-	while (1) {
-		struct sk_buff *skb;
-		int err, used;
-
-		skb = skb_recv_udp(sk, MSG_DONTWAIT, &err);
-		if (!skb)
-			return err;
+	struct sk_buff *skb;
+	int err, copied;
 
-		if (udp_lib_checksum_complete(skb)) {
-			__UDP_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS,
-					IS_UDPLITE(sk));
-			__UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS,
-					IS_UDPLITE(sk));
-			atomic_inc(&sk->sk_drops);
-			kfree_skb(skb);
-			continue;
-		}
+try_again:
+	skb = skb_recv_udp(sk, MSG_DONTWAIT, &err);
+	if (!skb)
+		return err;
 
-		WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
-		used = recv_actor(sk, skb);
-		if (used <= 0) {
-			if (!copied)
-				copied = used;
-			kfree_skb(skb);
-			break;
-		} else if (used <= skb->len) {
-			copied += used;
-		}
+	if (udp_lib_checksum_complete(skb)) {
+		int is_udplite = IS_UDPLITE(sk);
+		struct net *net = sock_net(sk);
 
+		__UDP_INC_STATS(net, UDP_MIB_CSUMERRORS, is_udplite);
+		__UDP_INC_STATS(net, UDP_MIB_INERRORS, is_udplite);
+		atomic_inc(&sk->sk_drops);
 		kfree_skb(skb);
-		break;
+		goto try_again;
 	}
 
+	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
+	copied = recv_actor(sk, skb);
+	kfree_skb(skb);
+
 	return copied;
 }
 EXPORT_SYMBOL(udp_read_skb);
-- 
2.20.1

