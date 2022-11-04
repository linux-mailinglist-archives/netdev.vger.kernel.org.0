Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBAC5618F9B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbiKDEwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbiKDEwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:52:34 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 475A627CE5;
        Thu,  3 Nov 2022 21:52:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KcsBW9Xsf2L8kJnzALlDf5NW1hnU8iZybjzeibY8NozWLTbL8QDaw7Ud3eLDUgU7ZXV4dHI0hZlP1GHwqqRZhGvG90n1+gCS+ujl0efDwKLNu5B8180eCnZ29MODBY9HP7/67M4fE4POA0dVEaxCkKNDEX/1hkcVavehIhrxvp7D+/uDSjBLv6JJQyG/QBL90NZoLLbHMLGwgVxjq9/WjijK53k18hrhKsWzLTrMOv0f/c0j/1y2LFoEYLDVioWG3UuMinyy1OeZIDtA1ehXGGq0EcUfMnL/mEi7ysEXEByMgM7puw6RXmxjUWFwkSmbSdfOusDTj1SlgIRa0ezwDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dt9pX2lxHqMl7tv1t4KwIkUWfX/vd6gBPbaesWwarE0=;
 b=oBb2nn1X/w28vMzeveBs8mYk6aDZNDOa7m+idJxArpr1CZxuBiA12GASx78uR4M447FZ4Vu56Dpd0U/df31QA0AetEydfAOKi9znquZXDeEkSuL4mewN/rFPFjBUUufBd2hZEyp6+r7JPSbpShzTHfslzquCZri/YhwBiDq9M5eaEQuYFCxkEEP+lrPrrKdRQkZvfFEhT9thXQEIrgwydm8lduuVD1a1p3pnnB/k25vesR3XpUOnc4Bk2yrLnJOSmu/KyqOv6MJoWJnnZYtNrjgT+BwKwa3ctvfe1ThnbGzolr0u1VRR4v9WDufEdV3mSMTXd9gA9qURe8s6TvulVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dt9pX2lxHqMl7tv1t4KwIkUWfX/vd6gBPbaesWwarE0=;
 b=EFvGjnCLXo7Zxjg4CWd20ibbjrjiHIzHF1VnS1vnsJgusag5EnvjZ/0EiP0B66AdPdUBWdl7f2yR10haqLff2CE3FVVMWbFJAwnYI3oBoDbk4ybBYimMcc4El5LtALVmQhMd6u1lJlONU5RFEw04umfum3bvuGC0b+3EmilJnbg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY5PR10MB5986.namprd10.prod.outlook.com
 (2603:10b6:930:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.22; Fri, 4 Nov
 2022 04:52:24 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 04:52:24 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 net-next 5/6] dt-bindings: net: add generic ethernet-switch-port binding
Date:   Thu,  3 Nov 2022 21:52:03 -0700
Message-Id: <20221104045204.746124-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221104045204.746124-1-colin.foster@in-advantage.com>
References: <20221104045204.746124-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CY5PR10MB5986:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c079e37-bcf2-4053-b8dc-08dabe205d36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lNdMre8rwfQQJPRIpGhxnbgJwhr1gVsbYU2V5a++vLvrHpcDHlptOyoPi5+5HG1IH7flIZUHNauR6O9rjZQINMKzBUJiEfQRg1EylM/vcaCSzsfR0cFlTMtnE40YE8LfgbTg5tL7mpals3omu2jSDbbUJtIBGeprSvwqVT6zUGVd6/n8tIbg8ITwjL4xG9S3J5PE0LT6ypcYiz8JCDZgq0kJ23uI3OpKXiIZi7MsVz8mW/pueHDibvyzbVw+vOiCh4tfto7UGT4j/nYARQJzCsPoOgqUlCx1tMrGP37ralEJcXeMRpzWuXidLKr8Dg++tnKmkDaKJlDdOruqApPR1dO3TabqGucXmaE3XF2eKgzhwulVuEiAvXibGndJLeyohPKxvBmZV5eA94cKqdn2/qDTLXjB4r0AWh9pfedPkSoCPBu6u49mGLXQ52uFH7AYM4mYtCFWP3LSBNCIPUFZXTI7W+wX668noAE2KXvTy4Eylq9VM+rGVzJNcT3dplhX4P5dJEIEFix3IoFzC3QZ1P6KTzJ4T02++0o5ioNwV+zCiJ2Lueph4fpx86jEQbD83etM4KQpzUl+PNtfeKwyflGiLj4J+wE9ffMn9n832hQWPvlA6fHZR5+wpIlsj6U0xWLWgwfdde78T2cRs70UqNUeWl2k94yRvqSbu3ZBUHfwSjs7zs7xKOzdzhYQ1CNEAsXfXvMXI1nGIfQ/1oE5ZMQmR5m/+IXzy1PtFPvPdiOOm3QdDJH2vf2J2kLwn0TPe/sBI9vrLtP8Cwv7/1MbY2kyKd5ephGsqpPniLh5mFcQtswR8kK53+h+hmm09HK3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(39840400004)(366004)(451199015)(86362001)(36756003)(316002)(38350700002)(38100700002)(6666004)(8676002)(2616005)(6506007)(66946007)(478600001)(966005)(54906003)(52116002)(66476007)(44832011)(6486002)(2906002)(5660300002)(7416002)(186003)(8936002)(4326008)(6512007)(83380400001)(1076003)(66556008)(26005)(41300700001)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ro28vNoAv7+3ZRWk6Bnr1qYJnQL4VRg8RO6xTAoroS7hqMVEvCM2wKWq5NrJ?=
 =?us-ascii?Q?XKijDo75RqUyx3AQaX8xcd3AO0f8YthrjnEUXVm+Tg/vMN4ah6RDeTZVRwFz?=
 =?us-ascii?Q?bZO4Klnhe2tDQeYbTVvoZcMy+cOPr+AKnFPEqrQkohQmJLQCNg3F5GQInFue?=
 =?us-ascii?Q?4Pc+Aj/9fimLV9nlhWMo4+dvZhB4tejshQGv62hwipW1Kewe43M0INB4fmKG?=
 =?us-ascii?Q?hTnrypwUA2426O5pEuX+neuzoSmybaOp/yGfnXnMR2VKcojybtZPKhZuyYOn?=
 =?us-ascii?Q?2S626VRWpWUxaLyvAUfneVzhTQ5McnAqY3gQyr11i8ExCWOWZSLq64J8yKGw?=
 =?us-ascii?Q?HMvsh5gwfdvS4jFwkLx7d+AoLj1ItcBZUW+De4kqFqVHuxvkKdOlO/7y+xlc?=
 =?us-ascii?Q?37plmZMqGSazyt8HG1y8htqGGeiHPJbVL5XbX0jvNl9p8TWVBUN0ba5k7zZv?=
 =?us-ascii?Q?SrNcDMSlzgX1mqnbuAh9Gb33LgqEtjSlSU0dZmTbIWvKZPXC918ExIrebxpC?=
 =?us-ascii?Q?zqgV3WH2DEPtns6+hrt8C+GCEStzwQyLgg/fqse/DDKLTwNCKgaPqblEXiE+?=
 =?us-ascii?Q?ZGGD0X1LjXnzDEt1w6KN/q1LWZiSLKO0gJ9cC0E+k7PSzulSkuzQyp6G/kmT?=
 =?us-ascii?Q?zu16C2UBC+TbNF+fdZVKLQqyCzB2Noi+fKw/k6tjQGp53yEgr92FU/b+r5ql?=
 =?us-ascii?Q?g8JLeKRtCt3D/OtLvZIq90FxDp+1Sbovgi5EHXQDaw2rUG4TTBCtJC6Wna3Z?=
 =?us-ascii?Q?tbRZ9/ueNgZMyhkuxMB5HuWwgbRX/TRjwO0HimxzJFmZ/3Z+9bnz8dxd4l98?=
 =?us-ascii?Q?UQA30/zHnCiFYrFq8mhTHsvSMpBVby9Ws787FRROTz0NJSez3+O//zH+1Op4?=
 =?us-ascii?Q?On/RrE6p8d7IzgrOTDZQerHuO6MIYJphqzlfM39vI1bBCZHXEqigf4QUvqKE?=
 =?us-ascii?Q?ChJSQvYzLMTBcW3tMsxKf0t9jXwPwFtQKnYCuvypYxn2plIC+squwz1VqFVZ?=
 =?us-ascii?Q?EfMIRhUaUhRTlllc2yXKqQ4YfnW6BWC4F8yvT4w1AegezS149ctCIPMYhIDd?=
 =?us-ascii?Q?xSbqbQXbPs0LTBGUgcbmkPp5H6ytpVklJwpxqPYrCs6/OOZSoYhLfpMrVYWC?=
 =?us-ascii?Q?gvpQREG0PjniWQa3QPWsnrPSCT2BjuE/rk/4HQkg/Ya77n7c2408IO2WfQ3T?=
 =?us-ascii?Q?Pu/+Eb1av2ddpjhsTSz6Togy7BJzgFw9uSj/galPSAF9zY2H0M5f7bOe5LMF?=
 =?us-ascii?Q?F4tXHePDJQwfQfZoGarBDeBIl7z+/NR2uu98BfqMHYBa8HjOrVDnZDfGs9uT?=
 =?us-ascii?Q?oOXjmCU38PD+HAnho50NFx32kvMdVuvl3HS9gJ1QeqJ4on1+bfOZq9lpxMp8?=
 =?us-ascii?Q?6pfTFhVreQc8s1/tbihOZDNNiVgy0Q2AeqiohqI+tP185JwynOZMBfJAzVQ0?=
 =?us-ascii?Q?fWf2AtfG/fKovMkYs1ngbS+2UvRKZuqzVt1WgbmPyGZIUkE5P874Hi9cTgUB?=
 =?us-ascii?Q?RJxD7wKVFua282lipnjUyL0AR/DCcAWSUQvT2eQhnm2GZgexyKP28eRlP2z7?=
 =?us-ascii?Q?v1pjmI9oYOAua85ZYKmjId9OztGMX3h2XeCchD/e2ON/HgYx5bJBB1V5vCWw?=
 =?us-ascii?Q?nMH+Ay/cbo/7YoooofBk+rg=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c079e37-bcf2-4053-b8dc-08dabe205d36
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 04:52:24.1413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u7RwYXBUsujRsEm9gRBhs7pnVj/lwVaWtGtfWHuagK3DyDKtpIJEew/Ixmp4WJyrwcHsZKYcALzNHWDwk2wKilxMLpzcM1nwaNxyYvvt2bI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5986
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa-port.yaml binding had several references that can be common to all
ethernet ports, not just dsa-specific ones. Break out the generic bindings
to ethernet-switch-port.yaml they can be used by non-dsa drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---

v1 -> v2
  * Remove accidental addition of
    "$ref: /schemas/net/ethernet-switch-port.yaml" which should be kept
    out of dsa-port so that it doesn't get referenced multiple times
    through both ethernet-switch and dsa-port.

---
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 27 +-----------
 .../bindings/net/ethernet-switch-port.yaml    | 44 +++++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         |  4 +-
 MAINTAINERS                                   |  1 +
 4 files changed, 49 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 10ad7e71097b..d97fb87cccb0 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ethernet Switch port Device Tree Bindings
+title: DSA Switch port Device Tree Bindings
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
@@ -14,13 +14,7 @@ maintainers:
 description:
   Ethernet switch port Description
 
-allOf:
-  - $ref: /schemas/net/ethernet-controller.yaml#
-
 properties:
-  reg:
-    description: Port number
-
   label:
     description:
       Describes the label associated with this port, which will become
@@ -57,25 +51,6 @@ properties:
       - rtl8_4t
       - seville
 
-  phy-handle: true
-
-  phy-mode: true
-
-  fixed-link: true
-
-  mac-address: true
-
-  sfp: true
-
-  managed: true
-
-  rx-internal-delay-ps: true
-
-  tx-internal-delay-ps: true
-
-required:
-  - reg
-
 # CPU and DSA ports must have phylink-compatible link descriptions
 if:
   oneOf:
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
new file mode 100644
index 000000000000..cb1e5e12bf0a
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-switch-port.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ethernet Switch port Device Tree Bindings
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
+
+description:
+  Ethernet switch port Description
+
+$ref: ethernet-controller.yaml#
+
+properties:
+  reg:
+    description: Port number
+
+  phy-handle: true
+
+  phy-mode: true
+
+  fixed-link: true
+
+  mac-address: true
+
+  sfp: true
+
+  managed: true
+
+  rx-internal-delay-ps: true
+
+  tx-internal-delay-ps: true
+
+required:
+  - reg
+
+additionalProperties: true
+
+...
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
index fbaac536673d..f698857619da 100644
--- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -36,7 +36,9 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        $ref: /schemas/net/dsa/dsa-port.yaml#
+        allOf:
+          - $ref: /schemas/net/dsa/dsa-port.yaml#
+          - $ref: ethernet-switch-port.yaml#
 
 oneOf:
   - required:
diff --git a/MAINTAINERS b/MAINTAINERS
index 3b6c3989c419..d98fc1962874 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14326,6 +14326,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
-- 
2.25.1

