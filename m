Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575B8506B12
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351658AbiDSLjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351400AbiDSLjO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:39:14 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50046.outbound.protection.outlook.com [40.107.5.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DBD33A2B;
        Tue, 19 Apr 2022 04:35:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bc3+GqdtD3OB/d/INZBXwtZg2KlpT3nAVq8mdCWV+W7UQVb0N2i9vX0DxDm8K1saC9+wkkyDnAmDXBC0OOH6ABKxy6tbhefjJmFtZNo+leazluzGPtWVGslRrvOTTJ2mhE5viTZykwNfWiwbwP3SdQKWKBob61CZUJZUPqprAvZNe0E580Px+fBVYwdq5+xHpqGKbM8KkwdNOoA1ckdHc/V2ZrZ9V4f4gItLJEaLQavxFO7DiQ+TOyKkaLYIpSO2lc/UhTLORxA323qoh6h+zM9NeSzkKfBYiN5/KB2CfzhrsqQF0ZGx41ItOeZYQx7kvXUEgHn6/on/kEmWQLVv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNzG20Xm8cjjQgd9yEWucBEHx1faTwFnEZ+XNKiseI8=;
 b=Pmm7v1om2C88/fxfPBD1CJGtSiZFuvgKwYUN1W4acBD/ARjyPHeH93nZAgexTHeavHy+5tbKXAdHwJqO9Etod0lqW/X58BiLGxBYofVWHLf58NvUxjZ0qPxB+KLa962+9S4dTfTlaMC87JjUtc5r6stlW97RjSxyXiJqRleZgiDmzKyaT3fgd4xanBABmEJElUUh3Rj1cXAw8plFe1/gsrTAs7VCIMR9u3K4vgpPa+y2edZ8t4PQHz4JRoz0Bx/G3K2MdHjzkg+pL4IMKRb0jWruLe478/7TXWw8d72FiapUzI7alZcxUXx5+9Lkwf0eVH8Kj9Uk/VRmQabGi/w2Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNzG20Xm8cjjQgd9yEWucBEHx1faTwFnEZ+XNKiseI8=;
 b=aCgibHPg4BYmnJuN1kEUBj7MzMoJsM0SdaoXBQ0lh8KV+0oGf/38mATkTJze4E+NK1tDQ94I2v1AbZW5LhfvBkOda6pL/grS2CmwGPcNoTj7M0N6aIyOSmXwD554dTtuDgvsRHgOKfhDQR/FZWmjhcbenT/XHP0nZ47ZoR1bYPs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AS1PR04MB9631.eurprd04.prod.outlook.com (2603:10a6:20b:476::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Tue, 19 Apr
 2022 11:35:39 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:35:39 +0000
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
Subject: [PATCH v8 11/13] dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:35:14 +0300
Message-Id: <20220419113516.1827863-12-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9fce3c65-05e8-4e90-6e55-08da21f8ba9d
X-MS-TrafficTypeDiagnostic: AS1PR04MB9631:EE_
X-Microsoft-Antispam-PRVS: <AS1PR04MB9631D6E84E0AAED3F8281560F6F29@AS1PR04MB9631.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifYEE6eQy4hidn7t5zC3+AId+MU/jTVw1drvUjOS9EzOZAufO1FqatFpwdlGNm4BAOe3YyWcGAQIXsl6TwYOWLHUD+2hEUoKm9qslYSO1+IioyJQns0XXZ+15LZ261ETcdbKOwT+m2ACMTwBgXnse7MjBgK1XLfIuPjAHM8BDxyZOypaGJRbZIpHnKZVtDvaiSYhINTkJE5GaAcsFFTt/YtTc4RKgCNtTQ2euor/etthMGKVJCv1sHZJoJ0V3Z71uUcSJjq1y2S29ddtp8/4A6lmgKX1ekPJxpMtljh/9DojWKTssFDBp4uqOaM20Mqd+CJ1Ovt/NOa6LD2kQEXngRdUX1bH6GmHOmyzdovriSqizbvtmhe8HqCSJ8LhESGo3tEL0ilpgX1La2uE5Yvx2sOW3b5uI/6YufkhPjwmGvfUoke0guQ72y3a+ypvnYmfzvbi2C+mBOOJ1fyreaYxTkzBhuBDp61GTjgvgSvaj1fOIYWSqIINn0oI7Fr58f6aQF/GzdTBrUuGb1zJ4YZp6OTHVW30Knw+qtNOHQl1XLhAChvh4/d2k7aM0D8rA8HxIKMrlpMq/YQDZb9ZeyXZAq5zncrL+J6PPSgRrYp/wacqZsOSvBXsiQoB6Ca+gwfbOz5+Cr6CiYBBgRIlWIGapxHHUZTO/EYCnzgTGvqyHghL9YG222p/c1xP7lQMql1tS4JUUJ+oGjy2HxDSrfThYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(66556008)(8676002)(66946007)(44832011)(5660300002)(4326008)(6506007)(52116002)(508600001)(36756003)(110136005)(2906002)(38350700002)(38100700002)(54906003)(8936002)(316002)(7416002)(86362001)(6512007)(66476007)(4744005)(6486002)(1076003)(2616005)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Sb4ZOXazISd0RJjRzFQUBFqao07IdXOnKhfGMV9UObipi/rqb8lUn7FS0mp?=
 =?us-ascii?Q?4A65/+sI1t38umVbgeQLm29Ix//znkHUPBj6MTBwyGkjrEM/wEorCsu25i/v?=
 =?us-ascii?Q?e36+6nxkkngzrwKUPMR42B7S5u5jVSrWEDVw/yDDbm+eHCtBaLAN8l138fZ2?=
 =?us-ascii?Q?b6EYQxqa1v2HqGdKkfMnzNtyyixX/9g87PJ8Fd4YsvN4yeyxSTb0MicfvniO?=
 =?us-ascii?Q?1tQSPzSmHNLF62icLbSmrOL61BXwexSLIix24ALSafcj7u/3y13ay2wXHB9A?=
 =?us-ascii?Q?6DoNGFTI3aGhaRUW8q/VDSh7xKYHVpaRC6ekbUjY4/cqoluo4wmvL6ICrGyT?=
 =?us-ascii?Q?xw9gDz2abMHYltg1jtKM1hKTNzuDb+lXcfOP/8L7EuuUS6nmuvnRR88WLTbx?=
 =?us-ascii?Q?X91B+il2OxKJmFkvDhVXBfE/n9wu8fBIMLahfP3Fy0711SHvNoSVNHx5+R8u?=
 =?us-ascii?Q?iKiO8T0SmMc5U2I3RZY/iAnGFmgADut+/TgSYDQfTZlIOhVaSRhOLABWoKED?=
 =?us-ascii?Q?fZAET8ydiOWYx0+GkX5QSj/V0Jx8yfNn9LM7cvXG7y6J+hiFzEG+tXRN/txC?=
 =?us-ascii?Q?Kp82w2EK8IMzpddO0DjNlbnvD8SwEGN8nkGfkCrdicxDndfiXsO3HnVh3U0q?=
 =?us-ascii?Q?vZsqPyemApzMRDSiYTOHuzSn+SPxfP8/+rZUn2nUJpPS5QLtnxG2BmRQe1Lr?=
 =?us-ascii?Q?19evLpHdNQOEXThnGr56Dd1A/2p5uj/1Ol8DM9vvpVHuITalIYUmRDoHO6Op?=
 =?us-ascii?Q?nk+2kUhOctW5LxG8Uz08WDzTFJZOKD9FK1mDbDXgPkkYsIXrCnLEgNprlAgU?=
 =?us-ascii?Q?Lztb+7rcojRabbd7F3y04P10Hg7B3nFxyXRjtThZJXZSUfrC+4r6V4NQu8uy?=
 =?us-ascii?Q?wXpAzdzHNH2Y1+7aF7XDXIYFLfrv5DBKe5eGZRVdllUQ71+ujpFC+bauePkM?=
 =?us-ascii?Q?5RzC/FwXpnfTg4HovsVVzZhSxEZ8mZbbMrwUsw+Q48Ugk5xJM9PmLnY/VLsX?=
 =?us-ascii?Q?KFozs/Q0smdx0cd1CraY5FBxOZf/V6RE1CFUCTXeeO0m/Ns2iQbR8EZjTKs+?=
 =?us-ascii?Q?l/+/AvtGQmYGs+wQCKzTUWniFN6jtZ0ek621/Wp+iviRwZMZPuzVI1XV08KL?=
 =?us-ascii?Q?awD8rX5jiP0uuEeiXF/3Zyk/bcPSX8Pbr6jmdYLywexoK0owwxowS2AwTOuC?=
 =?us-ascii?Q?HrIkahIaeCswmy+xcH4dPuVYpmjF4aZEBgPoSBY0l7icvcArD55R2uP1NTNX?=
 =?us-ascii?Q?LqsOZSorMZUqJcvXOVsqeapBYe4F68X/XJZH2A75PSp9GLO402/wvXqTVRN4?=
 =?us-ascii?Q?+BR7/fi3K8eo27DFCw/tByjwN8/fZTA11Jv9N3NhvdrVxAuXNZbl/10FWvss?=
 =?us-ascii?Q?fyIzmMC/H73xwbsOInNkdAe9y4KKIBYG2XYMXgroWIlUeX9nDqVbQsGEqi2w?=
 =?us-ascii?Q?OlNOEp3VVoO5cHUvJgjvBpcK1B9iG1n1ZhMIqSiplXTkulbK5G0eXexvMwUN?=
 =?us-ascii?Q?JhT+SKrUT1oD1CtGUhmJMLgifcJWbOsQx0T0eMEH7fUkCVcg0bORhAW4M0vS?=
 =?us-ascii?Q?urszZEUOnJPVhNMhoSeoDCMT38cNxF9YbQ3ZYREpbUjA3dPl5/E61EqkQxuw?=
 =?us-ascii?Q?0C7Kn4NLUgmx9Anpp7sw+2rEVWDSV+XGE7sOb9RZxHGt333+7kwJn4+Jgv1R?=
 =?us-ascii?Q?QH1RLZ7ViK6N/o55iZFeIk1fXBQ0rJl4bMKGyOQ0R9XanT0RNRpPAMML9EOZ?=
 =?us-ascii?Q?1xTcwVY4Mg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fce3c65-05e8-4e90-6e55-08da21f8ba9d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:35:39.4550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujK67a6/88aRb+Ls1BBckv0nRo0E3Jd/l9zQX0dw0eZLY25olTGpgj/o6eQA+pgl2NMsfQXP/D6CL6M2SR3phg==
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

Add compatible for i.MX8DXL USB PHY.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/phy/mxs-usb-phy.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt b/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
index c9f5c0caf8a9..c9e392c64a7c 100644
--- a/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
+++ b/Documentation/devicetree/bindings/phy/mxs-usb-phy.txt
@@ -8,6 +8,7 @@ Required properties:
 	* "fsl,vf610-usbphy" for Vybrid vf610
 	* "fsl,imx6sx-usbphy" for imx6sx
 	* "fsl,imx7ulp-usbphy" for imx7ulp
+	* "fsl,imx8dxl-usbphy" for imx8dxl
   "fsl,imx23-usbphy" is still a fallback for other strings
 - reg: Should contain registers location and length
 - interrupts: Should contain phy interrupt
-- 
2.34.1

