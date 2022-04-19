Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1029506AE1
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351717AbiDSLjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351618AbiDSLjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:11 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50046.outbound.protection.outlook.com [40.107.5.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB9A205DA;
        Tue, 19 Apr 2022 04:35:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EOXjHqfCGL6aG11cO04gJt3/bxanqtdy0svp94KfsknfxTJdTZBpXrBQ9QKcgyfHSqcaGJcfaKib9KKeWv/sTUimKtF8ScDa1GjwgcSxrsAflwvpJYCUlfAeUZVn/5RCzWpfA5e3vqdkmWw6pqrddlzpXenuuIENY+Q1PFUs0AHxx4ISIyL8E/+2LAMgyZZd39m7WYgTmZQhh4jz9jsRPWKOET/8KOjTWfhq7NbXauQpzzOk3f0BsALajW7ufRGPaXVYVVQ2pwpnUmg0sCV/Zpz8YCj6tgJxM4a7Vat/4BOfsjlIzTAHGM7IeJNgZ6xCeztvucxH1/CWRmF4stPCQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=85UFeRB/zGVi6eE47DWbgwvrQqugErgznrE2LXvLdKw=;
 b=jJSgWLeJkXkNpyXwmDB1FVZ6t7i9N3V69XwRCVlW/yyfhnnn2aCsOFPSBOVCmSliz8dBRJfDga2OEEjnbfOTANEK9pWRV3kFOS0qZp4QEDnSziA63zsp6Yz3NHq4I+kqVmSYyHJ+UcpqRflyfte9GV/+vxZeEG7cZFCYGzQQCLnfdaJZgHsCeGQvYe0RykzxOjpZZjupaU8zc1d1ehZ+1VRW5W/7Fgd/nfQPfs0hGfXfL3lYkvYi6uHdUEJBoZTSWAKVeWAobFU4LrJq6qyMu5Apa+DXPPDOO3AFNAHfIVSvqaE8r74Cl493vOtC2lR5Utp7x6v1k4bVuj5PCsbkKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85UFeRB/zGVi6eE47DWbgwvrQqugErgznrE2LXvLdKw=;
 b=LmfR205eofGfaxyqDfWL70HmQglrzuzgzSuSooIGeCyvooeMo5nIijme+6e1jQ3UoI7zAHjrqeFrMn8+kQw7FZGbWTEqYzhHd6FzPoOiVOCKR95ZkiodfktXg6eZ/MO+zL0rj11eQrdKWSwGLU9+tD58/dtfuk0bI2aLc4hYvZ4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS1PR04MB9631.eurprd04.prod.outlook.com (2603:10a6:20b:476::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Tue, 19 Apr
 2022 11:35:36 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:36 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v8 07/13] dt-bindings: fsl: scu: Add i.MX8DXL ocotp and scu-pd binding
Date:   Tue, 19 Apr 2022 14:35:10 +0300
Message-Id: <20220419113516.1827863-8-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419113516.1827863-1-abel.vesa@nxp.com>
References: <20220419113516.1827863-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0026.eurprd03.prod.outlook.com
 (2603:10a6:803:118::15) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90808b89-a93c-46f1-b3a5-08da21f8b8d3
X-MS-TrafficTypeDiagnostic: AS1PR04MB9631:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9631B7C96F25828D5092E7DAF6F29@AS1PR04MB9631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /zWfksfyP0jHiewskpa1mART5OFQAE2IrpK56nZnB07P5ZxZ/iWahBdYSjIXxhWCic6MzcZrI3NfqhbRkjNykGjYCneqamQdS8I5Xtt6U8r5YioSL+jTVpoNEorZ7X4Tp2mRNsZ6qvOC2hswb5JxqIzqxmaQNfnBk2BDbiRF4noMrZqP2nnQr10kYvCSDWJoOljOqjKPVMzNd3+7fYVYq9BocrPexF7EEhtJwZTChw9huDLNEjj9dnjglbSnM8mz2gWNPBkcUHLN3vTCyY536mUVMlUxiIoBehXXpadcxWRKo+6DRmtIj2/T+/CQnKTo97rx2rhbkHxg1EgVlrNWg3jQIhxFxOBdlxLzC6nIWWLEgKRt9vt5lvRC5Rgn1URYiYYzsYzHRSLJ6lHR630Ar6xx+qKg6qoQqAp8D9db4Z5RliXjgff3pH2tiaqeBUV0XmT2u2W4K/QhxIYCkd9/uHzcFpdg4lsmF0/1sMF+3NA5v/f5rQMazEbVZATsLYL0VA3zASNHztnXYBhjNPa5v/zLRvyDWA8oPrEBWUFhVDaGro/wWq9dfOUiR16UJpzT7tcUVUsFaDJPgFCIXtxAj/vDYLSDH8VcNKh7tKdiG3GbJREzOLGvwRUQuIBx27TXkss4Zv0J68tn1Lg4Tn8yg9gpXVgopu5NtpGVf6a/6vl3RfP9ogVmbUVTSvwZhJp3zvs5aMnnJ6Kc04JvMz4yDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(66556008)(8676002)(66946007)(44832011)(5660300002)(4326008)(6506007)(52116002)(508600001)(36756003)(110136005)(2906002)(38350700002)(38100700002)(54906003)(8936002)(316002)(7416002)(86362001)(6512007)(66476007)(6486002)(1076003)(2616005)(186003)(26005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nEjndfZofFL0u2kA6pm8GyDfkU9EaFODi6FTpHsCD6QE9i7cIxi+ZyGNiUO/?=
 =?us-ascii?Q?FT1TZGgKmIxR5gLNsOk7pOzrYrdGcZ2fSZkdEI/gmBm09LrGHRdrqVdjgjlB?=
 =?us-ascii?Q?RSHWOvnirwAxXze6A8I3lM8WMwit4NpR2/wmEF8k2i64nlZgUy9upomVVTZh?=
 =?us-ascii?Q?k/Qs2XxyE5Tdvjwt0ZWsXfS8ucvyH+p48pvo+8W1TcQNLmm/r5aIG/Lfdhtd?=
 =?us-ascii?Q?NtEwU5ZQE97fiWm5GmkbFSUdDvDXZ+ldUvsT4+KkPE+aFw2ITpOCJrHeynbM?=
 =?us-ascii?Q?Xs35pqJlwhqimLUSoVuaYcyJwePVd/pbHordQ8UuUrf14Z4FG1RMEq6fqsAo?=
 =?us-ascii?Q?fDMr1MptXl3yId0MrKuRa4+/F1fClwhKdGvcTLBX0IkoQ+YxPYRC/tMdOfcg?=
 =?us-ascii?Q?hMETUoykWUElEO/sTLqLW9uf2sRbMy3Tkm2CBAPUnKpYRc5HAxPEdHxtmwQ6?=
 =?us-ascii?Q?m08oKX0DoDOsIJT17jfy7d1DN4iih6G7hdDz3C5iWWRURbLHTRBoH6/Dtd8e?=
 =?us-ascii?Q?Uv56h8cEvHkXtK1EWWtae78+twm/elXatAzUO1X9Oeb2G+eqQxWXEIOlwKLh?=
 =?us-ascii?Q?W/lMfd8vZyfXVtEHU6jnJZHsw0OcHJaDNMQWJmGyC3aDn6Vg4g+e73T5onEa?=
 =?us-ascii?Q?sycYDHqofUyBDcdodPAqVfXG3iekLIK2kw78O4Qua83R+oZ0yFyRrKNLVjax?=
 =?us-ascii?Q?hcw1VUoa2anOj05N/ugoq87m8dGurRQ8GwrsfOo9CSCAusskXlaXxx2G+TC3?=
 =?us-ascii?Q?mP2MceNJmDdRpKyQGziVg8A+V+c4MmB8W8uJqH9ECDIxfmiEJeznhPuP8M4z?=
 =?us-ascii?Q?BMT+JGipXWXG0pK6D35eGvv8RIQ8118t5oagj3HkKnNSQj4e6CAMHqHLRxHh?=
 =?us-ascii?Q?oigY8bgx7MN7R04s0eZrRdlW2o6xrVuqiEudpp0kygm72STIGoQO1O9ySALJ?=
 =?us-ascii?Q?SsYO6/baWxeygguxTvawnwd3EExgn0mN+xyeWmv3QlqeOp+ZqAr5NTlvGV+6?=
 =?us-ascii?Q?imLApD7fya37T5W8jGZJr6R35P2JtuHI5vvQVsU2zgkNgWfTIZ+v9KLE2QKw?=
 =?us-ascii?Q?I9kSaVgTH5hisVonF8okkjFDz2gt8mGcOGbV0PC5Hqkkns9/lnZGUOwqWZDR?=
 =?us-ascii?Q?FAGxfOipXyAwRjugwiGHVejzme0nq8YEuVUpXCsBeZLctGpfhXz3vmLKe/Y+?=
 =?us-ascii?Q?KCepuGZhAb5L3gHPnmmYkYgOvpFexe0SpYuDCliLz4M9gdzzrSs4oYGCiw7R?=
 =?us-ascii?Q?vPXcMCrAfrSV1b4ANc+RF63uZBeY4AqAZYQ+34gwCFJqpi04HiWTm4AgvHqI?=
 =?us-ascii?Q?8fNJKZlIMEDBkUIs3aPdfTF6D69OykFu5meb9cihKwnWz68jq7/wC1qQ4VrV?=
 =?us-ascii?Q?gxL/oXjBQDJQwPxBJAWHtC2siznkJ6XhfN7kNWyfcSVUpOV0OI6YQ2yYRWH1?=
 =?us-ascii?Q?QagwUbcgnuKBhYrL8j4KNIrHftcxs09+MQVcI0RXlWw9QVtBnu3lTCFGuMaQ?=
 =?us-ascii?Q?E43udgTI5P1hQkoHZCzlZqqKbTvRY0b2RLpWLcDdnctmbsys9hmbrCB5MkEB?=
 =?us-ascii?Q?AI0Y3C3s3iWQPSsSDFbLj68d5P41DH3DzUIsrH78LmurFy8Ksd4QXGc6b8CR?=
 =?us-ascii?Q?7BjLXrGxF9ZCg8CQkjaFO/lNh+7VQ8BKWQxMKVJZmY+7iTFP78HaKjhYIGE/?=
 =?us-ascii?Q?KXA2JIRB3zB0+8LgufQrp7o+3URKDPcBy6mEJYUF/7zJG57h5oEIVWbtr5Pr?=
 =?us-ascii?Q?TGixoLK71w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90808b89-a93c-46f1-b3a5-08da21f8b8d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:36.4240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7jzuv1yYMm39qwuKimldnnXYt3zdOmincKA9X2723LbLoNNebMoLzbi688VFfyh94ZdOUz0YTxxa4yUualE7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9631
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL ocotp and scu-pd compatibles to the SCU bindings
documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>

dt-bindings: fsl: scu: Add i.MX8DXL scu-pd binding

Add i.MX8DXL scu-pd compatible to the SCU bindings documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt b/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
index a87ec15e28d2..27a2d9c45b0b 100644
--- a/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
+++ b/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
@@ -70,6 +70,7 @@ domain binding[2].
 
 Required properties:
 - compatible:		Should be one of:
+			  "fsl,imx8dxl-scu-pd",
 			  "fsl,imx8qm-scu-pd",
 			  "fsl,imx8qxp-scu-pd"
 			followed by "fsl,scu-pd"
@@ -142,7 +143,8 @@ OCOTP bindings based on SCU Message Protocol
 Required properties:
 - compatible:		Should be one of:
 			"fsl,imx8qm-scu-ocotp",
-			"fsl,imx8qxp-scu-ocotp".
+			"fsl,imx8qxp-scu-ocotp",
+			"fsl,imx8dxl-scu-ocotp".
 - #address-cells:	Must be 1. Contains byte index
 - #size-cells:		Must be 1. Contains byte length
 
-- 
2.34.1

