Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54382AB54B
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729364AbgKIKrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:47:07 -0500
Received: from mail-db8eur05on2041.outbound.protection.outlook.com ([40.107.20.41]:20449
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726646AbgKIKrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 05:47:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zo1gA7+sf/RPZp059NeeuwawxL2P+ruCrPJjA/hOCWgG/V+MmzhfY9seAXWuUvF26mDzAsZPTQwspmAyBYl+smA6Oq+7RcxUjDSETR2MMXrLCKtsYYXgKkRpspbtb2+VyztmZw+aFssebCuUddH/85g+JZxlyKM70ry3Finr5CJxTjvBMXEOBQ7tFfRkqg3UwI5sCbfseQpQQwGfJy17I/j88yXkoPCTqa0MmBUzRgcDXTM/c13F5xR5X39vb+WDT5bzlyW8ojSLKyKtBXhiMtAmSsv02D0O8+/wdLbiWW3xZ9fCfdWSW4vvSaffAAw8by33pkp49io6ErJqkrJlYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhGzIx5KrhVUX7Fh718g1RxZcOXE1liYsjF9SJs44jw=;
 b=VDSbRpGoNlMjdmb5Ze9FBssZobkN6deriwX7upSFOwUXAj5mng4Y/KCEvEf7HbWq1xHK3qk4a7A869m7Y3q+9t5zxbXJblrKY0jzDPyJuQC+XXyGGrCke70XcmVFWReyd2nr8480EfIDc0mt9/g7UdPttsj9a9lWDBzPu42M6kx+SsVD5PzplaYvmuke49WlPwaCS+2G9uqH1+7lg1Rm7r2vreu7AqvnjWseu4FT9RttCra6XuGBuEPgm2b56k3GlBXooovA0ztlWzRtHjkJzy4Wal2xjY97V6cQk6u8zP9sZORSMz98yjKhau5VRiE7IoZSlVkGShocRRZkguffBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhGzIx5KrhVUX7Fh718g1RxZcOXE1liYsjF9SJs44jw=;
 b=dGbSV48W46y7b0V7fxGx7SV/cz0meufTvsBqlrkS/0Ta2FuMolnCTKL1yVaPuKh3NrI5O/n1AH2L9qrtXWsLc1hkdlHLf5kjnVcSVbz+jn+HKW5d9eTZTeFajwbXqw2Gu9680Uvd+H0JDHkeDhLr1e5pS7LfMeb0yaskqBNMRFE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com (2603:10a6:803:3::26)
 by VI1PR04MB3982.eurprd04.prod.outlook.com (2603:10a6:803:49::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.24; Mon, 9 Nov
 2020 10:46:51 +0000
Received: from VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3]) by VI1PR0402MB3405.eurprd04.prod.outlook.com
 ([fe80::f557:4dcb:4d4d:57f3%2]) with mapi id 15.20.3541.021; Mon, 9 Nov 2020
 10:46:51 +0000
From:   Laurentiu Tudor <laurentiu.tudor@nxp.com>
To:     robh+dt@kernel.org, leoyang.li@nxp.com, corbet@lwn.net,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, ioana.ciornei@nxp.com,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: [PATCH v2 2/2] dt-bindings: misc: convert fsl,qoriq-mc from txt to YAML
Date:   Mon,  9 Nov 2020 12:46:35 +0200
Message-Id: <20201109104635.21116-2-laurentiu.tudor@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201109104635.21116-1-laurentiu.tudor@nxp.com>
References: <20201109104635.21116-1-laurentiu.tudor@nxp.com>
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM8P192CA0020.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::25) To VI1PR0402MB3405.eurprd04.prod.outlook.com
 (2603:10a6:803:3::26)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1864-101.ea.freescale.net (83.217.231.2) by AM8P192CA0020.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 10:46:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1770afa1-dfe5-407c-1baa-08d8849cc3bf
X-MS-TrafficTypeDiagnostic: VI1PR04MB3982:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB398228C60C9B7E73E9BD355AECEA0@VI1PR04MB3982.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v1GLn3lHOwJUWQBWB/JKVmhaAUI0x7vjCfZppfPDqVfgbtcjzOlWxD2aak3qyUpM/t2McE0Eo7ggRIUqtGbyEpl+/BnBDpDku/cbuiODB5k6OSVKRu8WWbx+TZfMKyUV6w1yWhjDPkwKU5zhD6yOWonVf3K9lIc6J9JDq68lL1PA1i+NLlUr1T/mKIRXGcoEvpQnVdFQA4TEDYHUUZdHT5nYEAT9eVAaDMbN8zIq59p6MgV/aP5bDl8pc92lCdQ4yn6kdKPjGDjTyTDM68Q9COJMkhKCiXp18aZ7xqYVAlFue9yM/YYAniAFu4B2uZAe9QzD/WYhnPF60um22WWrgCKpqIsJavSe6xHuwj1LqNoE18imTsiCoazUPvumjxPmwGmuNtRUquj6VMNgei2MTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3405.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(2906002)(52116002)(966005)(7416002)(66556008)(1076003)(6506007)(66946007)(66476007)(8676002)(16526019)(6512007)(30864003)(6486002)(956004)(44832011)(8936002)(6666004)(26005)(316002)(54906003)(4326008)(5660300002)(186003)(83380400001)(36756003)(478600001)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: IH6/lRU2RxZrmr6RYszEuvKpe07v4kLG9WI4JZttUhhRwsaGcIuaUbbDV8ewe0zygpgDlGM3EGT6pofExkDqDeGpuKnRX0WOfRG/e0CalOpNhqjpC0WM67xELyURMHLFhi2kbFXBRcT1GrHE+HkNYONPPrlKaXqnqTu6VpDMuCjw0He8+3i6h0l99176OjRlO/OLu5HnAzwP8pWJbHRKNdjBsy0jt4z8eK/sISHcOs742aEeJXF+cOEtfZPfuU48ce9LZOaeJioAmr398eOntI7QZgq2xpbD/lvpH2pM9QeXLdwwCSM8Fv3/hwBDa/ZSVoGqYsDUxDQ6LJ+i9tXozs8npK2UAP0U4/NBJSWgRtLJK56neHYBaSHYdaszSzpBOkSZeXwNcFwgO2w1hE1pvcjxFtoPno1+LTxmyYrz9wJrHJ3OklrSti7mJsRkNDP5qV4F9700OE1TIlOhQZw+UWyXT624OsF6PWWjidlDaCI8S1f3Av2IIByGeq5DjeYjqZVBZ+JaExMSHOTh+7bsP1370MKyd0jKQ4vUkfXJvzJGQqclF1AzBL7bzAR+Kc2nAyuNNnLvhRx3mbDTITMH+kRmXgub1jp8lofxIHpXiQoYvzotYe+hCuq4ywtPrZs0OOLKrKLzsjiY8OBHbxz/xA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1770afa1-dfe5-407c-1baa-08d8849cc3bf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3405.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 10:46:51.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wh34lYYgpgHbWUuGTBSSsmqBQsNUUB0U/XpYjmU8+EidhxuKEe5vZdgVEKhFPHC9hQFxxjf5zJYyIYzuO9TapQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3982
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
Changes in v2:
 - fixed errors reported by yamllint
 - dropped multiple unnecessary quotes
 - used schema instead of text in description
 - added constraints on dpmac reg property

 .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ----------------
 .../bindings/misc/fsl,qoriq-mc.yaml           | 210 ++++++++++++++++++
 .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
 MAINTAINERS                                   |   4 +-
 4 files changed, 217 insertions(+), 198 deletions(-)
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
index 000000000000..5b69057eeda8
--- /dev/null
+++ b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
@@ -0,0 +1,210 @@
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
+      "^dpmac@[0-9a-f]+$":
+        type: object
+
+        description:
+          dpmac sub-node that describes the relationship between the
+          Ethernet MACs which belong to the MC and the Ethernet PHYs
+          on the system board.
+
+        properties:
+          compatible:
+            const: "fsl,qoriq-mc-dpmac"
+
+          reg:
+            description: Specifies the id of the dpmac
+            $ref: /schemas/types.yaml#/definitions/uint32
+            minimum: 1
+            maximum: 31
+
+          phy-handle:
+            $ref: /schemas/types.yaml#definitions/phandle
+            description:
+              Specifies the phandle to the PHY device node associated with
+              this dpmac.
+
+        required:
+          - compatible
+          - reg
+          - phy-handle
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
+          dpmac@1 {
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
index b43b59542d15..400a17c90edb 100644
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

