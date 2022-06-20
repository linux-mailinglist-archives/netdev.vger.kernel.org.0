Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12465525BE
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 22:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344511AbiFTU0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 16:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343931AbiFTU0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 16:26:11 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60130.outbound.protection.outlook.com [40.107.6.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3472C1573D;
        Mon, 20 Jun 2022 13:26:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U+hx2cLirGZg9tnWuqNmsxSwYvroo4A3HmeF9eSAH9z0wiI6nt2LG3IYro8TinY7S2u0UaQqUqBd2CtByR9xnCPRqbxIR8s2p4dh+W3rJ65r1aQZoqm/2iwlpy1EIWKvevWNaWv9i0HU1BJ+VjSG78pdPKblodxDM6p0hbpLCrNlqoedObiDS0IAYLV5lV4LNXAt18ejMXwaB20kospatAkyf41xTQVE6f7UQDHA+42NvWBW/7sBBgHP683Ilt0ceT52HnKIjyYfhUFZ1lpsCbCjBZrqrQQgCf+i+xukboJGSoUws9U8r8Y8nsrMJehm5kJodZgU34sbHldf+SVm3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WoNPji7QrhRjlWU0qxvxSQvH9jt/B+/eKHLsA27IhyA=;
 b=B/tNJE0l0lvIIVLQPJr++B1c66lgzUeHygUdbo+S20JKyz3G3T57dGOamxvfy2gAWBO2guBdDK/YezwBCqqJ369TvHF4lQOhTj/TZZ+HZUU34KVa4XO/mMnLcb5QInzGa2TNMcTZ1nkcxhjBW7h819tjItpZ5YokvetbeI0zZFkNrx9+Pi7Zs3G1ELtHEbc79gSkkUYuasqB1iC9vSpXMsqY0e0VDZizlKXD37/Q4kFtbmPdBuQCqpJYQOAsovI9PRRrhpuwgqzM/3bGuLDjWIti8q+4T410Dbnhn1P16j0vXZkOvIy5QeL5P09zeExf6iqKTrCnZfzAM2AzwxGrbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 217.86.141.140) smtp.rcpttodomain=esd.eu smtp.mailfrom=esd.eu;
 dmarc=bestguesspass action=none header.from=esd.eu; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoNPji7QrhRjlWU0qxvxSQvH9jt/B+/eKHLsA27IhyA=;
 b=EgK9XTB3RyVMwVTi6Mxe/LuD6Te0BRpH/GtDM3H0zxMe/iQv23gBNAMtktxGNKFQU0SVb3CM+J+VzhJ6RYz53M8fEMUlnPfkDqQ4H5DOLtswYBMufjmWXqeupAWnAyrdLT2quBcJq7PH0EX2u8NDqEEy3hW8k9SRe9rWEIcyMmU=
Received: from AM6PR04CA0065.eurprd04.prod.outlook.com (2603:10a6:20b:f0::42)
 by PA4PR03MB7246.eurprd03.prod.outlook.com (2603:10a6:102:bc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22; Mon, 20 Jun
 2022 20:26:04 +0000
Received: from VI1EUR06FT062.eop-eur06.prod.protection.outlook.com
 (2603:10a6:20b:f0:cafe::94) by AM6PR04CA0065.outlook.office365.com
 (2603:10a6:20b:f0::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.22 via Frontend
 Transport; Mon, 20 Jun 2022 20:26:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 217.86.141.140)
 smtp.mailfrom=esd.eu; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=esd.eu;
Received-SPF: Pass (protection.outlook.com: domain of esd.eu designates
 217.86.141.140 as permitted sender) receiver=protection.outlook.com;
 client-ip=217.86.141.140; helo=esd-s7.esd; pr=C
Received: from esd-s7.esd (217.86.141.140) by
 VI1EUR06FT062.mail.protection.outlook.com (10.13.6.85) with Microsoft SMTP
 Server id 15.20.5353.14 via Frontend Transport; Mon, 20 Jun 2022 20:26:04
 +0000
Received: from esd-s20.esd.local (debby [10.0.0.190])
        by esd-s7.esd (Postfix) with ESMTPS id CEA377C16C8;
        Mon, 20 Jun 2022 22:26:03 +0200 (CEST)
Received: by esd-s20.esd.local (Postfix, from userid 2046)
        id AD4D82E4AED; Mon, 20 Jun 2022 22:26:03 +0200 (CEST)
From:   Frank Jungclaus <frank.jungclaus@esd.eu>
To:     linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frank Jungclaus <frank.jungclaus@esd.eu>
Subject: [PATCH 1/1] can/esd_usb2: Added support for esd CAN-USB/3
Date:   Mon, 20 Jun 2022 22:26:03 +0200
Message-Id: <20220620202603.2069841-2-frank.jungclaus@esd.eu>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220620202603.2069841-1-frank.jungclaus@esd.eu>
References: <20220620202603.2069841-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 2f0c69c9-f86a-42c3-776f-08da52fb1960
X-MS-TrafficTypeDiagnostic: PA4PR03MB7246:EE_
X-Microsoft-Antispam-PRVS: <PA4PR03MB724687DE4086364933AB3DEC96B09@PA4PR03MB7246.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5I72UUrLQVPzv7R3gOE+vHxp+5TOW9gofQ8r4i6ERKD3Y4TcFs5VNBEFqTVY9TuBb9CT/s8WutCrAR5OiX+7Z9PYGrNLxgwb5DMT6A81D9MaPwm0X0/JEdCcTC77ZrH+icx52S9WFaRpFST0vsQaHVXjQ12MSYvPAVJ0I3Augss9paq1ENalHwY4zOUGU4CNB956vb3ZRMUTyfEkxt2Y+DGXDXai3ScQbUCXk7/rfZOpU7RTcWjHkoqRhuPa1crsAUPp7M4pU13IdUR3q+WJdvzoDhaEGfUwrig9sk7PzhGtHxWOEv5VxxfyeLuQJU6sy/8SXILdnYSV4OqKK0wXyfGjIOk/BeTD+oadYKOUEQICoC7OMTc4qE51cSoiuefXtFwGOVtaJ2n15xNstiv/jHWnz23xcU7JCvPCSMHopJPIfujlxdgAd1jwuAYV8jTWUFuIFqavGcqRIW/iBs/kvGVmcVd7BzEub1xsFNm6sldlqD+pnWeCpE4l+KMV5M4RU6DVxAhIS+HMFn9we4pyxLTbZJNm1sV6OvFL/jRCvz2AJWDCyX2VeqLAfpUAk5rVh8jmRXw+2rFHVUvjVVFilbO9OoZ0tGDf8YzS772TDV95ShRpvaWyIGuGKINTIIiAf0/ZstTrR/S/YvkAoFNCyQ6TnZV2JOYZxG4aNniPqpUHkEMBxvK+rDu/lTTe+gp
X-Forefront-Antispam-Report: CIP:217.86.141.140;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:esd-s7.esd;PTR:pd9568d8c.dip0.t-ipconnect.de;CAT:NONE;SFS:(13230016)(4636009)(396003)(39840400004)(136003)(346002)(376002)(46966006)(36840700001)(2906002)(36756003)(44832011)(40480700001)(82310400005)(4326008)(5660300002)(8936002)(36860700001)(30864003)(8676002)(54906003)(316002)(42186006)(110136005)(478600001)(70206006)(70586007)(26005)(356005)(6266002)(41300700001)(2616005)(1076003)(86362001)(186003)(83380400001)(336012)(47076005)(81166007)(579004);DIR:OUT;SFP:1102;
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 20:26:04.1586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f0c69c9-f86a-42c3-776f-08da52fb1960
X-MS-Exchange-CrossTenant-Id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5a9c3a1d-52db-4235-b74c-9fd851db2e6b;Ip=[217.86.141.140];Helo=[esd-s7.esd]
X-MS-Exchange-CrossTenant-AuthSource: VI1EUR06FT062.eop-eur06.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7246
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for the newly available esd CAN-USB/3.
---
 drivers/net/can/usb/esd_usb2.c | 647 ++++++++++++++++++++++++---------
 1 file changed, 467 insertions(+), 180 deletions(-)

diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 286daaaea0b8..062f3dd922d2 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -1,9 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * CAN driver for esd CAN-USB/2 and CAN-USB/Micro
+ * CAN driver for esd CAN-USB/2, CAN-USB/3 and CAN-USB/Micro
  *
- * Copyright (C) 2010-2012 Matthias Fuchs <matthias.fuchs@esd.eu>, esd gmbh
+ * Copyright (C) 2010-     Matthias Fuchs                          , esd gmbh
+ * Copyright (C) 2022-     Frank Jungclaus <frank.jungclaus@esd.eu>, esd gmbh
  */
+
 #include <linux/signal.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -14,20 +16,25 @@
 #include <linux/can/dev.h>
 #include <linux/can/error.h>
 
-MODULE_AUTHOR("Matthias Fuchs <matthias.fuchs@esd.eu>");
-MODULE_DESCRIPTION("CAN driver for esd CAN-USB/2 and CAN-USB/Micro interfaces");
+MODULE_AUTHOR("Frank Jungclaus <frank.jungclaus@esd.eu>");
+MODULE_DESCRIPTION("CAN driver for esd CAN-USB/2, CAN-USB/3 and CAN-USB/Micro interfaces");
 MODULE_LICENSE("GPL v2");
 
-/* Define these values to match your devices */
+/* USB vendor and product ID */
 #define USB_ESDGMBH_VENDOR_ID	0x0ab4
 #define USB_CANUSB2_PRODUCT_ID	0x0010
 #define USB_CANUSBM_PRODUCT_ID	0x0011
+#define USB_CANUSB3_PRODUCT_ID	0x0014
 
+/* CAN controller clock frequencies */
 #define ESD_USB2_CAN_CLOCK	60000000
 #define ESD_USBM_CAN_CLOCK	36000000
-#define ESD_USB2_MAX_NETS	2
+#define ESD_USB3_CAN_CLOCK	80000000
+
+/* Maximum number of CAN nets */
+#define ESD_USB_MAX_NETS	2
 
-/* USB2 commands */
+/* USB commands */
 #define CMD_VERSION		1 /* also used for VERSION_REPLY */
 #define CMD_CAN_RX		2 /* device to host only */
 #define CMD_CAN_TX		3 /* also used for TX_DONE */
@@ -36,20 +43,29 @@ MODULE_LICENSE("GPL v2");
 #define CMD_IDADD		6 /* also used for IDADD_REPLY */
 
 /* esd CAN message flags - dlc field */
-#define ESD_RTR			0x10
+#define ESD_DLC_RTR		0x10
+#define ESD_DLC_NO_BRS		0x10
+#define ESD_DLC_ESI		0x20
+#define ESD_DLC_FD		0x80
+
 
 /* esd CAN message flags - id field */
 #define ESD_EXTID		0x20000000
 #define ESD_EVENT		0x40000000
 #define ESD_IDMASK		0x1fffffff
 
-/* esd CAN event ids used by this driver */
-#define ESD_EV_CAN_ERROR_EXT	2
+/* esd CAN event ids */
+#define ESD_EV_CAN_ERROR	0 /* General bus diagnostics data */
+#define ESD_EV_BAUD_CHANGE	1 /* Bit rate change event (unused within this driver) */
+#define ESD_EV_CAN_ERROR_EXT	2 /* CAN controller specific diagnostic data */
+#define ESD_EV_BUSLOAD		3 /* Busload event (unused within this driver) */
 
-/* baudrate message flags */
+/* Baudrate message flags */
 #define ESD_USB2_UBR		0x80000000
 #define ESD_USB2_LOM		0x40000000
 #define ESD_USB2_NO_BAUDRATE	0x7fffffff
+
+/* Bit timing CAN-USB/2 */
 #define ESD_USB2_TSEG1_MIN	1
 #define ESD_USB2_TSEG1_MAX	16
 #define ESD_USB2_TSEG1_SHIFT	16
@@ -64,6 +80,28 @@ MODULE_LICENSE("GPL v2");
 #define ESD_USB2_BRP_INC	1
 #define ESD_USB2_3_SAMPLES	0x00800000
 
+/* Bit timing CAN-USB/3 */
+#define ESD_USB3_TSEG1_MIN	1
+#define ESD_USB3_TSEG1_MAX	256
+#define ESD_USB3_TSEG2_MIN	1
+#define ESD_USB3_TSEG2_MAX	128
+#define ESD_USB3_SJW_MAX	128
+#define ESD_USB3_BRP_MIN	1
+#define ESD_USB3_BRP_MAX	1024
+#define ESD_USB3_BRP_INC	1
+/* Bit timing CAN-USB/3, data phase */
+#define ESD_USB3_DATA_TSEG1_MIN	1
+#define ESD_USB3_DATA_TSEG1_MAX	32
+#define ESD_USB3_DATA_TSEG2_MIN	1
+#define ESD_USB3_DATA_TSEG2_MAX	16
+#define ESD_USB3_DATA_SJW_MAX	8
+#define ESD_USB3_DATA_BRP_MIN	1
+#define ESD_USB3_DATA_BRP_MAX	32
+#define ESD_USB3_DATA_BRP_INC	1
+
+/* Transmitter Delay Compensation */
+#define ESD_TDC_MODE_AUTO       0
+
 /* esd IDADD message */
 #define ESD_ID_ENABLE		0x80
 #define ESD_MAX_ID_SEGMENT	64
@@ -78,15 +116,31 @@ MODULE_LICENSE("GPL v2");
 #define SJA1000_ECC_MASK	0xc0
 
 /* esd bus state event codes */
-#define ESD_BUSSTATE_MASK	0xc0
+#define ESD_BUSSTATE_OK         0x00
 #define ESD_BUSSTATE_WARN	0x40
 #define ESD_BUSSTATE_ERRPASSIVE	0x80
 #define ESD_BUSSTATE_BUSOFF	0xc0
+#define ESD_BUSSTATE_MASK	0xc0
 
 #define RX_BUFFER_SIZE		1024
 #define MAX_RX_URBS		4
 #define MAX_TX_URBS		16 /* must be power of 2 */
 
+/* Modes for NTCAN_BAUDRATE_X */
+#define ESD_BAUDRATE_MODE_DISABLE          0      /* Remove from bus        */
+#define ESD_BAUDRATE_MODE_INDEX            1      /* ESD (CiA) bit rate idx */
+#define ESD_BAUDRATE_MODE_BTR_CTRL         2      /* BTR values (Controller)*/
+#define ESD_BAUDRATE_MODE_BTR_CANONICAL    3      /* BTR values (Canonical) */
+#define ESD_BAUDRATE_MODE_NUM              4      /* Numerical bit rate     */
+#define ESD_BAUDRATE_MODE_AUTOBAUD         5      /* Autobaud               */
+
+/* Flags for NTCAN_BAUDRATE_X */
+#define ESD_BAUDRATE_FLAG_FD     0x0001        /* Enable CAN FD Mode        */
+#define ESD_BAUDRATE_FLAG_LOM    0x0002        /* Enable Listen Only mode   */
+#define ESD_BAUDRATE_FLAG_STM    0x0004        /* Enable Self test mode     */
+#define ESD_BAUDRATE_FLAG_TRS    0x0008        /* Enable Triple Sampling    */
+#define ESD_BAUDRATE_FLAG_TXP    0x0010        /* Enable Transmit Pause     */
+
 struct header_msg {
 	u8 len; /* len is always the total message length in 32bit words */
 	u8 cmd;
@@ -119,7 +173,10 @@ struct rx_msg {
 	u8 dlc;
 	__le32 ts;
 	__le32 id; /* upper 3 bits contain flags */
-	u8 data[8];
+	union {
+		u8 cc[8];  /* classic CAN */
+		u8 fd[64]; /* CAN FD */
+	} data;
 };
 
 struct tx_msg {
@@ -127,9 +184,12 @@ struct tx_msg {
 	u8 cmd;
 	u8 net;
 	u8 dlc;
-	u32 hnd;	/* opaque handle, not used by device */
+	u32 hnd;   /* opaque handle, not used by device */
 	__le32 id; /* upper 3 bits contain flags */
-	u8 data[8];
+	union {
+		u8 cc[8];  /* classic CAN */
+		u8 fd[64]; /* CAN FD */
+	} data;
 };
 
 struct tx_done_msg {
@@ -149,16 +209,41 @@ struct id_filter_msg {
 	__le32 mask[ESD_MAX_ID_SEGMENT + 1];
 };
 
+struct baudrate_x_cfg {
+	__le16 brp;          /* Bit rate pre-scaler                   */
+	__le16 tseg1;        /* TSEG1 register                        */
+	__le16 tseg2;        /* TSEG2 register                        */
+	__le16 sjw;          /* SJW register                          */
+};
+
+struct tdc_cfg {
+	u8 tdc_mode;    /* Transmitter Delay Compensation mode  */
+	u8 ssp_offset;  /* Secondary Sample Point offset in mtq */
+	s8 ssp_shift;   /* Secondary Sample Point shift in mtq  */
+	u8 tdc_filter;  /* Transmitter Delay Compensation       */
+};
+
+struct baudrate_x {
+	__le16 mode;        /* Mode word                          */
+	__le16 flags;       /* Control flags                      */
+	struct tdc_cfg tdc; /* TDC configuration                  */
+	struct baudrate_x_cfg arb;  /* Bit rate during arbitration phase  */
+	struct baudrate_x_cfg data; /* Bit rate during data phase         */
+};
+
 struct set_baudrate_msg {
 	u8 len;
 	u8 cmd;
 	u8 net;
 	u8 rsvd;
-	__le32 baud;
+	union {
+		__le32 baud;
+		struct baudrate_x baud_x;
+	} u;
 };
 
 /* Main message type used between library and application */
-struct __attribute__ ((packed)) esd_usb2_msg {
+struct __packed esd_usb_msg {
 	union {
 		struct header_msg hdr;
 		struct version_msg version;
@@ -171,23 +256,24 @@ struct __attribute__ ((packed)) esd_usb2_msg {
 	} msg;
 };
 
-static struct usb_device_id esd_usb2_table[] = {
+static struct usb_device_id esd_usb_table[] = {
 	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB2_PRODUCT_ID)},
 	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSBM_PRODUCT_ID)},
+	{USB_DEVICE(USB_ESDGMBH_VENDOR_ID, USB_CANUSB3_PRODUCT_ID)},
 	{}
 };
-MODULE_DEVICE_TABLE(usb, esd_usb2_table);
+MODULE_DEVICE_TABLE(usb, esd_usb_table);
 
-struct esd_usb2_net_priv;
+struct esd_usb_net_priv;
 
 struct esd_tx_urb_context {
-	struct esd_usb2_net_priv *priv;
+	struct esd_usb_net_priv *priv;
 	u32 echo_index;
 };
 
-struct esd_usb2 {
+struct esd_usb {
 	struct usb_device *udev;
-	struct esd_usb2_net_priv *nets[ESD_USB2_MAX_NETS];
+	struct esd_usb_net_priv *nets[ESD_USB_MAX_NETS];
 
 	struct usb_anchor rx_submitted;
 
@@ -198,36 +284,64 @@ struct esd_usb2 {
 	dma_addr_t rxbuf_dma[MAX_RX_URBS];
 };
 
-struct esd_usb2_net_priv {
+struct esd_usb_net_priv {
 	struct can_priv can; /* must be the first member */
 
 	atomic_t active_tx_jobs;
 	struct usb_anchor tx_submitted;
 	struct esd_tx_urb_context tx_contexts[MAX_TX_URBS];
 
-	struct esd_usb2 *usb2;
+	struct esd_usb *usb;
 	struct net_device *netdev;
 	int index;
 	u8 old_state;
 	struct can_berr_counter bec;
 };
 
-static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
-			      struct esd_usb2_msg *msg)
+static void esd_usb_rx_event(struct esd_usb_net_priv *priv, struct esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct can_frame *cf;
 	struct sk_buff *skb;
 	u32 id = le32_to_cpu(msg->msg.rx.id) & ESD_IDMASK;
 
+#if defined(DEBUG)
+	{
+		static struct esd_usb_msg old_msg;
+		static u32 rx_event_cnt;
+
+		msg->msg.rx.ts = 0;
+		if (memcmp(msg, &old_msg, 16)) {
+			netdev_info(priv->netdev,
+				    "EVENT:%08d: id=%#02x dlc=%#02x %02x %02x %02x %02x - %02x %02x %02x %02x\n",
+				    rx_event_cnt,
+				    id,
+				    msg->msg.rx.dlc,
+				    msg->msg.rx.data.cc[0],
+				    msg->msg.rx.data.cc[1],
+				    msg->msg.rx.data.cc[2],
+				    msg->msg.rx.data.cc[3],
+				    msg->msg.rx.data.cc[4],
+				    msg->msg.rx.data.cc[5],
+				    msg->msg.rx.data.cc[6],
+				    msg->msg.rx.data.cc[7]);
+			memcpy(&old_msg, msg, 16);
+		}
+		rx_event_cnt++;
+	}
+#endif /* DEBUG */
+
 	if (id == ESD_EV_CAN_ERROR_EXT) {
-		u8 state = msg->msg.rx.data[0];
-		u8 ecc = msg->msg.rx.data[1];
-		u8 rxerr = msg->msg.rx.data[2];
-		u8 txerr = msg->msg.rx.data[3];
+		/* Here, for ESD_EV_CAN_ERROR_EXT we don't need
+		 * any special treatment for EVMSG_X
+		 */
+		u8 state = msg->msg.rx.data.cc[0];
+		u8 ecc	 = msg->msg.rx.data.cc[1];
+		u8 rxerr = msg->msg.rx.data.cc[2];
+		u8 txerr = msg->msg.rx.data.cc[3];
 
 		skb = alloc_can_err_skb(priv->netdev, &cf);
-		if (skb == NULL) {
+		if (!skb) {
 			stats->rx_dropped++;
 			return;
 		}
@@ -280,7 +394,7 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
-			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
+				priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
 					CAN_ERR_CRTL_TX_PASSIVE :
 					CAN_ERR_CRTL_RX_PASSIVE;
@@ -293,16 +407,40 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 		priv->bec.rxerr = rxerr;
 
 		netif_rx(skb);
+
+	} else if (id == ESD_EV_CAN_ERROR) {
+		u8 state = msg->msg.rx.data.cc[1];
+
+		/* Switching back to Error Warn and back to Error Passive
+		 * only is announced by means of a non-extended Error Event ...
+		 */
+		switch (state & ESD_BUSSTATE_MASK) {
+		case ESD_BUSSTATE_OK:
+			priv->old_state = state;
+			priv->can.state = CAN_STATE_ERROR_ACTIVE;
+			priv->bec.txerr = 0;
+			priv->bec.rxerr = 0;
+			break;
+		case ESD_BUSSTATE_WARN:
+			/* ... intentionally, don't set priv->old_state here! */
+			priv->can.state = CAN_STATE_ERROR_WARNING;
+			break;
+		default:
+			/* Do nothing ... */
+			break;
+		}
 	}
 }
 
-static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
-				struct esd_usb2_msg *msg)
+static void esd_usb_rx_can_msg(struct esd_usb_net_priv *priv, struct esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
-	struct can_frame *cf;
+	/* can.h:
+	 *	  ... the struct can_frame and struct canfd_frame intentionally
+	 *	      share the same layout ...
+	 */
+	struct canfd_frame *cfd;
 	struct sk_buff *skb;
-	int i;
 	u32 id;
 
 	if (!netif_device_present(priv->netdev))
@@ -311,39 +449,63 @@ static void esd_usb2_rx_can_msg(struct esd_usb2_net_priv *priv,
 	id = le32_to_cpu(msg->msg.rx.id);
 
 	if (id & ESD_EVENT) {
-		esd_usb2_rx_event(priv, msg);
+		esd_usb_rx_event(priv, msg);
 	} else {
-		skb = alloc_can_skb(priv->netdev, &cf);
-		if (skb == NULL) {
-			stats->rx_dropped++;
-			return;
-		}
 
-		cf->can_id = id & ESD_IDMASK;
-		can_frame_set_cc_len(cf, msg->msg.rx.dlc & ~ESD_RTR,
-				     priv->can.ctrlmode);
+		if (msg->msg.rx.dlc & ESD_DLC_FD) {
+			/* CAN FD */
+			skb = alloc_canfd_skb(priv->netdev, &cfd);
+			if (!skb) {
+				stats->rx_dropped++;
+				return;
+			}
 
-		if (id & ESD_EXTID)
-			cf->can_id |= CAN_EFF_FLAG;
+			/* Masking by 0x0F is already done within can_fd_dlc2len()! */
+			cfd->len = can_fd_dlc2len(msg->msg.rx.dlc);
+
+			if ((msg->msg.rx.dlc & ESD_DLC_NO_BRS) == 0)
+				cfd->flags |= CANFD_BRS;
+
+			if (msg->msg.rx.dlc & ESD_DLC_ESI)
+				cfd->flags |= CANFD_ESI;
 
-		if (msg->msg.rx.dlc & ESD_RTR) {
-			cf->can_id |= CAN_RTR_FLAG;
+			memcpy(cfd->data, msg->msg.rx.data.fd, cfd->len);
+			stats->rx_bytes += cfd->len;
 		} else {
-			for (i = 0; i < cf->len; i++)
-				cf->data[i] = msg->msg.rx.data[i];
+			/* Classic CAN */
+			skb = alloc_can_skb(priv->netdev, (struct can_frame **)&cfd);
+			if (!skb) {
+				stats->rx_dropped++;
+				return;
+			}
 
-			stats->rx_bytes += cf->len;
+			can_frame_set_cc_len((struct can_frame *)cfd,
+					     msg->msg.rx.dlc & 0x0F,
+					     priv->can.ctrlmode);
+
+			if (msg->msg.rx.dlc & ESD_DLC_RTR) {
+				/* No data copy for a RTR frame */
+				cfd->can_id |= CAN_RTR_FLAG; // ok, due to memset(0)
+							     // in alloc_can_skb()
+			} else {
+				memcpy(cfd->data, msg->msg.rx.data.cc, cfd->len);
+				stats->rx_bytes += cfd->len;
+			}
 		}
-		stats->rx_packets++;
 
+		/* Common part for CAN FD and CAN classic ... */
+		cfd->can_id |= id & ESD_IDMASK;
+
+		if (id & ESD_EXTID)
+			cfd->can_id |= CAN_EFF_FLAG;
+
+		stats->rx_packets++;
 		netif_rx(skb);
 	}
 
-	return;
 }
 
-static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
-				 struct esd_usb2_msg *msg)
+static void esd_usb_tx_done_msg(struct esd_usb_net_priv *priv, struct esd_usb_msg *msg)
 {
 	struct net_device_stats *stats = &priv->netdev->stats;
 	struct net_device *netdev = priv->netdev;
@@ -356,8 +518,7 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
 
 	if (!msg->msg.txdone.status) {
 		stats->tx_packets++;
-		stats->tx_bytes += can_get_echo_skb(netdev, context->echo_index,
-						    NULL);
+		stats->tx_bytes += can_get_echo_skb(netdev, context->echo_index, NULL);
 	} else {
 		stats->tx_errors++;
 		can_free_echo_skb(netdev, context->echo_index, NULL);
@@ -370,9 +531,9 @@ static void esd_usb2_tx_done_msg(struct esd_usb2_net_priv *priv,
 	netif_wake_queue(netdev);
 }
 
-static void esd_usb2_read_bulk_callback(struct urb *urb)
+static void esd_usb_read_bulk_callback(struct urb *urb)
 {
-	struct esd_usb2 *dev = urb->context;
+	struct esd_usb *dev = urb->context;
 	int retval;
 	int pos = 0;
 	int i;
@@ -394,9 +555,9 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 	}
 
 	while (pos < urb->actual_length) {
-		struct esd_usb2_msg *msg;
+		struct esd_usb_msg *msg;
 
-		msg = (struct esd_usb2_msg *)(urb->transfer_buffer + pos);
+		msg = (struct esd_usb_msg *)(urb->transfer_buffer + pos);
 
 		switch (msg->msg.hdr.cmd) {
 		case CMD_CAN_RX:
@@ -405,7 +566,7 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 				break;
 			}
 
-			esd_usb2_rx_can_msg(dev->nets[msg->msg.rx.net], msg);
+			esd_usb_rx_can_msg(dev->nets[msg->msg.rx.net], msg);
 			break;
 
 		case CMD_CAN_TX:
@@ -414,8 +575,7 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 				break;
 			}
 
-			esd_usb2_tx_done_msg(dev->nets[msg->msg.txdone.net],
-					     msg);
+			esd_usb_tx_done_msg(dev->nets[msg->msg.txdone.net], msg);
 			break;
 		}
 
@@ -429,8 +589,8 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 
 resubmit_urb:
 	usb_fill_bulk_urb(urb, dev->udev, usb_rcvbulkpipe(dev->udev, 1),
-			  urb->transfer_buffer, RX_BUFFER_SIZE,
-			  esd_usb2_read_bulk_callback, dev);
+			urb->transfer_buffer, RX_BUFFER_SIZE,
+			esd_usb_read_bulk_callback, dev);
 
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
 	if (retval == -ENODEV) {
@@ -443,18 +603,17 @@ static void esd_usb2_read_bulk_callback(struct urb *urb)
 			"failed resubmitting read bulk urb: %d\n", retval);
 	}
 
-	return;
 }
 
 /*
  * callback for bulk IN urb
  */
-static void esd_usb2_write_bulk_callback(struct urb *urb)
+static void esd_usb_write_bulk_callback(struct urb *urb)
 {
 	struct esd_tx_urb_context *context = urb->context;
-	struct esd_usb2_net_priv *priv;
+	struct esd_usb_net_priv *priv;
 	struct net_device *netdev;
-	size_t size = sizeof(struct esd_usb2_msg);
+	size_t size = sizeof(struct esd_usb_msg);
 
 	WARN_ON(!context);
 
@@ -478,7 +637,7 @@ static ssize_t firmware_show(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 
 	return sprintf(buf, "%d.%d.%d\n",
 		       (dev->version >> 12) & 0xf,
@@ -491,7 +650,7 @@ static ssize_t hardware_show(struct device *d,
 			     struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 
 	return sprintf(buf, "%d.%d.%d\n",
 		       (dev->version >> 28) & 0xf,
@@ -504,13 +663,13 @@ static ssize_t nets_show(struct device *d,
 			 struct device_attribute *attr, char *buf)
 {
 	struct usb_interface *intf = to_usb_interface(d);
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 
 	return sprintf(buf, "%d", dev->net_count);
 }
 static DEVICE_ATTR_RO(nets);
 
-static int esd_usb2_send_msg(struct esd_usb2 *dev, struct esd_usb2_msg *msg)
+static int esd_usb_send_msg(struct esd_usb *dev, struct esd_usb_msg *msg)
 {
 	int actual_length;
 
@@ -522,8 +681,7 @@ static int esd_usb2_send_msg(struct esd_usb2 *dev, struct esd_usb2_msg *msg)
 			    1000);
 }
 
-static int esd_usb2_wait_msg(struct esd_usb2 *dev,
-			     struct esd_usb2_msg *msg)
+static int esd_usb_wait_msg(struct esd_usb *dev, struct esd_usb_msg *msg)
 {
 	int actual_length;
 
@@ -535,7 +693,7 @@ static int esd_usb2_wait_msg(struct esd_usb2 *dev,
 			    1000);
 }
 
-static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
+static int esd_usb_setup_rx_urbs(struct esd_usb *dev)
 {
 	int i, err = 0;
 
@@ -554,8 +712,7 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 			break;
 		}
 
-		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL,
-					 &buf_dma);
+		buf = usb_alloc_coherent(dev->udev, RX_BUFFER_SIZE, GFP_KERNEL, &buf_dma);
 		if (!buf) {
 			dev_warn(dev->udev->dev.parent,
 				 "No memory left for USB buffer\n");
@@ -568,15 +725,14 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 		usb_fill_bulk_urb(urb, dev->udev,
 				  usb_rcvbulkpipe(dev->udev, 1),
 				  buf, RX_BUFFER_SIZE,
-				  esd_usb2_read_bulk_callback, dev);
+				  esd_usb_read_bulk_callback, dev);
 		urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 		usb_anchor_urb(urb, &dev->rx_submitted);
 
 		err = usb_submit_urb(urb, GFP_KERNEL);
 		if (err) {
 			usb_unanchor_urb(urb);
-			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf,
-					  urb->transfer_dma);
+			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf, urb->transfer_dma);
 			goto freeurb;
 		}
 
@@ -609,11 +765,11 @@ static int esd_usb2_setup_rx_urbs(struct esd_usb2 *dev)
 /*
  * Start interface
  */
-static int esd_usb2_start(struct esd_usb2_net_priv *priv)
+static int esd_usb_start(struct esd_usb_net_priv *priv)
 {
-	struct esd_usb2 *dev = priv->usb2;
+	struct esd_usb *dev = priv->usb;
 	struct net_device *netdev = priv->netdev;
-	struct esd_usb2_msg *msg;
+	struct esd_usb_msg *msg;
 	int err, i;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
@@ -624,7 +780,7 @@ static int esd_usb2_start(struct esd_usb2_net_priv *priv)
 
 	/*
 	 * Enable all IDs
-	 * The IDADD message takes up to 64 32 bit bitmasks (2048 bits).
+	 * The IDADD message takes up to 64 32-bit bitmasks (2048 bits).
 	 * Each bit represents one 11 bit CAN identifier. A set bit
 	 * enables reception of the corresponding CAN identifier. A cleared
 	 * bit disabled this identifier. An additional bitmask value
@@ -641,14 +797,15 @@ static int esd_usb2_start(struct esd_usb2_net_priv *priv)
 	msg->msg.filter.option = ESD_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i < ESD_MAX_ID_SEGMENT; i++)
 		msg->msg.filter.mask[i] = cpu_to_le32(0xffffffff);
+
 	/* enable 29bit extended IDs */
 	msg->msg.filter.mask[ESD_MAX_ID_SEGMENT] = cpu_to_le32(0x00000001);
 
-	err = esd_usb2_send_msg(dev, msg);
+	err = esd_usb_send_msg(dev, msg);
 	if (err)
 		goto out;
 
-	err = esd_usb2_setup_rx_urbs(dev);
+	err = esd_usb_setup_rx_urbs(dev);
 	if (err)
 		goto out;
 
@@ -664,16 +821,16 @@ static int esd_usb2_start(struct esd_usb2_net_priv *priv)
 	return err;
 }
 
-static void unlink_all_urbs(struct esd_usb2 *dev)
+static void unlink_all_urbs(struct esd_usb *dev)
 {
-	struct esd_usb2_net_priv *priv;
+	struct esd_usb_net_priv *priv;
 	int i, j;
 
 	usb_kill_anchored_urbs(&dev->rx_submitted);
 
 	for (i = 0; i < MAX_RX_URBS; ++i)
-		usb_free_coherent(dev->udev, RX_BUFFER_SIZE,
-				  dev->rxbuf[i], dev->rxbuf_dma[i]);
+		usb_free_coherent(dev->udev, RX_BUFFER_SIZE, dev->rxbuf[i], dev->rxbuf_dma[i]);
+
 
 	for (i = 0; i < dev->net_count; i++) {
 		priv = dev->nets[i];
@@ -687,9 +844,9 @@ static void unlink_all_urbs(struct esd_usb2 *dev)
 	}
 }
 
-static int esd_usb2_open(struct net_device *netdev)
+static int esd_usb_open(struct net_device *netdev)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 	int err;
 
 	/* common open */
@@ -698,7 +855,7 @@ static int esd_usb2_open(struct net_device *netdev)
 		return err;
 
 	/* finally start device */
-	err = esd_usb2_start(priv);
+	err = esd_usb_start(priv);
 	if (err) {
 		netdev_warn(netdev, "couldn't start device: %d\n", err);
 		close_candev(netdev);
@@ -710,20 +867,23 @@ static int esd_usb2_open(struct net_device *netdev)
 	return 0;
 }
 
-static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
-				      struct net_device *netdev)
+static netdev_tx_t esd_usb_start_xmit(struct sk_buff *skb, struct net_device *netdev)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
-	struct esd_usb2 *dev = priv->usb2;
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb *dev = priv->usb;
 	struct esd_tx_urb_context *context = NULL;
 	struct net_device_stats *stats = &netdev->stats;
-	struct can_frame *cf = (struct can_frame *)skb->data;
-	struct esd_usb2_msg *msg;
+	/* can.h:
+	 *    ... the struct can_frame and struct canfd_frame intentionally
+	 *	  share the same layout ...
+	 */
+	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
+	struct esd_usb_msg *msg;
 	struct urb *urb;
 	u8 *buf;
 	int i, err;
 	int ret = NETDEV_TX_OK;
-	size_t size = sizeof(struct esd_usb2_msg);
+	size_t size = sizeof(struct esd_usb_msg);
 
 	if (can_dropped_invalid_skb(netdev, skb))
 		return NETDEV_TX_OK;
@@ -736,8 +896,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 		goto nourbmem;
 	}
 
-	buf = usb_alloc_coherent(dev->udev, size, GFP_ATOMIC,
-				 &urb->transfer_dma);
+	buf = usb_alloc_coherent(dev->udev, size, GFP_ATOMIC, &urb->transfer_dma);
 	if (!buf) {
 		netdev_err(netdev, "No memory left for USB buffer\n");
 		stats->tx_dropped++;
@@ -745,24 +904,35 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 		goto nobufmem;
 	}
 
-	msg = (struct esd_usb2_msg *)buf;
+	msg = (struct esd_usb_msg *)buf;
 
 	msg->msg.hdr.len = 3; /* minimal length */
 	msg->msg.hdr.cmd = CMD_CAN_TX;
 	msg->msg.tx.net = priv->index;
-	msg->msg.tx.dlc = can_get_cc_dlc(cf, priv->can.ctrlmode);
-	msg->msg.tx.id = cpu_to_le32(cf->can_id & CAN_ERR_MASK);
 
-	if (cf->can_id & CAN_RTR_FLAG)
-		msg->msg.tx.dlc |= ESD_RTR;
+	if (can_is_canfd_skb(skb)) {
+		/* CAN FD */
+		msg->msg.tx.dlc = can_fd_len2dlc(cfd->len);
+		msg->msg.tx.dlc |= ESD_DLC_FD;
 
-	if (cf->can_id & CAN_EFF_FLAG)
-		msg->msg.tx.id |= cpu_to_le32(ESD_EXTID);
+		if ((cfd->flags & CANFD_BRS) == 0)
+			msg->msg.tx.dlc |= ESD_DLC_NO_BRS;
+	} else {
+		/* Classic CAN */
+		msg->msg.tx.dlc = can_get_cc_dlc((struct can_frame *)cfd, priv->can.ctrlmode);
+
+		if (cfd->can_id & CAN_RTR_FLAG)
+			msg->msg.tx.dlc |= ESD_DLC_RTR;
+	}
 
-	for (i = 0; i < cf->len; i++)
-		msg->msg.tx.data[i] = cf->data[i];
+	/* Common for classic CAN and CAN FD */
+	msg->msg.hdr.len += (cfd->len + 3) >> 2;
 
-	msg->msg.hdr.len += (cf->len + 3) >> 2;
+	msg->msg.tx.id	= cpu_to_le32(cfd->can_id & CAN_ERR_MASK);
+	if (cfd->can_id & CAN_EFF_FLAG)
+		msg->msg.tx.id |= cpu_to_le32(ESD_EXTID);
+
+	memcpy(msg->msg.tx.data.fd, cfd->data, cfd->len);
 
 	for (i = 0; i < MAX_TX_URBS; i++) {
 		if (priv->tx_contexts[i].echo_index == MAX_TX_URBS) {
@@ -788,7 +958,7 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 
 	usb_fill_bulk_urb(urb, dev->udev, usb_sndbulkpipe(dev->udev, 2), buf,
 			  msg->msg.hdr.len << 2,
-			  esd_usb2_write_bulk_callback, context);
+			  esd_usb_write_bulk_callback, context);
 
 	urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
 
@@ -839,33 +1009,34 @@ static netdev_tx_t esd_usb2_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-static int esd_usb2_close(struct net_device *netdev)
+static int esd_usb_close(struct net_device *netdev)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
-	struct esd_usb2_msg *msg;
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb_msg *msg;
 	int i;
 
 	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
 	if (!msg)
 		return -ENOMEM;
 
-	/* Disable all IDs (see esd_usb2_start()) */
+	/* Disable all IDs (see esd_usb_start()) */
 	msg->msg.hdr.cmd = CMD_IDADD;
 	msg->msg.hdr.len = 2 + ESD_MAX_ID_SEGMENT;
 	msg->msg.filter.net = priv->index;
 	msg->msg.filter.option = ESD_ID_ENABLE; /* start with segment 0 */
 	for (i = 0; i <= ESD_MAX_ID_SEGMENT; i++)
 		msg->msg.filter.mask[i] = 0;
-	if (esd_usb2_send_msg(priv->usb2, msg) < 0)
+	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending idadd message failed\n");
 
-	/* set CAN controller to reset mode */
+	/* Set CAN controller to reset mode */
 	msg->msg.hdr.len = 2;
 	msg->msg.hdr.cmd = CMD_SETBAUD;
 	msg->msg.setbaud.net = priv->index;
 	msg->msg.setbaud.rsvd = 0;
-	msg->msg.setbaud.baud = cpu_to_le32(ESD_USB2_NO_BAUDRATE);
-	if (esd_usb2_send_msg(priv->usb2, msg) < 0)
+	/* Sending ESD_USB2_NO_BAUDRATE is sufficient for CAN-USB/3, even in CAN FD mode, too */
+	msg->msg.setbaud.u.baud = cpu_to_le32(ESD_USB2_NO_BAUDRATE);
+	if (esd_usb_send_msg(priv->usb, msg) < 0)
 		netdev_err(netdev, "sending setbaud message failed\n");
 
 	priv->can.state = CAN_STATE_STOPPED;
@@ -879,10 +1050,10 @@ static int esd_usb2_close(struct net_device *netdev)
 	return 0;
 }
 
-static const struct net_device_ops esd_usb2_netdev_ops = {
-	.ndo_open = esd_usb2_open,
-	.ndo_stop = esd_usb2_close,
-	.ndo_start_xmit = esd_usb2_start_xmit,
+static const struct net_device_ops esd_usb_netdev_ops = {
+	.ndo_open = esd_usb_open,
+	.ndo_stop = esd_usb_close,
+	.ndo_start_xmit = esd_usb_start_xmit,
 	.ndo_change_mtu = can_change_mtu,
 };
 
@@ -898,11 +1069,35 @@ static const struct can_bittiming_const esd_usb2_bittiming_const = {
 	.brp_inc = ESD_USB2_BRP_INC,
 };
 
+static const struct can_bittiming_const esd_usb3_bittiming_const = {
+	.name = "esd_usb3",
+	.tseg1_min = ESD_USB3_TSEG1_MIN,
+	.tseg1_max = ESD_USB3_TSEG1_MAX,
+	.tseg2_min = ESD_USB3_TSEG2_MIN,
+	.tseg2_max = ESD_USB3_TSEG2_MAX,
+	.sjw_max = ESD_USB3_SJW_MAX,
+	.brp_min = ESD_USB3_BRP_MIN,
+	.brp_max = ESD_USB3_BRP_MAX,
+	.brp_inc = ESD_USB3_BRP_INC,
+};
+
+static const struct can_bittiming_const esd_usb3_data_bittiming_const = {
+	.name = "esd_usb3",
+	.tseg1_min = ESD_USB3_DATA_TSEG1_MIN,
+	.tseg1_max = ESD_USB3_DATA_TSEG1_MAX,
+	.tseg2_min = ESD_USB3_DATA_TSEG2_MIN,
+	.tseg2_max = ESD_USB3_DATA_TSEG2_MAX,
+	.sjw_max = ESD_USB3_DATA_SJW_MAX,
+	.brp_min = ESD_USB3_DATA_BRP_MIN,
+	.brp_max = ESD_USB3_DATA_BRP_MAX,
+	.brp_inc = ESD_USB3_DATA_BRP_INC,
+};
+
 static int esd_usb2_set_bittiming(struct net_device *netdev)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 	struct can_bittiming *bt = &priv->can.bittiming;
-	struct esd_usb2_msg *msg;
+	struct esd_usb_msg *msg;
 	int err;
 	u32 canbtr;
 	int sjw_shift;
@@ -913,19 +1108,15 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 
 	canbtr |= (bt->brp - 1) & (ESD_USB2_BRP_MAX - 1);
 
-	if (le16_to_cpu(priv->usb2->udev->descriptor.idProduct) ==
-	    USB_CANUSBM_PRODUCT_ID)
+	if (le16_to_cpu(priv->usb->udev->descriptor.idProduct) == USB_CANUSBM_PRODUCT_ID)
 		sjw_shift = ESD_USBM_SJW_SHIFT;
 	else
 		sjw_shift = ESD_USB2_SJW_SHIFT;
 
-	canbtr |= ((bt->sjw - 1) & (ESD_USB2_SJW_MAX - 1))
-		<< sjw_shift;
-	canbtr |= ((bt->prop_seg + bt->phase_seg1 - 1)
-		   & (ESD_USB2_TSEG1_MAX - 1))
+	canbtr |= ((bt->sjw - 1) & (ESD_USB2_SJW_MAX - 1)) << sjw_shift;
+	canbtr |= ((bt->prop_seg + bt->phase_seg1 - 1) & (ESD_USB2_TSEG1_MAX - 1))
 		<< ESD_USB2_TSEG1_SHIFT;
-	canbtr |= ((bt->phase_seg2 - 1) & (ESD_USB2_TSEG2_MAX - 1))
-		<< ESD_USB2_TSEG2_SHIFT;
+	canbtr |= ((bt->phase_seg2 - 1) & (ESD_USB2_TSEG2_MAX - 1)) << ESD_USB2_TSEG2_SHIFT;
 	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
 		canbtr |= ESD_USB2_3_SAMPLES;
 
@@ -937,20 +1128,97 @@ static int esd_usb2_set_bittiming(struct net_device *netdev)
 	msg->msg.hdr.cmd = CMD_SETBAUD;
 	msg->msg.setbaud.net = priv->index;
 	msg->msg.setbaud.rsvd = 0;
-	msg->msg.setbaud.baud = cpu_to_le32(canbtr);
+	msg->msg.setbaud.u.baud = cpu_to_le32(canbtr);
 
 	netdev_info(netdev, "setting BTR=%#x\n", canbtr);
 
-	err = esd_usb2_send_msg(priv->usb2, msg);
+	err = esd_usb_send_msg(priv->usb, msg);
+
+	kfree(msg);
+	return err;
+}
+
+static int esd_usb3_set_bittiming(struct net_device *netdev)
+{
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
+	struct can_bittiming *bt   = &priv->can.bittiming;
+	struct can_bittiming *d_bt = &priv->can.data_bittiming;
+	struct esd_usb_msg *msg;
+	int err;
+	u16 mode;
+	u16 flags = 0;
+	u16 brp, tseg1, tseg2, sjw;
+	u16 d_brp, d_tseg1, d_tseg2, d_sjw;
+
+	msg = kmalloc(sizeof(*msg), GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	/* Canonical is the most reasonable mode for SocketCAN on CAN-USB/3 ... */
+	mode = ESD_BAUDRATE_MODE_BTR_CANONICAL;
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY)
+		flags |= ESD_BAUDRATE_FLAG_LOM;
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_3_SAMPLES)
+		flags |= ESD_BAUDRATE_FLAG_TRS;
+
+	brp = bt->brp & (ESD_USB3_BRP_MAX - 1);
+	sjw = bt->sjw & (ESD_USB3_SJW_MAX - 1);
+	tseg1 = (bt->prop_seg + bt->phase_seg1) & (ESD_USB3_TSEG1_MAX - 1);
+	tseg2 = bt->phase_seg2 & (ESD_USB3_TSEG2_MAX - 1);
+
+	msg->msg.setbaud.u.baud_x.arb.brp   = cpu_to_le16(brp);
+	msg->msg.setbaud.u.baud_x.arb.sjw   = cpu_to_le16(sjw);
+	msg->msg.setbaud.u.baud_x.arb.tseg1 = cpu_to_le16(tseg1);
+	msg->msg.setbaud.u.baud_x.arb.tseg2 = cpu_to_le16(tseg2);
+
+	if (priv->can.ctrlmode & CAN_CTRLMODE_FD) {
+		d_brp = d_bt->brp & (ESD_USB3_DATA_BRP_MAX - 1);
+		d_sjw = d_bt->sjw & (ESD_USB3_DATA_SJW_MAX - 1);
+		d_tseg1 = (d_bt->prop_seg + d_bt->phase_seg1) & (ESD_USB3_DATA_TSEG1_MAX - 1);
+		d_tseg2 = d_bt->phase_seg2 & (ESD_USB3_DATA_TSEG2_MAX - 1);
+		flags |= ESD_BAUDRATE_FLAG_FD;
+	} else {
+		d_brp   = 0;
+		d_sjw   = 0;
+		d_tseg1 = 0;
+		d_tseg2 = 0;
+	}
+
+	msg->msg.setbaud.u.baud_x.data.brp   = cpu_to_le16(d_brp);
+	msg->msg.setbaud.u.baud_x.data.sjw   = cpu_to_le16(d_sjw);
+	msg->msg.setbaud.u.baud_x.data.tseg1 = cpu_to_le16(d_tseg1);
+	msg->msg.setbaud.u.baud_x.data.tseg2 = cpu_to_le16(d_tseg2);
+	msg->msg.setbaud.u.baud_x.mode	     = cpu_to_le16(mode);
+	msg->msg.setbaud.u.baud_x.flags	     = cpu_to_le16(flags);
+	msg->msg.setbaud.u.baud_x.tdc.tdc_mode   = ESD_TDC_MODE_AUTO;
+	msg->msg.setbaud.u.baud_x.tdc.ssp_offset = 0;
+	msg->msg.setbaud.u.baud_x.tdc.ssp_shift  = 0;
+	msg->msg.setbaud.u.baud_x.tdc.tdc_filter = 0;
+
+	msg->msg.hdr.len = 7;
+	msg->msg.hdr.cmd = CMD_SETBAUD;
+
+	msg->msg.setbaud.net = priv->index;
+	msg->msg.setbaud.rsvd = 0;
+
+	netdev_info(netdev,
+		    "ctrlmode:{ is:%#x, spprted:%#x },  esd-net:%u, esd-mode:%#x, esd-flg:%#x, arb:{ brp:%u, ts1:%u, ts2:%u, sjw:%u }, data:{ dbrp:%u, dts1:%u, dts2:%u dsjw:%u }\n",
+		    priv->can.ctrlmode, priv->can.ctrlmode_supported,
+		    priv->index, mode, flags,
+		    brp, tseg1, tseg2, sjw,
+		    d_brp, d_tseg1, d_tseg2, d_sjw);
+
+	err = esd_usb_send_msg(priv->usb, msg);
 
 	kfree(msg);
 	return err;
 }
 
-static int esd_usb2_get_berr_counter(const struct net_device *netdev,
-				     struct can_berr_counter *bec)
+static int esd_usb_get_berr_counter(const struct net_device *netdev, struct can_berr_counter *bec)
 {
-	struct esd_usb2_net_priv *priv = netdev_priv(netdev);
+	struct esd_usb_net_priv *priv = netdev_priv(netdev);
 
 	bec->txerr = priv->bec.txerr;
 	bec->rxerr = priv->bec.rxerr;
@@ -958,7 +1226,7 @@ static int esd_usb2_get_berr_counter(const struct net_device *netdev,
 	return 0;
 }
 
-static int esd_usb2_set_mode(struct net_device *netdev, enum can_mode mode)
+static int esd_usb_set_mode(struct net_device *netdev, enum can_mode mode)
 {
 	switch (mode) {
 	case CAN_MODE_START:
@@ -972,11 +1240,11 @@ static int esd_usb2_set_mode(struct net_device *netdev, enum can_mode mode)
 	return 0;
 }
 
-static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
+static int esd_usb_probe_one_net(struct usb_interface *intf, int index)
 {
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 	struct net_device *netdev;
-	struct esd_usb2_net_priv *priv;
+	struct esd_usb_net_priv *priv;
 	int err = 0;
 	int i;
 
@@ -995,30 +1263,45 @@ static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
 	for (i = 0; i < MAX_TX_URBS; i++)
 		priv->tx_contexts[i].echo_index = MAX_TX_URBS;
 
-	priv->usb2 = dev;
+	priv->usb = dev;
 	priv->netdev = netdev;
 	priv->index = index;
 
 	priv->can.state = CAN_STATE_STOPPED;
-	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY |
-		CAN_CTRLMODE_CC_LEN8_DLC;
+	priv->can.ctrlmode_supported = CAN_CTRLMODE_LISTENONLY | CAN_CTRLMODE_CC_LEN8_DLC;
+
+	switch (le16_to_cpu(dev->udev->descriptor.idProduct)) {
+	case USB_CANUSB3_PRODUCT_ID:
+		priv->can.clock.freq = ESD_USB3_CAN_CLOCK;
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
+		priv->can.ctrlmode_supported |= CAN_CTRLMODE_FD;
+		priv->can.bittiming_const = &esd_usb3_bittiming_const;
+		priv->can.data_bittiming_const = &esd_usb3_data_bittiming_const;
+		priv->can.do_set_bittiming = esd_usb3_set_bittiming;
+		priv->can.do_set_data_bittiming = esd_usb3_set_bittiming;
+		break;
 
-	if (le16_to_cpu(dev->udev->descriptor.idProduct) ==
-	    USB_CANUSBM_PRODUCT_ID)
+	case USB_CANUSBM_PRODUCT_ID:
 		priv->can.clock.freq = ESD_USBM_CAN_CLOCK;
-	else {
+		priv->can.bittiming_const = &esd_usb2_bittiming_const;
+		priv->can.do_set_bittiming = esd_usb2_set_bittiming;
+		break;
+
+	case USB_CANUSB2_PRODUCT_ID:
+	default:
 		priv->can.clock.freq = ESD_USB2_CAN_CLOCK;
 		priv->can.ctrlmode_supported |= CAN_CTRLMODE_3_SAMPLES;
+		priv->can.bittiming_const = &esd_usb2_bittiming_const;
+		priv->can.do_set_bittiming = esd_usb2_set_bittiming;
+		break;
 	}
 
-	priv->can.bittiming_const = &esd_usb2_bittiming_const;
-	priv->can.do_set_bittiming = esd_usb2_set_bittiming;
-	priv->can.do_set_mode = esd_usb2_set_mode;
-	priv->can.do_get_berr_counter = esd_usb2_get_berr_counter;
+	priv->can.do_set_mode = esd_usb_set_mode;
+	priv->can.do_get_berr_counter = esd_usb_get_berr_counter;
 
 	netdev->flags |= IFF_ECHO; /* we support local echo */
 
-	netdev->netdev_ops = &esd_usb2_netdev_ops;
+	netdev->netdev_ops = &esd_usb_netdev_ops;
 
 	SET_NETDEV_DEV(netdev, &intf->dev);
 	netdev->dev_id = index;
@@ -1044,11 +1327,10 @@ static int esd_usb2_probe_one_net(struct usb_interface *intf, int index)
  * check version information and number of available
  * CAN interfaces
  */
-static int esd_usb2_probe(struct usb_interface *intf,
-			 const struct usb_device_id *id)
+static int esd_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
-	struct esd_usb2 *dev;
-	struct esd_usb2_msg *msg;
+	struct esd_usb *dev;
+	struct esd_usb_msg *msg;
 	int i, err;
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -1076,13 +1358,13 @@ static int esd_usb2_probe(struct usb_interface *intf,
 	msg->msg.version.flags = 0;
 	msg->msg.version.drv_version = 0;
 
-	err = esd_usb2_send_msg(dev, msg);
+	err = esd_usb_send_msg(dev, msg);
 	if (err < 0) {
 		dev_err(&intf->dev, "sending version message failed\n");
 		goto free_msg;
 	}
 
-	err = esd_usb2_wait_msg(dev, msg);
+	err = esd_usb_wait_msg(dev, msg);
 	if (err < 0) {
 		dev_err(&intf->dev, "no version message answer\n");
 		goto free_msg;
@@ -1091,21 +1373,26 @@ static int esd_usb2_probe(struct usb_interface *intf,
 	dev->net_count = (int)msg->msg.version_reply.nets;
 	dev->version = le32_to_cpu(msg->msg.version_reply.version);
 
+	dev_info(&intf->dev, "version:{ hw:%d.%d.%d fw:%d.%d.%d }\n",
+		 (dev->version >> 28) & 0xf,
+		 (dev->version >> 24) & 0xf,
+		 (dev->version >> 16) & 0xff,
+		 (dev->version >> 12) & 0xf,
+		 (dev->version >>  8) & 0xf,
+		 (dev->version)       & 0xff);
+
 	if (device_create_file(&intf->dev, &dev_attr_firmware))
-		dev_err(&intf->dev,
-			"Couldn't create device file for firmware\n");
+		dev_err(&intf->dev, "Couldn't create device file for firmware\n");
 
 	if (device_create_file(&intf->dev, &dev_attr_hardware))
-		dev_err(&intf->dev,
-			"Couldn't create device file for hardware\n");
+		dev_err(&intf->dev, "Couldn't create device file for hardware\n");
 
 	if (device_create_file(&intf->dev, &dev_attr_nets))
-		dev_err(&intf->dev,
-			"Couldn't create device file for nets\n");
+		dev_err(&intf->dev, "Couldn't create device file for nets\n");
 
 	/* do per device probing */
 	for (i = 0; i < dev->net_count; i++)
-		esd_usb2_probe_one_net(intf, i);
+		esd_usb_probe_one_net(intf, i);
 
 free_msg:
 	kfree(msg);
@@ -1118,9 +1405,9 @@ static int esd_usb2_probe(struct usb_interface *intf,
 /*
  * called by the usb core when the device is removed from the system
  */
-static void esd_usb2_disconnect(struct usb_interface *intf)
+static void esd_usb_disconnect(struct usb_interface *intf)
 {
-	struct esd_usb2 *dev = usb_get_intfdata(intf);
+	struct esd_usb *dev = usb_get_intfdata(intf);
 	struct net_device *netdev;
 	int i;
 
@@ -1144,11 +1431,11 @@ static void esd_usb2_disconnect(struct usb_interface *intf)
 }
 
 /* usb specific object needed to register this driver with the usb subsystem */
-static struct usb_driver esd_usb2_driver = {
-	.name = "esd_usb2",
-	.probe = esd_usb2_probe,
-	.disconnect = esd_usb2_disconnect,
-	.id_table = esd_usb2_table,
+static struct usb_driver esd_usb_driver = {
+	.name = "esd_usb",
+	.probe = esd_usb_probe,
+	.disconnect = esd_usb_disconnect,
+	.id_table = esd_usb_table,
 };
 
-module_usb_driver(esd_usb2_driver);
+module_usb_driver(esd_usb_driver);
-- 
2.25.1

