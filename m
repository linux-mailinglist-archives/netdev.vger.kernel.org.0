Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31CD223EC10
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 13:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgHGLLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 07:11:40 -0400
Received: from mail-am6eur05on2045.outbound.protection.outlook.com ([40.107.22.45]:38465
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728323AbgHGLLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 07:11:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e489ZBcFCSgR3z635ZDB4T1Y+8pr4q/5WM25rC61p04gyocmpiL9N8c/OXI6QlaOBTSNZkjKaGOan8gAfueGdVvZHFJ1SSV1PWYbU2sHq3liM9YMneSfVrwT2oiEweHUOLaZocOyPycCKVezKsham8mwk1sGLPv27cvwPrgSQk5ZY5TKkfY+CpktP4N6VFohKm/zl2UyXKPR4y9UxRSks8mxwm9V3fwfVdtW7ZvoSclGL3YwBoCju68N6DSVpolnMWDlmnhz1zYKvgzY5Yhr41RGA8MMY52//KNW4dWvhrhyxCgtIFi+Pdbl0JOun3V5vAR+IieL1xxJitfPWEVBGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2yAjuZa2uQw63XxMXocak9tjYXybGZNOIWyRZp5124=;
 b=g5KQZ9twCCSela+ySo4r4+mjbtfzyqwhxLtfi9gtyWFMBo1vlpDvV+oHf/XHHrs3JWjdnkcB8/yasx8zaC5e7aiK/1E6oO89/ySxlupUS3e2iM6F6xSyVUTJJ9x+V2NZQO3yffoEzwfqQ6yQVUpqDfhcqZUc9l80TBKTNT750TqG+CwhBh2Xb8Z5N7pb9DgmY7c8OTSsPesfy+W0GzUKZbrRQhFukEaRs5+EdxmHljtvxtZFgEHncXq/hKe6kawkKZJYD7wvaapMyWnGXt41QyEx42mrEeyfiJpnKMoHmN0W0GfUeI5HIF/nTe8dY6PpBUI1hPEsJAK7Eg8R7fc0rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W2yAjuZa2uQw63XxMXocak9tjYXybGZNOIWyRZp5124=;
 b=Goy587KJdXFX7Kz0uip6u0vJf3DlKzwkeFBmrc0dPH4Li9E3Uwel6zPV6h4yg3Wzr5ArD6cdxbqY7R58u5caTAMIeoz8BECxQruZ+wGcWy+K6nDy7c9XeaCga4iywTzT2KDgHaIqMXTD5Kr+xAMwx+KTl7hgDkH15Wql2nIO2ms=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com (2603:10a6:803:51::19)
 by VI1PR04MB5725.eurprd04.prod.outlook.com (2603:10a6:803:e3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.15; Fri, 7 Aug
 2020 11:11:23 +0000
Received: from VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3]) by VI1PR04MB5103.eurprd04.prod.outlook.com
 ([fe80::2c2c:20a4:38cd:73c3%7]) with mapi id 15.20.3261.020; Fri, 7 Aug 2020
 11:11:23 +0000
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
Subject: [PATCH v5 1/2] net: dsa: Add protocol support for 802.1AD when adding or  deleting vlan for dsa switch port
Date:   Fri,  7 Aug 2020 19:13:48 +0800
Message-Id: <20200807111349.20649-2-hongbo.wang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807111349.20649-1-hongbo.wang@nxp.com>
References: <20200807111349.20649-1-hongbo.wang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0218.apcprd06.prod.outlook.com
 (2603:1096:4:68::26) To VI1PR04MB5103.eurprd04.prod.outlook.com
 (2603:10a6:803:51::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from whb-OptiPlex-790.ap.freescale.net (119.31.174.73) by SG2PR06CA0218.apcprd06.prod.outlook.com (2603:1096:4:68::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19 via Frontend Transport; Fri, 7 Aug 2020 11:11:16 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [119.31.174.73]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: be2e0f0b-314a-414c-c235-08d83ac29ea3
X-MS-TrafficTypeDiagnostic: VI1PR04MB5725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB57258C716D1C14A3107E8889E1490@VI1PR04MB5725.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hJdmUiu7ByOzKXmKyrgpMJ8TdvnC4f76jWABbrZKA2LVAsscq3rGEojb2j03tcy/VvAzMDJvzGOpPoPiUQ117l72SpyezJEoMKJ6FJUYY+A6FJ6qd8C1BV/+p1jOpoND5fioclL6LRH83EGzQbLlGpcJnAhvplHRNugfywBwSpR7uJXfR8BM0QVLauAsYG1r67JGKOwuhOPlk54jQDM5QM0/9xQCTKM2os9DV+YvLiFs1wr7MXvLuFADx0zuPO4o0mFkZsduI5veZqkcf6aaZTms6lG4PXan0RabJ4BdwJUrPphE1aVVTRGAS8KtfmmBI07YW4H6NiwYnfMmle55F6L9TE1Gnm+6HwWijp0wJqBGZN4zvAnK282AT6JdneY+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5103.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(956004)(4326008)(2616005)(7416002)(5660300002)(6512007)(9686003)(8936002)(8676002)(6486002)(2906002)(478600001)(52116002)(26005)(66946007)(6506007)(316002)(16526019)(36756003)(186003)(6666004)(1076003)(86362001)(83380400001)(66476007)(66556008)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: anIvO7aMyZ6ATZ0qItObvaQLHeY12/D90p6Ih+V+Egd/DlijRkDkv7XJOa6MuvhKTxDqiLFWcxfAwFbyPRk2P4jjOVXAikPCa/6XVfyH2H44xFecTTxPPMR4DGbcUPXv93yh/iXoLSxDxoU9qU6pIPLcCHFrsyCvund804ZaTyMz3EHv8B/q+saCi1c+i6uaCTAbwdgCjjjKYQBH/34zjDQcMaCVNyNnE4jTk4wNtOIbmfRAMASAdMwsIrt9Y3dRXbbXHI4Q+bvTqZJdnL20IC3hi1CudjRI+ZsnIdI5gtvXXiGypmHeJaoFidHJTgwyJw/A9YhnZTx6/ZwfWFKGXjdzTChoV8xNh4Y+9jzGcM+Wqimm/aak74Zw/oBCLWu0J+dCN1V67kQrEnsSMUfVJrxCByeFr2BwZF1jhVAGaiY4m7FwMvkZR6wBQ56R6TsPvax38PnCmhi9yNcmggLu6FPjD8T/OJ+t+X85u6q3nNRDsHbmhX5jXMFeF4GtZvvkYlR3dSqV26TB/pIbgyEiAhP6y8d/4gXXAHxjBKPEuCVcxoJOybvdSGZuzjFiNOpK4VsVAmG+L1T7UVSnBzrsZa4yLzW6sELWUKgy8zEwa3ea1brjImBM3jFpvZKVoSpb2cWGwFl9p9TOQuNsSUr6ig==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be2e0f0b-314a-414c-c235-08d83ac29ea3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5103.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2020 11:11:23.7051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xjieFUyZaBoh6WhfQQdixlBQmt7G1Nt4q3+vdjbNIqj/+G2vIuBivfSlHLLoWGHRgIzkcH9hEBfbh9zYM8sKiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5725
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "hongbo.wang" <hongbo.wang@nxp.com>

the following command will be supported:

Set bridge's vlan protocol:
    ip link set br0 type bridge vlan_protocol 802.1ad
Add VLAN:
    ip link add link swp1 name swp1.100 type vlan protocol 802.1ad id 100
Delete VLAN:
    ip link del link swp1 name swp1.100

Signed-off-by: hongbo.wang <hongbo.wang@nxp.com>
---
 include/net/switchdev.h   |  1 +
 net/bridge/br_switchdev.c | 22 ++++++++++++++++
 net/dsa/dsa_priv.h        |  4 +--
 net/dsa/port.c            |  6 +++--
 net/dsa/slave.c           | 53 ++++++++++++++++++++++++++-------------
 net/dsa/tag_8021q.c       |  4 +--
 6 files changed, 66 insertions(+), 24 deletions(-)

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
diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 015209bf44aa..bcfa00d6d5eb 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -146,6 +146,26 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 	}
 }
 
+static u16 br_switchdev_get_bridge_vlan_proto(struct net_device *dev)
+{
+	u16 vlan_proto = ETH_P_8021Q;
+	struct net_device *br = NULL;
+	struct net_bridge_port *p;
+
+	if (netif_is_bridge_master(dev)) {
+		br = dev;
+	} else if (netif_is_bridge_port(dev)) {
+		p = br_port_get_rcu(dev);
+		if (p && p->br)
+			br = p->br->dev;
+	}
+
+	if (br)
+		br_vlan_get_proto(br, &vlan_proto);
+
+	return vlan_proto;
+}
+
 int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 			       struct netlink_ext_ack *extack)
 {
@@ -157,6 +177,7 @@ int br_switchdev_port_vlan_add(struct net_device *dev, u16 vid, u16 flags,
 		.vid_end = vid,
 	};
 
+	v.proto = br_switchdev_get_bridge_vlan_proto(dev);
 	return switchdev_port_obj_add(dev, &v.obj, extack);
 }
 
@@ -169,5 +190,6 @@ int br_switchdev_port_vlan_del(struct net_device *dev, u16 vid)
 		.vid_end = vid,
 	};
 
+	v.proto = br_switchdev_get_bridge_vlan_proto(dev);
 	return switchdev_port_obj_del(dev, &v.obj);
 }
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
index 41d60eeefdbd..f01deda00492 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -328,6 +328,7 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	 * it doesn't make sense to program a PVID, so clear this flag.
 	 */
 	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;
+	vlan.proto = ETH_P_8021Q;
 
 	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, trans);
 	if (err)
@@ -1229,11 +1230,38 @@ static int dsa_slave_get_ts_info(struct net_device *dev,
 	return ds->ops->get_ts_info(ds, p->dp->index, ts);
 }
 
+static bool dsa_slave_skip_vlan_configuration(struct dsa_port *dp,
+					      u16 vlan_proto, u16 vid)
+{
+	struct bridge_vlan_info info;
+	bool change_proto = false;
+	u16 br_proto = 0;
+	int ret;
+
+	/* when changing bridge's vlan protocol, it will change bridge
+	 * port's protocol firstly, then set bridge's protocol. if it's
+	 * changing vlan protocol, should not return -EBUSY.
+	 */
+	ret = br_vlan_get_proto(dp->bridge_dev, &br_proto);
+	if (ret == 0 && br_proto != vlan_proto)
+		change_proto = true;
+
+	/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
+	 * device, respectively the VID is not found, returning
+	 * 0 means success, which is a failure for us here.
+	 */
+	ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
+	if (ret == 0 && !change_proto)
+		return true;
+	else
+		return false;
+}
+
 static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 				     u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct bridge_vlan_info info;
+	u16 vlan_proto = ntohs(proto);
 	int ret;
 
 	/* Check for a possible bridge VLAN entry now since there is no
@@ -1243,20 +1271,15 @@ static int dsa_slave_vlan_rx_add_vid(struct net_device *dev, __be16 proto,
 		if (dsa_port_skip_vlan_configuration(dp))
 			return 0;
 
-		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-		 * device, respectively the VID is not found, returning
-		 * 0 means success, which is a failure for us here.
-		 */
-		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
-		if (ret == 0)
+		if (dsa_slave_skip_vlan_configuration(dp, vlan_proto, vid))
 			return -EBUSY;
 	}
 
-	ret = dsa_port_vid_add(dp, vid, 0);
+	ret = dsa_port_vid_add(dp, vid, vlan_proto, 0);
 	if (ret)
 		return ret;
 
-	ret = dsa_port_vid_add(dp->cpu_dp, vid, 0);
+	ret = dsa_port_vid_add(dp->cpu_dp, vid, ETH_P_8021Q, 0);
 	if (ret)
 		return ret;
 
@@ -1267,8 +1290,7 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 				      u16 vid)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct bridge_vlan_info info;
-	int ret;
+	u16 vlan_proto = ntohs(proto);
 
 	/* Check for a possible bridge VLAN entry now since there is no
 	 * need to emulate the switchdev prepare + commit phase.
@@ -1277,19 +1299,14 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		if (dsa_port_skip_vlan_configuration(dp))
 			return 0;
 
-		/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-		 * device, respectively the VID is not found, returning
-		 * 0 means success, which is a failure for us here.
-		 */
-		ret = br_vlan_get_info(dp->bridge_dev, vid, &info);
-		if (ret == 0)
+		if (dsa_slave_skip_vlan_configuration(dp, vlan_proto, vid))
 			return -EBUSY;
 	}
 
 	/* Do not deprogram the CPU port as it may be shared with other user
 	 * ports which can be members of this VLAN as well.
 	 */
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vid_del(dp, vid, vlan_proto);
 }
 
 struct dsa_hw_port {
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 780b2a15ac9b..4c93988e61a3 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -152,9 +152,9 @@ static int dsa_8021q_vid_apply(struct dsa_switch *ds, int port, u16 vid,
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (enabled)
-		return dsa_port_vid_add(dp, vid, flags);
+		return dsa_port_vid_add(dp, vid, ETH_P_8021Q, flags);
 
-	return dsa_port_vid_del(dp, vid);
+	return dsa_port_vid_del(dp, vid, ETH_P_8021Q);
 }
 
 /* RX VLAN tagging (left) and TX VLAN tagging (right) setup shown for a single
-- 
2.17.1

