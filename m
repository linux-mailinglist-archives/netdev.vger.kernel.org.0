Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC22C4FF4C9
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 12:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234934AbiDMKiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 06:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiDMKhY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 06:37:24 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10066.outbound.protection.outlook.com [40.107.1.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6755FD14;
        Wed, 13 Apr 2022 03:35:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8QYBKZlHPYxkgSG0zefLmahrXsCdH1urKuQt/46iOpvjwy8kXPgvoWmZK4xKuhRO3/X6h9r7CgkeK1Z1Fz9SIJu3e+lzcc4r19dnFkKRNarWcCeqvaeSYc8HI2OVTfeJmcHGORUAOyZyCK7k040KtgruLe0mW+OIPjA31672WOFAZZZ6hUO2FPiHJE3WLasTjRCGg9JXjEK0mF8kbrZMFaIkUL/gvFfE1d/8Dbrr5lp7h31Fax5EAqBRTTlkYUutOyR9Nf/2c7kP38OeckOVMv5qY/i1rHGo0KQ5+CcIxJh+yucyw+oVBL8Lla2uhoCBX4GU9Fch8cHywg++PAVcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+MBbIGrB/yirTTOWb4lgAS+Af8ax+/pOqzn3+r9cGnI=;
 b=W0oSJW/pxLZklC2WICSpXpS4zMZEO8Qt7SpiukW0/SIboV0QLmiv2JfnElZPoG4kS6uE3nwXLgs3VdWxQ2ZINgacGQIvMz7Nat+Y1my+47EZTIy8Wcf93X4adGA8IuTrbY+5nSOI1QvxdoItl8UiLvuhwerIea6xe9R4ELTIz8D4jzxb5rVketn0kq6G1HlVlfdh1bLwWZ4Oi7mC/ho2v1iuks1T3RrS19TP2KcQ9CpA8A7jO/1b4dCmkXXlCyvRO30pbnMaiS/nHfDewevKJEQS22u4fbvQCO0wTQHajWS9h9J0C8IWATEx5BbrhQxvgFgJHxcpQBKhbY90MPFoag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+MBbIGrB/yirTTOWb4lgAS+Af8ax+/pOqzn3+r9cGnI=;
 b=qwZVl4shhEvk06vBcFNyBiDqtm6/lS7z/L8dctZ4fPOctQk00UyzoLCFId3Vi7WAQLDtCRVYeXZ4m1dVpcZM/MbSje5mEJy1m/h3XhiFk7f8f/wwmoAhAzy1R3sxVK1RYbIK1e4XOkJu9zZ9vRwirLhHVXFdaoeSbJpdx1q0z4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30)
 by AM0PR04MB4082.eurprd04.prod.outlook.com (2603:10a6:208:59::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 13 Apr
 2022 10:34:55 +0000
Received: from VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f]) by VI1PR04MB4688.eurprd04.prod.outlook.com
 ([fe80::a9d1:199:574b:502f%6]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 10:34:55 +0000
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
Subject: [PATCH v6 13/13] dt-bindings: usb: usbmisc-imx: Add i.MX8DXL compatible string
Date:   Wed, 13 Apr 2022 13:33:56 +0300
Message-Id: <20220413103356.3433637-14-abel.vesa@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220413103356.3433637-1-abel.vesa@nxp.com>
References: <20220413103356.3433637-1-abel.vesa@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::24) To VI1PR04MB4688.eurprd04.prod.outlook.com
 (2603:10a6:803:6a::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddda04cd-e450-454c-9bba-08da1d394022
X-MS-TrafficTypeDiagnostic: AM0PR04MB4082:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB4082A60C681A86C840730FDEF6EC9@AM0PR04MB4082.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8weCiAhtk6dCFHycPHB6+XpVSxCTBNrUFZOelOnImYEO8wSzBpIOcE0vJ9awz3RQDbDCmko9FblCStCJlwkpkrmiDrAR4HbC6GoyRk7p2sfGR8l/5JvPsj1nyHaLRUCl/dlLXZBuhcaI2g+0Z+w7oKaBELzIlxs0+SyWKMJuuA9zOhdRHobm0cNcYGG1qWBU7w5S2CjTDNRJQVIHSNeYZzS5gyG/KpClayvaX+UxhYgZn3BL1Kcvxe1S3Ve+uweTs8JfJa3S02L9vOkO2oTqFxpaoJ6Q9k8+/JulVdbv6wxvY2nPN+jeKy3oVahh939DU365lFnN2U0KjLD9S07gC6YG0Av95HV0mWus9Owny1TEbvsbKZbiQH8Fm1CEfR4TavxwbAHVPvIGB5D8/8UBLAgKoe6QtDEI6i/kKO0Vxv/BXx5LXbD95lqY6lg924Q8y3imOdNXfmxww2VVuLeOA+ClJGrLM0xWjKqH2bCPpwhpdQhZODsDTyEUU6vwbpI9ipx6Zmbh9c1OAmvkjPTaMvOqe/TU6Yv7OH8R8hFTNssk4z4l/gpDxzBpSiOlXj2u0CcdymCMkkuXv1ih3djXrw/gqhQKTWdt5DROdQaOyen/DgbypI+2k/mdtcTlBGj63T5cqxYm7iv/KX3qRyRmxI48jcLcrEwEmAgdyd6Q/lW0OuEpF5g5zkjozl39CEqmyq8Mg4+Ayd4ObdUNp4b1xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB4688.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(110136005)(38100700002)(54906003)(38350700002)(4326008)(1076003)(2616005)(2906002)(44832011)(186003)(4744005)(26005)(316002)(86362001)(66476007)(8676002)(66556008)(7416002)(52116002)(6506007)(8936002)(6512007)(36756003)(6486002)(5660300002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VIZWO2MIBSNW8iFql1n7RrycZAJGl7fYYl6rV1CrTVmYIvpREAmuD6Ogfwf4?=
 =?us-ascii?Q?YWbDExbOLvmNaQmBhZEEhKtZima9RmnDTpBGKdild/lho//qK+wuzsSoqt2J?=
 =?us-ascii?Q?X5Dfdj8mpb6wpgd9RrejZHIqcgMVWZLvOLuGZMLjkaNR9tbg8Q7/ie349JGK?=
 =?us-ascii?Q?Nh63USi8YPBg4JMuhOP4tXQeP6UZDukgc3AKkdRXCmBZbaRaBvR7aVI+9LCC?=
 =?us-ascii?Q?EPLTA2vYsfMp0dVX5Msn+WJXu6X6HZr55rG4OjkDcMKRKqayr7EzeMatBAwR?=
 =?us-ascii?Q?FhxlsGuA45I05+HZqPlUQknTVv8JaNep1iJPw2lqBvz0uQrAu531sv+gUSqk?=
 =?us-ascii?Q?MRW0u74+9wMYbOmH3g3y6pSx5XyaSdtvEEME8nbzM1Ozt27JydoxKtXD09Sd?=
 =?us-ascii?Q?cn8VyJ6BkQRWNjONCgwUbERWVbcbc+sMgaMq69SAFRbg2jk0FbjNId0oCx+S?=
 =?us-ascii?Q?72oHrWVjJWQHC+VHMOKIrUytTmK9K/b1g0hukRxbKp1lrD+9NMdQckwiUArR?=
 =?us-ascii?Q?X4/RPi7KwikRKqWtPoKvu154TBzagLCHt07A2pQf2JZL/n8D6cpWQmLSmNis?=
 =?us-ascii?Q?mjWKFwrzIAwCTFjZlroPI92MkbCqLffUG8KP2OK0gLZwbRyndwj48AJOt5jL?=
 =?us-ascii?Q?UfxIpvPuSjXbGoSs0Cl/FlMpl9YQ89nDye4Ak47dpEX/+SLsawRjgTi3Nv9r?=
 =?us-ascii?Q?gtAeC2Am1CRz6qhx3f2XImaPTGFMlvy5Wq48uimoMbifFDuenFv/zkLkbCE5?=
 =?us-ascii?Q?QSWLeDghJoMjF/cOudc18v79wKg9rKj5TLv54P1z9ILy+Vij+AExNo1ENBZE?=
 =?us-ascii?Q?nULbtYWwVqww+ckIENuzUYSYy1z1SbRJCHaYaRzFfiY9xxPHHTztqfKNb43E?=
 =?us-ascii?Q?0SZx3sfT8jFSpKm0YvT8X6qhDD6nbx+K1QV/EBEQwVCOKhtnHZLn/VplIbx6?=
 =?us-ascii?Q?M6D5UlebjLkaOcyGbJvAUVedhKKvUN6Qc420XicBzA4RHcxjAY1Y4BDXhXn7?=
 =?us-ascii?Q?nMFUGmWmcvAueoX3U7JKdKh1fl2db8+nHjFAGAQ9UhbeNSFT9sYE9eQdEpDV?=
 =?us-ascii?Q?YFMa1WRUbddBpJWu655OZYlOMpwqNTG2kdXym4jUr8s6Cor5ht+ALS1uubZ6?=
 =?us-ascii?Q?uHa3Z/N4tjcYWGG22dEpi6MW4HZYVZdTinkkO8qJFlyoRcDJqYEV6fHwW//b?=
 =?us-ascii?Q?3n4TVZ/kpU0MHgWTI9ldtb1XZYH0djNpCUi7D2C+WN4YK/oCUui7yud4Pblh?=
 =?us-ascii?Q?Dre5LgwnEdEyAXQFJ72P9UJYw4XJvicVFuRF03muGRuOJlQOBwbPmkVW3Xft?=
 =?us-ascii?Q?mVp72T3aT653+SolpdVjQfXAXsHyzM9LfODg+dWMJ5ZumyjNkrOv92U4wePE?=
 =?us-ascii?Q?Wt7DOBAhBaCvuyghgHbtdqMXmjO1iwbvyxd0DPSkTuUkU7Q2k28Flo+aGrs9?=
 =?us-ascii?Q?L37d5ZD1IgU9/E0Nph9PBucsh5lpuDAHCJiAHdN8jbJH2aUmG9s1ypFebXCZ?=
 =?us-ascii?Q?qwpstbQw3Mr59yVj9DbCfBf4Pj6NNA1EL0Iz8UO7ZC0XGEqvZ+CPMZxKU6ez?=
 =?us-ascii?Q?I5U6OO00if3MqRtu+Ky1TGSH0o2jvVYLXGAjjfVT1VMuo8wQBEpbLcpaqZzd?=
 =?us-ascii?Q?a+42w7CRGcHsg3lgOXoVSETlZrxuoaziM2ct47CmjNGGo18jYYBCislcK7b7?=
 =?us-ascii?Q?Xer/gWlRtO04V62B1mx3+w5fOMkLNGbS6YwcJoMU8FTWZTW+x55xqKsiJZEK?=
 =?us-ascii?Q?iVK8gvfVrw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddda04cd-e450-454c-9bba-08da1d394022
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB4688.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 10:34:55.4728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Al2AtBCpJXmsu+XTxrodvHYXXV6k75D1mi/YVmTBvEmJbLtnoXbSD58IPXWpK+9EdtNZ1n3UnovLRLIKSt5nIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4082
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

