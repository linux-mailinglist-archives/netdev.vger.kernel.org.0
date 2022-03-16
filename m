Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE3C4DB45B
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 16:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357013AbiCPPLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 11:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357021AbiCPPKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 11:10:49 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5745F4ED
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:15 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id w12so4228512lfr.9
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=TJ/ysLEqmTIrEKAi22qClFzQAMPt3L4KxozAj/kLyzE=;
        b=hWyG+mS9Kxs+/LhY6K5HDdevwY5y0klEWciUDA/sqtLTCzp0tYUn6erX4d36ClkWSI
         VucLJnX+1P9Nj2S4aDw+ehQ4mk/jBhbbC+vjiX3HlzPHnnI685RXwraSVt+RmrsQP7yN
         37VfSi3BGd/kPpMqU6yBeTLtn5xl1ZITJmwrwQPGfqxykFdQr7GTjj6CjXhxKSY2jS6H
         TgWaGAMcQWl4D/+cEXhRkozGZuXibto8+xIsb3xSiHbjumN0Y71L3/DyI2kkog2Q6WCk
         EhBt6bWXm5DxArP+Bl+oqC07OOXg15f13k7yLkIbTlCsGOvh2b6uhgRuwPa+ly6fUYE2
         z16g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=TJ/ysLEqmTIrEKAi22qClFzQAMPt3L4KxozAj/kLyzE=;
        b=Brb9GdCZ1HIEBkQeP1f0YLb8flYrq9p+pg5/OsOv2TnOmV2F05R89Y6koBXmhbGXER
         sHVhlkoy5zlkhw+msh7BibnGyw9AJWP7EhwhSW0/iVq095H/AkulsCNWc6AFqSRuIqD3
         GW2sEVm/COR+Le6+m3DjabN7pXIHhA1Tu7T3OTQSbsr62jemJvs3b6aR76K7wWwqPUvV
         pYhAQdK68as8wnka5DRLY9fOhT5JM/wq4Y4g4tcCe1mC82x/Vtco11sLn2KUDh913hs9
         vIdIotpTsa7o31wBpNzW7Cl6oTTljl0fwES5QKfHazKNtCxVjVDHgKsxK1+gbgsJ60mi
         0Ctw==
X-Gm-Message-State: AOAM532OsBs5M9QgkS+PXNu/zUEXqRpEEhCr37tGDyiaJaW17bUhczsi
        doDy8ZSwf41XkZ6KYZNqEEffAQ==
X-Google-Smtp-Source: ABdhPJw3W+6hr7k/Qow2M2vxSYXUq9mv18Pdhd6yxNSHz8e12lhOMe1mcDcpa4gpziOw0j9E2jPupw==
X-Received: by 2002:ac2:48b5:0:b0:448:b9cf:ad2 with SMTP id u21-20020ac248b5000000b00448b9cf0ad2mr63639lfg.153.1647443353835;
        Wed, 16 Mar 2022 08:09:13 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id d2-20020a194f02000000b00448b915e2d3sm176048lfb.99.2022.03.16.08.09.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:09:13 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Subject: [PATCH v5 net-next 07/15] net: bridge: mst: Add helper to map an MSTI to a VID set
Date:   Wed, 16 Mar 2022 16:08:49 +0100
Message-Id: <20220316150857.2442916-8-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220316150857.2442916-1-tobias@waldekranz.com>
References: <20220316150857.2442916-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_mst_get_info answers the question: "On this bridge, which VIDs are
mapped to the given MSTI?"

This is useful in switchdev drivers, which might have to fan-out
operations, relating to an MSTI, per VLAN.

An example: When a port's MST state changes from forwarding to
blocking, a driver may choose to flush the dynamic FDB entries on that
port to get faster reconvergence of the network, but this should only
be done in the VLANs that are managed by the MSTI in question.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 include/linux/if_bridge.h |  7 +++++++
 net/bridge/br_mst.c       | 26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 3aae023a9353..1cf0cc46d90d 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -119,6 +119,7 @@ int br_vlan_get_info(const struct net_device *dev, u16 vid,
 		     struct bridge_vlan_info *p_vinfo);
 int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 			 struct bridge_vlan_info *p_vinfo);
+int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids);
 #else
 static inline bool br_vlan_enabled(const struct net_device *dev)
 {
@@ -151,6 +152,12 @@ static inline int br_vlan_get_info_rcu(const struct net_device *dev, u16 vid,
 {
 	return -EINVAL;
 }
+
+static inline int br_mst_get_info(const struct net_device *dev, u16 msti,
+				  unsigned long *vids)
+{
+	return -EINVAL;
+}
 #endif
 
 #if IS_ENABLED(CONFIG_BRIDGE)
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 00935a19afcc..00b36e629224 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -13,6 +13,32 @@
 
 DEFINE_STATIC_KEY_FALSE(br_mst_used);
 
+int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
+{
+	const struct net_bridge_vlan_group *vg;
+	const struct net_bridge_vlan *v;
+	const struct net_bridge *br;
+
+	ASSERT_RTNL();
+
+	if (!netif_is_bridge_master(dev))
+		return -EINVAL;
+
+	br = netdev_priv(dev);
+	if (!br_opt_get(br, BROPT_MST_ENABLED))
+		return -EINVAL;
+
+	vg = br_vlan_group(br);
+
+	list_for_each_entry(v, &vg->vlan_list, vlist) {
+		if (v->msti == msti)
+			__set_bit(v->vid, vids);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(br_mst_get_info);
+
 static void br_mst_vlan_set_state(struct net_bridge_port *p, struct net_bridge_vlan *v,
 				  u8 state)
 {
-- 
2.25.1

