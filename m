Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB02227DF4
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 12:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729426AbgGUK7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 06:59:39 -0400
Received: from mail-db8eur05on2083.outbound.protection.outlook.com ([40.107.20.83]:23072
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726611AbgGUK7i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 06:59:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LbLFE2Z4tRTqikyVUhBqikyq7ykklfEb7uJkOGB5vHYKg7KMZtVQCuGd8DRBgeehN4Qux3m0XtW2OtSMp2WIQR5/RWMsTjiCG5UGfeM52wLV475IvhGB4LL+dWdwnrf1ceko7kpYSEl20ajgxrubJk/xJeLMdj4JF9UFd4EOSGlVWj28eLkpHVrA2OAbGU3fSWiZVBemRXgZliQ08IFL4154nZGFSL+6+Tx1vILraYchcDE0VBorhFszHJyQwoksZuYUZ/t8U0Y6J3hVWlFxZ3GiyBfCmDQUWbp6fV5Lkb3GgewnutDykGsnIbEGemEG5evBNvbIVtMwEvu4XJdOCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xl5ijXLVCLXqq1DsMaHFBASTOUzrnJrx12/OosiibuQ=;
 b=dUZ+ZmyGiQHhSUmnVUNJEvVpNRZoKZs0eiRUKJC1/LZgUM5JX984X7X8f9dRBTeNrRT/c3pp9NghDVRveJAXF4h7lFIA3cUpsGePNNsnOC+ITnkyPqXH0UBzY3S5xoQWxf2Y926LA8XfrlKOGFmxltQ+hcMTu3id8pFMuAexSO4zv6dcJjz8+aT+0m9eJcKnMUZN6FrJi93JgnP7qw7jU4ouGT1QBHhmZzQsziQmD7r+c0mskqPIbk+8yTCrPhk430a86pboStzMr/weTZPQ8OBSZK0NxwS9za7djPWnyTY21BVMNwym2gT17AKq76iMvaFg0YRgdKtnt1Z9QxusKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xl5ijXLVCLXqq1DsMaHFBASTOUzrnJrx12/OosiibuQ=;
 b=iwOnZaca5AJ5i0jaT1MfLppbXqb6SbxmoCoLz8bT5jZ5T8vr7FGEiNX8Aq2/aLOOQAz5QeNlbDfGlkXoKqhEbaplQ+JHGGTAAa7r0V7m2LurGd3MGi/a1MKg4s7R3/BWa2Y0NWCsAir15KnoQ2LwReAMhgPtP8Xez1UjyJnYU7Q=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB3245.eurprd04.prod.outlook.com (2603:10a6:802:6::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.23; Tue, 21 Jul
 2020 10:59:33 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 10:59:33 +0000
From:   hongbo.wang@nxp.com
To:     xiaoliang.yang_1@nxp.com, allan.nielsen@microchip.com,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, vladimir.oltean@nxp.com,
        leoyang.li@nxp.com, mingkai.hu@nxp.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, vinicius.gomes@intel.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, linux-devel@linux.nxdi.nxp.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH] net: dsa: Add protocol support for 802.1AD when adding or deleting vlan for dsa switch and port
Date:   Tue, 21 Jul 2020 19:02:14 +0800
Message-Id: <20200721110214.15268-1-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SGAP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::36)
 To VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SGAP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Tue, 21 Jul 2020 10:59:25 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd9515db-0253-48e1-0ded-08d82d65266d
X-MS-TrafficTypeDiagnostic: VI1PR04MB3245:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB3245EF5EA7D92EDCDD096AB6E1780@VI1PR04MB3245.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O6Qc55u3MIsLB0yVIa3Z90MI1y5wkQdg4fuXAqi24t4ARmDMUO4JejW0otuXOS0OSUfX5OqVEnTtJQ7tOkhcpVO3xmWH/ivrc1vPBBXpJqXeP0RUxjHvBK0fWwqBVZndFrRy8HdiMGBCuvxBK9JGvCWUy3ATnLpJadShy7wyCd1VOBjpypj0f/uU1Bbg3aXLsk+CgfJDsiA0FPp0qnVb6TANyhzPfqnj2YIZea0qtIL8Tm+/aA/suBC7LpJSn9kHLuO+L6ED0wC5AfSxw0N21bf5yTwJ+izHUf89/w99DKpu1z15oANK9h3g6mzUOdGdqTlKAa4mYIhsfHMRXHMxF6RA2BbCwqZ36yt1HPATGBcklWY23wT6OEQUVGNMUse+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(366004)(396003)(39860400002)(6666004)(6506007)(52116002)(2906002)(8676002)(5660300002)(66556008)(66476007)(186003)(6512007)(9686003)(16526019)(6486002)(8936002)(36756003)(26005)(83380400001)(66946007)(1076003)(956004)(478600001)(4326008)(2616005)(7416002)(316002)(86362001)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: e/fbNP+WU+aHCQd5m6O+TRR3uIeFEPE1wYoPp7zMwDV0mmrg0gvXDiIcar3oUNaUz8JrKB6vub5HApt1zOdKY3eBmtaPIpyNRkbJfyDxNQsYrG9WLl/Ulw20fa6UJ/mdavlvAZ2BaalPeVg79Eo/LB/W6Azcaf2Bl0sbzN1Ywq+p5Mucj78/4jEnEaoy9LxOIr/F1Ec68Ms4tZ7uG9rg9Rz/5rduX42cLuKN+Fzd3UFI6egsEFpylol2TwI/iChNVl79fXAl/GSbhumJp+NlFRwxAdSrXknP3AzIp4BzgYBvG8/9JKrt4PLlMbSMcX5mYiZd0VahJYFv1jaBw96I/baexp2hSCjfTvjc4DG8WN0ANJE5Aua6UlFgHV/5tFTvrv1Hw+NTgM5x6eIn8X4cKOIPIklihgaEjsekDOcUrgzfUL5nrcXTMAprbmfGtpvo3qHXfwD4CZ1vLSR+pt5ECjvVkoZsS1BKD5Zea65OLrE=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9515db-0253-48e1-0ded-08d82d65266d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 10:59:33.5361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TmDS7xBpqFzc+31bI8caGSSb8Onq8nIys+rPtk+xt95v7AbNQvAnw2PDH7vhjiXgoAHAivAxcZInk9cNex2eDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3245
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

the following command will be supported:
Add VLAN:
    ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100
Delete VLAN:
    ip link del link swp1 name swp1.100

when adding vlan, this patch only set protocol for user port,
cpu port don't care it, so set parameter proto to 0 for cpu port.

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 include/net/switchdev.h | 1 +
 net/dsa/dsa_priv.h      | 4 ++--
 net/dsa/port.c          | 7 ++++---
 net/dsa/slave.c         | 9 +++++----
 net/dsa/tag_8021q.c     | 4 ++--
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/net/switchdev.h b/include/net/switchdev.h
index ff2246914301..7594ea82879f 100644
--- a/include/net/switchdev.h
+++ b/include/net/switchdev.h
@@ -97,6 +97,7 @@ struct switchdev_obj_port_vlan {
 	u16 flags;
 	u16 vid_begin;
 	u16 vid_end;
+	u16 proto;
 };
 
 #define SWITCHDEV_OBJ_PORT_VLAN(OBJ) \
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 1653e3377cb3..52685b9875e5 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -164,8 +164,8 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 		      struct switchdev_trans *trans);
 int dsa_port_vlan_del(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan);
-int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags);
-int dsa_port_vid_del(struct dsa_port *dp, u16 vid);
+int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 proto, u16 flags);
+int dsa_port_vid_del(struct dsa_port *dp, u16 vid, u16 proto);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
 extern const struct phylink_mac_ops dsa_port_phylink_mac_ops;
diff --git a/net/dsa/port.c b/net/dsa/port.c
index e23ece229c7e..c07c6ee136a9 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -364,7 +364,6 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		.port = dp->index,
 		.addr = addr,
 		.vid = vid,
-
 	};
 
 	return dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
@@ -433,13 +432,14 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	return dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
-int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
+int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 proto, u16 flags)
 {
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.flags = flags,
 		.vid_begin = vid,
 		.vid_end = vid,
+		.proto = proto,
 	};
 	struct switchdev_trans trans;
 	int err;
@@ -454,12 +454,13 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
 }
 EXPORT_SYMBOL(dsa_port_vid_add);
 
-int dsa_port_vid_del(struct dsa_port *dp, u16 vid)
+int dsa_port_vid_del(struct dsa_port *dp, u16 vid, u16 proto)
 {
 	struct switchdev_obj_port_vlan vlan = {
 		.obj.id = SWITCHDEV_OBJ_ID_PORT_VLAN,
 		.vid_begin = vid,
 		.vid_end = vid,
+		.proto = proto,
 	};
 
 	return dsa_port_vlan_del(dp, &vlan);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 41d60eeefdbd..ba3984565f7e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1252,11 +1252,11 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 			return -EBUSY;
 	}
 
-	ret = dsa_port_vid_add(dp, vid, 0);
+	ret = dsa_port_vid_add(dp, vid, ntohs(proto), 0);
 	if (ret)
 		return ret;
 
-	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
+	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0, 0);
 	if (ret)
 		return ret;
 
@@ -1289,7 +1289,7 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vid_del(dp, vid, ntohs(proto));
 }
 
 struct dsa_hw_port {
@@ -1744,7 +1744,8 @@ int dsa_slave_create(struct dsa_port *port)
 
 	slave_dev->features = master->vlan_features | NETIF_F_HW_TC;
 	if (ds->ops->port_vlan_add && ds->ops->port_vlan_del)
-		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER;
+		slave_dev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
+				       NETIF_F_HW_VLAN_STAG_FILTER;
 	slave_dev->hw_features |= NETIF_F_HW_TC;
 	slave_dev->features |= NETIF_F_LLTX;
 	slave_dev->ethtool_ops = &dsa_slave_ethtool_ops;
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 780b2a15ac9b..848f85ed5c0f 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -152,9 +152,9 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (enabled)
-		return dsa_port_vid_add(dp, vid, flags);
+		return dsa_port_vid_add(dp, vid, 0, flags);
 
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vid_del(dp, vid, 0);
 }
 
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
-- 
2.17.1

