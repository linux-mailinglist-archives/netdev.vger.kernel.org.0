Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89789576946
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiGOWAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiGOWAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:00:22 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50072.outbound.protection.outlook.com [40.107.5.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4164BD1A;
        Fri, 15 Jul 2022 15:00:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CprOmOyVGob3mQYFzbVK9eOaFG2gVUtqmNuynhSlZo063oStlkpPfD5Lw9S0V7VXuvhwT7eeGAE2F86bC6dAHYWELefuh487ZzhdrARLrGDGAwBbseGKPnwDu42Kmeq02Xjhxjl9/MvMd+SqvwGidCC/qRf+LCBf1AbfNnxPRj+PnOin5Kv30Pycm6y19F/zWbJHq44sLmEHf14BbTQLG2s79+l1cKA5s8yXaAR7sfAWCQdqfhX5A2HGpGcVbxChPjtcODuWGYWYShGeAlyq7VETaVWF0YYFFRxcy5pJR6Zns6NbKOll84snC450koahe4OhyGy8CRFNKIzkkz1g+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oGS0BA7YPnZMylAOCZf6r95AVRgACXITcb4wnUVKXA=;
 b=VhKNkKBKCUr+at4NEjDhjxKLFcVlcVlp5r4D7UpuU7MCcyZINaL1Qsyf/eRPc882uPU2GPen7HoGs8FbMyGpcJpmKPCz6HVtm3+6d/aXaIwtUWZUsrdIfpsgFhm/qaccWCE6NTzsryTT04I1Nug6HrXjyZ9al/OPIeH4ncTo/VcwxJxqg343aMyZS1iz0JhMuDVDVBtspzQPt7k3R6tGD/G+apzgRGFPgByLL1xjZcEks4q5945AfCm6GhMiXMWSfGTMmPwvKe0XV6NJavJ6Q3yu6XqvFMncwM6EA4I1OhWFZnjDPGJ0RDowwlkpk4+3IIsplhj9GWHtRHrGeqjkaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oGS0BA7YPnZMylAOCZf6r95AVRgACXITcb4wnUVKXA=;
 b=Y5UErRFKHf19CgkUChhPFnC+uQr3crc0zLx3TejHWrfh0OVIdP37pmDKtIBPrfcgjOnxI+NqwqNaGT3HXpBpemrujZ5Enm+x6rJd50D3aPDpzm0d0PQVvKziM4AIBGVqXZr1Mz9nMyAJJfuHftXICySwPWn7Zji1kvwGnEhHCzdsHUKQWIawzLIO9U4OJhOcwTvZlMd4KLL4bMfZAHdCRkmGK1L1NHSFvauuF/reZ7j7COIN34yJ9exF8u0DbvcmXlfyQTYsAxO8FXeh+PeYdIWHzrxT8dFU6L2/gfZ/Tj0STBzxHKDdpybkAK69X8YZblklVKfzjzgTGhHnAee87w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:17 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:17 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v3 03/47] dt-bindings: net: Convert FMan MAC bindings to yaml
Date:   Fri, 15 Jul 2022 17:59:10 -0400
Message-Id: <20220715215954.1449214-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b529b101-63a4-48ad-4462-08da66ad6761
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jywGjyFbO47exNdp+lBV7Alve3JJMKjhoRNtsFkCS3Ys79gGLjbRxNTUp2sCa+RuoW15Bm/Lh49bZYnd77Fgo1bsDLxjZ5UzLgEJG2qMY31jdfJuENYPQuJyf12bHSCIJWL0UDvZUgN86zG/eG9lUS6QHf7Od8ma478L3ciXv2EMsVySTfERBi81k2Soe9ieg9nBG9UJUsv0MCUHNrH4xdlKxCaILLg6EtZtDjc1QVzivu5A1bY5YDCBI7Occc9HwQ4yMcdestL3QbvPkWrrPBnI86tak72XtN+huxSpN4broxwHdTC+QxIwUsxIFKatUXTqRmw4AiGz1zr4NEpG2GV8m8JVmm/eYs/imlMxVaTn1w4xGEZwcJlGOYbjOu46IRfuV1pUGKQA1n9m+rjXqTN+Fhq4qdkcanlHHdsMqyOamJGZdgzP3sx75PNxzHnzO4U3QLJe2z1z2vb5E9OezofLo85pKTOWJKhXNuxKHK1b4/PvL2Iu9uzFJpA2Lsz5uHZDizu3Zq62Y3cP+fulkmIyf0kbJ0xAzQg1/Qe8zEFRxPZ4QT5f38bEjRkNVt7dOfBzbvysJtaNYTQ7pWHUz/QOWOtMNwlk5SCkmvdhfKMEoye57+38dNgWZGdyPO+Kng08nx+z9ryRPE6JKGD3L9WUoMTwNGtgdiZ4Q6VMT24PMAj689Ma8v+C9O3A2NvDMmPqTkPShZZh/RxaTkzp6B17jpI9rj9CtRYmfE22v0SZB/N+PzkdjPuhSoWThhp4u3vtyOP0Ovx/l29nSCC5d6Fg5Ylm8TEZkcXKINH0EYx570y3PCGPRI28yuBTxa9WHupAlVqydy4hNI8beQ5N8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(7416002)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(966005)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?q1Xmz8dFDVFhr1SBkVhfSDcTqIz5lDQRnO3nteB1//C0fQmw3z3tzK4xCYv2?=
 =?us-ascii?Q?vG4Ox0Q3CB0U/P+4bwksKdtRIKva7LQ5ervOT82+cXP3PWhgLIWywgCNvYTd?=
 =?us-ascii?Q?bZTmpiRCNJoeWE0/cn17zNjMlV/vlGykORVR867H/WRkog9IBQqvwfBdlTC7?=
 =?us-ascii?Q?GYVcgDX2cipHGgtIkBLrY9E+rxnByM0Er4d6paAVW7sg2EgO4aWP10Munp0b?=
 =?us-ascii?Q?NarxU7oQguj93I0sUd6TBpzmMfT/6rd3mvUQ46WZJVmQToB48I+7Dwafm1jE?=
 =?us-ascii?Q?ha/UY57Fw56p+dk2XYopCX7NYvIJDSYin+404Dlj+zswIhFPryDMwDRtW9hZ?=
 =?us-ascii?Q?lSO87UoXAJPIVQ++XCVi5J9Yq9KbVGV1ZhYt+Nzhh7p6QSibSHxTBieDfy6U?=
 =?us-ascii?Q?vXrtYk/hqdb4zHUZ8I/WRa6vP0yjbmMQuVf6lPpgj3JfVrPhsrUDLdtfOCMq?=
 =?us-ascii?Q?erdNbVV/Fbe9J4nCZ6ry9kWiN7Q+FopjlRJUCMKDCEDLVJO+GBxDafQe2Urk?=
 =?us-ascii?Q?pqHsXHw6ounzFcA/VbIrWSZpbCgAANhjl0EjARqS908Jg0O+hg/t3pwxCnOT?=
 =?us-ascii?Q?ZkB1kIOoyBuKvVW1Cd5FghUQ92uUO+iQ5Gxgpix9YRzpIXT3UXLH4Nbr2IIs?=
 =?us-ascii?Q?Xz+6kgs+KvgG1AsVO1yfLz8SVwqdttxSFrx7EecwFb1SM5YvRHolZSESWlOo?=
 =?us-ascii?Q?8sCcNgtZV+Q5VN8GJWqEAv7hQN22S61/aZv7MrKk2Z1PfW6W4q3PKBOkFTxJ?=
 =?us-ascii?Q?Psg4yVewOIASayS5r25AfSfBVD844CzRhV/5DOdbvDSX0jFHAm2ucPn9mPw0?=
 =?us-ascii?Q?afm1i/4R0l4ZobC8ggFsO4BDQv3G33cSU4cjf3x4QsPbZFx8XpoYQzCcUHLJ?=
 =?us-ascii?Q?j2rFDBxaGQu8nL2BcWufRmbEUKCVATgWJiRJlcG0jUqLbKCLxOOrHGXqj4DD?=
 =?us-ascii?Q?06UXmNUJGQfqz6fmM6QehlheG7Xw4jVm/JyX+s281uM5SsgZK9J9tm9oz2ni?=
 =?us-ascii?Q?tgr4SllvpbmC3QXWBBESgN+a32xltiWbGr1WhsHCKNPMyDBU8SzZME87jjU6?=
 =?us-ascii?Q?8ibqrDwQcum4oCcTZmsp0tS3wBX69Gs82sqN8puAU0Cl/djnndRNbRCqGaiM?=
 =?us-ascii?Q?pPEU7aNwjlC+Eyk8a8o5uFATWam3aLNfvIq2yqK2jJgRr247ff1vfTeYkdsO?=
 =?us-ascii?Q?6LiAmDwpBPa9QJE96tXoFGVWqHNN3l79jCDJ8sK51CR2nxLr13Wa9JPscMEz?=
 =?us-ascii?Q?HW8lrIvXgt0S+AjGFsVoPsis3EMv40i5eWHCS4o42+v8GrBPyHeNwSCmkrxj?=
 =?us-ascii?Q?s5GuidH519xROLRHzKYUlMxk+mReL34Y3zmZhtaq27zIceAl4KNfj8Aeni+m?=
 =?us-ascii?Q?yIfzCBGQ8vucJ5fWN4OQPNsxx+Ea8JGqzT+U1KmiDLpVQkrxv/0cjNHVhqHm?=
 =?us-ascii?Q?z5YRbS7nOfGGjXxwAEPjlpzDeSIT8cIfXPQqGIGPEiABgMTm+DmbnTh447NB?=
 =?us-ascii?Q?lb+Hde6hzA7fmNO9S1YvH/RcCmiDfzTYxNqAV2I2Ho8j+tsp3j/PVblf2AQj?=
 =?us-ascii?Q?GU7tccgnzEaUcGdoJFtnRmiba2WDb0xCF0mvKgHkjv76gDqTDGYwAaJNB6QT?=
 =?us-ascii?Q?mA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b529b101-63a4-48ad-4462-08da66ad6761
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:17.8024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cEnzoxEYczvHTjy6X3PUT4BRavD598tzKl0aZLGwo0thHxiV1EOvhtcIc7HoTJW4DFDeMYc0Ug+WVawIt9xzGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the MAC portion of the FMan MAC bindings to yaml.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

Changes in v3:
- Incorperate some minor changes into the first FMan binding commit

Changes in v2:
- New

 .../bindings/net/fsl,fman-dtsec.yaml          | 145 ++++++++++++++++++
 .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
 2 files changed, 146 insertions(+), 127 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml

diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
new file mode 100644
index 000000000000..78579ef839bf
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
@@ -0,0 +1,145 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/fsl,fman-dtsec.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP FMan MAC
+
+maintainers:
+  - Madalin Bucur <madalin.bucur@nxp.com>
+
+description: |
+  Each FMan has several MACs, each implementing an Ethernet interface. Earlier
+  versions of FMan used the Datapath Three Speed Ethernet Controller (dTSEC) for
+  10/100/1000 MBit/s speeds, and the 10-Gigabit Ethernet Media Access Controller
+  (10GEC) for 10 Gbit/s speeds. Later versions of FMan use the Multirate
+  Ethernet Media Access Controller (mEMAC) to handle all speeds.
+
+properties:
+  compatible:
+    enum:
+      - fsl,fman-dtsec
+      - fsl,fman-xgec
+      - fsl,fman-memac
+
+  cell-index:
+    maximum: 64
+    description: |
+      FManV2:
+      register[bit]           MAC             cell-index
+      ============================================================
+      FM_EPI[16]              XGEC            8
+      FM_EPI[16+n]            dTSECn          n-1
+      FM_NPI[11+n]            dTSECn          n-1
+              n = 1,..,5
+
+      FManV3:
+      register[bit]           MAC             cell-index
+      ============================================================
+      FM_EPI[16+n]            mEMACn          n-1
+      FM_EPI[25]              mEMAC10         9
+
+      FM_NPI[11+n]            mEMACn          n-1
+      FM_NPI[10]              mEMAC10         9
+      FM_NPI[11]              mEMAC9          8
+              n = 1,..8
+
+      FM_EPI and FM_NPI are located in the FMan memory map.
+
+      2. SoC registers:
+
+      - P2041, P3041, P4080 P5020, P5040:
+      register[bit]           FMan            MAC             cell
+                              Unit                            index
+      ============================================================
+      DCFG_DEVDISR2[7]        1               XGEC            8
+      DCFG_DEVDISR2[7+n]      1               dTSECn          n-1
+      DCFG_DEVDISR2[15]       2               XGEC            8
+      DCFG_DEVDISR2[15+n]     2               dTSECn          n-1
+              n = 1,..5
+
+      - T1040, T2080, T4240, B4860:
+      register[bit]                   FMan    MAC             cell
+                                      Unit                    index
+      ============================================================
+      DCFG_CCSR_DEVDISR2[n-1]         1       mEMACn          n-1
+      DCFG_CCSR_DEVDISR2[11+n]        2       mEMACn          n-1
+              n = 1,..6,9,10
+
+      EVDISR, DCFG_DEVDISR2 and DCFG_CCSR_DEVDISR2 are located in
+      the specific SoC "Device Configuration/Pin Control" Memory
+      Map.
+
+  reg:
+    maxItems: 1
+
+  fsl,fman-ports:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    maxItems: 2
+    description: |
+      An array of two references: the first is the FMan RX port and the second
+      is the TX port used by this MAC.
+
+  ptp-timer:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: A reference to the IEEE1588 timer
+
+  pcsphy-handle:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: A reference to the PCS (typically found on the SerDes)
+
+  tbi-handle:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: A reference to the (TBI-based) PCS
+
+required:
+  - compatible
+  - cell-index
+  - reg
+  - fsl,fman-ports
+  - ptp-timer
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: fsl,fman-dtsec
+    then:
+      required:
+        - tbi-handle
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: fsl,fman-memac
+    then:
+      required:
+        - pcsphy-handle
+
+additionalProperties: false
+
+examples:
+  - |
+    ethernet@e0000 {
+            compatible = "fsl,fman-dtsec";
+            cell-index = <0>;
+            reg = <0xe0000 0x1000>;
+            fsl,fman-ports = <&fman1_rx8 &fman1_tx28>;
+            ptp-timer = <&ptp_timer>;
+            tbi-handle = <&tbi0>;
+    };
+  - |
+    ethernet@e8000 {
+            cell-index = <4>;
+            compatible = "fsl,fman-memac";
+            reg = <0xe8000 0x1000>;
+            fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
+            ptp-timer = <&ptp_timer0>;
+            pcsphy-handle = <&pcsphy4>;
+            phy-handle = <&sgmii_phy1>;
+            phy-connection-type = "sgmii";
+    };
+...
diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index 801efc7d6818..b9055335db3b 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -232,133 +232,7 @@ port@81000 {
 =============================================================================
 FMan dTSEC/XGEC/mEMAC Node
 
-DESCRIPTION
-
-mEMAC/dTSEC/XGEC are the Ethernet network interfaces
-
-PROPERTIES
-
-- compatible
-		Usage: required
-		Value type: <stringlist>
-		Definition: A standard property.
-		Must include one of the following:
-		- "fsl,fman-dtsec" for dTSEC MAC
-		- "fsl,fman-xgec" for XGEC MAC
-		- "fsl,fman-memac" for mEMAC MAC
-
-- cell-index
-		Usage: required
-		Value type: <u32>
-		Definition: Specifies the MAC id.
-
-		The cell-index value may be used by the FMan or the SoC, to
-		identify the MAC unit in the FMan (or SoC) memory map.
-		In the tables below there's a description of the cell-index
-		use, there are two tables, one describes the use of cell-index
-		by the FMan, the second describes the use by the SoC:
-
-		1. FMan Registers
-
-		FManV2:
-		register[bit]		MAC		cell-index
-		============================================================
-		FM_EPI[16]		XGEC		8
-		FM_EPI[16+n]		dTSECn		n-1
-		FM_NPI[11+n]		dTSECn		n-1
-			n = 1,..,5
-
-		FManV3:
-		register[bit]		MAC		cell-index
-		============================================================
-		FM_EPI[16+n]		mEMACn		n-1
-		FM_EPI[25]		mEMAC10		9
-
-		FM_NPI[11+n]		mEMACn		n-1
-		FM_NPI[10]		mEMAC10		9
-		FM_NPI[11]		mEMAC9		8
-			n = 1,..8
-
-		FM_EPI and FM_NPI are located in the FMan memory map.
-
-		2. SoC registers:
-
-		- P2041, P3041, P4080 P5020, P5040:
-		register[bit]		FMan		MAC		cell
-					Unit				index
-		============================================================
-		DCFG_DEVDISR2[7]	1		XGEC		8
-		DCFG_DEVDISR2[7+n]	1		dTSECn		n-1
-		DCFG_DEVDISR2[15]	2		XGEC		8
-		DCFG_DEVDISR2[15+n]	2		dTSECn		n-1
-			n = 1,..5
-
-		- T1040, T2080, T4240, B4860:
-		register[bit]			FMan	MAC		cell
-						Unit			index
-		============================================================
-		DCFG_CCSR_DEVDISR2[n-1]		1	mEMACn		n-1
-		DCFG_CCSR_DEVDISR2[11+n]	2	mEMACn		n-1
-			n = 1,..6,9,10
-
-		EVDISR, DCFG_DEVDISR2 and DCFG_CCSR_DEVDISR2 are located in
-		the specific SoC "Device Configuration/Pin Control" Memory
-		Map.
-
-- reg
-		Usage: required
-		Value type: <prop-encoded-array>
-		Definition: A standard property.
-
-- fsl,fman-ports
-		Usage: required
-		Value type: <prop-encoded-array>
-		Definition: An array of two phandles - the first references is
-		the FMan RX port and the second is the TX port used by this
-		MAC.
-
-- ptp-timer
-		Usage required
-		Value type: <phandle>
-		Definition: A phandle for 1EEE1588 timer.
-
-- pcsphy-handle
-		Usage required for "fsl,fman-memac" MACs
-		Value type: <phandle>
-		Definition: A phandle for pcsphy.
-
-- tbi-handle
-		Usage required for "fsl,fman-dtsec" MACs
-		Value type: <phandle>
-		Definition: A phandle for tbiphy.
-
-EXAMPLE
-
-fman1_tx28: port@a8000 {
-	cell-index = <0x28>;
-	compatible = "fsl,fman-v2-port-tx";
-	reg = <0xa8000 0x1000>;
-};
-
-fman1_rx8: port@88000 {
-	cell-index = <0x8>;
-	compatible = "fsl,fman-v2-port-rx";
-	reg = <0x88000 0x1000>;
-};
-
-ptp-timer: ptp_timer@fe000 {
-	compatible = "fsl,fman-ptp-timer";
-	reg = <0xfe000 0x1000>;
-};
-
-ethernet@e0000 {
-	compatible = "fsl,fman-dtsec";
-	cell-index = <0>;
-	reg = <0xe0000 0x1000>;
-	fsl,fman-ports = <&fman1_rx8 &fman1_tx28>;
-	ptp-timer = <&ptp-timer>;
-	tbi-handle = <&tbi0>;
-};
+Refer to Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
 
 ============================================================================
 FMan IEEE 1588 Node
-- 
2.35.1.1320.gc452695387.dirty

