Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B02C01E1
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 10:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgKWJBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 04:01:44 -0500
Received: from mail-eopbgr70081.outbound.protection.outlook.com ([40.107.7.81]:64681
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725275AbgKWJBn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 04:01:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1ZeANb2ivAmn98ikKJOQAJOuuVqpC6kxo6F2PBx4xvKtVJ/llfYNRVT0q4eMopUBH2UyGj6J7raCKwXqR/gWO1V6RJT9vRybaTOv1mZOh0l7hucbQy6UuJeQ2mJfg8FUMJwRbepX066ciVTVb+IDGP8NapJtsY3jtdF6U1cu8BUubPaYedceQJ1y9TbVsYsX5cFMvkIcvaD2P4uvxl8wDQ/uHFoUE/B3P59pXpBIVPFB4Ch8I1R+JtGvURElbYFTp4N5FxFa55VxKqKnTdh6+2yXEJ2SmGkbrk+iO2MIto/u+OaYJyuoiGn9tcLQoZ9mOfaPptR0xApvHAtcmzCCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVYxre4DgeYalSz0RcQneVnlSik4tKgsHg1eDFFd244=;
 b=Y6HLiQggGuS43ucfzIdgjNsIOYljVMMD3w9nU6cI9bKUgS9VnGRxCAv3lU7js4ZmCM8StMhWx7WrXe/FxLqnUrOanbF1ZquuuRt37lbwiMheOf2AVlyemRerj5Oxy00fcp1GsWDs13Lielhua2VGWfKDElJTDoM7+9VgCKLbu4th1+SMY39RLjcvLVJi7AODcDql99zn40eY0bvS5eG1irTxSSKKmE7LN3HnvrFhMLcBDALBQxfb0i3KTrUTfa9Dv/lzEqILjbOGKRWrV02TfGjSIEOCWikBol/HONJYFpQ9/noHgyNXmyyhZYRg7G1Cictw32KkId8buyRKQYra2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hVYxre4DgeYalSz0RcQneVnlSik4tKgsHg1eDFFd244=;
 b=I+7lbrNIUZjg4P3bxPw8vaLz08y4l+0/4OvKgeN50eNyzXu6FXGG57XMpvo3FvnemfSYopwgbhn2ald7SYWliX1DQhW5/y2kKFri1Ns2d3citgh7CBBMKKfx17OSTirN/nHgg16CfVk/cqwpv+u2PizCqQx8UKghgUbm/16u3k0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB4239.eurprd04.prod.outlook.com (2603:10a6:803:48::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.30; Mon, 23 Nov
 2020 09:01:24 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3%2]) with mapi id 15.20.3541.028; Mon, 23 Nov 2020
 09:01:24 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     robh+dt@kernel.org, leoyang.li@nxp.com, corbet@lwn.net,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, ioana.ciornei@nxp.com,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v4] dt-bindings: misc: convert fsl,qoriq-mc from txt to YAML
Date:   Mon, 23 Nov 2020 11:00:35 +0200
Message-Id: <20201123090035.15734-1-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM8P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:219::22) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1864-101.ea.freescale.net (83.217.231.2) by AM8P190CA0017.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Mon, 23 Nov 2020 09:01:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c1ef2e80-75ec-4776-b5b2-08d88f8e5a2e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4239:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB423939E254456667CAAAB8A8ECFC0@VI1PR04MB4239.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W4Jkppi/ujPwzo/lA82PUbqTKm5+lAzRneeier64vKizC5mhUKm3Mv/DnUkivdDVIt0ievlZhgGOiQYk4Vy/PyAWrg/bBuk9GnUIexNVWaCTcivdirrDVuXH0WOO5ha+aBMZvzuu0w4sZeWpARlMzKxyVmWsKcXvb7sjjfpj69M8+jVn0c6+cwM1Ny1SkAQwDEErk8zLM8/qYHUeNsCZsM456gzeIJHixVCFbiYLUX6ZkXqmI6wreXVUYSdUnQOgkFCl8MfJbriqGbXUlWWCEU1S/N8YhkfaXGbjbP6NP+xRj+MrKgl5HytDKWInz7saDrcBJt632q4I5dzA923zbNB00jdoya5H3VzvRA7Z6GlOZv8aGyFSSmUybGBKG35aWD2T0Aam8MN4tZEBXBsxyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(376002)(396003)(39860400002)(6512007)(966005)(30864003)(5660300002)(83380400001)(54906003)(4326008)(52116002)(2906002)(956004)(6666004)(1076003)(86362001)(316002)(36756003)(8936002)(8676002)(6486002)(2616005)(186003)(478600001)(6506007)(26005)(66556008)(66476007)(66946007)(7416002)(44832011)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Lr/RwoI8EHs87pbuuG0jaejFspXDSfKqqAgvToPUyyo1fsx2B7K3BfXlT/u+spcKBUJ3CpoxXHbmcLiW3xD6vlvL/ftppMjYs4I5TaEf4SR4QAOEPCEMmaxZdp6pXBTfyu2+aOho9Ujy5uEsaZQ0ixfqk87uGLsOcLRLcniMI7XvsSUWcNgzp7lqSoUFVT5nIq7xSKSzn1ocTzz5aF0Nk39CTglPSMsZ/VcFdyOzeMZOszYKIoLWBoc4DepMpVixZeUWzMWdhYVlAvQ2Y85aFmMG5WSqvZX8qskq/oVJmacSN58H99qPYb41tl6USHaC/GNTOtNxEeJ/lIYuhpFYUlA61ClRvZE36ZVqAwPHaXVJZimz7vRgb+yyiQ2QwTqVRSmT8PMfbqT6VXH2jJyfKjf7nncsehWbZKhfqCrdNPM7E3NcPQGhPy4Q4+SlelF/d/naBwodqLjbHvwxne2jOBCtTz9deIHhBnW+C5eD+oIVlzZolG7+tgu1oiQZS3bO/zxplQh0pEQblCIEA3GfSvaonzsLPNC7/Pj5zf9hcTPqpCKt02HqsIdl8gst2s/s3Kz2N/o1j+7jB4WGEJWrqZQYvfv4lRGeEmk4p8PMKZxiV9x/MHdNBdEgIN7e3AGxquRYlZmB3Uq5h3IEBc2vLA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ef2e80-75ec-4776-b5b2-08d88f8e5a2e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2020 09:01:23.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5vvPz8EOHh3OZ+dtYT0xPWmKhMzJcY7yDywD1rPHyVvwvqdvTZ6Sg8/IJmqJBvO6xML8iOFp6nyF7Vm+GMXuKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ionut-robert Aron <ionut-robert.aron@nxp.com>

Convert fsl,qoriq-mc to YAML in order to automate the verification
process of dts files. In addition, update MAINTAINERS accordingly
and, while at it, add some missing files.

Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
[laurentiu.tudor@nxp.com: update MINTAINERS, updates & fixes in schema]
Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
---
Changes in v4:
 - use $ref to point to fsl,qoriq-mc-dpmac binding

Changes in v3:
 - dropped duplicated "fsl,qoriq-mc-dpmac" schema and replaced with
   reference to it
 - fixed a dt_binding_check warning

Changes in v2:
 - fixed errors reported by yamllint
 - dropped multiple unnecessary quotes
 - used schema instead of text in description
 - added constraints on dpmac reg property

 .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ------------------
 .../bindings/misc/fsl,qoriq-mc.yaml           | 186 +++++++++++++++++
 .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
 MAINTAINERS                                   |   4 +-
 4 files changed, 193 insertions(+), 198 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
 create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml

diff --git a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
deleted file mode 100644
index 7b486d4985dc..000000000000
--- a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
+++ /dev/null
@@ -1,196 +0,0 @@
-* Freescale Management Complex
-
-The Freescale Management Complex (fsl-mc) is a hardware resource
-manager that manages specialized hardware objects used in
-network-oriented packet processing applications. After the fsl-mc
-block is enabled, pools of hardware resources are available, such as
-queues, buffer pools, I/O interfaces. These resources are building
-blocks that can be used to create functional hardware objects/devices
-such as network interfaces, crypto accelerator instances, L2 switches,
-etc.
-
-For an overview of the DPAA2 architecture and fsl-mc bus see:
-Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
-
-As described in the above overview, all DPAA2 objects in a DPRC share the
-same hardware "isolation context" and a 10-bit value called an ICID
-(isolation context id) is expressed by the hardware to identify
-the requester.
-
-The generic 'iommus' property is insufficient to describe the relationship
-between ICIDs and IOMMUs, so an iommu-map property is used to define
-the set of possible ICIDs under a root DPRC and how they map to
-an IOMMU.
-
-For generic IOMMU bindings, see
-Documentation/devicetree/bindings/iommu/iommu.txt.
-
-For arm-smmu binding, see:
-Documentation/devicetree/bindings/iommu/arm,smmu.yaml.
-
-The MSI writes are accompanied by sideband data which is derived from the ICID.
-The msi-map property is used to associate the devices with both the ITS
-controller and the sideband data which accompanies the writes.
-
-For generic MSI bindings, see
-Documentation/devicetree/bindings/interrupt-controller/msi.txt.
-
-For GICv3 and GIC ITS bindings, see:
-Documentation/devicetree/bindings/interrupt-controller/arm,gic-v3.yaml.
-
-Required properties:
-
-    - compatible
-        Value type: <string>
-        Definition: Must be "fsl,qoriq-mc".  A Freescale Management Complex
-                    compatible with this binding must have Block Revision
-                    Registers BRR1 and BRR2 at offset 0x0BF8 and 0x0BFC in
-                    the MC control register region.
-
-    - reg
-        Value type: <prop-encoded-array>
-        Definition: A standard property.  Specifies one or two regions
-                    defining the MC's registers:
-
-                       -the first region is the command portal for the
-                        this machine and must always be present
-
-                       -the second region is the MC control registers. This
-                        region may not be present in some scenarios, such
-                        as in the device tree presented to a virtual machine.
-
-    - ranges
-        Value type: <prop-encoded-array>
-        Definition: A standard property.  Defines the mapping between the child
-                    MC address space and the parent system address space.
-
-                    The MC address space is defined by 3 components:
-                       <region type> <offset hi> <offset lo>
-
-                    Valid values for region type are
-                       0x0 - MC portals
-                       0x1 - QBMAN portals
-
-    - #address-cells
-        Value type: <u32>
-        Definition: Must be 3.  (see definition in 'ranges' property)
-
-    - #size-cells
-        Value type: <u32>
-        Definition: Must be 1.
-
-Sub-nodes:
-
-        The fsl-mc node may optionally have dpmac sub-nodes that describe
-        the relationship between the Ethernet MACs which belong to the MC
-        and the Ethernet PHYs on the system board.
-
-        The dpmac nodes must be under a node named "dpmacs" which contains
-        the following properties:
-
-            - #address-cells
-              Value type: <u32>
-              Definition: Must be present if dpmac sub-nodes are defined and must
-                          have a value of 1.
-
-            - #size-cells
-              Value type: <u32>
-              Definition: Must be present if dpmac sub-nodes are defined and must
-                          have a value of 0.
-
-        These nodes must have the following properties:
-
-            - compatible
-              Value type: <string>
-              Definition: Must be "fsl,qoriq-mc-dpmac".
-
-            - reg
-              Value type: <prop-encoded-array>
-              Definition: Specifies the id of the dpmac.
-
-            - phy-handle
-              Value type: <phandle>
-              Definition: Specifies the phandle to the PHY device node associated
-                          with the this dpmac.
-Optional properties:
-
-- iommu-map: Maps an ICID to an IOMMU and associated iommu-specifier
-  data.
-
-  The property is an arbitrary number of tuples of
-  (icid-base,iommu,iommu-base,length).
-
-  Any ICID i in the interval [icid-base, icid-base + length) is
-  associated with the listed IOMMU, with the iommu-specifier
-  (i - icid-base + iommu-base).
-
-- msi-map: Maps an ICID to a GIC ITS and associated msi-specifier
-  data.
-
-  The property is an arbitrary number of tuples of
-  (icid-base,gic-its,msi-base,length).
-
-  Any ICID in the interval [icid-base, icid-base + length) is
-  associated with the listed GIC ITS, with the msi-specifier
-  (i - icid-base + msi-base).
-
-Deprecated properties:
-
-    - msi-parent
-        Value type: <phandle>
-        Definition: Describes the MSI controller node handling message
-                    interrupts for the MC. When there is no translation
-                    between the ICID and deviceID this property can be used
-                    to describe the MSI controller used by the devices on the
-                    mc-bus.
-                    The use of this property for mc-bus is deprecated. Please
-                    use msi-map.
-
-Example:
-
-        smmu: iommu@5000000 {
-               compatible = "arm,mmu-500";
-               #iommu-cells = <1>;
-               stream-match-mask = <0x7C00>;
-               ...
-        };
-
-        gic: interrupt-controller@6000000 {
-               compatible = "arm,gic-v3";
-               ...
-        }
-        its: gic-its@6020000 {
-               compatible = "arm,gic-v3-its";
-               msi-controller;
-               ...
-        };
-
-        fsl_mc: fsl-mc@80c000000 {
-                compatible = "fsl,qoriq-mc";
-                reg = <0x00000008 0x0c000000 0 0x40>,    /* MC portal base */
-                      <0x00000000 0x08340000 0 0x40000>; /* MC control reg */
-                /* define map for ICIDs 23-64 */
-                iommu-map = <23 &smmu 23 41>;
-                /* define msi map for ICIDs 23-64 */
-                msi-map = <23 &its 23 41>;
-                #address-cells = <3>;
-                #size-cells = <1>;
-
-                /*
-                 * Region type 0x0 - MC portals
-                 * Region type 0x1 - QBMAN portals
-                 */
-                ranges = <0x0 0x0 0x0 0x8 0x0c000000 0x4000000
-                          0x1 0x0 0x0 0x8 0x18000000 0x8000000>;
-
-                dpmacs {
-                    #address-cells = <1>;
-                    #size-cells = <0>;
-
-                    dpmac@1 {
-                        compatible = "fsl,qoriq-mc-dpmac";
-                        reg = <1>;
-                        phy-handle = <&mdio0_phy0>;
-                    }
-                }
-        };
diff --git a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
new file mode 100644
index 000000000000..f45e21872e4f
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
@@ -0,0 +1,186 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2020 NXP
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/misc/fsl,qoriq-mc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+maintainers:
+  - Laurentiu Tudor <laurentiu.tudor@nxp.com>
+
+title: Freescale Management Complex
+
+description: |
+  The Freescale Management Complex (fsl-mc) is a hardware resource
+  manager that manages specialized hardware objects used in
+  network-oriented packet processing applications. After the fsl-mc
+  block is enabled, pools of hardware resources are available, such as
+  queues, buffer pools, I/O interfaces. These resources are building
+  blocks that can be used to create functional hardware objects/devices
+  such as network interfaces, crypto accelerator instances, L2 switches,
+  etc.
+
+  For an overview of the DPAA2 architecture and fsl-mc bus see:
+  Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
+
+  As described in the above overview, all DPAA2 objects in a DPRC share the
+  same hardware "isolation context" and a 10-bit value called an ICID
+  (isolation context id) is expressed by the hardware to identify
+  the requester.
+
+  The generic 'iommus' property is insufficient to describe the relationship
+  between ICIDs and IOMMUs, so an iommu-map property is used to define
+  the set of possible ICIDs under a root DPRC and how they map to
+  an IOMMU.
+
+  For generic IOMMU bindings, see:
+  Documentation/devicetree/bindings/iommu/iommu.txt.
+
+  For arm-smmu binding, see:
+  Documentation/devicetree/bindings/iommu/arm,smmu.yaml.
+
+  MC firmware binary images can be found here:
+  https://github.com/NXP/qoriq-mc-binary
+
+properties:
+  compatible:
+    const: fsl,qoriq-mc
+    description:
+      A Freescale Management Complex compatible with this binding must have
+      Block Revision Registers BRR1 and BRR2 at offset 0x0BF8 and 0x0BFC in
+      the MC control register region.
+
+  reg:
+    minItems: 1
+    items:
+      - description: the command portal for this machine
+      - description:
+          MC control registers. This region may not be present in some
+          scenarios, such as in the device tree presented to a virtual
+          machine.
+
+  ranges:
+    description: |
+      A standard property. Defines the mapping between the child MC address
+      space and the parent system address space.
+
+      The MC address space is defined by 3 components:
+                <region type> <offset hi> <offset lo>
+
+      Valid values for region type are:
+                  0x0 - MC portals
+                  0x1 - QBMAN portals
+
+  '#address-cells':
+    const: 3
+
+  '#size-cells':
+    const: 1
+
+  dpmacs:
+    type: object
+    description:
+      The fsl-mc node may optionally have dpmac sub-nodes that describe the
+      relationship between the Ethernet MACs which belong to the MC and the
+      Ethernet PHYs on the system board.
+
+    properties:
+      '#address-cells':
+        const: 1
+
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^(dpmac@[0-9a-f]+)|(ethernet@[0-9a-f]+)$":
+        type: object
+
+        $ref: /schemas/net/fsl,qoriq-mc-dpmac.yaml#
+
+  iommu-map:
+    description: |
+      Maps an ICID to an IOMMU and associated iommu-specifier data.
+
+      The property is an arbitrary number of tuples of
+      (icid-base, iommu, iommu-base, length).
+
+      Any ICID i in the interval [icid-base, icid-base + length) is
+      associated with the listed IOMMU, with the iommu-specifier
+      (i - icid-base + iommu-base).
+
+  msi-map:
+    description: |
+      Maps an ICID to a GIC ITS and associated msi-specifier data.
+
+      The property is an arbitrary number of tuples of
+      (icid-base, gic-its, msi-base, length).
+
+      Any ICID in the interval [icid-base, icid-base + length) is
+      associated with the listed GIC ITS, with the msi-specifier
+      (i - icid-base + msi-base).
+
+  msi-parent:
+    deprecated: true
+    description:
+      Points to the MSI controller node handling message interrupts for the MC.
+
+required:
+  - compatible
+  - reg
+  - iommu-map
+  - msi-map
+  - ranges
+  - '#address-cells'
+  - '#size-cells'
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+
+      smmu: iommu@5000000 {
+        compatible = "arm,mmu-500";
+        #global-interrupts = <1>;
+        #iommu-cells = <1>;
+        reg = <0 0x5000000 0 0x800000>;
+        stream-match-mask = <0x7c00>;
+        interrupts = <0 13 4>,
+                     <0 146 4>, <0 147 4>,
+                     <0 148 4>, <0 149 4>,
+                     <0 150 4>, <0 151 4>,
+                     <0 152 4>, <0 153 4>;
+      };
+
+      fsl_mc: fsl-mc@80c000000 {
+        compatible = "fsl,qoriq-mc";
+        reg = <0x00000008 0x0c000000 0 0x40>,    /* MC portal base */
+        <0x00000000 0x08340000 0 0x40000>; /* MC control reg */
+        /* define map for ICIDs 23-64 */
+        iommu-map = <23 &smmu 23 41>;
+        /* define msi map for ICIDs 23-64 */
+        msi-map = <23 &its 23 41>;
+        #address-cells = <3>;
+        #size-cells = <1>;
+
+        /*
+        * Region type 0x0 - MC portals
+        * Region type 0x1 - QBMAN portals
+        */
+        ranges = <0x0 0x0 0x0 0x8 0x0c000000 0x4000000
+                  0x1 0x0 0x0 0x8 0x18000000 0x8000000>;
+
+        dpmacs {
+          #address-cells = <1>;
+          #size-cells = <0>;
+
+          ethernet@1 {
+            compatible = "fsl,qoriq-mc-dpmac";
+            reg = <1>;
+            phy-handle = <&mdio0_phy0>;
+          };
+        };
+      };
+    };
diff --git a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
index d638b5a8aadd..b3261c5871cc 100644
--- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
@@ -28,6 +28,9 @@ interfaces, an L2 switch, or accelerator instances.
 The MC provides memory-mapped I/O command interfaces (MC portals)
 which DPAA2 software drivers use to operate on DPAA2 objects.
 
+MC firmware binary images can be found here:
+https://github.com/NXP/qoriq-mc-binary
+
 The diagram below shows an overview of the DPAA2 resource management
 architecture::
 
@@ -338,7 +341,7 @@ Key functions include:
   a bind of the root DPRC to the DPRC driver
 
 The binding for the MC-bus device-tree node can be consulted at
-*Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt*.
+*Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml*.
 The sysfs bind/unbind interfaces for the MC-bus can be consulted at
 *Documentation/ABI/testing/sysfs-bus-fsl-mc*.
 
diff --git a/MAINTAINERS b/MAINTAINERS
index b516bb34a8d5..e0ce6e2b663c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14409,9 +14409,11 @@ M:	Stuart Yoder <stuyoder@gmail.com>
 M:	Laurentiu Tudor <laurentiu.tudor@nxp.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
+F:	Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
+F:	Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
 F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
 F:	drivers/bus/fsl-mc/
+F:	include/linux/fsl/mc.h
 
 QT1010 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
-- 
2.17.1

