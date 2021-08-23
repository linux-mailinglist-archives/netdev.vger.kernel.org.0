Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E283F4808
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 11:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbhHWJ50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 05:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbhHWJ5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 05:57:22 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23047C061575;
        Mon, 23 Aug 2021 02:56:40 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id m17so2778813plc.6;
        Mon, 23 Aug 2021 02:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yne3gbAEgfLvuzl4ISOkMOkCXwKPNJ/FBTXv1EJmNsU=;
        b=YHDP74AbShnhW5meoBsQ1QYdIjc1c4tgZ6mqQmAVTFy848TGQQqIyv+LQ/0DbIvJIe
         4OEbNb6G4iCxHpmT7nK4EXbTum5BulylgPIakzGd2yr0czxgI7yOyVKBgrmTnf0mdaRn
         GfqfXyh2xAzSv3Sg2D7hNz5sMLwA9Dn8t9HnNKHrKhtBydgAdfL42vZMeYtcajYTTDd+
         3suCdMlFcSgZjpdYOJkUGIg1wcdnvEWHYKSOBm7r0MG6PPNIjERYe3/BwmZhLVZPiTHO
         7uc3wRgttdbRuookpJ/WH/xRCOrGUxAqmll3Kx32OJyVK+ca77M9PGDHWcUXOc8PplwD
         9X5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yne3gbAEgfLvuzl4ISOkMOkCXwKPNJ/FBTXv1EJmNsU=;
        b=oivT2aD62iyt0S1E7b9tAuT7BCV7eo9T6238W6nJ5s2PwVEZTb1P8gRK4ZgOBjja+6
         aTXXd6FtfaDkoH3UhMvjSTYm6rV1nGXRIwyJ0KuxBzeR9JmNEiznbV3TS16yhTG0MtNf
         O1Q1aw1lEccb/myQHkaMD0YwC3LcSyGQAdts3VhsX9j68wvBmsvaZJigV6/2Gl+xF+HE
         XlPzX/625L5OfLuxKQCt08W8nWqZScRD4XQv1KPc9N8mM0SvIg+bDxi0I3/l3ZkX0aud
         eu3SmIeaiN5s4i3REQl6de2me2iveBikQoStxPP7IK52Vrp5Gy9IykV/YUZDQ++5npnr
         SjEg==
X-Gm-Message-State: AOAM530+tgX/cpVpy8mMGXXGVtsRIdJH31bXPonVCY4f+ou0oWbvwhus
        hzAlH74Sp9LtiJcTRt0NJpE=
X-Google-Smtp-Source: ABdhPJwHG81pJecGw4CS54n5Ehnl98Eu8SCdM4WnNI/BGKDETYkhSMI6JGhVUIgtobCjFBNKTBNBRA==
X-Received: by 2002:a17:902:8348:b029:12b:b2a0:941b with SMTP id z8-20020a1709028348b029012bb2a0941bmr28027041pln.62.1629712599680;
        Mon, 23 Aug 2021 02:56:39 -0700 (PDT)
Received: from localhost.localdomain ([1.240.193.107])
        by smtp.googlemail.com with ESMTPSA id i5sm18538486pjk.47.2021.08.23.02.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 02:56:39 -0700 (PDT)
From:   Kangmin Park <l4stpr0gr4m@gmail.com>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next] net: bridge: change return type of br_handle_ingress_vlan_tunnel
Date:   Mon, 23 Aug 2021 18:56:34 +0900
Message-Id: <20210823095634.34752-1-l4stpr0gr4m@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_handle_ingress_vlan_tunnel() is only referenced in
br_handle_frame(). If br_handle_ingress_vlan_tunnel() is called and
return non-zero value, goto drop in br_handle_frame().

But, br_handle_ingress_vlan_tunnel() always return 0. So, the
routines that check the return value and goto drop has no meaning.

Therefore, change return type of br_handle_ingress_vlan_tunnel() to
void and remove if statement of br_handle_frame().

Signed-off-by: Kangmin Park <l4stpr0gr4m@gmail.com>
---
v2:
 - cleanup instead of modifying ingress function
 - change prototype of ingress function
 - cleanup br_handle_frame function
 - change commit message accordingly

 net/bridge/br_input.c          |  7 ++-----
 net/bridge/br_private_tunnel.h |  6 +++---
 net/bridge/br_vlan_tunnel.c    | 14 +++++++-------
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 8a0c0cc55cb4..b50382f957c1 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -294,11 +294,8 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 	memset(skb->cb, 0, sizeof(struct br_input_skb_cb));
 
 	p = br_port_get_rcu(skb->dev);
-	if (p->flags & BR_VLAN_TUNNEL) {
-		if (br_handle_ingress_vlan_tunnel(skb, p,
-						  nbp_vlan_group_rcu(p)))
-			goto drop;
-	}
+	if (p->flags & BR_VLAN_TUNNEL)
+		br_handle_ingress_vlan_tunnel(skb, p, nbp_vlan_group_rcu(p));
 
 	if (unlikely(is_link_local_ether_addr(dest))) {
 		u16 fwd_mask = p->br->group_fwd_mask_required;
diff --git a/net/bridge/br_private_tunnel.h b/net/bridge/br_private_tunnel.h
index c54cc26211d7..2b053289f016 100644
--- a/net/bridge/br_private_tunnel.h
+++ b/net/bridge/br_private_tunnel.h
@@ -38,9 +38,9 @@ int nbp_vlan_tunnel_info_add(const struct net_bridge_port *port, u16 vid,
 void nbp_vlan_tunnel_info_flush(struct net_bridge_port *port);
 void vlan_tunnel_info_del(struct net_bridge_vlan_group *vg,
 			  struct net_bridge_vlan *vlan);
-int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
-				  struct net_bridge_port *p,
-				  struct net_bridge_vlan_group *vg);
+void br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
+				   struct net_bridge_port *p,
+				   struct net_bridge_vlan_group *vg);
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
 				 struct net_bridge_vlan *vlan);
 bool vlan_tunid_inrange(const struct net_bridge_vlan *v_curr,
diff --git a/net/bridge/br_vlan_tunnel.c b/net/bridge/br_vlan_tunnel.c
index 01017448ebde..7d42b2a5be80 100644
--- a/net/bridge/br_vlan_tunnel.c
+++ b/net/bridge/br_vlan_tunnel.c
@@ -158,30 +158,30 @@ void vlan_tunnel_deinit(struct net_bridge_vlan_group *vg)
 	rhashtable_destroy(&vg->tunnel_hash);
 }
 
-int br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
-				  struct net_bridge_port *p,
-				  struct net_bridge_vlan_group *vg)
+void br_handle_ingress_vlan_tunnel(struct sk_buff *skb,
+				   struct net_bridge_port *p,
+				   struct net_bridge_vlan_group *vg)
 {
 	struct ip_tunnel_info *tinfo = skb_tunnel_info(skb);
 	struct net_bridge_vlan *vlan;
 
 	if (!vg || !tinfo)
-		return 0;
+		return;
 
 	/* if already tagged, ignore */
 	if (skb_vlan_tagged(skb))
-		return 0;
+		return;
 
 	/* lookup vid, given tunnel id */
 	vlan = br_vlan_tunnel_lookup(&vg->tunnel_hash, tinfo->key.tun_id);
 	if (!vlan)
-		return 0;
+		return;
 
 	skb_dst_drop(skb);
 
 	__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, vlan->vid);
 
-	return 0;
+	return;
 }
 
 int br_handle_egress_vlan_tunnel(struct sk_buff *skb,
-- 
2.26.2

