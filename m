Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F746B4FF6
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 19:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCJSUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 13:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjCJSUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 13:20:17 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2065.outbound.protection.outlook.com [40.107.241.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0B7A11052B;
        Fri, 10 Mar 2023 10:20:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nDwq23mJ9GKYZ+x8vOaRFnu2PKcB6uODK7Yo1ubsFQo5tpmlBa+Vmv0JHM2lBCjMOylfr/Nd9mhiNgLm/KHd9HcTi079r0oCAsXb5zELA66ED2NuLzGNHZ0LQ2t1v5JrcWRNMFIalZ2xY29A5MnXUXDciJVdsruD/k4uMCulKx1v2I94ExA8vLC2CwJmN4hd3OdUqjFOmO0B05YnlWfS/GkQTXWLACqm5D+0kM7ETXL5+7+Ls4uxPHLR9JY5uhhBEdX4t1jJjEc77ClcPmyK51McoC/CGNLhD25wWtfTvyj7dyZfIpnGmQIUztUxgC4ZwIAH81yv5ZF/CM2PNJL+FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=eglYaZv6uHeRnSYmkphM0xo6htJIdWOESfC/D3Wro/LSYLamMW1DkRBpvTgqefq6RQpQv3tXplVwKwJPy5myeB6gk2HfP5dOxu6T/BuU7OG69vWnQ3lQbFdaNTDAO+DnTloVtHdZZGxiR47dZXqv8H5eVphwbvrpCJMUrmHZ+2wDlWB5QGMJGNG/ukRajmwhU33if4RKFi4IS/cAXdnkrbfXVAZ4sgCNu3LRlJCT9KbElcSoTkyE4ezbj+Arfn268oeJlB7KeRWTslco+GfZ6p14KiTEVw1CALBfIbAxzaFR+h64+JuiVJWEVTMuukY35F54eziek2wmlFz/JSPGag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=k6GYrFry6h5JKlk/nASOvOUPv+km5f7MACzynAUkPxRmbcskbEwNuMOhoHPEjTnKxdWObjSbmhrjpb3Vb9UrEiF8Vw3QPloHBOWHQnDrdRRLGfOXnhdAcuXtu31sUi2sVMD8VZGJre0wFkvDTgIJwZVXCs28yE+LRtFuQVj8saI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB9PR04MB9704.eurprd04.prod.outlook.com (2603:10a6:10:303::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Fri, 10 Mar
 2023 18:20:13 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 18:20:13 +0000
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
Subject: [PATCH v8 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Fri, 10 Mar 2023 23:49:20 +0530
Message-Id: <20230310181921.1437890-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
References: <20230310181921.1437890-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0195.apcprd04.prod.outlook.com
 (2603:1096:4:14::33) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB9PR04MB9704:EE_
X-MS-Office365-Filtering-Correlation-Id: df840646-2387-4ae5-1cb1-08db21941718
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8pnLQMN4TxexaAQNbhPcAYbH1xu2werrqvhKvk/8izlHmpby4xSlE+gsteEeKVd9+qUgwtU8KUG2WkeDyP+GLuqJNhfWaCzFct28McS9U5l1ZgHL/3ZgvAtWnEfGISswq8nkGQRZ9FDgBlgb0NIFkhkHi0yUky3sJCmutGmjEQwREYGAV4lI3ZhIzWFpAqYwcDdbcOBaZHYvq//vsmvhLLJe+AhbrA+RHXRDL+1xGlxh2qt+vWDS+q5aGT1JKEHHLNpwlxikIuSGJVC6DunFz567mVWE8PaR2+0cyYHahmyz3AdDSlHtASyHA/w/A3jUSw+uWXML9zbzgtychiB9V4f7viihdllwaFf16ySFQJeHPUKP7NOvgc0Yms06IDrbJ4VvF7ZQWU+ElSDYVmkLDJMeJbI+sz3C2cDHL6k9OlFzdBRwzts6UND5i2gSQ0a2nwoDWBOwh+HM86cdG1po91bMBU22iLBe82JWRCtk3topGRcQIzhicuhZCk/oyi59khEWOREcYNUxoOYRRu+qAOesslFGpvxxNnMZH0+bET+IOxGAN/RYqRAZ3wdzF6I+z2X7rmW79vwDPeRgtk7wZm3YaM41A3YsqkJoBMVyZo2YPcDMDncWghCjeiAOeLAV/1YRz70xbP92vgE+Oo5cLazvMovdns+BdPWUe9x1ICCEDVAd8V1yDO4P8BNKwV8JxNZHTzaDgntsLE+95d0gRAInC6P4Sg8p0SpZ769ExVL7e1h/mYSVltD9MMmgOsJy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199018)(66946007)(66476007)(66556008)(1076003)(6512007)(6506007)(316002)(38100700002)(26005)(8676002)(36756003)(7416002)(478600001)(6666004)(8936002)(2906002)(5660300002)(6486002)(921005)(52116002)(86362001)(966005)(83380400001)(4326008)(2616005)(38350700002)(41300700001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vXBkZDloFn1LJaxg2wvR9Kn4sGxfEtCZq8WIAbwg0YWi9/+vt/vFC7QyiwTa?=
 =?us-ascii?Q?Vq4UKkVLnvRz6mxPxxf4mZoXjN7XwQWAlTdWzJHNkHzMr6bqKHDnN8eeqjDo?=
 =?us-ascii?Q?n7lddYJYMXnmLiBa7x+8k8Vz7K/Q2JD+q/HD2U7jzBxClBmGWt8eGHzYmzSB?=
 =?us-ascii?Q?GilyCNl9hV82qmQmFTXH4uMmQ2hSQT4TBKuj5A2Idwk/NS5FeD9rpRAKe0Me?=
 =?us-ascii?Q?xfmY7VPT5bX4Om0Jv9/bkvEVnp1YjbI3AHe99qF7izdStb0/37yVCZsCDp62?=
 =?us-ascii?Q?+zJ/yBcjAnC2zDGJJoE4f4ITfODWiMSxjPmr0dq2K8cogk4Qg5pH6V55jRWl?=
 =?us-ascii?Q?Fr3nTyUKsASlSsxcaXSMWINLwIw2S69Pxks1GRZiww0LxLfDvSY7s/PEwMOx?=
 =?us-ascii?Q?X0YUZZdALGC6lL+Kswhner4sRXpCcUS/lyHGrhwwMXRJm4JGuk6rihHv7YMM?=
 =?us-ascii?Q?Van5ZtSMyd2bhqFbLK/cDaV8aVK/eZZQ3IPhcS4rVu8OtTKh8TLm1q/oO6DJ?=
 =?us-ascii?Q?RjIZ4ZYYypskK+Y4pBvFBaySctco1gy/PbKi1bI5DrpAg8YPT+0LDJYq/tOj?=
 =?us-ascii?Q?cUqqb+XZDslwnKbmXbB5r2LuAgdr1ZCB4vx/A4RGQdu7R7aOImlxNmbNGDIz?=
 =?us-ascii?Q?iseHgCGXBqQK/Yy/wdQh25hCZ4E130USN0WXC8P00zWb7fJtdcSC435/L5Ou?=
 =?us-ascii?Q?xFI2J7BK8EQym1SN6Mmlc61CY6Q1GiWFgCyYHVyh8gWOiV6a17gsmCeShxcX?=
 =?us-ascii?Q?1GUT19j9/jXatl+SGxlb4UKmDXaQ/Hgah/aI0TOpdW3ZI9di7+o9VlayC13l?=
 =?us-ascii?Q?lXcEXcr3al86gdT19k5WjLEgQxJeAK4/P6Km4ZkVpONifiHxabTF1QJq6/Nz?=
 =?us-ascii?Q?gftyvdL0MtEp4+6ZTXfCPNFWrVq6InVzf3Xw7KkoWtAvlZvcMSh8/ZkOE7EE?=
 =?us-ascii?Q?/pYQOZEjDzSsUyTFCJlqwbEFmJ/jZgJ2yJGt9lbDoxCEcWROztF9ptpWENlu?=
 =?us-ascii?Q?uj2MxVNkzx9NzbjUxqHisgGd0czDlvU4B0fEe5vcTyME8Zy5U6yH50BTfP99?=
 =?us-ascii?Q?bvXkKEG7IinniLBad9xV/smcmnoY83TZ495KKo1Rvqnyg21NFQ9FE18xxGFV?=
 =?us-ascii?Q?6El+4oLTIbADedJf3bZg3mknT628ryK1+PLq4xzDkrIAe71PHAepcg2D4i/z?=
 =?us-ascii?Q?BpxIXNsUiRPmUxDB3rJzGC8OqfIfu1dK/HbluPvwaB/1VNXQF15DqqHgUDH9?=
 =?us-ascii?Q?V2Hl0Nlk82MX8CTacFT0SjNfwrwneQkfhHMOU9mJ4pay0duNOFq3EPVRVGT5?=
 =?us-ascii?Q?dWKR9IDmTVLTVptNoW5tpF/0GVTDnjOOpadSA+uf7tiL4prOeC/UpDYsNxcT?=
 =?us-ascii?Q?LejOv5zhJquIns9Q2O4zm2nCYoJtbwr2hAYkligFRYNTEG1aKVXi4Dlbm28P?=
 =?us-ascii?Q?9Y56ZXh3KnHGssyILU1zfBF6GbUCVHJCbSBmmeHY8K+MXGUHi/wxJ22f87NE?=
 =?us-ascii?Q?AHxy5j8vrfqnvjbVO+TlHpV5KoAeXr6i6X0sA0KY8NFYxin9ki31ZLU9/zsm?=
 =?us-ascii?Q?uTue/2ay4781uaDjPyJk35uyBFJVsx598OUZaYcHsnPk7U3WflSLYHEc7NZq?=
 =?us-ascii?Q?7w=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df840646-2387-4ae5-1cb1-08db21941718
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 18:20:13.1420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LoA5z5/x+UBKWdvrMax05ytgy29muHLFBymeni/QTp4aOKArowbsbHWVCAx0lE5bU3nDYWno07Ne3BhnhuXh/bc7cvYJSwDdus4NuanXfuc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9704
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for NXP bluetooth chipsets attached over UART.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
v2: Resolved dt_binding_check errors. (Rob Herring)
v2: Modified description, added specific compatibility devices, corrected
indentations. (Krzysztof Kozlowski)
v3: Modified description, renamed file (Krzysztof Kozlowski)
v4: Resolved dt_binding_check errors, corrected indentation.
(Rob Herring, Krzysztof Kozlowski)
v5: Corrected serial device name in example. (Krzysztof Kozlowski)
---
 .../net/bluetooth/nxp,88w8987-bt.yaml         | 46 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
new file mode 100644
index 000000000000..b913ca59b489
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/nxp,88w8987-bt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Bluetooth chips
+
+description:
+  This binding describes UART-attached NXP bluetooth chips.
+  These chips are dual-radio chips supporting WiFi and Bluetooth.
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
+
+  fw-init-baudrate:
+    description:
+      Chip baudrate after FW is downloaded and initialized.
+      This property depends on the module vendor's
+      configuration. If this property is not specified,
+      115200 is set as default.
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    serial {
+        bluetooth {
+            compatible = "nxp,88w8987-bt";
+            fw-init-baudrate = <3000000>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 32dd41574930..030ec6fe89df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22835,6 +22835,12 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+NXP BLUETOOTH WIRELESS DRIVERS
+M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
+M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.34.1

