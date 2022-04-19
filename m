Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37854506AF2
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239757AbiDSLjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351647AbiDSLjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:13 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50046.outbound.protection.outlook.com [40.107.5.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B06338BC;
        Tue, 19 Apr 2022 04:35:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMYXRjdRCA5RTDXkPuInrAeribNu9n6ocGPboCGyW8x9q69iwW83Y3w/d2udsQFQ6BlUJKxUYqK4RGFaWca5MlNzSDOWon9c43tr+3aD646ylSmSmXnaYooxIFWqN+vK9mUp236u7wnYY1RpFEaLSPlSNGgv0HflNu0pR3djfBHxSV6/5/nP+mbTeHKkcdvpIkjFtH08IRgdNETeL9VJ37hfFxR4A7XAxpyeHtMYL7A7jIWvCPd03S8F5znOUQiRgnYcxzQhrSybphcM/Y88r6PQv+NpxiXv+lDK9HLnSacMMaD4QpBzGR8zHVPF6rALTmTjvc2bszfKcb6aN9rOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+18qStte9ANpkU+tGwk8EzdSrZUUEuecfGlwwZF+2Q=;
 b=G+MirJpzoRj3jPqLkmSanl9AGn56nNZCWYl2a6qIygN/2UrbGEJWLjCT4nwImqudbEzDgEDRyBshc4TFixvFxgwmfOEY5TRWHvLOyeLHLAPEW/ugZW1ksiPP71qaG8F340ipiXqVbz0yvNhZInaVYKBXj+xDCBmztY1x0swfK9RUHgyGZP5vdyWRH8RlYa7f9nlvINc91wnrAySfH7TuWN9bVShf5D3KSnrjSt87QWBz9TnY07+BVoe1Uf6E4dmb0O7IexGqsrXzJGTWATvcq2hezm95AtQ87NDdBA0nuJnnl5zzyJ/uo0hQtFlSqS0xDBmY47gsZmtMrDeTLQVk5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+18qStte9ANpkU+tGwk8EzdSrZUUEuecfGlwwZF+2Q=;
 b=iu6p7hdBgzXgVftGHmBmUW8msRnx0YP/ZWVNd/V7H4AmO6D3g199gzz1Vk67REg6NH+7qs0ebRdPXnAmv7x7iPmajJlKXSuK2vIywvB83GjKWqxxfe1paoaoWdz+M/G5fsWFEIi/zdNcAl5epLz7Ja21hkX8PHV02eYzg/+GR7c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS1PR04MB9631.eurprd04.prod.outlook.com (2603:10a6:20b:476::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Tue, 19 Apr
 2022 11:35:38 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:38 +0000
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
Subject: [PATCH v8 10/13] dt-bindings: net: fec: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:35:13 +0300
Message-Id: <20220419113516.1827863-11-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c85d3a5-5d47-4f23-9d69-08da21f8ba28
X-MS-TrafficTypeDiagnostic: AS1PR04MB9631:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB96315F3EF57BDF0BB4FA377FF6F29@AS1PR04MB9631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LqttHsJ3zw7brTfm6zjsdGc+bqxplXi4pU6wy43m0rqcx19AM2gDAsnrDyY1iTNBmGz/nfBhRlJo1wz4bM88Wp+WEZyaMvfEon1rB9nG79TwOcyJxC60FbyjysjP09DPK3xveZteIYH3XTqUDAoqPZZlxPI17VlMvxHP1y9qjF/Jvl0t1NWDx/vLVXYTbbZE5zcW0YDSCqW+0x6rQz3lrk33I8uVJRADzbYO4K2q1yw4rkUWP32aRjx50okuhMZrnXL9jh/aO0NpeVJsN9ASPxyHfQ1GxDdBmza0Qvi1Fx+1nudPz5O48BIPkaTih0wTD8JVac6XGWmt2DpM52mH6mkVugJI7HLYoaD5R5IW/zFpXWm7lwDjBlo29K3O7rBXQCCqdD79P6/MHWgR0UhD37g/jgFHw7EUpz1kpqOIh6i7XGhDSpjPx5Qp8EpkGEtMrqy39GUckXydurloLb0q3+iXWSQoE/x2RBB8XV6bKgtfOBynkP+nmrJMf4fTfTw1Zr2RwdZYO4ZzBPeMEN0BFlWr133/r0duUYujkO4xmgeXplFyEZM/eIER7KqYIG6G0j2ZC5tNz6ncv8LXBsdyoFVTXArnJOiVOQcIVa/rfaue75AtIxXdkRXFBAZtP05e3bkuX7uwV9kJopMsAsASegIK+4afTvglMhTUSxACQcsEu63uPJFFs63hXoWfXk18B/MYoyqKPTF+L5I5RUibZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(66556008)(8676002)(66946007)(44832011)(5660300002)(4326008)(6506007)(52116002)(508600001)(36756003)(110136005)(2906002)(38350700002)(38100700002)(54906003)(8936002)(316002)(7416002)(86362001)(6512007)(66476007)(4744005)(6486002)(1076003)(2616005)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zgk/2epqReQAC3P+dsJfuRxvHRp6sok4FCArY1WFlt9pomcZkx23D3n3E8DS?=
 =?us-ascii?Q?rW0+lhqCT36Bj72Exx4HVlZUht0OamS3anDFsZZCvGnKRE1hgtn5zn1T+r35?=
 =?us-ascii?Q?3bF2F2bdFOh2YXD1aJe/7Md61aj71KjVVVlII9NFTF0uo7q3KEMGknTWdtd+?=
 =?us-ascii?Q?7EU+DPU2/zsEXFxxQOHLhFQLy0vzZdlthZlyltz2P3nrLHMOfdHpddauTxhb?=
 =?us-ascii?Q?GWlLmtHW/iZpo4S65delzVpUmJHNa1sYwGvRjircYj/WWRUoH9mNWojce4LC?=
 =?us-ascii?Q?HQXxEdVdIUn6cWHLHFQnd+35Qkd41So3mKRXIKGRdNxk7HtZ0VnYsZSUOhRM?=
 =?us-ascii?Q?+5T6tKJRQYbnM82Xv094bBhVtz/YsWhB2uZIZdnPag6Abiy9RRSkPXTIYejz?=
 =?us-ascii?Q?EQni5vxqQtzz1dkDVO/+OTRKcb8NsStuUH3biQNXGmK4EBFUDmNozg/rPtcm?=
 =?us-ascii?Q?arXptmg5cjPwwbj4hXWMRN6FjxBDvKfvjdE42upTpUt2WRy5aDKjZv6dKtrz?=
 =?us-ascii?Q?PQW4Vfsa9snPELvB5LnTF0kTY4N7035tWc7TKJSfUAIv4ZxstZOidlezOIaW?=
 =?us-ascii?Q?v2DiwOxWrmONziTMv0f8U8lmXYnzlo0zG6uYzk8sc0Oj4PL9lwlW86e8pfPL?=
 =?us-ascii?Q?wCo63GlEJU81S5dehmoeV6J2qUbw1CllR2aEYA3mVOYVuVROuWcCXTlQ6cbs?=
 =?us-ascii?Q?QcdAMGOKFVx/bFfR+/uR582u3gcbKxV+DaF/qWW5ao0qJBe1HC9XyVXrwblw?=
 =?us-ascii?Q?RqaeYFB1fPHRhVAMQKVlUIVJA/4Mi+XgDOFUpC9enzuL1+ofGd7WDtDBZNGI?=
 =?us-ascii?Q?muU+PhBffnWKrfl2ZWQUdsiunnC0OFv4UGSD4E6d3NAN0cxcrvYP+UCHVPwm?=
 =?us-ascii?Q?3mDZPo3evW2hDMdtYi9FB9dPSPfh0EDK49BvnifC9GqNFFiwwxqFwEXG+fCM?=
 =?us-ascii?Q?ZUMamkE5CZCFC610PVJbx2B9EaP0HCYrMeQsBpQcwRCbsGQ9JeWTuC/5GnMK?=
 =?us-ascii?Q?CsG3m9ZwuJf/bhjG1GIzlcpJiB+4cwxKb7PmCTu2IBKuwWWnePKXFfcm63XK?=
 =?us-ascii?Q?574klXjv5GR3/zqxQfBWf0DP+B3hlQ7dSlAeyRtaZjPeuxk7FJK++EHyJHSf?=
 =?us-ascii?Q?28h3IOZiYpxBzNyv6ECR4jHcFi+gs+1L1bgJgyGm/cKE30PLtJasUHCa01Ei?=
 =?us-ascii?Q?j4PSz/TVuyiVz9Q7bGybB+FTIczlZMtrWbJdIGPtlF5pjWzfoopIPBpLDmTh?=
 =?us-ascii?Q?A9Llt6mRXFdcP3X8Jp5qgfK2jKWIPj8vmpRXijoLRJOq91Mfz0ydtYoG6oNk?=
 =?us-ascii?Q?zgJXDmqljM57VN3lrVNfa/MBJAazxXHwJJPcf8OTPYbftvrv5oqCRdMN7T5R?=
 =?us-ascii?Q?Tyb9V1GyxE6x6zW1KXlFHskDEzZmm/pa96EZJQGDYrkBIoseh3/VFZ1q5K7i?=
 =?us-ascii?Q?g9+chguFbzs8FOv9MinzVtCoVSFsNma/RPBftK74zRfC6C9SmeicRs/bFgga?=
 =?us-ascii?Q?eaFoqtiytAmPPpAPrBHhMmNQ2twNR5aSEVueiIcv+Mo6+nQrDgDhTc9bFBJ5?=
 =?us-ascii?Q?BVREo/u+cklKMLC5mLow1fTFmWk1jVkHgy+hgvvf51SyOA17rJp/4wV/Z00I?=
 =?us-ascii?Q?OG0ej+9TnUhKy2wq+LQw9vopBexH7+lvD2d8hBTa+iJ3YAgJ7XB/pmYFGMEg?=
 =?us-ascii?Q?eMtv49E2891QBZlvCzlDbfoLDQbLRcd77prz718tEE8t8BjFmc9eDFo/X8sy?=
 =?us-ascii?Q?uHiaHrtc6w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c85d3a5-5d47-4f23-9d69-08da21f8ba28
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:38.6895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GcfatRHi4jiKPv31ka20GDyFClfWDgYrozrhdGtznRxRS+81r5DZ/pumiX/dpSU0Rw9agC1cNdExNtA88TLCqw==
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

Add the i.MX8DXL compatible string for FEC. It also uses
"fsl,imx8qm-fec".

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..92654823f3dd 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -58,6 +58,10 @@ properties:
               - fsl,imx8qxp-fec
           - const: fsl,imx8qm-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8dxl-fec
+          - const: fsl,imx8qm-fec
 
   reg:
     maxItems: 1
-- 
2.34.1

