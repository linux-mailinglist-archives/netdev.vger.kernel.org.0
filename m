Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67134F1676
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 15:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358530AbiDDNtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 09:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358482AbiDDNtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 09:49:03 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2044.outbound.protection.outlook.com [40.107.20.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170203EA83;
        Mon,  4 Apr 2022 06:46:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ft3ck6V6Vc8dvrrni9gJ8x5jWCPlAHXrHT6x27F7h4pPSBKCW91/HJetCXvM/iM49+agy7gGZXCQxZTzDFyQdf0t/6jl+/AefbFUsb3fZFR2WSUA89Jsi69ldnRpvqt1YpeRk3K5qD68VZZDInAuY98b+qTv04MVnYXE6hHBgwj9xIn89tN6vVSkVwenou0SFpR2asoYaoIlWEMybR7R+A93nTEKpmk8ET8m2pz8UEPBj1T2Cp831jsBel3wx2Oixq7zCFhW5jeyleWdiSCTwwqmfkiD+L6b3lMHywFEZbWa9dmPCd+4wToBk+xEtKpsHHG6fw6ure0B/rEVaz5sEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VjOhvA0lUkCJzHDIBEWaOPiV3cy/hHJUefEx0TvrVFU=;
 b=EmmK84/19Mal/UiaOdBcGZ2x1wxVIQu8lazxyFA1EbIPcG7BDUuUp95AZKMt2E4G4Ny6ttkPF0Y0CE0uhFHHgd1SPHmKyIVjKLB6z2hkZKY8xB3chg15niZuoZm+hmpcjNc0ncFhwsxLECTbSvVlcUeLsuKmBHWTg8mwv10d7Y193u6pr5YNHazM2JIhQa9ZZSYArvF0sjwBsn5Q7uI8EZQAL08li5ORttYf7mCYfXLgf+x2el3h8gz4zBbCAmRp+uPXNP8bTGzPH/bfT7pWXRQ5Acftrc+FFuHmUf5kFQ4aNEM1AarDjOQ4Z5k/hbYe+YAezsYlO3eEbLXRINE0nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjOhvA0lUkCJzHDIBEWaOPiV3cy/hHJUefEx0TvrVFU=;
 b=MunPnXpc5PT1pbD3uE4+TRVCmY9HaiMW/9TWea4r9cscsEYq0BLzUipquTYXhTUiCFskcu8T0DpxxP45cQy95M7lobeA8FB42E+/2/Lp+qLU6M2ZMG1qqkipWLniaQoYdrSWWGo8C9zBm3EHMNlCM+3qPZf/eZbnFLfaJ7WHIic=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM0PR04MB5889.eurprd04.prod.outlook.com (2603:10a6:208:127::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Mon, 4 Apr
 2022 13:46:43 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5123.031; Mon, 4 Apr 2022
 13:46:43 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>, Dong Aisheng <aisheng.dong@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v5 7/8] dt-bindings: fsl: scu: Add i.MX8DXL ocotp binding
Date:   Mon,  4 Apr 2022 16:46:08 +0300
Message-Id: <20220404134609.2676793-8-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220404134609.2676793-1-abel.vesa@nxp.com>
References: <20220404134609.2676793-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0021.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::34) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca62e932-435e-48fc-e77a-08da16418db0
X-MS-TrafficTypeDiagnostic: AM0PR04MB5889:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB58899A15B2FFE7746EE823B7F6E59@AM0PR04MB5889.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mRlAJJroQY6vyf9Evox7DNRxzbf+B6179OxAJUSXNdogXXMB9jCcTO+XA9ZGs/iRSPH1q27I74qqvdA27OZuMe9Sf2xsIrXtLGdcsnRxmHMfk3z8kYcHzb41ajUJzKOAbcvb31Ne3ulGTpnTxxpMRRi3XCnlYiNUEN2O2KtrfOcaKafR1bhjNFXf+ldlj1yHkskeY+DkgcUR2UxqwTAx4v+gecnRQQo2BbgPHoWH0+NePi2VaAp5p99bvwxPfIyqAC6Jhn4zQ3BcCTA7ViWoNtXq5sJ8sEZ4vpObw9GCciND5ZnO6t2yYkFEo+PXOdVW2kNlno1D4p7o/89E2iPYjfhbxLrawkGvO4N7+cpZB01pqr+PcqR8BFrDKLbxs8H8TBcMytiq4HhZgcmtgXGn8MqwKYq4lmoylXGSGeIOPe6iTsV2pGEIkXpXYo1LbJv8VPVj3/klfMMFdyy3t3nOG+Qf0K+DbXFEW3F5/55GtF5LRJrNWplsx42RxQRAJPKFbswkXAhJWdpMcbtyfaHCx8vhtwcrjAGLoGPMtNmZOtt35Yyhg9mhohfxQdHPLHgZ/6Cmip56yybFMB37BFxyzUZRV9Qf41n+Ru0Er80Z1eIXZ2Ttuv6p5TfkbiRfaExxrDvyifXry4bo51jaIkNQ4RaYyTmFeB0iEUsYz1Pl5GFbHVMlbcDhu7bPs3OkBZlCcDyk7iekK110IR9GshFnwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(83380400001)(38350700002)(38100700002)(54906003)(6486002)(110136005)(6512007)(6506007)(44832011)(4744005)(8936002)(4326008)(7416002)(86362001)(8676002)(5660300002)(316002)(66946007)(66556008)(66476007)(36756003)(26005)(508600001)(6666004)(52116002)(186003)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0E7BugRP2WyHFQLtZjzjJbtT9aw0r3/1uaGbz4d81jEMQXixx4gAITbFPmYV?=
 =?us-ascii?Q?FOW11YVTs+LaX8Xkme7PVOQqchd/NNrBRv+8chGwKjmQl9SaPfm39X62IE/p?=
 =?us-ascii?Q?KsKBtfBOX+YMhC5iIGiRpKJN1jkOeGc9oNNtFlj+zmTk0j4BbXeFhD/jy2wj?=
 =?us-ascii?Q?r/+U/XOzn8167j/3fZBMEEl2Wr7umuOT9GzAqjyv0J4+Nhb3TV1pCdykcDah?=
 =?us-ascii?Q?wIhc7MizjW8/4v4w3UaKwEr9IJ5YbJabo4R/SF+V7T8ZY9vdCZEb4LplG4Lh?=
 =?us-ascii?Q?oJN+SA9zh3y0LTkdLKWIa9Y2fx2pvBJxHnSoRpLc0qYlRdL3A05wJKmhnIN8?=
 =?us-ascii?Q?lYFOtOJ6CMHVsjYODaIvJZPNOXBKd4VYotBXhMXILldt2mddqBXNvYfva0Ev?=
 =?us-ascii?Q?qWtqaSxiOvY/zPpucMfpcxOk2LGZVsbZhCveayduwR6nCG8oNkbbchAapgbd?=
 =?us-ascii?Q?Yl2BlIMVMNIliuHwJjuD1pa1trDaYTr/+FqC9BGDAo5JKp6eA9eT3/jglbMi?=
 =?us-ascii?Q?v3qsTmbT2ynBQdo6zXoPuoytz/IXZx2zSNCoWIZmXmkhHXU5AvvFKW2/FUp1?=
 =?us-ascii?Q?Zzt0Tjo6DfjdR9mD8uQKWHZC5N0T/GnluSFKBUPtbpHnI4KfaLdtTVvQTEod?=
 =?us-ascii?Q?FjkgHuXtK2Ce/A8RCnADyiYgujGry4AYSeKI4uoxOGBfq5d6vqp4RBVO4qlt?=
 =?us-ascii?Q?JOcFSnpjbc/oB3UStpulaEXHg4aS9FuYVqS3dlZ04drrpAkK803PJM2lRVDB?=
 =?us-ascii?Q?5lGIgofrLYC68ZMfPvoH9t30uM3oShesc3QdpkEfzwhjJVWv1nbHgTeS7g/c?=
 =?us-ascii?Q?ks5lc3h1plBrS1mcT0z/6tfKPioliljcmsjEcOAjrU0Y6N+TgkkD2cy5QiWZ?=
 =?us-ascii?Q?T7C2sY2LRGlKYGsd9L8El40HOHlByc0iVl2FuTI6gVvwkiY6KCAIfYUGlbrC?=
 =?us-ascii?Q?UdXIBMPBL/uozH+xB72ERZ2EovhHQPTmb7bhQJw5WLcSLwTpvyKrZxyjsVrJ?=
 =?us-ascii?Q?i2OouxpYbvBfZmIcktBTWUO3jfyzyw/noEloPvhBI80na9p0ZRk6F/b9PgNy?=
 =?us-ascii?Q?e+v/gdoGmUMTZcg0wnZ9GIwTVZwn5lXKq6qP767b0ZF2/yavDaWbIE75yd6N?=
 =?us-ascii?Q?NrFTEL2KqiFUjC7CdC4b/9BEtC7zjvHWii5SX3JHeuAC0tgJzuvZKZfp4wbs?=
 =?us-ascii?Q?y6OYIBdB251aOnv7Sc3VkMyY1EOnEFafJDdgmP3i991OOO3wwOciyUdQBJY9?=
 =?us-ascii?Q?6ayKXdoOZv8qy/4uAGjN6vFgiuzCADo/2rRWqANrj1N8GRoFi9TKWf0qdth1?=
 =?us-ascii?Q?xBJOcLjFvZuKrtZ/rExYvPlCUFMphk4g6GF1IieLkZEp+AO6nAiKYgQoiqka?=
 =?us-ascii?Q?kwWp1qedYAIxVu98kRJ+pltd+SONt1c4JgA2EikZb1+kANmRC79N0fRChg3U?=
 =?us-ascii?Q?RfcVEAMnPuVQudTo9IvZgiBOqtLb7qeEGOqSttOxyjC2lz7hfbL4IzAyC2yF?=
 =?us-ascii?Q?twTEDpJATKIBoB+f7S1NjRwEpd4a24U8bCU1gtYkvBNk4Oa36YqhsLb53gAi?=
 =?us-ascii?Q?8gvpw5tqLTGaVWWJv2cgb+2EtgfEW6BIPiWXUX5Y3apve4Jc+WOOqdeRE9VD?=
 =?us-ascii?Q?PZYeC6rI9pxZZ2XF7RIbEQhuff+lF58cCdXFDEMouNRwIdPrLatedugd5pwm?=
 =?us-ascii?Q?bDZDHJkvwmEKHueirehGe7pA7gbXrXSMl4F7VPP5a7MEiBKRmd0tezgA1uil?=
 =?us-ascii?Q?opvjnBNh3A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca62e932-435e-48fc-e77a-08da16418db0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2022 13:46:43.3931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ALqPopc00ln6SFQfilWWs+mclY0YUWcDaH3NsI4RFvmKZi7zKxnYzVSka2jTewtUyr1xmG5e0vVt2IY2tEXNXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5889
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL ocotp compatible to the SCU bindings documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt b/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
index a87ec15e28d2..5603b8a70089 100644
--- a/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
+++ b/Documentation/devicetree/bindings/arm/freescale/fsl,scu.txt
@@ -142,7 +142,8 @@ OCOTP bindings based on SCU Message Protocol
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

