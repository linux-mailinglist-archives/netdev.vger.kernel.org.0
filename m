Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9586AC95C
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 18:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbjCFRIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 12:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCFRHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 12:07:49 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on0612.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe1e::612])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A6E3525D;
        Mon,  6 Mar 2023 09:07:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmtDHlzESas2volnTjyISAOYbzhWW0Uu6t0LGJlDUoHhDuAHWff3IpMJBXxVRDpBJ4LezxJrr3KeDo6ykvDG/94sVXD4uhchoSLxOHCHYiebV/tFSNIH637uYdky6rTuAKj1fLhS13Dh5Fg2Nui0RCcfvmJobdAqz0Vq+jbFjzxwuRCnvLYWl1gdtmfiUXF10cj0IefaOGvRTNPM+8O73WD+iox32S0W6F2lPEcd6BWdS+cc5pEiK4R0+QmbjfuIHlf7GzRQ21RWFuLjpA2TmQz93HU7FNDIMHLNfrjHhoQOG9zCZxAiJI4k2oez+i3aNBO7CnexWXJKQ9z0A9fscg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2su3s2ziA3Q0XGuzpKs4tK0OSz/YUqeLiRCEReI2QGw=;
 b=N2Mva3QEmua/yfmc7MASbpszDO+WVzKJbGVU9O7ueYUBVl3mVD8eeX55N2HYMKNQQKD6ZFuwwKBr/EuV9eR0+YoXTPAd6IHE9uyozimaQesB4fLZWqBqfq6QyyIG6Qotm+zMuYGpkv54eQxWmHN2cu55Gcj2tFcwirbTBWJ9TXDVhGCNondd03/KEmZqQiiJjP8h+ps8PxCrIm5E84hycSx8dAK6IG7oEbEtBuK2geo70mb3ggb6UbGaNSHslnVmSvw789EqFytZBqyDNqj0vxwk3LxX4EN2qyCrBhPLokSynGoRd2DwNGjavlxPaHUYvYwxkBSV0AB92zjhKVXpZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2su3s2ziA3Q0XGuzpKs4tK0OSz/YUqeLiRCEReI2QGw=;
 b=sVVMS77jHpfCMzA3u2lI62BhZQBbAtfxDUaq9cDNCEy5MOPfHnGXgQCFbGK0ke3XaRz/skaPBzbCM7lk/i0lSOq0qy29rEFjUx+gQJRv5mifX1P6EFEkyW7XtJgwmQ4VXNecfzx5e6XL9fMVSxJRGaReIQMyxywwJl7g1T1fi7I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DB9PR04MB9427.eurprd04.prod.outlook.com (2603:10a6:10:369::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 17:06:27 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 17:06:27 +0000
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
Subject: [PATCH v7 3/3] Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
Date:   Mon,  6 Mar 2023 22:35:25 +0530
Message-Id: <20230306170525.3732605-4-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com>
References: <20230306170525.3732605-1-neeraj.sanjaykale@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:196::19) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DB9PR04MB9427:EE_
X-MS-Office365-Filtering-Correlation-Id: e6609f08-4204-481e-b667-08db1e651f37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y/G1kMyU2c3++5FCTEfsHFUQRD/1TCM7HyPkoiiFCOHCKb6LWrq+ZHTafh49sDknJcvMj7ztJEmsibXt6sJjdg1dIXUZ9RsI1C5Q4M5q/wg92/IqwwdycUZxri391mNMJgxd8dB6ggq2XwVBHj5cZ7ErYHqs9dfHQdSiI/jtoKkIiXDQt2xNxjcU8rHum4UGg9GTctVsntSRJbG94VU72YRv0nhUj7w+Oh33a6mZJ1feygRniEGO+2SgZW1hXxb3MlOqNmuSHcu851LQGbsYbKXX3bc1yV4Zk6/Gd7QPhPYZU5SL/CiWPdlL6lry73pIj+/Jei49GypRT1/04yw/QA459ptWdisFZbtAh7UT9rP/AVyXHe4mUKGIFbYXQhTqFZxJcr5lws7xYU21VmZiNlQMOFbMQ7UM0HFY3wYTRudla+HLmaVBe8rEcG7ns7U0Zmd1Px9XzICBz3hCvrgvEoXzmXr69f/RLVx63lbf24WgGKkzzqCY0Wc0dB5whrsqplCwAWn1U5cNO4bWa9+l+T7Ep8EudtfWlhsvd7qowEK6qS08iCPvJOKa24RyqQGpBdSRqQz4mOs3BYe7k86oGIgJOJBvHMhfmhUACneVNkLFoyLA5V97UdkKOW352nRW0euQlfgaUcX5rm5QdawFdybe91CLMWnz1akJ0nvDeZJee19v863W/YeXSGREYhk8Hmm0rSYj5tZzIGy1cmcyJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(366004)(136003)(39860400002)(396003)(451199018)(8936002)(5660300002)(7416002)(30864003)(66946007)(66556008)(2906002)(66476007)(8676002)(4326008)(66899018)(316002)(478600001)(52116002)(36756003)(6506007)(6512007)(1076003)(6486002)(66574015)(26005)(2616005)(41300700001)(86362001)(83380400001)(921005)(186003)(38350700002)(38100700002)(579004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTV5NkdidDE3M0RnWFJEY2JFRWxTVkJ1TTFjL2hLWVZXQzRXcURMRWRHaGd5?=
 =?utf-8?B?VWxaY3dhVnAvQThOcGw3aHhDc3RLY1M2OUdibzc3czFvb0Y3WnVHbm9LUnAy?=
 =?utf-8?B?eEZjbGdGbTR0ZnU5YUZrYlJJTTVkWWYzc0JJeWtLQWJLTWEvRStPYWR0UFZG?=
 =?utf-8?B?M0JjWStjTkN6Q1piZ2cwc0Znc2ZnR2d5SmVuMmtXYWx0NFVBWXc0eWJrVjB3?=
 =?utf-8?B?VjZWMUg3VGdTTklsRm1vV1VrVFdzZitmNU02YWVvbkxZdmovK3pjaXAxYjRX?=
 =?utf-8?B?OERXSjFKWFBaK2pmTEhOMlcyZCtkZ0RDNGt0OTRRbm10MWwrb1YrQW52TVBT?=
 =?utf-8?B?UzhZd2FLVXNjWjlMeVAzbFk0MlhlQ2I0THpaM2w1b1BrckRYVFpjOFFuQjhu?=
 =?utf-8?B?Umx2S1h3cHR6Y2YxOGhpbGRQVWo3Y1lydVVKR1JsU0hlNmlzYXd3cTk5RTcw?=
 =?utf-8?B?VllYU2RsVmtSRU9GbHBVZlRTNUU1Rjl5WUVFSnpIZ1RzWGR5L0JqWTllYXk0?=
 =?utf-8?B?SmNyalI0Q1JPaEczV2lDTmhOOEdFM0J3eENPbThFUDRvNGNVam4xM3dQeDRZ?=
 =?utf-8?B?VEs3d1NUb05wYWFGVkYrVDExSGVJMytsa1VjZThTS1JsUks4enlWbWc1ZFdT?=
 =?utf-8?B?aTh6UEFqWTBESzVYQ3Zldy95N2lTeGRGR2lCMlVXeTNrZXMzUlJZVGV3azlT?=
 =?utf-8?B?TEtjZThIV1N0RDFBaXEydVptMzZKcFNnRlZJYW9CdWpack5iVjJHVVovUi9u?=
 =?utf-8?B?akp1NW9EOXUrWnBQcHhndGRBNy96OGlrVmExbVdPVWV3bjA3eG0reUJVaFBQ?=
 =?utf-8?B?VWl1ZjhGa3cwZy9lQUZBY1BCVDRWc1BRajFsZ05YNVNteWZSdDZEdkdFVHFF?=
 =?utf-8?B?OHZRbUZ0K3N0ZmJ0NlNzYnRFaUN1Zzh3MGJhZm80K0ZzZUV0aG44WXVKVmps?=
 =?utf-8?B?TzdrZ3REQ2ZKYUt0dDExOXAwbmF2am1wb0dBSko3SzVNNjhXZHhUMlNtbG42?=
 =?utf-8?B?Vms5QjdoOWxSVDVPdWxzVyswTzl0VGdHZXlNNHlXVGI0Q0piSHFUamhWdjZU?=
 =?utf-8?B?QXV3dERyYll6WUplRldNTWtNRU9JTkhrbVZpTWs4ZUtKbGFWb0tuNUx1SCtO?=
 =?utf-8?B?M0s3MHBvSkRaTUt3SisxRzdqMDlvTkp0SDRxZjdTM2h5aHhsY1g0UDkzWC9z?=
 =?utf-8?B?blJvTkVzRkJWck85OTFodzlWbG1iNFBWanJEQ0hoMXlLb3B6M3lGT0tiUHlz?=
 =?utf-8?B?NDlOTVQ5YkVTeDNqdzcxQVFhSzVkQm1QRnF2dVZ3SE8zaHFKUTlZWHJsRnZ0?=
 =?utf-8?B?ajdpbXRxc0Y5SnExZU40TnUyVzZCcS9FZHpROTVQVStHdGdiOWtwbHpZWHhB?=
 =?utf-8?B?OU9SeWJwVU02Wkx2bmFsS0tKOXR6aGljejEyQ2lIYzN6NnI2ei9BR3l2bHlv?=
 =?utf-8?B?OTVnWGtQczNVYy9FK0l1ckgxN3lSMWwwSHhFVW5JeWIvTkd4SG5naFROWDha?=
 =?utf-8?B?cTdJL1J5WldLZ2hKNkF5TjFKSE9qNkxXMzBkbTZielcrUVVHa1dyTm9kWE9U?=
 =?utf-8?B?SUI3ZXJrdE4zWmRaS296azdDRkNuQUVmTmxQc3JDaG9oWERSczZkSlRwOXNt?=
 =?utf-8?B?KzBjSWwweFBiT1pEWFFBdG4yclpEcHNvcUVqVDJ4ZjNxM2FtRVRsMHlyTVBX?=
 =?utf-8?B?NkcrUytWTTB6YWpQaW55aGNMWXBPNjdpRWRCSGF2Q3VpTm92eE5yanJ1MFN6?=
 =?utf-8?B?ckZrSjVTWmhFU2RUcXhBOTRsWHBqTGVBWEJWZmY0VmZIMjk1K2FwcnBQUTNa?=
 =?utf-8?B?emJwd0pjZ1NXTUtpNnkycU5RbWtyc1V1R1FOcGs1V2FOc0xoRUsvaXZ4MHNS?=
 =?utf-8?B?VVA0UXZLSVpjMy9kTURUMDVuRnNIRXJ0YjZVUUs4blIwYXNRdnZSekNSbkRY?=
 =?utf-8?B?K1c2Y0M0OVFqdkp3eldqUFhhSGE2R3NLMFUycStZL25ValRKNjN0dEVDU0Y2?=
 =?utf-8?B?N3NCbkl5K2lISmM5VzVBUlpsZjJyRitTdlBNS2NTWTN6UWZzQ1M1cmdlOUdM?=
 =?utf-8?B?REZCRk9HMncxeVRKMDdqNm5CYlNSa3lMNXBPM3hlTW9odlZVMUFmUmRsRk5H?=
 =?utf-8?B?RTNzMUM4ZFZBdU1jVEMrdkxnSFl5MllsWDlPcXVwYWhZV1J5UEIwaVhqWTM0?=
 =?utf-8?B?eVE9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6609f08-4204-481e-b667-08db1e651f37
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 17:06:27.1237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Ydk8hrdKlyNq7kfFBmzWzUEGbluUbWI3zIc4wY1o66FiASjDvQjNElu+4hyPwD+06WMZEyltYf4l1FpEKIrwZO57NghJob0VKBSQmPg/Nw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9427
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
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
FW name based on chip signature (Greg KH, Ilpo Järvinen, Sherry Sun)
v5: Replaced bt_dev_info() with bt_dev_dbg(), handled user-space cmd
parsing in nxp_enqueue() in a better way. (Greg KH, Luiz Augusto von Dentz)
v6: Add support for fw-init-baudrate parameter from device tree,
modified logic to detect FW download is needed or FW is running. (Greg
KH, Sherry Sun)
v7: Renamed variables, improved FW download functions, include ps_data
into btnxpuart_dev. (Ilpo Järvinen)
---
 MAINTAINERS                   |    1 +
 drivers/bluetooth/Kconfig     |   11 +
 drivers/bluetooth/Makefile    |    1 +
 drivers/bluetooth/btnxpuart.c | 1309 +++++++++++++++++++++++++++++++++
 4 files changed, 1322 insertions(+)
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
index 000000000000..5c9aa4c24237
--- /dev/null
+++ b/drivers/bluetooth/btnxpuart.c
@@ -0,0 +1,1309 @@
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
+#define BTNXPUART_SERDEV_OPEN		4
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
+struct ps_data {
+	u8    target_ps_mode;	/* ps mode to be set */
+	u8    cur_psmode;	/* current ps_mode */
+	u8    ps_state;		/* controller's power save state */
+	u8    ps_cmd;
+	u8    h2c_wakeupmode;
+	u8    cur_h2c_wakeupmode;
+	u8    c2h_wakeupmode;
+	u8    c2h_wakeup_gpio;
+	u8    h2c_wakeup_gpio;
+	bool  driver_sent_cmd;
+	u16   h2c_ps_interval;
+	u16   c2h_ps_interval;
+	struct hci_dev *hdev;
+	struct work_struct work;
+	struct timer_list ps_timer;
+};
+
+struct wakeup_cmd_payload {
+	u8 c2h_wakeupmode;
+	u8 c2h_wakeup_gpio;
+	u8 h2c_wakeupmode;
+	u8 h2c_wakeup_gpio;
+} __packed;
+
+struct psmode_cmd_payload {
+	u8 ps_cmd;
+	__le16 c2h_ps_interval;
+} __packed;
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
+	struct ps_data psdata;
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
+	struct ps_data *psdata = &nxpdev->psdata;
+	struct sk_buff *skb;
+
+	/* set flag to prevent nxp_enqueue from parsing values from this command and
+	 * calling hci_cmd_sync_queue() again.
+	 */
+	psdata->driver_sent_cmd = true;
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
+	struct ps_data *psdata = &nxpdev->psdata;
+
+	if (!psdata)
+		return;
+
+	if (psdata->cur_psmode == PS_MODE_ENABLE)
+		mod_timer(&psdata->ps_timer, jiffies + msecs_to_jiffies(psdata->h2c_ps_interval));
+}
+
+static void ps_cancel_timer(struct btnxpuart_dev *nxpdev)
+{
+	struct ps_data *psdata = &nxpdev->psdata;
+
+	flush_work(&psdata->work);
+	del_timer_sync(&psdata->ps_timer);
+}
+
+static void ps_control(struct hci_dev *hdev, u8 ps_state)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct ps_data *psdata = &nxpdev->psdata;
+	int status;
+
+	if (psdata->ps_state == ps_state ||
+	    !test_bit(BTNXPUART_SERDEV_OPEN, &nxpdev->tx_state))
+		return;
+
+	switch (psdata->cur_h2c_wakeupmode) {
+	case WAKEUP_METHOD_DTR:
+		if (ps_state == PS_STATE_AWAKE)
+			status = serdev_device_set_tiocm(nxpdev->serdev, TIOCM_DTR, 0);
+		else
+			status = serdev_device_set_tiocm(nxpdev->serdev, 0, TIOCM_DTR);
+		break;
+	case WAKEUP_METHOD_BREAK:
+	default:
+		if (ps_state == PS_STATE_AWAKE)
+			status = serdev_device_break_ctl(nxpdev->serdev, 0);
+		else
+			status = serdev_device_break_ctl(nxpdev->serdev, -1);
+		bt_dev_dbg(hdev, "Set UART break: %s, status=%d",
+			   str_on_off(ps_state == PS_STATE_SLEEP), status);
+		break;
+	}
+	if (!status)
+		psdata->ps_state = ps_state;
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
+	struct ps_data *psdata = &nxpdev->psdata;
+
+	psdata->h2c_ps_interval = PS_DEFAULT_TIMEOUT_PERIOD;
+	psdata->ps_state = PS_STATE_AWAKE;
+	psdata->target_ps_mode = DEFAULT_PS_MODE;
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
+	struct ps_data *psdata = &nxpdev->psdata;
+
+	timer_setup(&psdata->ps_timer, ps_timeout_func, 0);
+}
+
+static void ps_wakeup(struct btnxpuart_dev *nxpdev)
+{
+	struct ps_data *psdata = &nxpdev->psdata;
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
+	struct ps_data *psdata = &nxpdev->psdata;
+	struct psmode_cmd_payload pcmd;
+	struct sk_buff *skb;
+	u8 *status;
+
+	if (psdata->target_ps_mode == PS_MODE_ENABLE)
+		pcmd.ps_cmd = BT_PS_ENABLE;
+	else
+		pcmd.ps_cmd = BT_PS_DISABLE;
+	pcmd.c2h_ps_interval = __cpu_to_le16(psdata->c2h_ps_interval);
+
+	skb = nxp_drv_send_cmd(hdev, HCI_NXP_AUTO_SLEEP_MODE, sizeof(pcmd), &pcmd);
+	if (IS_ERR(skb)) {
+		bt_dev_err(hdev, "Setting Power Save mode failed (%ld)", PTR_ERR(skb));
+		return PTR_ERR(skb);
+	}
+
+	status = skb_pull_data(skb, 1);
+	if (status) {
+		if (!*status)
+			psdata->cur_psmode = psdata->target_ps_mode;
+		else
+			psdata->target_ps_mode = psdata->cur_psmode;
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
+	struct ps_data *psdata = &nxpdev->psdata;
+	struct wakeup_cmd_payload pcmd;
+	struct sk_buff *skb;
+	u8 *status;
+
+	pcmd.c2h_wakeupmode = psdata->c2h_wakeupmode;
+	pcmd.c2h_wakeup_gpio = psdata->c2h_wakeup_gpio;
+	switch (psdata->h2c_wakeupmode) {
+	case WAKEUP_METHOD_DTR:
+		pcmd.h2c_wakeupmode = BT_CTRL_WAKEUP_METHOD_DSR;
+		break;
+	case WAKEUP_METHOD_BREAK:
+	default:
+		pcmd.h2c_wakeupmode = BT_CTRL_WAKEUP_METHOD_BREAK;
+		break;
+	}
+	pcmd.h2c_wakeup_gpio = 0xff;
+
+	skb = nxp_drv_send_cmd(hdev, HCI_NXP_WAKEUP_METHOD, sizeof(pcmd), &pcmd);
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
+	struct ps_data *psdata = &nxpdev->psdata;
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
+	if (psdata->cur_h2c_wakeupmode != psdata->h2c_wakeupmode)
+		hci_cmd_sync_queue(hdev, send_wakeup_method_cmd, NULL, NULL);
+	if (psdata->cur_psmode != psdata->target_ps_mode)
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
+	memset(nxpdev->fw_name, 0, sizeof(nxpdev->fw_name));
+
+	/* Allow the downloaded FW to initialize */
+	usleep_range(800 * USEC_PER_MSEC, 1 * USEC_PER_SEC);
+
+	return 0;
+}
+
+static void nxp_send_ack(u8 ack, struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	u8 ack_nak[2];
+	int len = 1;
+
+	ack_nak[0] = ack;
+	if (ack == NXP_ACK_V3) {
+		ack_nak[1] = crc8(crc8_table, ack_nak, 1, 0xff);
+		len = 2;
+	}
+	serdev_device_write_buf(nxpdev->serdev, ack_nak, len);
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
+static bool is_fw_downloading(struct btnxpuart_dev *nxpdev)
+{
+	return test_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+}
+
+static int nxp_request_firmware(struct hci_dev *hdev, const u8 *fw_name)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	int err = 0;
+
+	if (!strlen(nxpdev->fw_name)) {
+		snprintf(nxpdev->fw_name, MAX_FW_FILE_NAME_LEN, "%s", fw_name);
+
+		bt_dev_dbg(hdev, "Request Firmware: %s", nxpdev->fw_name);
+		err = request_firmware(&nxpdev->fw, nxpdev->fw_name, &hdev->dev);
+		if (err < 0) {
+			bt_dev_err(hdev, "Firmware file %s not found", nxpdev->fw_name);
+			clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+		}
+	}
+	return err;
+}
+
+/* for legacy chipsets with V1 bootloader */
+static int nxp_recv_fw_req_v1(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	struct btnxpuart_data *nxp_data = nxpdev->nxp_data;
+	struct v1_data_req *req;
+	u32 requested_len;
+
+	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
+		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
+		goto ret;
+	}
+
+	if (!is_fw_downloading(nxpdev))
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
+	if (nxp_request_firmware(hdev, nxp_data->fw_name))
+		goto ret;
+
+	requested_len = req->len;
+	if (requested_len == 0) {
+		bt_dev_dbg(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
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
+		} else if (requested_len == HDR_LEN) {
+			/* FW download out of sync. Send previous chunk again */
+			nxpdev->fw_dnld_v1_offset -= nxpdev->fw_v1_sent_bytes;
+			nxpdev->fw_v1_expected_len = HDR_LEN;
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
+		bt_dev_err(hdev, "Unknown chip signature %04x", chipid);
+		break;
+	}
+	return fw_name;
+}
+
+static int nxp_recv_chip_ver_v3(struct hci_dev *hdev, struct sk_buff *skb)
+{
+	struct v3_start_ind *req = skb_pull_data(skb, sizeof(struct v3_start_ind));
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+
+	if (test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state)) {
+		clear_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->check_boot_sign_wait_q);
+		goto ret;
+	}
+
+	if (!is_fw_downloading(nxpdev))
+		goto ret;
+
+	if (!nxp_request_firmware(hdev, nxp_get_fw_name_from_chipid(hdev, req->chip_id)))
+		nxp_send_ack(NXP_ACK_V3, hdev);
+
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
+	if (!is_fw_downloading(nxpdev))
+		goto ret;
+
+	req = (struct v3_data_req *)skb_pull_data(skb, sizeof(struct v3_data_req));
+	if (!req || !nxpdev->fw)
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
+		bt_dev_dbg(hdev, "FW Downloaded Successfully: %zu bytes", nxpdev->fw->size);
+		clear_bit(BTNXPUART_FW_DOWNLOADING, &nxpdev->tx_state);
+		wake_up_interruptible(&nxpdev->fw_dnld_done_wait_q);
+		goto ret;
+	}
+	if (req->error)
+		bt_dev_dbg(hdev, "FW Download received err 0x%02x from chip", req->error);
+
+	if (req->offset < nxpdev->fw_v3_offset_correction) {
+		/* This scenario should ideally never occur. But if it ever does,
+		 * FW is out of sync and needs a power cycle.
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
+	__le32 new_baudrate = __cpu_to_le32(nxpdev->new_baudrate);
+	struct ps_data *psdata = &nxpdev->psdata;
+	struct sk_buff *skb;
+	u8 *status;
+
+	if (!psdata)
+		return 0;
+
+	skb = nxp_drv_send_cmd(hdev, HCI_NXP_SET_OPER_SPEED, 4, (u8 *)&new_baudrate);
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
+static int nxp_check_boot_sign(struct btnxpuart_dev *nxpdev)
+{
+	serdev_device_set_baudrate(nxpdev->serdev, HCI_NXP_PRI_BAUDRATE);
+	serdev_device_set_flow_control(nxpdev->serdev, 0);
+	set_bit(BTNXPUART_CHECK_BOOT_SIGNATURE, &nxpdev->tx_state);
+
+	return wait_event_interruptible_timeout(nxpdev->check_boot_sign_wait_q,
+					       !test_bit(BTNXPUART_CHECK_BOOT_SIGNATURE,
+							 &nxpdev->tx_state),
+					       msecs_to_jiffies(1000));
+}
+
+static int nxp_setup(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+	int err = 0;
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
+	struct ps_data *psdata = &nxpdev->psdata;
+	struct hci_command_hdr *hdr;
+
+	/* if vendor commands are received from user space (e.g. hcitool), update
+	 * driver flags accordingly and ask driver to re-send the command to FW.
+	 * In case the payload for any command does not match expected payload
+	 * length, let the firmware and user space program handle it, or throw
+	 * an error.
+	 */
+	if (bt_cb(skb)->pkt_type == HCI_COMMAND_PKT && !psdata->driver_sent_cmd) {
+		hdr = (struct hci_command_hdr *)skb->data;
+		if (hdr->plen != (skb->len - HCI_COMMAND_HDR_SIZE))
+			goto send_skb;
+
+		switch (__le16_to_cpu(hdr->opcode)) {
+		case HCI_NXP_AUTO_SLEEP_MODE:
+			{
+				struct psmode_cmd_payload param;
+
+				if (hdr->plen != sizeof(param))
+					goto send_skb;
+				memcpy(&param, skb->data + HCI_COMMAND_HDR_SIZE, hdr->plen);
+				if (param.ps_cmd == BT_PS_ENABLE)
+					psdata->target_ps_mode = PS_MODE_ENABLE;
+				else if (param.ps_cmd == BT_PS_DISABLE)
+					psdata->target_ps_mode = PS_MODE_DISABLE;
+				psdata->c2h_ps_interval = __le16_to_cpu(param.c2h_ps_interval);
+				hci_cmd_sync_queue(hdev, send_ps_cmd, NULL, NULL);
+				goto free_skb;
+			}
+			break;
+		case HCI_NXP_WAKEUP_METHOD:
+			{
+				struct wakeup_cmd_payload param;
+
+				if (hdr->plen != sizeof(param))
+					goto send_skb;
+				memcpy(&param, skb->data + HCI_COMMAND_HDR_SIZE, hdr->plen);
+				psdata->c2h_wakeupmode = param.c2h_wakeupmode;
+				psdata->c2h_wakeup_gpio = param.c2h_wakeup_gpio;
+				psdata->h2c_wakeup_gpio = param.h2c_wakeup_gpio;
+				switch (param.h2c_wakeupmode) {
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
+			{
+				__le32 param;
+
+				if (hdr->plen != sizeof(param))
+					goto send_skb;
+				memcpy(&param, skb->data + HCI_COMMAND_HDR_SIZE, hdr->plen);
+				nxpdev->new_baudrate = __le32_to_cpu(param);
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
+	} else {
+		set_bit(BTNXPUART_SERDEV_OPEN, &nxpdev->tx_state);
+	}
+	return err;
+}
+
+static int btnxpuart_close(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
+
+	serdev_device_close(nxpdev->serdev);
+	clear_bit(BTNXPUART_SERDEV_OPEN, &nxpdev->tx_state);
+	return 0;
+}
+
+static int btnxpuart_flush(struct hci_dev *hdev)
+{
+	struct btnxpuart_dev *nxpdev = hci_get_drvdata(hdev);
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
+	if (is_fw_downloading(nxpdev) && !is_valid_bootloader_signature(data, count)) {
+		/* Unknown bootloader signature, skip without returning error */
+		return count;
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
+	ps_init_work(hdev);
+	ps_init_timer(hdev);
+
+	crc8_populate_msb(crc8_table, POLYNOMIAL8);
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
+	return 0;
+}
+
+static void nxp_serdev_remove(struct serdev_device *serdev)
+{
+	struct btnxpuart_dev *nxpdev = serdev_device_get_drvdata(serdev);
+	struct ps_data *psdata = &nxpdev->psdata;
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
+	ps_cancel_timer(nxpdev);
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

