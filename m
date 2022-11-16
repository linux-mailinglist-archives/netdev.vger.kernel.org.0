Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD4F62C967
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234892AbiKPUBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234897AbiKPUBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:01:37 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38530654F3;
        Wed, 16 Nov 2022 12:01:36 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id l2so11431321qtq.11;
        Wed, 16 Nov 2022 12:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCiC2n3In44AUA3Uuke2R2qb/q2jLjqt8DH+CLd3Pvg=;
        b=G05wJI2aMYk9Nh0Aqn3qQQJ300BZRUxoxiu+4vBEfwa3i8+TrW3wcVWNb8bE8ElMiG
         /h5etrvleXUJmOGEYgbC8AmOECA9NFNf+mZlpwV77blpX7NmCEXw8y3sjdLk7R/WQJqk
         qn20tIQVqip2yOADfMwIE7E+8oct6VTR0tUERgKwdancQg/V6P0pkaZ1Jga1aH9KA3hD
         +HJbnOR2RL8rRoH19wH68qhq5VMU3ObRNyhmUSTph91qed2XRGl9KTEYsYsqIpmTQ/mN
         7//TlLljmygJrxr9/B6sJLBcy8kjMkkfBT1SVpYD3Tu8CsOdDqM6zT/LdiwLwicJw4IP
         4rVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gCiC2n3In44AUA3Uuke2R2qb/q2jLjqt8DH+CLd3Pvg=;
        b=ocQg6pSJ+UXLMno8vvrtIWuJ2XzGaCO0Ry2lkU39EVfO6StMnzml4RnPEds8T5eVAb
         YJUetyYYeRZBuRtuihyulcvyXLA/1ODE3KbsLjp2Ghz84E4yRQW7JzIAwgwT97uXPymb
         bf1B1EBd1+BqHUZKW85Rdz3adQHHRpmb1e+cNBnquBskmNQEBlLJwdjdcwyuRetuEw2t
         XPgoQS4RYaIcwmWSHXR9/n1X4sULR+ZvnHOz0k1e2WIKxj0+7b93X0DwJAtvv39dQQ6E
         bxjxI8w8003iUKxtmXugN63kL8t/7I9/fA/1zOFpMj9qrxWRPRatjwNbmDGovuyCHETC
         oGLg==
X-Gm-Message-State: ANoB5pkpRbxH1C1bB9b1OKAjns+0DRf5AFTppSEZ5TjsZC+t8lXSMlUK
        2NS/v7bbaoN6NMaIDnbfKCmVtfm9eoMeOA==
X-Google-Smtp-Source: AA0mqf70h3RVVuzYh1Ris07KUXwPV4KTH0xMHdPuba1fwgfLolovB5vxh1eXaQZ7nGsRrakxM0f6uQ==
X-Received: by 2002:ac8:6f15:0:b0:3a5:78a9:7a2d with SMTP id bs21-20020ac86f15000000b003a578a97a2dmr22640594qtb.666.1668628894889;
        Wed, 16 Nov 2022 12:01:34 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d7-20020a05620a240700b006fba44843a5sm2900411qkn.52.2022.11.16.12.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 12:01:34 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Ahern <dsahern@gmail.com>,
        Carlo Carraro <colrack@gmail.com>
Subject: [PATCHv2 net-next 5/7] sctp: add dif and sdif check in asoc and ep lookup
Date:   Wed, 16 Nov 2022 15:01:20 -0500
Message-Id: <0e303724a517da7e1eff357aac8ac31c03302415.1668628394.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1668628394.git.lucien.xin@gmail.com>
References: <cover.1668628394.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch at first adds a pernet global l3mdev_accept to decide if it
accepts the packets from a l3mdev when a SCTP socket doesn't bind to
any interface. It's set to 1 to avoid any possible incompatible issue,
and in next patch, a sysctl will be introduced to allow to change it.

Then similar to inet/udp_sk_bound_dev_eq(), sctp_sk_bound_dev_eq() is
added to check either dif or sdif is equal to sk_bound_dev_if, and to
check sid is 0 or l3mdev_accept is 1 if sk_bound_dev_if is not set.
This function is used to match a association or a endpoint, namely
called by sctp_addrs_lookup_transport() and sctp_endpoint_is_match().
All functions that needs updating are:

sctp_rcv():
  asoc:
  __sctp_rcv_lookup()
    __sctp_lookup_association() -> sctp_addrs_lookup_transport()
    __sctp_rcv_lookup_harder()
      __sctp_rcv_init_lookup()
         __sctp_lookup_association() -> sctp_addrs_lookup_transport()
      __sctp_rcv_walk_lookup()
         __sctp_rcv_asconf_lookup()
           __sctp_lookup_association() -> sctp_addrs_lookup_transport()

  ep:
  __sctp_rcv_lookup_endpoint() -> sctp_endpoint_is_match()

sctp_connect():
  sctp_endpoint_is_peeled_off()
    __sctp_lookup_association()
      sctp_has_association()
        sctp_lookup_association()
          __sctp_lookup_association() -> sctp_addrs_lookup_transport()

sctp_diag_dump_one():
  sctp_transport_lookup_process() -> sctp_addrs_lookup_transport()

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/netns/sctp.h   |   4 ++
 include/net/sctp/sctp.h    |   6 ++-
 include/net/sctp/structs.h |   8 +--
 net/sctp/diag.c            |   3 +-
 net/sctp/endpointola.c     |  13 +++--
 net/sctp/input.c           | 108 ++++++++++++++++++++-----------------
 net/sctp/protocol.c        |   4 ++
 net/sctp/socket.c          |   4 +-
 8 files changed, 89 insertions(+), 61 deletions(-)

diff --git a/include/net/netns/sctp.h b/include/net/netns/sctp.h
index a681147aecd8..7eff3d981b89 100644
--- a/include/net/netns/sctp.h
+++ b/include/net/netns/sctp.h
@@ -175,6 +175,10 @@ struct netns_sctp {
 
 	/* Threshold for autoclose timeout, in seconds. */
 	unsigned long max_autoclose;
+
+#ifdef CONFIG_NET_L3_MASTER_DEV
+	int l3mdev_accept;
+#endif
 };
 
 #endif /* __NETNS_SCTP_H__ */
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index a04999ee99b0..e499fd753fc4 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -114,7 +114,7 @@ struct sctp_transport *sctp_transport_get_idx(struct net *net,
 			struct rhashtable_iter *iter, int pos);
 int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
-				  const union sctp_addr *paddr, void *p);
+				  const union sctp_addr *paddr, void *p, int dif);
 int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
 				    struct net *net, int *pos, void *p);
 int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *), void *p);
@@ -162,10 +162,12 @@ void sctp_unhash_transport(struct sctp_transport *t);
 struct sctp_transport *sctp_addrs_lookup_transport(
 				struct net *net,
 				const union sctp_addr *laddr,
-				const union sctp_addr *paddr);
+				const union sctp_addr *paddr,
+				int dif, int sdif);
 struct sctp_transport *sctp_epaddr_lookup_transport(
 				const struct sctp_endpoint *ep,
 				const union sctp_addr *paddr);
+bool sctp_sk_bound_dev_eq(struct net *net, int bound_dev_if, int dif, int sdif);
 
 /*
  * sctp/proc.c
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 7b4884c63b26..afa3781e3ca2 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1379,10 +1379,12 @@ struct sctp_association *sctp_endpoint_lookup_assoc(
 	struct sctp_transport **);
 bool sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
 				 const union sctp_addr *paddr);
-struct sctp_endpoint *sctp_endpoint_is_match(struct sctp_endpoint *,
-					struct net *, const union sctp_addr *);
+struct sctp_endpoint *sctp_endpoint_is_match(struct sctp_endpoint *ep,
+					     struct net *net,
+					     const union sctp_addr *laddr,
+					     int dif, int sdif);
 bool sctp_has_association(struct net *net, const union sctp_addr *laddr,
-			  const union sctp_addr *paddr);
+			  const union sctp_addr *paddr, int dif, int sdif);
 
 int sctp_verify_init(struct net *net, const struct sctp_endpoint *ep,
 		     const struct sctp_association *asoc,
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index d9c6d8f30f09..a557009e9832 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -426,6 +426,7 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
 	struct net *net = sock_net(skb->sk);
 	const struct nlmsghdr *nlh = cb->nlh;
 	union sctp_addr laddr, paddr;
+	int dif = req->id.idiag_if;
 	struct sctp_comm_param commp = {
 		.skb = skb,
 		.r = req,
@@ -454,7 +455,7 @@ static int sctp_diag_dump_one(struct netlink_callback *cb,
 	}
 
 	return sctp_transport_lookup_process(sctp_sock_dump_one,
-					     net, &laddr, &paddr, &commp);
+					     net, &laddr, &paddr, &commp, dif);
 }
 
 static void sctp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index efffde7f2328..7e77b450697c 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -246,12 +246,15 @@ void sctp_endpoint_put(struct sctp_endpoint *ep)
 /* Is this the endpoint we are looking for?  */
 struct sctp_endpoint *sctp_endpoint_is_match(struct sctp_endpoint *ep,
 					       struct net *net,
-					       const union sctp_addr *laddr)
+					       const union sctp_addr *laddr,
+					       int dif, int sdif)
 {
+	int bound_dev_if = READ_ONCE(ep->base.sk->sk_bound_dev_if);
 	struct sctp_endpoint *retval = NULL;
 
-	if ((htons(ep->base.bind_addr.port) == laddr->v4.sin_port) &&
-	    net_eq(ep->base.net, net)) {
+	if (net_eq(ep->base.net, net) &&
+	    sctp_sk_bound_dev_eq(net, bound_dev_if, dif, sdif) &&
+	    (htons(ep->base.bind_addr.port) == laddr->v4.sin_port)) {
 		if (sctp_bind_addr_match(&ep->base.bind_addr, laddr,
 					 sctp_sk(ep->base.sk)))
 			retval = ep;
@@ -298,6 +301,7 @@ struct sctp_association *sctp_endpoint_lookup_assoc(
 bool sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
 				 const union sctp_addr *paddr)
 {
+	int bound_dev_if = READ_ONCE(ep->base.sk->sk_bound_dev_if);
 	struct sctp_sockaddr_entry *addr;
 	struct net *net = ep->base.net;
 	struct sctp_bind_addr *bp;
@@ -307,7 +311,8 @@ bool sctp_endpoint_is_peeled_off(struct sctp_endpoint *ep,
 	 * so the address_list can not change.
 	 */
 	list_for_each_entry(addr, &bp->address_list, list) {
-		if (sctp_has_association(net, &addr->a, paddr))
+		if (sctp_has_association(net, &addr->a, paddr,
+					 bound_dev_if, bound_dev_if))
 			return true;
 	}
 
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 4f43afa8678f..bf70371301ff 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -50,16 +50,19 @@ static struct sctp_association *__sctp_rcv_lookup(struct net *net,
 				      struct sk_buff *skb,
 				      const union sctp_addr *paddr,
 				      const union sctp_addr *laddr,
-				      struct sctp_transport **transportp);
+				      struct sctp_transport **transportp,
+				      int dif, int sdif);
 static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
 					struct net *net, struct sk_buff *skb,
 					const union sctp_addr *laddr,
-					const union sctp_addr *daddr);
+					const union sctp_addr *daddr,
+					int dif, int sdif);
 static struct sctp_association *__sctp_lookup_association(
 					struct net *net,
 					const union sctp_addr *local,
 					const union sctp_addr *peer,
-					struct sctp_transport **pt);
+					struct sctp_transport **pt,
+					int dif, int sdif);
 
 static int sctp_add_backlog(struct sock *sk, struct sk_buff *skb);
 
@@ -92,11 +95,11 @@ int sctp_rcv(struct sk_buff *skb)
 	struct sctp_chunk *chunk;
 	union sctp_addr src;
 	union sctp_addr dest;
-	int bound_dev_if;
 	int family;
 	struct sctp_af *af;
 	struct net *net = dev_net(skb->dev);
 	bool is_gso = skb_is_gso(skb) && skb_is_gso_sctp(skb);
+	int dif, sdif;
 
 	if (skb->pkt_type != PACKET_HOST)
 		goto discard_it;
@@ -141,6 +144,8 @@ int sctp_rcv(struct sk_buff *skb)
 	/* Initialize local addresses for lookups. */
 	af->from_skb(&src, skb, 1);
 	af->from_skb(&dest, skb, 0);
+	dif = af->skb_iif(skb);
+	sdif = af->skb_sdif(skb);
 
 	/* If the packet is to or from a non-unicast address,
 	 * silently discard the packet.
@@ -157,35 +162,15 @@ int sctp_rcv(struct sk_buff *skb)
 	    !af->addr_valid(&dest, NULL, skb))
 		goto discard_it;
 
-	asoc = __sctp_rcv_lookup(net, skb, &src, &dest, &transport);
+	asoc = __sctp_rcv_lookup(net, skb, &src, &dest, &transport, dif, sdif);
 
 	if (!asoc)
-		ep = __sctp_rcv_lookup_endpoint(net, skb, &dest, &src);
+		ep = __sctp_rcv_lookup_endpoint(net, skb, &dest, &src, dif, sdif);
 
 	/* Retrieve the common input handling substructure. */
 	rcvr = asoc ? &asoc->base : &ep->base;
 	sk = rcvr->sk;
 
-	/*
-	 * If a frame arrives on an interface and the receiving socket is
-	 * bound to another interface, via SO_BINDTODEVICE, treat it as OOTB
-	 */
-	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
-	if (bound_dev_if && (bound_dev_if != af->skb_iif(skb))) {
-		if (transport) {
-			sctp_transport_put(transport);
-			asoc = NULL;
-			transport = NULL;
-		} else {
-			sctp_endpoint_put(ep);
-			ep = NULL;
-		}
-		sk = net->sctp.ctl_sock;
-		ep = sctp_sk(sk)->ep;
-		sctp_endpoint_hold(ep);
-		rcvr = &ep->base;
-	}
-
 	/*
 	 * RFC 2960, 8.4 - Handle "Out of the blue" Packets.
 	 * An SCTP packet is called an "out of the blue" (OOTB)
@@ -485,6 +470,8 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *skb,
 	struct sctp_association *asoc;
 	struct sctp_transport *transport = NULL;
 	__u32 vtag = ntohl(sctphdr->vtag);
+	int sdif = inet_sdif(skb);
+	int dif = inet_iif(skb);
 
 	*app = NULL; *tpp = NULL;
 
@@ -500,7 +487,7 @@ struct sock *sctp_err_lookup(struct net *net, int family, struct sk_buff *skb,
 	/* Look for an association that matches the incoming ICMP error
 	 * packet.
 	 */
-	asoc = __sctp_lookup_association(net, &saddr, &daddr, &transport);
+	asoc = __sctp_lookup_association(net, &saddr, &daddr, &transport, dif, sdif);
 	if (!asoc)
 		return NULL;
 
@@ -850,7 +837,8 @@ static inline __u32 sctp_hashfn(const struct net *net, __be16 lport,
 static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
 					struct net *net, struct sk_buff *skb,
 					const union sctp_addr *laddr,
-					const union sctp_addr *paddr)
+					const union sctp_addr *paddr,
+					int dif, int sdif)
 {
 	struct sctp_hashbucket *head;
 	struct sctp_endpoint *ep;
@@ -863,7 +851,7 @@ static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
 	head = &sctp_ep_hashtable[hash];
 	read_lock(&head->lock);
 	sctp_for_each_hentry(ep, &head->chain) {
-		if (sctp_endpoint_is_match(ep, net, laddr))
+		if (sctp_endpoint_is_match(ep, net, laddr, dif, sdif))
 			goto hit;
 	}
 
@@ -990,14 +978,26 @@ void sctp_unhash_transport(struct sctp_transport *t)
 			sctp_hash_params);
 }
 
+bool sctp_sk_bound_dev_eq(struct net *net, int bound_dev_if, int dif, int sdif)
+{
+	bool l3mdev_accept = true;
+
+#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
+	l3mdev_accept = !!READ_ONCE(net->sctp.l3mdev_accept);
+#endif
+	return inet_bound_dev_eq(l3mdev_accept, bound_dev_if, dif, sdif);
+}
+
 /* return a transport with holding it */
 struct sctp_transport *sctp_addrs_lookup_transport(
 				struct net *net,
 				const union sctp_addr *laddr,
-				const union sctp_addr *paddr)
+				const union sctp_addr *paddr,
+				int dif, int sdif)
 {
 	struct rhlist_head *tmp, *list;
 	struct sctp_transport *t;
+	int bound_dev_if;
 	struct sctp_hash_cmp_arg arg = {
 		.paddr = paddr,
 		.net   = net,
@@ -1011,7 +1011,9 @@ struct sctp_transport *sctp_addrs_lookup_transport(
 		if (!sctp_transport_hold(t))
 			continue;
 
-		if (sctp_bind_addr_match(&t->asoc->base.bind_addr,
+		bound_dev_if = READ_ONCE(t->asoc->base.sk->sk_bound_dev_if);
+		if (sctp_sk_bound_dev_eq(net, bound_dev_if, dif, sdif) &&
+		    sctp_bind_addr_match(&t->asoc->base.bind_addr,
 					 laddr, sctp_sk(t->asoc->base.sk)))
 			return t;
 		sctp_transport_put(t);
@@ -1048,12 +1050,13 @@ static struct sctp_association *__sctp_lookup_association(
 					struct net *net,
 					const union sctp_addr *local,
 					const union sctp_addr *peer,
-					struct sctp_transport **pt)
+					struct sctp_transport **pt,
+					int dif, int sdif)
 {
 	struct sctp_transport *t;
 	struct sctp_association *asoc = NULL;
 
-	t = sctp_addrs_lookup_transport(net, local, peer);
+	t = sctp_addrs_lookup_transport(net, local, peer, dif, sdif);
 	if (!t)
 		goto out;
 
@@ -1069,12 +1072,13 @@ static
 struct sctp_association *sctp_lookup_association(struct net *net,
 						 const union sctp_addr *laddr,
 						 const union sctp_addr *paddr,
-						 struct sctp_transport **transportp)
+						 struct sctp_transport **transportp,
+						 int dif, int sdif)
 {
 	struct sctp_association *asoc;
 
 	rcu_read_lock();
-	asoc = __sctp_lookup_association(net, laddr, paddr, transportp);
+	asoc = __sctp_lookup_association(net, laddr, paddr, transportp, dif, sdif);
 	rcu_read_unlock();
 
 	return asoc;
@@ -1083,11 +1087,12 @@ struct sctp_association *sctp_lookup_association(struct net *net,
 /* Is there an association matching the given local and peer addresses? */
 bool sctp_has_association(struct net *net,
 			  const union sctp_addr *laddr,
-			  const union sctp_addr *paddr)
+			  const union sctp_addr *paddr,
+			  int dif, int sdif)
 {
 	struct sctp_transport *transport;
 
-	if (sctp_lookup_association(net, laddr, paddr, &transport)) {
+	if (sctp_lookup_association(net, laddr, paddr, &transport, dif, sdif)) {
 		sctp_transport_put(transport);
 		return true;
 	}
@@ -1115,7 +1120,8 @@ bool sctp_has_association(struct net *net,
  */
 static struct sctp_association *__sctp_rcv_init_lookup(struct net *net,
 	struct sk_buff *skb,
-	const union sctp_addr *laddr, struct sctp_transport **transportp)
+	const union sctp_addr *laddr, struct sctp_transport **transportp,
+	int dif, int sdif)
 {
 	struct sctp_association *asoc;
 	union sctp_addr addr;
@@ -1154,7 +1160,7 @@ static struct sctp_association *__sctp_rcv_init_lookup(struct net *net,
 		if (!af->from_addr_param(paddr, params.addr, sh->source, 0))
 			continue;
 
-		asoc = __sctp_lookup_association(net, laddr, paddr, transportp);
+		asoc = __sctp_lookup_association(net, laddr, paddr, transportp, dif, sdif);
 		if (asoc)
 			return asoc;
 	}
@@ -1181,7 +1187,8 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 					struct sctp_chunkhdr *ch,
 					const union sctp_addr *laddr,
 					__be16 peer_port,
-					struct sctp_transport **transportp)
+					struct sctp_transport **transportp,
+					int dif, int sdif)
 {
 	struct sctp_addip_chunk *asconf = (struct sctp_addip_chunk *)ch;
 	struct sctp_af *af;
@@ -1201,7 +1208,7 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 	if (!af->from_addr_param(&paddr, param, peer_port, 0))
 		return NULL;
 
-	return __sctp_lookup_association(net, laddr, &paddr, transportp);
+	return __sctp_lookup_association(net, laddr, &paddr, transportp, dif, sdif);
 }
 
 
@@ -1217,7 +1224,8 @@ static struct sctp_association *__sctp_rcv_asconf_lookup(
 static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 				      struct sk_buff *skb,
 				      const union sctp_addr *laddr,
-				      struct sctp_transport **transportp)
+				      struct sctp_transport **transportp,
+				      int dif, int sdif)
 {
 	struct sctp_association *asoc = NULL;
 	struct sctp_chunkhdr *ch;
@@ -1260,7 +1268,7 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 				asoc = __sctp_rcv_asconf_lookup(
 						net, ch, laddr,
 						sctp_hdr(skb)->source,
-						transportp);
+						transportp, dif, sdif);
 			break;
 		default:
 			break;
@@ -1285,7 +1293,8 @@ static struct sctp_association *__sctp_rcv_walk_lookup(struct net *net,
 static struct sctp_association *__sctp_rcv_lookup_harder(struct net *net,
 				      struct sk_buff *skb,
 				      const union sctp_addr *laddr,
-				      struct sctp_transport **transportp)
+				      struct sctp_transport **transportp,
+				      int dif, int sdif)
 {
 	struct sctp_chunkhdr *ch;
 
@@ -1309,9 +1318,9 @@ static struct sctp_association *__sctp_rcv_lookup_harder(struct net *net,
 
 	/* If this is INIT/INIT-ACK look inside the chunk too. */
 	if (ch->type == SCTP_CID_INIT || ch->type == SCTP_CID_INIT_ACK)
-		return __sctp_rcv_init_lookup(net, skb, laddr, transportp);
+		return __sctp_rcv_init_lookup(net, skb, laddr, transportp, dif, sdif);
 
-	return __sctp_rcv_walk_lookup(net, skb, laddr, transportp);
+	return __sctp_rcv_walk_lookup(net, skb, laddr, transportp, dif, sdif);
 }
 
 /* Lookup an association for an inbound skb. */
@@ -1319,11 +1328,12 @@ static struct sctp_association *__sctp_rcv_lookup(struct net *net,
 				      struct sk_buff *skb,
 				      const union sctp_addr *paddr,
 				      const union sctp_addr *laddr,
-				      struct sctp_transport **transportp)
+				      struct sctp_transport **transportp,
+				      int dif, int sdif)
 {
 	struct sctp_association *asoc;
 
-	asoc = __sctp_lookup_association(net, laddr, paddr, transportp);
+	asoc = __sctp_lookup_association(net, laddr, paddr, transportp, dif, sdif);
 	if (asoc)
 		goto out;
 
@@ -1331,7 +1341,7 @@ static struct sctp_association *__sctp_rcv_lookup(struct net *net,
 	 * SCTP Implementors Guide, 2.18 Handling of address
 	 * parameters within the INIT or INIT-ACK.
 	 */
-	asoc = __sctp_rcv_lookup_harder(net, skb, laddr, transportp);
+	asoc = __sctp_rcv_lookup_harder(net, skb, laddr, transportp, dif, sdif);
 	if (asoc)
 		goto out;
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index a18cf0471a8d..909a89a1cff4 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1394,6 +1394,10 @@ static int __net_init sctp_defaults_init(struct net *net)
 	/* Initialize maximum autoclose timeout. */
 	net->sctp.max_autoclose		= INT_MAX / HZ;
 
+#ifdef CONFIG_NET_L3_MASTER_DEV
+	net->sctp.l3mdev_accept = 1;
+#endif
+
 	status = sctp_sysctl_net_register(net);
 	if (status)
 		goto err_sysctl_register;
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 4306164238ef..5acbdf0d38f3 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5315,14 +5315,14 @@ EXPORT_SYMBOL_GPL(sctp_for_each_endpoint);
 
 int sctp_transport_lookup_process(sctp_callback_t cb, struct net *net,
 				  const union sctp_addr *laddr,
-				  const union sctp_addr *paddr, void *p)
+				  const union sctp_addr *paddr, void *p, int dif)
 {
 	struct sctp_transport *transport;
 	struct sctp_endpoint *ep;
 	int err = -ENOENT;
 
 	rcu_read_lock();
-	transport = sctp_addrs_lookup_transport(net, laddr, paddr);
+	transport = sctp_addrs_lookup_transport(net, laddr, paddr, dif, dif);
 	if (!transport) {
 		rcu_read_unlock();
 		return err;
-- 
2.31.1

