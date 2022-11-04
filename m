Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F251618F9A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbiKDEwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiKDEwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:52:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2121.outbound.protection.outlook.com [40.107.244.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED5A27931;
        Thu,  3 Nov 2022 21:52:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBD+HO+FZgio9DX1z6fnKnz5hKLFZUbCppbWTDZQEgSH439fQrNcIEphwrqzL6hApDtBNWgOGBksSWoL49M2l8QTuEJiqvgvFJi1jBx+ICkAl9w/rZ8vTbRXNMBLK7ixE+8KmjfXToXxfmpm0KJH5vCOAazVaWIlitNp3PW5UEOzq5zYmVpPIT4nwJZgkOHUyMqxtrbLvzXkgcoD+UPBCqPutUTBfplgqnorcBjx4AeYUhkgRVCZHL4ghlhs/vMhf/0Q8y8nmZ0nPSYzejlUjC3tKDotDy+XjGVAiMQ6wbURagtGZcPY2/xC6tMDfc1A5TT9biRMCaKRhTE+6Ysdgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QeUpcagE4U7c3tJwHU5yxD9l68Pk76ICR1i4PK62OI=;
 b=T4eYUumTgVbEVErvO15ReNA992LPC6RnSOzZNo2y/4d1RzEDmymT3C3ef9Iu9NZUnLEkVt0C1H+SkxP3AXJJ/IrlHyTDrbUnT2GzI77spBs6mm0d7Bw/8oCk565vJDuvzYNNeUFq9uJNnxK6zQF3R3MBEzQKq/xAgnyg8TTds3dw0zrPARg4ZHF+7yYjaY1iHXu4B3fHxSUlnwsZsf7r4Ci9bPpS7dNWCdWQxz0ZF0DxdaRiMXsS7OflzZXXitr7eKvJWthMxprt5GAqNJykd5HJmFC9cbJ4C6+4TpMa1Jejlf5/E2kIVCC2BLD4HMBk/AykXgeue/N06uBtuqtB6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QeUpcagE4U7c3tJwHU5yxD9l68Pk76ICR1i4PK62OI=;
 b=UjMqPW22AtjxYYdzMi72zAEN7rMNAt0GHmiTMRVCXtzurwCGxEIihPpLjH0HbFjm4vApOyj7kX48Fi79mW0EDeYQZ7mJUnnyVRgRjUgw0AUpe8RrdY8LplhqYoI8RV77CC/zHu/ugmfE0iI1R5yRrCISZLMFHOkPIvcMYRwZBog=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY5PR10MB5986.namprd10.prod.outlook.com
 (2603:10b6:930:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.22; Fri, 4 Nov
 2022 04:52:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 04:52:22 +0000
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
Subject: [PATCH v2 net-next 4/6] dt-bindings: net: add generic ethernet-switch
Date:   Thu,  3 Nov 2022 21:52:02 -0700
Message-Id: <20221104045204.746124-5-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: ed85f2a9-c88b-4ee7-2af1-08dabe205c41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0qSz/3ojZg5M7txnKp/D2H+5zbvIqWtz8DX4PA4TNzDXpFQW3YmAG5O5MEB4mmupzJIdbb93UbyAoRNhYlc224brHUl8uvLCcQMiAOhrVtfvmbXvGnLMPmo4PGwTT98pkvLwm8rIM8IjBIvG6wDlCmmORV4k5kcxi7BNiRhqA++JV4/C16J84hkc8Fn+tpvdIruwUFZYomCPC6ds0QfS0HLRvtmHU1FFaPG3MEvzf0SHYRW9EuMjjj5AgYfa0GIQnpIifKSYpBPFuzHOZERnMHje3N1XSvWC7d68JIHYiDEWaJz04U5om2saMwMWMEIXK63p9UdGSMuRkG1dt3sp4H2pF5P1yH5b4g4i4dDxD1nRHV1MoMCsQvKzRaqXZ0hEbDO0zw9mTAhlCifACgqdeuDtgsm+ygseikU4BDXsJZKDkfoWzps9w2gEAOayQlkU2k+SMcDih7TE8GKwFp2nAaM2kIp3WKfsMBfIUNM1JLlKgRI8kIaRzA6+RqnDyMApBKuXdcCyaaoO/sXjRY2K9N2LkJlyIsGero3nV256hm8eQk0M2UUY0LSRvrbHJ4LdXVNoW0hXnPrYyndkV3/rokPu2CyynBw5FViX4rUiPruv+e5WFV97w89DVPgM+YOpfxwj0Vh5YFz36H6Qz39pqXdMMJg9Sja2NQNWPWyhSaD9BBTETuwc7sm4LHEWsehgEnsQOFrktLszXd8+xC2Ol7BoDUMvgKr9MFNdzZkOAzF9u2h35OvWaN7EjvlLahUtRL8dmG5yqaZrc6MxXA5Vd4McV41cD/2HDiAGUROueUbflucEbjCJW3Y7nhfeh7B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(39840400004)(366004)(451199015)(86362001)(36756003)(316002)(38350700002)(38100700002)(6666004)(8676002)(2616005)(6506007)(66946007)(478600001)(966005)(54906003)(52116002)(66476007)(44832011)(6486002)(2906002)(5660300002)(7416002)(186003)(8936002)(4326008)(6512007)(83380400001)(1076003)(66556008)(26005)(41300700001)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JwDSzjujt2hglYCF18xtLp/leaeZs+WU3+lH3oIyI6/RbM4golN/ved55rwW?=
 =?us-ascii?Q?Noin7wQxdPY7w2xgalxZhzA38W5BPkEPKtoxXJmrxWLgMD5CkhHGgqsHTxOa?=
 =?us-ascii?Q?aM/4Rx064ta84A+8KwEFBi26yRDdMlGVHFhnIS1eRJSUHfYXT6HQnJh3BQ2L?=
 =?us-ascii?Q?cITuUyar998SyWDQ3zXE05RpBR3ZxV/KnJNmoTd9O3phP86K3ufvQxHNze0X?=
 =?us-ascii?Q?tApE2u2v+NIehl4EK848+6/KkktrYQA9qanuCTJGnaBpimi2fcIutU/8wcIE?=
 =?us-ascii?Q?KYysnDhEQLHihpvWYVvnXnw7o1AIjp6lO36GhgDIEJHtT0UBEIxqQxdqKacE?=
 =?us-ascii?Q?738QK/iShV4CYTnn5dSPXmqhZaB+ziuu812XAzM4W9U0GR1gNQBWztEPz1nc?=
 =?us-ascii?Q?heBTWEiodQXtbiVnyiJ824r30M2nXdfVVYOYs/48vADobisi3D4B+DsFdb2U?=
 =?us-ascii?Q?14Z0KYhDd9kWZ2c6TAzBv6IiYTarfHXoR3SXtTBgBSMIFZkn1hvmfPEuL8YN?=
 =?us-ascii?Q?zYD36H9q8yfCYAf/PmPlNOhpH9AaMEGP4xcseyT5/Ig6QcijRtD/sR5EWssY?=
 =?us-ascii?Q?dcFLwSvI5RXL1T4lsD2Xfwf0qJ4N3aSgKy+q+//F9rIwFVx0qmYfn+QTKWIF?=
 =?us-ascii?Q?+TaXIcZWu68D96nFOY9Ym+38pNSguTA/91L1lf+ClffhaJmo37mm46z3EzXR?=
 =?us-ascii?Q?8uSzKbDcZ+bYAYCtcRDHrFkt+hyei7SwMjJ8saRHFJ+Qnk7m/grwhCDDs8SL?=
 =?us-ascii?Q?JnT6TaigmwiLhjXUUgT1i7yN0kkjQNQWGLd1I9Rn5Z+Zw+ej/VtaghoPxyNd?=
 =?us-ascii?Q?+GS/smMcVVT/12QsHVe6693D9gkO18rNzocFUfH12RyFkqM8JbzpSviChpgS?=
 =?us-ascii?Q?E+A3L/pWufxAV3E+kuc6xiYR2xhChuId74SIpd/A5V2xH+n5eocircO9zJ2c?=
 =?us-ascii?Q?XenuN56lA3hPxXixVuIyjWAmv37x4RPb/0q//0w/Qn0PBnd1rqzPx1IfzNcD?=
 =?us-ascii?Q?o6dSymBkd4RAFVHPS9m4texFHubj2lrtYmZA0DhAozMeDpajQeBOWGwHhfm9?=
 =?us-ascii?Q?I3B+zSPzcRksCZmS4N6ID3lR5RsJ6SsnfO2dqR46MwCW6wCA92ucd/nTg1Xv?=
 =?us-ascii?Q?3GX3smmtfzEWayaPNjvOsY28H/9jkCw/Af4HVcuTk8sPYykeR024UbqqG5V2?=
 =?us-ascii?Q?0naqu2x8s4gHKpY6h8zo2Wc0VUp++LudMsGo5AU6rG0iSUKMyMeah1Xu4QIg?=
 =?us-ascii?Q?WZo2EPpgGESHKg+1PKiJdhzpi5jypXX4WkDjLpvY+x6eKI92cQ6i4tOw9ZnJ?=
 =?us-ascii?Q?7jyX3ecFj9fTTHdZcByXTinorMRhLNFG26cSK2Eg+VcbX54SYP0X/11VeFh0?=
 =?us-ascii?Q?SOQhb/9hktJhLo5l5TZTPyPjlJa2s3HoOHqDjl097vqG03HSoidGC2Pe2Yzv?=
 =?us-ascii?Q?clWOPNcxqtTM9jFttkIutZgE0JJUIjDCDQLvaw7MU66iGQkrbxsQjv7qxJv1?=
 =?us-ascii?Q?DfNa8Xm91Arh9vHTI7lK4yHhk4E3zG7F1dWj7IU5vX/3ukWuHO7vZzfUj/Dp?=
 =?us-ascii?Q?WcR7s2aM0LDk2xfqYAOk6jy/ictGgIze6a36gQw1SL8fI2VEccWfwlDm1r2V?=
 =?us-ascii?Q?WBGGTrDyR8pv0qASu79d58o=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed85f2a9-c88b-4ee7-2af1-08dabe205c41
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 04:52:22.4695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UqMmY1dEalStqZNG7yplUfnfhHegZOT71b/EgxpRJ0ioGFQqzJMrz8VHjVKEe1cE652ukuPSkh6qUd0UZnUvv9pE+5lhsXsaZJh3qXw9T48=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5986
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa.yaml bindings had references that can apply to non-dsa switches. To
prevent duplication of this information, keep the dsa-specific information
inside dsa.yaml and move the remaining generic information to the newly
created ethernet-switch.yaml.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---

v1 -> v2
  * No net change, but deletions from dsa.yaml included the changes for
    "addionalProperties: true" under ports and "unevaluatedProperties:
    true" under port.

---
 .../devicetree/bindings/net/dsa/dsa.yaml      | 28 +----------
 .../bindings/net/ethernet-switch.yaml         | 49 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 52 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index af9010c4f069..2290a9d32b21 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -18,6 +18,8 @@ description:
 
 select: false
 
+$ref: "/schemas/net/ethernet-switch.yaml#"
+
 properties:
   $nodename:
     pattern: "^(ethernet-)?switch(@.*)?$"
@@ -32,32 +34,6 @@ properties:
       (single device hanging off a CPU port) must not specify this property
     $ref: /schemas/types.yaml#/definitions/uint32-array
 
-patternProperties:
-  "^(ethernet-)?ports$":
-    type: object
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
-    additionalProperties: true
-
-    patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        $ref: dsa-port.yaml#
-
-        unevaluatedProperties: true
-
-oneOf:
-  - required:
-      - ports
-  - required:
-      - ethernet-ports
-
 additionalProperties: true
 
 ...
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
new file mode 100644
index 000000000000..fbaac536673d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ethernet Switch Device Tree Bindings
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
+
+description:
+  This binding represents Ethernet Switches which have a dedicated CPU
+  port. That port is usually connected to an Ethernet Controller of the
+  SoC. Such setups are typical for embedded devices.
+
+select: false
+
+properties:
+  $nodename:
+    pattern: "^(ethernet-)?switch(@.*)?$"
+
+patternProperties:
+  "^(ethernet-)?ports$":
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        type: object
+        description: Ethernet switch ports
+
+        $ref: /schemas/net/dsa/dsa-port.yaml#
+
+oneOf:
+  - required:
+      - ports
+  - required:
+      - ethernet-ports
+
+additionalProperties: true
+
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index 3106a9f0567a..3b6c3989c419 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14326,6 +14326,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
-- 
2.25.1

