Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 733F54D80C2
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 12:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238977AbiCNLeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 07:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238976AbiCNLeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 07:34:15 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF548140B9;
        Mon, 14 Mar 2022 04:33:01 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id z12-20020a17090ad78c00b001bf022b69d6so14201685pju.2;
        Mon, 14 Mar 2022 04:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g2mjjBED1Ll+wsWZ2eDde9aCbIt30NWlr5LqfZq48UI=;
        b=cgfg8RiMtG4Wof3AuqsZK8RoZf/3Txz1JEehHSI9pnDScQEnUPR0IBJhPk0JWMpUKB
         huC3uEEWanc7GUeLOk+Msmo0a4WdM3bWpxySWcpQbnE68dl8islfU5cFxXE30uhbLwtj
         OamVe7O4Lp65ux+uuSUdk91dHT/xZ+8cRTGgLZzYtfhhtG9z0+nt25QNHNYrzFNE83vM
         69oq+s0DjVkUBLcGynAziDg6s0BZyPaE7L2P9ENiltSW1VBGVLN6dyspAO0yWyYcXnR4
         WWLnbRINNhk4hKu6hhRPp8WTB6UNSUnBa0sopl+QGBHpclW0+uET9+E89yZDkKmX+Ncl
         Jjuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=g2mjjBED1Ll+wsWZ2eDde9aCbIt30NWlr5LqfZq48UI=;
        b=Ek3YkgWJlmeZH+vpyq9JvgjVBGl7FaardKxnld26TtuCmXR6uRipN31pYm3GdlLCcc
         5jooTz7v345h1KHJXDsBKVVJ4gJTqI9sxA2DNw80dEk5mmqNRmFBW9J60pCwFJiXqouy
         SCbT1JO5kfaCnwvy3NpVA78KWbcn4OfnWAGrIdC0duyT9a83v7LovWfWfXL2nW3MJO4w
         /FRmsdrac8wLqK9afW+1lw8gcPKQqdbK3csQc+g/kQ8uJuxkhxwVPPveG7iJbYB5OnsG
         UuTSXqd3MEhWacYiiiPVXEApYF+4BkiNNv8Nc2yZ2LBZArkJc23WwfCm2KXH2u5COaIy
         eI2g==
X-Gm-Message-State: AOAM532gsY/qMs6FcR7pf1szivBPGjPrZsnYFaY2zq7ZpteneWLWWzFt
        00SS6qE5XZ1+/neUOLPX3Hk=
X-Google-Smtp-Source: ABdhPJzw/k3I1mxQ2gNbBMkUuS2cR5cJZkVOlOEIdqgMMgIBV8p6TmwHHI00FvGm+lGxHeTruHsazQ==
X-Received: by 2002:a17:90a:5302:b0:1b9:ba0a:27e5 with SMTP id x2-20020a17090a530200b001b9ba0a27e5mr34918779pjh.91.1647257580459;
        Mon, 14 Mar 2022 04:33:00 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id l2-20020a056a0016c200b004f7e3181a41sm2645197pfc.98.2022.03.14.04.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:33:00 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     davem@davemloft.net, rostedt@goodmis.org, mingo@redhat.com,
        yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, kafai@fb.com, talalahmad@google.com,
        keescook@chromium.org, alobakin@pm.me, dongli.zhang@oracle.com,
        pabeni@redhat.com, maze@google.com, aahringo@redhat.com,
        weiwan@google.com, yangbo.lu@nxp.com, fw@strlen.de,
        tglx@linutronix.de, rpalethorpe@suse.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: icmp: add reasons of the skb drops to icmp protocol
Date:   Mon, 14 Mar 2022 19:32:25 +0800
Message-Id: <20220314113225.151959-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314113225.151959-1-imagedong@tencent.com>
References: <20220314113225.151959-1-imagedong@tencent.com>
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

Replace kfree_skb() used in icmp_rcv() and icmpv6_rcv() with
kfree_skb_reason().

In order to get the reasons of the skb drops after icmp message handle,
we change the return type of 'handler()' in 'struct icmp_control' from
'bool' to 'enum skb_drop_reason'. This may change its original
intention, as 'false' means failure, but 'SKB_NOT_DROPPED_YET' means
success now. Following functions are involved:

icmp_unreach()
icmp_redirect()
icmp_echo()
icmp_timestamp()
icmp_discard()

And following new drop reasons are added:

SKB_DROP_REASON_ICMP_CSUM
SKB_DROP_REASON_ICMP_TYPE
SKB_DROP_REASON_ICMP_BROADCAST

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  5 +++
 include/net/ping.h         |  2 +-
 include/trace/events/skb.h |  3 ++
 net/ipv4/icmp.c            | 75 ++++++++++++++++++++++----------------
 net/ipv4/ping.c            | 14 ++++---
 net/ipv6/icmp.c            | 24 +++++++-----
 6 files changed, 76 insertions(+), 47 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 26538ceb4b01..18c678b340d3 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -444,6 +444,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented
 					 * at tun/tap, e.g., check_filter()
 					 */
+	SKB_DROP_REASON_ICMP_CSUM,	/* ICMP checksum error */
+	SKB_DROP_REASON_ICMP_TYPE,	/* unknown ICMP type */
+	SKB_DROP_REASON_ICMP_BROADCAST,	/* unacceptable broadcast(multicast)
+					 * ICMP message
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/net/ping.h b/include/net/ping.h
index 2fe78874318c..b68fbfdb606f 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -76,7 +76,7 @@ int  ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 int  ping_common_sendmsg(int family, struct msghdr *msg, size_t len,
 			 void *user_icmph, size_t icmph_len);
 int  ping_queue_rcv_skb(struct sock *sk, struct sk_buff *skb);
-bool ping_rcv(struct sk_buff *skb);
+enum skb_drop_reason ping_rcv(struct sk_buff *skb);
 
 #ifdef CONFIG_PROC_FS
 void *ping_seq_start(struct seq_file *seq, loff_t *pos, sa_family_t family);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index e1670e1e4934..70d0dac8e08b 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -61,6 +61,9 @@
 	EM(SKB_DROP_REASON_HDR_TRUNC, HDR_TRUNC)		\
 	EM(SKB_DROP_REASON_TAP_FILTER, TAP_FILTER)		\
 	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
+	EM(SKB_DROP_REASON_ICMP_CSUM, ICMP_CSUM)		\
+	EM(SKB_DROP_REASON_ICMP_TYPE, ICMP_TYPE)		\
+	EM(SKB_DROP_REASON_ICMP_BROADCAST, ICMP_BROADCAST)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 72a375c7f417..97e53f86b14b 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -186,7 +186,7 @@ EXPORT_SYMBOL(icmp_err_convert);
  */
 
 struct icmp_control {
-	bool (*handler)(struct sk_buff *skb);
+	enum skb_drop_reason (*handler)(struct sk_buff *skb);
 	short   error;		/* This ICMP is classed as an error message */
 };
 
@@ -839,8 +839,9 @@ static bool icmp_tag_validation(int proto)
  *	ICMP_PARAMETERPROB.
  */
 
-static bool icmp_unreach(struct sk_buff *skb)
+static enum skb_drop_reason icmp_unreach(struct sk_buff *skb)
 {
+	enum skb_drop_reason reason = SKB_NOT_DROPPED_YET;
 	const struct iphdr *iph;
 	struct icmphdr *icmph;
 	struct net *net;
@@ -860,8 +861,10 @@ static bool icmp_unreach(struct sk_buff *skb)
 	icmph = icmp_hdr(skb);
 	iph   = (const struct iphdr *)skb->data;
 
-	if (iph->ihl < 5) /* Mangled header, drop. */
+	if (iph->ihl < 5)  { /* Mangled header, drop. */
+		reason = SKB_DROP_REASON_IP_INHDR;
 		goto out_err;
+	}
 
 	switch (icmph->type) {
 	case ICMP_DEST_UNREACH:
@@ -941,10 +944,10 @@ static bool icmp_unreach(struct sk_buff *skb)
 	icmp_socket_deliver(skb, info);
 
 out:
-	return true;
+	return reason;
 out_err:
 	__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
-	return false;
+	return reason ?: SKB_DROP_REASON_NOT_SPECIFIED;
 }
 
 
@@ -952,20 +955,20 @@ static bool icmp_unreach(struct sk_buff *skb)
  *	Handle ICMP_REDIRECT.
  */
 
-static bool icmp_redirect(struct sk_buff *skb)
+static enum skb_drop_reason icmp_redirect(struct sk_buff *skb)
 {
 	if (skb->len < sizeof(struct iphdr)) {
 		__ICMP_INC_STATS(dev_net(skb->dev), ICMP_MIB_INERRORS);
-		return false;
+		return SKB_DROP_REASON_PKT_TOO_SMALL;
 	}
 
 	if (!pskb_may_pull(skb, sizeof(struct iphdr))) {
 		/* there aught to be a stat */
-		return false;
+		return SKB_DROP_REASON_NOMEM;
 	}
 
 	icmp_socket_deliver(skb, ntohl(icmp_hdr(skb)->un.gateway));
-	return true;
+	return SKB_NOT_DROPPED_YET;
 }
 
 /*
@@ -982,7 +985,7 @@ static bool icmp_redirect(struct sk_buff *skb)
  *	See also WRT handling of options once they are done and working.
  */
 
-static bool icmp_echo(struct sk_buff *skb)
+static enum skb_drop_reason icmp_echo(struct sk_buff *skb)
 {
 	struct icmp_bxm icmp_param;
 	struct net *net;
@@ -990,7 +993,7 @@ static bool icmp_echo(struct sk_buff *skb)
 	net = dev_net(skb_dst(skb)->dev);
 	/* should there be an ICMP stat for ignored echos? */
 	if (net->ipv4.sysctl_icmp_echo_ignore_all)
-		return true;
+		return SKB_NOT_DROPPED_YET;
 
 	icmp_param.data.icmph	   = *icmp_hdr(skb);
 	icmp_param.skb		   = skb;
@@ -1001,10 +1004,10 @@ static bool icmp_echo(struct sk_buff *skb)
 	if (icmp_param.data.icmph.type == ICMP_ECHO)
 		icmp_param.data.icmph.type = ICMP_ECHOREPLY;
 	else if (!icmp_build_probe(skb, &icmp_param.data.icmph))
-		return true;
+		return SKB_NOT_DROPPED_YET;
 
 	icmp_reply(&icmp_param, skb);
-	return true;
+	return SKB_NOT_DROPPED_YET;
 }
 
 /*	Helper for icmp_echo and icmpv6_echo_reply.
@@ -1122,7 +1125,7 @@ EXPORT_SYMBOL_GPL(icmp_build_probe);
  *		  MUST be accurate to a few minutes.
  *		  MUST be updated at least at 15Hz.
  */
-static bool icmp_timestamp(struct sk_buff *skb)
+static enum skb_drop_reason icmp_timestamp(struct sk_buff *skb)
 {
 	struct icmp_bxm icmp_param;
 	/*
@@ -1147,17 +1150,17 @@ static bool icmp_timestamp(struct sk_buff *skb)
 	icmp_param.data_len	   = 0;
 	icmp_param.head_len	   = sizeof(struct icmphdr) + 12;
 	icmp_reply(&icmp_param, skb);
-	return true;
+	return SKB_NOT_DROPPED_YET;
 
 out_err:
 	__ICMP_INC_STATS(dev_net(skb_dst(skb)->dev), ICMP_MIB_INERRORS);
-	return false;
+	return SKB_DROP_REASON_PKT_TOO_SMALL;
 }
 
-static bool icmp_discard(struct sk_buff *skb)
+static enum skb_drop_reason icmp_discard(struct sk_buff *skb)
 {
 	/* pretend it was a success */
-	return true;
+	return SKB_NOT_DROPPED_YET;
 }
 
 /*
@@ -1165,18 +1168,20 @@ static bool icmp_discard(struct sk_buff *skb)
  */
 int icmp_rcv(struct sk_buff *skb)
 {
-	struct icmphdr *icmph;
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct rtable *rt = skb_rtable(skb);
 	struct net *net = dev_net(rt->dst.dev);
-	bool success;
+	struct icmphdr *icmph;
 
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb)) {
 		struct sec_path *sp = skb_sec_path(skb);
 		int nh;
 
 		if (!(sp && sp->xvec[sp->len - 1]->props.flags &
-				 XFRM_STATE_ICMP))
+				 XFRM_STATE_ICMP)) {
+			reason = SKB_DROP_REASON_XFRM_POLICY;
 			goto drop;
+		}
 
 		if (!pskb_may_pull(skb, sizeof(*icmph) + sizeof(struct iphdr)))
 			goto drop;
@@ -1184,8 +1189,11 @@ int icmp_rcv(struct sk_buff *skb)
 		nh = skb_network_offset(skb);
 		skb_set_network_header(skb, sizeof(*icmph));
 
-		if (!xfrm4_policy_check_reverse(NULL, XFRM_POLICY_IN, skb))
+		if (!xfrm4_policy_check_reverse(NULL, XFRM_POLICY_IN,
+						skb)) {
+			reason = SKB_DROP_REASON_XFRM_POLICY;
 			goto drop;
+		}
 
 		skb_set_network_header(skb, nh);
 	}
@@ -1207,13 +1215,13 @@ int icmp_rcv(struct sk_buff *skb)
 		/* We can't use icmp_pointers[].handler() because it is an array of
 		 * size NR_ICMP_TYPES + 1 (19 elements) and PROBE has code 42.
 		 */
-		success = icmp_echo(skb);
-		goto success_check;
+		reason = icmp_echo(skb);
+		goto reason_check;
 	}
 
 	if (icmph->type == ICMP_EXT_ECHOREPLY) {
-		success = ping_rcv(skb);
-		goto success_check;
+		reason = ping_rcv(skb);
+		goto reason_check;
 	}
 
 	/*
@@ -1222,8 +1230,10 @@ int icmp_rcv(struct sk_buff *skb)
 	 *	RFC 1122: 3.2.2  Unknown ICMP messages types MUST be silently
 	 *		  discarded.
 	 */
-	if (icmph->type > NR_ICMP_TYPES)
+	if (icmph->type > NR_ICMP_TYPES) {
+		reason = SKB_DROP_REASON_ICMP_TYPE;
 		goto error;
+	}
 
 	/*
 	 *	Parse the ICMP message
@@ -1239,27 +1249,30 @@ int icmp_rcv(struct sk_buff *skb)
 		if ((icmph->type == ICMP_ECHO ||
 		     icmph->type == ICMP_TIMESTAMP) &&
 		    net->ipv4.sysctl_icmp_echo_ignore_broadcasts) {
+			reason = SKB_DROP_REASON_ICMP_BROADCAST;
 			goto error;
 		}
 		if (icmph->type != ICMP_ECHO &&
 		    icmph->type != ICMP_TIMESTAMP &&
 		    icmph->type != ICMP_ADDRESS &&
 		    icmph->type != ICMP_ADDRESSREPLY) {
+			reason = SKB_DROP_REASON_ICMP_BROADCAST;
 			goto error;
 		}
 	}
 
-	success = icmp_pointers[icmph->type].handler(skb);
-success_check:
-	if (success)  {
+	reason = icmp_pointers[icmph->type].handler(skb);
+reason_check:
+	if (!reason)  {
 		consume_skb(skb);
 		return NET_RX_SUCCESS;
 	}
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return NET_RX_DROP;
 csum_error:
+	reason = SKB_DROP_REASON_ICMP_CSUM;
 	__ICMP_INC_STATS(net, ICMP_MIB_CSUMERRORS);
 error:
 	__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index cd4eb211431a..4442de0093f6 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -953,12 +953,12 @@ EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
  *	All we need to do is get the socket.
  */
 
-bool ping_rcv(struct sk_buff *skb)
+enum skb_drop_reason ping_rcv(struct sk_buff *skb)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NO_SOCKET;
 	struct sock *sk;
 	struct net *net = dev_net(skb->dev);
 	struct icmphdr *icmph = icmp_hdr(skb);
-	bool rc = false;
 
 	/* We assume the packet has already been checked by icmp_rcv */
 
@@ -973,15 +973,17 @@ bool ping_rcv(struct sk_buff *skb)
 		struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
 
 		pr_debug("rcv on socket %p\n", sk);
-		if (skb2 && !ping_queue_rcv_skb(sk, skb2))
-			rc = true;
+		if (skb2)
+			reason = ping_queue_rcv_skb(sk, skb2) * -1;
+		else
+			reason = SKB_DROP_REASON_NOMEM;
 		sock_put(sk);
 	}
 
-	if (!rc)
+	if (reason)
 		pr_debug("no socket, dropping\n");
 
-	return rc;
+	return reason;
 }
 EXPORT_SYMBOL_GPL(ping_rcv);
 
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index e6b978ea0e87..01c8003c9fc9 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -864,21 +864,23 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
 
 static int icmpv6_rcv(struct sk_buff *skb)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct net *net = dev_net(skb->dev);
 	struct net_device *dev = icmp6_dev(skb);
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	const struct in6_addr *saddr, *daddr;
 	struct icmp6hdr *hdr;
 	u8 type;
-	bool success = false;
 
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
 		struct sec_path *sp = skb_sec_path(skb);
 		int nh;
 
 		if (!(sp && sp->xvec[sp->len - 1]->props.flags &
-				 XFRM_STATE_ICMP))
+				 XFRM_STATE_ICMP)) {
+			reason = SKB_DROP_REASON_XFRM_POLICY;
 			goto drop_no_count;
+		}
 
 		if (!pskb_may_pull(skb, sizeof(*hdr) + sizeof(struct ipv6hdr)))
 			goto drop_no_count;
@@ -886,8 +888,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		nh = skb_network_offset(skb);
 		skb_set_network_header(skb, sizeof(*hdr));
 
-		if (!xfrm6_policy_check_reverse(NULL, XFRM_POLICY_IN, skb))
+		if (!xfrm6_policy_check_reverse(NULL, XFRM_POLICY_IN,
+						skb)) {
+			reason = SKB_DROP_REASON_XFRM_POLICY;
 			goto drop_no_count;
+		}
 
 		skb_set_network_header(skb, nh);
 	}
@@ -924,11 +929,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		break;
 
 	case ICMPV6_ECHO_REPLY:
-		success = ping_rcv(skb);
+		reason = ping_rcv(skb);
 		break;
 
 	case ICMPV6_EXT_ECHO_REPLY:
-		success = ping_rcv(skb);
+		reason = ping_rcv(skb);
 		break;
 
 	case ICMPV6_PKT_TOOBIG:
@@ -994,19 +999,20 @@ static int icmpv6_rcv(struct sk_buff *skb)
 	/* until the v6 path can be better sorted assume failure and
 	 * preserve the status quo behaviour for the rest of the paths to here
 	 */
-	if (success)
-		consume_skb(skb);
+	if (reason)
+		kfree_skb_reason(skb, reason);
 	else
-		kfree_skb(skb);
+		consume_skb(skb);
 
 	return 0;
 
 csum_error:
+	reason = SKB_DROP_REASON_ICMP_CSUM;
 	__ICMP6_INC_STATS(dev_net(dev), idev, ICMP6_MIB_CSUMERRORS);
 discard_it:
 	__ICMP6_INC_STATS(dev_net(dev), idev, ICMP6_MIB_INERRORS);
 drop_no_count:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return 0;
 }
 
-- 
2.35.1

