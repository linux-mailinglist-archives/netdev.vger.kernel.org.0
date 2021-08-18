Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D13F0335
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236749AbhHRME5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:57 -0400
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:52143
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236420AbhHRMEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSHmbYMT5oNQQnSsNqJhI1npi0UYChTvHLtjKkqOXVRM/jOKEHFUbLlRHUGCAncyD3+wuqn/meymo7idAe5qeGBvXprZxgXO2IQrVHlH8oRkSdDTS7ERf31K92moTWEl51RdxLmR8xPp+6euCJ24Zg/uNthwdIbEzt9C+udL3EbBRBtgTaIbgSrzb7DGfeBbY6iSR3zJh7CqlTZ/bed3sNFBp3oukTOCXfAwk+9i0dROCLZ/8GOw0C+6g1rOHBNBd4NvKTGhllHL5ZRXmyJanK4FscEptBg5eo2b9i0gTbqfDxuMIK2rLF0ZtSWYD8LD1nKXXJAP7MSyW4ynUzjtHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vf3+O7tUQaJn6O4WmHb3hFm/Vvw7RaSJB+jVPnqm3t8=;
 b=njP4Bpj4GuH1KYABhvpNeXIEQnsuNoFAoP44qO4Q9fiYr1Iy29Fe6ZbhMaxfFwDf+SNCo8NXffx8kLnsW6Kal1t+Cf4L1/az87QyrxXyZguVb8IVFjftSrF+FEE4TMY2x7lW5A8UFfpl+4yFL8A48Hoh7bU/YRbmI/Cc2e7SoIb9OKqLeM+uloC8l33YYGa05o3DlhHDgIBdQ+xdFl9lpCZmAEWL9PUGigS93QLz7ob+S5U0RxPnUmnnaIr8YwDeCzZocGDalCg86sFaex47WnFHC27hFMNOxJkfEApnY5g3zja8/OdGhaw7gk/FCyQybg+SLBXMLa+zTFWu72AjIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vf3+O7tUQaJn6O4WmHb3hFm/Vvw7RaSJB+jVPnqm3t8=;
 b=hleKJRxVCZWAIFUnRNLL4a25QFcRVLH5UymuYNXnk/t0RW1Wd8tSW28FZuC+dJUH3Zf9bKv0CCX7FkS5WEFQJ+AatuRCmuKVpSQAvqJSeUTZqDdbaowkSaag9oqRz5PuJRQ8ysmdAPGPBB6UF66ZJ40Q+iWX8WpmEdVwHoDkdwo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:10 +0000
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
Subject: [RFC PATCH net-next 14/20] net: dsa: pass extack to .port_bridge_join driver methods
Date:   Wed, 18 Aug 2021 15:01:44 +0300
Message-Id: <20210818120150.892647-15-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc3cf240-e099-47e7-da9d-08d962402595
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3839641E392AD3BFED533BADE0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1284;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gv0NAGn3l0P10SYKRXxPZ1+En1DQCy0UIfA07zNNvrahHjsOa5xqoCAhF8N23GThTHRxmtAzCTbjV9XH+hTBQ+ZDhUr3ix+dsRr+Q8oF7yYOaEXFHAtzM/EwCU0mBDCmva6kq7CsCV7KQmcCL7F+rChMGvKAs4R7Gc6OK1ows15K8lnEd/XLyEuyxxomnJt1Q2WZfSx7guCqjtZiv9gfI4QVjj1NY1c4ECMAeyBawSLRY7OAwwJm9//VzOg1muq9svptxcTOu4amb3FrXY9zcVqIoYVPT/GyXuEUSNo/7ktfbyPcBRf7u4lffbOdNHewyU6nH4CA00jk+dTdjrD9eyrVO7K+HDLpgW3Ya2uihmIm1ZzcRlV6KJkLVny6OcO5xSXcrwst0urqw+fpLGFOvMnWbtC11Z4bLnKdOAWclsp35/htjJfY5dSeobQOAFkw1KBcANBTuKdA3P3HOEeDdtmTKePsL6htvJd18kj9ovnJ3j+4Jg16VLnuyRJOgVqVyDiEGoee7mxWvG1kS/RX/n+lLBM5QMQIXVqheMgW0DG1UehRtsexvo8cE5B+QWBzBSGwR1uW4oQ51hTLC8OaSS2DoOBOgbfMaGzBvignioleHBygPwFqymXK2uXugsVkqfS4/E63Jjb60NPoJy7SIx8hGzLyh+lCt7E9BSID0yJ8cTRqrwn4pc3IeZlkR7T539iD/jxOw+orfYgNm2y/bXoqu2d8lkk22TPxkawLo3U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(30864003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+8zip0GunMv3PR1OqotzvpxOszn3yCeuCxdGVTFZKcX4YJpZdBsvirSqh7Vb?=
 =?us-ascii?Q?meDTvZVXBfWoz0WoDmhT4sb9BdpurGX22T8rMYtI4NX0fzIhLunTiW1V5rGK?=
 =?us-ascii?Q?9BsBifnWZLyPgudBa58EITTuj/5TzUNJuSDOBQ3SJme5DopzlpFVUdPt8oC6?=
 =?us-ascii?Q?QiTkAKA2h1MrdOXOUlnNiqiRzkcXHqGab84r9I11LgL1leaIBA+MmbDo8aY4?=
 =?us-ascii?Q?uaKSoX0XhMOgPnQCRbxpmZL1QvU7eo9JunF2qJwYps86vLuN5rXTbRCHLvsJ?=
 =?us-ascii?Q?D4bJgEDKPwYsEMNwVEE4fyQZqhILNZXp5+JW778hAPttkFClFloU38kClYtQ?=
 =?us-ascii?Q?5A1UN/qgPwClVZxiaZDV3ryNTsK3NPA2Sf8ZaJS3lbp8rR6+EF+FPMn4VgZg?=
 =?us-ascii?Q?BLjP5JwM5lIo2WhvBc5/HLc51Qy3s2UKU/6aq5lZyy3Bj1xsw+Kl6xRVTvGu?=
 =?us-ascii?Q?bpbVcYRX/yujL3JSua5JaSLCHbf9bjfyGnqcLZBFGfodclyRRoV2yCGogNIj?=
 =?us-ascii?Q?hID8YkWhZk3nF26e3ICwWOtx1f8MTxdWYwuWY/hnltOWfIH18AclwRJ6dS1Q?=
 =?us-ascii?Q?aFTQgB/1DLCcKD3Ifm7qQoBI+dQ+/l7sYe8qL6XfUFm0KshjMHlSV2xHr1ki?=
 =?us-ascii?Q?p3kxQHfi/MG+nDhYSUp+eCfxsrdOgQovQPIeJJughbqksRMdWET/rUyqMUnD?=
 =?us-ascii?Q?fdQqSL2sDGT7wDxgp3nFwvpQfi+yOS1wF2+ETc6ECkOBymP32ABlS3z7w73Q?=
 =?us-ascii?Q?iOQtH04WzgJp3c4P3HUyy2a8V8BfokrHr6ZuISxArfXSjVgXn70PgXumbOXC?=
 =?us-ascii?Q?7qvWrz9Ajr6qO2xTUup7OxXWBeL/Xvu5BnCmW49LPCIDQ0fRZc1JBSWU40bQ?=
 =?us-ascii?Q?t06yJAGNlV5P70McXS+WekQ/UNAo5dnsoBJLe68UOG4PqSUrpkd6IAy5LBn7?=
 =?us-ascii?Q?4mdEQ+CUCofm5RTpCWr0ov+9cAWX3+UXbfdVVaAM4XOrshni49xulSKToxJv?=
 =?us-ascii?Q?v0egAWRZiLSkIB0B7pHGJByRt6PtWrFewjEeYa/Fv6UNCUy7r8/AOppQ7anc?=
 =?us-ascii?Q?RVxuEucPzIqzMGGIRJUuxEYXdQfDlgCozvci63o01x/df0i2tKRZT6nvQzzg?=
 =?us-ascii?Q?E4wD6+lW9G2IjMcZHAwqyCeukE7//RA8Kwx0LG/oVpHDki4YjxVa6mpV2ohz?=
 =?us-ascii?Q?riNNbnw/JxlRofqLeSyO/Wr7KkhsQojTYUWmLEThIqkt62h6CqcRjYZ08MGw?=
 =?us-ascii?Q?gIdbVS4+SNDs2hr0cgT5RrX15PkReobWqYhFAS8PVC0U5l6wm0Hj2DjzQrYe?=
 =?us-ascii?Q?wzmsz21orwRyOEBYJVCDh0h3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc3cf240-e099-47e7-da9d-08d962402595
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:09.9981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sdxzVnze9jmqJcOlthq61ZzKqzSQJ4jj8j35JeVZQMOfgRHnurYPwXS9uWE6Oe7wOYu3bWim4P4G1y0uniIibw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As FDB isolation cannot be enforced between VLAN-aware bridges in lack
of hardware assistance like extra FID bits, it seems plausible that many
DSA switches cannot do it. Therefore, they need to reject configurations
with multiple VLAN-aware bridges from the two code paths that can
transition towards that state:

- joining a VLAN-aware bridge
- toggling VLAN awareness on an existing bridge

The .port_vlan_filtering method already propagates the netlink extack to
the driver, let's propagate it from .port_bridge_join too, to make sure
that the driver can use the same function for both.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/b53/b53_common.c       | 2 +-
 drivers/net/dsa/b53/b53_priv.h         | 2 +-
 drivers/net/dsa/dsa_loop.c             | 3 ++-
 drivers/net/dsa/hirschmann/hellcreek.c | 3 ++-
 drivers/net/dsa/lan9303-core.c         | 3 ++-
 drivers/net/dsa/lantiq_gswip.c         | 3 ++-
 drivers/net/dsa/microchip/ksz_common.c | 3 ++-
 drivers/net/dsa/microchip/ksz_common.h | 3 ++-
 drivers/net/dsa/mt7530.c               | 3 ++-
 drivers/net/dsa/mv88e6xxx/chip.c       | 6 ++++--
 drivers/net/dsa/ocelot/felix.c         | 3 ++-
 drivers/net/dsa/qca8k.c                | 2 +-
 drivers/net/dsa/sja1105/sja1105_main.c | 3 ++-
 drivers/net/dsa/xrs700x/xrs700x.c      | 3 ++-
 include/net/dsa.h                      | 6 ++++--
 net/dsa/dsa_priv.h                     | 1 +
 net/dsa/port.c                         | 1 +
 net/dsa/switch.c                       | 5 +++--
 18 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index d0f00cb0a235..55bfcec2b204 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1848,7 +1848,7 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 EXPORT_SYMBOL(b53_mdb_del);
 
 int b53_br_join(struct dsa_switch *ds, int port, struct net_device *br,
-		int bridge_num)
+		int bridge_num, struct netlink_ext_ack *extack)
 {
 	struct b53_device *dev = ds->priv;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index e3f1e9ff1b50..4e9b05008524 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -319,7 +319,7 @@ void b53_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_get_sset_count(struct dsa_switch *ds, int port, int sset);
 void b53_get_ethtool_phy_stats(struct dsa_switch *ds, int port, uint64_t *data);
 int b53_br_join(struct dsa_switch *ds, int port, struct net_device *bridge,
-		int bridge_num);
+		int bridge_num, struct netlink_ext_ack *extack);
 void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *bridge,
 		  int bridge_num);
 void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
diff --git a/drivers/net/dsa/dsa_loop.c b/drivers/net/dsa/dsa_loop.c
index c9fefdede1d1..658c23195b05 100644
--- a/drivers/net/dsa/dsa_loop.c
+++ b/drivers/net/dsa/dsa_loop.c
@@ -168,7 +168,8 @@ static int dsa_loop_phy_write(struct dsa_switch *ds, int port,
 
 static int dsa_loop_port_bridge_join(struct dsa_switch *ds, int port,
 				     struct net_device *bridge,
-				     int bridge_num)
+				     int bridge_num,
+				     struct netlink_ext_ack *extack)
 {
 	dev_dbg(ds->dev, "%s: port: %d, bridge: %s\n",
 		__func__, port, bridge->name);
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 732fff99bfb2..fdae74313eb7 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -675,7 +675,8 @@ static int hellcreek_bridge_flags(struct dsa_switch *ds, int port,
 
 static int hellcreek_port_bridge_join(struct dsa_switch *ds, int port,
 				      struct net_device *br,
-				      int bridge_num)
+				      int bridge_num,
+				      struct netlink_ext_ack *extack)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 4e72fd04eb5f..d1148ab2f66e 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -1103,7 +1103,8 @@ static void lan9303_port_disable(struct dsa_switch *ds, int port)
 }
 
 static int lan9303_port_bridge_join(struct dsa_switch *ds, int port,
-				    struct net_device *br, int bridge_num)
+				    struct net_device *br, int bridge_num,
+				    struct netlink_ext_ack *extack)
 {
 	struct lan9303 *chip = ds->priv;
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 2ce4da567106..64a22652cc75 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1128,7 +1128,8 @@ static int gswip_vlan_remove(struct gswip_priv *priv,
 }
 
 static int gswip_port_bridge_join(struct dsa_switch *ds, int port,
-				  struct net_device *bridge, int bridge_num)
+				  struct net_device *bridge, int bridge_num,
+				  struct netlink_ext_ack *extack)
 {
 	struct gswip_priv *priv = ds->priv;
 	int err;
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 4f821933e291..202fd93caae3 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -173,7 +173,8 @@ void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf)
 EXPORT_SYMBOL_GPL(ksz_get_ethtool_stats);
 
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct net_device *br, int bridge_num)
+			 struct net_device *br, int bridge_num,
+			 struct netlink_ext_ack *extack)
 {
 	struct ksz_device *dev = ds->priv;
 
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 3e905059374b..59c42cc1000b 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -159,7 +159,8 @@ void ksz_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
 int ksz_sset_count(struct dsa_switch *ds, int port, int sset);
 void ksz_get_ethtool_stats(struct dsa_switch *ds, int port, uint64_t *buf);
 int ksz_port_bridge_join(struct dsa_switch *ds, int port,
-			 struct net_device *br, int bridge_num);
+			 struct net_device *br, int bridge_num,
+			 struct netlink_ext_ack *extack);
 void ksz_port_bridge_leave(struct dsa_switch *ds, int port,
 			   struct net_device *br, int bridge_num);
 void ksz_port_fast_age(struct dsa_switch *ds, int port);
diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 751e477691f4..3f3b4d3a36e4 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1192,7 +1192,8 @@ mt7530_port_bridge_flags(struct dsa_switch *ds, int port,
 
 static int
 mt7530_port_bridge_join(struct dsa_switch *ds, int port,
-			struct net_device *bridge, int bridge_num)
+			struct net_device *bridge, int bridge_num,
+			struct netlink_ext_ack *extack)
 {
 	struct mt7530_priv *priv = ds->priv;
 	u32 port_bitmap = BIT(MT7530_CPU_PORT);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 37878ccf499c..92c2833a25a4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2388,7 +2388,8 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
 
 static int mv88e6xxx_port_bridge_join(struct dsa_switch *ds, int port,
 				      struct net_device *br,
-				      int bridge_num)
+				      int bridge_num,
+				      struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
@@ -2416,7 +2417,8 @@ static void mv88e6xxx_port_bridge_leave(struct dsa_switch *ds, int port,
 static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 					   int tree_index, int sw_index,
 					   int port, struct net_device *br,
-					   int bridge_num)
+					   int bridge_num,
+					   struct netlink_ext_ack *extack)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 747dd739f533..cccbd33d5ac5 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -688,7 +688,8 @@ static int felix_bridge_flags(struct dsa_switch *ds, int port,
 }
 
 static int felix_bridge_join(struct dsa_switch *ds, int port,
-			     struct net_device *br, int bridge_num)
+			     struct net_device *br, int bridge_num,
+			     struct netlink_ext_ack *extack)
 {
 	struct ocelot *ocelot = ds->priv;
 
diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 9addf99ceead..4254fbd84432 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1506,7 +1506,7 @@ qca8k_port_stp_state_set(struct dsa_switch *ds, int port, u8 state)
 
 static int
 qca8k_port_bridge_join(struct dsa_switch *ds, int port, struct net_device *br,
-		       int bridge_num)
+		       int bridge_num, struct netlink_ext_ack *extack)
 {
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	int port_mask = BIT(QCA8K_CPU_PORT);
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 3c319114e292..8580ca2e88df 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1985,7 +1985,8 @@ static void sja1105_bridge_stp_state_set(struct dsa_switch *ds, int port,
 }
 
 static int sja1105_bridge_join(struct dsa_switch *ds, int port,
-			       struct net_device *br, int bridge_num)
+			       struct net_device *br, int bridge_num,
+			       struct netlink_ext_ack *extack)
 {
 	int rc;
 
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 230dbbcc48f3..2b6806610a89 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -542,7 +542,8 @@ static int xrs700x_bridge_common(struct dsa_switch *ds, int port,
 }
 
 static int xrs700x_bridge_join(struct dsa_switch *ds, int port,
-			       struct net_device *bridge, int bridge_num)
+			       struct net_device *bridge, int bridge_num,
+			       struct netlink_ext_ack *extack)
 {
 	return xrs700x_bridge_common(ds, port, bridge, true);
 }
diff --git a/include/net/dsa.h b/include/net/dsa.h
index b2aaef292c6d..5ecba358889a 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -694,7 +694,8 @@ struct dsa_switch_ops {
 	 */
 	int	(*set_ageing_time)(struct dsa_switch *ds, unsigned int msecs);
 	int	(*port_bridge_join)(struct dsa_switch *ds, int port,
-				    struct net_device *bridge, int bridge_num);
+				    struct net_device *bridge, int bridge_num,
+				    struct netlink_ext_ack *extack);
 	void	(*port_bridge_leave)(struct dsa_switch *ds, int port,
 				     struct net_device *bridge, int bridge_num);
 	/* Called right after .port_bridge_join() */
@@ -776,7 +777,8 @@ struct dsa_switch_ops {
 	 */
 	int	(*crosschip_bridge_join)(struct dsa_switch *ds, int tree_index,
 					 int sw_index, int port,
-					 struct net_device *br, int bridge_num);
+					 struct net_device *br, int bridge_num,
+					 struct netlink_ext_ack *extack);
 	void	(*crosschip_bridge_leave)(struct dsa_switch *ds, int tree_index,
 					  int sw_index, int port,
 					  struct net_device *br, int bridge_num);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 417fac51c6e8..3a9d81ca3e64 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -57,6 +57,7 @@ struct dsa_notifier_bridge_info {
 	int tree_index;
 	int sw_index;
 	int port;
+	struct netlink_ext_ack *extack;
 };
 
 /* DSA_NOTIFIER_FDB_* */
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 270624e88358..07c57287ac3e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -355,6 +355,7 @@ int dsa_port_bridge_join(struct dsa_port *dp, struct net_device *br,
 		.sw_index = dp->ds->index,
 		.port = dp->index,
 		.br = br,
+		.extack = extack,
 	};
 	struct net_device *dev = dp->slave;
 	struct net_device *brport_dev;
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 26dbd70ebb5e..b1c38eee2cac 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -95,7 +95,7 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_join) {
 		err = ds->ops->port_bridge_join(ds, info->port, info->br,
-						info->bridge_num);
+						info->bridge_num, info->extack);
 		if (err)
 			return err;
 	}
@@ -105,7 +105,8 @@ static int dsa_switch_bridge_join(struct dsa_switch *ds,
 		err = ds->ops->crosschip_bridge_join(ds, info->tree_index,
 						     info->sw_index,
 						     info->port, info->br,
-						     info->bridge_num);
+						     info->bridge_num,
+						     info->extack);
 		if (err)
 			return err;
 	}
-- 
2.25.1

