Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E413054FE6D
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 22:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350056AbiFQUdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347978AbiFQUdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:33:40 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2075.outbound.protection.outlook.com [40.107.22.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A3F580DA;
        Fri, 17 Jun 2022 13:33:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aE6EUyUoIiz4ef7e47Wk6uKMQEDxLp+PwnyG8y7925grTx3MkAskygB9YloLxcIwk/6/OJ50KbPpT/aU6M1wQjXsIck6H3KGeAt/JtSDabUXx6MFCd3Vm+TEFARE2Z5Luin2EDl9ptu2YSvr0SPVgtchK/WgSI/y4XvC46eCBrQt3iAhF/SYAScS+AKKdy/X3sZyJOURYfq/AXP5/pEI+oPTlGultIV1bGXrdMjXxTK12VrNj+/QRwQiAdAxnXNtfE5wWnYbVgJm8E9j2YKrI0TsqqOAyFD0ggayIJmjlxD+9S1TPwYPl2eh10jmSzwanXAPoYa1WQHGSOZleJFyVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I9glw3505ujB7LUV7Xvsdgo9XaznzsVSm8YHPcXI1rA=;
 b=GJv/CMXYatwSob/4hGH+q5wZgKsRMt+Q4e4Nkt2WFHzzREkFOnUsv2rKbDYz3ZxbuzmOlqj1tF88WRhSD9nQf/x3+UHv3XV+MMlRDpPWnauajbTOcZJR9dkY77XOasrMFg1a3mLWY8ZkxFhl/WqCRPuXMXtRFng8XebqWn/osK1EkfMddRl418WkD6iLv6EkW/uAXBS/TECr81YPvuhFBoeE4q+BwHX36rz9CPgeAbKgk/JJZRsU4qlYMKTtk9cWc/MMIlTgvn5SW+VYk3gf/aA0++IhTCHjkkZ+LAjnfyRoJANacbG4x84gDGGRkA581dP6Wa6YDoMPKEFGfYSFfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9glw3505ujB7LUV7Xvsdgo9XaznzsVSm8YHPcXI1rA=;
 b=ohAfKwWTYxKU0rxVrkV5eAA3g09sw+LFpY4MSwW7/8RaLDsVbnLwjkT/nt+fjE8ZNvcXZ99H1UXPk5xgNwcPm7FFtHtLCpf7XyxRdZ4g2KYreOBsXA739Ku6bflsc4BOMbx+gVCC0+teazhdTKql9eA1MfcKnN0PTl2f2waJzDFDohyozCpIAumJxmUjehvQbw8HAO89MTxxglHPEW2TGIJOQjRvCPwXKBboqgVb9z3jdkb7739xaQNNr6LPixYDX4CdDfUJl+z4vxzN0jtCGXm/NTayuZCMRFZN4tFNTYKS6yd8nzGfldSzOsM/cJ4l1aCOPsE3tr8CZ+j7KGBEog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:36 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:36 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: [PATCH net-next 01/28] dt-bindings: phy: Add QorIQ SerDes binding
Date:   Fri, 17 Jun 2022 16:32:45 -0400
Message-Id: <20220617203312.3799646-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d3710a1-781e-4353-a8c8-08da50a0a761
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB6438E7E8B2D0012CE6A2DDD196AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vIbNy8/kBJTo9a7giHXX0tvji/1Ysgr3qmHIBtohuAwASzKtXzf+0NZGagaJjC+YGn706FcEAN7rAo3nFtI49OZhzI+hsymNcAXpyPyadJ5AoC3ACTI1rGAy7ugsb+1Sw6Yj5GFOY9QV5YZNT1pwC/eF+2d9C/cVM713ZeH6IeHO99smWiIZ5mm1OXxsfMW/rHbF8h4oHCwsHof5JBV2bcw4yhElMmV64of9JZg9Gs3x7zRQ8BLSXL1gitN25YhDtHXsXgPlYcLdwXNMoc5mMeazXeyGW35YTxbOnRQgQ6sVziSexRy3hKtjntHM/A8AtgXe2hzu/WRrOn/DvPhu6nubxRtyrGG06yVXWyHPubZHhL+djbLiGTggBiZMFm/yDg95ayuMVDNBSn0aQ1PtcT7V5kB0GT8xahUDFyNsve8T5cZyPxYkboAAXn4sTP3wrR6qTRhAbOUreaer9Kmhug3uppHiLkLz9FCIlCoO4MJPXN0nxvA2A4MfACiW5aVjujjZGCRP3y//QcDauiZm2ZmQcdHQVYgri3ZSWH33bZeXjbsI2LgjsfoYFHvZhtpt6j76P7ZASqxLPgj7K8yTKSrqpu52HJeavEHJ2dHv4a8HasLyHv7xQ327DqYTWDKZeh8mP7uFDXMXpN1QcydISGWHbxJDQGJAMtWARLaXi0eWaGZUPaZToOC8RXk/4oI9ejkaUH79GmJfJhE0+sl9UXrk5YaBeC4Qh93nFCiTRsFyOyvhMhfQTAS9ZkZ71+anM8u+8bDBPzYtn9YpGmOnGVRPwM0FFCRYKw1gK58o4os=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(38350700002)(86362001)(7416002)(38100700002)(186003)(2616005)(5660300002)(6512007)(966005)(6486002)(52116002)(2906002)(6506007)(110136005)(8936002)(54906003)(498600001)(316002)(1076003)(66946007)(6666004)(36756003)(8676002)(26005)(83380400001)(4326008)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J57FmXDSS69Z5aLJd+TlMO6Rur22TeZdB2qXYnyIpt8kQLuu6PZMxXx6YJ4O?=
 =?us-ascii?Q?Kg2SvGHrt5NkTudWS2mYTACt8YOlUdVD5MdfbRoZmFDKHykxwHIpX5Fs+Xve?=
 =?us-ascii?Q?gKWywvo5lDrC6Z83ykpPQWU5b60yynmpBwCNw4jHBdzOC5sVH+JCxx/smSNd?=
 =?us-ascii?Q?Svtwc5SD/kDfBfPQhO5iIwp8l3O1AfPgSxBBm8YeUg21vGWbzE2Tw4dAIsSB?=
 =?us-ascii?Q?1pYsWqiVSpZ0mENVX7mNJ+065q147z67oUe2EgU9mZaPrealy62kf2J1L73y?=
 =?us-ascii?Q?pOLClfLu9LbHisiX0eCkHcN2UPvH6Rdgy7cQBhREda2ceKYmBJBiIXJH3ikr?=
 =?us-ascii?Q?MWcw9+esq4I5kEBfquaGn6vb3lKE3CuXfPdb0+bZ0UkPL6wu6wtemIw3uqmK?=
 =?us-ascii?Q?l3Ztd21bkVy62gm53HQ/InrJQsv3pZb0tpJl61yrqWYd2Ra37+u52dVlD06A?=
 =?us-ascii?Q?CoKBlEDBRhWUyd//Lte5dNRggE3QFlta4UP4z4N1dXtSu5mrL/3Svot2Wzg4?=
 =?us-ascii?Q?YN2h4u454QGyi4bLojh6rVoE0GVhPCDs5syMZ9WeD3ZQ++8m4d+DWCH7NlWy?=
 =?us-ascii?Q?ki7n9CJ0LJEd56hAIrN+i2H5UjbNRKW32Os1dvDUxzBpmuiqHG+OWhvJdtl2?=
 =?us-ascii?Q?nRYoMHHob5W1u9eLXia3XgXkuKV8LS2e9GBz5FVc6S0cAiFTqN5IfFCbdVVP?=
 =?us-ascii?Q?Up0euKp2cbxre+QOvycPefY+M3JbCJ8feRd/eq3HtSY9yD/MEtsFac5aVnaR?=
 =?us-ascii?Q?djf4udKdH3QzW6k6ItL8Y1l4qz9ntrvzrHPcaJ10G66kYQA3avQkRex7+J09?=
 =?us-ascii?Q?tDQYcrAXR6ok1RrvZ18cERR1N0Go1pYVpFhVZLUejZogl8NLUNtxPpOsaXC8?=
 =?us-ascii?Q?xmUcfNVM15vbXzu6Z5Ap2qK/OQsoOlxhV7+XZyzDNSddS6c6PteUWtwqMavf?=
 =?us-ascii?Q?+RUq0PQIGxPpMmho5GKPSmo5ehdkYbsEfiDdi0udu6NPGMbnhyFDygHnvpRJ?=
 =?us-ascii?Q?QjNKewR5Rf8eXMCbFyPTHlvpOFFKBw0OXSt7ecMw9ncu1aKrSzFsgYrYLakq?=
 =?us-ascii?Q?m089OR50K8UOgRtEhN+/saBc2BHzAbMu1qQPJ8EAKJ5G1lZkvVzdNIAOHPrh?=
 =?us-ascii?Q?Lm/1YpgFZDpIgig7iiq9Uk3dj/ya6SiMm3J00lLVtQcDrx1mwp+jtDJHswkC?=
 =?us-ascii?Q?KcmKzl2m0emPANR0Lmh5GMHYQhTFse5WdmdM0102bq2ZyZxZIaHZlw/1tdnA?=
 =?us-ascii?Q?sdzudJqszcythuJaVsM71xxeGxrxeD2q5smJuhajAqj0U7OcaDmI4zm+xsaa?=
 =?us-ascii?Q?RpMl4IZs31L/U6VcoG2N3sCD1c+dgu2PdHywFEVF4hkp4OwrAOsOqte/y48m?=
 =?us-ascii?Q?RRsSKRRGnPVuqY8KiPw+xjLPKSo9MTZxe1Qq37Lb7C+Al8Qm5cEEGqWdBDsD?=
 =?us-ascii?Q?LnZ/y/Om8GTcSfc3Dv7ptwZuLdvwMkEc30nXbzaFOwdmEzoVMXeDbfl/AVaK?=
 =?us-ascii?Q?vDWNsDCPRqs9MBaEv7hW5QD4cDSZh+yTltCclZC4nK1dnFRRRzAvBATrt+Fj?=
 =?us-ascii?Q?+v/xErF7WD/hunqgbGDJEtliMXgXIiWQTQ0q1G6ZHVGY4CONt6t+EbN0hbR2?=
 =?us-ascii?Q?8UQPRltIO/PzQPAQECkdxKpiryu6K2qSOHKoxyfwtAOLucsCLCuma26JJgWQ?=
 =?us-ascii?Q?dXOdQIcTWa+ygGHTrmTdmhEtlXxjWL1jkZNQNzeu6KVTDc6QJzYY79k82L+G?=
 =?us-ascii?Q?N6y2PE8DLKgjwP5ZFblRESRtXFN8V2Y=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d3710a1-781e-4353-a8c8-08da50a0a761
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:36.1718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3zJE5wkTr16go0/puSO+QpRsOP+IUlq+uDpPAVqR07b0JV50TQ4ai+kSMzzwM5nMzqGF8Bu7RrEMICh/0PxDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a binding for the SerDes module found on QorIQ processors. The
phy reference has two cells, one for the first lane and one for the
last. This should allow for good support of multi-lane protocols when
(if) they are added. There is no protocol option, because the driver is
designed to be able to completely reconfigure lanes at runtime.
Generally, the phy consumer can select the appropriate protocol using
set_mode. For the most part there is only one protocol controller
(consumer) per lane/protocol combination. The exception to this is the
B4860 processor, which has some lanes which can be connected to
multiple MACs. For that processor, I anticipate the easiest way to
resolve this will be to add an additional cell with a "protocol
controller instance" property.

Each serdes has a unique set of supported protocols (and lanes). The
support matrix is stored in the driver and is selected based on the
compatible string. It is anticipated that a new compatible string will
need to be added for each serdes on each SoC that drivers support is
added for.

There are two PLLs, each of which can be used as the master clock for
each lane. Each PLL has its own reference. For the moment they are
required, because it simplifies the driver implementation. Absent
reference clocks can be modeled by a fixed-clock with a rate of 0.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../bindings/phy/fsl,qoriq-serdes.yaml        | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml

diff --git a/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml b/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
new file mode 100644
index 000000000000..4b9c1fcdab10
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/fsl,qoriq-serdes.yaml
@@ -0,0 +1,78 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/fsl,qoriq-serdes.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP QorIQ SerDes Device Tree Bindings
+
+maintainers:
+  - Sean Anderson <sean.anderson@seco.com>
+
+description: |
+  This binding describes the SerDes devices found in NXP's QorIQ line of
+  processors. The SerDes provides up to eight lanes. Each lane may be
+  configured individually, or may be combined with adjacent lanes for a
+  multi-lane protocol. The SerDes supports a variety of protocols, including up
+  to 10G Ethernet, PCIe, SATA, and others. The specific protocols supported for
+  each lane depend on the particular SoC.
+
+properties:
+  "#phy-cells":
+    const: 2
+    description: |
+      The cells contain the following arguments.
+
+      - description: |
+          The first lane in the group. Lanes are numbered based on the register
+          offsets, not the I/O ports. This corresponds to the letter-based
+          ("Lane A") naming scheme, and not the number-based ("Lane 0") naming
+          scheme. On most SoCs, "Lane A" is "Lane 0", but not always.
+        minimum: 0
+        maximum: 7
+      - description: |
+          Last lane. For single-lane protocols, this should be the same as the
+          first lane.
+        minimum: 0
+        maximum: 7
+
+  compatible:
+    enum:
+      - fsl,ls1046a-serdes-1
+      - fsl,ls1046a-serdes-2
+
+  clocks:
+    minItems: 2
+    maxItems: 2
+    description: |
+      Clock for each PLL reference clock input.
+
+  clock-names:
+    minItems: 2
+    maxItems: 2
+    items:
+      pattern: "^ref[0-1]$"
+
+  reg:
+    maxItems: 1
+
+required:
+  - "#phy-cells"
+  - compatible
+  - clocks
+  - clock-names
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    serdes1: phy@1ea0000 {
+      #phy-cells = <2>;
+      compatible = "fsl,ls1046a-serdes-1";
+      reg = <0x0 0x1ea0000 0x0 0x2000>;
+      clocks = <&clk_100mhz>, <&clk_156mhz>;
+      clock-names = "ref0", "ref1";
+    };
+
+...
-- 
2.35.1.1320.gc452695387.dirty

