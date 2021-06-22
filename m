Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5581C3B0C8C
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232856AbhFVSLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhFVSK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:58 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBD7C035468;
        Tue, 22 Jun 2021 11:05:15 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id g4so40615486qkl.1;
        Tue, 22 Jun 2021 11:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xRIswn7Q82V0pxOKu3EcLv8PlQZFbGi9nHGHyUxVj/8=;
        b=nuSIy9PVXKD+awu5UqvpowRwiHuckibVY/QI0/DtKJN4mvEQX7n7myme+oi9NOwik7
         idWP6PtYj8LYPv/2n6DOtGQG8KGhmNK4MEdJFrdmtTcBEnX5nFVuLP7v7PO9jOL55eP3
         qf15zk1AfGmJmpgrwUyf71W0PLJWXzRhJ8/8YCwv8uxm6hB6/zWDV4FIxiqGur1g5DFb
         blzElPyjNSyuSUJOB5uwBY6uHnY1fyjx7sVLWZgdLLpMd4Zl0Xf0i35hUD8vA0tZDMzu
         vBI1ZlpmngqoeuprpDjXagzmfku1PkaXN6xQMuljyUNSGM0Irzj8Pe8wdmIimeIc5+6D
         Ydnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xRIswn7Q82V0pxOKu3EcLv8PlQZFbGi9nHGHyUxVj/8=;
        b=uA1B7obngBLVbSsdIjXYkkUgft4rf5MOvBV9BQDH8D0KftzGgilPg+HGDv16v6Ji2D
         EtPXqdGHRfF7aHcvtzoJo2FY4ofhAzm5IY0hsjzEy+lchxIkVbatp5N/sSpKCHNm2KRS
         /vlNJehW38rqD6vDsoMCv0hvdVCI7n+PUoTAmLitK7ghMvclLsRNCryCALov26CRLCei
         ih/l9btaJXUbpVgyX+1UGMjxD92bU+pAdcG+M9wJ8BYEnpcIGNjH4QQ4XSKCqmjQ+Lak
         1w3c2lcrrWCiwia03bog047ahU2jBAt3tQ/c5E/8JGhg9GKFzkcOMShY9HiBNJ52rGAY
         1XaQ==
X-Gm-Message-State: AOAM532O7n7iL3nkFuu9BQ5uG4hKgjnld0xolp8jYIBDGJeNA0gPmRRo
        J0RTcV1jWHSeKpV9fFMO4E4NR0eQD0V8mA==
X-Google-Smtp-Source: ABdhPJzUA+JC8LczGbSYYC2q6iD8reaDF4Y1Glm8YissZQQrFtl3oFsFqzAduiUsdG60TJukUTF/+g==
X-Received: by 2002:a37:8e02:: with SMTP id q2mr5651637qkd.312.1624385114759;
        Tue, 22 Jun 2021 11:05:14 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id 9sm6838933qkj.123.2021.06.22.11.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:14 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 12/14] sctp: extract sctp_v6_err_handle function from sctp_v6_err
Date:   Tue, 22 Jun 2021 14:04:58 -0400
Message-Id: <99e9df6645a16126061a4eecc981f8255d4f2c5f.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to extract sctp_v6_err_handle() from sctp_v6_err() to
only handle the icmp err after the sock lookup, and it also makes
the code clearer.

sctp_v6_err_handle() will be used in sctp over udp's err handling
in the following patch.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sctp/ipv6.c | 76 ++++++++++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 36 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 50ed4de18069..6ad422f2d0d0 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -122,50 +122,28 @@ static struct notifier_block sctp_inet6addr_notifier = {
 	.notifier_call = sctp_inet6addr_event,
 };
 
-/* ICMP error handler. */
-static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
-			u8 type, u8 code, int offset, __be32 info)
+static void sctp_v6_err_handle(struct sctp_transport *t, struct sk_buff *skb,
+			       __u8 type, __u8 code, __u32 info)
 {
-	struct sock *sk;
-	struct sctp_association *asoc;
-	struct sctp_transport *transport;
+	struct sctp_association *asoc = t->asoc;
+	struct sock *sk = asoc->base.sk;
 	struct ipv6_pinfo *np;
-	__u16 saveip, savesctp;
-	int err, ret = 0;
-	struct net *net = dev_net(skb->dev);
-
-	/* Fix up skb to look at the embedded net header. */
-	saveip	 = skb->network_header;
-	savesctp = skb->transport_header;
-	skb_reset_network_header(skb);
-	skb_set_transport_header(skb, offset);
-	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);
-	/* Put back, the original pointers. */
-	skb->network_header   = saveip;
-	skb->transport_header = savesctp;
-	if (!sk) {
-		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
-		return -ENOENT;
-	}
-
-	/* Warning:  The sock lock is held.  Remember to call
-	 * sctp_err_finish!
-	 */
+	int err = 0;
 
 	switch (type) {
 	case ICMPV6_PKT_TOOBIG:
 		if (ip6_sk_accept_pmtu(sk))
-			sctp_icmp_frag_needed(sk, asoc, transport, ntohl(info));
-		goto out_unlock;
+			sctp_icmp_frag_needed(sk, asoc, t, info);
+		return;
 	case ICMPV6_PARAMPROB:
 		if (ICMPV6_UNK_NEXTHDR == code) {
-			sctp_icmp_proto_unreachable(sk, asoc, transport);
-			goto out_unlock;
+			sctp_icmp_proto_unreachable(sk, asoc, t);
+			return;
 		}
 		break;
 	case NDISC_REDIRECT:
-		sctp_icmp_redirect(sk, transport, skb);
-		goto out_unlock;
+		sctp_icmp_redirect(sk, t, skb);
+		return;
 	default:
 		break;
 	}
@@ -175,13 +153,39 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (!sock_owned_by_user(sk) && np->recverr) {
 		sk->sk_err = err;
 		sk->sk_error_report(sk);
-	} else {  /* Only an error on timeout */
+	} else {
 		sk->sk_err_soft = err;
 	}
+}
+
+/* ICMP error handler. */
+static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+		       u8 type, u8 code, int offset, __be32 info)
+{
+	struct net *net = dev_net(skb->dev);
+	struct sctp_transport *transport;
+	struct sctp_association *asoc;
+	__u16 saveip, savesctp;
+	struct sock *sk;
+
+	/* Fix up skb to look at the embedded net header. */
+	saveip	 = skb->network_header;
+	savesctp = skb->transport_header;
+	skb_reset_network_header(skb);
+	skb_set_transport_header(skb, offset);
+	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &transport);
+	/* Put back, the original pointers. */
+	skb->network_header   = saveip;
+	skb->transport_header = savesctp;
+	if (!sk) {
+		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+		return -ENOENT;
+	}
 
-out_unlock:
+	sctp_v6_err_handle(transport, skb, type, code, ntohl(info));
 	sctp_err_finish(sk, transport);
-	return ret;
+
+	return 0;
 }
 
 static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
-- 
2.27.0

