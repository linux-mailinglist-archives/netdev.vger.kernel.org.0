Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5121A5886E1
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 07:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbiHCFrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 01:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiHCFrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 01:47:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC24F275F3;
        Tue,  2 Aug 2022 22:47:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MopFt6CFo/1jwPN8RJYbSIC7ZbMyM+HBJ3Sqx8ro/Fto+mgyUKmTaCxIiNyHfjLoNEcWZYbhfK8qlXFL1B8hUKBnnW5IuJLi5LhKEVxzRXQTtobIeHNNTdu6BDCZQ2FY0GiWPEt3art/QC1IEJzAgNmkXH1diq7RfZwWzIclbWr4V1yIGoJVGty80NzWqkqed7cNbIpWCJjj6wCtiENzhtbxk2u48tPIlywWiNK+GUy7rzpUvCelw1KvB4vJP7TyuRMUijl/qBdEc8WW6LW39OBj0BHP2tPwB0P76HcNZt6XE0y8wZttRkiOlXA4/y6xYIXjpaA9FZhwFwmEIGw+SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5/XcCw7ZF/2dEB8dgem0EIgpd5fGnQGzsj6FzPHDvzU=;
 b=P1xjTSwkzakoLZYUv5TKE+NjrTUk0rgj3l+ttyoizUlTYhianNXZcQ3uYpKRZbRsrIynGy4RtXVT6DYkI5hPM9qlz/G43pKNhjl9J0Ri9udwxDYN46aYSOdM+JPhDh1zviRswtyYW2r42G0rKvticccclJ7krJPOowBWiVg2FKEm7hFdGU0BELqQSUb95qquFM/weCbWW2BcaHGFU/etiE3Kzg8FxwjcBl91yqTeP8m0juhe/jpBMNWioEUnMUGval+ljBlVQdXZuvZNC/4QV7f3K2+eUYCR0bXLG9CqVueeJPQ0wDPpqEIBq5E5D9G86BqTBkPwS3T0AQPd6Zo97A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/XcCw7ZF/2dEB8dgem0EIgpd5fGnQGzsj6FzPHDvzU=;
 b=Kltx0wvMQAO8mO0KGoFXzEK61vXVsRolEUYOhjD99S2BvOe42ZGDUnV8uRpQAG+Gg/JDaIRV8wu4h3MQRN92MGhaqCjdUMf6dd6YXx+K/W/6GAfBXnsWLIheeGXHl+6SbAMs5ArmUEZhRQjM7+p3+UPikYvLq5u3rxaRH8TShuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB6438.namprd10.prod.outlook.com
 (2603:10b6:303:218::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 05:47:44 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::b869:6c52:7a8d:ddee%4]) with mapi id 15.20.5482.014; Wed, 3 Aug 2022
 05:47:44 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [PATCH v15 mfd 1/9] mfd: ocelot: add helper to get regmap from a resource
Date:   Tue,  2 Aug 2022 22:47:20 -0700
Message-Id: <20220803054728.1541104-2-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220803054728.1541104-1-colin.foster@in-advantage.com>
References: <20220803054728.1541104-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0026.prod.exchangelabs.com (2603:10b6:a02:80::39)
 To MWHPR1001MB2351.namprd10.prod.outlook.com (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00ab748f-59bc-49bc-633b-08da7513b00a
X-MS-TrafficTypeDiagnostic: MW4PR10MB6438:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5dz8K3z0wr5aGwlQ8MN47Zf53V6b/phzNGtVMAWWm+xrT/uAXsDYSkT6g+19eRcFCwUsIidHfTBhkzCBTovo6S1vz9aw4Ia/LOs5AYqkwv9IZcwZzPGZxqyzEhkNkl8wrUnojMuTnXvsYXHW9brd2T8YNxlg7TQTHGlAwGdIbRGvEavqps1AcBFFuziou9S1RAlLAm+96Vov+ugF425UWOdZC3JvpqlgzRbTyxxcN2EcO+dn9dVbgH8rUc9IPrEyo4O1+GKxrCpim+6LIPZ6WEiWfDlPJjr0OD4gFv6w80rHUtHPL06TLYxMLz34JdtBBfjJ2rGeWNfMDG5fJm3dS/2CWqYNHWxl2zRS4LkH4cDfnq1STpouWbsqLNjSF2PuOgVN553+nu9x3+5AP/S/1AMJSYarU8+TzAamI40o8PyHrZL8cbFXvOarvyhfUL3ocLDehI4pK2M/E0WTMFm3jBAjrj6Egk1zMqGpHZE1pvqeu90QUNvqXWvyjqpVezYRS8XakJG7OMcDZ3ugByhfWEC+cKT+Ajt6OVt8/7KU8uMce+f+Murs2P/UAzKap2AquxwoEeInj/gqBw7uFX8z34N/Q8MfI3c65YQSnUTGtsf7YDSKOGTA8qW+YSs0T8XBVhXU977TJ9Ekt/MlIkrbUgY1UvGzW0uprj9DozsfRHIhLn+T/5qLoxC8Jn9mqOUdJck0ttm1H+ZepZyUgSZw4GsxLmc1mepM8oaeQhoXmj8WGU53NtZSudX6ZrQ42VlFDgxxexS2k01/FK4jK712SWF7eUnjJI3TMXV7//HABpc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(136003)(39830400003)(396003)(186003)(41300700001)(6666004)(2906002)(6512007)(26005)(52116002)(1076003)(6506007)(107886003)(2616005)(38350700002)(38100700002)(86362001)(83380400001)(5660300002)(36756003)(7416002)(6486002)(478600001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(44832011)(316002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uxlS4Zcy0ZFe48H4Bv/c13Pa55HTP7CQtXhM1FMOuikz2mx4eFEnhJU3OF2N?=
 =?us-ascii?Q?Q6wmQfWo0JQx8UXZ+SnOgeGtHetkD3gsnhyhfvXn3Wf0r75nVuFqpT8+mDVr?=
 =?us-ascii?Q?H9OWv4NemVuh6eZwrqDDCks3w+9VR0Eme5IF8Z7upQp13p0wFFAS2f65GLdU?=
 =?us-ascii?Q?UmqzAJcABwR2a7DZ+WcAfnqvxNINc1KQtwPSDD6zE5mtmbRxZ6H3s+Kqcivf?=
 =?us-ascii?Q?vBWS4rKXJcFxBrbhsxmte48uJQ6FtfovJjkZukW/zygt6quWnW+MYzkOG7Yl?=
 =?us-ascii?Q?+4UMNsBRmCCaRoUTiXOoh1pmTVAyGAOHEerdD8mUo9fYEfqnVOlIGc+vRSsC?=
 =?us-ascii?Q?Wv29Bb23NO6kzYhUj7kaaPzknwG0INO/SxZ4Rk6jXYSP8oQrOVOB2cqx5uNM?=
 =?us-ascii?Q?3Q/+YW91UamiP1VzQNpAkE94JdyGP5NuzyWxgNiJTBqSzYjxW+Hh2eRcHntR?=
 =?us-ascii?Q?Pta/+d5TCR5Uw/qGHus2FqmYJq7Eoel8povlC6mNDKEcfOcwdaiyHPZVUPG3?=
 =?us-ascii?Q?6ZaG/WCcH/iFJWiD4XnVO5HDX2tg3OeFIByxAhvMYM7pscypt7Nl3eb6a2IF?=
 =?us-ascii?Q?16J7v3fgaw8quNsH/Hvmjly50ZILuwBpJBgrrYpaCqxY7jMyQP5onYypwDrb?=
 =?us-ascii?Q?n2twMx3vfb3bnD04tNsrve7PhlsbcA5qtcV/Bfs8LX6HjnT+7ZHGjBP5kvYb?=
 =?us-ascii?Q?Bg84ua96If7nqbkZ2eOHjw7D9xD8CTlmPFub3GbKRdaOOFAiHj7Bs++ff79s?=
 =?us-ascii?Q?FD77nK8eV54oakadh85SyV2GTgAWnZ+19dfwY87no/DFzj6wN9HTl3rwQZ2J?=
 =?us-ascii?Q?uFIY254UEYxz/XtC3qYig5lN2AlTmJnfKclidJSVWL6Vp6zbiTgrP+GPjPKY?=
 =?us-ascii?Q?EgdmIM+PvNuqUqScZgvtCticb3daKm/zOJHRX8F768iFAJSli1pbsYTLDvSG?=
 =?us-ascii?Q?PUYA4cr5MrZ+YaLSbq/yFjVgLcZPtISTCGonSEnx2chniPvyVemOMWwtYPmp?=
 =?us-ascii?Q?dOwf+JuHjC2uxt8QApM7CdgAmjLgI/GJ1Idv2daqhUf97OHWy/sZGgro6B2j?=
 =?us-ascii?Q?GtcxEooiVTvB/UF3vU4pYfMRep6WmiBNRmFeKrWb//InlhBrg/8yBI+9m1SD?=
 =?us-ascii?Q?iyOgq4Ko3vaWgIzy1qv96OoZ9VLOUTOYmFFRs8R7ls/wuwxJmU6VdW+bZDG0?=
 =?us-ascii?Q?P5szlDi7BJ3DF1Xcvx8uaei3YzTI+uEM4ceb0j1e5IZmII+tsnPynAdi4u89?=
 =?us-ascii?Q?OikFKFsXhkVJtWQKiY+Bx2Kn12OfcDEa8L4uWof8EiHARWsFhQAJaOJocWQP?=
 =?us-ascii?Q?Hl3PvhhQ+UcJPZzSYeOtvZd6YP5CJ6AGjH/gbiPLabnvqNnCbBiIqDuYI6Tz?=
 =?us-ascii?Q?xj/+Vgj0FgPcDVFzbFGqNTxphZ62JLfk6q5BMYsRMEBwfrMsEJUFUZmnWfvd?=
 =?us-ascii?Q?MVuIxvu6nqrSJg2eZBqtfGCCzX7wx/29h0gHfiWXdg3GzLXjP3cqOnl824jr?=
 =?us-ascii?Q?AEQ63k4M1s05cqK5RPYfMQLSgg42Mi2GsyxuaHpXidPDWVqBszHt4BW0L/q1?=
 =?us-ascii?Q?vxrajkQOItfTXHL5m9iIjLbwCXadb871Hx1lBnrrq8VoG9gU3cXwaPLhDvrv?=
 =?us-ascii?Q?nA=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00ab748f-59bc-49bc-633b-08da7513b00a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 05:47:44.6989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bm/ti1ZaFhphUdZBQ30Cdh+xL2Trp9NtLxgFRNcT6bE8nC9AHYuZXC0cYvyUlwB86YI2FByGhpW+s+MrLUOkyIiCLlLpCTgj7scbPZ0eFPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6438
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several ocelot-related modules are designed for MMIO / regmaps. As such,
they often use a combination of devm_platform_get_and_ioremap_resource()
and devm_regmap_init_mmio().

Operating in an MFD might be different, in that it could be memory mapped,
or it could be SPI, I2C... In these cases a fallback to use IORESOURCE_REG
instead of IORESOURCE_MEM becomes necessary.

When this happens, there's redundant logic that needs to be implemented in
every driver. In order to avoid this redundancy, utilize a single function
that, if the MFD scenario is enabled, will perform this fallback logic.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---

v15
    * Add missed errno.h and ioport.h includes
    * Add () to function references in both the commit log and comments

v14
    * Add header guard
    * Change regs type from u32* to void*
    * Add Reviewed-by tag

---
 MAINTAINERS                |  5 +++
 include/linux/mfd/ocelot.h | 62 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 include/linux/mfd/ocelot.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 28108e4fdb8f..f781caceeb38 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14467,6 +14467,11 @@ F:	net/dsa/tag_ocelot.c
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
index 000000000000..dd72073d2d4f
--- /dev/null
+++ b/include/linux/mfd/ocelot.h
@@ -0,0 +1,62 @@
+/* SPDX-License-Identifier: GPL-2.0 OR MIT */
+/* Copyright 2022 Innovative Advantage Inc. */
+
+#ifndef _LINUX_MFD_OCELOT_H
+#define _LINUX_MFD_OCELOT_H
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/regmap.h>
+#include <linux/types.h>
+
+struct resource;
+
+static inline struct regmap *
+ocelot_regmap_from_resource_optional(struct platform_device *pdev,
+				     unsigned int index,
+				     const struct regmap_config *config)
+{
+	struct device *dev = &pdev->dev;
+	struct resource *res;
+	void __iomem *regs;
+
+	/*
+	 * Don't use _get_and_ioremap_resource() here, since that will invoke
+	 * prints of "invalid resource" which will simply add confusion.
+	 */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, index);
+	if (res) {
+		regs = devm_ioremap_resource(dev, res);
+		if (IS_ERR(regs))
+			return ERR_CAST(regs);
+		return devm_regmap_init_mmio(dev, regs, config);
+	}
+
+	/*
+	 * Fall back to using REG and getting the resource from the parent
+	 * device, which is possible in an MFD configuration
+	 */
+	if (dev->parent) {
+		res = platform_get_resource(pdev, IORESOURCE_REG, index);
+		if (!res)
+			return NULL;
+
+		return dev_get_regmap(dev->parent, res->name);
+	}
+
+	return NULL;
+}
+
+static inline struct regmap *
+ocelot_regmap_from_resource(struct platform_device *pdev, unsigned int index,
+			    const struct regmap_config *config)
+{
+	struct regmap *map;
+
+	map = ocelot_regmap_from_resource_optional(pdev, index, config);
+	return map ?: ERR_PTR(-ENOENT);
+}
+
+#endif
-- 
2.25.1

