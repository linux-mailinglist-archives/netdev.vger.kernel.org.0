Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 475AC639DCD
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiK0WuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiK0Wtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:49:36 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2128.outbound.protection.outlook.com [40.107.94.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E39DEB0;
        Sun, 27 Nov 2022 14:48:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bk06QBHSlMAvSySyykFQp/gs6Jag+Ho9+flAxqeKWpbO/rxPy1eOyjktc0RIKL4b9VJ5rM/xKdNtF+zqXoB39K+hlioprsoLO+j5saSsScx7OQQ0MhRDM39HnxUJXncpKoQ1nvmRSX3t5DjVvHlP9N81TUKwWNo9y6od3fRYISKDS3htAELt70scVQJSuTTb/2zEPMWNo8iOmvbLMk6M4rIcIGLO+2eI/fvuRJ1kIEBKQJ067VwtnhRyUpLgmVeJCmWnhBt1bcfybog/qi4Je+3BYuIszOqXru35WyEXHDYFzlkld2PWvCjzUffR7l1ib6Y2cw8e9ZXv9dTtvbJw/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKRBHoo1Zn5alHlfxxHQnLRUFosT6+Rl7Z/qnLMxuq4=;
 b=Vve9N/vDB9kaj7yuY/L27ex6Qz6Xu6/uZ469s3CDEIBKdgBoDtXuH2pue0O+w5H4oT76eKjvoNNeWbTnljf/lyfcw93AcQFQdckkkj+BnrLWP5TS5NeskoyWMhYosSkOmlowyw9zjEkYf3tduWKcSJ7xjLeHPbp3MD0GVbYUQmuZVgkSi9erA+GGw7SmHOcyxU5ZpDe8A8riqhgzkqz3i5Gt4JgDcxEqOuNTE/FsMUGmsGCPLS7E3IApMix4Fl+vmPd/FjLdH6pfOHyn8kTzmTeIVIv8zuYXmrSbdLn9tJmdgGbCPC/FiHS+bin7HZkfMUDXB4+uje78xyUNXShFAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKRBHoo1Zn5alHlfxxHQnLRUFosT6+Rl7Z/qnLMxuq4=;
 b=ZJ4xpcqCbuLR/U2xZ06+zDZlYiKaPYJl6yms7OKt6mmh92fKRwHUX8iimENTQPBPYz7B/q+sS2zb+tnhZ2Mt8Es6zrb93K2j1JP0NvmATDySSFbQAKpkdW0G0ytdttNfeVT1URdQYVO0VX3qJdNGkKWOpZB1Xw1ZqezSicgechQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:48:07 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:48:07 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 10/10] dt-bindings: net: mscc,vsc7514-switch: utilize generic ethernet-switch.yaml
Date:   Sun, 27 Nov 2022 14:47:34 -0800
Message-Id: <20221127224734.885526-11-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221127224734.885526-1-colin.foster@in-advantage.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: e67f645e-530c-4688-461f-08dad0c97359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RiwdVUZA5oBLG+/xglwLnXmvW0b5fMfkrUpU4jCryxEsa3sXrlIABN2rGxKPSQTqEbBMzAbsG+wLT365ZMAgSX2K5wQ+Y7R9ENTObQihYYbR9rTlHpyF/dtjuMtW8pfptYjN94GIrRoZBZMqfQXuEnPqgZ00Rqf0sfFPEm8EVEwApQP6XBRa2fCrrzMlXp/tjHa8B1KWdIk7fn8d8WYbGJjDm101O39ImMcsf5D2+//PuhOxzgmyfJlBKUBK4q4ez31xJLaKSUe+VeRjWJy3IfB2bpS5lg1yRt3+ldukkRKPVVGVVrPNztFOtNbd4J2biqGIMlPrBunkCWMkHXUcyrGkKTfWiVkTlEm1RTgQRju3eBQH6214Gv4Aq00K+OM9+MR8bZ0BvvX1lfp2fylRT4APnw4uXxX36CXRcdF4xJxJY2A5r90Ot/lhDn2XnnqXV6EmmiS/2SJNvvIze5TLttZK2h+eYhEu5AFNG0IsHoChugCbCcaC0SUNKXNxr5xeslN6lMlGiEWRq6fC+Iahh55+tYy89+gxvmvR7r6IyTo9LFYizfRDbRHb5qhDADuIZAIKQ0fqxnw5DzKDeXTN4WA0hEjTX40KSWVNxb59iw5UoYq2kT8xVABrBdjhThfmlaEjzWkvckBuBlsgSTuMLglMVDmMkapx/AGr7DhUXlCsQ1t0FjX6g4E2/wiGjKykGNBiOlL1ls1ANtV/pTF7YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(346002)(39840400004)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(6486002)(478600001)(52116002)(316002)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ccBOsnLOby3ojQT/UKtb19nOfC+7CqDhR5dOuacVM+c8m8T2tT/sVSIYRcUJ?=
 =?us-ascii?Q?ZQWvRYW6nHzzFpQ4CD0J4V+rfJrqkaaExYChph1IYu0nDxD84jEmRb16L5tX?=
 =?us-ascii?Q?A6NFz1DMbqRtmf16U2C93y6eJC3nzLcDUr8pWXYB532lmks0jKtTTGOooaPN?=
 =?us-ascii?Q?YGi2McrgHYN2yScmsIJGHNiK+KPBlCmsVsCKAQzDNZ7/S04AIoCg4PLXkFxt?=
 =?us-ascii?Q?vuX8Hepsu2+keUQwg2bAocvWatv9e36aZAOCMJyiT330/TbOygno0sTLBd8V?=
 =?us-ascii?Q?716aGWrs1Zgg2OQ0sJIfm6oUAKzSSvR7UI5NGlpf5N1fkBckH9Eciui2lKEM?=
 =?us-ascii?Q?ePgxsRTwL54SSTKOhc9Z4isIvgrcM5J24s049D6DGC9w+qA8I8io0VTvbQB9?=
 =?us-ascii?Q?rT1FSpQF53gxVGXC0GhUz736H37VUKNDBtZQiNnY0w/ZlracU7UufmGGsgo/?=
 =?us-ascii?Q?dwO5t0p/O2tCC/pTVz+/MMGCJfiY4n/1s4DobDwVIfM0KdsxpUjfZ7TQtnSf?=
 =?us-ascii?Q?Di/gLBBMOTi0A9i+56BjnC5nU4nojJUTyAxxkfNNUBpjw39S45JN9yTXboaB?=
 =?us-ascii?Q?f8YTWRzv9Y+hf0Zm1lEB1AQh2+NG/7GPleyDj5oSa1VExZCEfkvBqFI7ROBJ?=
 =?us-ascii?Q?Mj+kOzOGSJjI2q26rtAlkv5nD6Warx0+ybGGKld0NeweP4f/2cUBXU0oRAg3?=
 =?us-ascii?Q?ry7zMaD6Lnmw6EGlkbfUZe1l1dexrgmrlRh+qXvyLda13/hRCWrDLM1n5u//?=
 =?us-ascii?Q?Wh4KueVhnKw+QY8syRX1FcNWqnRGfbn6Myb+OBj+XWQgVOggcbll2tf5hnoC?=
 =?us-ascii?Q?sT44FSy4W6IvtLGMR6e3TfK8Plho/i5LrKy6WaC1P08dDzZSuWX2sd1xbS+r?=
 =?us-ascii?Q?IjnKhXScAyLEWMJoXeJWngJUpEMu2+dzh7aD4L6r6lOnqglEmlSxtwRCtDq5?=
 =?us-ascii?Q?+mrRnWvpEx49kcY7tcZ7KyUi72YSGri3X8gioFnOEBZ/Hu6WJali4fgKhBSt?=
 =?us-ascii?Q?mvbinHpqCFTlxXrfnwMcVHE/y26fmCQOLzk/nPFJUG+ImVG5a6hhcCqbMkB0?=
 =?us-ascii?Q?gfdGN1Ouw/cFBkb+5WXGXchT5HolKojXruftZkCz2phLCJOEfNnuPoySR3ED?=
 =?us-ascii?Q?/WKoAyE6PFUoMqMQ0cdzstIQTa9sT+m04biMh/t9Mh4sRWdqG4q0wNooTpBs?=
 =?us-ascii?Q?inQKfw7cU78PZpsctgRmQVR6qkQ25iNEAVy6jtXGOJu2PDm3Cznt04wsGSN4?=
 =?us-ascii?Q?IMmexXwso5t2k5IYB9yFPXOVJYGhscXldmluJRV4+ql4toNpG3TlFnRsN6AN?=
 =?us-ascii?Q?4m5M6V8rhWNH0nBO+BEVNgBJK6yF5Jepu0dtDcsFlMRGESK0ltd7vb9aDLHP?=
 =?us-ascii?Q?PUxruL4qLtMH2hNBO2QXAdqELBo7avX+Pfx5AZH/7xmxocRvk2rYxU5HXgjP?=
 =?us-ascii?Q?e1qIlBnZLUDVknUHcjKInSDQ9JgSLDLWq2Ohe6S/Q2vHQB2Wo58sQFUWHzsb?=
 =?us-ascii?Q?Q7CA+nQT/001Np48U01DfKe1rwuLImuBF6BOyoC2HMLB+okN11q1HVd2GfIq?=
 =?us-ascii?Q?NcXj3IVEg9XdnBOA44O+LtUSCNM2sudkjg6yWboBcJGs5Y1DtMcAxjGIj+Kd?=
 =?us-ascii?Q?35ESJXYpDZD2LnoZ+jXj0ik=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e67f645e-530c-4688-461f-08dad0c97359
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:48:07.0612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+ZEczLNcB2cNSoccORefcknYEv8iLPMkME3EyMAGPSYv3v8u26lMtzjxFrBD0ZqJP+6A/QGw2ifNe0HrEH16oR4eH0Nwulmx/YJksrWnjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several bindings for ethernet switches are available for non-dsa switches
by way of ethernet-switch.yaml. Remove these duplicate entries and utilize
the common bindings for the VSC7514.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---

v2 -> v3:
  * Reference ethernet-switch-port.yaml# instead of ethernet-controller
  * Undo the addition of "unevaluatedProperties: true" from v2. Those
    were only added because of my misunderstandings.
  * Keep #address-cells and #size-cells in the ports node.

v1 -> v2:
  * Fix "$ref: ethernet-switch.yaml" placement. Oops.
  * Add "unevaluatedProperties: true" to ethernet-ports layer so it
    can correctly read into ethernet-switch.yaml
  * Add "unevaluatedProperties: true" to ethernet-port layer so it can
    correctly read into ethernet-controller.yaml

---
 .../bindings/net/mscc,vsc7514-switch.yaml     | 31 ++-----------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
index ee0a504bdb24..5ffe831e59e4 100644
--- a/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
+++ b/Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
@@ -18,10 +18,9 @@ description: |
   packets using CPU. Additionally, PTP is supported as well as FDMA for faster
   packet extraction/injection.
 
-properties:
-  $nodename:
-    pattern: "^switch@[0-9a-f]+$"
+$ref: ethernet-switch.yaml#
 
+properties:
   compatible:
     const: mscc,vsc7514-switch
 
@@ -100,35 +99,11 @@ properties:
 
     patternProperties:
       "^port@[0-9a-f]+$":
-        type: object
-        description: Ethernet ports handled by the switch
 
-        $ref: ethernet-controller.yaml#
+        $ref: ethernet-switch-port.yaml#
 
         unevaluatedProperties: false
 
-        properties:
-          reg:
-            description: Switch port number
-
-          phy-handle: true
-
-          phy-mode: true
-
-          fixed-link: true
-
-          mac-address: true
-
-        required:
-          - reg
-          - phy-mode
-
-        oneOf:
-          - required:
-              - phy-handle
-          - required:
-              - fixed-link
-
 required:
   - compatible
   - reg
-- 
2.25.1

