Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7BC3C3667
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 21:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhGJT3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 15:29:25 -0400
Received: from mail-bn7nam10on2107.outbound.protection.outlook.com ([40.107.92.107]:9249
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231183AbhGJT3L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 15:29:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4wVgXL1KlZ07jRT9UH6yTpgx1PffDWX9HbpB9eHkPoB/2tKce9tXOfPStm2sjAVX15tHL47uWvq0qez7aBOmWqsn25pk1HKlPk4OYq6kmh3rheHSy+61M71uAo5QSzQsjwsyfaBQ9hfv/c5jawq/A5+niKfUgSlO3Pcr4kYvO1oNBwlq8rXMcvDZvv+1f7uHKEwNJocUxmoyckTvT+CynTFzc4rBbWVuMOWqiMRlqBlFmLmputbH17xOFQJYTAQXb49XEvh4AapVZeKN+aSPNQAR3oAZCUuOoMGslWNZ8PozJEE6Gl1MdfRn73fzHqNcig7UU7IBMlH43silpCb1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haGDF6utMR0NRHVAWsXQLK3t+CT5JeyKOm5VYtRbnAE=;
 b=mNisK6c/DwuhkOedPnZ+SeTKn17dw0ZLNlojgStjvdt9llKjr4V7T888GRkzIXbEtKfx1k2BidBFRyvjV9GniNttwGNJYllIA2RsAGSL1YWelJVtMmVDMVnVW2Yf51XFks96WkALcbw4a3h1toYCkQ0MwiBr3eTTw20Z9SeENVvs49yYZeSlK/Uzn7sv8uJgvMf3tAGNoAMkjTX99OMNHgGXQC6tzQWUmRltYeqlCZYvF/4ZuQqvHWfmfgMAMt/BRFWYAyWsdRr9Zgs96DzHaXVJ0H0UqACmkXYS7fNN68Z+PnHODVEymqmboC4qAo9tKQGUdg5Y5vOxbARgH3Vxfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=haGDF6utMR0NRHVAWsXQLK3t+CT5JeyKOm5VYtRbnAE=;
 b=dThMGPppGECX6TmerjQYM+qVHLx4Wh/kJamGXym4kWib5GxEnt+myAclNLrV0pggAYpWxu0KbavqcbwVM1Rejaap0mVcj+YGc4eqGxb+msskkKsoaGzTPUeqAkJdc9a0+pL2JdnU9xoh/6R0TotVmZBxxpNeL20per8MZoECoEg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB1709.namprd10.prod.outlook.com
 (2603:10b6:301:7::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Sat, 10 Jul
 2021 19:26:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4287.033; Sat, 10 Jul 2021
 19:26:19 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 net-next 4/8] net: dsa: ocelot: felix: add interface for custom regmaps
Date:   Sat, 10 Jul 2021 12:25:58 -0700
Message-Id: <20210710192602.2186370-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210710192602.2186370-1-colin.foster@in-advantage.com>
References: <20210710192602.2186370-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR12CA0042.namprd12.prod.outlook.com
 (2603:10b6:301:2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MWHPR12CA0042.namprd12.prod.outlook.com (2603:10b6:301:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Sat, 10 Jul 2021 19:26:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82d10a0d-03bb-4738-b081-08d943d897c9
X-MS-TrafficTypeDiagnostic: MWHPR10MB1709:
X-Microsoft-Antispam-PRVS: <MWHPR10MB1709900EDA8C98B601B1D17DA4179@MWHPR10MB1709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iL6qJizkdoCgJ4uryOfk/iGMz8UuWb+6sL22Jri/sWQPwGn9mWDr5Ev6i8m5jwH4nX6J4PNXfRsNqWo4ruiegxr0d9Rw9yWmuPfZstLUOEcNCY3TyeMVUxjwPooGZk3RfiShOIK9gAzps+9wH2HKJoFUD0wEi95RziEq/l5gwHSZ7gfQUTSiz0Q+n+2zEHm2lqtn6sMCaS5q349KvJJ0FnQdcvklApQvV95G9UjphuVC95A/QbslWWrZiCYJmpP+kD1snmwxMWmvDUzULiaE6S/JSZqw/PSzkZEL0gx6hWgxFU4Yicg2YHX3+nrG/5jYRB/00/R3yM7pNf9cQqsDUuyInrfiVotfoOPKTTUMlsO6c1V8Jf+OaX6TG1ZgCEr/+8lh2hUCKcaLKY4T/ssNNukHNWahKvTIq1PVLGKAew01e0cYhktFsVjer5Yk1NEWyWsFN/jfg4Q7+en9taxaRb1QG6XgXnv1OOOszSxopFXTD6K3mdtEqt3XbaHsD+JM4ITE32Xe4rU+hw6LcXLkpQ09jR8HJyzlUaKtbJF2IVxM5YEPqAfUr9dHIzPB0CKLthogB4RIzVN1uUQ0HU767JV+oKLIQEcCdxdqyySElJMCn84MtFm/zCJ6LHlWIqQudcopHRaOXoqgEVigM3uNrADSxuJMRhYRK4jgo9/7Z4FodkB+StuRJc08iTfhNnD5bTF93kgjNB/5Wts/F7IqQ6KNvU+dwUJj1hS0Ln/oY1o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39830400003)(136003)(366004)(8936002)(7416002)(6506007)(5660300002)(2906002)(66556008)(26005)(2616005)(8676002)(44832011)(6486002)(6512007)(66476007)(6666004)(38100700002)(38350700002)(52116002)(66946007)(921005)(4326008)(956004)(83380400001)(1076003)(316002)(36756003)(86362001)(186003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?twsCcOfPocWpVzhA1oQUWnAnevy6zR6emL0vLy7Jsc1tfPMfXfdwZjyPd2cR?=
 =?us-ascii?Q?61lcT3Bc3VT7pPZmWrbTDdwQSt17XJvQxmCG2qCcbYMRaUmCYeiBGtCH3Z+k?=
 =?us-ascii?Q?Wg9Dbo8n3dxgZrtCTm8oow0rOSfhREnpSWZFUNRzwoWaCJF7XEbMEt3xdfc8?=
 =?us-ascii?Q?BWSwkO82lsmiEDWk308BW0PD/C4APs5/GQ5OtCtGMtxKWr9ewCeN1Kk61jsb?=
 =?us-ascii?Q?SVlf/4cgV8xfSvklrfK8YWdnfN2dbBVDpHzy3Sq2t978cXROluy8KX2eiNcO?=
 =?us-ascii?Q?WHtMlhzhSesl/mq0NUun3B1UkfE2f09AC8STRV7Y2D18oMvWf3lNWVwxAkzm?=
 =?us-ascii?Q?nvt57xzi+4tQc63i6s+OQ1EopKtttWkL9+wohy0PVrxQBQWE5YeQAgtQo7UX?=
 =?us-ascii?Q?rYFXMX43Un+tzv8+7v5bMu0dqhHSk1kmhIfl/QR568Dx6IB0sua0e4e78f4v?=
 =?us-ascii?Q?D5QJzcln+qz3nIvblq4LrKaDpDbDkvCJ+wVIkvpRzRQjsIjWysW3YBR5EDAg?=
 =?us-ascii?Q?//6yOvA10j72uEgkwod18j+OhA5UtfFtiht2xC4DVGDyOHMJi47oEdSVYHT7?=
 =?us-ascii?Q?GSr8Mo8Do+Pq44yZBQk7A4/FxfNHO5IVEQDzFVImsY40hjT/ICeokZCQqXcn?=
 =?us-ascii?Q?F/xKDy5RuRLHp+OqujyAwR87e5kqkha5Cypx1w2xA7gERn7F1winuEYFMkFr?=
 =?us-ascii?Q?J7NSpx4uaiF6vXIrfRpz7X26mszwaR568z874CwtOEIIgrKs5R9c6JiaOCm0?=
 =?us-ascii?Q?evYTkKRPJq0HsFqqw9paZOw6FwUeneN8ck5kyB3RwxQX9mpkV1CCpneNsNsk?=
 =?us-ascii?Q?Y/Cm1uxlRVmNYYMKlGCD0/5IQZLZQLw1H+KOvDLk77SXBRy9VgcZPXXFVub0?=
 =?us-ascii?Q?3VtGskZKYvInoL0pl3Mx8jUVndR3clqbwK2j+abRkt7E/X/JL/TeB9IYzw30?=
 =?us-ascii?Q?yH/sdaUgJJtVMil/2QxsJQJOdMbZVyYgjdNfeqHQqi1zVPWl0rCQQa2hPyPB?=
 =?us-ascii?Q?musDOnzd7KuN8ufUKfNbq6QUqNlYPEvpp8yB8ichfRyQ9nlFK8VuKg5EyPHU?=
 =?us-ascii?Q?EeEseTUZobP8GWZOFRV2AXrjReYdGblwEUIOAAuLwMz0JixHMJxMS7Nm/a3J?=
 =?us-ascii?Q?cdYLH7Wdk+mYolpkjn7WQe1xFy8ko59Bdpozg6sMAaMySScTd2k9D92AAa/S?=
 =?us-ascii?Q?M9BkpQXmLG7FLxFLmBvCd7kIQgiPGHrWKQ0MuqsfgrHYse6tC2Zq8Kik/N5N?=
 =?us-ascii?Q?uw3bOWl6P2yoHoPTps/pvtWg7VC0uEsm1puRt5y3WU+hMNYmY7XN8vwh9uED?=
 =?us-ascii?Q?JceZFfTtwOZmYZ1+yMQhUUmQ?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d10a0d-03bb-4738-b081-08d943d897c9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2021 19:26:18.9749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A7KmysJDQDXjdkzvDE2NUOBo9392XFwVNQnHV+CJsH1vChMeyavCzA/hqIMHYKjDcwIV5tzqm8vmTnxgdOPTcvj2w0C2K57ZzHzCa2pHiys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface so that non-mmio regmaps can be used

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           | 4 ++--
 drivers/net/dsa/ocelot/felix.h           | 2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 74ae322b2126..77644deb4a35 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1124,7 +1124,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1161,7 +1161,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 47769dd386db..25f664ef4947 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -45,6 +45,8 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot,
+				      struct resource *res);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 182ca749c8e2..31712a77f4b4 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1367,6 +1367,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 0e06750db264..540cf5bc9c54 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1089,6 +1089,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1

