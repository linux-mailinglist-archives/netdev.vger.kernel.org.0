Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F3E4BCD00
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 08:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237533AbiBTHId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 02:08:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243004AbiBTHIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 02:08:31 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3F74D9C8;
        Sat, 19 Feb 2022 23:08:11 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id y16so3995094pjt.0;
        Sat, 19 Feb 2022 23:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mDOubhNw/a9sRYXV+7JLa5rcAVT46EltzMksSTCmpVE=;
        b=qVAh4qGNhC5Od0Ow7mFYPpH2xhkeLpm8qA91VpEhs6y5uNT+gsJbr9EO33iXR6IT37
         ity1CEfMUCEkru6df2stgj17shjKriWCRQf5AiZWzHqbmELmXR6TuKY4DTAGvTpqFbxa
         Up5aoKKdV+uRL1mVjT2N0DVOhWlR3DxLOMVVV2C++LHFJ++NbwJzrXSGl8lhkiynrB3Z
         DSqyvI8PpqyffOIPxLMs3j7AC94dDIYahJ3ozi4zqJ8M18VKFsR9OA7UD7Tl0USEyy1F
         oCT5DH/fe2nfUWa+8og9Vn8j8R7g4Mdgecz5csdV16T/LQwT5OMwYombFTWE9Ftjp1uA
         xPtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mDOubhNw/a9sRYXV+7JLa5rcAVT46EltzMksSTCmpVE=;
        b=dI4FlbUXq2GXgcn6yiG827pTzrnKHYbzwt0m90vX2Z0PHwOXkS22y5gH0bcG+uaBJQ
         fDRum3p6OQMWekUCKi6kcCjE0pTrwi8+q/Icy6XdXaLCI4Z2u24jflOW9wfgBeTb0evX
         ugHDLmkELdLe92J+9pms+McBo8pqda2p+nnNjZcZGV3CEwdwk34qBmqLvw6WgPuzmGsW
         vtMuCvM/S7GLBEg/Tjr278TzZMNAVXog073owZUtAdhEMWv1Q/f8+Qyk55iErQ8Hh6Lz
         yPsaemFU4PN42JL8R7wpNtYDZlAeup8+50hl4mSGrT7yzHL+Iqbamw0pqseC6tKYzSNT
         le/A==
X-Gm-Message-State: AOAM533wofq6PsFwBsUL/959pxUpjF4K8SO6KjfDVha4iCyDjLR4USaC
        jnzu2hAREHOvbUCN4DVdb88=
X-Google-Smtp-Source: ABdhPJwPXkbhp0gJiSoqko7WLsRVz+OFZrAwazZBvBklxjQ3oVRyVUNEcKKzxFlUJi6Sxhqyc0p3Zw==
X-Received: by 2002:a17:902:f711:b0:14d:61ba:8baf with SMTP id h17-20020a170902f71100b0014d61ba8bafmr14244325plo.39.1645340890856;
        Sat, 19 Feb 2022 23:08:10 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id p1sm8351326pfo.212.2022.02.19.23.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 23:08:10 -0800 (PST)
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
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        flyingpeng@tencent.com, mengensun@tencent.com
Subject: [PATCH net-next v3 4/9] net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
Date:   Sun, 20 Feb 2022 15:06:32 +0800
Message-Id: <20220220070637.162720-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220220070637.162720-1-imagedong@tencent.com>
References: <20220220070637.162720-1-imagedong@tencent.com>
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

Pass the address of drop reason to tcp_v4_inbound_md5_hash() and
tcp_v6_inbound_md5_hash() to store the reasons for skb drops when this
function fails. Therefore, the drop reason can be passed to
kfree_skb_reason() when the skb needs to be freed.

Following drop reasons are added:

SKB_DROP_REASON_TCP_MD5NOTFOUND
SKB_DROP_REASON_TCP_MD5UNEXPECTED
SKB_DROP_REASON_TCP_MD5FAILURE

SKB_DROP_REASON_TCP_MD5* above correspond to LINUX_MIB_TCPMD5*

Reviewed-by: Mengen Sun <mengensun@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 include/linux/skbuff.h     | 12 ++++++++++++
 include/trace/events/skb.h |  4 ++++
 net/ipv4/tcp_ipv4.c        | 13 +++++++++----
 net/ipv6/tcp_ipv6.c        | 11 ++++++++---
 4 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a5adbf6b51e8..46678eb587ff 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -346,6 +346,18 @@ enum skb_drop_reason {
 					 * udp packet drop out of
 					 * udp_memory_allocated.
 					 */
+	SKB_DROP_REASON_TCP_MD5NOTFOUND,	/* no MD5 hash and one
+						 * expected, corresponding
+						 * to LINUX_MIB_TCPMD5NOTFOUND
+						 */
+	SKB_DROP_REASON_TCP_MD5UNEXPECTED,	/* MD5 hash and we're not
+						 * expecting one, corresponding
+						 * to LINUX_MIB_TCPMD5UNEXPECTED
+						 */
+	SKB_DROP_REASON_TCP_MD5FAILURE,	/* MD5 hash and its wrong,
+					 * corresponding to
+					 * LINUX_MIB_TCPMD5FAILURE
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index cfcfd26399f7..46c06b0be850 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -27,6 +27,10 @@
 	EM(SKB_DROP_REASON_IP_NOPROTO, IP_NOPROTO)		\
 	EM(SKB_DROP_REASON_SOCKET_RCVBUFF, SOCKET_RCVBUFF)	\
 	EM(SKB_DROP_REASON_PROTO_MEM, PROTO_MEM)		\
+	EM(SKB_DROP_REASON_TCP_MD5NOTFOUND, TCP_MD5NOTFOUND)	\
+	EM(SKB_DROP_REASON_TCP_MD5UNEXPECTED,			\
+	   TCP_MD5UNEXPECTED)					\
+	EM(SKB_DROP_REASON_TCP_MD5FAILURE, TCP_MD5FAILURE)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index a3beab01e9a7..d3c417119057 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1412,7 +1412,8 @@ EXPORT_SYMBOL(tcp_v4_md5_hash_skb);
 /* Called with rcu_read_lock() */
 static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 				    const struct sk_buff *skb,
-				    int dif, int sdif)
+				    int dif, int sdif,
+				    enum skb_drop_reason *reason)
 {
 #ifdef CONFIG_TCP_MD5SIG
 	/*
@@ -1445,11 +1446,13 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 		return false;
 
 	if (hash_expected && !hash_location) {
+		*reason = SKB_DROP_REASON_TCP_MD5NOTFOUND;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
 		return true;
 	}
 
 	if (!hash_expected && hash_location) {
+		*reason = SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
 		return true;
 	}
@@ -1462,6 +1465,7 @@ static bool tcp_v4_inbound_md5_hash(const struct sock *sk,
 				      NULL, skb);
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+		*reason = SKB_DROP_REASON_TCP_MD5FAILURE;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		net_info_ratelimited("MD5 Hash failed for (%pI4, %d)->(%pI4, %d)%s L3 index %d\n",
 				     &iph->saddr, ntohs(th->source),
@@ -1971,13 +1975,13 @@ static void tcp_v4_fill_cb(struct sk_buff *skb, const struct iphdr *iph,
 int tcp_v4_rcv(struct sk_buff *skb)
 {
 	struct net *net = dev_net(skb->dev);
+	enum skb_drop_reason drop_reason;
 	int sdif = inet_sdif(skb);
 	int dif = inet_iif(skb);
 	const struct iphdr *iph;
 	const struct tcphdr *th;
 	bool refcounted;
 	struct sock *sk;
-	int drop_reason;
 	int ret;
 
 	drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
@@ -2025,7 +2029,8 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))) {
+		if (unlikely(tcp_v4_inbound_md5_hash(sk, skb, dif, sdif,
+						     &drop_reason))) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -2099,7 +2104,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif))
+	if (tcp_v4_inbound_md5_hash(sk, skb, dif, sdif, &drop_reason))
 		goto discard_and_relse;
 
 	nf_reset_ct(skb);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 0aa17073df1a..1262b790b146 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -775,7 +775,8 @@ static int tcp_v6_md5_hash_skb(char *md5_hash,
 
 static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 				    const struct sk_buff *skb,
-				    int dif, int sdif)
+				    int dif, int sdif,
+				    enum skb_drop_reason *reason)
 {
 #ifdef CONFIG_TCP_MD5SIG
 	const __u8 *hash_location = NULL;
@@ -798,11 +799,13 @@ static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 		return false;
 
 	if (hash_expected && !hash_location) {
+		*reason = SKB_DROP_REASON_TCP_MD5NOTFOUND;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5NOTFOUND);
 		return true;
 	}
 
 	if (!hash_expected && hash_location) {
+		*reason = SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
 		return true;
 	}
@@ -813,6 +816,7 @@ static bool tcp_v6_inbound_md5_hash(const struct sock *sk,
 				      NULL, skb);
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
+		*reason = SKB_DROP_REASON_TCP_MD5FAILURE;
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
 		net_info_ratelimited("MD5 Hash %s for [%pI6c]:%u->[%pI6c]:%u L3 index %d\n",
 				     genhash ? "failed" : "mismatch",
@@ -1681,7 +1685,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		struct sock *nsk;
 
 		sk = req->rsk_listener;
-		if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif)) {
+		if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif,
+					    &drop_reason)) {
 			sk_drops_add(sk, skb);
 			reqsk_put(req);
 			goto discard_it;
@@ -1752,7 +1757,7 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 		goto discard_and_relse;
 	}
 
-	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif))
+	if (tcp_v6_inbound_md5_hash(sk, skb, dif, sdif, &drop_reason))
 		goto discard_and_relse;
 
 	if (tcp_filter(sk, skb)) {
-- 
2.35.1

