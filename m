Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C411618F95
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 05:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiKDEwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 00:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiKDEwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 00:52:21 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22D420F61;
        Thu,  3 Nov 2022 21:52:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jtn1fEEsNknTkMHSiihi5yZLwpc/MX2DBddvh9XbyAksobU41CaSmNKBwhDay/GmVs/z1gh44bpahWIm5A2F8ax0WsytIbczX75a90Xtn6OTF/hRDjH9SLoDYZ5ZbIJUnI3obUNuKLEKyxBlWINm8aDWTPm5exKlrL8Q8IUlEXnh1g02tqzJq1wlFz2VZDpklXcMWN29wNmi7RM1zmgg9tP2S+yqLxcflWi+KfSjxBDmndYg5ZryLbi/Z0LFRHhvhYLY3VcYkx9ZIMkLSSvTIhH843oEpi//sXMWgJI1wSaABnDxIHnoRLkkkrSjW8aRlrLLwGltTuSI2KI6p6Ct+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rn2pTQA+eN6zHWL391CX9DRLmeHrRT1C6lKDQAExoMI=;
 b=aQyvJqVqS58HvLFzngvHSfZ30WQw7Oto0xPPT8SQDda6kwUjFqBNK2H+j/wcs4S0h1YVU3mbseE8c8EmRKcxov1hH1Q6D07G6+AHl8paPLNGBg2Qf2VB0TRUONzgY5B9/61M7ctg+DJiD9pj4w8GAXD15yjVNI7ocv/Y9HZ/yAAlk1IkW2I4CaGLxmoahMuKtem+chifugxwMTX0LPGqGB8gnjDkifS4ZFpDfLwuJyN2G9KAHlzP6OLH5S5IAlTNFSXSZEXpJ8laIWzj54CLyghbpKDCb0xe8OCYzqMIj7l4Q/93qJ7xP6L1lVcvcUxAdu3Qfp8UryaIyeXgGxbSxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rn2pTQA+eN6zHWL391CX9DRLmeHrRT1C6lKDQAExoMI=;
 b=YyiVa2e8teuZ0gQtOjEsqUdIxU00pNEf+lZ2uKrsm6s9b84hf7CPLlsLEyO8I9Jg5bos3BPuDUYKQI7h0UorISwDUtFYWawI6PlE48ZgyWAfnNwtuPv9IKMTM8aLB2xMGYKf9MLnLInbaABI679jhcR5iaVe5AF8JocEgfw7v8c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CY5PR10MB5986.namprd10.prod.outlook.com
 (2603:10b6:930:2a::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.22; Fri, 4 Nov
 2022 04:52:19 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::a8ed:4de9:679e:9d36%4]) with mapi id 15.20.5769.021; Fri, 4 Nov 2022
 04:52:19 +0000
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
Subject: [PATCH v2 net-next 2/6] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
Date:   Thu,  3 Nov 2022 21:52:00 -0700
Message-Id: <20221104045204.746124-3-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: 8b90a5ae-cb2b-4483-c366-08dabe205a28
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7aO5N6hRepcD3dwu4zMbrZ0VDT7G5Es64y5ZypWUfhKVgX2zpM2ZDsVDKCPPuMawZk6QLRsAJRzAmcMUjU9/ZUwrKYD61EH8EgcIz9CIHuY3fwy781F9Juxo/UDzH+CW0wTCzRrtDATPwA6/WuAeYmd8vj/PdcVKgYK0deCRltnGiZjtUtZQFidvhtbaIpt0JqMpJ4HFboupIjMo0qtMX94c0LD38OfFQ+Ncx+u8iYafXGUDAwq/9MZkIyWDxjFMS41+hhK5PemY15CbNnWGJQR0EtPjca2fdkUQwCDZlzLktPtextdY9Ap47XpTul10RYbmzzwUQAZfdVEzJjxtwRp1ifhXGIoNcJDSVBYSYvfMSblz7TGPc1aoc+US8IIxRy2FeysYfv5hcXxeCN1Cw8VLyEWIqRLBYabjc+d35YvqQqm6Hp1w9nPEv6PJkIQejilmmzmqobsv2niYzBGh//XOxBHyzgPhxlmuhDJQwo3ABOhwnQ1CXx7fVu91+zDUX0ewsRj76IMQzeczUyNNhMFYaLM2lPI76j0qRRcGvK8WMSOPUqQ/01jkWiCbaUqz7QjDAbKcNUd9IPFKzr6iRS18SqN6Kk18YUJuhN7dpfzruSxXDrPGAcXUJAM8hoYTclu/0vcNwtSp+VmW0vYjUkh0DbUIO2nSCQ+8/6v5Nji2WZQZo5VwbpfxHKv61kqb3AopQFEo/rU+YSGkEdg/x4urwS+pyrXjRxaVJBOgGgCY50yr6czMXT7OS0Ebjlhtw+jqPB4edZfQFBhSwBh6oQ9A202s54iSgUzicUNS8/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(396003)(136003)(39840400004)(366004)(451199015)(86362001)(36756003)(316002)(38350700002)(38100700002)(6666004)(8676002)(2616005)(6506007)(66946007)(478600001)(54906003)(52116002)(66476007)(44832011)(6486002)(2906002)(5660300002)(7416002)(186003)(8936002)(4326008)(6512007)(83380400001)(1076003)(66556008)(26005)(41300700001)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ci5ES4h/nAc7zQUGpw7FJDaDnJEARmBgoMS10yZXvlld5MWYRFg2pCpy42/W?=
 =?us-ascii?Q?l4rKTKM7kv7/v3IyGf0t7WhapYVtXcb7eo1gstsKWDTuJm0WvlWTPHGGbxny?=
 =?us-ascii?Q?Pu+51MzBVnkfdvymXa7BCthJL40k+Ah8DOy0/sQHFy3e8ZzYR8n4IEI+4z98?=
 =?us-ascii?Q?m37LSA/VogEq+6bIsPJWecyfvuO+n1Wmz8FJvTDNLTEm+slUcYYDOYxofdha?=
 =?us-ascii?Q?1mKi0Kke8aX/v1U+u7ly/itaT42kzoGlbvrVUIoY81OaeUaiVNEETy8AFoZC?=
 =?us-ascii?Q?xP5BGuRoHripmo5jdx1FDXb/D7+zR7SlCAzo41COl+LsVeNlBlXdxhb8wNwR?=
 =?us-ascii?Q?kKlSJOzmA12FvJQjxli5hdjZGCfLGZ803Qq3hytGslpaE178lpGGKEK/MU8J?=
 =?us-ascii?Q?vmSmCA63fXaZ3dEbCEFKWobmpO/BKq3MD9oQJ6QpGKDJ5OFmpTqS6EVwI4li?=
 =?us-ascii?Q?/wDlOduNL/37Gi5YmmgI3rizsoWOpF1hCPj3t6SUK/PXURbHG1W2H9fBlQQC?=
 =?us-ascii?Q?Y05pgqBN1/ovTvyxwqpAPJN93Fzs47WQJ/d018TQatCuzs4rfw0c85ka1tDH?=
 =?us-ascii?Q?HUleuoYi+n+ArxQJX+FPu/ZAMXJrvsk2T+B5fTWREU4xHcasaUQv91B0CftP?=
 =?us-ascii?Q?jAqLZWQZeyJeZaIz7Z2we9Eqamixv797VuxavPT3DvTOp+Cg9n++QcWbchL3?=
 =?us-ascii?Q?jYhNp9RQ7f43RalNDsN0Ogvbgal9lpTU6T1udhmT9F396lHd/ZbZfPVRurrM?=
 =?us-ascii?Q?t+uQr4e8KtvTxP/xno7Xkgg98j0aG6omUgzp3mbwIdAYRIxGetQNG/R9F416?=
 =?us-ascii?Q?rhFxLD7H16pvoR+TeaUFhQBA35ckYPsHG8kgOCt8V70+ZRxG5iXStT9aOj6B?=
 =?us-ascii?Q?sO5vXjyMrh8GcL3f3mU0HeVCehqP2Mju2fuHZ0YZmsaP+Y7uo9MwwCuJT5lV?=
 =?us-ascii?Q?9eFAYgIqBTzmjA5GJYqoa/7YhM7yJoY+iCJ1vjge8MjUMdOOXDR720V0mVyr?=
 =?us-ascii?Q?4bTiXTdQLyKYWhqmEv+aEWppR9/Wg2VLXXIgA88datYPz+zl3FW2AOnFTtA9?=
 =?us-ascii?Q?KHinn5DkIm23pd7XaVhHgmTX+wacFYTRWMa5XskZ2iuxYblgdA6jl7q27N8r?=
 =?us-ascii?Q?OvneaMzUXGa4hUVwB/MfdIMTsgR7of+GFoTW/Vw3qv6M/w3nJ4oHGZGAZF+x?=
 =?us-ascii?Q?BRyBmUkfPuNjtvkt0RmYGXtDHjhJpiSdXLFVASxHj7sjbL3fQQJgHKBUa5iB?=
 =?us-ascii?Q?nKWdojRO/YgkklsCl+tmiJ1fqqts6VAoKLVrnqZU0SMznGOa0JHh9mrwh6PZ?=
 =?us-ascii?Q?fMAATtNXAfxsENKrlry0pQiwY4SH7GMN51yTTgfBkElVL17iL/qzPtwyM/f4?=
 =?us-ascii?Q?GvB3emnnXLp1tM31Xea1InJt4FXO06ErnAp3ZnBy+67fRkNRPAutyfB9tcVA?=
 =?us-ascii?Q?/x7vSGP05mHNuzusJn4hzbrYf/e7nrMAHm0vdat1b8x/qUY3A5rdwg/dLWkF?=
 =?us-ascii?Q?cZBuK0Fwln/1x/BJsrJajYj7tUVIdOE/G6JE40Is1Qc6W3yyD9RWjNebtIKT?=
 =?us-ascii?Q?BzpM/1Oj7FmX5UTSQfLd5AQzgO8qxp7en5OnoXbK2wJh6cxNFuJUxjj+iOS2?=
 =?us-ascii?Q?Jnzw13SaQAipmPz1kIFnY7o=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b90a5ae-cb2b-4483-c366-08dabe205a28
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 04:52:19.0635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6+uXihseIS+5FJy/gIe9GEOEVe9UpY8JZ81lqUU0WLkUsD4Y/I/d7ApBWwOr78Thir6F/x8o/Lg+9ZTV+wYx6MlPyOHdgvuIFD0dki7Xb7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5986
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa.yaml binding contains duplicated bindings for address and size
cells, as well as the reference to dsa-port.yaml. Instead of duplicating
this information, remove the reference to dsa-port.yaml and include the
full reference to dsa.yaml.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
---

v1 -> v2
  * Add #address-cells and #size-cells to the switch layer. They aren't
    part of dsa.yaml.
  * Add unevaluatedProperties: true to the ethernet-port layer so it can
    correctly read properties from dsa.yaml.

---
 .../devicetree/bindings/net/dsa/qca8k.yaml     | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 978162df51f7..d831d5eee437 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -33,6 +33,10 @@ properties:
       qca,qca8334: referenced as QCA8334-AL3C QFN 88 pin package
       qca,qca8337: referenced as QCA8337N-AL3(B/C) DR-QFN 148 pin package
 
+  '#address-cells':
+    const: 1
+  '#size-cells':
+    const: 0
   reg:
     maxItems: 1
 
@@ -66,22 +70,16 @@ properties:
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
 
+$ref: "dsa.yaml#"
+
 patternProperties:
   "^(ethernet-)?ports$":
     type: object
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
     patternProperties:
       "^(ethernet-)?port@[0-6]$":
         type: object
         description: Ethernet switch ports
 
-        $ref: dsa-port.yaml#
-
         properties:
           qca,sgmii-rxclk-falling-edge:
             $ref: /schemas/types.yaml#/definitions/flag
@@ -104,7 +102,7 @@ patternProperties:
               SGMII on the QCA8337, it is advised to set this unless a communication
               issue is observed.
 
-        unevaluatedProperties: false
+        unevaluatedProperties: true
 
 oneOf:
   - required:
@@ -116,7 +114,7 @@ required:
   - compatible
   - reg
 
-additionalProperties: true
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.25.1

