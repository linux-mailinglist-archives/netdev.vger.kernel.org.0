Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17984FBD57
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344612AbiDKNlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343774AbiDKNlJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:09 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02D1222AE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:54 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id h14so21563815lfl.2
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=WN01e0l1+WdxQJa+iowT/x59ccthHRPG+MX9yqwnNBA=;
        b=k6eQUW56l8UrIWz2VghKJwhoP+InVqCMGkWpqHj8IB5vnlckcn1NfXqeDIn++xGzlB
         TZpLNsGKadS121SKMl1/k7fKlFEG8nt1DuoJyoovAJ4f16DqP+RGMaqdt9BCzUmJaNj/
         +PFK+YGtiPdrBSE//1i+jCmxh6PUDJcj0lps/RZsXNS8R3lWzTWXmB8CK8G+j5ylrI9N
         E4NMTCIFy70mWuO4uo4gQFAZgjKKBPfKBiGA5ZHWieT6Tg7ncfYvtUPJWIv09VaCCNSO
         ek/MIL8VLbZaIbMON+6Q3Iw2BXmg1QF5zg1J0MHa2v7Cx+iFzYL2FzrNP9mbYxMNgZAp
         Jtaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=WN01e0l1+WdxQJa+iowT/x59ccthHRPG+MX9yqwnNBA=;
        b=1UFgstYDYb1cgMPhYPEHfaRdbaCPJ1Nfql7lLcT1A0rjWKtz4FZJKFJEbK4nYSTPq3
         bVyuB9q3JvjXWmu/amESEy/pEWsnYEOLb/FYzKKigTK9XJa0tlKVjkMe2Qu9h6ZaCTfz
         tDG2TQiJscnQxtM6W/MDCjIx9ipwctoudwMxT6XehzZDnSSceN3oI/C2ndhiP9gfjdWg
         8LN6aXXxKxwU4NUDMOeMInlXN7N4zhicnZFHktzYGBhj8ok/H8mU4c5mnCPn+NChA53g
         cP46oMDJ7bwc7HaRArPaLZ8m1gK21oG/6oRQObpMr5UCzbZfHUT5qMA4zfUBEuYMKJBB
         J9zA==
X-Gm-Message-State: AOAM533qXpU5mg6gUEP5O3Scr2T+Qs4IvtCTLBkDzUkZPZiE5inxI1LJ
        QDzq/3cabpv3azyl3/s5yB4=
X-Google-Smtp-Source: ABdhPJxL1DL50hKc+7ns26+XXgUelg2bDzOAYxg04ol0LvoKPy/1y7xh9WY/lhwoxpLiyuj+09tBTg==
X-Received: by 2002:a05:6512:3046:b0:44b:121:4541 with SMTP id b6-20020a056512304600b0044b01214541mr21189810lfb.313.1649684333105;
        Mon, 11 Apr 2022 06:38:53 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:38:52 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 01/13] net: bridge: add control of bum flooding to bridge itself
Date:   Mon, 11 Apr 2022 15:38:25 +0200
Message-Id: <20220411133837.318876-2-troglobit@gmail.com>
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

The bridge itself is also a port, but unfortunately it does not (yet)
have a 'struct net_bridge_port'.  However, in many cases we want to
treat it as a proper port so concessions have been made, e.g., NULL
port or host_joined attributes.

This patch is an attempt to more of the same by adding support for
controlling flooding of unknown broadcast/unicast/multicast to the
bridge.  Something we often also want to control in an offloaded
switching fabric.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 net/bridge/br_device.c  |  4 ++++
 net/bridge/br_input.c   | 11 ++++++++---
 net/bridge/br_private.h |  3 +++
 3 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 8d6bab244c4a..0aa7d21ac82c 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -526,6 +526,10 @@ void br_dev_setup(struct net_device *dev)
 	br->bridge_ageing_time = br->ageing_time = BR_DEFAULT_AGEING_TIME;
 	dev->max_mtu = ETH_MAX_MTU;
 
+	br_opt_toggle(br, BROPT_UNICAST_FLOOD, 1);
+	br_opt_toggle(br, BROPT_MCAST_FLOOD, 1);
+	br_opt_toggle(br, BROPT_BCAST_FLOOD, 1);
+
 	br_netfilter_rtable_init(br);
 	br_stp_timer_init(br);
 	br_multicast_init(br);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 196417859c4a..d439b876bdf5 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -118,7 +118,8 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		/* by definition the broadcast is also a multicast address */
 		if (is_broadcast_ether_addr(eth_hdr(skb)->h_dest)) {
 			pkt_type = BR_PKT_BROADCAST;
-			local_rcv = true;
+			if (br_opt_get(br, BROPT_BCAST_FLOOD))
+				local_rcv = true;
 		} else {
 			pkt_type = BR_PKT_MULTICAST;
 			if (br_multicast_rcv(&brmctx, &pmctx, vlan, skb, vid))
@@ -161,12 +162,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 			}
 			mcast_hit = true;
 		} else {
-			local_rcv = true;
-			br->dev->stats.multicast++;
+			if (br_opt_get(br, BROPT_MCAST_FLOOD)) {
+				local_rcv = true;
+				br->dev->stats.multicast++;
+			}
 		}
 		break;
 	case BR_PKT_UNICAST:
 		dst = br_fdb_find_rcu(br, eth_hdr(skb)->h_dest, vid);
+		if (!dst && br_opt_get(br, BROPT_UNICAST_FLOOD))
+			local_rcv = true;
 		break;
 	default:
 		break;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 18ccc3d5d296..683bd0ee4c64 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -449,6 +449,9 @@ enum net_bridge_opts {
 	BROPT_VLAN_BRIDGE_BINDING,
 	BROPT_MCAST_VLAN_SNOOPING_ENABLED,
 	BROPT_MST_ENABLED,
+	BROPT_UNICAST_FLOOD,
+	BROPT_MCAST_FLOOD,
+	BROPT_BCAST_FLOOD,
 };
 
 struct net_bridge {
-- 
2.25.1

