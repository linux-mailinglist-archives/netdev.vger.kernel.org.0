Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D8C5707EE
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 18:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiGKQGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 12:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiGKQF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 12:05:57 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2077.outbound.protection.outlook.com [40.107.22.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AA6643CA;
        Mon, 11 Jul 2022 09:05:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f06GTROKfhQwkMhYDDXzClDoihOGTYrsKL1+0rXajReA+FTJP9QzNU37Tva4ooDe0d6dCX4QIfXInboNnxLK4tK9VGhfm2hhU2aFvfDy+o7JUTFfb2alRN9no223cWg+uWyoeQt8PCkWTdRacXkpDZwjj7AN0dgcgJMOhQgP/81ZKLZTh/wg38QauDq7B+02WQoan/GakDKV221/6Xotv6BXD+uxbwG/rc9WQ5LB+h8ma/t/x9WGkcWMts4fQokTqwlZb5UnD0TMV6xyJom0ezcE5r1W2CKxgkL0DWuAG9pi1QyLvD1SCbmFpV4bFx3U6feB2HWVEVvVMAPPN028MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJhoeHaS2RoLe/8oyfHiZlAmUj9I5VVBl6zSPK/jRzk=;
 b=O/e2z3I46O1qs77/3+1/lp9keNYvulfB8y21HnB+N7s1yukrvMNEbhenCd9qVHLG+fGIr9E6Zjyh+slkUVykT4S2M01uqWAQ5wwlm8M4xcUynrWSnjzOL8d2cSZZR/qQ4hUELQMjE9VUXrsreX9+hDYg+T1XzJPRK0EIKrVXjvcZB91AzjLmP1+uVK39NZNIHnxYwGqmH5vtn6fcW9ifT1Bny3gHWpgJ9Xbs481+UYw/AecXAqYNCZGQ/UYuU899vLBz4wzQsgF3q6YR/SP6g+WvAkQ1VsPIn74MG5mxJ1OFfFHX+Ak+hAl4d1BATCT7mUiGlAhBSEhyZTAI/llE6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJhoeHaS2RoLe/8oyfHiZlAmUj9I5VVBl6zSPK/jRzk=;
 b=SXnvNkcTiUK2bchmCrS12wDSAHyO56i5kkWMOF1jMVUqjOuQe8Qx2U5Bl2SYMPwBifWhAzqw+uXQpmt/T9KqkyvUOgN/5xNaBXAnjHJo8WsYVgBfdO0rwrlYuyZUVZyJVkiGJKiD0yDnoo88ssLMXKWk7KQJYK1lZF241QejahrrPBhJFJhjLY17FJ2tkhdFdY+V2n+qIAA/oA463rK7R1UAdZg0ScAHLpD8qMJTGBxaLabcw09bnm/8jGBvGZNCMQhxJ1EfG7mSt/ZefKiyAg3nq1b+j7XsaqDZYnNwOt/54axb2FQDtfzwMfw21HNKpwSdZwUqtiyEjRw9yyUEEw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB5113.eurprd03.prod.outlook.com (2603:10a6:10:77::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 16:05:48 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 16:05:48 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sean Anderson <sean.anderson@seco.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 4/9] net: pcs: lynx: Convert to an mdio driver
Date:   Mon, 11 Jul 2022 12:05:14 -0400
Message-Id: <20220711160519.741990-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220711160519.741990-1-sean.anderson@seco.com>
References: <20220711160519.741990-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:208:234::25) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1141b8bf-020c-4856-81cd-08da635737e3
X-MS-TrafficTypeDiagnostic: DB7PR03MB5113:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fLHzg4j5uMrVXcNcPBkXughwixB1sTI0JZt1StUrTvrmELHwSwhjOdE33Hokrrcna5sJ1IRh9z8q7WsSm6+azwLfzO+fS3xCwKE5SPVkmV3p+PrxLkdwEkaGpFg1GLNBFdYUlQaJ1W1gnS7p2VUYctYWCI8ewMqau1QYikYD5zgMoVQ3TeEBP6gGboV1Zm060RxTvarCRKNQW1M5Ppd4LGUR/t4XUn2KS6W6JBLKQ5YIsFRNAGw7xFmrmUfdy+uBP8T8JBeeLyg9fLRnRwIT9frU6Km3lZCmERjguqQvJC4butvwlG+cjrcxOv25Gg3Qb91mmsNsoyXFmbVfeAnL71tB5EylUQ8Xd/Oh1zYTLcRKOttfOTLtnvhP/bypzXKLy/AYjr0SMUIw00BNshCqWFEFtsyMD/wFwNKYUi/fzYp2bcmfyyAELoav49mcp4WyfYDLnTVpEIopSfZqQuh7VLaatXoF0iICvHTBRsjssmI1j+LeLuITXlXuEiOTbNJkWnHFp9ipdxlys4tK0imJDcIJ5O7LYv/jfr7WewNGP10Yk1QxQJa6zJGQxw9jMIF9WmrzFSBAwgyT9s4DUWGHrWWkix4JXJnbmhFln8x2mxPE7SsZQiaHaGS+5k0T49n05YTGYp0eSXlcPqhDGM4+dX7RQadTzHZxGuCeTERhajUDivqEFcXLY21bNQi1dKb8issfL2bM7tIX8S9CcYtA+ngZqedDoeXn6xRpg81cMoJ1bcT8FR/xnMn7N5831dcou6eBr6CtNlJnMaP6Yrp0sSO6S8raISTQCADQUVbcGTEwQxZ7egISpfspea14frdG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(376002)(39850400004)(366004)(83380400001)(86362001)(38350700002)(66946007)(38100700002)(4326008)(8936002)(66556008)(66476007)(8676002)(36756003)(6512007)(316002)(54906003)(5660300002)(44832011)(6666004)(7416002)(2906002)(6506007)(41300700001)(26005)(6486002)(52116002)(478600001)(110136005)(186003)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hz1SlZ7xmZR1mkygIDDZtJ9+IMgcT4YW0oVxbqZV7FuxMLOX0NRfMlAKreRy?=
 =?us-ascii?Q?Mw2QOViNj4bEYHLcOo8jFULkAS+lNdQ5Eb4MCcn7hAQ3VDqgpc2pPSctjS7z?=
 =?us-ascii?Q?j4NOYH4skeTs0hNOuRBeCrK2vyeNOJzc8jAm6L6SvjRlmTsDoKGCsMtWdrLw?=
 =?us-ascii?Q?vetWWRxptv8pYw69JJgLBumoQ7662NmdbAOpKOQuZKElDBZWcWry4ngLK6H7?=
 =?us-ascii?Q?t5Vy9znmPwSz7MllEuMTE+2Jp7hseOuGHIia1xA5KMYxkAAG7j8YO48HFEuU?=
 =?us-ascii?Q?m2EquU3UxzVG+YO1Ll7Rr8I8CLBqx22ioRMRmJM8V2qc9yOoGf+mgWpoZI8D?=
 =?us-ascii?Q?ZIji9zkVdP59EslP1FOCGj6XnB3rNtiYdst334yTcebyXHCLLqPrvu82JZL+?=
 =?us-ascii?Q?s5VBPN9aU4DsS2Gt5oiYOM4dcxdRiJXnkYM0DVu+f4r1bQszJh37hng0X7L7?=
 =?us-ascii?Q?TwzCbETHZpRwELi8kHhX8PzwQIikKTOJS3DgT7DqJwNGtv3XfVg01V4i0Ja9?=
 =?us-ascii?Q?r/O0yqQ91bpO98Z4qYf/b/f3SQKYwoDvqoHMSlzF75ObsgyZYXW+CAi5LI+U?=
 =?us-ascii?Q?B+/XcfNZ42p+L5tjzLTHrwxFiPQPC4677Z8EyL+eGPv69Vvw3PENLwdvw1/i?=
 =?us-ascii?Q?FZ9OduYiELUIfruAwzXY56U7OGrZ6z0G3Ze/F4VQ2nKrjKoRPyrywo1V9H+x?=
 =?us-ascii?Q?T8rQb+4fyyJhlEJDv9srVoP3RMMDlUxiI9HXHrlaK9lVZ5T13y+jVPAGNk2+?=
 =?us-ascii?Q?FGhPXOrtdOClzgTBsdMy7opLzBS+o5BhUXYpOBHRtLmyE38mspW202sLWpt9?=
 =?us-ascii?Q?XuB1Aq50pMVS7Vf8tuFVQFx2xeW5AJuT2XY9QRyHU5sUdih4QCnsW6pT3L5A?=
 =?us-ascii?Q?72yy9W5ubEKJtjfMrR/tu3F6ipyDf2r/C+Ey1Gj3K755Zwgd0wrq1Br68lC3?=
 =?us-ascii?Q?tFdzTFJ3HFYmSnPeguekOdSpclhUPkk2UfzCpgfxH7Inn+tYLPL2IA/mWMs8?=
 =?us-ascii?Q?dVfui/A1clMRiUCpAmHa9XlfGP1RW8JH+/SlXA9g+athVf+mFRL5++tZKiQi?=
 =?us-ascii?Q?7AVyeBYRKTICsYSQGyBBVjdf+/v+PRcy/sN3VZmO6hkhCxuE15InX00Icyql?=
 =?us-ascii?Q?iZYNdV2rONZtKNVLcHcrQ8ryBThHYBwv0h3ObIaHx1k938qZlUGKZVgVVUtM?=
 =?us-ascii?Q?ikulmrT67TLrfP8qDggqtvgfN0c6zBVmRQexV0cPVQ7uhXVISyY5HIyIIBd3?=
 =?us-ascii?Q?kivpiYbiTsz19FiYAvIfEFev+k+y9RQ8w11mIzgzP2+mHOx07jLYB6sIJeE3?=
 =?us-ascii?Q?eQ6zObGoqONUSJMieR8G9BR1cpcn+5qjmgPyteO0uv9pFctObiwrLyveqLA+?=
 =?us-ascii?Q?LYgIIxQcoeOwJI6fXno4P+QPfXrlxQZyCH/+fhHmsk1ztFHiYt+n1st7qtUx?=
 =?us-ascii?Q?O292NpVTlbxXJJ7tpZUNXS+JenZerYZSHDbOaGWg0pLH6XT1G/9NoBNrxiQa?=
 =?us-ascii?Q?J5aIdg9wNk62+jm16HtP8ciccE+66fm0dOqfA4Oi0wCBEH5BownSkgUF438o?=
 =?us-ascii?Q?Fc56AI8oZthPRJJcob0J3eZt7XTjevzGAaNpqIVuluPpzpP88plxB2glHGUT?=
 =?us-ascii?Q?2g=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1141b8bf-020c-4856-81cd-08da635737e3
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 16:05:48.3244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NofFABC9XLCHZZyKARyrfmuS9EmLVX2Qezqn/wCbq6u4mskta0lI4Y0Aeju+5PEWY9QGSF1BTjHbAGh+IHJFGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB5113
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the lynx PCS driver to a proper MDIO driver. This allows
using a more conventional driver lifecycle (e.g. with a probe and
remove). For compatibility with existing device trees lacking a
compatible property, we bind the driver in lynx_pcs_create. This is
intended only as a transitional method. After compatible properties are
added to all existing device trees (and a reasonable amount of time has
passed), then lynx_pcs_create can be removed, and users can be converted
to pcs_get_fwnode.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/dsa/ocelot/Kconfig                |  2 +
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  2 +-
 drivers/net/ethernet/freescale/dpaa2/Kconfig  |  1 +
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  4 +-
 drivers/net/ethernet/freescale/enetc/Kconfig  |  1 +
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  4 +-
 drivers/net/pcs/Kconfig                       | 11 +++-
 drivers/net/pcs/pcs-lynx.c                    | 65 +++++++++++++++----
 9 files changed, 72 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/ocelot/Kconfig b/drivers/net/dsa/ocelot/Kconfig
index 220b0b027b55..cbb0ced3f37d 100644
--- a/drivers/net/dsa/ocelot/Kconfig
+++ b/drivers/net/dsa/ocelot/Kconfig
@@ -10,6 +10,7 @@ config NET_DSA_MSCC_FELIX
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
 	select FSL_ENETC_MDIO
+	select PCS
 	select PCS_LYNX
 	help
 	  This driver supports the VSC9959 (Felix) switch, which is embedded as
@@ -25,6 +26,7 @@ config NET_DSA_MSCC_SEVILLE
 	select MSCC_OCELOT_SWITCH_LIB
 	select NET_DSA_TAG_OCELOT_8021Q
 	select NET_DSA_TAG_OCELOT
+	select PCS
 	select PCS_LYNX
 	help
 	  This driver supports the VSC9953 (Seville) switch, which is embedded
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 570d0204b7be..57634e2296c0 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1094,7 +1094,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 			continue;
 
 		phylink_pcs = lynx_pcs_create(mdio_device);
-		if (!phylink_pcs) {
+		if (IS_ERR(phylink_pcs)) {
 			mdio_device_free(mdio_device);
 			continue;
 		}
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index ea0649211356..8c52de5d0b02 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1049,7 +1049,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 			continue;
 
 		phylink_pcs = lynx_pcs_create(mdio_device);
-		if (!phylink_pcs) {
+		if (IS_ERR(phylink_pcs)) {
 			mdio_device_free(mdio_device);
 			continue;
 		}
diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index d029b69c3f18..2648e9fb6e13 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -3,6 +3,7 @@ config FSL_DPAA2_ETH
 	tristate "Freescale DPAA2 Ethernet"
 	depends on FSL_MC_BUS && FSL_MC_DPIO
 	select PHYLINK
+	select PCS
 	select PCS_LYNX
 	select FSL_XGMAC_MDIO
 	select NET_DEVLINK
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c9bee9a0c9b2..e82c0d23eeb5 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -268,10 +268,10 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 		return -EPROBE_DEFER;
 
 	mac->pcs = lynx_pcs_create(mdiodev);
-	if (!mac->pcs) {
+	if (IS_ERR(mac->pcs)) {
 		netdev_err(mac->net_dev, "lynx_pcs_create() failed\n");
 		put_device(&mdiodev->dev);
-		return -ENOMEM;
+		return PTR_ERR(mac->pcs);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/freescale/enetc/Kconfig b/drivers/net/ethernet/freescale/enetc/Kconfig
index cdc0ff89388a..c7dcdeb9a333 100644
--- a/drivers/net/ethernet/freescale/enetc/Kconfig
+++ b/drivers/net/ethernet/freescale/enetc/Kconfig
@@ -5,6 +5,7 @@ config FSL_ENETC
 	select FSL_ENETC_IERB
 	select FSL_ENETC_MDIO
 	select PHYLINK
+	select PCS
 	select PCS_LYNX
 	select DIMLIB
 	help
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c4a0e836d4f0..8c923a93da88 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -859,9 +859,9 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	}
 
 	phylink_pcs = lynx_pcs_create(mdio_device);
-	if (!phylink_pcs) {
+	if (IS_ERR(phylink_pcs)) {
 		mdio_device_free(mdio_device);
-		err = -ENOMEM;
+		err = PTR_ERR(phylink_pcs);
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
 		goto unregister_mdiobus;
 	}
diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
index fed6264fdf33..a225176f92e8 100644
--- a/drivers/net/pcs/Kconfig
+++ b/drivers/net/pcs/Kconfig
@@ -25,9 +25,14 @@ config PCS_XPCS
 	  controllers.
 
 config PCS_LYNX
-	tristate
+	tristate "NXP Lynx PCS driver"
+	depends on PCS && MDIO_DEVICE
 	help
-	  This module provides helpers to phylink for managing the Lynx PCS
-	  which is part of the Layerscape and QorIQ Ethernet SERDES.
+	  This module provides driver support for the PCSs in Lynx 10g and 28g
+	  SerDes devices. These devices are present in NXP QorIQ SoCs,
+	  including the Layerscape series.
+
+	  If you want to use Ethernet on a QorIQ SoC, say "Y". If compiled as a
+	  module, it will be called "pcs-lynx".
 
 endmenu
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index fd3445374955..8272072698e4 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -1,11 +1,14 @@
-// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
-/* Copyright 2020 NXP
+// SPDX-License-Identifier: GPL-2.0+
+/* Copyright (C) 2022 Sean Anderson <seanga2@gmail.com>
+ * Copyright 2020 NXP
  * Lynx PCS MDIO helpers
  */
 
 #include <linux/mdio.h>
-#include <linux/phylink.h>
+#include <linux/of.h>
+#include <linux/pcs.h>
 #include <linux/pcs-lynx.h>
+#include <linux/phylink.h>
 
 #define SGMII_CLOCK_PERIOD_NS		8 /* PCS is clocked at 125 MHz */
 #define LINK_TIMER_VAL(ns)		((u32)((ns) / SGMII_CLOCK_PERIOD_NS))
@@ -337,34 +340,74 @@ static void lynx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 }
 
 static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
+	.owner = THIS_MODULE,
 	.pcs_get_state = lynx_pcs_get_state,
 	.pcs_config = lynx_pcs_config,
 	.pcs_an_restart = lynx_pcs_an_restart,
 	.pcs_link_up = lynx_pcs_link_up,
 };
 
-struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
+static int lynx_pcs_probe(struct mdio_device *mdio)
 {
+	struct device *dev = &mdio->dev;
 	struct lynx_pcs *lynx;
+	int ret;
 
-	lynx = kzalloc(sizeof(*lynx), GFP_KERNEL);
+	lynx = devm_kzalloc(dev, sizeof(*lynx), GFP_KERNEL);
 	if (!lynx)
-		return NULL;
+		return -ENOMEM;
 
 	lynx->mdio = mdio;
+	lynx->pcs.dev = dev;
 	lynx->pcs.ops = &lynx_pcs_phylink_ops;
 	lynx->pcs.poll = true;
 
-	return lynx_to_phylink_pcs(lynx);
+	ret = devm_pcs_register(dev, &lynx->pcs);
+	if (ret)
+		return dev_err_probe(dev, ret, "could not register PCS\n");
+	dev_info(dev, "probed\n");
+	return 0;
+}
+
+static const struct of_device_id lynx_pcs_of_match[] = {
+	{ .compatible = "fsl,lynx-pcs" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, lynx_pcs_of_match);
+
+static struct mdio_driver lynx_pcs_driver = {
+	.probe = lynx_pcs_probe,
+	.mdiodrv.driver = {
+		.name = "lynx-pcs",
+		.of_match_table = of_match_ptr(lynx_pcs_of_match),
+	},
+};
+mdio_module_driver(lynx_pcs_driver);
+
+struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
+{
+	struct device *dev = &mdio->dev;
+	int err;
+
+	/* For compatibility with device trees lacking compatible strings, we
+	 * bind the device manually here.
+	 */
+	err = device_driver_attach(&lynx_pcs_driver.mdiodrv.driver, dev);
+	if (err && err != -EBUSY) {
+		if (err == -EAGAIN)
+			err = -EPROBE_DEFER;
+		return ERR_PTR(err);
+	}
+
+	return pcs_get_by_provider(&mdio->dev);
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
 void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
-	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
-
-	kfree(lynx);
+	pcs_put(pcs);
 }
 EXPORT_SYMBOL(lynx_pcs_destroy);
 
-MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION("NXP Lynx 10G/28G PCS driver");
+MODULE_LICENSE("GPL");
-- 
2.35.1.1320.gc452695387.dirty

