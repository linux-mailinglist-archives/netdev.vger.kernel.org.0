Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AE353FD5B
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241550AbiFGLTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242844AbiFGLRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:50 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130049.outbound.protection.outlook.com [40.107.13.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B024EB1D6;
        Tue,  7 Jun 2022 04:17:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bB17zz/lqxup7xCHnObrzREQj42EZ/3ytKlhHtOOri6d1cut+QH8fRW2LfEbyUv6a1dJesSib0MaovI6eam9/1QCUphPnVjT+ksMqTnwSyWVqDSv3AxC+FS8r9SmI69b9EwLv6rU1mLmtZpjDp0OMSOk5EwYK8LFGhIuAxIn/um3bCD07zNXzenokBT984SuVmUMjE0N2EQErhhSY64Uj1zQXw2lKw4LrMh56MgKxKA60PWS7jJVJZQ/CekGnvZ5M7QqIm4tLn036cH79fXUYxmMPfzutsOk2AgZfBGfbhpHiMdzKgnLm3NXUyMr8BjAc2vSaAFiclzU2EI/v4CJ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dEDJjYycruVfUURNiR3+/6h4yGZi+ypNcxJmP8i4Lu8=;
 b=Y+YgyGT5UPVr8UmR8ezvePy40d535K2pRfu+tzKrKzk+qOjo/fArgAd1CYyvdTZQevs5X49Cd7+fH8aEM8zOXlV+laZIV/9q0u0CKQzDEoflPjbFAtzUW2sHFDA9VfLrDfZOl7qSMnykZdaqSJKNVUsD9ILj5SBqV8F7V6IviAqstXhJZ9gCJCzYIWlaH2ZtNK7jWvd6eiV6N/3iPxoc2fBXxSdBc02rDjzx1mBCKX/B5vgxuFdixJ5PVZDSLlNauQhNn+qpo7pl/DrSyLdBXb1yFpLLwWN6V2R9n7pwifiyvPPE0xIe+52XfEm83YgBZ8j2mpW+5uervor/Rapr9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dEDJjYycruVfUURNiR3+/6h4yGZi+ypNcxJmP8i4Lu8=;
 b=f/rAD7ziHa3a+VZZaoSWP6PyAa4UIWYWGscHIDN0NwOOurxkpofEXX0+IOF3u1r7cLpDPRhZJH1kJFTCbWU4mT8SlvNym2HD7r/hbsUXuU5cwjD4tW3BLXrs0aiWJMLWAQb/SxGjzlEWDthL+mbhra93cRPqrPAWL4uR2jq4CSg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:16 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:16 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>, devicetree@vger.kernel.org,
        <netdev@vger.kernel.org>, linux-phy@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dong Aisheng <aisheng.dong@nxp.com>
Subject: [PATCH v9 09/12] dt-bindings: usb: ci-hdrc-usb2: Add i.MX8DXL compatible string
Date:   Tue,  7 Jun 2022 14:16:22 +0300
Message-Id: <20220607111625.1845393-10-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220607111625.1845393-1-abel.vesa@nxp.com>
References: <20220607111625.1845393-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P195CA0028.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::41) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b81b38ce-cb8d-41b8-b9af-08da4877473e
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4890C458AA981C9F50E6E65EF6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ufKPakbmRSBXm72nV5v6eH+Av6M8pHVcYwT0Da7gNBYu6DHqNsvzmZTjjoGsmEV8sTb0wNrwN6Xq9UFABEyHVZE/IlgRDGauP9TZ6bw0YAJ6bTouD8ttdeSTSkDx7PF8RHR8t1NQW3Y8ka1eCOb3oKI/K90c8tOY4YYWk3jK63HWFvSeAq1g4wnZ0/pmNBM7tLuvcmiiJSUo3sLZc8DG2YV34OfDFJBsxiGK/LqyOrgeoWZ1hEgjaHd+ip4s4GmCclmpji30z+nInuH1q3/ScE1WjuqtcZ0Y5ZvrKL56nac2bvQsBlq7z8uQjTmzV/0eRQGjP8V+1dRnz20D0U3aPOa8d+XzTWZNgJgv64DRnJRS/NnhAxkAv2AImjcoWBIh8Yw4y6h6s66z96JKG3ali8gGofqeFzqheEuxA0LLc1tB3ZzHhTC3UPbXWqcSjkswS1O/R8OX8MOosHzP6bOkgzPIUtQMfyH488DM8os+1sCXuSJCX2CZ9DUstkKYcijhZ8aZEFAq5cCn5HkOzyG7qlFbcibsrS9BRISY+A277M8IahMXYZHgZbRU7/nnxB0s7o/8PacfpR8nQQ+980P35okJcuZCrrHvjKbm4z6dO0QsyqkfHYp3RthVV/kcUJM1NimXGqudR6g4VIcDXboaDfdEMHevAzuWLbJOwuvlDX2M6wxbyZP1a21kd3TS/FdA3AgFRdraTfs/1rfcsTtKkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(4744005)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(186003)(1076003)(7416002)(2906002)(6666004)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U5jR63Pprs3n9nodFIujGcN5ztiqSIV4t0rj9gchQuaNvCMcYPdsSS8pABEe?=
 =?us-ascii?Q?y+v/2pCJiqr6p4OBhgWyp3y0lt6UJ/pJQxGkrjsnzZUCkD6R3SC6M3ntoWBp?=
 =?us-ascii?Q?gZxuluzN+VFTN45czAL7WMV3i9aDTk01DiZqQ1zOoicX2UfYnd8YDkz/mxwd?=
 =?us-ascii?Q?YvW/f9Mh98+yVKHGvpodM71w3i29ckN1B+ao6fhJVylGbkTAjWmtlh+UziQU?=
 =?us-ascii?Q?pL52WsIEjga+XRZvtHfOnFAMti4h8K+6P9Shn8PQAaRs7qoj2YtTc116OIMy?=
 =?us-ascii?Q?Y1eXW5HxTM7bh3ch8nKAidtVvuVBouLL0ulwxf1xws3OQ1o1/3aCvA/3CBV3?=
 =?us-ascii?Q?JvcxQ4SnWG1DbTHeJys4Fttwa5YLgyIyXN2MLCs6noVSYAhLNrbrjJi26Djg?=
 =?us-ascii?Q?EyZYbMeKtB+wmtpWUtRExZMKfTqShmTaVloBpQIkkFAmOjUsn263ZohHHaZ2?=
 =?us-ascii?Q?R8LPFe7fti4e4QFv6rnZBnsUReZwQO3mSHzapBr90JZwyxgQvjY2KZtNmLEw?=
 =?us-ascii?Q?ne0v9bcDtuqOZS2A8SUtzKg2KanxI8lJkjBO/2grOm+8bSftJjjOyiniZo1T?=
 =?us-ascii?Q?LgC9Jw9oVyF13BG4iKxsLYTiMXDUjV21xHOSVoKBEgV610IfbotzBJWavR3h?=
 =?us-ascii?Q?itJLEkT+9YiMNzcNOBLYauajnpZrVURjWgbQNC7/CVPk/E9fB8+TfuY7ZGJr?=
 =?us-ascii?Q?UEwawZn1l9MylOkoK9R46sj3Si/MNNX2jWu2n8bV6z/MX6h+q1D2p7nwW2B7?=
 =?us-ascii?Q?9tjSop/OhxEm9YtzQKI3k/TGaAuJZ1YpYsiZaOA22yXOMyAcSyhMD8x2WCBo?=
 =?us-ascii?Q?QNBa9xUua2Lt1GtonIN4vb5v8LBFl0uDkEiAsFybCG9WzJSxSlBIa6ceCxy/?=
 =?us-ascii?Q?YK0s9UYZQ7ch7DL4b9snL/yybkZMQR58FHtEQKApvxZLKSTHRunTUtvD7SQu?=
 =?us-ascii?Q?ai7unuHMrrxf/e8uCZunkgQ9Z8/rmS7BdpzS+AO+XSaWTLYTWyQo6yKmahdC?=
 =?us-ascii?Q?Ei4yjs7IYmJba3L7hagTDTqHBzS2f3X7vrOxR/5I7YYxDJnIfkCDEBDl+9X1?=
 =?us-ascii?Q?ugMCKCAPmxvZC69biIeT8GfuMAe8gSG9HEupV8j+pXBdGbtdETWGmyrbXAsJ?=
 =?us-ascii?Q?sWpSJnIzFl+hRKrlHe1T46Vm4UxqceaGVZI1G40zhq9Tbwr26WZtNl2/p8XT?=
 =?us-ascii?Q?CaZ76hM1GgUIEqGUqxEflf0i4Nx7n/bk3SFUtls8HUMoOc3FKbuSEuzLR8AR?=
 =?us-ascii?Q?K4PVNyczjfwg2oBpEpoe0qaOCooUt5ImkAHiGNL495nQnwNLXVf6T+0fbB+l?=
 =?us-ascii?Q?IpMUlZBF9/nZ6X7WJRMRlR0rgwRUQkawcpdcNTI64jUDtC0tqmhBBI9UzjLX?=
 =?us-ascii?Q?QsYlttwtMZXmo+ZmILBKZ7aHy4VJ47szuRYnJshkzaIWdwh7HpXyG2eP5kNe?=
 =?us-ascii?Q?/lRLLDJO6Y4uQoBhfLSlKV0/O3g7D/UKK06beqwspbJ/Eit/c2kPMX439Cti?=
 =?us-ascii?Q?YcWQx8RkTtwnXI8zKVBYj/XTq14VgxvhSwm99N2CNDAMY28/oOC35PnUrPUs?=
 =?us-ascii?Q?VOES5nMfgT9+LxRjtn/BzMSfszNmXQyMJjZK4hgQ4giIgkdCoZy8uHwZTLFX?=
 =?us-ascii?Q?vhg+d35g4Bt1ea6fdkBCcrVUFh5qZQGmPcAezAdHBAJGARMfjOWqG44gVH2t?=
 =?us-ascii?Q?Ip3m0JbBUXRX/zcowGfMT5MmdC6kJEVovbY0Lzg2SttO1q9Y99QdTiuQPbI3?=
 =?us-ascii?Q?edBkHNzS7A=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b81b38ce-cb8d-41b8-b9af-08da4877473e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:16.1822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2f7zJUj0cRE8dhsUPzFr3Wm4WTSPUZzwb6b2XUYPfZ8KZnJYiyC/xCDp6EZrxi3FkmCpyY5osaCBPCSP/7Ta7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL compatible string to ci-hdrc-usb2 bindings
documentation.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
index ba51fb1252b9..49fda92aaf3c 100644
--- a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
+++ b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
@@ -11,6 +11,7 @@ Required properties:
 	"fsl,imx6ul-usb"
 	"fsl,imx7d-usb"
 	"fsl,imx7ulp-usb"
+	"fsl,imx8dxl-usb"
 	"lsi,zevio-usb"
 	"qcom,ci-hdrc"
 	"chipidea,usb2"
-- 
2.34.3

