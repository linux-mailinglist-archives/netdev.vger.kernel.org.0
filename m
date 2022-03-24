Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF04E4E5DA3
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 04:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbiCXDmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 23:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348035AbiCXDmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 23:42:01 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70081.outbound.protection.outlook.com [40.107.7.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFB395A13;
        Wed, 23 Mar 2022 20:40:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QvzVe2r39LG4vFYimSAhppO56oMY7vWTqYAMdN7OWFF61Pq3o2zgKKYHHsFlybvJDMnGpGmbYGvpiPwf4upAFQi0bePtO0ZT0F9uGxkM/Ps/Ug9DHMH3wyV+x4Zb8ydFWc6IPhyNU8UWQCzG1mV+Y6Jfx+JsznhiYEaFlsMfJNtaW1gYAYiWDJWiUePcZ+qenOonO5WBumYGX4ucPW/2fbMnbeXvJ/2n4O5i5V2rwTisc9QqKMzGehWVYL1OIuItkkO6+bARfE+K3lOcyc/FWEnoX6dXV53JFV67LnYfDDv0GpGRPqPPlrZc1gV8Of1O6Rm5J32t/gFT8wkG0yGpYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Dis6wymXW/oq3hyyLVfO7XYxVC8Szus837WME6Mx18=;
 b=bdiIfsKkGnA/+SfZUPDe/BgA4ygeJY2F16QdOkkVTHpLPmp/fLbfRlgGvEgdSIp2ZDmZoeOF6V9aI/yU3Ci4F/pQ+TClGm2I0hGylB3OZk49f0Y0gzwp6aVjvUvRKLvgAMV6ErZbJxcdUuYIJ3KQ0NCkk9k4wKXMuAphWczJqrnl9Fgp9Lrc/Ug2/Dxp6RgYpm7SqPD0YtsS27gq3bOT9GZV07VUrmWfYB1sioffo+FHuquOSaSylvTvpcAMlUxzgKsACr8tNj8qfCfss1BCrEELNIj8gJFLnmJBkV5yA7gXvPW7ZHCqf6Hmiczng8ipML7MGgC8euWLvrIw+kg0Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Dis6wymXW/oq3hyyLVfO7XYxVC8Szus837WME6Mx18=;
 b=NNKy6SvfqZ3xki3XGOyWJ4bzOVzHO1wqR6dsTsldB688bOEHi/bGSBdcY/6ga8VquZM7F/0l6DtUujgcSaoing1WGdP7oYkVmRb3J67i+4cc5b5CL4ydL681ugswWHWNVLVHEHcn7oN0Al6qhvFXg34wcopPccXyctf4sILeY6I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DBAPR04MB7223.eurprd04.prod.outlook.com (2603:10a6:10:1a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 03:40:26 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff%3]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 03:40:26 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     ulf.hansson@linaro.org, robh+dt@kernel.org, krzk+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, qiangqing.zhang@nxp.com
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 2/4] dt-bindings: net: fsl,fec: introduce nvmem property
Date:   Thu, 24 Mar 2022 12:20:22 +0800
Message-Id: <20220324042024.26813-3-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220324042024.26813-1-peng.fan@oss.nxp.com>
References: <20220324042024.26813-1-peng.fan@oss.nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0172.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::28) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2dbf4d5-c06e-4367-6ccd-08da0d48087f
X-MS-TrafficTypeDiagnostic: DBAPR04MB7223:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7223760BD7B105C773B7B95DC9199@DBAPR04MB7223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbBTv31Pn+wFprX/h80lko7cdB0AfSUbONBkWXAsvcqsHXPCDs9jZ2GwaWr29HNITZjGUWMCFy4Suy2K59eCoUZnLPWcrkflYs/o6HrqpM77RgvL4yT4CMFmwhbDFppxeoEdnawzEs4J2OCZBpfep88NLz/F/XoKFALCNBUCpGnkrWN6qnRPlCcCd/q9KqYfTibVVNgZTS/Rv93fkAsqmpe3uhg8swkT+q+StGXfEcGciSi/4KmxyWa7QZ1txQEkh6PnPpclw52t6Tw2MqfpxRL8uuN4D+hZGaZl3xT17dYY/wbHoODMl2ineRoMR1TcYVPZicvsTTS6vcPvnb5SLjjMN0XeZSCXJEVgmhSoTt793XTx09NMa+7LOvMeyGRGPy0DYk1CgD4ymH646tArB4RtXQf6ajYMaeXQgSivG55iFkAfSBRYg65gV2/dRTlbW+6q9eYbEfOo7eUV59GIJtCgU4vMPw15PzbBNs5BSDzlutpgNk5LQTrEnGXx+h3MtrAUi5p5lN5MkfclKwRmMv1t1TPdl0rHxOu5ecfx28S5W0AGDTLzJU/tEqYwG54XZUEXaZ1y0Ok+C5n+9YZWkDUMCkUtv7Q3wgfZZXwqW1dk7cpQMhE8Ua0NWvMKpU72BnbCrPG6wwhwEcWPfNSF0Mv0GO9nLpBMp1hApg37L9gHdMvrSnS4MNOlhlpW1ArA9yBX4LCjK9YW3DGktHPZZuaW1LNir7cRqBUfF/7T2es=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(1076003)(52116002)(6506007)(6512007)(26005)(2616005)(186003)(316002)(8676002)(4326008)(66946007)(6666004)(66556008)(66476007)(921005)(38350700002)(8936002)(2906002)(4744005)(7416002)(5660300002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qEsjXFZQYFc7qqPyD49U5+cfZurZZ0I+PG13XZ2ycQwqCrQ2zlvwFUczMMrX?=
 =?us-ascii?Q?4AqF16q7SzsKm7VYksTERrFZT8VQWFLQXqj4xXz04BgpUcNH/GLzqtwGyV5K?=
 =?us-ascii?Q?ZTglDOrj9uHvpe4Nhop6Bzx+Qy0abyX/3W3l7Vsnn2SRQzzQMWRJID5ffVaC?=
 =?us-ascii?Q?jxRoaJ88bPDMebumMxUsZFit7zLanfNhDxE/hq+hH5LmpX3YeNHXCNf5nVDG?=
 =?us-ascii?Q?QUvBw2NaZifQKTcnm6L0mr7f+Y7nS+GdD5IoAXflFy25+d6F89q/w8xjGT5T?=
 =?us-ascii?Q?dzDAnjBsHEexvPoCHlBNlc3xCTdEEgM0efN6YD+W4vxRV3sth07SEMaSPaIs?=
 =?us-ascii?Q?LibX1u/5IK/7JB4bBvY/j97y1+5pP34UB4zqOVvWGJptAeoikITrZ0xJyLnN?=
 =?us-ascii?Q?Qsob+lLRv1yzy29EmQI5HAI3obMHVmGXtmS7JI7Ng6b9v1+AFQUDN+TmNpQP?=
 =?us-ascii?Q?Ycok1EQyC0r4HFKYOMxiroM1cXZs9kxQaItlbx8q4dNPXmAmg6B/QFHk/Nx8?=
 =?us-ascii?Q?Dw1rRAWWnCcbDGuuE//tOy8aQACPQQ66XGDDXhp13+fXltWONikDo3HmQTk3?=
 =?us-ascii?Q?S9E2GKu1lLf/W6UzMpa1Zgz+/AcHYfT14Qo4OIYX83sBTHkNnXM0yU7j18ER?=
 =?us-ascii?Q?MbLkNjXJOdJPGsJRgPWdoQxRsKVlFgtREYWhTFwD/WnefFCtpPxpr/Bvhwb6?=
 =?us-ascii?Q?x52JvgArkOPdvK+jVWZc/VECKILOA2x14k4Z49k1ALDjaEezFSp2PnOxxkDT?=
 =?us-ascii?Q?nvWtRGtaxM6gxWZu/BWDiQ3UDzTpZxjyiAUmNMwvKeCMriNKm4a59yQ+H4Pe?=
 =?us-ascii?Q?d1WcxFOW8EzAm/q1aLuDVeNndp9k2/q8qX7Q4L8l0oqghc19nU7j5eCxRA7F?=
 =?us-ascii?Q?54/lJu1EjM0233tXsly+kG7VCTVeQAj6TvdpZM1TpWNQKXCsdr39wWaDDcwG?=
 =?us-ascii?Q?vIzLnEIwAE2McggCKXzhsbzb20t6Lts9wOrURDl2v5ihz5rLLha+qWBDDkZJ?=
 =?us-ascii?Q?gm6raTEMfqN+/vUhsW540BmuLyuDkFR4P2ELLDbszh8/qZoa7x2RO9fE9ypU?=
 =?us-ascii?Q?klSZA+BWQ1iJ8Vtpo6EuOG4JsdSctoWSEJ4tCjgE7NmelQ4kPrXW1LWcaYAF?=
 =?us-ascii?Q?6FxgGpXNyWNW80+TVrwUODgEbvOEYBHhXssZ9oV0bofC4uUyBBct/hrqrgM8?=
 =?us-ascii?Q?cbDEptvf51rPtWjvDgXe/cpuMeMfUC4Nyu+kqoydRHuRbr6Z+N68so4X64d+?=
 =?us-ascii?Q?x+VrhpZRPEcI1epH+osjEqufxgfBIntk8+HBCdWvDnGSY/2C5BtU9zYB++HH?=
 =?us-ascii?Q?IcIvxvP8+Hd6l02v4OhRmQoaqPuJRs6UDhccEeiH6F4mHy+x9CpjOWzQF6Fr?=
 =?us-ascii?Q?Tp2dyh97dBZGAvkZWym5Pb+WnByx2pUmceHPeVn/JIY+W9gHjdF4vPCYhxV0?=
 =?us-ascii?Q?tGPL5yJ8bgOEQTpQkgVqsMn1JUwfojvfLn49RGxSQsGT20DTBKkk81oxIwzq?=
 =?us-ascii?Q?NNbdZPgmDbZrL7PjlTJSEXw0kRvz8h4Vl0+09ISwuwp7ZS7ANtvwzg0Dn8M7?=
 =?us-ascii?Q?N/XcQl0fQgoMx6r0Gj90FFPRqAW+p3eS9FzoRB6B2EHTQ8zcnBJMb8J18WTP?=
 =?us-ascii?Q?g5ndxU2bK5ExRVvrSL9V4dYKNt8+Ek2aMxI4OKACYcKpNF+ywK+ZmtmheAiJ?=
 =?us-ascii?Q?SytCP0IvEca0JI9bnvQTYta6wGOMKzr02Z7vealYt8v91Tuh1S9u0jx1e1me?=
 =?us-ascii?Q?QMm8Fj0R+w=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2dbf4d5-c06e-4367-6ccd-08da0d48087f
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 03:40:26.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2qnL5iGOmnNSSN5SC6kPLiIwMze82DzWQ1kP0pP/4RlwknEsBG8p0LE1zLCJNHvYvaN753lCbW9dsTpGNVfmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7223
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

To i.MX8M Family variants, fec maybe fused out. Bootloader could use
this property to read out the fuse value and mark the node status
at runtime.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index daa2f79a294f..5d18f59ca0c3 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -111,6 +111,15 @@ properties:
         - enet_out
         - enet_2x_txclk
 
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Nvmem data cell that indicate whether this IP is fused or not.
+
+  nvmem-cell-names:
+    items:
+      - const: fused
+
   phy-mode: true
 
   phy-handle: true
-- 
2.35.1

