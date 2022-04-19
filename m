Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3FF506A21
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351304AbiDSLZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351217AbiDSLZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:25:06 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A273C2ED4E;
        Tue, 19 Apr 2022 04:21:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+lJ3tRQCCMP95BGoXnefC8s0kqf/PPGxFg7XW1oaOjQ/ufpRu52QN+vhvMzLEEd/PT2V3v4ewLGY3taUEa3tSSm5xVbAq2xfH8L30xiQwlViem8/U4sdbvJPGmz/as/0hX2C9aE43Vam5poQfDUCini3L9/xG5CgvrAldlsLsmPfA/lR5VEMojFncsKndXc7JQItfQnX7yA6vbr9TJDbm/S/7IF8DNYhOPMQ2HH4jZ2k5bHnfz7aMUHciJyimMWZMkpw3RS7HRNAQkyENlAOoMJreWmM4sd9Z0kW9x9fkzxEM1at6rCgbpBzc80qGJb5ZJdkj6E1Xciyr11h4ai2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wFGtMjRUQBtzpYd3zm5u5zd1w5ZSXyOMsXkAbLpFGyg=;
 b=FZJL+K1qg07GYQiwb8qS+zyiofUdatRack8BQdgrwHbnQTNpUoAn9ta/w9qBQdRXfIiMvkG2A5z9lSmtTahro55ywFBNK6Mpz8jUF8viSEtvwWNcALVjDAz56Yt8hS9EKcWJ/amUzvF6/pUNoQLXOxxhWw823NfO7At3hCDMWfsKBFJu3VOSZBbEo56fL4Dz7aGcBwIkBGFRgmPk+KEiNwLUXPX7Fc71pAtGOeLjK9Q52oAa50JEgKKz3ppLzgHVVNDm6MQq39SY1xY3YXBIv/C8sypv3LBfU8dCYakozWL7Kgd8S+EIDSTH2R9klGKip3+ddM1pYmYq+pVxosOVKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wFGtMjRUQBtzpYd3zm5u5zd1w5ZSXyOMsXkAbLpFGyg=;
 b=BN8wcksiFtIgqqUgYGxjKQPOLBY7GrviHFHYLIFxB4aLPO231LUzOfJTZyeO7Al5XEIy9vr+KfvokSIyoBvrfQLlvzEz5tUSflue+IryZ3CS/5HFmyRHoC/SxPJsz0dEABXRDS2eTAzRAkW+z3vEcjSMcLxiv/taj0itYUslafU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:29 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:29 +0000
From:   Abel Vesa <abel.vesa@nxp.com>
To:     Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, <netdev@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 13/13] dt-bindings: usb: usbmisc-imx: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:20:56 +0300
Message-Id: <20220419112056.1808009-14-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419112056.1808009-1-abel.vesa@nxp.com>
References: <20220419112056.1808009-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0008.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::21) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 882a7335-9825-4060-efbb-08da21f6bf9c
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB7538DBF8815CD44469F42C5FF6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u8MMXrPBecG+IpLFjb4wA6qL3x+5HyoF4+SXdBbvL2Qz4GDWYtbWtQGwhdruGT1gDtL0jpjejMqNdhySnJujoatVG1FmRy85TcaLuRx+tfJM6H6SMEvwbdmU1xC0o2lOa4E2RcBdne4eyiXGj2t2NgnjUyNGmyz3/iakSAAXLCbBg0Q5ZDlDR8sg9pSY7QQLh+5eputDMAQ5ifH2Aq0n4ZW1t4CzZUVbyogtaHd7k7i6PerE0wBE5LwKBVFzDJeJzV4kOihe3/AWC/rIx7toOGCb0v9WYLVtm8NZlc2xI52PeMhccwhOvjlooyuMosQGYSrYL7suxw/2FVwz7YDkOx3yZfF78ge5J9IBvSnXMXk0fCPGa8SoaheKqAWTsfWArWlIHM9nyXeFO1Hh5IRpXeT+Ok6Jo3MPqc1Cf2KY5mWgvYl/rFsSzFOAOgxyFaz0PcASl8uokkGHOGqvmIV/BLytI3cyDuaDVOPZjRWFuNOONfW3t5RU1a7BJrOJANZDEPvR6lnmWpmN32UCsEy/J2l6yfqYLgOsYtjWvsmkAG1qjAb3/d+e4mkoDrbBBEWXxO9W3g2LW9utWi6NCQ0pgV/ELWP3dB0JeOKvSH7MvT3kHXGgyt1fcwYoJyoLVLDpF01JwPOKPdSQBuEOjAWDSyorw20NZ1Sax3EI6A17egO71CibduKOF51wGZD1hi/AiLwyOFh4JzFrZ8dPiGiV2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(4744005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GbKK93PVipfkPxQKrE7xGDqWyWYAu4XzWQNtYEULRor9cJFHh2QQOXk2I0oV?=
 =?us-ascii?Q?FQJyMppgHDP5a9hKk3+UAsJ5e2pYynwNjuCkEshjbjoo081u2bwe2gyNFSYt?=
 =?us-ascii?Q?coIzpzbGQB1G5y8+0w0prth8vni5M5kSRdpQnzqZMvNzmKXO6ehibd4Fystx?=
 =?us-ascii?Q?wRSojO7Ia0eaGN/4DhtAvfJQxyTEoEZWz2ub3VtIvZNP9mMy28VmiIYclIeN?=
 =?us-ascii?Q?gSdHf5xZnESWyOpFhnAW9jO2lig2ce0cFXSddLV2hKwDeefs1E/TXqT7EhAu?=
 =?us-ascii?Q?HZvVHQKFKRezbAVr7eCwWTRzaffbSUnpCGefFikFybMfuPM6KBQFbARlLM9a?=
 =?us-ascii?Q?NAstDDOwH0BOR7Ajoco7hD5yOY/jLIWaw+eOsthbZgR+zKUEe4QO/Te+0Rbj?=
 =?us-ascii?Q?WuDdgHQ6qZKkwLqZ+W+5kTw5Y2CsMRrfyHEwUXgwksGynwMYWgXifXUXKSdc?=
 =?us-ascii?Q?YuGPX7xfg+5pwc07PTLyQepWOnSJBGiEgJSiOfgYZKt1fOziJf5x6ufqeXCI?=
 =?us-ascii?Q?3u+IrPkCpK4jlPOlmfdymTaDFrwHLXFB9AiOMylaxlaJNMRBLSrvoOpt5AXi?=
 =?us-ascii?Q?xKRDhP7gkerSdqRZWSlt3dfdK2GV06eM5C5nRuRLBB7eC/fZ0pxH+6LYntWU?=
 =?us-ascii?Q?cG53hUcl7wEMSR5EFHbfxDE6eykr2bOu6ssjPeeJ/KSo+K0IbPb4NANXhSvf?=
 =?us-ascii?Q?XsCClajje6IFb1X7yjTLIqOwRff9aeLy9DTJAKotQGYzg10xKLQmGSncix/l?=
 =?us-ascii?Q?PCdXaMDr1ZWR+q0BIR1zYH8OVMovlBcUvh9Fd/qE59U194s8eL3nqxG5bWHK?=
 =?us-ascii?Q?b/IEuzawhGuACXl4Deqsi+bF43RwfsMWR7XJviMLOyNZBLPsPP/E2srL/6Rq?=
 =?us-ascii?Q?TunsYFqmOWZsyiVDnZ53mQ+ElAJqfbyPs15oLz9OkJEVFDaCLbDXmZWy3EcO?=
 =?us-ascii?Q?3ap9FjdUDUcYaxgPzKaInKHK0G6VClraqNvKRt6pkLot4eIO0G9/bkfKc3l5?=
 =?us-ascii?Q?2Tsm8nxqyS6vRX3wYJ5Y82rXq8UE1mIzs8Ou0yBHYijJIyF2W1KkvZoWLCNa?=
 =?us-ascii?Q?vcbvdKodsk2UfVoPnuBW8hxaHLxVEy/aU0WdDFvmIGuZ0TjGxCt6JSGVxr5K?=
 =?us-ascii?Q?Lqx10mWWFMX0KmpH5FhK2zNlBaoD1vZ7dE6lx5Za/KPFYZlkBEuudR+aZw71?=
 =?us-ascii?Q?vAtVL8wAg4zoYonGwfTndBTxKbMtTO2X0+Sc9tsIoVOh8y3itzkj65zqON/y?=
 =?us-ascii?Q?HdvCS+urSLy3aS5QiXEpCxoatoSfLC5zINE2D7HX//2h9754qTO7/ud94pwE?=
 =?us-ascii?Q?8CoSly0PaR8rbRGgrkie6HaC5RjArPCdhDH3Y6GoU1Ywgv64D6ZwY4X6BYww?=
 =?us-ascii?Q?JYv2VwrkspmE4Dahc6TmI671ZDqbLhS2Nc2Bm5L8tmesJZrgX3R9q1VIBtYX?=
 =?us-ascii?Q?gBaKa6VpVvUVgd1JXY6XbsY1yZhqGPGOw1JF6B9vZvAeTgAyj/OfGP4R/gZ6?=
 =?us-ascii?Q?Y+JbLGSrA8XG7FIhmayKKmALDZUScMb9bUGBm36B1CofCMRF5IjXW+FjctMZ?=
 =?us-ascii?Q?mSRHWS5+I9Ray2EH65AihxNMQ59syydC/IwzbVxIKm/bDabuhimMv9/FRuVR?=
 =?us-ascii?Q?PkeTpmt4ZHlM3B/E7L4ovt5SXPpYyNSyoiir3Xa2ktbnKlE8uw8PJ79t7vyY?=
 =?us-ascii?Q?2H/ZfwCGMvJohvp/qlRG5Ylrg/Co95Ns6x/E/hekKOnpNODXT6HYJ/xN4BTV?=
 =?us-ascii?Q?WNswwfyd5Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 882a7335-9825-4060-efbb-08da21f6bf9c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:28.8469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyDC4zmbaZGbA+0AT8XVjrsLVU9CgIWySvjao/cakpqZ2ZjUh1JfYBFOv4cwn7H3Tmbfqe+Wmnc8yRnmlU1t9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7538
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL compatible string to the usbmisc-imx bindings.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/usb/usbmisc-imx.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/usb/usbmisc-imx.txt b/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
index b796836d2ce7..6bebb7071c4f 100644
--- a/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
+++ b/Documentation/devicetree/bindings/usb/usbmisc-imx.txt
@@ -8,6 +8,7 @@ Required properties:
 	"fsl,imx6sx-usbmisc" for imx6sx
 	"fsl,imx7d-usbmisc" for imx7d
 	"fsl,imx7ulp-usbmisc" for imx7ulp
+	"fsl,imx8dxl-usbmisc" for imx8dxl
 - reg: Should contain registers location and length
 
 Examples:
-- 
2.34.1

