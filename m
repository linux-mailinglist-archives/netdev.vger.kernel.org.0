Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75C325E59F2
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbiIVEDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiIVECt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:02:49 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2093.outbound.protection.outlook.com [40.107.94.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4690AEDB8;
        Wed, 21 Sep 2022 21:01:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1/OhebMpCuISDkj+VXDC0Yld+6kJWNVlIgTbbKNwdYTriowTvSmLLLIndoa80UQxzMXI6PSvrkkvD34hr8hwLVDZ7YOCHwKVNEu8plwehkXClS/L3yK1xxjYXsYDzZ4WSVARn3PY8C6BnZeX8wJWZ2Akz/E5nCxnTFnJWwlXyDwWllEVthWIEi29GsXJBCxkqsQnqrZw9hhoEyGXOZySssF1cFUWqN8j2GoopgtB9L9TI/VIW73Qro87l7p1+Jnn8tgOrUiVHk13tW9RtKwZFYX4/cyul/mSb7qNAhQEWRc7zcK+6d1bpzQkDRqYLAA0KUF23MI1Fv90aJFBlPmuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ge0/0bsnUSNKMHWoEvOOtlwjEquTDRXoESOzy4fmmgI=;
 b=UK0QOFqgeNBBb+zVN098EXGRMdd4KRVH2X6AI//94IwO5lLZNa0AKTNzaiYZ7dbHZ6UbqiRSHkCwiTvOz/8rNbs4YQkm4MUznhLDtmAzV411ThTSdkLpyqHb3Xd1b68TKIQsLO4pwgHpIWM1R/tAgsHrnRFLfqnhfROneKi37hW1Ea324WgQaryEO1F6y8ctlzWbta5XhQ+tb2JinIqTfAr2ASoAwZ88yGG9FmCygXP05Fg2eiESS92935T0F08jD7PgX3veRUE5S+nv8vhQmt3ktObbiNRfozCcw1mYL3/leyq9knaPAoxfdLs6x7HqQRo+8J94ehooMzSn4HZ14Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ge0/0bsnUSNKMHWoEvOOtlwjEquTDRXoESOzy4fmmgI=;
 b=0czX5LPIH7vZvO9vcvouYdrhN8D+uYMVdJAdpWsSNVTGL+G4TEF4XrlxFpfE5mxyxQQezYemJJHa4SyY8Sh3J7kLGK5HaN3TLE72DijEaXNM+9tvAm9iN0oh/kDMQTUdvC8Tk8aSMaPOdvaz7W+Oyxke8QPXdAgtageAA0VXyjo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by BN0PR10MB5158.namprd10.prod.outlook.com (2603:10b6:408:120::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.17; Thu, 22 Sep
 2022 04:01:30 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:30 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 08/14] net: dsa: felix: update init_regmap to be string-based
Date:   Wed, 21 Sep 2022 21:00:56 -0700
Message-Id: <20220922040102.1554459-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|BN0PR10MB5158:EE_
X-MS-Office365-Filtering-Correlation-Id: 6232379b-aa2d-46bb-b86a-08da9c4f21a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TbGnAdbHEjunIkSvhx/s/Zv2OqAattxYcuC0SvsyQYk9rlu9VHY6HpsbdC9nTxJMpq4FjKCN/X2DyaKi4ydy7W5WAhtqj6sWBcw3LLRBT98affu3AfmxYtbXNsFRmVdjqTMvX7Rd8bHKAmkPYyK+yDREYQMALYQWVBgSRmjo4xbipWSkCQSvScxvwBNJGxBgyJLqCV2lZxXYG7rk4icvkt2O82/8IXGCDR+jJGDjXeDMudNPs5dR5yfnoYjPxxLbKweSkdpNNxy3xmPUQIRtBsHp5drdtz8bUrBgJocnvID+N4pCtfYSdlUtWDHqJ3KZYarb7lkSECrhNxWD5kQUXddLWb4tqVB1jw0hIkBEGdofO2fp+gfnqNR3jS2kfh5tmUBVEJi3J7yBFZ3vppPg5ygganuaVaevxYC82iQykPkOnC23iIXXn8tQcyy86Ig2k6o8xh8+sw5B+J51vjDaWdDNGe1cpi741wgyPTSlCbN0S2bCqeCh1HJp4Vyo1pSTRE0lxajxnYN/ISkXMdNus7KRhgeBV9p9RIhVKltWENV6Jv0CaDTI2PgHXzu5qQwIza5pAMb6ovm74nPFgQ+bjH8eEfYB7ffJ9uKQvGWGCq1+NFJA/uB8LRM2qElz1+2Ppvv2yTnSw/4xXlbBoIkXupfP2nQ7ZfgeHVkveNwx3OeHuMHmR+U/VbTT3V9zxJ0mKRRWQVfFDxj48xh4eokdAm/6+Q9xwB20G69p3MV/SLx1HjHqoDOH1ia6QoyNi2+HIsfIZlPYEFe0YqYiGCjbVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39840400004)(366004)(136003)(346002)(451199015)(6666004)(36756003)(41300700001)(8936002)(44832011)(26005)(6512007)(7416002)(6506007)(5660300002)(316002)(478600001)(54906003)(6486002)(38100700002)(8676002)(66476007)(66556008)(38350700002)(4326008)(66946007)(83380400001)(52116002)(1076003)(186003)(2616005)(86362001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OFKnAXYWMrm+esq1YRXSKzHoPVUfgp8RL8DLGGH9zrYikdxubuaWZCbEiYhd?=
 =?us-ascii?Q?xf2NC75tESdb2Gn4D0V6T+M8enAXuzXM3mwyhuHYnGO/sz0hXezaLgSnfRY/?=
 =?us-ascii?Q?mU59VFGvYOKi8y6bp3BoShSPdGpvxRddxLiZWNBNvlAqw7/kYzv5yJeCKjN7?=
 =?us-ascii?Q?ZbDxoXmHJGFTYd85fmo2gFUibAW05YSvJo6Ka8O21jaCcJdCVX9jDs1piOWP?=
 =?us-ascii?Q?iEPXwPdVJeXBYQIvQ0KFldksuT1lSDfO/3xUuyRpM2BIX/JKb/fucL5UvpYC?=
 =?us-ascii?Q?8iXe2yV1LOKy91o4NyG1VZNaP1zuI3eKxTVQy28OfbGUZmM6c47FN9uUDbgp?=
 =?us-ascii?Q?JckGoa8b/aludlvtmjo4RszNjrR4LC5tgpzZwM8IF3J1CtmDaxSfMYispg/X?=
 =?us-ascii?Q?sX09TTUfx2/u3OYaTjBJt4bx0zr5eaoUXxnjIobyh8Okpae9MKlVwFmCU8Yt?=
 =?us-ascii?Q?UpJBs4kbeScSb87oJ7kfCBz8+6MpXlL341XbcB7kQGpTtMLN/pREUKT360QW?=
 =?us-ascii?Q?GM3YStEsyI3BZuwo7LQ6Bpd2JQv7UbFGBHfyCr3npl4tUB55jHd+YjW/3se6?=
 =?us-ascii?Q?T6UHa4eGM85vr3FzOmmFFmaihKDzbBuTr0fgeQImZuD6xF/pTjaM8pyxyWcX?=
 =?us-ascii?Q?JeFv5EbSN3COvC5793JEUyXVD6K++wWxBz1jZF2egZ+OxaLAgd2FzKYI92FC?=
 =?us-ascii?Q?quzD9TA8egOXzK3L0gbgwTm8Nx5tgPGlRYEojg+lyEgVbqSbU1tXgjRs3ob8?=
 =?us-ascii?Q?gALona4yGW6WIX1r8FN7FTcxgPH160P7ljIprsOh3JB6FSau/JFRt6JaHm91?=
 =?us-ascii?Q?WbBdpNMaqb1dUm3GqIHeVaensCruBFrsRH+vijAVyI5NW4EuXDEsR6WacSrc?=
 =?us-ascii?Q?phYjyfot4JmB9xfkUmx0DRf15jFdKXSlpWCs5cHV5J/s7hJY3dUL9S74Glt2?=
 =?us-ascii?Q?BJrXJHJ1WjLTa9SOFa0w7xWcNw5eoycSMxB51jTDypVVpXJru8QuVNMrum7H?=
 =?us-ascii?Q?urYFppPZptwtr3/yyqy07S1WbYRWW2AUATInamrXeudAOAdYzYvnIoKP9KHL?=
 =?us-ascii?Q?weuYN9vzAsxf4Ta1ZdzBZXtMFtRHl5py6yld+DlRFfDGESvVQq4PW+oOqlIL?=
 =?us-ascii?Q?/FlIIV2hVo5M//WcwCSOU2cR3ACGzHjEvK2lhm+6+r7M8wMdvPI6ZckU+8/S?=
 =?us-ascii?Q?C5hE2ekcJibG9bLscq2Qgn1m8zj/398K50RVnab0IevG7ywOje5RmayQzj6w?=
 =?us-ascii?Q?M/SNYe3n/CCau1petQiDwBd5zWQXTPSWEIM+CKbXV4HoLAiEscXvvDksUMAJ?=
 =?us-ascii?Q?KIdtMSodjFR5lvFdOsOob1dXB1N0QxOwq81k6LbIzgEtLfzVJPXbzpwPvjPA?=
 =?us-ascii?Q?bZFbc2TuLnOsEWHZSq4anIcCiIDWByU3aDO+sWJi1wMYy7BplQAVK4ru9Myn?=
 =?us-ascii?Q?szOkbeWaD9/cmg1H5FAZqFU59R0FPEe7IWu4d/Yrdy+SqUwv2fOQuI7myT97?=
 =?us-ascii?Q?3qBL5cWBF+DXQANoL59nfQwgjFtCzfRdI7+PkGKyNw1/6/suARca6j8xPglA?=
 =?us-ascii?Q?2sYDtz0dWG0UAXtGvTp+DuPKi7d6LCJyiQBW9rWbz0aALuOTedO04rB2pxn2?=
 =?us-ascii?Q?Jg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6232379b-aa2d-46bb-b86a-08da9c4f21a9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:30.8873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFXSy147e5ebhJ50DnLJeDaMKuhI1sQvLBVLx0jACbiCsJ7li5wxM1Gpx+EM/OQC+I5trWV/ILOi48VZp6ZxVqs5ciDOBNKQ5y9zLZZncAc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5158
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During development, it was believed that a wrapper for ocelot_regmap_init()
would be sufficient for the felix driver to work in non-mmio scenarios.
This was merged in during commit 242bd0c10bbd ("net: dsa: ocelot: felix:
add interface for custom regmaps")

As the external ocelot DSA driver grew closer to an acceptable state, it
was realized that most of the parameters that were passed in from struct
resource *res were useless and ignored. This is due to the fact that the
external ocelot DSA driver utilizes dev_get_regmap(dev, resource->name).

Instead of simply ignoring those parameters, refactor the API to only
require the name as an argument. MMIO scenarios this will reconstruct the
struct resource before calling ocelot_regmap_init(ocelot, resource). MFD
scenarios need only call dev_get_regmap(dev, name).

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * New patch

---
 drivers/net/dsa/ocelot/felix.c           | 59 ++++++++++++++++++------
 drivers/net/dsa/ocelot/felix.h           |  4 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c   |  2 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c |  2 +-
 4 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index a8196cdedcc5..d600a14872e3 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1318,11 +1318,49 @@ static int felix_parse_dt(struct felix *felix, phy_interface_t *port_phy_modes)
 	return err;
 }
 
+struct regmap *felix_init_regmap(struct ocelot *ocelot, const char *name)
+{
+	struct felix *felix = ocelot_to_felix(ocelot);
+	const struct resource *match;
+	struct resource res;
+	int i;
+
+	for (i = 0; i < TARGET_MAX; i++) {
+		if (!felix->info->target_io_res[i].name)
+			continue;
+
+		if (!strcmp(name, felix->info->target_io_res[i].name)) {
+			match = &felix->info->target_io_res[i];
+			break;
+		}
+	}
+
+	if (!match) {
+		for (i = 0; i < ocelot->num_phys_ports; i++) {
+			if (!strcmp(name, felix->info->port_io_res[i].name)) {
+				match = &felix->info->port_io_res[i];
+				break;
+			}
+		}
+	}
+
+	if (!match)
+		return ERR_PTR(-EINVAL);
+
+	memcpy(&res, match, sizeof(res));
+	res.flags = IORESOURCE_MEM;
+	res.start += felix->switch_base;
+	res.end += felix->switch_base;
+
+	return ocelot_regmap_init(ocelot, &res);
+}
+EXPORT_SYMBOL(felix_init_regmap);
+
 static int felix_init_structs(struct felix *felix, int num_phys_ports)
 {
 	struct ocelot *ocelot = &felix->ocelot;
 	phy_interface_t *port_phy_modes;
-	struct resource res;
+	const char *name;
 	int port, i, err;
 
 	ocelot->num_phys_ports = num_phys_ports;
@@ -1358,15 +1396,12 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	for (i = 0; i < TARGET_MAX; i++) {
 		struct regmap *target;
 
-		if (!felix->info->target_io_res[i].name)
-			continue;
+		name = felix->info->target_io_res[i].name;
 
-		memcpy(&res, &felix->info->target_io_res[i], sizeof(res));
-		res.flags = IORESOURCE_MEM;
-		res.start += felix->switch_base;
-		res.end += felix->switch_base;
+		if (!name)
+			continue;
 
-		target = felix->info->init_regmap(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, name);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1398,12 +1433,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			return -ENOMEM;
 		}
 
-		memcpy(&res, &felix->info->port_io_res[port], sizeof(res));
-		res.flags = IORESOURCE_MEM;
-		res.start += felix->switch_base;
-		res.end += felix->switch_base;
-
-		target = felix->info->init_regmap(ocelot, &res);
+		name = felix->info->port_io_res[port].name;
+		target = felix->info->init_regmap(ocelot, name);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index f94a445c2542..e623806eb8ee 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -57,8 +57,7 @@ struct felix_info {
 	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
-	struct regmap *(*init_regmap)(struct ocelot *ocelot,
-				      struct resource *res);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot, const char *name);
 };
 
 /* Methods for initializing the hardware resources specific to a tagging
@@ -97,5 +96,6 @@ struct felix {
 
 struct net_device *felix_port_to_netdev(struct ocelot *ocelot, int port);
 int felix_netdev_to_port(struct net_device *dev);
+struct regmap *felix_init_regmap(struct ocelot *ocelot, const char *name);
 
 #endif
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 4adb109c2e77..87a38a57613c 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2615,7 +2615,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
 	.tas_guard_bands_update	= vsc9959_tas_guard_bands_update,
-	.init_regmap		= ocelot_regmap_init,
+	.init_regmap		= felix_init_regmap,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index ba71e5fa5921..a66bd35ce4ee 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1079,7 +1079,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.port_modes		= vsc9953_port_modes,
-	.init_regmap		= ocelot_regmap_init,
+	.init_regmap		= felix_init_regmap,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1

