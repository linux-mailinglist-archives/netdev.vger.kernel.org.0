Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31D0060C302
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 07:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiJYFEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 01:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiJYFEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 01:04:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2111.outbound.protection.outlook.com [40.107.92.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFA210AC31;
        Mon, 24 Oct 2022 22:04:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnMrKXBhiu5AucnP2TAqzB6aZrLfyd82gWgpvUt/o/aOxRGcq1w49WTMWi5jU5E3/njbJYGvJ0hnv14/RBdt9GaABK+SFNeqbbJnlFnGHEYZLFDltadEz4W6oStRbyuhmoFTxxuLd4SspSIeT8x+89sS3fTcXgaZ7AqDlVPZ9N91PE9B8Pmo7dJp5Hrn6WLUs5XfDFhPhVntMkotb9ZqIISIZ50lIjDFl21pR+Adl/dAGp5hD2OgVrln7ZSS6+1DIBZ9rJpXVHsmTCqq+mkjmkPfkKbiBqh29c3Ab3JIq43HzhfWTqSwYI9fOTidHj4kZNgt94Zeex1JA0TjPEnvbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/RMHuEdOnWkquNKOV+j+m2EXCnwMNaa0QcYRvNf6GY=;
 b=oJItE8uLnzbyHcsb5qv6tLKIT6zocW6y4/iD4Lu3Pq3pu3lL52Fwvhpm64O8up97v4eegIUlWn5RwcXowPSv0BlskWC9tE4q6+XjgshEGCcEG/610CLwKw/sVgEdpG3/R1JHzgPWD+vGeRZEvpEZfjpU2axVR+a9M7MDFIs4LueLmIWj1AwJFbW20WyC1+4Einzvr4PexcKCeAkeCdmcwvV7EVBVrXUcyMPDsgF8ggjnJ588yG0+TBtPC5JtR5PefN08326idbDLbVAodaXTDY/aBOJ9s2/rv8l31pIk/Cv00a73EQv6JZ9TAcu8WghfRUAvB7CjCy372/18Lvbg1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4/RMHuEdOnWkquNKOV+j+m2EXCnwMNaa0QcYRvNf6GY=;
 b=DzI+Cb4XgwieFpT7k8821cCLRBq2azDo6mxX/dp5tKtpm4g+sDWk/DfOG+rCYK5jpEL08+jM2gi6hCX4LtFQVodmJ0xLdsWqGbOZ3Rgl5kQj7Op+g/eR36/te3uToj27p8nG4GwHaI3MhvraTt1cucJusSjV+i56DS+3tywYGpw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4989.namprd10.prod.outlook.com
 (2603:10b6:5:3a9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 05:04:15 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 05:04:13 +0000
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
Subject: [PATCH v1 net-next 3/7] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
Date:   Mon, 24 Oct 2022 22:03:51 -0700
Message-Id: <20221025050355.3979380-4-colin.foster@in-advantage.com>
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
X-MS-Office365-Filtering-Correlation-Id: f41e7171-2bfc-4dd3-5ab8-08dab6465bbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +g4d1+XvoSAN7GocGo4Q6gRCuQ9QaOPDywHXI1atvYt16kzYpRtrxBIx7REk266K/xexmwjh8tnKU+iIulAw7bTY82t1EwpgGwAADyKUym2mo8KQdxOdXRF+J6nISuqyDGcqjhhhBQF24je6nT5PKnI96hp4zMvekhLpIXunh3IKQvoK0jeFJSY7sTXMnTq8kNFIJE8P5VgSLg2E9fCSdeb4tdVu1gSFw2jv+DatjRP7lssxf7Hv0HtCY4duszn9TEahCbCz6yxfq/xo4xHaIXghzQU93X1g/x6m2tN6lB3IJMeb0PUx/5zslR6d0QF4615pvb/odsIDlXcwwJL5xt144i7CJ9j7lZct6kE8FZgESXUXcB0mU6Ah1b3rdoIHF7CUl9FmM1U14D2JJQoPVGJ3H4vTmjtPHXExMdasJp2V0euS40HzNBQVZITXHx767Cp7ZBTCnL3+8I7eNh0cyUBTjKOBbCCmYzzQKI/dRwH52GSpvVFsIxLjPaYRJVX1/YL4towlwOFUDA4+Ib6ls9qMMQe9qYSmNW7JLNw5cJC139fx1C2Ad3ASYBCi89BvB7LJh3NdJcBHZxSj/hPznIDk2aV9m+Q+LiPPHRxuns5yc8k3UTI4OL6f697bmuLRkUanNFxfGl6busK+xrruAYdayAF4BqgTCkzBSl9aOj4oQotzMnEE3+SX44tbhZ/JycFtQgjP2WAeC5AGSHBFK+uZUvecLl8qTNqSDb/3LSEqjiqOge81J4crd0yshD3UlO/67X6CeNWyVQS/B3GKXO2pRB6sW9WoIo3f9/VvTY4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199015)(316002)(52116002)(66476007)(6512007)(26005)(54906003)(44832011)(36756003)(7416002)(66556008)(4326008)(41300700001)(8676002)(66946007)(86362001)(8936002)(5660300002)(2906002)(6666004)(478600001)(6486002)(83380400001)(6506007)(1076003)(38100700002)(186003)(38350700002)(2616005)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?51mNRRb0jEHJNECohr14Ln0zaNDTn8GA8LoSMndYPio3kwBKV9WbagZFVaBP?=
 =?us-ascii?Q?2nNYkTPiHZQP9j5mBVaKs1cw5liRv1jZXQvmuD1/3bcjdpDar4kpduIViGvP?=
 =?us-ascii?Q?B7kEWmbhYSljinjY9r+yDFzkIxa4njI3PmQ9/1mC75TwrYy66rBMlZRD0YqQ?=
 =?us-ascii?Q?MNVmMIaAI0IfKyLhVgoBEnd8+YwILHMVWwha4/T4L3K5fZXljaZ+48y1L0Uv?=
 =?us-ascii?Q?DC1TywKfQPwu+K12Tws7U722G1HrRZyHp1nomJKZVJwu+Dpw7LQzdqgkQqJy?=
 =?us-ascii?Q?y2uTORzvYgAtNz7RYfVJ1+CtRvzcDv1C0q1v1z7s6JMpz4L5vFxaCbpF8lcO?=
 =?us-ascii?Q?e6jexySqxJ16/Dgr8eG1/9V0dpEBTfC0Y4cbSGP6F612OqOA8ln/CZyX9DI0?=
 =?us-ascii?Q?98l767VGlg12AU4qqyUYlf6VZ1jn06k6l0OjPibF5MDATuEF7Uhd3wum5w7P?=
 =?us-ascii?Q?6Vjk8yNqHIyEEFPQ6X4yPcTFQf5h8VEE9YHMr0Uqkj5RSgsGhE+jv9fBk/L7?=
 =?us-ascii?Q?VLhRHD3qbx6PBK4MZk9L7hlQ0HiJhw6cXwZ9/nwNuSHitw3LyLFiPa7PhrcQ?=
 =?us-ascii?Q?QIwl8OWWTrsgk+vKVgqDr6Xohan1q7wIJqbHBwDqjtulwOxKBir5RAj4OEkS?=
 =?us-ascii?Q?ZHVAMygmDxO+MArFY3kg3dvFLfxW7AjKwN+aqu1UqqFWAjF35PXU7qviCuQE?=
 =?us-ascii?Q?gRR79y1zzwQ2q4cdva9qu8kdF20U5SnJsx92AkI+Xkj1YMMhcxG4Ov7uLvQZ?=
 =?us-ascii?Q?mNIrdnjQg8xVSqAYDTms8o5GZo+CRb5am/5WLiLl5Vy3fRO5d9I9hk8+Mewu?=
 =?us-ascii?Q?/VTz/+oZNs3mMfECgP4CVOklQWk+ytWVz3aqCw1UsIgT522hy/jDGVIwpyAV?=
 =?us-ascii?Q?fqT2I1X4jVND3bwHTBfPqNxoHAO+nTPSnJKLPSi7rQOwa1hsOm08KTGy7AMQ?=
 =?us-ascii?Q?NPRl2B/Y1qMsyQEkeq9cvrsQTDIuKeIo+hUpuh5lF0Z528lJbhBdQTQkQ6GL?=
 =?us-ascii?Q?F3ClvX/qMuAruDNBs66rOmhpRpzc0pvMvNpgEDNo0FRsMIIHogTr1dtl6cpF?=
 =?us-ascii?Q?dpms4ryhJ9uXKR8YHTIB+0ib7SgXe2Pvl3SNkAdp88QKOWq/E4GMPIr5WO1Q?=
 =?us-ascii?Q?XY+IEEvwrr/15sRhGtT2d1WBcxzqOMzerdcXvgv/8Gu6e65c9iGYp2SqY8ih?=
 =?us-ascii?Q?rE8CjbjDEmkKnc61PWbztFcNYTpGKX9NC8NjTQwd48wy6aJYCeZoENgrsQ/U?=
 =?us-ascii?Q?AZNrBIJK7JZ7LJeu05TQx6d1MUpJeJQVry6ILVo9bMPDgSbeXYjxBuYpCYLg?=
 =?us-ascii?Q?MXHCoJQwXTCcHexmYNhElxDHtQ0gRCQXZMM05DDXjN+vXuFfHdLgr3JE75RE?=
 =?us-ascii?Q?PK5mbxcVqBE+zg1wg0Ba2Rr5OA0iM5Y5YKFQlcN0Qg8x8iq+P9aLHJpvanBN?=
 =?us-ascii?Q?Jgw++00t4+bIoki6idMrVz9CzrhjSP8jiSrv+fLQQqX4HKN9bzCYSxDxLZXK?=
 =?us-ascii?Q?b73mrmqIJa6I84EV9UCgh0UVBqaXV9DrvJ/NcMZ0j1+/um1+WDTgHDLpJxkC?=
 =?us-ascii?Q?s4o8+UwzS7FbvIndjHDSS0bxYDne5LttjyexSgs8WojEbAtGz64FpbixowYU?=
 =?us-ascii?Q?vlflZWpgA4PZf3ZR5ZZdUpM=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f41e7171-2bfc-4dd3-5ab8-08dab6465bbc
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 05:04:13.2039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4kmGcE+0FCbbwC54B/0hCGXPoEjzevApyB4Wneg66YETrvlF99iLZeYPNuNfozUcMk2OuX+Ax85b51pHabDL/lY+HfUo+HKyEwdhch75ABA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
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
 .../devicetree/bindings/net/dsa/qca8k.yaml         | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 978162df51f7..7884f68cab73 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -66,22 +66,16 @@ properties:
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
@@ -104,8 +98,6 @@ patternProperties:
               SGMII on the QCA8337, it is advised to set this unless a communication
               issue is observed.
 
-        unevaluatedProperties: false
-
 oneOf:
   - required:
       - ports
@@ -116,7 +108,7 @@ required:
   - compatible
   - reg
 
-additionalProperties: true
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.25.1

