Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9CD68184A
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbjA3SGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:06:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235958AbjA3SGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:06:44 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on062f.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35CB13B66B;
        Mon, 30 Jan 2023 10:06:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKTBZIXnTbyN8QW8cAffiXvvgvrQjRtVxDJ9anXdIPmD0ylDqvev6FEGGkcaOq7UwxW+WJH1LDVyiM+wBlwLmYXcj5UpOtRjps+4Tu2658wvNYqGEYiOfsYrMng3ovf0b5OsJ7aE/MCcODrEFIxqtua9fsAtyN6Pk6njm3o3hhwwRlEXDdU8iu5urE0zWuL8gZwVZzFoW1/kFfx41chHySlVWteu1l8rKw6apFZ04Euc08h8f+GtvY50EI7RRuykQ+Vgth0SAKOOas6c2q8NzbUxTWcMFkwRJrTmR87fB/T2kmDxx9cZhd/QbkcBK/2wXvWtddZvOjvFoYcTfuv8+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XVxl3bbeiXOKyr94YhciPxo7/BUCyaK7usO4CrN6c0Q=;
 b=mIvejRYatmhJUnhZv6jm6WIrfxWWCls5H9zZuEVjoUlRJquEl6zBt3keADopMkomK8p0S8+Ya2ZvydsWKw9IuFxJAWIOZY1C5p+jkBMNWFI1lYhIcwsm+m9DLtwiw3AfTAvwhCTjv08Hdfh8u1G1hmuO/Pta24aJvcwe2kKq0B2sEI0w5bhnbhiMUK7J3Cpek5eYJlLIc53s9Rft6kL8o4PMeHosPdk0rI+r1BY24O+Wo9kqxYbS3PyWmgEBv8hrhfwo/Tm9wLHcB94tEhnBo3X8qtG/9C7i7FXSrdPA9MwsneHnTRcIxEzu9wmbTh8OHqH36csTDlUT44+v3B1Vtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XVxl3bbeiXOKyr94YhciPxo7/BUCyaK7usO4CrN6c0Q=;
 b=fKIorcdjgpVe80ONj8+eNwe5QJKQ++tQZzHJrICsdCa1JNjI4+VwbXYJ4j7lTsRhEdI/hrAJek50NIckfzsIjdgM9EjcSigNRYi83iL/Zoriyb0idPgbwdONCxRb+pW9hj1yWgXJ+dFlfuYsiXlRs58eBG3akh29nf2y9zJDz0s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB8PR04MB7129.eurprd04.prod.outlook.com (2603:10a6:10:127::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.28; Mon, 30 Jan
 2023 18:06:38 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::f8fe:ab7c:ef5d:9189%6]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 18:06:38 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v2 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Mon, 30 Jan 2023 23:35:03 +0530
Message-Id: <20230130180504.2029440-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
References: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0008.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::19) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB8PR04MB7129:EE_
X-MS-Office365-Filtering-Correlation-Id: a67a5ce0-2099-4b0c-7e41-08db02ecbb9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2viOQSbAYRIr54AG3OgYN9xWb1S2ZrI8viI2KRMQmlk8MDSozHifENzGc/D9k7pVkDtdEnl/YwRJsEwaWpHcgAeztmgdOumt1asgwE0emsXB/gLJBPYca8mLtvVZ5QzXeyHLwz1DdeoBDbS8V6qFQ8KYBkDFbh7iz8X4Ys6p0SNiQUT+bKj7hBDA8k5ALsmpmfPwiObDxv+E6m7oKDYgYUc7m3XQYtxeruf2tsEQLl+lUammd8EH1o4ykEeeRbNmIaMP+qdajNQ2gF5O2BDkr82ZYxhGcjB1iaeyoIPsHXw9XPYqHHbfzjOt+RIMuSm+f6o9y1TlGMdcSO65oju39DxsNRFdSwbRwgprvqKeCuSPkPH6r59dtygqlVhYBZU4kfNSx6+PYkAHmKR2+00vBxWh8bxFusQFMOn44WgosCxA/9YY+0wee5A/cVeDkhcAflawJtmAJf2vt4+GMVgh3mxb7zB0xUw7mdfHu+i6PPUq6UF4fPOacktBdM2EgONyPcpF0eafIuJe4EFmdBNuNJwQ6bwxjZTozHYiyfwyDMSCLtgOplcWGK2XusMs15kDoeFECRmPKZZZtONhXAw6TpukF7DoWm1VK0PdON6LDog5AY8sbaMoqPFCcC+yoo3YoJFtb3KBB1ZMXEZ4tTkEgK4P9/w2Ltc/OvutdYggWyUoJwghUYT+ooOi+xFGoekwgZStyWI2SBuX7lkVVGk0cyPCg1cbJjxyiOXlaQ2diYS3aFYH9F1B17V3uH6gDDggG/MC83yOpSV3T3qPn5LYxZnUW/KOYHoJQXXGZhSCYF8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199018)(186003)(6512007)(86362001)(26005)(6506007)(1076003)(921005)(38350700002)(38100700002)(2616005)(36756003)(316002)(6486002)(6666004)(8936002)(52116002)(41300700001)(966005)(478600001)(7416002)(5660300002)(2906002)(66556008)(8676002)(4326008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jv2yg+kjnOxt7nMjrFiDtjAUbmwSsRAhDVNK10CAs8h9DXz6zqj8W8cSnI4R?=
 =?us-ascii?Q?V/yd3HD/pBSw9VhD67/Jg2Ywt1PIh2BnR1qvkc7/ZNCBarJFLxTs92TBi9Pc?=
 =?us-ascii?Q?947W9h8qcHL3dohCa1OUCjhl0DNq5ND4Zc5JUA2szoABRm9EPj+vpd+tofh1?=
 =?us-ascii?Q?wgJbyuhfeZ2k2Upzx9ZmyZRwXTcBY4qXxNgvkMYInJl3GFxTjjSmVPZfvhGW?=
 =?us-ascii?Q?KajAFeRfEKrFrIpMKJzWIQBRq+ciDw4ReG7WpGy+1Vo7r5s3KM5wgi9HsQ7+?=
 =?us-ascii?Q?4LhFEG4kbojH+QXujBxkXjYWIoyOvHlmG7QrXXo/q+910DmFbst0P3KRRuc2?=
 =?us-ascii?Q?4YLWsgruG3muWonGUUQNKDFDfq4V8JmLiwl0AGb1pmO3itM7jxxAu1Uifbn6?=
 =?us-ascii?Q?MIvFodfL87lkO1XupZdxcDdjq0dAPOjh2E4TJNSxiZxt/10Hvp+8m/uyHGdU?=
 =?us-ascii?Q?cOkYUw7ch+/wpU3+ibQIs39Ns6Ko8BNe3FJTZVwgiP3iwOm66IOTC2HR45EP?=
 =?us-ascii?Q?KcqYcZ7qBmQ0/Izi6lq/C+pwVa4+kQwIUDHkgDZRlXJAp4Mp7ftx9hJwk/9f?=
 =?us-ascii?Q?8bSCV87NMU2mfchxQJsI8/DfcdcvvF/lS94+gYFqrpgsAbX3g2du8OURW9L5?=
 =?us-ascii?Q?TNGnqyPTV1EdNVnmI9oLBhcJFmqHRujRjOmJzW+lsmyaBRBGo/NzEJvTTJLo?=
 =?us-ascii?Q?RtZ+rtM9EZ8nidT4QaMqnSJbHFF9lX8YL+qfokmwBlVhLteJ2BapXxkHJVI3?=
 =?us-ascii?Q?2hP1rjbhPp1+s/bYyBRh2H05of2R18ACmuGbbN+nyT9j4vrGiFtdSkyEKD7Y?=
 =?us-ascii?Q?FYXDey6YzIo+XMQv79HzswD/ump5VfTtsMnnyKa+JVsE2okMRfy4Au1QJ5EI?=
 =?us-ascii?Q?2NLhCU4CbVNrRB5XI2H2DXYpT9btVz+U6wo/seq4WkO/b+BWpjQscv9YIJuV?=
 =?us-ascii?Q?CHVU2tUuAruf+uWEbWleYv7+SbNK6giPgReg8SxZZDT99phbo1oYDo7qWNMd?=
 =?us-ascii?Q?KROqV+CqAUQDLBjbB2Q2BmRjxMsmXFLVvp7q/Dewz2LjQ9dpAs7+gfCGlHha?=
 =?us-ascii?Q?V3srayP2dwgHHRYgdwOv4p3nBSoQYXsglk1LBPwopi3OD9WeqO6mxtn5aMmR?=
 =?us-ascii?Q?Hnzp/1hn9D4OgVAEJ2UgyWhBp/q8zGt9pOGq4XuMyC8LPcxtf9Que2s5l6qB?=
 =?us-ascii?Q?teMLrfHMo2Q5W+mkb9+1uu7vTOnUU7kiFLbEPUcNPwApbfB+KO642rK2qWTB?=
 =?us-ascii?Q?9xOKzO5Ep2fVfgekpHeyn86oYB4JdBZnSB3ha9uD8JUuKMrx23BL5PaeTsqe?=
 =?us-ascii?Q?HfUrH/4gmarAxQ/8bCMboGCBBjyjKiAvDC20mWMgP3toulQ0vkJwbKbnCnko?=
 =?us-ascii?Q?YFFVOdzsi8o5ftMiqNHjgPRERun62+pa/09iPfFOuoV8YeBXJ9SGx0UZMugS?=
 =?us-ascii?Q?b6kPBeoEzxsCHIlIc05iesLhoiRR/OAhAqIJpbVDaJX63TB2Taff07oUPsAz?=
 =?us-ascii?Q?/N6uUdpNiRqNsOga8TjEUoOpz6OBkulKUDxyqn9GppHNryMX8CJj+SES+Ir3?=
 =?us-ascii?Q?FvT4SRprR+zSLRpi0Tr6V0y4oOfB/oJ1uVIJtHLvexHZCNUT2l+g/tYru9Pw?=
 =?us-ascii?Q?JQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a67a5ce0-2099-4b0c-7e41-08db02ecbb9c
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 18:06:38.8221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lj1Rwhuhs+h/i9Wzs/e09+d9gg2THm3DfgHWi0fJppOLvKacVODa6jqz6RbxbLigjioILp3Wf+Xp7mSZrOWqG/R2XrB+UkGPFjLOAzWdxew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7129
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for generic and legacy NXP bluetooth
chipsets.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v2: Resolved dt_binding_check errors. (Rob Herring)
v2: Modified description, added specific compatibility devices,
corrected indentations. (Krzysztof Kozlowski)
---
 .../bindings/net/bluetooth/nxp-bluetooth.yaml | 40 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 46 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
new file mode 100644
index 000000000000..9c8a25396b49
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
@@ -0,0 +1,40 @@
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
+
+maintainers:
+  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - nxp,w8987-bt
+      - nxp,w8997-bt
+      - nxp,w9098-bt
+      - nxp,iw416-bt
+      - nxp,iw612-bt
+
+  firmware-name:
+    description:
+      Specify firmware file name.
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    uart2 {
+        bluetooth {
+          compatible = "nxp,iw416-bt";
+          firmware-name = "uartuart_n61x_v1.bin";
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 32dd41574930..d465c1124699 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22835,6 +22835,12 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+NXP BLUETOOTH WIRELESS DRIVERS
+M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
+M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/bluetooth/nxp-bluetooth.yaml
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.34.1

