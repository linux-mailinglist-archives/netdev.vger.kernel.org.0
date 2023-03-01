Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FFA6A7026
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjCAPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCAPrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:47:11 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2047.outbound.protection.outlook.com [40.107.247.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA9A32532;
        Wed,  1 Mar 2023 07:46:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IFB5FOpOyPwhHMmQ9M4B63V6u/d4lN2NSqSa4rncgDovKJVl14H7IhWCGldLKgIe+rXJe/+k3TbKcCDXt7/8AZxUBp7IRJNN/Np0DJDs8CKl5rfrmPZLNmuQNKKtbvMDB33ArHNAFS9/l+gbgCw/uSUYfjBmVNcxIx5+98tnp94afkPaB3aMzF88XFVf3y4nWcFzcHdX9fq8psMI7GG0p5EDS+IEF2Is6MFvectOJPo3QtFOoGju/BrWaEhJ1R0nor1YxuHTMby0UEU9UUtT42kJzw3qAIUQiH7iUna/3pCiE6Wq9XCdQw35YRHUlSIEq2Z/2Ys1TfIliZKaZy2B+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yMY/K1Gv+1W4jMLe2SfLaTVrSuqdWa7s1+SZ99GJyiA=;
 b=XNDOI+DLOEOg6wwRPaSLW73hmEcoIef60THMfb17ru5kNZqZELTwuFletZIzkG2pxm4XlfOAc4F0GhWTnsF2uIk/Zjo6QgjrGgSIamOm+azstWLYxpKiQAMatBs8mDx4m17lq3LZe0pRUuD69CpI+kDWBGt6mAfieQt4DOr/f4pVJeF8PVqTWsnBm+dT8OjAQI9Riw/UynCm5iVHydXVUJbWi2e1LdiZ8239CUgnB0i2WX//BaFPTXHChBOIqgFaRhNgWebhsnYYVfgAsQ4EtJM6BnYy4SwWNA8Sl6L6pcONr3lpr3Oj6RjN7quhVL+XtNjXm9MYqmup0GAOR9/G7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yMY/K1Gv+1W4jMLe2SfLaTVrSuqdWa7s1+SZ99GJyiA=;
 b=h9VVypgVrD+V0IZcZRGtTNjlg9yTe7WjskxBjesEmxd0YjcF6Z5Tzbde8Pv/cvSdKrmvdHbXd06Wpk8tBOo1xOHg6nFk+sf6KDGeWbVA7jAp8aY3yCcM8tSWY2o8u/yiIrL17IThukg/Iq5rwfjEY2ToGBun2WTXlwZDc3SQhpA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU2PR04MB9129.eurprd04.prod.outlook.com (2603:10a6:10:2f4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 15:46:13 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%4]) with mapi id 15.20.6156.017; Wed, 1 Mar 2023
 15:46:13 +0000
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
Subject: [PATCH v6 3/3] Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
Date:   Wed,  1 Mar 2023 21:15:14 +0530
Message-Id: <20230301154514.3292154-4-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
References: <20230301154514.3292154-1-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:208:1::46) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU2PR04MB9129:EE_
X-MS-Office365-Filtering-Correlation-Id: eec002d8-c2db-4079-74fb-08db1a6c160e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSxm62e974XfRVoPtkApvNDEcZme5r3kzip6LPwIUlFIho8fMarDCSbJ4ePLDtIHC1PV5SzYaVMZi6LU7w1yd2QWWbIBIamkeRNWketKZw+FyItGjrATBJyic/vBu5S4zAJZX2MVcIzeI0HjMzsLIUAnRuuRAgBzcuzudd9mG2qycvPPo2pH9X+Dsx/PX9gvliaUdRqpphtCNybOOA6QsejzPUGR0uYzXsF3iufRb5ubXo1R1kjfb8Pcvb9TptX1EBmMDnRxN8Y3asYFqaaC7TiTqynpwNb1HJuU4jl6GMihFiqDlVUV5BxEO9FMPWi+aLKot+k54c5iSqW3Pzv94v3pvRQuotkZz9m0JGf0mnli71QZ3smneYLy+zamRVNBPNp9jBN8LViWBKhzmv67NcMrQqqg0M03PxKBq4h0+7fRDcumY5sDkKJuKyr9JnFByBX/2tQv6ChjtfcWh4F00VylrEwZtqAHQ5IiFsomciaMIQV4Irg92VjBnjjjzIzdHT15+czaCJLuDwkz8+ZiCLSK8IlaNfLSWaT0njS5lWtwZHUzHPBoU9u9s82xvAcTmPfi81u+uNgTDrQrYDK5Q69kYJPjqlQNFQaVZXhEDC60CNaxPaBQovk2vOa/kV0Y1y9aCIqWIpLsxUVlbING45dtCFVdBsIROj8DO1q8o/WdC7TLkA7NZEUk0t7BuXxJ4wspnXU9ET68DZkDsy6UgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(396003)(346002)(39860400002)(451199018)(38350700002)(38100700002)(921005)(41300700001)(86362001)(4326008)(8676002)(36756003)(30864003)(2906002)(5660300002)(66476007)(8936002)(66946007)(66556008)(7416002)(52116002)(66574015)(186003)(6506007)(1076003)(6512007)(83380400001)(2616005)(26005)(316002)(478600001)(6486002)(66899018)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTJsUUc3WUt1K0I5Y1QrcXpMb2tKazZLUDZQQUdBUnBiejNJaEIvdThNYTlN?=
 =?utf-8?B?MWNjYW1sdi9TeWxwUm9VS3RyYmltYWora1hUY0ZQRHIxTkREQ0k4Z05hbjlW?=
 =?utf-8?B?RkRLTVJJVXRjYlQ1MzF1bEJjdEx0elpQeUl4MWt6ZGR4dzVQZmdHOVZmUWNx?=
 =?utf-8?B?UDRHZDNIV1RONjVoRkdybUVNOC9kTFljcURuOUxpcjFNOTI3dThoaUpHUFhQ?=
 =?utf-8?B?dzZvSUdESU5oYWx5a1RBSzFqSWlkVVpwYUhsenB0b3ZFYnFJMnc2UjMwcVhE?=
 =?utf-8?B?ZGk2OUxuNDM0TFFyWkV3Q29yUzZIREw1Q1hNZmZ5NFBtZVJHZHhQYVRZM2d3?=
 =?utf-8?B?RWlSdFpJUUZ0ZitwZ0VqWlpoaDZWOUhaZXFrZ0RlL0VOWExBVzRDV2FQTldU?=
 =?utf-8?B?cnM1eENFRWlmMFJta3Q2RVk0amlBaEtNUVNTM1ZpYi9PK1hDOHZQOEg4bVA4?=
 =?utf-8?B?cjRnLzErK2N5ZGt1RC9qT1BHOXE4TFQ4NktGR3hMbDNrT0dteVNTdE55NE00?=
 =?utf-8?B?cE5pcTkwU0dWeThENFduazF4amxpV3c3S3JNNnFhRkQraVVpQ0JQMThJanZB?=
 =?utf-8?B?YzU4Q2Z4akNPQ2V1d2IzM2Y4cVRNQitlVWZSTUxaQzRxZG5yTGJ2MFc5OEN0?=
 =?utf-8?B?Njl3U284dGxyR1VzR0ZSdW5aUHdSaG41Vm85Zm5KNTA0TXVTYVlQaThZM3hF?=
 =?utf-8?B?NTFqL081MkQrYmx0OFFwWlB2YlRJajRKSUVySXk5N3AwNUVPSGI5QkIzUXlR?=
 =?utf-8?B?cldyamQ3bmE3VmJOWmFHTlpFUmIzVDYzeG1HcDE1UWMyYml6cWxpQ25rVkNK?=
 =?utf-8?B?dkIyVFMrQTh2SUs4bnI5dmUzYnFpaFAzNWJXckR4MjZhQlNJYlBIaUFieWNn?=
 =?utf-8?B?dVVtUzVEcEp6aDJnN01hd2tveWh6TkY3VDh2TDF4TlI1TWEyQmdwY2JWWUZq?=
 =?utf-8?B?blVBcjZidVZmZHozekgxWHBmdVVkbFVSMC9hZEw0RGtqUEEzY2g4c2h0c0ox?=
 =?utf-8?B?eXdGUmZDU2VWT0k1VktPVVhrN3NaWjV0RjgxZGxJOHhRZDdMakVOV2Rpc3dy?=
 =?utf-8?B?MkpJMFdQTXJtcWxaR2NGaVF5WTFZekRMRktOTGNoUmxDc2JZNTZMUHAvdDh5?=
 =?utf-8?B?a1hFcTNiYzIyb1kyTDhsZlVwWXJNUnZkOVZGZzVmMjdWbVhjenN5UGJxa3l6?=
 =?utf-8?B?Q1JWYm5CZ2Q1TW5uajd0ODhMZjV5cXlOUHNac2FYNFMwaWZTazRmeW8rd3BG?=
 =?utf-8?B?V0YrRzRvclZBOUNjcVBoS0ZLVEFLVElLTTBFYklDV0pwcVV4a2FOSGlaTnJW?=
 =?utf-8?B?eDIzUUtDR2RtTTBVdlJYZHY1dGJEWG5ja1J1Y3B3L1FGV0Z0bFRSVStDSlRI?=
 =?utf-8?B?aC9MTXR6MWpsbG1HQnRIaThqemtYQmVsa3dVRUJ1SmRTR0hHYTFCSUwrbmJn?=
 =?utf-8?B?VmlXRjU2SStuTUVFS0NVT3M3TFBtSVBHLzVwYzNDbTVRanpIQTlJWEZ3blhE?=
 =?utf-8?B?aWZERmdic3pDZmZuNUFUWGhzQ29HOUoxZFp6c1RxSVFRbHFWem8rWk1KZEdh?=
 =?utf-8?B?aE5qRzI1bU5EcWJpbTRMUkVtNVh0Zm54QTNHWTl0MnIwQVZYNkUydnhDWlY0?=
 =?utf-8?B?RTR2S3JoeGlraVlLL1I1QnF4V05PamZ4S3BwUmtFb1FqeSs2R0I0MkFnb3gv?=
 =?utf-8?B?OFRMRjEvbWREbVozOXVSL1YzaUNidUwvRUQ5MFdzU0Fxb01kQk1JQTJuV0Fq?=
 =?utf-8?B?eWx5N1ZXZ2dzVi9KZDZ3QnpieHIya2UzMElwd3QwQU5FNTNZaUhaSlJMV2o4?=
 =?utf-8?B?U1hEek9ZNXVCVldWcUc3MjNxc3FHTVhvT2FwdjVDdThmS3pWVTg0V1ljdG1X?=
 =?utf-8?B?THVjZDZWczZVRk56WlZiQ2h3dVJycy8zRm9LazZzWmsxekxCSUJGakpXQXV2?=
 =?utf-8?B?Z2JVOXk1TjN6cU9zdjcydDBJOG5HdGVVYm1vb3YrTmhCYzZsVjkrUGlxdldF?=
 =?utf-8?B?VkdoM3BNZ2VUdUZlYkdCVURXUDdpY095TE5QL1lRT0RNa3JvSHVVNnFSZndy?=
 =?utf-8?B?U1pzN1hIUFRtMWM2ZHkxbHcyMUxrc1R4WXZRN3BheDlyNVZlMHl6eDJMM1dm?=
 =?utf-8?B?cERXWXIzVDZrRENYbXNZV01nNHc1b1dpdWttYXdQRitOaXRMT0hSR0xKVzdo?=
 =?utf-8?B?SXc9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eec002d8-c2db-4079-74fb-08db1a6c160e
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 15:46:13.6423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iL39D9JV/f4z3Dfj+hggy3PfzvsGvvgc+RNSDk4B+pr1z25OXF++VNiiH6jE7FPS2rCGOKkibd+WZT/GnNKjb3JW7G/zgCBg3LTzJSEdbmw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9129
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a driver based on serdev driver for the NXP BT serial protocol
based on running H:4, which can enable the built-in Bluetooth device
inside an NXP BT chip.

This driver has Power Save feature that will put the chip into sleep state
whenever there is no activity for 2000ms, and will be woken up when any
activity is to be initiated over UART.

This driver enables the power save feature by default by sending the vendor
specific commands to the chip during setup.

During setup, the driver checks if a FW is already running on the chip
by waiting for the bootloader signature, and downloads device specific FW
file into the chip over UART if bootloader signature is received..

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
---
v2: Removed conf file support and added static data for each chip based
on compatibility devices mentioned in DT bindings. Handled potential
memory leaks and null pointer dereference issues, simplified FW download
feature, handled byte-order and few cosmetic changes. (Ilpo Järvinen,
Alok Tiwari, Hillf Danton)
v3: Added conf file support necessary to support different vendor modules,
moved .h file contents to .c, cosmetic changes. (Luiz Augusto von Dentz,
Rob Herring, Leon Romanovsky)
v4: Removed conf file support, optimized driver data, add logic to select
FW name based on chip signature (Greg KH, Ilpo Jarvinen, Sherry Sun)
v5: Replaced bt_dev_info() with bt_dev_dbg(), handled user-space cmd
parsing in nxp_enqueue() in a better way. (Greg KH, Luiz Augusto von Dentz)
v6: Add support for fw-init-baudrate parameter from device tree,
modified logic to detect FW download is needed or FW is running. (Greg
KH, Sherry Sun)
---
 MAINTAINERS                   |    1 +
 drivers/bluetooth/Kconfig     |   11 +
 drivers/bluetooth/Makefile    |    1 +
 drivers/bluetooth/btnxpuart.c | 1317 +++++++++++++++++++++++++++++++++
 4 files changed, 1330 insertions(+)
 create mode 100644 drivers/bluetooth/btnxpuart.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 030ec6fe89df..fdb9b0788c89 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22840,6 +22840,7 @@ M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
 M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
+F:	drivers/bluetooth/btnxpuart.c
 
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 5a1a7bec3c42..359a4833e31f 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -465,4 +465,15 @@ config BT_VIRTIO
 	  Say Y here to compile support for HCI over Virtio into the
 	  kernel or say M to compile as a module.
 
+config BT_NXPUART
+	tristate "NXP protocol support"
+	depends on SERIAL_DEV_BUS
+	help
+	  NXP is serial driver required for NXP Bluetooth
+	  devices with UART interface.
+
+	  Say Y here to compile support for NXP Bluetooth UART device into
+	  the kernel, or say M here to compile as a module (btnxpuart).
+
+
 endmenu
diff --git a/drivers/bluetooth/Makefile b/drivers/bluetooth/Makefile
index e0b261f24fc9..7a5967e9ac48 100644
--- a/drivers/bluetooth/Makefile
+++ b/drivers/bluetooth/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_BT_QCA)		+= btqca.o
 obj-$(CONFIG_BT_MTK)		+= btmtk.o
 
 obj-$(CONFIG_BT_VIRTIO)		+= virtio_bt.o
+obj-$(CONFIG_BT_NXPUART)	+= btnxpuart.o
 
 obj-$(CONFIG_BT_HCIUART_NOKIA)	+= hci_nokia.o
 
diff --git a/drivers/bluetooth/btnxpuart.c b/drivers/bluetooth/btnxpuart.c
new file mode 100644
index 000000000000..f581e05ddecb
--- /dev/null
+++ b/drivers/bluetooth/btnxpuart.c
@@ -0,0 +1,1317 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *  NXP Bluetooth driver
+ *  Copyright 2018-2023 NXP
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+
+#include <linux/serdev.h>
+#include <linux/of.h>
+#include <linux/skbuff.h>
+#include <asm/unaligned.h>
+#include <linux/firmware.h>
+#include <linux/string.h>
+#include <linux/crc8.h>
+#include <linux/crc32.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+
+#include "h4_recv.h"
+
+#define MANUFACTURER_NXP		37
+
+#define BTNXPUART_TX_STATE_ACTIVE	1
+#define BTNXPUART_FW_DOWNLOADING	2
+#define BTNXPUART_CHECK_BOOT_SIGNATURE	3
+
+#define FIRMWARE_W8987	"nxp/uartuart8987_bt.bin"
+#define FIRMWARE_W8997	"nxp/uartuart8997_bt_v4.bin"
+#define FIRMWARE_W9098	"nxp/uartuart9098_bt_v1.bin"
+#define FIRMWARE_IW416	"nxp/uartiw416_bt_v0.bin"
+#define FIRMWARE_IW612	"nxp/uartspi_n61x_v1.bin.se"
+
+#define CHIP_ID_W9098		0x5c03
+#define CHIP_ID_IW416		0x7201
+#define CHIP_ID_IW612		0x7601
+
+#define HCI_NXP_PRI_BAUDRATE	115200
+#define HCI_NXP_SEC_BAUDRATE	3000000
+
+#define MAX_FW_FILE_NAME_LEN    50
+
+/* Default ps timeout period in milli-second */
+#define PS_DEFAULT_TIMEOUT_PERIOD     2000
+
+/* wakeup methods */
+#define WAKEUP_METHOD_DTR       0
+#define WAKEUP_METHOD_BREAK     1
+#define WAKEUP_METHOD_EXT_BREAK 2
+#define WAKEUP_METHOD_RTS       3
+#define WAKEUP_METHOD_INVALID   0xff
+
+/* power save mode status */
+#define PS_MODE_DISABLE         0
+#define PS_MODE_ENABLE          1
+
+/* Power Save Commands to ps_work_func  */
+#define PS_CMD_EXIT_PS          1
+#define PS_CMD_ENTER_PS         2
+
+/* power save state */
+#define PS_STATE_AWAKE          0
+#define PS_STATE_SLEEP          1
+
+/* Bluetooth vendor command : Sleep mode */
+#define HCI_NXP_AUTO_SLEEP_MODE	0xfc23
+/* Bluetooth vendor command : Wakeup method */
+#define HCI_NXP_WAKEUP_METHOD	0xfc53
+/* Bluetooth vendor command : Set operational baudrate */
+#define HCI_NXP_SET_OPER_SPEED	0xfc09
+/* Bluetooth vendor command: Independent Reset */
+#define HCI_NXP_IND_RESET	0xfcfc
+
+/* Bluetooth Power State : Vendor cmd params */
+#define BT_PS_ENABLE			0x02
+#define BT_PS_DISABLE			0x03
+
+/* Bluetooth Host Wakeup Methods */
+#define BT_HOST_WAKEUP_METHOD_NONE      0x00
+#define BT_HOST_WAKEUP_METHOD_DTR       0x01
+#define BT_HOST_WAKEUP_METHOD_BREAK     0x02
+#define BT_HOST_WAKEUP_METHOD_GPIO      0x03
+
+/* Bluetooth Chip Wakeup Methods */
+#define BT_CTRL_WAKEUP_METHOD_DSR       0x00
+#define BT_CTRL_WAKEUP_METHOD_BREAK     0x01
+#define BT_CTRL_WAKEUP_METHOD_GPIO      0x02
+#define BT_CTRL_WAKEUP_METHOD_EXT_BREAK 0x04
+#define BT_CTRL_WAKEUP_METHOD_RTS       0x05
+
+#define MAX_USER_PARAMS			10
+
+struct ps_data {
+	u8    ps_mode;
+	u8    cur_psmode;
+	u8    ps_state;
+	u8    ps_cmd;
+	u8    h2c_wakeupmode;
+	u8    cur_h2c_wakeupmode;
+	u8    c2h_wakeupmode;
+	u8    c2h_wakeup_gpio;
+	bool  driver_sent_cmd;
+	bool  timer_on;
+	u32   interval;
+	struct hci_dev *hdev;
+	struct work_struct work;
+	struct timer_list ps_timer;
+};
+
+struct btnxpuart_data {
+	bool fw_dnld_use_high_baudrate;
+	const u8 *fw_name;
+};
+
+struct btnxpuart_dev {
+	struct hci_dev *hdev;
+	struct serdev_device *serdev;
+
+	struct work_struct tx_work;
+	unsigned long tx_state;
+	struct sk_buff_head txq;
+	struct sk_buff *rx_skb;
+
+	const struct firmware *fw;
+	u8 fw_name[MAX_FW_FILE_NAME_LEN];
+	u32 fw_dnld_v1_offset;
+	u32 fw_v1_sent_bytes;
+	u32 fw_v3_offset_correction;
+	u32 fw_v1_expected_len;
+	wait_queue_head_t fw_dnld_done_wait_q;
+	wait_queue_head_t check_boot_sign_wait_q;
+
+	u32 new_baudrate;
+	u32 current_baudrate;
+	u32 fw_init_baudrate;
+	bool timeout_changed;
+	bool baudrate_changed;
+
+	struct ps_data *psdata;
+	struct btnxpuart_data *nxp_data;
+};
+
+#define NXP_V1_FW_REQ_PKT	0xa5
+#define NXP_V1_CHIP_VER_PKT	0xaa
+#define NXP_V3_FW_REQ_PKT	0xa7
+#define NXP_V3_CHIP_VER_PKT	0xab
+
+#define NXP_ACK_V1		0x5a
+#define NXP_NAK_V1		0xbf
+#define NXP_ACK_V3		0x7a
+#define NXP_NAK_V3		0x7b
+#define NXP_CRC_ERROR_V3	0x7c
+
+#define HDR_LEN			16
+
+#define NXP_RECV_FW_REQ_V1 \
+	.type = NXP_V1_FW_REQ_PKT, \
+	.hlen = 4, \
+	.loff = 0, \
+	.lsize = 0, \
+	.maxlen = 4
+
+#define NXP_RECV_CHIP_VER_V3 \
+	.type = NXP_V3_CHIP_VER_PKT, \
+	.hlen = 4, \
+	.loff = 0, \
+	.lsize = 0, \
+	.maxlen = 4
+
+#define NXP_RECV_FW_REQ_V3 \
+	.type = NXP_V3_FW_REQ_PKT, \
+	.hlen = 9, \
+	.loff = 0, \
+	.lsize = 0, \
+	.maxlen = 9
+
+struct v1_data_req {
+	__le16 len;
+	__le16 len_comp;
+} __packed;
+
+struct v3_data_req {
+	__le16 len;
+	__le32 offset;
+	__le16 error;
+	u8 crc;
+} __packed;
+
+struct v3_start_ind {
+	__le16 chip_id;
+	u8 loader_ver;
+	u8 crc;
+} __packed;
+
+/* UART register addresses of BT chip */
+#define CLKDIVADDR	0x7f00008f
+#define UARTDIVADDR	0x7f000090
+#define UARTMCRADDR	0x7f000091
+#define UARTREINITADDR	0x7f000092
+#define UARTICRADDR	0x7f000093
+#define UARTFCRADDR	0x7f000094
+
+#define MCR		0x00000022
+#define INIT		0x00000001
+#define ICR		0x000000c7
+#define FCR		0x000000c7
+
+#define POLYNOMIAL8	0x07
+#define POLYNOMIAL32	0x04c11db7L
+
+struct uart_reg {
+	__le32 address;
+	__le32 value;
+} __packed;
+
+struct uart_config {
+	struct uart_reg clkdiv;
+	struct uart_reg uartdiv;
+	struct uart_reg mcr;
+	struct uart_reg re_init;
+	struct uart_reg icr;
+	struct uart_reg fcr;
+	__le32 crc;
+} __packed;
+
+struct nxp_bootloader_cmd {
+	__le32 header;
+	__le32 arg;
+	__le32 payload_len;
+	__le32 crc;
+} __packed;
+
+static u8 crc8_table[CRC8_TABLE_SIZE];
+
+/* Default Power Save configuration */
+#define DEFAULT_H2C_WAKEUP_MODE	WAKEUP_METHOD_BREAK
+#define DEFAULT_PS_MODE		PS_MODE_ENABLE
+
+#define FW_INIT_BAUDRATE		115200
+
+static struct sk_buff *nxp_drv_send_cmd(struct hci_dev *hdev, u16 opcode,
+					u32 plen,
+					void *param)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata = nxpdev->psdata;
+	struct sk_buff *skb;
+
+	psdata->driver_sent_cmd = true;	/* set flag to prevent re-sending command in nxp_enqueue */
+	skb = __hci_cmd_sync(hdev, opcode, plen, param, HCI_CMD_TIMEOUT);
+	psdata->driver_sent_cmd = false;
+
+	return skb;
+}
+
+static void btnxpuart_tx_wakeup(struct btnxpuart_dev *nxpdev)
+{
+	if (schedule_work(&nxpdev->tx_work))
+		set_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state);
+}
+
+/* NXP Power Save Feature */
+static void ps_start_timer(struct btnxpuart_dev *nxpdev)
+{
+	struct ps_data *psdata = nxpdev->psdata;
+
+	if (!psdata)
+		return;
+
+	if (psdata->cur_psmode == PS_MODE_ENABLE) {
+		psdata->timer_on = true;
+		mod_timer(&psdata->ps_timer, jiffies + msecs_to_jiffies(psdata->interval));
+	}
+}
+
+static void ps_cancel_timer(struct btnxpuart_dev *nxpdev)
+{
+	struct ps_data *psdata = nxpdev->psdata;
+
+	flush_work(&psdata->work);
+	if (psdata->timer_on)
+		del_timer_sync(&psdata->ps_timer);
+}
+
+static void ps_control(struct hci_dev *hdev, u8 ps_state)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata = nxpdev->psdata;
+	int status;
+
+	if (psdata->ps_state == ps_state)
+		return;
+
+	switch (psdata->cur_h2c_wakeupmode) {
+	case WAKEUP_METHOD_DTR:
+		if (ps_state == PS_STATE_AWAKE)
+			serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
+		else
+			serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
+		break;
+	case WAKEUP_METHOD_BREAK:
+	default:
+		if (ps_state == PS_STATE_AWAKE)
+			status = serdev_device_break_ctl(nxpdev->serdev, 0);
+		else
+			status = serdev_device_break_ctl(nxpdev->serdev, -1);
+		bt_dev_dbg(hdev, "Set UART break: %s, status=%d",
+			   ps_state == PS_STATE_AWAKE ? "off" : "on", status);
+		break;
+	}
+	psdata->ps_state = ps_state;
+	if (ps_state == PS_STATE_AWAKE)
+		btnxpuart_tx_wakeup(nxpdev);
+}
+
+static void ps_work_func(struct work_struct *work)
+{
+	struct ps_data *data = container_of(work, struct ps_data, work);
+
+	if (data->ps_cmd == PS_CMD_ENTER_PS && data->cur_psmode == PS_MODE_ENABLE)
+		ps_control(data->hdev, PS_STATE_SLEEP);
+	else if (data->ps_cmd == PS_CMD_EXIT_PS)
+		ps_control(data->hdev, PS_STATE_AWAKE);
+}
+
+static void ps_timeout_func(struct timer_list *t)
+{
+	struct ps_data *data = from_timer(data, t, ps_timer);
+	struct hci_dev *hdev = data->hdev;
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+
+	data->timer_on = false;
+	if (test_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state)) {
+		ps_start_timer(nxpdev);
+	} else {
+		data->ps_cmd = PS_CMD_ENTER_PS;
+		schedule_work(&data->work);
+	}
+}
+
+static int ps_init_work(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata;
+
+	psdata = kzalloc(sizeof(*psdata), GFP_KERNEL);
+	if (!psdata)
+		return -ENOMEM;
+
+	nxpdev->psdata = psdata;
+
+	psdata->interval = PS_DEFAULT_TIMEOUT_PERIOD;
+	psdata->ps_state = PS_STATE_AWAKE;
+	psdata->ps_mode = DEFAULT_PS_MODE;
+	psdata->hdev = hdev;
+	psdata->c2h_wakeupmode = BT_HOST_WAKEUP_METHOD_NONE;
+	psdata->c2h_wakeup_gpio = 0xff;
+
+	switch (DEFAULT_H2C_WAKEUP_MODE) {
+	case WAKEUP_METHOD_DTR:
+		psdata->h2c_wakeupmode = WAKEUP_METHOD_DTR;
+		break;
+	case WAKEUP_METHOD_BREAK:
+	default:
+		psdata->h2c_wakeupmode = WAKEUP_METHOD_BREAK;
+		break;
+	}
+	psdata->cur_psmode = PS_MODE_DISABLE;
+	psdata->cur_h2c_wakeupmode = WAKEUP_METHOD_INVALID;
+	INIT_WORK(&psdata->work, ps_work_func);
+
+	return 0;
+}
+
+static void ps_init_timer(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata = nxpdev->psdata;
+
+	psdata->timer_on = false;
+	timer_setup(&psdata->ps_timer, ps_timeout_func, 0);
+}
+
+static void ps_wakeup(struct btnxpuart_dev *nxpdev)
+{
+	struct ps_data *psdata = nxpdev->psdata;
+
+	if (psdata->ps_state != PS_STATE_AWAKE) {
+		psdata->ps_cmd = PS_CMD_EXIT_PS;
+		schedule_work(&psdata->work);
+	}
+}
+
+static int send_ps_cmd(struct hci_dev *hdev, void *data)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata = nxpdev->psdata;
+	u8 pcmd;
+	struct sk_buff *skb;
+	u8 *status;
+
+	if (psdata->ps_mode == PS_MODE_ENABLE)
+		pcmd = BT_PS_ENABLE;
+	else
+		pcmd = BT_PS_DISABLE;
+
+	skb = nxp_drv_send_cmd(hdev, HCI_NXP_AUTO_SLEEP_MODE, 1, &pcmd);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Setting Power Save mode failed (%ld)", PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+
+	status = skb_pull_data(skb, 1);
+	if (status) {
+		if (!*status)
+			psdata->cur_psmode = psdata->ps_mode;
+		else
+			psdata->ps_mode = psdata->cur_psmode;
+		if (psdata->cur_psmode == PS_MODE_ENABLE)
+			ps_start_timer(nxpdev);
+		else
+			ps_wakeup(nxpdev);
+		bt_dev_dbg(hdev, "Power Save mode response: status=%d, ps_mode=%d",
+			   *status, psdata->cur_psmode);
+	}
+	kfree_skb(skb);
+
+	return 0;
+}
+
+static int send_wakeup_method_cmd(struct hci_dev *hdev, void *data)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata = nxpdev->psdata;
+	u8 pcmd[4];
+	struct sk_buff *skb;
+	u8 *status;
+
+	pcmd[0] = psdata->c2h_wakeupmode;
+	pcmd[1] = psdata->c2h_wakeup_gpio;
+	switch (psdata->h2c_wakeupmode) {
+	case WAKEUP_METHOD_DTR:
+		pcmd[2] = BT_CTRL_WAKEUP_METHOD_DSR;
+		break;
+	case WAKEUP_METHOD_BREAK:
+	default:
+		pcmd[2] = BT_CTRL_WAKEUP_METHOD_BREAK;
+		break;
+	}
+	pcmd[3] = 0xff;
+
+	skb = nxp_drv_send_cmd(hdev, HCI_NXP_WAKEUP_METHOD, 4, pcmd);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Setting wake-up method failed (%ld)", PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+
+	status = skb_pull_data(skb, 1);
+	if (status) {
+		if (*status == 0)
+			psdata->cur_h2c_wakeupmode = psdata->h2c_wakeupmode;
+		else
+			psdata->h2c_wakeupmode = psdata->cur_h2c_wakeupmode;
+		bt_dev_dbg(hdev, "Set Wakeup Method response: status=%d, h2c_wakeupmode=%d",
+			   *status, psdata->cur_h2c_wakeupmode);
+	}
+	kfree_skb(skb);
+
+	return 0;
+}
+
+static void ps_init(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata = nxpdev->psdata;
+
+	serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_RTS);
+	usleep_range(5000, 10000);
+	serdev_device_set_tiocm(nxpdev->serdev, TIOCM_RTS, 0);
+	usleep_range(5000, 10000);
+
+	switch (psdata->h2c_wakeupmode) {
+	case WAKEUP_METHOD_DTR:
+		serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
+		serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
+		break;
+	case WAKEUP_METHOD_BREAK:
+	default:
+		serdev_device_break_ctl(nxpdev->serdev, -1);
+		usleep_range(5000, 10000);
+		serdev_device_break_ctl(nxpdev->serdev, 0);
+		usleep_range(5000, 10000);
+		break;
+	}
+	if (!test_bit(HCI_RUNNING, &hdev->flags)) {
+		bt_dev_dbg(hdev, "HCI_RUNNING is not set");
+		return;
+	}
+	if (psdata->cur_h2c_wakeupmode != psdata->h2c_wakeupmode)
+		hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
+	if (psdata->cur_psmode != psdata->ps_mode)
+		hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
+}
+
+/* NXP Firmware Download Feature */
+static int nxp_download_firmware(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	int err = 0;
+
+	nxpdev->fw_dnld_v1_offset = 0;
+	nxpdev->fw_v1_sent_bytes = 0;
+	nxpdev->fw_v1_expected_len = HDR_LEN;
+	nxpdev->fw_v3_offset_correction = 0;
+	nxpdev->baudrate_changed = false;
+	nxpdev->timeout_changed = false;
+
+	serdev_device_set_baudrate(nxpdev->serdev, HCI_NXP_PRI_BAUDRATE);
+	serdev_device_set_flow_control(nxpdev->serdev, 0);
+	nxpdev->current_baudrate = HCI_NXP_PRI_BAUDRATE;
+
+	/* Wait till FW is downloaded and CTS becomes low */
+	err = wait_event_interruptible_timeout(nxpdev->fw_dnld_done_wait_q,
+					       !test_bit(BTNXPUART_FW_DOWNLOADING,
+							 &nxpdev->tx_state),
+					       msecs_to_jiffies(60000));
+	if (err == 0) {
+		bt_dev_err(hdev, "FW Download Timeout.");
+		return -ETIMEDOUT;
+	}
+
+	serdev_device_set_flow_control(nxpdev->serdev, 1);
+	err = serdev_device_wait_for_cts(nxpdev->serdev, 1, 60000);
+	if (err < 0) {
+		bt_dev_err(hdev, "CTS is still high. FW Download failed.");
+		return err;
+	}
+	release_firmware(nxpdev->fw);
+	memset(nxpdev->fw_name, 0, MAX_FW_FILE_NAME_LEN);
+
+	/* Allow the downloaded FW to initialize */
+	usleep_range(800000, 1000000);
+
+	return 0;
+}
+
+static void nxp_send_ack(u8 ack, struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	u8 ack_nak[2];
+
+	if (ack == NXP_ACK_V1 || ack == NXP_NAK_V1) {
+		ack_nak[0] = ack;
+		serdev_device_write_buf(nxpdev->serdev, ack_nak, 1);
+	} else if (ack == NXP_ACK_V3) {
+		ack_nak[0] = ack;
+		ack_nak[1] = crc8(crc8_table, ack_nak, 1, 0xff);
+		serdev_device_write_buf(nxpdev->serdev, ack_nak, 2);
+	}
+}
+
+static bool nxp_fw_change_baudrate(struct hci_dev *hdev, u16 req_len)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct nxp_bootloader_cmd nxp_cmd5;
+	struct uart_config uart_config;
+
+	if (req_len == sizeof(nxp_cmd5)) {
+		nxp_cmd5.header = __cpu_to_le32(5);
+		nxp_cmd5.arg = 0;
+		nxp_cmd5.payload_len = __cpu_to_le32(sizeof(uart_config));
+		nxp_cmd5.crc = swab32(crc32_be(0UL, (char *)&nxp_cmd5,
+					       sizeof(nxp_cmd5) - 4));
+
+		serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd5, req_len);
+		nxpdev->fw_v3_offset_correction += req_len;
+	} else if (req_len == sizeof(uart_config)) {
+		uart_config.clkdiv.address = __cpu_to_le32(CLKDIVADDR);
+		uart_config.clkdiv.value = __cpu_to_le32(0x00c00000);
+		uart_config.uartdiv.address = __cpu_to_le32(UARTDIVADDR);
+		uart_config.uartdiv.value = __cpu_to_le32(1);
+		uart_config.mcr.address = __cpu_to_le32(UARTMCRADDR);
+		uart_config.mcr.value = __cpu_to_le32(MCR);
+		uart_config.re_init.address = __cpu_to_le32(UARTREINITADDR);
+		uart_config.re_init.value = __cpu_to_le32(INIT);
+		uart_config.icr.address = __cpu_to_le32(UARTICRADDR);
+		uart_config.icr.value = __cpu_to_le32(ICR);
+		uart_config.fcr.address = __cpu_to_le32(UARTFCRADDR);
+		uart_config.fcr.value = __cpu_to_le32(FCR);
+		uart_config.crc = swab32(crc32_be(0UL, (char *)&uart_config,
+						  sizeof(uart_config) - 4));
+		serdev_device_write_buf(nxpdev->serdev, (u8 *)&uart_config, req_len);
+		serdev_device_wait_until_sent(nxpdev->serdev, 0);
+		nxpdev->fw_v3_offset_correction += req_len;
+		return true;
+	}
+	return false;
+}
+
+static bool nxp_fw_change_timeout(struct hci_dev *hdev, u16 req_len)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct nxp_bootloader_cmd nxp_cmd7;
+
+	if (req_len != sizeof(nxp_cmd7))
+		return false;
+
+	nxp_cmd7.header = __cpu_to_le32(7);
+	nxp_cmd7.arg = __cpu_to_le32(0x70);
+	nxp_cmd7.payload_len = 0;
+	nxp_cmd7.crc = swab32(crc32_be(0UL, (char *)&nxp_cmd7,
+				       sizeof(nxp_cmd7) - 4));
+
+	serdev_device_write_buf(nxpdev->serdev, (u8 *)&nxp_cmd7, req_len);
+	serdev_device_wait_until_sent(nxpdev->serdev, 0);
+	nxpdev->fw_v3_offset_correction += req_len;
+	return true;
+}
+
+static u32 nxp_get_data_len(const u8 *buf)
+{
+	struct nxp_bootloader_cmd *hdr = (struct nxp_bootloader_cmd *)buf;
+
+	return __le32_to_cpu(hdr->payload_len);
+}
+
+/* for legacy chipsets with V1 bootloader */
+static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
+	struct v1_data_req *req;
+	u32 requested_len;
+	int err;
+
+	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
+		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
+		goto ret;
+	}
+
+	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
+		goto ret;
+
+	req = (struct v1_data_req *)skb_pull_data(skb, sizeof(struct v1_data_req));
+	if (!req)
+		goto ret;
+
+	if ((req->len ^ req->len_comp) != 0xffff) {
+		bt_dev_dbg(hdev, "ERR: Send NAK");
+		nxp_send_ack(NXP_NAK_V1, hdev);
+		goto ret;
+	}
+	nxp_send_ack(NXP_ACK_V1, hdev);
+
+	if (nxp_data->fw_dnld_use_high_baudrate) {
+		if (!nxpdev->timeout_changed) {
+			nxpdev->timeout_changed = nxp_fw_change_timeout(hdev, req->len);
+			goto ret;
+		}
+		if (!nxpdev->baudrate_changed) {
+			nxpdev->baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
+			if (nxpdev->baudrate_changed) {
+				serdev_device_set_baudrate(nxpdev->serdev,
+							   HCI_NXP_SEC_BAUDRATE);
+				serdev_device_set_flow_control(nxpdev->serdev, 1);
+				nxpdev->current_baudrate = HCI_NXP_SEC_BAUDRATE;
+			}
+			goto ret;
+		}
+	}
+
+	if (!strlen(nxpdev->fw_name)) {
+		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
+			 nxp_data->fw_name);
+		bt_dev_info(hdev, "Request Firmware: %s", nxpdev->fw_name);
+		err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
+		if (err < 0) {
+			bt_dev_err(hdev, "Firmware file %s not found", nxpdev->fw_name);
+			clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+			return err;
+		}
+	}
+
+	requested_len = req->len;
+	if (requested_len == 0) {
+		bt_dev_info(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
+		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
+		goto ret;
+	}
+	if (requested_len & 0x01) {
+		/* The CRC did not match at the other end.
+		 * Simply send the same bytes again.
+		 */
+		requested_len = nxpdev->fw_v1_sent_bytes;
+		bt_dev_dbg(hdev, "CRC error. Resend %d bytes of FW.", requested_len);
+	} else {
+		nxpdev->fw_dnld_v1_offset += nxpdev->fw_v1_sent_bytes;
+
+		/* The FW bin file is made up of many blocks of
+		 * 16 byte header and payload data chunks. If the
+		 * FW has requested a header, read the payload length
+		 * info from the header, before sending the header.
+		 * In the next iteration, the FW should request the
+		 * payload data chunk, which should be equal to the
+		 * payload length read from header. If there is a
+		 * mismatch, clearly the driver and FW are out of sync,
+		 * and we need to re-send the previous header again.
+		 */
+		if (requested_len == nxpdev->fw_v1_expected_len) {
+			if (requested_len == HDR_LEN)
+				nxpdev->fw_v1_expected_len = nxp_get_data_len(nxpdev->fw->data +
+									nxpdev->fw_dnld_v1_offset);
+			else
+				nxpdev->fw_v1_expected_len = HDR_LEN;
+		} else {
+			if (requested_len == HDR_LEN) {
+				/* FW download out of sync. Send previous chunk again */
+				nxpdev->fw_dnld_v1_offset -= nxpdev->fw_v1_sent_bytes;
+				nxpdev->fw_v1_expected_len = HDR_LEN;
+			}
+		}
+	}
+
+	if (nxpdev->fw_dnld_v1_offset + requested_len <= nxpdev->fw->size)
+		serdev_device_write_buf(nxpdev->serdev,
+					nxpdev->fw->data + nxpdev->fw_dnld_v1_offset,
+					requested_len);
+	nxpdev->fw_v1_sent_bytes = requested_len;
+
+ret:
+	kfree_skb(skb);
+	return 0;
+}
+
+static u8 *nxp_get_fw_name_from_chipid(struct hci_dev *hdev, u16 chipid)
+{
+	u8 *fw_name = NULL;
+
+	switch (chipid) {
+	case CHIP_ID_W9098:
+		fw_name = FIRMWARE_W9098;
+		break;
+	case CHIP_ID_IW416:
+		fw_name = FIRMWARE_IW416;
+		break;
+	case CHIP_ID_IW612:
+		fw_name = FIRMWARE_IW612;
+		break;
+	default:
+		bt_dev_err(hdev, "Unknown chip signature %04X", chipid);
+		break;
+	}
+	return fw_name;
+}
+
+static int nxp_recv_chip_ver_v3(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct v3_start_ind *req = skb_pull_data(skb, sizeof(struct v3_start_ind));
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	int err;
+
+	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
+		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
+		goto ret;
+	}
+
+	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
+		goto ret;
+
+	if (!strlen(nxpdev->fw_name)) {
+		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s",
+			 nxp_get_fw_name_from_chipid(hdev, req->chip_id));
+
+		bt_dev_info(hdev, "Request Firmware: %s", nxpdev->fw_name);
+		err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
+		if (err < 0) {
+			bt_dev_err(hdev, "Firmware file %s not found", nxpdev->fw_name);
+			clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+			goto ret;
+		}
+	}
+	nxp_send_ack(NXP_ACK_V3, hdev);
+ret:
+	kfree_skb(skb);
+	return 0;
+}
+
+static int nxp_recv_fw_req_v3(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct v3_data_req *req;
+
+	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
+		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
+		goto ret;
+	}
+
+	if (!test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state))
+		goto ret;
+
+	req = (struct v3_data_req *)skb_pull_data(skb, sizeof(struct v3_data_req));
+	if (!req || !nxpdev || !nxpdev->fw)
+		goto ret;
+
+	nxp_send_ack(NXP_ACK_V3, hdev);
+
+	if (!nxpdev->timeout_changed) {
+		nxpdev->timeout_changed = nxp_fw_change_timeout(hdev, req->len);
+		goto ret;
+	}
+
+	if (!nxpdev->baudrate_changed) {
+		nxpdev->baudrate_changed = nxp_fw_change_baudrate(hdev, req->len);
+		if (nxpdev->baudrate_changed) {
+			serdev_device_set_baudrate(nxpdev->serdev,
+						   HCI_NXP_SEC_BAUDRATE);
+			serdev_device_set_flow_control(nxpdev->serdev, 1);
+			nxpdev->current_baudrate = HCI_NXP_SEC_BAUDRATE;
+		}
+		goto ret;
+	}
+
+	if (req->len == 0) {
+		bt_dev_info(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
+		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
+		goto ret;
+	}
+	if (req->error)
+		bt_dev_dbg(hdev, "FW Download received err 0x%02x from chip. Resending FW chunk.",
+			   req->error);
+
+	if (req->offset < nxpdev->fw_v3_offset_correction) {
+		/* This scenario should ideally never occur.
+		 * But if it ever does, FW is out of sync and
+		 * needs a power cycle.
+		 */
+		bt_dev_err(hdev, "Something went wrong during FW download. Please power cycle and try again");
+		goto ret;
+	}
+
+	serdev_device_write_buf(nxpdev->serdev,
+				nxpdev->fw->data + req->offset - nxpdev->fw_v3_offset_correction,
+				req->len);
+
+ret:
+	kfree_skb(skb);
+	return 0;
+}
+
+static int nxp_set_baudrate_cmd(struct hci_dev *hdev, void *data)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	u32 new_baudrate = __cpu_to_le32(nxpdev->new_baudrate);
+	struct ps_data *psdata = nxpdev->psdata;
+	u8 *pcmd = (u8 *)&new_baudrate;
+	struct sk_buff *skb;
+	u8 *status;
+
+	if (!psdata)
+		return 0;
+
+	skb = nxp_drv_send_cmd(hdev, HCI_NXP_SET_OPER_SPEED, 4, pcmd);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Setting baudrate failed (%ld)", PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+
+	status = (u8 *)skb_pull_data(skb, 1);
+	if (status) {
+		if (*status == 0) {
+			serdev_device_set_baudrate(nxpdev->serdev, nxpdev->new_baudrate);
+			nxpdev->current_baudrate = nxpdev->new_baudrate;
+		}
+		bt_dev_dbg(hdev, "Set baudrate response: status=%d, baudrate=%d",
+			   *status, nxpdev->new_baudrate);
+	}
+	kfree_skb(skb);
+
+	return 0;
+}
+
+static int nxp_set_ind_reset(struct hci_dev *hdev, void *data)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct sk_buff *skb;
+	u8 *status;
+	u8 pcmd = 0;
+	int err;
+
+	skb = nxp_drv_send_cmd(hdev, HCI_NXP_IND_RESET, 1, &pcmd);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	status = skb_pull_data(skb, 1);
+	if (status) {
+		if (*status == 0) {
+			set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+			err = nxp_download_firmware(hdev);
+			if (err < 0)
+				return err;
+			serdev_device_set_baudrate(nxpdev->serdev, nxpdev->fw_init_baudrate);
+			nxpdev->current_baudrate = nxpdev->fw_init_baudrate;
+			if (nxpdev->current_baudrate != HCI_NXP_SEC_BAUDRATE) {
+				nxpdev->new_baudrate = HCI_NXP_SEC_BAUDRATE;
+				nxp_set_baudrate_cmd(hdev, NULL);
+			}
+			hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
+			hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
+		}
+	}
+	kfree_skb(skb);
+
+	return 0;
+}
+
+/* NXP protocol */
+static bool nxp_check_boot_sign(struct btnxpuart_dev *nxpdev)
+{
+	int ret;
+
+	serdev_device_set_baudrate(nxpdev->serdev, HCI_NXP_PRI_BAUDRATE);
+	serdev_device_set_flow_control(nxpdev->serdev, 0);
+	set_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
+
+	ret = wait_event_interruptible_timeout(nxpdev->check_boot_sign_wait_q,
+					       !test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE,
+							 &nxpdev->tx_state),
+					       msecs_to_jiffies(1000));
+	if (ret == 0)
+		return false;
+	else
+		return true;
+}
+
+static int nxp_setup(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	int err = 0;
+
+	if (!nxpdev)
+		return 0;
+
+	set_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+	init_waitqueue_head(&nxpdev->fw_dnld_done_wait_q);
+	init_waitqueue_head(&nxpdev->check_boot_sign_wait_q);
+
+	if (nxp_check_boot_sign(nxpdev)) {
+		bt_dev_dbg(hdev, "Need FW Download.");
+		err = nxp_download_firmware(hdev);
+		if (err < 0)
+			return err;
+	} else {
+		bt_dev_dbg(hdev, "FW already running.");
+		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+	}
+
+	serdev_device_set_flow_control(nxpdev->serdev, 1);
+	device_property_read_u32(&nxpdev->serdev->dev, "fw-init-baudrate",
+				 &nxpdev->fw_init_baudrate);
+	if (!nxpdev->fw_init_baudrate)
+		nxpdev->fw_init_baudrate = FW_INIT_BAUDRATE;
+	serdev_device_set_baudrate(nxpdev->serdev, nxpdev->fw_init_baudrate);
+	nxpdev->current_baudrate = nxpdev->fw_init_baudrate;
+
+	if (nxpdev->current_baudrate != HCI_NXP_SEC_BAUDRATE) {
+		nxpdev->new_baudrate = HCI_NXP_SEC_BAUDRATE;
+		hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
+	}
+
+	ps_init(hdev);
+
+	return 0;
+}
+
+static int nxp_enqueue(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata = nxpdev->psdata;
+	struct hci_command_hdr *hdr;
+	u8 param[MAX_USER_PARAMS];
+
+	if (!nxpdev || !psdata)
+		goto free_skb;
+
+	/* if vendor commands are received from user space (e.g. hcitool), update
+	 * driver flags accordingly and ask driver to re-send the command to FW.
+	 */
+	if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT && !psdata->driver_sent_cmd) {
+		if (!skb->len || skb->len > (MAX_USER_PARAMS + HCI_COMMAND_HDR_SIZE))
+			goto send_skb;
+
+		hdr = (struct hci_command_hdr *)skb->data;
+		if (hdr->plen != (skb->len - HCI_COMMAND_HDR_SIZE))
+			goto send_skb;
+
+		memcpy(param, skb->data + HCI_COMMAND_HDR_SIZE, hdr->plen);
+		switch (__le16_to_cpu(hdr->opcode)) {
+		case HCI_NXP_AUTO_SLEEP_MODE:
+			if (hdr->plen >= 1) {
+				if (param[0] == BT_PS_ENABLE)
+					psdata->ps_mode = PS_MODE_ENABLE;
+				else if (param[0] == BT_PS_DISABLE)
+					psdata->ps_mode = PS_MODE_DISABLE;
+				hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
+				goto free_skb;
+			}
+			break;
+		case HCI_NXP_WAKEUP_METHOD:
+			if (hdr->plen >= 4) {
+				psdata->c2h_wakeupmode = param[0];
+				psdata->c2h_wakeup_gpio = param[1];
+				switch (param[2]) {
+				case BT_CTRL_WAKEUP_METHOD_DSR:
+					psdata->h2c_wakeupmode = WAKEUP_METHOD_DTR;
+					break;
+				case BT_CTRL_WAKEUP_METHOD_BREAK:
+				default:
+					psdata->h2c_wakeupmode = WAKEUP_METHOD_BREAK;
+					break;
+				}
+				hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
+				goto free_skb;
+			}
+			break;
+		case HCI_NXP_SET_OPER_SPEED:
+			if (hdr->plen == 4) {
+				nxpdev->new_baudrate = *((u32 *)param);
+				hci_cmd_sync_queue(hdev, nxp_set_baudrate_cmd, NULL, NULL);
+				goto free_skb;
+			}
+			break;
+		case HCI_NXP_IND_RESET:
+			if (hdr->plen == 1) {
+				hci_cmd_sync_queue(hdev, nxp_set_ind_reset, NULL, NULL);
+				goto free_skb;
+			}
+			break;
+		default:
+			break;
+		}
+	}
+
+send_skb:
+	/* Prepend skb with frame type */
+	memcpy(skb_push(skb, 1), &hci_skb_pkt_type(skb), 1);
+	skb_queue_tail(&nxpdev->txq, skb);
+
+	btnxpuart_tx_wakeup(nxpdev);
+ret:
+	return 0;
+
+free_skb:
+	kfree_skb(skb);
+	goto ret;
+}
+
+static struct sk_buff *nxp_dequeue(void *data)
+{
+	struct btnxpuart_dev *nxpdev = (struct btnxpuart_dev *)data;
+
+	ps_wakeup(nxpdev);
+	ps_start_timer(nxpdev);
+	return skb_dequeue(&nxpdev->txq);
+}
+
+/* btnxpuart based on serdev */
+static void btnxpuart_tx_work(struct work_struct *work)
+{
+	struct btnxpuart_dev *nxpdev = container_of(work, struct btnxpuart_dev,
+						   tx_work);
+	struct serdev_device *serdev = nxpdev->serdev;
+	struct hci_dev *hdev = nxpdev->hdev;
+	struct sk_buff *skb;
+	int len;
+
+	while ((skb = nxp_dequeue(nxpdev))) {
+		len = serdev_device_write_buf(serdev, skb->data, skb->len);
+		hdev->stat.byte_tx += len;
+
+		skb_pull(skb, len);
+		if (skb->len > 0) {
+			skb_queue_head(&nxpdev->txq, skb);
+			break;
+		}
+
+		switch (hci_skb_pkt_type(skb)) {
+		case HCI_COMMAND_PKT:
+			hdev->stat.cmd_tx++;
+			break;
+		case HCI_ACLDATA_PKT:
+			hdev->stat.acl_tx++;
+			break;
+		case HCI_SCODATA_PKT:
+			hdev->stat.sco_tx++;
+			break;
+		}
+
+		kfree_skb(skb);
+	}
+	clear_bit(BTNXPUART_TX_STATE_ACTIVE, &nxpdev->tx_state);
+}
+
+static int btnxpuart_open(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	int err = 0;
+
+	err = serdev_device_open(nxpdev->serdev);
+	if (err) {
+		bt_dev_err(hdev, "Unable to open UART device %s",
+			   dev_name(&nxpdev->serdev->dev));
+	}
+
+	return err;
+}
+
+static int btnxpuart_close(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+
+	if (!nxpdev)
+		return 0;
+
+	serdev_device_close(nxpdev->serdev);
+
+	return 0;
+}
+
+static int btnxpuart_flush(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+
+	if (!nxpdev)
+		return 0;
+
+	/* Flush any pending characters */
+	serdev_device_write_flush(nxpdev->serdev);
+	skb_queue_purge(&nxpdev->txq);
+
+	cancel_work_sync(&nxpdev->tx_work);
+
+	kfree_skb(nxpdev->rx_skb);
+	nxpdev->rx_skb = NULL;
+
+	return 0;
+}
+
+static const struct h4_recv_pkt nxp_recv_pkts[] = {
+	{ H4_RECV_ACL,          .recv = hci_recv_frame },
+	{ H4_RECV_SCO,          .recv = hci_recv_frame },
+	{ H4_RECV_EVENT,        .recv = hci_recv_frame },
+	{ NXP_RECV_FW_REQ_V1,   .recv = nxp_recv_fw_req_v1 },
+	{ NXP_RECV_CHIP_VER_V3, .recv = nxp_recv_chip_ver_v3 },
+	{ NXP_RECV_FW_REQ_V3,   .recv = nxp_recv_fw_req_v3 },
+};
+
+static bool is_valid_bootloader_signature(const u8 *data, size_t count)
+{
+	if ((*data == NXP_V1_FW_REQ_PKT && count == sizeof(struct v1_data_req) + 1) ||
+	    (*data == NXP_V3_FW_REQ_PKT && count == sizeof(struct v3_data_req) + 1) ||
+	    (*data == NXP_V3_CHIP_VER_PKT && count == sizeof(struct v3_start_ind) + 1))
+		return true;
+	else
+		return false;
+}
+
+static int btnxpuart_receive_buf(struct serdev_device *serdev, const u8 *data,
+				 size_t count)
+{
+	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
+
+	if (test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state)) {
+		if (!is_valid_bootloader_signature(data, count)) {
+			/* Unknown bootloader signature, skip without returning error */
+			return count;
+		}
+	}
+
+	ps_start_timer(nxpdev);
+
+	nxpdev->rx_skb = h4_recv_buf(nxpdev->hdev, nxpdev->rx_skb, data, count,
+				     nxp_recv_pkts, ARRAY_SIZE(nxp_recv_pkts));
+	if (IS_ERR(nxpdev->rx_skb)) {
+		int err = PTR_ERR(nxpdev->rx_skb);
+
+		bt_dev_err(nxpdev->hdev, "Frame reassembly failed (%d)", err);
+		nxpdev->rx_skb = NULL;
+		return err;
+	}
+	nxpdev->hdev->stat.byte_rx += count;
+	return count;
+}
+
+static void btnxpuart_write_wakeup(struct serdev_device *serdev)
+{
+	serdev_device_write_wakeup(serdev);
+}
+
+static const struct serdev_device_ops btnxpuart_client_ops = {
+	.receive_buf = btnxpuart_receive_buf,
+	.write_wakeup = btnxpuart_write_wakeup,
+};
+
+static int nxp_serdev_probe(struct serdev_device *serdev)
+{
+	struct hci_dev *hdev;
+	struct btnxpuart_dev *nxpdev;
+
+	nxpdev = devm_kzalloc(&serdev->dev, sizeof(*nxpdev), GFP_KERNEL);
+	if (!nxpdev)
+		return -ENOMEM;
+
+	nxpdev->nxp_data = (struct btnxpuart_data *)device_get_match_data(&serdev->dev);
+
+	nxpdev->serdev = serdev;
+	serdev_device_set_drvdata(serdev, nxpdev);
+
+	serdev_device_set_client_ops(serdev, &btnxpuart_client_ops);
+
+	INIT_WORK(&nxpdev->tx_work, btnxpuart_tx_work);
+	skb_queue_head_init(&nxpdev->txq);
+
+	/* Initialize and register HCI device */
+	hdev = hci_alloc_dev();
+	if (!hdev) {
+		dev_err(&serdev->dev, "Can't allocate HCI device\n");
+		return -ENOMEM;
+	}
+
+	nxpdev->hdev = hdev;
+
+	hdev->bus = HCI_UART;
+	hci_set_drvdata(hdev, nxpdev);
+
+	hdev->manufacturer = MANUFACTURER_NXP;
+	hdev->open  = btnxpuart_open;
+	hdev->close = btnxpuart_close;
+	hdev->flush = btnxpuart_flush;
+	hdev->setup = nxp_setup;
+	hdev->send  = nxp_enqueue;
+	SET_HCIDEV_DEV(hdev, &serdev->dev);
+
+	if (hci_register_dev(hdev) < 0) {
+		dev_err(&serdev->dev, "Can't register HCI device\n");
+		hci_free_dev(hdev);
+		return -ENODEV;
+	}
+
+	if (!ps_init_work(hdev))
+		ps_init_timer(hdev);
+
+	crc8_populate_msb(crc8_table, POLYNOMIAL8);
+
+	return 0;
+}
+
+static void nxp_serdev_remove(struct serdev_device *serdev)
+{
+	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
+	struct ps_data *psdata = nxpdev->psdata;
+	struct hci_dev *hdev = nxpdev->hdev;
+
+	/* Restore FW baudrate to fw_init_baudrate if changed.
+	 * This will ensure FW baudrate is in sync with
+	 * driver baudrate in case this driver is re-inserted.
+	 */
+	if (nxpdev->current_baudrate != nxpdev->fw_init_baudrate) {
+		nxpdev->new_baudrate = nxpdev->fw_init_baudrate;
+		nxp_set_baudrate_cmd(hdev, NULL);
+	}
+
+	if (psdata) {
+		ps_cancel_timer(nxpdev);
+		kfree(psdata);
+	}
+	hci_unregister_dev(hdev);
+	hci_free_dev(hdev);
+}
+
+static struct btnxpuart_data w8987_data = {
+	.fw_dnld_use_high_baudrate = true,
+	.fw_name = FIRMWARE_W8987,
+};
+
+static struct btnxpuart_data w8997_data = {
+	.fw_dnld_use_high_baudrate = false,
+	.fw_name = FIRMWARE_W8997,
+};
+
+static const struct of_device_id nxpuart_of_match_table[] = {
+	{ .compatible = "nxp,88w8987-bt", .data = &w8987_data },
+	{ .compatible = "nxp,88w8997-bt", .data = &w8997_data },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, nxpuart_of_match_table);
+
+static struct serdev_device_driver nxp_serdev_driver = {
+	.probe = nxp_serdev_probe,
+	.remove = nxp_serdev_remove,
+	.driver = {
+		.name = "btnxpuart",
+		.of_match_table = of_match_ptr(nxpuart_of_match_table),
+	},
+};
+
+module_serdev_device_driver(nxp_serdev_driver);
+
+MODULE_AUTHOR("Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>");
+MODULE_DESCRIPTION("NXP Bluetooth Serial driver v1.0 ");
+MODULE_LICENSE("GPL");
-- 
2.34.1

