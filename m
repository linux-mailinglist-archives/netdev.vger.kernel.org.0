Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CC8452AF3
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 07:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbhKPGcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 01:32:39 -0500
Received: from mail-bn8nam12on2139.outbound.protection.outlook.com ([40.107.237.139]:7392
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231418AbhKPGaW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 01:30:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PzrnZOaU5hNqpD2rtlXM59+6Kx3HJscCsJ5gEZ9CGiMpEGh+Vm+2NmJsBsmid6SGVHF5yWGljvFE9I8Odigh3O9LzR0/SmxpYKXJajkWK3Yh8TYDApjnSGMfwXxg2moGmHyxjK78/oUIDt9+j4FUhBWD76kaPtvi6fkkIfvXQ52XNq9CTZd8y4tol/LlIKVHNSGfMotIOR5xYqSaIoqjSCvTFj9WRsUcotqiAYRjm6BL464WgO9h5yl96xT6PvTMvwnGyRnUQjwziU2H2XQevCqGrE7+vNUswsMJlf33FG+Hgjd4/kenKZzdpun4Zcfr83OJb2LmELyDv3JnKwLLuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cszZkPnV4BadsDimOTuz9pvDojt7sQB7K03sDa1qf9c=;
 b=kZ/StDtCL1oFZ0fL1Hi0g1ezfJ0iJ07WEf0TnWDPO7qcRtdQCsIYgVD6b1k7taQswiGgqbe//Tj8bVYL7hteskkOUhIjKvMJH8tHK4z6coOw8e03WSDwJbc5eSUJhy/O+psyd4UjS3sOgzRUDAHzniiczd4ts91JQMpchcK0+iVOWxRPKQWfOLtkEzyg/8tKrx79aYMqjalskoJXMkLnMfIz76jjX/VkZk1kz8H1cjiPexOqc9S9yWQTU7V5Fuohcu3tV7jS7Eq6VdOdNLWBoPZvCXKapi+uZE6Dhr4Wi1FgtZ6kKWyoe9hL/Cx7KITPDGHDjy+aT18KSs1j+bnI+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cszZkPnV4BadsDimOTuz9pvDojt7sQB7K03sDa1qf9c=;
 b=r8yP0B5xVQEcZ2XqfB5OcbQ43WwDUKNcNUpg2A1mhZ+ZwppzIRtUgZkKedptn6OQ2lSGyuaJCDmRUBUMeseAud0/KZ+MeyMDxRcEBpGL2zQwLs3FutoEKyoA+6Y/xGHFXaBuEpEev4aJeg4zHHT0Ls+tUvaoHtUCXWqIhGta4Wg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Tue, 16 Nov
 2021 06:23:56 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4690.026; Tue, 16 Nov 2021
 06:23:56 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [RFC PATCH v4 net-next 18/23] net: phy: lynx: refactor Lynx PCS module to use generic phylink_pcs
Date:   Mon, 15 Nov 2021 22:23:23 -0800
Message-Id: <20211116062328.1949151-19-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116062328.1949151-1-colin.foster@in-advantage.com>
References: <20211116062328.1949151-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0028.namprd11.prod.outlook.com
 (2603:10b6:300:115::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0028.namprd11.prod.outlook.com (2603:10b6:300:115::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Tue, 16 Nov 2021 06:23:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea90379c-4735-4bf9-c686-08d9a8c9ab2d
X-MS-TrafficTypeDiagnostic: CO1PR10MB4722:
X-Microsoft-Antispam-PRVS: <CO1PR10MB4722B19E62A74C780798D31EA4999@CO1PR10MB4722.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:172;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgVnsjYQm2qvciJ8Ll9UgkPH+hoSe71Ub+fAbIs89dIVC7xk6N3v+IMwiOrLNcfuXt9W7YNQdOoVUXHZD0o4/zVLrPVIfJ0U01Spi535/TVyrUsJllFhqjw9cXAa33xJWDPHejJPtc6rKExePKsa0vtvUHU+IPhW24fjn6zesFjADWpXu5izVVOLZrIvfstaXC5rS0Kui5ukIFFJklD1xcHMttNexRsOCp46JRFXiP8zk51pVT5/y9FaUom6TkgO/D4uh943KrdMqAe3u+ZZYUDDTa9bwO1EvQcsgRgMSlmOxER2dd9hLVpt0aFZoGX/OHFrQu2XzGHX+bay/sI3vlhQyskO5hpmmTnmYwKX/kfhlKIMb+irXIDMuNjvfMcJI7dv2+0oyqAMqOoGtzaachK44cS7PW+6zWS3fAHAwcZEi61XheKpZJVBAdQXnyUed7pqA5T6KAR4fkfUyArHyrnK3oxIrM6ev6+ClFf/ggM7j3b91HeVK/mFThhhoAtvzhNzL9AE7ELZdQ6J0mM6YUdndfYkNZP8dqg+VZpBBDdnG6aacn7TeSe2n12G4rBHZHcNDJaWjIW8Ci8eOJhASVT44ETo7yoiZWfcxYs2/KKOcF3t+OnsSaSQsY+1G4jgpxMw5DXi5ximVd5QoZ+YO5XQc3Y5hvBzxGOtLlWcIQJPlOkI+6lV5VhY6gF99pK7A5hdGhphsf8XNO0uobzFGyNBaLDL//DQNINXyltJuqw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(83380400001)(6666004)(54906003)(5660300002)(2906002)(7416002)(6486002)(44832011)(956004)(86362001)(2616005)(4326008)(316002)(508600001)(8676002)(186003)(6512007)(38100700002)(38350700002)(1076003)(8936002)(52116002)(26005)(6506007)(36756003)(30864003)(66556008)(66476007)(66946007)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?97UCiMozJxe3oZ7/bxeHBPtmW9gFIhWGyfNC/8SQUDXTCFkDoqer+d66NTgY?=
 =?us-ascii?Q?FF5no2MU7i0rfgndj8Wektchh340lYDPf872lxFXGldQtt6CPPXQMwLgaV0C?=
 =?us-ascii?Q?lfqqQSCLUkYRNTnAjUey7nVdoYKIU0zUk+m0fMGIIMbnKI96gSqn6PlV83FY?=
 =?us-ascii?Q?0mpvlvPRZm2Xt6CusgThxD+g0b0OiVgDzPGUZPaoCZXpqW335rW6FDoDNU6a?=
 =?us-ascii?Q?kCznKHnwdHXv75ZkuwmV6vZ+kwzruZhTBfno3mxMACVv7n7GKft9YloJowZA?=
 =?us-ascii?Q?P+eD91x3Ub7+zUQvvgmGIQS1Drq8xUWK5rNoWL9SZNKE0oOcsngeuSVgGs0r?=
 =?us-ascii?Q?bnDQll8Yz9tFhGoJkSOzW4eO5EkjUmapdGDusek/oLl3AfPNu7uuhwHesC22?=
 =?us-ascii?Q?cFCTx3BAvI6XErk9qK6hLXBTiaMoTjs2FXDC4cEwOWTFwi19rDIYvtjVW4Yy?=
 =?us-ascii?Q?Xq/vmOtr4LbMUVxre1GrICVDxrxu3OYCUVGxKdXYzHvWE9UgUlWZF9a8y9kj?=
 =?us-ascii?Q?avsP9/jSfpjpSElepB6IUZVgmbMjM6H5CM9wzKXc1TZ3TLdZXJ8aGrNodO43?=
 =?us-ascii?Q?LoplG0WEDeF3MMMzLcAtcoi+O9Kih1z7ihDiEGHKdPljbc9TkZ6DBWltgeMp?=
 =?us-ascii?Q?EG+gUgdB8X9LQ4Q1m539MTXwip/OlDZsaXk1b/UirRQJjcp4cwIHaswiIJyp?=
 =?us-ascii?Q?+ts/g7zXAZW5EeUzrhkUXNYdGLSbQFjfmii4VTBZNleaUFckzthWug47pLpi?=
 =?us-ascii?Q?73/OyJtEUMw8b7HfX0L2qyHt2KFbbCuEPSDUcfLtmR7Y8DeG/6b/+PFwXgMk?=
 =?us-ascii?Q?3T/FvjsuMzuOgJ7s6CsFPXz2AjOgG76BA3IHfy80NX+X1B278LNNpnryHaup?=
 =?us-ascii?Q?+ZtCs0XVH98AW+/Na2Wg8bryaQ5xdDoJwbSZPaVotUNmcg7ax4RJLrOE00xf?=
 =?us-ascii?Q?kDMgjPRLIcezpcMA5mZpagP1lVITEiQpAezg+56PlVtVQTuH0EYiN80kcd44?=
 =?us-ascii?Q?NLrEsTB50pPW3d05k43BxQpzgNdSSjtVCxY0QC1sohNqK4kNb4RYCCdagYRL?=
 =?us-ascii?Q?XCATibO+V2CX0p+j7kVGhMz0onLBXnncrSGHjD5SjJTyiypdTrSwAygXbs06?=
 =?us-ascii?Q?Hqh6AtUZJd38f6keXhrGP0AvGfHQQnPpXcpv0eTmoyjQGdcFQgOGKzJya7nU?=
 =?us-ascii?Q?iiDQSe/tUIQQDzZ/Pah8JM0UcxbbkPZP/C6cGkYyoLb4AyPB35ZN2bA94ZG8?=
 =?us-ascii?Q?A76alSHlifhkvFU9c58w6AbLCdmJscQgy99CKgFtrxqjLrVQ+NUW6kg+4SVK?=
 =?us-ascii?Q?PX3VzFYt8itZqH19jD5Gw6quUOD9itkMEeeQ3ur/twXm4K1bK0tiP+HnJG6L?=
 =?us-ascii?Q?63DVwyQ5nzEZkZs0EWMbBpCJ1HHbFjlPJc8Zmw7YptCsuN1pOq44wbNfo/wH?=
 =?us-ascii?Q?bTgX3Ga9xv94M27l+wyMjs2Vyu8yvhYokrcZO+7GXTNhT20BIfmQzQs4mfZ2?=
 =?us-ascii?Q?/3Jbfd+upCJoR9Pr/kjqb0pW3ohIBjV+R7K6O+gBYoRcdKyqba1AMoB8tNO+?=
 =?us-ascii?Q?N4ratt5k6WFJR8MJBI1sSNSAVCkEIQua7Z0DYDpkkYDJdJIWsjDiq9s9gX43?=
 =?us-ascii?Q?ODHcdL9EqSx8ufboRpzBbEsH7w4jrh5wueyDNwrmilk3tUTCm8o41uBWYNwI?=
 =?us-ascii?Q?Vjq0huz8Yydu++I28XV/JSdhJSY=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea90379c-4735-4bf9-c686-08d9a8c9ab2d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 06:23:56.5891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QAQJSB8+ltJAFUItlgtCJtaaVLX8hr+a+t83zbLQyQoTqg4EU+NuKmbC3FVTY1oY/F45kcsJN/hFXbF8Oij/gkMUgjzVM1/s253rYuRZaas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4722
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove references to lynx_pcs structures so drivers like the Felix DSA
can reference alternate PCS drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c                |  3 +--
 drivers/net/dsa/ocelot/felix.h                |  2 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 18 +++++++-------
 drivers/net/dsa/ocelot/seville_vsc9953.c      | 22 +++++++++--------
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 12 ++++++----
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.h  |  3 +--
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 15 +++++++-----
 .../net/ethernet/freescale/enetc/enetc_pf.h   |  4 ++--
 drivers/net/pcs/pcs-lynx.c                    | 24 +++++++++++++++----
 include/linux/pcs-lynx.h                      |  9 +++----
 10 files changed, 65 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index f53db233148d..6d27c29a9c7b 100644
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
@@ -821,7 +820,7 @@ static void felix_phylink_mac_config(struct dsa_switch *ds, int port,
 	struct dsa_port *dp = dsa_to_port(ds, port);
 
 	if (felix->pcs && felix->pcs[port])
-		phylink_set_pcs(dp->pl, &felix->pcs[port]->pcs);
+		phylink_set_pcs(dp->pl, felix->pcs[port]);
 }
 
 unsigned long felix_quirks_have_rate_adaptation(struct ocelot *ocelot,
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index b5fa5b7325b1..f3f606fbd88d 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -59,7 +59,7 @@ struct felix {
 	const struct felix_info		*info;
 	struct ocelot			ocelot;
 	struct mii_bus			*imdio;
-	struct lynx_pcs			**pcs;
+	struct phylink_pcs		**pcs;
 	resource_size_t			switch_base;
 	resource_size_t			imdio_base;
 	enum dsa_tag_protocol		tag_proto;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 5056f39dc47e..636bfb096c66 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1044,7 +1044,7 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct lynx_pcs *),
+				  sizeof(struct phylink_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1093,8 +1093,8 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
+		struct phylink_pcs *phylink_pcs;
 		struct mdio_device *pcs;
-		struct lynx_pcs *lynx;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1106,13 +1106,13 @@ static int vsc9959_mdio_bus_alloc(struct ocelot *ocelot)
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
@@ -1126,13 +1126,13 @@ static void vsc9959_mdio_bus_free(struct ocelot *ocelot)
 	int port;
 
 	for (port = 0; port < ocelot->num_phys_ports; port++) {
-		struct lynx_pcs *pcs = felix->pcs[port];
+		struct phylink_pcs *phylink_pcs = felix->pcs[port];
 
-		if (!pcs)
+		if (!phylink_pcs)
 			continue;
 
-		mdio_device_free(pcs->mdio);
-		lynx_pcs_destroy(pcs);
+		mdio_device_free(phylink_pcs->mdio);
+		lynx_pcs_destroy(phylink_pcs);
 	}
 	mdiobus_unregister(felix->imdio);
 }
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 362ba66401d8..49fc8220d636 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1005,7 +1005,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	int rc;
 
 	felix->pcs = devm_kcalloc(dev, felix->info->num_ports,
-				  sizeof(struct phy_device *),
+				  sizeof(struct phylink_pcs *),
 				  GFP_KERNEL);
 	if (!felix->pcs) {
 		dev_err(dev, "failed to allocate array for PCS PHYs\n");
@@ -1026,9 +1026,9 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 
 	for (port = 0; port < felix->info->num_ports; port++) {
 		struct ocelot_port *ocelot_port = ocelot->ports[port];
-		int addr = port + 4;
+		struct phylink_pcs *phylink_pcs;
 		struct mdio_device *pcs;
-		struct lynx_pcs *lynx;
+		int addr = port + 4;
 
 		if (dsa_is_unused_port(felix->ds, port))
 			continue;
@@ -1040,13 +1040,13 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
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
@@ -1060,13 +1060,15 @@ static void vsc9953_mdio_bus_free(struct ocelot *ocelot)
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
+		mdio_device = lynx_pcs_get_mdio(phylink_pcs);
+		mdio_device_free(mdio_device);
+		lynx_pcs_destroy(phylink_pcs);
 	}
 	felix_mdio_bus_free(ocelot);
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index ef8f0a055024..e5fa181fbe2e 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -286,11 +286,13 @@ static int dpaa2_pcs_create(struct dpaa2_mac *mac,
 
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
@@ -349,7 +351,7 @@ int dpaa2_mac_connect(struct dpaa2_mac *mac)
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
index 0e87c7043b77..125a539b0654 100644
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
@@ -980,7 +983,7 @@ static void enetc_pl_mac_config(struct phylink_config *config,
 
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

