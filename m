Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E87E353FD56
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:19:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242969AbiFGLS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242891AbiFGLRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:17:53 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2044.outbound.protection.outlook.com [40.107.104.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EB8DFE1;
        Tue,  7 Jun 2022 04:17:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bj0wEqAJfq9/PXfddBfjpYOZZe70UFHEXWFZe06FxvtEgzxUbhuj2fVum+Pnjg3FMrsgMqg15unMja8xwPzKBsOlolMmKTHKxji6OwhutE/6mUS7UepJAQYX+ApE38JsSItXChmqi1KEy/krL2oMOC1Vc8S24mYp4YtEJHGIpnZ6pn6P+u/AY+iB3Id35G8kmpXjli7gSrUqUErpWrerFz5KcruZ/yDOMrnCFOdkhEz2bI555V3lIQfOIDnHdBZ7emPzpfWqr8FaH2YZMGdClmBY27/eu8G8AOFXtuPoXStaavv73ao/ZMXbzUZx1BYyAIOzZ5y851sx9UyfKoNn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VJ8jjJzm9PE3MDCwiT696T+Anf0G6SC0QHUw6WhGvI=;
 b=KkgB0MP2ILFYWY0UK6sPGlutzGUTdcwnD+2OhPMIbSMhjjFb5e8P8CzC2pHApTNsfGmT8pu5ydSc4as1YMoloPm3+LbUtG8IaUDt4K//DHwBOGVV8XU4hkVo5PZZO/SUc60qEP1tVY9mG2BTlEJsXLuss6FGs7hwTXohosVKQm3Hvd7BYhCB4knGM655GQnDvrSyX44ZRbIvJ042IHM+jNJ0+pkJi2kTFz/iuO8s8a7oDYh0ndPymIO911+QLupsM11S/heK5LaxhJEHwaKvoYd1tYxsAwucDsRn0dZqoOJ98C675jBbxDfzM9IeTOecWadZxTkXb2BHUGaUJa+wxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VJ8jjJzm9PE3MDCwiT696T+Anf0G6SC0QHUw6WhGvI=;
 b=AVpVu5mrhgRIPvTbqZVyfYCG+dBGsvCee/aPFWWib9Osxn7KxguRAO7/evP8O3ROMP3n/b2bASrgjMQbUyXuZrEFddTyJck74c6KSizODcUMyahzLnXsIHXrBQoMfW8T6Sb1gUcjFKifP9riRsq2ad9PFBq/GRqE8GgE0IDxp2s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by DB7PR04MB4890.eurprd04.prod.outlook.com (2603:10a6:10:1a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.19; Tue, 7 Jun
 2022 11:17:21 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a541:25cd:666f:11b1%5]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:17:21 +0000
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
Subject: [PATCH v9 12/12] dt-bindings: arm: freescale: scu-pd: Add i.MX8DXL compatible string
Date:   Tue,  7 Jun 2022 14:16:25 +0300
Message-Id: <20220607111625.1845393-13-abel.vesa@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: bb1ec98f-6639-4c4b-20ce-08da48774a81
X-MS-TrafficTypeDiagnostic: DB7PR04MB4890:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4890E347B28C5570024D69D9F6A59@DB7PR04MB4890.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QO5a0RzFR9DbuojQyCh2LxxmK0GDV6IkHo07FNKGFOsm8+Z8yzLgNhzbhr1jFTFEArjtMtXj5hUKn7riOzcmDetvzUVAR2TNHsxf5+UlDDN8qtzsAn4zVBjT9xvgup2BJaLDEHb5A4lu41eK/p+2CcMUxXdr028fx3GiPf0Q+sCmj3aXil+MDxBsl5HJPzx7bgrrp3LAFMWirX8hvCb7sFyaU6dXzEM+cZ1asgXE4HmsSNKNVh74Iez8HPk0YEzbNdhIGILIhXzQB9vq6vVGI6EtWrY0HhJr/lnhBKSyjeRBX+EUNe/ZdlBhuTxNNrRaCN7ag4TKOBjtl8YoXvotMQ12m9yy53Mq2tj7xE1E2NrvRHw5qb1mfQ+T3zU2braJaUyHwIIDPOO94YzGGtfWBuYY0XMpVOU/JHIE6exDJZmhuadmVKflcd0R6wv2rkDLzUUsf+WBQYY7kSLb1VMRxnIz5yEvzlLpYBm+9egkBdkYN/0X4Nw5dpBBp2/O1Lfe0jSioN4rbHebj0PiESNH06FgAktPV2ZzCwhbQJQnCQQbPDHec6mRY7xaa/6OvVgw7+TRZCavhrEtw/xlhorOUIOQYW3U7y0JbX7z+5eo32pdzv0NoeAT3x9YinBfeoNNbtFjQss0PXmXHjI2MsEMnffKDUPHYgYdX+vrCM+EB6V0frhuQKtvw1BzbN3gJaKRMuD7E4+e/l0HlMLykG/8jH9q/6KLnrbA2VtO8zqrKuU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(4744005)(44832011)(8936002)(5660300002)(921005)(508600001)(6512007)(186003)(1076003)(7416002)(2906002)(86362001)(26005)(2616005)(52116002)(6506007)(66476007)(4326008)(66556008)(66946007)(8676002)(38100700002)(6636002)(54906003)(110136005)(316002)(36756003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6xMHtjxO15WoUvQ+ke2gUbbSIaKElpjnPdv0bivTjF/iY6PNPfAeJDrkwrxX?=
 =?us-ascii?Q?jsqrHTmmcH3ybYcvHmnczsX1hkuQFE0WEqkFGKXSw8P2QvB5HUbT0J7bSYrH?=
 =?us-ascii?Q?Wo4D6d/eKhjJhhzpLMPkHkH5Uw1xRdWu6DtReoJSOQa6nXbKP5Q1OQBc9cF3?=
 =?us-ascii?Q?lqHFLl4lJdzLWpmEONF/jnc/NsV+h1S0+tdxdumn6UIBdw7IziBiNCT0ynXA?=
 =?us-ascii?Q?c1NjeOsa3k2LQBV2pg7PM3UhATLgD7EoL7cnCIuX0osQB+3u5rYPfN9Q95x1?=
 =?us-ascii?Q?5mhMqrU8oE8883OTf50Ki6D5H93z6yylGM00edp5WQbejSJO2cGAB2TwVcVc?=
 =?us-ascii?Q?NW9eU4Nmog915HtAYGHB1Srn9R2l6NdXddcwhifjRouwteKc6E2C4XsYdv7E?=
 =?us-ascii?Q?VT57WjuPLwjIBo4jNjNYUJGWwfM3gAVduDJt6TIJudV2z45o4m9zHIKFULWN?=
 =?us-ascii?Q?UpO/ByDOUUAEi7DyutbX9cudLm8jEf8O7emxhlK7dYyw4Q64Xd5UfO9KuDoZ?=
 =?us-ascii?Q?nn5RkcUo6baVkc/DWevXhZiy7r+7hLV5ppn43GV94s1KThIzFbG5hoDf/5Yg?=
 =?us-ascii?Q?w0q8QdDbOMUdta02VyADFSfYMrVXI6vcAA23YyP9IJD8AL4ICAn5leIg5mJr?=
 =?us-ascii?Q?PGyU7qcXtAUs9erLreu4yUW2lOF+M4RQb8SR3+463mefK8HrJJSRhRhaaIC4?=
 =?us-ascii?Q?CbziFflaKPgk+8vrl0Ink6JQzaAEqS6izZssy2Pb/jeZsLrXCu9bJ1kw6w6X?=
 =?us-ascii?Q?1PPomYDEdhPlCAHRydF8RLM4r6K8QATKbMhAcGrMDShx+8RRA6o7gf9nKUU4?=
 =?us-ascii?Q?qR8cumBvHsR/UrvNDe+1T37fqGfLeYJBPq3JTCVS7f6x0DuiCJ7/CbDg9HsW?=
 =?us-ascii?Q?s8kybjJsBjdINb1XacULbaklM46ZkTpZL+4vWttE/2oRKZ/uvx/NyClPHX2G?=
 =?us-ascii?Q?JQMbqQ7KcwpSx7ib5/aVPp+EiSLoHhLGNGoNYvlx+tQRh5Tq4mCiTTIgCTZB?=
 =?us-ascii?Q?0jlmx8cpp31VTztgYWZ2gobbdi5OjqbLFTSmAGrJbXoLo5Kh+Sj3H1yUsHN+?=
 =?us-ascii?Q?2D038Rc3QVfFCUo0Vyz6Y16BRwhIv/KlCOf25Qmjo+1ie4nk21eZWXYgHvqk?=
 =?us-ascii?Q?fx1I8P0EZ8ZQV8kL3Wf2aERYCl97Q77wvCb2/J63GHJIdRyUfBamzPHNMgp+?=
 =?us-ascii?Q?idgxbJRVaVG0/XOyEeUX24TD166qrULBquPlZXsC5rMksuF+nhCD15mr4j2/?=
 =?us-ascii?Q?rfhIIgALheZDTmuWboh7h+4wV986SLeF2BOWhtoGZopC5fIh035FjrqvyTyM?=
 =?us-ascii?Q?UcP9hNnbcqXvoOfiAStvgsH/HI7ufjoah3tLBRQFOEdKsGXD6onaffIky76d?=
 =?us-ascii?Q?gLv26ck2UWPEzkQZW5KAEn1uQ2235J9BKstekPl1YNH3OV1HJkH/lMUlGmK3?=
 =?us-ascii?Q?9/aBwTyN41wFRgNE42kVUgB/4lk3LsaGOT1QqyTq7wiQ9ka67MZuUxCdERYF?=
 =?us-ascii?Q?R/UXkPeJI3WaHe3dSIhIo6npstFjCo5y80/2LpPKgfoRWMR3Guc/JSLtSxRs?=
 =?us-ascii?Q?qTv+T/NEZnj3E/ZzFqaogCx0uWMxW4tCIypY5Vg/sTGlxX+GhDPrpy7zLklw?=
 =?us-ascii?Q?aexZhtRKkV2jqyPU6DnQotj5uuGL7TYdwDFyMriQPeEelsF5dFZOi2B0PbRY?=
 =?us-ascii?Q?6DCi8ggN31My01lOUtvbLPrSlCfJjgYuVF9c/tJQ0ln5CHbMCq4H7hjbsoDb?=
 =?us-ascii?Q?/wtQCnb/wQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1ec98f-6639-4c4b-20ce-08da48774a81
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 11:17:21.6505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wjb1TTG665LL9peQrthXy1ADytVfgz+q163NJlL7x+tP0Arwlk+L7UTrDVDXaUwi9GcmWrUG0DMVDdaaHhwcvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add i.MX8DXL compatible string to the scu-pd bindings.

Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
---
 Documentation/devicetree/bindings/arm/freescale/fsl,scu-pd.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/arm/freescale/fsl,scu-pd.yaml b/Documentation/devicetree/bindings/arm/freescale/fsl,scu-pd.yaml
index 154a63495436..78d855fc4105 100644
--- a/Documentation/devicetree/bindings/arm/freescale/fsl,scu-pd.yaml
+++ b/Documentation/devicetree/bindings/arm/freescale/fsl,scu-pd.yaml
@@ -19,6 +19,7 @@ properties:
   compatible:
     items:
       - enum:
+          - fsl,imx8dxl-scu-pd
           - fsl,imx8qm-scu-pd
           - fsl,imx8qxp-scu-pd
       - const: fsl,scu-pd
-- 
2.34.3

