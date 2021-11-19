Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFFB4578E5
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 23:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbhKSWqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 17:46:33 -0500
Received: from mail-co1nam11on2117.outbound.protection.outlook.com ([40.107.220.117]:22881
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233433AbhKSWqa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 17:46:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kUq16YaC/jew/APdFFpd32APawILDapzb1vSQxygCtlfA/EKxupS6Pmm2ljK/d0qBO2GNH2VWvmZFi5nAHYx+oGtVRvFP2lQOEmfvm3FEIgolcx6SVCr0Uv0HxU1KJH5m4S4poovRFih6JGjrSgrTrDnK0UgrPx0svBdpx2vdtLAHlr3qig8+UX/SUwx0pxMWZh3nmxa117aIPhnpMItuk5H+0JUz5Mpr9KEUAkwuWLNJds6r3znpRl8D8MVrYNZugLP/pDjveqmY9I0PVkD9H3TUDA3+D8MC6EcdDpDBnJMBgNcngtgi0trkjqR1EBwo2VlDqIRW0iaRFs0eR26PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fs+P/dCgvnLUdxBK+Q8CHOeMNGIvtl6dbtjReLlqRP4=;
 b=DLFvKyKGBsGACKRjWVCDwp58uRzmjh7sxZk0gWGoi5zc9egbYniOtY2S96fcqb2r02YKUG/YPxBSxKf/84RlDXlvkG9lQOV04/dOlqPDAccOIpCRsGBtJdkhe6Gwesd1vUt98kl6gh7FfB7RRq0jD1mvHnC5Zb3sM0wDKbsR2DDnfI/urouup9E97j0S7b/iONmeGHCcCO7uKHT2pwab1MejinvJm3LK5Rz2EFSRbwHFNdcsTYaYY/43r6U6cnO4uPQno0Hlxbl8TzEnATADnZ4eem6qNjjWCLol+U+icg0OSv1KhG6AIMVs4hEJyitXYFHBF7+d9ulDyzPlNbjU8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fs+P/dCgvnLUdxBK+Q8CHOeMNGIvtl6dbtjReLlqRP4=;
 b=rLBY9LkTte3rEl9ELnLrSZ+9Kdpz/56VkQrjcB/5htPaN8Gjv8lOAkGQ8gQqZvQGDtQrI/IIQEu3iha+8SXePHAVmWnGsfyfm3kzHvZu7BenfWqnKJN3Sd9rG1DKwL84vyQgPtt3XBoms4K8yTDZhJ1Ynxh1ttLLLe9d7JYoy24=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.27; Fri, 19 Nov
 2021 22:43:26 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 22:43:26 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v1 net-next 3/6] net: dsa: ocelot: felix: add interface for custom regmaps
Date:   Fri, 19 Nov 2021 14:43:10 -0800
Message-Id: <20211119224313.2803941-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119224313.2803941-1-colin.foster@in-advantage.com>
References: <20211119224313.2803941-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR19CA0061.namprd19.prod.outlook.com
 (2603:10b6:300:94::23) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR19CA0061.namprd19.prod.outlook.com (2603:10b6:300:94::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 22:43:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cacffc6-f77c-4faa-270b-08d9abadffdf
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5701D4D207243B29616AAA3BA49C9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4B91kVM8QKNafucQDcUmmxDDIagGg6XBMxZYtUqIg3fmtmPeuAHmfU/xTvRPtIkYLoCIMCEkVaTtxneiTigGolAVlmeji1J8g/Vw0sdpuptu3dEn8n6awrVUDyENqMJFjjmoXqx6mMl/jrKyi4ETAzMXSeYfHKXCM+2SLDAv1hKkuOx6t7uDBLsGn0TxHvI9UXxAXDJVrN3wMZnU85aS0FjqtB+9tGuIsA0/wZ59a40oM4rX9PVYiDiHu9MXFp5IYRfW+9l//VkbGm1c23s8qZIyjqBr0uf0uyfRtKUZebXVUIKH2xcFTjdE1vf6dKSLTChPu4a5Sj0Sf8nC31nsSW0fUDEI6aHn6AgdofYLOKYFsVzH7vP2hf2DfK8FU3TouBbo0FSzBjvBnoWq5g91ZarxGcnQvN/7QrxJk5/z6/CO2sHSHz9Z44khkMsm6/83jjjL4luCeObC/zwC0raU7D32ATDFzDuUAyiM2zfusVHdVh8IR+YzCSyjznfjkTue+5g4IsCSObqeA1AB6ksYqwR83IsTYmXsItbrnQKaAwedCbQ9oJrwtnXlQEOo6j9ZqK5oj7wkqNcBgE6gnqbNJcT+14h5lINqAbqKjg3wDBjvEkSqgp66Bp2C3xxCuSEelxUg/nb2xZL3RQgawD1AXFpVsozeBE4joLGgMhKEtF0FKonFQZljDW0npHyEVMulWd7fiQpExXRKq3rJw9rwWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(396003)(136003)(346002)(376002)(316002)(36756003)(44832011)(8936002)(8676002)(6486002)(4326008)(6506007)(508600001)(956004)(2616005)(1076003)(7416002)(6512007)(26005)(86362001)(66476007)(66946007)(66556008)(83380400001)(2906002)(38100700002)(52116002)(38350700002)(186003)(54906003)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0YBGue5XDs71uDPPEJ96MXroDrPKehTbfUbJnhbdL+Y8IJS6WM3jl2a9Bh48?=
 =?us-ascii?Q?aCQMmCZ7/fuwR3jEMVSNK7GBoSjkcfoUpo6SL6gHE56AKLSA+cstF7Pj0+JI?=
 =?us-ascii?Q?bV9ZFui8RcY/nnb8yNwn3zn/xlUeE5nrUMh4iKz5FUDC4jCHbkb9UhyXlwgi?=
 =?us-ascii?Q?lOESE9yRzLrNlufdoQrJBSvu4y8D0oELVawaG746jPAHbH+r4jKvs6LUjTLW?=
 =?us-ascii?Q?np6eM32nlEz79IJkW7LaD+kPD9J/kyjKcBMvrcMMN2E8PZd4Kjiv3/3yChl3?=
 =?us-ascii?Q?FpS3Bi3LLMeLndRvjVItYuMxnX8nrMqj5ck9rdyuCDJzfKNGlgAGkxTUUu+f?=
 =?us-ascii?Q?dF23lEmxKImLUQDtgLt88Nvk7N/UF6TxT8pcK/JV+BVCw38P/cVvlvioc28X?=
 =?us-ascii?Q?47X++2ExvsHxUlmvjdn/ID81V1wIR6uCoA82Ck0mGxzhi6XgzZ/GLdgN5s4V?=
 =?us-ascii?Q?alfScSi0sqtMyQjKy8IrLc/2oI7Zov5kai/BMD1RJ61tWglxAGzBzi2kBDKC?=
 =?us-ascii?Q?iHE25qcx2aeTEVf3bRDvhUTt7fFF3qmWqRI6vJjhJ8HSUB/R5aobmbRl0w9g?=
 =?us-ascii?Q?Riz69fGCINxSIR2CavrnzxCz3UZZfQh/Rb12MbCm8BWDHoIVKqujfW0ZwGkO?=
 =?us-ascii?Q?Y9KGFihVc2wu4+lJUm1dkYenCwYgC9lt7oMGLGagK9GKY2UlZufuM3lfORQG?=
 =?us-ascii?Q?0mVKY/JJruu0H8J0cmTovY04cb9AfmCqIu1dNpaYMgYDAj0CkIRccyWJUh5m?=
 =?us-ascii?Q?4OsohAjAwFdwZVNCylKU7k343Xs+93HUCmQUtu+wsBng6HgDcKzynXoKQYkH?=
 =?us-ascii?Q?R/I42fe0L9Hf8IQyDoRF7b+ILS9jYYvmOrn0HyDynbyGrjYaWfqBU8BCnLN3?=
 =?us-ascii?Q?HM8lGlCi4slDSUML6/HYEtDuWQR6FbM5wMPbnB0cid4rN/ieKvWOQTlUq41t?=
 =?us-ascii?Q?H6iSLGExGH6Fe5k4oC96i2qFnGt1NbgCQZLnGanV+rdjV8oq4GZyopE+D7Im?=
 =?us-ascii?Q?qOHnp8xwLatR0SS2vY1zzZceJl8AlyW4MhEt3siEyNgYTgagYrlW5buYhW1y?=
 =?us-ascii?Q?B1p1BOBI/TGX3vzR0B8/u8DFUWl56eqj/9fOq3eMENG2iLgjUnH4MBnRnDHK?=
 =?us-ascii?Q?o8rMyaeH+X3RKnWHJdoZrcdJMIvkapup1sueUALpD+RdrgRc6g9DTKUXO3CW?=
 =?us-ascii?Q?tt2DWgSYJZfoNJ2TaWFWsbvllXAQ7LRBOkUYKs/js6c+EphB+ehoeaj+X60e?=
 =?us-ascii?Q?vD29O8ezupXsPZv6jVA0yXJgskjmV7dHOUI9Jq1kosBvW7rljKtMnQs01JaZ?=
 =?us-ascii?Q?10b3OA2VFh24xyseFv7HmlKDqwqRTPRd5750Qgh0OBTMAKIC7Ijg/tk4mhpO?=
 =?us-ascii?Q?+PvpNSphSxsNOymV97Ahr+i1KJtMkr88PoexiuPbKSHmWarqTauRk3G5lmCZ?=
 =?us-ascii?Q?7EwIRjozBTyqQrSnzalq2nybdQKJhlhzI/r4Bsf/gnFx3rONT23oD4fUHeZC?=
 =?us-ascii?Q?vY5gppH1RnVDXPwjANGVi0OCvh8C5nlBAX0uKbeWlLk5NVIl3PMw1v2fqUb7?=
 =?us-ascii?Q?Z6ETAljZs7kmPBdLQIZ/ZwevUwWJxt/gD3VKiMnGuqIk7ASGHbuzO7YSMw+6?=
 =?us-ascii?Q?18q5NWpO0wQcX3QWc7cy+2uSxO2Gx8V3n68/q6H4/hAfyi/blJwx+AqG6tyY?=
 =?us-ascii?Q?qZCNyt8MOWN7cK8CMoA7lSgAOtA=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cacffc6-f77c-4faa-270b-08d9abadffdf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 22:43:26.2311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VzRd59Ga7luGAoGn/RlvKxvRg5NhuSF0Lm/O9gTSbG8Cq0GEsrZQzVl6M+Pmdqxy4z/499WjuaKszqfB8KiKGqBngSXigRjdUu75aHmpOwg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
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
index 7b42d219545c..2a90a703162d 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1020,7 +1020,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1057,7 +1057,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 183dbf832db9..515bddc012c0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -50,6 +50,8 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot,
+				      struct resource *res);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 9a144fd8c2e3..4ddec3325f61 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2165,6 +2165,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 899b98193b4a..ce30464371e2 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1187,6 +1187,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1

