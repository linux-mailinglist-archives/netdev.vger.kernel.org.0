Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDCF506A1C
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 13:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351369AbiDSLZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 07:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351024AbiDSLZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 07:25:05 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D1B2C120;
        Tue, 19 Apr 2022 04:21:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RLChCopHl/xFzR9LeoBpsF1l4iPj5M+frx67fPCYXzKRQoylP1+XjrvvdSrkSOJp4+rkwxNHaDiN+xPC7rx+y/PfXrlmTrQUZYXsB9zV6Va3eWsjyoZeo5qPwfT1wW09rn0sATAUFXD1XM1DAjBsT6xxglpjdkxqj0051hftomi+kzGXpsIFhW+5NIOFj0S9Kb0Ifnkkl5ZXxkvCXVI0/rboXeBf+7oMufgBHHkkwjGZ0VEMw3expy6n9cc7KxL4ZbpVSNXic0KBreXTXvHuXY9aG986pad4sMdAniUCWR1+SPtt8HFV3kvEdC3nALMCYUfG5VYOizi8z65Mjd/TtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNzG20Xm8cjjQgd9yEWucBEHx1faTwFnEZ+XNKiseI8=;
 b=LTFHeGUZ3huCQzhVGa037vmHH3Vkqx3NoaEHCNz+FYXldQELxopKd+auzffmVWyTMjB/5WULhACcrubTAwp4ra3V1R8SRqcqcDpp+4czDKdcI2zP/+SHEq7a/h74fPaaI9B66JjtlUKk4oJKvXBf6AEGu6qSPVD9BpvBQCWlj2+NC3yRiXegerGqiBSn+OqRGsIR9aJRWCOS0zDYl1g+zUk2ef05ycHaOwUuuo0n1UlgOgP18txLsBcRQQRIulbNzKWijF8pvtTMUWAAxAWfyY/VWNLlV4veSpNacFqmuufxuVpMUy3m4KDyfOILDGeNU3HAzpUh+R50NBIelvCR8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FNzG20Xm8cjjQgd9yEWucBEHx1faTwFnEZ+XNKiseI8=;
 b=nnQB9YBGuRWC19YlRxpEnw2Rk2kbToBD0LFB4NQOR0DwT+oE93N2f24ln8iP84u5nmBfU7BKPqfGzU8Hly6nZYtYXidGcIMZVFbG+UxaMKEc9/N/AzfXiw48XgQ3syjEE56ovufq7uf7UOrkW51VF9MSlajxM1zgLlB0NkR4jU0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM9PR04MB7538.eurprd04.prod.outlook.com (2603:10a6:20b:2d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 11:21:27 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 11:21:27 +0000
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
Subject: [PATCH v7 11/13] dt-bindings: phy: mxs-usb-phy: Add i.MX8DXL compatible string
Date:   Tue, 19 Apr 2022 14:20:54 +0300
Message-Id: <20220419112056.1808009-12-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 435a8e1d-800c-448d-ffef-08da21f6bea4
X-MS-TrafficTypeDiagnostic: AM9PR04MB7538:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB753893A2E003541E6EA2B658F6F29@AM9PR04MB7538.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKY5bXDp6GqgCy5umtLwyeXDiyOKgkckgBzPxC80sketY5JLN5pPgRf2PeCu1CD8hpQ60bhmv3qDaE9XoMgCMav0QfM4G0Tn9WVX76odsIX6006aIMzyA41X3FJQquNOu8P9qc1+PWhYubwHlofe8yPPjw9iiP2szoZdMkkfqi/eudlxYrZmLayNhxmeI3QmjSJFNp/ojoC889aTwA8wSGxUs/oRUOe5RBLEzC3n4VRv0A5Gr2Ou4RN4qmHJqnOkoXcb9DmkyMZIBL1IOVFE/0017AnFnAZ1eguRtBDvKd2CiW9CD8NviMNL+OpZAZbxPfFHXgJCwFkF/19NeIvF9Sb5p4LCYCANx544Xwgg8Dfsrkbl1kU5M3cXH215Jl2oZAnnbVkUfxGs19oibUx4znDyn2hQvEkOBTjA38gIyh43vVadCUXwfH/hxXLGN1gjh3qKBhMANcf0xG5TRBtOWFskHYfN90zyL5SyhnOcjmRV5bhtUf+hXi9NvaYyX6e4Z8Zy1Hpip1WPyEtm3MviOtfHRbJJpOY8VUqMuo3rkeKntFNzb/vw0TFGzVpGpZu1K4Gp9AZpyKcveLaqFlSJD8DeH/iikCJsRfGNs1X78nJG7ajqPu547RfcL/YAS0d0d33LkEQTBTxUnhT5H14RrSpRrzsYhx6SEqyfLHH4MAqUj1Vk4xfq49DAh93bL11TDipZQUldijcld1vt3qwh6w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(36756003)(66556008)(4326008)(8676002)(66476007)(66946007)(6486002)(1076003)(186003)(110136005)(4744005)(8936002)(7416002)(86362001)(38100700002)(54906003)(5660300002)(44832011)(38350700002)(2616005)(26005)(6506007)(6666004)(52116002)(6512007)(2906002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NdM5b381nOKHXuZDpycS44w+4SmTKKdcE12Y6E7YzcMhCJsTHjwe8AFWGLPg?=
 =?us-ascii?Q?/MwIszdbCuO6zfrbh77cVJRpD1BpDeJriWnuEu/ZJN5fI7xY69fh5uyapvqT?=
 =?us-ascii?Q?rFZw7NZaxDm160IImqVOaCi/JGxHQkdWvi7RMzIRZEsk9fHGWwtNZUBiEMQM?=
 =?us-ascii?Q?PS3fc17uGqfta+9yC+1uFwQrm+gxx3KR3s3mobnQXUOvQdxwSl6FJtXqzagC?=
 =?us-ascii?Q?ZX0BY1zA2T7LeGIzdaSS86sCj+vNPLSVyUpPx38gWb7bmVuGGJkFzc7Kv5dc?=
 =?us-ascii?Q?6Z03MmUTkDxvp4nbvRQP8Zi8stgWughHuYzLtIifuKewm818Li/rMmBRwHtu?=
 =?us-ascii?Q?nZoesD0voDIURbAALjuByyzTJ1qARJtbdNOeSnmGgL+lyxi629kptnhmZgLV?=
 =?us-ascii?Q?cu81YS44e/jUiwAtVuwIDQXPPa2lqSldf3FVtmPyRIzEbaTKG7/jLfvNZWM0?=
 =?us-ascii?Q?6lR5wIvTBRmPcPaUpfLG/xumQ0zYzpaHaheu5WHa/V0Xm3XtoEmNlvXFO2rk?=
 =?us-ascii?Q?PcN6lEFlRi+OJC7p1UjPlSErnhM7vjQ0SkIKHX+NvsQZ0DRGmTwk79tR5kbU?=
 =?us-ascii?Q?aM72VoykD+1gniNmiWSTFFDWLWw+l4mXVegCEH8tPxj9Ql4KIk4Vbyfnpy6w?=
 =?us-ascii?Q?KPXxoYZTTfPT2+71bIbcxMfMt7/53QVQMS52KFfaxnkjcgL1QOFLGw0xTzpR?=
 =?us-ascii?Q?jUCVDXt4cZPZ2wmuMLeRCwhD7OfPqZBMs11Vq7y789Qe4pL4tHAG7u6jAqX+?=
 =?us-ascii?Q?UJReTiCh2v7gx1OJed/05JJ2puktAEDWimac2hmg8VvvUy6nrotM8JRPL+CT?=
 =?us-ascii?Q?5JB2zTzYzwTiDf1M81XRibDtARYegYPewf6lqZe6NEVjKcA81c988paa65jM?=
 =?us-ascii?Q?Gqr9R8a04s/RamNNuH6TkbshPFo2oM0hftY6VTynQ7IjTeDYjSRMYXTXSIRQ?=
 =?us-ascii?Q?VxRThY+eVU3F1u1B9sncujXYFc2D93egOlYc8Wx6kPqDMhvmpDzLkC8c0RsO?=
 =?us-ascii?Q?+ubtNng425QdFBvUwt2KaUObGzwMKSZR7ks/fH8+mutrhedJTS9P9UW0nEOJ?=
 =?us-ascii?Q?UAf2VbxRNlt/nzYrMDBkV6QTL3ZyNFFgOVe7gE61P3RVQBrRr9T1nVhdCw70?=
 =?us-ascii?Q?gd5KlBpxtRTc9dCdMLdC9auGuaQGvFLFpjybveaQZVC98pUy1NHOXFEsGLaQ?=
 =?us-ascii?Q?sJ8gW5QupyMeQy6vWJHGnWdcF7/0x17WArHBqWbHLA2OWdt3ztayqfaH5Vxi?=
 =?us-ascii?Q?DlwIH5lY6cGa51GhcsEUdTHOIpCSDz/R4VZSmTY/vj7jwDs9Y0pMR4Cgv3q5?=
 =?us-ascii?Q?pGMrzK1la7QMnkP0+RpSZOUuHS6skzGx7DRQfnL2+dJWbWUTrYgaYob2h1Pk?=
 =?us-ascii?Q?NYOV1lsMznl8MWDD9gia77yrpmLN5pFPC5liOAkSdHbfi6jJ0EQmiEmDerht?=
 =?us-ascii?Q?uB2iWy9Gr905gSFS6gx8p+8UEMvZqm6YgOmRFhlNPYVpzL2Qm9JCkFHJCVrp?=
 =?us-ascii?Q?bNjEdptdwE1P2VoWUhgQOxk64wYm3rADMYTzQE1gQ47IAQXEUgWr4GSRjMpD?=
 =?us-ascii?Q?KR1/niHJRHX0IkhnpqIyYh5s/t1kj4/ZVVJtksNKgTXBOj+mH00tcF3M0YWw?=
 =?us-ascii?Q?MKVtLGzH99AD6p91CGKe7iUQbxeVCxKszbNNODVwAGVDj7DD7FJ634vvKETe?=
 =?us-ascii?Q?xE4P0oo1DmwjkZ41TSq/fwaRuTzGg6U2I7hFSJeB6AKfJ0b+fAVZqM41SHVw?=
 =?us-ascii?Q?O/nv0XQpBw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 435a8e1d-800c-448d-ffef-08da21f6bea4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2022 11:21:27.2377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FHO8TqEl3/lsCfGBxSw2V1uZeY9PMIWQldbQxD8pxE4SnW4vZMg3FQqAlEu6JdGhYbTRhIsX6ES63/w8vTXioA==
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

