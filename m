Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FECE4B7EF9
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245377AbiBPDzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:55:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245303AbiBPDzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:55:36 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3F9F9FBB;
        Tue, 15 Feb 2022 19:55:25 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id w1so1010558plb.6;
        Tue, 15 Feb 2022 19:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uARmFS+nDgVE7FjyHb31xPiMhFDOkZcIRfsfMlKqLac=;
        b=W96QghDLRJIgptWu4fLEMODL2iUGYfI4s3l4lvFDiXDSrEvA/mlAm/2CSJMMiH6eAF
         G/ndqkuVU1lBgmS1KauITrngRxBTOO7ZmOiUGlC0AAs36nPJ3Rlc/PcdFzb5WAfJfBGG
         ZwcKGVDsohurDx68zH7ejZB+gwyHf6HwciBC0vjZZlpUqu5XlnrP8UejqAjw52kgRuAu
         15GbVrQuJyFRE7rrBVdutCwo/ZhBkEndnfx5ed+pWaZ22uOr1DVun/i+yR36PlAk2iVz
         PMcVT40lTwY24SdHCKQrqcMB8w963C/wATNlhrsOEJaXntewnE7p3nN580sXkA8GV/6V
         Dayg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uARmFS+nDgVE7FjyHb31xPiMhFDOkZcIRfsfMlKqLac=;
        b=jXCggllJXsb8S9U8oTKmgadObZR+yfRpewaU0FHk1lCl+QlETQpvlkM7RLuz9JaS7m
         JlVwri7QGr8NMxsmjm5sIljsVJrydoUH3P7+8CVLeIUvyTvOHHdxRQIw3uqLwD5q6c8b
         WKJ71wwytw1mPsfUX0qoMyl/qp9pdI72cNHLJ1vUhtYClDKOwvfpPZqp4fNT52mUYiXQ
         nlZ7CXu5eipKrSku0IBbMlIkFlhxS9X7zf3MmLghFp4c6m25+4N5pXGMe4hfvVsX/qRz
         fl3gqghDaxE1ZoyS6RvBP4zLyJBrIGQQgGrkGqt8A8FeFGg4ofp+qmNidF4Alzr6SkU9
         IYVQ==
X-Gm-Message-State: AOAM5315XyLwR+A0kx03oZTsTB9q530gsH+8yE/9nbU710pvZzuw+B60
        ad6Kiu/YJO5oPZWcvR3vA8s=
X-Google-Smtp-Source: ABdhPJzzXzNKb20ALtRnB5E0498QAT9AuCFhOJIFPSwXlB2hv+ZJhavO+aqLDae0QQncv5sQGsJQ3Q==
X-Received: by 2002:a17:90a:6943:b0:1b9:e285:e4a3 with SMTP id j3-20020a17090a694300b001b9e285e4a3mr731452pjm.153.1644983724948;
        Tue, 15 Feb 2022 19:55:24 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.gmail.com with ESMTPSA id nn16sm19099668pjb.2.2022.02.15.19.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 19:55:24 -0800 (PST)
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
Subject: [PATCH net-next 4/9] net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
Date:   Wed, 16 Feb 2022 11:54:21 +0800
Message-Id: <20220216035426.2233808-5-imagedong@tencent.com>
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

Pass the address of drop reason to tcp_v4_inbound_md5_hash() and
tcp_v6_inbound_md5_hash() to store the reasons for skb drops when this
function fails. Therefore, the drop reason can be passed to
kfree_skb_reason() when the skb needs to be freed.

Following drop reasons are added:

SKB_DROP_REASON_TCP_MD5NOTFOUND
SKB_DROP_REASON_TCP_MD5UNEXPECTED
SKB_DROP_REASON_TCP_MD5FAILURE

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  7 +++++++
 include/trace/events/skb.h |  4 ++++
 net/ipv4/tcp_ipv4.c        | 13 +++++++++----
 net/ipv6/tcp_ipv6.c        | 11 ++++++++---
 4 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a5adbf6b51e8..aea46b38cffa 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -346,6 +346,13 @@ enum skb_drop_reason {
 					 * udp packet drop out of
 					 * udp_memory_allocated.
 					 */
+	SKB_DROP_REASON_TCP_MD5NOTFOUND,	/* No MD5 hash and one
+						 * expected
+						 */
+	SKB_DROP_REASON_TCP_MD5UNEXPECTED,	/* MD5 hash and we're not
+						 * expecting one
+						 */
+	SKB_DROP_REASON_TCP_MD5FAILURE,	/* MD5 hash and its wrong */
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
index a93921fb498f..3e7ab605dddc 100644
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
index 402ffbacc371..dfefbc1eac5d 100644
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
2.34.1

