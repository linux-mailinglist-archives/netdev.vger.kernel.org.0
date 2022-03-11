Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AE74D61D9
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 13:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236695AbiCKM4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 07:56:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348662AbiCKM4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 07:56:09 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60079.outbound.protection.outlook.com [40.107.6.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43E641BFDCD;
        Fri, 11 Mar 2022 04:55:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKcPC+zk5bBRfNoXAUSC8xMO5WZQH3GZFRfdifnEZadilv2boJ/fxAPpDTVpoWrN8QAqjnUfShiCiwl7eUo7y3K3Gy9UI5v2PzLkkrt5naTw+s7dOpKxnHYFnfn0wl4p5jVII8QZyQ63TAm9qZoXeL97jLbyB89JNfc5Pxz68Xk/L2s/Qp2jCmR2J6TAeVkppVo63TduEZMKA9mzaeTpwZbfKCwvxdByCjuzDE3SKr56rOrELSbb8FbF9jSeNW9jCxqEaxKLUwOuJBITjwTZ7/avybbKanTOz7w5Hfp7ypkuJhuiDPizf1pAvnC3kCoYyV2b3mqDrhEnxhyWEERqhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KB+Zp7eLioZvZ3BwE3OyUisFriyX66ZtMx0rlCx/IFI=;
 b=e4JXvziaBGL7JN7BdcTV98IuAbYLantkReUfP0SJskEAMPYuQ9p7b8aX92fmA29yWMT6LYHS6T+F4OxJoXurFmgWWGmang6LJm12d5qYDfpyM4OieDP78X+CvWtPy9XoEfj+KtY7ijFpIF2Do2hZODPrnbQtDUp+ofYwdUpyuTNyzUFSDbpOlwMp+HJzbND5LbjPNppIMugo8c9vh/3lkjlVEgP5NcNEzzH+FZxUGnPW35GpFYOzZSurCRT0bsDY/1PtRPcOJ9NiUSYVy5Nm/bRdgJwSHQ+SXhvAA5UNjd7/ovBhHL+cWfMG6XD5tjOGeZXWSHD4rdSOtI2dl7K4Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KB+Zp7eLioZvZ3BwE3OyUisFriyX66ZtMx0rlCx/IFI=;
 b=aUKUuAh5IUiaEDUeEaNFp5/k87E82Cw2/tgllhpKcmAwjlQGAa4BoGYOYfIbGHwaqmA/MArQhuhe4OjmVgdnJRwWrfi3v7pQtx8Rab+pWQwYXizKwWeRTWKF8TEF42IgH6xiCdcEnpa4ahX2bQE2LZ/6Z8FaKIMGVg4EPmhUTQ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM6PR0402MB3431.eurprd04.prod.outlook.com (2603:10a6:209:e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Fri, 11 Mar
 2022 12:55:02 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Fri, 11 Mar 2022
 12:55:02 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v4 2/8] dt-bindings: phy: add the "fsl,lynx-28g" compatible
Date:   Fri, 11 Mar 2022 14:54:31 +0200
Message-Id: <20220311125437.3854483-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR0402CA0014.eurprd04.prod.outlook.com
 (2603:10a6:203:90::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a21d6730-c05f-41a1-3f5a-08da035e5b65
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3431:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB343176200D428DD607D8E6EAE00C9@AM6PR0402MB3431.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5GRnQRMHX5m4DGAlNfZ8fmCU2EdmifrglU4cuih/x2n5Zj3BBiZX1pPNVyW/1bQz+b3u2bbtx/jNfzQVx1GF7ZVbGFRAdkxWQ2DuPsA977xmBG6L9xBt4BFYzfwK5FvPdIP1E5tY4BWq+AvT5Ec+4OU2N3DIILwQPqc1LB4Q++3vqihzxvCPrOTIjeL5IueDaQ+Bert+XdmcXG8YEfYGk5hrosh+fig9jk49VkvEWHtzMX3ZDVsoeV28ewYXL+2yQFcK5oSyT/1YP7KWyqBH1WBkOiMNC/etltZvf63sZorY/H5W7hqzhDE9WifkhdJNwUD1ioTbhikZ6pSrLFnerIcXPgyGvhy/W3bgdPSQSYtjcyB6tIaoY1dyKDT1M8npUZfUL9rOPFcUD2HjYhY2nV2/K/0ysDXIEFafv/adbErNTvB9Ut2/bHKlis34l/AOnt5gY2uge8Inx4PpsZuif+EAzHEUlRpIXp5Lpkix73yHdDzAgVfp6cIJp5UiQPCR9UiFOMdc8Jyn8fhV7/B0r5kFrDEkw7J36HDN+FV0ADx3qpI6TDIFCApmbjC422mIY5KJVWjRZIM/h7SO4XxcxxMBC4KRLbk5O/bjFxUFqUQg3aBePUFcby/LeM7NOCBgcFiAi8FiB8rqWRYW5NuElU/htmZYabqLciecc5evWjRuzUat7QWmmeMbxnWg9UWUb9tel/KcxknshbscaEU6kaDGCSXj8B8dVzjQcbR7nkRpFJ0O7kFKSYCf60r+RFnhGfnHXLwHf6RZ9QD0m57Qtf4EjAb6lC827ziW9l1Y5l2VmD7Fc0Mr856XWjZnAOyO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(66946007)(7416002)(966005)(5660300002)(6486002)(8936002)(44832011)(508600001)(66476007)(66556008)(316002)(4326008)(1076003)(2616005)(6512007)(52116002)(6666004)(6506007)(2906002)(26005)(186003)(86362001)(36756003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FUaxpdxpaG6Ao76P8FlZVYO+SBxSKJOHgBkVVy/bz+iicymHIAmm6/To1U0f?=
 =?us-ascii?Q?3d99kSUfN/wdYLz0oQXsUGHCa5iTjcJQRD5tlMpzTUayfX7XdEAWDkb2qz7j?=
 =?us-ascii?Q?wGrgGKjPU/6Y331lVks8z18MuTtNBN2IfeLA1BXkGUnw+qtoyXdo4C+a6/pp?=
 =?us-ascii?Q?d95pYl1ntloFzYBj0bvIf0hBwmlzEe92axwTn4ylKnv0FxHgvA10MSkaFVE3?=
 =?us-ascii?Q?awgg18cHkR8LUuyIf5bzSm3fF9d0suhTaRQkTi2WllWin1a+eHrHNEzSFBBV?=
 =?us-ascii?Q?INhPGEAOmPok6CNjwZEQgx/oyueYMc7YXeAPKKUPNbhhdcVg38Qn68sNESMb?=
 =?us-ascii?Q?JCVTnNrRM+QBkbguJrTLX8QOp2aCOGwZm8j54k2pls+O1IfTCN0lMC7Rxdnf?=
 =?us-ascii?Q?9gt8X2NxZ3JF/irj+BAjqNkKDiOX9H9whIMTRWKT3Dv75Z1Oy5Ich/avzsXw?=
 =?us-ascii?Q?0DgJaI5y9s2bDH2PNv8Fl8bfA5EsVCCtuAHRvxx87dUv5NzEVtTH9I1weO25?=
 =?us-ascii?Q?QpByRnN5ioHURb/N93Crw9i4zztHPi/RxLktdb6Ys/OwbnZZuXo6+U9c4fkn?=
 =?us-ascii?Q?qeb54FoBP076Gcxtaf9INNAEXdFuvgejsyeeP6rpWyT33WuFOCQmRnIeG6Os?=
 =?us-ascii?Q?nacvzVtqdtlLxalNfZYy3YEoHFKi4L6dP9/NeYt9HVefyiQbRmnNgvxdptwT?=
 =?us-ascii?Q?g4TBxRMJi45vjsXnc41x7ylVJVYQUrjSwIeyHc46a6Cm0ZDrA4mvwpsDCs/A?=
 =?us-ascii?Q?gH8Ii3qnev350iFZOS/Y1Y14s0Ot/ly7wmlXf7qnE/zA14EnWQwa91AZlVZa?=
 =?us-ascii?Q?hPCjNP3MawhjnZJIKt9Fdoom2ufjFOQRmxWSv9f4y4iJ6sFx2zd90BabnENo?=
 =?us-ascii?Q?xIcAoBCiDQ6P84blyn2JgfFZnu6JVJR7gqHld9VAIE+IXHWGZ2g6z3l/vObU?=
 =?us-ascii?Q?tqNqYByw/TOf6uX33u6xa168+VA+nSCdoRa1rC8kcEKJbldd3XyK6/k0OBHg?=
 =?us-ascii?Q?D6Dig/M5tKyY448TvIrdpHxgsReQjT5swhUHqbN5Yk8aU2DexRGr/mfk8ZSx?=
 =?us-ascii?Q?T2ih65lVIZyqVxIluvq537C9NaJ++Q1zm+dsGyZK7DwZbi+Mx3T52uqOuymS?=
 =?us-ascii?Q?esKqdF+bnwaCAf8R5AtSf0akCbRwRV9KsVnphb2iHzB95a591nqW+v0hxtN0?=
 =?us-ascii?Q?uw98ntB2w/m9LI13LJmn1ULsNPnkGct5axTKMPEA/HVXIXlBj18/79S3i5cz?=
 =?us-ascii?Q?dnAOukYrugRoEB4FVfinkteeLs138kRkOGMWXxLZuakVXnnELfljY8lbtS7T?=
 =?us-ascii?Q?k0QUkDsvFOBxYVQVAmLLVU5h3dx9mLlES5wrupYastWpFDyOHtBGKk6YSUh+?=
 =?us-ascii?Q?d34svsYpxdakT6pvD3W7ieybTsLeE2SMT92JwD+GVLZRPrYITuq6YgKOvBGT?=
 =?us-ascii?Q?p2DZutbWhcDOL6MfIYmps7Z1UMkHKd+N32zZWOsnkEXEiIoIJ2AkoGRS/3PA?=
 =?us-ascii?Q?L/rskoG/Z+PGUeZJdhTI2VJ+ZSTDuPol7r6K+PCziNxQNB9y0VJaQoWUP6j1?=
 =?us-ascii?Q?7WxFcKnjEQ4qgSRDN0hg/gNJNjsrP3mlWvUtnrAY3C4vwDrd0yp0B6NZ1oFa?=
 =?us-ascii?Q?ZP+bJvo0nqdsnOsRKYcbKuM=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a21d6730-c05f-41a1-3f5a-08da035e5b65
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 12:55:02.3704
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cw4waVkOLEyJI0QUk0H+wB0SEkI5ok0G5E2WpvdmZu4sUl0sRFV215eW5SLuoKr84uDoJryz8wiewxyfQ+FzKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the "fsl,lynx-28g" compatible used by the Lynx 28G SerDes PHY
driver on Layerscape based SoCs.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- 2/8: fix 'make dt_binding_check' errors
Changes in v4:
	- 2/8: remove the lane DT nodes

 .../devicetree/bindings/phy/fsl,lynx-28g.yaml | 40 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 41 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml

diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
new file mode 100644
index 000000000000..dd1adf7b3c05
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/fsl,lynx-28g.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Freescale Lynx 28G SerDes PHY binding
+
+maintainers:
+  - Ioana Ciornei <ioana.ciornei@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - fsl,lynx-28g
+
+  reg:
+    maxItems: 1
+
+  "#phy-cells":
+    const: 1
+
+required:
+  - compatible
+  - reg
+  - "#phy-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      serdes_1: serdes_phy@1ea0000 {
+        compatible = "fsl,lynx-28g";
+        reg = <0x0 0x1ea0000 0x0 0x1e30>;
+        #phy-cells = <1>;
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 3e76c8cd8a3a..3aa185235a52 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11340,6 +11340,7 @@ LYNX 28G SERDES PHY DRIVER
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
 F:	drivers/phy/freescale/phy-fsl-lynx-28g.c
 
 LYNX PCS MODULE
-- 
2.33.1

