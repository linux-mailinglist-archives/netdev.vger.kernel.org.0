Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EDD5982A9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 13:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244503AbiHRL4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 07:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244288AbiHRLzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 07:55:50 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2042.outbound.protection.outlook.com [40.107.104.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D362A261D;
        Thu, 18 Aug 2022 04:55:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fW7zysr3bQbxYCVErXH+kA+zg/nO+BWrTMnjJhoPOWa0OPn0OGOhfS/RNd4Go3rTxbMqcA6WCeU43vgWK+3FUHz1YYBZbMfJUBIlJNB7LZpnh1/oGEBXKpbKJE9KD09n2HfO375B/sMRW4SkrgSbg+kY0NgiD8x52Xr5zoAFG5m1egxKNR/VlT4UVHrl/LfO/xSiCIyuqT8fBQ6OpGMUYUxbE8IEoL+qoHaV7k5rtdfC3ScDaenUlZrLvJ91/KZevz/twHo1ku/6sLkm2mZSj5OQ3juiG9USPGU26MgG4v2t06MvMOJR4z3ruCFGRcrmUU+8wvq0OKaUghUDuNfiYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OlaPbbbTSj/PWqaW3/eRNtnGUVhDUuXH4kLurDjxGYM=;
 b=oLzwtl4KotgRgqzr52KWGaG1Y7lqY6rhS9SwkF4zjKFsOqT0vq9YhPa7UKRYEODoeIL+WqNhAbKLjAEBhH899s8dE8HfyXySLwrJ9voUshH0JLYQHq5hg8BQDaKZ3dnYrvE+nGk28HadDgu2lgffAeLZesfOF9lXDj0s1NC6dOhJmwfd7BX4e3p0DqrClPIbnPQ5694I5krAvJkvn5IJ3b0zUV5ZtFw+jQpcv73/U2uKeXmc+gtwbznUiqi5RvqWnUtn2yqlGe3I/DktFXWCgZ3sc3YqrVyaADddyuBzzE3b3ApWLqFmHoDp4a9tpixCjyJ7VtMj3KcghS/oDUjR/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OlaPbbbTSj/PWqaW3/eRNtnGUVhDUuXH4kLurDjxGYM=;
 b=a8FEpzm0kMaUbwAT9IC8lty5CQlASVKPFS4qOEGBMc+MH9yuic3yVtJfAdD1MZuNajJhBWPMDb8y7RFuHoLm/xexP+nge//YJ3nqcP60mWGG4oFOE13kRkz1L7FV/CWKqhh33QgwDojLdCVJqZsp7IPZD8VAAaOcaPDMNNRcQDw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB4085.eurprd04.prod.outlook.com (2603:10a6:209:47::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 11:55:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 11:55:46 +0000
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v4 net-next 06/10] dt-bindings: net: dsa: make phylink bindings required for CPU/DSA ports
Date:   Thu, 18 Aug 2022 14:54:56 +0300
Message-Id: <20220818115500.2592578-7-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7d390d4c-940f-4601-180a-08da811095f7
X-MS-TrafficTypeDiagnostic: AM6PR04MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xrop352/A3u7t3eA8utx7LJQWe6zfJtlbpzEf/V3nlnbC7NlMC4zGmN0I1xXAd+bCI1O90Rq/XHs2biBdxvvfwAVJ8NsNVBB1wNTnx6pRC9dI0Ra9aMT71Kc9gAm08d5vND4z6D9ao+Y+79UzsxBoxoLemhusN2nPLPuifa8WgxbAKW5KwNFTOU21hNFpirlZDG89pe1tw7HfWXHWUx1qHXVGXNeo+jb00JDAak5jVhwriM0+jXSQ+DryATt4Lns7H54y6GACavwsGH2d+KSxceHVYBCDnphxqVb4m+eiUxtaIy0axyr5U0I5UIJnFSr8ImdH/Twyk6Mwo3N5rrTKc5rckOiYQxb8BnCnl+qNIH76rmRL5lKKKTu88heujECOC3YB1jzxSmbfXuHthc+3DRbYX8ydR28LKVEKEFcQY42WEzpl7tQrhLbPxT5uK0umvBuxQjwThHXGXMuDzbAoH/aAf3tUqjihHB/As5O1Z1b6m9ktX74UvArB1G3OnjCeDNZ3kgW4x9gfXOQoQfBGVG5OX0ql5iiV2anR7Hk/jx0x2tZ2+XjWLO35JdqP8+kQZ4DzXduGt/BtdOi9t2HykUt1X23ERgEGvHkkAfCcNuVDR47cFEenrs9SOTth/BUeVnWBdnB2z8AB15QKNfwMxKYf5PjIRyKkssSLwcbTEq9iobwpoxNSeGNrSbTb12sPfQ3qdWS0HxQMJupO+7BIAvVk49S1GdiDwCMyHWpK/ANOE5HYbzx2NlqMpV4xpPk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(86362001)(26005)(6506007)(2616005)(478600001)(6666004)(6512007)(186003)(6486002)(52116002)(41300700001)(1076003)(7406005)(6916009)(2906002)(8676002)(66556008)(66476007)(54906003)(44832011)(38100700002)(38350700002)(5660300002)(8936002)(7416002)(36756003)(4326008)(66946007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QkdJQwf3SkfYMtHMLQOp9ZGK1ce4Vt/th+rEOWCWTZVb9qv22P2KxVYl0e97?=
 =?us-ascii?Q?LqZBoK+tfBJ3ogCrwnHP/WDKt/7GmVfvLN4QtMudGEx8ynSI7KKlj2tMi+zT?=
 =?us-ascii?Q?iNBIDXYIsDpjwFjFU5lQNKliTisj1KPSdrcBiOvZZBI+zlixgr9ZNlBzX7EI?=
 =?us-ascii?Q?/pnyqSpqBSUcK+VJGWpgSAsHRRrV36cISxD3hKcw/ls1iIig2qc/RvO7JX95?=
 =?us-ascii?Q?wcH8LfWBkbOa70mk9NgkBdzX02AGBGbuFNsdxCP28WrslV4aqkc68kaBe2KL?=
 =?us-ascii?Q?KzayDKIgoA2YrhbCN2wcezoReEI6Ba5RjZZVv0bQJCjweEM7YrTwz2HbEVXM?=
 =?us-ascii?Q?NT+hUW1obBOxYjYsOgiDzgWsUc52mzaPwf5smW0yIS3woKyEOlK8Mztftfb6?=
 =?us-ascii?Q?1Pn829F5R7xu6Hvdw9eE6xmxf53/Y+hdFZl0i79zdrRfmXdAumQfo0CfSdmW?=
 =?us-ascii?Q?gDO6QJljRcUtK379lEZtx4kB6mwYfu97EhUNjlV11olh1N49Fc7wZtwqhzpC?=
 =?us-ascii?Q?WeA27bKPIz8IF1IXrnAF2Yzi8Rlcrzqt+rRhiUnj4OV2yv/x9py/Zs0HPdi3?=
 =?us-ascii?Q?Jt29G0TNL3De1J0hrqnME49o0+KMGKeWwyxh3efnZ8KVuhQakxCU5WUYVyLl?=
 =?us-ascii?Q?fqMfQKZbCnsfj3/0k+MeeazIa3e8YNMytmt/XFR++MVnCEFfJxuxvK6x/DC8?=
 =?us-ascii?Q?jBgytbgImAlY9UGvE0fINys5y96p0x75Hzirp+cGB9qSJKWvf6rahFkctkCE?=
 =?us-ascii?Q?r6gKjgmp6SHHJOhyZjohuElXlxmIOUrSxD1zAhXC9wtj9296+tje3kmhjw2i?=
 =?us-ascii?Q?JxMNLJqtEsCs75f7x4RpE8k/vC5NhWv8Xv7g6PxL+5tB8tWLo1sefEezzHud?=
 =?us-ascii?Q?5J2YHvmg6RZuGPe8nD1YTpchi3Ww2N1hJ7cM7U6Ie80FqzA8eXDlhq7Oo+96?=
 =?us-ascii?Q?RkpbVm/XgTPAbLrPUmCJn/byqWsWVXpseOXJL9ZTe2hHH/GzqYHIo/PIPZsw?=
 =?us-ascii?Q?hWB/d7egGMBuuiVI1cuvPbHJi+APlpGFU8Eu79V4LpQSDH/E9Tp219NPN4AQ?=
 =?us-ascii?Q?f8L4tNd9OERvNX1gvkQtNz/N6JmNh5v47dv+5DlqChub5J/LLNC8dPtylm1W?=
 =?us-ascii?Q?4qySsqPXGYLM9iIJtXYlz8Mm3fbqQJNuzsI5ubMT0KUh//3cGX7nraVTEiMH?=
 =?us-ascii?Q?ykGV8pgyJnU9CvZQ7rwu7mRlNXPy6Mz5JHY/MUtKMV0GBmnztBxDselDk5+Q?=
 =?us-ascii?Q?oqJ7znFis0VP4zHpu7VyATCfivGXldlNY+RZRJxAIij9S1BFIxpE3myzwsUT?=
 =?us-ascii?Q?WdevDuF9zgiHmGAzUdUtMn3Lte80S0SXZuJ0dprX0B7iyyiLID+Dnj9LYs7y?=
 =?us-ascii?Q?MgMpmvUzPghgTAmIzeAaMPEIjLCfT+EHw7fySW9w6KT4C8MbZOLFOSu4Y0my?=
 =?us-ascii?Q?/1FhNPp3B3R8JyEzP7zV3UyYnoQxu58IyWfSma8bOiJA9/QPZw8kGi0y56+v?=
 =?us-ascii?Q?4lhlfVgS2GOLuS2a8Qy4cZC+nZdKMg3zoxH2lt+Qp9CIDgoExjuox1J5OES2?=
 =?us-ascii?Q?Yj/AzDeHhoMOgBGQQFMCKi9299QLLJl8vCO+0EE2oSAYHBlUreCvVq0Kbcv3?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d390d4c-940f-4601-180a-08da811095f7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 11:55:46.3992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qQFfNX8KutsFflwBtT8X7YQ1tpRacBNzHIoA+cC0B2ThVTn3Biy4muFX51YH51HkMcfErNcpKfGU/gTOUMCiAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4085
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is desirable that new DSA drivers are written to expect that all
their ports register with phylink, and not rely on the DSA core's
workarounds to skip this process.

To that end, DSA is being changed to warn existing drivers when such DT
blobs are in use, and to opt new drivers out of the workarounds.

Introduce another layer of validation in the DSA DT schema, and assert
that CPU and DSA ports must have phylink-related properties present.

Suggested-by: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---
v2->v3: patch is new
v3->v4: none

 .../devicetree/bindings/net/dsa/dsa-port.yaml   | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 09317e16cb5d..10ad7e71097b 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -76,6 +76,23 @@ properties:
 required:
   - reg
 
+# CPU and DSA ports must have phylink-compatible link descriptions
+if:
+  oneOf:
+    - required: [ ethernet ]
+    - required: [ link ]
+then:
+  allOf:
+    - required:
+        - phy-mode
+    - oneOf:
+        - required:
+            - fixed-link
+        - required:
+            - phy-handle
+        - required:
+            - managed
+
 additionalProperties: true
 
 ...
-- 
2.34.1

