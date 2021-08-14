Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA1FA3EBFE4
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbhHNCvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:51:01 -0400
Received: from mail-bn1nam07on2106.outbound.protection.outlook.com ([40.107.212.106]:65089
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236763AbhHNCuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:50:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDnJkiqbvi4kIph6wPQmqObYg65eaDfmZX1txyyMreHaQvCq/3abr+VHSAFNu5dtfZOSn4CpqfcThED/f0S7oXyGNazccGaJUJOm9AQd+XrvvNiAXhwooG+yLBOT+cVoWcAkDE7zRHhaR43IwTWzCxR/Slzbj+LNzE8jBSHDWU57NCJgooc70WDiwVRLcYeYT16HzcbXZQPGlqbwpkWu/enM95CWj/KdGH6+PaBy5oV5DHS7rERJABaOnUWvlfj1xbcOk86Qw8HyrmVrupvTCclfPqD/BHmqw78voaeayj/iN6y9sOdngHxqKppBplz4yYIFPoGdTMO+dYMC1f3mxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhGYJNnjw3D0fyx0iyJnQmkuk3FqOJlKQNe6ziHHRy4=;
 b=iwq9XXtqqZ+XX4q4xTpyX1fEgDSr8E5kiPZdmqSaUhG9hp5jEs7NJK3DrdPC+1WSNg4c6zYaGd+qYbewbsUEHwFooF9XSCEEGQ8ViV4irBtggPso2U9DWxhNXMng6mljvaW1fibQwzjkcBI3+caifZkqxILEbHu+5GjDDlZLROt8UtGy0hRzsGBkBRSDQLv2ksO3TCjh+Y97BiCdJdqAWLtdS2FwWWam2SymWpD1FIa2+Sc+BC981BmSrFldnh+0tBfiMZdSHHtv0EAvz4PvdmFiHbpR12fUid81+nXMdtfTYUIvuBBGJ/V27nQxOtpIUoY5eQy0P0FKiN/rarYj1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhGYJNnjw3D0fyx0iyJnQmkuk3FqOJlKQNe6ziHHRy4=;
 b=ZCJAoGNEHznWHshugGGiiiJkg9Jwa5Nd6YSpfG3FLhnz92RYDsFWBtS7Z+yNydcS+tsY34TdtQAb/18kd2ALAhFOlGB1Pd0AsShpaWUzYowqgeKrxNcDQFkkzMXTchILlEY9Fe/BqnDBOam7VEmnK1tOThxQ3PrAOHy5v9lOW5o=
Authentication-Results: in-advantage.com; dkim=none (message not signed)
 header.d=none;in-advantage.com; dmarc=none action=none
 header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR10MB2030.namprd10.prod.outlook.com
 (2603:10b6:300:10d::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Sat, 14 Aug
 2021 02:50:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::e81f:cf8e:6ad6:d24d%3]) with mapi id 15.20.4415.019; Sat, 14 Aug 2021
 02:50:18 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     colin.foster@in-advantage.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 net-next 05/10] net: dsa: ocelot: felix: add interface for custom regmaps
Date:   Fri, 13 Aug 2021 19:49:58 -0700
Message-Id: <20210814025003.2449143-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210814025003.2449143-1-colin.foster@in-advantage.com>
References: <20210814025003.2449143-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::12) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.185.175.147) by MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Sat, 14 Aug 2021 02:50:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ad03900-72b9-4192-abb4-08d95ece4055
X-MS-TrafficTypeDiagnostic: MWHPR10MB2030:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB2030F937FC62E3A74B3CCA57A4FB9@MWHPR10MB2030.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dx/PrwJlDEZ6tNsvjL6W4PfDZbg5zm5BIV9TemgVOM4DFYZJMXf/UdT24/B9vegHZpp+rSN0FvimA4n3aXH+lqlF8vEgfn+Y4ZpanTgLsBjGmShQQq+um2X1ekrB/j2qBD/N+vO0kRWitf3zScnWGhLU/5QcvPY+odREzPT0leLt42K1yn4C5vFkybu6XeGEhfk1tXEp0FxIosu3+/b8rEFHL0lmsDdrljD7/cJo2Cntl2o0U9wuw6fi05YUBqdVTlVtpOhjHNurTiBJcGnqjiRCksvffEwz/DuFfyT6rga02/aYwBpLCjvCWlFmqcz3LoJdgqvKxBFiOSUjJy4GkBsVsgA8/eg6SPWLHJFtcj/Kiu4d96Dq5qgFNFEDkC2MWRmLs/KCZRNZXaqet4UsIez2O2nDXKXLSnohonjBeqE1S58SDOdHWg07u0GY70rgHBDRmuSwAqwnnwwFB9suno+9RBqmJm0Zw5FgW6xYsoWT/goV7KR4krbhc2xcFQo2SBz6Ugy4pKFhiIsiOTQ/UhIWBaKxzHBkYG3mPHmMciTI3kbMfIWN2I4k77aG7Ab5rZwl3QSjZjQRioGisG4u7gNZ3ph0fesAc+fU7LYy/1t5/7QtldbQei3QF/kls+wqfl3WZNfv4Yyo/Vv935zH4i725Og010WIbn8eOco3HlkGDE8m8Gn5OMx8PQx6vkKlbt6VC+23XMiMmjGSbr/uY4uxc9+hWtUb40Y+8PvT9NE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39830400003)(136003)(376002)(186003)(5660300002)(316002)(4326008)(8936002)(6486002)(2906002)(52116002)(66476007)(66556008)(44832011)(956004)(2616005)(66946007)(1076003)(921005)(36756003)(83380400001)(38100700002)(38350700002)(6512007)(6506007)(26005)(478600001)(8676002)(86362001)(6666004)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lgqzow7IUYeDzLsnCyMzRYCYzbuZWnEpTlTubNyIi4XrVo7Z9Q7mnMv1yNO9?=
 =?us-ascii?Q?+NpDr/vBOk7d2oMIauZ6UwB8yEaWsnXhI/jc8c8dewtNJ9HfM42g9g389MjZ?=
 =?us-ascii?Q?PVbO3kB4+7qbPj0eVzbMCDY2dxo0F5cUquIwf4O9DEdkpKSOwL09JDj1Own0?=
 =?us-ascii?Q?ht823rLOZgO6xa/jHIv1koIWthPipd+r/0EMLW6v3xyvK65IxxMH6X4cDaxr?=
 =?us-ascii?Q?x7TxH98oL3YeUzDgDaffa1log7/gwOTZ/q5kYtoqzqzyWv3jPyHjTQenVWbp?=
 =?us-ascii?Q?TSedlmuJMRaCi8nGiDBIU94CNNnhHXmZG2xl3fOvAkMEQrOjnr7hUNZZ0x0b?=
 =?us-ascii?Q?O42nuI++42zJ3KtdXPq0zdoRFgFr2iH94Om+Hh6TwCx17RAbmO6BP3HLuAfZ?=
 =?us-ascii?Q?rE9XS5gD9w460quCASRnXfQfWM8KMPwzevN+UTYVWeceJXysinxYGGXfUZtF?=
 =?us-ascii?Q?zWskDaLJqwPJZlkaUd9uDh93tKdADR8lwxvEcRp2qHXbJUbXwMJH5G19rcuQ?=
 =?us-ascii?Q?JxaQq7jWqg+PlnJSTxgO2yot9FEeB5XyaKwHQqx6q2ZycZ3wTZsbWPhlYf6W?=
 =?us-ascii?Q?U50d7+6vDllGkg2gIPMgesd+75Kxl0cjNXTUswn6LoYi02J3uYX+pZ6gbOal?=
 =?us-ascii?Q?55XbEbpwapuw1XT9AMXKCjSpMeiKNSmsS1kYIilckvckSTz5aAI/e6T7DWLu?=
 =?us-ascii?Q?ZjXDhAIcr24yjUXkxllZhPRHMYFM5iXZcufuChTyaL0Wh+WdcQI2Wg2ETMmx?=
 =?us-ascii?Q?52SJ58zwZ7mg2iUr3m0D/SO8XffJ2aYk2UDOmTYrKlEInGGcfattbAjs+eDA?=
 =?us-ascii?Q?RJmLouITgXZSCn+gVBFrKAcv0m6n3cnA1YYBRzPBRYvGuotpNHTq9PKu16tq?=
 =?us-ascii?Q?pmzW6HWz6FHygGW59ko0Zz0XAPJwjLp/A+7fQX+GEFPMQQjvbeDOgUflTp4t?=
 =?us-ascii?Q?/m6cLKkVecpsICo/N934UHcj/6a8fv3iPZ+CFIGinwCmf/ap1cLDwvrBOHx0?=
 =?us-ascii?Q?Qc376VC2kKNTo6n3qZdWX79EmGxNsLMBERMTGHOI44+uX66LBFWZmlmKD6gf?=
 =?us-ascii?Q?R7WM9YEpuYhfds59ZV97Ig2TKJGhyRrx+qPHhpSDZZ0MlZb+D+37uB5rxI+S?=
 =?us-ascii?Q?bkaZMRGnkgIY/uz8lPv+sta7q8rUqQ3yGrpD4cGdJZioRkmU+DeoRKhmmYmW?=
 =?us-ascii?Q?hKd+nQ9WyFQ7u+eRWL/6ygZJpL8P16CyhOrMHQH1u3SJtAF6/PRRiiQEHrf5?=
 =?us-ascii?Q?sEXX+Iq4pWD0lc63iLrfue76rrp+owOWsixjxn5LGOUZBxRS9reYtGMgEiAv?=
 =?us-ascii?Q?O/E2KIZM2rXMpW/SrQk1157g?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad03900-72b9-4192-abb4-08d95ece4055
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2021 02:50:18.6585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F5JXGbfeIgsy12opPDTnPq8BWk7yFyWQ28IQTV1JEfOLE+4FPx/q3LPJfIyMKpR4+Duj721WVoA+JH4k90v0du66hFS/la+ElTHmBwVBqJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface so that non-mmio regmaps can be used

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c           | 4 ++--
 drivers/net/dsa/ocelot/felix.h           | 2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 6 +++---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 8 insertions(+), 5 deletions(-)

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
index 182ca749c8e2..a84129d18007 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -17,6 +17,8 @@
 #include "felix.h"
 
 #define VSC9959_TAS_GCL_ENTRY_MAX	63
+#define VSC9959_SWITCH_PCI_BAR		4
+#define VSC9959_IMDIO_PCI_BAR		0
 
 static const u32 vsc9959_ana_regmap[] = {
 	REG(ANA_ADVLEARN,			0x0089a0),
@@ -1367,6 +1369,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
@@ -1386,9 +1389,6 @@ static irqreturn_t felix_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-#define VSC9959_SWITCH_PCI_BAR 4
-#define VSC9959_IMDIO_PCI_BAR 0
-
 static int felix_pci_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *id)
 {
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

