Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2504B480F3F
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238551AbhL2DW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:22:59 -0500
Received: from mail-bn8nam08on2138.outbound.protection.outlook.com ([40.107.100.138]:18785
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238529AbhL2DWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Dec 2021 22:22:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGxm6s+eCX5RvDQcwlerWnJ3Iz8YVkKpQdybCI6EnO+/NUKGnZLtdOeLKT8berw3ql4y+L8GfbT5EzrCJIV+mnaUC2/0l76wvl/LXgaKXYIrYoR3iDazyMnFBpwl2QW0vU3s31LWql89ZWTbNr4Ta+Ce/Iqr4+3OLLxlWrXjNaRJ7UxtIuinM4YE8M4K0EAoy0ECjC99P/wag1r1DkEwBpvEx0UDiVJI9hX8o90JUodbFsoNjYb7XY6Mu0dYQapHMOaF9ufQuypZfObugvNTlqQKVEVH05RpY82M8oFBJOTY5TjDBBwCykBQOmJLZD4nAD3f0niVWy0vT8TqIft1+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h29CRPV94sbHRd/acWO2E1VuldLYFtATwdpJhqOjDWk=;
 b=TpDB2sfO/DAhT+ZBnJ+16fOFBUAZP6pjDPlIaFHkvZd3r7iUS72uud8osYICKVj1TObO2J2QqTwBLTtNWzQJ/XttkoFFdYwY7ytNfmp6Vag/VnRrs11b/nkTPzo/z3U2fbOKJVw/qYiN9ofYbCcOVMaveMZfvqsk1L4JiSIOH9yzZ2k+d6Za2cJTnqH8rZ0VzPFkhFiNPoFE8gmEMZ/LY1nC3VvytAAb5er+7lPZDjVAnFbbyficYZgsquIuOfb7rL2WgC3ksLhpCvAeAs0s5fL8yH0LY7A3nlAf0ykpLomn92R3H60h2N38SpLMbX4hTBOWQvH+bJmFYVdQ9GIz5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h29CRPV94sbHRd/acWO2E1VuldLYFtATwdpJhqOjDWk=;
 b=Re7GxQ/utd+AImOyPyiSbnkMlQ526ftqaxgvUQWYnayOiQlmiU08cpOcVn+oJoMBrwKiN94fKMISIrgbf9B+bac6atEvcBgFUpjMgA7kIAufZBqrMZHxrJIJAITmaobCya/f1pUNFhlM+XDKZVxvx5x4WejDRmjzU4SFfTPePAM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB5521.namprd10.prod.outlook.com
 (2603:10b6:303:160::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Wed, 29 Dec
 2021 03:22:48 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4823.024; Wed, 29 Dec 2021
 03:22:48 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v1 net-next 1/5] net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
Date:   Tue, 28 Dec 2021 19:22:33 -0800
Message-Id: <20211229032237.912649-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211229032237.912649-1-colin.foster@in-advantage.com>
References: <20211229032237.912649-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR14CA0015.namprd14.prod.outlook.com
 (2603:10b6:300:ae::25) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1ac0220-c1c4-47ac-ebcb-08d9ca7a7d34
X-MS-TrafficTypeDiagnostic: CO1PR10MB5521:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB55213A76AAB0F19C0170C50EA4449@CO1PR10MB5521.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:172;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKoGh6CkLq+H59ivxfqlAMg1jMIJmlvYwRiPamLmGi9BeZIaQ3dN2d8zdk8O6UBkf9MesOnXjuS7uBTXlggodnmXL9AhoI5TABZmCW4So/E+ztJWRL01z3jvjBTQtzy8WC18K2fx7xSMPzX9wz0uRSp3MleeMhfURAFkYahaI0C25gsUPDMP5Pf7zZBGN2E5d3oQrhlhoYN86+I4qOj7mNKufVAOkoW0FToDh6GBdBe15DfZIq2rPTTpNmz3Vmm7BdynZLQIHJA9rnrXuxiXfghSJvyvgzFAQVqKibUAchDGNgSCS5ZSdccAAUWiUEihDA0UzoYEF8BbKgDxT2EUDX3/mjUhBMvhr5YfrSA6bfktb4xwmkYAorRlBSAen79VfF5MUy/jq9gmDnw/tXSuW1itebThnChluLyj990jOjlCQISg8weyAwVHrGj8txAGhpKke4MsHAU/i+zE2OBKBZmSDo23kna27rmCsXo2RYMjdtm3kcKmB2hK0gUli67pN0lIOKCYr3Tk6WrEMoEysY1vx0yg6+TEyjxBlwHVaCZfWcFivUiXCuGFdukyoOMIEYzF5b244RnAQEf7SLl6W64Um6Dk7yiHVgBro5WHXfW/YZ14fTLmqOrGFUw8Am+59pNZGRIW1o5n0G3pUy/7VG6JlF4IezrkpLWkNuy/scyb0V4GjeWXuVuUaXoqf1gT0Nv3SN0Li1nSt6ilUfK7+UICBNcc7qtkPBWiitoxacc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(42606007)(376002)(396003)(366004)(39830400003)(6666004)(316002)(66946007)(186003)(8676002)(4326008)(2616005)(2906002)(6512007)(44832011)(30864003)(83380400001)(26005)(6506007)(508600001)(1076003)(86362001)(54906003)(5660300002)(8936002)(38100700002)(38350700002)(52116002)(66556008)(66476007)(6486002)(7416002)(36756003)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hE5iBMoEoPKZI6R1hrReQuTxEBS5ulCfrcgSVzbYqK+YA42FJqdVaf/V//SK?=
 =?us-ascii?Q?mvkdIii/oJT/2zELC2vLxG8mK7XVpLYBoJejW46PhlYyqEhE82CjnPjoiLtP?=
 =?us-ascii?Q?xj6rUVfuCNg0fJwL3ItpX6ROQfc3yFMCnyNzxeAvYIj4OrV7L69P8RuvHoqK?=
 =?us-ascii?Q?+7eh2WuAj9PA1BtDA39pIy34990MIva+D7MiaEMFl9k1+QLE+w7Pnfp1lF5t?=
 =?us-ascii?Q?eJgWmD+q6MtPNAIcH3HaQwpNsOSWe5mUvkoMXAa6QBHk6SnR8q9RfAKAcUec?=
 =?us-ascii?Q?avGP/a+a3jldhe4nplhL0OYgmNvWI0EiTDyC4sVcJNnr/cTkei7WvMNGQSJy?=
 =?us-ascii?Q?ivh8v+ww8X2daLDnlNNn/noQ0hL23A0Exc8hvDSn6+SKVa+n1vkP6D0hRYnk?=
 =?us-ascii?Q?M0cy1REnTM0s5k2KfxY/N1pB1zoReqZa4df/erpMyL/1yrzyc7ZzcP093CJt?=
 =?us-ascii?Q?75irc54twPOXby0hU0bAb/XjuV/tNSYfE4ejlv5I9UTMaJu98NF1kGGeJ/C9?=
 =?us-ascii?Q?fe1IFbih6JEZbJ+VlTq+6d3BOZxe3RKF6sctXlDjuU51/0d4tSVCVijeGaII?=
 =?us-ascii?Q?TFrgdev2cQ67Yn8xrUPS7B5OBDqddhVIXblmfWgOnVvIDT/5fsMj2S11Bl70?=
 =?us-ascii?Q?XBD8h6t3p9gC5XvjLI1us6ZfAa9CxVi5zjMHmUI2UQ/N7d+2jZtPdabAPz7U?=
 =?us-ascii?Q?4emuCU8Jf76jOJ532PGEyxzOQlJeWbyq+WVPdZ5qYu79NLgIofunRm3i84hO?=
 =?us-ascii?Q?QfacKmx3LKckoebxEpFDcmeicO92r/U5/7yNhfBBOhbVeDFFgqcTfagaG4Pj?=
 =?us-ascii?Q?a9uOZaOyI2cWTCXLtUbM1fTm1373crPYzm2jSksIdlfkQqTfzamWednTXN5h?=
 =?us-ascii?Q?5KHWCye+ozTmNci/5TJldTvwJwea/EboDrG7kDIXtvpMPkOSi9Pwtzd/Mcjx?=
 =?us-ascii?Q?2YHtNFCJZuut6znCBeZBUFee/ycRw+rs/g93bifblAylkRUNm/VgMMVF4bCO?=
 =?us-ascii?Q?YlOilizCP1DM0M1Ota9ysrgz/7lpAcLduSPGYivxeuQJXHUYAsvc9Dbp77WC?=
 =?us-ascii?Q?T4NM+AGwgeZ2/dQ8ieDswY/bP/JuujNHkq6QA1YlOHAtlftiTg2stDMRzXnK?=
 =?us-ascii?Q?KY0xCrCesSSaZOsSdTTXV+q78CB2EWSK+lxPDukhqI/FRNDeoMu9F4BrAjgO?=
 =?us-ascii?Q?cTXdAEdBRtE8cw9BN6SZRDbbSNK51pXNRXca3cwuna04iyTk68/8ctaTRQ3+?=
 =?us-ascii?Q?qduaCgGOoBBhoM4En7CjzWt2OtTOi25cre/Oi3qCmE6zA33t2olMpTkQShE2?=
 =?us-ascii?Q?fGrHplohpqb9xru0YNRyqGrb8IdpnzFDZrU+7xGGDW58Lm/MqNf/6RGTOrtz?=
 =?us-ascii?Q?wrsiQu0H+DhJNO7OyMv3G3U6s5P0SlbjMmIzidHGFI5Y1DX8AUhSzVkSnHRE?=
 =?us-ascii?Q?NQyObEr/P03WnHUMdrpTfmvjcmnZY8PxARE3LPeZIWTA2SPA9wW+hDp9SG1X?=
 =?us-ascii?Q?gmuwMoFiQjTiLGAUau9H9aortCht6eGpFGfKUwyrOwAP1zuNBJ7eF8Fc5qKz?=
 =?us-ascii?Q?QH5sTNn5T/hFnGAT4rjTFvCj9iuCf60D5OuxCcRvU8F5WTa2Bjl1W2xOoQIb?=
 =?us-ascii?Q?ShReUXJ3pt5dZDfm+RVkpOG3uD4FEVeQ8OANafUp1RIo625PK4/wCc4mI4HZ?=
 =?us-ascii?Q?z34gww=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ac0220-c1c4-47ac-ebcb-08d9ca7a7d34
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 03:22:48.6951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPcTSYazJHH3wIjNXrjPA4cOcKnTUcSFge3UhTU7U5GpzPs3bwNwCLUr24ZjpYFH5L+c6THP78tZKhmfRxASzIYlPDZ3O98Hy0BdnLQOcUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB5521
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove references to lynx_pcs structures so drivers like the Felix DSA
can reference alternate PCS drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c                |  3 +--
 drivers/net/dsa/ocelot/felix.h                |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 20 +++++++++-------
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 22 +++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 12 ++++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  3 +--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 15 +++++++-----
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  4 ++--
 drivers/net/pcs/pcs-lynx.c                    | 24 +++++++++++++++----
 include/linux/pcs-lynx.h                      |  9 +++----
 10 files changed, 67 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f4fc403fbc1e..bb2a43070ea8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -21,7 +21,6 @@
 #include <linux/of_net.h>
 #include <linux/pci.h>
 #include <linux/of.h>
-#include <linux/pcs-lynx.h>
 #include <net/pkt_sched.h>
 #include <net/dsa.h>
 #include "felix.h"
@@ -832,7 +831,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (felix->pcs && felix->pcs[port])
-		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
+		phylink_set_pcs(dp->pl, felix->pcs[port]);
 }
 
 static void felix_phylink_mac_link_down(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 515bddc012c0..9395ac119d33 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -62,7 +62,7 @@ struct felix {
 	const struct felix_info		*info;
 	struct ocelot			ocelot;
 	struct mii_bus			*imdio;
-	struct lynx_pcs			**pcs;
+	struct phylink_pcs		**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 4ffd303c64ea..93ad1d65e212 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1039,7 +1039,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct lynx_pcs *),
+				  sizeof(struct phylink_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1088,8 +1088,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct phylink_pcs *phylink_pcs;
 		struct mdio_device *pcs;
-		struct lynx_pcs *lynx;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1101,13 +1101,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 		if (IS_ERR(pcs))
 			continue;
 
-		lynx = lynx_pcs_create(pcs);
-		if (!lynx) {
+		phylink_pcs = lynx_pcs_create(pcs);
+		if (!phylink_pcs) {
 			mdio_device_free(pcs);
 			continue;
 		}
 
-		felix->pcs[port] = lynx;
+		felix->pcs[port] = phylink_pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", port);
 	}
@@ -1121,13 +1121,15 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct lynx_pcs *pcs = felix->pcs[port];
+		struct phylink_pcs *phylink_pcs = felix->pcs[port];
+		struct mdio_device *mdio_device;
 
-		if (!pcs)
+		if (!phylink_pcs)
 			continue;
 
-		mdio_device_free(pcs->mdio);
-		lynx_pcs_destroy(pcs);
+		mdio_device = lynx_get_mdio_device(phylink_pcs);
+		mdio_device_free(mdio_device);
+		lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 }
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index e110550e3507..d34d0f737c16 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1012,7 +1012,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct phy_device *),
+				  sizeof(struct phylink_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1039,9 +1039,9 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
-		int addr = port + 4;
+		struct phylink_pcs *phylink_pcs;
 		struct mdio_device *pcs;
-		struct lynx_pcs *lynx;
+		int addr = port + 4;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1053,13 +1053,13 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 		if (IS_ERR(pcs))
 			continue;
 
-		lynx = lynx_pcs_create(pcs);
-		if (!lynx) {
+		phylink_pcs = lynx_pcs_create(pcs);
+		if (!phylink_pcs) {
 			mdio_device_free(pcs);
 			continue;
 		}
 
-		felix->pcs[port] = lynx;
+		felix->pcs[port] = phylink_pcs;
 
 		dev_info(dev, "Found PCS at internal MDIO address %d\n", addr);
 	}
@@ -1073,13 +1073,15 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct lynx_pcs *pcs = felix->pcs[port];
+		struct phylink_pcs *phylink_pcs = felix->pcs[port];
+		struct mdio_device *mdio_device;
 
-		if (!pcs)
+		if (!phylink_pcs)
 			continue;
 
-		mdio_device_free(pcs->mdio);
-		lynx_pcs_destroy(pcs);
+		mdio_device = lynx_get_mdio_device(phylink_pcs);
+		mdio_device_free(mdio_device);
+		lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index 34b2a73c347f..fa999996c597 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -204,11 +204,13 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 
 static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
 {
-	struct lynx_pcs *pcs = mac->pcs;
+	struct phylink_pcs *phylink_pcs = mac->pcs;
 
-	if (pcs) {
-		struct device *dev = &pcs->mdio->dev;
-		lynx_pcs_destroy(pcs);
+	if (phylink_pcs) {
+		struct mdio_device *mdio = lynx_get_mdio_device(phylink_pcs);
+		struct device *dev = &mdio->dev;
+
+		lynx_pcs_destroy(phylink_pcs);
 		put_device(dev);
 		mac->pcs = NULL;
 	}
@@ -292,7 +294,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
 	mac->phylink = phylink;
 
 	if (mac->pcs)
-		phylink_set_pcs(mac->phylink, &mac->pcs->pcs);
+		phylink_set_pcs(mac->phylink, mac->pcs);
 
 	err = phylink_fwnode_phy_connect(mac->phylink, dpmac_node, 0);
 	if (err) {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
index 7842cbb2207a..1331a8477fe4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h
@@ -7,7 +7,6 @@
 #include <linux/of_mdio.h>
 #include <linux/of_net.h>
 #include <linux/phylink.h>
-#include <linux/pcs-lynx.h>
 
 #include "dpmac.h"
 #include "dpmac-cmd.h"
@@ -23,7 +22,7 @@ struct dpaa2_mac {
 	struct phylink *phylink;
 	phy_interface_t if_mode;
 	enum dpmac_link_type if_link_type;
-	struct lynx_pcs *pcs;
+	struct phylink_pcs *pcs;
 	struct fwnode_handle *fw_node;
 };
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index fe6a544f37f0..38b285871249 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -828,7 +828,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 {
 	struct device *dev = &pf->si->pdev->dev;
 	struct enetc_mdio_priv *mdio_priv;
-	struct lynx_pcs *pcs_lynx;
+	struct phylink_pcs *phylink_pcs;
 	struct mdio_device *pcs;
 	struct mii_bus *bus;
 	int err;
@@ -860,8 +860,8 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 		goto unregister_mdiobus;
 	}
 
-	pcs_lynx = lynx_pcs_create(pcs);
-	if (!pcs_lynx) {
+	phylink_pcs = lynx_pcs_create(pcs);
+	if (!phylink_pcs) {
 		mdio_device_free(pcs);
 		err = -ENOMEM;
 		dev_err(dev, "cannot create lynx pcs (%d)\n", err);
@@ -869,7 +869,7 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 	}
 
 	pf->imdio = bus;
-	pf->pcs = pcs_lynx;
+	pf->pcs = phylink_pcs;
 
 	return 0;
 
@@ -882,8 +882,11 @@ static int enetc_imdio_create(struct enetc_pf *pf)
 
 static void enetc_imdio_remove(struct enetc_pf *pf)
 {
+	struct mdio_device *mdio_device;
+
 	if (pf->pcs) {
-		mdio_device_free(pf->pcs->mdio);
+		mdio_device = lynx_get_mdio_device(pf->pcs);
+		mdio_device_free(mdio_device);
 		lynx_pcs_destroy(pf->pcs);
 	}
 	if (pf->imdio) {
@@ -941,7 +944,7 @@ static void enetc_pl_mac_config(struct phylink_config *config,
 
 	priv = netdev_priv(pf->si->ndev);
 	if (pf->pcs)
-		phylink_set_pcs(priv->phylink, &pf->pcs->pcs);
+		phylink_set_pcs(priv->phylink, &pf->pcs);
 }
 
 static void enetc_force_rgmii_mac(struct enetc_hw *hw, int speed, int duplex)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.h b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
index 263946c51e37..c26bd66e4597 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.h
@@ -2,7 +2,7 @@
 /* Copyright 2017-2019 NXP */
 
 #include "enetc.h"
-#include <linux/pcs-lynx.h>
+#include <linux/phylink.h>
 
 #define ENETC_PF_NUM_RINGS	8
 
@@ -46,7 +46,7 @@ struct enetc_pf {
 
 	struct mii_bus *mdio; /* saved for cleanup */
 	struct mii_bus *imdio;
-	struct lynx_pcs *pcs;
+	struct phylink_pcs *pcs;
 
 	phy_interface_t if_mode;
 	struct phylink_config phylink_config;
diff --git a/drivers/net/pcs/pcs-lynx.c b/drivers/net/pcs/pcs-lynx.c
index af36cd647bf5..7ff7f86ad430 100644
--- a/drivers/net/pcs/pcs-lynx.c
+++ b/drivers/net/pcs/pcs-lynx.c
@@ -22,6 +22,11 @@
 #define IF_MODE_SPEED_MSK		GENMASK(3, 2)
 #define IF_MODE_HALF_DUPLEX		BIT(4)
 
+struct lynx_pcs {
+	struct phylink_pcs pcs;
+	struct mdio_device *mdio;
+};
+
 enum sgmii_speed {
 	SGMII_SPEED_10		= 0,
 	SGMII_SPEED_100		= 1,
@@ -30,6 +35,15 @@ enum sgmii_speed {
 };
 
 #define phylink_pcs_to_lynx(pl_pcs) container_of((pl_pcs), struct lynx_pcs, pcs)
+#define lynx_to_phylink_pcs(lynx) (&(lynx)->pcs)
+
+struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs)
+{
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	return lynx->mdio;
+}
+EXPORT_SYMBOL(lynx_get_mdio_device);
 
 static void lynx_pcs_get_state_usxgmii(struct mdio_device *pcs,
 				       struct phylink_link_state *state)
@@ -329,7 +343,7 @@ static const struct phylink_pcs_ops lynx_pcs_phylink_ops = {
 	.pcs_link_up = lynx_pcs_link_up,
 };
 
-struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
+struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio)
 {
 	struct lynx_pcs *lynx_pcs;
 
@@ -341,13 +355,15 @@ struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
 	lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
 	lynx_pcs->pcs.poll = true;
 
-	return lynx_pcs;
+	return lynx_to_phylink_pcs(lynx_pcs);
 }
 EXPORT_SYMBOL(lynx_pcs_create);
 
-void lynx_pcs_destroy(struct lynx_pcs *pcs)
+void lynx_pcs_destroy(struct phylink_pcs *pcs)
 {
-	kfree(pcs);
+	struct lynx_pcs *lynx = phylink_pcs_to_lynx(pcs);
+
+	kfree(lynx);
 }
 EXPORT_SYMBOL(lynx_pcs_destroy);
 
diff --git a/include/linux/pcs-lynx.h b/include/linux/pcs-lynx.h
index a6440d6ebe95..5712cc2ce775 100644
--- a/include/linux/pcs-lynx.h
+++ b/include/linux/pcs-lynx.h
@@ -9,13 +9,10 @@
 #include <linux/mdio.h>
 #include <linux/phylink.h>
 
-struct lynx_pcs {
-	struct phylink_pcs pcs;
-	struct mdio_device *mdio;
-};
+struct mdio_device *lynx_get_mdio_device(struct phylink_pcs *pcs);
 
-struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio);
+struct phylink_pcs *lynx_pcs_create(struct mdio_device *mdio);
 
-void lynx_pcs_destroy(struct lynx_pcs *pcs);
+void lynx_pcs_destroy(struct phylink_pcs *pcs);
 
 #endif /* __LINUX_PCS_LYNX_H */
-- 
2.25.1

