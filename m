Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B837585F57
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 17:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbiGaPAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 11:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236780AbiGaPAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 11:00:43 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130089.outbound.protection.outlook.com [40.107.13.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF3F2723;
        Sun, 31 Jul 2022 08:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMycJSdNOhqL00f5kFuZxe89uI2nvpj+SpfKJLT/xyUtZZ+aBwVrCkPNgIB3dv37iKJgROXeujjIsM/6jiUW7QbQ2NoxVfFsI/tyf7C5hiTHR0DTIlEV4nt5N/dx/F3SKxZRgBB/QlM7SNhXolTBXYIwvnK/A/gUSRTcxejGJecVHieAODQbK2khFRfaoC+4NJlDugkpNf3X+5sZw0k427YaR2kffUG7BsDyhvQb/Zu5DCaLqxSS+rVI54mqSBs0w5MuWC5cIYJvx9oy47YtAsNl6QIjlIUrKEvObzduxK1IWq+IRyXrAuybawO7fVVTMuY9agHf3rmMKVfa2dTtlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glcCgdInRWymp+OH+dkHufFInXoFdV8CBVlhK8b4kfQ=;
 b=TBbouXrjiveMElPafIFTdMtoQT/lzv2vx0ZO79CfjJNgg5AbqvUbteYcbbFlKtx80wsGVurlXFWJaQWJmYPfBkyo0irCu5wAhq6xUID9RYseZpe0j05bspOfkI1KH0f1q3j5yEPsaiMEfU534x42ffwBXfLajWLdjIJb0PLcPvYg0CNcyvECUWSkvv+30SA/R9mBslIOT4+riJNZBhN9hya2a9Ge9ff18S5M6CeTmjtscqJiqlTiFgiEI+yZieRzJFNQa15sD2Nep6PgN4CzvYm8WgnJj2Rj/z+H9TGLqsT3fk/lMURM7d1ewMwfyucqKqQbz+FppQ9T81NXo9sssg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glcCgdInRWymp+OH+dkHufFInXoFdV8CBVlhK8b4kfQ=;
 b=JM5pOKy5gxAcS+QbqmjvOVMWvLkLsIgGYDCMZbqgDvbLyjQ4z2Pq2I9oGoD1KeTMUDk7i43wAKpRpEdnMoVAD5Jl4xLf8II72wDZwfDzJLDqp/su8Og0DIDVhT28XMT7L89kjWWQeRJqd/ioouCA+gBTIMoIywE5Dc3fFor0xhU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6367.eurprd04.prod.outlook.com (2603:10a6:803:11a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Sun, 31 Jul
 2022 15:00:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.015; Sun, 31 Jul 2022
 15:00:36 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Marcin Wojtas <mw@semihalf.com>
Subject: [PATCH net-next] dt-bindings: net: dsa: make phylink bindings required for CPU/DSA ports
Date:   Sun, 31 Jul 2022 18:00:06 +0300
Message-Id: <20220731150006.2841795-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0502CA0023.eurprd05.prod.outlook.com
 (2603:10a6:803:1::36) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 63b3a815-cf44-4190-39a6-08da73056d00
X-MS-TrafficTypeDiagnostic: VE1PR04MB6367:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mvu3p/FTYXAjXHjDOagCmm9oovnBfzUUHD4gdHrjU+4Oqg56yb1w6Iz1mcxKvhtWMV+1tObmhPhaZvD5C7gDQLI4wyGzsOpZVKIooML+bl4q0K53x0IcouODtH1xlC770vi5Ky/3DycGBOUkDUrLmNtB5uy5W+SINZL91ZYCOj4yR0W5BpxjwyedObvlLoxC9xeGRUU77QHanhiiqOqwuK0tNLBUaPq+lEV0fxOENtW1iSuK4avGKrVByKGRxjXzIxcVnrVgfuGpfN0oMM05/X8lrovElXgc5roSYGO879BsxedddsXKIIxiz+vE+F2g+xQ4QAazQNbceAwbyrhrTExeyQAMYUKxjjMadiAlA8V0qg9w6tK3j4iE2ElQhhUUt7FnMbLkBpL0ITV/uLzrSCfxZxxa63ghia7qtbjuxzWjYcW8GR+e/esJhaKJTwiAM05QTefABnm54waxZLnhB+HbZWMcT7duU66vQTbdjX1Pyhu48b7gMvCtHWx7iUeqfNDM1W5q4neX8MEtjhFLVSYi3aR6TyQdfpBU8D/dF5ItvTNpK2l6H58pDBWcdz6NCAkLznKA3mHCxrCEh9c/kIPlZV9y8mKZ5BihFEk+0yqrICc5CHXmiPSn1KFTQbBqsV7PBXF8qEpXGwcEl83AP+wdZVhDPU2udBuc3FWoeFrRonJ+3VopOacs/nrL0+3AE4iK+jtfAEz2zpGRL5RCJpeIVaHQTaFAVfvN9qHFAyhgkbM5I+fRnzZ+KmpyGAfxk93xrzXD+CsOK3eg8eEbptJYJtMc5PPKKdthQvj+L8+pf0gF02H72HzuAjMxoWo45oEzemCXjoUTO/pDYlLoSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39850400004)(396003)(366004)(2616005)(186003)(52116002)(1076003)(38100700002)(38350700002)(66476007)(6512007)(66946007)(5660300002)(7406005)(8936002)(44832011)(66556008)(7416002)(8676002)(4326008)(2906002)(6486002)(966005)(36756003)(26005)(478600001)(6506007)(6666004)(6916009)(316002)(41300700001)(54906003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZQD2mkiCx5X5QSUuIbiLJX62DG92E6JJJnlHgjcVoze8cPU2WyPdB8UTOTbz?=
 =?us-ascii?Q?ggXg3eUkkf1tmxYKIyK1fHKBzG5n1ejCCfvtc2T89XJr/6p6WXokPIXC+Q97?=
 =?us-ascii?Q?dqnkV2WfnlSaqj7Ep2pLvlM/uPR5PD76RGL9ewaYF3wmqWkB1mZX7ObC/SkO?=
 =?us-ascii?Q?NllErJp7/C2jxbFTd/aGgI1eNvlns1yeAGyzZQ4lqLorDfvBcLFg0OeWeqxW?=
 =?us-ascii?Q?WrgOlygmk0L68ku1P7TDA0emOXggb2SFQ+iKsSNu+P1HvNwxIZ72Xo7q9xK0?=
 =?us-ascii?Q?R+ywhaTc6toy8Ft848dI/00RbzE5cXLR7nQD1PsyJMLtcP/L8GYZv93JPVQs?=
 =?us-ascii?Q?Cboo+Iyj1emry4Uu5OCorO/ypNDf0oyBztAFKhlkJ5X0lxvuN4xS0BM6XflU?=
 =?us-ascii?Q?jkz/htim4GDXwG5ZI4SqexCznxnbtAhWpqh6UrjXoqYUTy7LTeOcKVXDkwyf?=
 =?us-ascii?Q?dfaTe0SMugBFU2oyO/NDiB/Q3TtJ/zqTbHO6D3WyFFi0C3D6Qk13RZZPzRmt?=
 =?us-ascii?Q?yofjN0F9WgY3Ji/fveJbuGM0Ub5b5fPkel18J6kzYiZh+A7yvWe1hYNExh2D?=
 =?us-ascii?Q?qWaaCTThL/JK1VJPY/g8NtokqtmFdnPKj8ClFHNV/zS96ew+oFIfZYNMFS9X?=
 =?us-ascii?Q?bsO8KuzMNyj5rbfYdR0faf0smN/Qnq3UN/5S4xnrWg1UL8n4QLi1uIECmhfv?=
 =?us-ascii?Q?Z1tZq9dgIlYAj7t10t7/QrS+xl5z6LW9rkkn2YKyDVImvKtjWlSf9ijAvwhl?=
 =?us-ascii?Q?d6vbOQcBNFjqn2+ssxQeF7A4KFhV4DXJ0Mvt8x+aNIzUZTGZX+a3m9m7zopG?=
 =?us-ascii?Q?8JJepS/Tqjh2JN/K41mKhJLJWxDUrRYspV2MkT14royWpfh6lBcmORyFW0uA?=
 =?us-ascii?Q?nZBD7aDpu8FZk9iwy+2OwoZK5Kvmi8itAV10caThpTxynKsNPKKOWHgQoNfe?=
 =?us-ascii?Q?dp8qF/wyU9ijPU4Tkgp5YwOwxnw2IOk2+bRychLsQWTm6CV3iQIq9P8tT/dF?=
 =?us-ascii?Q?gVwT0nwVT2/nQL7TR1VrutVjAW8ywl6YC/8dWc6dGdBJaB/pOk1IFGNO5/1M?=
 =?us-ascii?Q?hHUSJF7PQHY2UPatNpekyR3X28bIthBhftOya5LdUUPQgqgmMtLPGq2GD44k?=
 =?us-ascii?Q?VcqrjDSsEERS5DTEgTr57hqT3rpUTbmstHRDAhMZ9nJOQyDQaJn79VlcG1EM?=
 =?us-ascii?Q?YjTLIeNPYl9pcpIiH2ezRb9IijOwDjOmVgaIi8V4bicxdqnQyubjPkt1hUS/?=
 =?us-ascii?Q?g2pHbL8BZmI/yCh08gOHqK0WECheoDr0603aIz/816N6A7iWDOqmspO6XjuR?=
 =?us-ascii?Q?LMn3ZMPh2++ClhJ2X+T8yE3pz9gBGzLH9lzGLWGnCGUpO97NxOT03S8i6PV0?=
 =?us-ascii?Q?RO8Z1wkNOkbG0t1JNMJxvFypGqi1/A3qfYNRU+/jpTOZnlOmbjuXyiwT3ab7?=
 =?us-ascii?Q?uCHVtmaKhMoWmSrE/y8IYbX1QdFOUe9u5YrNm/J24+DJxk3D97cFn8yxxCl+?=
 =?us-ascii?Q?uetmauZL3CJ+YHiZlHMTI/AF7JG8UTayLIj7nqA+2tOIV+dO9j9aldmGsUwh?=
 =?us-ascii?Q?jUxy5uFwjb8+EAz1+VkOY2QIgeUUrIlAzbpmun37S8PVYUy9LltWjYuWfF0F?=
 =?us-ascii?Q?KQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b3a815-cf44-4190-39a6-08da73056d00
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 15:00:36.9295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FjHb8xRVCNjpu2iEkZFLO6fSspO1gpelsSIAk8y3R+UNy7fbYzGpwF0KuKrO+XcL8VPL1EA7jyINoT1RdZ8hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6367
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is desirable that new DSA drivers are written to expect that all
their ports register with phylink, and not rely on the DSA core's
workarounds to skip this process.

To that end, DSA is being changed to warn existing drivers when such DT
blobs are in use:
https://patchwork.kernel.org/project/netdevbpf/cover/20220729132119.1191227-1-vladimir.oltean@nxp.com/

Introduce another layer of validation in the DSA DT schema, and assert
that CPU and DSA ports must have phylink-related properties present.

Suggested-by: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
I've sent this patch separately because at least right now I don't have
a reason to resend the other 4 patches linked above, and this has no
dependency on those.

 .../devicetree/bindings/net/dsa/dsa-port.yaml | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 09317e16cb5d..a9420302c5d8 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -76,6 +76,28 @@ properties:
 required:
   - reg
 
+if:
+  oneOf:
+    - properties:
+        ethernet:
+          items:
+            $ref: /schemas/types.yaml#/definitions/phandle
+    - properties:
+        link:
+          items:
+            $ref: /schemas/types.yaml#/definitions/phandle-array
+then:
+  allOf:
+  - required:
+    - phy-mode
+  - oneOf:
+    - required:
+      - fixed-link
+    - required:
+      - phy-handle
+    - required:
+      - managed
+
 additionalProperties: true
 
 ...
-- 
2.34.1

