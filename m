Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389AF58B5EE
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbiHFOMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiHFOL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:11:56 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1792E120B4;
        Sat,  6 Aug 2022 07:11:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7rUvoZicwen2+EquMsyaB3ShBct+9Qwu7liuOSQsh9Tl2KVcaJnNPhZJXPkd50sTInsSSNLpGkx+yAwejHX7v0K+l5g33sN4tRR5Mn1a1BIMX7IA+X/B723parWvS3nToLEvKnhXYjUVwJ920o0GxsA5MCx9mVrNFwyxOJm7gHjos+yA+90wb08c3U5464zYgMmQ8mklj6vH1ISGmqbqhl9bHfmwB5cTEA0y2hBKwWsoAxhG1pS4n/ZrCWKWfdtlfQbCUS6FICuT+rCSBymd3gibLV7tofohS3oTYAZ7/L2p45jSk91Jf4S3sl5EdqdjA2X6g9N2PiunQJM547D1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tESQFWlBU7lzyNVQzGvgfOoKq1bl40zezgwY+87T1w8=;
 b=JExAVp6oSeiS32jik0Ptfol8VIV+5r2PPOLeVZM3gpY+7KJtFRnCBacz//acFHmMUoFEFNTYqdGDwXIPcH5VBsoJ8G5G84+Iu1/F9b2R5/SIPsE0xkLnzQPhvnx0vav5HoIKkjZysDx0F9vFSKfQaqmxkxoAPVaY2Dy3tqR7J/70Hc+tMjFG3CfMhQK2SLmsRt8Nxcx5qa7+9/7z5ybSMQwCxzJcGOmfXD99vCmkWi9ppdeewixNogQfrP+fx8mgIHasWQO6r+K0LQufTI6DvCqTxAXVxQLQMYI3DluTG+UzConEYTS3te0wwGYeku6ubOolhhLmH4IhKtGbkKktUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tESQFWlBU7lzyNVQzGvgfOoKq1bl40zezgwY+87T1w8=;
 b=Zg72+7dBNo5qstk/KXB2pLaZxc6TjgoM3SPyIn8SxrHDnFMR6L5kkOFJVcuJ8ffiqs7XXcF8Jd0lBrcBtx5vNx4hv+LAdZFhCMXvmAhjyWYVGf9WVTX9V+we1vuw5C3Wz/7plgKt9zE/joSZwKJavRxQtnlkMfYUVCQ4ASP+mQY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:42 +0000
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
        linux-renesas-soc@vger.kernel.org,
        Frank Rowand <frowand.list@gmail.com>
Subject: [RFC PATCH v3 net-next 07/10] of: base: export of_device_compatible_match() for use in modules
Date:   Sat,  6 Aug 2022 17:10:56 +0300
Message-Id: <20220806141059.2498226-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: e17de8ea-156e-4e1d-c139-08da77b595be
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GzdHR0kPvQZr57XdCbZHjcXu38oor4fEaU2vda9mpL8YheCE83LBrXgs8AFFjkkrdkW0fJlBZuk22emUO9retwt4YJLoLK3g9uL9lew5r2GUbNKgv0uNtOaZtXGleYSPn+0aX+YdPhH80kuF+mACJaS6Eg7uDXpA9lyf8mfioNdcf6/WuP2DVuz61mdScFkmFzaAUtPePYdelev2ozkXvkv/40Tzbtj4IkC/NhSN/kuwpE96T1WXwxkWIGCtZIaLQmjBeKdUen6F8E/w/uJAYMbVzJEC1kMa8DoZv2xIwY73jnvmtb7QLoZksok7t80gANBYW0SfU0lGedoZn2y90zJPcPFKMkSb0uaQ7k/8TQrwC4AsdXGpAa7MDhT9YC+a7Abx5MvuLYS7qrTxwvNnAl4oMrAcCWlbPJMpcIEGxmzgMCw0f3SfFxGYzplBzSCeo8sYYzK71+1NhqidmwlV9fWt9c2D3dXsMyT9cuQlfFrClb5AcDzQjbpQA8Dys4fLfYCZb7tGt2qm6vsjhBWz3a554NMYIot/K9WxQr4SFUHImCE+Uvq5ZRx+xB1PqQBOwvWwLUdRo/ZZTzDzXaLHDBtSCEsRuCJ4Y3XdQjOtE6KxH+etUnBRJ4XId8Mw2tZvgcs2giN8xeDyQ6w+YDQF57Ijm4KksxNdd2tg5KpTvSB2g8SwgonaJXl0aEZ2rE/BbZnM9k6VO3Dz3LwCEBwHFZ6XInWI9QSN77et+jRB7sRZlzjRkbB9sThjHSVH46NYt7wToEvA8tlWh1Deff6OT0EVt0YL2+uqlSGEPzEsrck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(4744005)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(83380400001)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WS6OJdtl1YqdMu2gtIeckEdCIQAs8BWgdjRjmg7ffQZXTkeKZrhlO1p4hnMB?=
 =?us-ascii?Q?lpNC69haSir/JeBHnwJercyCKcaso4EKiK3x6aYqr7EnQZ8yzXhkDPDYOyD4?=
 =?us-ascii?Q?+6NRLCniG0/nZmvQobo2zwVGYTerRaNazNxlhRjTxwDcm9j1B+DOTFFJrgue?=
 =?us-ascii?Q?zEPWdlw/u54Hlwi8XRSF5kPs3pv0PB2hDutQxxhqj3iqAv6YUhtZS50+lG8k?=
 =?us-ascii?Q?RGPlvTQTDd2m1muiRIrPNljFxEN3dxmWZ6hicXCyxZozYq6I9rIrciUlG0yT?=
 =?us-ascii?Q?gKL52anHUqSnVqQt7xfoPpR68gjcPOKH+/86oCRSHQlesuRtgwgCV+WxfcSi?=
 =?us-ascii?Q?kUzei3lTnsfd7aQfbiqbVmKL4tSWC2tv92Abih18qU1relb/h8ImC2eJhkKr?=
 =?us-ascii?Q?HnSwRBFVPPo4+XlQv6mpg8B1go5QyKWqXCVBwmSNBts8QyGYAOltJno1EuJz?=
 =?us-ascii?Q?vWraKONVjZpx862DyvoRBWCmEh7FOt/QmW6uR1u03i9QpkjUSVs6xfBLoCNX?=
 =?us-ascii?Q?nk+5V7UQ0j2Esd5xpST2ngm45hE1UHV2WtfnTavD2svK71tdJXgAu7HVPx09?=
 =?us-ascii?Q?OdWbsiwV90YAL0USCpuZs+YD1J82uNCZSwfyS90gssf2vKFxsEdYcI3cwAFl?=
 =?us-ascii?Q?iWBDH4abbpyfo+dCzBEehYSSY7oT40cU/CjpU/xgZ4vI3SZ+rwxtSE1gdlro?=
 =?us-ascii?Q?WmH4dH1M2DiyGqmTU7kBPPppAR5Tjf0w1BDAdWjSaoSmu76U9mBBrZcMnY1h?=
 =?us-ascii?Q?cyrs9L29khvAnOnFIzVnGXMyIBtA/yLGVSCcWoMDQL8Sd6rtt+ojS1VBbEhE?=
 =?us-ascii?Q?jYbbwbkUyA+K3UqG0pDIkAQ0JFxVmLMBWB/tUuGGNOwZUc8YvUiGmUvJmVnW?=
 =?us-ascii?Q?kJpTqcjqnMKQSM/2eZdlzc7ZSIvUhdmXkVsUtmOXsYapUL6miCEzKodGEGYX?=
 =?us-ascii?Q?gns4yE5xkXAMrBJWQk2qnTWDIcH9bm8dBBaNZfItlL3oG3HPnqeosK7PY6Jg?=
 =?us-ascii?Q?5QC2VDDtzebq6cGZRu6Kvw6Idw5W3dRqiUh+9dDOweyzUi2IrGMGhVEdgsjo?=
 =?us-ascii?Q?mCk6+lb9GkCEq/rtLrOFklXV9iMtrmb764RbiarlisS4ln59CWDLExU+BGl6?=
 =?us-ascii?Q?h6qqzcAKeEouxUc3vaATWKiVIiAmBdkIfhKGd7u26Hy7hTTJVV7UWH0wPblN?=
 =?us-ascii?Q?3K0aAQzqUaoRxZHYiquEKAftpOB2KrGJoecOpd7VkCehrrTz8a0KoUu5gQ1o?=
 =?us-ascii?Q?t9FufFs9jzpsRLhGUEN7pkztQOgaAL5ynSJqglBxlyLxzbxretIA+81EjDE/?=
 =?us-ascii?Q?VDHBr44FzBhxucYStfBOqDTbVBdjS1tUMkza9LVRQIq9m1Xoig2zFfXlWJgv?=
 =?us-ascii?Q?ipXhpmShndHKzjytqYY36t/lWzn+xI/bMA9DvcVHHoQctFDzOpFWwPITzuRP?=
 =?us-ascii?Q?X96u0UhuJ+j5QqDTLf98equLAUJUl01Kz/nZvtm+Rn+xES2f4TLmHNvpovJH?=
 =?us-ascii?Q?XrX3rcYgvjU1CaJypYnCodPGjWvrjPZYWmlkfHmGOQJS6Cjr62rjWETfEdsM?=
 =?us-ascii?Q?31xUTAXmyXxVq/ceDjj0v7Hgx2RnAa56w/LekmeeV8iblb67v7ca8ib/2fDu?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e17de8ea-156e-4e1d-c139-08da77b595be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:42.8781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBIwEuVzJDUKgZNOm+R4bINZswSge3H44wrXFH91OpgoPCoZwvzF1saQfBiax0/iMG5i/VirH7+x7lY29uSwAQ==
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

Modules such as net/dsa/dsa_core.ko might want to iterate through an
array of compatible strings for things such as validation (or rather,
skipping it for some potentially broken drivers).

of_device_is_compatible() is exported, by of_device_compatible_match()
isn't. Export the latter as well, so we don't have to open-code the
iteration.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new
v2->v3: none

 drivers/of/base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index d4f98c8469ed..5abd8fecaba2 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -578,6 +578,7 @@ int of_device_compatible_match(struct device_node *device,
 
 	return score;
 }
+EXPORT_SYMBOL_GPL(of_device_compatible_match);
 
 /**
  * of_machine_is_compatible - Test root of device tree for a given compatible value
-- 
2.34.1

