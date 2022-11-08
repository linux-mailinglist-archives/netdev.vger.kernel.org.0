Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6317F621856
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbiKHPeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbiKHPeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:34:08 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD9E58BC7;
        Tue,  8 Nov 2022 07:34:03 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id b29so14096202pfp.13;
        Tue, 08 Nov 2022 07:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzmpvqsSVGzC4zR1Nwhm4pVa3StYv2yshFqXUJPXYqw=;
        b=JrLetZAaQA5fdKWmr0LTbxE4GFeqieJLrYI7N6kpSi7MF1kMjv8jy5B2OM3FqZGKki
         +ebqEuuCr+lbU9+P8tGQslmJj28vKfVyMEswlBakqBN8Tt6q6zluM82DhV64zztRsP5F
         9lJaxpiDF5GL13jkzNpcRc7j9Flhfz2Mj6V2JVtnrQI/K0jQWmN/FNSBfr1NQllzhF2n
         NUcl1o/1Mqkw1PySpUU9U5NRW83RQSLk0OlkCIAtg/p/kMWqz0q8owSOu1sum9da5TX6
         sVDHjgWWS/klbsXVEshwXEGHexvwuWNHyp/RVYjR4KQ37NzE88a02e2pvvE8MostCLa8
         K/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gzmpvqsSVGzC4zR1Nwhm4pVa3StYv2yshFqXUJPXYqw=;
        b=pzCHvWXoh3MQec4TlCNK+zBLbosFCgYPOgTTUxaDhHG6INeYwvxmCQyFqxNFH/8T17
         O7tvJlYLCLM3CMNizaLZbhcO8Sxi7QFsejN+9BkC98ZuFfqQX9JbagVKKBiHvBdtIO20
         gxdmjlY5UO1zQ9WkYCmWUD1RWb1TcBHlL0T9jQCzGTmrUpogX4LrKYWZzFPe4TH2LPuZ
         /faXBVAQFI+M5FttCiU1XwTcS65Mi/9BhwyGLdpDuikTAFIj8DPIN1J81AqrT8f020Bq
         UXoi6rNAs7MaGRAMh9crtGgYkN+ZXpLPjvVTOwWjiAd/CGDvrdhUTGAcnl6aE48qrTIm
         vZMQ==
X-Gm-Message-State: ACrzQf3H2YE1Vc1Ye9NjyXfFvJkWD7hzfMSVgDsje6t4Eoh1QpSl75ei
        VpXv8lK8Nx73iOBExc7EIUE=
X-Google-Smtp-Source: AMsMyM4+vgz6UTMbx2z+Q+oFag00RFB+SI5VlQ2eDqSM2bgOekg9E9tW/5Zx9cf5MU3LD5K4k4Fspw==
X-Received: by 2002:a63:4307:0:b0:464:a24d:8201 with SMTP id q7-20020a634307000000b00464a24d8201mr49012548pga.116.1667921641613;
        Tue, 08 Nov 2022 07:34:01 -0800 (PST)
Received: from localhost.localdomain ([203.158.52.158])
        by smtp.gmail.com with ESMTPSA id w10-20020a17090a460a00b00213202d77d9sm6243412pjg.43.2022.11.08.07.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:34:00 -0800 (PST)
From:   Albert Zhou <albert.zhou.50@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next RFC 2/5] r8152: update to version two
Date:   Wed,  9 Nov 2022 02:33:39 +1100
Message-Id: <20221108153342.18979-3-albert.zhou.50@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221108153342.18979-1-albert.zhou.50@gmail.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the r8152 module to version two; the original source code is
accessible from the Realtek website. The website is included in a
comment in r8152.c, also describing the udev rules file I left out, in
case this affects future development.

The only other edit from the original driver source is amending
netif_napi_add, due to commit b48b89f9c189 ("net: drop the weight
argument from netif_napi_add"), which removed the weight argument. This
is also marked by a brief comment in the code.

The r8152_compatibility.h header was renamed from compatibility.h in the
original driver.

Signed-off-by: Albert Zhou <albert.zhou.50@gmail.com>
---
 drivers/net/usb/r8152.c               | 17938 +++++++++++++++++++-----
 drivers/net/usb/r8152_compatibility.h |   658 +
 2 files changed, 15130 insertions(+), 3466 deletions(-)
 create mode 100644 drivers/net/usb/r8152_compatibility.h

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index a481a1d831e2..cda0f4ed2a90 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1,6 +1,19 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- *  Copyright (c) 2014 Realtek Semiconductor Corp. All rights reserved.
+ *  Copyright (c) 2021 Realtek Semiconductor Corp. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ *  This product is covered by one or more of the following patents:
+ *  US6,570,884, US6,115,776, and US6,327,625.
+ */
+
+/* The original source code can be found at
+ * https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-usb-3-0-software
+ * and it additionally comes with a 50-usb-realtek-net.rules file, to be
+ * installed under /etc/udev/rules.d
  */
 
 #include <linux/signal.h>
@@ -18,27 +31,22 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <net/ip6_checksum.h>
-#include <uapi/linux/mdio.h>
-#include <linux/mdio.h>
 #include <linux/usb/cdc.h>
 #include <linux/suspend.h>
 #include <linux/atomic.h>
 #include <linux/acpi.h>
-#include <linux/firmware.h>
-#include <crypto/hash.h>
-#include <linux/usb/r8152.h>
-
-/* Information for net-next */
-#define NETNEXT_VERSION		"12"
-
-/* Information for net */
-#define NET_VERSION		"13"
+#include "r8152_compatibility.h"
 
-#define DRIVER_VERSION		"v1." NETNEXT_VERSION "." NET_VERSION
-#define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
+/* Version Information */
+#define DRIVER_VERSION "v2.16.3 (2022/07/06)"
+#define DRIVER_AUTHOR "Realtek nic sw <nic_swsd@realtek.com>"
 #define DRIVER_DESC "Realtek RTL8152/RTL8153 Based USB Ethernet Adapters"
 #define MODULENAME "r8152"
 
+#define PATENTS		"This product is covered by one or more of the " \
+			"following patents:\n" \
+			"\t\tUS6,570,884, US6,115,776, and US6,327,625.\n"
+
 #define R8152_PHY_ID		32
 
 #define PLA_IDR			0xc000
@@ -118,6 +126,15 @@
 #define PLA_BP_6		0xfc34
 #define PLA_BP_7		0xfc36
 #define PLA_BP_EN		0xfc38
+#define PLA_BP_8		0xfc38		/* RTL8153C */
+#define PLA_BP_9		0xfc3a
+#define PLA_BP_10		0xfc3c
+#define PLA_BP_11		0xfc3e
+#define PLA_BP_12		0xfc40
+#define PLA_BP_13		0xfc42
+#define PLA_BP_14		0xfc44
+#define PLA_BP_15		0xfc46
+#define PLA_BP2_EN		0xfc48
 
 #define USB_USB2PHY		0xb41e
 #define USB_SSPHYLINK1		0xb426
@@ -133,6 +150,7 @@
 #define USB_FW_FIX_EN0		0xcfca
 #define USB_FW_FIX_EN1		0xcfcc
 #define USB_LPM_CONFIG		0xcfd8
+#define USB_EFUSE		0xcfdb
 #define USB_ECM_OPTION		0xcfee
 #define USB_CSTMR		0xcfef	/* RTL8153A */
 #define USB_MISC_2		0xcfff
@@ -351,6 +369,7 @@
 #define BWF_EN			0x0040
 #define MWF_EN			0x0020
 #define UWF_EN			0x0010
+#define SPI_EN			BIT(3)
 #define LAN_WAKE_EN		0x0002
 
 /* PLA_LED_FEATURE */
@@ -462,6 +481,9 @@
 /* USB_LPM_CONFIG */
 #define LPM_U1U2_EN		BIT(0)
 
+/* USB_EFUSE */
+#define PASS_THRU_MASK		BIT(0)
+
 /* USB_TX_AGG */
 #define TX_AGG_MAX_THRESHOLD	0x03
 
@@ -505,6 +527,7 @@
 #define FORCE_SUPER		BIT(0)
 
 /* USB_MISC_2 */
+#define UPS_NO_UPS		BIT(7)
 #define UPS_FORCE_PWR_DOWN	BIT(0)
 
 /* USB_ECM_OP */
@@ -544,6 +567,12 @@
 
 /* USB_MISC_0 */
 #define PCUT_STATUS		0x0001
+#define AD_MASK			0xfee0
+
+/* USB_MISC_1 */
+#define BD_MASK			BIT(0)
+#define BND_MASK		BIT(2)
+#define BL_MASK			BIT(3)
 
 /* USB_RX_EARLY_TIMEOUT */
 #define COALESCE_SUPER		 85000U
@@ -714,15 +743,6 @@ enum spd_duplex {
 /* SRAM_PHY_LOCK */
 #define PHY_PATCH_LOCK		0x0001
 
-/* MAC PASSTHRU */
-#define AD_MASK			0xfee0
-#define BND_MASK		0x0004
-#define BD_MASK			0x0001
-#define EFUSE			0xcfdb
-#define PASS_THRU_MASK		0x1
-
-#define BP4_SUPER_ONLY		0x1578	/* RTL_VER_04 only */
-
 enum rtl_register_content {
 	_2500bps	= BIT(10),
 	_1250bps	= BIT(9),
@@ -750,6 +770,18 @@ enum rtl_register_content {
 
 #define INTR_LINK		0x0004
 
+#define RTL8152_REQT_READ	0xc0
+#define RTL8152_REQT_WRITE	0x40
+#define RTL8152_REQ_GET_REGS	0x05
+#define RTL8152_REQ_SET_REGS	0x05
+
+#define BYTE_EN_DWORD		0xff
+#define BYTE_EN_WORD		0x33
+#define BYTE_EN_BYTE		0x11
+#define BYTE_EN_SIX_BYTES	0x3f
+#define BYTE_EN_START_MASK	0x0f
+#define BYTE_EN_END_MASK	0xf0
+
 #define RTL8152_RMS		(VLAN_ETH_FRAME_LEN + ETH_FCS_LEN)
 #define RTL8153_RMS		RTL8153_MAX_PACKET
 #define RTL8152_TX_TIMEOUT	(5 * HZ)
@@ -757,6 +789,8 @@ enum rtl_register_content {
 #define size_to_mtu(s)		((s) - VLAN_ETH_HLEN - ETH_FCS_LEN)
 #define rx_reserved_size(x)	(mtu_to_size(x) + sizeof(struct rx_desc) + RX_ALIGN)
 
+#define RTL_MAX_SG_NUM		64
+
 /* rtl8152 flags */
 enum rtl8152_flags {
 	RTL8152_UNPLUG = 0,
@@ -768,14 +802,20 @@ enum rtl8152_flags {
 	SCHEDULE_TASKLET,
 	GREEN_ETHERNET,
 	RX_EPROTO,
+	RECOVER_SPEED,
 };
 
-#define DEVICE_ID_LENOVO_USB_C_TRAVEL_HUB		0x721e
-#define DEVICE_ID_THINKPAD_ONELINK_PLUS_DOCK		0x3054
-#define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
-#define DEVICE_ID_THINKPAD_USB_C_DONGLE			0x720c
-#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
-#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
+/* Define these values to match your device */
+#define VENDOR_ID_REALTEK		0x0bda
+#define VENDOR_ID_MICROSOFT		0x045e
+#define VENDOR_ID_SAMSUNG		0x04e8
+#define VENDOR_ID_LENOVO		0x17ef
+#define VENDOR_ID_LINKSYS		0x13b1
+#define VENDOR_ID_NVIDIA		0x0955
+#define VENDOR_ID_TPLINK		0x2357
+
+#define MCU_TYPE_PLA			0x0100
+#define MCU_TYPE_USB			0x0000
 
 struct tally_counter {
 	__le64	tx_packets;
@@ -795,6 +835,7 @@ struct tally_counter {
 
 struct rx_desc {
 	__le32 opts1;
+#define RD_CRC				BIT(15)
 #define RX_LEN_MASK			0x7fff
 
 	__le32 opts2;
@@ -818,6 +859,7 @@ struct tx_desc {
 	__le32 opts1;
 #define TX_FS			BIT(31) /* First segment of a packet */
 #define TX_LS			BIT(30) /* Final segment of a packet */
+#define LGSEND			BIT(29)
 #define GTSENDV4		BIT(28)
 #define GTSENDV6		BIT(27)
 #define GTTCPHO_SHIFT		18
@@ -850,6 +892,7 @@ struct tx_agg {
 	struct list_head list;
 	struct urb *urb;
 	struct r8152 *context;
+	struct sk_buff_head tx_skb;
 	void *buffer;
 	void *head;
 	u32 skb_num;
@@ -871,9 +914,18 @@ struct r8152 {
 	struct delayed_work schedule, hw_phy_work;
 	struct mii_if_info mii;
 	struct mutex control;	/* use for hw setting */
-#ifdef CONFIG_PM_SLEEP
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
+	struct vlan_group *vlgrp;
+#endif
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
+	struct net_device_stats stats;
+#endif
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP)
 	struct notifier_block pm_notifier;
 #endif
+#if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
+	struct notifier_block reboot_notifier;
+#endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
 	struct tasklet_struct tx_tl;
 
 	struct rtl_ops {
@@ -883,8 +935,10 @@ struct r8152 {
 		void (*up)(struct r8152 *tp);
 		void (*down)(struct r8152 *tp);
 		void (*unload)(struct r8152 *tp);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 		int (*eee_get)(struct r8152 *tp, struct ethtool_eee *eee);
 		int (*eee_set)(struct r8152 *tp, struct ethtool_eee *eee);
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		bool (*in_nway)(struct r8152 *tp);
 		void (*hw_phy_cfg)(struct r8152 *tp);
 		void (*autosuspend_en)(struct r8152 *tp, bool enable);
@@ -909,19 +963,6 @@ struct r8152 {
 		u32 ctap_short_off:1;
 	} ups_info;
 
-#define RTL_VER_SIZE		32
-
-	struct rtl_fw {
-		const char *fw_name;
-		const struct firmware *fw;
-
-		char version[RTL_VER_SIZE];
-		int (*pre_fw)(struct r8152 *tp);
-		int (*post_fw)(struct r8152 *tp);
-
-		bool retry;
-	} rtl_fw;
-
 	atomic_t rx_count;
 
 	bool eee_en;
@@ -939,217 +980,21 @@ struct r8152 {
 	unsigned int pipe_in, pipe_out, pipe_intr, pipe_ctrl_in, pipe_ctrl_out;
 
 	u32 support_2500full:1;
+	u32 sg_use:1;
+//	u32 dash_mode:1;
 	u32 lenovo_macpassthru:1;
-	u32 dell_tb_rx_agg_bug:1;
+	u32 dell_macpassthru:1;
+
 	u16 ocp_base;
 	u16 speed;
 	u16 eee_adv;
 	u8 *intr_buff;
 	u8 version;
+	u8 rtk_enable_diag;
 	u8 duplex;
 	u8 autoneg;
 };
 
-/**
- * struct fw_block - block type and total length
- * @type: type of the current block, such as RTL_FW_END, RTL_FW_PLA,
- *	RTL_FW_USB and so on.
- * @length: total length of the current block.
- */
-struct fw_block {
-	__le32 type;
-	__le32 length;
-} __packed;
-
-/**
- * struct fw_header - header of the firmware file
- * @checksum: checksum of sha256 which is calculated from the whole file
- *	except the checksum field of the file. That is, calculate sha256
- *	from the version field to the end of the file.
- * @version: version of this firmware.
- * @blocks: the first firmware block of the file
- */
-struct fw_header {
-	u8 checksum[32];
-	char version[RTL_VER_SIZE];
-	struct fw_block blocks[];
-} __packed;
-
-enum rtl8152_fw_flags {
-	FW_FLAGS_USB = 0,
-	FW_FLAGS_PLA,
-	FW_FLAGS_START,
-	FW_FLAGS_STOP,
-	FW_FLAGS_NC,
-	FW_FLAGS_NC1,
-	FW_FLAGS_NC2,
-	FW_FLAGS_UC2,
-	FW_FLAGS_UC,
-	FW_FLAGS_SPEED_UP,
-	FW_FLAGS_VER,
-};
-
-enum rtl8152_fw_fixup_cmd {
-	FW_FIXUP_AND = 0,
-	FW_FIXUP_OR,
-	FW_FIXUP_NOT,
-	FW_FIXUP_XOR,
-};
-
-struct fw_phy_set {
-	__le16 addr;
-	__le16 data;
-} __packed;
-
-struct fw_phy_speed_up {
-	struct fw_block blk_hdr;
-	__le16 fw_offset;
-	__le16 version;
-	__le16 fw_reg;
-	__le16 reserved;
-	char info[];
-} __packed;
-
-struct fw_phy_ver {
-	struct fw_block blk_hdr;
-	struct fw_phy_set ver;
-	__le32 reserved;
-} __packed;
-
-struct fw_phy_fixup {
-	struct fw_block blk_hdr;
-	struct fw_phy_set setting;
-	__le16 bit_cmd;
-	__le16 reserved;
-} __packed;
-
-struct fw_phy_union {
-	struct fw_block blk_hdr;
-	__le16 fw_offset;
-	__le16 fw_reg;
-	struct fw_phy_set pre_set[2];
-	struct fw_phy_set bp[8];
-	struct fw_phy_set bp_en;
-	u8 pre_num;
-	u8 bp_num;
-	char info[];
-} __packed;
-
-/**
- * struct fw_mac - a firmware block used by RTL_FW_PLA and RTL_FW_USB.
- *	The layout of the firmware block is:
- *	<struct fw_mac> + <info> + <firmware data>.
- * @blk_hdr: firmware descriptor (type, length)
- * @fw_offset: offset of the firmware binary data. The start address of
- *	the data would be the address of struct fw_mac + @fw_offset.
- * @fw_reg: the register to load the firmware. Depends on chip.
- * @bp_ba_addr: the register to write break point base address. Depends on
- *	chip.
- * @bp_ba_value: break point base address. Depends on chip.
- * @bp_en_addr: the register to write break point enabled mask. Depends
- *	on chip.
- * @bp_en_value: break point enabled mask. Depends on the firmware.
- * @bp_start: the start register of break points. Depends on chip.
- * @bp_num: the break point number which needs to be set for this firmware.
- *	Depends on the firmware.
- * @bp: break points. Depends on firmware.
- * @reserved: reserved space (unused)
- * @fw_ver_reg: the register to store the fw version.
- * @fw_ver_data: the firmware version of the current type.
- * @info: additional information for debugging, and is followed by the
- *	binary data of firmware.
- */
-struct fw_mac {
-	struct fw_block blk_hdr;
-	__le16 fw_offset;
-	__le16 fw_reg;
-	__le16 bp_ba_addr;
-	__le16 bp_ba_value;
-	__le16 bp_en_addr;
-	__le16 bp_en_value;
-	__le16 bp_start;
-	__le16 bp_num;
-	__le16 bp[16]; /* any value determined by firmware */
-	__le32 reserved;
-	__le16 fw_ver_reg;
-	u8 fw_ver_data;
-	char info[];
-} __packed;
-
-/**
- * struct fw_phy_patch_key - a firmware block used by RTL_FW_PHY_START.
- *	This is used to set patch key when loading the firmware of PHY.
- * @blk_hdr: firmware descriptor (type, length)
- * @key_reg: the register to write the patch key.
- * @key_data: patch key.
- * @reserved: reserved space (unused)
- */
-struct fw_phy_patch_key {
-	struct fw_block blk_hdr;
-	__le16 key_reg;
-	__le16 key_data;
-	__le32 reserved;
-} __packed;
-
-/**
- * struct fw_phy_nc - a firmware block used by RTL_FW_PHY_NC.
- *	The layout of the firmware block is:
- *	<struct fw_phy_nc> + <info> + <firmware data>.
- * @blk_hdr: firmware descriptor (type, length)
- * @fw_offset: offset of the firmware binary data. The start address of
- *	the data would be the address of struct fw_phy_nc + @fw_offset.
- * @fw_reg: the register to load the firmware. Depends on chip.
- * @ba_reg: the register to write the base address. Depends on chip.
- * @ba_data: base address. Depends on chip.
- * @patch_en_addr: the register of enabling patch mode. Depends on chip.
- * @patch_en_value: patch mode enabled mask. Depends on the firmware.
- * @mode_reg: the regitster of switching the mode.
- * @mode_pre: the mode needing to be set before loading the firmware.
- * @mode_post: the mode to be set when finishing to load the firmware.
- * @reserved: reserved space (unused)
- * @bp_start: the start register of break points. Depends on chip.
- * @bp_num: the break point number which needs to be set for this firmware.
- *	Depends on the firmware.
- * @bp: break points. Depends on firmware.
- * @info: additional information for debugging, and is followed by the
- *	binary data of firmware.
- */
-struct fw_phy_nc {
-	struct fw_block blk_hdr;
-	__le16 fw_offset;
-	__le16 fw_reg;
-	__le16 ba_reg;
-	__le16 ba_data;
-	__le16 patch_en_addr;
-	__le16 patch_en_value;
-	__le16 mode_reg;
-	__le16 mode_pre;
-	__le16 mode_post;
-	__le16 reserved;
-	__le16 bp_start;
-	__le16 bp_num;
-	__le16 bp[4];
-	char info[];
-} __packed;
-
-enum rtl_fw_type {
-	RTL_FW_END = 0,
-	RTL_FW_PLA,
-	RTL_FW_USB,
-	RTL_FW_PHY_START,
-	RTL_FW_PHY_STOP,
-	RTL_FW_PHY_NC,
-	RTL_FW_PHY_FIXUP,
-	RTL_FW_PHY_UNION_NC,
-	RTL_FW_PHY_UNION_NC1,
-	RTL_FW_PHY_UNION_NC2,
-	RTL_FW_PHY_UNION_UC2,
-	RTL_FW_PHY_UNION_UC,
-	RTL_FW_PHY_UNION_MISC,
-	RTL_FW_PHY_SPEED_UP,
-	RTL_FW_PHY_VER,
-};
-
 enum rtl_version {
 	RTL_VER_UNKNOWN = 0,
 	RTL_VER_01,
@@ -1215,6 +1060,12 @@ int get_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 
 	kfree(tmp);
 
+	if (ret < 0) {
+		if (ret == -ETIMEDOUT)
+			usb_queue_reset_device(tp->intf);
+		netif_err(tp, drv, tp->netdev, "get_registers %d\n", ret);
+	}
+
 	return ret;
 }
 
@@ -1234,6 +1085,12 @@ int set_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 
 	kfree(tmp);
 
+	if (ret < 0) {
+		if (ret == -ETIMEDOUT)
+			usb_queue_reset_device(tp->intf);
+		netif_err(tp, drv, tp->netdev, "set_registers %d\n", ret);
+	}
+
 	return ret;
 }
 
@@ -1370,6 +1227,12 @@ int pla_ocp_write(struct r8152 *tp, u16 index, u16 byteen, u16 size, void *data)
 	return generic_ocp_write(tp, index, byteen, size, data, MCU_TYPE_PLA);
 }
 
+static inline
+int usb_ocp_read(struct r8152 *tp, u16 index, u16 size, void *data)
+{
+	return generic_ocp_read(tp, index, size, data, MCU_TYPE_USB);
+}
+
 static inline
 int usb_ocp_write(struct r8152 *tp, u16 index, u16 byteen, u16 size, void *data)
 {
@@ -1523,7 +1386,7 @@ static u16 sram_read(struct r8152 *tp, u16 addr)
 static int read_mii_word(struct net_device *netdev, int phy_id, int reg)
 {
 	struct r8152 *tp = netdev_priv(netdev);
-	int ret;
+	int ret, lock;
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return -ENODEV;
@@ -1531,8 +1394,15 @@ static int read_mii_word(struct net_device *netdev, int phy_id, int reg)
 	if (phy_id != R8152_PHY_ID)
 		return -EINVAL;
 
+	lock = mutex_trylock(&tp->control);
+
 	ret = r8152_mdio_read(tp, reg);
 
+	if (lock) {
+		mutex_unlock(&tp->control);
+		netif_warn(tp, drv, netdev, "miss mutex for read_mii_word?\n");
+	}
+
 	return ret;
 }
 
@@ -1540,6 +1410,7 @@ static
 void write_mii_word(struct net_device *netdev, int phy_id, int reg, int val)
 {
 	struct r8152 *tp = netdev_priv(netdev);
+	int lock;
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
@@ -1547,7 +1418,14 @@ void write_mii_word(struct net_device *netdev, int phy_id, int reg, int val)
 	if (phy_id != R8152_PHY_ID)
 		return;
 
+	lock = mutex_trylock(&tp->control);
+
 	r8152_mdio_write(tp, reg, val);
+
+	if (lock) {
+		mutex_unlock(&tp->control);
+		netif_warn(tp, drv, netdev, "miss mutex for write_mii_word?\n");
+	}
 }
 
 static int
@@ -1564,6 +1442,9 @@ static int __rtl8152_set_mac_address(struct net_device *netdev, void *p,
 	struct sockaddr *addr = p;
 	int ret = -EADDRNOTAVAIL;
 
+	if (unlikely(tp->rtk_enable_diag))
+		return -EBUSY;
+
 	if (!is_valid_ether_addr(addr->sa_data))
 		goto out1;
 
@@ -1594,51 +1475,15 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 	return __rtl8152_set_mac_address(netdev, p, false);
 }
 
-/* Devices containing proper chips can support a persistent
- * host system provided MAC address.
- * Examples of this are Dell TB15 and Dell WD15 docks
- */
-static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
+static int rtl_mapt_read(struct r8152 *tp, char *mac_obj_name,
+			 acpi_object_type mac_obj_type, int mac_strlen,
+			 struct sockaddr *sa)
 {
-	acpi_status status;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
-	int ret = -EINVAL;
-	u32 ocp_data;
 	unsigned char buf[6];
-	char *mac_obj_name;
-	acpi_object_type mac_obj_type;
-	int mac_strlen;
-
-	if (tp->lenovo_macpassthru) {
-		mac_obj_name = "\\MACA";
-		mac_obj_type = ACPI_TYPE_STRING;
-		mac_strlen = 0x16;
-	} else {
-		/* test for -AD variant of RTL8153 */
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
-		if ((ocp_data & AD_MASK) == 0x1000) {
-			/* test for MAC address pass-through bit */
-			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
-			if ((ocp_data & PASS_THRU_MASK) != 1) {
-				netif_dbg(tp, probe, tp->netdev,
-						"No efuse for RTL8153-AD MAC pass through\n");
-				return -ENODEV;
-			}
-		} else {
-			/* test for RTL8153-BND and RTL8153-BD */
-			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
-			if ((ocp_data & BND_MASK) == 0 && (ocp_data & BD_MASK) == 0) {
-				netif_dbg(tp, probe, tp->netdev,
-						"Invalid variant for MAC pass through\n");
-				return -ENODEV;
-			}
-		}
-
-		mac_obj_name = "\\_SB.AMAC";
-		mac_obj_type = ACPI_TYPE_BUFFER;
-		mac_strlen = 0x17;
-	}
+	acpi_status status;
+	int ret = -EINVAL;
 
 	/* returns _AUXMAC_#AABBCCDDEEFF# */
 	status = acpi_evaluate_object(NULL, mac_obj_name, NULL, &buffer);
@@ -1658,15 +1503,17 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 			   "Invalid header when reading pass-thru MAC addr\n");
 		goto amacout;
 	}
-	ret = hex2bin(buf, obj->string.pointer + 9, 6);
-	if (!(ret == 0 && is_valid_ether_addr(buf))) {
+
+	ret = hex2bin(buf, obj->string.pointer + 9, sizeof(buf));
+	if (ret < 0 || !is_valid_ether_addr(buf)) {
 		netif_warn(tp, probe, tp->netdev,
 			   "Invalid MAC for pass-thru MAC addr: %d, %pM\n",
 			   ret, buf);
 		ret = -EINVAL;
 		goto amacout;
 	}
-	memcpy(sa->sa_data, buf, 6);
+
+	memcpy(sa->sa_data, buf, sizeof(buf));
 	netif_info(tp, probe, tp->netdev,
 		   "Using pass-thru MAC addr %pM\n", sa->sa_data);
 
@@ -1675,6 +1522,59 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 	return ret;
 }
 
+/* Devices containing proper chips can support a persistent
+ * host system provided MAC address.
+ * Examples of this are Dell TB15 and Dell WD15 docks
+ */
+static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
+{
+	int ret = -EOPNOTSUPP;
+
+	if (tp->dell_macpassthru)
+		ret = rtl_mapt_read(tp, "\\_SB.AMAC", ACPI_TYPE_BUFFER, 0x17,
+				    sa);
+	else if (tp->lenovo_macpassthru)
+		ret = rtl_mapt_read(tp, "\\MACA", ACPI_TYPE_STRING, 0x16, sa);
+
+	return ret;
+}
+
+static int rtl_hw_ether_addr(struct r8152 *tp, struct sockaddr *sa)
+{
+	u32 ocp_data = 0;
+	int ret;
+
+	if (tp->version == RTL_VER_05) {
+		/* Determine the hardware default ethernet address.
+		 * Check USB 0xcf0e bit 0
+		 *  1: read from USB 0xcf08
+		 *  0: read from PLA_BACKUP
+		 */
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, 0xcf0e);
+
+		if (ocp_data & BIT(0))
+			return usb_ocp_read(tp, 0xcf08, 8, sa->sa_data);
+
+		ocp_data |= BIT(0);
+	}
+
+	ret = pla_ocp_read(tp, PLA_BACKUP, 8, sa->sa_data);
+	if (ret < 0)
+		goto out;
+
+	if (tp->version == RTL_VER_05) {
+		/* Backup default ethernet address to USB 0xcf08.
+		 * Set USB 0xcf0e bit 0 to 1. Then, next time, read the default
+		 * ethernet address from USB 0xcf08 rather than PLA_BACKUP.
+		 */
+		usb_ocp_write(tp, 0xcf08, BYTE_EN_SIX_BYTES, 8, sa->sa_data);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcf0e, ocp_data);
+	}
+
+out:
+	return ret;
+}
+
 static int determine_ethernet_addr(struct r8152 *tp, struct sockaddr *sa)
 {
 	struct net_device *dev = tp->netdev;
@@ -1692,8 +1592,7 @@ static int determine_ethernet_addr(struct r8152 *tp, struct sockaddr *sa)
 			 */
 			ret = vendor_mac_passthru_addr_read(tp, sa);
 			if (ret < 0)
-				ret = pla_ocp_read(tp, PLA_BACKUP, 8,
-						   sa->sa_data);
+				ret = rtl_hw_ether_addr(tp, sa);
 		}
 	}
 
@@ -1730,6 +1629,17 @@ static int set_ethernet_addr(struct r8152 *tp, bool in_resume)
 	return ret;
 }
 
+static inline struct net_device_stats *rtl8152_get_stats(struct net_device *dev)
+{
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
+	struct rtl8152 *tp = netdev_priv(dev);
+
+	return (struct net_device_stats *)&tp->stats;
+#else
+	return &dev->stats;
+#endif
+}
+
 static void read_bulk_callback(struct urb *urb)
 {
 	struct net_device *netdev;
@@ -1787,11 +1697,13 @@ static void read_bulk_callback(struct urb *urb)
 		return;	/* the urb is in unlink state */
 	case -ETIME:
 		if (net_ratelimit())
-			netdev_warn(netdev, "maybe reset is needed?\n");
+			netif_warn(tp, rx_err, netdev,
+				   "maybe reset is needed?\n");
 		break;
 	default:
 		if (net_ratelimit())
-			netdev_warn(netdev, "Rx status %d\n", status);
+			netif_warn(tp, rx_err, netdev,
+				   "Rx status %d\n", status);
 		break;
 	}
 
@@ -1816,10 +1728,11 @@ static void write_bulk_callback(struct urb *urb)
 		return;
 
 	netdev = tp->netdev;
-	stats = &netdev->stats;
+	stats = rtl8152_get_stats(netdev);
 	if (status) {
 		if (net_ratelimit())
-			netdev_warn(netdev, "Tx status %d\n", status);
+			netif_warn(tp, tx_err, netdev,
+				   "Tx status %d\n", status);
 		stats->tx_errors += agg->skb_num;
 	} else {
 		stats->tx_packets += agg->skb_num;
@@ -1845,6 +1758,59 @@ static void write_bulk_callback(struct urb *urb)
 		tasklet_schedule(&tp->tx_tl);
 }
 
+static void write_bulk_sg_callback(struct urb *urb)
+{
+	struct net_device *netdev;
+	struct tx_agg *agg;
+	struct r8152 *tp;
+	unsigned long flags;
+	int status = urb->status;
+
+	agg = urb->context;
+	if (!agg)
+		return;
+
+	tp = agg->context;
+	if (!tp)
+		return;
+
+	netdev = tp->netdev;
+	if (status && net_ratelimit())
+		netif_warn(tp, tx_err, netdev, "Tx status %d\n", status);
+
+	while (!skb_queue_empty(&agg->tx_skb)) {
+		struct sk_buff *skb = __skb_dequeue(&agg->tx_skb);
+		struct net_device_stats *stats = rtl8152_get_stats(netdev);
+
+		if (status) {
+			stats->tx_errors += skb_shinfo(skb)->gso_segs ?: 1;
+			dev_kfree_skb_any(skb);
+		} else {
+			stats->tx_packets += skb_shinfo(skb)->gso_segs ?: 1;
+			stats->tx_bytes += skb->len - skb->cb[0];
+			dev_consume_skb_any(skb);
+		}
+	}
+
+	spin_lock_irqsave(&tp->tx_lock, flags);
+	list_add_tail(&agg->list, &tp->tx_free);
+	spin_unlock_irqrestore(&tp->tx_lock, flags);
+
+	usb_autopm_put_interface_async(tp->intf);
+
+	if (!netif_carrier_ok(netdev))
+		return;
+
+	if (!test_bit(WORK_ENABLE, &tp->flags))
+		return;
+
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
+
+	if (!skb_queue_empty(&tp->tx_queue))
+		tasklet_schedule(&tp->tx_tl);
+}
+
 static void intr_callback(struct urb *urb)
 {
 	struct r8152 *tp;
@@ -1875,9 +1841,7 @@ static void intr_callback(struct urb *urb)
 			   "Stop submitting intr, status %d\n", status);
 		return;
 	case -EOVERFLOW:
-		if (net_ratelimit())
-			netif_info(tp, intr, tp->netdev,
-				   "intr status -EOVERFLOW\n");
+		netif_info(tp, intr, tp->netdev, "intr status -EOVERFLOW\n");
 		goto resubmit;
 	/* -EPIPE:  should clear the halt */
 	default:
@@ -2056,6 +2020,7 @@ static int alloc_all_mem(struct r8152 *tp)
 		tp->tx_info[i].head = tx_agg_align(buf);
 
 		list_add_tail(&tp->tx_info[i].list, &tp->tx_free);
+		skb_queue_head_init(&tp->tx_info[i].tx_skb);
 	}
 
 	tp->intr_urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -2134,7 +2099,7 @@ static void r8152_csum_workaround(struct r8152 *tp, struct sk_buff *skb,
 		struct net_device_stats *stats;
 
 drop:
-		stats = &tp->netdev->stats;
+		stats = rtl8152_get_stats(tp->netdev);
 		stats->tx_dropped++;
 		dev_kfree_skb(skb);
 	}
@@ -2150,17 +2115,64 @@ static inline void rtl_tx_vlan_tag(struct tx_desc *desc, struct sk_buff *skb)
 	}
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
+
+static inline bool
+rtl_rx_vlan_tag(struct r8152 *tp, struct rx_desc *desc, struct sk_buff *skb)
+{
+	u32 opts2 = le32_to_cpu(desc->opts2);
+
+	if (tp->vlgrp && (opts2 & RX_VLAN_TAG)) {
+		vlan_gro_receive(&tp->napi, tp->vlgrp, swab16(opts2 & 0xffff),
+				 skb);
+		return true;
+	}
+
+	return false;
+}
+
+static inline void
+rtl_vlan_put_tag(struct r8152 *tp, struct rx_desc *desc, struct sk_buff *skb)
+{
+	u32 opts2 = le32_to_cpu(desc->opts2);
+
+	if (tp->vlgrp && (opts2 & RX_VLAN_TAG))
+		__vlan_hwaccel_put_tag(skb, swab16(opts2 & 0xffff));
+}
+
+static inline __u16
+rtl_vlan_get_tag(struct sk_buff *skb)
+{
+	__u16 tag;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
+	__vlan_hwaccel_get_tag(skb, &tag);
+#else
+	tag = skb->vlan_tci;
+#endif
+
+	return tag;
+}
+
+#else
+
 static inline void rtl_rx_vlan_tag(struct rx_desc *desc, struct sk_buff *skb)
 {
 	u32 opts2 = le32_to_cpu(desc->opts2);
 
 	if (opts2 & RX_VLAN_TAG)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0)
+		__vlan_hwaccel_put_tag(skb, swab16(opts2 & 0xffff));
+#else
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       swab16(opts2 & 0xffff));
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0) */
 }
 
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0) */
+
 static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
-			 struct sk_buff *skb, u32 len)
+			 struct sk_buff *skb, u32 len, u32 transport_offset)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
 	u32 opts1, opts2 = 0;
@@ -2171,8 +2183,6 @@ static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
 	opts1 = len | TX_FS | TX_LS;
 
 	if (mss) {
-		u32 transport_offset = (u32)skb_transport_offset(skb);
-
 		if (transport_offset > GTTCPHO_MAX) {
 			netif_warn(tp, tx_err, tp->netdev,
 				   "Invalid transport offset 0x%x for TSO\n",
@@ -2203,7 +2213,6 @@ static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
 		opts1 |= transport_offset << GTTCPHO_SHIFT;
 		opts2 |= min(mss, MSS_MAX) << MSS_SHIFT;
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
-		u32 transport_offset = (u32)skb_transport_offset(skb);
 		u8 ip_protocol;
 
 		if (transport_offset > TCPHO_MAX) {
@@ -2267,6 +2276,7 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 		struct tx_desc *tx_desc;
 		struct sk_buff *skb;
 		unsigned int len;
+		u32 offset;
 
 		skb = __skb_dequeue(&skb_head);
 		if (!skb)
@@ -2282,7 +2292,9 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 		tx_data = tx_agg_align(tx_data);
 		tx_desc = (struct tx_desc *)tx_data;
 
-		if (r8152_tx_csum(tp, tx_desc, skb, skb->len)) {
+		offset = (u32)skb_transport_offset(skb);
+
+		if (r8152_tx_csum(tp, tx_desc, skb, skb->len, offset)) {
 			r8152_csum_workaround(tp, skb, &skb_head);
 			continue;
 		}
@@ -2305,12 +2317,9 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 		agg->skb_len += len;
 		agg->skb_num += skb_shinfo(skb)->gso_segs ?: 1;
 
-		dev_kfree_skb_any(skb);
+		dev_consume_skb_any(skb);
 
 		remain = agg_buf_sz - (int)(tx_agg_align(tx_data) - agg->head);
-
-		if (tp->dell_tb_rx_agg_bug)
-			break;
 	}
 
 	if (!skb_queue_empty(&skb_head)) {
@@ -2335,6 +2344,9 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 			  agg->head, (int)(tx_data - (u8 *)agg->head),
 			  (usb_complete_t)write_bulk_callback, agg);
 
+	agg->urb->sg = NULL;
+	agg->urb->num_sgs = 0;
+
 	ret = usb_submit_urb(agg->urb, GFP_ATOMIC);
 	if (ret < 0)
 		usb_autopm_put_interface_async(tp->intf);
@@ -2343,74 +2355,218 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 	return ret;
 }
 
-static u8 r8152_rx_csum(struct r8152 *tp, struct rx_desc *rx_desc)
+static int r8152_tx_agg_sg_fill(struct r8152 *tp, struct tx_agg *agg)
 {
-	u8 checksum = CHECKSUM_NONE;
-	u32 opts2, opts3;
-
-	if (!(tp->netdev->features & NETIF_F_RXCSUM))
-		goto return_result;
+	struct sk_buff_head skb_head, *tx_queue = &tp->tx_queue;
+	int max_sg_num, ret, sg_num;
+	struct scatterlist *sg;
+	int padding = 0;
 
-	opts2 = le32_to_cpu(rx_desc->opts2);
-	opts3 = le32_to_cpu(rx_desc->opts3);
+	__skb_queue_head_init(&skb_head);
+	spin_lock(&tx_queue->lock);
+	skb_queue_splice_init(tx_queue, &skb_head);
+	spin_unlock(&tx_queue->lock);
 
-	if (opts2 & RD_IPV4_CS) {
-		if (opts3 & IPF)
-			checksum = CHECKSUM_NONE;
-		else if ((opts2 & RD_UDP_CS) && !(opts3 & UDPF))
-			checksum = CHECKSUM_UNNECESSARY;
-		else if ((opts2 & RD_TCP_CS) && !(opts3 & TCPF))
-			checksum = CHECKSUM_UNNECESSARY;
-	} else if (opts2 & RD_IPV6_CS) {
-		if ((opts2 & RD_UDP_CS) && !(opts3 & UDPF))
-			checksum = CHECKSUM_UNNECESSARY;
-		else if ((opts2 & RD_TCP_CS) && !(opts3 & TCPF))
-			checksum = CHECKSUM_UNNECESSARY;
-	}
+	sg = agg->head;
+	max_sg_num = (agg_buf_sz / sizeof(*sg)) - 1;
+	max_sg_num = min_t(int, RTL_MAX_SG_NUM, max_sg_num);
+	sg_init_table(sg, max_sg_num + 1);
+	agg->skb_num = 0;
+	agg->skb_len = 0;
 
-return_result:
-	return checksum;
-}
+	for (sg_num = 0; sg_num < max_sg_num;) {
+		struct tx_desc tx_desc;
+		struct sk_buff *skb;
+		int num_sgs, headroom;
+		unsigned int len;
+		u32 offset;
 
-static inline bool rx_count_exceed(struct r8152 *tp)
-{
-	return atomic_read(&tp->rx_count) > RTL8152_MAX_RX;
-}
+		skb = __skb_dequeue(&skb_head);
+		if (!skb)
+			break;
 
-static inline int agg_offset(struct rx_agg *agg, void *addr)
-{
-	return (int)(addr - agg->buffer);
-}
+		headroom = skb_headroom(skb) - padding - sizeof(tx_desc);
 
-static struct rx_agg *rtl_get_free_rx(struct r8152 *tp, gfp_t mflags)
-{
-	struct rx_agg *agg, *agg_next, *agg_free = NULL;
-	unsigned long flags;
+		if (skb_header_cloned(skb) || headroom < 0) {
+			struct sk_buff *tx_skb;
 
-	spin_lock_irqsave(&tp->rx_lock, flags);
+			headroom = padding + sizeof(tx_desc);
+			tx_skb = skb_copy_expand(skb, headroom, 0, GFP_ATOMIC);
+			dev_kfree_skb_any(skb);
+			if (!tx_skb) {
+				struct net_device_stats *stats;
 
-	list_for_each_entry_safe(agg, agg_next, &tp->rx_used, list) {
-		if (page_count(agg->page) == 1) {
-			if (!agg_free) {
-				list_del_init(&agg->list);
-				agg_free = agg;
-				continue;
-			}
-			if (rx_count_exceed(tp)) {
-				list_del_init(&agg->list);
-				free_rx_agg(tp, agg);
+				stats = rtl8152_get_stats(tp->netdev);
+				stats->tx_dropped++;
+				netif_wake_queue(tp->netdev);
+				return NETDEV_TX_OK;
 			}
+			skb = tx_skb;
+			headroom = skb_headroom(skb) - headroom;
+		}
+
+		 /* calculate the fragment numbers for skb */
+		num_sgs = 1 + skb_shinfo(skb)->nr_frags;
+		len = skb->len;
+
+		if ((num_sgs + sg_num) > max_sg_num) {
+			__skb_queue_head(&skb_head, skb);
 			break;
 		}
-	}
 
-	spin_unlock_irqrestore(&tp->rx_lock, flags);
+		offset = (u32)skb_transport_offset(skb);
 
-	if (!agg_free && atomic_read(&tp->rx_count) < tp->rx_pending)
-		agg_free = alloc_rx_agg(tp, mflags);
+		if (r8152_tx_csum(tp, &tx_desc, skb, len, offset)) {
+			r8152_csum_workaround(tp, skb, &skb_head);
+			continue;
+		}
 
-	return agg_free;
-}
+		rtl_tx_vlan_tag(&tx_desc, skb);
+
+		WARN_ON(padding < 0);
+
+		/* use skb_headroom for tx desc */
+		skb->cb[0] = padding + sizeof(tx_desc);
+		memcpy(skb_push(skb, sizeof(tx_desc)), &tx_desc,
+		       sizeof(tx_desc));
+		if (padding)
+			memset(skb_push(skb, padding), 0, padding);
+
+		num_sgs = skb_to_sgvec_nomark(skb, sg, 0, skb->len);
+		if (num_sgs < 0) {
+			netif_err(tp, tx_err, tp->netdev,
+				  "skb_to_sgvec fail %d\n", num_sgs);
+			__skb_queue_head(&skb_head, skb);
+			break;
+		}
+
+		sg += num_sgs;
+
+		__skb_queue_tail(&agg->tx_skb, skb);
+
+		sg_num += num_sgs;
+		agg->skb_len += skb->len;
+		padding = len + sizeof(tx_desc);
+
+		agg->skb_num++;
+
+		padding = ALIGN(padding, TX_ALIGN) - padding;
+	}
+
+	sg_mark_end(sg);
+
+	if (!skb_queue_empty(&skb_head)) {
+		spin_lock(&tx_queue->lock);
+		skb_queue_splice(&skb_head, tx_queue);
+		spin_unlock(&tx_queue->lock);
+	}
+
+	netif_tx_lock(tp->netdev);
+
+	if (netif_queue_stopped(tp->netdev) &&
+	    skb_queue_len(&tp->tx_queue) < tp->tx_qlen)
+		netif_wake_queue(tp->netdev);
+
+	netif_tx_unlock(tp->netdev);
+
+	if (sg_num == 0) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&tp->tx_lock, flags);
+		list_add_tail(&agg->list, &tp->tx_free);
+		spin_unlock_irqrestore(&tp->tx_lock, flags);
+
+		ret = 0;
+		goto out_tx_fill;
+	}
+
+	ret = usb_autopm_get_interface_async(tp->intf);
+	if (ret < 0)
+		goto out_tx_fill;
+
+	usb_fill_bulk_urb(agg->urb, tp->udev, tp->pipe_out,
+			  NULL, (int)agg->skb_len,
+			  (usb_complete_t)write_bulk_sg_callback, agg);
+
+	agg->urb->sg = agg->head;
+	agg->urb->num_sgs = sg_num;
+
+	ret = usb_submit_urb(agg->urb, GFP_ATOMIC);
+	if (ret < 0)
+		usb_autopm_put_interface_async(tp->intf);
+
+out_tx_fill:
+	return ret;
+}
+
+static u8 r8152_rx_csum(struct r8152 *tp, struct rx_desc *rx_desc)
+{
+	u8 checksum = CHECKSUM_NONE;
+	u32 opts2, opts3;
+
+	if (!(tp->netdev->features & NETIF_F_RXCSUM))
+		goto return_result;
+
+	opts2 = le32_to_cpu(rx_desc->opts2);
+	opts3 = le32_to_cpu(rx_desc->opts3);
+
+	if (opts2 & RD_IPV4_CS) {
+		if (opts3 & IPF)
+			checksum = CHECKSUM_NONE;
+		else if ((opts2 & RD_UDP_CS) && !(opts3 & UDPF))
+			checksum = CHECKSUM_UNNECESSARY;
+		else if ((opts2 & RD_TCP_CS) && !(opts3 & TCPF))
+			checksum = CHECKSUM_UNNECESSARY;
+	} else if (opts2 & RD_IPV6_CS) {
+		if ((opts2 & RD_UDP_CS) && !(opts3 & UDPF))
+			checksum = CHECKSUM_UNNECESSARY;
+		else if ((opts2 & RD_TCP_CS) && !(opts3 & TCPF))
+			checksum = CHECKSUM_UNNECESSARY;
+	}
+
+return_result:
+	return checksum;
+}
+
+static inline bool rx_count_exceed(struct r8152 *tp)
+{
+	return atomic_read(&tp->rx_count) > RTL8152_MAX_RX;
+}
+
+static inline int agg_offset(struct rx_agg *agg, void *addr)
+{
+	return (int)(addr - agg->buffer);
+}
+
+static struct rx_agg *rtl_get_free_rx(struct r8152 *tp, gfp_t mflags)
+{
+	struct rx_agg *agg, *agg_next, *agg_free = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tp->rx_lock, flags);
+
+	list_for_each_entry_safe(agg, agg_next, &tp->rx_used, list) {
+		if (page_count(agg->page) == 1) {
+			if (!agg_free) {
+				list_del_init(&agg->list);
+				agg_free = agg;
+				continue;
+			}
+			if (rx_count_exceed(tp)) {
+				list_del_init(&agg->list);
+				free_rx_agg(tp, agg);
+			}
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&tp->rx_lock, flags);
+
+	if (!agg_free && atomic_read(&tp->rx_count) < tp->rx_pending)
+		agg_free = alloc_rx_agg(tp, mflags);
+
+	return agg_free;
+}
 
 static int rx_bottom(struct r8152 *tp, int budget)
 {
@@ -2423,15 +2579,34 @@ static int rx_bottom(struct r8152 *tp, int budget)
 		while (work_done < budget) {
 			struct sk_buff *skb = __skb_dequeue(&tp->rx_queue);
 			struct net_device *netdev = tp->netdev;
-			struct net_device_stats *stats = &netdev->stats;
+			struct net_device_stats *stats;
 			unsigned int pkt_len;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
+			u16 vlan_tci;
+#endif
 
 			if (!skb)
 				break;
 
 			pkt_len = skb->len;
+			stats = rtl8152_get_stats(netdev);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
+			vlan_tci = rtl_vlan_get_tag(skb);
+
+			if (vlan_tci)
+				vlan_gro_receive(napi, tp->vlgrp, vlan_tci,
+						 skb);
+			else
+				napi_gro_receive(napi, skb);
+#else
 			napi_gro_receive(napi, skb);
+#endif
+
 			work_done++;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+			netdev->last_rx = jiffies;
+#endif
 			stats->rx_packets++;
 			stats->rx_bytes += pkt_len;
 		}
@@ -2468,7 +2643,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 
 		while (urb->actual_length > len_used) {
 			struct net_device *netdev = tp->netdev;
-			struct net_device_stats *stats = &netdev->stats;
+			struct net_device_stats *stats;
 			unsigned int pkt_len, rx_frag_head_sz;
 			struct sk_buff *skb;
 
@@ -2484,6 +2659,8 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			if (urb->actual_length < len_used)
 				break;
 
+			stats = rtl8152_get_stats(netdev);
+
 			pkt_len -= ETH_FCS_LEN;
 			rx_data += sizeof(struct rx_desc);
 
@@ -2511,7 +2688,26 @@ static int rx_bottom(struct r8152 *tp, int budget)
 				get_page(agg->page);
 			}
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
+			skb->dev = netdev;
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
 			skb->protocol = eth_type_trans(skb, netdev);
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
+			if (work_done < budget) {
+				if (!rtl_rx_vlan_tag(tp, rx_desc, skb))
+					napi_gro_receive(napi, skb);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+				netdev->last_rx = jiffies;
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
+				work_done++;
+				stats->rx_packets++;
+				stats->rx_bytes += skb->len;
+			} else {
+				rtl_vlan_put_tag(tp, rx_desc, skb);
+				__skb_queue_tail(&tp->rx_queue, skb);
+			}
+#else
 			rtl_rx_vlan_tag(rx_desc, skb);
 			if (work_done < budget) {
 				work_done++;
@@ -2521,6 +2717,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			} else {
 				__skb_queue_tail(&tp->rx_queue, skb);
 			}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0) */
 
 find_next_rx:
 			rx_data = rx_agg_align(rx_data + pkt_len + ETH_FCS_LEN);
@@ -2577,7 +2774,11 @@ static void tx_bottom(struct r8152 *tp)
 		if (!agg)
 			break;
 
-		res = r8152_tx_agg_fill(tp, agg);
+		if (tp->sg_use)
+			res = r8152_tx_agg_sg_fill(tp, agg);
+		else
+			res = r8152_tx_agg_fill(tp, agg);
+
 		if (!res)
 			continue;
 
@@ -2599,7 +2800,11 @@ static void tx_bottom(struct r8152 *tp)
 	} while (res == 0);
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,9,0)
+static void bottom_half(unsigned long t)
+#else
 static void bottom_half(struct tasklet_struct *t)
+#endif
 {
 	struct r8152 *tp = from_tasklet(tp, t, tx_tl);
 
@@ -2619,24 +2824,57 @@ static void bottom_half(struct tasklet_struct *t)
 	tx_bottom(tp);
 }
 
-static int r8152_poll(struct napi_struct *napi, int budget)
+static inline int __r8152_poll(struct r8152 *tp, int budget)
 {
-	struct r8152 *tp = container_of(napi, struct r8152, napi);
+	struct napi_struct *napi = &tp->napi;
 	int work_done;
 
 	work_done = rx_bottom(tp, budget);
 
 	if (work_done < budget) {
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
+		napi_complete_done(napi, work_done);
+#else
 		if (!napi_complete_done(napi, work_done))
 			goto out;
+#endif
 		if (!list_empty(&tp->rx_done))
 			napi_schedule(napi);
 	}
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
 out:
+#endif
 	return work_done;
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
+
+static int r8152_poll(struct net_device *dev, int *budget)
+{
+	struct r8152 *tp = netdev_priv(dev);
+	int quota = min(dev->quota, *budget);
+	int work_done;
+
+	work_done = __r8152_poll(tp, quota);
+
+	*budget -= work_done;
+	dev->quota -= work_done;
+
+	return (work_done >= quota);
+}
+
+#else
+
+static int r8152_poll(struct napi_struct *napi, int budget)
+{
+	struct r8152 *tp = container_of(napi, struct r8152, napi);
+
+	return __r8152_poll(tp, budget);
+}
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24) */
+
 static
 int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 {
@@ -2675,7 +2913,7 @@ int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 
 static void rtl_drop_queued_tx(struct r8152 *tp)
 {
-	struct net_device_stats *stats = &tp->netdev->stats;
+	struct net_device_stats *stats = rtl8152_get_stats(tp->netdev);
 	struct sk_buff_head skb_head, *tx_queue = &tp->tx_queue;
 	struct sk_buff *skb;
 
@@ -2693,32 +2931,47 @@ static void rtl_drop_queued_tx(struct r8152 *tp)
 	}
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,6,0)
+static void rtl8152_tx_timeout(struct net_device *netdev)
+#else
 static void rtl8152_tx_timeout(struct net_device *netdev, unsigned int txqueue)
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,6,0) */
 {
 	struct r8152 *tp = netdev_priv(netdev);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+	int i;
+#endif
 
 	netif_warn(tp, tx_err, netdev, "Tx timeout\n");
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+	for (i = 0; i < RTL8152_MAX_TX; i++)
+		usb_unlink_urb(tp->tx_info[i].urb);
+#else
 	usb_queue_reset_device(tp->intf);
+#endif
 }
 
 static void rtl8152_set_rx_mode(struct net_device *netdev)
-{
-	struct r8152 *tp = netdev_priv(netdev);
-
-	if (netif_carrier_ok(netdev)) {
-		set_bit(RTL8152_SET_RX_MODE, &tp->flags);
-		schedule_delayed_work(&tp->schedule, 0);
-	}
-}
-
-static void _rtl8152_set_rx_mode(struct net_device *netdev)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 	u32 mc_filter[2];	/* Multicast hash filter */
 	__le32 tmp[2];
 	u32 ocp_data;
 
+	if (in_atomic()) {
+		if (netif_carrier_ok(netdev)) {
+			set_bit(RTL8152_SET_RX_MODE, &tp->flags);
+			schedule_delayed_work(&tp->schedule, 0);
+		}
+		return;
+	}
+
+	clear_bit(RTL8152_SET_RX_MODE, &tp->flags);
+
+	if (!netif_carrier_ok(netdev))
+		return;
+
 	netif_stop_queue(netdev);
 	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
 	ocp_data &= ~RCR_ACPT_ALL;
@@ -2730,27 +2983,39 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 		ocp_data |= RCR_AM | RCR_AAP;
 		mc_filter[1] = 0xffffffff;
 		mc_filter[0] = 0xffffffff;
-	} else if ((netdev->flags & IFF_MULTICAST &&
-				netdev_mc_count(netdev) > multicast_filter_limit) ||
-			   (netdev->flags & IFF_ALLMULTI)) {
+	} else if ((netdev_mc_count(netdev) > multicast_filter_limit) ||
+		   (netdev->flags & IFF_ALLMULTI)) {
 		/* Too many to filter perfectly -- accept all multicasts. */
 		ocp_data |= RCR_AM;
 		mc_filter[1] = 0xffffffff;
 		mc_filter[0] = 0xffffffff;
 	} else {
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
+		struct dev_mc_list *mclist;
+		unsigned int i;
+
+		mc_filter[1] = mc_filter[0] = 0;
+		for (i = 0, mclist = netdev->mc_list;
+		     mclist && i < netdev->mc_count;
+		     i++, mclist = mclist->next) {
+			int bit_nr;
+
+			bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
+			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
+			ocp_data |= RCR_AM;
+		}
+#else
+		struct netdev_hw_addr *ha;
+
 		mc_filter[1] = 0;
 		mc_filter[0] = 0;
+		netdev_for_each_mc_addr(ha, netdev) {
+			int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
 
-		if (netdev->flags & IFF_MULTICAST) {
-			struct netdev_hw_addr *ha;
-
-			netdev_for_each_mc_addr(ha, netdev) {
-				int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
-
-				mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
-				ocp_data |= RCR_AM;
-			}
+			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
+			ocp_data |= RCR_AM;
 		}
+#endif
 	}
 
 	tmp[0] = __cpu_to_le32(swab32(mc_filter[1]));
@@ -2761,27 +3026,69 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 	netif_wake_queue(netdev);
 }
 
+static inline bool rtl_gso_check(struct net_device *dev, struct sk_buff *skb)
+{
+	struct r8152 *tp = netdev_priv(dev);
+
+	if (tp->sg_use)
+		return true;
+	else if ((skb->len + sizeof(struct tx_desc)) <= agg_buf_sz)
+		return true;
+	else
+		return false;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,4)
+
 static netdev_features_t
 rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
 		       netdev_features_t features)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
 	int max_offset = mss ? GTTCPHO_MAX : TCPHO_MAX;
+	int offset = skb_transport_offset(skb);
 
-	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) &&
-	    skb_transport_offset(skb) > max_offset)
+	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) && offset > max_offset)
 		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
-	else if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
+	else if (!rtl_gso_check(dev, skb))
 		features &= ~NETIF_F_GSO_MASK;
 
 	return features;
 }
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,4) */
 
 static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
 				      struct net_device *netdev)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,18,4)
+	if (unlikely(!rtl_gso_check(netdev, skb))) {
+		netdev_features_t features = netdev->features;
+		struct sk_buff *segs, *nskb;
+
+		features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+		segs = skb_gso_segment(skb, features);
+		if (IS_ERR(segs) || !segs)
+			goto free_skb;
+
+		do {
+			nskb = segs;
+			segs = segs->next;
+			nskb->next = NULL;
+			rtl8152_start_xmit(nskb, netdev);
+		} while (segs);
+
+free_skb:
+		dev_kfree_skb_any(skb);
+
+		return NETDEV_TX_OK;
+	}
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
+	netdev->trans_start = jiffies
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,18,4) */
+
 	skb_tx_timestamp(skb);
 
 	skb_queue_tail(&tp->tx_queue, skb);
@@ -2860,7 +3167,10 @@ static void rtl8152_nic_reset(struct r8152 *tp)
 
 static void set_tx_qlen(struct r8152 *tp)
 {
-	tp->tx_qlen = agg_buf_sz / (mtu_to_size(tp->netdev->mtu) + sizeof(struct tx_desc));
+	if (tp->sg_use)
+		tp->tx_qlen = RTL_MAX_SG_NUM;
+	else
+		tp->tx_qlen = agg_buf_sz / (mtu_to_size(tp->netdev->mtu) + sizeof(struct tx_desc));
 }
 
 static inline u16 rtl8152_get_speed(struct r8152 *tp)
@@ -3065,10 +3375,10 @@ static void r8153_set_rx_early_timeout(struct r8152 *tp)
 	case RTL_VER_09:
 	case RTL_VER_14:
 		/* The RTL8153B uses USB_RX_EXTRA_AGGR_TMR for rx timeout
-		 * primarily. For USB_RX_EARLY_TIMEOUT, we fix it to 128ns.
+		 * primarily. For USB_RX_EARLY_TIMEOUT, we fix it to 1264ns.
 		 */
 		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EARLY_TIMEOUT,
-			       128 / 8);
+			       1264 / 8);
 		ocp_write_word(tp, MCU_TYPE_USB, USB_RX_EXTRA_AGGR_TMR,
 			       ocp_data);
 		break;
@@ -3250,6 +3560,43 @@ static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 	}
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
+
+static void
+rtl8152_vlan_rx_register(struct net_device *dev, struct vlan_group *grp)
+{
+	struct r8152 *tp = netdev_priv(dev);
+
+	if (unlikely(tp->rtk_enable_diag))
+		return;
+
+	if (usb_autopm_get_interface(tp->intf) < 0)
+		return;
+
+	mutex_lock(&tp->control);
+
+	tp->vlgrp = grp;
+	if (tp->vlgrp)
+		rtl_rx_vlan_en(tp, true);
+	else
+		rtl_rx_vlan_en(tp, false);
+
+	mutex_unlock(&tp->control);
+}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
+
+static void rtl8152_vlan_rx_kill_vid(struct net_device *dev, unsigned short vid)
+{
+	struct r8152 *tp = netdev_priv(dev);
+
+	vlan_group_set_device(tp->vlgrp, vid, NULL);
+}
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
+
+#else
+
 static int rtl8152_set_features(struct net_device *dev,
 				netdev_features_t features)
 {
@@ -3257,6 +3604,9 @@ static int rtl8152_set_features(struct net_device *dev,
 	struct r8152 *tp = netdev_priv(dev);
 	int ret;
 
+	if (unlikely(tp->rtk_enable_diag))
+		return -EBUSY;
+
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		goto out;
@@ -3278,6 +3628,8 @@ static int rtl8152_set_features(struct net_device *dev,
 	return ret;
 }
 
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0) */
+
 #define WAKE_ANY (WAKE_PHY | WAKE_MAGIC | WAKE_UCAST | WAKE_BCAST | WAKE_MCAST)
 
 static u32 __rtl_get_wol(struct r8152 *tp)
@@ -3639,7 +3991,7 @@ static void r8153b_ups_en(struct r8152 *tp, bool enable)
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
 
 		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_2);
-		ocp_data &= ~UPS_FORCE_PWR_DOWN;
+		ocp_data &= ~(UPS_FORCE_PWR_DOWN | UPS_NO_UPS);
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_MISC_2, ocp_data);
 
 		if (ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0) & PCUT_STATUS) {
@@ -3679,7 +4031,7 @@ static void r8153c_ups_en(struct r8152 *tp, bool enable)
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
 
 		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_2);
-		ocp_data &= ~UPS_FORCE_PWR_DOWN;
+		ocp_data &= ~(UPS_FORCE_PWR_DOWN | UPS_NO_UPS);
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_MISC_2, ocp_data);
 
 		if (ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0) & PCUT_STATUS) {
@@ -3737,7 +4089,7 @@ static void r8156_ups_en(struct r8152 *tp, bool enable)
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_POWER_CUT, ocp_data);
 
 		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_2);
-		ocp_data &= ~UPS_FORCE_PWR_DOWN;
+		ocp_data &= ~(UPS_FORCE_PWR_DOWN | UPS_NO_UPS);
 		ocp_write_byte(tp, MCU_TYPE_USB, USB_MISC_2, ocp_data);
 
 		if (ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0) & PCUT_STATUS) {
@@ -3840,10 +4192,14 @@ static void rtl_runtime_suspend_enable(struct r8152 *tp, bool enable)
 static void rtl8153_runtime_enable(struct r8152 *tp, bool enable)
 {
 	if (enable) {
+		if (tp->version == RTL_VER_06)
+			r8153_queue_wake(tp, true);
 		r8153_u1u2en(tp, false);
 		r8153_u2p3en(tp, false);
 		rtl_runtime_suspend_enable(tp, true);
 	} else {
+		if (tp->version == RTL_VER_06)
+			r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
 
 		switch (tp->version) {
@@ -3873,6 +4229,7 @@ static void rtl8153b_runtime_enable(struct r8152 *tp, bool enable)
 		r8153b_ups_en(tp, false);
 		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
+//		r8153_u2p3en(tp, true);
 		if (tp->udev->speed >= USB_SPEED_SUPER)
 			r8153b_u1u2en(tp, true);
 	}
@@ -3890,6 +4247,7 @@ static void rtl8153c_runtime_enable(struct r8152 *tp, bool enable)
 		r8153c_ups_en(tp, false);
 		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
+//		r8153_u2p3en(tp, true);
 		r8153b_u1u2en(tp, true);
 	}
 }
@@ -3901,7 +4259,11 @@ static void rtl8156_runtime_enable(struct r8152 *tp, bool enable)
 		r8153b_u1u2en(tp, false);
 		r8153_u2p3en(tp, false);
 		rtl_runtime_suspend_enable(tp, true);
+//		if (tp->version != RTL_VER_10 ||
+//		    tp->udev->speed == USB_SPEED_HIGH)
+//			r8156_ups_en(tp, true);
 	} else {
+//		r8156_ups_en(tp, false);
 		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
 		r8153_u2p3en(tp, true);
@@ -3910,6 +4272,23 @@ static void rtl8156_runtime_enable(struct r8152 *tp, bool enable)
 	}
 }
 
+static int rtl_nway_restart(struct r8152 *tp)
+{
+	int r = -EINVAL;
+	int bmcr;
+
+	/* if autoneg is off, it's an error */
+	bmcr = r8152_mdio_read(tp, MII_BMCR);
+
+	if (bmcr & BMCR_ANENABLE) {
+		bmcr |= BMCR_ANRESTART;
+		r8152_mdio_write(tp, MII_BMCR, bmcr);
+		r = 0;
+	}
+
+	return r;
+}
+
 static void r8153_teredo_off(struct r8152 *tp)
 {
 	u32 ocp_data;
@@ -4105,1614 +4484,4875 @@ static int rtl_post_ram_code(struct r8152 *tp, u16 key_addr, bool wait)
 	return 0;
 }
 
-static bool rtl8152_is_fw_phy_speed_up_ok(struct r8152 *tp, struct fw_phy_speed_up *phy)
+static void patch4(struct r8152 *tp)
 {
-	u16 fw_offset;
-	u32 length;
-	bool rc = false;
+	u8 data;
+
+	data = ocp_read_byte(tp, MCU_TYPE_USB, 0xd429);
+	data |= 0x80;
+	ocp_write_byte(tp, MCU_TYPE_USB, 0xd429, data);
+	ocp_write_word(tp, MCU_TYPE_USB, 0xc0ce, 0x0210);
+	data = ocp_read_byte(tp, MCU_TYPE_USB, 0xd429);
+	data &= ~0x80;
+	ocp_write_byte(tp, MCU_TYPE_USB, 0xd429, data);
+}
 
-	switch (tp->version) {
-	case RTL_VER_01:
-	case RTL_VER_02:
-	case RTL_VER_03:
-	case RTL_VER_04:
-	case RTL_VER_05:
-	case RTL_VER_06:
-	case RTL_VER_07:
-	case RTL_VER_08:
-	case RTL_VER_09:
-	case RTL_VER_10:
-	case RTL_VER_11:
-	case RTL_VER_12:
-	case RTL_VER_14:
-		goto out;
-	case RTL_VER_13:
-	case RTL_VER_15:
-	default:
-		break;
-	}
+static void r8152b_firmware(struct r8152 *tp)
+{
+	if (tp->version == RTL_VER_01) {
+		int i;
+		static u8 pla_patch_a[] = {
+			0x08, 0xe0, 0x40, 0xe0,
+			0x78, 0xe0, 0x85, 0xe0,
+			0x5d, 0xe1, 0xa1, 0xe1,
+			0xa3, 0xe1, 0xab, 0xe1,
+			0x31, 0xc3, 0x60, 0x72,
+			0xa0, 0x49, 0x10, 0xf0,
+			0xa4, 0x49, 0x0e, 0xf0,
+			0x2c, 0xc3, 0x62, 0x72,
+			0x26, 0x70, 0x80, 0x49,
+			0x05, 0xf0, 0x2f, 0x48,
+			0x62, 0x9a, 0x24, 0x70,
+			0x60, 0x98, 0x24, 0xc3,
+			0x60, 0x99, 0x23, 0xc3,
+			0x00, 0xbb, 0x2c, 0x75,
+			0xdc, 0x21, 0xbc, 0x25,
+			0x04, 0x13, 0x0a, 0xf0,
+			0x03, 0x13, 0x08, 0xf0,
+			0x02, 0x13, 0x06, 0xf0,
+			0x01, 0x13, 0x04, 0xf0,
+			0x08, 0x13, 0x02, 0xf0,
+			0x03, 0xe0, 0xd4, 0x49,
+			0x04, 0xf1, 0x14, 0xc2,
+			0x12, 0xc3, 0x00, 0xbb,
+			0x12, 0xc3, 0x60, 0x75,
+			0xd0, 0x49, 0x05, 0xf1,
+			0x50, 0x48, 0x60, 0x9d,
+			0x09, 0xc6, 0x00, 0xbe,
+			0xd0, 0x48, 0x60, 0x9d,
+			0xf3, 0xe7, 0xc2, 0xc0,
+			0x38, 0xd2, 0xc6, 0xd2,
+			0x84, 0x17, 0xa2, 0x13,
+			0x0c, 0x17, 0xbc, 0xc0,
+			0xa2, 0xd1, 0x33, 0xc5,
+			0xa0, 0x74, 0xc0, 0x49,
+			0x1f, 0xf0, 0x30, 0xc5,
+			0xa0, 0x73, 0x00, 0x13,
+			0x04, 0xf1, 0xa2, 0x73,
+			0x00, 0x13, 0x14, 0xf0,
+			0x28, 0xc5, 0xa0, 0x74,
+			0xc8, 0x49, 0x1b, 0xf1,
+			0x26, 0xc5, 0xa0, 0x76,
+			0xa2, 0x74, 0x01, 0x06,
+			0x20, 0x37, 0xa0, 0x9e,
+			0xa2, 0x9c, 0x1e, 0xc5,
+			0xa2, 0x73, 0x23, 0x40,
+			0x10, 0xf8, 0x04, 0xf3,
+			0xa0, 0x73, 0x33, 0x40,
+			0x0c, 0xf8, 0x15, 0xc5,
+			0xa0, 0x74, 0x41, 0x48,
+			0xa0, 0x9c, 0x14, 0xc5,
+			0xa0, 0x76, 0x62, 0x48,
+			0xe0, 0x48, 0xa0, 0x9e,
+			0x10, 0xc6, 0x00, 0xbe,
+			0x0a, 0xc5, 0xa0, 0x74,
+			0x48, 0x48, 0xa0, 0x9c,
+			0x0b, 0xc5, 0x20, 0x1e,
+			0xa0, 0x9e, 0xe5, 0x48,
+			0xa0, 0x9e, 0xf0, 0xe7,
+			0xbc, 0xc0, 0xc8, 0xd2,
+			0xcc, 0xd2, 0x28, 0xe4,
+			0x22, 0x02, 0xf0, 0xc0,
+			0x0b, 0xc0, 0x00, 0x71,
+			0x0a, 0xc0, 0x00, 0x72,
+			0xa0, 0x49, 0x04, 0xf0,
+			0xa4, 0x49, 0x02, 0xf0,
+			0x93, 0x48, 0x04, 0xc0,
+			0x00, 0xb8, 0x00, 0xe4,
+			0xc2, 0xc0, 0x8c, 0x09,
+			0x14, 0xc2, 0x40, 0x73,
+			0xba, 0x48, 0x40, 0x9b,
+			0x11, 0xc2, 0x40, 0x73,
+			0xb0, 0x49, 0x17, 0xf0,
+			0xbf, 0x49, 0x03, 0xf1,
+			0x09, 0xc5, 0x00, 0xbd,
+			0xb1, 0x49, 0x11, 0xf0,
+			0xb1, 0x48, 0x40, 0x9b,
+			0x02, 0xc2, 0x00, 0xba,
+			0x82, 0x18, 0x00, 0xa0,
+			0x1e, 0xfc, 0xbc, 0xc0,
+			0xf0, 0xc0, 0xde, 0xe8,
+			0x00, 0x80, 0x00, 0x60,
+			0x2c, 0x75, 0xd4, 0x49,
+			0x12, 0xf1, 0x29, 0xe0,
+			0xf8, 0xc2, 0x46, 0x71,
+			0xf7, 0xc2, 0x40, 0x73,
+			0xbe, 0x49, 0x03, 0xf1,
+			0xf5, 0xc7, 0x02, 0xe0,
+			0xf2, 0xc7, 0x4f, 0x30,
+			0x26, 0x62, 0xa1, 0x49,
+			0xf0, 0xf1, 0x22, 0x72,
+			0xa0, 0x49, 0xed, 0xf1,
+			0x25, 0x25, 0x18, 0x1f,
+			0x97, 0x30, 0x91, 0x30,
+			0x36, 0x9a, 0x2c, 0x75,
+			0x32, 0xc3, 0x60, 0x73,
+			0xb1, 0x49, 0x0d, 0xf1,
+			0xdc, 0x21, 0xbc, 0x25,
+			0x27, 0xc6, 0xc0, 0x77,
+			0x04, 0x13, 0x18, 0xf0,
+			0x03, 0x13, 0x19, 0xf0,
+			0x02, 0x13, 0x1a, 0xf0,
+			0x01, 0x13, 0x1b, 0xf0,
+			0xd4, 0x49, 0x03, 0xf1,
+			0x1c, 0xc5, 0x00, 0xbd,
+			0xcd, 0xc6, 0xc6, 0x67,
+			0x2e, 0x75, 0xd7, 0x22,
+			0xdd, 0x26, 0x05, 0x15,
+			0x1a, 0xf0, 0x14, 0xc6,
+			0x00, 0xbe, 0x13, 0xc5,
+			0x00, 0xbd, 0x12, 0xc5,
+			0x00, 0xbd, 0xf1, 0x49,
+			0xfb, 0xf1, 0xef, 0xe7,
+			0xf4, 0x49, 0xfa, 0xf1,
+			0xec, 0xe7, 0xf3, 0x49,
+			0xf7, 0xf1, 0xe9, 0xe7,
+			0xf2, 0x49, 0xf4, 0xf1,
+			0xe6, 0xe7, 0xb6, 0xc0,
+			0x6a, 0x14, 0xac, 0x13,
+			0xd6, 0x13, 0xfa, 0x14,
+			0xa0, 0xd1, 0x00, 0x00,
+			0xc0, 0x75, 0xd0, 0x49,
+			0x46, 0xf0, 0x26, 0x72,
+			0xa7, 0x49, 0x43, 0xf0,
+			0x22, 0x72, 0x25, 0x25,
+			0x20, 0x1f, 0x97, 0x30,
+			0x91, 0x30, 0x40, 0x73,
+			0xf3, 0xc4, 0x1c, 0x40,
+			0x04, 0xf0, 0xd7, 0x49,
+			0x05, 0xf1, 0x37, 0xe0,
+			0x53, 0x48, 0xc0, 0x9d,
+			0x08, 0x02, 0x40, 0x66,
+			0x64, 0x27, 0x06, 0x16,
+			0x30, 0xf1, 0x46, 0x63,
+			0x3b, 0x13, 0x2d, 0xf1,
+			0x34, 0x9b, 0x18, 0x1b,
+			0x93, 0x30, 0x2b, 0xc3,
+			0x10, 0x1c, 0x2b, 0xe8,
+			0x01, 0x14, 0x25, 0xf1,
+			0x00, 0x1d, 0x26, 0x1a,
+			0x8a, 0x30, 0x22, 0x73,
+			0xb5, 0x25, 0x0e, 0x0b,
+			0x00, 0x1c, 0x2c, 0xe8,
+			0x1f, 0xc7, 0x27, 0x40,
+			0x1a, 0xf1, 0x38, 0xe8,
+			0x32, 0x1f, 0x8f, 0x30,
+			0x08, 0x1b, 0x24, 0xe8,
+			0x36, 0x72, 0x46, 0x77,
+			0x00, 0x17, 0x0d, 0xf0,
+			0x13, 0xc3, 0x1f, 0x40,
+			0x03, 0xf1, 0x00, 0x1f,
+			0x46, 0x9f, 0x44, 0x77,
+			0x9f, 0x44, 0x5f, 0x44,
+			0x17, 0xe8, 0x0a, 0xc7,
+			0x27, 0x40, 0x05, 0xf1,
+			0x02, 0xc3, 0x00, 0xbb,
+			0x50, 0x1a, 0x06, 0x1a,
+			0xff, 0xc7, 0x00, 0xbf,
+			0xb8, 0xcd, 0xff, 0xff,
+			0x02, 0x0c, 0x54, 0xa5,
+			0xdc, 0xa5, 0x2f, 0x40,
+			0x05, 0xf1, 0x00, 0x14,
+			0xfa, 0xf1, 0x01, 0x1c,
+			0x02, 0xe0, 0x00, 0x1c,
+			0x80, 0xff, 0xb0, 0x49,
+			0x04, 0xf0, 0x01, 0x0b,
+			0xd3, 0xa1, 0x03, 0xe0,
+			0x02, 0x0b, 0xd3, 0xa5,
+			0x27, 0x31, 0x20, 0x37,
+			0x02, 0x0b, 0xd3, 0xa5,
+			0x27, 0x31, 0x20, 0x37,
+			0x00, 0x13, 0xfb, 0xf1,
+			0x80, 0xff, 0x22, 0x73,
+			0xb5, 0x25, 0x18, 0x1e,
+			0xde, 0x30, 0xd9, 0x30,
+			0x64, 0x72, 0x11, 0x1e,
+			0x68, 0x23, 0x16, 0x31,
+			0x80, 0xff, 0xd4, 0x49,
+			0x28, 0xf0, 0x02, 0xb4,
+			0x2a, 0xc4, 0x00, 0x1d,
+			0x2e, 0xe8, 0xe0, 0x73,
+			0xb9, 0x21, 0xbd, 0x25,
+			0x04, 0x13, 0x02, 0xf0,
+			0x1a, 0xe0, 0x22, 0xc4,
+			0x23, 0xc3, 0x2f, 0xe8,
+			0x23, 0xc3, 0x2d, 0xe8,
+			0x00, 0x1d, 0x21, 0xe8,
+			0xe2, 0x73, 0xbb, 0x49,
+			0xfc, 0xf0, 0xe0, 0x73,
+			0xb7, 0x48, 0x03, 0xb4,
+			0x81, 0x1d, 0x19, 0xe8,
+			0x40, 0x1a, 0x84, 0x1d,
+			0x16, 0xe8, 0x12, 0xc3,
+			0x1e, 0xe8, 0x03, 0xb0,
+			0x81, 0x1d, 0x11, 0xe8,
+			0x0e, 0xc3, 0x19, 0xe8,
+			0x02, 0xb0, 0x06, 0xc7,
+			0x04, 0x1e, 0xe0, 0x9e,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x22, 0x02, 0x20, 0xe4,
+			0x04, 0xb8, 0x34, 0xb0,
+			0x00, 0x02, 0x00, 0x03,
+			0x00, 0x0e, 0x00, 0x0c,
+			0x09, 0xc7, 0xe0, 0x9b,
+			0xe2, 0x9a, 0xe4, 0x9c,
+			0xe6, 0x8d, 0xe6, 0x76,
+			0xef, 0x49, 0xfe, 0xf1,
+			0x80, 0xff, 0x08, 0xea,
+			0x82, 0x1d, 0xf5, 0xef,
+			0x00, 0x1a, 0x88, 0x1d,
+			0xf2, 0xef, 0xed, 0xc2,
+			0xf0, 0xef, 0x80, 0xff,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x46, 0x06, 0x08, 0xc2,
+			0x40, 0x73, 0x3a, 0x48,
+			0x40, 0x9b, 0x06, 0xff,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x86, 0x17, 0x1e, 0xfc,
+			0x36, 0xf0, 0x08, 0x1c,
+			0xea, 0x8c, 0xe3, 0x64,
+			0xc7, 0x49, 0x25, 0xf1,
+			0xe0, 0x75, 0xff, 0x1b,
+			0xeb, 0x47, 0xff, 0x1b,
+			0x6b, 0x47, 0xe0, 0x9d,
+			0x15, 0xc3, 0x60, 0x75,
+			0xd8, 0x49, 0x04, 0xf0,
+			0x81, 0x1d, 0xe2, 0x8d,
+			0x05, 0xe0, 0xe2, 0x63,
+			0x81, 0x1d, 0xdd, 0x47,
+			0xe2, 0x8b, 0x0b, 0xc3,
+			0x00, 0x1d, 0x61, 0x8d,
+			0x3c, 0x03, 0x60, 0x75,
+			0xd8, 0x49, 0x06, 0xf1,
+			0xdf, 0x48, 0x61, 0x95,
+			0x16, 0xe0, 0x4e, 0xe8,
+			0x12, 0xe8, 0x21, 0xc5,
+			0xa0, 0x73, 0xb0, 0x49,
+			0x03, 0xf0, 0x31, 0x48,
+			0xa0, 0x9b, 0x0d, 0xe0,
+			0xc0, 0x49, 0x0b, 0xf1,
+			0xe2, 0x63, 0x7e, 0x1d,
+			0xdd, 0x46, 0xe2, 0x8b,
+			0xe0, 0x75, 0x83, 0x1b,
+			0xeb, 0x46, 0xfe, 0x1b,
+			0x6b, 0x46, 0xe0, 0x9d,
+			0xe4, 0x49, 0x11, 0xf0,
+			0x10, 0x1d, 0xea, 0x8d,
+			0xe3, 0x64, 0xc6, 0x49,
+			0x09, 0xf1, 0x07, 0xc5,
+			0xa0, 0x73, 0xb1, 0x48,
+			0xa0, 0x9b, 0x02, 0xc5,
+			0x00, 0xbd, 0xe6, 0x04,
+			0xa0, 0xd1, 0x02, 0xc5,
+			0x00, 0xbd, 0xfe, 0x04,
+			0x02, 0xc5, 0x00, 0xbd,
+			0x30, 0x05, 0x00, 0x00 };
+		static u16 ram_code1[] = {
+			0x9700, 0x7fe0, 0x4c00, 0x4007,
+			0x4400, 0x4800, 0x7c1f, 0x4c00,
+			0x5310, 0x6000, 0x7c07, 0x6800,
+			0x673e, 0x0000, 0x0000, 0x571f,
+			0x5ffb, 0xaa05, 0x5b58, 0x7d80,
+			0x6100, 0x3019, 0x5b64, 0x7d80,
+			0x6080, 0xa6f8, 0xdcdb, 0x0015,
+			0xb915, 0xb511, 0xd16b, 0x000f,
+			0xb40f, 0xd06b, 0x000d, 0xb206,
+			0x7c01, 0x5800, 0x7c04, 0x5c00,
+			0x3011, 0x7c01, 0x5801, 0x7c04,
+			0x5c04, 0x3019, 0x30a5, 0x3127,
+			0x31d5, 0x7fe0, 0x4c60, 0x7c07,
+			0x6803, 0x7d00, 0x6900, 0x65a0,
+			0x0000, 0x0000, 0xaf03, 0x6015,
+			0x303e, 0x6017, 0x57e0, 0x580c,
+			0x588c, 0x7fdd, 0x5fa2, 0x4827,
+			0x7c1f, 0x4c00, 0x7c1f, 0x4c10,
+			0x8400, 0x7c30, 0x6020, 0x48bf,
+			0x7c1f, 0x4c00, 0x7c1f, 0x4c01,
+			0x7c07, 0x6803, 0xb806, 0x7c08,
+			0x6800, 0x0000, 0x0000, 0x305c,
+			0x7c08, 0x6808, 0x0000, 0x0000,
+			0xae06, 0x7c02, 0x5c02, 0x0000,
+			0x0000, 0x3067, 0x8e05, 0x7c02,
+			0x5c00, 0x0000, 0x0000, 0xad06,
+			0x7c20, 0x5c20, 0x0000, 0x0000,
+			0x3072, 0x8d05, 0x7c20, 0x5c00,
+			0x0000, 0x0000, 0xa008, 0x7c07,
+			0x6800, 0xb8db, 0x7c07, 0x6803,
+			0xd9b3, 0x00d7, 0x7fe0, 0x4c80,
+			0x7c08, 0x6800, 0x0000, 0x0000,
+			0x7c23, 0x5c23, 0x481d, 0x7c1f,
+			0x4c00, 0x7c1f, 0x4c02, 0x5310,
+			0x81ff, 0x30f5, 0x7fe0, 0x4d00,
+			0x4832, 0x7c1f, 0x4c00, 0x7c1f,
+			0x4c10, 0x7c08, 0x6000, 0xa49e,
+			0x7c07, 0x6800, 0xb89b, 0x7c07,
+			0x6803, 0xd9b3, 0x00f9, 0x7fe0,
+			0x4d20, 0x7e00, 0x6200, 0x3001,
+			0x7fe0, 0x4dc0, 0xd09d, 0x0002,
+			0xb4fe, 0x7fe0, 0x4d80, 0x7c04,
+			0x6004, 0x7c07, 0x6802, 0x6728,
+			0x0000, 0x0000, 0x7c08, 0x6000,
+			0x486c, 0x7c1f, 0x4c00, 0x7c1f,
+			0x4c01, 0x9503, 0x7e00, 0x6200,
+			0x571f, 0x5fbb, 0xaa05, 0x5b58,
+			0x7d80, 0x6100, 0x30c2, 0x5b64,
+			0x7d80, 0x6080, 0xcdab, 0x0063,
+			0xcd8d, 0x0061, 0xd96b, 0x005f,
+			0xd0a0, 0x00d7, 0xcba0, 0x0003,
+			0x80ec, 0x30cf, 0x30dc, 0x7fe0,
+			0x4ce0, 0x4832, 0x7c1f, 0x4c00,
+			0x7c1f, 0x4c08, 0x7c08, 0x6008,
+			0x8300, 0xb902, 0x30a5, 0x308a,
+			0x7fe0, 0x4da0, 0x65a8, 0x0000,
+			0x0000, 0x56a0, 0x590c, 0x7ffd,
+			0x5fa2, 0xae06, 0x7c02, 0x5c02,
+			0x0000, 0x0000, 0x30f0, 0x8e05,
+			0x7c02, 0x5c00, 0x0000, 0x0000,
+			0xcba4, 0x0004, 0xcd8d, 0x0002,
+			0x80f1, 0x7fe0, 0x4ca0, 0x7c08,
+			0x6408, 0x0000, 0x0000, 0x7d00,
+			0x6800, 0xb603, 0x7c10, 0x6010,
+			0x7d1f, 0x551f, 0x5fb3, 0xaa07,
+			0x7c80, 0x5800, 0x5b58, 0x7d80,
+			0x6100, 0x310f, 0x7c80, 0x5800,
+			0x5b64, 0x7d80, 0x6080, 0x4827,
+			0x7c1f, 0x4c00, 0x7c1f, 0x4c10,
+			0x8400, 0x7c10, 0x6000, 0x7fe0,
+			0x4cc0, 0x5fbb, 0x4824, 0x7c1f,
+			0x4c00, 0x7c1f, 0x4c04, 0x8200,
+			0x7ce0, 0x5400, 0x6728, 0x0000,
+			0x0000, 0x30cf, 0x3001, 0x7fe0,
+			0x4e00, 0x4007, 0x4400, 0x5310,
+			0x7c07, 0x6800, 0x673e, 0x0000,
+			0x0000, 0x570f, 0x5fff, 0xaa05,
+			0x585b, 0x7d80, 0x6100, 0x313b,
+			0x5867, 0x7d80, 0x6080, 0x9403,
+			0x7e00, 0x6200, 0xcda3, 0x00e7,
+			0xcd85, 0x00e5, 0xd96b, 0x00e3,
+			0x96e3, 0x7c07, 0x6800, 0x673e,
+			0x0000, 0x0000, 0x7fe0, 0x4e20,
+			0x96db, 0x8b04, 0x7c08, 0x5008,
+			0xab03, 0x7c08, 0x5000, 0x7c07,
+			0x6801, 0x677e, 0x0000, 0x0000,
+			0xdb7c, 0x00ec, 0x0000, 0x7fe1,
+			0x4f40, 0x4837, 0x4418, 0x41c7,
+			0x7fe0, 0x4e40, 0x7c40, 0x5400,
+			0x7c1f, 0x4c01, 0x7c1f, 0x4c01,
+			0x8fbf, 0xd2a0, 0x004b, 0x9204,
+			0xa042, 0x3168, 0x3127, 0x7fe1,
+			0x4f60, 0x489c, 0x4628, 0x7fe0,
+			0x4e60, 0x7e28, 0x4628, 0x7c40,
+			0x5400, 0x7c01, 0x5800, 0x7c04,
+			0x5c00, 0x41e8, 0x7c1f, 0x4c01,
+			0x7c1f, 0x4c01, 0x8fa5, 0xb241,
+			0xa02a, 0x3182, 0x7fe0, 0x4ea0,
+			0x7c02, 0x4402, 0x4448, 0x4894,
+			0x7c1f, 0x4c01, 0x7c1f, 0x4c03,
+			0x4824, 0x7c1f, 0x4c07, 0x41ef,
+			0x41ff, 0x4891, 0x7c1f, 0x4c07,
+			0x7c1f, 0x4c17, 0x8400, 0x8ef8,
+			0x41c7, 0x8f8a, 0x92d5, 0xa10f,
+			0xd480, 0x0008, 0xd580, 0x00b8,
+			0xa202, 0x319d, 0x7c04, 0x4404,
+			0x319d, 0xd484, 0x00f3, 0xd484,
+			0x00f1, 0x3127, 0x7fe0, 0x4ee0,
+			0x7c40, 0x5400, 0x4488, 0x41cf,
+			0x3127, 0x7fe0, 0x4ec0, 0x48f3,
+			0x7c1f, 0x4c01, 0x7c1f, 0x4c09,
+			0x4508, 0x41c7, 0x8fb0, 0xd218,
+			0x00ae, 0xd2a4, 0x009e, 0x31be,
+			0x7fe0, 0x4e80, 0x4832, 0x7c1f,
+			0x4c01, 0x7c1f, 0x4c11, 0x4428,
+			0x7c40, 0x5440, 0x7c01, 0x5801,
+			0x7c04, 0x5c04, 0x41e8, 0xa4b3,
+			0x31d3, 0x7fe0, 0x4f20, 0x7c07,
+			0x6800, 0x673e, 0x0000, 0x0000,
+			0x570f, 0x5fff, 0xaa04, 0x585b,
+			0x6100, 0x31e4, 0x5867, 0x6080,
+			0xbcf1, 0x3001 };
+
+		patch4(tp);
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+		generic_ocp_write(tp, 0xf800, 0x3f, sizeof(pla_patch_a),
+				  pla_patch_a, MCU_TYPE_PLA);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc26, 0x8000);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc28, 0x170b);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2a, 0x01e1);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2c, 0x0989);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2e, 0x1349);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc30, 0x01b7);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc32, 0x061d);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xe422, 0x0020);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xe420, 0x0018);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc34, 0x1785);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc36, 0x047b);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, 0x2000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb092, 0x7070);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb098, 0x0600);
+		for (i = 0; i < ARRAY_SIZE(ram_code1); i++)
+			ocp_write_word(tp, MCU_TYPE_PLA, 0xb09a, ram_code1[i]);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb098, 0x0200);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb092, 0x7030);
+
+		rtl_reset_ocp_base(tp);
+	} else if (tp->version == RTL_VER_02) {
+		static u8 pla_patch_a2[] = {
+			0x08, 0xe0, 0x1a, 0xe0,
+			0xf2, 0xe0, 0xfa, 0xe0,
+			0x32, 0xe1, 0x34, 0xe1,
+			0x36, 0xe1, 0x38, 0xe1,
+			0x2c, 0x75, 0xdc, 0x21,
+			0xbc, 0x25, 0x04, 0x13,
+			0x0b, 0xf0, 0x03, 0x13,
+			0x09, 0xf0, 0x02, 0x13,
+			0x07, 0xf0, 0x01, 0x13,
+			0x05, 0xf0, 0x08, 0x13,
+			0x03, 0xf0, 0x04, 0xc3,
+			0x00, 0xbb, 0x03, 0xc3,
+			0x00, 0xbb, 0xd2, 0x17,
+			0xbc, 0x17, 0x14, 0xc2,
+			0x40, 0x73, 0xba, 0x48,
+			0x40, 0x9b, 0x11, 0xc2,
+			0x40, 0x73, 0xb0, 0x49,
+			0x17, 0xf0, 0xbf, 0x49,
+			0x03, 0xf1, 0x09, 0xc5,
+			0x00, 0xbd, 0xb1, 0x49,
+			0x11, 0xf0, 0xb1, 0x48,
+			0x40, 0x9b, 0x02, 0xc2,
+			0x00, 0xba, 0x4e, 0x19,
+			0x00, 0xa0, 0x1e, 0xfc,
+			0xbc, 0xc0, 0xf0, 0xc0,
+			0xde, 0xe8, 0x00, 0x80,
+			0x00, 0x60, 0x2c, 0x75,
+			0xd4, 0x49, 0x12, 0xf1,
+			0x29, 0xe0, 0xf8, 0xc2,
+			0x46, 0x71, 0xf7, 0xc2,
+			0x40, 0x73, 0xbe, 0x49,
+			0x03, 0xf1, 0xf5, 0xc7,
+			0x02, 0xe0, 0xf2, 0xc7,
+			0x4f, 0x30, 0x26, 0x62,
+			0xa1, 0x49, 0xf0, 0xf1,
+			0x22, 0x72, 0xa0, 0x49,
+			0xed, 0xf1, 0x25, 0x25,
+			0x18, 0x1f, 0x97, 0x30,
+			0x91, 0x30, 0x36, 0x9a,
+			0x2c, 0x75, 0x32, 0xc3,
+			0x60, 0x73, 0xb1, 0x49,
+			0x0d, 0xf1, 0xdc, 0x21,
+			0xbc, 0x25, 0x27, 0xc6,
+			0xc0, 0x77, 0x04, 0x13,
+			0x18, 0xf0, 0x03, 0x13,
+			0x19, 0xf0, 0x02, 0x13,
+			0x1a, 0xf0, 0x01, 0x13,
+			0x1b, 0xf0, 0xd4, 0x49,
+			0x03, 0xf1, 0x1c, 0xc5,
+			0x00, 0xbd, 0xcd, 0xc6,
+			0xc6, 0x67, 0x2e, 0x75,
+			0xd7, 0x22, 0xdd, 0x26,
+			0x05, 0x15, 0x1a, 0xf0,
+			0x14, 0xc6, 0x00, 0xbe,
+			0x13, 0xc5, 0x00, 0xbd,
+			0x12, 0xc5, 0x00, 0xbd,
+			0xf1, 0x49, 0xfb, 0xf1,
+			0xef, 0xe7, 0xf4, 0x49,
+			0xfa, 0xf1, 0xec, 0xe7,
+			0xf3, 0x49, 0xf7, 0xf1,
+			0xe9, 0xe7, 0xf2, 0x49,
+			0xf4, 0xf1, 0xe6, 0xe7,
+			0xb6, 0xc0, 0xf6, 0x14,
+			0x36, 0x14, 0x62, 0x14,
+			0x86, 0x15, 0xa0, 0xd1,
+			0x00, 0x00, 0xc0, 0x75,
+			0xd0, 0x49, 0x46, 0xf0,
+			0x26, 0x72, 0xa7, 0x49,
+			0x43, 0xf0, 0x22, 0x72,
+			0x25, 0x25, 0x20, 0x1f,
+			0x97, 0x30, 0x91, 0x30,
+			0x40, 0x73, 0xf3, 0xc4,
+			0x1c, 0x40, 0x04, 0xf0,
+			0xd7, 0x49, 0x05, 0xf1,
+			0x37, 0xe0, 0x53, 0x48,
+			0xc0, 0x9d, 0x08, 0x02,
+			0x40, 0x66, 0x64, 0x27,
+			0x06, 0x16, 0x30, 0xf1,
+			0x46, 0x63, 0x3b, 0x13,
+			0x2d, 0xf1, 0x34, 0x9b,
+			0x18, 0x1b, 0x93, 0x30,
+			0x2b, 0xc3, 0x10, 0x1c,
+			0x2b, 0xe8, 0x01, 0x14,
+			0x25, 0xf1, 0x00, 0x1d,
+			0x26, 0x1a, 0x8a, 0x30,
+			0x22, 0x73, 0xb5, 0x25,
+			0x0e, 0x0b, 0x00, 0x1c,
+			0x2c, 0xe8, 0x1f, 0xc7,
+			0x27, 0x40, 0x1a, 0xf1,
+			0x38, 0xe8, 0x32, 0x1f,
+			0x8f, 0x30, 0x08, 0x1b,
+			0x24, 0xe8, 0x36, 0x72,
+			0x46, 0x77, 0x00, 0x17,
+			0x0d, 0xf0, 0x13, 0xc3,
+			0x1f, 0x40, 0x03, 0xf1,
+			0x00, 0x1f, 0x46, 0x9f,
+			0x44, 0x77, 0x9f, 0x44,
+			0x5f, 0x44, 0x17, 0xe8,
+			0x0a, 0xc7, 0x27, 0x40,
+			0x05, 0xf1, 0x02, 0xc3,
+			0x00, 0xbb, 0x1c, 0x1b,
+			0xd2, 0x1a, 0xff, 0xc7,
+			0x00, 0xbf, 0xb8, 0xcd,
+			0xff, 0xff, 0x02, 0x0c,
+			0x54, 0xa5, 0xdc, 0xa5,
+			0x2f, 0x40, 0x05, 0xf1,
+			0x00, 0x14, 0xfa, 0xf1,
+			0x01, 0x1c, 0x02, 0xe0,
+			0x00, 0x1c, 0x80, 0xff,
+			0xb0, 0x49, 0x04, 0xf0,
+			0x01, 0x0b, 0xd3, 0xa1,
+			0x03, 0xe0, 0x02, 0x0b,
+			0xd3, 0xa5, 0x27, 0x31,
+			0x20, 0x37, 0x02, 0x0b,
+			0xd3, 0xa5, 0x27, 0x31,
+			0x20, 0x37, 0x00, 0x13,
+			0xfb, 0xf1, 0x80, 0xff,
+			0x22, 0x73, 0xb5, 0x25,
+			0x18, 0x1e, 0xde, 0x30,
+			0xd9, 0x30, 0x64, 0x72,
+			0x11, 0x1e, 0x68, 0x23,
+			0x16, 0x31, 0x80, 0xff,
+			0x08, 0xc2, 0x40, 0x73,
+			0x3a, 0x48, 0x40, 0x9b,
+			0x06, 0xff, 0x02, 0xc6,
+			0x00, 0xbe, 0x4e, 0x18,
+			0x1e, 0xfc, 0x33, 0xc5,
+			0xa0, 0x74, 0xc0, 0x49,
+			0x1f, 0xf0, 0x30, 0xc5,
+			0xa0, 0x73, 0x00, 0x13,
+			0x04, 0xf1, 0xa2, 0x73,
+			0x00, 0x13, 0x14, 0xf0,
+			0x28, 0xc5, 0xa0, 0x74,
+			0xc8, 0x49, 0x1b, 0xf1,
+			0x26, 0xc5, 0xa0, 0x76,
+			0xa2, 0x74, 0x01, 0x06,
+			0x20, 0x37, 0xa0, 0x9e,
+			0xa2, 0x9c, 0x1e, 0xc5,
+			0xa2, 0x73, 0x23, 0x40,
+			0x10, 0xf8, 0x04, 0xf3,
+			0xa0, 0x73, 0x33, 0x40,
+			0x0c, 0xf8, 0x15, 0xc5,
+			0xa0, 0x74, 0x41, 0x48,
+			0xa0, 0x9c, 0x14, 0xc5,
+			0xa0, 0x76, 0x62, 0x48,
+			0xe0, 0x48, 0xa0, 0x9e,
+			0x10, 0xc6, 0x00, 0xbe,
+			0x0a, 0xc5, 0xa0, 0x74,
+			0x48, 0x48, 0xa0, 0x9c,
+			0x0b, 0xc5, 0x20, 0x1e,
+			0xa0, 0x9e, 0xe5, 0x48,
+			0xa0, 0x9e, 0xf0, 0xe7,
+			0xbc, 0xc0, 0xc8, 0xd2,
+			0xcc, 0xd2, 0x28, 0xe4,
+			0x22, 0x02, 0xf0, 0xc0,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x00, 0x00, 0x02, 0xc6,
+			0x00, 0xbe, 0x00, 0x00,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x00, 0x00, 0x02, 0xc6,
+			0x00, 0xbe, 0x00, 0x00,
+			0x00, 0x00, 0x00, 0x00 };
+		static u8 usb_patch_a2[] = {
+			0x10, 0xe0, 0x2d, 0xe0,
+			0x0e, 0xe0, 0x0d, 0xe0,
+			0x0c, 0xe0, 0x0b, 0xe0,
+			0x0a, 0xe0, 0x09, 0xe0,
+			0x08, 0xe0, 0x07, 0xe0,
+			0x06, 0xe0, 0x05, 0xe0,
+			0x04, 0xe0, 0x03, 0xe0,
+			0x02, 0xe0, 0x01, 0xe0,
+			0x1c, 0xc2, 0x40, 0x71,
+			0x9f, 0x48, 0x40, 0x99,
+			0x1f, 0x48, 0x40, 0x99,
+			0x15, 0xc2, 0x40, 0x61,
+			0x90, 0x49, 0x0a, 0xf0,
+			0x42, 0x70, 0x80, 0x49,
+			0x07, 0xf0, 0x80, 0x48,
+			0x42, 0x98, 0x0b, 0xc2,
+			0x40, 0x60, 0x03, 0x48,
+			0x40, 0x88, 0x0a, 0xc2,
+			0x08, 0x18, 0x55, 0x60,
+			0x55, 0x88, 0x02, 0xc0,
+			0x00, 0xb8, 0xc2, 0x09,
+			0x28, 0xd4, 0xd4, 0xc4,
+			0x06, 0xd4, 0x00, 0xb0,
+			0x61, 0xc7, 0x5a, 0xc6,
+			0xe4, 0x9e, 0x0f, 0x1e,
+			0xe6, 0x8e, 0xe6, 0x76,
+			0xef, 0x49, 0xfe, 0xf1,
+			0xe0, 0x73, 0xe2, 0x74,
+			0xb8, 0x26, 0xb8, 0x21,
+			0xb8, 0x25, 0x48, 0x23,
+			0x68, 0x27, 0x04, 0xb4,
+			0x05, 0xb4, 0x06, 0xb4,
+			0x4a, 0xc6, 0xe3, 0x23,
+			0xfe, 0x39, 0x00, 0x1c,
+			0x00, 0x1d, 0x00, 0x13,
+			0x0a, 0xf0, 0xb0, 0x49,
+			0x04, 0xf1, 0x01, 0x05,
+			0xb1, 0x25, 0xfa, 0xe7,
+			0xb8, 0x33, 0x35, 0x43,
+			0x30, 0x31, 0xf6, 0xe7,
+			0x06, 0xb0, 0x05, 0xb0,
+			0xae, 0x41, 0x25, 0x31,
+			0x37, 0xc5, 0x6c, 0x41,
+			0x04, 0xb0, 0x48, 0x26,
+			0x05, 0xb4, 0x36, 0xc7,
+			0x2f, 0xc6, 0x04, 0x06,
+			0xe4, 0x9e, 0x0f, 0x1e,
+			0xe6, 0x8e, 0xe6, 0x76,
+			0xef, 0x49, 0xfe, 0xf1,
+			0xe0, 0x76, 0xe8, 0x25,
+			0xe8, 0x23, 0xf8, 0x27,
+			0x24, 0xc5, 0x6c, 0x41,
+			0x33, 0x22, 0x23, 0x39,
+			0x7c, 0x41, 0xfd, 0x31,
+			0x1f, 0xc6, 0x7e, 0x41,
+			0x20, 0xc6, 0xc4, 0x9f,
+			0xf2, 0x21, 0xdf, 0x30,
+			0xdf, 0x30, 0x05, 0xb0,
+			0xc2, 0x9d, 0x53, 0x22,
+			0x25, 0x31, 0xa3, 0x31,
+			0x12, 0xc7, 0xb7, 0x31,
+			0x12, 0xc7, 0x77, 0x41,
+			0x12, 0xc7, 0xe6, 0x9e,
+			0x0f, 0xc3, 0xde, 0x30,
+			0x60, 0x64, 0xe8, 0x8c,
+			0x06, 0xc7, 0x04, 0x1e,
+			0xe0, 0x8e, 0x02, 0xc4,
+			0x00, 0xbc, 0xb6, 0x02,
+			0x34, 0xe4, 0x00, 0xc0,
+			0x25, 0x00, 0xff, 0x00,
+			0x7f, 0x00, 0x00, 0xf8,
+			0xf0, 0xc4, 0x08, 0xdc };
+		u32 ocp_data;
 
-	fw_offset = __le16_to_cpu(phy->fw_offset);
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	if (fw_offset < sizeof(*phy) || length <= fw_offset) {
-		dev_err(&tp->intf->dev, "invalid fw_offset\n");
-		goto out;
-	}
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
 
-	length -= fw_offset;
-	if (length & 3) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(pla_patch_a2),
+				  pla_patch_a2, MCU_TYPE_PLA);
 
-	if (__le16_to_cpu(phy->fw_reg) != 0x9A00) {
-		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
-		goto out;
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc26, 0x8000);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc28, 0x17a5);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2a, 0x13ad);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2c, 0x184d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2e, 0x01e1);
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(usb_patch_a2),
+				  usb_patch_a2, MCU_TYPE_USB);
+
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc26, 0xA000);
+
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc28, 0x0c87);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2a, 0x024f);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2c, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2e, 0x0000);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, 0xd428);
+		ocp_data |= BIT(15);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xd428, ocp_data);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, 0xc4d4);
+		ocp_data |= BIT(0);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xc4d4, ocp_data);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, 0xc4d6);
+		ocp_data &= ~BIT(0);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xc4d6, ocp_data);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, 0xd428);
+		ocp_data &= ~BIT(15);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xd428, ocp_data);
+
+		rtl_reset_ocp_base(tp);
 	}
 
-	rc = true;
-out:
-	return rc;
+	rtl_reset_ocp_base(tp);
 }
 
-static bool rtl8152_is_fw_phy_ver_ok(struct r8152 *tp, struct fw_phy_ver *ver)
+static void r8152_aldps_en(struct r8152 *tp, bool enable)
 {
-	bool rc = false;
-
-	switch (tp->version) {
-	case RTL_VER_10:
-	case RTL_VER_11:
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_15:
-		break;
-	default:
-		goto out;
+	if (enable) {
+		ocp_reg_write(tp, OCP_ALDPS_CONFIG, ENPWRSAVE | ENPDNPS |
+						    LINKENA | DIS_SDSAVE);
+	} else {
+		ocp_reg_write(tp, OCP_ALDPS_CONFIG, ENPDNPS | LINKENA |
+						    DIS_SDSAVE);
+		msleep(20);
 	}
+}
 
-	if (__le32_to_cpu(ver->blk_hdr.length) != sizeof(*ver)) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
+static inline void r8152_mmd_indirect(struct r8152 *tp, u16 dev, u16 reg)
+{
+	ocp_reg_write(tp, OCP_EEE_AR, FUN_ADDR | dev);
+	ocp_reg_write(tp, OCP_EEE_DATA, reg);
+	ocp_reg_write(tp, OCP_EEE_AR, FUN_DATA | dev);
+}
 
-	if (__le16_to_cpu(ver->ver.addr) != SRAM_GPHY_FW_VER) {
-		dev_err(&tp->intf->dev, "invalid phy ver addr\n");
-		goto out;
-	}
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+static u16 r8152_mmd_read(struct r8152 *tp, u16 dev, u16 reg)
+{
+	u16 data;
 
-	rc = true;
-out:
-	return rc;
+	r8152_mmd_indirect(tp, dev, reg);
+	data = ocp_reg_read(tp, OCP_EEE_DATA);
+	ocp_reg_write(tp, OCP_EEE_AR, 0x0000);
+
+	return data;
 }
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 
-static bool rtl8152_is_fw_phy_fixup_ok(struct r8152 *tp, struct fw_phy_fixup *fix)
+static void r8152_mmd_write(struct r8152 *tp, u16 dev, u16 reg, u16 data)
 {
-	bool rc = false;
+	r8152_mmd_indirect(tp, dev, reg);
+	ocp_reg_write(tp, OCP_EEE_DATA, data);
+	ocp_reg_write(tp, OCP_EEE_AR, 0x0000);
+}
 
-	switch (tp->version) {
-	case RTL_VER_10:
-	case RTL_VER_11:
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_15:
-		break;
-	default:
-		goto out;
-	}
+static void r8152_eee_en(struct r8152 *tp, bool enable)
+{
+	u16 config1, config2, config3;
+	u32 ocp_data;
 
-	if (__le32_to_cpu(fix->blk_hdr.length) != sizeof(*fix)) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
+	config1 = ocp_reg_read(tp, OCP_EEE_CONFIG1) & ~sd_rise_time_mask;
+	config2 = ocp_reg_read(tp, OCP_EEE_CONFIG2);
+	config3 = ocp_reg_read(tp, OCP_EEE_CONFIG3) & ~fast_snr_mask;
 
-	if (__le16_to_cpu(fix->setting.addr) != OCP_PHY_PATCH_CMD ||
-	    __le16_to_cpu(fix->setting.data) != BIT(7)) {
-		dev_err(&tp->intf->dev, "invalid phy fixup\n");
-		goto out;
+	if (enable) {
+		ocp_data |= EEE_RX_EN | EEE_TX_EN;
+		config1 |= EEE_10_CAP | EEE_NWAY_EN | TX_QUIET_EN | RX_QUIET_EN;
+		config1 |= sd_rise_time(1);
+		config2 |= RG_DACQUIET_EN | RG_LDVQUIET_EN;
+		config3 |= fast_snr(42);
+	} else {
+		ocp_data &= ~(EEE_RX_EN | EEE_TX_EN);
+		config1 &= ~(EEE_10_CAP | EEE_NWAY_EN | TX_QUIET_EN |
+			     RX_QUIET_EN);
+		config1 |= sd_rise_time(7);
+		config2 &= ~(RG_DACQUIET_EN | RG_LDVQUIET_EN);
+		config3 |= fast_snr(511);
 	}
 
-	rc = true;
-out:
-	return rc;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
+	ocp_reg_write(tp, OCP_EEE_CONFIG1, config1);
+	ocp_reg_write(tp, OCP_EEE_CONFIG2, config2);
+	ocp_reg_write(tp, OCP_EEE_CONFIG3, config3);
 }
 
-static bool rtl8152_is_fw_phy_union_ok(struct r8152 *tp, struct fw_phy_union *phy)
+static void r8153_eee_en(struct r8152 *tp, bool enable)
 {
-	u16 fw_offset;
-	u32 length;
-	bool rc = false;
+	u32 ocp_data;
+	u16 config;
 
-	switch (tp->version) {
-	case RTL_VER_10:
-	case RTL_VER_11:
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_15:
-		break;
-	default:
-		goto out;
-	}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
+	config = ocp_reg_read(tp, OCP_EEE_CFG);
 
-	fw_offset = __le16_to_cpu(phy->fw_offset);
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	if (fw_offset < sizeof(*phy) || length <= fw_offset) {
-		dev_err(&tp->intf->dev, "invalid fw_offset\n");
-		goto out;
+	if (enable) {
+		ocp_data |= EEE_RX_EN | EEE_TX_EN;
+		config |= EEE10_EN;
+	} else {
+		ocp_data &= ~(EEE_RX_EN | EEE_TX_EN);
+		config &= ~EEE10_EN;
 	}
 
-	length -= fw_offset;
-	if (length & 1) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
+	ocp_reg_write(tp, OCP_EEE_CFG, config);
 
-	if (phy->pre_num > 2) {
-		dev_err(&tp->intf->dev, "invalid pre_num %d\n", phy->pre_num);
-		goto out;
-	}
+	tp->ups_info.eee = enable;
+}
 
-	if (phy->bp_num > 8) {
-		dev_err(&tp->intf->dev, "invalid bp_num %d\n", phy->bp_num);
-		goto out;
-	}
+static void r8156_eee_en(struct r8152 *tp, bool enable)
+{
+	u16 config;
 
-	rc = true;
-out:
-	return rc;
+	r8153_eee_en(tp, enable);
+
+	config = ocp_reg_read(tp, OCP_EEE_ADV2);
+
+	if (enable)
+		config |= MDIO_EEE_2_5GT;
+	else
+		config &= ~MDIO_EEE_2_5GT;
+
+	ocp_reg_write(tp, OCP_EEE_ADV2, config);
 }
 
-static bool rtl8152_is_fw_phy_nc_ok(struct r8152 *tp, struct fw_phy_nc *phy)
+static void rtl_eee_enable(struct r8152 *tp, bool enable)
 {
-	u32 length;
-	u16 fw_offset, fw_reg, ba_reg, patch_en_addr, mode_reg, bp_start;
-	bool rc = false;
-
 	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_07:
+		if (enable) {
+			r8152_eee_en(tp, true);
+			r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV,
+					tp->eee_adv);
+		} else {
+			r8152_eee_en(tp, false);
+			r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
+		}
+		break;
+	case RTL_VER_03:
 	case RTL_VER_04:
 	case RTL_VER_05:
 	case RTL_VER_06:
-		fw_reg = 0xa014;
-		ba_reg = 0xa012;
-		patch_en_addr = 0xa01a;
-		mode_reg = 0xb820;
-		bp_start = 0xa000;
+	case RTL_VER_08:
+	case RTL_VER_09:
+	case RTL_VER_14:
+		if (enable) {
+			r8153_eee_en(tp, true);
+			ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
+		} else {
+			r8153_eee_en(tp, false);
+			ocp_reg_write(tp, OCP_EEE_ADV, 0);
+		}
+		break;
+	case RTL_VER_10:
+	case RTL_VER_11:
+	case RTL_VER_12:
+	case RTL_VER_13:
+	case RTL_VER_15:
+		if (enable) {
+			r8156_eee_en(tp, true);
+			ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
+		} else {
+			r8156_eee_en(tp, false);
+			ocp_reg_write(tp, OCP_EEE_ADV, 0);
+		}
 		break;
 	default:
-		goto out;
+		break;
 	}
+}
 
-	fw_offset = __le16_to_cpu(phy->fw_offset);
-	if (fw_offset < sizeof(*phy)) {
-		dev_err(&tp->intf->dev, "fw_offset too small\n");
-		goto out;
-	}
+static void r8152b_enable_fc(struct r8152 *tp)
+{
+	u16 anar;
 
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	if (length < fw_offset) {
-		dev_err(&tp->intf->dev, "invalid fw_offset\n");
-		goto out;
-	}
+	anar = r8152_mdio_read(tp, MII_ADVERTISE);
+	anar |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;
+	r8152_mdio_write(tp, MII_ADVERTISE, anar);
 
-	length -= __le16_to_cpu(phy->fw_offset);
-	if (!length || (length & 1)) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
+	tp->ups_info.flow_control = true;
+}
 
-	if (__le16_to_cpu(phy->fw_reg) != fw_reg) {
-		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
-		goto out;
-	}
+static void rtl8152_disable(struct r8152 *tp)
+{
+	r8152_aldps_en(tp, false);
+	rtl_disable(tp);
+	r8152_aldps_en(tp, true);
+}
 
-	if (__le16_to_cpu(phy->ba_reg) != ba_reg) {
-		dev_err(&tp->intf->dev, "invalid base address register\n");
-		goto out;
-	}
+static void r8152b_hw_phy_cfg(struct r8152 *tp)
+{
+	r8152b_firmware(tp);
 
-	if (__le16_to_cpu(phy->patch_en_addr) != patch_en_addr) {
-		dev_err(&tp->intf->dev,
-			"invalid patch mode enabled register\n");
-		goto out;
-	}
+	rtl_eee_enable(tp, tp->eee_en);
+	r8152_aldps_en(tp, true);
+	r8152b_enable_fc(tp);
 
-	if (__le16_to_cpu(phy->mode_reg) != mode_reg) {
-		dev_err(&tp->intf->dev,
-			"invalid register to switch the mode\n");
-		goto out;
-	}
+	set_bit(PHY_RESET, &tp->flags);
+}
 
-	if (__le16_to_cpu(phy->bp_start) != bp_start) {
-		dev_err(&tp->intf->dev,
-			"invalid start register of break point\n");
-		goto out;
-	}
+static void wait_oob_link_list_ready(struct r8152 *tp)
+{
+	u32 ocp_data;
+	int i;
 
-	if (__le16_to_cpu(phy->bp_num) > 4) {
-		dev_err(&tp->intf->dev, "invalid break point number\n");
-		goto out;
+	for (i = 0; i < 1000; i++) {
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+		if (ocp_data & LINK_LIST_READY)
+			break;
+		usleep_range(1000, 2000);
 	}
-
-	rc = true;
-out:
-	return rc;
 }
 
-static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
+static void r8156b_wait_loading_flash(struct r8152 *tp)
 {
-	u16 fw_reg, bp_ba_addr, bp_en_addr, bp_start, fw_offset;
-	bool rc = false;
-	u32 length, type;
-	int i, max_bp;
+	if ((ocp_read_word(tp, MCU_TYPE_PLA, PLA_GPHY_CTRL) & GPHY_FLASH) &&
+	    !(ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL) & BYPASS_FLASH)) {
+		int i;
 
-	type = __le32_to_cpu(mac->blk_hdr.type);
-	if (type == RTL_FW_PLA) {
-		switch (tp->version) {
-		case RTL_VER_01:
-		case RTL_VER_02:
-		case RTL_VER_07:
-			fw_reg = 0xf800;
-			bp_ba_addr = PLA_BP_BA;
-			bp_en_addr = 0;
-			bp_start = PLA_BP_0;
-			max_bp = 8;
-			break;
-		case RTL_VER_03:
-		case RTL_VER_04:
-		case RTL_VER_05:
-		case RTL_VER_06:
-		case RTL_VER_08:
-		case RTL_VER_09:
-		case RTL_VER_11:
-		case RTL_VER_12:
-		case RTL_VER_13:
-		case RTL_VER_15:
-			fw_reg = 0xf800;
-			bp_ba_addr = PLA_BP_BA;
-			bp_en_addr = PLA_BP_EN;
-			bp_start = PLA_BP_0;
-			max_bp = 8;
-			break;
-		case RTL_VER_14:
-			fw_reg = 0xf800;
-			bp_ba_addr = PLA_BP_BA;
-			bp_en_addr = USB_BP2_EN;
-			bp_start = PLA_BP_0;
-			max_bp = 16;
-			break;
-		default:
-			goto out;
-		}
-	} else if (type == RTL_FW_USB) {
-		switch (tp->version) {
-		case RTL_VER_03:
-		case RTL_VER_04:
-		case RTL_VER_05:
-		case RTL_VER_06:
-			fw_reg = 0xf800;
-			bp_ba_addr = USB_BP_BA;
-			bp_en_addr = USB_BP_EN;
-			bp_start = USB_BP_0;
-			max_bp = 8;
-			break;
-		case RTL_VER_08:
-		case RTL_VER_09:
-		case RTL_VER_11:
-		case RTL_VER_12:
-		case RTL_VER_13:
-		case RTL_VER_14:
-		case RTL_VER_15:
-			fw_reg = 0xe600;
-			bp_ba_addr = USB_BP_BA;
-			bp_en_addr = USB_BP2_EN;
-			bp_start = USB_BP_0;
-			max_bp = 16;
-			break;
-		case RTL_VER_01:
-		case RTL_VER_02:
-		case RTL_VER_07:
-		default:
-			goto out;
+		for (i = 0; i < 100; i++) {
+			if (ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL) & GPHY_PATCH_DONE)
+				break;
+			usleep_range(1000, 2000);
 		}
-	} else {
-		goto out;
 	}
+}
 
-	fw_offset = __le16_to_cpu(mac->fw_offset);
-	if (fw_offset < sizeof(*mac)) {
-		dev_err(&tp->intf->dev, "fw_offset too small\n");
-		goto out;
-	}
+static void r8152b_exit_oob(struct r8152 *tp)
+{
+	u32 ocp_data;
 
-	length = __le32_to_cpu(mac->blk_hdr.length);
-	if (length < fw_offset) {
-		dev_err(&tp->intf->dev, "invalid fw_offset\n");
-		goto out;
-	}
+	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data &= ~RCR_ACPT_ALL;
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
 
-	length -= fw_offset;
-	if (length < 4 || (length & 3)) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
+	rxdy_gated_en(tp, true);
+	r8153_teredo_off(tp);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CR, 0x00);
 
-	if (__le16_to_cpu(mac->fw_reg) != fw_reg) {
-		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
-		goto out;
-	}
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data &= ~NOW_IS_OOB;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
-	if (__le16_to_cpu(mac->bp_ba_addr) != bp_ba_addr) {
-		dev_err(&tp->intf->dev, "invalid base address register\n");
-		goto out;
-	}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data &= ~MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	if (__le16_to_cpu(mac->bp_en_addr) != bp_en_addr) {
-		dev_err(&tp->intf->dev, "invalid enabled mask register\n");
-		goto out;
-	}
+	wait_oob_link_list_ready(tp);
 
-	if (__le16_to_cpu(mac->bp_start) != bp_start) {
-		dev_err(&tp->intf->dev,
-			"invalid start register of break point\n");
-		goto out;
-	}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= RE_INIT_LL;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	if (__le16_to_cpu(mac->bp_num) > max_bp) {
-		dev_err(&tp->intf->dev, "invalid break point number\n");
-		goto out;
-	}
+	wait_oob_link_list_ready(tp);
 
-	for (i = __le16_to_cpu(mac->bp_num); i < max_bp; i++) {
-		if (mac->bp[i]) {
-			dev_err(&tp->intf->dev, "unused bp%u is not zero\n", i);
-			goto out;
-		}
-	}
+	rtl8152_nic_reset(tp);
 
-	rc = true;
-out:
-	return rc;
-}
+	/* rx share fifo credit full threshold */
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_NORMAL);
 
-/* Verify the checksum for the firmware file. It is calculated from the version
- * field to the end of the file. Compare the result with the checksum field to
- * make sure the file is correct.
- */
-static long rtl8152_fw_verify_checksum(struct r8152 *tp,
-				       struct fw_header *fw_hdr, size_t size)
-{
-	unsigned char checksum[sizeof(fw_hdr->checksum)];
-	struct crypto_shash *alg;
-	struct shash_desc *sdesc;
-	size_t len;
-	long rc;
-
-	alg = crypto_alloc_shash("sha256", 0, 0);
-	if (IS_ERR(alg)) {
-		rc = PTR_ERR(alg);
-		goto out;
+	if (tp->udev->speed == USB_SPEED_FULL ||
+	    tp->udev->speed == USB_SPEED_LOW) {
+		/* rx share fifo credit near full threshold */
+		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1,
+				RXFIFO_THR2_FULL);
+		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2,
+				RXFIFO_THR3_FULL);
+	} else {
+		/* rx share fifo credit near full threshold */
+		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1,
+				RXFIFO_THR2_HIGH);
+		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2,
+				RXFIFO_THR3_HIGH);
 	}
 
-	if (crypto_shash_digestsize(alg) != sizeof(fw_hdr->checksum)) {
-		rc = -EFAULT;
-		dev_err(&tp->intf->dev, "digestsize incorrect (%u)\n",
-			crypto_shash_digestsize(alg));
-		goto free_shash;
-	}
+	/* TX share fifo free credit full threshold */
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL2);
 
-	len = sizeof(*sdesc) + crypto_shash_descsize(alg);
-	sdesc = kmalloc(len, GFP_KERNEL);
-	if (!sdesc) {
-		rc = -ENOMEM;
-		goto free_shash;
-	}
-	sdesc->tfm = alg;
+	ocp_write_byte(tp, MCU_TYPE_USB, USB_TX_AGG, TX_AGG_MAX_THRESHOLD);
+	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_HIGH);
+	ocp_write_dword(tp, MCU_TYPE_USB, USB_TX_DMA,
+			TEST_MODE_DISABLE | TX_SIZE_ADJUST1);
 
-	len = size - sizeof(fw_hdr->checksum);
-	rc = crypto_shash_digest(sdesc, fw_hdr->version, len, checksum);
-	kfree(sdesc);
-	if (rc)
-		goto free_shash;
+	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
-	if (memcmp(fw_hdr->checksum, checksum, sizeof(fw_hdr->checksum))) {
-		dev_err(&tp->intf->dev, "checksum fail\n");
-		rc = -EFAULT;
-	}
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
 
-free_shash:
-	crypto_free_shash(alg);
-out:
-	return rc;
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0);
+	ocp_data |= TCR0_AUTO_FIFO;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TCR0, ocp_data);
 }
 
-static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
+static void r8152b_enter_oob(struct r8152 *tp)
 {
-	const struct firmware *fw = rtl_fw->fw;
-	struct fw_header *fw_hdr = (struct fw_header *)fw->data;
-	unsigned long fw_flags = 0;
-	long ret = -EFAULT;
-	int i;
-
-	if (fw->size < sizeof(*fw_hdr)) {
-		dev_err(&tp->intf->dev, "file too small\n");
-		goto fail;
-	}
-
-	ret = rtl8152_fw_verify_checksum(tp, fw_hdr, fw->size);
-	if (ret)
-		goto fail;
-
-	ret = -EFAULT;
-
-	for (i = sizeof(*fw_hdr); i < fw->size;) {
-		struct fw_block *block = (struct fw_block *)&fw->data[i];
-		u32 type;
-
-		if ((i + sizeof(*block)) > fw->size)
-			goto fail;
-
-		type = __le32_to_cpu(block->type);
-		switch (type) {
-		case RTL_FW_END:
-			if (__le32_to_cpu(block->length) != sizeof(*block))
-				goto fail;
-			goto fw_end;
-		case RTL_FW_PLA:
-			if (test_bit(FW_FLAGS_PLA, &fw_flags)) {
-				dev_err(&tp->intf->dev,
-					"multiple PLA firmware encountered");
-				goto fail;
-			}
+	u32 ocp_data;
 
-			if (!rtl8152_is_fw_mac_ok(tp, (struct fw_mac *)block)) {
-				dev_err(&tp->intf->dev,
-					"check PLA firmware failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_PLA, &fw_flags);
-			break;
-		case RTL_FW_USB:
-			if (test_bit(FW_FLAGS_USB, &fw_flags)) {
-				dev_err(&tp->intf->dev,
-					"multiple USB firmware encountered");
-				goto fail;
-			}
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data &= ~NOW_IS_OOB;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
-			if (!rtl8152_is_fw_mac_ok(tp, (struct fw_mac *)block)) {
-				dev_err(&tp->intf->dev,
-					"check USB firmware failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_USB, &fw_flags);
-			break;
-		case RTL_FW_PHY_START:
-			if (test_bit(FW_FLAGS_START, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC1, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC, &fw_flags) ||
-			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
-				dev_err(&tp->intf->dev,
-					"check PHY_START fail\n");
-				goto fail;
-			}
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_OOB);
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_OOB);
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_OOB);
 
-			if (__le32_to_cpu(block->length) != sizeof(struct fw_phy_patch_key)) {
-				dev_err(&tp->intf->dev,
-					"Invalid length for PHY_START\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_START, &fw_flags);
-			break;
-		case RTL_FW_PHY_STOP:
-			if (test_bit(FW_FLAGS_STOP, &fw_flags) ||
-			    !test_bit(FW_FLAGS_START, &fw_flags)) {
-				dev_err(&tp->intf->dev,
-					"Check PHY_STOP fail\n");
-				goto fail;
-			}
+	rtl_disable(tp);
 
-			if (__le32_to_cpu(block->length) != sizeof(*block)) {
-				dev_err(&tp->intf->dev,
-					"Invalid length for PHY_STOP\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_STOP, &fw_flags);
-			break;
-		case RTL_FW_PHY_NC:
-			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
-			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
-				dev_err(&tp->intf->dev,
-					"check PHY_NC fail\n");
-				goto fail;
-			}
+	wait_oob_link_list_ready(tp);
 
-			if (test_bit(FW_FLAGS_NC, &fw_flags)) {
-				dev_err(&tp->intf->dev,
-					"multiple PHY NC encountered\n");
-				goto fail;
-			}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= RE_INIT_LL;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-			if (!rtl8152_is_fw_phy_nc_ok(tp, (struct fw_phy_nc *)block)) {
-				dev_err(&tp->intf->dev,
-					"check PHY NC firmware failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_NC, &fw_flags);
-			break;
-		case RTL_FW_PHY_UNION_NC:
-			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC1, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC, &fw_flags) ||
-			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
-				dev_err(&tp->intf->dev, "PHY_UNION_NC out of order\n");
-				goto fail;
-			}
+	wait_oob_link_list_ready(tp);
 
-			if (test_bit(FW_FLAGS_NC, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY_UNION_NC encountered\n");
-				goto fail;
-			}
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
 
-			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
-				dev_err(&tp->intf->dev, "check PHY_UNION_NC failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_NC, &fw_flags);
-			break;
-		case RTL_FW_PHY_UNION_NC1:
-			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC, &fw_flags) ||
-			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
-				dev_err(&tp->intf->dev, "PHY_UNION_NC1 out of order\n");
-				goto fail;
-			}
+	rtl_rx_vlan_en(tp, true);
 
-			if (test_bit(FW_FLAGS_NC1, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY NC1 encountered\n");
-				goto fail;
-			}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BDC_CR);
+	ocp_data |= ALDPS_PROXY_MODE;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BDC_CR, ocp_data);
 
-			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
-				dev_err(&tp->intf->dev, "check PHY_UNION_NC1 failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_NC1, &fw_flags);
-			break;
-		case RTL_FW_PHY_UNION_NC2:
-			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC, &fw_flags) ||
-			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
-				dev_err(&tp->intf->dev, "PHY_UNION_NC2 out of order\n");
-				goto fail;
-			}
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
-			if (test_bit(FW_FLAGS_NC2, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY NC2 encountered\n");
-				goto fail;
-			}
+	rxdy_gated_en(tp, false);
 
-			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
-				dev_err(&tp->intf->dev, "check PHY_UNION_NC2 failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_NC2, &fw_flags);
-			break;
-		case RTL_FW_PHY_UNION_UC2:
-			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC, &fw_flags) ||
-			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
-				dev_err(&tp->intf->dev, "PHY_UNION_UC2 out of order\n");
-				goto fail;
-			}
+	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+}
 
-			if (test_bit(FW_FLAGS_UC2, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY UC2 encountered\n");
-				goto fail;
-			}
+static int r8156_lock_main(struct r8152 *tp, bool lock)
+{
+	u16 data;
+	int i;
 
-			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
-				dev_err(&tp->intf->dev, "check PHY_UNION_UC2 failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_UC2, &fw_flags);
-			break;
-		case RTL_FW_PHY_UNION_UC:
-			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
-			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
-				dev_err(&tp->intf->dev, "PHY_UNION_UC out of order\n");
-				goto fail;
-			}
+	data = ocp_reg_read(tp, 0xa46a);
+	if (lock)
+		data |= BIT(1);
+	else
+		data &= ~BIT(1);
+	ocp_reg_write(tp, 0xa46a, data);
 
-			if (test_bit(FW_FLAGS_UC, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY UC encountered\n");
-				goto fail;
-			}
+	if (lock) {
+		for (i = 0; i < 100; i++) {
+			usleep_range(1000, 2000);
+			data = ocp_reg_read(tp, 0xa730) & 0xff;
+			if (data == 1)
+				break;
+		}
+	} else {
+		for (i = 0; i < 100; i++) {
+			usleep_range(1000, 2000);
+			data = ocp_reg_read(tp, 0xa730) & 0xff;
+			if (data != 1)
+				break;
+		}
+	}
 
-			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
-				dev_err(&tp->intf->dev, "check PHY_UNION_UC failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_UC, &fw_flags);
-			break;
-		case RTL_FW_PHY_UNION_MISC:
-			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
-				dev_err(&tp->intf->dev, "check RTL_FW_PHY_UNION_MISC failed\n");
-				goto fail;
-			}
-			break;
-		case RTL_FW_PHY_FIXUP:
-			if (!rtl8152_is_fw_phy_fixup_ok(tp, (struct fw_phy_fixup *)block)) {
-				dev_err(&tp->intf->dev, "check PHY fixup failed\n");
-				goto fail;
-			}
-			break;
-		case RTL_FW_PHY_SPEED_UP:
-			if (test_bit(FW_FLAGS_SPEED_UP, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY firmware encountered");
-				goto fail;
-			}
+	if (i == 100)
+		return -ETIME;
+	else
+		return 0;
+}
 
-			if (!rtl8152_is_fw_phy_speed_up_ok(tp, (struct fw_phy_speed_up *)block)) {
-				dev_err(&tp->intf->dev, "check PHY speed up failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_SPEED_UP, &fw_flags);
-			break;
-		case RTL_FW_PHY_VER:
-			if (test_bit(FW_FLAGS_START, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC1, &fw_flags) ||
-			    test_bit(FW_FLAGS_NC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
-			    test_bit(FW_FLAGS_UC, &fw_flags) ||
-			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
-				dev_err(&tp->intf->dev, "Invalid order to set PHY version\n");
-				goto fail;
-			}
+static void r8153_wdt1_end(struct r8152 *tp)
+{
+	int i;
 
-			if (test_bit(FW_FLAGS_VER, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY version encountered");
-				goto fail;
-			}
+	/* Wait till the WTD timer is ready. It would take at most 104 ms. */
+	for (i = 0; i < 104; i++) {
+		u32 ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_WDT1_CTRL);
 
-			if (!rtl8152_is_fw_phy_ver_ok(tp, (struct fw_phy_ver *)block)) {
-				dev_err(&tp->intf->dev, "check PHY version failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_VER, &fw_flags);
-			break;
-		default:
-			dev_warn(&tp->intf->dev, "Unknown type %u is found\n",
-				 type);
+		if (!(ocp_data & WTD1_EN))
 			break;
-		}
-
-		/* next block */
-		i += ALIGN(__le32_to_cpu(block->length), 8);
+		usleep_range(1000, 2000);
 	}
+}
 
-fw_end:
-	if (test_bit(FW_FLAGS_START, &fw_flags) && !test_bit(FW_FLAGS_STOP, &fw_flags)) {
-		dev_err(&tp->intf->dev, "without PHY_STOP\n");
-		goto fail;
-	}
+#define DBG_COUNTER_MASK		0x1f
+#define DBG_DRV_RUNNING			(1 << 5)
+#define DBG_IS_LINUX			8
+#define DGB_DRV_STATE_MASK		(3 << 14)
+#define DGB_DRV_STATE_LOAD		(2 << 14)
+#define DGB_DRV_STATE_UNLOAD		(1 << 14)
+static void rtl_set_dbg_info_init(struct r8152 *tp)
+{
+	u32 counter;
 
-	return 0;
-fail:
-	return ret;
+	counter = ocp_read_byte(tp, MCU_TYPE_USB, 0xcfcf);
+	counter = (counter & DBG_COUNTER_MASK) + 1;
+	ocp_write_byte(tp, MCU_TYPE_USB, 0xcfcf, counter | DBG_DRV_RUNNING);
+	counter = (counter << 5) | DBG_IS_LINUX;
+	ocp_write_word(tp, MCU_TYPE_USB, 0xcfd0, counter);
 }
 
-static void rtl_ram_code_speed_up(struct r8152 *tp, struct fw_phy_speed_up *phy, bool wait)
+static void rtl_set_dbg_info_state(struct r8152 *tp, u16 state)
 {
-	u32 len;
-	u8 *data;
-
-	rtl_reset_ocp_base(tp);
+	u32 ocp_data;
 
-	if (sram_read(tp, SRAM_GPHY_FW_VER) >= __le16_to_cpu(phy->version)) {
-		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
-		return;
-	}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, 0xcfd0);
+	ocp_data &= ~DGB_DRV_STATE_MASK;
+	ocp_write_word(tp, MCU_TYPE_USB, 0xcfd0, state | ocp_data);
+}
 
-	len = __le32_to_cpu(phy->blk_hdr.length);
-	len -= __le16_to_cpu(phy->fw_offset);
-	data = (u8 *)phy + __le16_to_cpu(phy->fw_offset);
+static void r8153_firmware(struct r8152 *tp)
+{
+	if (tp->version == RTL_VER_03) {
+		rtl_reset_ocp_base(tp);
+
+		rtl_pre_ram_code(tp, 0x8146, 0x7000, true);
+		sram_write(tp, 0xb820, 0x0290);
+		sram_write(tp, 0xa012, 0x0000);
+		sram_write(tp, 0xa014, 0x2c04);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c18);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c45);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c45);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd502);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8301);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8306);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd500);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8208);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd501);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xe018);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x0308);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x60f2);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8404);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x607d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc117);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c16);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc116);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c16);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x607d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc117);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa404);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd500);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x0800);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd501);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x62d2);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x615d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc115);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa404);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc307);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd502);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8301);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8306);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd500);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8208);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c42);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc114);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8404);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc317);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd701);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x435d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd500);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa208);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd502);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa306);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa301);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c42);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8404);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x613d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc115);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc307);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd502);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8301);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8306);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd500);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8208);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c42);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc114);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xc317);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd701);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x40dd);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd500);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa208);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd502);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa306);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa301);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd500);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd702);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x0800);
+		sram_write(tp, 0xa01a, 0x0000);
+		sram_write(tp, 0xa006, 0x0fff);
+		sram_write(tp, 0xa004, 0x0fff);
+		sram_write(tp, 0xa002, 0x05a3);
+		sram_write(tp, 0xa000, 0x3591);
+		sram_write(tp, 0xb820, 0x0210);
+		rtl_post_ram_code(tp, 0x8146, true);
+	} else if (tp->version == RTL_VER_04) {
+		static u8 usb_patch_b[] = {
+			0x08, 0xe0, 0x0f, 0xe0,
+			0x18, 0xe0, 0x24, 0xe0,
+			0x26, 0xe0, 0x3a, 0xe0,
+			0x84, 0xe0, 0x9c, 0xe0,
+			0xc2, 0x49, 0x04, 0xf0,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x14, 0x18, 0x02, 0xc0,
+			0x00, 0xb8, 0x2e, 0x18,
+			0x06, 0x89, 0x08, 0xc0,
+			0x0c, 0x61, 0x92, 0x48,
+			0x93, 0x48, 0x0c, 0x89,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x08, 0x05, 0x40, 0xb4,
+			0x16, 0x89, 0x6d, 0xc0,
+			0x00, 0x61, 0x95, 0x49,
+			0x06, 0xf0, 0xfa, 0xc0,
+			0x0c, 0x61, 0x92, 0x48,
+			0x93, 0x48, 0x0c, 0x89,
+			0x02, 0xc0, 0x00, 0xb8,
+			0xe2, 0x04, 0x02, 0xc2,
+			0x00, 0xba, 0xec, 0x11,
+			0x60, 0x60, 0x85, 0x49,
+			0x0d, 0xf1, 0x11, 0xc6,
+			0xd2, 0x61, 0x91, 0x49,
+			0xfd, 0xf0, 0x74, 0x60,
+			0x04, 0x48, 0x74, 0x88,
+			0x08, 0xc6, 0x08, 0xc0,
+			0xc4, 0x98, 0x01, 0x18,
+			0xc0, 0x88, 0x02, 0xc0,
+			0x00, 0xb8, 0x6e, 0x12,
+			0x04, 0xe4, 0x0d, 0x00,
+			0x00, 0xd4, 0xd1, 0x49,
+			0x3c, 0xf1, 0xd2, 0x49,
+			0x16, 0xf1, 0xd3, 0x49,
+			0x18, 0xf1, 0xd4, 0x49,
+			0x19, 0xf1, 0xd5, 0x49,
+			0x1a, 0xf1, 0xd6, 0x49,
+			0x1b, 0xf1, 0xd7, 0x49,
+			0x1c, 0xf1, 0xd8, 0x49,
+			0x1d, 0xf1, 0xd9, 0x49,
+			0x20, 0xf1, 0xda, 0x49,
+			0x23, 0xf1, 0xdb, 0x49,
+			0x24, 0xf1, 0x02, 0xc4,
+			0x00, 0xbc, 0x20, 0x04,
+			0xe5, 0x8e, 0x02, 0xc4,
+			0x00, 0xbc, 0x14, 0x02,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x16, 0x02, 0x02, 0xc4,
+			0x00, 0xbc, 0x18, 0x02,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x1a, 0x02, 0x02, 0xc4,
+			0x00, 0xbc, 0x1c, 0x02,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x94, 0x02, 0x10, 0xc7,
+			0xe0, 0x8e, 0x02, 0xc4,
+			0x00, 0xbc, 0x8a, 0x02,
+			0x0b, 0xc7, 0xe4, 0x8e,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x88, 0x02, 0x02, 0xc4,
+			0x00, 0xbc, 0x6e, 0x02,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x5a, 0x02, 0x30, 0xe4,
+			0x0c, 0xc3, 0x60, 0x64,
+			0xc5, 0x49, 0x04, 0xf1,
+			0x74, 0x64, 0xc4, 0x48,
+			0x74, 0x8c, 0x06, 0xc3,
+			0x64, 0x8e, 0x02, 0xc4,
+			0x00, 0xbc, 0x20, 0x04,
+			0x00, 0xd8, 0x00, 0xe4,
+			0xb2, 0xc0, 0x00, 0x61,
+			0x90, 0x49, 0x09, 0xf1,
+			0x8b, 0xc6, 0xca, 0x61,
+			0x94, 0x49, 0x0e, 0xf1,
+			0xf6, 0xc6, 0xda, 0x60,
+			0x81, 0x49, 0x0a, 0xf0,
+			0x65, 0x60, 0x03, 0x48,
+			0x65, 0x88, 0xef, 0xc6,
+			0xdc, 0x60, 0x80, 0x48,
+			0xdc, 0x88, 0x05, 0xc6,
+			0x00, 0xbe, 0x02, 0xc6,
+			0x00, 0xbe, 0x36, 0x13,
+			0x4c, 0x17, 0x99, 0xc4,
+			0x80, 0x65, 0xd0, 0x49,
+			0x04, 0xf1, 0xfa, 0x75,
+			0x04, 0xc4, 0x00, 0xbc,
+			0x03, 0xc4, 0x00, 0xbc,
+			0x9a, 0x00, 0xee, 0x01 };
+		static u8 pla_patch_b[] = {
+			0x08, 0xe0, 0xea, 0xe0,
+			0xf2, 0xe0, 0x04, 0xe1,
+			0x09, 0xe1, 0x0e, 0xe1,
+			0x46, 0xe1, 0xf7, 0xe1,
+			0x14, 0xc2, 0x40, 0x73,
+			0xba, 0x48, 0x40, 0x9b,
+			0x11, 0xc2, 0x40, 0x73,
+			0xb0, 0x49, 0x17, 0xf0,
+			0xbf, 0x49, 0x03, 0xf1,
+			0x09, 0xc5, 0x00, 0xbd,
+			0xb1, 0x49, 0x11, 0xf0,
+			0xb1, 0x48, 0x40, 0x9b,
+			0x02, 0xc2, 0x00, 0xba,
+			0x1a, 0x17, 0x00, 0xe0,
+			0x1e, 0xfc, 0xbc, 0xc0,
+			0xf0, 0xc0, 0xde, 0xe8,
+			0x00, 0x80, 0x00, 0x20,
+			0x2c, 0x75, 0xd4, 0x49,
+			0x12, 0xf1, 0x32, 0xe0,
+			0xf8, 0xc2, 0x46, 0x71,
+			0xf7, 0xc2, 0x40, 0x73,
+			0xbe, 0x49, 0x03, 0xf1,
+			0xf5, 0xc7, 0x02, 0xe0,
+			0xf2, 0xc7, 0x4f, 0x30,
+			0x26, 0x62, 0xa1, 0x49,
+			0xf0, 0xf1, 0x22, 0x72,
+			0xa0, 0x49, 0xed, 0xf1,
+			0x25, 0x25, 0x18, 0x1f,
+			0x97, 0x30, 0x91, 0x30,
+			0x36, 0x9a, 0x2c, 0x75,
+			0x3c, 0xc3, 0x60, 0x73,
+			0xb1, 0x49, 0x0d, 0xf1,
+			0xdc, 0x21, 0xbc, 0x25,
+			0x30, 0xc6, 0xc0, 0x77,
+			0x04, 0x13, 0x21, 0xf0,
+			0x03, 0x13, 0x22, 0xf0,
+			0x02, 0x13, 0x23, 0xf0,
+			0x01, 0x13, 0x24, 0xf0,
+			0x08, 0x13, 0x08, 0xf1,
+			0x2e, 0x73, 0xba, 0x21,
+			0xbd, 0x25, 0x05, 0x13,
+			0x03, 0xf1, 0x24, 0xc5,
+			0x00, 0xbd, 0xd4, 0x49,
+			0x03, 0xf1, 0x1c, 0xc5,
+			0x00, 0xbd, 0xc4, 0xc6,
+			0xc6, 0x67, 0x2e, 0x75,
+			0xd7, 0x22, 0xdd, 0x26,
+			0x05, 0x15, 0x1b, 0xf0,
+			0x14, 0xc6, 0x00, 0xbe,
+			0x13, 0xc5, 0x00, 0xbd,
+			0x12, 0xc5, 0x00, 0xbd,
+			0xf1, 0x49, 0xfb, 0xf1,
+			0xef, 0xe7, 0xf4, 0x49,
+			0xfa, 0xf1, 0xec, 0xe7,
+			0xf3, 0x49, 0xf7, 0xf1,
+			0xe9, 0xe7, 0xf2, 0x49,
+			0xf4, 0xf1, 0xe6, 0xe7,
+			0xb6, 0xc0, 0x9e, 0x12,
+			0xde, 0x11, 0x0a, 0x12,
+			0x3c, 0x13, 0x00, 0xa0,
+			0xa0, 0xd1, 0x00, 0x00,
+			0xc0, 0x75, 0xd0, 0x49,
+			0x46, 0xf0, 0x26, 0x72,
+			0xa7, 0x49, 0x43, 0xf0,
+			0x22, 0x72, 0x25, 0x25,
+			0x20, 0x1f, 0x97, 0x30,
+			0x91, 0x30, 0x40, 0x73,
+			0xf3, 0xc4, 0x1c, 0x40,
+			0x04, 0xf0, 0xd7, 0x49,
+			0x05, 0xf1, 0x37, 0xe0,
+			0x53, 0x48, 0xc0, 0x9d,
+			0x08, 0x02, 0x40, 0x66,
+			0x64, 0x27, 0x06, 0x16,
+			0x30, 0xf1, 0x46, 0x63,
+			0x3b, 0x13, 0x2d, 0xf1,
+			0x34, 0x9b, 0x18, 0x1b,
+			0x93, 0x30, 0x2b, 0xc3,
+			0x10, 0x1c, 0x2b, 0xe8,
+			0x01, 0x14, 0x25, 0xf1,
+			0x00, 0x1d, 0x26, 0x1a,
+			0x8a, 0x30, 0x22, 0x73,
+			0xb5, 0x25, 0x0e, 0x0b,
+			0x00, 0x1c, 0x2c, 0xe8,
+			0x1f, 0xc7, 0x27, 0x40,
+			0x1a, 0xf1, 0x38, 0xe8,
+			0x32, 0x1f, 0x8f, 0x30,
+			0x08, 0x1b, 0x24, 0xe8,
+			0x36, 0x72, 0x46, 0x77,
+			0x00, 0x17, 0x0d, 0xf0,
+			0x13, 0xc3, 0x1f, 0x40,
+			0x03, 0xf1, 0x00, 0x1f,
+			0x46, 0x9f, 0x44, 0x77,
+			0x9f, 0x44, 0x5f, 0x44,
+			0x17, 0xe8, 0x0a, 0xc7,
+			0x27, 0x40, 0x05, 0xf1,
+			0x02, 0xc3, 0x00, 0xbb,
+			0xfa, 0x18, 0xb0, 0x18,
+			0xff, 0xc7, 0x00, 0xbf,
+			0xb8, 0xcd, 0xff, 0xff,
+			0x02, 0x0c, 0x54, 0xa5,
+			0xdc, 0xa5, 0x2f, 0x40,
+			0x05, 0xf1, 0x00, 0x14,
+			0xfa, 0xf1, 0x01, 0x1c,
+			0x02, 0xe0, 0x00, 0x1c,
+			0x80, 0xff, 0xb0, 0x49,
+			0x04, 0xf0, 0x01, 0x0b,
+			0xd3, 0xa1, 0x03, 0xe0,
+			0x02, 0x0b, 0xd3, 0xa5,
+			0x27, 0x31, 0x20, 0x37,
+			0x02, 0x0b, 0xd3, 0xa5,
+			0x27, 0x31, 0x20, 0x37,
+			0x00, 0x13, 0xfb, 0xf1,
+			0x80, 0xff, 0x22, 0x73,
+			0xb5, 0x25, 0x18, 0x1e,
+			0xde, 0x30, 0xd9, 0x30,
+			0x64, 0x72, 0x11, 0x1e,
+			0x68, 0x23, 0x16, 0x31,
+			0x80, 0xff, 0x08, 0xc2,
+			0x40, 0x73, 0x3a, 0x48,
+			0x40, 0x9b, 0x06, 0xff,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x08, 0x16, 0x1e, 0xfc,
+			0x2c, 0x75, 0xdc, 0x21,
+			0xbc, 0x25, 0x04, 0x13,
+			0x0b, 0xf0, 0x03, 0x13,
+			0x09, 0xf0, 0x02, 0x13,
+			0x07, 0xf0, 0x01, 0x13,
+			0x05, 0xf0, 0x08, 0x13,
+			0x03, 0xf0, 0x04, 0xc3,
+			0x00, 0xbb, 0x03, 0xc3,
+			0x00, 0xbb, 0x8c, 0x15,
+			0x76, 0x15, 0xa0, 0x64,
+			0x40, 0x48, 0xa0, 0x8c,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x82, 0x00, 0xa0, 0x62,
+			0x21, 0x48, 0xa0, 0x8a,
+			0x02, 0xc2, 0x00, 0xba,
+			0x40, 0x03, 0x33, 0xc5,
+			0xa0, 0x74, 0xc0, 0x49,
+			0x1f, 0xf0, 0x30, 0xc5,
+			0xa0, 0x73, 0x00, 0x13,
+			0x04, 0xf1, 0xa2, 0x73,
+			0x00, 0x13, 0x14, 0xf0,
+			0x28, 0xc5, 0xa0, 0x74,
+			0xc8, 0x49, 0x1b, 0xf1,
+			0x26, 0xc5, 0xa0, 0x76,
+			0xa2, 0x74, 0x01, 0x06,
+			0x20, 0x37, 0xa0, 0x9e,
+			0xa2, 0x9c, 0x1e, 0xc5,
+			0xa2, 0x73, 0x23, 0x40,
+			0x10, 0xf8, 0x04, 0xf3,
+			0xa0, 0x73, 0x33, 0x40,
+			0x0c, 0xf8, 0x15, 0xc5,
+			0xa0, 0x74, 0x41, 0x48,
+			0xa0, 0x9c, 0x14, 0xc5,
+			0xa0, 0x76, 0x62, 0x48,
+			0xe0, 0x48, 0xa0, 0x9e,
+			0x10, 0xc6, 0x00, 0xbe,
+			0x0a, 0xc5, 0xa0, 0x74,
+			0x48, 0x48, 0xa0, 0x9c,
+			0x0b, 0xc5, 0x20, 0x1e,
+			0xa0, 0x9e, 0xe5, 0x48,
+			0xa0, 0x9e, 0xf0, 0xe7,
+			0xbc, 0xc0, 0xc8, 0xd2,
+			0xcc, 0xd2, 0x28, 0xe4,
+			0xe6, 0x01, 0xf0, 0xc0,
+			0x18, 0x89, 0x00, 0x1d,
+			0x3c, 0xc3, 0x64, 0x71,
+			0x3c, 0xc0, 0x02, 0x99,
+			0x00, 0x61, 0x67, 0x11,
+			0x3c, 0xf1, 0x69, 0x33,
+			0x35, 0xc0, 0x28, 0x40,
+			0xf6, 0xf1, 0x34, 0xc0,
+			0x00, 0x19, 0x81, 0x1b,
+			0x91, 0xe8, 0x31, 0xc0,
+			0x04, 0x1a, 0x84, 0x1b,
+			0x8d, 0xe8, 0x82, 0xe8,
+			0xa3, 0x49, 0xfe, 0xf0,
+			0x2b, 0xc0, 0x7e, 0xe8,
+			0xa1, 0x48, 0x28, 0xc0,
+			0x84, 0x1b, 0x84, 0xe8,
+			0x00, 0x1d, 0x69, 0x33,
+			0x00, 0x1e, 0x01, 0x06,
+			0xff, 0x18, 0x30, 0x40,
+			0xfd, 0xf1, 0x19, 0xc0,
+			0x00, 0x76, 0x2e, 0x40,
+			0xf7, 0xf1, 0x21, 0x48,
+			0x19, 0xc0, 0x84, 0x1b,
+			0x75, 0xe8, 0x10, 0xc0,
+			0x69, 0xe8, 0xa1, 0x49,
+			0xfd, 0xf0, 0x11, 0xc0,
+			0x00, 0x1a, 0x84, 0x1b,
+			0x6d, 0xe8, 0x62, 0xe8,
+			0xa5, 0x49, 0xfe, 0xf0,
+			0x09, 0xc0, 0x01, 0x19,
+			0x81, 0x1b, 0x66, 0xe8,
+			0x54, 0xe0, 0x10, 0xd4,
+			0x88, 0xd3, 0xb8, 0x0b,
+			0x50, 0xe8, 0x20, 0xb4,
+			0x10, 0xd8, 0x84, 0xd4,
+			0xfd, 0xc0, 0x52, 0xe8,
+			0x48, 0x33, 0xf9, 0xc0,
+			0x00, 0x61, 0x9c, 0x20,
+			0x9c, 0x24, 0xd0, 0x49,
+			0x04, 0xf0, 0x04, 0x11,
+			0x02, 0xf1, 0x03, 0xe0,
+			0x00, 0x11, 0x06, 0xf1,
+			0x5c, 0xc0, 0x00, 0x61,
+			0x92, 0x48, 0x00, 0x89,
+			0x3a, 0xe0, 0x06, 0x11,
+			0x06, 0xf1, 0x55, 0xc0,
+			0x00, 0x61, 0x11, 0x48,
+			0x00, 0x89, 0x33, 0xe0,
+			0x05, 0x11, 0x08, 0xf1,
+			0x4e, 0xc0, 0x00, 0x61,
+			0x91, 0x49, 0x04, 0xf0,
+			0x91, 0x48, 0x00, 0x89,
+			0x11, 0xe0, 0xd9, 0xc0,
+			0x00, 0x61, 0x98, 0x20,
+			0x98, 0x24, 0x25, 0x11,
+			0x24, 0xf1, 0x44, 0xc0,
+			0x29, 0xe8, 0x95, 0x49,
+			0x20, 0xf0, 0xcf, 0xc0,
+			0x00, 0x61, 0x98, 0x20,
+			0x98, 0x24, 0x25, 0x11,
+			0x1a, 0xf1, 0x37, 0xc0,
+			0x00, 0x61, 0x92, 0x49,
+			0x16, 0xf1, 0x12, 0x48,
+			0x00, 0x89, 0x2f, 0xc0,
+			0x00, 0x19, 0x00, 0x89,
+			0x2d, 0xc0, 0x01, 0x89,
+			0x2d, 0xc0, 0x04, 0x19,
+			0x81, 0x1b, 0x1c, 0xe8,
+			0x2a, 0xc0, 0x14, 0x19,
+			0x81, 0x1b, 0x18, 0xe8,
+			0x21, 0xc0, 0x0c, 0xe8,
+			0x1f, 0xc0, 0x12, 0x48,
+			0x81, 0x1b, 0x12, 0xe8,
+			0xae, 0xc3, 0x66, 0x71,
+			0xae, 0xc0, 0x02, 0x99,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x96, 0x07, 0x13, 0xc4,
+			0x84, 0x98, 0x00, 0x1b,
+			0x86, 0x8b, 0x86, 0x73,
+			0xbf, 0x49, 0xfe, 0xf1,
+			0x80, 0x71, 0x82, 0x72,
+			0x80, 0xff, 0x09, 0xc4,
+			0x84, 0x98, 0x80, 0x99,
+			0x82, 0x9a, 0x86, 0x8b,
+			0x86, 0x73, 0xbf, 0x49,
+			0xfe, 0xf1, 0x80, 0xff,
+			0x08, 0xea, 0x30, 0xd4,
+			0x10, 0xc0, 0x12, 0xe8,
+			0x8a, 0xd3, 0x28, 0xe4,
+			0x2c, 0xe4, 0x00, 0xd8,
+			0x00, 0x00, 0x00, 0x00 };
+
+		rtl_pre_ram_code(tp, 0x8146, 0x7001, true);
+		sram_write(tp, 0xb820, 0x0290);
+		sram_write(tp, 0xa012, 0x0000);
+		sram_write(tp, 0xa014, 0x2c04);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c07);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c0a);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c0d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa240);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa104);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x292d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8620);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa480);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2a2c);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8480);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa101);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2a36);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd056);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2223);
+		sram_write(tp, 0xa01a, 0x0000);
+		sram_write(tp, 0xa006, 0x0222);
+		sram_write(tp, 0xa004, 0x0a35);
+		sram_write(tp, 0xa002, 0x0a2b);
+		sram_write(tp, 0xa000, 0xf92c);
+		sram_write(tp, 0xb820, 0x0210);
+		rtl_post_ram_code(tp, 0x8146, true);
+
+		r8153_wdt1_end(tp);
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(usb_patch_b),
+				  usb_patch_b, MCU_TYPE_USB);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc26, 0xa000);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc28, 0x180c);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2a, 0x0506);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2c, 0x04E0);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2e, 0x11E4);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc30, 0x125C);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc32, 0x0232);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc34, 0x131E);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc36, 0x0098);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_EN, 0x00FF);
+
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+		/* Enable backup/restore of MACDBG. This is required after
+		 * clearing PLA break points and before applying the PLA
+		 * firmware.
+		 */
+		if (!(ocp_read_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST) &
+		      DEBUG_OE)) {
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_PRE,
+				       DEBUG_LTSSM);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST,
+				       DEBUG_LTSSM);
+		}
 
-	if (rtl_phy_patch_request(tp, true, wait))
-		return;
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(pla_patch_b),
+				  pla_patch_b, MCU_TYPE_PLA);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc26, 0x8000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc28, 0x1154);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2a, 0x1606);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2c, 0x155a);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2e, 0x0080);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc30, 0x033c);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc32, 0x01a0);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc34, 0x0794);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc36, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, 0x007f);
+
+		/* reset UPHY timer to 36 ms */
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_UPHY_TIMER, 36000 / 16);
+
+		rtl_reset_ocp_base(tp);
+	} else if (tp->version == RTL_VER_05) {
+		u32 ocp_data;
+		static u8 usb_patch_c[] = {
+			0x08, 0xe0, 0x0a, 0xe0,
+			0x14, 0xe0, 0x58, 0xe0,
+			0x64, 0xe0, 0x79, 0xe0,
+			0xab, 0xe0, 0xb6, 0xe0,
+			0x02, 0xc5, 0x00, 0xbd,
+			0x38, 0x3b, 0xdb, 0x49,
+			0x04, 0xf1, 0x06, 0xc3,
+			0x00, 0xbb, 0x5a, 0x02,
+			0x05, 0xc4, 0x03, 0xc3,
+			0x00, 0xbb, 0xa4, 0x04,
+			0x7e, 0x02, 0x30, 0xd4,
+			0x65, 0xc6, 0x66, 0x61,
+			0x92, 0x49, 0x12, 0xf1,
+			0x3e, 0xc0, 0x02, 0x61,
+			0x97, 0x49, 0x05, 0xf0,
+			0x3c, 0xc0, 0x00, 0x61,
+			0x90, 0x49, 0x0a, 0xf1,
+			0xca, 0x63, 0xb0, 0x49,
+			0x09, 0xf1, 0xb1, 0x49,
+			0x05, 0xf0, 0x32, 0xc0,
+			0x00, 0x71, 0x9e, 0x49,
+			0x03, 0xf1, 0xb0, 0x48,
+			0x05, 0xe0, 0x30, 0x48,
+			0xda, 0x61, 0x10, 0x48,
+			0xda, 0x89, 0x4a, 0xc6,
+			0xc0, 0x60, 0x85, 0x49,
+			0x03, 0xf0, 0x31, 0x48,
+			0x04, 0xe0, 0xb1, 0x48,
+			0xb2, 0x48, 0x0f, 0xe0,
+			0x30, 0x18, 0x1b, 0xc1,
+			0x0f, 0xe8, 0x1a, 0xc6,
+			0xc7, 0x65, 0xd0, 0x49,
+			0x05, 0xf0, 0x32, 0x48,
+			0x02, 0xc2, 0x00, 0xba,
+			0x3e, 0x16, 0x02, 0xc2,
+			0x00, 0xba, 0x48, 0x16,
+			0x02, 0xc2, 0x00, 0xba,
+			0x4a, 0x16, 0x02, 0xb4,
+			0x09, 0xc2, 0x40, 0x99,
+			0x0e, 0x48, 0x42, 0x98,
+			0x42, 0x70, 0x8e, 0x49,
+			0xfe, 0xf1, 0x02, 0xb0,
+			0x80, 0xff, 0xc0, 0xd4,
+			0xe4, 0x40, 0x20, 0xd4,
+			0xca, 0xcf, 0x00, 0xcf,
+			0x3c, 0xe4, 0x0c, 0xc0,
+			0x00, 0x63, 0xb5, 0x49,
+			0x09, 0xc0, 0x30, 0x18,
+			0x06, 0xc1, 0xea, 0xef,
+			0xf5, 0xc7, 0x02, 0xc0,
+			0x00, 0xb8, 0xd0, 0x10,
+			0xe4, 0x4b, 0x00, 0xd8,
+			0x14, 0xc3, 0x60, 0x61,
+			0x90, 0x49, 0x06, 0xf0,
+			0x11, 0xc3, 0x70, 0x61,
+			0x12, 0x48, 0x70, 0x89,
+			0x08, 0xe0, 0x0a, 0xc6,
+			0xd4, 0x61, 0x93, 0x48,
+			0xd4, 0x89, 0x02, 0xc1,
+			0x00, 0xb9, 0x72, 0x17,
+			0x02, 0xc1, 0x00, 0xb9,
+			0x9c, 0x15, 0x00, 0xd8,
+			0xef, 0xcf, 0x20, 0xd4,
+			0x30, 0x18, 0xe7, 0xc1,
+			0xcb, 0xef, 0x2b, 0xc5,
+			0xa0, 0x77, 0x00, 0x1c,
+			0xa0, 0x9c, 0x28, 0xc5,
+			0xa0, 0x64, 0xc0, 0x48,
+			0xc1, 0x48, 0xc2, 0x48,
+			0xa0, 0x8c, 0xb1, 0x64,
+			0xc0, 0x48, 0xb1, 0x8c,
+			0x20, 0xc5, 0xa0, 0x64,
+			0x40, 0x48, 0x41, 0x48,
+			0xc2, 0x48, 0xa0, 0x8c,
+			0x19, 0xc5, 0xa4, 0x64,
+			0x44, 0x48, 0xa4, 0x8c,
+			0xb1, 0x64, 0x40, 0x48,
+			0xb1, 0x8c, 0x14, 0xc4,
+			0x80, 0x73, 0x13, 0xc4,
+			0x82, 0x9b, 0x11, 0x1b,
+			0x80, 0x9b, 0x0c, 0xc5,
+			0xa0, 0x64, 0x40, 0x48,
+			0x41, 0x48, 0x42, 0x48,
+			0xa0, 0x8c, 0x05, 0xc5,
+			0xa0, 0x9f, 0x02, 0xc5,
+			0x00, 0xbd, 0x6c, 0x3a,
+			0x1e, 0xfc, 0x10, 0xd8,
+			0x86, 0xd4, 0xf8, 0xcb,
+			0x20, 0xe4, 0x0a, 0xc0,
+			0x16, 0x61, 0x91, 0x48,
+			0x16, 0x89, 0x07, 0xc0,
+			0x11, 0x19, 0x0c, 0x89,
+			0x02, 0xc1, 0x00, 0xb9,
+			0x02, 0x06, 0x00, 0xd4,
+			0x40, 0xb4, 0xfe, 0xc0,
+			0x16, 0x61, 0x91, 0x48,
+			0x16, 0x89, 0xfb, 0xc0,
+			0x11, 0x19, 0x0c, 0x89,
+			0x02, 0xc1, 0x00, 0xb9,
+			0xd2, 0x05, 0x00, 0x00 };
+		static u8 pla_patch_c[] = {
+			0x5d, 0xe0, 0x07, 0xe0,
+			0x0f, 0xe0, 0x5a, 0xe0,
+			0x59, 0xe0, 0x1f, 0xe0,
+			0x57, 0xe0, 0x3e, 0xe1,
+			0x08, 0xc2, 0x40, 0x73,
+			0x3a, 0x48, 0x40, 0x9b,
+			0x06, 0xff, 0x02, 0xc6,
+			0x00, 0xbe, 0xcc, 0x17,
+			0x1e, 0xfc, 0x2c, 0x75,
+			0xdc, 0x21, 0xbc, 0x25,
+			0x04, 0x13, 0x0b, 0xf0,
+			0x03, 0x13, 0x09, 0xf0,
+			0x02, 0x13, 0x07, 0xf0,
+			0x01, 0x13, 0x05, 0xf0,
+			0x08, 0x13, 0x03, 0xf0,
+			0x04, 0xc3, 0x00, 0xbb,
+			0x03, 0xc3, 0x00, 0xbb,
+			0x50, 0x17, 0x3a, 0x17,
+			0x33, 0xc5, 0xa0, 0x74,
+			0xc0, 0x49, 0x1f, 0xf0,
+			0x30, 0xc5, 0xa0, 0x73,
+			0x00, 0x13, 0x04, 0xf1,
+			0xa2, 0x73, 0x00, 0x13,
+			0x14, 0xf0, 0x28, 0xc5,
+			0xa0, 0x74, 0xc8, 0x49,
+			0x1b, 0xf1, 0x26, 0xc5,
+			0xa0, 0x76, 0xa2, 0x74,
+			0x01, 0x06, 0x20, 0x37,
+			0xa0, 0x9e, 0xa2, 0x9c,
+			0x1e, 0xc5, 0xa2, 0x73,
+			0x23, 0x40, 0x10, 0xf8,
+			0x04, 0xf3, 0xa0, 0x73,
+			0x33, 0x40, 0x0c, 0xf8,
+			0x15, 0xc5, 0xa0, 0x74,
+			0x41, 0x48, 0xa0, 0x9c,
+			0x14, 0xc5, 0xa0, 0x76,
+			0x62, 0x48, 0xe0, 0x48,
+			0xa0, 0x9e, 0x10, 0xc6,
+			0x00, 0xbe, 0x0a, 0xc5,
+			0xa0, 0x74, 0x48, 0x48,
+			0xa0, 0x9c, 0x0b, 0xc5,
+			0x20, 0x1e, 0xa0, 0x9e,
+			0xe5, 0x48, 0xa0, 0x9e,
+			0xf0, 0xe7, 0xbc, 0xc0,
+			0xc8, 0xd2, 0xcc, 0xd2,
+			0x28, 0xe4, 0xfa, 0x01,
+			0xf0, 0xc0, 0x18, 0x89,
+			0x74, 0xc0, 0xcd, 0xe8,
+			0x80, 0x76, 0x00, 0x1d,
+			0x6e, 0xc3, 0x66, 0x62,
+			0xa0, 0x49, 0x06, 0xf0,
+			0x64, 0xc0, 0x02, 0x71,
+			0x60, 0x99, 0x62, 0xc1,
+			0x03, 0xe0, 0x5f, 0xc0,
+			0x60, 0xc1, 0x02, 0x99,
+			0x00, 0x61, 0x0f, 0x1b,
+			0x59, 0x41, 0x03, 0x13,
+			0x18, 0xf1, 0xe4, 0x49,
+			0x20, 0xf1, 0xe5, 0x49,
+			0x1e, 0xf0, 0x59, 0xc6,
+			0xd0, 0x73, 0xb7, 0x49,
+			0x08, 0xf0, 0x01, 0x0b,
+			0x80, 0x13, 0x03, 0xf0,
+			0xd0, 0x8b, 0x03, 0xe0,
+			0x3f, 0x48, 0xd0, 0x9b,
+			0x51, 0xc0, 0x10, 0x1a,
+			0x84, 0x1b, 0xb1, 0xe8,
+			0x4b, 0xc2, 0x40, 0x63,
+			0x30, 0x48, 0x0a, 0xe0,
+			0xe5, 0x49, 0x09, 0xf0,
+			0x47, 0xc0, 0x00, 0x1a,
+			0x84, 0x1b, 0xa7, 0xe8,
+			0x41, 0xc2, 0x40, 0x63,
+			0xb0, 0x48, 0x40, 0x8b,
+			0x67, 0x11, 0x3f, 0xf1,
+			0x69, 0x33, 0x32, 0xc0,
+			0x28, 0x40, 0xd2, 0xf1,
+			0x33, 0xc0, 0x00, 0x19,
+			0x81, 0x1b, 0x99, 0xe8,
+			0x30, 0xc0, 0x04, 0x1a,
+			0x84, 0x1b, 0x95, 0xe8,
+			0x8a, 0xe8, 0xa3, 0x49,
+			0xfe, 0xf0, 0x2a, 0xc0,
+			0x86, 0xe8, 0xa1, 0x48,
+			0x84, 0x1b, 0x8d, 0xe8,
+			0x00, 0x1d, 0x69, 0x33,
+			0x00, 0x1e, 0x01, 0x06,
+			0xff, 0x18, 0x30, 0x40,
+			0xfd, 0xf1, 0x1f, 0xc0,
+			0x00, 0x76, 0x2e, 0x40,
+			0xf7, 0xf1, 0x21, 0x48,
+			0x19, 0xc0, 0x84, 0x1b,
+			0x7e, 0xe8, 0x74, 0x08,
+			0x72, 0xe8, 0xa1, 0x49,
+			0xfd, 0xf0, 0x11, 0xc0,
+			0x00, 0x1a, 0x84, 0x1b,
+			0x76, 0xe8, 0x6b, 0xe8,
+			0xa5, 0x49, 0xfe, 0xf0,
+			0x09, 0xc0, 0x01, 0x19,
+			0x81, 0x1b, 0x6f, 0xe8,
+			0x5a, 0xe0, 0xb8, 0x0b,
+			0x50, 0xe8, 0x83, 0x00,
+			0x82, 0x00, 0x20, 0xb4,
+			0x10, 0xd8, 0x84, 0xd4,
+			0x88, 0xd3, 0x10, 0xe0,
+			0x00, 0xd8, 0x24, 0xd4,
+			0xf9, 0xc0, 0x57, 0xe8,
+			0x48, 0x33, 0xf3, 0xc0,
+			0x00, 0x61, 0x6a, 0xc0,
+			0x47, 0x11, 0x03, 0xf0,
+			0x57, 0x11, 0x05, 0xf1,
+			0x00, 0x61, 0x17, 0x48,
+			0x00, 0x89, 0x41, 0xe0,
+			0x9c, 0x20, 0x9c, 0x24,
+			0xd0, 0x49, 0x09, 0xf0,
+			0x04, 0x11, 0x07, 0xf1,
+			0x00, 0x61, 0x97, 0x49,
+			0x38, 0xf0, 0x97, 0x48,
+			0x00, 0x89, 0x2b, 0xe0,
+			0x00, 0x11, 0x05, 0xf1,
+			0x00, 0x61, 0x92, 0x48,
+			0x00, 0x89, 0x2f, 0xe0,
+			0x06, 0x11, 0x05, 0xf1,
+			0x00, 0x61, 0x11, 0x48,
+			0x00, 0x89, 0x29, 0xe0,
+			0x05, 0x11, 0x0f, 0xf1,
+			0x00, 0x61, 0x93, 0x49,
+			0x1a, 0xf1, 0x91, 0x49,
+			0x0a, 0xf0, 0x91, 0x48,
+			0x00, 0x89, 0x0f, 0xe0,
+			0xc6, 0xc0, 0x00, 0x61,
+			0x98, 0x20, 0x98, 0x24,
+			0x25, 0x11, 0x80, 0xff,
+			0xfa, 0xef, 0x17, 0xf1,
+			0x38, 0xc0, 0x1f, 0xe8,
+			0x95, 0x49, 0x13, 0xf0,
+			0xf4, 0xef, 0x11, 0xf1,
+			0x31, 0xc0, 0x00, 0x61,
+			0x92, 0x49, 0x0d, 0xf1,
+			0x12, 0x48, 0x00, 0x89,
+			0x29, 0xc0, 0x00, 0x19,
+			0x00, 0x89, 0x27, 0xc0,
+			0x01, 0x89, 0x23, 0xc0,
+			0x0e, 0xe8, 0x12, 0x48,
+			0x81, 0x1b, 0x15, 0xe8,
+			0xae, 0xc3, 0x66, 0x62,
+			0xa0, 0x49, 0x04, 0xf0,
+			0x64, 0x71, 0xa3, 0xc0,
+			0x02, 0x99, 0x02, 0xc0,
+			0x00, 0xb8, 0xd6, 0x07,
+			0x13, 0xc4, 0x84, 0x98,
+			0x00, 0x1b, 0x86, 0x8b,
+			0x86, 0x73, 0xbf, 0x49,
+			0xfe, 0xf1, 0x80, 0x71,
+			0x82, 0x72, 0x80, 0xff,
+			0x09, 0xc4, 0x84, 0x98,
+			0x80, 0x99, 0x82, 0x9a,
+			0x86, 0x8b, 0x86, 0x73,
+			0xbf, 0x49, 0xfe, 0xf1,
+			0x80, 0xff, 0x08, 0xea,
+			0x30, 0xd4, 0x10, 0xc0,
+			0x12, 0xe8, 0x8a, 0xd3,
+			0x00, 0xd8, 0x02, 0xc6,
+			0x00, 0xbe, 0xe0, 0x08 };
+
+		rtl_pre_ram_code(tp, 0x8146, 0x7001, true);
+		sram_write(tp, 0xb820, 0x0290);
+		sram_write(tp, 0xa012, 0x0000);
+		sram_write(tp, 0xa014, 0x2c04);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c07);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c0a);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c0d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa240);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa104);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x292d);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8620);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa480);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2a2c);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x8480);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa101);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2a36);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xd056);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2223);
+		sram_write(tp, 0xa01a, 0x0000);
+		sram_write(tp, 0xa006, 0x0222);
+		sram_write(tp, 0xa004, 0x0a35);
+		sram_write(tp, 0xa002, 0x0a2b);
+		sram_write(tp, 0xa000, 0xf92c);
+		sram_write(tp, 0xb820, 0x0210);
+		rtl_post_ram_code(tp, 0x8146, true);
+
+		r8153_wdt1_end(tp);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
+		ocp_data &= ~FW_FIX_SUSPEND;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(usb_patch_c),
+				  usb_patch_c, MCU_TYPE_USB);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc26, 0xa000);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc28, 0x3b34);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2a, 0x027c);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2c, 0x15de);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2e, 0x10ce);
+		if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER)
+			ocp_write_word(tp, MCU_TYPE_USB, 0xfc30, 0x1578);
+		else
+			ocp_write_word(tp, MCU_TYPE_USB, 0xfc30, 0x1adc);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc32, 0x3a28);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc34, 0x05f8);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc36, 0x05c8);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_EN, 0x00ff);
+
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(pla_patch_c),
+				  pla_patch_c, MCU_TYPE_PLA);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc26, 0x8000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc28, 0x1306);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2a, 0x17ca);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2c, 0x171e);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2e, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc30, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc32, 0x01b4);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc34, 0x07d4);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc36, 0x0894);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, 0x00e6);
+
+		/* reset UPHY timer to 36 ms */
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_UPHY_TIMER, 36000 / 16);
+
+		/* enable U3P3 check, set the counter to 4 */
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS,
+			       U3P3_CHECK_EN | 4);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
+		ocp_data |= FW_FIX_SUSPEND;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
 
-	while (len) {
-		u32 ocp_data, size;
-		int i;
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
+		ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
+		ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
 
-		if (len < 2048)
-			size = len;
+		rtl_reset_ocp_base(tp);
+	} else if (tp->version == RTL_VER_06) {
+		u32 ocp_data;
+		static u8 usb_patch_d[] = {
+			0x08, 0xe0, 0x0e, 0xe0,
+			0x11, 0xe0, 0x24, 0xe0,
+			0x2b, 0xe0, 0x33, 0xe0,
+			0x3a, 0xe0, 0x3c, 0xe0,
+			0x1e, 0xc3, 0x70, 0x61,
+			0x12, 0x48, 0x70, 0x89,
+			0x02, 0xc3, 0x00, 0xbb,
+			0x02, 0x17, 0x32, 0x19,
+			0x02, 0xc3, 0x00, 0xbb,
+			0x44, 0x14, 0x30, 0x18,
+			0x11, 0xc1, 0x05, 0xe8,
+			0x10, 0xc6, 0x02, 0xc2,
+			0x00, 0xba, 0x94, 0x17,
+			0x02, 0xb4, 0x09, 0xc2,
+			0x40, 0x99, 0x0e, 0x48,
+			0x42, 0x98, 0x42, 0x70,
+			0x8e, 0x49, 0xfe, 0xf1,
+			0x02, 0xb0, 0x80, 0xff,
+			0xc0, 0xd4, 0xe4, 0x40,
+			0x20, 0xd4, 0x30, 0x18,
+			0x06, 0xc1, 0xf1, 0xef,
+			0xfc, 0xc7, 0x02, 0xc0,
+			0x00, 0xb8, 0x38, 0x12,
+			0xe4, 0x4b, 0x0c, 0x61,
+			0x92, 0x48, 0x93, 0x48,
+			0x95, 0x48, 0x96, 0x48,
+			0x0c, 0x89, 0x02, 0xc0,
+			0x00, 0xb8, 0x0e, 0x06,
+			0x30, 0x18, 0xf5, 0xc1,
+			0xe0, 0xef, 0x04, 0xc5,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x76, 0x3c, 0x1e, 0xfc,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x00, 0x00, 0x02, 0xc6,
+			0x00, 0xbe, 0x00, 0x00 };
+		static u8 pla_patch_d[] = {
+			0x03, 0xe0, 0x16, 0xe0,
+			0x30, 0xe0, 0x12, 0xc2,
+			0x40, 0x73, 0xb0, 0x49,
+			0x08, 0xf0, 0xb8, 0x49,
+			0x06, 0xf0, 0xb8, 0x48,
+			0x40, 0x9b, 0x0b, 0xc2,
+			0x40, 0x76, 0x05, 0xe0,
+			0x02, 0x61, 0x02, 0xc3,
+			0x00, 0xbb, 0x54, 0x08,
+			0x02, 0xc3, 0x00, 0xbb,
+			0x64, 0x08, 0x98, 0xd3,
+			0x1e, 0xfc, 0xfe, 0xc0,
+			0x02, 0x62, 0xa0, 0x48,
+			0x02, 0x8a, 0x00, 0x72,
+			0xa0, 0x49, 0x11, 0xf0,
+			0x13, 0xc1, 0x20, 0x62,
+			0x2e, 0x21, 0x2f, 0x25,
+			0x00, 0x71, 0x9f, 0x24,
+			0x0a, 0x40, 0x09, 0xf0,
+			0x00, 0x71, 0x18, 0x48,
+			0xa0, 0x49, 0x03, 0xf1,
+			0x9f, 0x48, 0x02, 0xe0,
+			0x1f, 0x48, 0x00, 0x99,
+			0x02, 0xc2, 0x00, 0xba,
+			0xac, 0x0c, 0x08, 0xe9,
+			0x36, 0xc0, 0x00, 0x61,
+			0x9c, 0x20, 0x9c, 0x24,
+			0x33, 0xc0, 0x07, 0x11,
+			0x05, 0xf1, 0x00, 0x61,
+			0x17, 0x48, 0x00, 0x89,
+			0x0d, 0xe0, 0x04, 0x11,
+			0x0b, 0xf1, 0x00, 0x61,
+			0x97, 0x49, 0x08, 0xf0,
+			0x97, 0x48, 0x00, 0x89,
+			0x23, 0xc0, 0x0e, 0xe8,
+			0x12, 0x48, 0x81, 0x1b,
+			0x15, 0xe8, 0x1f, 0xc0,
+			0x00, 0x61, 0x67, 0x11,
+			0x04, 0xf0, 0x02, 0xc0,
+			0x00, 0xb8, 0x42, 0x09,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x90, 0x08, 0x13, 0xc4,
+			0x84, 0x98, 0x00, 0x1b,
+			0x86, 0x8b, 0x86, 0x73,
+			0xbf, 0x49, 0xfe, 0xf1,
+			0x80, 0x71, 0x82, 0x72,
+			0x80, 0xff, 0x09, 0xc4,
+			0x84, 0x98, 0x80, 0x99,
+			0x82, 0x9a, 0x86, 0x8b,
+			0x86, 0x73, 0xbf, 0x49,
+			0xfe, 0xf1, 0x80, 0xff,
+			0x08, 0xea, 0x30, 0xd4,
+			0x50, 0xe8, 0x8a, 0xd3 };
+
+		rtl_pre_ram_code(tp, 0x8146, 0x7003, true);
+		sram_write(tp, 0xb820, 0x0290);
+		sram_write(tp, 0xa012, 0x0000);
+		sram_write(tp, 0xa014, 0x2c04);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c07);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c07);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2c07);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa240);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0xa104);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xb438, 0x2944);
+		sram_write(tp, 0xa01a, 0x0000);
+		sram_write(tp, 0xa006, 0x0fff);
+		sram_write(tp, 0xa004, 0x0fff);
+		sram_write(tp, 0xa002, 0x0fff);
+		sram_write(tp, 0xa000, 0x1943);
+		sram_write(tp, 0xb820, 0x0210);
+		rtl_post_ram_code(tp, 0x8146, true);
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(usb_patch_d),
+				  usb_patch_d, MCU_TYPE_USB);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc26, 0xa000);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc28, 0x16de);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2a, 0x1442);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2c, 0x1792);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc2e, 0x1236);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc30, 0x0606);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc32, 0x3C74);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc34, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xfc36, 0x0000);
+		if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER)
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_EN, 0x003f);
 		else
-			size = 2048;
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_EN, 0x003e);
+
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(pla_patch_d),
+				  pla_patch_d, MCU_TYPE_PLA);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc26, 0x8000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc28, 0x0852);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2a, 0x0c92);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2c, 0x088c);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc2e, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc30, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc32, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc34, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, 0xfc36, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, 0x0007);
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL);
-		ocp_data |= GPHY_PATCH_DONE | BACKUP_RESTRORE;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL, ocp_data);
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
+		ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
+		ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
 
-		generic_ocp_write(tp, __le16_to_cpu(phy->fw_reg), 0xff, size, data, MCU_TYPE_USB);
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+		ocp_data |= FW_IP_RESET_EN;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
 
-		data += size;
-		len -= size;
+		rtl_reset_ocp_base(tp);
+	}
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL);
-		ocp_data |= POL_GPHY_PATCH;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL, ocp_data);
+	rtl_reset_ocp_base(tp);
+}
 
-		for (i = 0; i < 1000; i++) {
-			if (!(ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL) & POL_GPHY_PATCH))
-				break;
+static void r8153b_firmware(struct r8152 *tp)
+{
+	if (tp->version == RTL_VER_09) {
+		u32 ocp_data;
+		static u8 usb_patch2_b[] = {
+			0x10, 0xe0, 0x26, 0xe0,
+			0x3a, 0xe0, 0x58, 0xe0,
+			0x6c, 0xe0, 0x85, 0xe0,
+			0xa5, 0xe0, 0xbe, 0xe0,
+			0xd8, 0xe0, 0xdb, 0xe0,
+			0xf3, 0xe0, 0x05, 0xe1,
+			0x0d, 0xe1, 0x6b, 0xe1,
+			0x71, 0xe1, 0x92, 0xe1,
+			0x16, 0xc0, 0x00, 0x75,
+			0xd1, 0x49, 0x0d, 0xf0,
+			0x0f, 0xc0, 0x0f, 0xc5,
+			0x00, 0x1e, 0x08, 0x9e,
+			0x0c, 0x9d, 0x0c, 0xc6,
+			0x0a, 0x9e, 0x8f, 0x1c,
+			0x0e, 0x8c, 0x0e, 0x74,
+			0xcf, 0x49, 0xfe, 0xf1,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x96, 0x31, 0x00, 0xdc,
+			0x24, 0xe4, 0x80, 0x02,
+			0x34, 0xd3, 0xff, 0xc3,
+			0x60, 0x72, 0xa1, 0x49,
+			0x0d, 0xf0, 0xf8, 0xc3,
+			0xf8, 0xc2, 0x00, 0x1c,
+			0x68, 0x9c, 0xf6, 0xc4,
+			0x6a, 0x9c, 0x6c, 0x9a,
+			0x8f, 0x1c, 0x6e, 0x8c,
+			0x6e, 0x74, 0xcf, 0x49,
+			0xfe, 0xf1, 0x04, 0xc0,
+			0x02, 0xc2, 0x00, 0xba,
+			0xa8, 0x28, 0xf8, 0xc7,
+			0xea, 0xc0, 0x00, 0x75,
+			0xd1, 0x49, 0x15, 0xf0,
+			0x19, 0xc7, 0x17, 0xc2,
+			0xec, 0x9a, 0x00, 0x19,
+			0xee, 0x89, 0xee, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0xea, 0x71, 0x9f, 0x49,
+			0x0a, 0xf0, 0xd9, 0xc2,
+			0xec, 0x9a, 0x00, 0x19,
+			0xe8, 0x99, 0x81, 0x19,
+			0xee, 0x89, 0xee, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x06, 0xc3, 0x02, 0xc2,
+			0x00, 0xba, 0xf0, 0x1d,
+			0x4c, 0xe8, 0x00, 0xdc,
+			0x00, 0xd4, 0xcb, 0xc0,
+			0x00, 0x75, 0xd1, 0x49,
+			0x0d, 0xf0, 0xc4, 0xc0,
+			0xc4, 0xc5, 0x00, 0x1e,
+			0x08, 0x9e, 0xc2, 0xc6,
+			0x0a, 0x9e, 0x0c, 0x9d,
+			0x8f, 0x1c, 0x0e, 0x8c,
+			0x0e, 0x74, 0xcf, 0x49,
+			0xfe, 0xf1, 0x04, 0xc0,
+			0x02, 0xc1, 0x00, 0xb9,
+			0xc4, 0x16, 0x20, 0xd4,
+			0xb6, 0xc0, 0x00, 0x75,
+			0xd1, 0x48, 0x00, 0x9d,
+			0xe5, 0xc7, 0xaf, 0xc2,
+			0xec, 0x9a, 0x00, 0x19,
+			0xe8, 0x9a, 0x81, 0x19,
+			0xee, 0x89, 0xee, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x2c, 0xc1, 0xec, 0x99,
+			0x81, 0x19, 0xee, 0x89,
+			0xee, 0x71, 0x9f, 0x49,
+			0xfe, 0xf1, 0x04, 0xc3,
+			0x02, 0xc2, 0x00, 0xba,
+			0x96, 0x1c, 0xc0, 0xd4,
+			0xc0, 0x88, 0x1e, 0xc6,
+			0xc0, 0x70, 0x8f, 0x49,
+			0x0e, 0xf0, 0x8f, 0x48,
+			0x93, 0xc6, 0xca, 0x98,
+			0x11, 0x18, 0xc8, 0x98,
+			0x16, 0xc0, 0xcc, 0x98,
+			0x8f, 0x18, 0xce, 0x88,
+			0xce, 0x70, 0x8f, 0x49,
+			0xfe, 0xf1, 0x0b, 0xe0,
+			0x43, 0xc6, 0x00, 0x18,
+			0xc8, 0x98, 0x0b, 0xc0,
+			0xcc, 0x98, 0x81, 0x18,
+			0xce, 0x88, 0xce, 0x70,
+			0x8f, 0x49, 0xfe, 0xf1,
+			0x02, 0xc0, 0x00, 0xb8,
+			0xf2, 0x19, 0x40, 0xd3,
+			0x20, 0xe4, 0x33, 0xc2,
+			0x40, 0x71, 0x91, 0x48,
+			0x40, 0x99, 0x30, 0xc2,
+			0x00, 0x19, 0x48, 0x99,
+			0xf8, 0xc1, 0x4c, 0x99,
+			0x81, 0x19, 0x4e, 0x89,
+			0x4e, 0x71, 0x9f, 0x49,
+			0xfe, 0xf1, 0x0b, 0xc1,
+			0x4c, 0x99, 0x81, 0x19,
+			0x4e, 0x89, 0x4e, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x02, 0x71, 0x02, 0xc2,
+			0x00, 0xba, 0x0e, 0x34,
+			0x24, 0xe4, 0x19, 0xc2,
+			0x40, 0x71, 0x91, 0x48,
+			0x40, 0x99, 0x16, 0xc2,
+			0x00, 0x19, 0x48, 0x99,
+			0xde, 0xc1, 0x4c, 0x99,
+			0x81, 0x19, 0x4e, 0x89,
+			0x4e, 0x71, 0x9f, 0x49,
+			0xfe, 0xf1, 0xf1, 0xc1,
+			0x4c, 0x99, 0x81, 0x19,
+			0x4e, 0x89, 0x4e, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x02, 0x71, 0x02, 0xc2,
+			0x00, 0xba, 0x60, 0x33,
+			0x34, 0xd3, 0x00, 0xdc,
+			0x1e, 0x89, 0x02, 0xc0,
+			0x00, 0xb8, 0xfa, 0x12,
+			0x18, 0xc0, 0x00, 0x65,
+			0xd1, 0x49, 0x0d, 0xf0,
+			0x11, 0xc0, 0x11, 0xc5,
+			0x00, 0x1e, 0x08, 0x9e,
+			0x0c, 0x9d, 0x0e, 0xc6,
+			0x0a, 0x9e, 0x8f, 0x1c,
+			0x0e, 0x8c, 0x0e, 0x74,
+			0xcf, 0x49, 0xfe, 0xf1,
+			0x04, 0xc0, 0x02, 0xc2,
+			0x00, 0xba, 0xa0, 0x41,
+			0x06, 0xd4, 0x00, 0xdc,
+			0x24, 0xe4, 0x80, 0x02,
+			0x34, 0xd3, 0x9e, 0x49,
+			0x0a, 0xf0, 0x0f, 0xc2,
+			0x40, 0x71, 0x9f, 0x49,
+			0x02, 0xf1, 0x08, 0xe0,
+			0x0b, 0xc2, 0x40, 0x61,
+			0x91, 0x48, 0x40, 0x89,
+			0x02, 0xc5, 0x00, 0xbd,
+			0x82, 0x24, 0x02, 0xc5,
+			0x00, 0xbd, 0xf8, 0x23,
+			0xfe, 0xcf, 0x1e, 0xd4,
+			0xfe, 0xc7, 0xe0, 0x75,
+			0x5f, 0x48, 0xe0, 0x9d,
+			0x04, 0xc7, 0x02, 0xc5,
+			0x00, 0xbd, 0x82, 0x18,
+			0x14, 0xd8, 0xc0, 0x88,
+			0x5d, 0xc7, 0x56, 0xc6,
+			0xe4, 0x9e, 0x0f, 0x1e,
+			0xe6, 0x8e, 0xe6, 0x76,
+			0xef, 0x49, 0xfe, 0xf1,
+			0xe2, 0x75, 0xe0, 0x74,
+			0xd8, 0x25, 0xd8, 0x22,
+			0xd8, 0x26, 0x48, 0x23,
+			0x68, 0x27, 0x48, 0x26,
+			0x04, 0xb4, 0x05, 0xb4,
+			0x06, 0xb4, 0x45, 0xc6,
+			0xe2, 0x23, 0xfe, 0x39,
+			0x00, 0x1c, 0x00, 0x1d,
+			0x00, 0x13, 0x0c, 0xf0,
+			0xb0, 0x49, 0x04, 0xf1,
+			0x01, 0x05, 0xb1, 0x25,
+			0xfa, 0xe7, 0xb8, 0x33,
+			0x35, 0x43, 0x26, 0x31,
+			0x01, 0x05, 0xb1, 0x25,
+			0xf4, 0xe7, 0x06, 0xb0,
+			0x05, 0xb0, 0xae, 0x41,
+			0x25, 0x31, 0x30, 0xc5,
+			0x6c, 0x41, 0x04, 0xb0,
+			0x05, 0xb4, 0x30, 0xc7,
+			0x29, 0xc6, 0x04, 0x06,
+			0xe4, 0x9e, 0x0f, 0x1e,
+			0xe6, 0x8e, 0xe6, 0x76,
+			0xef, 0x49, 0xfe, 0xf1,
+			0xe0, 0x76, 0xe8, 0x25,
+			0xe8, 0x23, 0xf8, 0x27,
+			0x1e, 0xc5, 0x6f, 0x41,
+			0x33, 0x23, 0xb3, 0x31,
+			0x74, 0x41, 0xf5, 0x31,
+			0x19, 0xc6, 0x7e, 0x41,
+			0x1a, 0xc6, 0xc4, 0x9f,
+			0xf1, 0x21, 0xdf, 0x30,
+			0x05, 0xb0, 0xc2, 0x9d,
+			0x52, 0x22, 0xa3, 0x31,
+			0x0e, 0xc7, 0xb7, 0x31,
+			0x0e, 0xc7, 0x77, 0x41,
+			0x0e, 0xc7, 0xe6, 0x9e,
+			0x0b, 0xc3, 0xde, 0x30,
+			0x60, 0x64, 0xe8, 0x8c,
+			0x02, 0xc4, 0x00, 0xbc,
+			0xe8, 0x19, 0x00, 0xc0,
+			0x41, 0x00, 0xff, 0x00,
+			0x7f, 0x00, 0x00, 0xe6,
+			0x60, 0xd3, 0x08, 0xdc,
+			0x40, 0x60, 0x80, 0x48,
+			0x81, 0x48, 0x82, 0x48,
+			0x02, 0xc1, 0x00, 0xb9,
+			0x72, 0x16, 0x1c, 0xc6,
+			0xc0, 0x61, 0x04, 0x11,
+			0x15, 0xf1, 0x19, 0xc6,
+			0xc0, 0x61, 0x9c, 0x20,
+			0x9c, 0x24, 0x09, 0x11,
+			0x0f, 0xf1, 0x14, 0xc6,
+			0x01, 0x19, 0xc0, 0x89,
+			0x13, 0xc1, 0x13, 0xc6,
+			0x24, 0x9e, 0x00, 0x1e,
+			0x26, 0x8e, 0x26, 0x76,
+			0xef, 0x49, 0xfe, 0xf1,
+			0x22, 0x76, 0x08, 0xc1,
+			0x22, 0x9e, 0x07, 0xc6,
+			0x02, 0xc1, 0x00, 0xb9,
+			0x8c, 0x08, 0x18, 0xb4,
+			0x4a, 0xb4, 0x90, 0xcc,
+			0x80, 0xd4, 0x08, 0xdc,
+			0x10, 0xe8, 0xfc, 0xc6,
+			0xc0, 0x67, 0xf0, 0x49,
+			0x13, 0xf0, 0xf0, 0x48,
+			0xc0, 0x8f, 0xc2, 0x77,
+			0xf7, 0xc1, 0xf7, 0xc6,
+			0x24, 0x9e, 0x22, 0x9f,
+			0x8c, 0x1e, 0x26, 0x8e,
+			0x26, 0x76, 0xef, 0x49,
+			0xfe, 0xf1, 0xfb, 0x49,
+			0x05, 0xf0, 0x07, 0xc6,
+			0xc0, 0x61, 0x10, 0x48,
+			0xc0, 0x89, 0x02, 0xc6,
+			0x00, 0xbe, 0x7e, 0x36,
+			0x6c, 0xb4, 0x00, 0x00 };
+		static u8 pla_patch2_b[] = {
+			0x05, 0xe0, 0x1b, 0xe0,
+			0x2c, 0xe0, 0x60, 0xe0,
+			0x73, 0xe0, 0x15, 0xc6,
+			0xc2, 0x64, 0xd2, 0x49,
+			0x06, 0xf1, 0xc4, 0x48,
+			0xc5, 0x48, 0xc6, 0x48,
+			0xc7, 0x48, 0x05, 0xe0,
+			0x44, 0x48, 0x45, 0x48,
+			0x46, 0x48, 0x47, 0x48,
+			0xc2, 0x8c, 0xc0, 0x64,
+			0x46, 0x48, 0xc0, 0x8c,
+			0x05, 0xc5, 0x02, 0xc4,
+			0x00, 0xbc, 0x18, 0x02,
+			0x06, 0xdc, 0xb0, 0xc0,
+			0x10, 0xc5, 0xa0, 0x77,
+			0xa0, 0x74, 0x46, 0x48,
+			0x47, 0x48, 0xa0, 0x9c,
+			0x0b, 0xc5, 0xa0, 0x74,
+			0x44, 0x48, 0x43, 0x48,
+			0xa0, 0x9c, 0x05, 0xc5,
+			0xa0, 0x9f, 0x02, 0xc5,
+			0x00, 0xbd, 0x3c, 0x03,
+			0x1c, 0xe8, 0x20, 0xe8,
+			0xd4, 0x49, 0x04, 0xf1,
+			0xd5, 0x49, 0x20, 0xf1,
+			0x28, 0xe0, 0x2a, 0xc7,
+			0xe0, 0x75, 0xda, 0x49,
+			0x14, 0xf0, 0x27, 0xc7,
+			0xe0, 0x75, 0xdc, 0x49,
+			0x10, 0xf1, 0x24, 0xc7,
+			0xe0, 0x75, 0x25, 0xc7,
+			0xe0, 0x74, 0x2c, 0x40,
+			0x0a, 0xfa, 0x1f, 0xc7,
+			0xe4, 0x75, 0xd0, 0x49,
+			0x09, 0xf1, 0x1c, 0xc5,
+			0xe6, 0x9d, 0x11, 0x1d,
+			0xe4, 0x8d, 0x04, 0xe0,
+			0x16, 0xc7, 0x00, 0x1d,
+			0xe4, 0x8d, 0xe0, 0x8e,
+			0x11, 0x1d, 0xe0, 0x8d,
+			0x07, 0xe0, 0x0c, 0xc7,
+			0xe0, 0x75, 0xda, 0x48,
+			0xe0, 0x9d, 0x0b, 0xc7,
+			0xe4, 0x8e, 0x02, 0xc4,
+			0x00, 0xbc, 0x28, 0x03,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x14, 0x03, 0x12, 0xe8,
+			0x4e, 0xe8, 0x1c, 0xe6,
+			0x20, 0xe4, 0x80, 0x02,
+			0xa4, 0xc0, 0x12, 0xc2,
+			0x40, 0x73, 0xb0, 0x49,
+			0x08, 0xf0, 0xb8, 0x49,
+			0x06, 0xf0, 0xb8, 0x48,
+			0x40, 0x9b, 0x0b, 0xc2,
+			0x40, 0x76, 0x05, 0xe0,
+			0x02, 0x61, 0x02, 0xc3,
+			0x00, 0xbb, 0x0a, 0x0a,
+			0x02, 0xc3, 0x00, 0xbb,
+			0x1a, 0x0a, 0x98, 0xd3,
+			0x1e, 0xfc, 0xfe, 0xc0,
+			0x02, 0x62, 0xa0, 0x48,
+			0x02, 0x8a, 0x00, 0x72,
+			0xa0, 0x49, 0x11, 0xf0,
+			0x13, 0xc1, 0x20, 0x62,
+			0x2e, 0x21, 0x2f, 0x25,
+			0x00, 0x71, 0x9f, 0x24,
+			0x0a, 0x40, 0x09, 0xf0,
+			0x00, 0x71, 0x18, 0x48,
+			0xa0, 0x49, 0x03, 0xf1,
+			0x9f, 0x48, 0x02, 0xe0,
+			0x1f, 0x48, 0x00, 0x99,
+			0x02, 0xc2, 0x00, 0xba,
+			0xda, 0x0e, 0x08, 0xe9 };
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		/* enable fc timer and set timer to 1 second. */
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FC_TIMER,
+			       CTRL_TIMER_EN | (1000 / 8));
+
+		generic_ocp_write(tp, 0xe600, 0xff, sizeof(usb_patch2_b),
+				  usb_patch2_b, MCU_TYPE_USB);
+
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0xa000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_0, 0x2a20);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_1, 0x28a6);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_2, 0x1dee);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_3, 0x16c2);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, 0x1c94);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_5, 0x19f0);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_6, 0x340c);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_7, 0x335e);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0x12f8);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0x419e);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0x23f4);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0x186e);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0x19e6);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0x1670);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0x088a);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0x35a8);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0xffff);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd7, 0x04);
+
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(pla_patch2_b),
+				  pla_patch2_b, MCU_TYPE_PLA);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_BA, 0x8000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_0, 0x0216);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_1, 0x0332);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_2, 0x030c);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_3, 0x0a08);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_4, 0x0ec0);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_5, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_6, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_7, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, 0x001e);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd6, 0x02);
+
+		if (ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1) & BND_MASK) {
+			ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
+			ocp_data |= BIT(0);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
 		}
 
-		if (i == 1000) {
-			dev_err(&tp->intf->dev, "ram code speedup mode timeout\n");
-			break;
-		}
-	}
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
+		ocp_data |= FLOW_CTRL_PATCH_OPT;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
 
-	rtl_reset_ocp_base(tp);
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
+		ocp_data |= FC_PATCH_TASK;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
 
-	rtl_phy_patch_request(tp, false, wait);
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+		ocp_data |= FW_IP_RESET_EN;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
 
-	if (sram_read(tp, SRAM_GPHY_FW_VER) == __le16_to_cpu(phy->version))
-		dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
-	else
-		dev_err(&tp->intf->dev, "ram code speedup mode fail\n");
+		rtl_reset_ocp_base(tp);
+	} else if (tp->version == RTL_VER_14) {
+		u32 ocp_data;
+		static u8 usb_patch3_a[] = {
+			0x10, 0xe0, 0x79, 0xe0,
+			0x97, 0xe0, 0x99, 0xe0,
+			0xa0, 0xe0, 0xa2, 0xe0,
+			0xa4, 0xe0, 0xa6, 0xe0,
+			0xa8, 0xe0, 0xaa, 0xe0,
+			0xac, 0xe0, 0xae, 0xe0,
+			0xb0, 0xe0, 0xb2, 0xe0,
+			0xb4, 0xe0, 0xb6, 0xe0,
+			0x01, 0xb4, 0x03, 0xb4,
+			0x04, 0xb4, 0x05, 0xb4,
+			0x07, 0xb4, 0x64, 0xc6,
+			0xc0, 0x60, 0x82, 0x48,
+			0xc0, 0x88, 0x5f, 0xc7,
+			0x58, 0xc6, 0xe4, 0x9e,
+			0x0f, 0x1e, 0xe6, 0x8e,
+			0xe6, 0x76, 0xef, 0x49,
+			0xfe, 0xf1, 0xe2, 0x73,
+			0xe0, 0x74, 0xb8, 0x22,
+			0xd8, 0x26, 0xb8, 0x25,
+			0x48, 0x23, 0x68, 0x27,
+			0x48, 0x26, 0x04, 0xb4,
+			0x05, 0xb4, 0x06, 0xb4,
+			0x47, 0xc6, 0xe2, 0x23,
+			0xfe, 0x39, 0x00, 0x1c,
+			0x00, 0x1d, 0x00, 0x13,
+			0x0c, 0xf0, 0xb0, 0x49,
+			0x04, 0xf1, 0x01, 0x05,
+			0xb1, 0x25, 0xfa, 0xe7,
+			0xb8, 0x33, 0x35, 0x43,
+			0x26, 0x31, 0x01, 0x05,
+			0xb1, 0x25, 0xf4, 0xe7,
+			0x06, 0xb0, 0x05, 0xb0,
+			0xae, 0x41, 0x25, 0x31,
+			0x32, 0xc5, 0x6c, 0x41,
+			0x04, 0xb0, 0x05, 0xb4,
+			0x32, 0xc7, 0x2b, 0xc6,
+			0x04, 0x06, 0xe4, 0x9e,
+			0x0f, 0x1e, 0xe6, 0x8e,
+			0xe6, 0x76, 0xef, 0x49,
+			0xfe, 0xf1, 0xe0, 0x76,
+			0xe8, 0x25, 0xe8, 0x23,
+			0xf8, 0x27, 0x20, 0xc5,
+			0x6f, 0x41, 0xb3, 0x20,
+			0x4b, 0x30, 0x4c, 0x41,
+			0x4d, 0x30, 0x1b, 0xc6,
+			0x4e, 0x41, 0x91, 0x21,
+			0xd9, 0x30, 0x05, 0xb0,
+			0x52, 0x22, 0xa3, 0x31,
+			0x13, 0xc7, 0xb7, 0x31,
+			0x13, 0xc7, 0x77, 0x41,
+			0x12, 0xc3, 0xde, 0x30,
+			0x60, 0x65, 0x10, 0xc7,
+			0xe0, 0x8d, 0xe2, 0x9e,
+			0x07, 0xb0, 0x05, 0xb0,
+			0x04, 0xb0, 0x03, 0xb0,
+			0x01, 0xb0, 0x02, 0xc0,
+			0x00, 0xb8, 0xd6, 0x20,
+			0x00, 0xc0, 0x41, 0x00,
+			0xff, 0x00, 0x7f, 0x00,
+			0x00, 0xe6, 0x7a, 0xd3,
+			0x08, 0xdc, 0xe8, 0xd4,
+			0x04, 0xb4, 0x05, 0xb4,
+			0x06, 0xb4, 0x1b, 0xc0,
+			0x00, 0x75, 0xd8, 0x49,
+			0x0d, 0xf0, 0x14, 0xc0,
+			0x14, 0xc5, 0x00, 0x1e,
+			0x08, 0x9e, 0x0c, 0x9d,
+			0x11, 0xc6, 0x0a, 0x9e,
+			0x8f, 0x1c, 0x0e, 0x8c,
+			0x0e, 0x74, 0xcf, 0x49,
+			0xfe, 0xf1, 0x07, 0xc1,
+			0x06, 0xb0, 0x05, 0xb0,
+			0x04, 0xb0, 0x02, 0xc0,
+			0x00, 0xb8, 0xdc, 0x5c,
+			0xe0, 0xcb, 0x00, 0xdc,
+			0x24, 0xe4, 0x80, 0x02,
+			0x34, 0xd3, 0x02, 0xc2,
+			0x00, 0xba, 0x42, 0x08,
+			0x40, 0x60, 0x80, 0x48,
+			0x81, 0x48, 0x82, 0x48,
+			0x40, 0x88, 0x02, 0xc2,
+			0x00, 0xba, 0xf0, 0x1b,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x3a, 0x4e, 0x02, 0xc0,
+			0x00, 0xb8, 0x3a, 0x4e,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x3a, 0x4e, 0x02, 0xc0,
+			0x00, 0xb8, 0x3a, 0x4e,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00 };
+		static u8 pla_patch3_a[] = {
+			0x10, 0xe0, 0x12, 0xe0,
+			0x15, 0xe0, 0x1a, 0xe0,
+			0x25, 0xe0, 0x31, 0xe0,
+			0x33, 0xe0, 0x35, 0xe0,
+			0x37, 0xe0, 0x39, 0xe0,
+			0x3b, 0xe0, 0x3d, 0xe0,
+			0x3f, 0xe0, 0x41, 0xe0,
+			0x43, 0xe0, 0x45, 0xe0,
+			0x02, 0xc6, 0x00, 0xbe,
+			0xec, 0x2c, 0x94, 0x49,
+			0x02, 0xc6, 0x00, 0xbe,
+			0xae, 0x2b, 0x05, 0xc0,
+			0x00, 0x72, 0x02, 0xc6,
+			0x00, 0xbe, 0xd6, 0x2b,
+			0x20, 0xe8, 0x08, 0xc3,
+			0x60, 0x65, 0xd0, 0x49,
+			0x06, 0xf1, 0xe0, 0x75,
+			0x02, 0xc3, 0x00, 0xbb,
+			0x3e, 0x08, 0xb4, 0xd3,
+			0x02, 0xc3, 0x00, 0xbb,
+			0x5e, 0x08, 0x6c, 0x74,
+			0xc4, 0x75, 0xe5, 0x41,
+			0xc2, 0x49, 0x05, 0xf0,
+			0x07, 0xc6, 0x01, 0x1c,
+			0xc0, 0x8c, 0xc1, 0x8c,
+			0x02, 0xc4, 0x00, 0xbc,
+			0x16, 0x02, 0x99, 0xd3,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x3a, 0x4e, 0x02, 0xc0,
+			0x00, 0xb8, 0x3a, 0x4e,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x3a, 0x4e, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x00, 0x00 };
+
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(pla_patch3_a),
+				  pla_patch3_a, MCU_TYPE_PLA);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_BA, 0x8000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_0, 0x2be6);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_1, 0x2bac);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_2, 0x2bd4);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_3, 0x083c);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_4, 0x0214);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_5, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_6, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_7, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_8, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_9, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_10, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_11, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_12, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_13, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_14, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_15, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP2_EN, 0x001f);
+
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd6, 0x02);
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		/* enable fc timer and set timer to 1 second. */
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FC_TIMER,
+			       CTRL_TIMER_EN | (1000 / 8));
+
+		generic_ocp_write(tp, 0xe600, 0xff, sizeof(usb_patch3_a),
+				  usb_patch3_a, MCU_TYPE_USB);
+
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0xa000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_0, 0x02ce);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_1, 0x5cda);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_2, 0x0834);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_3, 0x1bec);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_5, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_6, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_7, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0x000f);
+
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd7, 0x02);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
+		ocp_data |= FLOW_CTRL_PATCH_2;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
+		ocp_data |= FC_PATCH_TASK;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+
+		rtl_reset_ocp_base(tp);
+	}
+
+	rtl_reset_ocp_base(tp);
 }
 
-static int rtl8152_fw_phy_ver(struct r8152 *tp, struct fw_phy_ver *phy_ver)
+static void r8156_firmware(struct r8152 *tp)
 {
-	u16 ver_addr, ver;
+	if (tp->version == RTL_TEST_01) {
+		static u8 usb3_patch_t[] = {
+			0x01, 0xe0, 0x05, 0xc7,
+			0xf6, 0x65, 0x02, 0xc0,
+			0x00, 0xb8, 0x40, 0x03,
+			0x00, 0xd4, 0x00, 0x00 };
+		u16 data;
 
-	ver_addr = __le16_to_cpu(phy_ver->ver.addr);
-	ver = __le16_to_cpu(phy_ver->ver.data);
+		rtl_reset_ocp_base(tp);
 
-	rtl_reset_ocp_base(tp);
+		ocp_reg_write(tp, 0xb87c, 0x8099);
+		ocp_reg_write(tp, 0xb87e, 0x2a50);
+		ocp_reg_write(tp, 0xb87c, 0x80a1);
+		ocp_reg_write(tp, 0xb87e, 0x2a50);
+		ocp_reg_write(tp, 0xb87c, 0x809a);
+		ocp_reg_write(tp, 0xb87e, 0x5010);
+		ocp_reg_write(tp, 0xb87c, 0x80a2);
+		ocp_reg_write(tp, 0xb87e, 0x500f);
+		ocp_reg_write(tp, 0xb87c, 0x8087);
+		ocp_reg_write(tp, 0xb87e, 0xc0cf);
+		ocp_reg_write(tp, 0xb87c, 0x8080);
+		ocp_reg_write(tp, 0xb87e, 0x0f16);
+		ocp_reg_write(tp, 0xb87c, 0x8089);
+		ocp_reg_write(tp, 0xb87e, 0x161b);
+		ocp_reg_write(tp, 0xb87c, 0x808a);
+		ocp_reg_write(tp, 0xb87e, 0x1b1f);
+
+		ocp_reg_write(tp, 0xac36, 0x0080);
+		ocp_reg_write(tp, 0xac4a, 0xff00);
+		data = ocp_reg_read(tp, 0xac34);
+		data &= ~BIT(4);
+		data |= BIT(2) | BIT(3);
+		ocp_reg_write(tp, 0xac34, data);
+
+		data = ocp_reg_read(tp, 0xac54);
+		data &= ~(BIT(9) | BIT(10));
+		ocp_reg_write(tp, 0xac54, data);
+		ocp_reg_write(tp, 0xb87c, 0x8099);
+		ocp_reg_write(tp, 0xb87e, 0x2050);
+		ocp_reg_write(tp, 0xb87c, 0x80a1);
+		ocp_reg_write(tp, 0xb87e, 0x2050);
+		ocp_reg_write(tp, 0xb87c, 0x809a);
+		ocp_reg_write(tp, 0xb87e, 0x5010);
+		ocp_reg_write(tp, 0xb87c, 0x80a2);
+		ocp_reg_write(tp, 0xb87e, 0x500f);
+		data = ocp_reg_read(tp, 0xac34);
+		data &= ~BIT(5);
+		data |= BIT(6) | BIT(7);
+		ocp_reg_write(tp, 0xac34, data);
 
-	if (sram_read(tp, ver_addr) >= ver) {
-		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
-		return 0;
-	}
+		if (rtl_phy_patch_request(tp, true, true)) {
+			netif_err(tp, drv, tp->netdev,
+				  "patch request error\n");
+			return;
+		}
+
+		data = ocp_reg_read(tp, 0xb896);
+		data &= ~BIT(0);
+		ocp_reg_write(tp, 0xb896, data);
+		ocp_reg_write(tp, 0xb892, 0x0000);
+		ocp_reg_write(tp, 0xb88e, 0xc089);
+		ocp_reg_write(tp, 0xb890, 0xc1d0);
+		ocp_reg_write(tp, 0xb88e, 0xc08a);
+		ocp_reg_write(tp, 0xb890, 0xe0f0);
+		ocp_reg_write(tp, 0xb88e, 0xc08b);
+		ocp_reg_write(tp, 0xb890, 0xe0f0);
+		ocp_reg_write(tp, 0xb88e, 0xc08c);
+		ocp_reg_write(tp, 0xb890, 0xffff);
+		ocp_reg_write(tp, 0xb88e, 0xc08d);
+		ocp_reg_write(tp, 0xb890, 0xffff);
+		ocp_reg_write(tp, 0xb88e, 0xc08e);
+		ocp_reg_write(tp, 0xb890, 0xffff);
+		ocp_reg_write(tp, 0xb88e, 0xc08f);
+		ocp_reg_write(tp, 0xb890, 0xffff);
+		ocp_reg_write(tp, 0xb88e, 0xc090);
+		ocp_reg_write(tp, 0xb890, 0xff12);
+
+		ocp_reg_write(tp, 0xb88e, 0xc09a);
+		ocp_reg_write(tp, 0xb890, 0x191a);
+		ocp_reg_write(tp, 0xb88e, 0xc09b);
+		ocp_reg_write(tp, 0xb890, 0x191a);
+		ocp_reg_write(tp, 0xb88e, 0xc09e);
+		ocp_reg_write(tp, 0xb890, 0x1d1e);
+		ocp_reg_write(tp, 0xb88e, 0xc09f);
+		ocp_reg_write(tp, 0xb890, 0x1d1e);
+		ocp_reg_write(tp, 0xb88e, 0xc0a0);
+		ocp_reg_write(tp, 0xb890, 0x1f20);
+		ocp_reg_write(tp, 0xb88e, 0xc0a1);
+		ocp_reg_write(tp, 0xb890, 0x1f20);
+		ocp_reg_write(tp, 0xb88e, 0xc0a2);
+		ocp_reg_write(tp, 0xb890, 0x2122);
+		ocp_reg_write(tp, 0xb88e, 0xc0a3);
+		ocp_reg_write(tp, 0xb890, 0x2122);
+		ocp_reg_write(tp, 0xb88e, 0xc0a4);
+		ocp_reg_write(tp, 0xb890, 0x2324);
+		ocp_reg_write(tp, 0xb88e, 0xc0a5);
+		ocp_reg_write(tp, 0xb890, 0x2324);
+
+		ocp_reg_write(tp, 0xb88e, 0xc029);
+		ocp_reg_write(tp, 0xb890, 0xdff3);
+		ocp_reg_write(tp, 0xb88e, 0xc02a);
+		ocp_reg_write(tp, 0xb890, 0xf3f3);
+		ocp_reg_write(tp, 0xb88e, 0xc02b);
+		ocp_reg_write(tp, 0xb890, 0xf3f3);
+		ocp_reg_write(tp, 0xb88e, 0xc02c);
+		ocp_reg_write(tp, 0xb890, 0xf3ef);
+		ocp_reg_write(tp, 0xb88e, 0xc02d);
+		ocp_reg_write(tp, 0xb890, 0xf3ef);
+		ocp_reg_write(tp, 0xb88e, 0xc02e);
+		ocp_reg_write(tp, 0xb890, 0xebe7);
+		ocp_reg_write(tp, 0xb88e, 0xc02f);
+		ocp_reg_write(tp, 0xb890, 0xebe7);
+		ocp_reg_write(tp, 0xb88e, 0xc030);
+		ocp_reg_write(tp, 0xb890, 0xe4e2);
+		ocp_reg_write(tp, 0xb88e, 0xc031);
+		ocp_reg_write(tp, 0xb890, 0xe4e2);
+		ocp_reg_write(tp, 0xb88e, 0xc032);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc033);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc034);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc035);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc036);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc037);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc038);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc039);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc03a);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc03b);
+		ocp_reg_write(tp, 0xb890, 0xdfdf);
+		ocp_reg_write(tp, 0xb88e, 0xc03c);
+		ocp_reg_write(tp, 0xb890, 0xdf00);
+
+		data = ocp_reg_read(tp, 0xb896);
+		data |= BIT(0);
+		ocp_reg_write(tp, 0xb896, data);
 
-	sram_write(tp, ver_addr, ver);
+		rtl_patch_key_set(tp, 0x8024, 0x0000);
+		sram_write(tp, SRAM_PHY_LOCK, PHY_PATCH_LOCK);
 
-	dev_dbg(&tp->intf->dev, "PHY firmware version %x\n", ver);
+		data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+		data |= BIT(7);
+		ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+		/* nc0_patch_171220_loop_test_USB */
+		sram_write(tp, 0xA016, 0x0000);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8027);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x802e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8035);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x806d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8077);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x808c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8091);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3709);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8017);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3bdd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x801f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x38c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1034);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4061);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x37b8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1034);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1044);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3b0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1032);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12ed);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2109);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1032);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa130);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa140);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd020);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8120);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa8c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd020);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8140);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd093);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa63f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa73f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd09e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd0dc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd03b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1c4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x617d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcdc7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4013);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0f7a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8280);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0f7a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8208);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcc08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x08ba);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x08c6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ee6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x068b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0e9d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd719);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x34a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0da2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f1c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd75e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ffd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0dca);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd707);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5e67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd719);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2f79);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0dc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd75e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2a51);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0db6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffec);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa540);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1308);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x159e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc445);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdb02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0608);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c47);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0542);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x408d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd075);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6045);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd05d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd07a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1b5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0771);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3b4d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x809f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2635);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0241);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2745);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0241);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x27d0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80aa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ec8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc446);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdb04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd064);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd018);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x068b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0753);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x407b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0771);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2745);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0241);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x608a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6306);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80c5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5e28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2730);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80b1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80c5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0771);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8103);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc447);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdb08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x406d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c07);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd056);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1c2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ce1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2734);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80c5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c07);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1b2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd0a8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdb08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc447);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x26d7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8103);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x648a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fbb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ca0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0320);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa208);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc317);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2c51);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8103);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdb10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc448);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa620);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x41dd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa306);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x415f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa210);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa330);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc575);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8210);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8320);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2c59);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8103);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3a33);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd098);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd191);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x609f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8306);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa320);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa210);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd006);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1e3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc30f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4093);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc033);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02fb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa0f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8208);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02fb);
+		sram_write(tp, 0xA026, 0x0279);
+		sram_write(tp, 0xA024, 0x159c);
+		sram_write(tp, 0xA022, 0x0d94);
+		sram_write(tp, 0xA020, 0x0ee1);
+		sram_write(tp, 0xA006, 0x0f46);
+		sram_write(tp, 0xA004, 0x12e2);
+		sram_write(tp, 0xA002, 0x12ea);
+		sram_write(tp, 0xA000, 0x1034);
+		sram_write(tp, 0xA008, 0xff00);
+
+		/* nc2_patch_171109_USB */
+		sram_write(tp, 0xA016, 0x0020);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8018);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8024);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8056);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8062);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8069);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8080);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0390);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd37a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd21a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0508);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd164);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0441);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcf0c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0437);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x010c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb60);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x210c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x001a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f57);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbb80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x605f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9b80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1c3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd074);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfff1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb62);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb910);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9930);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8406);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa780);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd141);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0441);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb82);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa70c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa2b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6041);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0441);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ed);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd164);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0441);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0450);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0236);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb808);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbb80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1c3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd074);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03f3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb17);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0441);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ec0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0426);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0426);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0e80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0426);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaec0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0426);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x34a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x012c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5d8e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0134);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb23);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0441);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ec0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0426);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0426);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0e80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0426);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaec0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0426);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5dee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0249);
+		sram_write(tp, 0xA10E, 0x0239);
+		sram_write(tp, 0xA10C, 0x0119);
+		sram_write(tp, 0xA10A, 0x03f2);
+		sram_write(tp, 0xA108, 0x0231);
+		sram_write(tp, 0xA106, 0x0413);
+		sram_write(tp, 0xA104, 0x0108);
+		sram_write(tp, 0xA102, 0x0506);
+		sram_write(tp, 0xA100, 0x038e);
+		sram_write(tp, 0xA110, 0x00ff);
+
+		/* uc2_patch_171006_calc_txcrc_reg_write_seq_USB */
+		sram_write(tp, 0xb87c, 0x82c1);
+		sram_write(tp, 0xb87e, 0xaf82);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcdaf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82d6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf82);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd9af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82dc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0282);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdc02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x830c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd7af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0eea);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe4f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8169);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac23);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x815d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad23);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1bf7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffcf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfa02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0b99);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0283);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3cf6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffcf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d70);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8169);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac24);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x815d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad24);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1bf7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffcf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfa02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8349);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0283);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3cf6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffcf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x861d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf70f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcfad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x27fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf60f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8375);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae16);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x83aa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae0e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x848f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae06);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x857e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad2b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x16ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ee1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x815d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf62c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe581);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5dbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8663);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe281);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa6e3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef13);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3905);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac2f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1da2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0417);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0285);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x815d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf62c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe581);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5dbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8663);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4412);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x20e6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe781);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa75d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0303);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef12);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c12);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1e13);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe281);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa4e3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5d03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x030c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x260c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x341e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x121e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x13bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8666);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8d1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x09bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8669);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8675);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa201);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0abf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x867b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x64ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x22a2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x020a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7e02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3f2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef64);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae15);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa203);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0abf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8681);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x64ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x08bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8684);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6483);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c64);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c32);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a63);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf81);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa81a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x961f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x66ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x563d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1fd9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef79);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ee8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef16);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x290a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ee8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x435c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef97);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1916);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaed9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8678);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2879);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd103);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7202);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ee8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6f02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3f2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa094);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62e2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe381);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa7d1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8672);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x100d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x121f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1259);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0043);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f13);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5903);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3a02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x851c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe681);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa4e7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5d03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x120c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x121e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x130c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x121e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x120c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x121e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x13bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8666);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8d1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x09bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8669);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8675);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x06bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8675);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f66);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8283);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c32);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef12);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ee8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef46);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3c00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2741);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef46);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2c00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8672);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x868a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x13bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x868d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8690);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x10bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x868a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1311);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ee8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x435c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2b02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x16ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7802);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3f2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ee2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe381);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa7d1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8672);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1259);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef13);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5903);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0da0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x900a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x13e7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x81a7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee81);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae2f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa094);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x26d1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8672);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x100d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x161f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1259);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x000d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f13);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5903);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcdbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8675);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd209);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ee8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef32);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3b0e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad3f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x11ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8669);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0243);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5c12);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaee8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad2b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0286);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x44e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8169);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf62c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe581);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x815d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf62c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe581);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5def);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee81);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa400);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee81);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee81);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa601);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee81);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee81);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa300);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x44a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe070);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb468);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdab4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x68ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb468);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0b6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3a20);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb638);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeeb6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x38ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb638);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x10b5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0032);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54b5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0076);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x10b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4e70);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb450);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x52b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4e66);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb44e);
+		sram_write(tp, 0xb85e, 0x03d1);
+		sram_write(tp, 0xb860, 0x0ee4);
+		sram_write(tp, 0xb862, 0x0fde);
+		sram_write(tp, 0xb864, 0xffff);
+		sram_write(tp, 0xb878, 0x0001);
+
+		data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+		data &= ~BIT(7);
+		ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+		/* uc_patch_171212_customer_USB */
+		sram_write(tp, 0x8586, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x92af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8598);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa1af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0285);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa1af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0414);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0286);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7e02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1273);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1cf8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9e3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x83ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa601);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x580f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa008);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4659);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0f9e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4239);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0aab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffcf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07f7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ead);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2729);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf60e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe283);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xab1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x239f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x28e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb714);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe1b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x155c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9fee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0285);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffcf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0af7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0fe0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffcf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac27);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaf6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0fe2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x83ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f23);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9f03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa6fd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfb02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f77);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2ee1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb72f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0286);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ce0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb72c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe1b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x864c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2ae1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb72b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0286);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ce0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb728);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe1b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x864c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x26e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb727);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0286);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x47d2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb8e6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb468);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe5b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69d2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbce6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb468);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe4b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x866d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfffd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfad2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x675e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f46);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d71);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f7f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2803);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fa0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x010d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4112);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa210);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb463);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6901);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe4b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb463);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8016);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad2d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3bbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86fd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x08ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2832);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3f08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x29d2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8703);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x023f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x080d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x11f6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2fef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x31e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf627);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf627);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8202);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86ca);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbfa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf4e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fed);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1c21);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a92);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe08f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeee1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef74);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe08f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef64);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0217);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x70fc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xff04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2087);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0620);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8709);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0087);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cbb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa880);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeea8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8070);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa880);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60a8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x18e8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa818);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60a8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a00);
+		sram_write(tp, 0xb818, 0x040e);
+		sram_write(tp, 0xb81a, 0x1019);
+		sram_write(tp, 0xb81c, 0xffff);
+		sram_write(tp, 0xb81e, 0xffff);
+		sram_write(tp, 0xb832, 0x0003);
+
+		rtl_patch_key_set(tp, 0x8024, 0x0000);
+		ocp_reg_write(tp, 0xc414, 0x0200);
 
-	return ver;
-}
+		rtl_phy_patch_request(tp, false, true);
 
-static void rtl8152_fw_phy_fixup(struct r8152 *tp, struct fw_phy_fixup *fix)
-{
-	u16 addr, data;
+		r8156_lock_main(tp, true);
+
+		sram_write(tp, 0x80c9, 0x3478);
+		sram_write(tp, 0x80d0, 0xfe8f);
+		sram_write(tp, 0x80ca, 0x7843);
+		sram_write(tp, 0x80cb, 0x43b0);
+		sram_write(tp, 0x80cb, 0x4380);
+		sram_write(tp, 0x80cc, 0xb00b);
+		sram_write(tp, 0x80cd, 0x0ba1);
+		sram_write(tp, 0x80d8, 0x1078);
+		sram_write(tp, 0x8016, 0x3f00);
+		sram_write(tp, 0x8fed, 0x0386);
+		sram_write(tp, 0x8fee, 0x86f4);
+		sram_write(tp, 0x8fef, 0xf486);
+		sram_write(tp, 0x8ff0, 0x86fd);
+		sram_write(tp, 0x8ff1, 0xfd28);
+		sram_write(tp, 0x8ff2, 0x285a);
+		sram_write(tp, 0x8ff3, 0x5a70);
+		sram_write(tp, 0x8ff4, 0x7000);
+		sram_write(tp, 0x8ff5, 0x005d);
+		sram_write(tp, 0x8ff6, 0x5d77);
+		sram_write(tp, 0x8ff7, 0x7778);
+		sram_write(tp, 0x8ff8, 0x785f);
+		sram_write(tp, 0x8ff9, 0x5f74);
+		sram_write(tp, 0x8ffa, 0x7478);
+		sram_write(tp, 0x8ffb, 0x7858);
+		sram_write(tp, 0x8ffc, 0x5870);
+		sram_write(tp, 0x8ffd, 0x7078);
+		sram_write(tp, 0x8ffe, 0x7850);
+		sram_write(tp, 0x8fff, 0x5000);
+		sram_write(tp, 0x80dd, 0x34a4);
+		sram_write(tp, 0x80e4, 0xfe7f);
+		sram_write(tp, 0x80e6, 0x4a19);
+		sram_write(tp, 0x80de, 0xa443);
+		sram_write(tp, 0x80df, 0x43a0);
+		sram_write(tp, 0x80df, 0x43a0);
+		sram_write(tp, 0x80e0, 0xa00a);
+		sram_write(tp, 0x80e1, 0x0a00);
+		sram_write(tp, 0x80e8, 0x700c);
+		sram_write(tp, 0x80e2, 0x0007);
+		sram_write(tp, 0x80e3, 0x07fe);
+		sram_write(tp, 0x80ec, 0x0e78);
+		sram_write(tp, 0x80b5, 0x42f7);
+		sram_write(tp, 0x80bc, 0xfaa4);
+		sram_write(tp, 0x80bf, 0x1f80);
+		sram_write(tp, 0x80be, 0xff1f);
+		sram_write(tp, 0x80b7, 0x4280);
+		sram_write(tp, 0x80b6, 0xf742);
+		sram_write(tp, 0x80b8, 0x800f);
+		sram_write(tp, 0x80b9, 0x0fab);
+		sram_write(tp, 0x80c1, 0x1e0a);
+		sram_write(tp, 0x80c0, 0x801e);
+		sram_write(tp, 0x80bd, 0xa4ff);
+		sram_write(tp, 0x80bb, 0x0bfa);
+		sram_write(tp, 0x80ba, 0xab0b);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0x818d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x003d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x009b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00cb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00f2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00fd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00c2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0065);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0034);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x001b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x000e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0007);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		sram_write(tp, 0x8163, 0xdb06);
+		sram_write(tp, 0x816a, 0xdb06);
+		sram_write(tp, 0x8171, 0xdb06);
+
+		r8156_lock_main(tp, false);
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		generic_ocp_write(tp, 0xe600, 0xff, sizeof(usb3_patch_t),
+				  usb3_patch_t, MCU_TYPE_USB);
+
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0xa000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_0, 0x033e);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_1, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_2, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_3, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_5, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_6, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_7, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0x0001);
+	}
 
 	rtl_reset_ocp_base(tp);
+}
 
-	addr = __le16_to_cpu(fix->setting.addr);
-	data = ocp_reg_read(tp, addr);
+static void r8153_aldps_en(struct r8152 *tp, bool enable)
+{
+	u16 data;
 
-	switch (__le16_to_cpu(fix->bit_cmd)) {
-	case FW_FIXUP_AND:
-		data &= __le16_to_cpu(fix->setting.data);
-		break;
-	case FW_FIXUP_OR:
-		data |= __le16_to_cpu(fix->setting.data);
-		break;
-	case FW_FIXUP_NOT:
-		data &= ~__le16_to_cpu(fix->setting.data);
-		break;
-	case FW_FIXUP_XOR:
-		data ^= __le16_to_cpu(fix->setting.data);
-		break;
-	default:
-		return;
-	}
+	data = ocp_reg_read(tp, OCP_POWER_CFG);
+	if (enable) {
+		data |= EN_ALDPS;
+		ocp_reg_write(tp, OCP_POWER_CFG, data);
+	} else {
+		int i;
 
-	ocp_reg_write(tp, addr, data);
+		data &= ~EN_ALDPS;
+		ocp_reg_write(tp, OCP_POWER_CFG, data);
+		for (i = 0; i < 20; i++) {
+			usleep_range(1000, 2000);
+			if (ocp_read_word(tp, MCU_TYPE_PLA, 0xe000) & 0x0100)
+				break;
+		}
+	}
 
-	dev_dbg(&tp->intf->dev, "applied ocp %x %x\n", addr, data);
+	tp->ups_info.aldps = enable;
 }
 
-static void rtl8152_fw_phy_union_apply(struct r8152 *tp, struct fw_phy_union *phy)
+static void r8153b_mcu_spdown_en(struct r8152 *tp, bool enable)
 {
-	__le16 *data;
-	u32 length;
-	int i, num;
+	u32 ocp_data;
 
-	rtl_reset_ocp_base(tp);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
+	if (enable)
+		ocp_data |= PLA_MCU_SPDWN_EN;
+	else
+		ocp_data &= ~PLA_MCU_SPDWN_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+}
 
-	num = phy->pre_num;
-	for (i = 0; i < num; i++)
-		sram_write(tp, __le16_to_cpu(phy->pre_set[i].addr),
-			   __le16_to_cpu(phy->pre_set[i].data));
+static void r8153_hw_phy_cfg(struct r8152 *tp)
+{
+	u32 ocp_data;
+	u16 data;
 
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	length -= __le16_to_cpu(phy->fw_offset);
-	num = length / 2;
-	data = (__le16 *)((u8 *)phy + __le16_to_cpu(phy->fw_offset));
+	/* disable ALDPS before updating the PHY parameters */
+	r8153_aldps_en(tp, false);
 
-	ocp_reg_write(tp, OCP_SRAM_ADDR, __le16_to_cpu(phy->fw_reg));
-	for (i = 0; i < num; i++)
-		ocp_reg_write(tp, OCP_SRAM_DATA, __le16_to_cpu(data[i]));
+	/* disable EEE before updating the PHY parameters */
+	rtl_eee_enable(tp, false);
 
-	num = phy->bp_num;
-	for (i = 0; i < num; i++)
-		sram_write(tp, __le16_to_cpu(phy->bp[i].addr), __le16_to_cpu(phy->bp[i].data));
+	r8153_firmware(tp);
 
-	if (phy->bp_num && phy->bp_en.addr)
-		sram_write(tp, __le16_to_cpu(phy->bp_en.addr), __le16_to_cpu(phy->bp_en.data));
+	if (tp->version == RTL_VER_03) {
+		data = ocp_reg_read(tp, OCP_EEE_CFG);
+		data &= ~CTAP_SHORT_EN;
+		ocp_reg_write(tp, OCP_EEE_CFG, data);
+	}
 
-	dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
-}
+	data = ocp_reg_read(tp, OCP_POWER_CFG);
+	data |= EEE_CLKDIV_EN;
+	ocp_reg_write(tp, OCP_POWER_CFG, data);
 
-static void rtl8152_fw_phy_nc_apply(struct r8152 *tp, struct fw_phy_nc *phy)
-{
-	u16 mode_reg, bp_index;
-	u32 length, i, num;
-	__le16 *data;
+	data = ocp_reg_read(tp, OCP_DOWN_SPEED);
+	data |= EN_10M_BGOFF;
+	ocp_reg_write(tp, OCP_DOWN_SPEED, data);
+	data = ocp_reg_read(tp, OCP_POWER_CFG);
+	data |= EN_10M_PLLOFF;
+	ocp_reg_write(tp, OCP_POWER_CFG, data);
+	sram_write(tp, SRAM_IMPEDANCE, 0x0b13);
 
-	rtl_reset_ocp_base(tp);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+	ocp_data |= PFM_PWM_SWITCH;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
 
-	mode_reg = __le16_to_cpu(phy->mode_reg);
-	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_pre));
-	sram_write(tp, __le16_to_cpu(phy->ba_reg),
-		   __le16_to_cpu(phy->ba_data));
+	/* Enable LPF corner auto tune */
+	sram_write(tp, SRAM_LPF_CFG, 0xf70f);
 
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	length -= __le16_to_cpu(phy->fw_offset);
-	num = length / 2;
-	data = (__le16 *)((u8 *)phy + __le16_to_cpu(phy->fw_offset));
+	/* Adjust 10M Amplitude */
+	sram_write(tp, SRAM_10M_AMP1, 0x00af);
+	sram_write(tp, SRAM_10M_AMP2, 0x0208);
 
-	ocp_reg_write(tp, OCP_SRAM_ADDR, __le16_to_cpu(phy->fw_reg));
-	for (i = 0; i < num; i++)
-		ocp_reg_write(tp, OCP_SRAM_DATA, __le16_to_cpu(data[i]));
+	if (tp->eee_en)
+		rtl_eee_enable(tp, true);
 
-	sram_write(tp, __le16_to_cpu(phy->patch_en_addr),
-		   __le16_to_cpu(phy->patch_en_value));
+	r8153_aldps_en(tp, true);
+	r8152b_enable_fc(tp);
 
-	bp_index = __le16_to_cpu(phy->bp_start);
-	num = __le16_to_cpu(phy->bp_num);
-	for (i = 0; i < num; i++) {
-		sram_write(tp, bp_index, __le16_to_cpu(phy->bp[i]));
-		bp_index += 2;
+	switch (tp->version) {
+	case RTL_VER_03:
+	case RTL_VER_04:
+		break;
+	case RTL_VER_05:
+	case RTL_VER_06:
+	default:
+		r8153_u2p3en(tp, true);
+		break;
 	}
 
-	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_post));
-
-	dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
+	set_bit(PHY_RESET, &tp->flags);
 }
 
-static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
+static u32 r8152_efuse_read(struct r8152 *tp, u8 addr)
 {
-	u16 bp_en_addr, bp_index, type, bp_num, fw_ver_reg;
-	u32 length;
-	u8 *data;
-	int i;
+	u32 ocp_data;
 
-	switch (__le32_to_cpu(mac->blk_hdr.type)) {
-	case RTL_FW_PLA:
-		type = MCU_TYPE_PLA;
-		break;
-	case RTL_FW_USB:
-		type = MCU_TYPE_USB;
-		break;
-	default:
-		return;
-	}
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EFUSE_CMD, EFUSE_READ_CMD | addr);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EFUSE_CMD);
+	ocp_data = (ocp_data & EFUSE_DATA_BIT16) << 9;	/* data of bit16 */
+	ocp_data |= ocp_read_word(tp, MCU_TYPE_PLA, PLA_EFUSE_DATA);
 
-	fw_ver_reg = __le16_to_cpu(mac->fw_ver_reg);
-	if (fw_ver_reg && ocp_read_byte(tp, MCU_TYPE_USB, fw_ver_reg) >= mac->fw_ver_data) {
-		dev_dbg(&tp->intf->dev, "%s firmware has been the newest\n", type ? "PLA" : "USB");
-		return;
-	}
+	return ocp_data;
+}
 
-	rtl_clear_bp(tp, type);
+static void r8153b_hw_phy_cfg(struct r8152 *tp)
+{
+	u32 ocp_data;
+	u16 data;
 
-	/* Enable backup/restore of MACDBG. This is required after clearing PLA
-	 * break points and before applying the PLA firmware.
-	 */
-	if (tp->version == RTL_VER_04 && type == MCU_TYPE_PLA &&
-	    !(ocp_read_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST) & DEBUG_OE)) {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_PRE, DEBUG_LTSSM);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST, DEBUG_LTSSM);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+	if (ocp_data & PCUT_STATUS) {
+		ocp_data &= ~PCUT_STATUS;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
 	}
 
-	length = __le32_to_cpu(mac->blk_hdr.length);
-	length -= __le16_to_cpu(mac->fw_offset);
+	/* disable ALDPS before updating the PHY parameters */
+	r8153_aldps_en(tp, false);
+
+	/* disable EEE before updating the PHY parameters */
+	rtl_eee_enable(tp, false);
 
-	data = (u8 *)mac;
-	data += __le16_to_cpu(mac->fw_offset);
+	/* U1/U2/L1 idle timer. 500 us */
+	ocp_write_word(tp, MCU_TYPE_USB, USB_U1U2_TIMER, 500);
 
-	generic_ocp_write(tp, __le16_to_cpu(mac->fw_reg), 0xff, length, data,
-			  type);
+	data = r8153_phy_status(tp, 0);
 
-	ocp_write_word(tp, type, __le16_to_cpu(mac->bp_ba_addr),
-		       __le16_to_cpu(mac->bp_ba_value));
+	switch (data) {
+	case PHY_STAT_PWRDN:
+	case PHY_STAT_EXT_INIT:
+		r8153b_firmware(tp);
 
-	bp_index = __le16_to_cpu(mac->bp_start);
-	bp_num = __le16_to_cpu(mac->bp_num);
-	for (i = 0; i < bp_num; i++) {
-		ocp_write_word(tp, type, bp_index, __le16_to_cpu(mac->bp[i]));
-		bp_index += 2;
+		data = r8152_mdio_read(tp, MII_BMCR);
+		data &= ~BMCR_PDOWN;
+		r8152_mdio_write(tp, MII_BMCR, data);
+		break;
+	case PHY_STAT_LAN_ON:
+	default:
+		r8153b_firmware(tp);
+		break;
 	}
 
-	bp_en_addr = __le16_to_cpu(mac->bp_en_addr);
-	if (bp_en_addr)
-		ocp_write_word(tp, type, bp_en_addr,
-			       __le16_to_cpu(mac->bp_en_value));
+	r8153b_green_en(tp, test_bit(GREEN_ETHERNET, &tp->flags));
 
-	if (fw_ver_reg)
-		ocp_write_byte(tp, MCU_TYPE_USB, fw_ver_reg,
-			       mac->fw_ver_data);
+	data = sram_read(tp, SRAM_GREEN_CFG);
+	data |= R_TUNE_EN;
+	sram_write(tp, SRAM_GREEN_CFG, data);
+	data = ocp_reg_read(tp, OCP_NCTL_CFG);
+	data |= PGA_RETURN_EN;
+	ocp_reg_write(tp, OCP_NCTL_CFG, data);
 
-	dev_dbg(&tp->intf->dev, "successfully applied %s\n", mac->info);
-}
+	/* ADC Bias Calibration:
+	 * read efuse offset 0x7d to get a 17-bit data. Remove the dummy/fake
+	 * bit (bit3) to rebuild the real 16-bit data. Write the data to the
+	 * ADC ioffset.
+	 */
+	ocp_data = r8152_efuse_read(tp, 0x7d);
+	data = (u16)(((ocp_data & 0x1fff0) >> 1) | (ocp_data & 0x7));
+	if (data != 0xffff)
+		ocp_reg_write(tp, OCP_ADC_IOFFSET, data);
 
-static void rtl8152_apply_firmware(struct r8152 *tp, bool power_cut)
-{
-	struct rtl_fw *rtl_fw = &tp->rtl_fw;
-	const struct firmware *fw;
-	struct fw_header *fw_hdr;
-	struct fw_phy_patch_key *key;
-	u16 key_addr = 0;
-	int i, patch_phy = 1;
+	/* ups mode tx-link-pulse timing adjustment:
+	 * rg_saw_cnt = OCP reg 0xC426 Bit[13:0]
+	 * swr_cnt_1ms_ini = 16000000 / rg_saw_cnt
+	 */
+	ocp_data = ocp_reg_read(tp, 0xc426);
+	ocp_data &= 0x3fff;
+	if (ocp_data) {
+		u32 swr_cnt_1ms_ini;
 
-	if (IS_ERR_OR_NULL(rtl_fw->fw))
-		return;
+		swr_cnt_1ms_ini = (16000000 / ocp_data) & SAW_CNT_1MS_MASK;
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_UPS_CFG);
+		ocp_data = (ocp_data & ~SAW_CNT_1MS_MASK) | swr_cnt_1ms_ini;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_UPS_CFG, ocp_data);
+	}
 
-	fw = rtl_fw->fw;
-	fw_hdr = (struct fw_header *)fw->data;
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+	ocp_data |= PFM_PWM_SWITCH;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
 
-	if (rtl_fw->pre_fw)
-		rtl_fw->pre_fw(tp);
+#ifdef CONFIG_CTAP_SHORT_OFF
+	data = ocp_reg_read(tp, OCP_EEE_CFG);
+	data &= ~CTAP_SHORT_EN;
+	ocp_reg_write(tp, OCP_EEE_CFG, data);
 
-	for (i = offsetof(struct fw_header, blocks); i < fw->size;) {
-		struct fw_block *block = (struct fw_block *)&fw->data[i];
+	tp->ups_info.ctap_short_off = true;
+#endif
+	/* Advnace EEE */
+	if (!rtl_phy_patch_request(tp, true, true)) {
+		data = ocp_reg_read(tp, OCP_POWER_CFG);
+		data |= EEE_CLKDIV_EN;
+		ocp_reg_write(tp, OCP_POWER_CFG, data);
+		tp->ups_info.eee_ckdiv = true;
 
-		switch (__le32_to_cpu(block->type)) {
-		case RTL_FW_END:
-			goto post_fw;
-		case RTL_FW_PLA:
-		case RTL_FW_USB:
-			rtl8152_fw_mac_apply(tp, (struct fw_mac *)block);
-			break;
-		case RTL_FW_PHY_START:
-			if (!patch_phy)
-				break;
-			key = (struct fw_phy_patch_key *)block;
-			key_addr = __le16_to_cpu(key->key_reg);
-			rtl_pre_ram_code(tp, key_addr, __le16_to_cpu(key->key_data), !power_cut);
-			break;
-		case RTL_FW_PHY_STOP:
-			if (!patch_phy)
-				break;
-			WARN_ON(!key_addr);
-			rtl_post_ram_code(tp, key_addr, !power_cut);
-			break;
-		case RTL_FW_PHY_NC:
-			rtl8152_fw_phy_nc_apply(tp, (struct fw_phy_nc *)block);
-			break;
-		case RTL_FW_PHY_VER:
-			patch_phy = rtl8152_fw_phy_ver(tp, (struct fw_phy_ver *)block);
-			break;
-		case RTL_FW_PHY_UNION_NC:
-		case RTL_FW_PHY_UNION_NC1:
-		case RTL_FW_PHY_UNION_NC2:
-		case RTL_FW_PHY_UNION_UC2:
-		case RTL_FW_PHY_UNION_UC:
-		case RTL_FW_PHY_UNION_MISC:
-			if (patch_phy)
-				rtl8152_fw_phy_union_apply(tp, (struct fw_phy_union *)block);
-			break;
-		case RTL_FW_PHY_FIXUP:
-			if (patch_phy)
-				rtl8152_fw_phy_fixup(tp, (struct fw_phy_fixup *)block);
-			break;
-		case RTL_FW_PHY_SPEED_UP:
-			rtl_ram_code_speed_up(tp, (struct fw_phy_speed_up *)block, !power_cut);
-			break;
-		default:
-			break;
-		}
+		data = ocp_reg_read(tp, OCP_DOWN_SPEED);
+		data |= EN_EEE_CMODE | EN_EEE_1000 | EN_10M_CLKDIV;
+		ocp_reg_write(tp, OCP_DOWN_SPEED, data);
+		tp->ups_info.eee_cmod_lv = true;
+		tp->ups_info._10m_ckdiv = true;
+		tp->ups_info.eee_plloff_giga = true;
+
+		ocp_reg_write(tp, OCP_SYSCLK_CFG, 0);
+		ocp_reg_write(tp, OCP_SYSCLK_CFG, clk_div_expo(5));
+		tp->ups_info._250m_ckdiv = true;
 
-		i += ALIGN(__le32_to_cpu(block->length), 8);
+		rtl_phy_patch_request(tp, false, true);
 	}
 
-post_fw:
-	if (rtl_fw->post_fw)
-		rtl_fw->post_fw(tp);
+	if (tp->eee_en)
+		rtl_eee_enable(tp, true);
+
+	r8153_aldps_en(tp, true);
+	r8152b_enable_fc(tp);
+//	r8153_u2p3en(tp, true);
 
-	rtl_reset_ocp_base(tp);
-	strscpy(rtl_fw->version, fw_hdr->version, RTL_VER_SIZE);
-	dev_info(&tp->intf->dev, "load %s successfully\n", rtl_fw->version);
+	set_bit(PHY_RESET, &tp->flags);
+	rtl_set_dbg_info_state(tp, DGB_DRV_STATE_LOAD);
 }
 
-static void rtl8152_release_firmware(struct r8152 *tp)
+static void r8153c_hw_phy_cfg(struct r8152 *tp)
 {
-	struct rtl_fw *rtl_fw = &tp->rtl_fw;
+	r8153b_hw_phy_cfg(tp);
 
-	if (!IS_ERR_OR_NULL(rtl_fw->fw)) {
-		release_firmware(rtl_fw->fw);
-		rtl_fw->fw = NULL;
-	}
+	tp->ups_info.r_tune = true;
 }
 
-static int rtl8152_request_firmware(struct r8152 *tp)
+static void rtl8153_change_mtu(struct r8152 *tp)
 {
-	struct rtl_fw *rtl_fw = &tp->rtl_fw;
-	long rc;
-
-	if (rtl_fw->fw || !rtl_fw->fw_name) {
-		dev_info(&tp->intf->dev, "skip request firmware\n");
-		rc = 0;
-		goto result;
-	}
-
-	rc = request_firmware(&rtl_fw->fw, rtl_fw->fw_name, &tp->intf->dev);
-	if (rc < 0)
-		goto result;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_JUMBO);
+}
 
-	rc = rtl8152_check_firmware(tp, rtl_fw);
-	if (rc < 0)
-		release_firmware(rtl_fw->fw);
+static void r8153_first_init(struct r8152 *tp)
+{
+	u32 ocp_data;
 
-result:
-	if (rc) {
-		rtl_fw->fw = ERR_PTR(rc);
+	rxdy_gated_en(tp, true);
+	r8153_teredo_off(tp);
 
-		dev_warn(&tp->intf->dev,
-			 "unable to load firmware patch %s (%ld)\n",
-			 rtl_fw->fw_name, rc);
-	}
+	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data &= ~RCR_ACPT_ALL;
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
 
-	return rc;
-}
+	rtl8152_nic_reset(tp);
+	rtl_reset_bmu(tp);
 
-static void r8152_aldps_en(struct r8152 *tp, bool enable)
-{
-	if (enable) {
-		ocp_reg_write(tp, OCP_ALDPS_CONFIG, ENPWRSAVE | ENPDNPS |
-						    LINKENA | DIS_SDSAVE);
-	} else {
-		ocp_reg_write(tp, OCP_ALDPS_CONFIG, ENPDNPS | LINKENA |
-						    DIS_SDSAVE);
-		msleep(20);
-	}
-}
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data &= ~NOW_IS_OOB;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
-static inline void r8152_mmd_indirect(struct r8152 *tp, u16 dev, u16 reg)
-{
-	ocp_reg_write(tp, OCP_EEE_AR, FUN_ADDR | dev);
-	ocp_reg_write(tp, OCP_EEE_DATA, reg);
-	ocp_reg_write(tp, OCP_EEE_AR, FUN_DATA | dev);
-}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data &= ~MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-static u16 r8152_mmd_read(struct r8152 *tp, u16 dev, u16 reg)
-{
-	u16 data;
+	wait_oob_link_list_ready(tp);
 
-	r8152_mmd_indirect(tp, dev, reg);
-	data = ocp_reg_read(tp, OCP_EEE_DATA);
-	ocp_reg_write(tp, OCP_EEE_AR, 0x0000);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= RE_INIT_LL;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	return data;
-}
+	wait_oob_link_list_ready(tp);
 
-static void r8152_mmd_write(struct r8152 *tp, u16 dev, u16 reg, u16 data)
-{
-	r8152_mmd_indirect(tp, dev, reg);
-	ocp_reg_write(tp, OCP_EEE_DATA, data);
-	ocp_reg_write(tp, OCP_EEE_AR, 0x0000);
-}
+	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
-static void r8152_eee_en(struct r8152 *tp, bool enable)
-{
-	u16 config1, config2, config3;
-	u32 ocp_data;
+	rtl8153_change_mtu(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
-	config1 = ocp_reg_read(tp, OCP_EEE_CONFIG1) & ~sd_rise_time_mask;
-	config2 = ocp_reg_read(tp, OCP_EEE_CONFIG2);
-	config3 = ocp_reg_read(tp, OCP_EEE_CONFIG3) & ~fast_snr_mask;
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0);
+	ocp_data |= TCR0_AUTO_FIFO;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TCR0, ocp_data);
 
-	if (enable) {
-		ocp_data |= EEE_RX_EN | EEE_TX_EN;
-		config1 |= EEE_10_CAP | EEE_NWAY_EN | TX_QUIET_EN | RX_QUIET_EN;
-		config1 |= sd_rise_time(1);
-		config2 |= RG_DACQUIET_EN | RG_LDVQUIET_EN;
-		config3 |= fast_snr(42);
-	} else {
-		ocp_data &= ~(EEE_RX_EN | EEE_TX_EN);
-		config1 &= ~(EEE_10_CAP | EEE_NWAY_EN | TX_QUIET_EN |
-			     RX_QUIET_EN);
-		config1 |= sd_rise_time(7);
-		config2 &= ~(RG_DACQUIET_EN | RG_LDVQUIET_EN);
-		config3 |= fast_snr(511);
-	}
+	rtl8152_nic_reset(tp);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
-	ocp_reg_write(tp, OCP_EEE_CONFIG1, config1);
-	ocp_reg_write(tp, OCP_EEE_CONFIG2, config2);
-	ocp_reg_write(tp, OCP_EEE_CONFIG3, config3);
+	/* rx share fifo credit full threshold */
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_NORMAL);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_NORMAL);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_NORMAL);
+	/* TX share fifo free credit full threshold */
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL2);
 }
 
-static void r8153_eee_en(struct r8152 *tp, bool enable)
+static void r8153_enter_oob(struct r8152 *tp)
 {
 	u32 ocp_data;
-	u16 config;
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EEE_CR);
-	config = ocp_reg_read(tp, OCP_EEE_CFG);
-
-	if (enable) {
-		ocp_data |= EEE_RX_EN | EEE_TX_EN;
-		config |= EEE10_EN;
-	} else {
-		ocp_data &= ~(EEE_RX_EN | EEE_TX_EN);
-		config &= ~EEE10_EN;
-	}
-
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_CR, ocp_data);
-	ocp_reg_write(tp, OCP_EEE_CFG, config);
 
-	tp->ups_info.eee = enable;
-}
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data &= ~NOW_IS_OOB;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
-static void r8156_eee_en(struct r8152 *tp, bool enable)
-{
-	u16 config;
+	rtl_disable(tp);
+	rtl_reset_bmu(tp);
 
-	r8153_eee_en(tp, enable);
+	wait_oob_link_list_ready(tp);
 
-	config = ocp_reg_read(tp, OCP_EEE_ADV2);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= RE_INIT_LL;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	if (enable)
-		config |= MDIO_EEE_2_5GT;
-	else
-		config &= ~MDIO_EEE_2_5GT;
+	wait_oob_link_list_ready(tp);
 
-	ocp_reg_write(tp, OCP_EEE_ADV2, config);
-}
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
 
-static void rtl_eee_enable(struct r8152 *tp, bool enable)
-{
 	switch (tp->version) {
-	case RTL_VER_01:
-	case RTL_VER_02:
-	case RTL_VER_07:
-		if (enable) {
-			r8152_eee_en(tp, true);
-			r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV,
-					tp->eee_adv);
-		} else {
-			r8152_eee_en(tp, false);
-			r8152_mmd_write(tp, MDIO_MMD_AN, MDIO_AN_EEE_ADV, 0);
-		}
-		break;
 	case RTL_VER_03:
 	case RTL_VER_04:
 	case RTL_VER_05:
 	case RTL_VER_06:
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG);
+		ocp_data &= ~TEREDO_WAKE_MASK;
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, ocp_data);
+		break;
+
 	case RTL_VER_08:
 	case RTL_VER_09:
 	case RTL_VER_14:
-		if (enable) {
-			r8153_eee_en(tp, true);
-			ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
-		} else {
-			r8153_eee_en(tp, false);
-			ocp_reg_write(tp, OCP_EEE_ADV, 0);
-		}
-		break;
-	case RTL_VER_10:
-	case RTL_VER_11:
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_15:
-		if (enable) {
-			r8156_eee_en(tp, true);
-			ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
-		} else {
-			r8156_eee_en(tp, false);
-			ocp_reg_write(tp, OCP_EEE_ADV, 0);
-		}
+		/* Clear teredo wake event. bit[15:8] is the teredo wakeup
+		 * type. Set it to zero. bits[7:0] are the W1C bits about
+		 * the events. Set them to all 1 to clear them.
+		 */
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_WAKE_BASE, 0x00ff);
 		break;
+
 	default:
 		break;
 	}
-}
 
-static void r8152b_enable_fc(struct r8152 *tp)
-{
-	u16 anar;
+	rtl_rx_vlan_en(tp, true);
 
-	anar = r8152_mdio_read(tp, MII_ADVERTISE);
-	anar |= ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM;
-	r8152_mdio_write(tp, MII_ADVERTISE, anar);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BDC_CR);
+	ocp_data |= ALDPS_PROXY_MODE;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BDC_CR, ocp_data);
 
-	tp->ups_info.flow_control = true;
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
+	ocp_data |= MCU_BORW_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+
+	rxdy_gated_en(tp, false);
+
+	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
 }
 
-static void rtl8152_disable(struct r8152 *tp)
+static void rtl8153_disable(struct r8152 *tp)
 {
-	r8152_aldps_en(tp, false);
+	r8153_aldps_en(tp, false);
 	rtl_disable(tp);
-	r8152_aldps_en(tp, true);
+	rtl_reset_bmu(tp);
+	r8153_aldps_en(tp, true);
 }
 
-static void r8152b_hw_phy_cfg(struct r8152 *tp)
+static int rtl8156_enable(struct r8152 *tp)
 {
-	rtl8152_apply_firmware(tp, false);
-	rtl_eee_enable(tp, tp->eee_en);
-	r8152_aldps_en(tp, true);
-	r8152b_enable_fc(tp);
+	u32 ocp_data;
+	u16 speed;
 
-	set_bit(PHY_RESET, &tp->flags);
-}
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return -ENODEV;
 
-static void wait_oob_link_list_ready(struct r8152 *tp)
-{
-	u32 ocp_data;
-	int i;
+	set_tx_qlen(tp);
+	rtl_set_eee_plus(tp);
+	r8153_set_rx_early_timeout(tp);
+	r8153_set_rx_early_size(tp);
 
-	for (i = 0; i < 1000; i++) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-		if (ocp_data & LINK_LIST_READY)
-			break;
-		usleep_range(1000, 2000);
+	switch (tp->version) {
+	case RTL_TEST_01:
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, 0xe95a);
+		ocp_data &= ~0xf;
+		ocp_data |= 5;
+		ocp_write_byte(tp, MCU_TYPE_PLA, 0xe95a, ocp_data);
+
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, 0xe940);
+		ocp_data &= ~0x1f;
+		ocp_data |= 4;
+		ocp_write_byte(tp, MCU_TYPE_PLA, 0xe940, ocp_data);
+		break;
+	default:
+		break;
 	}
-}
 
-static void r8156b_wait_loading_flash(struct r8152 *tp)
-{
-	if ((ocp_read_word(tp, MCU_TYPE_PLA, PLA_GPHY_CTRL) & GPHY_FLASH) &&
-	    !(ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL) & BYPASS_FLASH)) {
-		int i;
+	speed = rtl8152_get_speed(tp);
+	rtl_set_ifg(tp, speed);
 
-		for (i = 0; i < 100; i++) {
-			if (ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL) & GPHY_PATCH_DONE)
-				break;
-			usleep_range(1000, 2000);
-		}
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4);
+	if (speed & _2500bps)
+		ocp_data &= ~IDLE_SPDWN_EN;
+	else
+		ocp_data |= IDLE_SPDWN_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, ocp_data);
+
+	if (speed & _1000bps)
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_TXTWSYS, 0x11);
+	else if (speed & _500bps)
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_TXTWSYS, 0x3d);
+
+	if (tp->udev->speed == USB_SPEED_HIGH) {
+		/* USB 0xb45e[3:0] l1_nyet_hird */
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_L1_CTRL);
+		ocp_data &= ~0xf;
+		if (is_flow_control(speed))
+			ocp_data |= 0xf;
+		else
+			ocp_data |= 0x1;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_L1_CTRL, ocp_data);
 	}
+
+	return rtl_enable(tp);
 }
 
-static void r8152b_exit_oob(struct r8152 *tp)
+static int rtl8156b_enable(struct r8152 *tp)
 {
 	u32 ocp_data;
+	u16 speed;
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
-	ocp_data &= ~RCR_ACPT_ALL;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
-
-	rxdy_gated_en(tp, true);
-	r8153_teredo_off(tp);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CR, 0x00);
-
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data &= ~MCU_BORW_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return -ENODEV;
 
-	wait_oob_link_list_ready(tp);
+	set_tx_qlen(tp);
+	rtl_set_eee_plus(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data |= RE_INIT_LL;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_RX_AGGR_NUM);
+	ocp_data &= ~RX_AGGR_NUM_MASK;
+//	ocp_data |= 2;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_RX_AGGR_NUM, ocp_data);
 
-	wait_oob_link_list_ready(tp);
+	r8153_set_rx_early_timeout(tp);
+	r8153_set_rx_early_size(tp);
 
-	rtl8152_nic_reset(tp);
+	speed = rtl8152_get_speed(tp);
+	rtl_set_ifg(tp, speed);
 
-	/* rx share fifo credit full threshold */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_NORMAL);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4);
+	if (speed & _2500bps)
+		ocp_data &= ~IDLE_SPDWN_EN;
+	else
+		ocp_data |= IDLE_SPDWN_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, ocp_data);
 
-	if (tp->udev->speed == USB_SPEED_FULL ||
-	    tp->udev->speed == USB_SPEED_LOW) {
-		/* rx share fifo credit near full threshold */
-		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1,
-				RXFIFO_THR2_FULL);
-		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2,
-				RXFIFO_THR3_FULL);
-	} else {
-		/* rx share fifo credit near full threshold */
-		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1,
-				RXFIFO_THR2_HIGH);
-		ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2,
-				RXFIFO_THR3_HIGH);
+	if (tp->udev->speed == USB_SPEED_HIGH) {
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_L1_CTRL);
+		ocp_data &= ~0xf;
+		if (is_flow_control(speed))
+			ocp_data |= 0xf;
+		else
+			ocp_data |= 0x1;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_L1_CTRL, ocp_data);
 	}
 
-	/* TX share fifo free credit full threshold */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL2);
-
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_TX_AGG, TX_AGG_MAX_THRESHOLD);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_HIGH);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_TX_DMA,
-			TEST_MODE_DISABLE | TX_SIZE_ADJUST1);
-
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
-
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
+	ocp_data &= ~FC_PATCH_TASK;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+	usleep_range(1000, 2000);
+	ocp_data |= FC_PATCH_TASK;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0);
-	ocp_data |= TCR0_AUTO_FIFO;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TCR0, ocp_data);
+	return rtl_enable(tp);
 }
 
-static void r8152b_enter_oob(struct r8152 *tp)
+static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
+			     u32 advertising)
 {
-	u32 ocp_data;
+	u16 bmcr;
+	int ret = 0;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	if (autoneg == AUTONEG_DISABLE) {
+		if (duplex != DUPLEX_HALF && duplex != DUPLEX_FULL)
+			return -EINVAL;
 
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_OOB);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_OOB);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_OOB);
+		switch (speed) {
+		case SPEED_10:
+			bmcr = BMCR_SPEED10;
+			if (duplex == DUPLEX_FULL) {
+				bmcr |= BMCR_FULLDPLX;
+				tp->ups_info.speed_duplex = FORCE_10M_FULL;
+			} else {
+				tp->ups_info.speed_duplex = FORCE_10M_HALF;
+			}
+			break;
+		case SPEED_100:
+			bmcr = BMCR_SPEED100;
+			if (duplex == DUPLEX_FULL) {
+				bmcr |= BMCR_FULLDPLX;
+				tp->ups_info.speed_duplex = FORCE_100M_FULL;
+			} else {
+				tp->ups_info.speed_duplex = FORCE_100M_HALF;
+			}
+			break;
+		case SPEED_1000:
+			if (tp->mii.supports_gmii) {
+				bmcr = BMCR_SPEED1000 | BMCR_FULLDPLX;
+				tp->ups_info.speed_duplex = NWAY_1000M_FULL;
+				break;
+			}
+			fallthrough;
+		default:
+			ret = -EINVAL;
+			goto out;
+		}
 
-	rtl_disable(tp);
+		if (duplex == DUPLEX_FULL)
+			tp->mii.full_duplex = 1;
+		else
+			tp->mii.full_duplex = 0;
 
-	wait_oob_link_list_ready(tp);
+		tp->mii.force_media = 1;
+	} else {
+		u16 orig, new1;
+		u32 support;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data |= RE_INIT_LL;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+		support = RTL_ADVERTISED_10_HALF | RTL_ADVERTISED_10_FULL |
+			  RTL_ADVERTISED_100_HALF | RTL_ADVERTISED_100_FULL;
 
-	wait_oob_link_list_ready(tp);
+		if (tp->mii.supports_gmii) {
+			support |= RTL_ADVERTISED_1000_FULL;
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, RTL8152_RMS);
+			if (tp->support_2500full)
+				support |= RTL_ADVERTISED_2500_FULL;
+		}
 
-	rtl_rx_vlan_en(tp, true);
+		if (!(advertising & support))
+			return -EINVAL;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BDC_CR);
-	ocp_data |= ALDPS_PROXY_MODE;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BDC_CR, ocp_data);
+		orig = r8152_mdio_read(tp, MII_ADVERTISE);
+		new1 = orig & ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
+				ADVERTISE_100HALF | ADVERTISE_100FULL);
+		if (advertising & RTL_ADVERTISED_10_HALF) {
+			new1 |= ADVERTISE_10HALF;
+			tp->ups_info.speed_duplex = NWAY_10M_HALF;
+		}
+		if (advertising & RTL_ADVERTISED_10_FULL) {
+			new1 |= ADVERTISE_10FULL;
+			tp->ups_info.speed_duplex = NWAY_10M_FULL;
+		}
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+		if (advertising & RTL_ADVERTISED_100_HALF) {
+			new1 |= ADVERTISE_100HALF;
+			tp->ups_info.speed_duplex = NWAY_100M_HALF;
+		}
+		if (advertising & RTL_ADVERTISED_100_FULL) {
+			new1 |= ADVERTISE_100FULL;
+			tp->ups_info.speed_duplex = NWAY_100M_FULL;
+		}
 
-	rxdy_gated_en(tp, false);
+		if (orig != new1) {
+			r8152_mdio_write(tp, MII_ADVERTISE, new1);
+			tp->mii.advertising = new1;
+		}
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
-	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
-}
+		if (tp->mii.supports_gmii) {
+			orig = r8152_mdio_read(tp, MII_CTRL1000);
+			new1 = orig & ~(ADVERTISE_1000FULL |
+					ADVERTISE_1000HALF);
 
-static int r8153_pre_firmware_1(struct r8152 *tp)
-{
-	int i;
+			if (advertising & RTL_ADVERTISED_1000_FULL) {
+				new1 |= ADVERTISE_1000FULL;
+				tp->ups_info.speed_duplex = NWAY_1000M_FULL;
+			}
 
-	/* Wait till the WTD timer is ready. It would take at most 104 ms. */
-	for (i = 0; i < 104; i++) {
-		u32 ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_WDT1_CTRL);
+			if (orig != new1)
+				r8152_mdio_write(tp, MII_CTRL1000, new1);
+		}
 
-		if (!(ocp_data & WTD1_EN))
-			break;
-		usleep_range(1000, 2000);
-	}
+		if (tp->support_2500full) {
+			orig = ocp_reg_read(tp, OCP_10GBT_CTRL);
+			new1 = orig & ~MDIO_AN_10GBT_CTRL_ADV2_5G;
 
-	return 0;
-}
+			if (advertising & RTL_ADVERTISED_2500_FULL) {
+				new1 |= MDIO_AN_10GBT_CTRL_ADV2_5G;
+				tp->ups_info.speed_duplex = NWAY_2500M_FULL;
+			}
 
-static int r8153_post_firmware_1(struct r8152 *tp)
-{
-	/* set USB_BP_4 to support USB_SPEED_SUPER only */
-	if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER)
-		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, BP4_SUPER_ONLY);
+			if (orig != new1)
+				ocp_reg_write(tp, OCP_10GBT_CTRL, new1);
+		}
 
-	/* reset UPHY timer to 36 ms */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_UPHY_TIMER, 36000 / 16);
+		bmcr = BMCR_ANENABLE | BMCR_ANRESTART;
 
-	return 0;
-}
+		tp->mii.force_media = 0;
+	}
 
-static int r8153_pre_firmware_2(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	r8153_pre_firmware_1(tp);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
-	ocp_data &= ~FW_FIX_SUSPEND;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
+	if (test_and_clear_bit(PHY_RESET, &tp->flags))
+		bmcr |= BMCR_RESET;
 
-	return 0;
-}
+	r8152_mdio_write(tp, MII_BMCR, bmcr);
 
-static int r8153_post_firmware_2(struct r8152 *tp)
-{
-	u32 ocp_data;
+	if (bmcr & BMCR_RESET) {
+		int i;
 
-	/* enable bp0 if support USB_SPEED_SUPER only */
-	if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
-		ocp_data |= BIT(0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
+		for (i = 0; i < 50; i++) {
+			msleep(20);
+			if ((r8152_mdio_read(tp, MII_BMCR) & BMCR_RESET) == 0)
+				break;
+		}
 	}
 
-	/* reset UPHY timer to 36 ms */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_UPHY_TIMER, 36000 / 16);
-
-	/* enable U3P3 check, set the counter to 4 */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, U3P3_CHECK_EN | 4);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
-	ocp_data |= FW_FIX_SUSPEND;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
-
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
-	ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
-
-	return 0;
-}
-
-static int r8153_post_firmware_3(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
-	ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
-	ocp_data |= FW_IP_RESET_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
-
-	return 0;
+out:
+	return ret;
 }
 
-static int r8153b_pre_firmware_1(struct r8152 *tp)
+static bool rtl_speed_down(struct r8152 *tp)
 {
-	/* enable fc timer and set timer to 1 second. */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FC_TIMER,
-		       CTRL_TIMER_EN | (1000 / 8));
+	bool ret = false;
 
-	return 0;
-}
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return ret;
 
-static int r8153b_post_firmware_1(struct r8152 *tp)
-{
-	u32 ocp_data;
+	if ((tp->saved_wolopts & WAKE_ANY) && !(tp->saved_wolopts & WAKE_PHY)) {
+		u16 bmcr;
 
-	/* enable bp0 for RTL8153-BND */
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
-	if (ocp_data & BND_MASK) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
-		ocp_data |= BIT(0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
-	}
+		bmcr = r8152_mdio_read(tp, MII_BMCR);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
-	ocp_data |= FLOW_CTRL_PATCH_OPT;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
+		if (netif_carrier_ok(tp->netdev) && (bmcr & BMCR_ANENABLE) &&
+		    (r8152_mdio_read(tp, MII_EXPANSION) & EXPANSION_NWAY)) {
+			u16 anar, gbcr = 0, lpa, gbcr2 = 0;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
-	ocp_data |= FC_PATCH_TASK;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+			anar = r8152_mdio_read(tp, MII_ADVERTISE);
+			anar &= ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
+				  ADVERTISE_100HALF | ADVERTISE_100FULL);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
-	ocp_data |= FW_IP_RESET_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
+			if (tp->mii.supports_gmii) {
+				gbcr = r8152_mdio_read(tp, MII_CTRL1000);
+				gbcr &= ~(ADVERTISE_1000FULL |
+					  ADVERTISE_1000HALF);
+				if (tp->support_2500full) {
+					gbcr2 = ocp_reg_read(tp, 0xa5d4);
+					gbcr2 &= ~BIT(7);
+				}
+			}
 
-	return 0;
-}
+			lpa = r8152_mdio_read(tp, MII_LPA);
+			if (lpa & (LPA_10HALF | LPA_10FULL)) {
+				anar |= ADVERTISE_10HALF | ADVERTISE_10FULL;
+				rtl_eee_plus_en(tp, true);
+			} else if (lpa & (LPA_100HALF | LPA_100FULL)) {
+				anar |= ADVERTISE_10HALF | ADVERTISE_10FULL |
+					ADVERTISE_100HALF | ADVERTISE_100FULL;
+			} else {
+				goto out1;
+			}
 
-static int r8153c_post_firmware_1(struct r8152 *tp)
-{
-	u32 ocp_data;
+			if (tp->mii.supports_gmii) {
+				r8152_mdio_write(tp, MII_CTRL1000, gbcr);
+				if (tp->support_2500full)
+					ocp_reg_write(tp, 0xa5d4, gbcr2);
+			}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
-	ocp_data |= FLOW_CTRL_PATCH_2;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
+			r8152_mdio_write(tp, MII_ADVERTISE, anar);
+			r8152_mdio_write(tp, MII_BMCR, bmcr | BMCR_ANRESTART);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
-	ocp_data |= FC_PATCH_TASK;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+			set_bit(RECOVER_SPEED, &tp->flags);
+			ret = true;
+		}
+	}
 
-	return 0;
+out1:
+	return ret;
 }
 
-static int r8156a_post_firmware_1(struct r8152 *tp)
+static void rtl8152_up(struct r8152 *tp)
 {
-	u32 ocp_data;
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
-	ocp_data |= FW_IP_RESET_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
-
-	/* Modify U3PHY parameter for compatibility issue */
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPHY3_MDCMDIO, 0x4026840e);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPHY3_MDCMDIO, 0x4001acc9);
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
 
-	return 0;
+	r8152_aldps_en(tp, false);
+	r8152b_exit_oob(tp);
+	r8152_aldps_en(tp, true);
 }
 
-static void r8153_aldps_en(struct r8152 *tp, bool enable)
+static void rtl8152_down(struct r8152 *tp)
 {
-	u16 data;
-
-	data = ocp_reg_read(tp, OCP_POWER_CFG);
-	if (enable) {
-		data |= EN_ALDPS;
-		ocp_reg_write(tp, OCP_POWER_CFG, data);
-	} else {
-		int i;
-
-		data &= ~EN_ALDPS;
-		ocp_reg_write(tp, OCP_POWER_CFG, data);
-		for (i = 0; i < 20; i++) {
-			usleep_range(1000, 2000);
-			if (ocp_read_word(tp, MCU_TYPE_PLA, 0xe000) & 0x0100)
-				break;
-		}
+	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
+		rtl_drop_queued_tx(tp);
+		return;
 	}
 
-	tp->ups_info.aldps = enable;
+	r8152_power_cut_en(tp, false);
+	r8152_aldps_en(tp, false);
+	r8152b_enter_oob(tp);
+	r8152_aldps_en(tp, true);
 }
 
-static void r8153_hw_phy_cfg(struct r8152 *tp)
+static void rtl8153_up(struct r8152 *tp)
 {
 	u32 ocp_data;
-	u16 data;
-
-	/* disable ALDPS before updating the PHY parameters */
-	r8153_aldps_en(tp, false);
-
-	/* disable EEE before updating the PHY parameters */
-	rtl_eee_enable(tp, false);
-
-	rtl8152_apply_firmware(tp, false);
-
-	if (tp->version == RTL_VER_03) {
-		data = ocp_reg_read(tp, OCP_EEE_CFG);
-		data &= ~CTAP_SHORT_EN;
-		ocp_reg_write(tp, OCP_EEE_CFG, data);
-	}
 
-	data = ocp_reg_read(tp, OCP_POWER_CFG);
-	data |= EEE_CLKDIV_EN;
-	ocp_reg_write(tp, OCP_POWER_CFG, data);
-
-	data = ocp_reg_read(tp, OCP_DOWN_SPEED);
-	data |= EN_10M_BGOFF;
-	ocp_reg_write(tp, OCP_DOWN_SPEED, data);
-	data = ocp_reg_read(tp, OCP_POWER_CFG);
-	data |= EN_10M_PLLOFF;
-	ocp_reg_write(tp, OCP_POWER_CFG, data);
-	sram_write(tp, SRAM_IMPEDANCE, 0x0b13);
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
-	ocp_data |= PFM_PWM_SWITCH;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
+	r8153_u1u2en(tp, false);
+	r8153_u2p3en(tp, false);
+	r8153_aldps_en(tp, false);
+	r8153_first_init(tp);
 
-	/* Enable LPF corner auto tune */
-	sram_write(tp, SRAM_LPF_CFG, 0xf70f);
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data |= LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
 
-	/* Adjust 10M Amplitude */
-	sram_write(tp, SRAM_10M_AMP1, 0x00af);
-	sram_write(tp, SRAM_10M_AMP2, 0x0208);
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data &= ~LANWAKE_PIN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
 
-	if (tp->eee_en)
-		rtl_eee_enable(tp, true);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_SSPHYLINK1);
+	ocp_data &= ~DELAY_PHY_PWR_CHG;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_SSPHYLINK1, ocp_data);
 
 	r8153_aldps_en(tp, true);
-	r8152b_enable_fc(tp);
 
 	switch (tp->version) {
 	case RTL_VER_03:
@@ -5725,142 +9365,91 @@ static void r8153_hw_phy_cfg(struct r8152 *tp)
 		break;
 	}
 
-	set_bit(PHY_RESET, &tp->flags);
+	r8153_u1u2en(tp, true);
 }
 
-static u32 r8152_efuse_read(struct r8152 *tp, u8 addr)
+static void rtl8153_down(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EFUSE_CMD, EFUSE_READ_CMD | addr);
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EFUSE_CMD);
-	ocp_data = (ocp_data & EFUSE_DATA_BIT16) << 9;	/* data of bit16 */
-	ocp_data |= ocp_read_word(tp, MCU_TYPE_PLA, PLA_EFUSE_DATA);
+	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
+		rtl_drop_queued_tx(tp);
+		return;
+	}
 
-	return ocp_data;
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data &= ~LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+
+	r8153_u1u2en(tp, false);
+	r8153_u2p3en(tp, false);
+	r8153_power_cut_en(tp, false);
+	r8153_aldps_en(tp, false);
+	r8153_enter_oob(tp);
+	r8153_aldps_en(tp, true);
 }
 
-static void r8153b_hw_phy_cfg(struct r8152 *tp)
+static void rtl8153b_up(struct r8152 *tp)
 {
-	u32 ocp_data;
-	u16 data;
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
-	if (ocp_data & PCUT_STATUS) {
-		ocp_data &= ~PCUT_STATUS;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
-	}
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
 
-	/* disable ALDPS before updating the PHY parameters */
+	r8153b_u1u2en(tp, false);
+	r8153_u2p3en(tp, false);
 	r8153_aldps_en(tp, false);
 
-	/* disable EEE before updating the PHY parameters */
-	rtl_eee_enable(tp, false);
-
-	/* U1/U2/L1 idle timer. 500 us */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_U1U2_TIMER, 500);
-
-	data = r8153_phy_status(tp, 0);
+	r8153_first_init(tp);
+	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_B);
 
-	switch (data) {
-	case PHY_STAT_PWRDN:
-	case PHY_STAT_EXT_INIT:
-		rtl8152_apply_firmware(tp, true);
+	r8153b_mcu_spdown_en(tp, false);
+	r8153_aldps_en(tp, true);
+//	r8153_u2p3en(tp, true);
+	if (tp->udev->speed >= USB_SPEED_SUPER)
+		r8153b_u1u2en(tp, true);
+}
 
-		data = r8152_mdio_read(tp, MII_BMCR);
-		data &= ~BMCR_PDOWN;
-		r8152_mdio_write(tp, MII_BMCR, data);
-		break;
-	case PHY_STAT_LAN_ON:
-	default:
-		rtl8152_apply_firmware(tp, false);
-		break;
+static void rtl8153b_down(struct r8152 *tp)
+{
+	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
+		rtl_drop_queued_tx(tp);
+		return;
 	}
 
-	r8153b_green_en(tp, test_bit(GREEN_ETHERNET, &tp->flags));
+	r8153b_mcu_spdown_en(tp, true);
+	r8153b_u1u2en(tp, false);
+	r8153_u2p3en(tp, false);
+	r8153b_power_cut_en(tp, false);
+	r8153_aldps_en(tp, false);
+	r8153_enter_oob(tp);
+	r8153_aldps_en(tp, true);
+}
 
-	data = sram_read(tp, SRAM_GREEN_CFG);
-	data |= R_TUNE_EN;
-	sram_write(tp, SRAM_GREEN_CFG, data);
-	data = ocp_reg_read(tp, OCP_NCTL_CFG);
-	data |= PGA_RETURN_EN;
-	ocp_reg_write(tp, OCP_NCTL_CFG, data);
+static void rtl8153c_change_mtu(struct r8152 *tp)
+{
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, 10 * 1024 / 64);
 
-	/* ADC Bias Calibration:
-	 * read efuse offset 0x7d to get a 17-bit data. Remove the dummy/fake
-	 * bit (bit3) to rebuild the real 16-bit data. Write the data to the
-	 * ADC ioffset.
-	 */
-	ocp_data = r8152_efuse_read(tp, 0x7d);
-	data = (u16)(((ocp_data & 0x1fff0) >> 1) | (ocp_data & 0x7));
-	if (data != 0xffff)
-		ocp_reg_write(tp, OCP_ADC_IOFFSET, data);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, 512 / 64);
 
-	/* ups mode tx-link-pulse timing adjustment:
-	 * rg_saw_cnt = OCP reg 0xC426 Bit[13:0]
-	 * swr_cnt_1ms_ini = 16000000 / rg_saw_cnt
+	/* Adjust the tx fifo free credit full threshold, otherwise
+	 * the fifo would be too small to send a jumbo frame packet.
 	 */
-	ocp_data = ocp_reg_read(tp, 0xc426);
-	ocp_data &= 0x3fff;
-	if (ocp_data) {
-		u32 swr_cnt_1ms_ini;
-
-		swr_cnt_1ms_ini = (16000000 / ocp_data) & SAW_CNT_1MS_MASK;
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_UPS_CFG);
-		ocp_data = (ocp_data & ~SAW_CNT_1MS_MASK) | swr_cnt_1ms_ini;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_UPS_CFG, ocp_data);
-	}
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
-	ocp_data |= PFM_PWM_SWITCH;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
-
-	/* Advnace EEE */
-	if (!rtl_phy_patch_request(tp, true, true)) {
-		data = ocp_reg_read(tp, OCP_POWER_CFG);
-		data |= EEE_CLKDIV_EN;
-		ocp_reg_write(tp, OCP_POWER_CFG, data);
-		tp->ups_info.eee_ckdiv = true;
-
-		data = ocp_reg_read(tp, OCP_DOWN_SPEED);
-		data |= EN_EEE_CMODE | EN_EEE_1000 | EN_10M_CLKDIV;
-		ocp_reg_write(tp, OCP_DOWN_SPEED, data);
-		tp->ups_info.eee_cmod_lv = true;
-		tp->ups_info._10m_ckdiv = true;
-		tp->ups_info.eee_plloff_giga = true;
-
-		ocp_reg_write(tp, OCP_SYSCLK_CFG, 0);
-		ocp_reg_write(tp, OCP_SYSCLK_CFG, clk_div_expo(5));
-		tp->ups_info._250m_ckdiv = true;
-
-		rtl_phy_patch_request(tp, false, true);
-	}
-
-	if (tp->eee_en)
-		rtl_eee_enable(tp, true);
-
-	r8153_aldps_en(tp, true);
-	r8152b_enable_fc(tp);
-
-	set_bit(PHY_RESET, &tp->flags);
+	if (tp->netdev->mtu < 8000)
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_FULL, 2048 / 8);
+	else
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_FULL, 900 / 8);
 }
 
-static void r8153c_hw_phy_cfg(struct r8152 *tp)
+static void rtl8153c_up(struct r8152 *tp)
 {
-	r8153b_hw_phy_cfg(tp);
-
-	tp->ups_info.r_tune = true;
-}
+	u32 ocp_data;
 
-static void rtl8153_change_mtu(struct r8152 *tp)
-{
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_JUMBO);
-}
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
 
-static void r8153_first_init(struct r8152 *tp)
-{
-	u32 ocp_data;
+	r8153b_u1u2en(tp, false);
+	r8153_u2p3en(tp, false);
+	r8153_aldps_en(tp, false);
 
 	rxdy_gated_en(tp, true);
 	r8153_teredo_off(tp);
@@ -5890,1349 +9479,7116 @@ static void r8153_first_init(struct r8152 *tp)
 
 	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
-	rtl8153_change_mtu(tp);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TCR0);
-	ocp_data |= TCR0_AUTO_FIFO;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TCR0, ocp_data);
+	rtl8153c_change_mtu(tp);
 
 	rtl8152_nic_reset(tp);
 
 	/* rx share fifo credit full threshold */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_NORMAL);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, 0x02);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL, 0x08);
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_NORMAL);
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_NORMAL);
+
+	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_B);
+
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG34);
+	ocp_data |= BIT(8);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CONFIG34, ocp_data);
+
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
+
+	r8153b_mcu_spdown_en(tp, false);
+
+	r8153_aldps_en(tp, true);
+//	r8153_u2p3en(tp, true);
+	r8153b_u1u2en(tp, true);
+}
+
+static inline u32 fc_pause_on_auto(struct r8152 *tp)
+{
+	return (ALIGN(mtu_to_size(tp->netdev->mtu), 1024) + 6 * 1024);
+}
+
+static inline u32 fc_pause_off_auto(struct r8152 *tp)
+{
+	return (ALIGN(mtu_to_size(tp->netdev->mtu), 1024) + 14 * 1024);
+}
+
+static void r8156_fc_parameter(struct r8152 *tp)
+{
+	u32 pause_on = tp->fc_pause_on ? tp->fc_pause_on : fc_pause_on_auto(tp);
+	u32 pause_off = tp->fc_pause_off ? tp->fc_pause_off : fc_pause_off_auto(tp);
+
+	switch (tp->version) {
+	case RTL_VER_10:
+	case RTL_VER_11:
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 8);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 8);
+		break;
+	case RTL_VER_12:
+	case RTL_VER_13:
+	case RTL_VER_15:
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 16);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 16);
+		break;
+	default:
+		break;
+	}
+}
+
+static void rtl8156_change_mtu(struct r8152 *tp)
+{
+	u32 rx_max_size = mtu_to_size(tp->netdev->mtu);
+
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, rx_max_size);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_JUMBO);
+	r8156_fc_parameter(tp);
+
 	/* TX share fifo free credit full threshold */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, TXFIFO_THR_NORMAL2);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, 512 / 64);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_FULL,
+		       ALIGN(rx_max_size + sizeof(struct tx_desc), 1024) / 16);
 }
 
-static void r8153_enter_oob(struct r8152 *tp)
+static void rtl8156_up(struct r8152 *tp)
 {
 	u32 ocp_data;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
 
-	/* RX FIFO settings for OOB */
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, RXFIFO_THR1_OOB);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_OOB);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_OOB);
+	r8153b_u1u2en(tp, false);
+	r8153_u2p3en(tp, false);
+	r8153_aldps_en(tp, false);
 
-	rtl_disable(tp);
+	rxdy_gated_en(tp, true);
+	r8153_teredo_off(tp);
+
+	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
+	ocp_data &= ~RCR_ACPT_ALL;
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+
+	rtl8152_nic_reset(tp);
 	rtl_reset_bmu(tp);
 
-	wait_oob_link_list_ready(tp);
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data &= ~NOW_IS_OOB;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data |= RE_INIT_LL;
+	ocp_data &= ~MCU_BORW_EN;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
 
-	wait_oob_link_list_ready(tp);
+	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, 1522);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
+	rtl8156_change_mtu(tp);
 
 	switch (tp->version) {
-	case RTL_VER_03:
-	case RTL_VER_04:
-	case RTL_VER_05:
-	case RTL_VER_06:
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG);
-		ocp_data &= ~TEREDO_WAKE_MASK;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, ocp_data);
-		break;
-
-	case RTL_VER_08:
-	case RTL_VER_09:
-	case RTL_VER_14:
-		/* Clear teredo wake event. bit[15:8] is the teredo wakeup
-		 * type. Set it to zero. bits[7:0] are the W1C bits about
-		 * the events. Set them to all 1 to clear them.
-		 */
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_WAKE_BASE, 0x00ff);
+	case RTL_TEST_01:
+	case RTL_VER_10:
+	case RTL_VER_11:
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_BMU_CONFIG);
+		ocp_data |= ACT_ODMA;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BMU_CONFIG, ocp_data);
 		break;
-
 	default:
 		break;
 	}
 
-	rtl_rx_vlan_en(tp, true);
+	/* share FIFO settings */
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL);
+	ocp_data &= ~RXFIFO_FULL_MASK;
+	ocp_data |= 0x08;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BDC_CR);
-	ocp_data |= ALDPS_PROXY_MODE;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_BDC_CR, ocp_data);
+	r8153b_mcu_spdown_en(tp, false);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_SPEED_OPTION);
+	ocp_data &= ~(RG_PWRDN_EN | ALL_SPEED_OFF);
+	ocp_write_word(tp, MCU_TYPE_USB, USB_SPEED_OPTION, ocp_data);
+
+	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, 0x00600400);
+
+	if (tp->saved_wolopts != __rtl_get_wol(tp)) {
+		netif_warn(tp, ifup, tp->netdev, "wol setting is changed\n");
+		__rtl_set_wol(tp, tp->saved_wolopts);
+	}
+
+	r8153_aldps_en(tp, true);
+	r8153_u2p3en(tp, true);
+
+	if (tp->udev->speed >= USB_SPEED_SUPER)
+		r8153b_u1u2en(tp, true);
+}
+
+static void rtl8156_down(struct r8152 *tp)
+{
+	u32 ocp_data;
+
+	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
+		rtl_drop_queued_tx(tp);
+		return;
+	}
+
+	r8153b_mcu_spdown_en(tp, true);
+	r8153b_u1u2en(tp, false);
+	r8153_u2p3en(tp, false);
+	r8153b_power_cut_en(tp, false);
+	r8153_aldps_en(tp, false);
 
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data |= NOW_IS_OOB | DIS_MCU_CLROOB;
+	ocp_data &= ~NOW_IS_OOB;
 	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data |= MCU_BORW_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	rtl_disable(tp);
+	rtl_reset_bmu(tp);
+
+	/* Clear teredo wake event. bit[15:8] is the teredo wakeup
+	 * type. Set it to zero. bits[7:0] are the W1C bits about
+	 * the events. Set them to all 1 to clear them.
+	 */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_WAKE_BASE, 0x00ff);
 
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
+	ocp_data |= NOW_IS_OOB;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+
+	rtl_rx_vlan_en(tp, true);
 	rxdy_gated_en(tp, false);
 
 	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
 	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
 	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
-}
 
-static void rtl8153_disable(struct r8152 *tp)
-{
-	r8153_aldps_en(tp, false);
-	rtl_disable(tp);
-	rtl_reset_bmu(tp);
 	r8153_aldps_en(tp, true);
 }
 
-static int rtl8156_enable(struct r8152 *tp)
+static bool rtl8152_in_nway(struct r8152 *tp)
 {
-	u32 ocp_data;
-	u16 speed;
+	u16 nway_state;
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return -ENODEV;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, 0x2000);
+	tp->ocp_base = 0x2000;
+	ocp_write_byte(tp, MCU_TYPE_PLA, 0xb014, 0x4c);		/* phy state */
+	nway_state = ocp_read_word(tp, MCU_TYPE_PLA, 0xb01a);
 
-	set_tx_qlen(tp);
-	rtl_set_eee_plus(tp);
-	r8153_set_rx_early_timeout(tp);
-	r8153_set_rx_early_size(tp);
+	/* bit 15: TXDIS_STATE, bit 14: ABD_STATE */
+	if (nway_state & 0xc000)
+		return false;
+	else
+		return true;
+}
 
-	speed = rtl8152_get_speed(tp);
-	rtl_set_ifg(tp, speed);
+static bool rtl8153_in_nway(struct r8152 *tp)
+{
+	u16 phy_state = ocp_reg_read(tp, OCP_PHY_STATE) & 0xff;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4);
-	if (speed & _2500bps)
-		ocp_data &= ~IDLE_SPDWN_EN;
+	if (phy_state == TXDIS_STATE || phy_state == ABD_STATE)
+		return false;
 	else
-		ocp_data |= IDLE_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, ocp_data);
+		return true;
+}
 
-	if (speed & _1000bps)
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_TXTWSYS, 0x11);
-	else if (speed & _500bps)
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EEE_TXTWSYS, 0x3d);
+static void r8156_mdio_force_mode(struct r8152 *tp)
+{
+	u16 data;
 
-	if (tp->udev->speed == USB_SPEED_HIGH) {
-		/* USB 0xb45e[3:0] l1_nyet_hird */
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_L1_CTRL);
-		ocp_data &= ~0xf;
-		if (is_flow_control(speed))
-			ocp_data |= 0xf;
-		else
-			ocp_data |= 0x1;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_L1_CTRL, ocp_data);
+	/* Select force mode through 0xa5b4 bit 15
+	 * 0: MDIO force mode
+	 * 1: MMD force mode
+	 */
+	data = ocp_reg_read(tp, 0xa5b4);
+	if (data & BIT(15)) {
+		data &= ~BIT(15);
+		ocp_reg_write(tp, 0xa5b4, data);
 	}
-
-	return rtl_enable(tp);
 }
 
-static int rtl8156b_enable(struct r8152 *tp)
+static void set_carrier(struct r8152 *tp)
 {
-	u32 ocp_data;
+	struct net_device *netdev = tp->netdev;
+	struct napi_struct *napi = &tp->napi;
 	u16 speed;
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return -ENODEV;
+	speed = rtl8152_get_speed(tp);
 
-	set_tx_qlen(tp);
-	rtl_set_eee_plus(tp);
+	if (speed & LINK_STATUS) {
+		if (!netif_carrier_ok(netdev)) {
+			tp->rtl_ops.enable(tp);
+			netif_stop_queue(netdev);
+			napi_disable(napi);
+			netif_carrier_on(netdev);
+			rtl_start_rx(tp);
+			rtl8152_set_rx_mode(netdev);
+			napi_enable(napi);
+			netif_wake_queue(netdev);
+			netif_info(tp, link, netdev, "carrier on\n");
+		} else if (netif_queue_stopped(netdev) &&
+			   skb_queue_len(&tp->tx_queue) < tp->tx_qlen) {
+			netif_wake_queue(netdev);
+		}
+	} else {
+		if (netif_carrier_ok(netdev)) {
+			netif_carrier_off(netdev);
+			tasklet_disable(&tp->tx_tl);
+			napi_disable(napi);
+			tp->rtl_ops.disable(tp);
+			napi_enable(napi);
+			tasklet_enable(&tp->tx_tl);
+			netif_info(tp, link, netdev, "carrier off\n");
+		}
+	}
+}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_RX_AGGR_NUM);
-	ocp_data &= ~RX_AGGR_NUM_MASK;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_RX_AGGR_NUM, ocp_data);
+static inline void __rtl_work_func(struct r8152 *tp)
+{
+	/* If the device is unplugged or !netif_running(), the workqueue
+	 * doesn't need to wake the device, and could return directly.
+	 */
+	if (test_bit(RTL8152_UNPLUG, &tp->flags) || !netif_running(tp->netdev))
+		return;
 
-	r8153_set_rx_early_timeout(tp);
-	r8153_set_rx_early_size(tp);
+	if (usb_autopm_get_interface(tp->intf) < 0)
+		return;
 
-	speed = rtl8152_get_speed(tp);
-	rtl_set_ifg(tp, speed);
+	if (!test_bit(WORK_ENABLE, &tp->flags))
+		goto out1;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4);
-	if (speed & _2500bps)
-		ocp_data &= ~IDLE_SPDWN_EN;
-	else
-		ocp_data |= IDLE_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL4, ocp_data);
+	if (!mutex_trylock(&tp->control)) {
+		if (tp->rtk_enable_diag)
+			goto link_chg_only;
 
-	if (tp->udev->speed == USB_SPEED_HIGH) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_L1_CTRL);
-		ocp_data &= ~0xf;
-		if (is_flow_control(speed))
-			ocp_data |= 0xf;
-		else
-			ocp_data |= 0x1;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_L1_CTRL, ocp_data);
+		schedule_delayed_work(&tp->schedule, 0);
+		goto out1;
 	}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
-	ocp_data &= ~FC_PATCH_TASK;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
-	usleep_range(1000, 2000);
-	ocp_data |= FC_PATCH_TASK;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+	if (test_and_clear_bit(RTL8152_LINK_CHG, &tp->flags))
+		set_carrier(tp);
 
-	return rtl_enable(tp);
-}
+	if (test_bit(RTL8152_SET_RX_MODE, &tp->flags))
+		rtl8152_set_rx_mode(tp->netdev);
 
-static int rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
-			     u32 advertising)
-{
-	u16 bmcr;
-	int ret = 0;
+	/* don't schedule tasket before linking */
+	if (test_and_clear_bit(SCHEDULE_TASKLET, &tp->flags) &&
+	    netif_carrier_ok(tp->netdev))
+		tasklet_schedule(&tp->tx_tl);
 
-	if (autoneg == AUTONEG_DISABLE) {
-		if (duplex != DUPLEX_HALF && duplex != DUPLEX_FULL)
-			return -EINVAL;
+	if (test_and_clear_bit(RX_EPROTO, &tp->flags) &&
+	    !list_empty(&tp->rx_done))
+		napi_schedule(&tp->napi);
 
-		switch (speed) {
-		case SPEED_10:
-			bmcr = BMCR_SPEED10;
-			if (duplex == DUPLEX_FULL) {
-				bmcr |= BMCR_FULLDPLX;
-				tp->ups_info.speed_duplex = FORCE_10M_FULL;
-			} else {
-				tp->ups_info.speed_duplex = FORCE_10M_HALF;
-			}
-			break;
-		case SPEED_100:
-			bmcr = BMCR_SPEED100;
-			if (duplex == DUPLEX_FULL) {
-				bmcr |= BMCR_FULLDPLX;
-				tp->ups_info.speed_duplex = FORCE_100M_FULL;
-			} else {
-				tp->ups_info.speed_duplex = FORCE_100M_HALF;
-			}
-			break;
-		case SPEED_1000:
-			if (tp->mii.supports_gmii) {
-				bmcr = BMCR_SPEED1000 | BMCR_FULLDPLX;
-				tp->ups_info.speed_duplex = NWAY_1000M_FULL;
-				break;
-			}
-			fallthrough;
-		default:
-			ret = -EINVAL;
-			goto out;
-		}
+	mutex_unlock(&tp->control);
 
-		if (duplex == DUPLEX_FULL)
-			tp->mii.full_duplex = 1;
-		else
-			tp->mii.full_duplex = 0;
+out1:
+	usb_autopm_put_interface(tp->intf);
 
-		tp->mii.force_media = 1;
-	} else {
-		u16 orig, new1;
-		u32 support;
+link_chg_only:
+	if (test_and_clear_bit(RTL8152_LINK_CHG, &tp->flags)) {
+		int lock;
 
-		support = RTL_ADVERTISED_10_HALF | RTL_ADVERTISED_10_FULL |
-			  RTL_ADVERTISED_100_HALF | RTL_ADVERTISED_100_FULL;
+		rtnl_lock();
+		lock = mutex_trylock(&tp->control);
+		set_carrier(tp);
+		if (lock)
+			mutex_unlock(&tp->control);
+		rtnl_unlock();
+		goto out1;
+	}
+}
 
-		if (tp->mii.supports_gmii) {
-			support |= RTL_ADVERTISED_1000_FULL;
+static inline void __rtl_hw_phy_work_func(struct r8152 *tp)
+{
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
 
-			if (tp->support_2500full)
-				support |= RTL_ADVERTISED_2500_FULL;
-		}
+	if (usb_autopm_get_interface(tp->intf) < 0)
+		return;
 
-		if (!(advertising & support))
-			return -EINVAL;
+	mutex_lock(&tp->control);
 
-		orig = r8152_mdio_read(tp, MII_ADVERTISE);
-		new1 = orig & ~(ADVERTISE_10HALF | ADVERTISE_10FULL |
-				ADVERTISE_100HALF | ADVERTISE_100FULL);
-		if (advertising & RTL_ADVERTISED_10_HALF) {
-			new1 |= ADVERTISE_10HALF;
-			tp->ups_info.speed_duplex = NWAY_10M_HALF;
-		}
-		if (advertising & RTL_ADVERTISED_10_FULL) {
-			new1 |= ADVERTISE_10FULL;
-			tp->ups_info.speed_duplex = NWAY_10M_FULL;
-		}
+	tp->rtl_ops.hw_phy_cfg(tp);
 
-		if (advertising & RTL_ADVERTISED_100_HALF) {
-			new1 |= ADVERTISE_100HALF;
-			tp->ups_info.speed_duplex = NWAY_100M_HALF;
-		}
-		if (advertising & RTL_ADVERTISED_100_FULL) {
-			new1 |= ADVERTISE_100FULL;
-			tp->ups_info.speed_duplex = NWAY_100M_FULL;
-		}
+	rtl8152_set_speed(tp, tp->autoneg, tp->speed, tp->duplex,
+			  tp->advertising);
 
-		if (orig != new1) {
-			r8152_mdio_write(tp, MII_ADVERTISE, new1);
-			tp->mii.advertising = new1;
-		}
+	mutex_unlock(&tp->control);
 
-		if (tp->mii.supports_gmii) {
-			orig = r8152_mdio_read(tp, MII_CTRL1000);
-			new1 = orig & ~(ADVERTISE_1000FULL |
-					ADVERTISE_1000HALF);
+	usb_autopm_put_interface(tp->intf);
+}
 
-			if (advertising & RTL_ADVERTISED_1000_FULL) {
-				new1 |= ADVERTISE_1000FULL;
-				tp->ups_info.speed_duplex = NWAY_1000M_FULL;
-			}
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
 
-			if (orig != new1)
-				r8152_mdio_write(tp, MII_CTRL1000, new1);
-		}
+static void rtl_work_func_t(void *data)
+{
+	struct r8152 *tp = (struct r8152 *)data;
 
-		if (tp->support_2500full) {
-			orig = ocp_reg_read(tp, OCP_10GBT_CTRL);
-			new1 = orig & ~MDIO_AN_10GBT_CTRL_ADV2_5G;
-
-			if (advertising & RTL_ADVERTISED_2500_FULL) {
-				new1 |= MDIO_AN_10GBT_CTRL_ADV2_5G;
-				tp->ups_info.speed_duplex = NWAY_2500M_FULL;
-			}
-
-			if (orig != new1)
-				ocp_reg_write(tp, OCP_10GBT_CTRL, new1);
-		}
-
-		bmcr = BMCR_ANENABLE | BMCR_ANRESTART;
-
-		tp->mii.force_media = 0;
-	}
-
-	if (test_and_clear_bit(PHY_RESET, &tp->flags))
-		bmcr |= BMCR_RESET;
-
-	r8152_mdio_write(tp, MII_BMCR, bmcr);
-
-	if (bmcr & BMCR_RESET) {
-		int i;
+	__rtl_work_func(tp);
+}
 
-		for (i = 0; i < 50; i++) {
-			msleep(20);
-			if ((r8152_mdio_read(tp, MII_BMCR) & BMCR_RESET) == 0)
-				break;
-		}
-	}
+static void rtl_hw_phy_work_func_t(void *data)
+{
+	struct r8152 *tp = (struct r8152 *)data;
 
-out:
-	return ret;
+	__rtl_hw_phy_work_func(tp);
 }
 
-static void rtl8152_up(struct r8152 *tp)
+#else
+
+static void rtl_work_func_t(struct work_struct *work)
 {
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+	struct r8152 *tp = container_of(work, struct r8152, schedule.work);
 
-	r8152_aldps_en(tp, false);
-	r8152b_exit_oob(tp);
-	r8152_aldps_en(tp, true);
+	__rtl_work_func(tp);
 }
 
-static void rtl8152_down(struct r8152 *tp)
+static void rtl_hw_phy_work_func_t(struct work_struct *work)
 {
-	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
-		rtl_drop_queued_tx(tp);
-		return;
-	}
+	struct r8152 *tp = container_of(work, struct r8152, hw_phy_work.work);
 
-	r8152_power_cut_en(tp, false);
-	r8152_aldps_en(tp, false);
-	r8152b_enter_oob(tp);
-	r8152_aldps_en(tp, true);
+	__rtl_hw_phy_work_func(tp);
 }
 
-static void rtl8153_up(struct r8152 *tp)
+#endif
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP)
+static int rtl_notifier(struct notifier_block *nb, unsigned long action,
+			void *data)
 {
-	u32 ocp_data;
+	struct r8152 *tp = container_of(nb, struct r8152, pm_notifier);
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		if (usb_autopm_get_interface(tp->intf) < 0)
+			netif_info(tp, drv, tp->netdev, "Auto-wake fail\n");
+		break;
 
-	r8153_u1u2en(tp, false);
-	r8153_u2p3en(tp, false);
-	r8153_aldps_en(tp, false);
-	r8153_first_init(tp);
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		usb_autopm_put_interface(tp->intf);
+		break;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
-	ocp_data |= LANWAKE_CLR_EN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+	case PM_POST_RESTORE:
+	case PM_RESTORE_PREPARE:
+	default:
+		break;
+	}
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
-	ocp_data &= ~LANWAKE_PIN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
+	return NOTIFY_DONE;
+}
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP) */
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_SSPHYLINK1);
-	ocp_data &= ~DELAY_PHY_PWR_CHG;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_SSPHYLINK1, ocp_data);
+#if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
+static int rtl_s5_wol(struct r8152 *tp)
+{
+	struct usb_device *udev = tp->udev;
+	u32 ocp_data;
 
-	r8153_aldps_en(tp, true);
+	if (!tp->saved_wolopts)
+		return -EOPNOTSUPP;
 
 	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_07:
+		return -EOPNOTSUPP;
 	case RTL_VER_03:
 	case RTL_VER_04:
-		break;
 	case RTL_VER_05:
 	case RTL_VER_06:
+		goto remote_wake;
 	default:
-		r8153_u2p3en(tp, true);
 		break;
 	}
 
-	r8153_u1u2en(tp, true);
-}
-
-static void rtl8153_down(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
-		rtl_drop_queued_tx(tp);
-		return;
-	}
+	if (!(ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG5) & LAN_WAKE_EN))
+		return -EOPNOTSUPP;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
-	ocp_data &= ~LANWAKE_CLR_EN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_INDICATE_FALG);
+	ocp_data |= BIT(1);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_INDICATE_FALG, ocp_data);
 
-	r8153_u1u2en(tp, false);
-	r8153_u2p3en(tp, false);
-	r8153_power_cut_en(tp, false);
-	r8153_aldps_en(tp, false);
-	r8153_enter_oob(tp);
-	r8153_aldps_en(tp, true);
+remote_wake:
+	/* usb_enable_remote_wakeup */
+	if (udev->speed < USB_SPEED_SUPER)
+		return usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+				USB_REQ_SET_FEATURE, USB_RECIP_DEVICE,
+				USB_DEVICE_REMOTE_WAKEUP, 0, NULL, 0,
+				USB_CTRL_SET_TIMEOUT);
+	else
+		return usb_control_msg(udev, usb_sndctrlpipe(udev, 0),
+				USB_REQ_SET_FEATURE, USB_RECIP_INTERFACE,
+				USB_INTRF_FUNC_SUSPEND,
+				USB_INTRF_FUNC_SUSPEND_RW |
+				USB_INTRF_FUNC_SUSPEND_LP,
+				NULL, 0, USB_CTRL_SET_TIMEOUT);
 }
 
-static void rtl8153b_up(struct r8152 *tp)
+static
+int rtl_reboot_notifier(struct notifier_block *nb, unsigned long action,
+			void *data)
 {
-	u32 ocp_data;
+	struct r8152 *tp = container_of(nb, struct r8152, reboot_notifier);
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+	switch (action) {
+	case SYS_POWER_OFF:
+		if (test_and_clear_bit(WORK_ENABLE, &tp->flags)) {
+			int ret;
 
-	r8153b_u1u2en(tp, false);
-	r8153_u2p3en(tp, false);
-	r8153_aldps_en(tp, false);
+			if (usb_autopm_get_interface(tp->intf) < 0)
+				break;
 
-	r8153_first_init(tp);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_B);
+			mutex_lock(&tp->control);
+			tp->rtl_ops.down(tp);
+			ret = rtl_s5_wol(tp);
+			if (ret < 0)
+				netif_info(tp, drv, tp->netdev,
+					   "S5 WOL is not enabled, %d\n", ret);
+			else
+				netif_info(tp, drv, tp->netdev, "Enable S5 WOL\n");
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
-	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+			mutex_unlock(&tp->control);
+			usb_autopm_put_interface(tp->intf);
+		}
+		break;
 
-	r8153_aldps_en(tp, true);
+	case SYS_RESTART:
+	default:
+		break;
+	}
 
-	if (tp->udev->speed >= USB_SPEED_SUPER)
-		r8153b_u1u2en(tp, true);
+	return NOTIFY_DONE;
 }
+#endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
 
-static void rtl8153b_down(struct r8152 *tp)
+static int rtk_disable_diag(struct r8152 *tp)
 {
-	u32 ocp_data;
+	tp->rtk_enable_diag--;
+	rtl_reset_ocp_base(tp);
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
-		rtl_drop_queued_tx(tp);
-		return;
-	}
+	if (tp->support_2500full)
+		r8156_mdio_force_mode(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
-	ocp_data |= PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+	netif_info(tp, drv, tp->netdev, "disable rtk diag %d\n",
+		   tp->rtk_enable_diag);
+	mutex_unlock(&tp->control);
+	if (test_bit(WORK_ENABLE, &tp->flags))
+		schedule_delayed_work(&tp->schedule, 0);
+	usb_autopm_put_interface(tp->intf);
 
-	r8153b_u1u2en(tp, false);
-	r8153_u2p3en(tp, false);
-	r8153b_power_cut_en(tp, false);
-	r8153_aldps_en(tp, false);
-	r8153_enter_oob(tp);
-	r8153_aldps_en(tp, true);
+	return 0;
 }
 
-static void rtl8153c_change_mtu(struct r8152 *tp)
+static int rtl8152_open(struct net_device *netdev)
 {
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, mtu_to_size(tp->netdev->mtu));
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, 10 * 1024 / 64);
-
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, 512 / 64);
+	struct r8152 *tp = netdev_priv(netdev);
+	int res = 0;
 
-	/* Adjust the tx fifo free credit full threshold, otherwise
-	 * the fifo would be too small to send a jumbo frame packet.
-	 */
-	if (tp->netdev->mtu < 8000)
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_FULL, 2048 / 8);
-	else
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_FULL, 900 / 8);
-}
+	if (unlikely(tp->rtk_enable_diag))
+		return -EBUSY;
 
-static void rtl8153c_up(struct r8152 *tp)
-{
-	u32 ocp_data;
+	if (work_busy(&tp->hw_phy_work.work) & WORK_BUSY_PENDING) {
+		cancel_delayed_work_sync(&tp->hw_phy_work);
+		__rtl_hw_phy_work_func(tp);
+	}
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+	res = alloc_all_mem(tp);
+	if (res)
+		goto out;
 
-	r8153b_u1u2en(tp, false);
-	r8153_u2p3en(tp, false);
-	r8153_aldps_en(tp, false);
+	res = usb_autopm_get_interface(tp->intf);
+	if (res < 0)
+		goto out_free;
 
-	rxdy_gated_en(tp, true);
-	r8153_teredo_off(tp);
+	mutex_lock(&tp->control);
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
-	ocp_data &= ~RCR_ACPT_ALL;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+	tp->rtl_ops.up(tp);
 
-	rtl8152_nic_reset(tp);
-	rtl_reset_bmu(tp);
+	netif_carrier_off(netdev);
+	netif_start_queue(netdev);
+	smp_mb__before_atomic();
+	set_bit(WORK_ENABLE, &tp->flags);
+	smp_mb__after_atomic();
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	if (test_and_clear_bit(RECOVER_SPEED, &tp->flags))
+		rtl8152_set_speed(tp, tp->autoneg, tp->speed, tp->duplex,
+				  tp->advertising);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data &= ~MCU_BORW_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	res = usb_submit_urb(tp->intr_urb, GFP_KERNEL);
+	if (res) {
+		if (res == -ENODEV)
+			netif_device_detach(tp->netdev);
+		netif_warn(tp, ifup, netdev, "intr_urb submit failed: %d\n",
+			   res);
+		goto out_unlock;
+	}
+	napi_enable(&tp->napi);
+	tasklet_enable(&tp->tx_tl);
 
-	wait_oob_link_list_ready(tp);
+	mutex_unlock(&tp->control);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data |= RE_INIT_LL;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	usb_autopm_put_interface(tp->intf);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP)
+	tp->pm_notifier.notifier_call = rtl_notifier;
+	register_pm_notifier(&tp->pm_notifier);
+#endif
+#if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
+	tp->reboot_notifier.notifier_call = rtl_reboot_notifier;
+	register_reboot_notifier(&tp->reboot_notifier);
+#endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
+	return 0;
 
-	wait_oob_link_list_ready(tp);
+out_unlock:
+	mutex_unlock(&tp->control);
+	usb_autopm_put_interface(tp->intf);
+out_free:
+	free_all_mem(tp);
+out:
+	return res;
+}
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
-
-	rtl8153c_change_mtu(tp);
+static int rtl8152_close(struct net_device *netdev)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	int res = 0;
 
-	rtl8152_nic_reset(tp);
+#if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
+	unregister_reboot_notifier(&tp->reboot_notifier);
+#endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP)
+	unregister_pm_notifier(&tp->pm_notifier);
+#endif
+	tasklet_disable(&tp->tx_tl);
+	smp_mb__before_atomic();
+	clear_bit(WORK_ENABLE, &tp->flags);
+	smp_mb__after_atomic();
+	usb_kill_urb(tp->intr_urb);
+	cancel_delayed_work_sync(&tp->schedule);
+	napi_disable(&tp->napi);
+	netif_stop_queue(netdev);
 
-	/* rx share fifo credit full threshold */
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL0, 0x02);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL, 0x08);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL1, RXFIFO_THR2_NORMAL);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_CTRL2, RXFIFO_THR3_NORMAL);
+	if (unlikely(tp->rtk_enable_diag)) {
+		netif_err(tp, drv, tp->netdev, "rtk diag isn't disabled\n");
+		rtk_disable_diag(tp);
+	}
 
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, RX_THR_B);
+	res = usb_autopm_get_interface(tp->intf);
+	if (res < 0 || test_bit(RTL8152_UNPLUG, &tp->flags)) {
+		rtl_drop_queued_tx(tp);
+		rtl_stop_rx(tp);
+	} else {
+		mutex_lock(&tp->control);
 
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
+		tp->rtl_ops.down(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG34);
-	ocp_data |= BIT(8);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CONFIG34, ocp_data);
+#if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
+		if (rtl_s5_wol(tp) < 0)
+			netif_info(tp, drv, tp->netdev,
+				   "S5 WOL is not enabled\n");
+		else
+			netif_info(tp, drv, tp->netdev, "Enable S5 WOL\n");
+#endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
 
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_NORAML);
+		if (tp->version == RTL_VER_01)
+			rtl8152_set_speed(tp, AUTONEG_ENABLE, 0, 0, 3);
+		else
+			rtl_speed_down(tp);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
-	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+		mutex_unlock(&tp->control);
 
-	r8153_aldps_en(tp, true);
-	r8153b_u1u2en(tp, true);
-}
+		usb_autopm_put_interface(tp->intf);
+	}
 
-static inline u32 fc_pause_on_auto(struct r8152 *tp)
-{
-	return (ALIGN(mtu_to_size(tp->netdev->mtu), 1024) + 6 * 1024);
-}
+	free_all_mem(tp);
 
-static inline u32 fc_pause_off_auto(struct r8152 *tp)
-{
-	return (ALIGN(mtu_to_size(tp->netdev->mtu), 1024) + 14 * 1024);
+	return res;
 }
 
-static void r8156_fc_parameter(struct r8152 *tp)
+static void rtl_tally_reset(struct r8152 *tp)
 {
-	u32 pause_on = tp->fc_pause_on ? tp->fc_pause_on : fc_pause_on_auto(tp);
-	u32 pause_off = tp->fc_pause_off ? tp->fc_pause_off : fc_pause_off_auto(tp);
+	u32 ocp_data;
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, pause_on / 16);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, pause_off / 16);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_RSTTALLY);
+	ocp_data |= TALLY_RESET;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RSTTALLY, ocp_data);
 }
 
-static void rtl8156_change_mtu(struct r8152 *tp)
+static void rtl_disable_spi(struct r8152 *tp)
 {
-	u32 rx_max_size = mtu_to_size(tp->netdev->mtu);
-
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, rx_max_size);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_JUMBO);
-	r8156_fc_parameter(tp);
+	u32 ocp_data;
 
-	/* TX share fifo free credit full threshold */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_CTRL, 512 / 64);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TXFIFO_FULL,
-		       ALIGN(rx_max_size + sizeof(struct tx_desc), 1024) / 16);
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG5);
+	ocp_data &= ~SPI_EN;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CONFIG5, ocp_data);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, 0xcbf0);
+	ocp_data |= BIT(1);
+	ocp_write_word(tp, MCU_TYPE_USB, 0xcbf0, ocp_data);
 }
 
-static void rtl8156_up(struct r8152 *tp)
+static void r8152b_init(struct r8152 *tp)
 {
 	u32 ocp_data;
+	u16 data;
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
 
-	r8153b_u1u2en(tp, false);
-	r8153_u2p3en(tp, false);
-	r8153_aldps_en(tp, false);
+#if 0
+	/* Clear EP3 Fifo before using interrupt transfer */
+	if (ocp_read_byte(tp, MCU_TYPE_USB, 0xb963) & 0x80) {
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xb963, 0x08);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xb963, 0x40);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xb963, 0x00);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xb968, 0x00);
+		ocp_write_word(tp, MCU_TYPE_USB, 0xb010, 0x00e0);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xb963, 0x04);
+	}
+#endif
 
-	rxdy_gated_en(tp, true);
-	r8153_teredo_off(tp);
+	data = r8152_mdio_read(tp, MII_BMCR);
+	if (data & BMCR_PDOWN) {
+		data &= ~BMCR_PDOWN;
+		r8152_mdio_write(tp, MII_BMCR, data);
+	}
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
-	ocp_data &= ~RCR_ACPT_ALL;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
+	r8152_aldps_en(tp, false);
 
-	rtl8152_nic_reset(tp);
-	rtl_reset_bmu(tp);
+	if (tp->version == RTL_VER_01) {
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE);
+		ocp_data &= ~LED_MODE_MASK;
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE, ocp_data);
+	}
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	r8152_power_cut_en(tp, false);
+	rtl_runtime_suspend_enable(tp, false);
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data &= ~MCU_BORW_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+	ocp_data |= TX_10M_IDLE_EN | PFM_PWM_SWITCH;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
+	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL);
+	ocp_data &= ~MCU_CLK_RATIO_MASK;
+	ocp_data |= MCU_CLK_RATIO | D3_CLK_GATED_EN;
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, ocp_data);
+	ocp_data = GPHY_STS_MSK | SPEED_DOWN_MSK |
+		   SPDWN_RXDV_MSK | SPDWN_LINKCHG_MSK;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_GPHY_INTR_IMR, ocp_data);
 
-	rtl_rx_vlan_en(tp, tp->netdev->features & NETIF_F_HW_VLAN_CTAG_RX);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_TIMER);
+	ocp_data |= BIT(15);
+	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_TIMER, ocp_data);
+	ocp_write_word(tp, MCU_TYPE_USB, 0xcbfc, 0x03e8);
+	ocp_data &= ~BIT(15);
+	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_TIMER, ocp_data);
 
-	rtl8156_change_mtu(tp);
+	rtl_tally_reset(tp);
 
-	switch (tp->version) {
-	case RTL_TEST_01:
-	case RTL_VER_10:
-	case RTL_VER_11:
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_BMU_CONFIG);
-		ocp_data |= ACT_ODMA;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_BMU_CONFIG, ocp_data);
-		break;
-	default:
-		break;
-	}
+	/* enable rx aggregation */
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
+	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
+	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
+}
 
-	/* share FIFO settings */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL);
-	ocp_data &= ~RXFIFO_FULL_MASK;
-	ocp_data |= 0x08;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL, ocp_data);
+static void r8153_init(struct r8152 *tp)
+{
+	u32 ocp_data;
+	u16 data;
+	int i;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
-	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_SPEED_OPTION);
-	ocp_data &= ~(RG_PWRDN_EN | ALL_SPEED_OFF);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_SPEED_OPTION, ocp_data);
+	r8153_u1u2en(tp, false);
 
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_RX_BUF_TH, 0x00600400);
+	for (i = 0; i < 500; i++) {
+		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
+		    AUTOLOAD_DONE)
+			break;
 
-	if (tp->saved_wolopts != __rtl_get_wol(tp)) {
-		netif_warn(tp, ifup, tp->netdev, "wol setting is changed\n");
-		__rtl_set_wol(tp, tp->saved_wolopts);
+		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
-	r8153_aldps_en(tp, true);
-	r8153_u2p3en(tp, true);
-
-	if (tp->udev->speed >= USB_SPEED_SUPER)
-		r8153b_u1u2en(tp, true);
-}
+	data = r8153_phy_status(tp, 0);
 
-static void rtl8156_down(struct r8152 *tp)
-{
-	u32 ocp_data;
+	if (tp->version == RTL_VER_03 || tp->version == RTL_VER_04 ||
+	    tp->version == RTL_VER_05)
+		ocp_reg_write(tp, OCP_ADC_CFG, CKADSEL_L | ADC_EN | EN_EMI_L);
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags)) {
-		rtl_drop_queued_tx(tp);
-		return;
+	data = r8152_mdio_read(tp, MII_BMCR);
+	if (data & BMCR_PDOWN) {
+		data &= ~BMCR_PDOWN;
+		r8152_mdio_write(tp, MII_BMCR, data);
 	}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
-	ocp_data |= PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
 
-	r8153b_u1u2en(tp, false);
 	r8153_u2p3en(tp, false);
-	r8153b_power_cut_en(tp, false);
-	r8153_aldps_en(tp, false);
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data &= ~NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+	if (tp->version == RTL_VER_04) {
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_SSPHYLINK2);
+		ocp_data &= ~pwd_dn_scale_mask;
+		ocp_data |= pwd_dn_scale(96);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_SSPHYLINK2, ocp_data);
 
-	/* RX FIFO settings for OOB */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RXFIFO_FULL, 64 / 16);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_FULL, 1024 / 16);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RX_FIFO_EMPTY, 4096 / 16);
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
+		ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
+		ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
+	} else if (tp->version == RTL_VER_05) {
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_DMY_REG0);
+		ocp_data &= ~ECM_ALDPS;
+		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_DMY_REG0, ocp_data);
 
-	rtl_disable(tp);
-	rtl_reset_bmu(tp);
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1);
+		if (ocp_read_word(tp, MCU_TYPE_USB, USB_BURST_SIZE) == 0)
+			ocp_data &= ~DYNAMIC_BURST;
+		else
+			ocp_data |= DYNAMIC_BURST;
+		ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1, ocp_data);
+	} else if (tp->version == RTL_VER_06) {
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1);
+		if (ocp_read_word(tp, MCU_TYPE_USB, USB_BURST_SIZE) == 0)
+			ocp_data &= ~DYNAMIC_BURST;
+		else
+			ocp_data |= DYNAMIC_BURST;
+		ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1, ocp_data);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RMS, 1522);
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_MTPS, MTPS_DEFAULT);
+		r8153_queue_wake(tp, false);
 
-	/* Clear teredo wake event. bit[15:8] is the teredo wakeup
-	 * type. Set it to zero. bits[7:0] are the W1C bits about
-	 * the events. Set them to all 1 to clear them.
-	 */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_WAKE_BASE, 0x00ff);
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+		if (rtl8152_get_speed(tp) & LINK_STATUS)
+			ocp_data |= CUR_LINK_OK;
+		else
+			ocp_data &= ~CUR_LINK_OK;
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL);
-	ocp_data |= NOW_IS_OOB;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_OOB_CTRL, ocp_data);
+		/* r8153_queue_wake() has set this bit */
+		/* ocp_data &= ~BIT(8); */
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7);
-	ocp_data |= MCU_BORW_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_SFF_STS_7, ocp_data);
+		ocp_data |= POLL_LINK_CHG;
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
+	}
 
-	rtl_rx_vlan_en(tp, true);
-	rxdy_gated_en(tp, false);
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY2);
+	ocp_data |= EP4_FULL_FC;
+	ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY2, ocp_data);
 
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_RCR);
-	ocp_data |= RCR_APM | RCR_AM | RCR_AB;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
-
-	r8153_aldps_en(tp, true);
-}
-
-static bool rtl8152_in_nway(struct r8152 *tp)
-{
-	u16 nway_state;
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_WDT11_CTRL);
+	ocp_data &= ~TIMER11_EN;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_WDT11_CTRL, ocp_data);
 
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, 0x2000);
-	tp->ocp_base = 0x2000;
-	ocp_write_byte(tp, MCU_TYPE_PLA, 0xb014, 0x4c);		/* phy state */
-	nway_state = ocp_read_word(tp, MCU_TYPE_PLA, 0xb01a);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE);
+	ocp_data &= ~LED_MODE_MASK;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE, ocp_data);
 
-	/* bit 15: TXDIS_STATE, bit 14: ABD_STATE */
-	if (nway_state & 0xc000)
-		return false;
+	ocp_data = FIFO_EMPTY_1FB | ROK_EXIT_LPM;
+	if (tp->version == RTL_VER_04 && tp->udev->speed < USB_SPEED_SUPER)
+		ocp_data |= LPM_TIMER_500MS;
 	else
-		return true;
-}
+		ocp_data |= LPM_TIMER_500US;
+	ocp_write_byte(tp, MCU_TYPE_USB, USB_LPM_CTRL, ocp_data);
 
-static bool rtl8153_in_nway(struct r8152 *tp)
-{
-	u16 phy_state = ocp_reg_read(tp, OCP_PHY_STATE) & 0xff;
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_AFE_CTRL2);
+	ocp_data &= ~SEN_VAL_MASK;
+	ocp_data |= SEN_VAL_NORMAL | SEL_RXIDLE;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_AFE_CTRL2, ocp_data);
 
-	if (phy_state == TXDIS_STATE || phy_state == ABD_STATE)
-		return false;
-	else
-		return true;
-}
+	ocp_write_word(tp, MCU_TYPE_USB, USB_CONNECT_TIMER, 0x0001);
 
-static void r8156_mdio_force_mode(struct r8152 *tp)
-{
-	u16 data;
+	r8153_power_cut_en(tp, false);
+	rtl_runtime_suspend_enable(tp, false);
+	r8153_mac_clk_speed_down(tp, false);
+	r8153_u1u2en(tp, true);
+	usb_enable_lpm(tp->udev);
 
-	/* Select force mode through 0xa5b4 bit 15
-	 * 0: MDIO force mode
-	 * 1: MMD force mode
-	 */
-	data = ocp_reg_read(tp, 0xa5b4);
-	if (data & BIT(15)) {
-		data &= ~BIT(15);
-		ocp_reg_write(tp, 0xa5b4, data);
-	}
-}
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data |= LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
 
-static void set_carrier(struct r8152 *tp)
-{
-	struct net_device *netdev = tp->netdev;
-	struct napi_struct *napi = &tp->napi;
-	u16 speed;
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data &= ~LANWAKE_PIN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
 
-	speed = rtl8152_get_speed(tp);
+	/* rx aggregation */
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
+	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
+	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
 
-	if (speed & LINK_STATUS) {
-		if (!netif_carrier_ok(netdev)) {
-			tp->rtl_ops.enable(tp);
-			netif_stop_queue(netdev);
-			napi_disable(napi);
-			netif_carrier_on(netdev);
-			rtl_start_rx(tp);
-			clear_bit(RTL8152_SET_RX_MODE, &tp->flags);
-			_rtl8152_set_rx_mode(netdev);
-			napi_enable(napi);
-			netif_wake_queue(netdev);
-			netif_info(tp, link, netdev, "carrier on\n");
-		} else if (netif_queue_stopped(netdev) &&
-			   skb_queue_len(&tp->tx_queue) < tp->tx_qlen) {
-			netif_wake_queue(netdev);
-		}
-	} else {
-		if (netif_carrier_ok(netdev)) {
-			netif_carrier_off(netdev);
-			tasklet_disable(&tp->tx_tl);
-			napi_disable(napi);
-			tp->rtl_ops.disable(tp);
-			napi_enable(napi);
-			tasklet_enable(&tp->tx_tl);
-			netif_info(tp, link, netdev, "carrier off\n");
-		}
+	rtl_tally_reset(tp);
+
+	switch (tp->udev->speed) {
+	case USB_SPEED_SUPER:
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0)
+	case USB_SPEED_SUPER_PLUS:
+#endif
+		tp->coalesce = COALESCE_SUPER;
+		break;
+	case USB_SPEED_HIGH:
+		tp->coalesce = COALESCE_HIGH;
+		break;
+	default:
+		tp->coalesce = COALESCE_SLOW;
+		break;
 	}
 }
 
-static void rtl_work_func_t(struct work_struct *work)
+static void r8153b_init(struct r8152 *tp)
 {
-	struct r8152 *tp = container_of(work, struct r8152, schedule.work);
+	u32 ocp_data;
+	u16 data;
+	int i;
 
-	/* If the device is unplugged or !netif_running(), the workqueue
-	 * doesn't need to wake the device, and could return directly.
-	 */
-	if (test_bit(RTL8152_UNPLUG, &tp->flags) || !netif_running(tp->netdev))
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
 
-	if (usb_autopm_get_interface(tp->intf) < 0)
-		return;
+	rtl_set_dbg_info_init(tp);
+	r8153b_u1u2en(tp, false);
+	rtl_disable_spi(tp);
 
-	if (!test_bit(WORK_ENABLE, &tp->flags))
-		goto out1;
+	for (i = 0; i < 500; i++) {
+		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
+		    AUTOLOAD_DONE)
+			break;
 
-	if (!mutex_trylock(&tp->control)) {
-		schedule_delayed_work(&tp->schedule, 0);
-		goto out1;
+		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			break;
 	}
 
-	if (test_and_clear_bit(RTL8152_LINK_CHG, &tp->flags))
-		set_carrier(tp);
+	data = r8153_phy_status(tp, 0);
 
-	if (test_and_clear_bit(RTL8152_SET_RX_MODE, &tp->flags))
-		_rtl8152_set_rx_mode(tp->netdev);
+	data = r8152_mdio_read(tp, MII_BMCR);
+	if (data & BMCR_PDOWN) {
+		data &= ~BMCR_PDOWN;
+		r8152_mdio_write(tp, MII_BMCR, data);
+	}
 
-	/* don't schedule tasket before linking */
-	if (test_and_clear_bit(SCHEDULE_TASKLET, &tp->flags) &&
-	    netif_carrier_ok(tp->netdev))
-		tasklet_schedule(&tp->tx_tl);
+	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
 
-	if (test_and_clear_bit(RX_EPROTO, &tp->flags) &&
-	    !list_empty(&tp->rx_done))
-		napi_schedule(&tp->napi);
+	r8153_u2p3en(tp, false);
 
-	mutex_unlock(&tp->control);
+	/* MSC timer = 0xfff * 8ms = 32760 ms */
+	ocp_write_word(tp, MCU_TYPE_USB, USB_MSC_TIMER, 0x0fff);
 
-out1:
-	usb_autopm_put_interface(tp->intf);
-}
+	r8153b_power_cut_en(tp, false);
+	r8153b_ups_en(tp, false);
+	r8153_queue_wake(tp, false);
+	rtl_runtime_suspend_enable(tp, false);
 
-static void rtl_hw_phy_work_func_t(struct work_struct *work)
-{
-	struct r8152 *tp = container_of(work, struct r8152, hw_phy_work.work);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+	if (rtl8152_get_speed(tp) & LINK_STATUS)
+		ocp_data |= CUR_LINK_OK;
+	else
+		ocp_data &= ~CUR_LINK_OK;
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+	/* r8153_queue_wake() has set this bit */
+	/* ocp_data &= ~BIT(8); */
 
-	if (usb_autopm_get_interface(tp->intf) < 0)
-		return;
+	ocp_data |= POLL_LINK_CHG;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
 
-	mutex_lock(&tp->control);
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data |= LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
 
-	if (rtl8152_request_firmware(tp) == -ENODEV && tp->rtl_fw.retry) {
-		tp->rtl_fw.retry = false;
-		tp->rtl_fw.fw = NULL;
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
+	ocp_data &= ~LANWAKE_PIN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
 
-		/* Delay execution in case request_firmware() is not ready yet.
-		 */
-		queue_delayed_work(system_long_wq, &tp->hw_phy_work, HZ * 10);
-		goto ignore_once;
-	}
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
+	ocp_data &= ~LANWAKE_CLR_EN;
+	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
 
-	tp->rtl_ops.hw_phy_cfg(tp);
+	if (tp->udev->descriptor.idVendor == VENDOR_ID_LENOVO &&
+	    tp->udev->descriptor.idProduct == 0x3069)
+		ocp_write_word(tp, MCU_TYPE_USB, USB_SSPHYLINK2, 0x0c8c);
 
-	rtl8152_set_speed(tp, tp->autoneg, tp->speed, tp->duplex,
-			  tp->advertising);
+//	if (tp->udev->speed >= USB_SPEED_SUPER)
+//		r8153b_u1u2en(tp, true);
 
-ignore_once:
-	mutex_unlock(&tp->control);
+	usb_enable_lpm(tp->udev);
 
-	usb_autopm_put_interface(tp->intf);
-}
+	/* MAC clock speed down */
+	r8153_mac_clk_speed_down(tp, true);
 
-#ifdef CONFIG_PM_SLEEP
-static int rtl_notifier(struct notifier_block *nb, unsigned long action,
-			void *data)
-{
-	struct r8152 *tp = container_of(nb, struct r8152, pm_notifier);
+	r8153b_mcu_spdown_en(tp, false);
 
-	switch (action) {
-	case PM_HIBERNATION_PREPARE:
-	case PM_SUSPEND_PREPARE:
-		usb_autopm_get_interface(tp->intf);
-		break;
+	if (tp->version == RTL_VER_09) {
+		/* Disable Test IO for 32QFN */
+		if (ocp_read_byte(tp, MCU_TYPE_PLA, 0xdc00) & BIT(5)) {
+			ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
+			ocp_data |= TEST_IO_OFF;
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
+		}
+	}
 
-	case PM_POST_HIBERNATION:
-	case PM_POST_SUSPEND:
-		usb_autopm_put_interface(tp->intf);
-		break;
+	set_bit(GREEN_ETHERNET, &tp->flags);
 
-	case PM_POST_RESTORE:
-	case PM_RESTORE_PREPARE:
-	default:
-		break;
-	}
+	/* rx aggregation */
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
+	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
+	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
 
-	return NOTIFY_DONE;
+	rtl_tally_reset(tp);
+
+	tp->coalesce = 15000;	/* 15 us */
 }
-#endif
 
-static int rtl8152_open(struct net_device *netdev)
+static void r8153c_init(struct r8152 *tp)
 {
-	struct r8152 *tp = netdev_priv(netdev);
-	int res = 0;
+	u32 ocp_data;
+	u16 data;
+	int i;
 
-	if (work_busy(&tp->hw_phy_work.work) & WORK_BUSY_PENDING) {
-		cancel_delayed_work_sync(&tp->hw_phy_work);
-		rtl_hw_phy_work_func_t(&tp->hw_phy_work.work);
-	}
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
 
-	res = alloc_all_mem(tp);
-	if (res)
-		goto out;
+	r8153b_u1u2en(tp, false);
 
-	res = usb_autopm_get_interface(tp->intf);
-	if (res < 0)
-		goto out_free;
+	rtl_disable_spi(tp);
 
-	mutex_lock(&tp->control);
+	for (i = 0; i < 500; i++) {
+		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
+		    AUTOLOAD_DONE)
+			break;
 
-	tp->rtl_ops.up(tp);
+		msleep(20);
+		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+			return;
+	}
 
-	netif_carrier_off(netdev);
-	netif_start_queue(netdev);
-	set_bit(WORK_ENABLE, &tp->flags);
+	data = r8153_phy_status(tp, 0);
 
-	res = usb_submit_urb(tp->intr_urb, GFP_KERNEL);
-	if (res) {
-		if (res == -ENODEV)
-			netif_device_detach(tp->netdev);
-		netif_warn(tp, ifup, netdev, "intr_urb submit failed: %d\n",
-			   res);
-		goto out_unlock;
+	data = r8152_mdio_read(tp, MII_BMCR);
+	if (data & BMCR_PDOWN) {
+		data &= ~BMCR_PDOWN;
+		r8152_mdio_write(tp, MII_BMCR, data);
 	}
-	napi_enable(&tp->napi);
-	tasklet_enable(&tp->tx_tl);
 
-	mutex_unlock(&tp->control);
+	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
 
-	usb_autopm_put_interface(tp->intf);
-#ifdef CONFIG_PM_SLEEP
-	tp->pm_notifier.notifier_call = rtl_notifier;
-	register_pm_notifier(&tp->pm_notifier);
-#endif
-	return 0;
+	r8153_u2p3en(tp, false);
 
-out_unlock:
-	mutex_unlock(&tp->control);
-	usb_autopm_put_interface(tp->intf);
-out_free:
-	free_all_mem(tp);
-out:
-	return res;
-}
+	/* MSC timer = 0xfff * 8ms = 32760 ms */
+	ocp_write_word(tp, MCU_TYPE_USB, USB_MSC_TIMER, 0x0fff);
 
-static int rtl8152_close(struct net_device *netdev)
-{
-	struct r8152 *tp = netdev_priv(netdev);
-	int res = 0;
+	r8153b_power_cut_en(tp, false);
+	r8153c_ups_en(tp, false);
+	r8153_queue_wake(tp, false);
+	rtl_runtime_suspend_enable(tp, false);
 
-#ifdef CONFIG_PM_SLEEP
-	unregister_pm_notifier(&tp->pm_notifier);
-#endif
-	tasklet_disable(&tp->tx_tl);
-	clear_bit(WORK_ENABLE, &tp->flags);
-	usb_kill_urb(tp->intr_urb);
-	cancel_delayed_work_sync(&tp->schedule);
-	napi_disable(&tp->napi);
-	netif_stop_queue(netdev);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
+	if (rtl8152_get_speed(tp) & LINK_STATUS)
+		ocp_data |= CUR_LINK_OK;
+	else
+		ocp_data &= ~CUR_LINK_OK;
 
-	res = usb_autopm_get_interface(tp->intf);
-	if (res < 0 || test_bit(RTL8152_UNPLUG, &tp->flags)) {
-		rtl_drop_queued_tx(tp);
-		rtl_stop_rx(tp);
-	} else {
-		mutex_lock(&tp->control);
+	/* r8153_queue_wake() has set this bit */
+	/* ocp_data &= ~BIT(8); */
 
-		tp->rtl_ops.down(tp);
+	ocp_data |= POLL_LINK_CHG;
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
 
-		mutex_unlock(&tp->control);
-	}
+	r8153b_u1u2en(tp, true);
 
-	if (!res)
-		usb_autopm_put_interface(tp->intf);
+	usb_enable_lpm(tp->udev);
 
-	free_all_mem(tp);
+	/* MAC clock speed down */
+	r8153_mac_clk_speed_down(tp, true);
 
-	return res;
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_2);
+	ocp_data &= ~BIT(7);
+	ocp_write_byte(tp, MCU_TYPE_USB, USB_MISC_2, ocp_data);
+
+	set_bit(GREEN_ETHERNET, &tp->flags);
+
+	/* rx aggregation */
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
+	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
+	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
+
+	rtl_tally_reset(tp);
+
+	tp->coalesce = 15000;	/* 15 us */
 }
 
-static void rtl_tally_reset(struct r8152 *tp)
+static void r8156_patch_code(struct r8152 *tp)
 {
-	u32 ocp_data;
+	if (tp->version == RTL_TEST_01) {
+		static u8 usb3_patch_t[] = {
+			0x01, 0xe0, 0x05, 0xc7,
+			0xf6, 0x65, 0x02, 0xc0,
+			0x00, 0xb8, 0x40, 0x03,
+			0x00, 0xd4, 0x00, 0x00 };
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		generic_ocp_write(tp, 0xe600, 0xff, sizeof(usb3_patch_t),
+				  usb3_patch_t, MCU_TYPE_USB);
+
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0xa000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_0, 0x033e);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_1, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_2, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_3, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_5, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_6, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_7, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0x0001);
+	} else if (tp->version == RTL_VER_11) {
+		u32 ocp_data;
+		static u8 usb_patch3_b[] = {
+			0x10, 0xe0, 0x28, 0xe0,
+			0x3d, 0xe0, 0x85, 0xe0,
+			0x99, 0xe0, 0xb4, 0xe0,
+			0xd4, 0xe0, 0xfa, 0xe0,
+			0x20, 0xe1, 0x39, 0xe1,
+			0x65, 0xe1, 0xab, 0xe1,
+			0xba, 0xe1, 0xcc, 0xe1,
+			0xe3, 0xe1, 0xc0, 0xe2,
+			0x18, 0xc0, 0x00, 0x75,
+			0xd8, 0x49, 0x0e, 0xf0,
+			0x10, 0xc0, 0x10, 0xc5,
+			0x00, 0x1e, 0x08, 0x9e,
+			0x0c, 0x9d, 0x0e, 0xc6,
+			0x0a, 0x9e, 0x8f, 0x1c,
+			0x0e, 0x8c, 0x0e, 0x74,
+			0xcf, 0x49, 0xfe, 0xf1,
+			0x45, 0xe8, 0x02, 0xc0,
+			0x00, 0xb8, 0xf0, 0x4b,
+			0x00, 0xdc, 0x24, 0xe4,
+			0x04, 0xe4, 0x80, 0x02,
+			0x34, 0xd3, 0xff, 0xc3,
+			0x60, 0x72, 0xa8, 0x49,
+			0x0e, 0xf0, 0xf7, 0xc3,
+			0xf7, 0xc2, 0x00, 0x1c,
+			0x68, 0x9c, 0xf6, 0xc4,
+			0x6a, 0x9c, 0x6c, 0x9a,
+			0x8f, 0x1c, 0x6e, 0x8c,
+			0x6e, 0x74, 0xcf, 0x49,
+			0xfe, 0xf1, 0x2c, 0xe8,
+			0x04, 0xc0, 0x02, 0xc2,
+			0x00, 0xba, 0x9a, 0x3c,
+			0x80, 0xc3, 0x26, 0xe8,
+			0x23, 0xc7, 0x21, 0xc2,
+			0xec, 0x9a, 0x00, 0x19,
+			0xee, 0x89, 0xee, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0xea, 0x71, 0x9f, 0x49,
+			0x14, 0xf0, 0xda, 0xc2,
+			0xec, 0x9a, 0x00, 0x19,
+			0xe8, 0x99, 0x81, 0x19,
+			0xee, 0x89, 0xee, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0xd2, 0xc2, 0xec, 0x9a,
+			0x00, 0x19, 0x98, 0x20,
+			0xe8, 0x99, 0x82, 0x19,
+			0xee, 0x89, 0xee, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x06, 0xc3, 0x02, 0xc2,
+			0x00, 0xba, 0x3e, 0x29,
+			0x4c, 0xe8, 0x00, 0xdc,
+			0x00, 0xd4, 0x00, 0xb4,
+			0x04, 0xb4, 0x05, 0xb4,
+			0x06, 0xb4, 0xbf, 0xc0,
+			0x00, 0x75, 0xd9, 0x49,
+			0x17, 0xf0, 0xb7, 0xc0,
+			0xb8, 0xc5, 0x00, 0x1e,
+			0x68, 0x23, 0x08, 0x9e,
+			0x0c, 0x9d, 0x82, 0x1c,
+			0x0e, 0x8c, 0x0e, 0x74,
+			0xcf, 0x49, 0xfe, 0xf1,
+			0xac, 0xc0, 0xad, 0xc5,
+			0x11, 0x1e, 0x68, 0x23,
+			0x08, 0x9e, 0x0c, 0x9d,
+			0x82, 0x1c, 0x0e, 0x8c,
+			0x0e, 0x74, 0xcf, 0x49,
+			0xfe, 0xf1, 0x06, 0xb0,
+			0x05, 0xb0, 0x04, 0xb0,
+			0x00, 0xb0, 0x80, 0xff,
+			0xa0, 0xc0, 0x00, 0x75,
+			0xd8, 0x49, 0x0d, 0xf0,
+			0x98, 0xc0, 0x98, 0xc5,
+			0x00, 0x1e, 0x08, 0x9e,
+			0x97, 0xc6, 0x0a, 0x9e,
+			0x0c, 0x9d, 0x8f, 0x1c,
+			0x0e, 0x8c, 0x0e, 0x74,
+			0xcf, 0x49, 0xfe, 0xf1,
+			0x04, 0xc0, 0x02, 0xc1,
+			0x00, 0xb9, 0x00, 0x1d,
+			0x20, 0xd4, 0xc8, 0xef,
+			0x8a, 0xc0, 0x00, 0x75,
+			0xd8, 0x48, 0x00, 0x9d,
+			0xc1, 0xc7, 0x15, 0xc2,
+			0xec, 0x9a, 0x00, 0x19,
+			0xe8, 0x9a, 0x81, 0x19,
+			0xee, 0x89, 0xee, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x2d, 0xc1, 0xec, 0x99,
+			0x81, 0x19, 0xee, 0x89,
+			0xee, 0x71, 0x9f, 0x49,
+			0xfe, 0xf1, 0x04, 0xc3,
+			0x02, 0xc2, 0x00, 0xba,
+			0x3a, 0x27, 0xc0, 0xd4,
+			0x24, 0xe4, 0xc0, 0x88,
+			0x1e, 0xc6, 0xc0, 0x70,
+			0x8f, 0x49, 0x0e, 0xf0,
+			0x8f, 0x48, 0x68, 0xc6,
+			0xca, 0x98, 0x11, 0x18,
+			0xc8, 0x98, 0x16, 0xc0,
+			0xcc, 0x98, 0x8f, 0x18,
+			0xce, 0x88, 0xce, 0x70,
+			0x8f, 0x49, 0xfe, 0xf1,
+			0x0b, 0xe0, 0x5c, 0xc6,
+			0x00, 0x18, 0xc8, 0x98,
+			0x0b, 0xc0, 0xcc, 0x98,
+			0x81, 0x18, 0xce, 0x88,
+			0xce, 0x70, 0x8f, 0x49,
+			0xfe, 0xf1, 0x02, 0xc0,
+			0x00, 0xb8, 0xbc, 0x21,
+			0x40, 0xd3, 0x20, 0xe4,
+			0x4c, 0xc2, 0x40, 0x71,
+			0x98, 0x48, 0x99, 0x48,
+			0x40, 0x99, 0x48, 0xc2,
+			0x00, 0x19, 0x98, 0x20,
+			0x48, 0x99, 0x1d, 0xc1,
+			0x4c, 0x99, 0x82, 0x19,
+			0x4e, 0x89, 0x4e, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x3d, 0xc2, 0x00, 0x19,
+			0x48, 0x99, 0xec, 0xc1,
+			0x4c, 0x99, 0x81, 0x19,
+			0x4e, 0x89, 0x4e, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x0b, 0xc1, 0x4c, 0x99,
+			0x81, 0x19, 0x4e, 0x89,
+			0x4e, 0x71, 0x9f, 0x49,
+			0xfe, 0xf1, 0x02, 0x71,
+			0x02, 0xc2, 0x00, 0xba,
+			0xfe, 0x4e, 0x24, 0xe4,
+			0x04, 0xe4, 0x25, 0xc2,
+			0x40, 0x71, 0x98, 0x48,
+			0x99, 0x48, 0x40, 0x99,
+			0x21, 0xc2, 0x00, 0x19,
+			0x98, 0x20, 0x48, 0x99,
+			0xf6, 0xc1, 0x4c, 0x99,
+			0x82, 0x19, 0x4e, 0x89,
+			0x4e, 0x71, 0x9f, 0x49,
+			0xfe, 0xf1, 0x16, 0xc2,
+			0x00, 0x19, 0x48, 0x99,
+			0xc5, 0xc1, 0x4c, 0x99,
+			0x81, 0x19, 0x4e, 0x89,
+			0x4e, 0x71, 0x9f, 0x49,
+			0xfe, 0xf1, 0xe4, 0xc1,
+			0x4c, 0x99, 0x81, 0x19,
+			0x4e, 0x89, 0x4e, 0x71,
+			0x9f, 0x49, 0xfe, 0xf1,
+			0x02, 0x71, 0x02, 0xc2,
+			0x00, 0xba, 0x00, 0x4e,
+			0x34, 0xd3, 0x00, 0xdc,
+			0x3d, 0xef, 0x18, 0xc0,
+			0x00, 0x72, 0xa8, 0x49,
+			0x0d, 0xf0, 0x11, 0xc0,
+			0x11, 0xc2, 0x00, 0x19,
+			0x08, 0x99, 0x0c, 0x9a,
+			0x0e, 0xc1, 0x0a, 0x99,
+			0x8f, 0x1b, 0x0e, 0x8b,
+			0x0e, 0x73, 0xbf, 0x49,
+			0xfe, 0xf1, 0x04, 0xc0,
+			0x02, 0xc2, 0x00, 0xba,
+			0x64, 0x62, 0x02, 0xcf,
+			0x00, 0xdc, 0x24, 0xe4,
+			0x80, 0x02, 0x34, 0xd3,
+			0x2c, 0xc3, 0x60, 0x70,
+			0x80, 0x49, 0xfd, 0xf0,
+			0x27, 0xc3, 0x66, 0x60,
+			0x80, 0x48, 0x02, 0x48,
+			0x66, 0x88, 0x00, 0x48,
+			0x82, 0x48, 0x66, 0x88,
+			0x1b, 0xc3, 0x60, 0x70,
+			0x17, 0xc4, 0x88, 0x98,
+			0x14, 0xc0, 0x8c, 0x98,
+			0x83, 0x18, 0x8e, 0x88,
+			0x8e, 0x70, 0x8f, 0x49,
+			0xfe, 0xf1, 0x62, 0x70,
+			0x8a, 0x98, 0x0d, 0xc0,
+			0x8c, 0x98, 0x84, 0x18,
+			0x8e, 0x88, 0x8e, 0x70,
+			0x8f, 0x49, 0xfe, 0xf1,
+			0x08, 0xc3, 0x02, 0xc4,
+			0x00, 0xbc, 0x68, 0x0f,
+			0x6c, 0xe9, 0x00, 0xdc,
+			0x50, 0xe8, 0x30, 0xc1,
+			0x36, 0xd3, 0x80, 0x10,
+			0x00, 0x00, 0x80, 0xd4,
+			0x26, 0xd8, 0x44, 0xc2,
+			0x4a, 0x41, 0x94, 0x20,
+			0x42, 0xc0, 0x16, 0x00,
+			0x00, 0x73, 0x40, 0xc4,
+			0x5c, 0x41, 0x8b, 0x41,
+			0x0b, 0x18, 0x38, 0xc6,
+			0xc0, 0x88, 0xc1, 0x99,
+			0x21, 0xe8, 0x35, 0xc0,
+			0x00, 0x73, 0xbd, 0x48,
+			0x0d, 0x18, 0x30, 0xc6,
+			0xc0, 0x88, 0xc1, 0x9b,
+			0x19, 0xe8, 0x2d, 0xc0,
+			0x02, 0x73, 0x35, 0x48,
+			0x0e, 0x18, 0x28, 0xc6,
+			0xc0, 0x88, 0xc1, 0x9b,
+			0x11, 0xe8, 0xdf, 0xc3,
+			0xdd, 0xc6, 0x01, 0x03,
+			0x1e, 0x40, 0xfe, 0xf1,
+			0x20, 0xc0, 0x02, 0x73,
+			0xb5, 0x48, 0x0e, 0x18,
+			0x1b, 0xc6, 0xc0, 0x88,
+			0xc1, 0x9b, 0x04, 0xe8,
+			0x02, 0xc6, 0x00, 0xbe,
+			0xb6, 0x10, 0x00, 0xb4,
+			0x01, 0xb4, 0x02, 0xb4,
+			0x03, 0xb4, 0x10, 0xc3,
+			0x0e, 0xc2, 0x61, 0x71,
+			0x40, 0x99, 0x60, 0x60,
+			0x0e, 0x48, 0x42, 0x98,
+			0x42, 0x70, 0x8e, 0x49,
+			0xfe, 0xf1, 0x03, 0xb0,
+			0x02, 0xb0, 0x01, 0xb0,
+			0x00, 0xb0, 0x80, 0xff,
+			0xc0, 0xd4, 0x8f, 0xcb,
+			0xaa, 0xc7, 0x1e, 0x00,
+			0x90, 0xc7, 0x1f, 0xfe,
+			0x0a, 0x10, 0x0c, 0xf0,
+			0x0b, 0x10, 0x0a, 0xf0,
+			0x0d, 0x10, 0x08, 0xf0,
+			0x0e, 0x10, 0x06, 0xf0,
+			0x24, 0x10, 0x04, 0xf0,
+			0x02, 0xc7, 0x00, 0xbf,
+			0x58, 0x11, 0x02, 0xc7,
+			0x00, 0xbf, 0x62, 0x11,
+			0xec, 0xc0, 0x02, 0x75,
+			0xd5, 0x48, 0x0e, 0x18,
+			0xe7, 0xc6, 0xc0, 0x88,
+			0xc1, 0x9d, 0xd0, 0xef,
+			0xe4, 0xc0, 0x02, 0x75,
+			0x55, 0x48, 0x0e, 0x18,
+			0xdf, 0xc6, 0xc0, 0x88,
+			0xc1, 0x9d, 0xc8, 0xef,
+			0x02, 0xc7, 0x00, 0xbf,
+			0x8e, 0x11, 0x16, 0xc0,
+			0xbb, 0x21, 0xb9, 0x25,
+			0x00, 0x71, 0x13, 0xc2,
+			0x4a, 0x41, 0x8b, 0x41,
+			0x24, 0x18, 0xd0, 0xc6,
+			0xc0, 0x88, 0xc1, 0x99,
+			0xb9, 0xef, 0x0a, 0xc0,
+			0x08, 0x71, 0x28, 0x18,
+			0xc9, 0xc6, 0xc0, 0x88,
+			0xc1, 0x99, 0xb2, 0xef,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x3c, 0x11, 0xd8, 0xc7,
+			0x83, 0xff, 0x01, 0xb4,
+			0x02, 0xb4, 0x03, 0xb4,
+			0x04, 0xb4, 0x05, 0xb4,
+			0x43, 0xc4, 0x44, 0xc0,
+			0x47, 0xc1, 0x81, 0x1b,
+			0xcd, 0xe8, 0x45, 0xc0,
+			0x43, 0xc2, 0x84, 0x1b,
+			0xc9, 0xe8, 0x58, 0xc0,
+			0x00, 0x1b, 0xc6, 0xe8,
+			0x80, 0x65, 0xdb, 0x22,
+			0xdd, 0x26, 0x03, 0x15,
+			0x12, 0xf1, 0x4d, 0xc0,
+			0x36, 0xc1, 0x81, 0x1b,
+			0xbd, 0xe8, 0x4a, 0xc0,
+			0x31, 0xc1, 0x88, 0x1b,
+			0xb9, 0xe8, 0x47, 0xc0,
+			0x48, 0xc1, 0x81, 0x1b,
+			0xb5, 0xe8, 0x04, 0x00,
+			0x45, 0xc1, 0x45, 0xc2,
+			0x8f, 0x1b, 0xb0, 0xe8,
+			0x24, 0xc0, 0x28, 0xc1,
+			0x2a, 0xc2, 0xac, 0xe8,
+			0x04, 0x00, 0x3e, 0xc1,
+			0x27, 0xc2, 0xa8, 0xe8,
+			0x04, 0x00, 0x2b, 0xc1,
+			0x2b, 0xc2, 0xa4, 0xe8,
+			0x04, 0x00, 0x29, 0xc1,
+			0x2b, 0xc2, 0xa0, 0xe8,
+			0x04, 0x00, 0x26, 0xc1,
+			0x26, 0xc2, 0x9c, 0xe8,
+			0x04, 0x00, 0x24, 0xc1,
+			0x21, 0xc2, 0x98, 0xe8,
+			0x04, 0x00, 0x21, 0xc1,
+			0x1f, 0xc2, 0x94, 0xe8,
+			0x04, 0x00, 0x1a, 0xc1,
+			0x1d, 0xc2, 0x90, 0xe8,
+			0x3d, 0xe0, 0x08, 0xdc,
+			0x3c, 0xe8, 0x14, 0xe8,
+			0x00, 0xf8, 0x00, 0x40,
+			0x00, 0x00, 0x01, 0x00,
+			0x9a, 0xd3, 0x04, 0xe0,
+			0x02, 0xe0, 0x0b, 0xe0,
+			0x0c, 0xe0, 0x25, 0xe0,
+			0xef, 0x1f, 0xa8, 0x8f,
+			0x02, 0xc7, 0x00, 0xbf,
+			0x76, 0x15, 0x66, 0x15,
+			0xa0, 0x49, 0x05, 0xf1,
+			0xa4, 0x49, 0x00, 0xbe,
+			0xca, 0x1a, 0x02, 0xc6,
+			0xe0, 0x1a, 0xce, 0x13,
+			0x80, 0xe0, 0xcb, 0xe0,
+			0xe0, 0xe8, 0x28, 0xdc,
+			0x13, 0x00, 0x08, 0x11,
+			0x42, 0x80, 0x0e, 0xe0,
+			0x06, 0xb4, 0x84, 0x76,
+			0x31, 0x40, 0x82, 0x71,
+			0x0c, 0xe8, 0x81, 0x24,
+			0x1f, 0x48, 0x84, 0x99,
+			0x08, 0xe8, 0x80, 0x49,
+			0x03, 0xf1, 0x80, 0x71,
+			0x80, 0xff, 0x85, 0x61,
+			0x96, 0x24, 0xfd, 0xf1,
+			0x06, 0xb0, 0x00, 0x11,
+			0x6c, 0x0f, 0x34, 0x1c,
+			0x28, 0xfc, 0x38, 0xfc,
+			0x0f, 0x00, 0xc8, 0x1a,
+			0xbe, 0x13, 0x04, 0x00,
+			0xe6, 0xc1, 0xea, 0xc2,
+			0x4f, 0xe8, 0x04, 0x00,
+			0xe3, 0xc1, 0xe3, 0xc2,
+			0x4b, 0xe8, 0x04, 0x00,
+			0xe8, 0xc1, 0xe0, 0xc2,
+			0x47, 0xe8, 0x04, 0x00,
+			0xc1, 0xc1, 0xdd, 0xc2,
+			0x43, 0xe8, 0x04, 0x00,
+			0xdb, 0xc1, 0xdb, 0xc2,
+			0x3f, 0xe8, 0x04, 0x00,
+			0xd9, 0xc1, 0xd9, 0xc2,
+			0x3b, 0xe8, 0x04, 0x00,
+			0xd7, 0xc1, 0xd7, 0xc2,
+			0x37, 0xe8, 0x04, 0x00,
+			0xd5, 0xc1, 0xaf, 0xc2,
+			0x33, 0xe8, 0x04, 0x00,
+			0xc9, 0xc1, 0xd5, 0xc2,
+			0x2f, 0xe8, 0x04, 0x00,
+			0xce, 0xc1, 0xce, 0xc2,
+			0x2b, 0xe8, 0x04, 0x00,
+			0xcc, 0xc1, 0xce, 0xc2,
+			0x27, 0xe8, 0x04, 0x00,
+			0xc9, 0xc1, 0xc5, 0xc2,
+			0x23, 0xe8, 0x04, 0x00,
+			0xa0, 0xc1, 0xa0, 0xc2,
+			0x1f, 0xe8, 0x04, 0x00,
+			0x9e, 0xc1, 0x9e, 0xc2,
+			0x1b, 0xe8, 0x04, 0x00,
+			0x9c, 0xc1, 0x83, 0x1b,
+			0x17, 0xe8, 0xbf, 0xc0,
+			0xc1, 0xc1, 0xc1, 0xc2,
+			0x8f, 0x1b, 0x12, 0xe8,
+			0x04, 0x00, 0xb8, 0xc1,
+			0x93, 0xc2, 0x8f, 0x1b,
+			0x0d, 0xe8, 0xb6, 0xc0,
+			0xb6, 0xc1, 0x81, 0x1b,
+			0x09, 0xe8, 0x05, 0xb0,
+			0x04, 0xb0, 0x03, 0xb0,
+			0x02, 0xb0, 0x01, 0xb0,
+			0x60, 0x70, 0xa9, 0xc3,
+			0x00, 0xbb, 0x84, 0x98,
+			0x80, 0x99, 0x82, 0x9a,
+			0x86, 0x8b, 0x86, 0x75,
+			0xdf, 0x49, 0xfe, 0xf1,
+			0x80, 0xff, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00};
+		static u8 pla_patch11[] = {
+			0x05, 0xe0, 0x0a, 0xe0,
+			0x38, 0xe0, 0x3a, 0xe0,
+			0x57, 0xe0, 0x05, 0xc2,
+			0x40, 0x76, 0x02, 0xc4,
+			0x00, 0xbc, 0xd6, 0x0b,
+			0x1e, 0xfc, 0x29, 0xc5,
+			0xa0, 0x77, 0x2b, 0xc4,
+			0xa0, 0x9c, 0x26, 0xc5,
+			0xa0, 0x64, 0x01, 0x14,
+			0x0b, 0xf0, 0x02, 0x14,
+			0x09, 0xf0, 0x01, 0x07,
+			0xf1, 0x49, 0x06, 0xf0,
+			0x21, 0xc7, 0xe0, 0x8e,
+			0x11, 0x1e, 0xe0, 0x8e,
+			0x14, 0xe0, 0x17, 0xc5,
+			0x00, 0x1f, 0xa0, 0x9f,
+			0x13, 0xc5, 0xa0, 0x77,
+			0xa0, 0x74, 0x46, 0x48,
+			0x47, 0x48, 0xa0, 0x9c,
+			0x11, 0xc5, 0xa0, 0x74,
+			0x44, 0x48, 0x43, 0x48,
+			0xa0, 0x9c, 0x08, 0xc5,
+			0xa0, 0x9f, 0x02, 0xc5,
+			0x00, 0xbd, 0xea, 0x03,
+			0x02, 0xc5, 0x00, 0xbd,
+			0xf6, 0x03, 0x1c, 0xe8,
+			0xaa, 0xd3, 0x08, 0xb7,
+			0x6c, 0xe8, 0x20, 0xe8,
+			0x00, 0xa0, 0x38, 0xe4,
+			0x02, 0xc5, 0x00, 0xbd,
+			0xcc, 0x06, 0xd4, 0x49,
+			0x17, 0xf0, 0x19, 0xc5,
+			0xa4, 0x64, 0xc1, 0x49,
+			0x07, 0xf1, 0x16, 0xc5,
+			0xa0, 0x64, 0xc7, 0x48,
+			0x46, 0x48, 0xa0, 0x8c,
+			0x06, 0xe0, 0x10, 0xc5,
+			0xa0, 0x64, 0x47, 0x48,
+			0xc6, 0x48, 0xa0, 0x8c,
+			0x0c, 0xc7, 0xe0, 0x8e,
+			0x11, 0x1e, 0xe0, 0x8e,
+			0x02, 0xc7, 0x00, 0xbf,
+			0x88, 0x04, 0x02, 0xc7,
+			0x00, 0xbf, 0xbe, 0x03,
+			0x5c, 0xdc, 0xf0, 0xd3,
+			0x20, 0xe4, 0xd2, 0x49,
+			0x08, 0xf1, 0xd3, 0x49,
+			0x55, 0xf1, 0xd4, 0x49,
+			0x1e, 0xf1, 0xd5, 0x49,
+			0x45, 0xf1, 0x4d, 0xe0,
+			0x5a, 0xc7, 0xe0, 0x72,
+			0xa0, 0x49, 0x05, 0xf0,
+			0x54, 0xc7, 0xe0, 0x72,
+			0xaf, 0x49, 0x0e, 0xf1,
+			0x53, 0xc7, 0xff, 0x1a,
+			0xe0, 0x9a, 0x51, 0xc2,
+			0xe4, 0x9a, 0x50, 0xc2,
+			0xe6, 0x9a, 0x01, 0x1a,
+			0xe0, 0x9a, 0x4d, 0xc2,
+			0xe4, 0x9a, 0x4a, 0xc2,
+			0xe6, 0x9a, 0x44, 0xc7,
+			0xe5, 0x8e, 0x00, 0x1d,
+			0xe5, 0x8d, 0x30, 0xe0,
+			0x38, 0xc7, 0xe0, 0x75,
+			0xda, 0x49, 0x1f, 0xf0,
+			0x35, 0xc7, 0xe0, 0x75,
+			0xdc, 0x49, 0x1b, 0xf1,
+			0x32, 0xc7, 0xe0, 0x75,
+			0xd5, 0x49, 0x17, 0xf0,
+			0x39, 0xc7, 0xe0, 0x75,
+			0xd8, 0x48, 0xd9, 0x48,
+			0xda, 0x48, 0xdb, 0x48,
+			0xe0, 0x9d, 0x2a, 0xc7,
+			0xe0, 0x75, 0xdb, 0x49,
+			0x03, 0xf1, 0xde, 0x49,
+			0x0d, 0xf0, 0x22, 0xc7,
+			0xe4, 0x75, 0xd0, 0x49,
+			0x09, 0xf1, 0x1f, 0xc5,
+			0xe6, 0x9d, 0x11, 0x1d,
+			0xe4, 0x8d, 0x04, 0xe0,
+			0x19, 0xc7, 0x00, 0x1d,
+			0xe4, 0x8d, 0xe0, 0x8e,
+			0x11, 0x1d, 0xe0, 0x8d,
+			0x07, 0xe0, 0x0f, 0xc7,
+			0xe0, 0x75, 0xda, 0x48,
+			0xe0, 0x9d, 0x0e, 0xc7,
+			0xe4, 0x8e, 0x02, 0xc4,
+			0x00, 0xbc, 0xd6, 0x03,
+			0x02, 0xc4, 0x00, 0xbc,
+			0xc2, 0x03, 0x02, 0xc4,
+			0x00, 0xbc, 0x5a, 0x04,
+			0x12, 0xe8, 0x4e, 0xe8,
+			0x08, 0xe9, 0x20, 0xe4,
+			0x80, 0x02, 0x9a, 0xc0,
+			0x4e, 0xe8, 0x00, 0xe4,
+			0x10, 0xe0, 0xe0, 0xe8,
+			0x80, 0x11, 0x02, 0x80,
+			0x30, 0x10, 0xb4, 0xc0};
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		generic_ocp_write(tp, 0xe600, 0xff, sizeof(usb_patch3_b),
+				  usb_patch3_b, MCU_TYPE_USB);
+
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0xa000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_0, 0x39d4);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_1, 0x3c98);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_2, 0x293c);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_3, 0x1cfe);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, 0x2738);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_5, 0x21ba);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_6, 0x4efc);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_7, 0x4dfe);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0x6262);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0x0f66);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0x1098);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0x1148);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0x116c);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0x10e0);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0x0f6a);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0x7fff);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd7, 0x04);
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+		ocp_data |= FW_IP_RESET_EN;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
+
+		ocp_write_dword(tp, MCU_TYPE_USB, USB_UPHY3_MDCMDIO, 0x4026840e);
+		ocp_write_dword(tp, MCU_TYPE_USB, USB_UPHY3_MDCMDIO, 0x4001acc9);
+
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(pla_patch11),
+				  pla_patch11, MCU_TYPE_PLA);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_BA, 0x8000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_0, 0x0bc2);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_1, 0x03e0);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_2, 0x06b8);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_3, 0x03ba);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_4, 0x03b2);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_5, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_6, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_7, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, 0x0017);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd6, 0x06);
+	} else if (tp->version == RTL_VER_12) {
+		static u8 usb_patch4_a[] = {
+			0x10, 0xe0, 0x38, 0xe0,
+			0x4e, 0xe0, 0x8b, 0xe0,
+			0xc1, 0xe0, 0xcd, 0xe0,
+			0xd5, 0xe0, 0xed, 0xe0,
+			0xf9, 0xe0, 0xfb, 0xe0,
+			0xfd, 0xe0, 0xff, 0xe0,
+			0x01, 0xe1, 0x03, 0xe1,
+			0x05, 0xe1, 0x07, 0xe1,
+			0x22, 0xc2, 0x4a, 0x41,
+			0x91, 0x20, 0x20, 0xc0,
+			0x16, 0x00, 0x00, 0x73,
+			0x1e, 0xc4, 0x5c, 0x41,
+			0x8b, 0x41, 0x1a, 0xc0,
+			0x1a, 0x00, 0x00, 0x73,
+			0xbd, 0x48, 0x0d, 0x18,
+			0x17, 0xc6, 0xc0, 0x88,
+			0xc1, 0x9b, 0x15, 0xe8,
+			0x0b, 0x18, 0x12, 0xc6,
+			0xc0, 0x88, 0xc1, 0x99,
+			0x10, 0xe8, 0x0c, 0xc0,
+			0x1c, 0x00, 0x00, 0x73,
+			0x0e, 0x18, 0x0a, 0xc6,
+			0xc0, 0x88, 0xc1, 0x9b,
+			0x08, 0xe8, 0x02, 0xc6,
+			0x00, 0xbe, 0x10, 0x12,
+			0xf0, 0x00, 0x90, 0xc7,
+			0x1f, 0xfe, 0x8f, 0xcb,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x66, 0x3f, 0x11, 0x21,
+			0x2b, 0x25, 0x13, 0xc4,
+			0xa2, 0x41, 0x80, 0x63,
+			0xf5, 0xc0, 0x48, 0x00,
+			0xbb, 0x21, 0xb9, 0x25,
+			0x00, 0x71, 0x0c, 0xc2,
+			0x4a, 0x41, 0x8b, 0x41,
+			0x24, 0x18, 0xee, 0xc6,
+			0xc0, 0x88, 0xc1, 0x99,
+			0xec, 0xef, 0x02, 0xc6,
+			0x00, 0xbe, 0x8a, 0x12,
+			0xa0, 0xf9, 0x83, 0xff,
+			0xd4, 0x18, 0x20, 0x88,
+			0x36, 0xe8, 0x22, 0x60,
+			0x85, 0x48, 0x06, 0x48,
+			0x21, 0x88, 0xf4, 0x18,
+			0x20, 0x88, 0x32, 0xe8,
+			0x2d, 0xc3, 0xc0, 0x18,
+			0x20, 0x88, 0x2b, 0xe8,
+			0x22, 0x60, 0x60, 0x88,
+			0xc1, 0x18, 0x20, 0x88,
+			0x26, 0xe8, 0x22, 0x60,
+			0x61, 0x88, 0xc2, 0x18,
+			0x20, 0x88, 0x21, 0xe8,
+			0x22, 0x60, 0x62, 0x88,
+			0xc3, 0x18, 0x20, 0x88,
+			0x1c, 0xe8, 0x22, 0x60,
+			0x63, 0x88, 0xc4, 0x18,
+			0x20, 0x88, 0x17, 0xe8,
+			0x22, 0x60, 0x64, 0x88,
+			0xc5, 0x18, 0x20, 0x88,
+			0x12, 0xe8, 0x22, 0x60,
+			0x65, 0x88, 0xc6, 0x18,
+			0x20, 0x88, 0x0d, 0xe8,
+			0x22, 0x60, 0x66, 0x88,
+			0xc7, 0x18, 0x20, 0x88,
+			0x08, 0xe8, 0x22, 0x60,
+			0x67, 0x88, 0xd4, 0x18,
+			0x02, 0xc5, 0x00, 0xbd,
+			0xc2, 0x35, 0xc0, 0xd3,
+			0x02, 0xc5, 0x00, 0xbd,
+			0xb2, 0x3e, 0x02, 0xc5,
+			0x00, 0xbd, 0x08, 0x3f,
+			0xd4, 0x18, 0xc0, 0x88,
+			0xf8, 0xef, 0xc2, 0x60,
+			0x85, 0x48, 0x06, 0x48,
+			0xc1, 0x88, 0xf4, 0x18,
+			0xc0, 0x88, 0xf4, 0xef,
+			0xef, 0xc3, 0x60, 0x60,
+			0xc1, 0x88, 0xe0, 0x18,
+			0xc0, 0x88, 0xee, 0xef,
+			0x61, 0x60, 0xc1, 0x88,
+			0xe1, 0x18, 0xc0, 0x88,
+			0xe9, 0xef, 0x62, 0x60,
+			0xc1, 0x88, 0xe2, 0x18,
+			0xc0, 0x88, 0xe4, 0xef,
+			0x63, 0x60, 0xc1, 0x88,
+			0xe3, 0x18, 0xc0, 0x88,
+			0xdf, 0xef, 0x64, 0x60,
+			0xc1, 0x88, 0xe4, 0x18,
+			0xc0, 0x88, 0xda, 0xef,
+			0x65, 0x60, 0xc1, 0x88,
+			0xe5, 0x18, 0xc0, 0x88,
+			0xd5, 0xef, 0x66, 0x60,
+			0xc1, 0x88, 0xe6, 0x18,
+			0xc0, 0x88, 0xd0, 0xef,
+			0x67, 0x60, 0xc1, 0x88,
+			0xe7, 0x18, 0xc0, 0x88,
+			0xcb, 0xef, 0xd4, 0x18,
+			0x02, 0xc2, 0x00, 0xba,
+			0x3a, 0x15, 0x0b, 0xc6,
+			0xc7, 0x65, 0xd0, 0x49,
+			0x05, 0xf1, 0x08, 0xc0,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x50, 0x2f, 0x02, 0xc7,
+			0x00, 0xbf, 0x56, 0x2f,
+			0x20, 0xd4, 0x00, 0xd4,
+			0x08, 0xc3, 0x60, 0x60,
+			0x03, 0x48, 0x60, 0x88,
+			0x00, 0x1b, 0x02, 0xc6,
+			0x00, 0xbe, 0xda, 0x2c,
+			0x60, 0xb4, 0x17, 0xc1,
+			0x17, 0xc2, 0x4c, 0x99,
+			0x00, 0x19, 0x4e, 0x89,
+			0x4f, 0x61, 0x97, 0x49,
+			0xfe, 0xf1, 0x48, 0x61,
+			0x01, 0xb4, 0x16, 0x48,
+			0x17, 0x48, 0x48, 0x89,
+			0x0a, 0xc1, 0x4c, 0x99,
+			0x81, 0x19, 0x4e, 0x89,
+			0x4f, 0x61, 0x97, 0x49,
+			0xfe, 0xf1, 0x02, 0xc0,
+			0x00, 0xb8, 0x32, 0x7c,
+			0x1c, 0xe8, 0x00, 0xdc,
+			0x01, 0xb0, 0xfe, 0xc2,
+			0x48, 0x89, 0xfb, 0xc1,
+			0x4c, 0x99, 0x81, 0x19,
+			0x4e, 0x89, 0x4f, 0x61,
+			0x97, 0x49, 0xfe, 0xf1,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x96, 0x7c, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x00, 0x00};
+		static u8 pla_patch4_a[] = {
+			0x08, 0xe0, 0x0c, 0xe0,
+			0x10, 0xe0, 0x3e, 0xe0,
+			0x40, 0xe0, 0x42, 0xe0,
+			0x44, 0xe0, 0x46, 0xe0,
+			0x03, 0xb4, 0x02, 0xb4,
+			0x02, 0xc7, 0x00, 0xbf,
+			0xb4, 0x03, 0x02, 0xb0,
+			0x03, 0xb0, 0x02, 0xc6,
+			0x00, 0xbe, 0x8c, 0x05,
+			0xaf, 0x49, 0x17, 0xf1,
+			0x20, 0xc6, 0x00, 0x1a,
+			0x23, 0xe8, 0x21, 0xc6,
+			0xc0, 0x61, 0x91, 0x49,
+			0x0c, 0xf0, 0x95, 0x49,
+			0x0a, 0xf1, 0x14, 0x48,
+			0x16, 0xc6, 0x81, 0x1a,
+			0x19, 0xe8, 0x14, 0xc6,
+			0xc0, 0x62, 0x24, 0x48,
+			0xc0, 0x8a, 0x0c, 0xe0,
+			0x10, 0xc6, 0xc0, 0x62,
+			0xa5, 0x49, 0x08, 0xf1,
+			0x0d, 0xc6, 0xc0, 0x62,
+			0xa0, 0x48, 0xc0, 0x8a,
+			0xc2, 0x62, 0xa3, 0x48,
+			0xc2, 0x8a, 0x02, 0xc6,
+			0x00, 0xbe, 0xd2, 0x16,
+			0x84, 0xd2, 0x6a, 0xdc,
+			0x90, 0xd3, 0x66, 0xb4,
+			0x08, 0xea, 0xff, 0xc0,
+			0x04, 0x9e, 0x00, 0x99,
+			0x06, 0x8a, 0x06, 0x72,
+			0xaf, 0x49, 0xfe, 0xf1,
+			0x80, 0xff, 0x02, 0xc6,
+			0x00, 0xbe, 0x00, 0x00,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x00, 0x00, 0x02, 0xc6,
+			0x00, 0xbe, 0x00, 0x00,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x00, 0x00, 0x02, 0xc6,
+			0x00, 0xbe, 0x00, 0x00};
+
+		rtl_clear_bp(tp, MCU_TYPE_USB);
+
+		generic_ocp_write(tp, 0xe600, 0xff, sizeof(usb_patch4_a),
+				  usb_patch4_a, MCU_TYPE_USB);
+
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0xc000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_0, 0x11e2);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_1, 0x1268);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_2, 0x35c0);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_3, 0x1538);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, 0x2f4e);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_5, 0x2cd8);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_6, 0x7c26);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_7, 0x7c90);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0x0000);
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0x00df);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd7, 0x02);
+
+//		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+//		ocp_data |= FW_IP_RESET_EN;
+//		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
+
+//		ocp_write_dword(tp, MCU_TYPE_USB, 0xd480, 0x4026840e);
+//		ocp_write_dword(tp, MCU_TYPE_USB, 0xd480, 0x4001acc9);
+
+		rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+		generic_ocp_write(tp, 0xf800, 0xff, sizeof(pla_patch4_a),
+				  pla_patch4_a, MCU_TYPE_PLA);
+
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_BA, 0x8000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_0, 0x03b2);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_1, 0x058a);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_2, 0x16c0);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_3, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_4, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_5, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_6, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_7, 0x0000);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, 0x0007);
+		ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd6, 0x02);
+	} else if (tp->version == RTL_VER_13 || tp->version == RTL_VER_15) {
+		static u8 usb_patch_13[] = {
+			0x10, 0xe0, 0x25, 0xe0,
+			0x29, 0xe0, 0x2d, 0xe0,
+			0x52, 0xe0, 0xff, 0xe0,
+			0x02, 0xe1, 0x06, 0xe1,
+			0x16, 0xe1, 0x18, 0xe1,
+			0x39, 0xe1, 0x52, 0xe1,
+			0x54, 0xe1, 0x56, 0xe1,
+			0x58, 0xe1, 0x5a, 0xe1,
+			0x13, 0xc3, 0x60, 0x70,
+			0x8b, 0x49, 0x0d, 0xf1,
+			0x10, 0xc3, 0x60, 0x60,
+			0x85, 0x49, 0x09, 0xf1,
+			0x40, 0x03, 0x64, 0x60,
+			0x82, 0x49, 0x05, 0xf1,
+			0x09, 0xc3, 0x60, 0x60,
+			0x80, 0x48, 0x60, 0x88,
+			0x02, 0xc0, 0x00, 0xb8,
+			0xde, 0x0f, 0xca, 0xcf,
+			0x00, 0xd8, 0x1e, 0xb4,
+			0x04, 0xc3, 0x02, 0xc0,
+			0x00, 0xb8, 0x62, 0x36,
+			0xc8, 0xd3, 0x04, 0xc3,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x7a, 0x14, 0xc8, 0xd3,
+			0x00, 0xb4, 0x01, 0xb4,
+			0x02, 0xb4, 0x03, 0xb4,
+			0x1f, 0xc1, 0x02, 0x1b,
+			0x2c, 0x8b, 0x0c, 0x62,
+			0xa7, 0x49, 0x0a, 0xf1,
+			0x00, 0x1b, 0x08, 0x72,
+			0x13, 0x40, 0x04, 0xf1,
+			0x0a, 0x72, 0x13, 0x40,
+			0x03, 0xf0, 0x01, 0x1b,
+			0x2c, 0x8b, 0x12, 0xc0,
+			0x01, 0x1a, 0x08, 0x8a,
+			0x0a, 0x8a, 0x0d, 0xc0,
+			0x12, 0x71, 0x19, 0x48,
+			0x1a, 0x48, 0x12, 0x99,
+			0x03, 0xb0, 0x02, 0xb0,
+			0x01, 0xb0, 0x00, 0xb0,
+			0x02, 0xc0, 0x00, 0xb8,
+			0xb0, 0x77, 0x20, 0xc3,
+			0x18, 0xb4, 0x80, 0xcb,
+			0x00, 0xb4, 0x01, 0xb4,
+			0x02, 0xb4, 0x03, 0xb4,
+			0x07, 0xb4, 0x23, 0xc0,
+			0x24, 0xc1, 0x08, 0x1a,
+			0x2a, 0x8a, 0x24, 0x01,
+			0x0d, 0x1a, 0x20, 0x9a,
+			0x24, 0x09, 0x00, 0x1a,
+			0x22, 0x9a, 0x04, 0x72,
+			0x06, 0x73, 0x18, 0xc7,
+			0xe4, 0x9a, 0xe6, 0x9b,
+			0x17, 0xc2, 0x17, 0xc3,
+			0xe0, 0x9a, 0xe2, 0x9b,
+			0x80, 0x1b, 0x32, 0x8b,
+			0x00, 0x1a, 0x24, 0x9f,
+			0x26, 0x9a, 0x01, 0x1a,
+			0x28, 0x8a, 0x0f, 0xe8,
+			0x07, 0xb0, 0x03, 0xb0,
+			0x02, 0xb0, 0x01, 0xb0,
+			0x00, 0xb0, 0x02, 0xc6,
+			0x00, 0xbe, 0xe6, 0x60,
+			0x00, 0xc3, 0x20, 0xc3,
+			0x80, 0xcb, 0x55, 0x53,
+			0x42, 0x53, 0x80, 0xcb,
+			0x03, 0xb4, 0x06, 0xb4,
+			0x07, 0xb4, 0xfc, 0xc7,
+			0x79, 0xc7, 0xe0, 0x73,
+			0xba, 0x49, 0x0d, 0xf0,
+			0xf7, 0xc6, 0x24, 0x06,
+			0xc0, 0x77, 0xfa, 0x25,
+			0x76, 0x23, 0x66, 0x27,
+			0x70, 0xc7, 0xe1, 0x9e,
+			0x00, 0x16, 0x10, 0xf0,
+			0x01, 0x03, 0x0e, 0xe0,
+			0xb9, 0x49, 0x10, 0xf0,
+			0xe9, 0xc6, 0x24, 0x06,
+			0xc0, 0x77, 0xf9, 0x25,
+			0x77, 0x23, 0x67, 0x27,
+			0x62, 0xc7, 0xe1, 0x9e,
+			0x00, 0x16, 0x02, 0xf0,
+			0x01, 0x03, 0x5e, 0xc7,
+			0xe0, 0x8b, 0x12, 0xe8,
+			0x0d, 0xe0, 0xda, 0xc6,
+			0x24, 0x06, 0xc0, 0x77,
+			0xf6, 0x25, 0x7a, 0x23,
+			0x6a, 0x27, 0x53, 0xc7,
+			0xe1, 0x9e, 0x00, 0x16,
+			0xf3, 0xf0, 0x01, 0x03,
+			0xf1, 0xe7, 0x07, 0xb0,
+			0x06, 0xb0, 0x03, 0xb0,
+			0x80, 0xff, 0x03, 0xb4,
+			0x06, 0xb4, 0x07, 0xb4,
+			0xc7, 0xc6, 0xc4, 0x77,
+			0x40, 0xc3, 0x7c, 0x9f,
+			0x41, 0xc6, 0xc0, 0x73,
+			0xba, 0x49, 0x05, 0xf1,
+			0x00, 0x13, 0x05, 0xf1,
+			0x39, 0xc3, 0x04, 0xe0,
+			0x38, 0xc3, 0x02, 0xe0,
+			0x40, 0x1b, 0xb8, 0xc6,
+			0xfb, 0x31, 0xc4, 0x9f,
+			0x35, 0xc6, 0xc0, 0x67,
+			0x01, 0x17, 0x07, 0xfc,
+			0x30, 0xc6, 0xc1, 0x77,
+			0x01, 0x1b, 0xc0, 0x8b,
+			0x00, 0x17, 0x0c, 0xf1,
+			0x29, 0xc6, 0xc0, 0x73,
+			0xba, 0x49, 0x05, 0xf1,
+			0xb9, 0x49, 0x05, 0xf0,
+			0x21, 0xc7, 0x04, 0xe0,
+			0x20, 0xc7, 0x02, 0xe0,
+			0x40, 0x1f, 0x1a, 0xc6,
+			0x7e, 0x41, 0x1d, 0xc6,
+			0xc0, 0x63, 0xbb, 0x21,
+			0xbb, 0x41, 0x15, 0xc3,
+			0x66, 0x9f, 0x18, 0xc6,
+			0xc0, 0x67, 0xf9, 0x3b,
+			0xc0, 0x8f, 0x01, 0x17,
+			0x03, 0xfd, 0x00, 0x1f,
+			0x02, 0xe0, 0x01, 0x1f,
+			0x0e, 0xc6, 0xc0, 0x8f,
+			0x08, 0xc3, 0x04, 0x1e,
+			0x60, 0x8e, 0x07, 0xb0,
+			0x06, 0xb0, 0x03, 0xb0,
+			0x80, 0xff, 0xff, 0x07,
+			0x40, 0xd4, 0x00, 0x02,
+			0x00, 0x04, 0x80, 0xb9,
+			0xfd, 0xcb, 0xa2, 0xcb,
+			0xe8, 0x74, 0x02, 0xc5,
+			0x00, 0xbd, 0x96, 0x6d,
+			0x04, 0xc4, 0x02, 0xc3,
+			0x00, 0xbb, 0x50, 0x28,
+			0x7f, 0x00, 0x00, 0x1e,
+			0x00, 0x11, 0x0c, 0xf0,
+			0x90, 0x49, 0x04, 0xf1,
+			0x01, 0x06, 0x91, 0x24,
+			0xfa, 0xe7, 0x28, 0x32,
+			0x06, 0x43, 0xf8, 0x31,
+			0x01, 0x06, 0x91, 0x24,
+			0xf4, 0xe7, 0x02, 0xc0,
+			0x00, 0xb8, 0x0e, 0x28,
+			0x02, 0xc7, 0x00, 0xbf,
+			0x48, 0x31, 0x1c, 0xc6,
+			0xc0, 0x61, 0x04, 0x11,
+			0x15, 0xf1, 0x19, 0xc6,
+			0xc0, 0x61, 0x9c, 0x20,
+			0x9c, 0x24, 0x09, 0x11,
+			0x0f, 0xf1, 0x14, 0xc6,
+			0x01, 0x19, 0xc0, 0x89,
+			0x13, 0xc1, 0x13, 0xc6,
+			0x24, 0x9e, 0x00, 0x1e,
+			0x26, 0x8e, 0x26, 0x76,
+			0xef, 0x49, 0xfe, 0xf1,
+			0x22, 0x76, 0x08, 0xc1,
+			0x22, 0x9e, 0x07, 0xc6,
+			0x02, 0xc1, 0x00, 0xb9,
+			0xae, 0x09, 0x18, 0xb4,
+			0x4a, 0xb4, 0xe0, 0xcc,
+			0x80, 0xd4, 0x08, 0xdc,
+			0x10, 0xe8, 0xfc, 0xc6,
+			0xc0, 0x67, 0xf0, 0x49,
+			0x13, 0xf0, 0xf0, 0x48,
+			0xc0, 0x8f, 0xc2, 0x77,
+			0xf7, 0xc1, 0xf7, 0xc6,
+			0x24, 0x9e, 0x22, 0x9f,
+			0x8c, 0x1e, 0x26, 0x8e,
+			0x26, 0x76, 0xef, 0x49,
+			0xfe, 0xf1, 0xfb, 0x49,
+			0x05, 0xf0, 0x07, 0xc6,
+			0xc0, 0x61, 0x10, 0x48,
+			0xc0, 0x89, 0x02, 0xc6,
+			0x00, 0xbe, 0x06, 0x5f,
+			0x6c, 0xb4, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x00, 0x00, 0x02, 0xc0,
+			0x00, 0xb8, 0x00, 0x00};
+		static u8 pla_patch_13[] = {
+			0x08, 0xe0, 0x14, 0xe0,
+			0x18, 0xe0, 0x32, 0xe0,
+			0xc8, 0xe0, 0xd4, 0xe0,
+			0x0e, 0xe1, 0x10, 0xe1,
+			0x0c, 0xc4, 0x04, 0x40,
+			0x05, 0xf0, 0x8c, 0x26,
+			0x0b, 0x15, 0x02, 0xf0,
+			0x03, 0xe0, 0x00, 0x9a,
+			0x01, 0xe0, 0x02, 0xc4,
+			0x00, 0xbc, 0x36, 0x37,
+			0x6c, 0xe8, 0x3a, 0x73,
+			0xbb, 0x49, 0x02, 0xc6,
+			0x00, 0xbe, 0xde, 0x27,
+			0x3a, 0x73, 0xb5, 0x21,
+			0xbc, 0x25, 0x04, 0x13,
+			0x11, 0xf1, 0x12, 0x1b,
+			0x2a, 0x1d, 0x68, 0x31,
+			0xda, 0x3a, 0xab, 0x31,
+			0x00, 0x1a, 0xc0, 0x9a,
+			0x00, 0x13, 0xfb, 0xf1,
+			0x20, 0x76, 0x6e, 0x23,
+			0x6f, 0x27, 0x3c, 0x1a,
+			0xa1, 0x22, 0xb5, 0x41,
+			0xe2, 0x9e, 0xe4, 0x76,
+			0x6f, 0x48, 0xe4, 0x9e,
+			0x02, 0xc6, 0x00, 0xbe,
+			0x62, 0x2a, 0x87, 0x49,
+			0x62, 0xf0, 0x03, 0x1b,
+			0x58, 0x41, 0x33, 0xf0,
+			0x20, 0x73, 0x0b, 0xc5,
+			0xa4, 0x74, 0xc0, 0x49,
+			0x1b, 0xf1, 0x08, 0xc4,
+			0x14, 0x40, 0x07, 0xf1,
+			0x01, 0x1c, 0xa6, 0x9c,
+			0xa0, 0x9b, 0x27, 0xe0,
+			0xb8, 0xd3, 0x6c, 0xe8,
+			0x2c, 0x26, 0x0b, 0x14,
+			0x0f, 0xf1, 0x70, 0xc4,
+			0xa6, 0x73, 0xb0, 0x49,
+			0x08, 0xf0, 0xb0, 0x48,
+			0xa6, 0x9b, 0xa0, 0x73,
+			0x80, 0x9b, 0x20, 0x73,
+			0x40, 0x83, 0x17, 0xe0,
+			0x20, 0x73, 0x40, 0x83,
+			0x14, 0xe0, 0x70, 0xc4,
+			0x22, 0x40, 0x0a, 0xf1,
+			0x38, 0x22, 0x48, 0x26,
+			0xe8, 0x14, 0x06, 0xfb,
+			0x6b, 0xc4, 0x80, 0x74,
+			0xca, 0x49, 0x02, 0xf1,
+			0xbe, 0x48, 0x40, 0x83,
+			0x56, 0xc4, 0x22, 0x40,
+			0x57, 0xf0, 0x54, 0xc4,
+			0x22, 0x40, 0x57, 0xf0,
+			0x0c, 0x1b, 0x58, 0x41,
+			0x57, 0xf0, 0x02, 0x24,
+			0x03, 0x1b, 0x58, 0x41,
+			0x53, 0xf0, 0x47, 0xc5,
+			0xa4, 0x74, 0xc0, 0x49,
+			0x0e, 0xf1, 0x2c, 0x26,
+			0x0b, 0x14, 0x0b, 0xf1,
+			0x41, 0xc4, 0x80, 0x73,
+			0xa2, 0x9b, 0xa0, 0x73,
+			0x80, 0x9b, 0x22, 0x73,
+			0x42, 0x83, 0xa2, 0x73,
+			0x80, 0x9b, 0x42, 0xe0,
+			0x22, 0x73, 0x45, 0xc4,
+			0x22, 0x40, 0x0a, 0xf1,
+			0x39, 0x22, 0x4e, 0x26,
+			0x03, 0x14, 0x06, 0xf1,
+			0x3f, 0xc4, 0x80, 0x74,
+			0xca, 0x49, 0x02, 0xf1,
+			0xbe, 0x48, 0x42, 0x83,
+			0x2a, 0xc4, 0x22, 0x40,
+			0x31, 0xf1, 0x29, 0xc4,
+			0x82, 0x83, 0x2e, 0xe0,
+			0x22, 0xc5, 0xa4, 0x74,
+			0xc0, 0x49, 0x12, 0xf1,
+			0x2c, 0x26, 0x0b, 0x14,
+			0x0f, 0xf1, 0x1b, 0xc5,
+			0x1b, 0xc4, 0xa6, 0x73,
+			0xb0, 0x49, 0x05, 0xf0,
+			0xb0, 0x48, 0xa6, 0x9b,
+			0xa0, 0x73, 0x80, 0x9b,
+			0x40, 0x73, 0x20, 0x9b,
+			0x42, 0x73, 0x22, 0x9b,
+			0x19, 0xe0, 0x86, 0x49,
+			0x03, 0xf0, 0x84, 0x49,
+			0x03, 0xf0, 0x40, 0x73,
+			0x20, 0x9b, 0x86, 0x49,
+			0x03, 0xf0, 0x85, 0x49,
+			0x0f, 0xf0, 0x42, 0x73,
+			0x22, 0x9b, 0x0c, 0xe0,
+			0xb8, 0xd3, 0x6c, 0xe8,
+			0x00, 0xc0, 0x04, 0xc0,
+			0x82, 0xcc, 0xff, 0xc4,
+			0x80, 0x83, 0xab, 0xe7,
+			0xfc, 0xc4, 0x84, 0x83,
+			0xa8, 0xe7, 0x02, 0xc5,
+			0x00, 0xbd, 0x66, 0x0a,
+			0x00, 0xea, 0x04, 0xdd,
+			0x02, 0xdd, 0x5a, 0xe8,
+			0x04, 0xe8, 0x02, 0xc1,
+			0x00, 0xb9, 0xac, 0x35,
+			0x08, 0xc1, 0x20, 0x70,
+			0x87, 0x48, 0x20, 0x98,
+			0x36, 0x70, 0x80, 0x48,
+			0x36, 0x98, 0x80, 0xff,
+			0xd4, 0xb5, 0x04, 0x10,
+			0x07, 0xf1, 0x27, 0xc1,
+			0x32, 0x70, 0x89, 0x48,
+			0x32, 0x98, 0xf1, 0xef,
+			0x18, 0xe0, 0x05, 0x10,
+			0x07, 0xf1, 0x1f, 0xc1,
+			0x32, 0x70, 0x89, 0x48,
+			0x32, 0x98, 0x1d, 0xe8,
+			0x10, 0xe0, 0x06, 0x10,
+			0x07, 0xf1, 0x17, 0xc1,
+			0x32, 0x70, 0x09, 0x48,
+			0x32, 0x98, 0x15, 0xe8,
+			0x08, 0xe0, 0x07, 0x10,
+			0x0d, 0xf1, 0x0f, 0xc1,
+			0x32, 0x70, 0x09, 0x48,
+			0x32, 0x98, 0x15, 0xe8,
+			0x0b, 0xc1, 0x28, 0x70,
+			0x09, 0x48, 0x28, 0x98,
+			0x02, 0xc1, 0x00, 0xb9,
+			0x44, 0x36, 0x02, 0xc1,
+			0x00, 0xb9, 0x52, 0x36,
+			0x00, 0xb4, 0x20, 0xb4,
+			0xd4, 0xc1, 0x20, 0x70,
+			0x87, 0x48, 0x20, 0x98,
+			0x36, 0x70, 0x00, 0x48,
+			0x36, 0x98, 0x80, 0xff,
+			0xcc, 0xc1, 0x20, 0x70,
+			0x07, 0x48, 0x20, 0x98,
+			0x36, 0x70, 0x00, 0x48,
+			0x36, 0x98, 0x80, 0xff,
+			0x02, 0xc0, 0x00, 0xb8,
+			0x3a, 0x4e, 0x02, 0xc0,
+			0x00, 0xb8, 0x3a, 0x4e};
+
+		if (ocp_read_byte(tp, MCU_TYPE_USB, 0xcfd7) < 0x04) {
+			rtl_clear_bp(tp, MCU_TYPE_USB);
+
+			generic_ocp_write(tp, 0xe600, 0xff,
+					  sizeof(usb_patch_13),
+					  usb_patch_13, MCU_TYPE_USB);
+
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_BA, 0xc000);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_0, 0x0fba);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_1, 0x3660);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_2, 0x1478);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_3, 0x77ae);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, 0x60e0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_5, 0x6d94);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_6, 0x284e);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_7, 0x27f6);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0x3140);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0x09ac);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0x5e2a);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0x0000);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0x0000);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0x0000);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0x0000);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0x0000);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0x07ff);
+			ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd7, 0x04);
+		}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_RSTTALLY);
-	ocp_data |= TALLY_RESET;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_RSTTALLY, ocp_data);
+		if (ocp_read_byte(tp, MCU_TYPE_USB, 0xcfd6) < 0x06) {
+			rtl_clear_bp(tp, MCU_TYPE_PLA);
+
+			generic_ocp_write(tp, 0xf800, 0xff,
+					  sizeof(pla_patch_13),
+					  pla_patch_13, MCU_TYPE_PLA);
+
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_BA, 0x8000);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_0, 0x374e);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_1, 0x27dc);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_2, 0x2a5c);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_3, 0x09d0);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_4, 0x359e);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_5, 0x35b6);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_6, 0x0000);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_7, 0x0000);
+			ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, 0x003f);
+			ocp_write_byte(tp, MCU_TYPE_USB, 0xcfd6, 0x06);
+		}
+	}
+
+	rtl_reset_ocp_base(tp);
 }
 
-static void r8152b_init(struct r8152 *tp)
+static void rtl_ram_code_speed_up(struct r8152 *tp, bool wait)
 {
-	u32 ocp_data;
-	u16 data;
+	u32 ocp_data, len = 0;
+	u8 *data = NULL;
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+	rtl_reset_ocp_base(tp);
 
-	data = r8152_mdio_read(tp, MII_BMCR);
-	if (data & BMCR_PDOWN) {
-		data &= ~BMCR_PDOWN;
-		r8152_mdio_write(tp, MII_BMCR, data);
+	if (tp->version == RTL_VER_13 || tp->version == RTL_VER_15) {
+		static u8 ram13[] = {
+			0x6c, 0xe8, 0x00, 0xa0,
+			0x36, 0xb4, 0x24, 0x80,
+			0x38, 0xb4, 0x01, 0x37,
+			0x36, 0xb4, 0x2e, 0xb8,
+			0x38, 0xb4, 0x01, 0x00,
+			0x6c, 0xe8, 0x00, 0xb0,
+			0x20, 0xb8, 0x90, 0x00,
+			0x6c, 0xe8, 0x00, 0xa0,
+			0x36, 0xb4, 0x16, 0xa0,
+			0x38, 0xb4, 0x00, 0x00,
+			0x36, 0xb4, 0x12, 0xa0,
+			0x38, 0xb4, 0x00, 0x00,
+			0x36, 0xb4, 0x14, 0xa0,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x10, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x1a, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x3f, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x45, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x67, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x6d, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x71, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0xb1, 0x80,
+			0x38, 0xb4, 0x93, 0xd0,
+			0x38, 0xb4, 0xc4, 0xd1,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x5c, 0x13,
+			0x38, 0xb4, 0x04, 0xd7,
+			0x38, 0xb4, 0xbc, 0x5f,
+			0x38, 0xb4, 0x04, 0xd5,
+			0x38, 0xb4, 0xf1, 0xc9,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0xc9, 0x0f,
+			0x38, 0xb4, 0x50, 0xbb,
+			0x38, 0xb4, 0x05, 0xd5,
+			0x38, 0xb4, 0x02, 0xa2,
+			0x38, 0xb4, 0x04, 0xd5,
+			0x38, 0xb4, 0x0f, 0x8c,
+			0x38, 0xb4, 0x00, 0xd5,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x19, 0x15,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x5c, 0x13,
+			0x38, 0xb4, 0x5e, 0xd7,
+			0x38, 0xb4, 0xae, 0x5f,
+			0x38, 0xb4, 0x50, 0x9b,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x5c, 0x13,
+			0x38, 0xb4, 0x5e, 0xd7,
+			0x38, 0xb4, 0xae, 0x7f,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x5c, 0x13,
+			0x38, 0xb4, 0x07, 0xd7,
+			0x38, 0xb4, 0xa7, 0x40,
+			0x38, 0xb4, 0x19, 0xd7,
+			0x38, 0xb4, 0x71, 0x40,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x57, 0x15,
+			0x38, 0xb4, 0x19, 0xd7,
+			0x38, 0xb4, 0x70, 0x2f,
+			0x38, 0xb4, 0x3b, 0x80,
+			0x38, 0xb4, 0x73, 0x2f,
+			0x38, 0xb4, 0x6a, 0x15,
+			0x38, 0xb4, 0x70, 0x5e,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x5d, 0x15,
+			0x38, 0xb4, 0x05, 0xd5,
+			0x38, 0xb4, 0x02, 0xa2,
+			0x38, 0xb4, 0x00, 0xd5,
+			0x38, 0xb4, 0xed, 0xff,
+			0x38, 0xb4, 0x09, 0xd7,
+			0x38, 0xb4, 0x54, 0x40,
+			0x38, 0xb4, 0x88, 0xa7,
+			0x38, 0xb4, 0x0b, 0xd7,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2a, 0x17,
+			0x38, 0xb4, 0xc1, 0xc0,
+			0x38, 0xb4, 0xc0, 0xc0,
+			0x38, 0xb4, 0x5a, 0xd0,
+			0x38, 0xb4, 0xba, 0xd1,
+			0x38, 0xb4, 0x01, 0xd7,
+			0x38, 0xb4, 0x29, 0x25,
+			0x38, 0xb4, 0x2a, 0x02,
+			0x38, 0xb4, 0xa7, 0xd0,
+			0x38, 0xb4, 0xb9, 0xd1,
+			0x38, 0xb4, 0x08, 0xa2,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x0e, 0x08,
+			0x38, 0xb4, 0x01, 0xd7,
+			0x38, 0xb4, 0x8b, 0x40,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x65, 0x0a,
+			0x38, 0xb4, 0x03, 0xf0,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x6b, 0x0a,
+			0x38, 0xb4, 0x01, 0xd7,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x20, 0x09,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x15, 0x09,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x09, 0x09,
+			0x38, 0xb4, 0x8f, 0x22,
+			0x38, 0xb4, 0x4e, 0x80,
+			0x38, 0xb4, 0x01, 0x98,
+			0x38, 0xb4, 0x1e, 0xd7,
+			0x38, 0xb4, 0x61, 0x5d,
+			0x38, 0xb4, 0x01, 0xd7,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2a, 0x02,
+			0x38, 0xb4, 0x05, 0x20,
+			0x38, 0xb4, 0x1a, 0x09,
+			0x38, 0xb4, 0xd9, 0x3b,
+			0x38, 0xb4, 0x19, 0x09,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x16, 0x09,
+			0x38, 0xb4, 0x90, 0xd0,
+			0x38, 0xb4, 0xc9, 0xd1,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x64, 0x10,
+			0x38, 0xb4, 0x96, 0xd0,
+			0x38, 0xb4, 0xa9, 0xd1,
+			0x38, 0xb4, 0x03, 0xd5,
+			0x38, 0xb4, 0x04, 0xa1,
+			0x38, 0xb4, 0x07, 0x0c,
+			0x38, 0xb4, 0x02, 0x09,
+			0x38, 0xb4, 0x00, 0xd5,
+			0x38, 0xb4, 0x10, 0xbc,
+			0x38, 0xb4, 0x01, 0xd5,
+			0x38, 0xb4, 0x01, 0xce,
+			0x38, 0xb4, 0x01, 0xa2,
+			0x38, 0xb4, 0x01, 0x82,
+			0x38, 0xb4, 0x00, 0xce,
+			0x38, 0xb4, 0x00, 0xd5,
+			0x38, 0xb4, 0x84, 0xc4,
+			0x38, 0xb4, 0x03, 0xd5,
+			0x38, 0xb4, 0x02, 0xcc,
+			0x38, 0xb4, 0x0d, 0xcd,
+			0x38, 0xb4, 0x01, 0xaf,
+			0x38, 0xb4, 0x00, 0xd5,
+			0x38, 0xb4, 0x03, 0xd7,
+			0x38, 0xb4, 0x71, 0x43,
+			0x38, 0xb4, 0x08, 0xbd,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x5c, 0x13,
+			0x38, 0xb4, 0x5e, 0xd7,
+			0x38, 0xb4, 0xb3, 0x5f,
+			0x38, 0xb4, 0x03, 0xd5,
+			0x38, 0xb4, 0xf5, 0xd0,
+			0x38, 0xb4, 0xc6, 0xd1,
+			0x38, 0xb4, 0xf0, 0x0c,
+			0x38, 0xb4, 0x50, 0x0e,
+			0x38, 0xb4, 0x04, 0xd7,
+			0x38, 0xb4, 0x1c, 0x40,
+			0x38, 0xb4, 0xf5, 0xd0,
+			0x38, 0xb4, 0xc6, 0xd1,
+			0x38, 0xb4, 0xf0, 0x0c,
+			0x38, 0xb4, 0xa0, 0x0e,
+			0x38, 0xb4, 0x1c, 0x40,
+			0x38, 0xb4, 0x7b, 0xd0,
+			0x38, 0xb4, 0xc5, 0xd1,
+			0x38, 0xb4, 0xf0, 0x8e,
+			0x38, 0xb4, 0x1c, 0x40,
+			0x38, 0xb4, 0x08, 0x9d,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x5c, 0x13,
+			0x38, 0xb4, 0x5e, 0xd7,
+			0x38, 0xb4, 0xb3, 0x7f,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x5c, 0x13,
+			0x38, 0xb4, 0x5e, 0xd7,
+			0x38, 0xb4, 0xad, 0x5f,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0xc5, 0x14,
+			0x38, 0xb4, 0x03, 0xd7,
+			0x38, 0xb4, 0x81, 0x31,
+			0x38, 0xb4, 0xaf, 0x80,
+			0x38, 0xb4, 0xad, 0x60,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x5c, 0x13,
+			0x38, 0xb4, 0x03, 0xd7,
+			0x38, 0xb4, 0xba, 0x5f,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0xc7, 0x0c,
+			0x38, 0xb4, 0x02, 0xa8,
+			0x38, 0xb4, 0x01, 0xa3,
+			0x38, 0xb4, 0x01, 0xa8,
+			0x38, 0xb4, 0x04, 0xc0,
+			0x38, 0xb4, 0x10, 0xd7,
+			0x38, 0xb4, 0x00, 0x40,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x79, 0x1e,
+			0x36, 0xb4, 0x26, 0xa0,
+			0x38, 0xb4, 0x78, 0x1e,
+			0x36, 0xb4, 0x24, 0xa0,
+			0x38, 0xb4, 0x93, 0x0c,
+			0x36, 0xb4, 0x22, 0xa0,
+			0x38, 0xb4, 0x62, 0x10,
+			0x36, 0xb4, 0x20, 0xa0,
+			0x38, 0xb4, 0x15, 0x09,
+			0x36, 0xb4, 0x06, 0xa0,
+			0x38, 0xb4, 0x0a, 0x02,
+			0x36, 0xb4, 0x04, 0xa0,
+			0x38, 0xb4, 0x26, 0x17,
+			0x36, 0xb4, 0x02, 0xa0,
+			0x38, 0xb4, 0x42, 0x15,
+			0x36, 0xb4, 0x00, 0xa0,
+			0x38, 0xb4, 0xc7, 0x0f,
+			0x36, 0xb4, 0x08, 0xa0,
+			0x38, 0xb4, 0x00, 0xff,
+			0x6c, 0xe8, 0x00, 0xa0,
+			0x36, 0xb4, 0x16, 0xa0,
+			0x38, 0xb4, 0x10, 0x00,
+			0x36, 0xb4, 0x12, 0xa0,
+			0x38, 0xb4, 0x00, 0x00,
+			0x36, 0xb4, 0x14, 0xa0,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x10, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x1d, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2c, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2c, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2c, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2c, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2c, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2c, 0x80,
+			0x38, 0xb4, 0x00, 0xd7,
+			0x38, 0xb4, 0x90, 0x60,
+			0x38, 0xb4, 0xd1, 0x60,
+			0x38, 0xb4, 0x5c, 0xc9,
+			0x38, 0xb4, 0x07, 0xf0,
+			0x38, 0xb4, 0xb1, 0x60,
+			0x38, 0xb4, 0x5a, 0xc9,
+			0x38, 0xb4, 0x04, 0xf0,
+			0x38, 0xb4, 0x56, 0xc9,
+			0x38, 0xb4, 0x02, 0xf0,
+			0x38, 0xb4, 0x4e, 0xc9,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0xcd, 0x00,
+			0x38, 0xb4, 0x00, 0xd7,
+			0x38, 0xb4, 0x90, 0x60,
+			0x38, 0xb4, 0xd1, 0x60,
+			0x38, 0xb4, 0x5c, 0xc9,
+			0x38, 0xb4, 0x07, 0xf0,
+			0x38, 0xb4, 0xb1, 0x60,
+			0x38, 0xb4, 0x5a, 0xc9,
+			0x38, 0xb4, 0x04, 0xf0,
+			0x38, 0xb4, 0x56, 0xc9,
+			0x38, 0xb4, 0x02, 0xf0,
+			0x38, 0xb4, 0x4e, 0xc9,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x2a, 0x02,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x32, 0x01,
+			0x36, 0xb4, 0x8e, 0xa0,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x8c, 0xa0,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x8a, 0xa0,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x88, 0xa0,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x86, 0xa0,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x84, 0xa0,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x82, 0xa0,
+			0x38, 0xb4, 0x2f, 0x01,
+			0x36, 0xb4, 0x80, 0xa0,
+			0x38, 0xb4, 0xcc, 0x00,
+			0x36, 0xb4, 0x90, 0xa0,
+			0x38, 0xb4, 0x03, 0x01,
+			0x6c, 0xe8, 0x00, 0xa0,
+			0x36, 0xb4, 0x16, 0xa0,
+			0x38, 0xb4, 0x20, 0x00,
+			0x36, 0xb4, 0x12, 0xa0,
+			0x38, 0xb4, 0x00, 0x00,
+			0x36, 0xb4, 0x14, 0xa0,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x10, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x20, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2a, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x35, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x3c, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x3c, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x3c, 0x80,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x3c, 0x80,
+			0x38, 0xb4, 0x07, 0xd1,
+			0x38, 0xb4, 0x42, 0xd0,
+			0x38, 0xb4, 0x04, 0xa4,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0xdf, 0x09,
+			0x38, 0xb4, 0x00, 0xd7,
+			0x38, 0xb4, 0xb4, 0x5f,
+			0x38, 0xb4, 0x80, 0x82,
+			0x38, 0xb4, 0x00, 0xd7,
+			0x38, 0xb4, 0x65, 0x60,
+			0x38, 0xb4, 0x25, 0xd1,
+			0x38, 0xb4, 0x02, 0xf0,
+			0x38, 0xb4, 0x2b, 0xd1,
+			0x38, 0xb4, 0x40, 0xd0,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x7f, 0x07,
+			0x38, 0xb4, 0xf0, 0x0c,
+			0x38, 0xb4, 0x50, 0x0c,
+			0x38, 0xb4, 0x04, 0xd1,
+			0x38, 0xb4, 0x40, 0xd0,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0xa8, 0x0a,
+			0x38, 0xb4, 0x00, 0xd7,
+			0x38, 0xb4, 0xb4, 0x5f,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x2e, 0x0a,
+			0x38, 0xb4, 0x9b, 0xcb,
+			0x38, 0xb4, 0x10, 0xd1,
+			0x38, 0xb4, 0x40, 0xd0,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0x7b, 0x0b,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0xdf, 0x09,
+			0x38, 0xb4, 0x00, 0xd7,
+			0x38, 0xb4, 0xb4, 0x5f,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x1b, 0x08,
+			0x38, 0xb4, 0x00, 0x10,
+			0x38, 0xb4, 0xdf, 0x09,
+			0x38, 0xb4, 0x04, 0xd7,
+			0x38, 0xb4, 0xb8, 0x7f,
+			0x38, 0xb4, 0x18, 0xa7,
+			0x38, 0xb4, 0x00, 0x18,
+			0x38, 0xb4, 0x4e, 0x07,
+			0x36, 0xb4, 0x0e, 0xa1,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x0c, 0xa1,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x0a, 0xa1,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x08, 0xa1,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x06, 0xa1,
+			0x38, 0xb4, 0x4d, 0x07,
+			0x36, 0xb4, 0x04, 0xa1,
+			0x38, 0xb4, 0x18, 0x08,
+			0x36, 0xb4, 0x02, 0xa1,
+			0x38, 0xb4, 0x2c, 0x0a,
+			0x36, 0xb4, 0x00, 0xa1,
+			0x38, 0xb4, 0x7e, 0x07,
+			0x36, 0xb4, 0x10, 0xa1,
+			0x38, 0xb4, 0x0f, 0x00,
+			0x6c, 0xe8, 0x00, 0xa0,
+			0x36, 0xb4, 0x7c, 0xb8,
+			0x38, 0xb4, 0x25, 0x86,
+			0x36, 0xb4, 0x7e, 0xb8,
+			0x38, 0xb4, 0x86, 0xaf,
+			0x38, 0xb4, 0xaf, 0x3d,
+			0x38, 0xb4, 0x89, 0x86,
+			0x38, 0xb4, 0x88, 0xaf,
+			0x38, 0xb4, 0xaf, 0x69,
+			0x38, 0xb4, 0x87, 0x88,
+			0x38, 0xb4, 0x88, 0xaf,
+			0x38, 0xb4, 0xaf, 0x9c,
+			0x38, 0xb4, 0x9c, 0x88,
+			0x38, 0xb4, 0x88, 0xaf,
+			0x38, 0xb4, 0xaf, 0x9c,
+			0x38, 0xb4, 0x9c, 0x88,
+			0x38, 0xb4, 0x86, 0xbf,
+			0x38, 0xb4, 0xd7, 0x49,
+			0x38, 0xb4, 0x40, 0x00,
+			0x38, 0xb4, 0x77, 0x02,
+			0x38, 0xb4, 0xaf, 0x7d,
+			0x38, 0xb4, 0x27, 0x27,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x05, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x08, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0xf3, 0x71,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0xf6, 0x71,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x29, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x2c, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x17, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x1a, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x1d, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x11, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x20, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x14, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x2f, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x23, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x32, 0x72,
+			0x38, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x26, 0x72,
+			0x38, 0xb4, 0xf9, 0xf8,
+			0x38, 0xb4, 0xe0, 0xfa,
+			0x38, 0xb4, 0xb3, 0x85,
+			0x38, 0xb4, 0x02, 0x38,
+			0x38, 0xb4, 0x27, 0xad,
+			0x38, 0xb4, 0xae, 0x02,
+			0x38, 0xb4, 0xaf, 0x03,
+			0x38, 0xb4, 0x30, 0x88,
+			0x38, 0xb4, 0x66, 0x1f,
+			0x38, 0xb4, 0x65, 0xef,
+			0x38, 0xb4, 0xc2, 0xbf,
+			0x38, 0xb4, 0x1a, 0x1f,
+			0x38, 0xb4, 0xf7, 0x96,
+			0x38, 0xb4, 0xee, 0x05,
+			0x38, 0xb4, 0xd2, 0xff,
+			0x38, 0xb4, 0xda, 0x00,
+			0x38, 0xb4, 0x05, 0xf6,
+			0x38, 0xb4, 0xc2, 0xbf,
+			0x38, 0xb4, 0x1a, 0x2f,
+			0x38, 0xb4, 0xf7, 0x96,
+			0x38, 0xb4, 0xee, 0x05,
+			0x38, 0xb4, 0xd2, 0xff,
+			0x38, 0xb4, 0xdb, 0x00,
+			0x38, 0xb4, 0x05, 0xf6,
+			0x38, 0xb4, 0x02, 0xef,
+			0x38, 0xb4, 0x11, 0x1f,
+			0x38, 0xb4, 0x42, 0x0d,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x42,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x02, 0xef,
+			0x38, 0xb4, 0x03, 0x1b,
+			0x38, 0xb4, 0x11, 0x1f,
+			0x38, 0xb4, 0x42, 0x0d,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x45,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x02, 0xef,
+			0x38, 0xb4, 0x03, 0x1a,
+			0x38, 0xb4, 0x11, 0x1f,
+			0x38, 0xb4, 0x42, 0x0d,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x48,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0xc2, 0xbf,
+			0x38, 0xb4, 0x1a, 0x3f,
+			0x38, 0xb4, 0xf7, 0x96,
+			0x38, 0xb4, 0xee, 0x05,
+			0x38, 0xb4, 0xd2, 0xff,
+			0x38, 0xb4, 0xda, 0x00,
+			0x38, 0xb4, 0x05, 0xf6,
+			0x38, 0xb4, 0xc2, 0xbf,
+			0x38, 0xb4, 0x1a, 0x4f,
+			0x38, 0xb4, 0xf7, 0x96,
+			0x38, 0xb4, 0xee, 0x05,
+			0x38, 0xb4, 0xd2, 0xff,
+			0x38, 0xb4, 0xdb, 0x00,
+			0x38, 0xb4, 0x05, 0xf6,
+			0x38, 0xb4, 0x02, 0xef,
+			0x38, 0xb4, 0x11, 0x1f,
+			0x38, 0xb4, 0x42, 0x0d,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x4b,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x02, 0xef,
+			0x38, 0xb4, 0x03, 0x1b,
+			0x38, 0xb4, 0x11, 0x1f,
+			0x38, 0xb4, 0x42, 0x0d,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x4e,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x02, 0xef,
+			0x38, 0xb4, 0x03, 0x1a,
+			0x38, 0xb4, 0x11, 0x1f,
+			0x38, 0xb4, 0x42, 0x0d,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x51,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x56, 0xef,
+			0x38, 0xb4, 0x20, 0xd0,
+			0x38, 0xb4, 0x11, 0x1f,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x54,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x57,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x5a,
+			0xff, 0xff, 0xff, 0xff,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xef, 0xa0,
+			0x38, 0xb4, 0x48, 0x03,
+			0x38, 0xb4, 0x28, 0x0a,
+			0x38, 0xb4, 0xef, 0x05,
+			0x38, 0xb4, 0x1b, 0x20,
+			0x38, 0xb4, 0xad, 0x01,
+			0x38, 0xb4, 0x35, 0x27,
+			0x38, 0xb4, 0x44, 0x1f,
+			0x38, 0xb4, 0x85, 0xe0,
+			0x38, 0xb4, 0xe1, 0x88,
+			0x38, 0xb4, 0x89, 0x85,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x5d,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x85, 0xe0,
+			0x38, 0xb4, 0xe1, 0x8e,
+			0x38, 0xb4, 0x8f, 0x85,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x60,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x85, 0xe0,
+			0x38, 0xb4, 0xe1, 0x94,
+			0x38, 0xb4, 0x95, 0x85,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x63,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x85, 0xe0,
+			0x38, 0xb4, 0xe1, 0x9a,
+			0x38, 0xb4, 0x9b, 0x85,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x66,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x88, 0xaf,
+			0x38, 0xb4, 0xbf, 0x3c,
+			0x38, 0xb4, 0x3f, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xad, 0x9c,
+			0x38, 0xb4, 0x35, 0x28,
+			0x38, 0xb4, 0x44, 0x1f,
+			0x38, 0xb4, 0x8f, 0xe0,
+			0x38, 0xb4, 0xe1, 0xf8,
+			0x38, 0xb4, 0xf9, 0x8f,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x5d,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x8f, 0xe0,
+			0x38, 0xb4, 0xe1, 0xfa,
+			0x38, 0xb4, 0xfb, 0x8f,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x60,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x8f, 0xe0,
+			0x38, 0xb4, 0xe1, 0xfc,
+			0x38, 0xb4, 0xfd, 0x8f,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x63,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x8f, 0xe0,
+			0x38, 0xb4, 0xe1, 0xfe,
+			0x38, 0xb4, 0xff, 0x8f,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x66,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x88, 0xaf,
+			0x38, 0xb4, 0xe1, 0x3c,
+			0x38, 0xb4, 0xa1, 0x85,
+			0x38, 0xb4, 0x21, 0x1b,
+			0x38, 0xb4, 0x37, 0xad,
+			0x38, 0xb4, 0x1f, 0x34,
+			0x38, 0xb4, 0xe0, 0x44,
+			0x38, 0xb4, 0x8a, 0x85,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xbf, 0x8b,
+			0x38, 0xb4, 0x5d, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xe0, 0x7d,
+			0x38, 0xb4, 0x90, 0x85,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xbf, 0x91,
+			0x38, 0xb4, 0x60, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xe0, 0x7d,
+			0x38, 0xb4, 0x96, 0x85,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xbf, 0x97,
+			0x38, 0xb4, 0x63, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xe0, 0x7d,
+			0x38, 0xb4, 0x9c, 0x85,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xbf, 0x9d,
+			0x38, 0xb4, 0x66, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xae, 0x7d,
+			0x38, 0xb4, 0x1f, 0x40,
+			0x38, 0xb4, 0xe0, 0x44,
+			0x38, 0xb4, 0x8c, 0x85,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xbf, 0x8d,
+			0x38, 0xb4, 0x5d, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xe0, 0x7d,
+			0x38, 0xb4, 0x92, 0x85,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xbf, 0x93,
+			0x38, 0xb4, 0x60, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xe0, 0x7d,
+			0x38, 0xb4, 0x98, 0x85,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xbf, 0x99,
+			0x38, 0xb4, 0x63, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xe0, 0x7d,
+			0x38, 0xb4, 0x9e, 0x85,
+			0x38, 0xb4, 0x85, 0xe1,
+			0x38, 0xb4, 0xbf, 0x9f,
+			0x38, 0xb4, 0x66, 0x88,
+			0x38, 0xb4, 0x6e, 0x02,
+			0x38, 0xb4, 0xae, 0x7d,
+			0x38, 0xb4, 0xe1, 0x0c,
+			0x38, 0xb4, 0xb3, 0x85,
+			0x38, 0xb4, 0x04, 0x39,
+			0x38, 0xb4, 0x2f, 0xac,
+			0x38, 0xb4, 0xee, 0x04,
+			0x38, 0xb4, 0xb3, 0x85,
+			0x38, 0xb4, 0xaf, 0x00,
+			0x38, 0xb4, 0xd9, 0x39,
+			0x38, 0xb4, 0xac, 0x22,
+			0x38, 0xb4, 0xf0, 0xea,
+			0x38, 0xb4, 0xf6, 0xac,
+			0x38, 0xb4, 0xac, 0xf0,
+			0x38, 0xb4, 0xf0, 0xfa,
+			0x38, 0xb4, 0xf8, 0xac,
+			0x38, 0xb4, 0xac, 0xf0,
+			0x38, 0xb4, 0xf0, 0xfc,
+			0x38, 0xb4, 0x00, 0xad,
+			0x38, 0xb4, 0xac, 0xf0,
+			0x38, 0xb4, 0xf0, 0xfe,
+			0x38, 0xb4, 0xf0, 0xac,
+			0x38, 0xb4, 0xac, 0xf0,
+			0x38, 0xb4, 0xf0, 0xf4,
+			0x38, 0xb4, 0xf2, 0xac,
+			0x38, 0xb4, 0xac, 0xf0,
+			0x38, 0xb4, 0xf0, 0xb0,
+			0x38, 0xb4, 0xae, 0xac,
+			0x38, 0xb4, 0xac, 0xf0,
+			0x38, 0xb4, 0xf0, 0xac,
+			0x38, 0xb4, 0xaa, 0xac,
+			0x38, 0xb4, 0x00, 0xa1,
+			0x38, 0xb4, 0xe1, 0x0c,
+			0x38, 0xb4, 0xf7, 0x8f,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x84,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x26, 0xaf,
+			0x38, 0xb4, 0xe1, 0xe9,
+			0x38, 0xb4, 0xf6, 0x8f,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x84,
+			0x38, 0xb4, 0x7d, 0x6e,
+			0x38, 0xb4, 0x26, 0xaf,
+			0x38, 0xb4, 0x20, 0xf5,
+			0x38, 0xb4, 0x86, 0xac,
+			0x38, 0xb4, 0x88, 0xbf,
+			0x38, 0xb4, 0x02, 0x3f,
+			0x38, 0xb4, 0x9c, 0x6e,
+			0x38, 0xb4, 0x28, 0xad,
+			0x38, 0xb4, 0xaf, 0x03,
+			0x38, 0xb4, 0x24, 0x33,
+			0x38, 0xb4, 0x38, 0xad,
+			0x38, 0xb4, 0xaf, 0x03,
+			0x38, 0xb4, 0xe6, 0x32,
+			0x38, 0xb4, 0x32, 0xaf,
+			0x38, 0xb4, 0x00, 0xfb,
+			0x36, 0xb4, 0x7c, 0xb8,
+			0x38, 0xb4, 0xf6, 0x8f,
+			0x36, 0xb4, 0x7e, 0xb8,
+			0x38, 0xb4, 0x05, 0x07,
+			0x36, 0xb4, 0x7c, 0xb8,
+			0x38, 0xb4, 0xf8, 0x8f,
+			0x36, 0xb4, 0x7e, 0xb8,
+			0x38, 0xb4, 0xcc, 0x19,
+			0x36, 0xb4, 0x7c, 0xb8,
+			0x38, 0xb4, 0xfa, 0x8f,
+			0x36, 0xb4, 0x7e, 0xb8,
+			0x38, 0xb4, 0xe3, 0x28,
+			0x36, 0xb4, 0x7c, 0xb8,
+			0x38, 0xb4, 0xfc, 0x8f,
+			0x36, 0xb4, 0x7e, 0xb8,
+			0x38, 0xb4, 0x47, 0x10,
+			0x36, 0xb4, 0x7c, 0xb8,
+			0x38, 0xb4, 0xfe, 0x8f,
+			0x36, 0xb4, 0x7e, 0xb8,
+			0x38, 0xb4, 0x45, 0x0a,
+			0x36, 0xb4, 0x5e, 0xb8,
+			0x38, 0xb4, 0x1e, 0x27,
+			0x36, 0xb4, 0x60, 0xb8,
+			0x38, 0xb4, 0x46, 0x38,
+			0x36, 0xb4, 0x62, 0xb8,
+			0x38, 0xb4, 0xe6, 0x26,
+			0x36, 0xb4, 0x64, 0xb8,
+			0x38, 0xb4, 0xe3, 0x32,
+			0x36, 0xb4, 0x86, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x88, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x8a, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x8c, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x38, 0xb8,
+			0x38, 0xb4, 0x0f, 0x00,
+			0x6c, 0xe8, 0x00, 0xb0,
+			0x20, 0xb8, 0x10, 0x00,
+			0x6c, 0xe8, 0x00, 0xa0,
+			0x36, 0xb4, 0x6e, 0x84,
+			0x38, 0xb4, 0x84, 0xaf,
+			0x38, 0xb4, 0xaf, 0x86,
+			0x38, 0xb4, 0x90, 0x86,
+			0x38, 0xb4, 0x86, 0xaf,
+			0x38, 0xb4, 0xaf, 0xa4,
+			0x38, 0xb4, 0xa4, 0x86,
+			0x38, 0xb4, 0x86, 0xaf,
+			0x38, 0xb4, 0xaf, 0xa4,
+			0x38, 0xb4, 0xa4, 0x86,
+			0x38, 0xb4, 0x86, 0xaf,
+			0x38, 0xb4, 0xaf, 0xa4,
+			0x38, 0xb4, 0xa4, 0x86,
+			0x38, 0xb4, 0x82, 0xee,
+			0x38, 0xb4, 0x00, 0x5f,
+			0x38, 0xb4, 0x84, 0x02,
+			0x38, 0xb4, 0xaf, 0x90,
+			0x38, 0xb4, 0x41, 0x04,
+			0x38, 0xb4, 0xe0, 0xf8,
+			0x38, 0xb4, 0xf3, 0x8f,
+			0x38, 0xb4, 0x00, 0xa0,
+			0x38, 0xb4, 0x02, 0x05,
+			0x38, 0xb4, 0xa4, 0x84,
+			0x38, 0xb4, 0x06, 0xae,
+			0x38, 0xb4, 0x01, 0xa0,
+			0x38, 0xb4, 0x02, 0x03,
+			0x38, 0xb4, 0xc8, 0x84,
+			0x38, 0xb4, 0x04, 0xfc,
+			0x38, 0xb4, 0xf9, 0xf8,
+			0x38, 0xb4, 0x59, 0xef,
+			0x38, 0xb4, 0x80, 0xe0,
+			0x38, 0xb4, 0xad, 0x15,
+			0x38, 0xb4, 0x02, 0x27,
+			0x38, 0xb4, 0x03, 0xae,
+			0x38, 0xb4, 0x84, 0xaf,
+			0x38, 0xb4, 0xbf, 0xc3,
+			0x38, 0xb4, 0xca, 0x53,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xad, 0xc8,
+			0x38, 0xb4, 0x07, 0x28,
+			0x38, 0xb4, 0x85, 0x02,
+			0x38, 0xb4, 0xee, 0x2c,
+			0x38, 0xb4, 0xf3, 0x8f,
+			0x38, 0xb4, 0xef, 0x01,
+			0x38, 0xb4, 0xfd, 0x95,
+			0x38, 0xb4, 0x04, 0xfc,
+			0x38, 0xb4, 0xf9, 0xf8,
+			0x38, 0xb4, 0xef, 0xfa,
+			0x38, 0xb4, 0xbf, 0x69,
+			0x38, 0xb4, 0xca, 0x53,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xac, 0xc8,
+			0x38, 0xb4, 0x22, 0x28,
+			0x38, 0xb4, 0x80, 0xd4,
+			0x38, 0xb4, 0xbf, 0x00,
+			0x38, 0xb4, 0x84, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xbf, 0xa9,
+			0x38, 0xb4, 0x87, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xbf, 0xa9,
+			0x38, 0xb4, 0x8a, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xbf, 0xa9,
+			0x38, 0xb4, 0x8d, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xee, 0xa9,
+			0x38, 0xb4, 0xf3, 0x8f,
+			0x38, 0xb4, 0xaf, 0x00,
+			0x38, 0xb4, 0x26, 0x85,
+			0x38, 0xb4, 0x8f, 0xe0,
+			0x38, 0xb4, 0xe1, 0xf4,
+			0x38, 0xb4, 0xf5, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe2,
+			0x38, 0xb4, 0xe3, 0xf6,
+			0x38, 0xb4, 0xf7, 0x8f,
+			0x38, 0xb4, 0x45, 0x1b,
+			0x38, 0xb4, 0x27, 0xac,
+			0x38, 0xb4, 0xee, 0x0e,
+			0x38, 0xb4, 0xf4, 0x8f,
+			0x38, 0xb4, 0xee, 0x00,
+			0x38, 0xb4, 0xf5, 0x8f,
+			0x38, 0xb4, 0x02, 0x00,
+			0x38, 0xb4, 0x2c, 0x85,
+			0x38, 0xb4, 0x85, 0xaf,
+			0x38, 0xb4, 0xe0, 0x26,
+			0x38, 0xb4, 0xf4, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe1,
+			0x38, 0xb4, 0x2c, 0xf5,
+			0x38, 0xb4, 0x01, 0x00,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xf4,
+			0x38, 0xb4, 0xf5, 0x8f,
+			0x38, 0xb4, 0x96, 0xef,
+			0x38, 0xb4, 0xfd, 0xfe,
+			0x38, 0xb4, 0x04, 0xfc,
+			0x38, 0xb4, 0xf9, 0xf8,
+			0x38, 0xb4, 0x59, 0xef,
+			0x38, 0xb4, 0x53, 0xbf,
+			0x38, 0xb4, 0x02, 0x22,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8b, 0xa1,
+			0x38, 0xb4, 0xae, 0x02,
+			0x38, 0xb4, 0xaf, 0x03,
+			0x38, 0xb4, 0xda, 0x85,
+			0x38, 0xb4, 0x57, 0xbf,
+			0x38, 0xb4, 0x02, 0x72,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xf8,
+			0x38, 0xb4, 0xf9, 0x8f,
+			0x38, 0xb4, 0x57, 0xbf,
+			0x38, 0xb4, 0x02, 0x75,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xfa,
+			0x38, 0xb4, 0xfb, 0x8f,
+			0x38, 0xb4, 0x57, 0xbf,
+			0x38, 0xb4, 0x02, 0x78,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xfc,
+			0x38, 0xb4, 0xfd, 0x8f,
+			0x38, 0xb4, 0x57, 0xbf,
+			0x38, 0xb4, 0x02, 0x7b,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xfe,
+			0x38, 0xb4, 0xff, 0x8f,
+			0x38, 0xb4, 0x57, 0xbf,
+			0x38, 0xb4, 0x02, 0x6c,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x02, 0xa1,
+			0x38, 0xb4, 0xee, 0x13,
+			0x38, 0xb4, 0xfc, 0x8f,
+			0x38, 0xb4, 0xee, 0x80,
+			0x38, 0xb4, 0xfd, 0x8f,
+			0x38, 0xb4, 0xee, 0x00,
+			0x38, 0xb4, 0xfe, 0x8f,
+			0x38, 0xb4, 0xee, 0x80,
+			0x38, 0xb4, 0xff, 0x8f,
+			0x38, 0xb4, 0xaf, 0x00,
+			0x38, 0xb4, 0x99, 0x85,
+			0x38, 0xb4, 0x01, 0xa1,
+			0x38, 0xb4, 0xbf, 0x0c,
+			0x38, 0xb4, 0x4c, 0x53,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xa1, 0xc8,
+			0x38, 0xb4, 0x03, 0x03,
+			0x38, 0xb4, 0x85, 0xaf,
+			0x38, 0xb4, 0xbf, 0x77,
+			0x38, 0xb4, 0x22, 0x53,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xa1, 0xc8,
+			0x38, 0xb4, 0x02, 0x8b,
+			0x38, 0xb4, 0x03, 0xae,
+			0x38, 0xb4, 0x86, 0xaf,
+			0x38, 0xb4, 0xe0, 0x64,
+			0x38, 0xb4, 0xf8, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe1,
+			0x38, 0xb4, 0xbf, 0xf9,
+			0x38, 0xb4, 0x84, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xe0, 0xa9,
+			0x38, 0xb4, 0xfa, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe1,
+			0x38, 0xb4, 0xbf, 0xfb,
+			0x38, 0xb4, 0x87, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xe0, 0xa9,
+			0x38, 0xb4, 0xfc, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe1,
+			0x38, 0xb4, 0xbf, 0xfd,
+			0x38, 0xb4, 0x8a, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xe0, 0xa9,
+			0x38, 0xb4, 0xfe, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe1,
+			0x38, 0xb4, 0xbf, 0xff,
+			0x38, 0xb4, 0x8d, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xaf, 0xa9,
+			0x38, 0xb4, 0x7f, 0x86,
+			0x38, 0xb4, 0x53, 0xbf,
+			0x38, 0xb4, 0x02, 0x22,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x44, 0xa1,
+			0x38, 0xb4, 0xbf, 0x3c,
+			0x38, 0xb4, 0x7b, 0x54,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xe4, 0xc8,
+			0x38, 0xb4, 0xf8, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe5,
+			0x38, 0xb4, 0xbf, 0xf9,
+			0x38, 0xb4, 0x7e, 0x54,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xe4, 0xc8,
+			0x38, 0xb4, 0xfa, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe5,
+			0x38, 0xb4, 0xbf, 0xfb,
+			0x38, 0xb4, 0x81, 0x54,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xe4, 0xc8,
+			0x38, 0xb4, 0xfc, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe5,
+			0x38, 0xb4, 0xbf, 0xfd,
+			0x38, 0xb4, 0x84, 0x54,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xe4, 0xc8,
+			0x38, 0xb4, 0xfe, 0x8f,
+			0x38, 0xb4, 0x8f, 0xe5,
+			0x38, 0xb4, 0xbf, 0xff,
+			0x38, 0xb4, 0x22, 0x53,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xa1, 0xc8,
+			0x38, 0xb4, 0x48, 0x44,
+			0x38, 0xb4, 0x85, 0xaf,
+			0x38, 0xb4, 0xbf, 0xa7,
+			0x38, 0xb4, 0x22, 0x53,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xa1, 0xc8,
+			0x38, 0xb4, 0x3c, 0x31,
+			0x38, 0xb4, 0x54, 0xbf,
+			0x38, 0xb4, 0x02, 0x7b,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xf8,
+			0x38, 0xb4, 0xf9, 0x8f,
+			0x38, 0xb4, 0x54, 0xbf,
+			0x38, 0xb4, 0x02, 0x7e,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xfa,
+			0x38, 0xb4, 0xfb, 0x8f,
+			0x38, 0xb4, 0x54, 0xbf,
+			0x38, 0xb4, 0x02, 0x81,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xfc,
+			0x38, 0xb4, 0xfd, 0x8f,
+			0x38, 0xb4, 0x54, 0xbf,
+			0x38, 0xb4, 0x02, 0x84,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x8f, 0xe4,
+			0x38, 0xb4, 0xe5, 0xfe,
+			0x38, 0xb4, 0xff, 0x8f,
+			0x38, 0xb4, 0x53, 0xbf,
+			0x38, 0xb4, 0x02, 0x22,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x31, 0xa1,
+			0x38, 0xb4, 0xaf, 0x03,
+			0x38, 0xb4, 0xa7, 0x85,
+			0x38, 0xb4, 0x80, 0xd4,
+			0x38, 0xb4, 0xbf, 0x00,
+			0x38, 0xb4, 0x84, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xbf, 0xa9,
+			0x38, 0xb4, 0x87, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xbf, 0xa9,
+			0x38, 0xb4, 0x8a, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xbf, 0xa9,
+			0x38, 0xb4, 0x8d, 0x86,
+			0x38, 0xb4, 0x52, 0x02,
+			0x38, 0xb4, 0xef, 0xa9,
+			0x38, 0xb4, 0xfd, 0x95,
+			0x38, 0xb4, 0x04, 0xfc,
+			0x38, 0xb4, 0xd1, 0xf0,
+			0x38, 0xb4, 0xf0, 0x2a,
+			0x38, 0xb4, 0x2c, 0xd1,
+			0x38, 0xb4, 0xd1, 0xf0,
+			0x38, 0xb4, 0xf0, 0x44,
+			0x38, 0xb4, 0x46, 0xd1,
+			0x38, 0xb4, 0x86, 0xbf,
+			0x38, 0xb4, 0x02, 0xa1,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x86, 0xbf,
+			0x38, 0xb4, 0x02, 0xa1,
+			0x38, 0xb4, 0xc8, 0x52,
+			0x38, 0xb4, 0x01, 0xd1,
+			0x38, 0xb4, 0x06, 0xaf,
+			0x38, 0xb4, 0x70, 0xa5,
+			0x38, 0xb4, 0x42, 0xce,
+			0x36, 0xb4, 0x18, 0xb8,
+			0x38, 0xb4, 0x3d, 0x04,
+			0x36, 0xb4, 0x1a, 0xb8,
+			0x38, 0xb4, 0xa3, 0x06,
+			0x36, 0xb4, 0x1c, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x1e, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x50, 0xb8,
+			0xff, 0xff, 0xff, 0xff,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x52, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x78, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x84, 0xb8,
+			0x38, 0xb4, 0xff, 0xff,
+			0x36, 0xb4, 0x32, 0xb8,
+			0x38, 0xb4, 0x03, 0x00,
+			0x36, 0xb4, 0x00, 0x00,
+			0x38, 0xb4, 0x00, 0x00,
+			0x36, 0xb4, 0x2e, 0xb8,
+			0x38, 0xb4, 0x00, 0x00,
+			0x36, 0xb4, 0x24, 0x80,
+			0x38, 0xb4, 0x00, 0x00,
+			0x36, 0xb4, 0x1e, 0x80,
+			0x38, 0xb4, 0x21, 0x00,
+			0x6c, 0xe8, 0x00, 0xb0,
+			0x20, 0xb8, 0x00, 0x00,
+			0xff, 0xff, 0xff, 0xff};
+
+		if (sram_read(tp, SRAM_GPHY_FW_VER) < 0x0021) {
+			data = ram13;
+			len = sizeof(ram13);
+		}
 	}
 
-	r8152_aldps_en(tp, false);
-
-	if (tp->version == RTL_VER_01) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE);
-		ocp_data &= ~LED_MODE_MASK;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE, ocp_data);
-	}
+	if (!data)
+		return;
 
-	r8152_power_cut_en(tp, false);
+	if (rtl_phy_patch_request(tp, true, wait))
+		return;
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
-	ocp_data |= TX_10M_IDLE_EN | PFM_PWM_SWITCH;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
-	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL);
-	ocp_data &= ~MCU_CLK_RATIO_MASK;
-	ocp_data |= MCU_CLK_RATIO | D3_CLK_GATED_EN;
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL, ocp_data);
-	ocp_data = GPHY_STS_MSK | SPEED_DOWN_MSK |
-		   SPDWN_RXDV_MSK | SPDWN_LINKCHG_MSK;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_GPHY_INTR_IMR, ocp_data);
+	while (len) {
+		u32 size;
+		int i;
 
-	rtl_tally_reset(tp);
+		if (len < 2048)
+			size = len;
+		else
+			size = 2048;
 
-	/* enable rx aggregation */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
-	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
-}
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL);
+		ocp_data |= GPHY_PATCH_DONE | BACKUP_RESTRORE;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL, ocp_data);
 
-static void r8153_init(struct r8152 *tp)
-{
-	u32 ocp_data;
-	u16 data;
-	int i;
+		generic_ocp_write(tp, 0x9A00, 0xff, size, data, MCU_TYPE_USB);
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+		data += size;
+		len -= size;
 
-	r8153_u1u2en(tp, false);
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL);
+		ocp_data |= POL_GPHY_PATCH;
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL, ocp_data);
 
-	for (i = 0; i < 500; i++) {
-		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
-		    AUTOLOAD_DONE)
-			break;
+		for (i = 0; i < 1000; i++) {
+			if (!(ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL) & POL_GPHY_PATCH))
+				break;
+		}
 
-		msleep(20);
-		if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		if (i == 1000) {
+			dev_err(&tp->intf->dev, "ram code speedup mode fail\n");
 			break;
+		}
 	}
 
-	data = r8153_phy_status(tp, 0);
-
-	if (tp->version == RTL_VER_03 || tp->version == RTL_VER_04 ||
-	    tp->version == RTL_VER_05)
-		ocp_reg_write(tp, OCP_ADC_CFG, CKADSEL_L | ADC_EN | EN_EMI_L);
+	rtl_reset_ocp_base(tp);
 
-	data = r8152_mdio_read(tp, MII_BMCR);
-	if (data & BMCR_PDOWN) {
-		data &= ~BMCR_PDOWN;
-		r8152_mdio_write(tp, MII_BMCR, data);
-	}
+	rtl_phy_patch_request(tp, false, wait);
+}
 
-	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
+static void r8156_ram_code(struct r8152 *tp, bool power_cut)
+{
+	u16 data;
 
-	r8153_u2p3en(tp, false);
+	rtl_reset_ocp_base(tp);
 
-	if (tp->version == RTL_VER_04) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_SSPHYLINK2);
-		ocp_data &= ~pwd_dn_scale_mask;
-		ocp_data |= pwd_dn_scale(96);
-		ocp_write_word(tp, MCU_TYPE_USB, USB_SSPHYLINK2, ocp_data);
+	if (tp->version == RTL_VER_10) {
+		rtl_pre_ram_code(tp, 0x8024, 0x8600, !power_cut);
+
+		data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+		data |= BIT(7);
+		ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+		/* nc0_patch_180504_usb */
+		sram_write(tp, 0xA016, 0x0000);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8013);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8021);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x802f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x803d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8042);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8051);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8051);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa088);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a50);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8008);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd707);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40c2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a6c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8080);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd019);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd707);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40c4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a84);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8970);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c07);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0901);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcf09);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd705);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xceff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf0a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1213);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8580);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1253);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd064);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd181);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4018);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc50f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd706);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2c59);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x804d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc60f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc605);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x10fd);
+		sram_write(tp, 0xA026, 0xffff);
+		sram_write(tp, 0xA024, 0xffff);
+		sram_write(tp, 0xA022, 0x10f4);
+		sram_write(tp, 0xA020, 0x1252);
+		sram_write(tp, 0xA006, 0x1206);
+		sram_write(tp, 0xA004, 0x0a78);
+		sram_write(tp, 0xA002, 0x0a60);
+		sram_write(tp, 0xA000, 0x0a4f);
+		sram_write(tp, 0xA008, 0x3f00);
+
+		/* nc1_patch_180423_cml_usb */
+		sram_write(tp, 0xA016, 0x0010);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8066);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x807c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8089);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x808e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80b2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80c2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62db);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x655c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd73e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60e9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x614a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0505);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0509);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x653c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd73e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60e9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x614a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0506);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x050a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd73e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60e9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x614a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0505);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0506);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x050c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd73e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60e9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x614a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0509);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x050a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x050c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0508);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd73e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60e9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x614a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0321);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0321);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0321);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0508);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0321);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0346);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8208);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x609d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa50f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x001a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x001a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x607d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60fd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa50f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x017b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a05);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x017b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60fd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa50f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a05);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60fd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa50f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0231);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a05);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0231);
+		sram_write(tp, 0xA08E, 0xffff);
+		sram_write(tp, 0xA08C, 0x0221);
+		sram_write(tp, 0xA08A, 0x01ce);
+		sram_write(tp, 0xA088, 0x0169);
+		sram_write(tp, 0xA086, 0x00a6);
+		sram_write(tp, 0xA084, 0x000d);
+		sram_write(tp, 0xA082, 0x0308);
+		sram_write(tp, 0xA080, 0x029f);
+		sram_write(tp, 0xA090, 0x007f);
+
+		/* nc2_patch_180508_usb */
+		sram_write(tp, 0xA016, 0x0020);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8017);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x801b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8029);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8054);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x805a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8064);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80a7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9430);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9480);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb408);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd120);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd057);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x064b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9906);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0567);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb94);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8406);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8dff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07e4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa840);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0773);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb91);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4063);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd139);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd140);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07dc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa610);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa2a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4045);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x405d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0742);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07ec);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f74);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0742);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fb6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8610);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07dc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x064b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0481);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x94bc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x870c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa280);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8220);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x078e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb92);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa840);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4063);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd140);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd150);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd703);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6121);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61a2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6223);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf02f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf00f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d20);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d30);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf005);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07e4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa610);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa008);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4046);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x405d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0742);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07f7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f74);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0742);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fb5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07e4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ad4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0537);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8610);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8840);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x064b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa70c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x890c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8840);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x064b);
+		sram_write(tp, 0xA10E, 0x0642);
+		sram_write(tp, 0xA10C, 0x0686);
+		sram_write(tp, 0xA10A, 0x0788);
+		sram_write(tp, 0xA108, 0x047b);
+		sram_write(tp, 0xA106, 0x065c);
+		sram_write(tp, 0xA104, 0x0769);
+		sram_write(tp, 0xA102, 0x0565);
+		sram_write(tp, 0xA100, 0x06f9);
+		sram_write(tp, 0xA110, 0x00ff);
+
+		/* uc2_patch_180507_usb */
+		sram_write(tp, 0xb87c, 0x8530);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xb87e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3caf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8593);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9caf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85a5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5afb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfb0c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x020d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x021b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x10bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86d7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbe0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x83fc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xda02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdd02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5afb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfd0c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x020d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x021b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x10bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86dd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbe0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x83fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf2f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2cac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0286);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x65af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x212b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x022c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86b6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf21);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cd1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x870d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8719);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8716);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x871f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x871c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8728);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8725);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8707);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x281c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2202);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2b02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae1a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd101);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2202);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2b02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd101);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3a02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4c02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2e02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ab7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf35);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7ff8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86e3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86fb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86e6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86e9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86ec);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x025a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0262);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7cbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86f2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0262);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7cbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86f5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0262);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7cbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0262);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6273);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf202);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6273);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6273);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf802);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6273);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0420);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb540);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x53b5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4086);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb540);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb9b5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40c8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb03a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc8b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbac8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb13a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc8b1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xba77);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffbd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2677);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffbd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2840);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc8bd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2640);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc8bd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x28bb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa430);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x98b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1eba);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb01e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdcb0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1e98);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb09e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbab0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9edc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb09e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x98b1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1eba);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb11e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdcb1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1e98);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb19e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbab1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9edc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb19e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x11b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1e22);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb01e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x33b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1e11);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb09e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x22b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9e33);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb09e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x11b1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1e22);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb11e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x33b1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1e11);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb19e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x22b1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9e33);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb19e);
+		sram_write(tp, 0xb85e, 0x2f71);
+		sram_write(tp, 0xb860, 0x20d9);
+		sram_write(tp, 0xb862, 0x2109);
+		sram_write(tp, 0xb864, 0x34e7);
+		sram_write(tp, 0xb878, 0x000f);
+
+		data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+		data &= ~BIT(7);
+		ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+		rtl_post_ram_code(tp, 0x8024, !power_cut);
+	} else if (tp->version == RTL_VER_11) {
+		rtl_pre_ram_code(tp, 0x8024, 0x8601, !power_cut);
+
+		data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+		data |= BIT(7);
+		ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+		/* nc_patch */
+		sram_write(tp, 0xA016, 0x0000);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x808b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x808f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8093);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8097);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x809d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80aa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd718);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x607b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf00e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x42da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf01e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd718);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x615b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1456);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14bc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd718);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f2e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf01c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1456);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14bc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd718);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f2e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf024);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1456);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14bc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd718);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f2e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf02c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1456);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14bc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd718);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f2e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf034);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd719);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4118);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac11);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa410);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4779);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf034);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd719);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4118);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac22);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa420);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4559);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf023);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd719);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4118);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac44);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa440);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4339);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf012);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd719);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4118);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa480);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xce00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4119);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1456);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd718);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc48f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x141b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x121a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd0b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1bb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0898);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd0b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1bb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a0e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd064);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd18a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0b7e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x401c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa804);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8804);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x053b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd500);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0648);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc520);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa201);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x252d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1646);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4006);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1646);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0308);
+		sram_write(tp, 0xA026, 0x0307);
+		sram_write(tp, 0xA024, 0x1645);
+		sram_write(tp, 0xA022, 0x0647);
+		sram_write(tp, 0xA020, 0x053a);
+		sram_write(tp, 0xA006, 0x0b7c);
+		sram_write(tp, 0xA004, 0x0a0c);
+		sram_write(tp, 0xA002, 0x0896);
+		sram_write(tp, 0xA000, 0x11a1);
+		sram_write(tp, 0xA008, 0xff00);
+
+		/* nc1_patch */
+		sram_write(tp, 0xA016, 0x0010);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8015);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x801a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x801a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x801a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x801a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x801a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x801a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02d7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ed);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0509);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x008f);
+		sram_write(tp, 0xA08E, 0xffff);
+		sram_write(tp, 0xA08C, 0xffff);
+		sram_write(tp, 0xA08A, 0xffff);
+		sram_write(tp, 0xA088, 0xffff);
+		sram_write(tp, 0xA086, 0xffff);
+		sram_write(tp, 0xA084, 0xffff);
+		sram_write(tp, 0xA082, 0x008d);
+		sram_write(tp, 0xA080, 0x00eb);
+		sram_write(tp, 0xA090, 0x0103);
+
+		/* nc2_patch */
+		sram_write(tp, 0xA016, 0x0020);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8018);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8024);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8051);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8055);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8072);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80dc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfffd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfffd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa70c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x890c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8840);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa380);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x066e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb91);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4063);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd139);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd140);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa610);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa2a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8280);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x405d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0743);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f74);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0743);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fb6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8610);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x066e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd158);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03d4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x94bc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x870c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8380);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd10d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07c4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa280);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa220);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd130);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07c4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbb80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1c4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd074);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x604b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa90c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0556);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb92);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4063);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd116);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd119);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd703);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6241);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x63e2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6583);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf054);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x611e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf02f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d50);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf02a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x611e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d20);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf021);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d60);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf01c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x611e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d30);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf013);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d70);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf00e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x611e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf005);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07e8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa610);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x405d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5ff4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa008);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4046);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0743);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07fb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd703);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f6f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f2d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f0c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07e8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa740);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0743);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fb5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ad4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0556);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8610);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x066e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1f5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd049);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01ec);
+		sram_write(tp, 0xA10E, 0x01ea);
+		sram_write(tp, 0xA10C, 0x06a9);
+		sram_write(tp, 0xA10A, 0x078a);
+		sram_write(tp, 0xA108, 0x03d2);
+		sram_write(tp, 0xA106, 0x067f);
+		sram_write(tp, 0xA104, 0x0665);
+		sram_write(tp, 0xA102, 0x0000);
+		sram_write(tp, 0xA100, 0x0000);
+		sram_write(tp, 0xA110, 0x00fc);
+
+		/* uc2 */
+		sram_write(tp, 0xb87c, 0x8530);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xb87e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3caf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8545);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x45af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8545);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee82);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf900);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0103);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa601);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x58f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa080);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x37a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae16);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa185);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x11a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae0c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa188);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x07a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae1c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb463);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6901);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe4b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb463);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe0b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb463);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6901);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe4b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb463);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		sram_write(tp, 0xb85e, 0x03b3);
+		sram_write(tp, 0xb860, 0xffff);
+		sram_write(tp, 0xb862, 0xffff);
+		sram_write(tp, 0xb864, 0xffff);
+		sram_write(tp, 0xb878, 0x0001);
+
+		/* data_ram_patch_v02_usb */
+		sram_write(tp, 0xb892, 0x0000);
+		sram_write(tp, 0xb88e, 0xc089);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xb890);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6050);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f6e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e6e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e6e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e12);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1214);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1516);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x171b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b1c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2021);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2224);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2424);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2424);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2424);
+		sram_write(tp, 0xb88e, 0xc018);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xb890);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0af2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d4a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0f26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x118d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14f3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x175a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x19c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1c26);
+
+		data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+		data &= ~BIT(7);
+		ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+		rtl_post_ram_code(tp, 0x8024, !power_cut);
+
+		/* 100M MLT-3 Tx interpolator coefficient */
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0x81b3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0043);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00a7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00d6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ec);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00f6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00fb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00fd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00bb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0058);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0029);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0013);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0009);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+	} else if (tp->version == RTL_VER_12) {
+		rtl_pre_ram_code(tp, 0x8024, 0x3700, !power_cut);
+
+		data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+		data |= BIT(7);
+		ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+		/* nc_patch */
+		sram_write(tp, 0xA016, 0x0000);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8025);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x803a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8044);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x808d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x808d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x808d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd712);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4077);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4159);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6099);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f44);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9201);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b1a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2425);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ce5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1afb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd712);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4077);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4159);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60b9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2421);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1c17);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1c2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2425);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3ce5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1c0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1c13);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6072);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x146e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0b77);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd703);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x665d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x653e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x641f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62c4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6185);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6066);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x165a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc101);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1945);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fa6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x807d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1945);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2569);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8058);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x807d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc104);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1945);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fa4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x807d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc120);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1945);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd703);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x807d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc140);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1945);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd703);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fbe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x807d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1945);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd703);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fbd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6018);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x165a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x14f6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1e3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1356);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd705);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fbe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1559);
+		sram_write(tp, 0xA026, 0xffff);
+		sram_write(tp, 0xA024, 0xffff);
+		sram_write(tp, 0xA022, 0xffff);
+		sram_write(tp, 0xA020, 0x1557);
+		sram_write(tp, 0xA006, 0x1677);
+		sram_write(tp, 0xA004, 0x0b75);
+		sram_write(tp, 0xA002, 0x1c17);
+		sram_write(tp, 0xA000, 0x1b04);
+		sram_write(tp, 0xA008, 0x1f00);
+
+		/* nc1_patch */
+
+		/* nc2_patch */
+		sram_write(tp, 0xA016, 0x0020);
+		sram_write(tp, 0xA012, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xA014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8010);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x817f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82ab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x83f8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8454);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8459);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8465);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb11);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa50c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8310);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4076);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0903);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a4d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb12);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f84);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60f3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd413);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd410);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb13);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa108);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8108);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa910);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa780);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd14a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd048);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6255);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f74);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6326);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f07);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffe2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fab);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xba08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9a08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6535);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd40d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa780);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd14a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd048);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6206);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f47);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8064);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd40e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6073);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4216);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd120);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb21);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f9f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd196);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb22);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a6d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa640);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8910);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0f14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb23);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0f80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xafc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5dee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb24);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8f1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f6e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa111);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa215);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8640);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0b43);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0b86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f82);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8111);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8205);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb27);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa104);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8104);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa120);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd193);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd046);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb804);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f82);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9804);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb29);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb820);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f65);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9820);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb2a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd13d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8149);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa220);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8151);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f51);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb2f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f63);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd411);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd409);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb808);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fa3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9808);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0433);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb15);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa508);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a4d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f9f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd115);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd413);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb16);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a6d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa640);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd17a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0f14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb17);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0f80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xafc0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a25);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61ce);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5db4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb18);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8640);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0b43);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffd6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8f1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa131);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa2d5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa407);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa720);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8310);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa308);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8308);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb19);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8640);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9503);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0b43);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0b86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb1a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f82);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8111);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82c5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb804);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f82);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9804);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb1b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb820);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f65);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9820);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb1c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb1d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa220);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1f5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd049);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8221);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f51);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb808);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fa3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9808);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb2b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f84);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd14a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd048);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa780);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb2d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f94);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6208);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f27);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffe9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb2e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa406);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa220);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3444);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x827d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f51);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb2f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f63);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd411);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd409);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8406);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb808);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fa3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9808);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0433);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb30);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8380);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb31);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9308);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb204);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb301);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9204);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb32);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd408);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd141);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd043);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ccc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4c81);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x609e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa108);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8108);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa203);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8120);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8a0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa111);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8204);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa140);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8140);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd17a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa204);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8101);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8201);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa104);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8104);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa120);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa0f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd193);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd047);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd13d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf024);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8204);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa280);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8406);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4121);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60f3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8204);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa280);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb33);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa710);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb820);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd71f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f65);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9820);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb34);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6853);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8284);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb35);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd407);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8204);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa280);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4215);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1c3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd043);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8304);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4109);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf01e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb36);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd412);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6309);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x42c7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8280);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd14a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd048);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a7d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcc55);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa2a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6041);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd13d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f71);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb38);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8224);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa288);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x800a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6041);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd415);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a37);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd13d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd04a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb39);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa2a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6041);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd17a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd047);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fb4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0560);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa111);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd3f5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd219);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c31);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa215);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd30e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd21a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c31);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x63e9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f65);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f36);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c35);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8004);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c35);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8001);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4098);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd103);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb401);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c27);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa108);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c35);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8108);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8110);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8294);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa202);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0bdb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd39c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd210);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c31);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd39c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd210);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c31);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5fa5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c31);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x29b5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x840e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd708);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f4a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1014);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c31);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd709);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7fa4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x901f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c23);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb43);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa508);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3699);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x844a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa2a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2109);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05ea);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05ea);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcb90);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0ca0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x06db);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd1ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd052);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa508);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8718);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa00a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa190);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa2a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa404);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c50);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x09ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a5e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd704);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2e70);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x06da);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f55);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa90c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0645);
+		sram_write(tp, 0xA10E, 0x0644);
+		sram_write(tp, 0xA10C, 0x09e9);
+		sram_write(tp, 0xA10A, 0x06da);
+		sram_write(tp, 0xA108, 0x05e1);
+		sram_write(tp, 0xA106, 0x0be4);
+		sram_write(tp, 0xA104, 0x0435);
+		sram_write(tp, 0xA102, 0x0141);
+		sram_write(tp, 0xA100, 0x026d);
+		sram_write(tp, 0xA110, 0x00ff);
+
+		/* uc2 */
+		sram_write(tp, 0xb87c, 0x85fe);
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0xb87e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x16af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8699);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe5af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x86f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7aaf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x883a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x58af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b6c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd48b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7c02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8644);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2c00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x503c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffd6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac27);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x18e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x82fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cd4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b84);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0286);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x442c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x003c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac27);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x06ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8299);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8299);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x23dc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcefa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x79fb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc4bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b76);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6dac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2804);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd203);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd201);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbdd8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x19d9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef94);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6d78);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x648a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbdd8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x19d9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef94);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6d78);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x72cd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac50);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x643a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x019f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe4ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4678);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd0ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x97ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfec6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x041f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x771f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x221c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x450d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x481f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7f04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a94);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a94);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac7f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03d7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef46);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1c45);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef57);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef74);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0272);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe8a7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d1a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x941b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x979e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x072d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a64);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef76);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef97);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d98);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd400);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xff1d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x941a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x89cf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a75);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf74);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b79);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6da1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0005);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa0ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf26);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9aac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x284d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe08f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x10c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe08f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfe10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04c8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67c8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8c02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc4bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6def);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x74e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x830c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad20);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x74ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xccef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x971b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x76ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae13);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef30);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b32);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc4ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x46e4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ffb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe58f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfce7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ffd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xcc10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x11ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb8d1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4fbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ec4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8f02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c6d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef74);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe083);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0cad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2003);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0274);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaccc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef97);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b76);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad5f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x69ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3111);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaed1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0287);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x80af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2293);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfafb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef59);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe080);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x13ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x252f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2802);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c6d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef64);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f44);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb91b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x64ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f1d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd688);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2bd7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x882e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0274);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x73ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5008);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x737c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0287);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd0bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x882b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0273);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x73e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x824c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf621);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe482);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4cbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8834);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0273);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7cef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x95ff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8f9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfafb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef79);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x737c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f22);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac32);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x31ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x12bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8822);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ed6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fba);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f33);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac3c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1eef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x13bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8837);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4eef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96d8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x19d9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1616);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x13ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdf12);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaecc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7373);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef97);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfffe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0466);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x88f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac8a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x92ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbadd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac6c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeeac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6cff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x99ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0030);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd4c3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0000);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00b4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xecee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8298);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1412);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf8bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b5d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6d58);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fb8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2901);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe58f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb8a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0049);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef47);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe483);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8303);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbfc2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f1a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x95f7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffd2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00d8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf605);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f11);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef60);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c6d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf728);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf628);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c64);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef46);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0289);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf89);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0149);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef47);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe483);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8305);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbfc2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f1a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x95f7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffd2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00d8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf605);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f11);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef60);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c6d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf729);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf629);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c64);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef46);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0289);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf89);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96a0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0249);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef47);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe483);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x06e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8307);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbfc2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5f1a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x95f7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffd2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00d8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf605);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f11);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef60);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c6d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf72a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf62a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0c64);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef46);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0289);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x9902);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3920);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf89);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x96ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x47e4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8308);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe583);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x09bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc25f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a95);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf705);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeeff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd200);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd8f6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x051f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x11ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x60bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b30);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ebf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b33);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6df7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2bbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b33);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ef6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2bbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b33);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4e0c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x64ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x46bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b69);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4e02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8999);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0239);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x20af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8996);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf39);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1ef8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9fa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe08f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb838);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x201f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x66ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x65bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc21f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf705);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeeff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd200);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdaf6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc22f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf705);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeeff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd200);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdbf6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x021f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x110d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x42bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b3c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4eef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x021b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x031f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x110d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x42bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b36);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4eef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x021a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x031f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x110d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x42bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b39);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ebf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc23f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf705);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeeff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd200);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdaf6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc24f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a96);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf705);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeeff);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd200);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xdbf6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x05ef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x021f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x110d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x42bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b45);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4eef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x021b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x031f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x110d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x42bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b3f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4eef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x021a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x031f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x110d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x42bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b42);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4eef);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x56d0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x201f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x11bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ebf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ebf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b4b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ee1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8578);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef03);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x480a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2805);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xef20);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1b01);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad27);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3f1f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x44e0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8560);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe185);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x61bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b51);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8566);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe185);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b54);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x856c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe185);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6dbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b57);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ee0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8572);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe185);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x73bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b5a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x026c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4ee1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fb8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5900);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf728);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe58f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb8af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8b2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe185);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x791b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x21ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x373e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f44);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x62e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8563);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x68e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8569);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6ee1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x856f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x74e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8575);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5a02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb859);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00f7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x28e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fb8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae4a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1f44);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x64e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8565);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6ae1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x856b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x70e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8571);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe085);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x76e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8577);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5a02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6c4e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb859);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00f7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x28e5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8fb8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae0c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb839);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x04ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2f04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfefd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfc04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8efc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac8c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfaf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xacf8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf6f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfef0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xacfc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf4f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xacf2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xacb0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaef0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xacac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaaf0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xacee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x24f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb0a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0b1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x24f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb1a4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xee8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd400);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3976);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x66ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xeabb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa430);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e50);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e53);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e56);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e59);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e5c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e5f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e62);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6e65);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd9ac);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x70f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac6a);
+		sram_write(tp, 0xb85e, 0x23b7);
+		sram_write(tp, 0xb860, 0x74db);
+		sram_write(tp, 0xb862, 0x268c);
+		sram_write(tp, 0xb864, 0x3FE5);
+		sram_write(tp, 0xb886, 0x2250);
+		sram_write(tp, 0xb888, 0x140e);
+		sram_write(tp, 0xb88a, 0x3696);
+		sram_write(tp, 0xb88c, 0x3973);
+		sram_write(tp, 0xb838, 0x00ff);
+
+		data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+		data &= ~BIT(7);
+		ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
+
+		/* uc */
+		ocp_reg_write(tp, OCP_SRAM_ADDR, 0x8464);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf84);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7caf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8485);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x13af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x851e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb9af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8684);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf87);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x01af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8701);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xac38);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x38bb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf38);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4618);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0a02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd400);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0fbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8507);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8504);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6759);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3008);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae06);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0d02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa183);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x15a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae10);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x59f0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa180);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x16bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8501);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x381b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae0b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xffbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x84fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x17bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x84fe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0254);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x84fb);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0254);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb7ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x09a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x5006);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf84);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfb02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf04);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4700);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad34);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0670);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae14);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf0a6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00b8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd32);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x30bd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x30aa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xccbd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2ca1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x0705);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xec80);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf40);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf7af);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x40f5);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd101);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd10f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6abf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xddbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xddbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85b3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xddbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85b6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ffa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xddd1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85aa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4802);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4d6a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbdd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfcdd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfddd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfedd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf3c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x2066);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb800);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb8bd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x30ee);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb8bd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7040);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc8bd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8640);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbd88);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xc8bd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8802);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1929);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa202);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x03a2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x032e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd10f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf7bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf9bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85b3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ffa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae2c);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ffc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfdbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85b3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ffe);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7e02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa100);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x02ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x25a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x041d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf1bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8675);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff2);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7802);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf3bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x867b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48ae);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x29a1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x070b);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xae24);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8102);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad28);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1be1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff4);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7502);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xe18f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xf5bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8678);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x48e1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf86);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x7b02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf09);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8420);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbc32);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x20bc);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x3e76);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbc08);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfda6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x1a00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb64e);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd101);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa402);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54c0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xd10f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaa02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f48);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024d);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x6abf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85ad);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xddbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85b0);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff8);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xddbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85b3);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ff9);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xddbf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85b6);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x67bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8ffa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xddd1);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x00bf);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x85aa);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x024f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4802);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4d6a);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xad02);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfbdd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb002);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfcdd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb302);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfddd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xb602);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x4f67);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf8f);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xfedd);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xbf85);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xa702);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x54b7);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0xaf00);
+		ocp_reg_write(tp, OCP_SRAM_DATA, 0x8800);
+		sram_write(tp, 0xb818, 0x38b8);
+		sram_write(tp, 0xb81a, 0x0444);
+		sram_write(tp, 0xb81c, 0x40ee);
+		sram_write(tp, 0xb81e, 0x3C1A);
+		sram_write(tp, 0xb850, 0x0981);
+		sram_write(tp, 0xb852, 0x0085);
+		sram_write(tp, 0xb878, 0xffff);
+		sram_write(tp, 0xb884, 0xffff);
+		sram_write(tp, 0xb832, 0x003f);
+
+		rtl_post_ram_code(tp, 0x8024, !power_cut);
+	} else {
+		rtl_ram_code_speed_up(tp, !power_cut);
+	}
 
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
-		ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
-		ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
-	} else if (tp->version == RTL_VER_05) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_DMY_REG0);
-		ocp_data &= ~ECM_ALDPS;
-		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_DMY_REG0, ocp_data);
+	rtl_reset_ocp_base(tp);
+}
 
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1);
-		if (ocp_read_word(tp, MCU_TYPE_USB, USB_BURST_SIZE) == 0)
-			ocp_data &= ~DYNAMIC_BURST;
-		else
-			ocp_data |= DYNAMIC_BURST;
-		ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1, ocp_data);
-	} else if (tp->version == RTL_VER_06) {
-		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1);
-		if (ocp_read_word(tp, MCU_TYPE_USB, USB_BURST_SIZE) == 0)
-			ocp_data &= ~DYNAMIC_BURST;
-		else
-			ocp_data |= DYNAMIC_BURST;
-		ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY1, ocp_data);
+static void r8156_hw_phy_cfg(struct r8152 *tp)
+{
+	u32 ocp_data;
+	u16 data;
 
-		r8153_queue_wake(tp, false);
+	r8156_patch_code(tp);
 
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
-		if (rtl8152_get_speed(tp) & LINK_STATUS)
-			ocp_data |= CUR_LINK_OK;
-		else
-			ocp_data &= ~CUR_LINK_OK;
-		ocp_data |= POLL_LINK_CHG;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+	if (ocp_data & PCUT_STATUS) {
+		ocp_data &= ~PCUT_STATUS;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
 	}
 
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY2);
-	ocp_data |= EP4_FULL_FC;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_CSR_DUMMY2, ocp_data);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_WDT11_CTRL);
-	ocp_data &= ~TIMER11_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_WDT11_CTRL, ocp_data);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE);
-	ocp_data &= ~LED_MODE_MASK;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_LED_FEATURE, ocp_data);
-
-	ocp_data = FIFO_EMPTY_1FB | ROK_EXIT_LPM;
-	if (tp->version == RTL_VER_04 && tp->udev->speed < USB_SPEED_SUPER)
-		ocp_data |= LPM_TIMER_500MS;
-	else
-		ocp_data |= LPM_TIMER_500US;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_LPM_CTRL, ocp_data);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_AFE_CTRL2);
-	ocp_data &= ~SEN_VAL_MASK;
-	ocp_data |= SEN_VAL_NORMAL | SEL_RXIDLE;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_AFE_CTRL2, ocp_data);
-
-	ocp_write_word(tp, MCU_TYPE_USB, USB_CONNECT_TIMER, 0x0001);
-
-	r8153_power_cut_en(tp, false);
-	rtl_runtime_suspend_enable(tp, false);
-	r8153_mac_clk_speed_down(tp, false);
-	r8153_u1u2en(tp, true);
-	usb_enable_lpm(tp->udev);
-
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6);
-	ocp_data |= LANWAKE_CLR_EN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CONFIG6, ocp_data);
-
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG);
-	ocp_data &= ~LANWAKE_PIN;
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_LWAKE_CTRL_REG, ocp_data);
-
-	/* rx aggregation */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
-	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	if (tp->dell_tb_rx_agg_bug)
-		ocp_data |= RX_AGG_DISABLE;
-
-	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
-
-	rtl_tally_reset(tp);
-
-	switch (tp->udev->speed) {
-	case USB_SPEED_SUPER:
-	case USB_SPEED_SUPER_PLUS:
-		tp->coalesce = COALESCE_SUPER;
-		break;
-	case USB_SPEED_HIGH:
-		tp->coalesce = COALESCE_HIGH;
-		break;
-	default:
-		tp->coalesce = COALESCE_SLOW;
-		break;
-	}
-}
-
-static void r8153b_init(struct r8152 *tp)
-{
-	u32 ocp_data;
-	u16 data;
-	int i;
-
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
-
-	r8153b_u1u2en(tp, false);
-
-	for (i = 0; i < 500; i++) {
-		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
-		    AUTOLOAD_DONE)
-			break;
-
-		msleep(20);
-		if (test_bit(RTL8152_UNPLUG, &tp->flags))
-			break;
-	}
-
-	data = r8153_phy_status(tp, 0);
-
-	data = r8152_mdio_read(tp, MII_BMCR);
-	if (data & BMCR_PDOWN) {
-		data &= ~BMCR_PDOWN;
-		r8152_mdio_write(tp, MII_BMCR, data);
-	}
-
-	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
-
-	r8153_u2p3en(tp, false);
-
-	/* MSC timer = 0xfff * 8ms = 32760 ms */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_MSC_TIMER, 0x0fff);
-
-	r8153b_power_cut_en(tp, false);
-	r8153b_ups_en(tp, false);
-	r8153_queue_wake(tp, false);
-	rtl_runtime_suspend_enable(tp, false);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
-	if (rtl8152_get_speed(tp) & LINK_STATUS)
-		ocp_data |= CUR_LINK_OK;
-	else
-		ocp_data &= ~CUR_LINK_OK;
-	ocp_data |= POLL_LINK_CHG;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
-
-	if (tp->udev->speed >= USB_SPEED_SUPER)
-		r8153b_u1u2en(tp, true);
-
-	usb_enable_lpm(tp->udev);
-
-	/* MAC clock speed down */
-	r8153_mac_clk_speed_down(tp, true);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
-	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
-
-	if (tp->version == RTL_VER_09) {
-		/* Disable Test IO for 32QFN */
-		if (ocp_read_byte(tp, MCU_TYPE_PLA, 0xdc00) & BIT(5)) {
-			ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR);
-			ocp_data |= TEST_IO_OFF;
-			ocp_write_word(tp, MCU_TYPE_PLA, PLA_PHY_PWR, ocp_data);
-		}
-	}
-
-	set_bit(GREEN_ETHERNET, &tp->flags);
-
-	/* rx aggregation */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
-	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
-
-	rtl_tally_reset(tp);
-
-	tp->coalesce = 15000;	/* 15 us */
-}
-
-static void r8153c_init(struct r8152 *tp)
-{
-	u32 ocp_data;
-	u16 data;
-	int i;
-
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
-
-	r8153b_u1u2en(tp, false);
-
-	/* Disable spi_en */
-	ocp_write_byte(tp, MCU_TYPE_PLA, PLA_CRWECR, CRWECR_CONFIG);
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_CONFIG5);
-	ocp_data &= ~BIT(3);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_CONFIG5, ocp_data);
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, 0xcbf0);
-	ocp_data |= BIT(1);
-	ocp_write_word(tp, MCU_TYPE_USB, 0xcbf0, ocp_data);
-
-	for (i = 0; i < 500; i++) {
-		if (ocp_read_word(tp, MCU_TYPE_PLA, PLA_BOOT_CTRL) &
-		    AUTOLOAD_DONE)
-			break;
-
-		msleep(20);
-		if (test_bit(RTL8152_UNPLUG, &tp->flags))
-			return;
-	}
-
-	data = r8153_phy_status(tp, 0);
-
-	data = r8152_mdio_read(tp, MII_BMCR);
-	if (data & BMCR_PDOWN) {
-		data &= ~BMCR_PDOWN;
-		r8152_mdio_write(tp, MII_BMCR, data);
-	}
-
-	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
-
-	r8153_u2p3en(tp, false);
-
-	/* MSC timer = 0xfff * 8ms = 32760 ms */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_MSC_TIMER, 0x0fff);
-
-	r8153b_power_cut_en(tp, false);
-	r8153c_ups_en(tp, false);
-	r8153_queue_wake(tp, false);
-	rtl_runtime_suspend_enable(tp, false);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
-	if (rtl8152_get_speed(tp) & LINK_STATUS)
-		ocp_data |= CUR_LINK_OK;
-	else
-		ocp_data &= ~CUR_LINK_OK;
-
-	ocp_data |= POLL_LINK_CHG;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
-
-	r8153b_u1u2en(tp, true);
-
-	usb_enable_lpm(tp->udev);
-
-	/* MAC clock speed down */
-	r8153_mac_clk_speed_down(tp, true);
-
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_2);
-	ocp_data &= ~BIT(7);
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_MISC_2, ocp_data);
-
-	set_bit(GREEN_ETHERNET, &tp->flags);
-
-	/* rx aggregation */
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_USB_CTRL);
-	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
-	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
-
-	rtl_tally_reset(tp);
-
-	tp->coalesce = 15000;	/* 15 us */
-}
-
-static void r8156_hw_phy_cfg(struct r8152 *tp)
-{
-	u32 ocp_data;
-	u16 data;
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
-	if (ocp_data & PCUT_STATUS) {
-		ocp_data &= ~PCUT_STATUS;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_MISC_0, ocp_data);
-	}
-
-	data = r8153_phy_status(tp, 0);
-	switch (data) {
-	case PHY_STAT_EXT_INIT:
-		rtl8152_apply_firmware(tp, true);
+	data = r8153_phy_status(tp, 0);
+	switch (data) {
+	case PHY_STAT_EXT_INIT:
+		r8156_ram_code(tp, true);
 
 		data = ocp_reg_read(tp, 0xa468);
 		data &= ~(BIT(3) | BIT(1));
@@ -7241,7 +16597,7 @@ static void r8156_hw_phy_cfg(struct r8152 *tp)
 	case PHY_STAT_LAN_ON:
 	case PHY_STAT_PWRDN:
 	default:
-		rtl8152_apply_firmware(tp, false);
+		r8156_ram_code(tp, false);
 		break;
 	}
 
@@ -7363,6 +16719,7 @@ static void r8156_hw_phy_cfg(struct r8152 *tp)
 		ocp_reg_write(tp, 0xbd2c, data);
 		break;
 	case RTL_VER_11:
+		/* 2.5G INRX */
 		data = ocp_reg_read(tp, 0xad16);
 		data |= 0x3ff;
 		ocp_reg_write(tp, 0xad16, data);
@@ -7568,6 +16925,8 @@ static void r8156b_hw_phy_cfg(struct r8152 *tp)
 	u32 ocp_data;
 	u16 data;
 
+	r8156_patch_code(tp);
+
 	switch (tp->version) {
 	case RTL_VER_12:
 		ocp_reg_write(tp, 0xbf86, 0x9000);
@@ -7604,7 +16963,7 @@ static void r8156b_hw_phy_cfg(struct r8152 *tp)
 	data = r8153_phy_status(tp, 0);
 	switch (data) {
 	case PHY_STAT_EXT_INIT:
-		rtl8152_apply_firmware(tp, true);
+		r8156_ram_code(tp, true);
 
 		data = ocp_reg_read(tp, 0xa466);
 		data &= ~BIT(0);
@@ -7617,7 +16976,7 @@ static void r8156b_hw_phy_cfg(struct r8152 *tp)
 	case PHY_STAT_LAN_ON:
 	case PHY_STAT_PWRDN:
 	default:
-		rtl8152_apply_firmware(tp, false);
+		r8156_ram_code(tp, false);
 		break;
 	}
 
@@ -7975,6 +17334,156 @@ static void r8156b_hw_phy_cfg(struct r8152 *tp)
 	set_bit(PHY_RESET, &tp->flags);
 }
 
+static void r8156_hw_phy_cfg_test(struct r8152 *tp)
+{
+	u32 ocp_data;
+	u16 data;
+
+	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
+
+	/* disable ALDPS before updating the PHY parameters */
+	r8153_aldps_en(tp, false);
+
+	/* disable EEE before updating the PHY parameters */
+	r8153_eee_en(tp, false);
+	ocp_reg_write(tp, OCP_EEE_ADV, 0);
+
+	r8156_firmware(tp);
+
+	data = ocp_reg_read(tp, 0xa5d4);
+	data |= BIT(7) | BIT(0);
+	ocp_reg_write(tp, 0xa5d4, data);
+	ocp_reg_write(tp, 0xa5e6, 0x6290);
+
+	data = ocp_reg_read(tp, 0xa5e8);
+	data &= ~BIT(3);
+	ocp_reg_write(tp, 0xa5e8, data);
+	data = ocp_reg_read(tp, 0xa428);
+	data |= BIT(9);
+	ocp_reg_write(tp, 0xa428, data);
+
+	ocp_reg_write(tp, 0xb636, 0x2c00);
+	data = ocp_reg_read(tp, 0xb460);
+	data &= ~BIT(13);
+	ocp_reg_write(tp, 0xb460, data);
+	ocp_reg_write(tp, 0xb83e, 0x00a9);
+	ocp_reg_write(tp, 0xb840, 0x0035);
+	ocp_reg_write(tp, 0xb680, 0x0022);
+	ocp_reg_write(tp, 0xb468, 0x10c0);
+	ocp_reg_write(tp, 0xb468, 0x90c0);
+
+	data = ocp_reg_read(tp, 0xb60a);
+	data &= ~0xfff;
+	data |= 0xc0;
+	ocp_reg_write(tp, 0xb60a, data);
+	data = ocp_reg_read(tp, 0xb628);
+	data &= ~0xfff;
+	data |= 0xc0;
+	ocp_reg_write(tp, 0xb628, data);
+	data = ocp_reg_read(tp, 0xb62a);
+	data &= ~0xfff;
+	data |= 0xc0;
+	ocp_reg_write(tp, 0xb62a, data);
+
+	data = ocp_reg_read(tp, 0xbc1e);
+	data &= 0xf;
+	data |= (data << 4) | (data << 8) | (data << 12);
+	ocp_reg_write(tp, 0xbce0, data);
+	data = ocp_reg_read(tp, 0xbd42);
+	data &= ~BIT(8);
+	ocp_reg_write(tp, 0xbd42, data);
+
+	data = ocp_reg_read(tp, 0xbf90);
+	data &= ~0xf0;
+	data |= BIT(7);
+	ocp_reg_write(tp, 0xbf90, data);
+	data = ocp_reg_read(tp, 0xbf92);
+	data &= ~0x3f;
+	data |= 0x3fc0;
+	ocp_reg_write(tp, 0xbf92, data);
+
+	data = ocp_reg_read(tp, 0xbf94);
+	data |= 0x3e00;
+	ocp_reg_write(tp, 0xbf94, data);
+	data = ocp_reg_read(tp, 0xbf88);
+	data &= ~0x3eff;
+	data |= 0x1e01;
+	ocp_reg_write(tp, 0xbf88, data);
+
+	data = ocp_reg_read(tp, 0xbc58);
+	data &= ~BIT(1);
+	ocp_reg_write(tp, 0xbc58, data);
+
+	data = ocp_reg_read(tp, 0xbd0c);
+	data &= ~0x3f;
+	ocp_reg_write(tp, 0xbd0c, data);
+
+	data = ocp_reg_read(tp, 0xbcc2);
+	data &= ~BIT(14);
+	ocp_reg_write(tp, 0xbcc2, data);
+
+	ocp_reg_write(tp, 0xd098, 0x0427);
+
+	data = ocp_reg_read(tp, 0xa430);
+	data &= ~BIT(12);
+	ocp_reg_write(tp, 0xa430, data);
+
+	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, 0xe84c);
+	ocp_data |= BIT(6);
+	ocp_write_dword(tp, MCU_TYPE_PLA, 0xe84c, ocp_data);
+
+	data = ocp_reg_read(tp, 0xbeb4);
+	data &= ~BIT(1);
+	ocp_reg_write(tp, 0xbeb4, data);
+	data = ocp_reg_read(tp, 0xbf0c);
+	data &= ~BIT(13);
+	data |= BIT(12);
+	ocp_reg_write(tp, 0xbf0c, data);
+	data = ocp_reg_read(tp, 0xbd44);
+	data &= ~BIT(2);
+	ocp_reg_write(tp, 0xbd44, data);
+
+	data = ocp_reg_read(tp, 0xa442);
+	data |= BIT(11);
+	ocp_reg_write(tp, 0xa442, data);
+	ocp_data = ocp_read_dword(tp, MCU_TYPE_PLA, 0xe84c);
+	ocp_data |= BIT(7);
+	ocp_write_dword(tp, MCU_TYPE_PLA, 0xe84c, ocp_data);
+
+	r8156_lock_main(tp, true);
+	data = ocp_reg_read(tp, 0xcc46);
+	data &= ~0x700;
+	ocp_reg_write(tp, 0xcc46, data);
+	data = ocp_reg_read(tp, 0xcc46);
+	data &= ~0x70;
+	ocp_reg_write(tp, 0xcc46, data);
+	data = ocp_reg_read(tp, 0xcc46);
+	data &= ~0x70;
+	data |= BIT(6) | BIT(4);
+	ocp_reg_write(tp, 0xcc46, data);
+	r8156_lock_main(tp, false);
+
+	data = ocp_reg_read(tp, 0xbd38);
+	data &= ~BIT(13);
+	ocp_reg_write(tp, 0xbd38, data);
+	data = ocp_reg_read(tp, 0xbd38);
+	data |= BIT(12);
+	ocp_reg_write(tp, 0xbd38, data);
+	ocp_reg_write(tp, 0xbd36, 0x0fb4);
+	data = ocp_reg_read(tp, 0xbd38);
+	data |= BIT(13);
+	ocp_reg_write(tp, 0xbd38, data);
+
+//	if (tp->eee_en) {
+//		r8153_eee_en(tp, true);
+//		ocp_reg_write(tp, OCP_EEE_ADV, tp->eee_adv);
+//	}
+
+	r8153_aldps_en(tp, true);
+	r8152b_enable_fc(tp);
+	r8153_u2p3en(tp, true);
+}
+
 static void r8156_init(struct r8152 *tp)
 {
 	u32 ocp_data;
@@ -8040,17 +17549,31 @@ static void r8156_init(struct r8152 *tp)
 
 	usb_enable_lpm(tp->udev);
 
-	r8156_mac_clk_spd(tp, true);
+//	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, 0xd850) & 0xc000;
+//	switch (ocp_data) {
+//	case 0x4000:
+//		tp->dash_mode = 1;
+//		r8156_mac_clk_spd(tp, false);
+//		break;
+//	case 0x8000:
+//		tp->dash_mode = 0;
+		r8156_mac_clk_spd(tp, true);
+//		break;
+//	default:
+//		netif_warn(tp, drv, tp->netdev, "Invalid type %x\n", ocp_data);
+//		break;
+//	}
 
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
-	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+
+	r8153b_mcu_spdown_en(tp, false);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
 	if (rtl8152_get_speed(tp) & LINK_STATUS)
 		ocp_data |= CUR_LINK_OK;
 	else
 		ocp_data &= ~CUR_LINK_OK;
+	/* r8153_queue_wake() has cleared this bit */
+	/* ocp_data &= ~BIT(8); */
 	ocp_data |= POLL_LINK_CHG;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
 
@@ -8061,6 +17584,12 @@ static void r8156_init(struct r8152 *tp)
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
 	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
 
+	/* Set Rx aggregation parameters to default value
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, 0xd4c9);
+	ocp_data |= BIT(2);
+	ocp_write_byte(tp, MCU_TYPE_USB, 0xd4c9, ocp_data);
+	*/
+
 	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_BMU_CONFIG);
 	ocp_data |= ACT_ODMA;
 	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_CONFIG, ocp_data);
@@ -8175,16 +17704,15 @@ static void r8156b_init(struct r8152 *tp)
 	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
 
 	r8156_mac_clk_spd(tp, true);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3);
-	ocp_data &= ~PLA_MCU_SPDWN_EN;
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_MAC_PWR_CTRL3, ocp_data);
+	r8153b_mcu_spdown_en(tp, false);
 
 	ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS);
 	if (rtl8152_get_speed(tp) & LINK_STATUS)
 		ocp_data |= CUR_LINK_OK;
 	else
 		ocp_data &= ~CUR_LINK_OK;
+	/* r8153_queue_wake() has cleared this bit */
+	/* ocp_data &= ~BIT(8); */
 	ocp_data |= POLL_LINK_CHG;
 	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, ocp_data);
 
@@ -8195,6 +17723,12 @@ static void r8156b_init(struct r8152 *tp)
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
 	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
 
+	/* Set Rx aggregation parameters to default value
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, 0xd4c9);
+	ocp_data |= BIT(2);
+	ocp_write_byte(tp, MCU_TYPE_USB, 0xd4c9, ocp_data);
+	*/
+
 	r8156_mdio_force_mode(tp);
 	rtl_tally_reset(tp);
 
@@ -8204,6 +17738,64 @@ static void r8156b_init(struct r8152 *tp)
 static bool rtl_check_vendor_ok(struct usb_interface *intf)
 {
 	struct usb_host_interface *alt = intf->cur_altsetting;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,12,0)
+	struct usb_host_endpoint *in = NULL, *out = NULL, *intr = NULL;
+	unsigned int ep;
+
+	if (alt->desc.bNumEndpoints < 3) {
+		dev_err(&intf->dev, "Unexpected bNumEndpoints %d\n", alt->desc.bNumEndpoints);
+		return false;
+	}
+
+	for (ep = 0; ep < alt->desc.bNumEndpoints; ep++) {
+		struct usb_host_endpoint *e;
+
+		e = alt->endpoint + ep;
+
+		/* ignore endpoints which cannot transfer data */
+		if (!usb_endpoint_maxp(&e->desc))
+			continue;
+
+		switch (e->desc.bmAttributes) {
+		case USB_ENDPOINT_XFER_INT:
+			if (!usb_endpoint_dir_in(&e->desc))
+				continue;
+			if (!intr)
+				intr = e;
+			break;
+		case USB_ENDPOINT_XFER_BULK:
+			if (usb_endpoint_dir_in(&e->desc)) {
+				if (!in)
+					in = e;
+			} else if (!out) {
+				out = e;
+			}
+			break;
+		default:
+			continue;
+		}
+	}
+
+	if (!in || !out || !intr) {
+		dev_err(&intf->dev, "Miss Endpoints\n");
+		return false;
+	}
+
+	if ((in->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 1) {
+		dev_err(&intf->dev, "Invalid Rx endpoint address\n");
+		return false;
+	}
+
+	if ((out->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 2) {
+		dev_err(&intf->dev, "Invalid Tx endpoint address\n");
+		return false;
+	}
+
+	if ((intr->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 3) {
+		dev_err(&intf->dev, "Invalid interrupt endpoint address\n");
+		return false;
+	}
+#else
 	struct usb_endpoint_descriptor *in, *out, *intr;
 
 	if (usb_find_common_endpoints(alt, &in, &out, &intr, NULL) < 0) {
@@ -8228,6 +17820,7 @@ static bool rtl_check_vendor_ok(struct usb_interface *intf)
 		dev_err(&intf->dev, "Invalid interrupt endpoint address\n");
 		return false;
 	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,12,0) */
 
 	return true;
 }
@@ -8242,6 +17835,9 @@ static bool rtl_vendor_mode(struct usb_interface *intf)
 	if (alt->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC)
 		return rtl_check_vendor_ok(intf);
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
+	dev_err(&intf->dev, "The kernel is too old to set configuration\n");
+#else
 	/* The vendor mode is not always config #1, so to find it out. */
 	udev = interface_to_usbdev(intf);
 	c = udev->config;
@@ -8265,6 +17861,7 @@ static bool rtl_vendor_mode(struct usb_interface *intf)
 
 	if (i == num_configs)
 		dev_err(&intf->dev, "Unexpected Device\n");
+#endif
 
 	return false;
 }
@@ -8283,7 +17880,9 @@ static int rtl8152_pre_reset(struct usb_interface *intf)
 
 	netif_stop_queue(netdev);
 	tasklet_disable(&tp->tx_tl);
+	smp_mb__before_atomic();
 	clear_bit(WORK_ENABLE, &tp->flags);
+	smp_mb__after_atomic();
 	usb_kill_urb(tp->intr_urb);
 	cancel_delayed_work_sync(&tp->schedule);
 	napi_disable(&tp->napi);
@@ -8308,7 +17907,11 @@ static int rtl8152_post_reset(struct usb_interface *intf)
 	/* reset the MAC address in case of policy change */
 	if (determine_ethernet_addr(tp, &sa) >= 0) {
 		rtnl_lock();
-		dev_set_mac_address (tp->netdev, &sa, NULL);
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0)
+		dev_set_mac_address(tp->netdev, &sa);
+#else
+		dev_set_mac_address(tp->netdev, &sa, NULL);
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0) */
 		rtnl_unlock();
 	}
 
@@ -8316,12 +17919,14 @@ static int rtl8152_post_reset(struct usb_interface *intf)
 	if (!netif_running(netdev))
 		return 0;
 
+	smp_mb__before_atomic();
 	set_bit(WORK_ENABLE, &tp->flags);
+	smp_mb__after_atomic();
 	if (netif_carrier_ok(netdev)) {
 		mutex_lock(&tp->control);
 		tp->rtl_ops.enable(tp);
 		rtl_start_rx(tp);
-		_rtl8152_set_rx_mode(netdev);
+		rtl8152_set_rx_mode(netdev);
 		mutex_unlock(&tp->control);
 	}
 
@@ -8368,7 +17973,9 @@ static int rtl8152_runtime_resume(struct r8152 *tp)
 
 		tp->rtl_ops.autosuspend_en(tp, false);
 		napi_disable(napi);
+		smp_mb__before_atomic();
 		set_bit(WORK_ENABLE, &tp->flags);
+		smp_mb__after_atomic();
 
 		if (netif_carrier_ok(netdev)) {
 			if (rtl8152_get_speed(tp) & LINK_STATUS) {
@@ -8384,8 +17991,11 @@ static int rtl8152_runtime_resume(struct r8152 *tp)
 		clear_bit(SELECTIVE_SUSPEND, &tp->flags);
 		smp_mb__after_atomic();
 
-		if (!list_empty(&tp->rx_done))
+		if (!list_empty(&tp->rx_done)) {
+			local_bh_disable();
 			napi_schedule(&tp->napi);
+			local_bh_enable();
+		}
 
 		usb_submit_urb(tp->intr_urb, GFP_NOIO);
 	} else {
@@ -8393,6 +18003,7 @@ static int rtl8152_runtime_resume(struct r8152 *tp)
 			tp->rtl_ops.autosuspend_en(tp, false);
 
 		clear_bit(SELECTIVE_SUSPEND, &tp->flags);
+		smp_mb__after_atomic();
 	}
 
 	return 0;
@@ -8407,7 +18018,12 @@ static int rtl8152_system_resume(struct r8152 *tp)
 	if (netif_running(netdev) && (netdev->flags & IFF_UP)) {
 		tp->rtl_ops.up(tp);
 		netif_carrier_off(netdev);
+		smp_mb__before_atomic();
 		set_bit(WORK_ENABLE, &tp->flags);
+		smp_mb__after_atomic();
+		if (test_and_clear_bit(RECOVER_SPEED, &tp->flags))
+			rtl8152_set_speed(tp, tp->autoneg, tp->speed,
+					  tp->duplex, tp->advertising);
 		usb_submit_urb(tp->intr_urb, GFP_NOIO);
 	}
 
@@ -8447,7 +18063,9 @@ static int rtl8152_runtime_suspend(struct r8152 *tp)
 			}
 		}
 
+		smp_mb__before_atomic();
 		clear_bit(WORK_ENABLE, &tp->flags);
+		smp_mb__after_atomic();
 		usb_kill_urb(tp->intr_urb);
 
 		tp->rtl_ops.autosuspend_en(tp, true);
@@ -8481,12 +18099,20 @@ static int rtl8152_system_suspend(struct r8152 *tp)
 	if (netif_running(netdev) && test_bit(WORK_ENABLE, &tp->flags)) {
 		struct napi_struct *napi = &tp->napi;
 
+		smp_mb__before_atomic();
 		clear_bit(WORK_ENABLE, &tp->flags);
+		smp_mb__after_atomic();
 		usb_kill_urb(tp->intr_urb);
 		tasklet_disable(&tp->tx_tl);
 		napi_disable(napi);
 		cancel_delayed_work_sync(&tp->schedule);
 		tp->rtl_ops.down(tp);
+
+		if (tp->version == RTL_VER_01)
+			rtl8152_set_speed(tp, AUTONEG_ENABLE, 0, 0, 3);
+		else
+			rtl_speed_down(tp);
+
 		napi_enable(napi);
 		tasklet_enable(&tp->tx_tl);
 	}
@@ -8609,53 +18235,339 @@ static void rtl8152_get_drvinfo(struct net_device *netdev,
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
-	strscpy(info->driver, MODULENAME, sizeof(info->driver));
-	strscpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strlcpy(info->driver, MODULENAME, sizeof(info->driver));
+	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
 	usb_make_path(tp->udev, info->bus_info, sizeof(info->bus_info));
-	if (!IS_ERR_OR_NULL(tp->rtl_fw.fw))
-		strscpy(info->fw_version, tp->rtl_fw.version,
-			sizeof(info->fw_version));
 }
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
 static
-int rtl8152_get_link_ksettings(struct net_device *netdev,
-			       struct ethtool_link_ksettings *cmd)
+int rtl8152_get_settings(struct net_device *netdev, struct ethtool_cmd *cmd)
 {
 	struct r8152 *tp = netdev_priv(netdev);
-	int ret;
+	u16 bmcr, bmsr;
+	int ret, advert;
 
-	if (!tp->mii.mdio_read)
-		return -EOPNOTSUPP;
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		goto out;
+
+	cmd->supported =
+	    (SUPPORTED_10baseT_Half | SUPPORTED_10baseT_Full |
+	     SUPPORTED_100baseT_Half | SUPPORTED_100baseT_Full |
+	     SUPPORTED_Autoneg | SUPPORTED_MII);
+
+	/* only supports twisted-pair */
+	cmd->port = PORT_MII;
+
+	/* only supports internal transceiver */
+	cmd->transceiver = XCVR_INTERNAL;
+	cmd->phy_address = 32;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
+	cmd->mdio_support = ETH_MDIO_SUPPORTS_C22;
+#endif
+	cmd->advertising = ADVERTISED_MII;
+
+	mutex_lock(&tp->control);
+
+	bmcr = r8152_mdio_read(tp, MII_BMCR);
+	bmsr = r8152_mdio_read(tp, MII_BMSR);
+
+	advert = r8152_mdio_read(tp, MII_ADVERTISE);
+	if (advert & ADVERTISE_10HALF)
+		cmd->advertising |= ADVERTISED_10baseT_Half;
+	if (advert & ADVERTISE_10FULL)
+		cmd->advertising |= ADVERTISED_10baseT_Full;
+	if (advert & ADVERTISE_100HALF)
+		cmd->advertising |= ADVERTISED_100baseT_Half;
+	if (advert & ADVERTISE_100FULL)
+		cmd->advertising |= ADVERTISED_100baseT_Full;
+	if (advert & ADVERTISE_PAUSE_CAP)
+		cmd->advertising |= ADVERTISED_Pause;
+	if (advert & ADVERTISE_PAUSE_ASYM)
+		cmd->advertising |= ADVERTISED_Asym_Pause;
+	if (tp->mii.supports_gmii) {
+		u16 ctrl1000 = r8152_mdio_read(tp, MII_CTRL1000);
+
+		cmd->supported |= SUPPORTED_1000baseT_Full;
+
+		if (tp->support_2500full) {
+			u16 data = ocp_reg_read(tp, 0xa5d4);
+
+			cmd->supported |= SUPPORTED_2500baseX_Full;
+			if (data & BIT(7))
+				cmd->advertising |= ADVERTISED_2500baseX_Full;
+		}
+
+		if (ctrl1000 & ADVERTISE_1000HALF)
+			cmd->advertising |= ADVERTISED_1000baseT_Half;
+		if (ctrl1000 & ADVERTISE_1000FULL)
+			cmd->advertising |= ADVERTISED_1000baseT_Full;
+	}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
+	if (bmsr & BMSR_ANEGCOMPLETE) {
+		advert = r8152_mdio_read(tp, MII_LPA);
+		if (advert & LPA_LPACK)
+			cmd->lp_advertising |= ADVERTISED_Autoneg;
+		if (advert & ADVERTISE_10HALF)
+			cmd->lp_advertising |=
+				ADVERTISED_10baseT_Half;
+		if (advert & ADVERTISE_10FULL)
+			cmd->lp_advertising |=
+				ADVERTISED_10baseT_Full;
+		if (advert & ADVERTISE_100HALF)
+			cmd->lp_advertising |=
+				ADVERTISED_100baseT_Half;
+		if (advert & ADVERTISE_100FULL)
+			cmd->lp_advertising |=
+				ADVERTISED_100baseT_Full;
+
+		if (tp->mii.supports_gmii) {
+			u16 stat1000 = r8152_mdio_read(tp, MII_STAT1000);
+
+			if (stat1000 & LPA_1000HALF)
+				cmd->lp_advertising |=
+					ADVERTISED_1000baseT_Half;
+			if (stat1000 & LPA_1000FULL)
+				cmd->lp_advertising |=
+					ADVERTISED_1000baseT_Full;
+		}
+	} else {
+		cmd->lp_advertising = 0;
+	}
+#endif
+
+	if (bmcr & BMCR_ANENABLE) {
+		cmd->advertising |= ADVERTISED_Autoneg;
+		cmd->autoneg = AUTONEG_ENABLE;
+	} else {
+		cmd->autoneg = AUTONEG_DISABLE;
+	}
+
+
+	if (netif_running(netdev) && netif_carrier_ok(netdev)) {
+		u16 speed = rtl8152_get_speed(tp);
+
+		if (speed & _100bps)
+			cmd->speed = SPEED_100;
+		else if (speed & _10bps)
+			cmd->speed = SPEED_10;
+		else if (tp->mii.supports_gmii && (speed & _1000bps))
+			cmd->speed = SPEED_1000;
+		else if (tp->support_2500full && (speed & _2500bps))
+			cmd->speed = SPEED_2500;
+
+		cmd->duplex = (speed & FULL_DUP) ? DUPLEX_FULL : DUPLEX_HALF;
+	} else {
+		cmd->speed = SPEED_UNKNOWN;
+		cmd->duplex = DUPLEX_UNKNOWN;
+	}
+
+	mutex_unlock(&tp->control);
+
+	usb_autopm_put_interface(tp->intf);
+
+out:
+	return ret;
+}
+
+static int rtl8152_set_settings(struct net_device *dev, struct ethtool_cmd *cmd)
+{
+	struct r8152 *tp = netdev_priv(dev);
+	u32 advertising = 0;
+	int ret;
 
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		goto out;
 
+	if (cmd->advertising & ADVERTISED_10baseT_Half)
+		advertising |= RTL_ADVERTISED_10_HALF;
+	if (cmd->advertising & ADVERTISED_10baseT_Full)
+		advertising |= RTL_ADVERTISED_10_FULL;
+	if (cmd->advertising & ADVERTISED_100baseT_Half)
+		advertising |= RTL_ADVERTISED_100_HALF;
+	if (cmd->advertising & ADVERTISED_100baseT_Full)
+		advertising |= RTL_ADVERTISED_100_FULL;
+	if (cmd->advertising & ADVERTISED_1000baseT_Half)
+		advertising |= RTL_ADVERTISED_1000_HALF;
+	if (cmd->advertising & ADVERTISED_1000baseT_Full)
+		advertising |= RTL_ADVERTISED_1000_FULL;
+	if (cmd->advertising & ADVERTISED_2500baseX_Full)
+		advertising |= RTL_ADVERTISED_2500_FULL;
+
 	mutex_lock(&tp->control);
 
-	mii_ethtool_get_link_ksettings(&tp->mii, cmd);
+	ret = rtl8152_set_speed(tp, cmd->autoneg, cmd->speed, cmd->duplex,
+				advertising);
+	if (!ret) {
+		tp->autoneg = cmd->autoneg;
+		tp->speed = cmd->speed;
+		tp->duplex = cmd->duplex;
+		tp->advertising = advertising;
+	}
+
+	mutex_unlock(&tp->control);
+
+	usb_autopm_put_interface(tp->intf);
+
+out:
+	return ret;
+}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0) */
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0)
+static int rtl8152_get_link_ksettings(struct net_device *netdev,
+				      struct ethtool_link_ksettings *cmd)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	u16 bmcr, bmsr, advert;
+	int ret;
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		goto out1;
 
+	/* only supports twisted-pair */
+	cmd->base.port = PORT_MII;
+
+	/* this isn't fully supported at higher layers */
+	cmd->base.phy_address = 32;
+	cmd->base.mdio_support = ETH_MDIO_SUPPORTS_C22;
+
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+			 cmd->link_modes.supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+			 cmd->link_modes.supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+			 cmd->link_modes.supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+			 cmd->link_modes.supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			 cmd->link_modes.supported);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT,
+			 cmd->link_modes.supported);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+			 cmd->link_modes.supported, tp->mii.supports_gmii);
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
 			 cmd->link_modes.supported, tp->support_2500full);
 
+	ret = mutex_lock_interruptible(&tp->control);
+	if (ret < 0)
+		goto out2;
+
+	bmcr = r8152_mdio_read(tp, MII_BMCR);
+	bmsr = r8152_mdio_read(tp, MII_BMSR);
+
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			 cmd->link_modes.advertising, bmcr & BMCR_ANENABLE);
+
+	if (bmcr & BMCR_ANENABLE)
+		cmd->base.autoneg = AUTONEG_ENABLE;
+	else
+		cmd->base.autoneg = AUTONEG_DISABLE;
+
+	advert = r8152_mdio_read(tp, MII_ADVERTISE);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+			 cmd->link_modes.advertising,
+			 advert & ADVERTISE_10HALF);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
+			 cmd->link_modes.advertising,
+			 advert & ADVERTISE_10FULL);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+			 cmd->link_modes.advertising,
+			 advert & ADVERTISE_100HALF);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+			 cmd->link_modes.advertising,
+			 advert & ADVERTISE_100FULL);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			 cmd->link_modes.advertising,
+			 advert & ADVERTISE_PAUSE_CAP);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			 cmd->link_modes.advertising,
+			 advert & ADVERTISE_PAUSE_ASYM);
+
+	if (tp->mii.supports_gmii) {
+		u16 ctrl1000 = r8152_mdio_read(tp, MII_CTRL1000);
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+				 cmd->link_modes.advertising,
+				 ctrl1000 & ADVERTISE_1000HALF);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+				 cmd->link_modes.advertising,
+				 ctrl1000 & ADVERTISE_1000FULL);
+	}
+
 	if (tp->support_2500full) {
 		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
 				 cmd->link_modes.advertising,
 				 ocp_reg_read(tp, OCP_10GBT_CTRL) & MDIO_AN_10GBT_CTRL_ADV2_5G);
+	}
 
-		linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+	if (bmsr & BMSR_ANEGCOMPLETE) {
+		advert = r8152_mdio_read(tp, MII_LPA);
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				 cmd->link_modes.lp_advertising,
+				 advert & LPA_LPACK);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Half_BIT,
+				 cmd->link_modes.lp_advertising,
+				 advert & ADVERTISE_10HALF);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT_Full_BIT,
 				 cmd->link_modes.lp_advertising,
-				 ocp_reg_read(tp, OCP_10GBT_STAT) & MDIO_AN_10GBT_STAT_LP2_5G);
+				 advert & ADVERTISE_10FULL);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Half_BIT,
+				 cmd->link_modes.lp_advertising,
+				 advert & ADVERTISE_100HALF);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT,
+				 cmd->link_modes.lp_advertising,
+				 advert & ADVERTISE_100FULL);
+
+		if (tp->mii.supports_gmii) {
+			u16 stat1000 = r8152_mdio_read(tp, MII_STAT1000);
+
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
+					 cmd->link_modes.lp_advertising,
+					 stat1000 & LPA_1000HALF);
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
+					 cmd->link_modes.lp_advertising,
+					 stat1000 & LPA_1000FULL);
+		}
+
+		if (tp->support_2500full) {
+			u16 data = ocp_reg_read(tp, OCP_10GBT_STAT);
+
+			linkmode_mod_bit(ETHTOOL_LINK_MODE_2500baseT_Full_BIT,
+					 cmd->link_modes.lp_advertising,
+					 data & MDIO_AN_10GBT_STAT_LP2_5G);
+		}
+	}
 
-		if (is_speed_2500(rtl8152_get_speed(tp)))
+	if (netif_running(netdev) && netif_carrier_ok(netdev)) {
+		u16 speed = rtl8152_get_speed(tp);
+
+		if (speed & _100bps)
+			cmd->base.speed = SPEED_100;
+		else if (speed & _10bps)
+			cmd->base.speed = SPEED_10;
+		else if (tp->mii.supports_gmii && (speed & _1000bps))
+			cmd->base.speed = SPEED_1000;
+		else if (tp->support_2500full && (speed & _2500bps))
 			cmd->base.speed = SPEED_2500;
+
+		cmd->base.duplex = (speed & FULL_DUP) ? DUPLEX_FULL :
+							DUPLEX_HALF;
+	} else {
+		cmd->base.speed = SPEED_UNKNOWN;
+		cmd->base.duplex = DUPLEX_UNKNOWN;
 	}
 
 	mutex_unlock(&tp->control);
 
+out2:
 	usb_autopm_put_interface(tp->intf);
-
-out:
+out1:
 	return ret;
 }
 
@@ -8716,6 +18628,7 @@ static int rtl8152_set_link_ksettings(struct net_device *dev,
 out:
 	return ret;
 }
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0) */
 
 static const char rtl8152_gstrings[][ETH_GSTRING_LEN] = {
 	"tx_packets",
@@ -8733,6 +18646,12 @@ static const char rtl8152_gstrings[][ETH_GSTRING_LEN] = {
 	"tx_underrun",
 };
 
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
+static int rtl8152_get_sset_count(struct net_device *dev)
+{
+	return ARRAY_SIZE(rtl8152_gstrings);
+}
+#else
 static int rtl8152_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
@@ -8742,6 +18661,7 @@ static int rtl8152_get_sset_count(struct net_device *dev, int sset)
 		return -EOPNOTSUPP;
 	}
 }
+#endif
 
 static void rtl8152_get_ethtool_stats(struct net_device *dev,
 				      struct ethtool_stats *stats, u64 *data)
@@ -8752,8 +18672,15 @@ static void rtl8152_get_ethtool_stats(struct net_device *dev,
 	if (usb_autopm_get_interface(tp->intf) < 0)
 		return;
 
+	if (mutex_lock_interruptible(&tp->control) < 0) {
+		usb_autopm_put_interface(tp->intf);
+		return;
+	}
+
 	generic_ocp_read(tp, PLA_TALLYCNT, sizeof(tally), &tally, MCU_TYPE_PLA);
 
+	mutex_unlock(&tp->control);
+
 	usb_autopm_put_interface(tp->intf);
 
 	data[0] = le64_to_cpu(tally.tx_packets);
@@ -8780,6 +18707,7 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	}
 }
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 static int r8152_get_eee(struct r8152 *tp, struct ethtool_eee *eee)
 {
 	u32 lp, adv, supported = 0;
@@ -8884,7 +18812,7 @@ rtl_ethtool_set_eee(struct net_device *net, struct ethtool_eee *edata)
 
 	ret = tp->rtl_ops.eee_set(tp, edata);
 	if (!ret)
-		ret = mii_nway_restart(&tp->mii);
+		ret = rtl_nway_restart(tp);
 
 	mutex_unlock(&tp->control);
 
@@ -8893,6 +18821,7 @@ rtl_ethtool_set_eee(struct net_device *net, struct ethtool_eee *edata)
 out:
 	return ret;
 }
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 
 static int rtl8152_nway_reset(struct net_device *dev)
 {
@@ -8905,7 +18834,7 @@ static int rtl8152_nway_reset(struct net_device *dev)
 
 	mutex_lock(&tp->control);
 
-	ret = mii_nway_restart(&tp->mii);
+	ret = rtl_nway_restart(tp);
 
 	mutex_unlock(&tp->control);
 
@@ -8916,694 +18845,1677 @@ static int rtl8152_nway_reset(struct net_device *dev)
 }
 
 static int rtl8152_get_coalesce(struct net_device *netdev,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
+				struct ethtool_coalesce *coalesce)
+#else
+				struct ethtool_coalesce *coalesce,
+				struct kernel_ethtool_coalesce *kernel_coal,
+				struct netlink_ext_ack *extack)
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_07:
+		return -EOPNOTSUPP;
+	default:
+		break;
+	}
+
+	coalesce->rx_coalesce_usecs = tp->coalesce / 1000;
+
+	return 0;
+}
+
+static int rtl8152_set_coalesce(struct net_device *netdev,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
+				struct ethtool_coalesce *coalesce)
+#else
 				struct ethtool_coalesce *coalesce,
 				struct kernel_ethtool_coalesce *kernel_coal,
 				struct netlink_ext_ack *extack)
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
 {
 	struct r8152 *tp = netdev_priv(netdev);
+	u32 rx_coalesce_nsecs;
+	int ret;
 
 	switch (tp->version) {
 	case RTL_VER_01:
 	case RTL_VER_02:
 	case RTL_VER_07:
+	case RTL_TEST_01: /* fix me */
+		return -EOPNOTSUPP;
+	default:
+		break;
+	}
+
+	rx_coalesce_nsecs = coalesce->rx_coalesce_usecs * 1000;
+
+	if (rx_coalesce_nsecs > COALESCE_SLOW)
+		return -EINVAL;
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&tp->control);
+
+	if (tp->coalesce != rx_coalesce_nsecs) {
+		tp->coalesce = rx_coalesce_nsecs;
+
+		if (netif_running(netdev) && netif_carrier_ok(netdev)) {
+			netif_stop_queue(netdev);
+			napi_disable(&tp->napi);
+			tp->rtl_ops.disable(tp);
+			tp->rtl_ops.enable(tp);
+			rtl_start_rx(tp);
+			napi_enable(&tp->napi);
+			rtl8152_set_rx_mode(netdev);
+			netif_wake_queue(netdev);
+		}
+	}
+
+	mutex_unlock(&tp->control);
+
+	usb_autopm_put_interface(tp->intf);
+
+	return ret;
+}
+
+static int rtl8152_ethtool_begin(struct net_device *netdev)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	if (unlikely(tp->rtk_enable_diag))
+		return -EBUSY;
+
+	return 0;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,0)
+static int rtl8152_get_tunable(struct net_device *netdev,
+			       const struct ethtool_tunable *tunable, void *d)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	switch (tunable->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		*(u32 *)d = tp->rx_copybreak;
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int rtl8152_set_tunable(struct net_device *netdev,
+			       const struct ethtool_tunable *tunable,
+			       const void *d)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	u32 val;
+
+	switch (tunable->id) {
+	case ETHTOOL_RX_COPYBREAK:
+		val = *(u32 *)d;
+		if (val < ETH_ZLEN) {
+			netif_err(tp, rx_err, netdev,
+				  "Invalid rx copy break value\n");
+			return -EINVAL;
+		}
+
+		if (tp->rx_copybreak != val) {
+			if (netdev->flags & IFF_UP) {
+				mutex_lock(&tp->control);
+				napi_disable(&tp->napi);
+				tp->rx_copybreak = val;
+				napi_enable(&tp->napi);
+				mutex_unlock(&tp->control);
+			} else {
+				tp->rx_copybreak = val;
+			}
+		}
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,0) */
+
+static void rtl8152_get_ringparam(struct net_device *netdev,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,17,0)
+				  struct ethtool_ringparam *ring)
+#else
+				  struct ethtool_ringparam *ring,
+				  struct kernel_ethtool_ringparam *kernel_ring,
+				  struct netlink_ext_ack *extack)
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	ring->rx_max_pending = RTL8152_RX_MAX_PENDING;
+	ring->rx_pending = tp->rx_pending;
+}
+
+static int rtl8152_set_ringparam(struct net_device *netdev,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,17,0)
+				 struct ethtool_ringparam *ring)
+#else
+				 struct ethtool_ringparam *ring,
+				 struct kernel_ethtool_ringparam *kernel_ring,
+				 struct netlink_ext_ack *extack)
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
+{
+	struct r8152 *tp = netdev_priv(netdev);
+
+	if (ring->rx_pending < (RTL8152_MAX_RX * 2))
+		return -EINVAL;
+
+	if (tp->rx_pending != ring->rx_pending) {
+		if (netdev->flags & IFF_UP) {
+			mutex_lock(&tp->control);
+			napi_disable(&tp->napi);
+			tp->rx_pending = ring->rx_pending;
+			napi_enable(&tp->napi);
+			mutex_unlock(&tp->control);
+		} else {
+			tp->rx_pending = ring->rx_pending;
+		}
+	}
+
+	return 0;
+}
+
+static void rtl8152_get_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	u16 bmcr, lcladv, rmtadv;
+	u8 cap;
+
+	if (usb_autopm_get_interface(tp->intf) < 0)
+		return;
+
+	mutex_lock(&tp->control);
+
+	bmcr = r8152_mdio_read(tp, MII_BMCR);
+	lcladv = r8152_mdio_read(tp, MII_ADVERTISE);
+	rmtadv = r8152_mdio_read(tp, MII_LPA);
+
+	mutex_unlock(&tp->control);
+
+	usb_autopm_put_interface(tp->intf);
+
+	if (!(bmcr & BMCR_ANENABLE)) {
+		pause->autoneg = 0;
+		pause->rx_pause = 0;
+		pause->tx_pause = 0;
+		return;
+	}
+
+	pause->autoneg = 1;
+
+	cap = mii_resolve_flowctrl_fdx(lcladv, rmtadv);
+
+	if (cap & FLOW_CTRL_RX)
+		pause->rx_pause = 1;
+
+	if (cap & FLOW_CTRL_TX)
+		pause->tx_pause = 1;
+}
+
+static int rtl8152_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	u16 old, new1;
+	u8 cap = 0;
+	int ret;
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&tp->control);
+
+	if (pause->autoneg && !(r8152_mdio_read(tp, MII_BMCR) & BMCR_ANENABLE)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (pause->rx_pause)
+		cap |= FLOW_CTRL_RX;
+
+	if (pause->tx_pause)
+		cap |= FLOW_CTRL_TX;
+
+	old = r8152_mdio_read(tp, MII_ADVERTISE);
+	new1 = (old & ~(ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM)) | mii_advertise_flowctrl(cap);
+	if (old != new1)
+		r8152_mdio_write(tp, MII_ADVERTISE, new1);
+
+	if (new1 & (ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM))
+		tp->ups_info.flow_control = true;
+	else
+		tp->ups_info.flow_control = false;
+
+out:
+	mutex_unlock(&tp->control);
+	usb_autopm_put_interface(tp->intf);
+
+	return ret;
+}
+
+static const struct ethtool_ops ops = {
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,7,0)
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(5,7,0) */
+	.get_drvinfo = rtl8152_get_drvinfo,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
+	.get_settings = rtl8152_get_settings,
+	.set_settings = rtl8152_set_settings,
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0) */
+	.get_link = ethtool_op_get_link,
+	.nway_reset = rtl8152_nway_reset,
+	.get_msglevel = rtl8152_get_msglevel,
+	.set_msglevel = rtl8152_set_msglevel,
+	.get_wol = rtl8152_get_wol,
+	.set_wol = rtl8152_set_wol,
+	.get_strings = rtl8152_get_strings,
+	.get_sset_count = rtl8152_get_sset_count,
+	.get_ethtool_stats = rtl8152_get_ethtool_stats,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)
+	.get_tx_csum = ethtool_op_get_tx_csum,
+	.set_tx_csum = ethtool_op_set_tx_csum,
+	.get_sg = ethtool_op_get_sg,
+	.set_sg = ethtool_op_set_sg,
+#ifdef NETIF_F_TSO
+	.get_tso = ethtool_op_get_tso,
+	.set_tso = ethtool_op_set_tso,
+#endif
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0) */
+	.get_coalesce = rtl8152_get_coalesce,
+	.set_coalesce = rtl8152_set_coalesce,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+	.get_eee = rtl_ethtool_get_eee,
+	.set_eee = rtl_ethtool_set_eee,
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0)
+	.get_link_ksettings = rtl8152_get_link_ksettings,
+	.set_link_ksettings = rtl8152_set_link_ksettings,
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0) */
+	.begin = rtl8152_ethtool_begin,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,0)
+	.get_tunable = rtl8152_get_tunable,
+	.set_tunable = rtl8152_set_tunable,
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,0) */
+	.get_ringparam = rtl8152_get_ringparam,
+	.set_ringparam = rtl8152_set_ringparam,
+	.get_pauseparam = rtl8152_get_pauseparam,
+	.set_pauseparam = rtl8152_set_pauseparam,
+};
+
+static int rtltool_ioctl(struct r8152 *tp, struct ifreq *ifr)
+{
+	struct net_device *netdev = tp->netdev;
+	struct rtltool_cmd my_cmd, *myptr;
+	struct usb_device_info *uinfo;
+	struct usb_device *udev;
+	__le32	ocp_data;
+	void	*buffer;
+	int	ret;
+
+	myptr = (struct rtltool_cmd *)ifr->ifr_data;
+	if (copy_from_user(&my_cmd, myptr, sizeof(my_cmd)))
+		return -EFAULT;
+
+	ret = 0;
+
+	switch (my_cmd.cmd) {
+	case RTLTOOL_PLA_OCP_READ_DWORD:
+		pla_ocp_read(tp, (u16)my_cmd.offset, sizeof(ocp_data),
+			     &ocp_data);
+		my_cmd.data = __le32_to_cpu(ocp_data);
+
+		if (copy_to_user(myptr, &my_cmd, sizeof(my_cmd))) {
+			ret = -EFAULT;
+			break;
+		}
+		break;
+
+	case RTLTOOL_PLA_OCP_WRITE_DWORD:
+		if (!tp->rtk_enable_diag && net_ratelimit())
+			netif_warn(tp, drv, netdev,
+				   "rtk diag isn't enable\n");
+
+		ocp_data = __cpu_to_le32(my_cmd.data);
+		pla_ocp_write(tp, (u16)my_cmd.offset, (u16)my_cmd.byteen,
+			      sizeof(ocp_data), &ocp_data);
+		break;
+
+	case RTLTOOL_USB_OCP_READ_DWORD:
+		usb_ocp_read(tp, (u16)my_cmd.offset, sizeof(ocp_data),
+			     &ocp_data);
+		my_cmd.data = __le32_to_cpu(ocp_data);
+
+		if (copy_to_user(myptr, &my_cmd, sizeof(my_cmd))) {
+			ret = -EFAULT;
+			break;
+		}
+		break;
+
+
+	case RTLTOOL_USB_OCP_WRITE_DWORD:
+		if (!tp->rtk_enable_diag && net_ratelimit())
+			netif_warn(tp, drv, netdev,
+				   "rtk diag isn't enable\n");
+
+		ocp_data = __cpu_to_le32(my_cmd.data);
+		usb_ocp_write(tp, (u16)my_cmd.offset, (u16)my_cmd.byteen,
+			      sizeof(ocp_data), &ocp_data);
+		break;
+
+	case RTLTOOL_PLA_OCP_READ:
+		buffer = kmalloc(my_cmd.data, GFP_KERNEL);
+		if (!buffer) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		pla_ocp_read(tp, (u16)my_cmd.offset, my_cmd.data, buffer);
+
+		if (copy_to_user(my_cmd.buf, buffer, my_cmd.data))
+			ret = -EFAULT;
+
+		kfree(buffer);
+		break;
+
+	case RTLTOOL_PLA_OCP_WRITE:
+		if (!tp->rtk_enable_diag && net_ratelimit())
+			netif_warn(tp, drv, netdev,
+				   "rtk diag isn't enable\n");
+
+		buffer = kmalloc(my_cmd.data, GFP_KERNEL);
+		if (!buffer) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		if (copy_from_user(buffer, my_cmd.buf, my_cmd.data)) {
+			ret = -EFAULT;
+			kfree(buffer);
+			break;
+		}
+
+		pla_ocp_write(tp, (u16)my_cmd.offset, (u16)my_cmd.byteen,
+			      my_cmd.data, buffer);
+		kfree(buffer);
+		break;
+
+	case RTLTOOL_USB_OCP_READ:
+		buffer = kmalloc(my_cmd.data, GFP_KERNEL);
+		if (!buffer) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		usb_ocp_read(tp, (u16)my_cmd.offset, my_cmd.data, buffer);
+
+		if (copy_to_user(my_cmd.buf, buffer, my_cmd.data))
+			ret = -EFAULT;
+
+		kfree(buffer);
+		break;
+
+	case RTLTOOL_USB_OCP_WRITE:
+		if (!tp->rtk_enable_diag && net_ratelimit())
+			netif_warn(tp, drv, netdev,
+				   "rtk diag isn't enable\n");
+
+		buffer = kmalloc(my_cmd.data, GFP_KERNEL);
+		if (!buffer) {
+			ret = -ENOMEM;
+			break;
+		}
+
+		if (copy_from_user(buffer, my_cmd.buf, my_cmd.data)) {
+			ret = -EFAULT;
+			kfree(buffer);
+			break;
+		}
+
+		usb_ocp_write(tp, (u16)my_cmd.offset, (u16)my_cmd.byteen,
+			      my_cmd.data, buffer);
+		kfree(buffer);
+		break;
+
+	case RTLTOOL_USB_INFO:
+		uinfo = (struct usb_device_info *)&my_cmd.nic_info;
+		udev = tp->udev;
+		uinfo->idVendor = __le16_to_cpu(udev->descriptor.idVendor);
+		uinfo->idProduct = __le16_to_cpu(udev->descriptor.idProduct);
+		uinfo->bcdDevice = __le16_to_cpu(udev->descriptor.bcdDevice);
+		strlcpy(uinfo->devpath, udev->devpath, sizeof(udev->devpath));
+		pla_ocp_read(tp, PLA_IDR, sizeof(uinfo->dev_addr),
+			     uinfo->dev_addr);
+
+		if (copy_to_user(myptr, &my_cmd, sizeof(my_cmd)))
+			ret = -EFAULT;
+
+		break;
+
+	case RTL_ENABLE_USB_DIAG:
+		ret = usb_autopm_get_interface(tp->intf);
+		if (ret < 0)
+			break;
+
+		mutex_lock(&tp->control);
+		tp->rtk_enable_diag++;
+		netif_info(tp, drv, netdev, "enable rtk diag %d\n",
+			   tp->rtk_enable_diag);
+		break;
+
+	case RTL_DISABLE_USB_DIAG:
+		if (!tp->rtk_enable_diag) {
+			netif_err(tp, drv, netdev,
+				  "Invalid using rtk diag\n");
+			ret = -EPERM;
+			break;
+		}
+
+		rtk_disable_diag(tp);
+		break;
+
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,15,0)
+static int rtl8152_siocdevprivate(struct net_device *netdev, struct ifreq *rq,
+				  void __user *data, int cmd)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	int ret;
+
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return -ENODEV;
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		goto out;
+
+	switch (cmd) {
+	case SIOCDEVPRIVATE:
+		if (!capable(CAP_NET_ADMIN)) {
+			ret = -EPERM;
+			break;
+		}
+		ret = rtltool_ioctl(tp, rq);
+		break;
+
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	usb_autopm_put_interface(tp->intf);
+
+out:
+	return ret;
+}
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(5,15,0) */
+
+static int rtl8152_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
+{
+	struct r8152 *tp = netdev_priv(netdev);
+	struct mii_ioctl_data *data = if_mii(rq);
+	int ret;
+
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return -ENODEV;
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		goto out;
+
+	switch (cmd) {
+	case SIOCGMIIPHY:
+		data->phy_id = R8152_PHY_ID; /* Internal PHY */
+		break;
+
+	case SIOCGMIIREG:
+		if (unlikely(tp->rtk_enable_diag)) {
+			ret = -EBUSY;
+			break;
+		}
+
+		mutex_lock(&tp->control);
+		data->val_out = r8152_mdio_read(tp, data->reg_num);
+		mutex_unlock(&tp->control);
+		break;
+
+	case SIOCSMIIREG:
+		if (!capable(CAP_NET_ADMIN)) {
+			ret = -EPERM;
+			break;
+		}
+
+		if (unlikely(tp->rtk_enable_diag)) {
+			ret = -EBUSY;
+			break;
+		}
+
+		mutex_lock(&tp->control);
+		r8152_mdio_write(tp, data->reg_num, data->val_in);
+		mutex_unlock(&tp->control);
+		break;
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
+	case SIOCDEVPRIVATE:
+		if (!capable(CAP_NET_ADMIN)) {
+			ret = -EPERM;
+			break;
+		}
+		ret = rtltool_ioctl(tp, rq);
+		break;
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
+
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	usb_autopm_put_interface(tp->intf);
+
+out:
+	return ret;
+}
+
+static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
+{
+	struct r8152 *tp = netdev_priv(dev);
+	int ret;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
+	u32 max_mtu;
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0) */
+
+	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_07:
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
+		return eth_change_mtu(dev, new_mtu);
+#else
+		dev->mtu = new_mtu;
+		return 0;
+#endif
+	default:
+		break;
+	}
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
+	switch (tp->version) {
+	case RTL_VER_03:
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+	case RTL_VER_08:
+	case RTL_VER_09:
+	case RTL_VER_14:
+		max_mtu = size_to_mtu(9 * 1024);
+		break;
+	case RTL_VER_10:
+	case RTL_VER_11:
+		max_mtu = size_to_mtu(15 * 1024);
+		break;
+	case RTL_VER_12:
+	case RTL_VER_13:
+	case RTL_VER_15:
+		max_mtu = size_to_mtu(16 * 1024);
+		break;
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_07:
+	default:
+		max_mtu = ETH_DATA_LEN;
+		break;
+	}
+
+	if (new_mtu < 68 || new_mtu > max_mtu)
+		return -EINVAL;
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0) */
+
+	ret = usb_autopm_get_interface(tp->intf);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&tp->control);
+
+	dev->mtu = new_mtu;
+
+	if (netif_running(dev)) {
+		if (tp->rtl_ops.change_mtu)
+			tp->rtl_ops.change_mtu(tp);
+
+		if (netif_carrier_ok(dev)) {
+			netif_stop_queue(dev);
+			napi_disable(&tp->napi);
+			tasklet_disable(&tp->tx_tl);
+			tp->rtl_ops.disable(tp);
+			tp->rtl_ops.enable(tp);
+			rtl_start_rx(tp);
+			tasklet_enable(&tp->tx_tl);
+			napi_enable(&tp->napi);
+			rtl8152_set_rx_mode(dev);
+			netif_wake_queue(dev);
+		}
+	}
+
+	mutex_unlock(&tp->control);
+
+	usb_autopm_put_interface(tp->intf);
+
+	return ret;
+}
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
+static const struct net_device_ops rtl8152_netdev_ops = {
+	.ndo_open		= rtl8152_open,
+	.ndo_stop		= rtl8152_close,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
+	.ndo_do_ioctl		= rtl8152_ioctl,
+#else
+	.ndo_siocdevprivate	= rtl8152_siocdevprivate,
+	.ndo_eth_ioctl		= rtl8152_ioctl,
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
+	.ndo_start_xmit		= rtl8152_start_xmit,
+	.ndo_tx_timeout		= rtl8152_tx_timeout,
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
+	.ndo_vlan_rx_register	= rtl8152_vlan_rx_register,
+#else
+	.ndo_set_features	= rtl8152_set_features,
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0) */
+	.ndo_set_rx_mode	= rtl8152_set_rx_mode,
+	.ndo_set_mac_address	= rtl8152_set_mac_address,
+	.ndo_change_mtu		= rtl8152_change_mtu,
+	.ndo_validate_addr	= eth_validate_addr,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,4)
+	.ndo_features_check	= rtl8152_features_check,
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,4) */
+};
+#endif
+
+static void rtl8152_unload(struct r8152 *tp)
+{
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
+
+	r8152_power_cut_en(tp, false);
+}
+
+static void rtl8153_unload(struct r8152 *tp)
+{
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
+
+	r8153_power_cut_en(tp, false);
+}
+
+static void rtl8153b_unload(struct r8152 *tp)
+{
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return;
+
+	r8153b_power_cut_en(tp, false);
+	rtl_set_dbg_info_state(tp, DGB_DRV_STATE_UNLOAD);
+}
+
+static int rtl_ops_init(struct r8152 *tp)
+{
+	struct rtl_ops *ops = &tp->rtl_ops;
+	int ret = 0;
+
+	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_07:
+		ops->init		= r8152b_init;
+		ops->enable		= rtl8152_enable;
+		ops->disable		= rtl8152_disable;
+		ops->up			= rtl8152_up;
+		ops->down		= rtl8152_down;
+		ops->unload		= rtl8152_unload;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+		ops->eee_get		= r8152_get_eee;
+		ops->eee_set		= r8152_set_eee;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
+		ops->in_nway		= rtl8152_in_nway;
+		ops->hw_phy_cfg		= r8152b_hw_phy_cfg;
+		ops->autosuspend_en	= rtl_runtime_suspend_enable;
+		tp->rx_buf_sz		= 16 * 1024;
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_100TX;
+		break;
+
+	case RTL_VER_03:
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+		ops->init		= r8153_init;
+		ops->enable		= rtl8153_enable;
+		ops->disable		= rtl8153_disable;
+		ops->up			= rtl8153_up;
+		ops->down		= rtl8153_down;
+		ops->unload		= rtl8153_unload;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+		ops->eee_get		= r8153_get_eee;
+		ops->eee_set		= r8152_set_eee;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
+		ops->in_nway		= rtl8153_in_nway;
+		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
+		ops->autosuspend_en	= rtl8153_runtime_enable;
+		ops->change_mtu		= rtl8153_change_mtu;
+		if (tp->udev->speed < USB_SPEED_SUPER)
+			tp->rx_buf_sz	= 16 * 1024;
+		else
+			tp->rx_buf_sz	= 32 * 1024;
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
+		break;
+
+	case RTL_VER_08:
+	case RTL_VER_09:
+		ops->init		= r8153b_init;
+		ops->enable		= rtl8153_enable;
+		ops->disable		= rtl8153_disable;
+		ops->up			= rtl8153b_up;
+		ops->down		= rtl8153b_down;
+		ops->unload		= rtl8153b_unload;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+		ops->eee_get		= r8153_get_eee;
+		ops->eee_set		= r8152_set_eee;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
+		ops->in_nway		= rtl8153_in_nway;
+		ops->hw_phy_cfg		= r8153b_hw_phy_cfg;
+		ops->autosuspend_en	= rtl8153b_runtime_enable;
+		ops->change_mtu		= rtl8153_change_mtu;
+		tp->rx_buf_sz		= 32 * 1024;
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
+		break;
+
+	case RTL_TEST_01:
+		ops->init		= r8156_init;
+		ops->enable		= rtl8156_enable;
+		ops->disable		= rtl8153_disable;
+		ops->up			= rtl8156_up;
+		ops->down		= rtl8156_down;
+		ops->unload		= rtl8153_unload;
+//#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+//		ops->eee_get		= r8156_get_eee;
+//		ops->eee_set		= r8156_set_eee;
+//#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
+		ops->in_nway		= rtl8153_in_nway;
+		ops->hw_phy_cfg		= r8156_hw_phy_cfg_test;
+		ops->autosuspend_en	= rtl8156_runtime_enable;
+		tp->rx_buf_sz		= 48 * 1024;
+		tp->support_2500full	= 1;
+		break;
+
+	case RTL_VER_11:
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
+		fallthrough;
+	case RTL_VER_10:
+		ops->init		= r8156_init;
+		ops->enable		= rtl8156_enable;
+		ops->disable		= rtl8153_disable;
+		ops->up			= rtl8156_up;
+		ops->down		= rtl8156_down;
+		ops->unload		= rtl8153_unload;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+		ops->eee_get		= r8153_get_eee;
+		ops->eee_set		= r8152_set_eee;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
+		ops->in_nway		= rtl8153_in_nway;
+		ops->hw_phy_cfg		= r8156_hw_phy_cfg;
+		ops->autosuspend_en	= rtl8156_runtime_enable;
+		ops->change_mtu		= rtl8156_change_mtu;
+		tp->rx_buf_sz		= 48 * 1024;
+		tp->support_2500full	= 1;
+		break;
+
+	case RTL_VER_12:
+	case RTL_VER_13:
+		tp->support_2500full	= 1;
+		fallthrough;
+	case RTL_VER_15:
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
+		ops->init		= r8156b_init;
+		ops->enable		= rtl8156b_enable;
+		ops->disable		= rtl8153_disable;
+		ops->up			= rtl8156_up;
+		ops->down		= rtl8156_down;
+		ops->unload		= rtl8153_unload;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+		ops->eee_get		= r8153_get_eee;
+		ops->eee_set		= r8152_set_eee;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
+		ops->in_nway		= rtl8153_in_nway;
+		ops->hw_phy_cfg		= r8156b_hw_phy_cfg;
+		ops->autosuspend_en	= rtl8156_runtime_enable;
+		ops->change_mtu		= rtl8156_change_mtu;
+		tp->rx_buf_sz		= 48 * 1024;
+		break;
+
+	case RTL_VER_14:
+		ops->init		= r8153c_init;
+		ops->enable		= rtl8153_enable;
+		ops->disable		= rtl8153_disable;
+		ops->up			= rtl8153c_up;
+		ops->down		= rtl8153b_down;
+		ops->unload		= rtl8153_unload;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
+		ops->eee_get		= r8153_get_eee;
+		ops->eee_set		= r8152_set_eee;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
+		ops->in_nway		= rtl8153_in_nway;
+		ops->hw_phy_cfg		= r8153c_hw_phy_cfg;
+		ops->autosuspend_en	= rtl8153c_runtime_enable;
+		ops->change_mtu		= rtl8153c_change_mtu;
+		tp->rx_buf_sz		= 32 * 1024;
+		tp->eee_en		= true;
+		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
+		break;
+
+	default:
+		ret = -ENODEV;
+		dev_err(&tp->intf->dev, "Unknown Device\n");
+		break;
+	}
+
+	return ret;
+}
+
+u8 rtl8152_get_version(struct usb_interface *intf)
+{
+	struct usb_device *udev = interface_to_usbdev(intf);
+	u32 ocp_data = 0;
+	__le32 *tmp;
+	u8 version;
+	int ret;
+
+	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
+	if (!tmp)
+		return 0;
+
+	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
+			      RTL8152_REQ_GET_REGS, RTL8152_REQT_READ,
+			      PLA_TCR0, MCU_TYPE_PLA, tmp, sizeof(*tmp), 500);
+	if (ret > 0)
+		ocp_data = (__le32_to_cpu(*tmp) >> 16) & VERSION_MASK;
+
+	kfree(tmp);
+
+	switch (ocp_data) {
+	case 0x4c00:
+		version = RTL_VER_01;
+		break;
+	case 0x4c10:
+		version = RTL_VER_02;
+		break;
+	case 0x5c00:
+		version = RTL_VER_03;
+		break;
+	case 0x5c10:
+		version = RTL_VER_04;
+		break;
+	case 0x5c20:
+		version = RTL_VER_05;
+		break;
+	case 0x5c30:
+		version = RTL_VER_06;
+		break;
+	case 0x4800:
+		version = RTL_VER_07;
+		break;
+	case 0x6000:
+		version = RTL_VER_08;
+		break;
+	case 0x6010:
+		version = RTL_VER_09;
+		break;
+	case 0x7010:
+		version = RTL_TEST_01;
+		break;
+	case 0x7020:
+		version = RTL_VER_10;
+		break;
+	case 0x7030:
+		version = RTL_VER_11;
+		break;
+	case 0x7400:
+		version = RTL_VER_12;
+		break;
+	case 0x7410:
+		version = RTL_VER_13;
+		break;
+	case 0x6400:
+		version = RTL_VER_14;
+		break;
+	case 0x7420:
+		version = RTL_VER_15;
+		break;
 	default:
+		version = RTL_VER_UNKNOWN;
+		dev_info(&intf->dev, "Unknown version 0x%04x\n", ocp_data);
 		break;
 	}
 
-	coalesce->rx_coalesce_usecs = tp->coalesce;
+	dev_dbg(&intf->dev, "Detected version 0x%04x\n", version);
 
-	return 0;
+	return version;
 }
+EXPORT_SYMBOL_GPL(rtl8152_get_version);
 
-static int rtl8152_set_coalesce(struct net_device *netdev,
-				struct ethtool_coalesce *coalesce,
-				struct kernel_ethtool_coalesce *kernel_coal,
-				struct netlink_ext_ack *extack)
+#ifdef RTL8152_DEBUG
+
+static ssize_t
+ocp_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
+	struct net_device *netdev = to_net_dev(dev);
 	struct r8152 *tp = netdev_priv(netdev);
+	struct usb_interface *intf = tp->intf;
+	char tmp[256];
+	struct tally_counter tally;
 	int ret;
 
+	strcpy(buf, dev_name(dev));
+	strcat(buf, "\n");
+	strcat(buf, DRIVER_VERSION);
+	strcat(buf, "\n");
+
 	switch (tp->version) {
-	case RTL_VER_01:
-	case RTL_VER_02:
-	case RTL_VER_07:
-		return -EOPNOTSUPP;
+	case RTL_VER_05:
+		strcat(buf, "RTL_VER_05\n");
+		strcat(buf, "usb_patch_code_20190904\n");
+		strcat(buf, "pla_patch_code_20190220_0\n");
+		strcat(buf, "\n\n\n\n");
+		break;
+	case RTL_VER_06:
+		strcat(buf, "RTL_VER_06\n");
+		strcat(buf, "usb_patch_20190909\n");
+		strcat(buf, "pla_patch_code_20190408_0\n");
+		strcat(buf, "\n\n\n\n");
+		break;
+	case RTL_VER_09:
+		strcat(buf, "RTL_VER_09\n");
+		strcat(buf, "usb_patch_code_20190906.cfg\n");
+		strcat(buf, "plamcu_patch_code_20190408_0\n");
+		strcat(buf, "\n\n\n\n");
+		break;
+	case RTL_VER_11:
+		strcat(buf, "RTL_VER_11\n");
+		strcat(buf, "nc0_patch_190128_usb\n");
+		strcat(buf, "nc1_patch_181029_usb\n");
+		strcat(buf, "nc2_patch_180821_usb\n");
+		strcat(buf, "uc2_patch_181018_usb\n");
+		strcat(buf, "data_ram_patch_v02_usb\n");
+		strcat(buf, "100m_tx_coefficient_180716_usb\n");
+		strcat(buf, "USB_patch_code_20210310_v4\n");
+		strcat(buf, "PLA_patch_code_20210318_v6\n");
+		break;
+	case RTL_VER_12:
+		strcat(buf, "RTL_VER_12\n");
+		strcat(buf, "nc_patch_190821_usb\n");
+		strcat(buf, "nc2_patch_190823_usb\n");
+		strcat(buf, "uc2_patch_190817_usb\n");
+		strcat(buf, "uc_patch_190731_usb\n");
+		strcat(buf, "USB_patch_code_20190816_v2\n");
+		strcat(buf, "PLA_patch_code_20190827_v2\n");
+		break;
+	case RTL_VER_13:
+	case RTL_VER_15:
+		strcat(buf, "RTL_VER_13\n");
+		strcat(buf, "tgphy_ramcode_v21_usb_20220324\n");
+		strcat(buf, "\n");
+		strcat(buf, "\n");
+		strcat(buf, "\n");
+		strcat(buf, "USB_patch_code_20220314_v4\n");
+		strcat(buf, "PLA_SVN8948_20220330_v06\n");
+		break;
+	case RTL_VER_14:
+		strcat(buf, "RTL_VER_14\n");
+		strcat(buf, "USB_Patch_Code_svn3347\n");
+		strcat(buf, "PLA_Patch_Code_svn3346\n");
+		strcat(buf, "\n\n\n\n");
+		break;
 	default:
+		strcat(buf, "\n\n\n\n\n\n\n");
 		break;
 	}
 
-	if (coalesce->rx_coalesce_usecs > COALESCE_SLOW)
-		return -EINVAL;
-
-	ret = usb_autopm_get_interface(tp->intf);
+	ret = usb_autopm_get_interface(intf);
 	if (ret < 0)
 		return ret;
 
-	mutex_lock(&tp->control);
-
-	if (tp->coalesce != coalesce->rx_coalesce_usecs) {
-		tp->coalesce = coalesce->rx_coalesce_usecs;
-
-		if (netif_running(netdev) && netif_carrier_ok(netdev)) {
-			netif_stop_queue(netdev);
-			napi_disable(&tp->napi);
-			tp->rtl_ops.disable(tp);
-			tp->rtl_ops.enable(tp);
-			rtl_start_rx(tp);
-			clear_bit(RTL8152_SET_RX_MODE, &tp->flags);
-			_rtl8152_set_rx_mode(netdev);
-			napi_enable(&tp->napi);
-			netif_wake_queue(netdev);
-		}
-	}
-
-	mutex_unlock(&tp->control);
-
-	usb_autopm_put_interface(tp->intf);
-
-	return ret;
-}
-
-static int rtl8152_get_tunable(struct net_device *netdev,
-			       const struct ethtool_tunable *tunable, void *d)
-{
-	struct r8152 *tp = netdev_priv(netdev);
-
-	switch (tunable->id) {
-	case ETHTOOL_RX_COPYBREAK:
-		*(u32 *)d = tp->rx_copybreak;
-		break;
-	default:
-		return -EOPNOTSUPP;
+	ret = mutex_lock_interruptible(&tp->control);
+	if (ret < 0) {
+		usb_autopm_put_interface(intf);
+		goto err1;
 	}
 
-	return 0;
-}
-
-static int rtl8152_set_tunable(struct net_device *netdev,
-			       const struct ethtool_tunable *tunable,
-			       const void *d)
-{
-	struct r8152 *tp = netdev_priv(netdev);
-	u32 val;
-
-	switch (tunable->id) {
-	case ETHTOOL_RX_COPYBREAK:
-		val = *(u32 *)d;
-		if (val < ETH_ZLEN) {
-			netif_err(tp, rx_err, netdev,
-				  "Invalid rx copy break value\n");
-			return -EINVAL;
-		}
-
-		if (tp->rx_copybreak != val) {
-			if (netdev->flags & IFF_UP) {
-				mutex_lock(&tp->control);
-				napi_disable(&tp->napi);
-				tp->rx_copybreak = val;
-				napi_enable(&tp->napi);
-				mutex_unlock(&tp->control);
-			} else {
-				tp->rx_copybreak = val;
-			}
-		}
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
+	generic_ocp_read(tp, PLA_TALLYCNT, sizeof(tally), &tally, MCU_TYPE_PLA);
 
-	return 0;
-}
+	mutex_unlock(&tp->control);
 
-static void rtl8152_get_ringparam(struct net_device *netdev,
-				  struct ethtool_ringparam *ring,
-				  struct kernel_ethtool_ringparam *kernel_ring,
-				  struct netlink_ext_ack *extack)
-{
-	struct r8152 *tp = netdev_priv(netdev);
+	usb_autopm_put_interface(intf);
+
+	sprintf(tmp, "tx_packets = %Lu\n", le64_to_cpu(tally.tx_packets));
+	strcat(buf, tmp);
+	sprintf(tmp, "rx_packets = %Lu\n", le64_to_cpu(tally.rx_packets));
+	strcat(buf, tmp);
+	sprintf(tmp, "tx_errors = %Lu\n", le64_to_cpu(tally.tx_errors));
+	strcat(buf, tmp);
+	sprintf(tmp, "tx_errors = %u\n", le32_to_cpu(tally.rx_errors));
+	strcat(buf, tmp);
+	sprintf(tmp, "rx_missed = %u\n", le16_to_cpu(tally.rx_missed));
+	strcat(buf, tmp);
+	sprintf(tmp, "align_errors = %u\n", le16_to_cpu(tally.align_errors));
+	strcat(buf, tmp);
+	sprintf(tmp, "tx_one_collision = %u\n",
+		le32_to_cpu(tally.tx_one_collision));
+	strcat(buf, tmp);
+	sprintf(tmp, "tx_multi_collision = %u\n",
+		le32_to_cpu(tally.tx_multi_collision));
+	strcat(buf, tmp);
+	sprintf(tmp, "rx_unicast = %Lu\n", le64_to_cpu(tally.rx_unicast));
+	strcat(buf, tmp);
+	sprintf(tmp, "rx_broadcast = %Lu\n", le64_to_cpu(tally.rx_broadcast));
+	strcat(buf, tmp);
+	sprintf(tmp, "rx_multicast = %u\n", le32_to_cpu(tally.rx_multicast));
+	strcat(buf, tmp);
+	sprintf(tmp, "tx_aborted = %u\n", le16_to_cpu(tally.tx_aborted));
+	strcat(buf, tmp);
+	sprintf(tmp, "tx_underrun = %u\n", le16_to_cpu(tally.tx_underrun));
+	strcat(buf, tmp);
 
-	ring->rx_max_pending = RTL8152_RX_MAX_PENDING;
-	ring->rx_pending = tp->rx_pending;
+err1:
+	if (ret < 0)
+		return ret;
+	else
+		return strlen(buf);
 }
 
-static int rtl8152_set_ringparam(struct net_device *netdev,
-				 struct ethtool_ringparam *ring,
-				 struct kernel_ethtool_ringparam *kernel_ring,
-				 struct netlink_ext_ack *extack)
+static inline bool hex_value(char p)
 {
-	struct r8152 *tp = netdev_priv(netdev);
-
-	if (ring->rx_pending < (RTL8152_MAX_RX * 2))
-		return -EINVAL;
-
-	if (tp->rx_pending != ring->rx_pending) {
-		if (netdev->flags & IFF_UP) {
-			mutex_lock(&tp->control);
-			napi_disable(&tp->napi);
-			tp->rx_pending = ring->rx_pending;
-			napi_enable(&tp->napi);
-			mutex_unlock(&tp->control);
-		} else {
-			tp->rx_pending = ring->rx_pending;
-		}
-	}
-
-	return 0;
+	return (p >= '0' && p <= '9') ||
+	       (p >= 'a' && p <= 'f') ||
+	       (p >= 'A' && p <= 'F');
 }
 
-static void rtl8152_get_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
+static int ocp_count(char *v1)
 {
-	struct r8152 *tp = netdev_priv(netdev);
-	u16 bmcr, lcladv, rmtadv;
-	u8 cap;
-
-	if (usb_autopm_get_interface(tp->intf) < 0)
-		return;
-
-	mutex_lock(&tp->control);
-
-	bmcr = r8152_mdio_read(tp, MII_BMCR);
-	lcladv = r8152_mdio_read(tp, MII_ADVERTISE);
-	rmtadv = r8152_mdio_read(tp, MII_LPA);
-
-	mutex_unlock(&tp->control);
+	int len = strlen(v1), count = 0;
+	char *v2 = strchr(v1, ' ');
+	bool is_vaild = false;
 
-	usb_autopm_put_interface(tp->intf);
+	if (len < 5 || !v2)
+		goto out1;
+//	else if (strncmp(v1, "pla ", 4) && strncmp(v1, "usb ", 4))
+//		goto out1;
 
-	if (!(bmcr & BMCR_ANENABLE)) {
-		pause->autoneg = 0;
-		pause->rx_pause = 0;
-		pause->tx_pause = 0;
-		return;
+	v1 = v2;
+	len = strlen(v2);
+	while(len) {
+		if (*v1 != ' ')
+			break;
+		v1++;
+		len--;
 	}
 
-	pause->autoneg = 1;
-
-	cap = mii_resolve_flowctrl_fdx(lcladv, rmtadv);
-
-	if (cap & FLOW_CTRL_RX)
-		pause->rx_pause = 1;
-
-	if (cap & FLOW_CTRL_TX)
-		pause->tx_pause = 1;
-}
-
-static int rtl8152_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
-{
-	struct r8152 *tp = netdev_priv(netdev);
-	u16 old, new1;
-	u8 cap = 0;
-	int ret;
-
-	ret = usb_autopm_get_interface(tp->intf);
-	if (ret < 0)
-		return ret;
+	if (!len || *v1 == '\n')
+		goto out1;
 
-	mutex_lock(&tp->control);
+check:
+	v2 = strchr(v1, ' ');
 
-	if (pause->autoneg && !(r8152_mdio_read(tp, MII_BMCR) & BMCR_ANENABLE)) {
-		ret = -EINVAL;
-		goto out;
+	if (len > 2 && !strncasecmp(v1, "0x", 2)) {
+		v1 += 2;
+		len -= 2;
+		if (v1 == v2 || *v1 == '\n')
+			goto out1;
 	}
 
-	if (pause->rx_pause)
-		cap |= FLOW_CTRL_RX;
-
-	if (pause->tx_pause)
-		cap |= FLOW_CTRL_TX;
+	if (v2) {
+		while (v1 < v2) {
+			if (!hex_value(*v1))
+				goto out1;
+			v1++;
+			len--;
+		}
 
-	old = r8152_mdio_read(tp, MII_ADVERTISE);
-	new1 = (old & ~(ADVERTISE_PAUSE_CAP | ADVERTISE_PAUSE_ASYM)) | mii_advertise_flowctrl(cap);
-	if (old != new1)
-		r8152_mdio_write(tp, MII_ADVERTISE, new1);
+		count++;
 
-out:
-	mutex_unlock(&tp->control);
-	usb_autopm_put_interface(tp->intf);
+		while(len) {
+			if (*v1 != ' ')
+				break;
+			v1++;
+			len--;
+		}
 
-	return ret;
-}
+		if (len)
+			goto check;
 
-static const struct ethtool_ops ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
-	.get_drvinfo = rtl8152_get_drvinfo,
-	.get_link = ethtool_op_get_link,
-	.nway_reset = rtl8152_nway_reset,
-	.get_msglevel = rtl8152_get_msglevel,
-	.set_msglevel = rtl8152_set_msglevel,
-	.get_wol = rtl8152_get_wol,
-	.set_wol = rtl8152_set_wol,
-	.get_strings = rtl8152_get_strings,
-	.get_sset_count = rtl8152_get_sset_count,
-	.get_ethtool_stats = rtl8152_get_ethtool_stats,
-	.get_coalesce = rtl8152_get_coalesce,
-	.set_coalesce = rtl8152_set_coalesce,
-	.get_eee = rtl_ethtool_get_eee,
-	.set_eee = rtl_ethtool_set_eee,
-	.get_link_ksettings = rtl8152_get_link_ksettings,
-	.set_link_ksettings = rtl8152_set_link_ksettings,
-	.get_tunable = rtl8152_get_tunable,
-	.set_tunable = rtl8152_set_tunable,
-	.get_ringparam = rtl8152_get_ringparam,
-	.set_ringparam = rtl8152_set_ringparam,
-	.get_pauseparam = rtl8152_get_pauseparam,
-	.set_pauseparam = rtl8152_set_pauseparam,
-};
+		is_vaild = true;
+	} else {
+		int i;
 
-static int rtl8152_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
+		if (len && v1[len - 1] == '\n')
+			len--;
+
+		for (i = 0; i < len; i++) {
+			if (!hex_value(*v1))
+				goto out1;
+			v1++;
+		}
+
+		if (len)
+			count++;
+
+		is_vaild = true;
+	}
+
+out1:
+	if (is_vaild)
+		return count;
+	else
+		return 0;
+}
+
+static ssize_t ocp_store(struct device *dev, struct device_attribute *attr,
+			 const char *buf, size_t count)
 {
+	struct net_device *netdev = to_net_dev(dev);
 	struct r8152 *tp = netdev_priv(netdev);
-	struct mii_ioctl_data *data = if_mii(rq);
-	int res;
+	struct usb_interface *intf = tp->intf;
+	u32 v1, v2, v3, v4;
+	u16 type;
+	int num, ret;
 
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return -ENODEV;
+	if (!strncmp(buf, "pla ", 4))
+		type = MCU_TYPE_PLA;
+	else if (!strncmp(buf, "usb ", 4))
+		type = MCU_TYPE_USB;
+	else
+		return -EINVAL;
 
-	res = usb_autopm_get_interface(tp->intf);
-	if (res < 0)
-		goto out;
+	if (!ocp_count((char *)buf))
+		return -EINVAL;
 
-	switch (cmd) {
-	case SIOCGMIIPHY:
-		data->phy_id = R8152_PHY_ID; /* Internal PHY */
-		break;
+	num = sscanf(strchr(buf, ' '), "%x %x %x %x\n", &v1, &v2, &v3, &v4);
 
-	case SIOCGMIIREG:
-		mutex_lock(&tp->control);
-		data->val_out = r8152_mdio_read(tp, data->reg_num);
-		mutex_unlock(&tp->control);
-		break;
+	if (num > 1) {
+		if ((v1 == 2 && (v2 & 1)) ||
+		    (v1 == 4 && (v2 & 3)) ||
+		    (type == MCU_TYPE_PLA &&
+		     (v2 < 0xc000 || (v2 & ~3) == PLA_OCP_GPHY_BASE)))
+			return -EINVAL;
+	}
 
-	case SIOCSMIIREG:
-		if (!capable(CAP_NET_ADMIN)) {
-			res = -EPERM;
+	ret = usb_autopm_get_interface(intf);
+	if (ret < 0)
+		return ret;
+
+	ret = mutex_lock_interruptible(&tp->control);
+	if (ret < 0)
+		goto put;
+
+	switch(num) {
+	case 2:
+		switch (v1) {
+		case 1:
+			netif_info(tp, drv, netdev, "%s read byte %x = %x\n",
+				   type ? "PLA" : "USB", v2,
+				   ocp_read_byte(tp, type, v2));
+			break;
+		case 2:
+			netif_info(tp, drv, netdev, "%s read word %x = %x\n",
+				   type ? "PLA" : "USB", v2,
+				   ocp_read_word(tp, type, v2));
+			break;
+		case 4:
+			netif_info(tp, drv, netdev, "%s read dword %x = %x\n",
+				   type ? "PLA" : "USB", v2,
+				   ocp_read_dword(tp, type, v2));
+			break;
+		default:
+			ret = -EINVAL;
 			break;
 		}
-		mutex_lock(&tp->control);
-		r8152_mdio_write(tp, data->reg_num, data->val_in);
-		mutex_unlock(&tp->control);
 		break;
-
+	case 3:
+		switch (v1) {
+		case 1:
+			netif_info(tp, drv, netdev, "%s write byte %x = %x\n",
+				   type ? "PLA" : "USB", v2, v3);
+			ocp_write_byte(tp, type, v2, v3);
+			break;
+		case 2:
+			netif_info(tp, drv, netdev, "%s write word %x = %x\n",
+				   type ? "PLA" : "USB", v2, v3);
+			ocp_write_word(tp, type, v2, v3);
+			break;
+		case 4:
+			netif_info(tp, drv, netdev, "%s write dword %x = %x\n",
+				   type ? "PLA" : "USB", v2, v3);
+			ocp_write_dword(tp, type, v2, v3);
+			break;
+		default:
+			ret = -EINVAL;
+			break;
+		}
+		break;
+	case 4:
+	case 1:
 	default:
-		res = -EOPNOTSUPP;
+		ret = -EINVAL;
+		break;
 	}
 
-	usb_autopm_put_interface(tp->intf);
+	mutex_unlock(&tp->control);
 
-out:
-	return res;
+put:
+	usb_autopm_put_interface(intf);
+
+	if (ret < 0)
+		return ret;
+	else
+		return count;
 }
 
-static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
+static DEVICE_ATTR_RW(ocp);
+
+static struct attribute *rtk_attrs[] = {
+	&dev_attr_ocp.attr,
+	NULL
+};
+
+#define ATTR_PLA_SIZE	0x3000
+
+/* hexdump -e '"%04_ax\t" 16/1 "%02X " "\n"' pla */
+static ssize_t pla_read(struct file *fp, struct kobject *kobj,
+			struct bin_attribute *attr, char *buf, loff_t offset,
+			size_t size)
 {
-	struct r8152 *tp = netdev_priv(dev);
+	struct device *dev = kobj_to_dev(kobj);
+	struct net_device *netdev = to_net_dev(dev);
+	struct r8152 *tp = netdev_priv(netdev);
 	int ret;
 
-	switch (tp->version) {
-	case RTL_VER_01:
-	case RTL_VER_02:
-	case RTL_VER_07:
-		dev->mtu = new_mtu;
-		return 0;
-	default:
-		break;
-	}
+	if (size <= ATTR_PLA_SIZE)
+		size = min(size, ATTR_PLA_SIZE - (size_t)offset);
+	else
+		return -EINVAL;
 
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		return ret;
 
-	mutex_lock(&tp->control);
-
-	dev->mtu = new_mtu;
-
-	if (netif_running(dev)) {
-		if (tp->rtl_ops.change_mtu)
-			tp->rtl_ops.change_mtu(tp);
+	/* rtnl_lock(); */
+	ret = mutex_lock_interruptible(&tp->control);
+	if (ret < 0)
+		goto put;
 
-		if (netif_carrier_ok(dev)) {
-			netif_stop_queue(dev);
-			napi_disable(&tp->napi);
-			tasklet_disable(&tp->tx_tl);
-			tp->rtl_ops.disable(tp);
-			tp->rtl_ops.enable(tp);
-			rtl_start_rx(tp);
-			tasklet_enable(&tp->tx_tl);
-			napi_enable(&tp->napi);
-			rtl8152_set_rx_mode(dev);
-			netif_wake_queue(dev);
-		}
-	}
+	ret = pla_ocp_read(tp, offset + 0xc000, (u16)size, buf);
+	if (ret < 0)
+		netif_err(tp, drv, netdev,
+			  "Read PLA offset 0x%Lx, len = %zd fail\n",
+			  offset + 0xc000, size);
 
 	mutex_unlock(&tp->control);
+	/* rtnl_unlock(); */
 
+put:
 	usb_autopm_put_interface(tp->intf);
 
-	return ret;
+	if (ret < 0)
+		return ret;
+	else
+		return size;
 }
 
-static const struct net_device_ops rtl8152_netdev_ops = {
-	.ndo_open		= rtl8152_open,
-	.ndo_stop		= rtl8152_close,
-	.ndo_eth_ioctl		= rtl8152_ioctl,
-	.ndo_start_xmit		= rtl8152_start_xmit,
-	.ndo_tx_timeout		= rtl8152_tx_timeout,
-	.ndo_set_features	= rtl8152_set_features,
-	.ndo_set_rx_mode	= rtl8152_set_rx_mode,
-	.ndo_set_mac_address	= rtl8152_set_mac_address,
-	.ndo_change_mtu		= rtl8152_change_mtu,
-	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_features_check	= rtl8152_features_check,
+static BIN_ATTR_RO(pla, ATTR_PLA_SIZE);
+
+static struct bin_attribute *rtk_bin_attrs[] = {
+	&bin_attr_pla,
+	NULL
 };
 
-static void rtl8152_unload(struct r8152 *tp)
+static struct attribute_group rtk_dbg_grp = {
+	.name = "nic_swsd",
+	.attrs = rtk_attrs,
+	.bin_attrs = rtk_bin_attrs,
+};
+
+#endif /* RTL8152_DEBUG */
+
+static ssize_t rx_copybreak_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
 {
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+	struct net_device *netdev = to_net_dev(dev);
+	struct r8152 *tp = netdev_priv(netdev);
+
+	sprintf(buf, "%u\n", tp->rx_copybreak);
 
-	if (tp->version != RTL_VER_01)
-		r8152_power_cut_en(tp, true);
+	return strlen(buf);
 }
 
-static void rtl8153_unload(struct r8152 *tp)
+static ssize_t rx_copybreak_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
 {
+	struct net_device *netdev = to_net_dev(dev);
+	struct r8152 *tp = netdev_priv(netdev);
+	u32 rx_copybreak;
+
+	if (sscanf(buf, "%u\n", &rx_copybreak) != 1)
+		return -EINVAL;
+
+	if (rx_copybreak < ETH_ZLEN)
+		return -EINVAL;
+
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+		return -ENODEV;
 
-	r8153_power_cut_en(tp, false);
+	if (tp->rx_copybreak != rx_copybreak) {
+		if (tp->netdev->flags & IFF_UP) {
+			int ret;
+
+			ret = mutex_lock_interruptible(&tp->control);
+			if (ret < 0)
+				return ret;
+
+			napi_disable(&tp->napi);
+			tp->rx_copybreak = rx_copybreak;
+			napi_enable(&tp->napi);
+
+			mutex_unlock(&tp->control);
+		} else {
+			tp->rx_copybreak = rx_copybreak;
+		}
+	}
+
+	return count;
 }
 
-static void rtl8153b_unload(struct r8152 *tp)
+static DEVICE_ATTR_RW(rx_copybreak);
+
+static ssize_t fc_pause_on_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
-	if (test_bit(RTL8152_UNPLUG, &tp->flags))
-		return;
+	struct r8152 *tp = netdev_priv(to_net_dev(dev));
 
-	r8153b_power_cut_en(tp, false);
+	if (!tp->fc_pause_on)
+		sprintf(buf, "(Auto)%u\n", fc_pause_on_auto(tp));
+	else
+		sprintf(buf, "%u\n", tp->fc_pause_on);
+
+	return strlen(buf);
 }
 
-static int rtl_ops_init(struct r8152 *tp)
+static ssize_t fc_pause_on_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
 {
-	struct rtl_ops *ops = &tp->rtl_ops;
+	struct net_device *netdev = to_net_dev(dev);
+	struct r8152 *tp = netdev_priv(netdev);
+	struct usb_interface *intf = tp->intf;
+	u32 pause_on, pause_off, tmp;
 	int ret = 0;
 
-	switch (tp->version) {
-	case RTL_VER_01:
-	case RTL_VER_02:
-	case RTL_VER_07:
-		ops->init		= r8152b_init;
-		ops->enable		= rtl8152_enable;
-		ops->disable		= rtl8152_disable;
-		ops->up			= rtl8152_up;
-		ops->down		= rtl8152_down;
-		ops->unload		= rtl8152_unload;
-		ops->eee_get		= r8152_get_eee;
-		ops->eee_set		= r8152_set_eee;
-		ops->in_nway		= rtl8152_in_nway;
-		ops->hw_phy_cfg		= r8152b_hw_phy_cfg;
-		ops->autosuspend_en	= rtl_runtime_suspend_enable;
-		tp->rx_buf_sz		= 16 * 1024;
-		tp->eee_en		= true;
-		tp->eee_adv		= MDIO_EEE_100TX;
-		break;
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return -ENODEV;
 
-	case RTL_VER_03:
-	case RTL_VER_04:
-	case RTL_VER_05:
-	case RTL_VER_06:
-		ops->init		= r8153_init;
-		ops->enable		= rtl8153_enable;
-		ops->disable		= rtl8153_disable;
-		ops->up			= rtl8153_up;
-		ops->down		= rtl8153_down;
-		ops->unload		= rtl8153_unload;
-		ops->eee_get		= r8153_get_eee;
-		ops->eee_set		= r8152_set_eee;
-		ops->in_nway		= rtl8153_in_nway;
-		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
-		ops->autosuspend_en	= rtl8153_runtime_enable;
-		ops->change_mtu		= rtl8153_change_mtu;
-		if (tp->udev->speed < USB_SPEED_SUPER)
-			tp->rx_buf_sz	= 16 * 1024;
-		else
-			tp->rx_buf_sz	= 32 * 1024;
-		tp->eee_en		= true;
-		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
-		break;
+	if (sscanf(buf, "%u\n", &pause_on) != 1)
+		return -EINVAL;
 
-	case RTL_VER_08:
-	case RTL_VER_09:
-		ops->init		= r8153b_init;
-		ops->enable		= rtl8153_enable;
-		ops->disable		= rtl8153_disable;
-		ops->up			= rtl8153b_up;
-		ops->down		= rtl8153b_down;
-		ops->unload		= rtl8153b_unload;
-		ops->eee_get		= r8153_get_eee;
-		ops->eee_set		= r8152_set_eee;
-		ops->in_nway		= rtl8153_in_nway;
-		ops->hw_phy_cfg		= r8153b_hw_phy_cfg;
-		ops->autosuspend_en	= rtl8153b_runtime_enable;
-		ops->change_mtu		= rtl8153_change_mtu;
-		tp->rx_buf_sz		= 32 * 1024;
-		tp->eee_en		= true;
-		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
-		break;
+	if (tp->fc_pause_off)
+		pause_off = tp->fc_pause_off;
+	else
+		pause_off = fc_pause_off_auto(tp);
 
-	case RTL_VER_11:
-		tp->eee_en		= true;
-		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
-		fallthrough;
-	case RTL_VER_10:
-		ops->init		= r8156_init;
-		ops->enable		= rtl8156_enable;
-		ops->disable		= rtl8153_disable;
-		ops->up			= rtl8156_up;
-		ops->down		= rtl8156_down;
-		ops->unload		= rtl8153_unload;
-		ops->eee_get		= r8153_get_eee;
-		ops->eee_set		= r8152_set_eee;
-		ops->in_nway		= rtl8153_in_nway;
-		ops->hw_phy_cfg		= r8156_hw_phy_cfg;
-		ops->autosuspend_en	= rtl8156_runtime_enable;
-		ops->change_mtu		= rtl8156_change_mtu;
-		tp->rx_buf_sz		= 48 * 1024;
-		tp->support_2500full	= 1;
-		break;
+	if (pause_on)
+		tmp = pause_on;
+	else
+		tmp = fc_pause_on_auto(tp);
 
-	case RTL_VER_12:
-	case RTL_VER_13:
-		tp->support_2500full	= 1;
-		fallthrough;
-	case RTL_VER_15:
-		tp->eee_en		= true;
-		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
-		ops->init		= r8156b_init;
-		ops->enable		= rtl8156b_enable;
-		ops->disable		= rtl8153_disable;
-		ops->up			= rtl8156_up;
-		ops->down		= rtl8156_down;
-		ops->unload		= rtl8153_unload;
-		ops->eee_get		= r8153_get_eee;
-		ops->eee_set		= r8152_set_eee;
-		ops->in_nway		= rtl8153_in_nway;
-		ops->hw_phy_cfg		= r8156b_hw_phy_cfg;
-		ops->autosuspend_en	= rtl8156_runtime_enable;
-		ops->change_mtu		= rtl8156_change_mtu;
-		tp->rx_buf_sz		= 48 * 1024;
-		break;
+	if (tmp >= pause_off) {
+		netif_err(tp, drv, netdev, "fc_pause_on must be less than %u\n",
+			  pause_off);
+		return -EINVAL;
+	}
 
-	case RTL_VER_14:
-		ops->init		= r8153c_init;
-		ops->enable		= rtl8153_enable;
-		ops->disable		= rtl8153_disable;
-		ops->up			= rtl8153c_up;
-		ops->down		= rtl8153b_down;
-		ops->unload		= rtl8153_unload;
-		ops->eee_get		= r8153_get_eee;
-		ops->eee_set		= r8152_set_eee;
-		ops->in_nway		= rtl8153_in_nway;
-		ops->hw_phy_cfg		= r8153c_hw_phy_cfg;
-		ops->autosuspend_en	= rtl8153c_runtime_enable;
-		ops->change_mtu		= rtl8153c_change_mtu;
-		tp->rx_buf_sz		= 32 * 1024;
-		tp->eee_en		= true;
-		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
-		break;
+	if (tp->fc_pause_on != pause_on) {
+		ret = usb_autopm_get_interface(intf);
+		if (ret < 0)
+			return ret;
 
-	default:
-		ret = -ENODEV;
-		dev_err(&tp->intf->dev, "Unknown Device\n");
-		break;
+		ret = mutex_lock_interruptible(&tp->control);
+		if (ret < 0)
+			goto put;
+
+		tp->fc_pause_on = pause_on;
+
+		if (netdev->flags & IFF_UP) {
+			r8156_fc_parameter(tp);
+
+			if (netif_carrier_ok(netdev)) {
+				netif_stop_queue(netdev);
+				napi_disable(&tp->napi);
+				tasklet_disable(&tp->tx_tl);
+				tp->rtl_ops.disable(tp);
+				tp->rtl_ops.enable(tp);
+				rtl_start_rx(tp);
+				tasklet_enable(&tp->tx_tl);
+				napi_enable(&tp->napi);
+				rtl8152_set_rx_mode(netdev);
+				netif_wake_queue(netdev);
+			}
+		}
+
+		mutex_unlock(&tp->control);
+
+put:
+		usb_autopm_put_interface(intf);
 	}
 
-	return ret;
+	if (ret < 0)
+		return ret;
+	else
+		return count;
 }
 
-#define FIRMWARE_8153A_2	"rtl_nic/rtl8153a-2.fw"
-#define FIRMWARE_8153A_3	"rtl_nic/rtl8153a-3.fw"
-#define FIRMWARE_8153A_4	"rtl_nic/rtl8153a-4.fw"
-#define FIRMWARE_8153B_2	"rtl_nic/rtl8153b-2.fw"
-#define FIRMWARE_8153C_1	"rtl_nic/rtl8153c-1.fw"
-#define FIRMWARE_8156A_2	"rtl_nic/rtl8156a-2.fw"
-#define FIRMWARE_8156B_2	"rtl_nic/rtl8156b-2.fw"
+static DEVICE_ATTR_RW(fc_pause_on);
+
+static ssize_t fc_pause_off_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct r8152 *tp = netdev_priv(to_net_dev(dev));
+
+	if (!tp->fc_pause_off)
+		sprintf(buf, "(Auto)%u\n", fc_pause_off_auto(tp));
+	else
+		sprintf(buf, "%u\n", tp->fc_pause_off);
 
-MODULE_FIRMWARE(FIRMWARE_8153A_2);
-MODULE_FIRMWARE(FIRMWARE_8153A_3);
-MODULE_FIRMWARE(FIRMWARE_8153A_4);
-MODULE_FIRMWARE(FIRMWARE_8153B_2);
-MODULE_FIRMWARE(FIRMWARE_8153C_1);
-MODULE_FIRMWARE(FIRMWARE_8156A_2);
-MODULE_FIRMWARE(FIRMWARE_8156B_2);
+	return strlen(buf);
+}
 
-static int rtl_fw_init(struct r8152 *tp)
+static ssize_t fc_pause_off_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
 {
-	struct rtl_fw *rtl_fw = &tp->rtl_fw;
+	struct net_device *netdev = to_net_dev(dev);
+	struct r8152 *tp = netdev_priv(netdev);
+	struct usb_interface *intf = tp->intf;
+	u32 pause_on, pause_off, tmp;
+	int ret = 0;
 
-	switch (tp->version) {
-	case RTL_VER_04:
-		rtl_fw->fw_name		= FIRMWARE_8153A_2;
-		rtl_fw->pre_fw		= r8153_pre_firmware_1;
-		rtl_fw->post_fw		= r8153_post_firmware_1;
-		break;
-	case RTL_VER_05:
-		rtl_fw->fw_name		= FIRMWARE_8153A_3;
-		rtl_fw->pre_fw		= r8153_pre_firmware_2;
-		rtl_fw->post_fw		= r8153_post_firmware_2;
-		break;
-	case RTL_VER_06:
-		rtl_fw->fw_name		= FIRMWARE_8153A_4;
-		rtl_fw->post_fw		= r8153_post_firmware_3;
-		break;
-	case RTL_VER_09:
-		rtl_fw->fw_name		= FIRMWARE_8153B_2;
-		rtl_fw->pre_fw		= r8153b_pre_firmware_1;
-		rtl_fw->post_fw		= r8153b_post_firmware_1;
-		break;
-	case RTL_VER_11:
-		rtl_fw->fw_name		= FIRMWARE_8156A_2;
-		rtl_fw->post_fw		= r8156a_post_firmware_1;
-		break;
-	case RTL_VER_13:
-	case RTL_VER_15:
-		rtl_fw->fw_name		= FIRMWARE_8156B_2;
-		break;
-	case RTL_VER_14:
-		rtl_fw->fw_name		= FIRMWARE_8153C_1;
-		rtl_fw->pre_fw		= r8153b_pre_firmware_1;
-		rtl_fw->post_fw		= r8153c_post_firmware_1;
-		break;
-	default:
-		break;
+	if (test_bit(RTL8152_UNPLUG, &tp->flags))
+		return -ENODEV;
+
+	if (sscanf(buf, "%u\n", &pause_off) != 1)
+		return -EINVAL;
+
+	if (tp->fc_pause_on)
+		pause_on = tp->fc_pause_on;
+	else
+		pause_on = fc_pause_on_auto(tp);
+
+	if (pause_off)
+		tmp = pause_off;
+	else
+		tmp = fc_pause_off_auto(tp);
+
+	if (tmp <= pause_on){
+		netif_err(tp, drv, netdev, "fc_pause_off must be more than %u\n",
+			  pause_on);
+		return -EINVAL;
 	}
 
-	return 0;
+	if (tp->fc_pause_off != pause_off) {
+		ret = usb_autopm_get_interface(intf);
+		if (ret < 0)
+			return ret;
+
+		ret = mutex_lock_interruptible(&tp->control);
+		if (ret < 0)
+			goto put;
+
+		tp->fc_pause_off = pause_off;
+
+		if (netdev->flags & IFF_UP) {
+			r8156_fc_parameter(tp);
+
+			if (netif_carrier_ok(netdev)) {
+				netif_stop_queue(netdev);
+				napi_disable(&tp->napi);
+				tasklet_disable(&tp->tx_tl);
+				tp->rtl_ops.disable(tp);
+				tp->rtl_ops.enable(tp);
+				rtl_start_rx(tp);
+				tasklet_enable(&tp->tx_tl);
+				napi_enable(&tp->napi);
+				rtl8152_set_rx_mode(netdev);
+				netif_wake_queue(netdev);
+			}
+		}
+
+		mutex_unlock(&tp->control);
+
+put:
+		usb_autopm_put_interface(intf);
+	}
+
+	if (ret < 0)
+		return ret;
+	else
+		return count;
 }
 
-u8 rtl8152_get_version(struct usb_interface *intf)
-{
-	struct usb_device *udev = interface_to_usbdev(intf);
-	u32 ocp_data = 0;
-	__le32 *tmp;
-	u8 version;
-	int ret;
+static DEVICE_ATTR_RW(fc_pause_off);
 
-	tmp = kmalloc(sizeof(*tmp), GFP_KERNEL);
-	if (!tmp)
-		return 0;
+static ssize_t
+sg_en_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct r8152 *tp = netdev_priv(netdev);
 
-	ret = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
-			      RTL8152_REQ_GET_REGS, RTL8152_REQT_READ,
-			      PLA_TCR0, MCU_TYPE_PLA, tmp, sizeof(*tmp), 500);
-	if (ret > 0)
-		ocp_data = (__le32_to_cpu(*tmp) >> 16) & VERSION_MASK;
+	if (tp->sg_use)
+		strcat(buf, "enable\n");
+	else
+		strcat(buf, "disable\n");
 
-	kfree(tmp);
+	return strlen(buf);
+}
 
-	switch (ocp_data) {
-	case 0x4c00:
-		version = RTL_VER_01;
-		break;
-	case 0x4c10:
-		version = RTL_VER_02;
-		break;
-	case 0x5c00:
-		version = RTL_VER_03;
-		break;
-	case 0x5c10:
-		version = RTL_VER_04;
-		break;
-	case 0x5c20:
-		version = RTL_VER_05;
-		break;
-	case 0x5c30:
-		version = RTL_VER_06;
-		break;
-	case 0x4800:
-		version = RTL_VER_07;
-		break;
-	case 0x6000:
-		version = RTL_VER_08;
-		break;
-	case 0x6010:
-		version = RTL_VER_09;
-		break;
-	case 0x7010:
-		version = RTL_TEST_01;
-		break;
-	case 0x7020:
-		version = RTL_VER_10;
-		break;
-	case 0x7030:
-		version = RTL_VER_11;
-		break;
-	case 0x7400:
-		version = RTL_VER_12;
-		break;
-	case 0x7410:
-		version = RTL_VER_13;
-		break;
-	case 0x6400:
-		version = RTL_VER_14;
-		break;
-	case 0x7420:
-		version = RTL_VER_15;
-		break;
-	default:
-		version = RTL_VER_UNKNOWN;
-		dev_info(&intf->dev, "Unknown version 0x%04x\n", ocp_data);
-		break;
+static ssize_t sg_en_store(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct r8152 *tp = netdev_priv(netdev);
+	u32 tso_size;
+
+	if (!strncmp(buf, "enable", 6) &&
+	    usb_device_no_sg_constraint(tp->udev)) {
+		tp->sg_use = true;
+		tso_size = GSO_MAX_SIZE;
+	} else if (!strncmp(buf, "disable", 7)) {
+		tp->sg_use = false;
+		tso_size = RTL_LIMITED_TSO_SIZE;
+	} else {
+		return -EINVAL;
 	}
 
-	dev_dbg(&intf->dev, "Detected version 0x%04x\n", version);
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
+	netif_set_gso_max_size(netdev, tso_size);
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26) */
 
-	return version;
+	return count;
 }
-EXPORT_SYMBOL_GPL(rtl8152_get_version);
 
-static bool rtl8152_supports_lenovo_macpassthru(struct usb_device *udev)
-{
-	int parent_vendor_id = le16_to_cpu(udev->parent->descriptor.idVendor);
-	int product_id = le16_to_cpu(udev->descriptor.idProduct);
-	int vendor_id = le16_to_cpu(udev->descriptor.idVendor);
-
-	if (vendor_id == VENDOR_ID_LENOVO) {
-		switch (product_id) {
-		case DEVICE_ID_LENOVO_USB_C_TRAVEL_HUB:
-		case DEVICE_ID_THINKPAD_ONELINK_PLUS_DOCK:
-		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
-		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
-		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
-		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
-			return 1;
-		}
-	} else if (vendor_id == VENDOR_ID_REALTEK && parent_vendor_id == VENDOR_ID_LENOVO) {
-		switch (product_id) {
-		case 0x8153:
-			return 1;
+static DEVICE_ATTR_RW(sg_en);
+
+static struct attribute *rtk_adv_attrs[] = {
+	&dev_attr_rx_copybreak.attr,
+	&dev_attr_sg_en.attr,
+	&dev_attr_fc_pause_on.attr,
+	&dev_attr_fc_pause_off.attr,
+	NULL
+};
+
+static struct attribute_group rtk_adv_grp = {
+	.name = "rtl_adv",
+	.attrs = rtk_adv_attrs,
+};
+
+static void rtl_get_mapt_ver(struct r8152 *tp)
+{
+	struct usb_device *udev = tp->udev;
+	u32 ocp_data;
+
+	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
+		tp->lenovo_macpassthru = 1;
+		return;
+	}
+
+	/* test for -AD variant of RTL8153 */
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
+	if ((ocp_data & AD_MASK) == 0x1000) {
+		/* test for MAC address pass-through bit */
+		ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_EFUSE);
+		if (ocp_data & PASS_THRU_MASK) {
+			tp->dell_macpassthru = 1;
+			return;
 		}
 	}
-	return 0;
+
+	/* test for RTL8153-BND and RTL8153-BD */
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
+	if ((ocp_data & BND_MASK) || (ocp_data & BD_MASK)) {
+		tp->dell_macpassthru = 1;
+		return;
+	} else if (tp->version == RTL_VER_09 && (ocp_data & BL_MASK)) {
+		tp->lenovo_macpassthru = 1;
+		return;
+	}
 }
 
 static int rtl8152_probe(struct usb_interface *intf,
@@ -9658,21 +20570,43 @@ static int rtl8152_probe(struct usb_interface *intf,
 	if (ret)
 		goto out;
 
-	rtl_fw_init(tp);
-
 	mutex_init(&tp->control);
 	INIT_DELAYED_WORK(&tp->schedule, rtl_work_func_t);
 	INIT_DELAYED_WORK(&tp->hw_phy_work, rtl_hw_phy_work_func_t);
 	tasklet_setup(&tp->tx_tl, bottom_half);
 	tasklet_disable(&tp->tx_tl);
 
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,2,3)
+	if (usb_device_no_sg_constraint(udev))
+		tp->sg_use = true;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(5,2,3) */
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+	netdev->open = rtl8152_open;
+	netdev->stop = rtl8152_close;
+	netdev->get_stats = rtl8152_get_stats;
+	netdev->hard_start_xmit = rtl8152_start_xmit;
+	netdev->tx_timeout = rtl8152_tx_timeout;
+	netdev->change_mtu = rtl8152_change_mtu;
+	netdev->set_mac_address = rtl8152_set_mac_address;
+	netdev->do_ioctl = rtl8152_ioctl;
+	netdev->set_multicast_list = rtl8152_set_rx_mode;
+	netdev->vlan_rx_register = rtl8152_vlan_rx_register;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
+	netdev->vlan_rx_kill_vid = rtl8152_vlan_rx_kill_vid;
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
+#else
 	netdev->netdev_ops = &rtl8152_netdev_ops;
+#endif /* HAVE_NET_DEVICE_OPS */
+
 	netdev->watchdog_timeo = RTL8152_TX_TIMEOUT;
 
 	netdev->features |= NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
 			    NETIF_F_TSO | NETIF_F_FRAGLIST | NETIF_F_IPV6_CSUM |
 			    NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
 			    NETIF_F_HW_VLAN_CTAG_TX;
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)
 	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
 			      NETIF_F_TSO | NETIF_F_FRAGLIST |
 			      NETIF_F_IPV6_CSUM | NETIF_F_TSO6 |
@@ -9680,24 +20614,26 @@ static int rtl8152_probe(struct usb_interface *intf,
 	netdev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 				NETIF_F_HIGHDMA | NETIF_F_FRAGLIST |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39) */
 
 	if (tp->version == RTL_VER_01) {
 		netdev->features &= ~NETIF_F_RXCSUM;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39) */
 	}
 
-	tp->lenovo_macpassthru = rtl8152_supports_lenovo_macpassthru(udev);
-
-	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
-	    (!strcmp(udev->serial, "000001000000") ||
-	     !strcmp(udev->serial, "000002000000"))) {
-		dev_info(&udev->dev, "Dell TB16 Dock, disable RX aggregation");
-		tp->dell_tb_rx_agg_bug = 1;
-	}
+	rtl_get_mapt_ver(tp);
 
 	netdev->ethtool_ops = &ops;
-	netif_set_tso_max_size(netdev, RTL_LIMITED_TSO_SIZE);
-
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
+	if (!tp->sg_use)
+		netif_set_gso_max_size(netdev, RTL_LIMITED_TSO_SIZE);
+#else
+	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26) */
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
 	/* MTU range: 68 - 1500 or 9194 */
 	netdev->min_mtu = ETH_MIN_MTU;
 	switch (tp->version) {
@@ -9726,6 +20662,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->max_mtu = ETH_DATA_LEN;
 		break;
 	}
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0) */
 
 	tp->mii.dev = netdev;
 	tp->mii.mdio_read = read_mii_word;
@@ -9733,6 +20670,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->mii.phy_id_mask = 0x3f;
 	tp->mii.reg_num_mask = 0x1f;
 	tp->mii.phy_id = R8152_PHY_ID;
+	tp->mii.force_media = 0;
+	tp->mii.advertising = ADVERTISE_10HALF | ADVERTISE_10FULL |
+			      ADVERTISE_100HALF | ADVERTISE_100FULL;
 
 	tp->autoneg = AUTONEG_ENABLE;
 	tp->speed = SPEED_100;
@@ -9761,17 +20701,26 @@ static int rtl8152_probe(struct usb_interface *intf,
 		tp->saved_wolopts = __rtl_get_wol(tp);
 
 	tp->rtl_ops.init(tp);
-#if IS_BUILTIN(CONFIG_USB_RTL8152)
-	/* Retry in case request_firmware() is not ready yet. */
-	tp->rtl_fw.retry = true;
-#endif
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
 	set_ethernet_addr(tp, false);
 
 	usb_set_intfdata(intf, tp);
 
-	netif_napi_add_weight(netdev, &tp->napi, r8152_poll,
-			      tp->support_2500full ? 256 : 64);
+	/* Below modifications from the original driver code due to 
+	 * commit b48b89f9c189d24eb5e2b4a0ac067da5a24ee86d
+	 */
+	if (tp->support_2500full)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(6,1,0)
+		netif_napi_add_weight(netdev, &tp->napi, r8152_poll, 256);
+#else 
+		netif_napi_add(netdev, &tp->napi, r8152_poll, 256);
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(6,1,0) */
+	else
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(6,1,0)
+		netif_napi_add(netdev, &tp->napi, r8152_poll);
+#else 
+		netif_napi_add(netdev, &tp->napi, r8152_poll, 64);
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(6,1,0) */
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
@@ -9784,11 +20733,35 @@ static int rtl8152_probe(struct usb_interface *intf,
 	else
 		device_set_wakeup_enable(&udev->dev, false);
 
+	/* usb_enable_autosuspend(udev); */
+
 	netif_info(tp, probe, netdev, "%s\n", DRIVER_VERSION);
+	netif_info(tp, probe, netdev, "%s\n", PATENTS);
+
+	ret = sysfs_create_group(&netdev->dev.kobj, &rtk_adv_grp);
+	if (ret < 0) {
+		netif_err(tp, probe, netdev, "creat rtk_adv_grp fail\n");
+		goto out2;
+	}
+
+#ifdef RTL8152_DEBUG
+	ret = sysfs_create_group(&netdev->dev.kobj, &rtk_dbg_grp);
+	if (ret < 0) {
+		netif_err(tp, probe, netdev, "creat rtk_dbg_grp fail\n");
+		goto out3;
+	}
+#endif
 
 	return 0;
 
+#ifdef RTL8152_DEBUG
+out3:
+	sysfs_remove_group(&netdev->dev.kobj, &rtk_adv_grp);
+#endif
+out2:
+	unregister_netdev(netdev);
 out1:
+	netif_napi_del(&tp->napi);
 	tasklet_kill(&tp->tx_tl);
 	usb_set_intfdata(intf, NULL);
 out:
@@ -9802,15 +20775,21 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	if (tp) {
-		rtl_set_unplug(tp);
+		struct net_device *netdev = tp->netdev;
+
+#ifdef RTL8152_DEBUG
+		sysfs_remove_group(&netdev->dev.kobj, &rtk_dbg_grp);
+#endif
+		sysfs_remove_group(&netdev->dev.kobj, &rtk_adv_grp);
 
-		unregister_netdev(tp->netdev);
+		rtl_set_unplug(tp);
+		unregister_netdev(netdev);
+		netif_napi_del(&tp->napi);
 		tasklet_kill(&tp->tx_tl);
 		cancel_delayed_work_sync(&tp->hw_phy_work);
 		if (tp->rtl_ops.unload)
 			tp->rtl_ops.unload(tp);
-		rtl8152_release_firmware(tp);
-		free_netdev(tp->netdev);
+		free_netdev(netdev);
 	}
 }
 
@@ -9820,6 +20799,10 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 { \
 	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
 			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE), \
+}, \
+{ \
+	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
+			USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE), \
 }
 
 /* table of devices that work with this driver */
@@ -9836,20 +20819,41 @@ static const struct usb_device_id rtl8152_table[] = {
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07ab),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x07c6),
 	REALTEK_USB_DEVICE(VENDOR_ID_MICROSOFT, 0x0927),
+
+	/* Samsung */
 	REALTEK_USB_DEVICE(VENDOR_ID_SAMSUNG, 0xa101),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x304f),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3054),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3062),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3069),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x3082),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e),
-	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387),
-	REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041),
+
+	/* Lenovo */
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x304f),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x3052),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x3054),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x3057),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x3062),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x3069),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x3082),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x3098),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x7205),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x720a),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x720b),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x720c),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x7214),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x721e),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0x8153),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0xa359),
+	REALTEK_USB_DEVICE(VENDOR_ID_LENOVO, 0xa387),
+
+	/* TP-LINK */
+	REALTEK_USB_DEVICE(VENDOR_ID_TPLINK, 0x0601),
+
+	/* Nvidia */
 	REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff),
-	REALTEK_USB_DEVICE(VENDOR_ID_TPLINK,  0x0601),
+
+	/* LINKSYS */
+	REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041),
+
+	/* Getac */
+	REALTEK_USB_DEVICE(0x2baf, 0x0012),
+
 	{}
 };
 
@@ -9866,7 +20870,9 @@ static struct usb_driver rtl8152_driver = {
 	.pre_reset =	rtl8152_pre_reset,
 	.post_reset =	rtl8152_post_reset,
 	.supports_autosuspend = 1,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0)
 	.disable_hub_initiated_lpm = 1,
+#endif
 };
 
 module_usb_driver(rtl8152_driver);
diff --git a/drivers/net/usb/r8152_compatibility.h b/drivers/net/usb/r8152_compatibility.h
new file mode 100644
index 000000000000..7738d17de7be
--- /dev/null
+++ b/drivers/net/usb/r8152_compatibility.h
@@ -0,0 +1,658 @@
+#ifndef LINUX_COMPATIBILITY_H
+#define LINUX_COMPATIBILITY_H
+
+/*
+ * Definition and macro
+ */
+
+#include <linux/init.h>
+#include <linux/version.h>
+#include <linux/in.h>
+#include <linux/acpi.h>
+
+#if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
+#include <linux/reboot.h>
+#endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
+	#include <linux/mdio.h>
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,7,0)
+	#include <uapi/linux/mdio.h>
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,7,0) */
+#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31) */
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,12,0)
+	#define PHY_MAC_INTERRUPT		PHY_IGNORE_INTERRUPT
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,9,0)
+	#ifdef CONFIG_PM
+	#define pm_ptr(_ptr) (_ptr)
+	#else
+	#define pm_ptr(_ptr) NULL
+	#endif
+
+	#define from_tasklet(var, callback_tasklet, tasklet_fieldname)	\
+		container_of((struct tasklet_struct *)callback_tasklet, typeof(*var), tasklet_fieldname)
+
+	#define tasklet_setup(t, fun)	tasklet_init(t, fun, (unsigned long)t)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,7,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,6,0)
+	/* Iterate through singly-linked GSO fragments of an skb. */
+	#define skb_list_walk_safe(first, skb, next_skb)                               \
+		for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
+		     (skb) = (next_skb), (next_skb) = (skb) ? (skb)->next : NULL)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,4,0)
+	#ifndef __has_attribute
+	# define __has_attribute(x)         0
+	#endif
+
+	#if __has_attribute(__fallthrough__)
+	# define fallthrough                    __attribute__((__fallthrough__))
+	#else
+	# define fallthrough                    do {} while (0)  /* fallthrough */
+	#endif
+
+	#define MDIO_EEE_2_5GT         0x0001  /* 2.5GT EEE cap */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,2,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,1,0)
+	#define MDIO_AN_10GBT_CTRL_ADV2_5G     0x0080  /* Advertise 2.5GBASE-T */
+	#define MDIO_AN_10GBT_STAT_LP2_5G      0x0020  /* LP is 2.5GBT capable */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,12,0)
+	#define SPEED_2500				2500
+	#define SPEED_25000				25000
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
+	#ifndef ETHTOOL_LINK_MODE_2500baseT_Full_BIT
+	#define ETHTOOL_LINK_MODE_2500baseT_Full_BIT	ETHTOOL_LINK_MODE_2500baseX_Full_BIT
+	#endif
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,9,0)
+	#define BMCR_SPEED10				0x0000
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,5,0)
+	#define NETIF_F_CSUM_MASK			NETIF_F_ALL_CSUM
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,1,0)
+	#define IS_REACHABLE(option)			(defined(option) || \
+							 (defined(option##_MODULE) && defined(MODULE)))
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,0,0)
+	#define skb_vlan_tag_present(__skb)		vlan_tx_tag_present(__skb)
+	#define skb_vlan_tag_get(__skb)			vlan_tx_tag_get(__skb)
+	#define skb_vlan_tag_get_id(__skb)		vlan_tx_tag_get_id(__skb)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,19,0)
+	#define napi_alloc_skb(napi, length)		netdev_alloc_skb_ip_align(netdev,length)
+	#define napi_complete_done(n, d)		napi_complete(n)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,16,0)
+	#ifndef smp_mb__before_atomic
+	#define smp_mb__before_atomic()			smp_mb()
+	#endif
+
+	#ifndef smp_mb__after_atomic
+	#define smp_mb__after_atomic()			smp_mb()
+	#endif
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,15,0)
+	#define IS_ERR_OR_NULL(ptr)			(!ptr)
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,14,0)
+	#define ether_addr_copy(dst, src)		memcpy(dst, src, ETH_ALEN)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,13,0)
+	#define BIT(nr)					(1UL << (nr))
+	#define BIT_ULL(nr)				(1ULL << (nr))
+	#define BITS_PER_BYTE				8
+	#define reinit_completion(x)			((x)->done = 0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,12,0)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,11,0)
+	#define DEVICE_ATTR_RW(_name) \
+		struct device_attribute dev_attr_##_name = __ATTR(_name, 0644, _name##_show, _name##_store)
+	#define DEVICE_ATTR_RO(_name) \
+		struct device_attribute dev_attr_##_name = __ATTR_RO(_name)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0)
+	#define NETIF_F_HW_VLAN_CTAG_RX			NETIF_F_HW_VLAN_RX
+	#define NETIF_F_HW_VLAN_CTAG_TX			NETIF_F_HW_VLAN_TX
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,8,0)
+	#define USB_DEVICE_INTERFACE_CLASS(vend, prod, cl) \
+		.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
+			       USB_DEVICE_ID_MATCH_INT_CLASS, \
+		.idVendor = (vend), \
+		.idProduct = (prod), \
+		.bInterfaceClass = (cl)
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,7,0)
+	#ifndef SPEED_UNKNOWN
+		#define SPEED_UNKNOWN		0
+	#endif
+
+	#ifndef DUPLEX_UNKNOWN
+		#define DUPLEX_UNKNOWN		0xff
+	#endif
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,6,0)
+	#define eth_random_addr(addr)			random_ether_addr(addr)
+	#define usb_enable_lpm(udev)
+	#define MDIO_EEE_100TX				MDIO_AN_EEE_ADV_100TX	/* 100TX EEE cap */
+	#define MDIO_EEE_1000T				MDIO_AN_EEE_ADV_1000T	/* 1000T EEE cap */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)
+	#define ETH_MDIO_SUPPORTS_C22			MDIO_SUPPORTS_C22
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)
+	#define module_usb_driver(__driver) \
+	static int __init __driver##_init(void) \
+	{ \
+		return usb_register(&(__driver)); \
+	} \
+	module_init(__driver##_init); \
+	static void __exit __driver##_exit(void) \
+	{ \
+		usb_deregister(&(__driver)); \
+	} \
+	module_exit(__driver##_exit);
+
+	#define netdev_features_t			u32
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
+	#define PMSG_IS_AUTO(msg)	(((msg).event & PM_EVENT_AUTO) != 0)
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)
+	#define ndo_set_rx_mode				ndo_set_multicast_list
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)
+	#define NETIF_F_RXCSUM				(1 << 29) /* Receive checksumming offload */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)
+	#define MDIO_AN_EEE_ADV				60	/* EEE advertisement */
+	#define MDIO_AN_EEE_ADV_100TX			0x0002	/* Advertise 100TX EEE cap */
+	#define MDIO_AN_EEE_ADV_1000T			0x0004	/* Advertise 1000T EEE cap */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)
+	#define skb_checksum_none_assert(skb_ptr)	(skb_ptr)->ip_summed = CHECKSUM_NONE
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
+	#define skb_tx_timestamp(skb)
+
+	#define queue_delayed_work(long_wq, work, delay)	schedule_delayed_work(work, delay)
+
+	#define work_busy(x)				0
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)
+	#define netdev_mc_count(netdev)			((netdev)->mc_count)
+	#define netdev_mc_empty(netdev)			(netdev_mc_count(netdev) == 0)
+
+	#define netif_printk(priv, type, level, netdev, fmt, args...)	\
+	do {								\
+		if (netif_msg_##type(priv))				\
+			printk(level "%s: " fmt,(netdev)->name , ##args); \
+	} while (0)
+
+	#define netif_emerg(priv, type, netdev, fmt, args...)		\
+		netif_printk(priv, type, KERN_EMERG, netdev, fmt, ##args)
+	#define netif_alert(priv, type, netdev, fmt, args...)		\
+		netif_printk(priv, type, KERN_ALERT, netdev, fmt, ##args)
+	#define netif_crit(priv, type, netdev, fmt, args...)		\
+		netif_printk(priv, type, KERN_CRIT, netdev, fmt, ##args)
+	#define netif_err(priv, type, netdev, fmt, args...)		\
+		netif_printk(priv, type, KERN_ERR, netdev, fmt, ##args)
+	#define netif_warn(priv, type, netdev, fmt, args...)		\
+		netif_printk(priv, type, KERN_WARNING, netdev, fmt, ##args)
+	#define netif_notice(priv, type, netdev, fmt, args...)		\
+		netif_printk(priv, type, KERN_NOTICE, netdev, fmt, ##args)
+	#define netif_info(priv, type, netdev, fmt, args...)		\
+		netif_printk(priv, type, KERN_INFO, (netdev), fmt, ##args)
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
+	#define get_sset_count				get_stats_count
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)
+	#define pm_request_resume(para)
+	#define pm_runtime_set_suspended(para)
+	#define pm_schedule_suspend(para1, para2)
+	#define pm_runtime_get_sync(para)
+	#define pm_runtime_put_sync(para)
+	#define pm_runtime_put_noidle(para)
+	#define pm_runtime_idle(para)
+	#define pm_runtime_set_active(para)
+	#define pm_runtime_enable(para)
+	#define pm_runtime_disable(para)
+	typedef int netdev_tx_t;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
+	#define USB_SPEED_SUPER				(USB_SPEED_VARIABLE + 1)
+	#define MDIO_MMD_AN				7	/* Auto-Negotiation */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
+	#define napi_gro_receive(napi, skb)		netif_receive_skb(skb)
+	#define vlan_gro_receive(napi, grp, vlan_tci, skb) \
+		vlan_hwaccel_receive_skb(skb, grp, vlan_tci)
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
+	#define PM_EVENT_AUTO		0x0400
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
+	struct napi_struct {
+		struct list_head	poll_list;
+		unsigned long		state;
+		int			weight;
+		int			(*poll)(struct napi_struct *, int);
+	#ifdef CONFIG_NETPOLL
+		spinlock_t		poll_lock;
+		int			poll_owner;
+		struct net_device	*dev;
+		struct list_head	dev_list;
+	#endif
+	};
+
+	#define napi_enable(napi_ptr)			netif_poll_enable(container_of(napi_ptr, struct r8152, napi)->netdev)
+	#define napi_disable(napi_ptr)			netif_poll_disable(container_of(napi_ptr, struct r8152, napi)->netdev)
+	#define napi_schedule(napi_ptr)			netif_rx_schedule(container_of(napi_ptr, struct r8152, napi)->netdev)
+	#define napi_complete(napi_ptr)			netif_rx_complete(container_of(napi_ptr, struct r8152, napi)->netdev)
+	#define netif_napi_add(ndev, napi_ptr, function, weight_t) \
+		ndev->poll = function; \
+		ndev->weight = weight_t;
+	typedef unsigned long				uintptr_t;
+	#define DMA_BIT_MASK(value) \
+		(value < 64 ? ((1ULL << value) - 1) : 0xFFFFFFFFFFFFFFFFULL)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)
+	#define NETIF_F_IPV6_CSUM			16
+	#define cancel_delayed_work_sync		cancel_delayed_work
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
+	#define ip_hdr(skb_ptr)				(skb_ptr)->nh.iph
+	#define ipv6hdr(skb_ptr)			(skb_ptr)->nh.ipv6h
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)
+	#define vlan_group_set_device(vlgrp, vid, value) \
+		if (vlgrp) \
+			(vlgrp)->vlan_devices[vid] = value;
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
+	#define delayed_work				work_struct
+	#define INIT_DELAYED_WORK(a,b)			INIT_WORK(a,b,tp)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
+	#define CHECKSUM_PARTIAL			CHECKSUM_HW
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
+	#define skb_is_gso(skb_ptr)			skb_shinfo(skb_ptr)->tso_size
+	#define netdev_alloc_skb(dev, len)		dev_alloc_skb(len)
+	#define IRQF_SHARED				SA_SHIRQ
+
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,16)
+	#ifndef __LINUX_MUTEX_H
+	#define mutex					semaphore
+	#define mutex_lock				down
+	#define mutex_unlock				up
+	#define mutex_trylock				down_trylock
+	#define mutex_lock_interruptible		down_interruptible
+	#define mutex_init				init_MUTEX
+	#endif
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
+	#define ADVERTISED_Pause			(1 << 13)
+	#define ADVERTISED_Asym_Pause			(1 << 14)
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12)
+	#define skb_header_cloned(skb)			skb_cloned(skb)
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,16) */
+	static inline struct sk_buff *skb_gso_segment(struct sk_buff *skb, int features)
+	{
+		return NULL;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18) */
+	static inline void *kmemdup(const void *src, size_t len, gfp_t gfp)
+	{
+		void *p;
+
+		p = kmalloc_track_caller(len, gfp);
+		if (p)
+			memcpy(p, src, len);
+		return p;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21) */
+	static inline void skb_copy_from_linear_data(const struct sk_buff *skb,
+						     void *to,
+						     const unsigned int len)
+	{
+		memcpy(to, skb->data, len);
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
+	static inline int skb_cow_head(struct sk_buff *skb, unsigned int headroom)
+	{
+		int delta = 0;
+
+		if (headroom > skb_headroom(skb))
+			delta = headroom - skb_headroom(skb);
+
+		if (delta || skb_header_cloned(skb))
+			return pskb_expand_head(skb, ALIGN(delta, NET_SKB_PAD),
+						0, GFP_ATOMIC);
+		return 0;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24) */
+	static inline void __list_splice2(const struct list_head *list,
+					  struct list_head *prev,
+					  struct list_head *next)
+	{
+		struct list_head *first = list->next;
+		struct list_head *last = list->prev;
+
+		first->prev = prev;
+		prev->next = first;
+
+		last->next = next;
+		next->prev = last;
+	}
+
+	static inline void list_splice_tail(struct list_head *list,
+					    struct list_head *head)
+	{
+		if (!list_empty(list))
+			__list_splice2(list, head->prev, head);
+	}
+
+	static inline void netif_napi_del(struct napi_struct *napi)
+	{
+	#ifdef CONFIG_NETPOLL
+	        list_del(&napi->dev_list);
+	#endif
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27) */
+	static inline void __skb_queue_splice(const struct sk_buff_head *list,
+					      struct sk_buff *prev,
+					      struct sk_buff *next)
+	{
+		struct sk_buff *first = list->next;
+		struct sk_buff *last = list->prev;
+
+		first->prev = prev;
+		prev->next = first;
+
+		last->next = next;
+		next->prev = last;
+	}
+
+	static inline void skb_queue_splice(const struct sk_buff_head *list,
+					    struct sk_buff_head *head)
+	{
+		if (!skb_queue_empty(list)) {
+			__skb_queue_splice(list, (struct sk_buff *) head, head->next);
+			head->qlen += list->qlen;
+		}
+	}
+
+	static inline void __skb_queue_head_init(struct sk_buff_head *list)
+	{
+		list->prev = list->next = (struct sk_buff *)list;
+		list->qlen = 0;
+	}
+
+	static inline void skb_queue_splice_init(struct sk_buff_head *list,
+						 struct sk_buff_head *head)
+	{
+		if (!skb_queue_empty(list)) {
+			__skb_queue_splice(list, (struct sk_buff *) head, head->next);
+			head->qlen += list->qlen;
+			__skb_queue_head_init(list);
+		}
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
+	static inline void usb_autopm_put_interface_async(struct usb_interface *intf)
+	{
+		struct usb_device *udev = interface_to_usbdev(intf);
+		int status = 0;
+
+		if (intf->condition == USB_INTERFACE_UNBOUND) {
+			status = -ENODEV;
+		} else {
+			udev->last_busy = jiffies;
+			--intf->pm_usage_cnt;
+			if (udev->autosuspend_disabled || udev->autosuspend_delay < 0)
+				status = -EPERM;
+		}
+	}
+
+	static inline int usb_autopm_get_interface_async(struct usb_interface *intf)
+	{
+		struct usb_device *udev = interface_to_usbdev(intf);
+		int status = 0;
+
+		if (intf->condition == USB_INTERFACE_UNBOUND)
+			status = -ENODEV;
+		else if (udev->autoresume_disabled)
+			status = -EPERM;
+		else
+			++intf->pm_usage_cnt;
+		return status;
+	}
+
+	static inline int eth_change_mtu(struct net_device *dev, int new_mtu)
+	{
+		if (new_mtu < 68 || new_mtu > ETH_DATA_LEN)
+			return -EINVAL;
+		dev->mtu = new_mtu;
+		return 0;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32) */
+	static inline
+	struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
+						  unsigned int length)
+	{
+		struct sk_buff *skb = netdev_alloc_skb(dev, length + NET_IP_ALIGN);
+
+		if (NET_IP_ALIGN && skb)
+			skb_reserve(skb, NET_IP_ALIGN);
+		return skb;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33) */
+	static inline int usb_enable_autosuspend(struct usb_device *udev)
+	{ return 0; }
+	static inline int usb_disable_autosuspend(struct usb_device *udev)
+	{ return 0; }
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34) */
+	static inline bool pci_dev_run_wake(struct pci_dev *dev)
+	{
+		return 1;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35) */
+	static inline void usleep_range(unsigned long min, unsigned long max)
+	{
+		unsigned long ms = min / 1000;
+
+		if (ms)
+			mdelay(ms);
+
+		udelay(min % 1000);
+	}
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36) */
+	static inline __be16 vlan_get_protocol(const struct sk_buff *skb)
+	{
+	       __be16 protocol = 0;
+
+	       if (vlan_tx_tag_present(skb) ||
+	            skb->protocol != cpu_to_be16(ETH_P_8021Q))
+	               protocol = skb->protocol;
+	       else {
+	               __be16 proto, *protop;
+	               protop = skb_header_pointer(skb, offsetof(struct vlan_ethhdr,
+	                                               h_vlan_encapsulated_proto),
+	                                               sizeof(proto), &proto);
+	               if (likely(protop))
+	                       protocol = *protop;
+	       }
+
+	       return protocol;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0) */
+	static inline struct page *skb_frag_page(const skb_frag_t *frag)
+	{
+		return frag->page;
+	}
+
+	static inline void *skb_frag_address(const skb_frag_t *frag)
+	{
+		return page_address(skb_frag_page(frag)) + frag->page_offset;
+	}
+
+	static inline unsigned int skb_frag_size(const skb_frag_t *frag)
+	{
+		return frag->size;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0) */
+	static inline void eth_hw_addr_random(struct net_device *dev)
+	{
+		random_ether_addr(dev->dev_addr);
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,6,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,7,0) */
+	static inline __sum16 tcp_v6_check(int len,
+					   const struct in6_addr *saddr,
+					   const struct in6_addr *daddr,
+					   __wsum base)
+	{
+		return csum_ipv6_magic(saddr, daddr, len, IPPROTO_TCP, base);
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,8,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,11,0) */
+	static inline bool usb_device_no_sg_constraint(struct usb_device *udev)
+	{
+		return 0;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,12,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,13,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,14,0) */
+	static inline int skb_to_sgvec_nomark(struct sk_buff *skb,
+					      struct scatterlist *sg,
+					      int offset, int len)
+	{
+		int nsg = skb_to_sgvec(skb, sg, offset, len);
+
+		if (nsg <= 0)
+			return nsg;
+
+		sg_unmark_end(&sg[nsg - 1]);
+
+		return nsg;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,15,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,16,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,19,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,0,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,1,0) */
+	static inline int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr)
+	{
+		return -EOPNOTSUPP;
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,5,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,9,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,12,0) */
+#if LINUX_VERSION_CODE < KERNEL_VERSION(4,19,10) && \
+    !(LINUX_VERSION_CODE >= KERNEL_VERSION(4,14,217) && LINUX_VERSION_CODE < KERNEL_VERSION(4,15,0))
+	static inline void skb_mark_not_on_list(struct sk_buff *skb)
+	{
+		skb->next = NULL;
+	}
+#endif
+	static inline void linkmode_set_bit(int nr, volatile unsigned long *addr)
+	{
+		__set_bit(nr, addr);
+	}
+
+	static inline void linkmode_clear_bit(int nr, volatile unsigned long *addr)
+	{
+		__clear_bit(nr, addr);
+	}
+
+	static inline int linkmode_test_bit(int nr, volatile unsigned long *addr)
+	{
+		return test_bit(nr, addr);
+	}
+
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0) */
+	static inline void linkmode_mod_bit(int nr, volatile unsigned long *addr,
+					    int set)
+	{
+		if (set)
+			linkmode_set_bit(nr, addr);
+		else
+			linkmode_clear_bit(nr, addr);
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,1,0) */
+//	static inline u16 pci_dev_id(struct pci_dev *dev)
+//	{
+//		return PCI_DEVID(dev->bus->number, dev->devfn);
+//	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,2,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,4,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,6,0) */
+	static inline void tcp_v6_gso_csum_prep(struct sk_buff *skb)
+	{
+		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+		struct tcphdr *th = tcp_hdr(skb);
+
+		ipv6h->payload_len = 0;
+		th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,7,0) */
+	static inline void fsleep(unsigned long usecs)
+	{
+		if (usecs <= 10)
+			udelay(usecs);
+		else if (usecs <= 20000)
+			usleep_range(usecs, 2 * usecs);
+		else
+			msleep(DIV_ROUND_UP(usecs, 1000));
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,9,0) */
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,12,0) */
+	static inline void eth_hw_addr_set(struct net_device *dev, const u8 *addr)
+	{
+		memcpy(dev->dev_addr, addr, 6);
+	}
+#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
+
+#ifndef FALSE
+	#define TRUE	1
+	#define FALSE	0
+#endif
+
+enum rtl_cmd {
+	RTLTOOL_PLA_OCP_READ_DWORD = 0,
+	RTLTOOL_PLA_OCP_WRITE_DWORD,
+	RTLTOOL_USB_OCP_READ_DWORD,
+	RTLTOOL_USB_OCP_WRITE_DWORD,
+	RTLTOOL_PLA_OCP_READ,
+	RTLTOOL_PLA_OCP_WRITE,
+	RTLTOOL_USB_OCP_READ,
+	RTLTOOL_USB_OCP_WRITE,
+	RTLTOOL_USB_INFO,
+	RTL_ENABLE_USB_DIAG,
+	RTL_DISABLE_USB_DIAG,
+
+	RTLTOOL_INVALID
+};
+
+struct usb_device_info {
+	__u16		idVendor;
+	__u16		idProduct;
+	__u16		bcdDevice;
+	__u8		dev_addr[8];
+	char		devpath[16];
+};
+
+struct rtltool_cmd {
+	__u32	cmd;
+	__u32	offset;
+	__u32	byteen;
+	__u32	data;
+	void	*buf;
+	struct usb_device_info nic_info;
+	struct sockaddr ifru_addr;
+	struct sockaddr ifru_netmask;
+	struct sockaddr ifru_hwaddr;
+};
+
+#endif /* LINUX_COMPATIBILITY_H */
-- 
2.34.1

