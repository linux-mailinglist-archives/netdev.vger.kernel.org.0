Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F5D3F033F
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbhHRMGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:06:14 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:54881
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236248AbhHRMEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=btmjwkRE1MVeEehMA4kVtNOL9WNv+kvbG0T+lKkvxRPbXEAVkSUEqwo9cr5+WKroEoxjVPmsJNzP4MvrPiC8Kur5u+hFXUgEOw9ASECkpAqSfib+VnW4ZqOov4x3f0nCNKVLuNIUzRYoAJrLwqCtbUsMiRLLwIsStChIzJw7wcAfdOGE3ns0CSXqhTYlH67QGiOF7f3aJxErf29+ftueCnm7lbC1ppilxH+lkQxh6AnavD5lyBOFSvYPFAfOw2J8U/ZA8UNNNIwStQjWQDLKTg0Pz5xbCxp/Hbx0In0En1YvDonGezZTfM9oEgTmyr45STuhNkX7lpVIVQqU9xGbeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zQmhdGJjvGc6x8W/0H/J8I4/NgGniuyPBzRA12vOmA=;
 b=c0fA02wQxJxcc1q8cuEXA68LFjx98D+8Kn3nnL2JOghBIuzZVOqSxGNg5SIj1a0ODUrpt2oVPgypSyVENJLhAWf/GBlwBGo1XgrLPzj1NCdZxsbLLslSqR+zan7ttfuF1ulN4TAOLDNwAMGLP3X/sZfJtJMPPpPppJZML9Ker1IP0nD31/1n8wUsaJzuTZ4ARop7F2EEZnSc8JUDUMbuKso4mcEFeW5o3og3CZmyYPCl3BuZNScwF4MBugUBBLPtQNC7eUbv4X81gUQNAi5Bi9KvZlvVw7QT6yvvLavGqyGEwn1a3s5bR5kw1jPK7DQ+UbjHmW+zdYuLlNfR7OgJKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6zQmhdGJjvGc6x8W/0H/J8I4/NgGniuyPBzRA12vOmA=;
 b=jkDMlFxa8Toi7a3KcX4t+WYe71MkBQl0NqYCKUJSV+/xDdFMKLtsVqkw8pA/O6feLywlYoNnfJf4i5CxCec9gaSZJ/QI4j7iTUrvlFEDYhjM6OongYdxei50lXm//bzDn8gPmp/UJDX9qaMg1fmmVrRREG4JMKFpoCDwcUPW9ag=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 12:03:15 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 18/20] net: mscc: ocelot: transmit the VLAN filtering restrictions via extack
Date:   Wed, 18 Aug 2021 15:01:48 +0300
Message-Id: <20210818120150.892647-19-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41bbb013-16ca-4398-a7fc-08d9624028fa
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB42221AE750ED1A00A7ED8E7FE0FF9@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:281;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TxVa12mlbLg3Sr+aSIr1/cxsrWIY3/hczEuL9q1bUNumKjL9h3lDDBPuFz24uJ5OMYmj6Lp/Yic7bI2VbuwlUCfZaK/dt+lF2bLW1AXvzJYRpr7297aU1uVLxfGE9vp/f9EdvVb9aZW9b9bVl+uGc6NwRqx31lLgx5l+rOwpEIUuN6Gbx/sfzypTjb+mIij24K7pcocCX81KKi2+1l+EOgFs60e5YOxQup7B46LxuBI/MErbkb2NmbEEWJ8P7L4O10jxkgQODxBIFTRmHRYThcfxEx8g2gAHFsnTeGM+edICW5z97DCrX5f7c+7zJO4UOtqt9j1kcoM1uMloZCJOKywW2p4jzuJ1ntoA8PHlFUXtupuVMdBXJCGCqUJOoXnVowlhBNGDgfeykPV50oVZs0+PiNstAy8fHIUHTNl9JFHQv38y/dp9oYyf+mpgWtjg6TICppt+WPK+33UQb4VPo7LAX8b5NvKXINKWzKfkvv0ZFgB3+zYP0nF+3bdFtHXxyT3bjrztDrTGUQ0cUGX7d1BAhnYhN8xI1l32kQ8EXZ9090cj+EKP0ld1JOyDKApX7bju8If/dUHYmePTjSg8oAApgqH3BAdHTNKHoJnoPT1UVCYHHvCN24nL3/WnXTK4831bvMxGYb8Yq69IakV2Fxo/PpNAWvOEdcnUHkCrCtmh6uIBIsB1RV7PqFyTW+GZr25mECs2p1weDtlPrp7BZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(6486002)(52116002)(2616005)(44832011)(4326008)(5660300002)(26005)(1076003)(6666004)(54906003)(956004)(6512007)(6506007)(186003)(38350700002)(38100700002)(86362001)(36756003)(110136005)(316002)(83380400001)(8936002)(478600001)(8676002)(66476007)(7416002)(7406005)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ibzk1qe7zv/2DbQ6mJAJF+ypMi4MlsifLSCFqL2rjbzNJ0/qxXq7e2qHdX/V?=
 =?us-ascii?Q?XTNtOmDYSDGpuZC8ALNCmDDaDr/nFBs841MUE7FM5PeYkGSgeb43bsRwLlYH?=
 =?us-ascii?Q?cK5FksqcmmdGMPVE/azlUtaoOCbpF5zwE9kUUBdQVX+nLLm9OHjgtOvx5Jik?=
 =?us-ascii?Q?XDZyy+WD2zXs0sKAF/Q1DrN+QRD6gwMwo+VOc6Qs7I4kpwlSHdLwrCE+pcTL?=
 =?us-ascii?Q?xV/Ar02evwrYzcImAdcCiEAO5CzphZme6TlbQR4psi84va2JzdRGNcKZ8V42?=
 =?us-ascii?Q?ca516xDWgiIR40MgiQ94SO6mFkJosNRyB0vyfpGITqijvXLU1xQM9uoDuQDy?=
 =?us-ascii?Q?LMGb62DZyZZh+dlsCZKOkCnotXBZLKLwuKgJYKw8b22Xfc8jpajfx1XO1PAz?=
 =?us-ascii?Q?vZyXe5w0tSQUTrnj4FSZkN954rNxZ72k3aXUdvC9SBg0ENYb93LUDJlX4p2s?=
 =?us-ascii?Q?lpcP52xfjROihqSb+snKCbD2hBbHVuAE7gOWhcVqMzospreo/RIFuIhgEPvO?=
 =?us-ascii?Q?o/a8FGj2/vqLczL8VSpKJyNHv4VmdYyDfUM9gAV1xjMNzW32Z9YBXsZnBFa3?=
 =?us-ascii?Q?MOw0qdE0fSIR9P49G+MPWvFERDJYV1KOdEsy1ME6paICBEDTZztE3eVMDHQi?=
 =?us-ascii?Q?dQLubC0TX5Q+qhytpL9DYAA3ezo37BeNEaGdSUA1Te2bL8pbSueFyluLCxJP?=
 =?us-ascii?Q?EZ4Bj3Vmkb+aQ9NtyzMrxh8dNvMr0pLh2SoywRL9hWXQ2CgKrtRT75k2OajZ?=
 =?us-ascii?Q?kBy1MmUcD/RA50H68Z+x6DbGqq5XuvAasGlwQWFAmH/uYM4BqzLg/UGnhCig?=
 =?us-ascii?Q?tbDWBqjZnTGfMF5JkyqoTwEiILg+YjyrPcDnG9XVqGXkvwaqhMbKuHnMAvjw?=
 =?us-ascii?Q?i/bMbB+1/PJq5oHqYVwsO5ASrgZu9gctc7B7KQ9Glqx/fEH1PpyyeFhIdjHv?=
 =?us-ascii?Q?CVweh6dAkRQusKvY0336z0R5WsSzoKV2syU1sOVUX/KewjZT9R8iUwIjWjk2?=
 =?us-ascii?Q?GMTaYH/i8AVvsjoBYds2DKnNGTS5pXpKG6CduLRyHnZHh4oWvCu8tWCz+3XX?=
 =?us-ascii?Q?y7i3fiK+pJlIcdqz9fL1FTiBOAkGZrX10SX6+ZfG+qx/cF4IMCQ1bAjOKLZP?=
 =?us-ascii?Q?XJqmYT/yGe/OmZAuPUNx7jXhuG7f/JJa9fDzsIZsJcDI3HU55aTV/iLuN0CD?=
 =?us-ascii?Q?AN79YhgenfVRxZFoaly7SzS8H5YD1uWE0dMGiMMMvw1bxLfnPBJJmERkZAlS?=
 =?us-ascii?Q?uLag0HTFBG9U/tuqU/RgdzePBbHcUdXkgnmrkoLo8Z02avvdxddjQhTg4XqV?=
 =?us-ascii?Q?VDQWMf2wjzGlW32CzJP1GAnq?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41bbb013-16ca-4398-a7fc-08d9624028fa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:15.6849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xBXAYdgim6oBg6IXjLAldAbq6FbwgjP/eUuu17s7jAJAC+q8vKgXw63E7LzCMnl+sh0ObgPzCk0VOib3GDVARA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to transmit more restrictions in future patches, convert this
one to netlink extack.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 2 +-
 drivers/net/ethernet/mscc/ocelot.c     | 6 +++---
 drivers/net/ethernet/mscc/ocelot_net.c | 8 +++++---
 include/soc/mscc/ocelot.h              | 3 ++-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 0b3f7345d13d..fdfb7954b203 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -768,7 +768,7 @@ static int felix_vlan_filtering(struct dsa_switch *ds, int port, bool enabled,
 {
 	struct ocelot *ocelot = ds->priv;
 
-	return ocelot_port_vlan_filtering(ocelot, port, enabled);
+	return ocelot_port_vlan_filtering(ocelot, port, enabled, extack);
 }
 
 static int felix_vlan_add(struct dsa_switch *ds, int port,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ccb8a9863890..e848e0379b5a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -223,7 +223,7 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 }
 
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
-			       bool vlan_aware)
+			       bool vlan_aware, struct netlink_ext_ack *extack)
 {
 	struct ocelot_vcap_block *block = &ocelot->block[VCAP_IS1];
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -233,8 +233,8 @@ int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 	list_for_each_entry(filter, &block->rules, list) {
 		if (filter->ingress_port_mask & BIT(port) &&
 		    filter->action.vid_replace_ena) {
-			dev_err(ocelot->dev,
-				"Cannot change VLAN state with vlan modify rules active\n");
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Cannot change VLAN state with vlan modify rules active");
 			return -EBUSY;
 		}
 	}
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 133634852ecf..d255ab2c2848 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -912,7 +912,8 @@ static int ocelot_port_attr_set(struct net_device *dev, const void *ctx,
 		ocelot_port_attr_ageing_set(ocelot, port, attr->u.ageing_time);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING:
-		ocelot_port_vlan_filtering(ocelot, port, attr->u.vlan_filtering);
+		ocelot_port_vlan_filtering(ocelot, port, attr->u.vlan_filtering,
+					   extack);
 		break;
 	case SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED:
 		ocelot_port_attr_mc_set(ocelot, port, !attr->u.mc_disabled);
@@ -1132,14 +1133,15 @@ static int ocelot_switchdev_sync(struct ocelot *ocelot, int port,
 	ocelot_port_attr_ageing_set(ocelot, port, ageing_time);
 
 	return ocelot_port_vlan_filtering(ocelot, port,
-					  br_vlan_enabled(bridge_dev));
+					  br_vlan_enabled(bridge_dev),
+					  extack);
 }
 
 static int ocelot_switchdev_unsync(struct ocelot *ocelot, int port)
 {
 	int err;
 
-	err = ocelot_port_vlan_filtering(ocelot, port, false);
+	err = ocelot_port_vlan_filtering(ocelot, port, false, NULL);
 	if (err)
 		return err;
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index ac072303dadf..06706a9fd5b1 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -807,7 +807,8 @@ int ocelot_get_sset_count(struct ocelot *ocelot, int port, int sset);
 int ocelot_get_ts_info(struct ocelot *ocelot, int port,
 		       struct ethtool_ts_info *info);
 void ocelot_set_ageing_time(struct ocelot *ocelot, unsigned int msecs);
-int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled);
+int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port, bool enabled,
+			       struct netlink_ext_ack *extack);
 void ocelot_bridge_stp_state_set(struct ocelot *ocelot, int port, u8 state);
 void ocelot_apply_bridge_fwd_mask(struct ocelot *ocelot);
 int ocelot_port_pre_bridge_flags(struct ocelot *ocelot, int port,
-- 
2.25.1

