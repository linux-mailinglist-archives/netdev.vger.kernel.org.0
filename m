Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53B3D694918
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjBMO4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbjBMOzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:55:46 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2084.outbound.protection.outlook.com [40.107.6.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355971C7F8;
        Mon, 13 Feb 2023 06:55:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFjA+hSHEjKtfC37KT+dRZi0EYpN4yxAb9gD2ojc/FJbUgmXmExiu4WuD0RQJhCHZcDUupfhFialWjU1ZHaZ6bm7iB/Tm8FZ8AkuP0cEkGIk9yE26/6rpqH/WGqdvrVxdcBgNBU6loO7lV51sj6/stYsmDGQjpMjNweEpxol7m5co+HJPGTctnHiV6WiQska7fFOtYnh9FqEQL+XxwVvjx80vLU8Ke/LFsv8mwTvsYZwEiTLGHewv/r9YBrTuYqG8siX+J/t6W8dhzoxrHF1FDQKooXSvnLVvAwCKo/D/MMMXodBy/VJ4pBZ3xX4TEf4edvNT1E6N7YrThlELiaDDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tDpQIOargL0QzxHgFfcOPc6+EncnHFtwaAkcgBoyf0s=;
 b=kfkITJiZqY9M7TFBI/sFcFm798nQWh7XRVRJYCWzJUG+LPXYJ6XovXCRpGlDDkqoLz6O1htAptT0f+tDU81F6jDlAxVa4zkp5+oHa9ltBrplSmgdwEPHl0SkcdNpmsMVuR/sR+Nwj6Qu5WIaiu6f7wdzpJCm1rSJrg+Tikh24RxlxcfBUI4grnpDHHyrKEv+vTqZmTaSQwZ/tA2i10SXnzEj7sdw8/LYktnWNKHn5XAO7IeLuFlD6aHNQ6df+JeSgItufrcazkJ+LmWTUmQXw2C08SBo3WS46kj4qL+5R1+Lfky75mIhoqBZPBNgaPR7yCa8SGiKybwhV6Bzaw47PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tDpQIOargL0QzxHgFfcOPc6+EncnHFtwaAkcgBoyf0s=;
 b=VNceYiqZUAC80a7ZTWiIZlRu1er2tKIYrTazBuFQp8Bnvtsdg1IMNbaekkwZ+C3M6WhwZ1A3w/V/j2dm2/T1RYXiL4YDTq3m/uTU9TJYp4rUmXpu4+WWII68rOx8xe5OnWGMl+J9H7NApexGQCTSsgVAPqFjLSy4fDON+15fn68=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PA4PR04MB9390.eurprd04.prod.outlook.com (2603:10a6:102:2a9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.22; Mon, 13 Feb
 2023 14:55:33 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%9]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 14:55:33 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v3 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Mon, 13 Feb 2023 20:24:31 +0530
Message-Id: <20230213145432.1192911-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
References: <20230213145432.1192911-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0156.eurprd05.prod.outlook.com
 (2603:10a6:207:3::34) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|PA4PR04MB9390:EE_
X-MS-Office365-Filtering-Correlation-Id: c334d28d-09c3-4c6b-dd63-08db0dd25b70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 15lpyjreGgx0f63XyLNNmYCOVBKdbtxQCqsxNant5R3K0du3b+inAP0sPXyxtfsZZGSWRcfxiM2X7qz+c3meB5KwRQlRBdIU0Q0S8HdxHjX4cMiq92unxl5O95iIw3kJzo0s59WPQ7/M12N53qVbdQtR2uz3C+WQY2Q0g1bDSR41iBo5mnrdC3Q7fDXsoL0nnh2vYJNfbsLCic3w86H1QLeXN54TeU73NjkNerOcZymKotmLgchcItsrk3Z6OHW505mAe8oPFTKhYXKHOgMWe0IHoDhqL7+GZ4e7fz4VhEC6cEMWZqybJDhF9j+ySIgwOtTn8wFAmDt1vYDvrxSflnAzx9x1lL13vnYkrGtpA4nBU4QMPttsr3aeFEAt/z/RQ1QTFiNKDTNbqOANGNJo1l0JzF4lYGZXzNWVEWb3Dtba/Qdi+BjlfjrV+VtOdOmAOafYm6WpwPrv2eqoclvkwDPUda8Wi49JhOf0mXInOcL3obF6jZMD1jXVIyHoymJIMRXj5pF5479OU3J+W3KZh/o+nEAMANkPFBbk/O11QB5oIATNHqaJ9c5Alfv7RwGDYf9NRcYBUNXIjAjwnh+OuF6XJIH7UJuHaAZjoSzLzFFAeCe0d2/V1LsAnV6SujOuEMy3HDkWCUcf+pCde56rqvB5rTjrNAgZGn34XR/2mldY5cPmIH1Ro30j2uECMnsI0AJXAsQKE6fwL34DXKJtLuQsT9JTzYE6xJzvMPld595mAniSFtAsdwKqVaaBIw0zlKnTKLWT/LDI753BGdTtA4ow3g3z/T1D5ig9Ml/2UY0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199018)(26005)(186003)(921005)(6506007)(6512007)(1076003)(86362001)(478600001)(5660300002)(38350700002)(38100700002)(2906002)(2616005)(6486002)(966005)(36756003)(52116002)(7416002)(8936002)(66556008)(66946007)(83380400001)(4326008)(8676002)(41300700001)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xdly/qmmUA87pg0MgLF9BwimhQ3Ej4Y+tZfCu0dsY5dSaQ+FMVt+owNnKxKZ?=
 =?us-ascii?Q?AvUcQvvKQgyuOrnAQadW+LLZnbCn132qS/9UdM1pHEeQQptA8f9OvZbLW8O6?=
 =?us-ascii?Q?nrN07h8ACY/69dbnawd4cjV/w5AEF4K2+pXXO6CascMa+zsHrH/GQA6vIREz?=
 =?us-ascii?Q?dmSwkQcybc/mewdAWxM+XWMPMmNwZTdbAIC9dfnp6V/rWylhWz+cPYAKSCrd?=
 =?us-ascii?Q?x69edNT8MKFo1wWuD8CexEBePEg5je0yiEo62ZrhoTtsZFEJEL6EwcrgBb2f?=
 =?us-ascii?Q?fSH15IaZJ/i4DVcr12kSvGWOGlj4Yu5u514XR4h/bOhCmHC86YraWEC+ftdZ?=
 =?us-ascii?Q?v1KGJJt9Yqnq6kQ9hmWHUYLgxMpBWCLG9bs8zIsRLJBcroJ8Nwvuu5ug4N5k?=
 =?us-ascii?Q?5910FeL2o4za0JlieTJHFfyqU4E4h/yih5goOA0xZtzOApbkwbLDYcDeMIjR?=
 =?us-ascii?Q?CCmkWMm+luwFwEhC4hPlf8zQrytJyWomOp/s3Nj3Md4MEmkQFrAebohEujLZ?=
 =?us-ascii?Q?ORT9elx9wpG7AhrbqobY+Bmy+QzAeQFXbOXoQtMggm9RHX/eTKIK0lBnFrrR?=
 =?us-ascii?Q?PlARvdUeJkNi+JvOHN5sieNrAuNmNx1SFUKgEXxlU091KRs2ajjVR+H3R7yV?=
 =?us-ascii?Q?jOAOqhZyhzfiCZ5QAOzILo12eLjndWuli2BCj0vMyZshzr5pKoKToK1SK8aF?=
 =?us-ascii?Q?jSIVMf368C1gLjHhVuVt5bHVjaZ7M8lYQPj797FjVwKgS5959jcy35RkSLL6?=
 =?us-ascii?Q?GtCrB4p5bKVh5I6xeasNOFBNj6U4uq2aW7aAqYkihyzWsQ6m8VG+hLJSW5pd?=
 =?us-ascii?Q?+ZHukUQKXeAl5NI9HlUFX0IHIm/nlakBfZLvn7xvMvcap/6BWAG5sIt902/d?=
 =?us-ascii?Q?vw3mYEnygws858ZKDoijSEQFxMBKVTGEHwUPixwH81acaKS9A2pITQFW0GjH?=
 =?us-ascii?Q?HEw0CbiQgKOZY8IQDQVkx/cwinZEwPS29AxehEw921OU/hfQZ+fQGuwQMeBw?=
 =?us-ascii?Q?P71nO63t/W3MOhGPWdW1irpPVWoYFwc7+rcYif7Wp09OHdB6fyY+ISq9aXGS?=
 =?us-ascii?Q?1M0F2sKEVYeoAwyZD2vMVBd/CnP5ni+NIxEu/96Gc4veeVlEPOaYLBLOeUhs?=
 =?us-ascii?Q?T5VOn/Kc19ZjFMAOVVYWnsSGA2v/2brsBaYyd+LLH+i2ny+Feym9+Rt6jiJO?=
 =?us-ascii?Q?BvAie5Ve2hRbWAhMcYt6H6XtxYVBLFvoUST3ZqAj/OSs+f6QieBzKqkerusk?=
 =?us-ascii?Q?9VB9xzQ3RHUcFM9KAhrnZzkNLESPBytZtoDo2JUkd159dLCx5Mr60TwaaE0h?=
 =?us-ascii?Q?tyDku6e7KdpsoSs5m5ZauZI4+bYofhMs9ush/6pWKdDk0ljnLRmVVEX+MFly?=
 =?us-ascii?Q?/V0PiOq/lGWzWtlJioRYAVCTvSOjqHPxuqAoaHtAnSR3AWFEgBY7apSFFBdR?=
 =?us-ascii?Q?CqaF4RnD8ROWJFZ63JxFj/naUYZwlMRpoo4Ja5OCMFKPS2niHUawv3pzJwMt?=
 =?us-ascii?Q?asaH47vYpRkl8VOrJ4lZlyqluyUzB7EUul3on6fcVRgTsevfFpdwMLTrFhI3?=
 =?us-ascii?Q?7Owo2Ce12ildKStjBlNOM2d0vraZMf/IghZvJPZh1XZdsW/L2wWL+ZrvV59B?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c334d28d-09c3-4c6b-dd63-08db0dd25b70
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 14:55:33.3817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGzlIMbS4Z4tPsEoDu6gV6qbj/6R1alwhs4bvrslWuGEm1lE+mQMzVFfTDHlskqFr3c2XJL/8H/kM+5flWZRzYZpQRg9u6h1E8ppNTLGonA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9390
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for NXP bluetooth chipsets attached
over UART.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v2: Resolved dt_binding_check errors. (Rob Herring)
v2: Modified description, added specific compatibility devices, corrected indentations. (Krzysztof Kozlowski)
v3: Modified description, renamed file (Krzysztof Kozlowski)
---
 .../bindings/net/bluetooth/nxp,w8xxx-bt.yaml  | 44 +++++++++++++++++++
 MAINTAINERS                                   |  7 +++
 2 files changed, 51 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml
new file mode 100644
index 000000000000..2685f6d5904f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,w8xxx-bt.yaml
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/nxp-bluetooth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Bluetooth chips
+
+description:
+  This binding describes UART-attached NXP bluetooth chips.
+  These chips are dual-radio chips supporting WiFi and Bluetooth,
+  except for iw612, which is a tri-radio chip supporting 15.4
+  as well.
+  The bluetooth works on standard H4 protocol over 4-wire UART.
+  The RTS and CTS lines are used during FW download.
+  To enable power save mode, the host asserts break signal
+  over UART-TX line to put the chip into power save state.
+  De-asserting break wakes-up the BT chip.
+
+maintainers:
+  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - nxp,88w8987-bt
+      - nxp,88w8997-bt
+      - nxp,88w9098-bt
+      - nxp,iw416-bt
+      - nxp,iw612-bt
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    uart2 {
+        uart-has-rtscts;
+        bluetooth {
+          compatible = "nxp,iw416-bt";
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 32dd41574930..211fc667c0ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22835,6 +22835,13 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+NXP BLUETOOTH WIRELESS DRIVERS
+M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
+M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
+F:	drivers/bluetooth/btnxpuart*
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.34.1

