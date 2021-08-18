Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A673F0333
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbhHRMEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:40 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:54881
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236394AbhHRMEO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cl+/V1hSsgff6Jmnn1FfO3K7/A8ZBlkXxlQge+mwFCdZlMQBq313b5V4efTvD8y44WmRqZ53uR9y7MaTi9vcJ3X2in8b8j4lDt0pbfAmMZhnO0reuS6c/fAZbFx5bu4aYGK2wMdunRFuUxvVsXFIaSjWDEnTSV5zj9p4jjZc5fSvK5y/xcTiVZ7xzZURULv+ggcqx5lEejVekU2wOsfVt4AVGNUUxxDemynEG24eIHyTYdNaSl2iUaUSiqB+ODeXaLpDe76WMwdtmM7sryOMh3wOY8Jr8yulC2B3CCxToNYXxzRZ3B3//5I4zE1v/81BdAm/k0XOJdVrQCJUzjKL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhImt1syFqdWJrYlFm96xbsLOURwpTwXQrNslGfzI0M=;
 b=OWKXfKVaUkzfARlUAPfW9xmVksqmQsqfQIIPgt95X+8Li1yjngnQ5TbXtzNlO9eAXcm5Hn390XIZi36hEq+rS7RMzQjOn496igPe+fB4Zx2o3ibRptLBX+ffwWuNnC49TLhCNpfT0//k4EMhZEgTjBuuRW32CTC51satUwEEVCHzF+Hqbr3annSZ3iwqKZFwXVBDQW6SY38+Q6CkMBva6ylsOzTnkZQ2afKedwPSK9zMsLvergKba/gu7b766pdT4iZg9aiEUP1P+vrw1XjmAmzGjpR9LhFfKGfo9cbKkSBLjekuC/6DdseTrNeMsUe5i/0/VqWwI2v9sTCjFsn9Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zhImt1syFqdWJrYlFm96xbsLOURwpTwXQrNslGfzI0M=;
 b=HpNSFZTLFdEQtRrsQ7BECWwhbSK//zeGzwscmt8LOdXyUAbhGTMFtUyRD2F3LVk4pIc7hhnnDj12fEPhhcsO/qU3T9hQfYf6RGjxwCGGQHV3xwFk15vRWFu6bS0LUKYLVY1PdDlYnMZXE85zPSX+2JKPaJNEBZzX4GmoEcXgAb4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 12:03:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:17 +0000
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
Subject: [RFC PATCH net-next 19/20] net: mscc: ocelot: use helpers for port VLAN membership
Date:   Wed, 18 Aug 2021 15:01:49 +0300
Message-Id: <20210818120150.892647-20-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f765e2f-5379-4342-f04a-08d9624029ce
X-MS-TrafficTypeDiagnostic: VI1PR04MB4222:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4222EE06A9D7263B6513AD34E0FF9@VI1PR04MB4222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lGfJWDnifx8XooR3gBBdD5dSLz3UkZ5cxisbJSmhaQKk1es9daN9n1SKkr3I8Fve1q+iK929vnSlxN70zzV+X9GiWti0MhzZCILww6tV2E5FyxaH6MR1LIVVOjn26dFUT0e23l0Qx9uBzYNigmrm1y1q7t9NhOnvJHiUTjymP9hkZ0spFGpmphvnhDd4b/sh3+E4EbQLS+lCL2A02wXxGsm12D+dJOq11KRv+yGexooiNUGOn+zrAGTa/257BH77hLZIw+n1BzAF+YR1Q5GjnXM51ONr+INsx2uQWi2J2cgqXxleEfv0MEgj5mHIa0oeiiPyoQ7KdSGMOE9lQ4ss2EFqLsIMJtxvEGo68bWXeVzU9fM4RvwITqjYHecvFXjyYTqI7ERfdOw4mypGkiRtkFKOUPZOvdgJ3nkvnIl8icT0RdtIqn+jUYsRgNT94WSOp0m7kNw9HlgBSAq25hqMneUmQOV1pxVThIOhphXkSE61G/z5aGSIzitoVMZXI14NVr45DtwvKUGGfuZiPz0MezrUmIuME4pjKdvbyH7ygfEhDd9nI9f3MQf67ukatLap
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(6486002)(52116002)(2616005)(44832011)(4326008)(5660300002)(26005)(1076003)(6666004)(54906003)(956004)(6512007)(6506007)(186003)(38350700002)(38100700002)(86362001)(36756003)(110136005)(316002)(83380400001)(8936002)(478600001)(8676002)(66476007)(7416002)(7406005)(66946007)(66556008)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?o8LSPcHDKtnEnxG/Iv28xKRPBD0xqQpCAuZH1BTQAqBzm9iGJ5UN1h0Iaipn?=
 =?us-ascii?Q?8ggxP1faCK7+FQEEfBlAcPrckJMaLcbz5hobRjMlADJK+OP9V0EQga7rd8cp?=
 =?us-ascii?Q?D2aNDMHEl4Q01q8CQ1IXsOdd6TQPjvhPtwDwWzRC4DCk9rGp9uPlsllsAzU2?=
 =?us-ascii?Q?YBM4reVyMe4aAyDTpUL3XPjV8Gd3qfrpDTty/WGBulhkAj9InKnk/6JVvFhO?=
 =?us-ascii?Q?rkwq1s7ZVf3PVGeKSGzKHkzFG18ki2rwic+4tpcG++IAObYbW154aKd8CdCS?=
 =?us-ascii?Q?46ATobI3+sImgmlRwx+Zob20oi9vW5a9xfA3e7HmugHmNCUJBwxtaKURQ7jj?=
 =?us-ascii?Q?vJGoMEdJ9EeQHOWQE6mwvCrw+qQDqsNon5+K+qX0fv0xdi1N3Yf65Or0IN20?=
 =?us-ascii?Q?aTVLRSCl0RSU2lTMQQPxBYemYfsITtZkj8QCFNcRH+Im1gzfQnAq+sXpkiLf?=
 =?us-ascii?Q?G/fXRf12d448QJxACkr3JvRo+vmFlOtYTaYFTZBbtOiMI0FgBl9cPZyJ2S3Q?=
 =?us-ascii?Q?Vproy3z3Q9p6gpzLOHBOTcxHNt9/YwKeExzbws0BmbJWiX250ipLHhKJ6nnz?=
 =?us-ascii?Q?rZrvU8hPHUu6Ro/9hbBPdct9xuaiTHwnzvQfngzc/TR1oPkTcbuBKWJInYY/?=
 =?us-ascii?Q?o2aCbQsiUUR/RpcOL18LoGI6BdZjUmulTTOckz6H+Az5c5YOeMRx5+SVvhax?=
 =?us-ascii?Q?8030QStDDIR94CT9Shyu0iV3iBPrF+gKNwXcy6vBANLAM2O/Xz/0vAStCSqB?=
 =?us-ascii?Q?MTZq5NONXrw755wuUtPLCnEYiNmytZthGHj2BwipssgagWf7xtbSlEtBDMD8?=
 =?us-ascii?Q?ypKGiTm/xCL41Gn12JMo8WGip80gu7eJxElFPr5d8IAZrkiOGU0vQR8QNG05?=
 =?us-ascii?Q?G8Y+7eDfJqeu1h30MoUi8hdvBVVb+Lo7SYVS2HKQ1TD3t74Mg+HVXMN31Lms?=
 =?us-ascii?Q?NjTrwIqdHnnAZBW9o3zOH20PumSjYHJgDQgj336rbwUGOTYCChoHBGkTKqXq?=
 =?us-ascii?Q?HwzCkqf4zpyDC0751UaT7MTscjpZACSaCaT1rzg6z7ZAGxQ1EzPjLNphXzwr?=
 =?us-ascii?Q?lP49bhgMyE8WkBN2CANtOMM6m1fEXk0XMu0MfwV3RDwQdyYT8n9WoIRDqyRO?=
 =?us-ascii?Q?Yg5MBOjNqATGI4olIKgvjeI91f9pbpaNKIfNKPRqhfb/2nZl8Vpl+Z5oHyf8?=
 =?us-ascii?Q?fMVbALH5zQL9LOeVAV0mHpFelZd73UFJ6bTYzSIItOOtXWq/yGZ7H3Ux90eL?=
 =?us-ascii?Q?Ou3DS6HE2djU4aUxQkPHilXFkHakhMOL4S8UZvXAJTOSRWO0DKbe6+Dqrpgs?=
 =?us-ascii?Q?XtmC/TbjJSfgZGrZeyjLE0An?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f765e2f-5379-4342-f04a-08d9624029ce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:17.0681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZVHarSzFubO0ibHVvEo5pApl/AaVx0+sFsx5UdJugUOM2817u8TJAx9YM2JCrCMC7yg0WNkIgvHJiYLHY75BA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a mostly cosmetic patch that creates some helpers for accessing
the VLAN table. These helpers are also a bit more careful in that they
do not modify the ocelot->vlan_mask unless the hardware operation
succeeded.

Not all callers check the return value (the init code doesn't), but anyway.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 60 ++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e848e0379b5a..c581b955efb3 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -222,6 +222,33 @@ static void ocelot_port_set_pvid(struct ocelot *ocelot, int port,
 		       ANA_PORT_DROP_CFG, port);
 }
 
+static int ocelot_vlan_member_set(struct ocelot *ocelot, u32 vlan_mask, u16 vid)
+{
+	int err;
+
+	err = ocelot_vlant_set_mask(ocelot, vid, vlan_mask);
+	if (err)
+		return err;
+
+	ocelot->vlan_mask[vid] = vlan_mask;
+
+	return 0;
+}
+
+static int ocelot_vlan_member_add(struct ocelot *ocelot, int port, u16 vid)
+{
+	return ocelot_vlan_member_set(ocelot,
+				      ocelot->vlan_mask[vid] | BIT(port),
+				      vid);
+}
+
+static int ocelot_vlan_member_del(struct ocelot *ocelot, int port, u16 vid)
+{
+	return ocelot_vlan_member_set(ocelot,
+				      ocelot->vlan_mask[vid] & ~BIT(port),
+				      vid);
+}
+
 int ocelot_port_vlan_filtering(struct ocelot *ocelot, int port,
 			       bool vlan_aware, struct netlink_ext_ack *extack)
 {
@@ -278,13 +305,11 @@ EXPORT_SYMBOL(ocelot_vlan_prepare);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged)
 {
-	int ret;
+	int err;
 
-	/* Make the port a member of the VLAN */
-	ocelot->vlan_mask[vid] |= BIT(port);
-	ret = ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
-	if (ret)
-		return ret;
+	err = ocelot_vlan_member_add(ocelot, port, vid);
+	if (err)
+		return err;
 
 	/* Default ingress vlan classification */
 	if (pvid) {
@@ -311,13 +336,11 @@ EXPORT_SYMBOL(ocelot_vlan_add);
 int ocelot_vlan_del(struct ocelot *ocelot, int port, u16 vid)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
-	int ret;
+	int err;
 
-	/* Stop the port from being a member of the vlan */
-	ocelot->vlan_mask[vid] &= ~BIT(port);
-	ret = ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
-	if (ret)
-		return ret;
+	err = ocelot_vlan_member_del(ocelot, port, vid);
+	if (err)
+		return err;
 
 	/* Ingress */
 	if (ocelot_port->pvid_vlan.vid == vid) {
@@ -339,6 +362,7 @@ EXPORT_SYMBOL(ocelot_vlan_del);
 
 static void ocelot_vlan_init(struct ocelot *ocelot)
 {
+	unsigned long all_ports = GENMASK(ocelot->num_phys_ports - 1, 0);
 	u16 port, vid;
 
 	/* Clear VLAN table, by default all ports are members of all VLANs */
@@ -347,23 +371,19 @@ static void ocelot_vlan_init(struct ocelot *ocelot)
 	ocelot_vlant_wait_for_completion(ocelot);
 
 	/* Configure the port VLAN memberships */
-	for (vid = 1; vid < VLAN_N_VID; vid++) {
-		ocelot->vlan_mask[vid] = 0;
-		ocelot_vlant_set_mask(ocelot, vid, ocelot->vlan_mask[vid]);
-	}
+	for (vid = 1; vid < VLAN_N_VID; vid++)
+		ocelot_vlan_member_set(ocelot, 0, vid);
 
 	/* Because VLAN filtering is enabled, we need VID 0 to get untagged
 	 * traffic.  It is added automatically if 8021q module is loaded, but
 	 * we can't rely on it since module may be not loaded.
 	 */
-	ocelot->vlan_mask[0] = GENMASK(ocelot->num_phys_ports - 1, 0);
-	ocelot_vlant_set_mask(ocelot, 0, ocelot->vlan_mask[0]);
+	ocelot_vlan_member_set(ocelot, all_ports, 0);
 
 	/* Set vlan ingress filter mask to all ports but the CPU port by
 	 * default.
 	 */
-	ocelot_write(ocelot, GENMASK(ocelot->num_phys_ports - 1, 0),
-		     ANA_VLANMASK);
+	ocelot_write(ocelot, all_ports, ANA_VLANMASK);
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
 		ocelot_write_gix(ocelot, 0, REW_PORT_VLAN_CFG, port);
-- 
2.25.1

