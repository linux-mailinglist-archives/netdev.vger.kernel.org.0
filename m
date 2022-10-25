Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A7260C30B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 07:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiJYFF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 01:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiJYFEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 01:04:52 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2111.outbound.protection.outlook.com [40.107.92.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 864E410B7A3;
        Mon, 24 Oct 2022 22:04:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtFdep2aCKSqt5ZXusJaFwbkdAW1Bao3KCX726EgX/duRas/sbq0a/4KVC8RzZU8vKavN81spWSaPVMqIKwT34sxUl3h9hnJSTyNl5P/JfswT0iGf+BMy3JjhU3ipnNV0DcKJCNvC2LPeaVO5pGuUTWUhDwsrtqXEhdbI0+RPlpnrfpEvIzfmZ8UahjANriwGb/QNhKd1GfPnflCFJ/aIdO02cmQfGBqKst3KHWoPr6CDhbISyMOOdTnUAsDnms58zWOFuPTiu1LivIn8dCihx/UxFNDGe8SgJWHBcZ/a4zsf1tm/tP4HPyDQl/oGPkGgY5f9kfAP6ZbwVngO4EsWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cNnXTXeOUPV7CQywjg7olCcL6rmd+7/AFlxSOijwJAc=;
 b=UjRPGhUy+aCatdk6JuKxp5vLAOM7r8Odv8urO9TNf/pjFyVRQNrO8pN0DaXx8GJw/cfjv6u0el23q0LFsLp10UlhoVosVnmWIbNHUhouicG/spZ0vCAs0ToNUm6D5riDZ9dkvqnfmh02piBaivObwr0AzP1/ii32a8j9bXROuvZEjFdXZ/rgqlRJUswSNXQNVJ4H56HCV9LzzRSrUzSzYHv2q2cFXTABScOuMxQaGUyCBD986gGYQuLqYQCEX1Dn4NPLOX1JnRHuY5JHORKFcyV8tY7JAKMKi2MqPM0k2/dJTcfeKsfuvMf7T4aF4VcmplpT1JrOve9TuBwmAyeu5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cNnXTXeOUPV7CQywjg7olCcL6rmd+7/AFlxSOijwJAc=;
 b=la3eQhM4WndJ3n/GhJtf8+dELbu3WAWNPwwJQqpGX9V5gv1M3h8FoHA1NFssoGmD6ULsUqMtrGyDV/hdLZ7XVoC1fBu6oE1Dg8HX1fgpMdF0/JBPY5nAkAY8U1SvSqW9xGwTOIdjnvPekex92tWG7ApwERgnek53ml8WbIV1wKo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4989.namprd10.prod.outlook.com
 (2603:10b6:5:3a9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 05:04:18 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 05:04:18 +0000
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
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v1 net-next 6/7] dt-bindings: net: add generic ethernet-switch-port binding
Date:   Mon, 24 Oct 2022 22:03:54 -0700
Message-Id: <20221025050355.3979380-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025050355.3979380-1-colin.foster@in-advantage.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: 983e5af6-59ff-4fcd-898c-08dab6465ee4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbQX8q0CvssWiy7jf4B3eAy6QI+Z5d4pabjHsRDoda6jB6oY4PWqHuGgKSbKiz8zk1AqDF4w95o92S/Mbrq+vFW3YqNvVfKq5R8gdrb5fLJeY5GBWHdKRqTZKJWiMWfSyD2rMxh2m4OuZTKAwkvZjPNmi+0+GRGm7aqyxk1QtdEjBPC7PcXCI7O1zUa5CBdai99dae8x2WQAgiItv/QTZPOOiqL6Y9rW3VNa7kmD5oL4/scSQGGsOhlDnrfynCIRffzjSY6x02PBCBCiK1rcb2QKvrMeg6WmkL/nbnTOTaKrmlZvWZCA/t0F3jdj4nZBvWC2dQmcw2+aFWbtuKAIJ4wmEsXNIaY4wgQoiAMn2cMsyvdigpO5iJsZG2frFWdggMXDLjg/9St8Mrj/5DXWHST4HGRYuwAzMQDcw3Qfq06T9DYsUCP7InL4wC3Lmygpt61UM7b0OXlBCKEuZ3tRpRW2qOdITV9/imer2ANrJlb9G6KLJXSvzg0GkGi6VNl5TwMGyRirk4VSRicoVsJMdTCWP3k3pFNB6ICa3bTiq+PhoMyqpyaLrUnqPnkk2eIL9JHMq7DkTLxAcPdCB03EFQqSXvYnxge6rfxvgFS+tw4QhDDcqCEvR8N0htuDedvaqVsLZ8SYoQH3AeMge4VDCdB/Z9E2zPTymwAmVp4pzkXO0Rqt75wQTzxBS9pvYCeBnYF309IpPqvaUaL1D3jlzpQvEB6h0YZRoPxZy+DhusyvcWFvNWYKo5jxbGoubV5MTht1kDUIlcXF10ViOET3J8YQnDc9HLhY6orR5RkzZfPKY6zp2iqjoDOvbxslz/NU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199015)(316002)(52116002)(66476007)(6512007)(26005)(54906003)(44832011)(36756003)(7416002)(66556008)(4326008)(41300700001)(8676002)(66946007)(86362001)(8936002)(5660300002)(2906002)(6666004)(478600001)(966005)(6486002)(83380400001)(6506007)(1076003)(38100700002)(186003)(38350700002)(2616005)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4dRLb926lQ6Vkne39Zn7QUIKPq9zFsvjWgnVsOTsXEqdhzFvFWiv82WanTnp?=
 =?us-ascii?Q?XBAWOWUGWp35UxaeD64F+XRdZRlLk9Sz3WORNpulSHiu8LZsq1uspd0njrnB?=
 =?us-ascii?Q?OEh2XHAJD2DFTIjtGx0HkCRt7fVZur3OlVj/p25gK2FGbonLUFTHRoYALZ01?=
 =?us-ascii?Q?dn8cUTqO8H6/ReYK990X6L7XmDDH6mjmKrxBAdQi2l6MKLy/cpErta7HVppj?=
 =?us-ascii?Q?Ya9j641mebU2AvtOl1J34AtHIy/KgJ6VtNRCVA3ZeuPy6wrzaWMxRDBf99Bu?=
 =?us-ascii?Q?Y5rxY8raQpsX2niowG/8hNTX5E2Tn2HhmFh2JXNtFq5fPWZSUBtFiO0nlEle?=
 =?us-ascii?Q?a2MnK8QmzIaVXlZJf+19rfE/lFCj20YRAK3OPFuck7SM9gE8R3pdY78l889Q?=
 =?us-ascii?Q?XZLashr+BzZrGk8DfcmkWPkWQDW3cyk4Zh0BX6mWhqgTz1XyRvJIue7vSIxk?=
 =?us-ascii?Q?wOj+lmsNJKc41uNweIYhKS1p8/pgQn/Sncnof2cmyZGVgKzCqz9xt5uFDi4P?=
 =?us-ascii?Q?+RXoROc8GKWxWBFVvKkoMy7MUqM9hOMBLaqcC20jDCMMDdmz2IVAyWhc8wrh?=
 =?us-ascii?Q?h3OFMtTG++WmpQbnbq1MAqp81co8oxFQs7IVy4bW0IRMS7kiFIaoUySC5XTw?=
 =?us-ascii?Q?qGVhuoHwgjAPUUHm/uUIj3lUsnXPnbq5Dvk2c225C3roxjIBxMUmxG8V3wlN?=
 =?us-ascii?Q?u/8dpw9DHlWBr+yOEEUi6l4e1zarf0FvYduqn2fhEO5ZW04nY0w3zIzQosto?=
 =?us-ascii?Q?9lLz3NUbPfiY/QmZIw+Q8cFLFlQRbiVLSAmXpHt3m16m5kx21I85C84X66RB?=
 =?us-ascii?Q?34DQXFSJrrUxmf9z6eoPlZ3k5VTc72bkiN2mb+keoArX8I7ZaYsYUDwKXkIV?=
 =?us-ascii?Q?f4qcTLRoYdnslocwKr/tAN7j+zYPm/P2qk76j2pa0aoOVWKC0JEeWMJ94K2u?=
 =?us-ascii?Q?pLe8ttjSfX7JmLQCk+lSeyLV48PPip1Y9ifRmFZ0gKBfhqWhmPuLMmtxQ8RO?=
 =?us-ascii?Q?dSA6qRoJsfrBrzFaMT9er8RGKwmMuT5c2rH8EoR7KFC1aNbGFbGSldVCB9oD?=
 =?us-ascii?Q?AHMpOOJcgZJj7e94Fg2DtLVT2nKV8p2R7dTMXXndM/s2c4JytxoZztDgMMgU?=
 =?us-ascii?Q?KE30VFJL9XwbkwJlTTDbcotXHeL/ZhcnsaqeFYMRgUo35NQph9RnIHbvf4b5?=
 =?us-ascii?Q?4HPYdTlX2MQw+XI8aiUgNpcOzucoZ2NqmLr0gRLR1oO+gFIQORmbrXElEL3K?=
 =?us-ascii?Q?N5tjIs9u9TgF6r5s6gZeAB7hRQEM9sLOcIT1uOq+Btod0uXiXTa7MXZzEuD7?=
 =?us-ascii?Q?Kp4lAZSvVK4EyqVsvjDpUEN7yPf8RsVnWs8f0dheITyZ+b3e1mEaUoscA6iQ?=
 =?us-ascii?Q?no8BjQjNUTfM725rPctxd3UX/nPt+tPSfxBHXLJTWY5zIaAcBsOuxZC40c7M?=
 =?us-ascii?Q?MlyuZtftLqgUU77PPOeawzMSDdAY9Vfx+xieiQmn7X9NYnakj1ul4qDr69wX?=
 =?us-ascii?Q?UmbCYqPW4jAw+o9NcNU3wu5wnJxWNHcLPM+d4YrpaPs0QV4G3ZmdndeeJe21?=
 =?us-ascii?Q?1mGTl8MlXVt+43hsTE3TWphkJt0FhLbXPRATxs5ZbusXAUre+vqgJ4X6ZA6/?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 983e5af6-59ff-4fcd-898c-08dab6465ee4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 05:04:18.5004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 79DADlt1HsT8pb18/jnm1AZjN1Icj2TJKPQJW4cPKP9ljVrnRenFWO67Fy3NaVKyhGCZCJuZaK6U8hGyNcUh/hkh7xlcUVN/4xfpU2xO+L0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 26 +----------
 .../bindings/net/ethernet-switch-port.yaml    | 44 +++++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         |  4 +-
 MAINTAINERS                                   |  1 +
 4 files changed, 50 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index 10ad7e71097b..c5144e733511 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ethernet Switch port Device Tree Bindings
+title: DSA Switch port Device Tree Bindings
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
@@ -15,12 +15,9 @@ description:
   Ethernet switch port Description
 
 allOf:
-  - $ref: /schemas/net/ethernet-controller.yaml#
+  - $ref: /schemas/net/ethernet-switch-port.yaml#
 
 properties:
-  reg:
-    description: Port number
-
   label:
     description:
       Describes the label associated with this port, which will become
@@ -57,25 +54,6 @@ properties:
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

