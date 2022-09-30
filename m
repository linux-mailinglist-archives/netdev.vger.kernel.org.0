Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C24A5F133F
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbiI3UKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232420AbiI3UKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:10:01 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2041.outbound.protection.outlook.com [40.107.104.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D5650072;
        Fri, 30 Sep 2022 13:09:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nc4xSeht9ZvV7rPyMC42rVC66s8xO5o7dwYTLtna+M22JvF6TqKXGxvFl95cy5iFCavDc7Tej68UM90PkVVtDS8AW4VaoRIJIbMX8+LuX8tmzkT0aWvoCr0MlMhygS+N9Yr72R/pmT8PyKVDykwRnmzdYgKLfedoqNyXeKMaelrRC4xDW9yUPeECOrSCLc+Ef2CrfANLOPWT6EVrlg7AjyBNty5xsPGJZMFiFO78f6+RaA6ySFeRnQkTl+sMDLQfpcr87DsyP09nLibuvSyxupRWO28ngHzWm9Xn+xif2L4n/w0CFIVJ0iWVf+eEZPjWn9UsQH3FAYS1vfW9mMF3/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OiB6zoWB32H0EkrMl3eZ7akSCrZvMfmnm7jIt71Dpkw=;
 b=WpxKjy4i59wpoveX68iudh0avq02sKoQywoYxpA3WKeFGq6LFSYxQVCrFhVCdhDJ3P1RW494rnANCWaLwx7rGvVMTCkSaYDPYK4bu8aiDtDSKvRABRcoJIYRu2ixNIeJ2UJLf4nJXj8Wk6bC4AFCeTZ8uDDNyuuXf2AiwxxcDGdD8wEU+CQDUrG6bkgFRv+uvWbDix08DmtsgabR85CSwK8XcOOcN2HNQMmyUzmPqcawbEx2z+rP9WYRn1y3k5DV+u00qqtiVMyXXQwPz9Y2QRyQz3B+nmif69OekewnXq5qKKk9DetCgqDn9Rf86j5JW0RiaYDmangy0HoJA5r05w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OiB6zoWB32H0EkrMl3eZ7akSCrZvMfmnm7jIt71Dpkw=;
 b=vVKB6CCn8N3m3sD3wILzKH3mwXzPEmrXhr4YFNVgh+2HBAtsG7z9EHfcLFCCZ9wRRNe20ViO0yTgVM5g/Qe7M7hEs/VJGhN6WqvFMFmEQV1DekeiBlM/G5poYI/zcYEV2nPXrHgxPFFgvA/K1j95GAF7zTHmB8CpggHLXzRC9tKOwXL6GEoNyVBFhLbroWOxm2LurahQ0kP2odyWxrRBycG+4BtrvHBdFdCzHErHJ2PVJr1dS4gPSpF7w4xAHx7GisZ0FAvnL3cZ9bxzwLFI74vo/mxFoJdWGt3DjU9DSF3kjwD+v3U2QLtN1QrbYWb/pkroTm7bPieRZ3yvytZS8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7749.eurprd03.prod.outlook.com (2603:10a6:20b:404::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:09:50 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:09:50 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v6 2/9] dt-bindings: net: Add Lynx PCS binding
Date:   Fri, 30 Sep 2022 16:09:26 -0400
Message-Id: <20220930200933.4111249-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220930200933.4111249-1-sean.anderson@seco.com>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e19aa6a-43a4-451f-a262-08daa31fbb3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yR+OwH4hon5QGdc/jDqD9QdWnwefM6pqLT1XXclk8Oh4LjOUYbDxQEQcvXk/zs9Q8836eiem7S0m8lpj1VkvK/C0f1CJQbUpW/se6iqHt117M8tXln0NY/5JWNtmWGZkCzansYIUt4JSui5GTAjewasm3tJ99ushpHFIjLc3ctSX7UTwubDTK0ebBCEKV1fLjylC203P3vD5vlqgiQtTegzcXo/F0rDAiGvm2LMVjkEVv5pQuYDCECBiiovjvqx7mf1Qpqt9owjarMvg6OfPeeqIDHve4cx5CZRXztWa0lrktXP+RLk8+jXwtobjydTI3WDIQTL/6Wfb41uQK6N5sgp1EZ/SCbFlrrD2Ux4EIQP51ev6VSkxTsolo12tCd5v5NkFnI0RMNMXWHZS7DpKY7IkSRdG5/uCerL6wWxVIr2LRqSxPy4aiGOGviXKZdHXV+9eOeiZssSToUNn/CK2mbKkhGDh6gE7ir7R70/Q9oTcQcks+GXO6/9unqlUhKB2ItTsiR8YIuzgDAzWlgvA7cw8Zok7UFLjQpfZ9yNRTGO2jj786F21mVt2VwsG5e6JviosVzj3fkuEWh0dnAkBaUztvlgk/kfgPCQ/eceQopzH9stFcpo8c3DplQ4nTOgCaCjrf6WHvgBSNVAxGvmTtUmPa6GdBA/MiOjLvuMWibKBkjzYYornh6IlDoH+q8OETDyk5sDUgkdnBZkr5/eIA2Rxe+GN8ltuLnAwXxo1FSSUEHkRgDzhx90XI7io45VdBpzyPmlGzQbUhH7aT/drYbW33J0p5ThsNB3oyG8zubA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(346002)(39850400004)(451199015)(66946007)(2906002)(6666004)(38350700002)(38100700002)(8676002)(66476007)(66556008)(4326008)(83380400001)(41300700001)(36756003)(6486002)(966005)(6512007)(478600001)(6506007)(52116002)(26005)(110136005)(316002)(54906003)(186003)(1076003)(2616005)(86362001)(8936002)(7416002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fg2wfRPin7PdB0ClXp00i029kacm1A7eXzPsWlDCZPZFv76Q7tpdlb6oiIFy?=
 =?us-ascii?Q?Y5MPf5C5paapSn0U+Tejw/gfnB1KetlswRJ2NL/c4+SLPXkxwVcOwgckEldY?=
 =?us-ascii?Q?QwLO0kYob1yLaYKsx83ztiQN2uUixGdv7ud5OuuCzIPy/0GseKWf6EVt5shc?=
 =?us-ascii?Q?j2RBOOiuAQFFqa34gNi2/ok7HW0OPjMbV4NBfBAoYAKzfmenFS1VUw2gicBA?=
 =?us-ascii?Q?qmBer9f7b5N9Wm39oVnwMapmt3wz1PauyZTXP8il+ckYnkdErZnrKQbSwQ0z?=
 =?us-ascii?Q?whMkyC6nDULmXXOqCS0bvYxkW/bbBeU/HBK2lKjDFnxQ5SLYbXUVTpt05Z+r?=
 =?us-ascii?Q?TNU1I9Z4BfoE8BIosqBAIcORvBIC+Gm/i8yn9fpkyq6mVVmK8BJObjeSEcpa?=
 =?us-ascii?Q?GfpShAvlLfDLnb3it0l0+dIatdhlCW5/cZF+mn9MZ9Tx97KHgPVMgQhcOi4l?=
 =?us-ascii?Q?tzj8IvYsR7YEdSqoXFnorzcHQGaaZkX8F6PIUCAWCLJcl+GI2hX+3fnbv+nm?=
 =?us-ascii?Q?LI5Jzi410GzCPiaFyaB4xsJPyXznxai7JZYc/mtSjORWxQWDV1FEO1JQsG6n?=
 =?us-ascii?Q?C1u9qkncvIsuCqEgM7cUyrOE6IVp3HfU+N1dRcKCIue7dBed36YN92YgRLV4?=
 =?us-ascii?Q?ivXqP8gr1Q5QZrfgqFaRTINuFnmhHiNgMij28AH4iTwy1H6UdeEk122A/ybq?=
 =?us-ascii?Q?LGpkmDuvtSI1gjSwat33t7PGpaIWF/0AwhmhBy9ZYv0wMv1BREYzLkTTaTne?=
 =?us-ascii?Q?QrJGvH5uin9aevi/Q1xKTPhL64ljncjTZhlSkPoYVLBaXldGM1ZVOF9uNyHd?=
 =?us-ascii?Q?SvvTmqxp375zhhQR4jxlpzk7dohS/KYoUPXwuG6PwPtVSY6Ip8nA1fmvhwOW?=
 =?us-ascii?Q?cK7E0rEbPfpjgXfJqi11cRzsfuUfDPxEAbN9WSapzAtk4a7ePRcek3x0giyc?=
 =?us-ascii?Q?s2ootMfc78FR880nZnrMA2JLe21F+RxlpjXziZ1agiouJJrVt+Yguwyfu9Cp?=
 =?us-ascii?Q?DvrhSqdv1QOORCvPbw/Qw4f2BwNMrIhHu7iV0CkVoDRmQN2GkjvoVvKvt97R?=
 =?us-ascii?Q?F5XXdby+4RCi+V93d2XKy/FOxVst0debAZtcmln+Kq9U8NDw/uTF2C/NzFuO?=
 =?us-ascii?Q?lqnwUIek83Yyl/rGl2AXn1YxW7WKQRpcv3sb7OrltqGtJ0hBuIG4FicjfoDE?=
 =?us-ascii?Q?Dd69nZJ4EzO73+5k2vbYhxiQB4AwS3IlYwlNyOapZieTKC6qypxP/n5ra2rm?=
 =?us-ascii?Q?icecmZMw4aJV+almQI5cu9ZSeyZYvO/ZJgEnijJz2FlnUd26y209uDTeKU8I?=
 =?us-ascii?Q?NQkOPXN1pr50JS02O45JnTeE2szHNstqNAAh05NczScrzGEzmMhgVnVbQ5jf?=
 =?us-ascii?Q?UzIWwxHFOUUd9XlKey00jJ/sRdKb7sQNOiB+cHuOi5FVnZ3hzT3EDj6oGe5a?=
 =?us-ascii?Q?0SRtewZ2u214ae/eek3jXsbu8G1FwEcRZtrsJUZ3B6ox2IXyXq1OGqjJjOQN?=
 =?us-ascii?Q?YWHxWZTIPB1FZtzc4KbUdHbKlNwGKd/sDGKsLC0FT118K1NxZnAegZ/SNGfc?=
 =?us-ascii?Q?6IEoHF0S1pIU5idNHDDJUE9Tg+XCduCl7vnxD6rmwK+joXJNvznOqoAO1xAF?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e19aa6a-43a4-451f-a262-08daa31fbb3c
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 20:09:50.7754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NSoq5n7QskfH86xMUFXe1NQmxmJ2PiRwpXRoKOpdLxiKmXjM5U6W9GWDiwbY3a1/1V/WOsaUyu80LuJPFuSVkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7749
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This binding is fairly bare-bones for now, since the Lynx driver doesn't
parse any properties (or match based on the compatible). We just need it
in order to prevent the PCS nodes from having phy devices attached to
them. This is not really a problem, but it is a bit inefficient.

This binding is really for three separate PCSs (SGMII, QSGMII, and XFI).
However, the driver treats all of them the same. This works because the
SGMII and XFI devices typically use the same address, and the SerDes
driver (or RCW) muxes between them. The QSGMII PCSs have the same
register layout as the SGMII PCSs. To do things properly, we'd probably
do something like

	ethernet-pcs@0 {
		#pcs-cells = <1>;
		compatible = "fsl,lynx-pcs";
		reg = <0>, <1>, <2>, <3>;
	};

but that would add complexity, and we can describe the hardware just
fine using separate PCSs for now.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

(no changes since v5)

Changes in v5:
- New

 .../bindings/net/pcs/fsl,lynx-pcs.yaml        | 40 +++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml

diff --git a/Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml b/Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
new file mode 100644
index 000000000000..fbedf696c555
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/pcs/fsl,lynx-pcs.yaml
@@ -0,0 +1,40 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/pcs/fsl,lynx-pcs.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Lynx PCS
+
+maintainers:
+  - Ioana Ciornei <ioana.ciornei@nxp.com>
+
+description: |
+  NXP Lynx 10G and 28G SerDes have Ethernet PCS devices which can be used as
+  protocol controllers. They are accessible over the Ethernet interface's MDIO
+  bus.
+
+properties:
+  compatible:
+    const: fsl,lynx-pcs
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    mdio-bus {
+      #address-cells = <1>;
+      #size-cells = <0>;
+
+      qsgmii_pcs1: ethernet-pcs@1 {
+        compatible = "fsl,lynx-pcs";
+        reg = <1>;
+      };
+    };
-- 
2.35.1.1320.gc452695387.dirty

