Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CBE3D141C
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhGUPpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:45:19 -0400
Received: from mail-db8eur05on2070.outbound.protection.outlook.com ([40.107.20.70]:1893
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233518AbhGUPpJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:45:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qc9rCUdSZTzNJtfhb06GQjDqT81wg5VuWKLDT6kBOLySHmI9wJHb8iRFabJWDzfaoxIdKGWS38SYqMViU89Q7VFniXaHE79bUVnhFkGsDMciWjgaicti16A+uUq9mpiyzzz5j62uOsH5XtRIBBIANICs2WrHTjNrX96+4jeLvPDen5qSIT0e6lT4xlfMlNiMRZtUIg7jw52dGD2cbD87Suj+i6gWzk20gpGacn3n0yIqsBQnP/s/nDShWDJafei/RK/0ztXCgPHNQQkZPQ88/D/Cbj3XZnZkNmCRYbhBLPbti4OzI5SP2KKDGKI5L7oDuRQ/35WIo51CG8laEsduGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psZBzoBRyoXm9d5Q7PJUvdhOwJl++V6sL3EHYK8MGPE=;
 b=lDe41xJnjny/lrtXtgJG9WKvw8pBKbhVxiuIIrNS5loVtBrQvpURkldHCo9FuUu3l9pv0c//pVG83RJKtmpACnfCo/XkpkUrStCd7B/eaIOIsqtBQopqPbCdUuoQMDbsIco//Kfrd6ALtAK6cY0mEZEq7VawbI02NLPL8Y+BAZD//ZGoidfXwoJXvt99CPOZFJlRRQVzukd8z/mF46Gff7/zbhHPHhFrhXhyY8Vb8up3KTJ6zWctaitE2SpMUtawxXMhdbIZE8Hxeh2EaotTvmrbBXj0fbNCNKeiLglEvtuOU4fk1oNUZh4VtFBsW/S6LIbnzxl2rHrG3RIiiFIRKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psZBzoBRyoXm9d5Q7PJUvdhOwJl++V6sL3EHYK8MGPE=;
 b=g09SNsvdXIwGvbvLu4AYecQJnfN32aGoJ5jYz+ocu5uN3h4vGoj7Lo/UQufiJH6+gV5wzyxOT/6Q1lpPqPu+PYAcPnXLPQujcVuynV/q3TXecRFeOVl+KYKMb4ATAudEtzvx/+cy06FfxwCTfRMF2a62i6NyB6XRBP1wfHXPCaI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 16:25:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 16:25:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH v6 net-next 2/7] net: dpaa2-switch: refactor prechangeupper sanity checks
Date:   Wed, 21 Jul 2021 19:23:58 +0300
Message-Id: <20210721162403.1988814-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
References: <20210721162403.1988814-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by LO4P123CA0292.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:196::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 16:25:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8953633-0238-4665-71cd-08d94c64225a
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7343DF3F374BE8569BFFFA0CE0E39@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KfSFPupDbr6ycmgQL98a+t3NOaTWrYsAAf/eXex3PqyDQZ9i7FDwQ8q3xeCJnwrDXYE7SNAZhib0KXfqkQRidYuShKwnhzHwHkKgZJH0WI53Dq/FFKeZiDdxdjyalVoqruXyfSWVNfDEWXB6QegbVBDqaD6lustIrhkEIo90ncu+ISVpLcSkCLrVnCwjy/x5f/KljaTCWEYpkIrT0XxPU9kYM5dRBVoMVeGki6vN5ERh82rc2o1Pt1iTpFmPbk+M0QIZaKNL4Q+8mq3KkQ2yBnbsjGDVT1lEVQ+Ecc3DkR5G0EV2Qex1H6YgKnt1dZ5OexllFJGR/fHu+Th4h8CgLMsGMTiVpInhlrb/wbUc4gD3zFgLPPUnRKxm8qp8QiX9g5+mt0thgXbai0inXfduUXso+YUuiRPAMpnpHu0GPRiI0njW8To6x/0VL21FK36GmZKQKUj1TG8u2CJhrxVk1Zgxd9BXPwVyNSitrHk6VzjwoQ5M13P7tWhEomEakg++bIUsJ9xuVyK58y0ojB2f9EZxd8mQYltJrEWIHgbASnCUTuY3BPT6tUQlASjyj2piPpar2pxvCmOlVcKzXfmeNRc793OV9GbZjNT8g0D5UC09LBtNL1gBJSenz/sxhg/LOkm/1Kxh9MUjz3fTfSyGrhqwOIhgxdD9p5eB3nSOxBeRQ8MG0DISdb0+D2ETUa7jrddyIl4aWncBz03QKbd/3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39850400004)(366004)(186003)(110136005)(956004)(4326008)(44832011)(316002)(2616005)(54906003)(8676002)(8936002)(478600001)(83380400001)(36756003)(7416002)(2906002)(6486002)(6512007)(52116002)(1076003)(5660300002)(66946007)(66476007)(6666004)(38100700002)(6506007)(66556008)(38350700002)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NsTNKCS9Izg/p5mI+YXkgVVrNnuiXDtajtepbyxehRFgjQWM1u0xtdBG0g5L?=
 =?us-ascii?Q?qirr4rFyKw/o7Vh6orhxRdIh+xsD0073tHzPzPUBeufw4kftiUAj3iLldg+C?=
 =?us-ascii?Q?2Y77C2eWlw1ck0A1WzL26WCr3bC047bY/t1Jx4GxSYex7bm2lyHa4dPgOnJK?=
 =?us-ascii?Q?aklDgCAPLP8WQ/3wAE4D/Uo5IoMNT19QGUXxU+UbK5thpg9BzZJk8kPIPq3T?=
 =?us-ascii?Q?qoZSRwnd/0FEtzUi3J/KeM61qsxwQLgoL4hxUhRQhdDG4KRJX1V9IcurmvZI?=
 =?us-ascii?Q?jbN+UGPIF63jYGoea5ad9V2otvyoFxyuB/YfyO2vpA1soBcjm5AYiMxn+vds?=
 =?us-ascii?Q?LPkReyYCzQSPorYFxHt+xAV1Llx5dXe6gry0j2mlTOZyWS9di5JlhKOLbnfr?=
 =?us-ascii?Q?0MVhOZjugW7W4RRoKf4u7DgMtPRGcCYHrgjV16RRJG/WExqvx0gmVN8WZqOj?=
 =?us-ascii?Q?wB/nttW8SiE9K/aBLVOJ1WnnNlHpNs7i8C64KuHQLy2EJTXcWhVngEAn+Zlk?=
 =?us-ascii?Q?9lvEOT0xDK74fVjauofatcPaoAFSDSGc2fnRSnileQoScVvLOYZ2RVzRQMgM?=
 =?us-ascii?Q?i0/B2eQvU5ocdXeHT++EzKfj/ketYGj/lAAWyRxTFqZHrLhiJa8MORj98/Xb?=
 =?us-ascii?Q?CU0TpJlRcTxE00TIGVluRJ8z6t7PhsYUjveUGAXd+xIOsw8VuF7mZcUXi3F1?=
 =?us-ascii?Q?fEIJ+u/sFrIkVvNzgwrjIMAzv1KNvq0+YSZdmKZGNgHqjSFjcyRcl1gHtB9w?=
 =?us-ascii?Q?4v4fglmyyi1dsi37PSkleeS/CBc1Cx366qtqzphF3qal8+/RuOcrbe0dKoL9?=
 =?us-ascii?Q?Nd1SN1h87qSOTJHeKWyRrjn81iRXThaFKiikXZvKJ/JHbgyPonWoB0aChTdn?=
 =?us-ascii?Q?IlOk/mixCgV9B9xJSNY4zIhjvYLQTAYkNZ8fqdh9lman3LfmbVSGOChEdQrc?=
 =?us-ascii?Q?NmXTDJLbS9oTYzhBgHTvvp3In4jzlFWsjeSBQYkWfazlsxqJu+CxAdo/OQPo?=
 =?us-ascii?Q?x0V8OWd0zD2/HdU/fW8MHqbViCFubjSYLOYOc5ZEvcTTrtZBhvnAwGlmlDQy?=
 =?us-ascii?Q?J5K0JoyQYUgVdtrkiGSAt3WWNJX9B0hxrakBQF/cyYSnqTbCFi2lJ7sNrAYG?=
 =?us-ascii?Q?eiUFHxi2UoGOT/veFy47SwG0b8FvsXE9LBTK8uwGCeq92su2X5IJvbgbi3ac?=
 =?us-ascii?Q?MgnWdJan5f7o8aaVj4FtrnTkRwcdFJrUG25Ne2m8qO9f3Mq30wlBZJzHedAJ?=
 =?us-ascii?Q?73X3cabygTuGvY376Ie7N/uqiVnQ3mqolIoySK8UfWx5UvD9SWzf2k8hKhp9?=
 =?us-ascii?Q?BgvXIBsoi7BxcHw9tJNUsLAO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8953633-0238-4665-71cd-08d94c64225a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 16:25:20.7748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NupyWziEHdlPYCV3qvKWAH2O0kY8y6VnWtQ5MZhZdo2MIDtI8l2As9VUwha410a+PQDccoXOZiNHcXoHF2HF0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make more room for some extra code in the NETDEV_PRECHANGEUPPER handler
by moving what already exists into a dedicated function.

Cc: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
v2->v3: patch is new
v3->v4: fix build error (s/dev/netdev/)
v4->v6: none

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 37 +++++++++++++------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 62d322ebf1f2..23798feb40b2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2030,6 +2030,28 @@ static int dpaa2_switch_prevent_bridging_with_8021q_upper(struct net_device *net
 	return 0;
 }
 
+static int
+dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
+					  struct net_device *upper_dev,
+					  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!br_vlan_enabled(upper_dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Cannot join a VLAN-unaware bridge");
+		return -EOPNOTSUPP;
+	}
+
+	err = dpaa2_switch_prevent_bridging_with_8021q_upper(netdev);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot join a bridge while VLAN uppers are present");
+		return 0;
+	}
+
+	return 0;
+}
+
 static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 					     unsigned long event, void *ptr)
 {
@@ -2050,18 +2072,11 @@ static int dpaa2_switch_port_netdevice_event(struct notifier_block *nb,
 		if (!netif_is_bridge_master(upper_dev))
 			break;
 
-		if (!br_vlan_enabled(upper_dev)) {
-			NL_SET_ERR_MSG_MOD(extack, "Cannot join a VLAN-unaware bridge");
-			err = -EOPNOTSUPP;
-			goto out;
-		}
-
-		err = dpaa2_switch_prevent_bridging_with_8021q_upper(netdev);
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Cannot join a bridge while VLAN uppers are present");
+		err = dpaa2_switch_prechangeupper_sanity_checks(netdev,
+								upper_dev,
+								extack);
+		if (err)
 			goto out;
-		}
 
 		break;
 	case NETDEV_CHANGEUPPER:
-- 
2.25.1

