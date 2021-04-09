Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E279935980F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhDIIid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:38:33 -0400
Received: from mail-eopbgr30077.outbound.protection.outlook.com ([40.107.3.77]:50793
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232021AbhDIIia (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 04:38:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAIt6yb0SaEDro9WVE3cm1MXip0/7SZ2GoP74TnUiL9+WnbaRVUD+/fsPtg5xqJV3LRbaaGqaYTo5EiP7gG5rNGuigL+2rdIIEenDdCDOjzVROLbDeFe6M927VxGKVgT69sKHnq4CLwoxI/BtTdesIGnz2+Xg50YhdmebJHYR1PJ6yd7hUlCFHgFskuKZhcEIpND6uRipgjLIF5IM9S1J+gxbLH+i/3nXgpj10jsqMcsLnecgqR+ZsFAnZ0siYAd3yRHIALNXsx319YVDvkkA/XcMbdBLfa2jWj1jkhk9G5KAmCo4yd1w1gr09o+hek9gkuRSABGEs5wey31mcbTuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ci/5m4BuQuvSU5S9ipW21U1f1kWeQmz1Ae3R+0Nlexs=;
 b=HDQIZioovzkzse9YBleGFKnTPU4P9QneOgpsFklwD8cUzvpsTSzxKKGK8D6q7Nnf8Xank6uEbPW3pWXaAleD0vpl+FW8dtLqhEQTgiGoRFaWk6SSB00DYcSs6unV4237kFyvP+NG1NrSke6BgsrJHBmyiRfkKuCTetxaeXH3e92Xn0M619Eot6K5jcGNVfM1kko8a0cIwuKCso+7/TB7n4LNlss8YEZgH2ZOp4+gakfgRSKAYIs1f7KG9ruzLZmzV2+EYm/2fKWOfnZjSuHrJQiAV8+pJN4XruPqDQO8Nqp2g3qV4cJ1wyqYmZXhOUu7OKcs3awhxL7XDTUM4IyaQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ci/5m4BuQuvSU5S9ipW21U1f1kWeQmz1Ae3R+0Nlexs=;
 b=KYp2hp7l8kbD/OR66tow9HxQrn4BV0hg84s541PkZZEFha1YPjVu21X8Ug3TtKTwxjEd11oaztjrqd0YQpbtWVchIcKQI1iyG2YoQyDpFIg6AcqmBYBchylEsrRUXxc6PThipYG/sj7LGSm8mcaxatfagEj/WzeoRb8+tNgKBYE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4521.eurprd04.prod.outlook.com (2603:10a6:5:39::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Fri, 9 Apr
 2021 08:38:16 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9598:ace0:4417:d1d5%6]) with mapi id 15.20.4020.017; Fri, 9 Apr 2021
 08:38:16 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        frowand.list@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/3] dt-bindings: net: add new properties for of_get_mac_address from nvmem
Date:   Fri,  9 Apr 2021 16:37:49 +0800
Message-Id: <20210409083751.27750-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
References: <20210409083751.27750-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR0401CA0014.apcprd04.prod.outlook.com
 (2603:1096:202:2::24) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR0401CA0014.apcprd04.prod.outlook.com (2603:1096:202:2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Fri, 9 Apr 2021 08:38:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10914813-7557-40f0-c4f9-08d8fb32d17f
X-MS-TrafficTypeDiagnostic: DB7PR04MB4521:
X-Microsoft-Antispam-PRVS: <DB7PR04MB45216750AEA528C7A79FB329E6739@DB7PR04MB4521.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /IQi/usn4tVSEtvVjJm9eVW9NRY/4P8K7CePIcUEA/2ROn5Puh2DP2upI0bsim4xgx/6HTBoh3GEZ93TcSFOw0mhFBEJOUdxK3d96pAYuYKIXI4ya0t08qFt9mgm3txcp6LBck6W+l+in7fPMEkKCGfr3T47JtUjZmc34qUUYvFsxuLDw2WGjFgEQB4q+gnUEHEgL0BBPlLgeqlpeifRouYwDFkcKvvJ3cFhnCevvAqfHSI5Qc2zm9jvazJqxp5/vEUe9B63R7nY5iyxyg2lAz7s8gFJQYbCijxG9Ksc73Mth6Go2ls0zUkqdeLxpWBwarkuuKvU1D/hF48HZp3QvGb6aZM26gg/SWncfyTr2KPd5A3DjZ0FGKIfQVm+5w3zWkKCb5TGG2ceFEoK8pO82jMKhPA1WM+H19OOJVB9x3MgxIH5FlstMQjOvUSycalNIOx0K5bZRc6y99OaixEhZhBUVv4D0wExVghh6e0yODvpQs82FMNqqpkoEewr/+EfS/SkADzJQUDaJsbM2ra6JRvBz0kpe1/Xg0WlOemjCfBqnzMxLu8/jD9IinrDhr8oEHgAs/rsL3QC6PffV7HRBFEPaebc7iBCkLTajdo+Jcp21L1BJHEThQZbYaeCohSkFnFzzOdWBBfKDQ3EaaDib9lKZoCuVx0FnXaLBFQKakW9XylieuFthYUHhFsWpV62HM91272fXzKExqkBhuixfkGhUuIcY6PYQFrBV2QfZGQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(8676002)(6486002)(52116002)(316002)(6506007)(6512007)(478600001)(69590400012)(83380400001)(8936002)(2616005)(36756003)(7416002)(2906002)(26005)(186003)(956004)(38350700001)(16526019)(66946007)(6666004)(1076003)(66476007)(66556008)(4326008)(5660300002)(38100700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?oh3aaXVpF+jSsSnaxfz50gpWUfcpBs7LIBa/YHAtzncjpafrsCX0jjYmczYN?=
 =?us-ascii?Q?Tbhc9n9m3uHUEokwTVhQCyjgVCMSGR/wOqtudjcYCdVtr6VnDDzmhLH+XqBf?=
 =?us-ascii?Q?qFQQaFnAbOcc3Idy2WQa8ctZgqUdFc3VbMLDY/PrSK+5uoCxPaB/PauEqifS?=
 =?us-ascii?Q?9mOoyEab9ILG1Y5q67CN6kHDYb42QU07DbZe52e0O159dWHynDRsqUYxkJ4R?=
 =?us-ascii?Q?QRA7VUhV2JL3WIrjp8OBH8QmVk7lK1hbuadIxEgZJyW9qXBLwsIkHqwWZT4T?=
 =?us-ascii?Q?OD+c/DWJVKg6WBKBRr6V1EyhyJgKUmPlleDwd0bxn2xcmQTkiW1iAi3US4mR?=
 =?us-ascii?Q?AQgkgqX8GDhXoOSCdFO1koiE+kZ5R30m9o5PpLwEkO4FClWNBrMQig8b3QoK?=
 =?us-ascii?Q?8Bs8Yk6USLCikHdCm585XxPpSjakdXy3Y+MohlcdLKXrigwCHuBI4Go2nrGW?=
 =?us-ascii?Q?81tOdoZNJJJgVXty4RVXj2r/Chn3j4Kl1rAe0Q/V+oQeiLXmWjKBKW61xL8H?=
 =?us-ascii?Q?UCdbEUt6t5xTNjA4EJMZfHpUOBOYdUoitzGm+ToStpZ7a/K4oN7MJ4Phqeru?=
 =?us-ascii?Q?4Nd8/cjNq/3KWuaxnBOUPzFtxxoE3kkRYzeWajX2YXJoX9rl1Hx3m0h3KXlQ?=
 =?us-ascii?Q?XPQFih2Sr2MHSWER5dr9AjHYIC1nkbesjoKdSZk3yf2gQq6/8uYsU58S4bzS?=
 =?us-ascii?Q?27bpjD3Rpo7vKi/SmWnhqFO0mLJBQnpdEzZnjz7AKrVIAFb31H1Vwh9/ylH7?=
 =?us-ascii?Q?paHSaQt9E1WCvWtUgOh6ceSnk4nWMhbNj4J0HdauaVTJWHxrUWYL0TwWra/6?=
 =?us-ascii?Q?Phamc/gxAt6lrkuOfhwAC+I52E/8nc1EqFXfRu2hJPYtjQlFAXQsIu+F0ill?=
 =?us-ascii?Q?IzzAJq3osnt3ejaP1IC+YSoUtFzeEwBWJfS3BkvgKlvn1l/ZdUdtQBZWmRwL?=
 =?us-ascii?Q?DvSkkYpdMVBuI5AsusyWcGE6eUcvU30Wqu8BWKeOYAXS+Y1HS7ijeWHgtLCZ?=
 =?us-ascii?Q?2IGv3PtO+Whb1OwNbCde58+NPCRkbLFdMpxSSuf1eu2sN4J0HkZYsB65hQUm?=
 =?us-ascii?Q?A0UpoWRs7uz5FrAjTCPIs9Y8G9yu78ZWgB2xkB3Ror6mgPfTkA9+rRJCuPDP?=
 =?us-ascii?Q?5NTQLnKjgRrYTNtaoih5L9NwwAjgAzLccfnmQ6Ei9QVRhTTM2zo6HD1zTxzC?=
 =?us-ascii?Q?77lrgaPA3ITkn31IbtHDMfr1airL1JIKDy4B5PwNXNvPU2JLlGJt6Wedo50T?=
 =?us-ascii?Q?oBuh8m4LwtrQFmMfX0ZDaJJvjxpfVzp9/yM1dikBvfTEF1VU/g5YZcBbkrw0?=
 =?us-ascii?Q?IoiWv8xfn5sPj5sQ2vSityFo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10914813-7557-40f0-c4f9-08d8fb32d17f
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 08:38:15.9681
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ylJPxWitLIr5lKd3vulXOXoE0qrqS20qq5iZn/Syajkb4GnD2n0HjlEJJNKW6aA5R/EgvLeBMH80dffoydk1XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4521
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

