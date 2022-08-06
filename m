Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4F458B5F3
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 16:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbiHFOMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 10:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232039AbiHFOMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 10:12:01 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A1811A3F;
        Sat,  6 Aug 2022 07:11:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n7rciMYXhiYH71GwJ6f7RYZZJ/Q9ieTvwPJJS0mpJVZ2GfF61D7PuQwazCz5pIDM0y2TtS1/GPY9PEFP4hUtJJZlrafjLe8a6Yjc2PTFcsKCYYjsPv3ik85TNvGjBT7gkECNRkLE7WZnDcXhbsQSi0pawgvmUJoZMbQcBYXzYhGgatoelWWabqPx+yh+KYxepzGLbNW/YfD2e3ihWMyK489ieR6GtrBnBME1yBD49d8s3ZJpYQZYmrE8k/IZ66MVxa9b65uX47YHtCD7KGAYWR5y3EDfTopILu/XfqmH/5JLjtE8anzKjkaueHYX+59AU0Ads1klVfGuhuybURuRFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qLUi9UGhi/FTRnRZH6wTWctI45lKZ73jWygFrb2yztY=;
 b=NwHSi6n8iI079Vud1PrTTJ/OA8k3m87d+b+h3gwizOPitP/FlGeMJpzJrGRQgj9FkRkYSJQfstN4g2ffmSqlJuE4a/IS7VEZ29yITiFu04aqFcTIY1LbzDSpYwoURs+xl3qtiU/rfXL5SP2oZS9zg4W3JR882tZFqZVsbgMiUZXWdGzLrKAxZM/j3WgHTZ6/+nrs7gpeaXfPfP5qF3e9i2L6Brh2k1j27PPvO8dG9eRh8d8EdwS7vUKb+pECpsOtXLL0U1Pgyl8xQ2rl5eaui9AHeyKiFE+SR+SSNP95NRI2FAQKVZm1Xl5/bmUGE9/RvQwO3pPKwvXMA6JAjNXOXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qLUi9UGhi/FTRnRZH6wTWctI45lKZ73jWygFrb2yztY=;
 b=RivOCPdqAjvCxyZ5mu3ml5KpcSCV88VvG7HWS/Qs+9YZObDNqYC7d7Gwpc/M0tEHPFeIv2b8cePeczi+rqGeWuLl7Tl69mk7VpdCkpbqMFocBB1mB7+shF7TB7qqyJqyp5va2pLU4zWaAdIq7qMrp0vRTgrnPvdJTx6TZitCA+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6988.eurprd04.prod.outlook.com (2603:10a6:10:117::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Sat, 6 Aug
 2022 14:11:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5504.017; Sat, 6 Aug 2022
 14:11:46 +0000
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
Subject: [RFC PATCH v3 net-next 08/10] net: dsa: avoid dsa_port_link_{,un}register_of() calls with platform data
Date:   Sat,  6 Aug 2022 17:10:57 +0300
Message-Id: <20220806141059.2498226-9-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 74bb33f1-6e7d-4542-d2d0-08da77b59844
X-MS-TrafficTypeDiagnostic: DB8PR04MB6988:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HkFVoYdxfQAh68iW2adeUMNSJrnle2XYkHQo0OngF5NsJcjyaRzPDn5O0mQ7qO5sgwAr8ymF1u+u5yMraYxCQmCx0o+mDDyA/oedEPWojtSfFQfj1wS7myrJ+ww4eHc1Io8i797lxdRo24Z17K96gu1kpRCuLYe5p4btyprAMu4CHUwlWi9TaqcHDfmvMDgcaG42tqNdudOqTHYVNjXMu+PMLQf8p0k+d3Wso96THhcCiD8Unlt5bwNZrkYjcx5tlrw8sQ8K7tDIY/isDayUjDIq/yYT02H0f5Nuyen5CypBDUo3F82m9qRXYXYP0XYjr2DNtbhx6auh2bMXdhIB0qbBCZZxVlOMUgYcfyx+5viOqii1uDwOyWIz0/6t3++Zxdws6j/gK9PBPFc0IrPm4HFPczMdmsOFT9A7xeldrrixQ1BiYqNdO/LruAO4gt/2KmKRA1VgclVaG6vg8+Rw0tIBRGAIY/YS8Ns7U+twWdumTAE5zaL/0boVfHSR1AEctZBdjRUMogHTPSQp16AK4+iZxUqJSUPJTwMm8SFeeDELrSMbMyOmMCQPgFW8SU4LRp91Vpu4HjJyjm/XnpR8O0GuwDatAF4wfTCTADDUCaUa4rLQaPd9k8zNMR8lF49SDWm9KSNN1NgrHvFySrQYd8/qn8bzmpjl136fYnlQYtCRIRnsKPKbHSxxqXiCxiQ74pBgD5qm51897eBwf8HR4aia3TV97nSidlHIRvYR8rKzrafI1PyOVyf+w+E/mL91gElddIKCELS9itaZXkAxKLauCOF8gQMR8ESOKzGIJhY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(366004)(5660300002)(44832011)(7416002)(7406005)(186003)(1076003)(2616005)(38100700002)(38350700002)(83380400001)(6666004)(52116002)(6486002)(41300700001)(316002)(36756003)(6916009)(54906003)(6506007)(26005)(6512007)(66946007)(66556008)(66476007)(4326008)(8676002)(8936002)(478600001)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f5PpFWSGgGmM0Z7x4l4FnU3MVmvBvrc6NZUYYLRWJqW5xXkAKFYw4wr1zmBT?=
 =?us-ascii?Q?szp9WvdPoha/zV7lG0cLr2c4b6zjhDJSdLZwwTWYZOrSv4K9kaPfPAntB//J?=
 =?us-ascii?Q?cS5SZna0v8uq6xRHgjBZS6NqhVR+6kbKvt9xOmXypXw1Q7lrRw+ouigGMjX3?=
 =?us-ascii?Q?wp+vlF5wHpGicb4jKn5aNnypZ944EEM14WZoC7KuOCGd04TKHJU6idZwlwhH?=
 =?us-ascii?Q?wtBkJtaoKpfafHVTwFUeZsDy5sN3lH/pd2gCaXXmirB4q6AHNMMi12N9oku7?=
 =?us-ascii?Q?WZLJGqnNI+y1ZB4RkSajimcFp1ELcUGP8Z1D0aR9+u1THUxX96h0pKVBGUW2?=
 =?us-ascii?Q?Jif2fgvSswkxL1ivmEpUKI1JXZF0HqRcdGNwhSD/5GFIgduc0clqlW98cBaA?=
 =?us-ascii?Q?cxRZDfQwSzP651WXBOQe5vT7VAjnPtP5siTGmMWnKkuWLHWq2YZYnHhdT5j6?=
 =?us-ascii?Q?wZ8tMFIYTZN4xq/ctTsmIvrNMgBCa02zyNT766bCG/OtgAsKkLfRnympDXJt?=
 =?us-ascii?Q?b8T9TAJV/rT5QDY+VKo92YxVkCoV8A+nWC5bS2iyenbMDEy2qsXB/kKmOABy?=
 =?us-ascii?Q?2Pjn24g0u6UGZiT1DqYHtVQpaeewJ0z59YTA0PFW2AtdLg7lfTkwtMW49Ftj?=
 =?us-ascii?Q?WffLQ4/PGee2Wce/22D8jCUo6TRZ6xFea02FLYLWya6kbxxV2zd4jrP2caU9?=
 =?us-ascii?Q?pHGQUCzlC1CX9lGrMAWQ0ENgIMjwK/LWownns5+f/zZyuBpR1uHK5PVu6h3u?=
 =?us-ascii?Q?sXf2wwao4WOU76UUE1SWqxoymCdNOBvP3QtsVy+rQitSnt0XGc8XFA1jegLm?=
 =?us-ascii?Q?lSJx6SMmLCA1Lj1B8Mn0qvp5DhXl7OthTP5FGYQ6GTs2EbGKovIqrhndOME6?=
 =?us-ascii?Q?eXgF7i8h+ROXMBiWB67g/15nYaybBH3BHMLmKEtmAG4HbZOOn9ovzQ3bcHzv?=
 =?us-ascii?Q?ST1Lyto3Ri4/xiMvqxHMt+vA3aEXR5PvN149hzGeV8vp71aLjnXxWuzvEkoR?=
 =?us-ascii?Q?n0zXXXPHUAOGLRMT04MTTsAHB+bjJ33Kawq5M/ZGstPPN19hzQsiry/MneCp?=
 =?us-ascii?Q?HU3h3oDLl2VY3zzvAsMvL62/X202iRW2iRrO2nL7ifGnPeQhHr6WICxFyywU?=
 =?us-ascii?Q?7nn51O8OZaeUfKxhGXzJuY0SitiKOp0F0Z1JqStlKXxyhTTXmgVr3bI4KzuJ?=
 =?us-ascii?Q?Qu6TY2Fk4dCvoeC5NZ1gUvXXsBSoNDtaW4KEldySFItOHFuLmcPYgAksj1DC?=
 =?us-ascii?Q?YMWjKi1waSRUyne1GsVBcZuhgbij6FqYzMRandSSXvJJ+Jrh4+RqCKgorjcL?=
 =?us-ascii?Q?wGWuLP0qoe5zpFrW+8q6Z60WUToUiIlvFp0gEy/xCj9sFenP5VO7Hf3wfTwd?=
 =?us-ascii?Q?sVtyBSzqmJbkSUQV7jJEIdAmJlz41dgOLSptBWS3yEVuEtFbLQ+bhvw8uLkw?=
 =?us-ascii?Q?75HWbvK6IKNa9qaqMtL66YFwN59q6peWclXD+HKUB4c2mL1OgmQtVCKLghht?=
 =?us-ascii?Q?vHKb34mZW/M7Yq1MZLEx/IXqLl1t9939N0c3dW/ugqB6FCpfXFBUr+UUNMwr?=
 =?us-ascii?Q?31Aj/7JHBwn8+MjFIwtge844yupq82m+GPbR7tzWRpvRm5MVPKGZCa4JTeXK?=
 =?us-ascii?Q?nw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74bb33f1-6e7d-4542-d2d0-08da77b59844
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2022 14:11:46.5341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGYD6MxctDZyRHeXSivqBbKh4YcqxpEnBDOuEyjgWsSAbm3MUSKH17t9SlWYKkrCuwPzC0TOiSpqK5ENr6D8Xg==
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

dsa_port_link_register_of() and dsa_port_link_unregister_of() are not
written with the fact in mind that they can be called with a dp->dn that
is NULL (as evidenced even by the _of suffix in their name), but this is
exactly what happens.

How this behaves will differ depending on whether the backing driver
implements ->adjust_link() or not.

If it doesn't, the "if (of_phy_is_fixed_link(dp->dn) || phy_np)"
condition will return false, and dsa_port_link_register_of() will do
nothing and return 0.

If the driver does implement ->adjust_link(), the
"if (of_phy_is_fixed_link(dp->dn))" condition will return false
(dp->dn is NULL) and we will call dsa_port_setup_phy_of(). This will
call dsa_port_get_phy_device(), which will also return NULL, and we will
also do nothing and return 0.

It is hard to maintain this code and make future changes to it in this
state, so just suppress calls to these 2 functions if dp->dn is NULL.
The only functional effect is that if the driver does implement
->adjust_link(), we'll stop printing this to the console:

Using legacy PHYLIB callbacks. Please migrate to PHYLINK!

but instead we'll always print:

[    8.539848] dsa-loop fixed-0:1f: skipping link registration for CPU port 5

This is for the better anyway, since "using legacy phylib callbacks"
was misleading information - we weren't issuing _any_ callbacks due to
dsa_port_get_phy_device() returning NULL.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new
v2->v3: none

 net/dsa/dsa2.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cac48a741f27..12479707bf96 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -469,10 +469,16 @@ static int dsa_port_setup(struct dsa_port *dp)
 		dsa_port_disable(dp);
 		break;
 	case DSA_PORT_TYPE_CPU:
-		err = dsa_port_link_register_of(dp);
-		if (err)
-			break;
-		dsa_port_link_registered = true;
+		if (dp->dn) {
+			err = dsa_port_link_register_of(dp);
+			if (err)
+				break;
+			dsa_port_link_registered = true;
+		} else {
+			dev_warn(ds->dev,
+				 "skipping link registration for CPU port %d\n",
+				 dp->index);
+		}
 
 		err = dsa_port_enable(dp, NULL);
 		if (err)
@@ -481,10 +487,16 @@ static int dsa_port_setup(struct dsa_port *dp)
 
 		break;
 	case DSA_PORT_TYPE_DSA:
-		err = dsa_port_link_register_of(dp);
-		if (err)
-			break;
-		dsa_port_link_registered = true;
+		if (dp->dn) {
+			err = dsa_port_link_register_of(dp);
+			if (err)
+				break;
+			dsa_port_link_registered = true;
+		} else {
+			dev_warn(ds->dev,
+				 "skipping link registration for DSA port %d\n",
+				 dp->index);
+		}
 
 		err = dsa_port_enable(dp, NULL);
 		if (err)
@@ -577,11 +589,13 @@ static void dsa_port_teardown(struct dsa_port *dp)
 		break;
 	case DSA_PORT_TYPE_CPU:
 		dsa_port_disable(dp);
-		dsa_port_link_unregister_of(dp);
+		if (dp->dn)
+			dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_DSA:
 		dsa_port_disable(dp);
-		dsa_port_link_unregister_of(dp);
+		if (dp->dn)
+			dsa_port_link_unregister_of(dp);
 		break;
 	case DSA_PORT_TYPE_USER:
 		if (dp->slave) {
-- 
2.34.1

