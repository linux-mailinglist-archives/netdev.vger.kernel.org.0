Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1B34FBD6E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346603AbiDKNl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346602AbiDKNlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:18 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADE612A
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:39:01 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id p10so26631056lfa.12
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=TFNOjZAXZon/4fuYvoXX/NbbTAf3VntOhKR6DBqpfYk=;
        b=kvB+hyM6e8RNZhoXuBQ/tSpmItfGCHtV/80UPZA2wcqsSJle472+AMQJQkqTSKG1zm
         9Ts/A1anN1MHNODDAuUPyykcEu1h3TncWzzTNf9nyt/TVZtmY+pPFG7NFuUeJhHrhKXa
         g9WqrFGvVVpE5OLbkZ64U+QIwjL7mx5bxxM82hWCDKNkDygEjR9jbQoxAPm6i/8W5kPR
         RzHZi9JYFT+8ZqGHUqK4lCk6QIv67edRLjOnrYh6wQB2mGbwq+hC0jyLJCtINGFhAInp
         U08yaJaXH9DmG3bSRD4IyKJK0gv0HkZDmsae+6ULbupzhH0+WDlM2Kp1QSlSlOP6Jn3H
         itWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=TFNOjZAXZon/4fuYvoXX/NbbTAf3VntOhKR6DBqpfYk=;
        b=iRwYMCHAk88Ocp8xBAc7ShYTXUojTxhaHVr1WiDixiIQFJFseWA9Cq0EmWQw8FpD7p
         51F/n1qyRfHmbHhDz9GchwuwK6Inn80NirNgQ0HZYa/dFsLCpm6g1ckBJo3+3ABOcoPx
         J3taxNSnOjBDkhU01a+rk5HQ1tjNEJgdUgVb4+GXHrsXHXbw0dCXXuXOF1RbAN7fuzBE
         qea8snWvOXRP9hDkpMdCBecYf9oK4YWzkcq0uDLeD+YvqYY3mYUF4WMi/jJQfl1wBZIN
         1Nc9XZS1UIVXJCUeRLGJ1UIL2qh9Hl4+jEO+CmhdBoo3BB4XPYdonnff0qwPIpSbOidF
         QlRw==
X-Gm-Message-State: AOAM533jJxKU28OWxObqg1hmh6qmLMciUkcbo+LvgFP1tgUQ8HBpuUws
        KKYrMCGjIIxw53sqHADO7RE=
X-Google-Smtp-Source: ABdhPJz8VyAgDW/b+e3V8a/isVm7gzC8dVXcgQJDNS04+ThstRMLoxnxLoypvvmLCJqc1Rsk2tMNoQ==
X-Received: by 2002:ac2:4194:0:b0:442:ed9e:4a25 with SMTP id z20-20020ac24194000000b00442ed9e4a25mr20779404lfh.629.1649684339767;
        Mon, 11 Apr 2022 06:38:59 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:38:59 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 08/13] net: bridge: avoid classifying unknown multicast as mrouters_only
Date:   Mon, 11 Apr 2022 15:38:32 +0200
Message-Id: <20220411133837.318876-9-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220411133837.318876-1-troglobit@gmail.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
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

Unknown multicast, MAC/IPv4/IPv6, should always be flooded according to
the per-port mcast_flood setting, as well as to detected and configured
mcast_router ports.

This patch drops the mrouters_only classifier of unknown IP multicast
and moves the flow handling from br_multicast_flood() to br_flood().
This in turn means br_flood() must know about multicast router ports.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 net/bridge/br_forward.c   | 11 +++++++++++
 net/bridge/br_multicast.c |  6 +-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 02bb620d3b8d..ab5b97a8c12e 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -199,9 +199,15 @@ static struct net_bridge_port *maybe_deliver(
 void br_flood(struct net_bridge *br, struct sk_buff *skb,
 	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig)
 {
+	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
+	struct net_bridge_port *rport = NULL;
 	struct net_bridge_port *prev = NULL;
+	struct hlist_node *rp = NULL;
 	struct net_bridge_port *p;
 
+	if (pkt_type == BR_PKT_MULTICAST)
+		rp = br_multicast_get_first_rport_node(brmctx, skb);
+
 	list_for_each_entry_rcu(p, &br->port_list, list) {
 		/* Do not flood unicast traffic to ports that turn it off, nor
 		 * other traffic if flood off, except for traffic we originate
@@ -212,6 +218,11 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
 				continue;
 			break;
 		case BR_PKT_MULTICAST:
+			rport = br_multicast_rport_from_node_skb(rp, skb);
+			if (rport == p) {
+				rp = rcu_dereference(hlist_next_rcu(rp));
+				break;
+			}
 			if (!(p->flags & BR_MCAST_FLOOD) && skb->dev != br->dev)
 				continue;
 			break;
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index db4f2641d1cd..c57e3bbb00ad 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -3643,9 +3643,7 @@ static int br_multicast_ipv4_rcv(struct net_bridge_mcast *brmctx,
 	err = ip_mc_check_igmp(skb);
 
 	if (err == -ENOMSG) {
-		if (!ipv4_is_local_multicast(ip_hdr(skb)->daddr)) {
-			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
-		} else if (pim_ipv4_all_pim_routers(ip_hdr(skb)->daddr)) {
+		if (pim_ipv4_all_pim_routers(ip_hdr(skb)->daddr)) {
 			if (ip_hdr(skb)->protocol == IPPROTO_PIM)
 				br_multicast_pim(brmctx, pmctx, skb);
 		} else if (ipv4_is_all_snoopers(ip_hdr(skb)->daddr)) {
@@ -3712,8 +3710,6 @@ static int br_multicast_ipv6_rcv(struct net_bridge_mcast *brmctx,
 	err = ipv6_mc_check_mld(skb);
 
 	if (err == -ENOMSG || err == -ENODATA) {
-		if (!ipv6_addr_is_ll_all_nodes(&ipv6_hdr(skb)->daddr))
-			BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 		if (err == -ENODATA &&
 		    ipv6_addr_is_all_snoopers(&ipv6_hdr(skb)->daddr))
 			br_ip6_multicast_mrd_rcv(brmctx, pmctx, skb);
-- 
2.25.1

