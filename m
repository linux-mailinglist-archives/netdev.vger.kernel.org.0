Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C69558B5E5
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiHFOLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiHFOLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:11:41 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130071.outbound.protection.outlook.com [40.107.13.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F292712604;
        Sat,  6 Aug 2022 07:11:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LGvu0Q5Xc2kfymP4C9Axu2TrecoO9S9U5rh5mXVOk+HkR45imvBNNkqa9kidfvKHia4jA80m3+ApcTYF5ZW8dUGkwtx/K9DzSgpzdI+yFikRKW0PRlHdlUtZW4dcAA5g1/KjvTysBmLpOODTinNk2FQsSZdvw0iy4R9J7mq/TMxukeiuGNsBIQdm4fX28Me0Z+c/db9M1+Zz8d4VKZKTol5S8OWVmPS2oR/eX3HfnufsYG3OgGlPC7ISOh1Lp3BbixPqFebSmBDS9unjh0TC1vgntkzXxtxTxUrm8hIcI/tbdyUXoFq1ehDd6A8UXNRbNSS5sN4TA0PQZvIlOBHJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9j1m9+uZLoW75wjkbY5+CJ6yI8Q1KYRDrzdtNSlMHWw=;
 b=FfyhrqZpzp3B5Crwk8JHKVCjGBGgLcBqBSdTD54WEL8OXC3iF/FN5tXqpJloCY7AWnajgtODRMIn44TlC1AKOAN6qXJXzY5bfZVhlqon6gG7BArDsNmMlkNuNPzQIdGz92cf2sNT2WMYzWOrlLB0iBrHc0OuQoRzjGBPEuPuxHZlkE+KaQDnaYHYyLSy7LLSM9MKOUADO9gJxGBndplQcNdieQylNuAjpWzqTfxxTmP6BhsMlS4WguPJMAWIZU+FYxl53or7voc1zaa8DNr55Y6bqCdedE7DL0EvyBpjjak/RVTzjN7+JejdtpBbKyDS33/PMZO7j3qnjImBTooZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9j1m9+uZLoW75wjkbY5+CJ6yI8Q1KYRDrzdtNSlMHWw=;
 b=d4V+jY1r5tpnG6zXe/8z7M8C8tiPnwNN0fmw6jcaAJi8xzAHe68Nx6G+H0B6Mje9eQN2l6MyQUCIK7HTXmlzuFfdmc3zRLJzHP9AIkFIQfDP7Z/GTQZC7E2IP0BXNTipYXmhpK3mSIYrv80c8N6plPCBn1UBhKK76mesB8xRD2c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:29 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>, Marek Vasut <marex@denx.de>,
        linux-renesas-soc@vger.kernel.org
Subject: [RFC PATCH v3 net-next 04/10] dt-bindings: net: dsa: microchip: add missing CPU port phy-mode to example
Date:   Sat,  6 Aug 2022 17:10:53 +0300
Message-Id: <20220806141059.2498226-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0802CA0016.eurprd08.prod.outlook.com
 (2603:10a6:800:aa::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c21e9946-e191-4c0e-9d02-08da77b58ac1
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q4+pjJ/CU/TKEc+IBA5utMVJzAH36wZnA6rB693E6pLCN0bvYd2QK8fOcXM9ZjhO8J/1DBCDtHq8egAyg/N8caH6lESywzN+fCsQsYVp2rqFGyVCnxFbQRkCvPwjIr1oLxj9e4A1WASVdwEpB5agBpuWsKcCFHjsNwKJMDtnVsUH/Tukfu953yQ3nCTd2idoDphvX32dFKQdk1bVuGtQhPy4sRfQ+3FH/YCu684OJaOudieJeR7VsI2pIUFJoecMYPH2pZDgnN7D8YY6p4TrSTBgB7FUOaXZTv7CrTe2QRKJtJwhcUGH8QSL3WNiy0Qzq+3KPeh5lXmOBm7wIdXbmPRxXKEvZ38JrwhAy9HFFo7/k5lqttgoU+9IVqUrQiW1Ay++Xtz1Tf84/yFHjD18AAnVfKeTxvga4ZbBhfNGazOOMS80YINnLT+aNLE5oZAI3BQpBTZu9czd6GcsQDohzlnBTorlXDEhyNqMnKXFCOFga5LVaS9czKaQanOHp3Q90jQG3SGXQyP4iQ33dfp6ld29aguWkVmpeiNl8OANmqoqNPSNCnVD8ohSFu0EDdyt4QJ7T5nTXJNYxxrJJAukDbwC8IGTJ28Bw4hWWlJrpVzgKtAln40PFuxUUswDC5m0fBmyIn31zkXv8dD2tJK/Qc5o+GKzDRqA1V+Jmh+CKsxPLAlj3zFt+1oGqbrXN2T5qIyz2Nj31dDTVk7/m9Px6ckqhRcE0mwrzymhSMgYEfw/cmYHHtgzEQZNgq4t3lrt5N2du22WvyigNdjPYODBLY6j92IHGryksc9DvC5sejw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7XVZ3dh0ZPJb469s4yHaxcSdNqI6SZvIq5h435PijqjcLf7WK/uoUJJLtm3O?=
 =?us-ascii?Q?VB1bZNvGgdYtznBgTM4s7VqKg7GKGhXmYTWUl6qmVj2XXb81/P4CtEgxz7R0?=
 =?us-ascii?Q?fNrSMYZok12iQ0SMgEpYD+z2M80l+2bQN4Jn2bjPnxaOuidpPeVKQEgT4sVn?=
 =?us-ascii?Q?hywUEazteXW1jH+hab8RdjMXivbxIQGBA04Q2LZa7ebJh6I8nHgz5vvqRzwC?=
 =?us-ascii?Q?0iyjVbfObiRtr513IhHl+jVl8PpF9ssw79oFMoccw8OxCabtQOBK/oCgzY5m?=
 =?us-ascii?Q?9vlAJfEKbaAcwODugxzYSW+ghuE1yMZX8Te2hQiieLWDK9yLztw3wdB96+LW?=
 =?us-ascii?Q?IhyssTmKCwOuNw7RTR1Q8pvi3JNSVaenB9ArSH8Sge+q4X1Xlhue+b2/ch40?=
 =?us-ascii?Q?taWUnCv8GhTBLqyHCkDMC8uwlX3I4ds6ikwAcz7tmtLPk1hmUlTzLqVe1fg5?=
 =?us-ascii?Q?wOxlg1KF4xDxHQkdk4qKVo/RInhnJJpZFMthM505NTNAzp4QqcClJKyUGYOS?=
 =?us-ascii?Q?QTtBQSG2Etjd8p0AxowbdIw7o+IyrQW7qheazBHuYvo+XGRgQL6W8Jhhsaeu?=
 =?us-ascii?Q?3xerLYVd8f7v2rLW2N6lB9MvrhQFk4OyOGNdCV67ZGCoeHLpZx2/W2+5ZCmQ?=
 =?us-ascii?Q?Ga339uDyYKKIqi4V1ACGjJvQF+T58xRbXsAegMhIQdFIBub6rujl9E3nPMw8?=
 =?us-ascii?Q?WT06pSipmNcaE4yIFcYuGjwlEcmyp3LaYVnKSVAobKN04rqnFT69orV6fELj?=
 =?us-ascii?Q?GPigkA5MwIUI8hhB8JRB5Ascr+grG9MbLZ66BIuM2wfFAMo8kiVmbtrDvdzZ?=
 =?us-ascii?Q?yqb102t9bhgqKtd8WmrhctGdDUp+1684qMRfs2c6kr/Q/DS+VLqLCOj5jJhH?=
 =?us-ascii?Q?V2TNGCAXkGqCPORz35iaOM130dHKCvoK48uFKN3iVChMZM5bvCk7TGdyWcmj?=
 =?us-ascii?Q?fdZXkOhZQdhHn1srSarohW7SD2cpTbElnNNep3lm8P2N2xPSB+aVcz7TzcjO?=
 =?us-ascii?Q?kd4AA+prMIdHhjVYRcMStJcj6H/rbNe6Y9UfqK5NOZyiir1xzMYnPwN8AFvr?=
 =?us-ascii?Q?U97vSCEgbBqlhGPvIEWjXSW1DVTy8hz6IyNW5IJNAc0LNhKSQ5ebThI1ZTwR?=
 =?us-ascii?Q?5n/xRzTryDIKviU9M09BPhCF7kefavyB2MDhXu2exgpvkZZiknJ7j+5xyGhf?=
 =?us-ascii?Q?xXxztqTjDBJMY/IgesRaIPWv2983Sy9vRV884/yf0izyezTJvl41UR9882lx?=
 =?us-ascii?Q?9ubcwdEjHtLP5IYeR2SE62A/AK8x0n/8/EI+waFV254Fxqyw/3hYrQhHFXQo?=
 =?us-ascii?Q?gYG1AEChaYLK2f2cNFA9HMhmgnNAvLhz2GQHwMmnsWsScWu0dQcR9wiO3FfU?=
 =?us-ascii?Q?51NmsRA/M0VBV5Yg3Aq/Tc0MLWjz6iJm9L9pOzGtI30XLew4R2R/aipY6KtD?=
 =?us-ascii?Q?FGls58Xf8EUWVzA05pRcXI8HpocIvbWc4OmAPm5ChxDC7JdcQ5Zxb1fU3F/c?=
 =?us-ascii?Q?Rb3d5wsqdfMaQnG5wzVpCAaXivyVeAxzjNHYtoeBaBPh8aTa8C+al6ZJCddN?=
 =?us-ascii?Q?rqZTSvDd+1kRopSiHHykCX7n+5RdCGDtyWUYb3gMTJoMnx0EGw4mo8etf4jA?=
 =?us-ascii?Q?dQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c21e9946-e191-4c0e-9d02-08da77b58ac1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:29.1447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6lAtzE+yCBKsupQppTIQDJ4ZtVMyX4jgscwtQJpw/pIIh6VBpgWGzEHfPydyoq6UiMUkM/Sl0DavvF3t5Mz0xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6988
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ksz_switch_chips[] element for KSZ9477 says that port 5 is an xMII
port and it supports speeds of 10/100/1000. The device tree example does
declare a fixed-link at 1000, and RGMII is the only one of those modes
that supports this speed, so use this phy-mode.

The microchip,ksz8565 compatible string is not supported by the
microchip driver, however on Microchip's product page it says that there
are 5 ports, 4 of which have internal PHYs and the 5th is an
MII/RMII/RGMII port. It's a bit strange that this is port@6, but it is
probably just the way it is. Select an RGMII phy-mode for this one as
well.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: patch is new

 Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
index 6bbd8145b6c1..456802affc9d 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
@@ -109,6 +109,8 @@ examples:
                     reg = <5>;
                     label = "cpu";
                     ethernet = <&eth0>;
+                    phy-mode = "rgmii";
+
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
@@ -146,6 +148,8 @@ examples:
                     reg = <6>;
                     label = "cpu";
                     ethernet = <&eth0>;
+                    phy-mode = "rgmii";
+
                     fixed-link {
                         speed = <1000>;
                         full-duplex;
-- 
2.34.1

