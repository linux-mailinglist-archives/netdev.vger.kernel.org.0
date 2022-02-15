Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F8C4B6AED
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 12:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiBOLcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 06:32:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235210AbiBOLcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 06:32:03 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4F919C30;
        Tue, 15 Feb 2022 03:31:47 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso2459882pjt.4;
        Tue, 15 Feb 2022 03:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W5Xx1rlsjYhtyS/c0HXRmeHBBWJ3wfX66uoRpQ9UrCw=;
        b=gFkbyq+oUr4b9J1LKUZlR9gGtBmxwygLMAuwe+PV1haFkzloOqWo1huc6sjdpTNnDY
         ZRqCZNzh3IvR8/MqXyml3/0FYrBC9ukKsF7iOGATO1qn7NxHl/HuIiYpjngN8w56NPQP
         maMg84vhRXX1ZIxo4oSeSdM8MZUJ63HqW6yxdy2Mrja7wMWPLeeZuxonFjrJP3e8x3ZP
         tknLTriTjcjSQECyoP5cj3waL8PDLhxin6aJ551oX3Zxd9DkDpoB09T8z66Vh6T6qxHm
         HKeINFwFZpGHcQ4QGc06sCcccDsw5FVV9xZTwK18FObOQOh06TMBVSO2tR9VtUnRveJD
         R4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W5Xx1rlsjYhtyS/c0HXRmeHBBWJ3wfX66uoRpQ9UrCw=;
        b=OlEGYtGAbDrtv57sTcaElarAcVV3jmeVJ6GNxS6RggUcklebz0EotYN0ZzPxY4tCax
         FvoB0U/Gor3vOUrRX3DRkrizlb7qpb2jcpXsmDYJ5xZMdj80tKWAKWTmOZTWh+SnUW7y
         xxw6Nk5MTPJoAxGp0SG28yB2+GlSXE8adZdwbiIgqzOA1HZxvgrs73DTUMCJnmdsmdCA
         wagTZtbQ3Ice+ubpGoL+l8bMnqhObAp02R7Fcl+M2IS+nvnZBgLbiAA9voFBOyX+6PU7
         poChmlEvo8KuwQ5xkb4ZNV07jPVmPSujypo69Lovnum9YD7x8KxRwoNP59lo43O/ga/+
         d4/w==
X-Gm-Message-State: AOAM530pbiqx9rhqjDO0mNgasjCnVoSh7sKV7DYu/QOTYHldCFAIpEEd
        SliPxbMUVOkCvsxVHy000QM=
X-Google-Smtp-Source: ABdhPJxuuFQuA/oVWKAWC61fVgbWY56+La1nygHlqoesSt8l1wJIKNqO8L2bMkjHBn4hUKbwQ2gdYA==
X-Received: by 2002:a17:902:e851:: with SMTP id t17mr3785576plg.54.1644924706693;
        Tue, 15 Feb 2022 03:31:46 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id s11sm44515513pfu.58.2022.02.15.03.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 03:31:46 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     edumazet@google.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@redhat.com, yoshfuji@linux-ipv6.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        imagedong@tencent.com, talalahmad@google.com,
        keescook@chromium.org, ilias.apalodimas@linaro.org, alobakin@pm.me,
        memxor@gmail.com, atenart@kernel.org, bigeasy@linutronix.de,
        pabeni@redhat.com, linyunsheng@huawei.com, arnd@arndb.de,
        yajun.deng@linux.dev, roopa@nvidia.com, willemb@google.com,
        vvs@virtuozzo.com, cong.wang@bytedance.com,
        luiz.von.dentz@intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: [PATCH net-next 09/19] net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
Date:   Tue, 15 Feb 2022 19:28:02 +0800
Message-Id: <20220215112812.2093852-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220215112812.2093852-1-imagedong@tencent.com>
References: <20220215112812.2093852-1-imagedong@tencent.com>
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

Replace tcp_drop() used in tcp_data_queue_ofo with tcp_drop_reason().
Following drop reasons are introduced:

SKB_DROP_REASON_TCP_OFOMERGE

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  3 +++
 include/trace/events/skb.h |  1 +
 net/ipv4/tcp_input.c       | 10 ++++++----
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 62a0d7d78f6f..73ed01d87e43 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -371,6 +371,9 @@ enum skb_drop_reason {
 					 * the right edges of receive
 					 * window
 					 */
+	SKB_DROP_REASON_TCP_OFOMERGE,	/* the data of skb is already in
+					 * the ofo queue.
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index cc1c8f7eaf72..2ab7193313aa 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -36,6 +36,7 @@
 	EM(SKB_DROP_REASON_TCP_ZEROWINDOW, TCP_ZEROWINDOW)	\
 	EM(SKB_DROP_REASON_TCP_OLD_DATA, TCP_OLD_DATA)		\
 	EM(SKB_DROP_REASON_TCP_OVERWINDOW, TCP_OVERWINDOW)	\
+	EM(SKB_DROP_REASON_TCP_OFOMERGE, TCP_OFOMERGE)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c042711fb5a2..cb6ad47733f1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4782,7 +4782,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		sk->sk_data_ready(sk);
-		tcp_drop(sk, skb);
+		tcp_drop_reason(sk, skb, SKB_DROP_REASON_PROTO_MEM);
 		return;
 	}
 
@@ -4845,7 +4845,8 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 				/* All the bits are present. Drop. */
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb);
+				tcp_drop_reason(sk, skb,
+						SKB_DROP_REASON_TCP_OFOMERGE);
 				skb = NULL;
 				tcp_dsack_set(sk, seq, end_seq);
 				goto add_sack;
@@ -4864,7 +4865,8 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						 TCP_SKB_CB(skb1)->end_seq);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb1);
+				tcp_drop_reason(sk, skb1,
+						SKB_DROP_REASON_TCP_OFOMERGE);
 				goto merge_right;
 			}
 		} else if (tcp_ooo_try_coalesce(sk, skb1,
@@ -4892,7 +4894,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 		tcp_dsack_extend(sk, TCP_SKB_CB(skb1)->seq,
 				 TCP_SKB_CB(skb1)->end_seq);
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFOMERGE);
-		tcp_drop(sk, skb1);
+		tcp_drop_reason(sk, skb1, SKB_DROP_REASON_TCP_OFOMERGE);
 	}
 	/* If there is no skb after us, we are the last_skb ! */
 	if (!skb1)
-- 
2.34.1

