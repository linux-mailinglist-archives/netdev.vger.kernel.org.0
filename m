Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7925022960D
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbgGVK3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:29:12 -0400
Received: from mail-eopbgr50072.outbound.protection.outlook.com ([40.107.5.72]:59498
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730296AbgGVK3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 06:29:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oaq3++vlO8HC0aA5FMCIgVXKIeRkpS8zRu6kG6Hjc+vbH7APNPN3FWHjo0WoCelfAbSGfcq8tNDZvYup0TCJYYluoHxFWZDp1cdVYsGeHaB6hsTePbrA2jZM3hryNlCTGIGY07gThdeotD6oigGbFQ7cDatkTT+1WoZQfTAOUENL2wGM7c7HYEQkKy6t/r/d2TtDdzkWDFIEKUBBX/qSdWQLEq6YCC6efm/06EqsU7D7DLPqa7vQmWmCwf2NpLQ/GyiY5tixCAtIIlUS2RKBBAmCP0DsMUtEWiVO5INJRJHeITawfCVaKy5BPagw93kql252UQmOa5tmpXNcsKiSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fEuhfbbpQ5hujEdrQ2HX0XIduN1nTKiY8RF5tU9uPM=;
 b=EBc0KYd5+yYV7/7Z+pwFgrrh3yEYfsFop/6nskOKMPrcBFWnH41Jt5EI80rN1ARwKVmFY17E1FwE0mr4+Uip7pxx6YKtRdJ3O+R02ylHd+n11Oj86+nhHEmMuH1bw8NnvMy4LA1vrFaRHidZ29j+F7wgZCw8NDYlVPlu9m7Gx44cPTOKuw7WrBDpVQd3t3quo97+XxG7cU1OY21n9MQ88VSYqJR4I+hToxr93u/4P+txeCxtVqQ5BTTUkMOMfmi2zWdGr/28mgSYxVAxh2iFyhh7ZP7GEulzAtseJ6WqfgKhJM/JxSP+Jv6tUDga7gJWc/5BCNCMvIE7RTcxLsYaEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8fEuhfbbpQ5hujEdrQ2HX0XIduN1nTKiY8RF5tU9uPM=;
 b=YB5UtrFAIvLKqb6GyCRpXjKp4xq4aAA5sVL2/HBM4VJBuL+LB7pFJ/JmWsk4986/+F3aOM4GbuSVjNy/YLB2sNts+Euei45biHfMFJkN9ifk7mlFo4o5B9NAjpWarp1BCSbyywyyUP+FE6LqaCuFbdfhf2PybIGBvZV5jc6oMb0=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB3151.eurprd04.prod.outlook.com (2603:10a6:802:6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.20; Wed, 22 Jul
 2020 10:29:07 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::596d:cc81:f48a:daf7%2]) with mapi id 15.20.3216.022; Wed, 22 Jul 2020
 10:29:07 +0000
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
        UNGLinuxDriver@microchip.com, ivecera@redhat.com
Cc:     "hongbo.wang" <hongbo.wang@nxp.com>
Subject: [PATCH v3 1/2] net: dsa: Add protocol support for 802.1AD when adding or  deleting vlan for dsa switch and port
Date:   Wed, 22 Jul 2020 18:31:59 +0800
Message-Id: <20200722103200.15395-2-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200722103200.15395-1-hongbo.wang@nxp.com>
References: <20200722103200.15395-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Wed, 22 Jul 2020 10:29:00 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e2a3438-524e-477a-9fb4-08d82e2a1072
X-MS-TrafficTypeDiagnostic: VI1PR04MB3151:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB3151ABDBA4040774B182B229E1790@VI1PR04MB3151.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aZf3d1sU9C96hk6pw3478Bh0WzR5Bmph4q8KJRV589cHLBrRAIrU+lzJv+h/xeu77hYHQVlsOPjORWW76DYv6T0NNOuiFufzNk5aJSZM+iYsnr0bIRxTqCi0fbZ/DJvARdPfqX6TRwaDrMTEjCNtP747lTrEdq39njzyuA+gNx0YnFfTeZtcy2QDvJ2JQmVXt0askyzI0njOD+PstNNzUTEpLk3LZqXDrC1xcxQ3tPU7m2kah810YS8f9YbBUkHWaast6SmYFeWxNvETnHRD7xcL85Ly2w8Hu8wf86asp2GaUjX+YODK0PO6gRGBtVVMgxinRU7qpqcUdCkJTRwHfh4rVlOr4Nhd9S6AckprMepB2EEihIIM1r/HJQ1IAfUZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(8936002)(7416002)(2906002)(66476007)(66556008)(66946007)(8676002)(83380400001)(1076003)(6486002)(36756003)(6512007)(316002)(5660300002)(9686003)(6506007)(478600001)(86362001)(2616005)(956004)(16526019)(186003)(26005)(4326008)(52116002)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TqfobscGQdF4NJyCkT4r9md/ait7tCuFoOZvAJMA1p2M3uetk0LoFTxu0VBBd9O2ERgVjHc/eUSCPbKyRyVkRFCzUmPDfzAVV8Xj8Pu+E8oCX+ZyhYSxBQ7XCdJYoPAAvgHDU+R4RJPLLmgOGjmFU2FUlmzG0+eOM4d/TEIYiVsoAnv4mS3ZjnqFl33PRVRv7Gvc1DjSNZQ4WKDxCSrF8vMQbIFWxzi4R8tve8Pt+FxH3kn1NgyvloZ0AkiPiV16eXoosMNOSG2c9BFEngJwzf4y9R99BByK+HrdW5YaG/wStT9gFN0meJPrYfHHMAKtVhJhVudKHhiI34AR8P08xlgxIurPXNDCefMVtU/tGn0IF7Cgh5uHFpdrEYDAtESHRReImNDko5qqO4mHsBEdnKerZMl7ysTrH8ta2Cu3UPtqLJGd2rTd6C/+n1P/GNEtI789tJizrfWbXMC56pA1C/IdKS6D+ieFxWm7je83qmJgFbzUZSyTfLWlNgN71Zl1
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e2a3438-524e-477a-9fb4-08d82e2a1072
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2020 10:29:07.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ts24L4ChuwOuUDzZSx5WmApzyYStUh01bRcKA0twZkXQkKqjuE9HJs5xfVjQ8Ri4Qqn2M1cC8uOJGnmW+kme5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3151
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
 net/dsa/port.c          | 6 ++++--
 net/dsa/slave.c         | 9 +++++----
 net/dsa/tag_8021q.c     | 4 ++--
 5 files changed, 14 insertions(+), 10 deletions(-)

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
index e23ece229c7e..c98bbac3980a 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -433,13 +433,14 @@ int dsa_port_vlan_del(struct dsa_port *dp,
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
@@ -454,12 +455,13 @@ int dsa_port_vid_add(struct dsa_port *dp, u16 vid, u16 flags)
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

