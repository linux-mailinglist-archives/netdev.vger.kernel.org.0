Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0EE667DFA
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbjALSWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240580AbjALSVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:24 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E3C1D0F0;
        Thu, 12 Jan 2023 09:56:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HVmLOifCFRa2n1PGElUb8g+yW9DE30Uo7+peL0BiTGIsBfTfFvVuBVB6XVYxgQMad+zOODxRQUOGU98jDeNmBhOuZyDHdK1ZO8S4jUPCwbm9q9f9mSaimLRYsS4nLKjULbW/N1z+VdmDfbCQD11vkJ8QaroIZOJYyKfzAwMbHgMaVoBUC8xh/paxyXU8qohl4r8OtDVkIOKf01CzszG8UMg3N2O5TMLlraHdvxelNyva4TuhV9XPLN808rwA79mOBpbFhMe9kWRsAnp1kyF7vm/TVqJhnNc5Eeb95vSJ7sOce5aTNCfUVFCrIDzDxarqd+wPa+ud8Xt7GCv4/7c/Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oNBOv7dVDoShGlUEJXNcsZMnCJqGDPiunqVqy3Nx2Y=;
 b=TrU6GRkL7GHIM8QIcS8hWBM9jUINdtOiTmMryMTwJscw7VGVgXLib+gUrtFir0SZUaCzUyNM5VXztBT3UXK39kmeNJzH19viigtpTzUvz8WJd5Ofs3R6Qt1cATSQzmoAzTlUBSWVbsSWKiKkmPLp/pAMzIwuBHIkRkOfvX06b3rmL9n835R7NSd/T4SNi/QMVrnFgo09ycQ/8bXq1S+SdE43uuVOz2yKJDA+UwySQypgc9f7X7Uu+WbcXJjzrqSTCVMXNucMVZCsRBjuUvCZmXcowHYWv3X7xiGqE+Ypvza2VlacMgWZv9tJggtqK2l1wYTPX8PYubcWcAHOsuM4FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oNBOv7dVDoShGlUEJXNcsZMnCJqGDPiunqVqy3Nx2Y=;
 b=KxQrNyGSfafaKIRbqGjN+HwT8u2UiA+1mP9hO6fypPbjzWuiyb83sZuvNksrGiuZwTjDOUgwQv3Zzdjn2BarZnCr+lGIFnfpqUDWVvjbZn3XNY92cUM4Z+chQvk4SXomr+TwcXT9VZ2iXKWHXiJ22mx6gVlJ7A4VS1RNtdsCgyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SN7PR10MB6548.namprd10.prod.outlook.com
 (2603:10b6:806:2ab::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:56:50 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:56:50 +0000
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
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v7 net-next 06/10] dt-bindings: net: dsa: qca8k: utilize shared dsa.yaml
Date:   Thu, 12 Jan 2023 07:56:09 -1000
Message-Id: <20230112175613.18211-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SN7PR10MB6548:EE_
X-MS-Office365-Filtering-Correlation-Id: 45db3a41-4e30-40a9-a10b-08daf4c66152
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gwx8azZ0rVl6GrUwWJsWzMfLLPl8Im7LDPzNIYvqA4GGfMH7LyEVy2UuefC7TS8zXW7TrLtYlca1xw6I3xEW1Gq2NOyqkB/Zz3bAHa85syyjJ4ShZaDQmdJ9JdTpGwUt79uly0vLbcueSdAXDF3A7aDPoUWbSGOTomOGxlF8KhGFJ7aKv8GNCP51FpYoaiCF19v2zoPp6XLOxwYRmS8rpmo3LP6qIzHBFUOTz7e7GcPSgGcR2iokr1GTtZ6vMQt7s6t8IFOTk0PnRW8Adf0Et4RG2YKDJjEGLe6OHsTszAe3Hzrcv76RtI/sIGQL6YME1BQ2Xycd9HkQmBTb+AWaY1mJN0Er95sPrVQI4qrsDnCU1lKOlQFl07DPn6YjWEEBK8aeEp3CjYMqmFlF4YnnkJaOoGtenXwl4v1qlZdgCSsQwmVhHVKRKhq/JUk6uOQ2nMXXefA/Y3ZXqnCjo92IG2CoHs+o0ENFKfUhDFS1mmjU+j2aTBbUL/28zrr440TB+GLlYN75XjkQ6/WheNrtwEClx1AJkWGxg695l27+HAXlQKDRiZVSd5/4pPD0q6PP85wriNMpibYmwSb1ovmIj/M6ilItp1sGwOZJ6XRXPQ9w4apLsjZCxE3gKefyMB0hd8kuw/pxRl6U7zSq9Zs6nnNLE06dQei73K5A/4EAEOc/C9yZRVXHLiIuT3j4q8OV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(39840400004)(366004)(346002)(451199015)(66476007)(41300700001)(66556008)(66946007)(8676002)(7406005)(5660300002)(7416002)(316002)(44832011)(54906003)(4326008)(8936002)(2906002)(86362001)(38100700002)(478600001)(36756003)(6486002)(52116002)(6666004)(186003)(6506007)(1076003)(2616005)(6512007)(83380400001)(32563001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1XUsTyFoEoWpL7yrFRPoAYSgCG33TzWGUJmqtNlrjZyNe9Na5m8XlCiA79I7?=
 =?us-ascii?Q?YS71Zk52sJfT02yWD4MoXELAfQlTF6IMwcDsIIMMpPwlbSIrhl2XaTOpZh3d?=
 =?us-ascii?Q?kbuHzpYdEXTTIyQlE1h3TFYcjaKqfU0I06lNZlt3ZjC1UXF6RP80haSNjy0D?=
 =?us-ascii?Q?gBsf5Mo6xGOyEqTUHpWrerP00SqUmX2JYgq4B6tWTQ9P0lUvBlAZ1psEbWbW?=
 =?us-ascii?Q?rV4BiheK4pAU/Iy16dO6kezPIFqPGEF342rxHq7q54B341wvSC+gOGgA9MiU?=
 =?us-ascii?Q?1qgY6M0vCDbp9irF34BhRQ1PhoLXd+HmUFx4RTm3eDsJekSOZPsz2cZA+sPz?=
 =?us-ascii?Q?QRLvS79+c8SIEVlaMXp7UMwZLLXAUAL1ztH4n5VyLrL1EGhu8sYcCKt7RUD1?=
 =?us-ascii?Q?isusbh6JXlWmz5owBNdq5unDODxKKDy/Idy2H0Dswfwrek8yfqzhudzrnto8?=
 =?us-ascii?Q?hTo9UaxlaK45Upw2FZiayXlRSOagJ4NJhCT0iSHZgDXdLyf3iTEiK2t4jyef?=
 =?us-ascii?Q?DLrZS9L9cACd75YIKq414jMUHBrEYkdfNq2GdYPD6JAJ0rnQmONAnu5MEX0r?=
 =?us-ascii?Q?rg8otoVoy/7Pf5vtux++aqCEslevWl0OvDIVcRZE14R8F8OyWJnVd30hiTt4?=
 =?us-ascii?Q?f1a7EKwNzQN6RUYAm3wh226mK6fqbli1GU882odKBtge+8ivcN9LH2uGiWIK?=
 =?us-ascii?Q?vAszhDIPYaGoO7zfIrXSFOIp08tQ4H1O0Yhe5qFyd0fF5eq8grBDK8DKPE54?=
 =?us-ascii?Q?7ijQ0AgaqaF1BXU9fj8hJ/upXxbWo4or1u8U04Cj9WCqoEBltp6GuHw2jOqW?=
 =?us-ascii?Q?oQ85rbo6V1GSo58Wh5xsiNZEMjvg9p0X9N5acGPXELM2lAYradYOW5Pjr24l?=
 =?us-ascii?Q?gaPW+OgiR7+cVFn2qNQ/zKfuEEFcwA+2LCrf6Aknek8nWsR/TcIBLW2RPAC/?=
 =?us-ascii?Q?u+Lu3y8XETv7e/4yB47ntcHvqjrYvhiYb8fUsw1P9dV2/OaOfhKuRL0m/FQK?=
 =?us-ascii?Q?WfdDmvJXz+irbT6Igh92chJTnhvcaw1Z07CQOjJFQLbmv826PnIomtX39Viy?=
 =?us-ascii?Q?Mbt5CPB7zv96nUMbiSYHC7SpFGGeIR8RbLgkmHVQGZHnL7JKsCp98KB1JHE7?=
 =?us-ascii?Q?9En8FucQdzcqb+7Z/omsBOGRhVllytpSknu5VjEA6P21GiiPNoEwikPE/zFS?=
 =?us-ascii?Q?iJmKrGuapv/8LQArsOEi6ZgHWXeHj9J9CS5Jj6xanDL9N7Jx1FTJj3ueeIr7?=
 =?us-ascii?Q?6QTXdyqkiSYOTOs6l5pBdrIQieUW2svPwprzLbksCrN0l9K0/uDUyH0ulvSO?=
 =?us-ascii?Q?+nc3ukEcA/z3oxElK25oAqojGBjY60g5cwM6HlxKal3RkDe/wK+3byiHLhVC?=
 =?us-ascii?Q?KHLQuGa3OiQuoAI1nJD0SFliCYPixBThoMbRE3WhF6DYOYD0kqKHsXFQSRsY?=
 =?us-ascii?Q?Q3GPEYljFjToKQ8eV1UlVLATj1bwkOYEtVbjS2OQXSJfjMm8Q41Iuryd/jfG?=
 =?us-ascii?Q?ZwgzupKiiJktG00w5cguVHFP9jDC1hb9suti6w4tTzgjVv3bZ3NiywFZgogH?=
 =?us-ascii?Q?NoxseTOuN2NEvTplqhGkM0otjXwzvAG88UKUO5/cu1PCTN0bcjNiyuel+9g0?=
 =?us-ascii?Q?2LO/EMJko0ybYwduscywgJbwOj5dVv3N3p+CAnFfnC5yjYcgxIAicN3tggPa?=
 =?us-ascii?Q?WgChOMeR4xj9mfpf/6srh9AUPw8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45db3a41-4e30-40a9-a10b-08daf4c66152
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:56:50.2509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QJzqjkhemcAmTSXyJzHrcXU6nfm1vM++0fsG53U92W6/n0qJq6mnYqDOJGtOVGylrm/sR+u62WSQiXACd1hOVkk5zT+sB4cxtkzthLt2hq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6548
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v7
  * No change

v4 -> v5
  * Add Rob Reviewed

v3 -> v4
  * Add Reviewed tag
  * Remove unnecessary blank line deletion

v2 -> v3
  * Remove #address-cells and #size-cells from v2. The examples were
    incorrect and fixed elsewhere.
  * Remove erroneous unevaluatedProperties: true under Ethernet Port.
  * Add back ref: dsa-port.yaml#.

v1 -> v2
  * Add #address-cells and #size-cells to the switch layer. They aren't
    part of dsa.yaml.
  * Add unevaluatedProperties: true to the ethernet-port layer so it can
    correctly read properties from dsa.yaml.

---
 Documentation/devicetree/bindings/net/dsa/qca8k.yaml | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 6fc9bc985726..389892592aac 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -66,15 +66,11 @@ properties:
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
@@ -116,7 +112,7 @@ required:
   - compatible
   - reg
 
-additionalProperties: true
+unevaluatedProperties: false
 
 examples:
   - |
-- 
2.25.1

