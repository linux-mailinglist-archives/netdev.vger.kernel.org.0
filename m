Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73344BB451
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232554AbiBRIeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:34:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiBRIdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:33:39 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690D72C647;
        Fri, 18 Feb 2022 00:33:23 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id y11so1787316pfa.6;
        Fri, 18 Feb 2022 00:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6+BkML9iaRNDFcXeRLhjMQPtsJIgMk1H7r/pJuUNY9w=;
        b=MKBu7mUkUf4BMB8MtRcQl0JJQUKrewgqpd5RM2/SP+IbZbugS7jkvwPWCEGaplJUWt
         3J8WUJTYTYk5okR56O9VSui9VfQDcIoxrCSVevjjc7wTAU78wwb4DH0dryzXYiF9OE86
         CM8nthfCB8DFS4xgPbydz6SLxURd9ic2OS3500fmyPTp+5qBRwEqeoioPo6LnIkUuQzn
         3siJTmTHqgSRorziOOTNnlpJ0VEW8qVNZzBpzPLYm5xV5QVQf3x0dDJYxEjWeqSdK6Ha
         0wQfEM1rLkP8v7i/0oJpqyYlXCaamFrLeQF2mTW3rIdFdhXQkFPXuztWEvSl7qZdA+Fm
         hWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6+BkML9iaRNDFcXeRLhjMQPtsJIgMk1H7r/pJuUNY9w=;
        b=vHitKh89jWGnigdjpigaN+bNaPBwV1mot1CeB4SgALL/5rMVgAu1z2Uv6TbgazoI8r
         q0kvRFbfEaBzdwQlVna09IHBd3g78zvpxiv4BeZP5Ou/Qzcuatc27664P6kkkjwWl128
         IiFxDM9s9VhnMOfj5g1LxCKFc56DrvcYg2JHagItPSuWxuaKJVMzHrrmB/06/CzFw7Gu
         gM7j0DAZnYwbRKQF7+FMSHhF9xJ8p6f+TFZHJXWQ/OIuAYkrzR5fT3IF2TdNVkyw0Zl/
         QUBlI7x6FTeIqOV03sRmckktmmeYyO9Wn9NTSFjHaog5Y9w7aunjLCEou4WyclGL4W2g
         S2+g==
X-Gm-Message-State: AOAM5306l24P9eTkJQ9Hv7PUgW2JexBcnBIS74j/40DCbe+EJt9UpZm5
        cxVczNocTdBF6gWuyurNQjI=
X-Google-Smtp-Source: ABdhPJy1zr2CdJu+Vb7q12ljdy+DnqtXWBVH9QP6pNXRZWCiz7WFlKSs4tlYRTE57gXTfBeafjtcNg==
X-Received: by 2002:a63:f055:0:b0:362:d557:2ccb with SMTP id s21-20020a63f055000000b00362d5572ccbmr5473790pgj.377.1645173202910;
        Fri, 18 Feb 2022 00:33:22 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m23sm1963530pff.201.2022.02.18.00.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:33:22 -0800 (PST)
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
Subject: [PATCH net-next v2 9/9] net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
Date:   Fri, 18 Feb 2022 16:31:33 +0800
Message-Id: <20220218083133.18031-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220218083133.18031-1-imagedong@tencent.com>
References: <20220218083133.18031-1-imagedong@tencent.com>
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
 include/linux/skbuff.h     |  4 ++++
 include/trace/events/skb.h |  1 +
 net/ipv4/tcp_input.c       | 10 ++++++----
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 554ef2c848ee..a3e90efe6586 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -376,6 +376,10 @@ enum skb_drop_reason {
 					 * the right edges of receive
 					 * window
 					 */
+	SKB_DROP_REASON_TCP_OFOMERGE,	/* the data of skb is already in
+					 * the ofo queue, corresponding to
+					 * LINUX_MIB_TCPOFOMERGE
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
index 0a4ca818d580..1fc422af11f8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -4779,7 +4779,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 	if (unlikely(tcp_try_rmem_schedule(sk, skb, skb->truesize))) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPOFODROP);
 		sk->sk_data_ready(sk);
-		tcp_drop(sk, skb);
+		tcp_drop_reason(sk, skb, SKB_DROP_REASON_PROTO_MEM);
 		return;
 	}
 
@@ -4842,7 +4842,8 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 				/* All the bits are present. Drop. */
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb);
+				tcp_drop_reason(sk, skb,
+						SKB_DROP_REASON_TCP_OFOMERGE);
 				skb = NULL;
 				tcp_dsack_set(sk, seq, end_seq);
 				goto add_sack;
@@ -4861,7 +4862,8 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
 						 TCP_SKB_CB(skb1)->end_seq);
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPOFOMERGE);
-				tcp_drop(sk, skb1);
+				tcp_drop_reason(sk, skb1,
+						SKB_DROP_REASON_TCP_OFOMERGE);
 				goto merge_right;
 			}
 		} else if (tcp_ooo_try_coalesce(sk, skb1,
@@ -4889,7 +4891,7 @@ static void tcp_data_queue_ofo(struct sock *sk, struct sk_buff *skb)
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

