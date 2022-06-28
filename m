Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 954A855DAAD
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244914AbiF1ITo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243946AbiF1IS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:18:58 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2095.outbound.protection.outlook.com [40.107.96.95])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17F62CDDA;
        Tue, 28 Jun 2022 01:17:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DPynDzFO8Rq3xU95mwShzQ2aK39AVWlTpScGwWUOfST8zMpQYpwyDVvt+lz/Jh2BWeBtUr8mvgm+RmvDKZaBbAh/ANkUTjo4G0tTzJRYHFZ+rgT1uW1J/FJKYuAPnJGKj48lFt378//FjGXZLfEUcxuKDn43hw3lOexFGLVucPdPWqv9x5OEg7BnCBAEhBrbSh6jdQ7TUQWx1x1+OSIC4okhrsE7lpiAMq8N/EmLNUhtu+/r+VTwux1DqhW0vsOb22mrSjOerejnfS9zZ90hNIjr4IG1T1JecYsmLEaxHr6u/r90uvHm82uFfzJ4OmgtX59W2pdcNysqeTTmf9mLCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etvTK1jZUaNQRolhrrc2mAl0SaiY0CsgopO8BNLU9Mc=;
 b=WIrz8/We9H45Gz5YWApnIoL3BD0Nv49RFaGxhxpJnWFMwoKbIyjqYZ0KLoyUAwdLbBtiLVEY0oIFPqk9rASjJKWMqG7cjXuRKLPIURT5MvfQ2oXv4+lh6jcPB6wgdOtozrD3El5qD1V4Eq8adE30TSsbik6cYcG8DoXwMoSG0qXgX+aRs/J3ofWBsrE9tjHPxxVmCr3zK9LtuGGkQs/CbnNXf5SE+JzM3JCWLR8j9yI73aH5IGQWK1Ogn4BaTA0rrxjH/9oGoMYGk68bVoViGuECn1u/1qUUjBn7ap8zXU90JJ0cphm/jRtbudendz2ODXB9V6uLtjt2RcoGuf/vxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etvTK1jZUaNQRolhrrc2mAl0SaiY0CsgopO8BNLU9Mc=;
 b=fMVNivEwAjwDUFMKDHNRbOQy8VbcAJdzVX4WGpg4LAOvk2ji/96bp5sFOopzCbRlNLkueX1bkDX8AD09DcNwWuAKBjjTSz5Xr9EMzFVpG3kjgyc5o0p/zP3JeOgtKob8J2eWmZeU3gZOYwLheP/aDv28cS3ZEujpmh0v11TJg/o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5891.namprd10.prod.outlook.com
 (2603:10b6:a03:425::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 08:17:26 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::712f:6916:3431:e74e%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 08:17:26 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH v11 net-next 1/9] mfd: ocelot: add helper to get regmap from a resource
Date:   Tue, 28 Jun 2022 01:17:01 -0700
Message-Id: <20220628081709.829811-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220628081709.829811-1-colin.foster@in-advantage.com>
References: <20220628081709.829811-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0259.namprd04.prod.outlook.com
 (2603:10b6:303:88::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff154b95-1a82-48b7-391a-08da58dea288
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5891:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tKQqlgj37GYtHIOJxLiZN8U007bYybCSk6N8NupIkNlnSeMjwmnmQr7yYnvTSQ6Q10v8gxerJrRCAO2tTPRn1Lz2PNhby+xS+mml06BQMmOoR6UAFe69LrXG0Z4MuPGfCv/FH0e1n2ULmZnK6PuAsg4xH9+/3iDGPPOZsM/97JhymhYwsmrIbAiAwd2zh46mNFyrC5y75VeIgt8DmT6njZovs9OJLKgJ1+tSw3Mdz5DYTC+8RwJ7Ew8Cq93dhseVt61C09wrgkNymSfda+/NlxvY2DPeAm2cmm0fmQhb13vUKcK7E1cND7wlejLyzO3Yr1uGEGJmJX8kX/hG/ugBy5gGIgzl7gRd+LbPP5oMZCwv5lgE9EpBj2NNf2guOKX90GEGBWInDTmP77PB1ooZoX9ERgSvXYl58VwpG4/KdWUTU/D9oKBir6mqkTumti+wbJi/7QshOlTJcKNvaApAoQVfG9C3xL7V+yFma63qsO9R9BbGkZqjPTcImFc3Bbd4+Hq6NCOoIocDQU0gvwoCXPiEnFEWifULywBFixE4RDFtViSu1WdIRily9OEHzbgOTETtln5b9rkoR30KOvFouOl7w66M56MnI5mNLUonvC4YVzXSH+Y37Yw+LL3ZIH96xL/FoDFcbjt4VUFzmt/Kfjcg7Yq+AoXXcLT5NIzva3sksSSLg82Bww8wFYf1PAQeAwUL1EPWpth1j3LqcC44vkPbtSUEvmItd09YplYP9bqW+NqHIswgS0iiDhxEUgiKjApIFV2OsmyV/euX84xAGq6aSXIK20/dve5+wP1qnto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(39840400004)(376002)(136003)(36756003)(38100700002)(6512007)(6666004)(41300700001)(38350700002)(44832011)(478600001)(8676002)(4326008)(2616005)(66946007)(66556008)(66476007)(6506007)(2906002)(54906003)(86362001)(1076003)(6486002)(8936002)(186003)(5660300002)(7416002)(316002)(83380400001)(26005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/BGrVByW/R2QjXsLj8o1811hAUUrV5BqRoyns5VWlooHj/q3kMRf06EK6Hvh?=
 =?us-ascii?Q?eu1qf/eI2eD+LNLux9L1mpSTgA+fiMNf83X3Nu7GctIgv9mOGtmmG/byLyWJ?=
 =?us-ascii?Q?sjlCbv0gM4sdTQ2rmE8W0u2S/ECPW/15n7oQOS0FA1mqYt4ZAHf6xiBXFS88?=
 =?us-ascii?Q?CRqzYI9HuKGHkljWVjFvPmX5EEZSy9cVUPITAc47KsqRW6xe42ZtJe/7iEJM?=
 =?us-ascii?Q?QoSoPJWW0LUnd9C1Nld2EDTutBFae7c2g0JsjkOtHJuE4gG11D2NLVp1Xx1W?=
 =?us-ascii?Q?AFy2efxbckn1RqM9MAoplEqHD8NmHIKBdwz7QLmta1txMbxFogbZMETMltQC?=
 =?us-ascii?Q?/jer7h2BpP/ag0JQue+xpac8SZhqZh+e6kP/DMmdpQdS3MflXmWpOSogprbI?=
 =?us-ascii?Q?nFGWuJFnoCO3EPQ/AoUHW0LC1wIFqZMprX9At+vPqlTo2Mf9G482i5vkhi2r?=
 =?us-ascii?Q?MZiFt3TiMyMfV1yLEIrMXrov1UEx68851R753seGAKp8iSr426qIC6nxiACZ?=
 =?us-ascii?Q?mOmC3qUYohirjImOCBk1Uj+lV1pRK9rjuU+nUs2+cotnKlr7PPEdsKOnkB+p?=
 =?us-ascii?Q?wPHBLFnPpBJVuAeBlSxhJ48pXz8fdOVkQpZPvv09ekioAEFqQA1X4usJyOr4?=
 =?us-ascii?Q?0E27ktkPQKM+YfrFdT6srTXdsOQ7I0XnS0uiFId/fZSSnQSlGQifMPmEsCPj?=
 =?us-ascii?Q?refNuofU2lHNhsvBhaMPOKCUF5duWWohxKs/VhIBnBXOALJlXU7441jFg3Kf?=
 =?us-ascii?Q?XiQ0SDaGmp7nzdb5E1U9PSSTcteIuieZi+SAP92G837xGMXFalkG0kHnT1ot?=
 =?us-ascii?Q?8/ILbNmuM7owNBhKxnehk1vv6Q8W5+uaiDYYDa77PdVfksxSRMwhTUOQA30G?=
 =?us-ascii?Q?bFA7Tzf1tOEH0Lsv5iDHlJnJlsa8rdOXZnJnpeC/B0KM/Ej6mdo/0IoKjtFK?=
 =?us-ascii?Q?SIYvWED3Ub4kcfqYtXAiGHXyCBBq29KDqJwnYr/0E+fyRbUyq72HJzhvS8Mm?=
 =?us-ascii?Q?iejxySAP1YthzWQqqovmdmJJLotdQyCMNl+wcI/n/iVfrzCKGePzoIih/0gy?=
 =?us-ascii?Q?N+c3yh3cW003AnhqMLdG355VaHcYulsfaLwdA7fD5MPNX2aC0W7C53wkS/ti?=
 =?us-ascii?Q?bEepk1smpFOfE70wIskDI4iNq3qD6vlAxD7yLg8YgQRkfgiDXQxxzokohQEn?=
 =?us-ascii?Q?NMbu9L5cV2wKg97LO9Fdb0H5EEQ67NSeaL1BCAVcTqalDMurTKUdO83Z8nNI?=
 =?us-ascii?Q?uo4OE4oJw3wlF/qTkzGR7fS1ksde7KKjq9uxl9b85TuHmzR+igj5jbPw7K4Z?=
 =?us-ascii?Q?p5NqC1jvdMg6QdCquRrHVW8jI+z7KBsfMXpjeSgfx5Tisgp55jYOP2alvYqO?=
 =?us-ascii?Q?UFze5h2eIVaCY2qgMmnRzjXAY0Mr/yQnpjVkbs+wPfBWDPGVPEezi7xuK6F1?=
 =?us-ascii?Q?vxL6J0mMB9VGmTf5vj8NVyY6LrWFt6orpeCs/8hL9CnybcEknZje9xkigWpe?=
 =?us-ascii?Q?PjVnZbDJ9nJHxxfBMNHnx1VQc87DMrwFSsEOjto6kBQNsrL7FubqJr1GYvoT?=
 =?us-ascii?Q?A1QkRV6fMUWc2HBjRdcRkxdPS2GyAm72Rc+ZH7APQ4BMp61QxLVP41/uIp8i?=
 =?us-ascii?Q?Gg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff154b95-1a82-48b7-391a-08da58dea288
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 08:17:26.0885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gN4x9V4T3cqViFmsrpTlPW09MLDoxkq7ooDGKulsBlY3pfwJV9wbVkvxZpVIy7y29jOTK+/UzZuF5D0OTLRmi4q73yel44yj/PE+OR5Q6po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5891
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several ocelot-related modules are designed for MMIO / regmaps. As such,
they often use a combination of devm_platform_get_and_ioremap_resource and
devm_regmap_init_mmio.

Operating in an MFD might be different, in that it could be memory mapped,
or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
instead of IORESOURCE_MEM becomes necessary.

When this happens, there's redundant logic that needs to be implemented in
every driver. In order to avoid this redundancy, utilize a single function
that, if the MFD scenario is enabled, will perform this fallback logic.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 MAINTAINERS                |  5 +++++
 include/linux/mfd/ocelot.h | 27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)
 create mode 100644 include/linux/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 36f0a205c54a..4d9ccec78f18 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14413,6 +14413,11 @@ F:	net/dsa/tag_ocelot.c
 F:	net/dsa/tag_ocelot_8021q.c
 F:	tools/testing/selftests/drivers/net/ocelot/*
 
+OCELOT EXTERNAL SWITCH CONTROL
+M:	Colin Foster <colin.foster@in-advantage.com>
+S:	Supported
+F:	include/linux/mfd/ocelot.h
+
 OCXL (Open Coherent Accelerator Processor Interface OpenCAPI) DRIVER
 M:	Frederic Barrat <fbarrat@linux.ibm.com>
 M:	Andrew Donnellan <ajd@linux.ibm.com>
diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
new file mode 100644
index 000000000000..5c95e4ee38a6
--- /dev/null
+++ b/include/linux/mfd/ocelot.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2022 Innovative Advantage Inc. */
+
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+struct resource;
+
+static inline struct regmap *
+ocelot_platform_init_regmap_from_resource(struct platform_device *pdev,
+					  unsigned int index,
+					  const struct regmap_config *config)
+{
+	struct resource *res;
+	u32 __iomem *regs;
+
+	regs = devm_platform_get_and_ioremap_resource(pdev, index, &res);
+
+	if (!res)
+		return ERR_PTR(-ENOENT);
+	else if (IS_ERR(regs))
+		return ERR_CAST(regs);
+	else
+		return devm_regmap_init_mmio(&pdev->dev, regs, config);
+}
-- 
2.25.1

