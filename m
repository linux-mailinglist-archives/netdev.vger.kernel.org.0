Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74F24B7EF1
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245622AbiBPD4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:56:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245598AbiBPD4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:56:18 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF41100755;
        Tue, 15 Feb 2022 19:56:00 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id c10so1075504pfv.8;
        Tue, 15 Feb 2022 19:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZjE2za8E6rbwX5jEVaF9Cp+T5JL4P0j5o1dlD0LxMeg=;
        b=Cg+Cbe4EpSorYD3QMbtbyA5bvY5hKIEjZ5VaFTUETucTnBj939nbRgCHC0bvcl+VnG
         clt124pEC81A2FUP3bl4GY8gwSd2OEeMrL6TPCVCZIryyLKZExLeL0Y2GE+fsmn34c3Y
         fNsgMH+2lAV3ouV6R9Z8URryC21fpD+vokBpVfQTdXJspqsEH9GulhS+sHqAsqk6T6TU
         na9u0fPQywZEVHhwIebVXYonbf66e2wyNIHnScRWru/gsfLWAGq2Y3T0O1JjrIlSjQ9d
         HEROXOOjhxae/J+5LGep+Zlf5vIPrtIW50txM+ItUsrpBLtUIwxSOCv0M9MvsP34hbPl
         fFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZjE2za8E6rbwX5jEVaF9Cp+T5JL4P0j5o1dlD0LxMeg=;
        b=wBvXeBvULFRHb+qSjGPzooPhZifCHoIdqN/ZZFS/oxRhttK7bxuVGgaZQnQV3aXANL
         bkJPlI21L3YosQxbr4cCOI6oGduNCH6VXHakLwx9JapZN+CyiUwG5Hi9P7T3oGYH5aKp
         THDiR8Zaukf881ebkPGpFPBadMpn1rTRZfxgQmd2+ouJzwv4YJcmprwJl8mphs1n3fpE
         mfHhCHvprjGh1IVjGVsPf7RSY5HZsZ9pZjOQJJUymu2zQErimNWhsmm8GZAnmUU9LNBE
         0bbl8JsfyEfIcH6o/Jtswp0DCe1a5zF7L6h2RAEAWWENO19mqdPXQYIkNsLgb21EK/IA
         TVmg==
X-Gm-Message-State: AOAM532KRW76uhiaRoy1dWXVkMZBboaRfNYLT+nIba6RdQ/Snvb5CWTJ
        ce1bGFLQGjetrsQOq8WMTuE=
X-Google-Smtp-Source: ABdhPJzdAVEDWvBUtRoWX8Ol5FNdxdQRWpFxv1xoWcExFOcyHL8l1GJItbEqfdyR78j5Xs0u0+tVQQ==
X-Received: by 2002:a63:1651:0:b0:342:b566:57c4 with SMTP id 17-20020a631651000000b00342b56657c4mr712433pgw.258.1644983760278;
        Tue, 15 Feb 2022 19:56:00 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:59 -0800 (PST)
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
Subject: [PATCH net-next 9/9] net: tcp: use tcp_drop_reason() for tcp_data_queue_ofo()
Date:   Wed, 16 Feb 2022 11:54:26 +0800
Message-Id: <20220216035426.2233808-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220216035426.2233808-1-imagedong@tencent.com>
References: <20220216035426.2233808-1-imagedong@tencent.com>
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

