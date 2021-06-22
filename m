Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA203B0C8E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhFVSLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 14:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhFVSK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 14:10:58 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBB3C09B097;
        Tue, 22 Jun 2021 11:05:17 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d5so105412qtd.5;
        Tue, 22 Jun 2021 11:05:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=x+Xg6iM+QB/s2gTWnq9NFUo2g1N76G4pjTUyEYZgt8s=;
        b=fYV0ojnbXla/ypCYUd8kaJUSy4ytvmHGtUFA6lUuR6Obt5LQ03zi28V/F4tJ2Nks8s
         aB33JuTz4Bm7IJ61RC6BGTx5YHXSOFBVd21OaKD2tZDajW+x4fmUKdjs4nC2xI+UzXyg
         dag37AYb3fZBLcGSRBt27U/ACgKJPXW//T82p+klK3QV4i18X8nf4XZujQ/ejJrEG8cC
         VgEX+XAwxgg2axp9jCQXeBBSjrxSGBuy6U4h+hisn3szMN0eTrwQpTqafqKbvpK0baNE
         4YHAvEbBoW1szi0lw1wbPZ1pZr0lPshcWOhWB4cfB29hvEc+iQFyVcoO1m2XTdk1p1po
         qgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x+Xg6iM+QB/s2gTWnq9NFUo2g1N76G4pjTUyEYZgt8s=;
        b=MLPWnyah6TJOibd2zuGmOvDtYA0cTe5miG92xS+IKOCSErs3kgcfH8JCLoXpD7AZq/
         VU5eNuGF2tZNSmGCntRpSdNag8M3wnzchE5S2X6PO6C8fcMvlx3XAqy/O93gbt4WeSCb
         /wL58p7aiQzHI/Bkhlpx7i3PQ+LdOSn+IlvHL/YJH2mrDCsry/mbbq6vsxGBpYgjTahq
         f4ehu7i3EfbbmCFF5tHOBxhrrQe6/vMFWSE9PYW1en18m2NoGX9LBI7B9vcnALkoJMcA
         Zn3+kXehxZ/BslmHnGe8SCu1NB/hICEk2+JHAuCy0uGc6G80g+OELWT6KalcUwKmDRVg
         w41g==
X-Gm-Message-State: AOAM531u/UotytcaLTJQS0Gmtu7sYww62xTtHmvleAC0AdQnQRhfDB7w
        ktk+FflmG547384hXgw2XhKNq4NdGCKfrQ==
X-Google-Smtp-Source: ABdhPJwU0+LajRM5gnabO6ZfMszGwCAqDrUSRtJ89ixwspuS/g4wM7QNPAWlo5YAzPiQI/XHFfLHxQ==
X-Received: by 2002:ac8:7188:: with SMTP id w8mr29906qto.13.1624385116907;
        Tue, 22 Jun 2021 11:05:16 -0700 (PDT)
Received: from localhost (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id w2sm12939817qkf.88.2021.06.22.11.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 11:05:16 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org
Subject: [PATCHv2 net-next 14/14] sctp: process sctp over udp icmp err on sctp side
Date:   Tue, 22 Jun 2021 14:05:00 -0400
Message-Id: <a8924b07e7e744860e9e9ae903f46c6a6a8e09a0.1624384990.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1624384990.git.lucien.xin@gmail.com>
References: <cover.1624384990.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, sctp over udp was using udp tunnel's icmp err process, which
only does sk lookup on sctp side. However for sctp's icmp error process,
there are more things to do, like syncing assoc pmtu/retransmit packets
for toobig type err, and starting proto_unreach_timer for unreach type
err etc.

Now after adding PLPMTUD, which also requires to process toobig type err
on sctp side. This patch is to process icmp err on sctp side by parsing
the type/code/info in .encap_err_lookup and call sctp's icmp processing
functions. Note as the 'redirect' err process needs to know the outer
ip(v6) header's, we have to leave it to udp(v6)_err to handle it.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 include/net/sctp/sctp.h |  2 ++
 net/sctp/input.c        | 30 ++++++++++++++++++++++++++++++
 net/sctp/ipv6.c         | 30 ++++++++++++++++++++++++++++++
 net/sctp/protocol.c     | 21 ++-------------------
 4 files changed, 64 insertions(+), 19 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index f7e083602c10..69bab88ad66b 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -145,6 +145,8 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *,
 			     struct sctphdr *, struct sctp_association **,
 			     struct sctp_transport **);
 void sctp_err_finish(struct sock *, struct sctp_transport *);
+int sctp_udp_v4_err(struct sock *sk, struct sk_buff *skb);
+int sctp_udp_v6_err(struct sock *sk, struct sk_buff *skb);
 void sctp_icmp_frag_needed(struct sock *, struct sctp_association *,
 			   struct sctp_transport *t, __u32 pmtu);
 void sctp_icmp_redirect(struct sock *, struct sctp_transport *,
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 83d58d42ea45..fe6429cc012f 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -645,6 +645,36 @@ int sctp_v4_err(struct sk_buff *skb, __u32 info)
 	return 0;
 }
 
+int sctp_udp_v4_err(struct sock *sk, struct sk_buff *skb)
+{
+	struct net *net = dev_net(skb->dev);
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+	struct icmphdr *hdr;
+	__u32 info = 0;
+
+	skb->transport_header += sizeof(struct udphdr);
+	sk = sctp_err_lookup(net, AF_INET, skb, sctp_hdr(skb), &asoc, &t);
+	if (!sk) {
+		__ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
+		return -ENOENT;
+	}
+
+	skb->transport_header -= sizeof(struct udphdr);
+	hdr = (struct icmphdr *)(skb_network_header(skb) - sizeof(struct icmphdr));
+	if (hdr->type == ICMP_REDIRECT) {
+		/* can't be handled without outer iphdr known, leave it to udp_err */
+		sctp_err_finish(sk, t);
+		return 0;
+	}
+	if (hdr->type == ICMP_DEST_UNREACH && hdr->code == ICMP_FRAG_NEEDED)
+		info = ntohs(hdr->un.frag.mtu);
+	sctp_v4_err_handle(t, skb, hdr->type, hdr->code, info);
+
+	sctp_err_finish(sk, t);
+	return 1;
+}
+
 /*
  * RFC 2960, 8.4 - Handle "Out of the blue" Packets.
  *
diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 6ad422f2d0d0..05f81a4d0ee7 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -188,6 +188,36 @@ static int sctp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	return 0;
 }
 
+int sctp_udp_v6_err(struct sock *sk, struct sk_buff *skb)
+{
+	struct net *net = dev_net(skb->dev);
+	struct sctp_association *asoc;
+	struct sctp_transport *t;
+	struct icmp6hdr *hdr;
+	__u32 info = 0;
+
+	skb->transport_header += sizeof(struct udphdr);
+	sk = sctp_err_lookup(net, AF_INET6, skb, sctp_hdr(skb), &asoc, &t);
+	if (!sk) {
+		__ICMP6_INC_STATS(net, __in6_dev_get(skb->dev), ICMP6_MIB_INERRORS);
+		return -ENOENT;
+	}
+
+	skb->transport_header -= sizeof(struct udphdr);
+	hdr = (struct icmp6hdr *)(skb_network_header(skb) - sizeof(struct icmp6hdr));
+	if (hdr->icmp6_type == NDISC_REDIRECT) {
+		/* can't be handled without outer ip6hdr known, leave it to udpv6_err */
+		sctp_err_finish(sk, t);
+		return 0;
+	}
+	if (hdr->icmp6_type == ICMPV6_PKT_TOOBIG)
+		info = ntohl(hdr->icmp6_mtu);
+	sctp_v6_err_handle(t, skb, hdr->icmp6_type, hdr->icmp6_code, info);
+
+	sctp_err_finish(sk, t);
+	return 1;
+}
+
 static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 {
 	struct dst_entry *dst = dst_clone(t->dst);
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index baa4e770e4ba..bc5db0b404ce 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -850,23 +850,6 @@ static int sctp_udp_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
-static int sctp_udp_err_lookup(struct sock *sk, struct sk_buff *skb)
-{
-	struct sctp_association *asoc;
-	struct sctp_transport *t;
-	int family;
-
-	skb->transport_header += sizeof(struct udphdr);
-	family = (ip_hdr(skb)->version == 4) ? AF_INET : AF_INET6;
-	sk = sctp_err_lookup(dev_net(skb->dev), family, skb, sctp_hdr(skb),
-			     &asoc, &t);
-	if (!sk)
-		return -ENOENT;
-
-	sctp_err_finish(sk, t);
-	return 0;
-}
-
 int sctp_udp_sock_start(struct net *net)
 {
 	struct udp_tunnel_sock_cfg tuncfg = {NULL};
@@ -885,7 +868,7 @@ int sctp_udp_sock_start(struct net *net)
 
 	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
-	tuncfg.encap_err_lookup = sctp_udp_err_lookup;
+	tuncfg.encap_err_lookup = sctp_udp_v4_err;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp4_sock = sock->sk;
 
@@ -907,7 +890,7 @@ int sctp_udp_sock_start(struct net *net)
 
 	tuncfg.encap_type = 1;
 	tuncfg.encap_rcv = sctp_udp_rcv;
-	tuncfg.encap_err_lookup = sctp_udp_err_lookup;
+	tuncfg.encap_err_lookup = sctp_udp_v6_err;
 	setup_udp_tunnel_sock(net, sock, &tuncfg);
 	net->sctp.udp6_sock = sock->sk;
 #endif
-- 
2.27.0

