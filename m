Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8544E36F5
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiCVCzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbiCVCzR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:55:17 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D67227C6F;
        Mon, 21 Mar 2022 19:53:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id g19so17058542pfc.9;
        Mon, 21 Mar 2022 19:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hgxTxmsnaTYyizSw4eAQyNDGLmIntCuoWZzioX+aEz8=;
        b=Xwcx6lqcFZu7ahSvJAXSMICOYkVwiQe0bnG9/Fpbje9rbP0XR8xLBV5WQ3Ad4VtNRu
         Xyg8ID+Dk6oKQgCckfsV2gJCbvD/B1aSW9x0sMluqXvodR0lBmSKWN6MziWL0ziydwdf
         FYM6dvXsEoR1VUKfQGOuEq0nbW1peZtfBNlHBBdkrxafAmvo3JKsnsQpMoQtJGJP9k1T
         PNSxWWEDeX96Atc9MebuE8y22lhg4QyIs98TwBiqfgnrLjS0ntYLtmPd/fJGEDTf/OBx
         ay9Fl9Sahzorjfz9gsHhCya2KNZ0zEOsFskMBNrbueZlA7qy4jtj/12QK5xVGuIIXVjV
         phuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hgxTxmsnaTYyizSw4eAQyNDGLmIntCuoWZzioX+aEz8=;
        b=kIDWek/WsEQN8rf9Jgk6oOgrABzT/sUn0ewDauw1L5szDaLpyPuD+qoUdX4I3axi8Z
         0/aJeTfjkMYGGMBzSoqWI8FIsPAFPYC0mUXJ75q5e3P1XB2jZZGarACRwQrzNs4rlC60
         ULXjrCiaODr+cAvGZzHakJLDIeucjrLolB4Y5kyr5CVFQnAbCmKLhSSTa1Zpwh6moG8B
         TW2ucJ9XR75brUQ8PqxxXvHZWeT5ml1wteWiDl5WM8uRvKGS0BBgUawqFGXxwIgAee7P
         bJwENHjLOmfRdGzkNkLgD5Hzt/s9eOEjDPEL2jVk+mm8gOSPveONkN2PDaAqyBILxji/
         KWhQ==
X-Gm-Message-State: AOAM532FncmZlBEZaita7RnToygcczNhjwtANZTsbioSvllBSmoEuW6E
        Bq7mH0KcW1MvktlTHl1sDyg=
X-Google-Smtp-Source: ABdhPJyviixAHAnfhAmjEBP87ZsQbnEGmFDaQFa94lB4d1hmM9MTM6/stpS1bt0ZFqi8rviRuTjMxQ==
X-Received: by 2002:a05:6a00:1990:b0:4fa:b49c:d64b with SMTP id d16-20020a056a00199000b004fab49cd64bmr3025274pfl.82.1647917628961;
        Mon, 21 Mar 2022 19:53:48 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id g24-20020a17090a579800b001c60f919656sm764687pji.18.2022.03.21.19.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:53:48 -0700 (PDT)
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
Subject: [PATCH net-next v4 4/4] net: icmp: add skb drop reasons to icmp protocol
Date:   Tue, 22 Mar 2022 10:52:20 +0800
Message-Id: <20220322025220.190568-5-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220322025220.190568-1-imagedong@tencent.com>
References: <20220322025220.190568-1-imagedong@tencent.com>
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
success now. Therefore, all 'handler' and the call of them need to be
handled. Following 'handler' functions are involved:

icmp_unreach()
icmp_redirect()
icmp_echo()
icmp_timestamp()
icmp_discard()

And following new drop reasons are added:

SKB_DROP_REASON_ICMP_CSUM
SKB_DROP_REASON_RFC_1122

The reason 'RFC_1122' is introduced for the case that the packet doesn't
follow rfc 1122 and is dropped. This is not a common case, and I believe
we can locate the problem from the data in the packet. For now, this
'RFC_1122' is used for the icmp broadcasts with wrong types.

Maybe there should be a document file for these reasons. For example,
list all the case that causes the 'RFC_1122' drop reason. Therefore,
users can locate their problems according to the document.

Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v4:
- remove SKB_DROP_REASON_ICMP_TYPE and SKB_DROP_REASON_ICMP_BROADCAST
  and introduce the SKB_DROP_REASON_RFC_1122
---
 include/linux/skbuff.h     |  2 +
 include/net/ping.h         |  2 +-
 include/trace/events/skb.h |  2 +
 net/ipv4/icmp.c            | 75 ++++++++++++++++++++++----------------
 net/ipv4/ping.c            | 14 ++++---
 net/ipv6/icmp.c            | 24 +++++++-----
 6 files changed, 72 insertions(+), 47 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 10ba07892c46..3c30cc6f559e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -442,6 +442,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TAP_TXFILTER,	/* dropped by tx filter implemented
 					 * at tun/tap, e.g., check_filter()
 					 */
+	SKB_DROP_REASON_ICMP_CSUM,	/* ICMP checksum error */
+	SKB_DROP_REASON_RFC_1122,	/* dropped as RFC 1122 is not followed */
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
index 85abd7cbd221..52c965f3fca7 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -61,6 +61,8 @@
 	EM(SKB_DROP_REASON_HDR_TRUNC, HDR_TRUNC)		\
 	EM(SKB_DROP_REASON_TAP_FILTER, TAP_FILTER)		\
 	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
+	EM(SKB_DROP_REASON_ICMP_CSUM, ICMP_CSUM)		\
+	EM(SKB_DROP_REASON_RFC_1122, RFC_1122)			\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 72a375c7f417..1cd6296f312c 100644
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
+		reason = SKB_DROP_REASON_UNHANDLED_PROTO;
 		goto error;
+	}
 
 	/*
 	 *	Parse the ICMP message
@@ -1239,27 +1249,30 @@ int icmp_rcv(struct sk_buff *skb)
 		if ((icmph->type == ICMP_ECHO ||
 		     icmph->type == ICMP_TIMESTAMP) &&
 		    net->ipv4.sysctl_icmp_echo_ignore_broadcasts) {
+			reason = SKB_DROP_REASON_RFC_1122;
 			goto error;
 		}
 		if (icmph->type != ICMP_ECHO &&
 		    icmph->type != ICMP_TIMESTAMP &&
 		    icmph->type != ICMP_ADDRESS &&
 		    icmph->type != ICMP_ADDRESSREPLY) {
+			reason = SKB_DROP_REASON_RFC_1122;
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
index 877270ad17c9..b383e0393206 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -960,12 +960,12 @@ EXPORT_SYMBOL_GPL(ping_queue_rcv_skb);
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
 
@@ -980,15 +980,17 @@ bool ping_rcv(struct sk_buff *skb)
 		struct sk_buff *skb2 = skb_clone(skb, GFP_ATOMIC);
 
 		pr_debug("rcv on socket %p\n", sk);
-		if (skb2 && !ping_queue_rcv_skb(sk, skb2))
-			rc = true;
+		if (skb2)
+			reason = __ping_queue_rcv_skb(sk, skb2);
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

