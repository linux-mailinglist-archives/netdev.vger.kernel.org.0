Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6AA3598BA
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbhDIJIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:08:11 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:40854
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232579AbhDIJIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 05:08:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5L0cz5g4FkOvVYgixRuAo7dkUcyN3Z/O7Rg03GCIEKw2fLRmzFK0K/Xx3Xuk+I4FFZhnJCbeKbjLLHQRTEDNYYD0r3Qb0vvCU+rnurtGWQe4GPxzrdwtD0PcXaF8kDJOlKeRDjgSIWWozenNS2drUSHIVRexsjK4Log6X6rIxB58TErOPsAk6KCNjgDlWxrwxDAf7L1pNDAGrKeKMVc0e5tiZZoYxG3R1faAkFDy8DsTzng7RFE0yvpbJ3TwdbDi/oyRdPlycwEESU9KMDomCVy/vcJ16n9HQ5XKxtdxOBfOGUB4bAKfsxK7zdzL0c15oH49cj7ddmGkRWjzcK5bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ci/5m4BuQuvSU5S9ipW21U1f1kWeQmz1Ae3R+0Nlexs=;
 b=lWBvoFVjE6+30qyzzgzr4Dc+4MA86eGbdLCXmLcSOTKW3Yslmkyh4RwzAW8vsl+TfDcU6LTkCPalmAN69QSUrzygVXJ0M2ck9iRzdItqt13nhsxHQzXGvZFeYsa4+Fx0+UEzS1zG8i8zpPHJeav5PS6luvZMqfGZq6XgbDxk4UwHA8TsnSpLAY1bAhF709RdR4APCbK4OFsuwz8wfm6yEZYjR3EUH5qKzWTP8PzwA20Olt3D3Af0AMOwoH5UoGnstkuiCagkhflrKo3GOVS7BTq5t/zI1EM5MdPQCF2KLnCVBylDrZbf+HeEvXqgnf5f1UDLpjcpTyKgr+OAFuRehg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ci/5m4BuQuvSU5S9ipW21U1f1kWeQmz1Ae3R+0Nlexs=;
 b=i+pVIago42M31cSc/lcFlHEi5eabBvRALYG2VkPwgxeHjYpEVHUAtEM+s7uNwtt3KCVzDgUZU6eVYj58K35Sg2GHoNqfc0lNsg48t8sYQ20KJhA7uwIHZyB1WkVSnpuNW0WSnaOmlfLeISoJIrQMSpsfuZJjH2I/1lm7xclBe2s=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7336.eurprd04.prod.outlook.com (2603:10a6:10:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.20; Fri, 9 Apr
 2021 09:07:44 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 09:07:44 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH net-next 1/3] dt-bindings: net: add new properties for of_get_mac_address from nvmem
Date:   Fri,  9 Apr 2021 17:07:09 +0800
Message-Id: <20210409090711.27358-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
References: <20210409090711.27358-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR02CA0184.apcprd02.prod.outlook.com
 (2603:1096:201:21::20) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR02CA0184.apcprd02.prod.outlook.com (2603:1096:201:21::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 09:07:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f5d895f-7e56-4aea-9f28-08d8fb36f006
X-MS-TrafficTypeDiagnostic: DBAPR04MB7336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7336B8B2519AF2BC8F738504E6739@DBAPR04MB7336.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zg+1Y825xvQ1mZP62Z5RC6OTgWq04pdYJzi9ycQLe13ez6gs2g9813ARNhdOdSC2ejr57i6DFpuspv1BmwBQq0wQSTQrYMEWmSoQAPqi2mNGQMZMSiraZawWcsuguDuZEsQzLAdV+8pCK4nXAcN8obfn6NNgjDritmcAuGQ3K4c3GBsp50z6lyxsp9dvsPdTyM5DNsuUVEizC69W1s7BYQH4xI7BZGCBn5mvBnMsfq9kf47qx15m3rjn6cJnE/5TQcUNsm6O4Fg5Mf0zHaUcq44Ms8V33E0p9Tx+3N6jpcQ21rOZe9U1DUJ3A26wNAOOFPkDYBEunsr4eopW105BXAHR259Pek9hiC9oFWPZm6f2qbE56hm0HDo2qccAdcJ90Kwcg73L+PQCu72EQ0Lu6K7WxmsUS4TwuoSTlEmWkPXWgjJleSkvgZOeRwc+Um4NDiY4ZHBsGIPmwcA+kAIlivnOIN9SAulpvpek/084dMGIhf4Rrf35gcXrGyz95bdFA2pTBk1j/r4qRdxXvqod9XdwH/zZTexsDnAMPSICXbkudE+NxbJL39OXGleVUegzx7v0aNs2lH+9302mmoLaSg1Nb8eyL2PUW5qSNeVd0pE6BOz5/0i2lCF8gGmsAI1S10P34fNdG2TvgbIzBu9/5H0jLoAqwN6OLq4D28EXBy53qX+esutCUpBBQtezel2FfEuP8UVuKHsf+o0l1ORFqhkW+4uOkxt41sFXJeISmA4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(316002)(36756003)(6506007)(8936002)(8676002)(6486002)(52116002)(6666004)(6512007)(4326008)(956004)(66476007)(38350700001)(66556008)(5660300002)(69590400012)(2616005)(38100700001)(83380400001)(478600001)(7416002)(16526019)(26005)(186003)(2906002)(1076003)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4JgpV8bUohBdBZbW7ekyTubE2+ZzcSME2XFGMBKY9yMUBKskvU0FDlaLzC4f?=
 =?us-ascii?Q?JpF8ANvHl3S5V7gk8Hx4UtAUjDgW97egzl1noAK4nq5kHxsbYsJVV3WpjkH9?=
 =?us-ascii?Q?WxeY7L4E4d+BgcFqeSk8SfkpzQnzldJs1W8FK2wne4Yfwb9g8sioUtpvM6AI?=
 =?us-ascii?Q?nJPS6uw5wmeatulv3++88DQnPV7sQsEz/39aDauJDKRvFvscPg/8TBMZmllL?=
 =?us-ascii?Q?Ph4eOZcU1zEnHk0oENtAPFNRHQOs2ld62aWvRRBvqCECIKrPzQLl63jpWR6R?=
 =?us-ascii?Q?u9+wQFqe0crfRJjcMpMXBhJeRYKYv3ANUvfXV6ev6FnQu5Hj3nNTlwz+R/Xf?=
 =?us-ascii?Q?n04g+smLpiyHShTSvLtiuGzEI17OUEeEEv131aVAy5vE4/rXqWU6VOuqPuYQ?=
 =?us-ascii?Q?f7GXqzhpEWWolyaIigk4fNhTSZgM2GNh1eyjjpQCNQg8YjFNaNfMSehDBK2n?=
 =?us-ascii?Q?w6UzVIIzT6Sroi1aV556TAh8LYOM6thwgqKAX2qHfeDthgnxcPxfOg0V3Ptm?=
 =?us-ascii?Q?qV1AseThEXH3TO2Y8tS8/BXxkTsFmDLJHzzpq/dyyPR0sLECZzV3Jrdp5Cam?=
 =?us-ascii?Q?DV9J+qcCWuF+2Lm8Kr6bw0U4wTxXfteUto39iOF3ZNZSGppj7cxFS9jk0wuZ?=
 =?us-ascii?Q?J4bqEgcDoir3zfIg6qkOBoVZk4uu8koOc32XNr1cT/DL5eS14lUczv0y1+Cj?=
 =?us-ascii?Q?7w93gGL0zB8xjwRkzDPl3kfeA1aSo5Uwmf09/aiBdkl4S9l+qkuBy5P0ng2k?=
 =?us-ascii?Q?PPemreeuRb44C9vdmD1HCQ6HNSl8/AqFKmi5jnCgr135e18xChCKrl3u1/19?=
 =?us-ascii?Q?z9nKqilKyKoSwMzvj6VqTf0VYG74ZhE/e3MFmj/nV4dgwSPTQ/iarDqEsIf1?=
 =?us-ascii?Q?A7De14Lw+vo6O//7Tyu1tIxDWiseh6JZYBFUA02nx5AHcUpNzCLZG90QvGz3?=
 =?us-ascii?Q?l/leBABki8KROkHZaZRiOY7m8tNv4S3ovcuP7rNqbcQaoPQdrKqNSJh4tlU5?=
 =?us-ascii?Q?iFXYNDd+inAcAn7J/T30sKT6qB295i4GrR6M5lcVve0gi4hpsO8hBQsQlYIw?=
 =?us-ascii?Q?5gCKjZnVlln/4DnEaChwz8gtdquQQN9eaW208gqJSH6ymwOL1FckAolgVIud?=
 =?us-ascii?Q?XIpJCD0birFbWtFIeCJcqRT2SKj7jK+4y//a4cN1KDDGZfTBO58dkc1kXfvV?=
 =?us-ascii?Q?d6azHJGwQD+PsFP4e/2dbZH+7H+BBeLRgUBGfh+Ch59WJDy/v9AVITD4ND8J?=
 =?us-ascii?Q?EKPtBJk2LXZivbNS0YbUsUhCVZ1sZR8wpbMv7WC2Bm4mIzwMSNmXev2fa2QW?=
 =?us-ascii?Q?M7rnIPu2/b1DdAFcda5jYc48?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f5d895f-7e56-4aea-9f28-08d8fb36f006
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 09:07:44.8279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jnqUlreMLah/O7k1CL1QaKkW/nDOyKvlFyR+A0eDg+eNJW2QY6j3RZq57T7E82caRR0UlagXpn5ZLRBkaVh+vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7336
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

Currently, of_get_mac_address supports NVMEM, some platforms
MAC address that read from NVMEM efuse requires to swap bytes
order, so add new property "nvmem_macaddr_swap" to specify the
behavior. If the MAC address is valid from NVMEM, add new property
"nvmem-mac-address" in ethernet node.

Update these two properties in the binding documentation.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index e8f04687a3e0..c868c295aabf 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -32,6 +32,15 @@ properties:
       - minItems: 6
         maxItems: 6
 
+  nvmem-mac-address:
+    allOf:
+      - $ref: /schemas/types.yaml#definitions/uint8-array
+      - minItems: 6
+        maxItems: 6
+    description:
+      Specifies the MAC address that was read from nvmem-cells and dynamically
+      add the property in device node;
+
   max-frame-size:
     $ref: /schemas/types.yaml#/definitions/uint32
     description:
@@ -52,6 +61,11 @@ properties:
   nvmem-cell-names:
     const: mac-address
 
+  nvmem_macaddr_swap:
+    $ref: /schemas/types.yaml#/definitions/flag
+    description:
+      swap bytes order for the 6 bytes of MAC address
+
   phy-connection-type:
     description:
       Specifies interface type between the Ethernet device and a physical
-- 
2.17.1

