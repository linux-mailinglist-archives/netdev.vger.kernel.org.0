Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E634BB442
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbiBRId1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:33:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232654AbiBRIdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:33:06 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FBA2DD44;
        Fri, 18 Feb 2022 00:32:48 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id s16so7216389pgs.13;
        Fri, 18 Feb 2022 00:32:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t1JcfESLshia0hfZycViI4NCFCf3p6OKuHoudYWw9ZA=;
        b=nW1lmzUWrykSgiE/tTu7hLPrzSoBOmVu8KhT2CwzKOtoEltuMIChHFFssB84S2vJle
         +i7nMinoTX1xU6o3XQmn9HBfT/HC3R5oYYB/wdWB+fgAL//7DZqE0h2Zw4BSNRbfES3U
         M+w4/aHF1aO11jpwOMaOW8Xl3hJFr5h0aKZUpHefWt+ZkmkVpBM5IBgEVtoZSKPFClgv
         LBKX3ZitBWt9+cGHaq+ne6b0C1lWsKhtpVAttUQcHdXb4F1xHIFWzVdSEZwpsvFxIt9W
         rzMJ5dunERiioXDPTFJ47f/ZxmLoh5VbGw/maw60xDhS5qw/+MAdmnRVTC1RNjGekzwX
         g41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t1JcfESLshia0hfZycViI4NCFCf3p6OKuHoudYWw9ZA=;
        b=IeVlCLd3mTwl/xQZJggQuJyZI5yHit3cqvZDdPQFpljEsMfjj+LgZuJUzgDWRxRFxN
         Wq0V5a/65u80qXYDa3kYgD3WGTetoKG535tQiZJDZPmpuYtWalwCeAjdBfF63lzbaZr7
         aQo4nIrvU7O3Ha8AtMMy+h7ACEb+yRfyuHJWGMDnTxhk/NgrGV5D9ozwhY99m6nK0CkH
         sAeoRRo+qy5xxkj7tVCiirM+QpjAMgecp4sL83CmUjaQxBkQAI3tBXSSu6cXBsN/Hz7K
         a6GdAR8o/U7nxoCut/KXFqKznbqDHEfh9FTMSJrZDiht5TEoaXeSlAJlSDqKuOFGMyEB
         qUXA==
X-Gm-Message-State: AOAM5326Avp2Ixsj99Z+JPaaerTtTsFwBdsTe1H6kH+R0U9Eu76hT7MQ
        d5+6hyFjoLxx4fzDiKSBWC8=
X-Google-Smtp-Source: ABdhPJyYZfppkZR2mWdHy47N4ktkhPj+VteDGTdrW+jkzIQv2uBzjpPCaa3OsFgd0fNHyFwLdijFJg==
X-Received: by 2002:a63:3202:0:b0:365:84d4:4705 with SMTP id y2-20020a633202000000b0036584d44705mr5453321pgy.201.1645173168382;
        Fri, 18 Feb 2022 00:32:48 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.113])
        by smtp.gmail.com with ESMTPSA id m23sm1963530pff.201.2022.02.18.00.32.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Feb 2022 00:32:47 -0800 (PST)
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
Subject: [PATCH net-next v2 4/9] net: tcp: add skb drop reasons to tcp_v{4,6}_inbound_md5_hash()
Date:   Fri, 18 Feb 2022 16:31:28 +0800
Message-Id: <20220218083133.18031-5-imagedong@tencent.com>
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

Pass the address of drop reason to tcp_v4_inbound_md5_hash() and
tcp_v6_inbound_md5_hash() to store the reasons for skb drops when this
function fails. Therefore, the drop reason can be passed to
kfree_skb_reason() when the skb needs to be freed.

Following drop reasons are added:

SKB_DROP_REASON_TCP_MD5NOTFOUND
SKB_DROP_REASON_TCP_MD5UNEXPECTED
SKB_DROP_REASON_TCP_MD5FAILURE

SKB_DROP_REASON_TCP_MD5* above correspond to LINUX_MIB_TCPMD5*

Signed-off-by: Menglong Dong <imagedong@tencent.com>
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
2.34.1

