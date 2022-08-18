Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAE245982AE
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243375AbiHRL4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244470AbiHRLz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:57 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150077.outbound.protection.outlook.com [40.107.15.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E9AAE9DC;
        Thu, 18 Aug 2022 04:55:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXtOaLyWFwV9yDnPeRY0oGT5H9Ycuf1urU0aV4RrvADsJd3q9RnP5myJdxC0ngyfhAUYPlkE41/ojpc/PCVwRRf4NTT1D/rTuuT3BYERrhnwJGr1QzD70NGAJDioGOspuhJNEWgOpDjOwyWlMDhZfqemDNKgO2GfO5HX/sZHooj8xnowsU8n8OAZo5s8KoNCL9TZNnYBigjqZPEsn0JV2NqohjtroRmqfSERwlPuxXkPOWD5ohVgxHaf6NZ2Fa8JuAYwk0Vv0wNZaoWW6VWBCIhifvKpsJ8xzYo1o1xKp/GrKc8v5JLVld4euRZUP7LKmj6FIqdCPqxMYCTdMS+cxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2fWzPtnisSvX73UOST0tKHp8QV0PdrYL/Y9vLCin2k=;
 b=S67AT/zoW/g9LgalhSMlYLtGDc+sf8zJbfyXjICYfGpFkpUdQNdhUI3d1qN2jvcniRW+xWFF7UP3HdWu0LLX+kOGwMoFRYSjgnmFHnma4DbDjEAny1p+W7Yd+H7IedXsMKnNjPQuqkr0e7lyFczmy32QNT+7XINlU9vNiX1RLu3yBUcp1CqTehxhCx2kcEc5TTuHQNOp3Xe1cYVftO+8rSxpXTrNPT1vuTKzWeZeMTTmNN55WlxtxPz++0iLjg0KrQBVKxSwE5cORgnEOc4VrPv1yERzELjKLLOuFKeYLLqs6JyLo8DP17a7SPpQVzVGfZAy/M7oPM+6OoWQNos2HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m2fWzPtnisSvX73UOST0tKHp8QV0PdrYL/Y9vLCin2k=;
 b=mxuHABYlErOKEeAXBU7RP5hGjcvFkgqa1IQVuMhf4qeir5r8UB8Su3dabw6G3j8rp/wX/B8DS4StGpuX4ulGrChqr701WjMM5MDvJeW+ynQMCZI3BlVh47EMA+VcTbdIW+Opji5C0gpOUw+ubLM8I3qDKpAig8EPFV1+Wba9kqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:54 +0000
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH v4 net-next 08/10] net: dsa: avoid dsa_port_link_{,un}register_of() calls with platform data
Date:   Thu, 18 Aug 2022 14:54:58 +0300
Message-Id: <20220818115500.2592578-9-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
References: <20220818115500.2592578-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 743b406f-1c53-4059-a57c-08da81109a89
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ho0SuKbfuuGwnrNp7sgNTmYGYMrYS3N9zkb+cY4uDQbNheOurQwmX+JbgW9aGycVag9lWY6/HwoksnSk3yO091etF0Ht+Wmk/cQV8x//UMt84fFoqquiZuEWiLcHfw+js8trsP4xLwFFzhHcWgOlVXZ7rYK7ZRjHNsDXCfWSkQhc01y8Cn2C9xUyi5GUvn3zQb4XCykAzix5HMdbhbq5XRpNP2pSNARFtl/5CBpR/m3bteg6e1Ehheem/iFrkQvCRHxcUzHVMhMOqkkoKLqAtoNqxD79XQcdzlSUWkERnAVf4ime12UWKJFWBqLefKmhK2O4fBe/Q+C0WAicHSAePppn9RG/K0Z8fYW+WIoQH/4x7CBfmOVJpXm1bjAFw7gPhZdA0uNo6BXf/Ole9FVO1IhFrnQ++Znr8SUCpm1Dg3Gi5xyTebvHPbb2Jtl848YvRdxtMZjbFKMLzB9WyQT/49NovCCvQL9le7vVYGkU7/xeaJX+B9O/aMe/b5FjjhpQBE1Bb38fUOcD18x3d64xEDokMBSYHKeOxJSHYMczZfy55S1je8JxG+XUne6f0JtJzzJlpeDF5ZdljX2ay3cXGlME6IpuyOnNq0b9KryLC3JYiS8RHqKZJkFwoTd3Jb+uZCm7L2hM50jB9g4nwDkC7R8OAGO3DiSMO6poo9tteVwbZsaMtFI41OL6Qjj8E6V2SDXBHmzjxMNXUC/O07LM/qTHoubfozMW46J+h+ieu8TlS8A1hOEFZVhooXXwVF+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6512007)(186003)(6486002)(52116002)(83380400001)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A7GG6k29wNzR1gjSnVxCpFV5lll2qutK7aHySUnUPKB0fWH9qFUxQ+uAqZpg?=
 =?us-ascii?Q?mrYC5PiJzPch7tXzzJnUt4fmi6k0nah5t6bFHrcUF4KSw5nKrccsa4yJnAPd?=
 =?us-ascii?Q?LkZ9fXyecCiE5gwFU73MHjDJv1Cw4GazE2dUygXzI4Ad1z4M0KRKUXugmSGo?=
 =?us-ascii?Q?BqGvyoZMp7+TU9UgDsmWVqaNsmcGnamJf10b9/5FV7B9XCGHeG8HhcVB3g0l?=
 =?us-ascii?Q?d8QY1H8PyLMHpW8yhOEWXnYaUDpvmhCajuS2jc/JkZoyaf28q6vEzWJgYwfa?=
 =?us-ascii?Q?QTSavUI4ZCZ+I4qThdpYpMMPN6qlwN+wAE1njcR5s2Kxp1TNeOyibbjXACnn?=
 =?us-ascii?Q?y0iw3qECviv+mN9O26zlkbmCvuuSqdEptWbK0+X5BSLzJaazlbY3u5IE3otD?=
 =?us-ascii?Q?JIR2QI1ca+8Ok4CimSNgmbfP2iWBHbef+AlsyBmkiQ9Or45B5vt5XIK4Mf6y?=
 =?us-ascii?Q?7jkmPPEsWkbjPB+sfZx4OwydYnCUxMEqf2feVVp1F3Hh8kSz0IDt8y4M1C49?=
 =?us-ascii?Q?LsQx7qsouiwlWwQdg8+njZqpzyOBalnivUzxYxEZz+/yogeYxOBkgoIN5x8O?=
 =?us-ascii?Q?pe2u2O1M6nlpCaUcdJIGUe9qtwCOh5zLpwff2HV4Wyq3y1tsd69g7+CtHm/k?=
 =?us-ascii?Q?qXJ4EgKUQys+WgU1CvjxZQn2KXlG8nO0hlOCGB0b5Tnvq2GZy1thQ78Qzmss?=
 =?us-ascii?Q?jn8lDQ2i7xAQf1+iF5qK3OpRSenG5N3UB58LHL2Up4K/h91ixFuwho0IuUzx?=
 =?us-ascii?Q?xvPDDVN3dlN37qckMxxnEj/4yvEWFmVFSyRXN36U9bL6flvhVxta0OqDwWR5?=
 =?us-ascii?Q?Hin+QByL4uKiPclyPL3J50Y2Ke3ilKohK01UbfoAtni/Go+L1NOU/8N99FBw?=
 =?us-ascii?Q?NW2bXd4tfE9CPr0pqo1X/yH5YHjTim1Iyaun0uiDo66feo+S+n92dXj3ItEQ?=
 =?us-ascii?Q?c0myJM5P6h8y0AW3oFLfEru+vE7J0tnP/5xXGZVHN3cvP1mEZCNovfDbTpAo?=
 =?us-ascii?Q?+T3e92o+MHnLeUbpj7rLEMmGD5g9kShH6JgSl14P5cOua7wIuKBT74jjbDMY?=
 =?us-ascii?Q?kPdhMFjqnn4OEDtobfcGWzEMS2S7Ahmo9U9aLr3wE+4bu/1SoHGiBJFJ+5mp?=
 =?us-ascii?Q?KfrFczGUqsjP22h7tLsj8UdhVFEKLcVU2b1vwW0a15HIhiXffXYLJrbp+seL?=
 =?us-ascii?Q?oJcCCsULMZb0MGhrMsA0LcyilMZAGLZLsAvgPjXgRP6AV2t9mVK/I35L4Emo?=
 =?us-ascii?Q?ayYf1R261mFHKm3zrhDLE4/YvaJyn+vSXY9QIOiggOYQ97u6Nm9Ce2SOCJ/h?=
 =?us-ascii?Q?VwOLWGSNgLwPnqXHimrpVq5PplWDK7/1n0ErWzaS/WOlnMYpE32jMgqGKU4W?=
 =?us-ascii?Q?7FfbWMuRiD5TJYRGOp0eKqjQJvS6kXoAfGwbj++OwFjKB+SLTBMowl+KKC2Z?=
 =?us-ascii?Q?hV75o3f5QnnCKyOyqs1Do5hPMBKzwTkqfYG2qWoM0d8jp4zMlbuoi0T88dhV?=
 =?us-ascii?Q?8Kq7AXqMyfvJcov3ieR5ukvy2wycbj3o3Y2LFaPBsc8FD/G78orvQQ6zDESs?=
 =?us-ascii?Q?iyGn5BRO/xPhpD8pLVUPWwTwXPgO2PAtt+Grl6YmIEohlJ6VX1faQAJbuzv3?=
 =?us-ascii?Q?hA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 743b406f-1c53-4059-a57c-08da81109a89
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:54.0549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92cowDAAtsibzEDq5ewTKaZXDeb9c1wmYJJ83rgdcT/X7uLGqrq5QebNDnrWBmromvRPD6xtZe6/AzmWU8NjBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
v2->v4: none

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

