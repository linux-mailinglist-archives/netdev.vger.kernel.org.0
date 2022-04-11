Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBFE4FBD6C
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346609AbiDKNlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346570AbiDKNlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:41:12 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB66222B3
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:57 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id bn33so20132563ljb.6
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 06:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=DSRcc4cQuRQfjO5ws3ys+XQ4CrSo1tNDaNbQ7j9cAHE=;
        b=AUEdjlBM7ypyirvB5ZGOPXA9+wdMGwDzlWRxJUW2YESDOXXAhx29foqjE2BZwX6F4X
         ppeYtNJRg1uY9mqnSpLa4BmGrwoafD427QNp/3wI6He/bIUaDT0N7tA0ZwXS+zMbykZH
         kAVmlbp+UG2hfQCvBflsLla6crUMmMSKAkHbxtoNWthJFC2/PdFiHBrDGWf2LipayZSh
         ZnyhPEp6PWqBAiLmPBjFycMpZO9mrM+hryVf48XQS0UZyHHeoHA+pgVjiREO9fHcAXbc
         fiTJt1zsZhKY5pupgIz9lGz2n1ezkYM0c7Ow02JphNuxkheWU65FuFuqIjaELxZyV7Sj
         k0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=DSRcc4cQuRQfjO5ws3ys+XQ4CrSo1tNDaNbQ7j9cAHE=;
        b=2UU0Qen9U4xwwZP/CJ/ir+ceEfOuw2lMm4+pziGWX4sKetIVBOHLSCjC49bYWnQHpa
         xGRpjLedziHlU04N8jr2+s9L3FtR+z6MXu2LnfxPG8G6TEXKsTT4QEcYumOvV7CZlpKo
         Uqp29rX2h+vM/sb6foEyGeumXt/Aj8UpQxl1wdNjzrj77rpaWtuTov1ov9jrbThzmQZA
         UvDMpJwC6iHizq+jnOk5+AHQHVJxXh8CDmPJ6kSEPDttNxCDjgDp89cCP8IyZvu1N8VX
         tx0X6LVLqdb5w3YwRBlcVZau49dqHlrt0I9+eC9gj/Xl4g2ZK2BJtCCxAePA4NNL35/F
         ssCA==
X-Gm-Message-State: AOAM530Nu16bWCKdkynYPixlSVyFP6voQW19YgtOO4xuN3xnbK/5U/E8
        Nj8CkPdfFSVHpPutDXe0GPs=
X-Google-Smtp-Source: ABdhPJzFVd+o/fG8WImDGh0V3CGrdKyAxclb2kQMHcgQRzaDb3tCfi7H+2vhH48BPlGQwvhPC1ZzMw==
X-Received: by 2002:a05:651c:b14:b0:24b:638d:dfe4 with SMTP id b20-20020a05651c0b1400b0024b638ddfe4mr3152246ljr.314.1649684335985;
        Mon, 11 Apr 2022 06:38:55 -0700 (PDT)
Received: from wbg.labs.westermo.se (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p12-20020a056512138c00b0044833f1cd85sm3336847lfa.62.2022.04.11.06.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 06:38:55 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Joachim Wiberg <troglobit@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC net-next 04/13] net: bridge: netlink support for controlling BUM flooding to bridge
Date:   Mon, 11 Apr 2022 15:38:28 +0200
Message-Id: <20220411133837.318876-5-troglobit@gmail.com>
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

This patch adds netlink support for controlling the new broadcast,
unicast, and multicast flooding flags to the bridge itself.

The messy part is in br_setport(), which re-indents a large block of
code for the port settings.  To reduce code duplication a few new
variables have been added; new_flags and dev.  The latter is used for
the recently renamed br_switchdev_set_dev_flag(), which can now be used
by underlying switching fabric drivers as another source of information
when controlling flooding of unknown BUM traffic to the CPU port.

Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
---
 net/bridge/br_netlink.c | 160 ++++++++++++++++++++++++++++++----------
 1 file changed, 123 insertions(+), 37 deletions(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 8f4297287b32..68bbf703b31a 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -225,13 +225,29 @@ static inline size_t br_nlmsg_size(struct net_device *dev, u32 filter_mask)
 		+ nla_total_size(4); /* IFLA_BRPORT_BACKUP_PORT */
 }
 
-static int br_port_fill_attrs(struct sk_buff *skb,
+static int br_port_fill_attrs(struct sk_buff *skb, const struct net_bridge *br,
 			      const struct net_bridge_port *p)
 {
-	u8 mode = !!(p->flags & BR_HAIRPIN_MODE);
 	struct net_bridge_port *backup_p;
 	u64 timerval;
+	u8 mode;
 
+	if (!p) {
+		if (!br)
+			return -EINVAL;
+
+		if (nla_put_u8(skb, IFLA_BRPORT_UNICAST_FLOOD,
+			       br_opt_get(br, BROPT_UNICAST_FLOOD)) ||
+		    nla_put_u8(skb, IFLA_BRPORT_MCAST_FLOOD,
+			       br_opt_get(br, BROPT_MCAST_FLOOD)) ||
+		    nla_put_u8(skb, IFLA_BRPORT_BCAST_FLOOD,
+			       br_opt_get(br, BROPT_BCAST_FLOOD)))
+			return -EMSGSIZE;
+
+		return 0;
+	}
+
+	mode = !!(p->flags & BR_HAIRPIN_MODE);
 	if (nla_put_u8(skb, IFLA_BRPORT_STATE, p->state) ||
 	    nla_put_u16(skb, IFLA_BRPORT_PRIORITY, p->priority) ||
 	    nla_put_u32(skb, IFLA_BRPORT_COST, p->path_cost) ||
@@ -475,11 +491,11 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 	     nla_put_u32(skb, IFLA_LINK, dev_get_iflink(dev))))
 		goto nla_put_failure;
 
-	if (event == RTM_NEWLINK && port) {
+	if (event == RTM_NEWLINK) {
 		struct nlattr *nest;
 
 		nest = nla_nest_start(skb, IFLA_PROTINFO);
-		if (nest == NULL || br_port_fill_attrs(skb, port) < 0)
+		if (!nest || br_port_fill_attrs(skb, br, port) < 0)
 			goto nla_put_failure;
 		nla_nest_end(skb, nest);
 	}
@@ -911,43 +927,113 @@ static void br_set_port_flag(struct net_bridge_port *p, struct nlattr *tb[],
 		p->flags &= ~mask;
 }
 
+/* Map bridge options to brport flags */
+static unsigned long br_boolopt_map_flags(struct br_boolopt_multi *bm)
+{
+	unsigned long bitmap = bm->optmask;
+	unsigned long bitmask = 0;
+	int opt_id;
+
+	for_each_set_bit(opt_id, &bitmap, BR_BOOLOPT_MAX) {
+		if (!(bm->optval & BIT(opt_id)))
+			continue;
+
+		switch (opt_id) {
+		case BROPT_UNICAST_FLOOD:
+			bitmask |= BR_FLOOD;
+			break;
+		case BROPT_MCAST_FLOOD:
+			bitmask |= BR_MCAST_FLOOD;
+			break;
+		case BROPT_BCAST_FLOOD:
+			bitmask |= BR_BCAST_FLOOD;
+			break;
+		}
+	}
+
+	return bitmask;
+}
+
+static void br_set_bropt(struct net_bridge *br, struct nlattr *tb[],
+			 int attrtype, enum net_bridge_opts opt)
+{
+	if (!tb[attrtype])
+		return;
+
+	br_opt_toggle(br, opt, !!nla_get_u8(tb[attrtype]));
+}
+
+#define BROPT_MASK (BROPT_UNICAST_FLOOD | BROPT_MCAST_FLOOD | BROPT_MCAST_FLOOD)
+
 /* Process bridge protocol info on port */
-static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
-		      struct netlink_ext_ack *extack)
+static int br_setport(struct net_bridge *br, struct net_bridge_port *p,
+		      struct nlattr *tb[], struct netlink_ext_ack *extack)
 {
-	unsigned long old_flags, changed_mask;
+	unsigned long old_flags, new_flags, changed_mask;
+	struct br_boolopt_multi old_opts = {
+		.optmask = BROPT_MASK
+	};
 	bool br_vlan_tunnel_old;
+	struct net_device *dev;
 	int err;
 
-	old_flags = p->flags;
-	br_vlan_tunnel_old = (old_flags & BR_VLAN_TUNNEL) ? true : false;
-
-	br_set_port_flag(p, tb, IFLA_BRPORT_MODE, BR_HAIRPIN_MODE);
-	br_set_port_flag(p, tb, IFLA_BRPORT_GUARD, BR_BPDU_GUARD);
-	br_set_port_flag(p, tb, IFLA_BRPORT_FAST_LEAVE,
-			 BR_MULTICAST_FAST_LEAVE);
-	br_set_port_flag(p, tb, IFLA_BRPORT_PROTECT, BR_ROOT_BLOCK);
-	br_set_port_flag(p, tb, IFLA_BRPORT_LEARNING, BR_LEARNING);
-	br_set_port_flag(p, tb, IFLA_BRPORT_UNICAST_FLOOD, BR_FLOOD);
-	br_set_port_flag(p, tb, IFLA_BRPORT_MCAST_FLOOD, BR_MCAST_FLOOD);
-	br_set_port_flag(p, tb, IFLA_BRPORT_MCAST_TO_UCAST,
-			 BR_MULTICAST_TO_UNICAST);
-	br_set_port_flag(p, tb, IFLA_BRPORT_BCAST_FLOOD, BR_BCAST_FLOOD);
-	br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP, BR_PROXYARP);
-	br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP_WIFI, BR_PROXYARP_WIFI);
-	br_set_port_flag(p, tb, IFLA_BRPORT_VLAN_TUNNEL, BR_VLAN_TUNNEL);
-	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
-	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
-	br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
-
-	changed_mask = old_flags ^ p->flags;
-
-	err = br_switchdev_set_dev_flag(p->dev, p->flags, changed_mask, extack);
+	if (p) {
+		old_flags = p->flags;
+		br_vlan_tunnel_old = (old_flags & BR_VLAN_TUNNEL) ? true : false;
+
+		br_set_port_flag(p, tb, IFLA_BRPORT_MODE, BR_HAIRPIN_MODE);
+		br_set_port_flag(p, tb, IFLA_BRPORT_GUARD, BR_BPDU_GUARD);
+		br_set_port_flag(p, tb, IFLA_BRPORT_FAST_LEAVE,
+				 BR_MULTICAST_FAST_LEAVE);
+		br_set_port_flag(p, tb, IFLA_BRPORT_PROTECT, BR_ROOT_BLOCK);
+		br_set_port_flag(p, tb, IFLA_BRPORT_LEARNING, BR_LEARNING);
+		br_set_port_flag(p, tb, IFLA_BRPORT_UNICAST_FLOOD, BR_FLOOD);
+		br_set_port_flag(p, tb, IFLA_BRPORT_MCAST_FLOOD, BR_MCAST_FLOOD);
+		br_set_port_flag(p, tb, IFLA_BRPORT_MCAST_TO_UCAST,
+				 BR_MULTICAST_TO_UNICAST);
+		br_set_port_flag(p, tb, IFLA_BRPORT_BCAST_FLOOD, BR_BCAST_FLOOD);
+		br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP, BR_PROXYARP);
+		br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP_WIFI, BR_PROXYARP_WIFI);
+		br_set_port_flag(p, tb, IFLA_BRPORT_VLAN_TUNNEL, BR_VLAN_TUNNEL);
+		br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
+		br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
+		br_set_port_flag(p, tb, IFLA_BRPORT_LOCKED, BR_PORT_LOCKED);
+
+		new_flags = p->flags;
+		dev = p->dev;
+	} else {
+		struct br_boolopt_multi opts = {
+			.optmask = BROPT_MASK
+		};
+
+		br_boolopt_multi_get(br, &old_opts);
+		old_flags = br_boolopt_map_flags(&old_opts);
+
+		br_set_bropt(br, tb, IFLA_BRPORT_UNICAST_FLOOD, BROPT_UNICAST_FLOOD);
+		br_set_bropt(br, tb, IFLA_BRPORT_MCAST_FLOOD, BROPT_MCAST_FLOOD);
+		br_set_bropt(br, tb, IFLA_BRPORT_BCAST_FLOOD, BROPT_BCAST_FLOOD);
+
+		br_boolopt_multi_get(br, &opts);
+		new_flags = br_boolopt_map_flags(&opts);
+		dev = br->dev;
+	}
+
+	changed_mask = old_flags ^ new_flags;
+
+	err = br_switchdev_set_dev_flag(dev, new_flags, changed_mask, extack);
 	if (err) {
-		p->flags = old_flags;
+		if (!p)
+			br_boolopt_multi_toggle(br, &old_opts, extack);
+		else
+			p->flags = old_flags;
+
 		return err;
 	}
 
+	/* Skip the rest for the bridge itself, for now */
+	if (!p)
+		return 0;
+
 	if (br_vlan_tunnel_old && !(p->flags & BR_VLAN_TUNNEL))
 		nbp_vlan_tunnel_info_flush(p);
 
@@ -1048,7 +1134,7 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 	if (!p && !afspec)
 		return -EINVAL;
 
-	if (p && protinfo) {
+	if (protinfo) {
 		if (protinfo->nla_type & NLA_F_NESTED) {
 			err = nla_parse_nested_deprecated(tb, IFLA_BRPORT_MAX,
 							  protinfo,
@@ -1058,9 +1144,9 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
 				return err;
 
 			spin_lock_bh(&br->lock);
-			err = br_setport(p, tb, extack);
+			err = br_setport(br, p, tb, extack);
 			spin_unlock_bh(&br->lock);
-		} else {
+		} else if (p) {
 			/* Binary compatibility with old RSTP */
 			if (nla_len(protinfo) < sizeof(u8))
 				return -EINVAL;
@@ -1153,7 +1239,7 @@ static int br_port_slave_changelink(struct net_device *brdev,
 		return 0;
 
 	spin_lock_bh(&br->lock);
-	ret = br_setport(br_port_get_rtnl(dev), data, extack);
+	ret = br_setport(br, br_port_get_rtnl(dev), data, extack);
 	spin_unlock_bh(&br->lock);
 
 	return ret;
@@ -1163,7 +1249,7 @@ static int br_port_fill_slave_info(struct sk_buff *skb,
 				   const struct net_device *brdev,
 				   const struct net_device *dev)
 {
-	return br_port_fill_attrs(skb, br_port_get_rtnl(dev));
+	return br_port_fill_attrs(skb, NULL, br_port_get_rtnl(dev));
 }
 
 static size_t br_port_get_slave_size(const struct net_device *brdev,
-- 
2.25.1

