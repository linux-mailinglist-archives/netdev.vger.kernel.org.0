Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75BC962E9FE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 01:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbiKRADH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 19:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239809AbiKRACh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 19:02:37 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80055.outbound.protection.outlook.com [40.107.8.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9FE85EF2
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 16:02:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M23HgAjU8fBU9WxEH/yYXQJmDrBS/RUc6agMvy2rOjImhzM6LRVLUp/tCKnNF0+jaSbN54kS1uS1zv9bJTVkwmsiIsvzAL+/5BGc96HpZ3Cfhhh2dekeoyAAI4JFstAI6hDUGXFeaUgs9wJYNJ5n1oQ8iFcfu9Zs2Dkttrf8fQT3whSCcVMVLWchX0FbvCnjNEjlZxYSBVzG8Qblk58aHCzQrY4Jr3rg34X6p9QdBduKfdW10sUfNOGQBeHq0qUvZcjOrCNAmG7SLMM8bfWtfvoOu38RCmT5tysvrsw1CWVhtsIMYb/WQFuDsLdKrz96+G5TvIyFj+87U7yNVeZD6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q+/1l92qO7xH2CsN9qdGpylmgxPKoDmzkxE6/s8Z2zo=;
 b=X5+SNe/SWtRaz8/jRRzX1kGgQDHa2JrT9UxEhSdIwCfoy2YfEUyF34eRl1SemH5habFjP6T6QwTljnKWDQSrCR5oHOLtfolwRgCeVuU4Ixfnhb8qp1No1RV+d/18fu/pM84XGNOshXehIyBJJo0IdhrlbK3EN1Fxc8Gnqfhp57kr84gt9PZZyaJMOgjQNPPtOu/f08A5Gl3695pDuviDF/fcBvF/mY5lbxaMPIGtnyge7Vm1pdxQV8BunfqC5Gy6sa7b24nfFrf8UgGcbwR4zFeLUoeRC8+7oSAqMv6ymkk+uX/MLBsw64x5gmpiWrmBA2GeMCEJbAcm6sC6epHUew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q+/1l92qO7xH2CsN9qdGpylmgxPKoDmzkxE6/s8Z2zo=;
 b=Gz/RDYZDF9yHHtjw0FcGKltsYwefc9krfa6813jrIOQzyGXXZokH0w1EXxBGSVEMz42n2WXjb9TWSB02AIikmZ0424F3yfB4QW6zKCmoaUKlGPNsqLtP3jJT/klmyJrBDGfOQoe2rHoLi9x8nbWTeunFsmEZN9mxxPmo7bXP8hY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8542.eurprd04.prod.outlook.com (2603:10a6:102:215::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 18 Nov
 2022 00:02:17 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 00:02:17 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        bcm-kernel-feedback-list@broadcom.com,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Sean Anderson <sean.anderson@seco.com>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Raag Jadav <raagjadav@gmail.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Marek Behun <marek.behun@nic.cz>
Subject: [PATCH v4 net-next 8/8] net: opt MAC drivers which use Lynx PCS into phylink sync_an_inband
Date:   Fri, 18 Nov 2022 02:01:24 +0200
Message-Id: <20221118000124.2754581-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
References: <20221118000124.2754581-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0006.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::16)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: ee5ca32e-06c9-4216-c5b7-08dac8f827ee
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P8qIiPHhP3vz8jqpKc2aEfVJtci1bb9h6hn2s4ld6rLrSUlk5UkDBJ/mTWTP+9HJlfwl1d+/Z08tm37lL1YQTHo2sw2oNkmCBZfpKSWUGnsNvemv2qdplRvfOq1csAVOPzQuCZqzCrFF1O6C8wQ+TSD2Ojav/jBRSqIYS2ODUUA056dUxceA7SogUm7rNx5Ua0AC+7L56MonvZzuKY/evcjijdvH0D93D4MhyihimquVRUPuprlDo7Xzb+7w133kYyziH0QgUA4iVFjnH2++VsvadrcgUqgH07R90ukcNd7+98Pkm89vtrx6CDspzM35tmb0y9xeHdtJoLTRdHCupCuFVcYIEXs2g2eilewX9EgjJR+CEr5aGxa7s8H/yv2MCB5LOmd2UkDRhDjHTaBw60Fn2E2krfpHEZc9kf44Q0Y1GKPwIJveznbnl2CFwluzNdX4KO1xuX+4Eo7kilDKXjtoIzuTOZ866P8DG/mu5+YOiFcLVi5rJ/1pO5DOKvYJ3XU1tGLmLZg3rQYp9Oj2VG+TKyyY1xsRADLL0LvlfONoaM6f1trF36gUDJErqsLrNZGbqu7hNasxcEWYopaQmjjwrX55D7ReAdIyV9r4K1kscaQogMAyukJwZ6uYTkIwyYbab9KBBzb8PmyIAeFkA9bsq14ASDOuqnDWbBSQVLcgUT2BXcGFvS9aWco+3XuY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199015)(478600001)(26005)(41300700001)(6506007)(6666004)(36756003)(8676002)(52116002)(6486002)(4326008)(38100700002)(44832011)(7416002)(8936002)(2616005)(66946007)(66556008)(38350700002)(6512007)(66476007)(186003)(316002)(1076003)(2906002)(54906003)(6916009)(86362001)(5660300002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MQoz6hjb9Bvs7uy6QmONljFm3DX5HBEKNcB4BschxHLitCGSLrM4BI2AqUHl?=
 =?us-ascii?Q?27POsztuK6PMVrW2VP5sQ+k3FJ+3c8TQGWLsp46vhXHGL0DsmByl8DR1kbwS?=
 =?us-ascii?Q?pMsigme8y6rqWGDor5zQvAYSfyUSLUlcFxHTOW+2u6hitFJWgryt7qVIZSb4?=
 =?us-ascii?Q?T+Z0nzO98UHKrSuJ/W1gUUs/9+Pcqhzn/9d7sXvHkRO9cOgKHn+Or7GjBfGW?=
 =?us-ascii?Q?5gCbmGmHmK0pZ7avyO6BYnhoi+5wZlj4G/hbZ50QBxSrA9NqEbKd4eGDtM0g?=
 =?us-ascii?Q?ClNZJIW2EW9ld8IhuVsOV04X7zLXDbw8xnhULjyXTEeCV/qbukxBNgsPEF5F?=
 =?us-ascii?Q?ukxCqs/MbnoRTagps60q9DHyVgSkBmWXxZIfRoyT3Lliv5FCzOt86qvQ0mMu?=
 =?us-ascii?Q?csGmL33cZMk1qNJKfrMTnNujKcmOvijgLgSqF9UZ+t/fY1kGacyFWZ720sjQ?=
 =?us-ascii?Q?16NYAgV4ERjoLqsVcO+gJvpemfhWuDq6AiY1OW5DamT/iTUYAZtWlXY2tdOg?=
 =?us-ascii?Q?/blk55peuBHnDJEQqtoh4xWujDqgEH4sjnZvV/16ciWZpsr7LoisRqqnccuY?=
 =?us-ascii?Q?KC6U3hTYexE5vnS2NIvTmJjhO1skblXZ24vh39wNIt8veCxjqF3xSnTbkzvE?=
 =?us-ascii?Q?yLbx9+WybsninehQd1wD2WmdcOtDB8NhzhqVcahjpRK8ZABVWrEA11ej9tHX?=
 =?us-ascii?Q?scTtxAI3xTAryFgYqEvLenVIjBK9ZjX3DkMjghtcO19p0NEVWkV5wKq18ykk?=
 =?us-ascii?Q?ZC+jLwKfliDuxBSoZ5UVF9umtrZlzNzmZAMJIdpTKwWpMXgaammz/7JkaESu?=
 =?us-ascii?Q?eWjyVJve6um2YLjsntOY2Ey0Xe1nTXPKDeoTeJOu8b3qtmgARj2dzXHdsXOp?=
 =?us-ascii?Q?XcTaYXdV/sx+3lu/AjzizFrZJ6ubvsxgLBQNgs3OvzzswH+OL5S4jsCYWWrh?=
 =?us-ascii?Q?3do+6EWl7ximfrQERoU1H0i0grt6YlczX8FVsCAmDbBZjq2GrJRVaAmewQ5n?=
 =?us-ascii?Q?SYAFbLzU4Tc1RQjv9MrhyuewSYe9tETPmxVCBe4w3Balx1+uiJ3kwAyD8CvF?=
 =?us-ascii?Q?7uaCmawkLhGxxYo8FAQcs4zLkfsFMu00jVag95L5Dw25hzCHQ6PuI7jjvXXl?=
 =?us-ascii?Q?hhwWUS5bQk5b42ltN2UPWipzCldY7pU93F6FWgEGPAryfGlfz/HkJvg6fKxo?=
 =?us-ascii?Q?hy9t2w3Mz+YuC57X3rZpzhE99Xi4UuP1OIqsW3sfWh+rgF4ePYMBqMg+O0A6?=
 =?us-ascii?Q?fGs0a27u2SmpaFkUZeT+avXjExqk7OkVgKK0TlryGb5bgzS4qOeNBRjxdVls?=
 =?us-ascii?Q?ynYcDt3r/x26YsgCFBciJKbRMqaY80z2Xf0ZSWSqp9ZMZKHv+rvDLHfULqxB?=
 =?us-ascii?Q?FUrciTQJ9L16LvBLOfiepEgo7177nNAYhQjlkss5tWkk+5eaQ9moTd8kTmab?=
 =?us-ascii?Q?PGY3yXju3SRyGyqFreOudwZLu+0WE0odjuUkBhuANmOXjJ66oE3dUPf6wp4x?=
 =?us-ascii?Q?n8b+xN6UCoNO6w4HRZzr4y16wRoIHwBGxijzo3bjFouV6MGTIZp3RiAUVPx4?=
 =?us-ascii?Q?MwzhAtkNAo3nn+HTScNkUh44PIwmo2tlKB4GE8wJ/1pa9NlIL2tNd1TnAxpb?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee5ca32e-06c9-4216-c5b7-08dac8f827ee
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 00:02:17.5625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtaYdTW9uDNNByRdbwOYiGxW0ibp08yzCpw5JHkLD+lAEqtj1NblX6kmzwsktf9a8lNHlFyC6LtT+D76ESAwlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8542
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

lynx_pcs_config_giga() enables "SGMII AN" only when used in the
MLO_AN_INBAND mode. If it's connected to a PHY, it expects that the PHY
has the in-band autoneg setting in sync with it.

To fulfill those expectations, set the sync_an_inband field in the
phylink_config structure, to opt into the new phylink behavior which
does the following to help with that:

(1) queries PHY driver to figure out a mode supported by both ends
(2) configures in-band autoneg in the PHY to something supported by both
    ends

The Lynx PCS is integrated in DPAA1 and DPAA2 SoCs, as well as in
LS1028A (ENETC + Felix switch) and in the T1040 Seville switch.

It seems that the DPAA1 phylink conversion already took steps to prevent
breakage with old DT blobs, by using ovr_an_inband. That is partially
sufficient, partially insufficient (there is still no guarantee that PHY
really has in-band AN enabled). Remove that logic and simply set
sync_an_inband instead (setting both isn't allowed anyway).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: patch is new

 drivers/net/dsa/ocelot/felix.c                   |  2 ++
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c |  1 +
 drivers/net/ethernet/freescale/enetc/enetc_pf.c  |  1 +
 drivers/net/ethernet/freescale/fman/fman_memac.c | 16 +---------------
 4 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 44e160f32067..6deff681c02d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1042,6 +1042,8 @@ static void felix_phylink_get_caps(struct dsa_switch *ds, int port,
 {
 	struct ocelot *ocelot = ds->priv;
 
+	config->sync_an_inband = true;
+
 	/* This driver does not make use of the speed, duplex, pause or the
 	 * advertisement in its mac_config, so it is safe to mark this driver
 	 * as non-legacy.
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 51c9da8e1be2..61d31ffb5d97 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -406,6 +406,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	memset(&mac->phylink_config, 0, sizeof(mac->phylink_config));
 	mac->phylink_config.dev = &net_dev->dev;
 	mac->phylink_config.type = PHYLINK_NETDEV;
+	mac->phylink_config.sync_an_inband = true;
 
 	mac->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_ASYM_PAUSE |
 		MAC_10FD | MAC_100FD | MAC_1000FD | MAC_2500FD | MAC_5000FD |
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 9f6c4f5c0a6c..c0d4fff00987 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1126,6 +1126,7 @@ static int enetc_phylink_create(struct enetc_ndev_priv *priv,
 
 	pf->phylink_config.dev = &priv->ndev->dev;
 	pf->phylink_config.type = PHYLINK_NETDEV;
+	pf->phylink_config.sync_an_inband = true;
 	pf->phylink_config.mac_capabilities = MAC_ASYM_PAUSE | MAC_SYM_PAUSE |
 		MAC_10 | MAC_100 | MAC_1000 | MAC_2500FD;
 
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 9349f841bd06..e4a707a7d7f4 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1075,7 +1075,6 @@ int memac_initialization(struct mac_device *mac_dev,
 			 struct fman_mac_params *params)
 {
 	int			 err;
-	struct device_node      *fixed;
 	struct phylink_pcs	*pcs;
 	struct fman_mac		*memac;
 	unsigned long		 capabilities;
@@ -1219,6 +1218,7 @@ int memac_initialization(struct mac_device *mac_dev,
 		capabilities &= ~(MAC_10HD | MAC_100HD);
 
 	mac_dev->phylink_config.mac_capabilities = capabilities;
+	mac_dev->phylink_config.sync_an_inband = true;
 
 	/* The T2080 and T4240 don't support half duplex RGMII. There is no
 	 * other way to identify these SoCs, so just use the machine
@@ -1231,20 +1231,6 @@ int memac_initialization(struct mac_device *mac_dev,
 	    of_machine_is_compatible("fsl,T4240RDB"))
 		memac->rgmii_no_half_duplex = true;
 
-	/* Most boards should use MLO_AN_INBAND, but existing boards don't have
-	 * a managed property. Default to MLO_AN_INBAND if nothing else is
-	 * specified. We need to be careful and not enable this if we have a
-	 * fixed link or if we are using MII or RGMII, since those
-	 * configurations modes don't use in-band autonegotiation.
-	 */
-	fixed = of_get_child_by_name(mac_node, "fixed-link");
-	if (!fixed && !of_property_read_bool(mac_node, "fixed-link") &&
-	    !of_property_read_bool(mac_node, "managed") &&
-	    mac_dev->phy_if != PHY_INTERFACE_MODE_MII &&
-	    !phy_interface_mode_is_rgmii(mac_dev->phy_if))
-		mac_dev->phylink_config.ovr_an_inband = true;
-	of_node_put(fixed);
-
 	err = memac_init(mac_dev->fman_mac);
 	if (err < 0)
 		goto _return_fm_mac_free;
-- 
2.34.1

