Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D744479DA9
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 22:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbhLRVuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 16:50:09 -0500
Received: from mail-mw2nam10on2096.outbound.protection.outlook.com ([40.107.94.96]:43520
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231545AbhLRVuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Dec 2021 16:50:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izlP/ks8OAarp3To14n76fyNJ3zXuMzgxI0F8fB3ASxCdk3y7LmsR7vhkZSt0JDVWV8IE5oDxNvrLd4IPS9+0TrouTF2cOoI5G3Bx065O88q3NxOFvf/XkIEuVxvOE6z1qDPmpsVyWvXYocyZc46jS0HXAzIu92MTYxiLaCySIulEzohuAZumBvNkiXw0YTPxf8xhlJKNjr4cziP7TwrQJJtkkxyNd+LdbIYq1y0PPQarBagvgHKgyzIm40cmEvlTQ5COiLEA/cSn5MNr4g0rf9LbmoN/EPLGajLSlrK+9Iv2EuOo9k0GJ4NILJL8xb6Fxgi1SZZqT/R1dbN/IQlrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DvRm/Wk5tMUlCJqRVSrJ8dVEshWv2C49TAT8UbhlNYA=;
 b=Y2XcCGtkaapziYUXJAn1sem6H6kbz7453zgPBmMSWZkm7k5dMvAvK0BkzWfraVfgXO6qYrwg/lPiGG2C6v5haudAjZnIUHuZzCJArzvK/mMEJdN2dI7S11Jtk/H9j5K2Hm04gs6/utCIXcEvvVcQsyq0fhR2CnTSDJ0iZBq66h5nuU+GyFw8fC0IjjHBZ05L8kALb7hBviyqzC2UAnn2T5qEuq+wddfgRn5HAdosLIEpV3t2nATaLXbEs7C1xglBV1/ReIpxPVV0mfBs5Pnc4h8kzwIXH997015xcUQtStVga4XIA2bpIoCmjVflR8qmVpzur1eqbMtKmBR4ydHBeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DvRm/Wk5tMUlCJqRVSrJ8dVEshWv2C49TAT8UbhlNYA=;
 b=SrN8Jy+qA52WNYjEhqdb8kypokGoVRjybA6xh5Yc60vHOsJeAAu6NApYIHSDJQwZ258J7mm3mPxHmf7hv2jszeZglVDzHPeCJgoShOAoSS2vTgLfX/zN3GlECIlHLmEqMZ/iEsylGzz+H/eqAUEqNOLjgbuPq9fQvLQ4h6FcCZQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CO6PR10MB5633.namprd10.prod.outlook.com
 (2603:10b6:303:148::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Sat, 18 Dec
 2021 21:50:07 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4801.017; Sat, 18 Dec 2021
 21:50:07 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [RFC v5 net-next 02/13] mfd: ocelot: offer an interface for MFD children to get regmaps
Date:   Sat, 18 Dec 2021 13:49:43 -0800
Message-Id: <20211218214954.109755-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218214954.109755-1-colin.foster@in-advantage.com>
References: <20211218214954.109755-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:300:4b::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 772ee936-3acf-487c-3865-08d9c2705af6
X-MS-TrafficTypeDiagnostic: CO6PR10MB5633:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB5633D40117C0DA7609DED141A4799@CO6PR10MB5633.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yLKPA4maNdFxCQFWXcO0eWWuz4ueriambPuFrr6RMFz2o9bFJP77HQ4HvbHV2fW9PI8TSXWpRWVvVVnbw0so1Xm49cZWojq5lHE9yP0zzBtBuSlUH5XYBjEmXjqGZLkLVJoOb/CyxvSZK6370BFhnIlMRSqz2XPXBKdyhjgaRSDdzSy0C0q/TrsRDQhVk4H4620E0kwrVcWy8hAMgvPF+u1UseB4J5e1WXjVWfEr5VSNRgSjJgqxbw8j7CtLmG8V7etGVbrIuyuxPJYMQwdp9Id7Q6i6Ha5vZGJx+fy/2q/fbGzPxIRco+RmQYiG9oe4o+44WdAg2eVoJqMbEIDdM6mYXr730I+zNgtwdA3wmunDFUWOSBIxoPi2Ig+YttmmhaN0bEC7cdzT77fJY667yQTXndedyyPyf7Y8EnOyuA4YuUfNEwNCqsslBqpEjHJR2e1RN9X2cSEeJW/sOwj/NEdLYZuaC35IP6xXBMBqQ19qdRrqB2HzvJCkZ1AI3ppm6BD+GrA35jrCrWEcBfEwrkEXmKnnUOx6ViXBFuwsucr6LAssEONpeJ/+gPaedH1GJq2eW7zEWaBWp+DRW6W17OeX5MC0eDgFD6VOrtW+ObA9G6C9D4/HOCCXqWZknk/bKJQaZNlKVeOBnrOSJKv8jI2tML22A/o12etTyskXIW/0rPk95KTMJ7jIwTKyYS4AqwO7qJ1ge69E/Vc1jIFjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(346002)(376002)(136003)(6486002)(6506007)(7416002)(2906002)(36756003)(6512007)(26005)(86362001)(66556008)(66476007)(186003)(1076003)(6666004)(4326008)(66946007)(2616005)(44832011)(8936002)(8676002)(316002)(54906003)(38100700002)(5660300002)(508600001)(52116002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?52kJGgRmiFBqxxPtct9OzlUAtMtU/w98dVLsO8JYZ62vGpgWv4tFxpkPlYcB?=
 =?us-ascii?Q?h8bCnv2bpyDo8Xwz32M3/nub1LhCEjnTcguoefGaOk6mXe2NDxN3ijFD2UrC?=
 =?us-ascii?Q?g1x9/i9JeyjlzYk4NxuZYU7dUJGaetsjf9Kl4ANpQwAnomciWtW0x0mR44v+?=
 =?us-ascii?Q?E35rbkm9mFOjQXmfKykw7Rtp9I3349xsE+FldUKOmX2eYOXlS6howwlN8G1D?=
 =?us-ascii?Q?Tyk5aJei+0xjtqKSZcnYiXYcgpZieqYnYroNS91IZVfMq3xc7oLMbj1L1frT?=
 =?us-ascii?Q?t00nVssija0B6RXyIrJK2NQbcJPIW53pC9ZH9FC1ZA7ox+xAfi1p+yJcHzYP?=
 =?us-ascii?Q?b7ASW7RA9b9tyxf3hAjdJSuML/YvfmE6+0ttfd/wf/DoWXokExGK1MegFb8s?=
 =?us-ascii?Q?JV2BGc/QjelyBkWu5MjTbqqfgT43Ra4q2cfjrhlrZyB0bFUCKqBvmQnyAE8I?=
 =?us-ascii?Q?XHXrd+3395PtRd6dtaAm42rZgMoJKsU7Z24cFmZW0iUZ/jFqyLz78Z20GQQM?=
 =?us-ascii?Q?V2pF3dqfLePXw9KH1QH3YzLHfIpH/vYgnRyz/Eh50Xpj2uGakfERIf7mcGEu?=
 =?us-ascii?Q?fPLeo38yll5nOBo3BuCshWv6K3pruNSHHHcyAR0NShhMUNuDx35Qs5Egs3JC?=
 =?us-ascii?Q?zVu31erLgQ8KiKfY7OiTQ4JCv8Uit4c2K5POvUfQ7EQv90UozGnDOGLvtaDZ?=
 =?us-ascii?Q?dDpPDvFO/79qRT4hflBuiN8RnZUPEAmg7TIXkzo6cqjy3bvZfg09QTHXzY2/?=
 =?us-ascii?Q?9sZK6EUM6vnGPZJdQ63NO2fDDEBXRPaj00wSv8x7FE5rmH1IFrNoAlgQ6aLo?=
 =?us-ascii?Q?GarAR0GgHFtJBq2BDtzfieNnD+irwDIm+3Lo3Tr1pSXxDb9Y8M4canxas/Kr?=
 =?us-ascii?Q?UBttuBVCy7PNGy1VRxKwC4FE+eNgmkvBiSHlNzcxMQV7bAbbCY7BNj8XRlsq?=
 =?us-ascii?Q?86d3lAHG6riKBsqEDE+5kGzfRJauhc/Gb9dx7LZIQtCuyXpEGFHSBPcqwCE/?=
 =?us-ascii?Q?MFn7Q6rCFNQdiLaROlHZ8Wftv8pn1sbP495rwyx3RTScRE1N5ayJeJzOonJ4?=
 =?us-ascii?Q?vxCNlgj2R3oJoHJUrMsOdlZ/O1sErW08aw8foZshF30kZO6Th7gn3UTGOfB8?=
 =?us-ascii?Q?VcCS5G+Y1iLCcD+jqVtbZ0KoUWhusEYXrFvhFxUrond6hhAlvB2nOS4mVun8?=
 =?us-ascii?Q?lsCBHpL8rzm28BVZyaWn/lkLoZ/cXYDa/Bphb6R8dp+r3HBxgujcOh3e9naJ?=
 =?us-ascii?Q?RrD0oAoll1PhpoGk6yOolfPBqBy6N2FP4Lb97CG9LPKHqC3rFU0NgKcvxOaU?=
 =?us-ascii?Q?adt8CDoBnXfmLUf28n3oWu2P9cIOe2WwNNe5esdVWpV986NQmizfH2cWEOxq?=
 =?us-ascii?Q?RoAqNW3ap96Bmo3SnxW7rtlsarMFkyBYO4PKdHk9MQT1RPNLquSI3bNFP69f?=
 =?us-ascii?Q?XN1yVYUK/9XRzS3j5g22FBnwy/82m91CqCeD0tO9fy+yHJRpJmkIdfcZuxf7?=
 =?us-ascii?Q?56jUgpXi/Ye67Rp6cyQx10fcsk8gvjpWJA8fXY9zCSOu8WSBVFUBM/gMmCiz?=
 =?us-ascii?Q?KGaKX7NrzMYz6FVaxmKCiT+8rOVqbGmRNAz9AR63Hu5cvWydBgF9N+kvuREs?=
 =?us-ascii?Q?k1E4TNsZEOUuN0RKqFEadnsLehY8vuK82kmIe+YjVC1uAoznXfRIjMiR83t9?=
 =?us-ascii?Q?b3FX3w=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772ee936-3acf-487c-3865-08d9c2705af6
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2021 21:50:06.9722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BG6jh2hUQq6un17S0uaJCCputh9awEm/lGvaGYsYonNh2AYXqDCqKUswJj+I/tue3FBNLnnNHQDdpH9A0p9OzqmURVW17LLizrVCuZ8kyZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5633
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Child devices need to get a regmap from a resource struct, specifically
from the MFD parent. The MFD parent has the interface to the hardware
layer, which could be I2C, SPI, PCIe, etc.

This is somewhat a hack... ideally child devices would interface with the
struct device* directly, by way of a function like
devm_get_regmap_from_resource which would be akin to
devm_get_and_ioremap_resource. A less ideal option would be to interface
directly with MFD to get a regmap from the parent.

This solution is even less ideal than both of the two suggestions, so is
intentionally left in a separate commit after the initial MFD addition.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/ocelot-core.c |  9 +++++++++
 include/soc/mscc/ocelot.h | 12 ++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index a65619a8190b..09132ea52760 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -94,6 +94,15 @@ static struct regmap *ocelot_mfd_regmap_init(struct ocelot_mfd_core *core,
 	return regmap;
 }
 
+struct regmap *ocelot_mfd_get_regmap_from_resource(struct device *dev,
+						   const struct resource *res)
+{
+	struct ocelot_mfd_core *core = dev_get_drvdata(dev);
+
+	return ocelot_mfd_regmap_init(core, res);
+}
+EXPORT_SYMBOL(ocelot_mfd_get_regmap_from_resource);
+
 int ocelot_mfd_init(struct ocelot_mfd_config *config)
 {
 	struct device *dev = config->dev;
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3e9454b00562..a641c9cc6f3f 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -968,4 +968,16 @@ ocelot_mrp_del_ring_role(struct ocelot *ocelot, int port,
 }
 #endif
 
+#if IS_ENABLED(CONFIG_MFD_OCELOT_CORE)
+struct regmap *ocelot_mfd_get_regmap_from_resource(struct device *dev,
+						   const struct resource *res);
+#else
+static inline regmap *
+ocelot_mfd_get_regmap_from_resource(struct device *dev,
+				    const struct resource *res)
+{
+	return NULL;
+}
+#endif
+
 #endif
-- 
2.25.1

