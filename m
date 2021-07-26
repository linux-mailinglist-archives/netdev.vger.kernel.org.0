Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D63C3D5214
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 06:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhGZDVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 23:21:41 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:35841 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhGZDVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 23:21:33 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16Q41tPtA018637, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16Q41tPtA018637
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 12:01:55 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 12:01:55 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Mon, 26 Jul
 2021 12:01:53 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next RESEND 2/2] r8152: separate the r8152.c into r8152_main.c and r8152_fw.c
Date:   Mon, 26 Jul 2021 12:01:09 +0800
Message-ID: <1394712342-15778-373-Taiwan-albertk@realtek.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1394712342-15778-371-Taiwan-albertk@realtek.com>
References: <1394712342-15778-368-Taiwan-albertk@realtek.com>
 <1394712342-15778-371-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/23/2021 16:12:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMjMgpFWkyCAwMjowNTowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMjYgpFekyCAwMjo1MjowMA==?=
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 03:51:53
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165230 [Jul 25 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: {Track_Chinese_Simplified, headers_charset}
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 03:54:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename r8152.c with r8152_main.c. Move some basic definitions from
r8152_main.c to r8152_basic.h. Move the relative code of firmware
from r8152_main.c to r8152_fw.c. Rename the definition of "EFUSE"
with "USB_EFUSE".

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/realtek/Makefile              |    1 +
 drivers/net/usb/realtek/r8152_basic.h         |  861 ++++++
 drivers/net/usb/realtek/r8152_fw.c            | 1557 ++++++++++
 .../net/usb/realtek/{r8152.c => r8152_main.c} | 2590 +----------------
 4 files changed, 2527 insertions(+), 2482 deletions(-)
 create mode 100644 drivers/net/usb/realtek/r8152_basic.h
 create mode 100644 drivers/net/usb/realtek/r8152_fw.c
 rename drivers/net/usb/realtek/{r8152.c => r8152_main.c} (75%)

diff --git a/drivers/net/usb/realtek/Makefile b/drivers/net/usb/realtek/Makefile
index 6f89910a8f76..513a34775e0a 100644
--- a/drivers/net/usb/realtek/Makefile
+++ b/drivers/net/usb/realtek/Makefile
@@ -5,4 +5,5 @@
 
 obj-$(CONFIG_USB_RTL8150)	+= rtl8150.o
 obj-$(CONFIG_USB_RTL8152)	+= r8152.o
+r8152-objs := r8152_main.o r8152_fw.o
 obj-$(CONFIG_USB_RTL8153_ECM)	+= r8153_ecm.o
diff --git a/drivers/net/usb/realtek/r8152_basic.h b/drivers/net/usb/realtek/r8152_basic.h
new file mode 100644
index 000000000000..96af784d7535
--- /dev/null
+++ b/drivers/net/usb/realtek/r8152_basic.h
@@ -0,0 +1,861 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ *  Copyright (c) 2021 Realtek Semiconductor Corp. All rights reserved.
+ */
+
+#ifndef LINUX_R8152_BASIC_H
+#define LINUX_R8152_BASIC_H
+
+#define PLA_IDR			0xc000
+#define PLA_RCR			0xc010
+#define PLA_RCR1		0xc012
+#define PLA_RMS			0xc016
+#define PLA_RXFIFO_CTRL0	0xc0a0
+#define PLA_RXFIFO_FULL		0xc0a2
+#define PLA_RXFIFO_CTRL1	0xc0a4
+#define PLA_RX_FIFO_FULL	0xc0a6
+#define PLA_RXFIFO_CTRL2	0xc0a8
+#define PLA_RX_FIFO_EMPTY	0xc0aa
+#define PLA_DMY_REG0		0xc0b0
+#define PLA_FMC			0xc0b4
+#define PLA_CFG_WOL		0xc0b6
+#define PLA_TEREDO_CFG		0xc0bc
+#define PLA_TEREDO_WAKE_BASE	0xc0c4
+#define PLA_MAR			0xcd00
+#define PLA_BACKUP		0xd000
+#define PLA_BDC_CR		0xd1a0
+#define PLA_TEREDO_TIMER	0xd2cc
+#define PLA_REALWOW_TIMER	0xd2e8
+#define PLA_UPHY_TIMER		0xd388
+#define PLA_SUSPEND_FLAG	0xd38a
+#define PLA_INDICATE_FALG	0xd38c
+#define PLA_MACDBG_PRE		0xd38c	/* RTL_VER_04 only */
+#define PLA_MACDBG_POST		0xd38e	/* RTL_VER_04 only */
+#define PLA_EXTRA_STATUS	0xd398
+#define PLA_GPHY_CTRL		0xd3ae
+#define PLA_POL_GPIO_CTRL	0xdc6a
+#define PLA_EFUSE_DATA		0xdd00
+#define PLA_EFUSE_CMD		0xdd02
+#define PLA_LEDSEL		0xdd90
+#define PLA_LED_FEATURE		0xdd92
+#define PLA_PHYAR		0xde00
+#define PLA_BOOT_CTRL		0xe004
+#define PLA_LWAKE_CTRL_REG	0xe007
+#define PLA_GPHY_INTR_IMR	0xe022
+#define PLA_EEE_CR		0xe040
+#define PLA_EEE_TXTWSYS		0xe04c
+#define PLA_EEE_TXTWSYS_2P5G	0xe058
+#define PLA_EEEP_CR		0xe080
+#define PLA_MAC_PWR_CTRL	0xe0c0
+#define PLA_MAC_PWR_CTRL2	0xe0ca
+#define PLA_MAC_PWR_CTRL3	0xe0cc
+#define PLA_MAC_PWR_CTRL4	0xe0ce
+#define PLA_WDT6_CTRL		0xe428
+#define PLA_TCR0		0xe610
+#define PLA_TCR1		0xe612
+#define PLA_MTPS		0xe615
+#define PLA_TXFIFO_CTRL		0xe618
+#define PLA_TXFIFO_FULL		0xe61a
+#define PLA_RSTTALLY		0xe800
+#define PLA_CR			0xe813
+#define PLA_CRWECR		0xe81c
+#define PLA_CONFIG12		0xe81e	/* CONFIG1, CONFIG2 */
+#define PLA_CONFIG34		0xe820	/* CONFIG3, CONFIG4 */
+#define PLA_CONFIG5		0xe822
+#define PLA_PHY_PWR		0xe84c
+#define PLA_OOB_CTRL		0xe84f
+#define PLA_CPCR		0xe854
+#define PLA_MISC_0		0xe858
+#define PLA_MISC_1		0xe85a
+#define PLA_OCP_GPHY_BASE	0xe86c
+#define PLA_TALLYCNT		0xe890
+#define PLA_SFF_STS_7		0xe8de
+#define PLA_PHYSTATUS		0xe908
+#define PLA_CONFIG6		0xe90a /* CONFIG6 */
+#define PLA_USB_CFG		0xe952
+#define PLA_BP_BA		0xfc26
+#define PLA_BP_0		0xfc28
+#define PLA_BP_1		0xfc2a
+#define PLA_BP_2		0xfc2c
+#define PLA_BP_3		0xfc2e
+#define PLA_BP_4		0xfc30
+#define PLA_BP_5		0xfc32
+#define PLA_BP_6		0xfc34
+#define PLA_BP_7		0xfc36
+#define PLA_BP_EN		0xfc38
+
+#define USB_USB2PHY		0xb41e
+#define USB_SSPHYLINK1		0xb426
+#define USB_SSPHYLINK2		0xb428
+#define USB_L1_CTRL		0xb45e
+#define USB_U2P3_CTRL		0xb460
+#define USB_CSR_DUMMY1		0xb464
+#define USB_CSR_DUMMY2		0xb466
+#define USB_DEV_STAT		0xb808
+#define USB_CONNECT_TIMER	0xcbf8
+#define USB_MSC_TIMER		0xcbfc
+#define USB_BURST_SIZE		0xcfc0
+#define USB_FW_FIX_EN0		0xcfca
+#define USB_FW_FIX_EN1		0xcfcc
+#define USB_LPM_CONFIG		0xcfd8
+#define USB_EFUSE		0xcfdb
+#define USB_ECM_OPTION		0xcfee
+#define USB_CSTMR		0xcfef	/* RTL8153A */
+#define USB_MISC_2		0xcfff
+#define USB_ECM_OP		0xd26b
+#define USB_GPHY_CTRL		0xd284
+#define USB_SPEED_OPTION	0xd32a
+#define USB_FW_CTRL		0xd334	/* RTL8153B */
+#define USB_FC_TIMER		0xd340
+#define USB_USB_CTRL		0xd406
+#define USB_PHY_CTRL		0xd408
+#define USB_TX_AGG		0xd40a
+#define USB_RX_BUF_TH		0xd40c
+#define USB_USB_TIMER		0xd428
+#define USB_RX_EARLY_TIMEOUT	0xd42c
+#define USB_RX_EARLY_SIZE	0xd42e
+#define USB_PM_CTRL_STATUS	0xd432	/* RTL8153A */
+#define USB_RX_EXTRA_AGGR_TMR	0xd432	/* RTL8153B */
+#define USB_TX_DMA		0xd434
+#define USB_UPT_RXDMA_OWN	0xd437
+#define USB_UPHY3_MDCMDIO	0xd480
+#define USB_TOLERANCE		0xd490
+#define USB_LPM_CTRL		0xd41a
+#define USB_BMU_RESET		0xd4b0
+#define USB_BMU_CONFIG		0xd4b4
+#define USB_U1U2_TIMER		0xd4da
+#define USB_FW_TASK		0xd4e8	/* RTL8153B */
+#define USB_RX_AGGR_NUM		0xd4ee
+#define USB_UPS_CTRL		0xd800
+#define USB_POWER_CUT		0xd80a
+#define USB_MISC_0		0xd81a
+#define USB_MISC_1		0xd81f
+#define USB_AFE_CTRL2		0xd824
+#define USB_UPHY_XTAL		0xd826
+#define USB_UPS_CFG		0xd842
+#define USB_UPS_FLAGS		0xd848
+#define USB_WDT1_CTRL		0xe404
+#define USB_WDT11_CTRL		0xe43c
+#define USB_BP_BA		PLA_BP_BA
+#define USB_BP_0		PLA_BP_0
+#define USB_BP_1		PLA_BP_1
+#define USB_BP_2		PLA_BP_2
+#define USB_BP_3		PLA_BP_3
+#define USB_BP_4		PLA_BP_4
+#define USB_BP_5		PLA_BP_5
+#define USB_BP_6		PLA_BP_6
+#define USB_BP_7		PLA_BP_7
+#define USB_BP_EN		PLA_BP_EN	/* RTL8153A */
+#define USB_BP_8		0xfc38		/* RTL8153B */
+#define USB_BP_9		0xfc3a
+#define USB_BP_10		0xfc3c
+#define USB_BP_11		0xfc3e
+#define USB_BP_12		0xfc40
+#define USB_BP_13		0xfc42
+#define USB_BP_14		0xfc44
+#define USB_BP_15		0xfc46
+#define USB_BP2_EN		0xfc48
+
+/* OCP Registers */
+#define OCP_ALDPS_CONFIG	0x2010
+#define OCP_EEE_CONFIG1		0x2080
+#define OCP_EEE_CONFIG2		0x2092
+#define OCP_EEE_CONFIG3		0x2094
+#define OCP_BASE_MII		0xa400
+#define OCP_EEE_AR		0xa41a
+#define OCP_EEE_DATA		0xa41c
+#define OCP_PHY_STATUS		0xa420
+#define OCP_NCTL_CFG		0xa42c
+#define OCP_POWER_CFG		0xa430
+#define OCP_EEE_CFG		0xa432
+#define OCP_SRAM_ADDR		0xa436
+#define OCP_SRAM_DATA		0xa438
+#define OCP_DOWN_SPEED		0xa442
+#define OCP_EEE_ABLE		0xa5c4
+#define OCP_EEE_ADV		0xa5d0
+#define OCP_EEE_LPABLE		0xa5d2
+#define OCP_10GBT_CTRL		0xa5d4
+#define OCP_10GBT_STAT		0xa5d6
+#define OCP_EEE_ADV2		0xa6d4
+#define OCP_PHY_STATE		0xa708		/* nway state for 8153 */
+#define OCP_PHY_PATCH_STAT	0xb800
+#define OCP_PHY_PATCH_CMD	0xb820
+#define OCP_PHY_LOCK		0xb82e
+#define OCP_ADC_IOFFSET		0xbcfc
+#define OCP_ADC_CFG		0xbc06
+#define OCP_SYSCLK_CFG		0xc416
+
+/* SRAM Register */
+#define SRAM_GREEN_CFG		0x8011
+#define SRAM_LPF_CFG		0x8012
+#define SRAM_GPHY_FW_VER	0x801e
+#define SRAM_10M_AMP1		0x8080
+#define SRAM_10M_AMP2		0x8082
+#define SRAM_IMPEDANCE		0x8084
+#define SRAM_PHY_LOCK		0xb82e
+
+/* PLA_RCR */
+#define RCR_AAP			0x00000001
+#define RCR_APM			0x00000002
+#define RCR_AM			0x00000004
+#define RCR_AB			0x00000008
+#define RCR_ACPT_ALL		(RCR_AAP | RCR_APM | RCR_AM | RCR_AB)
+#define SLOT_EN			BIT(11)
+
+/* PLA_RCR1 */
+#define OUTER_VLAN		BIT(7)
+#define INNER_VLAN		BIT(6)
+
+/* PLA_RXFIFO_CTRL0 */
+#define RXFIFO_THR1_NORMAL	0x00080002
+#define RXFIFO_THR1_OOB		0x01800003
+
+/* PLA_RXFIFO_FULL */
+#define RXFIFO_FULL_MASK	0xfff
+
+/* PLA_RXFIFO_CTRL1 */
+#define RXFIFO_THR2_FULL	0x00000060
+#define RXFIFO_THR2_HIGH	0x00000038
+#define RXFIFO_THR2_OOB		0x0000004a
+#define RXFIFO_THR2_NORMAL	0x00a0
+
+/* PLA_RXFIFO_CTRL2 */
+#define RXFIFO_THR3_FULL	0x00000078
+#define RXFIFO_THR3_HIGH	0x00000048
+#define RXFIFO_THR3_OOB		0x0000005a
+#define RXFIFO_THR3_NORMAL	0x0110
+
+/* PLA_TXFIFO_CTRL */
+#define TXFIFO_THR_NORMAL	0x00400008
+#define TXFIFO_THR_NORMAL2	0x01000008
+
+/* PLA_DMY_REG0 */
+#define ECM_ALDPS		0x0002
+
+/* PLA_FMC */
+#define FMC_FCR_MCU_EN		0x0001
+
+/* PLA_EEEP_CR */
+#define EEEP_CR_EEEP_TX		0x0002
+
+/* PLA_WDT6_CTRL */
+#define WDT6_SET_MODE		0x0010
+
+/* PLA_TCR0 */
+#define TCR0_TX_EMPTY		0x0800
+#define TCR0_AUTO_FIFO		0x0080
+
+/* PLA_TCR1 */
+#define VERSION_MASK		0x7cf0
+#define IFG_MASK		(BIT(3) | BIT(9) | BIT(8))
+#define IFG_144NS		BIT(9)
+#define IFG_96NS		(BIT(9) | BIT(8))
+
+/* PLA_MTPS */
+#define MTPS_JUMBO		(12 * 1024 / 64)
+#define MTPS_DEFAULT		(6 * 1024 / 64)
+
+/* PLA_RSTTALLY */
+#define TALLY_RESET		0x0001
+
+/* PLA_CR */
+#define CR_RST			0x10
+#define CR_RE			0x08
+#define CR_TE			0x04
+
+/* PLA_CRWECR */
+#define CRWECR_NORAML		0x00
+#define CRWECR_CONFIG		0xc0
+
+/* PLA_OOB_CTRL */
+#define NOW_IS_OOB		0x80
+#define TXFIFO_EMPTY		0x20
+#define RXFIFO_EMPTY		0x10
+#define LINK_LIST_READY		0x02
+#define DIS_MCU_CLROOB		0x01
+#define FIFO_EMPTY		(TXFIFO_EMPTY | RXFIFO_EMPTY)
+
+/* PLA_MISC_1 */
+#define RXDY_GATED_EN		0x0008
+
+/* PLA_SFF_STS_7 */
+#define RE_INIT_LL		0x8000
+#define MCU_BORW_EN		0x4000
+
+/* PLA_CPCR */
+#define FLOW_CTRL_EN		BIT(0)
+#define CPCR_RX_VLAN		0x0040
+
+/* PLA_CFG_WOL */
+#define MAGIC_EN		0x0001
+
+/* PLA_TEREDO_CFG */
+#define TEREDO_SEL		0x8000
+#define TEREDO_WAKE_MASK	0x7f00
+#define TEREDO_RS_EVENT_MASK	0x00fe
+#define OOB_TEREDO_EN		0x0001
+
+/* PLA_BDC_CR */
+#define ALDPS_PROXY_MODE	0x0001
+
+/* PLA_EFUSE_CMD */
+#define EFUSE_READ_CMD		BIT(15)
+#define EFUSE_DATA_BIT16	BIT(7)
+
+/* PLA_CONFIG34 */
+#define LINK_ON_WAKE_EN		0x0010
+#define LINK_OFF_WAKE_EN	0x0008
+
+/* PLA_CONFIG6 */
+#define LANWAKE_CLR_EN		BIT(0)
+
+/* PLA_USB_CFG */
+#define EN_XG_LIP		BIT(1)
+#define EN_G_LIP		BIT(2)
+
+/* PLA_CONFIG5 */
+#define BWF_EN			0x0040
+#define MWF_EN			0x0020
+#define UWF_EN			0x0010
+#define LAN_WAKE_EN		0x0002
+
+/* PLA_LED_FEATURE */
+#define LED_MODE_MASK		0x0700
+
+/* PLA_PHY_PWR */
+#define TX_10M_IDLE_EN		0x0080
+#define PFM_PWM_SWITCH		0x0040
+#define TEST_IO_OFF		BIT(4)
+
+/* PLA_MAC_PWR_CTRL */
+#define D3_CLK_GATED_EN		0x00004000
+#define MCU_CLK_RATIO		0x07010f07
+#define MCU_CLK_RATIO_MASK	0x0f0f0f0f
+#define ALDPS_SPDWN_RATIO	0x0f87
+
+/* PLA_MAC_PWR_CTRL2 */
+#define EEE_SPDWN_RATIO		0x8007
+#define MAC_CLK_SPDWN_EN	BIT(15)
+#define EEE_SPDWN_RATIO_MASK	0xff
+
+/* PLA_MAC_PWR_CTRL3 */
+#define PLA_MCU_SPDWN_EN	BIT(14)
+#define PKT_AVAIL_SPDWN_EN	0x0100
+#define SUSPEND_SPDWN_EN	0x0004
+#define U1U2_SPDWN_EN		0x0002
+#define L1_SPDWN_EN		0x0001
+
+/* PLA_MAC_PWR_CTRL4 */
+#define PWRSAVE_SPDWN_EN	0x1000
+#define RXDV_SPDWN_EN		0x0800
+#define TX10MIDLE_EN		0x0100
+#define IDLE_SPDWN_EN		BIT(6)
+#define TP100_SPDWN_EN		0x0020
+#define TP500_SPDWN_EN		0x0010
+#define TP1000_SPDWN_EN		0x0008
+#define EEE_SPDWN_EN		0x0001
+
+/* PLA_GPHY_INTR_IMR */
+#define GPHY_STS_MSK		0x0001
+#define SPEED_DOWN_MSK		0x0002
+#define SPDWN_RXDV_MSK		0x0004
+#define SPDWN_LINKCHG_MSK	0x0008
+
+/* PLA_PHYAR */
+#define PHYAR_FLAG		0x80000000
+
+/* PLA_EEE_CR */
+#define EEE_RX_EN		0x0001
+#define EEE_TX_EN		0x0002
+
+/* PLA_BOOT_CTRL */
+#define AUTOLOAD_DONE		0x0002
+
+/* PLA_LWAKE_CTRL_REG */
+#define LANWAKE_PIN		BIT(7)
+
+/* PLA_SUSPEND_FLAG */
+#define LINK_CHG_EVENT		BIT(0)
+
+/* PLA_INDICATE_FALG */
+#define UPCOMING_RUNTIME_D3	BIT(0)
+
+/* PLA_MACDBG_PRE and PLA_MACDBG_POST */
+#define DEBUG_OE		BIT(0)
+#define DEBUG_LTSSM		0x0082
+
+/* PLA_EXTRA_STATUS */
+#define CUR_LINK_OK		BIT(15)
+#define U3P3_CHECK_EN		BIT(7)	/* RTL_VER_05 only */
+#define LINK_CHANGE_FLAG	BIT(8)
+#define POLL_LINK_CHG		BIT(0)
+
+/* PLA_GPHY_CTRL */
+#define GPHY_FLASH		BIT(1)
+
+/* PLA_POL_GPIO_CTRL */
+#define DACK_DET_EN		BIT(15)
+#define POL_GPHY_PATCH		BIT(4)
+
+/* USB_USB2PHY */
+#define USB2PHY_SUSPEND		0x0001
+#define USB2PHY_L1		0x0002
+
+/* USB_SSPHYLINK1 */
+#define DELAY_PHY_PWR_CHG	BIT(1)
+
+/* USB_SSPHYLINK2 */
+#define pwd_dn_scale_mask	0x3ffe
+#define pwd_dn_scale(x)		((x) << 1)
+
+/* USB_CSR_DUMMY1 */
+#define DYNAMIC_BURST		0x0001
+
+/* USB_CSR_DUMMY2 */
+#define EP4_FULL_FC		0x0001
+
+/* USB_DEV_STAT */
+#define STAT_SPEED_MASK		0x0006
+#define STAT_SPEED_HIGH		0x0000
+#define STAT_SPEED_FULL		0x0002
+
+/* USB_FW_FIX_EN0 */
+#define FW_FIX_SUSPEND		BIT(14)
+
+/* USB_FW_FIX_EN1 */
+#define FW_IP_RESET_EN		BIT(9)
+
+/* USB_LPM_CONFIG */
+#define LPM_U1U2_EN		BIT(0)
+
+/* USB_EFUSE */
+#define PASS_THRU_MASK		BIT(0)
+
+/* USB_TX_AGG */
+#define TX_AGG_MAX_THRESHOLD	0x03
+
+/* USB_RX_BUF_TH */
+#define RX_THR_SUPPER		0x0c350180
+#define RX_THR_HIGH		0x7a120180
+#define RX_THR_SLOW		0xffff0180
+#define RX_THR_B		0x00010001
+
+/* USB_TX_DMA */
+#define TEST_MODE_DISABLE	0x00000001
+#define TX_SIZE_ADJUST1		0x00000100
+
+/* USB_BMU_RESET */
+#define BMU_RESET_EP_IN		0x01
+#define BMU_RESET_EP_OUT	0x02
+
+/* USB_BMU_CONFIG */
+#define ACT_ODMA		BIT(1)
+
+/* USB_UPT_RXDMA_OWN */
+#define OWN_UPDATE		BIT(0)
+#define OWN_CLEAR		BIT(1)
+
+/* USB_FW_TASK */
+#define FC_PATCH_TASK		BIT(1)
+
+/* USB_RX_AGGR_NUM */
+#define RX_AGGR_NUM_MASK	0x1ff
+
+/* USB_UPS_CTRL */
+#define POWER_CUT		0x0100
+
+/* USB_PM_CTRL_STATUS */
+#define RESUME_INDICATE		0x0001
+
+/* USB_ECM_OPTION */
+#define BYPASS_MAC_RESET	BIT(5)
+
+/* USB_CSTMR */
+#define FORCE_SUPER		BIT(0)
+
+/* USB_MISC_2 */
+#define UPS_FORCE_PWR_DOWN	BIT(0)
+
+/* USB_ECM_OP */
+#define	EN_ALL_SPEED		BIT(0)
+
+/* USB_GPHY_CTRL */
+#define GPHY_PATCH_DONE		BIT(2)
+#define BYPASS_FLASH		BIT(5)
+#define BACKUP_RESTRORE		BIT(6)
+
+/* USB_SPEED_OPTION */
+#define RG_PWRDN_EN		BIT(8)
+#define ALL_SPEED_OFF		BIT(9)
+
+/* USB_FW_CTRL */
+#define FLOW_CTRL_PATCH_OPT	BIT(1)
+#define AUTO_SPEEDUP		BIT(3)
+#define FLOW_CTRL_PATCH_2	BIT(8)
+
+/* USB_FC_TIMER */
+#define CTRL_TIMER_EN		BIT(15)
+
+/* USB_USB_CTRL */
+#define CDC_ECM_EN		BIT(3)
+#define RX_AGG_DISABLE		0x0010
+#define RX_ZERO_EN		0x0080
+
+/* USB_U2P3_CTRL */
+#define U2P3_ENABLE		0x0001
+#define RX_DETECT8		BIT(3)
+
+/* USB_POWER_CUT */
+#define PWR_EN			0x0001
+#define PHASE2_EN		0x0008
+#define UPS_EN			BIT(4)
+#define USP_PREWAKE		BIT(5)
+
+/* USB_MISC_0 */
+#define PCUT_STATUS		0x0001
+#define AD_MASK			0xfee0
+
+/* USB_MISC_1 */
+#define BD_MASK			BIT(0)
+#define BND_MASK		BIT(2)
+#define BL_MASK			BIT(3)
+
+/* USB_RX_EARLY_TIMEOUT */
+#define COALESCE_SUPER		 85000U
+#define COALESCE_HIGH		250000U
+#define COALESCE_SLOW		524280U
+
+/* USB_WDT1_CTRL */
+#define WTD1_EN			BIT(0)
+
+/* USB_WDT11_CTRL */
+#define TIMER11_EN		0x0001
+
+/* USB_LPM_CTRL */
+/* bit 4 ~ 5: fifo empty boundary */
+#define FIFO_EMPTY_1FB		0x30	/* 0x1fb * 64 = 32448 bytes */
+/* bit 2 ~ 3: LMP timer */
+#define LPM_TIMER_MASK		0x0c
+#define LPM_TIMER_500MS		0x04	/* 500 ms */
+#define LPM_TIMER_500US		0x0c	/* 500 us */
+#define ROK_EXIT_LPM		0x02
+
+/* USB_AFE_CTRL2 */
+#define SEN_VAL_MASK		0xf800
+#define SEN_VAL_NORMAL		0xa000
+#define SEL_RXIDLE		0x0100
+
+/* USB_UPHY_XTAL */
+#define OOBS_POLLING		BIT(8)
+
+/* USB_UPS_CFG */
+#define SAW_CNT_1MS_MASK	0x0fff
+#define MID_REVERSE		BIT(5)	/* RTL8156A */
+
+/* USB_UPS_FLAGS */
+#define UPS_FLAGS_R_TUNE		BIT(0)
+#define UPS_FLAGS_EN_10M_CKDIV		BIT(1)
+#define UPS_FLAGS_250M_CKDIV		BIT(2)
+#define UPS_FLAGS_EN_ALDPS		BIT(3)
+#define UPS_FLAGS_CTAP_SHORT_DIS	BIT(4)
+#define UPS_FLAGS_SPEED_MASK		(0xf << 16)
+#define ups_flags_speed(x)		((x) << 16)
+#define UPS_FLAGS_EN_EEE		BIT(20)
+#define UPS_FLAGS_EN_500M_EEE		BIT(21)
+#define UPS_FLAGS_EN_EEE_CKDIV		BIT(22)
+#define UPS_FLAGS_EEE_PLLOFF_100	BIT(23)
+#define UPS_FLAGS_EEE_PLLOFF_GIGA	BIT(24)
+#define UPS_FLAGS_EEE_CMOD_LV_EN	BIT(25)
+#define UPS_FLAGS_EN_GREEN		BIT(26)
+#define UPS_FLAGS_EN_FLOW_CTR		BIT(27)
+
+enum spd_duplex {
+	NWAY_10M_HALF,
+	NWAY_10M_FULL,
+	NWAY_100M_HALF,
+	NWAY_100M_FULL,
+	NWAY_1000M_FULL,
+	FORCE_10M_HALF,
+	FORCE_10M_FULL,
+	FORCE_100M_HALF,
+	FORCE_100M_FULL,
+	FORCE_1000M_FULL,
+	NWAY_2500M_FULL,
+};
+
+/* OCP_ALDPS_CONFIG */
+#define ENPWRSAVE		0x8000
+#define ENPDNPS			0x0200
+#define LINKENA			0x0100
+#define DIS_SDSAVE		0x0010
+
+/* OCP_PHY_STATUS */
+#define PHY_STAT_MASK		0x0007
+#define PHY_STAT_EXT_INIT	2
+#define PHY_STAT_LAN_ON		3
+#define PHY_STAT_PWRDN		5
+
+/* OCP_NCTL_CFG */
+#define PGA_RETURN_EN		BIT(1)
+
+/* OCP_POWER_CFG */
+#define EEE_CLKDIV_EN		0x8000
+#define EN_ALDPS		0x0004
+#define EN_10M_PLLOFF		0x0001
+
+/* OCP_EEE_CONFIG1 */
+#define RG_TXLPI_MSK_HFDUP	0x8000
+#define RG_MATCLR_EN		0x4000
+#define EEE_10_CAP		0x2000
+#define EEE_NWAY_EN		0x1000
+#define TX_QUIET_EN		0x0200
+#define RX_QUIET_EN		0x0100
+#define sd_rise_time_mask	0x0070
+#define sd_rise_time(x)		(min(x, 7) << 4)	/* bit 4 ~ 6 */
+#define RG_RXLPI_MSK_HFDUP	0x0008
+#define SDFALLTIME		0x0007	/* bit 0 ~ 2 */
+
+/* OCP_EEE_CONFIG2 */
+#define RG_LPIHYS_NUM		0x7000	/* bit 12 ~ 15 */
+#define RG_DACQUIET_EN		0x0400
+#define RG_LDVQUIET_EN		0x0200
+#define RG_CKRSEL		0x0020
+#define RG_EEEPRG_EN		0x0010
+
+/* OCP_EEE_CONFIG3 */
+#define fast_snr_mask		0xff80
+#define fast_snr(x)		(min(x, 0x1ff) << 7)	/* bit 7 ~ 15 */
+#define RG_LFS_SEL		0x0060	/* bit 6 ~ 5 */
+#define MSK_PH			0x0006	/* bit 0 ~ 3 */
+
+/* OCP_EEE_AR */
+/* bit[15:14] function */
+#define FUN_ADDR		0x0000
+#define FUN_DATA		0x4000
+/* bit[4:0] device addr */
+
+/* OCP_EEE_CFG */
+#define CTAP_SHORT_EN		0x0040
+#define EEE10_EN		0x0010
+
+/* OCP_DOWN_SPEED */
+#define EN_EEE_CMODE		BIT(14)
+#define EN_EEE_1000		BIT(13)
+#define EN_EEE_100		BIT(12)
+#define EN_10M_CLKDIV		BIT(11)
+#define EN_10M_BGOFF		0x0080
+
+/* OCP_10GBT_CTRL */
+#define RTL_ADV2_5G_F_R		BIT(5)	/* Advertise 2.5GBASE-T fast-retrain */
+
+/* OCP_PHY_STATE */
+#define TXDIS_STATE		0x01
+#define ABD_STATE		0x02
+
+/* OCP_PHY_PATCH_STAT */
+#define PATCH_READY		BIT(6)
+
+/* OCP_PHY_PATCH_CMD */
+#define PATCH_REQUEST		BIT(4)
+
+/* OCP_PHY_LOCK */
+#define PATCH_LOCK		BIT(0)
+
+/* OCP_ADC_CFG */
+#define CKADSEL_L		0x0100
+#define ADC_EN			0x0080
+#define EN_EMI_L		0x0040
+
+/* OCP_SYSCLK_CFG */
+#define sysclk_div_expo(x)	(min(x, 5) << 8)
+#define clk_div_expo(x)		(min(x, 5) << 4)
+
+/* SRAM_GREEN_CFG */
+#define GREEN_ETH_EN		BIT(15)
+#define R_TUNE_EN		BIT(11)
+
+/* SRAM_LPF_CFG */
+#define LPF_AUTO_TUNE		0x8000
+
+/* SRAM_10M_AMP1 */
+#define GDAC_IB_UPALL		0x0008
+
+/* SRAM_10M_AMP2 */
+#define AMP_DN			0x0200
+
+/* SRAM_IMPEDANCE */
+#define RX_DRIVING_MASK		0x6000
+
+/* SRAM_PHY_LOCK */
+#define PHY_PATCH_LOCK		0x0001
+
+#define RTL8152_MAX_TX		4
+#define RTL8152_MAX_RX		10
+
+struct r8152;
+
+struct rx_agg {
+	struct list_head list, info_list;
+	struct urb *urb;
+	struct r8152 *context;
+	struct page *page;
+	void *buffer;
+};
+
+struct tx_agg {
+	struct list_head list;
+	struct urb *urb;
+	struct r8152 *context;
+	void *buffer;
+	void *head;
+	u32 skb_num;
+	u32 skb_len;
+};
+
+struct r8152 {
+	unsigned long flags;
+	struct usb_device *udev;
+	struct napi_struct napi;
+	struct usb_interface *intf;
+	struct net_device *netdev;
+	struct urb *intr_urb;
+	struct tx_agg tx_info[RTL8152_MAX_TX];
+	struct list_head rx_info, rx_used;
+	struct list_head rx_done, tx_free;
+	struct sk_buff_head tx_queue, rx_queue;
+	spinlock_t rx_lock, tx_lock;
+	struct delayed_work schedule, hw_phy_work;
+	struct mii_if_info mii;
+	struct mutex control;	/* use for hw setting */
+#ifdef CONFIG_PM_SLEEP
+	struct notifier_block pm_notifier;
+#endif
+	struct tasklet_struct tx_tl;
+
+	struct rtl_ops {
+		void (*init)(struct r8152 *tp);
+		int (*enable)(struct r8152 *tp);
+		void (*disable)(struct r8152 *tp);
+		void (*up)(struct r8152 *tp);
+		void (*down)(struct r8152 *tp);
+		void (*unload)(struct r8152 *tp);
+		int (*eee_get)(struct r8152 *tp, struct ethtool_eee *eee);
+		int (*eee_set)(struct r8152 *tp, struct ethtool_eee *eee);
+		bool (*in_nway)(struct r8152 *tp);
+		void (*hw_phy_cfg)(struct r8152 *tp);
+		void (*autosuspend_en)(struct r8152 *tp, bool enable);
+		void (*change_mtu)(struct r8152 *tp);
+	} rtl_ops;
+
+	struct ups_info {
+		u32 r_tune:1;
+		u32 _10m_ckdiv:1;
+		u32 _250m_ckdiv:1;
+		u32 aldps:1;
+		u32 lite_mode:2;
+		u32 speed_duplex:4;
+		u32 eee:1;
+		u32 eee_lite:1;
+		u32 eee_ckdiv:1;
+		u32 eee_plloff_100:1;
+		u32 eee_plloff_giga:1;
+		u32 eee_cmod_lv:1;
+		u32 green:1;
+		u32 flow_control:1;
+		u32 ctap_short_off:1;
+	} ups_info;
+
+#define RTL_VER_SIZE		32
+
+	struct rtl_fw {
+		const char *fw_name;
+		const struct firmware *fw;
+
+		char version[RTL_VER_SIZE];
+		int (*pre_fw)(struct r8152 *tp);
+		int (*post_fw)(struct r8152 *tp);
+
+		bool retry;
+	} rtl_fw;
+
+	atomic_t rx_count;
+
+	bool eee_en;
+	int intr_interval;
+	u32 saved_wolopts;
+	u32 msg_enable;
+	u32 tx_qlen;
+	u32 coalesce;
+	u32 advertising;
+	u32 rx_buf_sz;
+	u32 rx_copybreak;
+	u32 rx_pending;
+	u32 fc_pause_on, fc_pause_off;
+
+	unsigned int pipe_in, pipe_out, pipe_intr, pipe_ctrl_in, pipe_ctrl_out;
+
+	u32 support_2500full:1;
+	u32 lenovo_macpassthru:1;
+	u32 dell_tb_rx_agg_bug:1;
+	u16 ocp_base;
+	u16 speed;
+	u16 eee_adv;
+	u8 *intr_buff;
+	u8 version;
+	u8 duplex;
+	u8 autoneg;
+};
+
+enum rtl_version {
+	RTL_VER_UNKNOWN = 0,
+	RTL_VER_01,
+	RTL_VER_02,
+	RTL_VER_03,
+	RTL_VER_04,
+	RTL_VER_05,
+	RTL_VER_06,
+	RTL_VER_07,
+	RTL_VER_08,
+	RTL_VER_09,
+
+	RTL_TEST_01,
+	RTL_VER_10,
+	RTL_VER_11,
+	RTL_VER_12,
+	RTL_VER_13,
+	RTL_VER_14,
+	RTL_VER_15,
+
+	RTL_VER_MAX
+};
+
+#define FIRMWARE_8153A_2	"rtl_nic/rtl8153a-2.fw"
+#define FIRMWARE_8153A_3	"rtl_nic/rtl8153a-3.fw"
+#define FIRMWARE_8153A_4	"rtl_nic/rtl8153a-4.fw"
+#define FIRMWARE_8153B_2	"rtl_nic/rtl8153b-2.fw"
+#define FIRMWARE_8153C_1	"rtl_nic/rtl8153c-1.fw"
+#define FIRMWARE_8156A_2	"rtl_nic/rtl8156a-2.fw"
+#define FIRMWARE_8156B_2	"rtl_nic/rtl8156b-2.fw"
+
+int generic_ocp_read(struct r8152 *tp, u16 index, u16 size, void *data, u16 type);
+int generic_ocp_write(struct r8152 *tp, u16 index, u16 byteen, u16 size, void *data, u16 type);
+u32 ocp_read_dword(struct r8152 *tp, u16 type, u16 index);
+u16 ocp_read_word(struct r8152 *tp, u16 type, u16 index);
+u8 ocp_read_byte(struct r8152 *tp, u16 type, u16 index);
+void ocp_write_dword(struct r8152 *tp, u16 type, u16 index, u32 data);
+void ocp_write_word(struct r8152 *tp, u16 type, u16 index, u32 data);
+void ocp_write_byte(struct r8152 *tp, u16 type, u16 index, u32 data);
+
+u16 ocp_reg_read(struct r8152 *tp, u16 addr);
+void ocp_reg_write(struct r8152 *tp, u16 addr, u16 data);
+void sram_write(struct r8152 *tp, u16 addr, u16 data);
+u16 sram_read(struct r8152 *tp, u16 addr);
+
+int rtl_phy_patch_request(struct r8152 *tp, bool request, bool wait);
+
+void rtl8152_apply_firmware(struct r8152 *tp, bool power_cut);
+void rtl8152_release_firmware(struct r8152 *tp);
+int rtl8152_request_firmware(struct r8152 *tp);
+int rtl_fw_init(struct r8152 *tp);
+
+#endif /* LINUX_R8152_BASIC_H */
diff --git a/drivers/net/usb/realtek/r8152_fw.c b/drivers/net/usb/realtek/r8152_fw.c
new file mode 100644
index 000000000000..1c368e3a0bc8
--- /dev/null
+++ b/drivers/net/usb/realtek/r8152_fw.c
@@ -0,0 +1,1557 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ *  Copyright (c) 2021 Realtek Semiconductor Corp. All rights reserved.
+ */
+
+#include <linux/netdevice.h>
+#include <linux/usb.h>
+#include <linux/mii.h>
+#include <linux/ethtool.h>
+#include <linux/firmware.h>
+#include <linux/usb/r8152.h>
+#include <crypto/hash.h>
+#include "r8152_basic.h"
+
+/**
+ * struct fw_block - block type and total length
+ * @type: type of the current block, such as RTL_FW_END, RTL_FW_PLA,
+ *	RTL_FW_USB and so on.
+ * @length: total length of the current block.
+ */
+struct fw_block {
+	__le32 type;
+	__le32 length;
+} __packed;
+
+/**
+ * struct fw_header - header of the firmware file
+ * @checksum: checksum of sha256 which is calculated from the whole file
+ *	except the checksum field of the file. That is, calculate sha256
+ *	from the version field to the end of the file.
+ * @version: version of this firmware.
+ * @blocks: the first firmware block of the file
+ */
+struct fw_header {
+	u8 checksum[32];
+	char version[RTL_VER_SIZE];
+	struct fw_block blocks[];
+} __packed;
+
+enum rtl8152_fw_flags {
+	FW_FLAGS_USB = 0,
+	FW_FLAGS_PLA,
+	FW_FLAGS_START,
+	FW_FLAGS_STOP,
+	FW_FLAGS_NC,
+	FW_FLAGS_NC1,
+	FW_FLAGS_NC2,
+	FW_FLAGS_UC2,
+	FW_FLAGS_UC,
+	FW_FLAGS_SPEED_UP,
+	FW_FLAGS_VER,
+};
+
+enum rtl8152_fw_fixup_cmd {
+	FW_FIXUP_AND = 0,
+	FW_FIXUP_OR,
+	FW_FIXUP_NOT,
+	FW_FIXUP_XOR,
+};
+
+struct fw_phy_set {
+	__le16 addr;
+	__le16 data;
+} __packed;
+
+struct fw_phy_speed_up {
+	struct fw_block blk_hdr;
+	__le16 fw_offset;
+	__le16 version;
+	__le16 fw_reg;
+	__le16 reserved;
+	char info[];
+} __packed;
+
+struct fw_phy_ver {
+	struct fw_block blk_hdr;
+	struct fw_phy_set ver;
+	__le32 reserved;
+} __packed;
+
+struct fw_phy_fixup {
+	struct fw_block blk_hdr;
+	struct fw_phy_set setting;
+	__le16 bit_cmd;
+	__le16 reserved;
+} __packed;
+
+struct fw_phy_union {
+	struct fw_block blk_hdr;
+	__le16 fw_offset;
+	__le16 fw_reg;
+	struct fw_phy_set pre_set[2];
+	struct fw_phy_set bp[8];
+	struct fw_phy_set bp_en;
+	u8 pre_num;
+	u8 bp_num;
+	char info[];
+} __packed;
+
+/**
+ * struct fw_mac - a firmware block used by RTL_FW_PLA and RTL_FW_USB.
+ *	The layout of the firmware block is:
+ *	<struct fw_mac> + <info> + <firmware data>.
+ * @blk_hdr: firmware descriptor (type, length)
+ * @fw_offset: offset of the firmware binary data. The start address of
+ *	the data would be the address of struct fw_mac + @fw_offset.
+ * @fw_reg: the register to load the firmware. Depends on chip.
+ * @bp_ba_addr: the register to write break point base address. Depends on
+ *	chip.
+ * @bp_ba_value: break point base address. Depends on chip.
+ * @bp_en_addr: the register to write break point enabled mask. Depends
+ *	on chip.
+ * @bp_en_value: break point enabled mask. Depends on the firmware.
+ * @bp_start: the start register of break points. Depends on chip.
+ * @bp_num: the break point number which needs to be set for this firmware.
+ *	Depends on the firmware.
+ * @bp: break points. Depends on firmware.
+ * @reserved: reserved space (unused)
+ * @fw_ver_reg: the register to store the fw version.
+ * @fw_ver_data: the firmware version of the current type.
+ * @info: additional information for debugging, and is followed by the
+ *	binary data of firmware.
+ */
+struct fw_mac {
+	struct fw_block blk_hdr;
+	__le16 fw_offset;
+	__le16 fw_reg;
+	__le16 bp_ba_addr;
+	__le16 bp_ba_value;
+	__le16 bp_en_addr;
+	__le16 bp_en_value;
+	__le16 bp_start;
+	__le16 bp_num;
+	__le16 bp[16]; /* any value determined by firmware */
+	__le32 reserved;
+	__le16 fw_ver_reg;
+	u8 fw_ver_data;
+	char info[];
+} __packed;
+
+/**
+ * struct fw_phy_patch_key - a firmware block used by RTL_FW_PHY_START.
+ *	This is used to set patch key when loading the firmware of PHY.
+ * @blk_hdr: firmware descriptor (type, length)
+ * @key_reg: the register to write the patch key.
+ * @key_data: patch key.
+ * @reserved: reserved space (unused)
+ */
+struct fw_phy_patch_key {
+	struct fw_block blk_hdr;
+	__le16 key_reg;
+	__le16 key_data;
+	__le32 reserved;
+} __packed;
+
+/**
+ * struct fw_phy_nc - a firmware block used by RTL_FW_PHY_NC.
+ *	The layout of the firmware block is:
+ *	<struct fw_phy_nc> + <info> + <firmware data>.
+ * @blk_hdr: firmware descriptor (type, length)
+ * @fw_offset: offset of the firmware binary data. The start address of
+ *	the data would be the address of struct fw_phy_nc + @fw_offset.
+ * @fw_reg: the register to load the firmware. Depends on chip.
+ * @ba_reg: the register to write the base address. Depends on chip.
+ * @ba_data: base address. Depends on chip.
+ * @patch_en_addr: the register of enabling patch mode. Depends on chip.
+ * @patch_en_value: patch mode enabled mask. Depends on the firmware.
+ * @mode_reg: the regitster of switching the mode.
+ * @mode_pre: the mode needing to be set before loading the firmware.
+ * @mode_post: the mode to be set when finishing to load the firmware.
+ * @reserved: reserved space (unused)
+ * @bp_start: the start register of break points. Depends on chip.
+ * @bp_num: the break point number which needs to be set for this firmware.
+ *	Depends on the firmware.
+ * @bp: break points. Depends on firmware.
+ * @info: additional information for debugging, and is followed by the
+ *	binary data of firmware.
+ */
+struct fw_phy_nc {
+	struct fw_block blk_hdr;
+	__le16 fw_offset;
+	__le16 fw_reg;
+	__le16 ba_reg;
+	__le16 ba_data;
+	__le16 patch_en_addr;
+	__le16 patch_en_value;
+	__le16 mode_reg;
+	__le16 mode_pre;
+	__le16 mode_post;
+	__le16 reserved;
+	__le16 bp_start;
+	__le16 bp_num;
+	__le16 bp[4];
+	char info[];
+} __packed;
+
+enum rtl_fw_type {
+	RTL_FW_END = 0,
+	RTL_FW_PLA,
+	RTL_FW_USB,
+	RTL_FW_PHY_START,
+	RTL_FW_PHY_STOP,
+	RTL_FW_PHY_NC,
+	RTL_FW_PHY_FIXUP,
+	RTL_FW_PHY_UNION_NC,
+	RTL_FW_PHY_UNION_NC1,
+	RTL_FW_PHY_UNION_NC2,
+	RTL_FW_PHY_UNION_UC2,
+	RTL_FW_PHY_UNION_UC,
+	RTL_FW_PHY_UNION_MISC,
+	RTL_FW_PHY_SPEED_UP,
+	RTL_FW_PHY_VER,
+};
+
+static void rtl_patch_key_set(struct r8152 *tp, u16 key_addr, u16 patch_key)
+{
+	if (patch_key && key_addr) {
+		sram_write(tp, key_addr, patch_key);
+		sram_write(tp, SRAM_PHY_LOCK, PHY_PATCH_LOCK);
+	} else if (key_addr) {
+		u16 data;
+
+		sram_write(tp, 0x0000, 0x0000);
+
+		data = ocp_reg_read(tp, OCP_PHY_LOCK);
+		data &= ~PATCH_LOCK;
+		ocp_reg_write(tp, OCP_PHY_LOCK, data);
+
+		sram_write(tp, key_addr, 0x0000);
+	} else {
+		WARN_ON_ONCE(1);
+	}
+}
+
+static int rtl_pre_ram_code(struct r8152 *tp, u16 key_addr, u16 patch_key, bool wait)
+{
+	if (rtl_phy_patch_request(tp, true, wait))
+		return -ETIME;
+
+	rtl_patch_key_set(tp, key_addr, patch_key);
+
+	return 0;
+}
+
+static int rtl_post_ram_code(struct r8152 *tp, u16 key_addr, bool wait)
+{
+	rtl_patch_key_set(tp, key_addr, 0);
+
+	rtl_phy_patch_request(tp, false, wait);
+
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
+
+	return 0;
+}
+
+/* Clear the bp to stop the firmware before loading a new one */
+static void rtl_clear_bp(struct r8152 *tp, u16 type)
+{
+	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_07:
+		break;
+	case RTL_VER_03:
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+		ocp_write_byte(tp, type, PLA_BP_EN, 0);
+		break;
+	case RTL_VER_08:
+	case RTL_VER_09:
+	case RTL_VER_10:
+	case RTL_VER_11:
+	case RTL_VER_12:
+	case RTL_VER_13:
+	case RTL_VER_14:
+	case RTL_VER_15:
+	default:
+		if (type == MCU_TYPE_USB) {
+			ocp_write_byte(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
+
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0);
+		} else {
+			ocp_write_byte(tp, MCU_TYPE_PLA, PLA_BP_EN, 0);
+		}
+		break;
+	}
+
+	ocp_write_word(tp, type, PLA_BP_0, 0);
+	ocp_write_word(tp, type, PLA_BP_1, 0);
+	ocp_write_word(tp, type, PLA_BP_2, 0);
+	ocp_write_word(tp, type, PLA_BP_3, 0);
+	ocp_write_word(tp, type, PLA_BP_4, 0);
+	ocp_write_word(tp, type, PLA_BP_5, 0);
+	ocp_write_word(tp, type, PLA_BP_6, 0);
+	ocp_write_word(tp, type, PLA_BP_7, 0);
+
+	/* wait 3 ms to make sure the firmware is stopped */
+	usleep_range(3000, 6000);
+	ocp_write_word(tp, type, PLA_BP_BA, 0);
+}
+
+static bool rtl8152_is_fw_phy_speed_up_ok(struct r8152 *tp, struct fw_phy_speed_up *phy)
+{
+	u16 fw_offset;
+	u32 length;
+	bool rc = false;
+
+	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_03:
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+	case RTL_VER_07:
+	case RTL_VER_08:
+	case RTL_VER_09:
+	case RTL_VER_10:
+	case RTL_VER_11:
+	case RTL_VER_12:
+	case RTL_VER_14:
+		goto out;
+	case RTL_VER_13:
+	case RTL_VER_15:
+	default:
+		break;
+	}
+
+	fw_offset = __le16_to_cpu(phy->fw_offset);
+	length = __le32_to_cpu(phy->blk_hdr.length);
+	if (fw_offset < sizeof(*phy) || length <= fw_offset) {
+		dev_err(&tp->intf->dev, "invalid fw_offset\n");
+		goto out;
+	}
+
+	length -= fw_offset;
+	if (length & 3) {
+		dev_err(&tp->intf->dev, "invalid block length\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->fw_reg) != 0x9A00) {
+		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
+		goto out;
+	}
+
+	rc = true;
+out:
+	return rc;
+}
+
+static bool rtl8152_is_fw_phy_ver_ok(struct r8152 *tp, struct fw_phy_ver *ver)
+{
+	bool rc = false;
+
+	switch (tp->version) {
+	case RTL_VER_10:
+	case RTL_VER_11:
+	case RTL_VER_12:
+	case RTL_VER_13:
+	case RTL_VER_15:
+		break;
+	default:
+		goto out;
+	}
+
+	if (__le32_to_cpu(ver->blk_hdr.length) != sizeof(*ver)) {
+		dev_err(&tp->intf->dev, "invalid block length\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(ver->ver.addr) != SRAM_GPHY_FW_VER) {
+		dev_err(&tp->intf->dev, "invalid phy ver addr\n");
+		goto out;
+	}
+
+	rc = true;
+out:
+	return rc;
+}
+
+static bool rtl8152_is_fw_phy_fixup_ok(struct r8152 *tp, struct fw_phy_fixup *fix)
+{
+	bool rc = false;
+
+	switch (tp->version) {
+	case RTL_VER_10:
+	case RTL_VER_11:
+	case RTL_VER_12:
+	case RTL_VER_13:
+	case RTL_VER_15:
+		break;
+	default:
+		goto out;
+	}
+
+	if (__le32_to_cpu(fix->blk_hdr.length) != sizeof(*fix)) {
+		dev_err(&tp->intf->dev, "invalid block length\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(fix->setting.addr) != OCP_PHY_PATCH_CMD ||
+	    __le16_to_cpu(fix->setting.data) != BIT(7)) {
+		dev_err(&tp->intf->dev, "invalid phy fixup\n");
+		goto out;
+	}
+
+	rc = true;
+out:
+	return rc;
+}
+
+static bool rtl8152_is_fw_phy_union_ok(struct r8152 *tp, struct fw_phy_union *phy)
+{
+	u16 fw_offset;
+	u32 length;
+	bool rc = false;
+
+	switch (tp->version) {
+	case RTL_VER_10:
+	case RTL_VER_11:
+	case RTL_VER_12:
+	case RTL_VER_13:
+	case RTL_VER_15:
+		break;
+	default:
+		goto out;
+	}
+
+	fw_offset = __le16_to_cpu(phy->fw_offset);
+	length = __le32_to_cpu(phy->blk_hdr.length);
+	if (fw_offset < sizeof(*phy) || length <= fw_offset) {
+		dev_err(&tp->intf->dev, "invalid fw_offset\n");
+		goto out;
+	}
+
+	length -= fw_offset;
+	if (length & 1) {
+		dev_err(&tp->intf->dev, "invalid block length\n");
+		goto out;
+	}
+
+	if (phy->pre_num > 2) {
+		dev_err(&tp->intf->dev, "invalid pre_num %d\n", phy->pre_num);
+		goto out;
+	}
+
+	if (phy->bp_num > 8) {
+		dev_err(&tp->intf->dev, "invalid bp_num %d\n", phy->bp_num);
+		goto out;
+	}
+
+	rc = true;
+out:
+	return rc;
+}
+
+static bool rtl8152_is_fw_phy_nc_ok(struct r8152 *tp, struct fw_phy_nc *phy)
+{
+	u32 length;
+	u16 fw_offset, fw_reg, ba_reg, patch_en_addr, mode_reg, bp_start;
+	bool rc = false;
+
+	switch (tp->version) {
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+		fw_reg = 0xa014;
+		ba_reg = 0xa012;
+		patch_en_addr = 0xa01a;
+		mode_reg = 0xb820;
+		bp_start = 0xa000;
+		break;
+	default:
+		goto out;
+	}
+
+	fw_offset = __le16_to_cpu(phy->fw_offset);
+	if (fw_offset < sizeof(*phy)) {
+		dev_err(&tp->intf->dev, "fw_offset too small\n");
+		goto out;
+	}
+
+	length = __le32_to_cpu(phy->blk_hdr.length);
+	if (length < fw_offset) {
+		dev_err(&tp->intf->dev, "invalid fw_offset\n");
+		goto out;
+	}
+
+	length -= __le16_to_cpu(phy->fw_offset);
+	if (!length || (length & 1)) {
+		dev_err(&tp->intf->dev, "invalid block length\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->fw_reg) != fw_reg) {
+		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->ba_reg) != ba_reg) {
+		dev_err(&tp->intf->dev, "invalid base address register\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->patch_en_addr) != patch_en_addr) {
+		dev_err(&tp->intf->dev,
+			"invalid patch mode enabled register\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->mode_reg) != mode_reg) {
+		dev_err(&tp->intf->dev,
+			"invalid register to switch the mode\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->bp_start) != bp_start) {
+		dev_err(&tp->intf->dev,
+			"invalid start register of break point\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(phy->bp_num) > 4) {
+		dev_err(&tp->intf->dev, "invalid break point number\n");
+		goto out;
+	}
+
+	rc = true;
+out:
+	return rc;
+}
+
+static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
+{
+	u16 fw_reg, bp_ba_addr, bp_en_addr, bp_start, fw_offset;
+	bool rc = false;
+	u32 length, type;
+	int i, max_bp;
+
+	type = __le32_to_cpu(mac->blk_hdr.type);
+	if (type == RTL_FW_PLA) {
+		switch (tp->version) {
+		case RTL_VER_01:
+		case RTL_VER_02:
+		case RTL_VER_07:
+			fw_reg = 0xf800;
+			bp_ba_addr = PLA_BP_BA;
+			bp_en_addr = 0;
+			bp_start = PLA_BP_0;
+			max_bp = 8;
+			break;
+		case RTL_VER_03:
+		case RTL_VER_04:
+		case RTL_VER_05:
+		case RTL_VER_06:
+		case RTL_VER_08:
+		case RTL_VER_09:
+		case RTL_VER_11:
+		case RTL_VER_12:
+		case RTL_VER_13:
+		case RTL_VER_14:
+		case RTL_VER_15:
+			fw_reg = 0xf800;
+			bp_ba_addr = PLA_BP_BA;
+			bp_en_addr = PLA_BP_EN;
+			bp_start = PLA_BP_0;
+			max_bp = 8;
+			break;
+		default:
+			goto out;
+		}
+	} else if (type == RTL_FW_USB) {
+		switch (tp->version) {
+		case RTL_VER_03:
+		case RTL_VER_04:
+		case RTL_VER_05:
+		case RTL_VER_06:
+			fw_reg = 0xf800;
+			bp_ba_addr = USB_BP_BA;
+			bp_en_addr = USB_BP_EN;
+			bp_start = USB_BP_0;
+			max_bp = 8;
+			break;
+		case RTL_VER_08:
+		case RTL_VER_09:
+		case RTL_VER_11:
+		case RTL_VER_12:
+		case RTL_VER_13:
+		case RTL_VER_14:
+		case RTL_VER_15:
+			fw_reg = 0xe600;
+			bp_ba_addr = USB_BP_BA;
+			bp_en_addr = USB_BP2_EN;
+			bp_start = USB_BP_0;
+			max_bp = 16;
+			break;
+		case RTL_VER_01:
+		case RTL_VER_02:
+		case RTL_VER_07:
+		default:
+			goto out;
+		}
+	} else {
+		goto out;
+	}
+
+	fw_offset = __le16_to_cpu(mac->fw_offset);
+	if (fw_offset < sizeof(*mac)) {
+		dev_err(&tp->intf->dev, "fw_offset too small\n");
+		goto out;
+	}
+
+	length = __le32_to_cpu(mac->blk_hdr.length);
+	if (length < fw_offset) {
+		dev_err(&tp->intf->dev, "invalid fw_offset\n");
+		goto out;
+	}
+
+	length -= fw_offset;
+	if (length < 4 || (length & 3)) {
+		dev_err(&tp->intf->dev, "invalid block length\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(mac->fw_reg) != fw_reg) {
+		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(mac->bp_ba_addr) != bp_ba_addr) {
+		dev_err(&tp->intf->dev, "invalid base address register\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(mac->bp_en_addr) != bp_en_addr) {
+		dev_err(&tp->intf->dev, "invalid enabled mask register\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(mac->bp_start) != bp_start) {
+		dev_err(&tp->intf->dev,
+			"invalid start register of break point\n");
+		goto out;
+	}
+
+	if (__le16_to_cpu(mac->bp_num) > max_bp) {
+		dev_err(&tp->intf->dev, "invalid break point number\n");
+		goto out;
+	}
+
+	for (i = __le16_to_cpu(mac->bp_num); i < max_bp; i++) {
+		if (mac->bp[i]) {
+			dev_err(&tp->intf->dev, "unused bp%u is not zero\n", i);
+			goto out;
+		}
+	}
+
+	rc = true;
+out:
+	return rc;
+}
+
+/* Verify the checksum for the firmware file. It is calculated from the version
+ * field to the end of the file. Compare the result with the checksum field to
+ * make sure the file is correct.
+ */
+static long rtl8152_fw_verify_checksum(struct r8152 *tp,
+				       struct fw_header *fw_hdr, size_t size)
+{
+	unsigned char checksum[sizeof(fw_hdr->checksum)];
+	struct crypto_shash *alg;
+	struct shash_desc *sdesc;
+	size_t len;
+	long rc;
+
+	alg = crypto_alloc_shash("sha256", 0, 0);
+	if (IS_ERR(alg)) {
+		rc = PTR_ERR(alg);
+		goto out;
+	}
+
+	if (crypto_shash_digestsize(alg) != sizeof(fw_hdr->checksum)) {
+		rc = -EFAULT;
+		dev_err(&tp->intf->dev, "digestsize incorrect (%u)\n",
+			crypto_shash_digestsize(alg));
+		goto free_shash;
+	}
+
+	len = sizeof(*sdesc) + crypto_shash_descsize(alg);
+	sdesc = kmalloc(len, GFP_KERNEL);
+	if (!sdesc) {
+		rc = -ENOMEM;
+		goto free_shash;
+	}
+	sdesc->tfm = alg;
+
+	len = size - sizeof(fw_hdr->checksum);
+	rc = crypto_shash_digest(sdesc, fw_hdr->version, len, checksum);
+	kfree(sdesc);
+	if (rc)
+		goto free_shash;
+
+	if (memcmp(fw_hdr->checksum, checksum, sizeof(fw_hdr->checksum))) {
+		dev_err(&tp->intf->dev, "checksum fail\n");
+		rc = -EFAULT;
+	}
+
+free_shash:
+	crypto_free_shash(alg);
+out:
+	return rc;
+}
+
+static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
+{
+	const struct firmware *fw = rtl_fw->fw;
+	struct fw_header *fw_hdr = (struct fw_header *)fw->data;
+	unsigned long fw_flags = 0;
+	long ret = -EFAULT;
+	int i;
+
+	if (fw->size < sizeof(*fw_hdr)) {
+		dev_err(&tp->intf->dev, "file too small\n");
+		goto fail;
+	}
+
+	ret = rtl8152_fw_verify_checksum(tp, fw_hdr, fw->size);
+	if (ret)
+		goto fail;
+
+	ret = -EFAULT;
+
+	for (i = sizeof(*fw_hdr); i < fw->size;) {
+		struct fw_block *block = (struct fw_block *)&fw->data[i];
+		u32 type;
+
+		if ((i + sizeof(*block)) > fw->size)
+			goto fail;
+
+		type = __le32_to_cpu(block->type);
+		switch (type) {
+		case RTL_FW_END:
+			if (__le32_to_cpu(block->length) != sizeof(*block))
+				goto fail;
+			goto fw_end;
+		case RTL_FW_PLA:
+			if (test_bit(FW_FLAGS_PLA, &fw_flags)) {
+				dev_err(&tp->intf->dev,
+					"multiple PLA firmware encountered");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_mac_ok(tp, (struct fw_mac *)block)) {
+				dev_err(&tp->intf->dev,
+					"check PLA firmware failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_PLA, &fw_flags);
+			break;
+		case RTL_FW_USB:
+			if (test_bit(FW_FLAGS_USB, &fw_flags)) {
+				dev_err(&tp->intf->dev,
+					"multiple USB firmware encountered");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_mac_ok(tp, (struct fw_mac *)block)) {
+				dev_err(&tp->intf->dev,
+					"check USB firmware failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_USB, &fw_flags);
+			break;
+		case RTL_FW_PHY_START:
+			if (test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC1, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
+				dev_err(&tp->intf->dev,
+					"check PHY_START fail\n");
+				goto fail;
+			}
+
+			if (__le32_to_cpu(block->length) != sizeof(struct fw_phy_patch_key)) {
+				dev_err(&tp->intf->dev,
+					"Invalid length for PHY_START\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_START, &fw_flags);
+			break;
+		case RTL_FW_PHY_STOP:
+			if (test_bit(FW_FLAGS_STOP, &fw_flags) ||
+			    !test_bit(FW_FLAGS_START, &fw_flags)) {
+				dev_err(&tp->intf->dev,
+					"Check PHY_STOP fail\n");
+				goto fail;
+			}
+
+			if (__le32_to_cpu(block->length) != sizeof(*block)) {
+				dev_err(&tp->intf->dev,
+					"Invalid length for PHY_STOP\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_STOP, &fw_flags);
+			break;
+		case RTL_FW_PHY_NC:
+			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
+				dev_err(&tp->intf->dev,
+					"check PHY_NC fail\n");
+				goto fail;
+			}
+
+			if (test_bit(FW_FLAGS_NC, &fw_flags)) {
+				dev_err(&tp->intf->dev,
+					"multiple PHY NC encountered\n");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_phy_nc_ok(tp, (struct fw_phy_nc *)block)) {
+				dev_err(&tp->intf->dev,
+					"check PHY NC firmware failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_NC, &fw_flags);
+			break;
+		case RTL_FW_PHY_UNION_NC:
+			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC1, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
+				dev_err(&tp->intf->dev, "PHY_UNION_NC out of order\n");
+				goto fail;
+			}
+
+			if (test_bit(FW_FLAGS_NC, &fw_flags)) {
+				dev_err(&tp->intf->dev, "multiple PHY_UNION_NC encountered\n");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
+				dev_err(&tp->intf->dev, "check PHY_UNION_NC failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_NC, &fw_flags);
+			break;
+		case RTL_FW_PHY_UNION_NC1:
+			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
+				dev_err(&tp->intf->dev, "PHY_UNION_NC1 out of order\n");
+				goto fail;
+			}
+
+			if (test_bit(FW_FLAGS_NC1, &fw_flags)) {
+				dev_err(&tp->intf->dev, "multiple PHY NC1 encountered\n");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
+				dev_err(&tp->intf->dev, "check PHY_UNION_NC1 failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_NC1, &fw_flags);
+			break;
+		case RTL_FW_PHY_UNION_NC2:
+			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
+				dev_err(&tp->intf->dev, "PHY_UNION_NC2 out of order\n");
+				goto fail;
+			}
+
+			if (test_bit(FW_FLAGS_NC2, &fw_flags)) {
+				dev_err(&tp->intf->dev, "multiple PHY NC2 encountered\n");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
+				dev_err(&tp->intf->dev, "check PHY_UNION_NC2 failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_NC2, &fw_flags);
+			break;
+		case RTL_FW_PHY_UNION_UC2:
+			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
+				dev_err(&tp->intf->dev, "PHY_UNION_UC2 out of order\n");
+				goto fail;
+			}
+
+			if (test_bit(FW_FLAGS_UC2, &fw_flags)) {
+				dev_err(&tp->intf->dev, "multiple PHY UC2 encountered\n");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
+				dev_err(&tp->intf->dev, "check PHY_UNION_UC2 failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_UC2, &fw_flags);
+			break;
+		case RTL_FW_PHY_UNION_UC:
+			if (!test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
+				dev_err(&tp->intf->dev, "PHY_UNION_UC out of order\n");
+				goto fail;
+			}
+
+			if (test_bit(FW_FLAGS_UC, &fw_flags)) {
+				dev_err(&tp->intf->dev, "multiple PHY UC encountered\n");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
+				dev_err(&tp->intf->dev, "check PHY_UNION_UC failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_UC, &fw_flags);
+			break;
+		case RTL_FW_PHY_UNION_MISC:
+			if (!rtl8152_is_fw_phy_union_ok(tp, (struct fw_phy_union *)block)) {
+				dev_err(&tp->intf->dev, "check RTL_FW_PHY_UNION_MISC failed\n");
+				goto fail;
+			}
+			break;
+		case RTL_FW_PHY_FIXUP:
+			if (!rtl8152_is_fw_phy_fixup_ok(tp, (struct fw_phy_fixup *)block)) {
+				dev_err(&tp->intf->dev, "check PHY fixup failed\n");
+				goto fail;
+			}
+			break;
+		case RTL_FW_PHY_SPEED_UP:
+			if (test_bit(FW_FLAGS_SPEED_UP, &fw_flags)) {
+				dev_err(&tp->intf->dev, "multiple PHY firmware encountered");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_phy_speed_up_ok(tp, (struct fw_phy_speed_up *)block)) {
+				dev_err(&tp->intf->dev, "check PHY speed up failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_SPEED_UP, &fw_flags);
+			break;
+		case RTL_FW_PHY_VER:
+			if (test_bit(FW_FLAGS_START, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC1, &fw_flags) ||
+			    test_bit(FW_FLAGS_NC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC2, &fw_flags) ||
+			    test_bit(FW_FLAGS_UC, &fw_flags) ||
+			    test_bit(FW_FLAGS_STOP, &fw_flags)) {
+				dev_err(&tp->intf->dev, "Invalid order to set PHY version\n");
+				goto fail;
+			}
+
+			if (test_bit(FW_FLAGS_VER, &fw_flags)) {
+				dev_err(&tp->intf->dev, "multiple PHY version encountered");
+				goto fail;
+			}
+
+			if (!rtl8152_is_fw_phy_ver_ok(tp, (struct fw_phy_ver *)block)) {
+				dev_err(&tp->intf->dev, "check PHY version failed\n");
+				goto fail;
+			}
+			__set_bit(FW_FLAGS_VER, &fw_flags);
+			break;
+		default:
+			dev_warn(&tp->intf->dev, "Unknown type %u is found\n",
+				 type);
+			break;
+		}
+
+		/* next block */
+		i += ALIGN(__le32_to_cpu(block->length), 8);
+	}
+
+fw_end:
+	if (test_bit(FW_FLAGS_START, &fw_flags) && !test_bit(FW_FLAGS_STOP, &fw_flags)) {
+		dev_err(&tp->intf->dev, "without PHY_STOP\n");
+		goto fail;
+	}
+
+	return 0;
+fail:
+	return ret;
+}
+
+static void rtl_ram_code_speed_up(struct r8152 *tp, struct fw_phy_speed_up *phy, bool wait)
+{
+	u32 len;
+	u8 *data;
+
+	if (sram_read(tp, SRAM_GPHY_FW_VER) >= __le16_to_cpu(phy->version)) {
+		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
+		return;
+	}
+
+	len = __le32_to_cpu(phy->blk_hdr.length);
+	len -= __le16_to_cpu(phy->fw_offset);
+	data = (u8 *)phy + __le16_to_cpu(phy->fw_offset);
+
+	if (rtl_phy_patch_request(tp, true, wait))
+		return;
+
+	while (len) {
+		u32 ocp_data, size;
+		int i;
+
+		if (len < 2048)
+			size = len;
+		else
+			size = 2048;
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL);
+		ocp_data |= GPHY_PATCH_DONE | BACKUP_RESTRORE;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL, ocp_data);
+
+		generic_ocp_write(tp, __le16_to_cpu(phy->fw_reg), 0xff, size, data, MCU_TYPE_USB);
+
+		data += size;
+		len -= size;
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL);
+		ocp_data |= POL_GPHY_PATCH;
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL, ocp_data);
+
+		for (i = 0; i < 1000; i++) {
+			if (!(ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL) & POL_GPHY_PATCH))
+				break;
+		}
+
+		if (i == 1000) {
+			dev_err(&tp->intf->dev, "ram code speedup mode timeout\n");
+			break;
+		}
+	}
+
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
+	rtl_phy_patch_request(tp, false, wait);
+
+	if (sram_read(tp, SRAM_GPHY_FW_VER) == __le16_to_cpu(phy->version))
+		dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
+	else
+		dev_err(&tp->intf->dev, "ram code speedup mode fail\n");
+}
+
+static int rtl8152_fw_phy_ver(struct r8152 *tp, struct fw_phy_ver *phy_ver)
+{
+	u16 ver_addr, ver;
+
+	ver_addr = __le16_to_cpu(phy_ver->ver.addr);
+	ver = __le16_to_cpu(phy_ver->ver.data);
+
+	if (sram_read(tp, ver_addr) >= ver) {
+		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
+		return 0;
+	}
+
+	sram_write(tp, ver_addr, ver);
+
+	dev_dbg(&tp->intf->dev, "PHY firmware version %x\n", ver);
+
+	return ver;
+}
+
+static void rtl8152_fw_phy_fixup(struct r8152 *tp, struct fw_phy_fixup *fix)
+{
+	u16 addr, data;
+
+	addr = __le16_to_cpu(fix->setting.addr);
+	data = ocp_reg_read(tp, addr);
+
+	switch (__le16_to_cpu(fix->bit_cmd)) {
+	case FW_FIXUP_AND:
+		data &= __le16_to_cpu(fix->setting.data);
+		break;
+	case FW_FIXUP_OR:
+		data |= __le16_to_cpu(fix->setting.data);
+		break;
+	case FW_FIXUP_NOT:
+		data &= ~__le16_to_cpu(fix->setting.data);
+		break;
+	case FW_FIXUP_XOR:
+		data ^= __le16_to_cpu(fix->setting.data);
+		break;
+	default:
+		return;
+	}
+
+	ocp_reg_write(tp, addr, data);
+
+	dev_dbg(&tp->intf->dev, "applied ocp %x %x\n", addr, data);
+}
+
+static void rtl8152_fw_phy_union_apply(struct r8152 *tp, struct fw_phy_union *phy)
+{
+	__le16 *data;
+	u32 length;
+	int i, num;
+
+	num = phy->pre_num;
+	for (i = 0; i < num; i++)
+		sram_write(tp, __le16_to_cpu(phy->pre_set[i].addr),
+			   __le16_to_cpu(phy->pre_set[i].data));
+
+	length = __le32_to_cpu(phy->blk_hdr.length);
+	length -= __le16_to_cpu(phy->fw_offset);
+	num = length / 2;
+	data = (__le16 *)((u8 *)phy + __le16_to_cpu(phy->fw_offset));
+
+	ocp_reg_write(tp, OCP_SRAM_ADDR, __le16_to_cpu(phy->fw_reg));
+	for (i = 0; i < num; i++)
+		ocp_reg_write(tp, OCP_SRAM_DATA, __le16_to_cpu(data[i]));
+
+	num = phy->bp_num;
+	for (i = 0; i < num; i++)
+		sram_write(tp, __le16_to_cpu(phy->bp[i].addr), __le16_to_cpu(phy->bp[i].data));
+
+	if (phy->bp_num && phy->bp_en.addr)
+		sram_write(tp, __le16_to_cpu(phy->bp_en.addr), __le16_to_cpu(phy->bp_en.data));
+
+	dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
+}
+
+static void rtl8152_fw_phy_nc_apply(struct r8152 *tp, struct fw_phy_nc *phy)
+{
+	u16 mode_reg, bp_index;
+	u32 length, i, num;
+	__le16 *data;
+
+	mode_reg = __le16_to_cpu(phy->mode_reg);
+	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_pre));
+	sram_write(tp, __le16_to_cpu(phy->ba_reg),
+		   __le16_to_cpu(phy->ba_data));
+
+	length = __le32_to_cpu(phy->blk_hdr.length);
+	length -= __le16_to_cpu(phy->fw_offset);
+	num = length / 2;
+	data = (__le16 *)((u8 *)phy + __le16_to_cpu(phy->fw_offset));
+
+	ocp_reg_write(tp, OCP_SRAM_ADDR, __le16_to_cpu(phy->fw_reg));
+	for (i = 0; i < num; i++)
+		ocp_reg_write(tp, OCP_SRAM_DATA, __le16_to_cpu(data[i]));
+
+	sram_write(tp, __le16_to_cpu(phy->patch_en_addr),
+		   __le16_to_cpu(phy->patch_en_value));
+
+	bp_index = __le16_to_cpu(phy->bp_start);
+	num = __le16_to_cpu(phy->bp_num);
+	for (i = 0; i < num; i++) {
+		sram_write(tp, bp_index, __le16_to_cpu(phy->bp[i]));
+		bp_index += 2;
+	}
+
+	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_post));
+
+	dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
+}
+
+static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
+{
+	u16 bp_en_addr, bp_index, type, bp_num, fw_ver_reg;
+	u32 length;
+	u8 *data;
+	int i;
+
+	switch (__le32_to_cpu(mac->blk_hdr.type)) {
+	case RTL_FW_PLA:
+		type = MCU_TYPE_PLA;
+		break;
+	case RTL_FW_USB:
+		type = MCU_TYPE_USB;
+		break;
+	default:
+		return;
+	}
+
+	fw_ver_reg = __le16_to_cpu(mac->fw_ver_reg);
+	if (fw_ver_reg && ocp_read_byte(tp, MCU_TYPE_USB, fw_ver_reg) >= mac->fw_ver_data) {
+		dev_dbg(&tp->intf->dev, "%s firmware has been the newest\n", type ? "PLA" : "USB");
+		return;
+	}
+
+	rtl_clear_bp(tp, type);
+
+	/* Enable backup/restore of MACDBG. This is required after clearing PLA
+	 * break points and before applying the PLA firmware.
+	 */
+	if (tp->version == RTL_VER_04 && type == MCU_TYPE_PLA &&
+	    !(ocp_read_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST) & DEBUG_OE)) {
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_PRE, DEBUG_LTSSM);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST, DEBUG_LTSSM);
+	}
+
+	length = __le32_to_cpu(mac->blk_hdr.length);
+	length -= __le16_to_cpu(mac->fw_offset);
+
+	data = (u8 *)mac;
+	data += __le16_to_cpu(mac->fw_offset);
+
+	generic_ocp_write(tp, __le16_to_cpu(mac->fw_reg), 0xff, length, data,
+			  type);
+
+	ocp_write_word(tp, type, __le16_to_cpu(mac->bp_ba_addr),
+		       __le16_to_cpu(mac->bp_ba_value));
+
+	bp_index = __le16_to_cpu(mac->bp_start);
+	bp_num = __le16_to_cpu(mac->bp_num);
+	for (i = 0; i < bp_num; i++) {
+		ocp_write_word(tp, type, bp_index, __le16_to_cpu(mac->bp[i]));
+		bp_index += 2;
+	}
+
+	bp_en_addr = __le16_to_cpu(mac->bp_en_addr);
+	if (bp_en_addr)
+		ocp_write_word(tp, type, bp_en_addr,
+			       __le16_to_cpu(mac->bp_en_value));
+
+	if (fw_ver_reg)
+		ocp_write_byte(tp, MCU_TYPE_USB, fw_ver_reg,
+			       mac->fw_ver_data);
+
+	dev_dbg(&tp->intf->dev, "successfully applied %s\n", mac->info);
+}
+
+void rtl8152_apply_firmware(struct r8152 *tp, bool power_cut)
+{
+	struct rtl_fw *rtl_fw = &tp->rtl_fw;
+	const struct firmware *fw;
+	struct fw_header *fw_hdr;
+	struct fw_phy_patch_key *key;
+	u16 key_addr = 0;
+	int i, patch_phy = 1;
+
+	if (IS_ERR_OR_NULL(rtl_fw->fw))
+		return;
+
+	fw = rtl_fw->fw;
+	fw_hdr = (struct fw_header *)fw->data;
+
+	if (rtl_fw->pre_fw)
+		rtl_fw->pre_fw(tp);
+
+	for (i = offsetof(struct fw_header, blocks); i < fw->size;) {
+		struct fw_block *block = (struct fw_block *)&fw->data[i];
+
+		switch (__le32_to_cpu(block->type)) {
+		case RTL_FW_END:
+			goto post_fw;
+		case RTL_FW_PLA:
+		case RTL_FW_USB:
+			rtl8152_fw_mac_apply(tp, (struct fw_mac *)block);
+			break;
+		case RTL_FW_PHY_START:
+			if (!patch_phy)
+				break;
+			key = (struct fw_phy_patch_key *)block;
+			key_addr = __le16_to_cpu(key->key_reg);
+			rtl_pre_ram_code(tp, key_addr, __le16_to_cpu(key->key_data), !power_cut);
+			break;
+		case RTL_FW_PHY_STOP:
+			if (!patch_phy)
+				break;
+			WARN_ON(!key_addr);
+			rtl_post_ram_code(tp, key_addr, !power_cut);
+			break;
+		case RTL_FW_PHY_NC:
+			rtl8152_fw_phy_nc_apply(tp, (struct fw_phy_nc *)block);
+			break;
+		case RTL_FW_PHY_VER:
+			patch_phy = rtl8152_fw_phy_ver(tp, (struct fw_phy_ver *)block);
+			break;
+		case RTL_FW_PHY_UNION_NC:
+		case RTL_FW_PHY_UNION_NC1:
+		case RTL_FW_PHY_UNION_NC2:
+		case RTL_FW_PHY_UNION_UC2:
+		case RTL_FW_PHY_UNION_UC:
+		case RTL_FW_PHY_UNION_MISC:
+			if (patch_phy)
+				rtl8152_fw_phy_union_apply(tp, (struct fw_phy_union *)block);
+			break;
+		case RTL_FW_PHY_FIXUP:
+			if (patch_phy)
+				rtl8152_fw_phy_fixup(tp, (struct fw_phy_fixup *)block);
+			break;
+		case RTL_FW_PHY_SPEED_UP:
+			rtl_ram_code_speed_up(tp, (struct fw_phy_speed_up *)block, !power_cut);
+			break;
+		default:
+			break;
+		}
+
+		i += ALIGN(__le32_to_cpu(block->length), 8);
+	}
+
+post_fw:
+	if (rtl_fw->post_fw)
+		rtl_fw->post_fw(tp);
+
+	strscpy(rtl_fw->version, fw_hdr->version, RTL_VER_SIZE);
+	dev_info(&tp->intf->dev, "load %s successfully\n", rtl_fw->version);
+}
+
+void rtl8152_release_firmware(struct r8152 *tp)
+{
+	struct rtl_fw *rtl_fw = &tp->rtl_fw;
+
+	if (!IS_ERR_OR_NULL(rtl_fw->fw)) {
+		release_firmware(rtl_fw->fw);
+		rtl_fw->fw = NULL;
+	}
+}
+
+int rtl8152_request_firmware(struct r8152 *tp)
+{
+	struct rtl_fw *rtl_fw = &tp->rtl_fw;
+	long rc;
+
+	if (rtl_fw->fw || !rtl_fw->fw_name) {
+		dev_info(&tp->intf->dev, "skip request firmware\n");
+		rc = 0;
+		goto result;
+	}
+
+	rc = request_firmware(&rtl_fw->fw, rtl_fw->fw_name, &tp->intf->dev);
+	if (rc < 0)
+		goto result;
+
+	rc = rtl8152_check_firmware(tp, rtl_fw);
+	if (rc < 0)
+		release_firmware(rtl_fw->fw);
+
+result:
+	if (rc) {
+		rtl_fw->fw = ERR_PTR(rc);
+
+		dev_warn(&tp->intf->dev,
+			 "unable to load firmware patch %s (%ld)\n",
+			 rtl_fw->fw_name, rc);
+	}
+
+	return rc;
+}
+
+static int r8153_pre_firmware_1(struct r8152 *tp)
+{
+	int i;
+
+	/* Wait till the WTD timer is ready. It would take at most 104 ms. */
+	for (i = 0; i < 104; i++) {
+		u32 ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_WDT1_CTRL);
+
+		if (!(ocp_data & WTD1_EN))
+			break;
+		usleep_range(1000, 2000);
+	}
+
+	return 0;
+}
+
+static int r8153_post_firmware_1(struct r8152 *tp)
+{
+	/* reset UPHY timer to 36 ms */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_UPHY_TIMER, 36000 / 16);
+
+	return 0;
+}
+
+static int r8153_pre_firmware_2(struct r8152 *tp)
+{
+	u32 ocp_data;
+
+	r8153_pre_firmware_1(tp);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
+	ocp_data &= ~FW_FIX_SUSPEND;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
+
+	return 0;
+}
+
+#define BP4_SUPER_ONLY		0x1578	/* RTL_VER_04 only */
+
+static int r8153_post_firmware_2(struct r8152 *tp)
+{
+	u32 ocp_data;
+
+	/* set USB_BP_4 to support USB_SPEED_SUPER only */
+	if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER)
+		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, BP4_SUPER_ONLY);
+
+	r8153_post_firmware_1(tp);
+
+	/* enable U3P3 check, set the counter to 4 */
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_EXTRA_STATUS, U3P3_CHECK_EN | 4);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
+	ocp_data |= FW_FIX_SUSPEND;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
+	ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
+	ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
+
+	return 0;
+}
+
+static int r8153_post_firmware_3(struct r8152 *tp)
+{
+	u32 ocp_data;
+
+	/* enable bp0 if support USB_SPEED_SUPER only */
+	if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER) {
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
+		ocp_data |= BIT(0);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
+	}
+
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_USB2PHY);
+	ocp_data |= USB2PHY_L1 | USB2PHY_SUSPEND;
+	ocp_write_byte(tp, MCU_TYPE_USB, USB_USB2PHY, ocp_data);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+	ocp_data |= FW_IP_RESET_EN;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
+
+	return 0;
+}
+
+static int r8153b_pre_firmware_1(struct r8152 *tp)
+{
+	/* enable fc timer and set timer to 1 second. */
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FC_TIMER,
+		       CTRL_TIMER_EN | (1000 / 8));
+
+	return 0;
+}
+
+static int r8153b_post_firmware_1(struct r8152 *tp)
+{
+	u32 ocp_data;
+
+	/* enable bp0 for RTL8153-BND */
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
+	if (ocp_data & BND_MASK) {
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
+		ocp_data |= BIT(0);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
+	}
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
+	ocp_data |= FLOW_CTRL_PATCH_OPT;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
+	ocp_data |= FC_PATCH_TASK;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+	ocp_data |= FW_IP_RESET_EN;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
+
+	return 0;
+}
+
+static int r8153c_post_firmware_1(struct r8152 *tp)
+{
+	u32 ocp_data;
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
+	ocp_data |= FLOW_CTRL_PATCH_2;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
+	ocp_data |= FC_PATCH_TASK;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+
+	return 0;
+}
+
+static int r8156a_post_firmware_1(struct r8152 *tp)
+{
+	u32 ocp_data;
+
+	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
+	ocp_data |= FW_IP_RESET_EN;
+	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
+
+	/* Modify U3PHY parameter for compatibility issue */
+	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPHY3_MDCMDIO, 0x4026840e);
+	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPHY3_MDCMDIO, 0x4001acc9);
+
+	return 0;
+}
+
+int rtl_fw_init(struct r8152 *tp)
+{
+	struct rtl_fw *rtl_fw = &tp->rtl_fw;
+
+	switch (tp->version) {
+	case RTL_VER_04:
+		rtl_fw->fw_name		= FIRMWARE_8153A_2;
+		rtl_fw->pre_fw		= r8153_pre_firmware_1;
+		rtl_fw->post_fw		= r8153_post_firmware_1;
+		break;
+	case RTL_VER_05:
+		rtl_fw->fw_name		= FIRMWARE_8153A_3;
+		rtl_fw->pre_fw		= r8153_pre_firmware_2;
+		rtl_fw->post_fw		= r8153_post_firmware_2;
+		break;
+	case RTL_VER_06:
+		rtl_fw->fw_name		= FIRMWARE_8153A_4;
+		rtl_fw->post_fw		= r8153_post_firmware_3;
+		break;
+	case RTL_VER_09:
+		rtl_fw->fw_name		= FIRMWARE_8153B_2;
+		rtl_fw->pre_fw		= r8153b_pre_firmware_1;
+		rtl_fw->post_fw		= r8153b_post_firmware_1;
+		break;
+	case RTL_VER_11:
+		rtl_fw->fw_name		= FIRMWARE_8156A_2;
+		rtl_fw->post_fw		= r8156a_post_firmware_1;
+		break;
+	case RTL_VER_13:
+	case RTL_VER_15:
+		rtl_fw->fw_name		= FIRMWARE_8156B_2;
+		break;
+	case RTL_VER_14:
+		rtl_fw->fw_name		= FIRMWARE_8153C_1;
+		rtl_fw->pre_fw		= r8153b_pre_firmware_1;
+		rtl_fw->post_fw		= r8153c_post_firmware_1;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/usb/realtek/r8152.c b/drivers/net/usb/realtek/r8152_main.c
similarity index 75%
rename from drivers/net/usb/realtek/r8152.c
rename to drivers/net/usb/realtek/r8152_main.c
index e09b107b5c99..0b0271454d8b 100644
--- a/drivers/net/usb/realtek/r8152.c
+++ b/drivers/net/usb/realtek/r8152_main.c
@@ -24,12 +24,11 @@
 #include <linux/suspend.h>
 #include <linux/atomic.h>
 #include <linux/acpi.h>
-#include <linux/firmware.h>
-#include <crypto/hash.h>
 #include <linux/usb/r8152.h>
+#include "r8152_basic.h"
 
 /* Information for net-next */
-#define NETNEXT_VERSION		"12"
+#define NETNEXT_VERSION		"13"
 
 /* Information for net */
 #define NET_VERSION		"11"
@@ -41,687 +40,6 @@
 
 #define R8152_PHY_ID		32
 
-#define PLA_IDR			0xc000
-#define PLA_RCR			0xc010
-#define PLA_RCR1		0xc012
-#define PLA_RMS			0xc016
-#define PLA_RXFIFO_CTRL0	0xc0a0
-#define PLA_RXFIFO_FULL		0xc0a2
-#define PLA_RXFIFO_CTRL1	0xc0a4
-#define PLA_RX_FIFO_FULL	0xc0a6
-#define PLA_RXFIFO_CTRL2	0xc0a8
-#define PLA_RX_FIFO_EMPTY	0xc0aa
-#define PLA_DMY_REG0		0xc0b0
-#define PLA_FMC			0xc0b4
-#define PLA_CFG_WOL		0xc0b6
-#define PLA_TEREDO_CFG		0xc0bc
-#define PLA_TEREDO_WAKE_BASE	0xc0c4
-#define PLA_MAR			0xcd00
-#define PLA_BACKUP		0xd000
-#define PLA_BDC_CR		0xd1a0
-#define PLA_TEREDO_TIMER	0xd2cc
-#define PLA_REALWOW_TIMER	0xd2e8
-#define PLA_UPHY_TIMER		0xd388
-#define PLA_SUSPEND_FLAG	0xd38a
-#define PLA_INDICATE_FALG	0xd38c
-#define PLA_MACDBG_PRE		0xd38c	/* RTL_VER_04 only */
-#define PLA_MACDBG_POST		0xd38e	/* RTL_VER_04 only */
-#define PLA_EXTRA_STATUS	0xd398
-#define PLA_GPHY_CTRL		0xd3ae
-#define PLA_POL_GPIO_CTRL	0xdc6a
-#define PLA_EFUSE_DATA		0xdd00
-#define PLA_EFUSE_CMD		0xdd02
-#define PLA_LEDSEL		0xdd90
-#define PLA_LED_FEATURE		0xdd92
-#define PLA_PHYAR		0xde00
-#define PLA_BOOT_CTRL		0xe004
-#define PLA_LWAKE_CTRL_REG	0xe007
-#define PLA_GPHY_INTR_IMR	0xe022
-#define PLA_EEE_CR		0xe040
-#define PLA_EEE_TXTWSYS		0xe04c
-#define PLA_EEE_TXTWSYS_2P5G	0xe058
-#define PLA_EEEP_CR		0xe080
-#define PLA_MAC_PWR_CTRL	0xe0c0
-#define PLA_MAC_PWR_CTRL2	0xe0ca
-#define PLA_MAC_PWR_CTRL3	0xe0cc
-#define PLA_MAC_PWR_CTRL4	0xe0ce
-#define PLA_WDT6_CTRL		0xe428
-#define PLA_TCR0		0xe610
-#define PLA_TCR1		0xe612
-#define PLA_MTPS		0xe615
-#define PLA_TXFIFO_CTRL		0xe618
-#define PLA_TXFIFO_FULL		0xe61a
-#define PLA_RSTTALLY		0xe800
-#define PLA_CR			0xe813
-#define PLA_CRWECR		0xe81c
-#define PLA_CONFIG12		0xe81e	/* CONFIG1, CONFIG2 */
-#define PLA_CONFIG34		0xe820	/* CONFIG3, CONFIG4 */
-#define PLA_CONFIG5		0xe822
-#define PLA_PHY_PWR		0xe84c
-#define PLA_OOB_CTRL		0xe84f
-#define PLA_CPCR		0xe854
-#define PLA_MISC_0		0xe858
-#define PLA_MISC_1		0xe85a
-#define PLA_OCP_GPHY_BASE	0xe86c
-#define PLA_TALLYCNT		0xe890
-#define PLA_SFF_STS_7		0xe8de
-#define PLA_PHYSTATUS		0xe908
-#define PLA_CONFIG6		0xe90a /* CONFIG6 */
-#define PLA_USB_CFG		0xe952
-#define PLA_BP_BA		0xfc26
-#define PLA_BP_0		0xfc28
-#define PLA_BP_1		0xfc2a
-#define PLA_BP_2		0xfc2c
-#define PLA_BP_3		0xfc2e
-#define PLA_BP_4		0xfc30
-#define PLA_BP_5		0xfc32
-#define PLA_BP_6		0xfc34
-#define PLA_BP_7		0xfc36
-#define PLA_BP_EN		0xfc38
-
-#define USB_USB2PHY		0xb41e
-#define USB_SSPHYLINK1		0xb426
-#define USB_SSPHYLINK2		0xb428
-#define USB_L1_CTRL		0xb45e
-#define USB_U2P3_CTRL		0xb460
-#define USB_CSR_DUMMY1		0xb464
-#define USB_CSR_DUMMY2		0xb466
-#define USB_DEV_STAT		0xb808
-#define USB_CONNECT_TIMER	0xcbf8
-#define USB_MSC_TIMER		0xcbfc
-#define USB_BURST_SIZE		0xcfc0
-#define USB_FW_FIX_EN0		0xcfca
-#define USB_FW_FIX_EN1		0xcfcc
-#define USB_LPM_CONFIG		0xcfd8
-#define USB_ECM_OPTION		0xcfee
-#define USB_CSTMR		0xcfef	/* RTL8153A */
-#define USB_MISC_2		0xcfff
-#define USB_ECM_OP		0xd26b
-#define USB_GPHY_CTRL		0xd284
-#define USB_SPEED_OPTION	0xd32a
-#define USB_FW_CTRL		0xd334	/* RTL8153B */
-#define USB_FC_TIMER		0xd340
-#define USB_USB_CTRL		0xd406
-#define USB_PHY_CTRL		0xd408
-#define USB_TX_AGG		0xd40a
-#define USB_RX_BUF_TH		0xd40c
-#define USB_USB_TIMER		0xd428
-#define USB_RX_EARLY_TIMEOUT	0xd42c
-#define USB_RX_EARLY_SIZE	0xd42e
-#define USB_PM_CTRL_STATUS	0xd432	/* RTL8153A */
-#define USB_RX_EXTRA_AGGR_TMR	0xd432	/* RTL8153B */
-#define USB_TX_DMA		0xd434
-#define USB_UPT_RXDMA_OWN	0xd437
-#define USB_UPHY3_MDCMDIO	0xd480
-#define USB_TOLERANCE		0xd490
-#define USB_LPM_CTRL		0xd41a
-#define USB_BMU_RESET		0xd4b0
-#define USB_BMU_CONFIG		0xd4b4
-#define USB_U1U2_TIMER		0xd4da
-#define USB_FW_TASK		0xd4e8	/* RTL8153B */
-#define USB_RX_AGGR_NUM		0xd4ee
-#define USB_UPS_CTRL		0xd800
-#define USB_POWER_CUT		0xd80a
-#define USB_MISC_0		0xd81a
-#define USB_MISC_1		0xd81f
-#define USB_AFE_CTRL2		0xd824
-#define USB_UPHY_XTAL		0xd826
-#define USB_UPS_CFG		0xd842
-#define USB_UPS_FLAGS		0xd848
-#define USB_WDT1_CTRL		0xe404
-#define USB_WDT11_CTRL		0xe43c
-#define USB_BP_BA		PLA_BP_BA
-#define USB_BP_0		PLA_BP_0
-#define USB_BP_1		PLA_BP_1
-#define USB_BP_2		PLA_BP_2
-#define USB_BP_3		PLA_BP_3
-#define USB_BP_4		PLA_BP_4
-#define USB_BP_5		PLA_BP_5
-#define USB_BP_6		PLA_BP_6
-#define USB_BP_7		PLA_BP_7
-#define USB_BP_EN		PLA_BP_EN	/* RTL8153A */
-#define USB_BP_8		0xfc38		/* RTL8153B */
-#define USB_BP_9		0xfc3a
-#define USB_BP_10		0xfc3c
-#define USB_BP_11		0xfc3e
-#define USB_BP_12		0xfc40
-#define USB_BP_13		0xfc42
-#define USB_BP_14		0xfc44
-#define USB_BP_15		0xfc46
-#define USB_BP2_EN		0xfc48
-
-/* OCP Registers */
-#define OCP_ALDPS_CONFIG	0x2010
-#define OCP_EEE_CONFIG1		0x2080
-#define OCP_EEE_CONFIG2		0x2092
-#define OCP_EEE_CONFIG3		0x2094
-#define OCP_BASE_MII		0xa400
-#define OCP_EEE_AR		0xa41a
-#define OCP_EEE_DATA		0xa41c
-#define OCP_PHY_STATUS		0xa420
-#define OCP_NCTL_CFG		0xa42c
-#define OCP_POWER_CFG		0xa430
-#define OCP_EEE_CFG		0xa432
-#define OCP_SRAM_ADDR		0xa436
-#define OCP_SRAM_DATA		0xa438
-#define OCP_DOWN_SPEED		0xa442
-#define OCP_EEE_ABLE		0xa5c4
-#define OCP_EEE_ADV		0xa5d0
-#define OCP_EEE_LPABLE		0xa5d2
-#define OCP_10GBT_CTRL		0xa5d4
-#define OCP_10GBT_STAT		0xa5d6
-#define OCP_EEE_ADV2		0xa6d4
-#define OCP_PHY_STATE		0xa708		/* nway state for 8153 */
-#define OCP_PHY_PATCH_STAT	0xb800
-#define OCP_PHY_PATCH_CMD	0xb820
-#define OCP_PHY_LOCK		0xb82e
-#define OCP_ADC_IOFFSET		0xbcfc
-#define OCP_ADC_CFG		0xbc06
-#define OCP_SYSCLK_CFG		0xc416
-
-/* SRAM Register */
-#define SRAM_GREEN_CFG		0x8011
-#define SRAM_LPF_CFG		0x8012
-#define SRAM_GPHY_FW_VER	0x801e
-#define SRAM_10M_AMP1		0x8080
-#define SRAM_10M_AMP2		0x8082
-#define SRAM_IMPEDANCE		0x8084
-#define SRAM_PHY_LOCK		0xb82e
-
-/* PLA_RCR */
-#define RCR_AAP			0x00000001
-#define RCR_APM			0x00000002
-#define RCR_AM			0x00000004
-#define RCR_AB			0x00000008
-#define RCR_ACPT_ALL		(RCR_AAP | RCR_APM | RCR_AM | RCR_AB)
-#define SLOT_EN			BIT(11)
-
-/* PLA_RCR1 */
-#define OUTER_VLAN		BIT(7)
-#define INNER_VLAN		BIT(6)
-
-/* PLA_RXFIFO_CTRL0 */
-#define RXFIFO_THR1_NORMAL	0x00080002
-#define RXFIFO_THR1_OOB		0x01800003
-
-/* PLA_RXFIFO_FULL */
-#define RXFIFO_FULL_MASK	0xfff
-
-/* PLA_RXFIFO_CTRL1 */
-#define RXFIFO_THR2_FULL	0x00000060
-#define RXFIFO_THR2_HIGH	0x00000038
-#define RXFIFO_THR2_OOB		0x0000004a
-#define RXFIFO_THR2_NORMAL	0x00a0
-
-/* PLA_RXFIFO_CTRL2 */
-#define RXFIFO_THR3_FULL	0x00000078
-#define RXFIFO_THR3_HIGH	0x00000048
-#define RXFIFO_THR3_OOB		0x0000005a
-#define RXFIFO_THR3_NORMAL	0x0110
-
-/* PLA_TXFIFO_CTRL */
-#define TXFIFO_THR_NORMAL	0x00400008
-#define TXFIFO_THR_NORMAL2	0x01000008
-
-/* PLA_DMY_REG0 */
-#define ECM_ALDPS		0x0002
-
-/* PLA_FMC */
-#define FMC_FCR_MCU_EN		0x0001
-
-/* PLA_EEEP_CR */
-#define EEEP_CR_EEEP_TX		0x0002
-
-/* PLA_WDT6_CTRL */
-#define WDT6_SET_MODE		0x0010
-
-/* PLA_TCR0 */
-#define TCR0_TX_EMPTY		0x0800
-#define TCR0_AUTO_FIFO		0x0080
-
-/* PLA_TCR1 */
-#define VERSION_MASK		0x7cf0
-#define IFG_MASK		(BIT(3) | BIT(9) | BIT(8))
-#define IFG_144NS		BIT(9)
-#define IFG_96NS		(BIT(9) | BIT(8))
-
-/* PLA_MTPS */
-#define MTPS_JUMBO		(12 * 1024 / 64)
-#define MTPS_DEFAULT		(6 * 1024 / 64)
-
-/* PLA_RSTTALLY */
-#define TALLY_RESET		0x0001
-
-/* PLA_CR */
-#define CR_RST			0x10
-#define CR_RE			0x08
-#define CR_TE			0x04
-
-/* PLA_CRWECR */
-#define CRWECR_NORAML		0x00
-#define CRWECR_CONFIG		0xc0
-
-/* PLA_OOB_CTRL */
-#define NOW_IS_OOB		0x80
-#define TXFIFO_EMPTY		0x20
-#define RXFIFO_EMPTY		0x10
-#define LINK_LIST_READY		0x02
-#define DIS_MCU_CLROOB		0x01
-#define FIFO_EMPTY		(TXFIFO_EMPTY | RXFIFO_EMPTY)
-
-/* PLA_MISC_1 */
-#define RXDY_GATED_EN		0x0008
-
-/* PLA_SFF_STS_7 */
-#define RE_INIT_LL		0x8000
-#define MCU_BORW_EN		0x4000
-
-/* PLA_CPCR */
-#define FLOW_CTRL_EN		BIT(0)
-#define CPCR_RX_VLAN		0x0040
-
-/* PLA_CFG_WOL */
-#define MAGIC_EN		0x0001
-
-/* PLA_TEREDO_CFG */
-#define TEREDO_SEL		0x8000
-#define TEREDO_WAKE_MASK	0x7f00
-#define TEREDO_RS_EVENT_MASK	0x00fe
-#define OOB_TEREDO_EN		0x0001
-
-/* PLA_BDC_CR */
-#define ALDPS_PROXY_MODE	0x0001
-
-/* PLA_EFUSE_CMD */
-#define EFUSE_READ_CMD		BIT(15)
-#define EFUSE_DATA_BIT16	BIT(7)
-
-/* PLA_CONFIG34 */
-#define LINK_ON_WAKE_EN		0x0010
-#define LINK_OFF_WAKE_EN	0x0008
-
-/* PLA_CONFIG6 */
-#define LANWAKE_CLR_EN		BIT(0)
-
-/* PLA_USB_CFG */
-#define EN_XG_LIP		BIT(1)
-#define EN_G_LIP		BIT(2)
-
-/* PLA_CONFIG5 */
-#define BWF_EN			0x0040
-#define MWF_EN			0x0020
-#define UWF_EN			0x0010
-#define LAN_WAKE_EN		0x0002
-
-/* PLA_LED_FEATURE */
-#define LED_MODE_MASK		0x0700
-
-/* PLA_PHY_PWR */
-#define TX_10M_IDLE_EN		0x0080
-#define PFM_PWM_SWITCH		0x0040
-#define TEST_IO_OFF		BIT(4)
-
-/* PLA_MAC_PWR_CTRL */
-#define D3_CLK_GATED_EN		0x00004000
-#define MCU_CLK_RATIO		0x07010f07
-#define MCU_CLK_RATIO_MASK	0x0f0f0f0f
-#define ALDPS_SPDWN_RATIO	0x0f87
-
-/* PLA_MAC_PWR_CTRL2 */
-#define EEE_SPDWN_RATIO		0x8007
-#define MAC_CLK_SPDWN_EN	BIT(15)
-#define EEE_SPDWN_RATIO_MASK	0xff
-
-/* PLA_MAC_PWR_CTRL3 */
-#define PLA_MCU_SPDWN_EN	BIT(14)
-#define PKT_AVAIL_SPDWN_EN	0x0100
-#define SUSPEND_SPDWN_EN	0x0004
-#define U1U2_SPDWN_EN		0x0002
-#define L1_SPDWN_EN		0x0001
-
-/* PLA_MAC_PWR_CTRL4 */
-#define PWRSAVE_SPDWN_EN	0x1000
-#define RXDV_SPDWN_EN		0x0800
-#define TX10MIDLE_EN		0x0100
-#define IDLE_SPDWN_EN		BIT(6)
-#define TP100_SPDWN_EN		0x0020
-#define TP500_SPDWN_EN		0x0010
-#define TP1000_SPDWN_EN		0x0008
-#define EEE_SPDWN_EN		0x0001
-
-/* PLA_GPHY_INTR_IMR */
-#define GPHY_STS_MSK		0x0001
-#define SPEED_DOWN_MSK		0x0002
-#define SPDWN_RXDV_MSK		0x0004
-#define SPDWN_LINKCHG_MSK	0x0008
-
-/* PLA_PHYAR */
-#define PHYAR_FLAG		0x80000000
-
-/* PLA_EEE_CR */
-#define EEE_RX_EN		0x0001
-#define EEE_TX_EN		0x0002
-
-/* PLA_BOOT_CTRL */
-#define AUTOLOAD_DONE		0x0002
-
-/* PLA_LWAKE_CTRL_REG */
-#define LANWAKE_PIN		BIT(7)
-
-/* PLA_SUSPEND_FLAG */
-#define LINK_CHG_EVENT		BIT(0)
-
-/* PLA_INDICATE_FALG */
-#define UPCOMING_RUNTIME_D3	BIT(0)
-
-/* PLA_MACDBG_PRE and PLA_MACDBG_POST */
-#define DEBUG_OE		BIT(0)
-#define DEBUG_LTSSM		0x0082
-
-/* PLA_EXTRA_STATUS */
-#define CUR_LINK_OK		BIT(15)
-#define U3P3_CHECK_EN		BIT(7)	/* RTL_VER_05 only */
-#define LINK_CHANGE_FLAG	BIT(8)
-#define POLL_LINK_CHG		BIT(0)
-
-/* PLA_GPHY_CTRL */
-#define GPHY_FLASH		BIT(1)
-
-/* PLA_POL_GPIO_CTRL */
-#define DACK_DET_EN		BIT(15)
-#define POL_GPHY_PATCH		BIT(4)
-
-/* USB_USB2PHY */
-#define USB2PHY_SUSPEND		0x0001
-#define USB2PHY_L1		0x0002
-
-/* USB_SSPHYLINK1 */
-#define DELAY_PHY_PWR_CHG	BIT(1)
-
-/* USB_SSPHYLINK2 */
-#define pwd_dn_scale_mask	0x3ffe
-#define pwd_dn_scale(x)		((x) << 1)
-
-/* USB_CSR_DUMMY1 */
-#define DYNAMIC_BURST		0x0001
-
-/* USB_CSR_DUMMY2 */
-#define EP4_FULL_FC		0x0001
-
-/* USB_DEV_STAT */
-#define STAT_SPEED_MASK		0x0006
-#define STAT_SPEED_HIGH		0x0000
-#define STAT_SPEED_FULL		0x0002
-
-/* USB_FW_FIX_EN0 */
-#define FW_FIX_SUSPEND		BIT(14)
-
-/* USB_FW_FIX_EN1 */
-#define FW_IP_RESET_EN		BIT(9)
-
-/* USB_LPM_CONFIG */
-#define LPM_U1U2_EN		BIT(0)
-
-/* USB_TX_AGG */
-#define TX_AGG_MAX_THRESHOLD	0x03
-
-/* USB_RX_BUF_TH */
-#define RX_THR_SUPPER		0x0c350180
-#define RX_THR_HIGH		0x7a120180
-#define RX_THR_SLOW		0xffff0180
-#define RX_THR_B		0x00010001
-
-/* USB_TX_DMA */
-#define TEST_MODE_DISABLE	0x00000001
-#define TX_SIZE_ADJUST1		0x00000100
-
-/* USB_BMU_RESET */
-#define BMU_RESET_EP_IN		0x01
-#define BMU_RESET_EP_OUT	0x02
-
-/* USB_BMU_CONFIG */
-#define ACT_ODMA		BIT(1)
-
-/* USB_UPT_RXDMA_OWN */
-#define OWN_UPDATE		BIT(0)
-#define OWN_CLEAR		BIT(1)
-
-/* USB_FW_TASK */
-#define FC_PATCH_TASK		BIT(1)
-
-/* USB_RX_AGGR_NUM */
-#define RX_AGGR_NUM_MASK	0x1ff
-
-/* USB_UPS_CTRL */
-#define POWER_CUT		0x0100
-
-/* USB_PM_CTRL_STATUS */
-#define RESUME_INDICATE		0x0001
-
-/* USB_ECM_OPTION */
-#define BYPASS_MAC_RESET	BIT(5)
-
-/* USB_CSTMR */
-#define FORCE_SUPER		BIT(0)
-
-/* USB_MISC_2 */
-#define UPS_FORCE_PWR_DOWN	BIT(0)
-
-/* USB_ECM_OP */
-#define	EN_ALL_SPEED		BIT(0)
-
-/* USB_GPHY_CTRL */
-#define GPHY_PATCH_DONE		BIT(2)
-#define BYPASS_FLASH		BIT(5)
-#define BACKUP_RESTRORE		BIT(6)
-
-/* USB_SPEED_OPTION */
-#define RG_PWRDN_EN		BIT(8)
-#define ALL_SPEED_OFF		BIT(9)
-
-/* USB_FW_CTRL */
-#define FLOW_CTRL_PATCH_OPT	BIT(1)
-#define AUTO_SPEEDUP		BIT(3)
-#define FLOW_CTRL_PATCH_2	BIT(8)
-
-/* USB_FC_TIMER */
-#define CTRL_TIMER_EN		BIT(15)
-
-/* USB_USB_CTRL */
-#define CDC_ECM_EN		BIT(3)
-#define RX_AGG_DISABLE		0x0010
-#define RX_ZERO_EN		0x0080
-
-/* USB_U2P3_CTRL */
-#define U2P3_ENABLE		0x0001
-#define RX_DETECT8		BIT(3)
-
-/* USB_POWER_CUT */
-#define PWR_EN			0x0001
-#define PHASE2_EN		0x0008
-#define UPS_EN			BIT(4)
-#define USP_PREWAKE		BIT(5)
-
-/* USB_MISC_0 */
-#define PCUT_STATUS		0x0001
-
-/* USB_RX_EARLY_TIMEOUT */
-#define COALESCE_SUPER		 85000U
-#define COALESCE_HIGH		250000U
-#define COALESCE_SLOW		524280U
-
-/* USB_WDT1_CTRL */
-#define WTD1_EN			BIT(0)
-
-/* USB_WDT11_CTRL */
-#define TIMER11_EN		0x0001
-
-/* USB_LPM_CTRL */
-/* bit 4 ~ 5: fifo empty boundary */
-#define FIFO_EMPTY_1FB		0x30	/* 0x1fb * 64 = 32448 bytes */
-/* bit 2 ~ 3: LMP timer */
-#define LPM_TIMER_MASK		0x0c
-#define LPM_TIMER_500MS		0x04	/* 500 ms */
-#define LPM_TIMER_500US		0x0c	/* 500 us */
-#define ROK_EXIT_LPM		0x02
-
-/* USB_AFE_CTRL2 */
-#define SEN_VAL_MASK		0xf800
-#define SEN_VAL_NORMAL		0xa000
-#define SEL_RXIDLE		0x0100
-
-/* USB_UPHY_XTAL */
-#define OOBS_POLLING		BIT(8)
-
-/* USB_UPS_CFG */
-#define SAW_CNT_1MS_MASK	0x0fff
-#define MID_REVERSE		BIT(5)	/* RTL8156A */
-
-/* USB_UPS_FLAGS */
-#define UPS_FLAGS_R_TUNE		BIT(0)
-#define UPS_FLAGS_EN_10M_CKDIV		BIT(1)
-#define UPS_FLAGS_250M_CKDIV		BIT(2)
-#define UPS_FLAGS_EN_ALDPS		BIT(3)
-#define UPS_FLAGS_CTAP_SHORT_DIS	BIT(4)
-#define UPS_FLAGS_SPEED_MASK		(0xf << 16)
-#define ups_flags_speed(x)		((x) << 16)
-#define UPS_FLAGS_EN_EEE		BIT(20)
-#define UPS_FLAGS_EN_500M_EEE		BIT(21)
-#define UPS_FLAGS_EN_EEE_CKDIV		BIT(22)
-#define UPS_FLAGS_EEE_PLLOFF_100	BIT(23)
-#define UPS_FLAGS_EEE_PLLOFF_GIGA	BIT(24)
-#define UPS_FLAGS_EEE_CMOD_LV_EN	BIT(25)
-#define UPS_FLAGS_EN_GREEN		BIT(26)
-#define UPS_FLAGS_EN_FLOW_CTR		BIT(27)
-
-enum spd_duplex {
-	NWAY_10M_HALF,
-	NWAY_10M_FULL,
-	NWAY_100M_HALF,
-	NWAY_100M_FULL,
-	NWAY_1000M_FULL,
-	FORCE_10M_HALF,
-	FORCE_10M_FULL,
-	FORCE_100M_HALF,
-	FORCE_100M_FULL,
-	FORCE_1000M_FULL,
-	NWAY_2500M_FULL,
-};
-
-/* OCP_ALDPS_CONFIG */
-#define ENPWRSAVE		0x8000
-#define ENPDNPS			0x0200
-#define LINKENA			0x0100
-#define DIS_SDSAVE		0x0010
-
-/* OCP_PHY_STATUS */
-#define PHY_STAT_MASK		0x0007
-#define PHY_STAT_EXT_INIT	2
-#define PHY_STAT_LAN_ON		3
-#define PHY_STAT_PWRDN		5
-
-/* OCP_NCTL_CFG */
-#define PGA_RETURN_EN		BIT(1)
-
-/* OCP_POWER_CFG */
-#define EEE_CLKDIV_EN		0x8000
-#define EN_ALDPS		0x0004
-#define EN_10M_PLLOFF		0x0001
-
-/* OCP_EEE_CONFIG1 */
-#define RG_TXLPI_MSK_HFDUP	0x8000
-#define RG_MATCLR_EN		0x4000
-#define EEE_10_CAP		0x2000
-#define EEE_NWAY_EN		0x1000
-#define TX_QUIET_EN		0x0200
-#define RX_QUIET_EN		0x0100
-#define sd_rise_time_mask	0x0070
-#define sd_rise_time(x)		(min(x, 7) << 4)	/* bit 4 ~ 6 */
-#define RG_RXLPI_MSK_HFDUP	0x0008
-#define SDFALLTIME		0x0007	/* bit 0 ~ 2 */
-
-/* OCP_EEE_CONFIG2 */
-#define RG_LPIHYS_NUM		0x7000	/* bit 12 ~ 15 */
-#define RG_DACQUIET_EN		0x0400
-#define RG_LDVQUIET_EN		0x0200
-#define RG_CKRSEL		0x0020
-#define RG_EEEPRG_EN		0x0010
-
-/* OCP_EEE_CONFIG3 */
-#define fast_snr_mask		0xff80
-#define fast_snr(x)		(min(x, 0x1ff) << 7)	/* bit 7 ~ 15 */
-#define RG_LFS_SEL		0x0060	/* bit 6 ~ 5 */
-#define MSK_PH			0x0006	/* bit 0 ~ 3 */
-
-/* OCP_EEE_AR */
-/* bit[15:14] function */
-#define FUN_ADDR		0x0000
-#define FUN_DATA		0x4000
-/* bit[4:0] device addr */
-
-/* OCP_EEE_CFG */
-#define CTAP_SHORT_EN		0x0040
-#define EEE10_EN		0x0010
-
-/* OCP_DOWN_SPEED */
-#define EN_EEE_CMODE		BIT(14)
-#define EN_EEE_1000		BIT(13)
-#define EN_EEE_100		BIT(12)
-#define EN_10M_CLKDIV		BIT(11)
-#define EN_10M_BGOFF		0x0080
-
-/* OCP_10GBT_CTRL */
-#define RTL_ADV2_5G_F_R		BIT(5)	/* Advertise 2.5GBASE-T fast-retrain */
-
-/* OCP_PHY_STATE */
-#define TXDIS_STATE		0x01
-#define ABD_STATE		0x02
-
-/* OCP_PHY_PATCH_STAT */
-#define PATCH_READY		BIT(6)
-
-/* OCP_PHY_PATCH_CMD */
-#define PATCH_REQUEST		BIT(4)
-
-/* OCP_PHY_LOCK */
-#define PATCH_LOCK		BIT(0)
-
-/* OCP_ADC_CFG */
-#define CKADSEL_L		0x0100
-#define ADC_EN			0x0080
-#define EN_EMI_L		0x0040
-
-/* OCP_SYSCLK_CFG */
-#define sysclk_div_expo(x)	(min(x, 5) << 8)
-#define clk_div_expo(x)		(min(x, 5) << 4)
-
-/* SRAM_GREEN_CFG */
-#define GREEN_ETH_EN		BIT(15)
-#define R_TUNE_EN		BIT(11)
-
-/* SRAM_LPF_CFG */
-#define LPF_AUTO_TUNE		0x8000
-
-/* SRAM_10M_AMP1 */
-#define GDAC_IB_UPALL		0x0008
-
-/* SRAM_10M_AMP2 */
-#define AMP_DN			0x0200
-
-/* SRAM_IMPEDANCE */
-#define RX_DRIVING_MASK		0x6000
-
-/* SRAM_PHY_LOCK */
-#define PHY_PATCH_LOCK		0x0001
-
-/* MAC PASSTHRU */
-#define AD_MASK			0xfee0
-#define BND_MASK		0x0004
-#define BD_MASK			0x0001
-#define EFUSE			0xcfdb
-#define PASS_THRU_MASK		0x1
-
-#define BP4_SUPER_ONLY		0x1578	/* RTL_VER_04 only */
 
 enum rtl_register_content {
 	_2500bps	= BIT(10),
@@ -739,8 +57,6 @@ enum rtl_register_content {
 #define is_speed_2500(_speed)	(((_speed) & (_2500bps | LINK_STATUS)) == (_2500bps | LINK_STATUS))
 #define is_flow_control(_speed)	(((_speed) & (_tx_flow | _rx_flow)) == (_tx_flow | _rx_flow))
 
-#define RTL8152_MAX_TX		4
-#define RTL8152_MAX_RX		10
 #define INTBUFSIZE		2
 #define TX_ALIGN		4
 #define RX_ALIGN		8
@@ -831,343 +147,6 @@ struct tx_desc {
 #define TX_VLAN_TAG		BIT(16)
 };
 
-struct r8152;
-
-struct rx_agg {
-	struct list_head list, info_list;
-	struct urb *urb;
-	struct r8152 *context;
-	struct page *page;
-	void *buffer;
-};
-
-struct tx_agg {
-	struct list_head list;
-	struct urb *urb;
-	struct r8152 *context;
-	void *buffer;
-	void *head;
-	u32 skb_num;
-	u32 skb_len;
-};
-
-struct r8152 {
-	unsigned long flags;
-	struct usb_device *udev;
-	struct napi_struct napi;
-	struct usb_interface *intf;
-	struct net_device *netdev;
-	struct urb *intr_urb;
-	struct tx_agg tx_info[RTL8152_MAX_TX];
-	struct list_head rx_info, rx_used;
-	struct list_head rx_done, tx_free;
-	struct sk_buff_head tx_queue, rx_queue;
-	spinlock_t rx_lock, tx_lock;
-	struct delayed_work schedule, hw_phy_work;
-	struct mii_if_info mii;
-	struct mutex control;	/* use for hw setting */
-#ifdef CONFIG_PM_SLEEP
-	struct notifier_block pm_notifier;
-#endif
-	struct tasklet_struct tx_tl;
-
-	struct rtl_ops {
-		void (*init)(struct r8152 *tp);
-		int (*enable)(struct r8152 *tp);
-		void (*disable)(struct r8152 *tp);
-		void (*up)(struct r8152 *tp);
-		void (*down)(struct r8152 *tp);
-		void (*unload)(struct r8152 *tp);
-		int (*eee_get)(struct r8152 *tp, struct ethtool_eee *eee);
-		int (*eee_set)(struct r8152 *tp, struct ethtool_eee *eee);
-		bool (*in_nway)(struct r8152 *tp);
-		void (*hw_phy_cfg)(struct r8152 *tp);
-		void (*autosuspend_en)(struct r8152 *tp, bool enable);
-		void (*change_mtu)(struct r8152 *tp);
-	} rtl_ops;
-
-	struct ups_info {
-		u32 r_tune:1;
-		u32 _10m_ckdiv:1;
-		u32 _250m_ckdiv:1;
-		u32 aldps:1;
-		u32 lite_mode:2;
-		u32 speed_duplex:4;
-		u32 eee:1;
-		u32 eee_lite:1;
-		u32 eee_ckdiv:1;
-		u32 eee_plloff_100:1;
-		u32 eee_plloff_giga:1;
-		u32 eee_cmod_lv:1;
-		u32 green:1;
-		u32 flow_control:1;
-		u32 ctap_short_off:1;
-	} ups_info;
-
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
-	atomic_t rx_count;
-
-	bool eee_en;
-	int intr_interval;
-	u32 saved_wolopts;
-	u32 msg_enable;
-	u32 tx_qlen;
-	u32 coalesce;
-	u32 advertising;
-	u32 rx_buf_sz;
-	u32 rx_copybreak;
-	u32 rx_pending;
-	u32 fc_pause_on, fc_pause_off;
-
-	unsigned int pipe_in, pipe_out, pipe_intr, pipe_ctrl_in, pipe_ctrl_out;
-
-	u32 support_2500full:1;
-	u32 lenovo_macpassthru:1;
-	u32 dell_tb_rx_agg_bug:1;
-	u16 ocp_base;
-	u16 speed;
-	u16 eee_adv;
-	u8 *intr_buff;
-	u8 version;
-	u8 duplex;
-	u8 autoneg;
-};
-
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
-enum rtl_version {
-	RTL_VER_UNKNOWN = 0,
-	RTL_VER_01,
-	RTL_VER_02,
-	RTL_VER_03,
-	RTL_VER_04,
-	RTL_VER_05,
-	RTL_VER_06,
-	RTL_VER_07,
-	RTL_VER_08,
-	RTL_VER_09,
-
-	RTL_TEST_01,
-	RTL_VER_10,
-	RTL_VER_11,
-	RTL_VER_12,
-	RTL_VER_13,
-	RTL_VER_14,
-	RTL_VER_15,
-
-	RTL_VER_MAX
-};
-
 enum tx_csum_stat {
 	TX_CSUM_SUCCESS = 0,
 	TX_CSUM_TSO,
@@ -1240,8 +219,7 @@ static void rtl_set_unplug(struct r8152 *tp)
 	}
 }
 
-static int generic_ocp_read(struct r8152 *tp, u16 index, u16 size,
-			    void *data, u16 type)
+int generic_ocp_read(struct r8152 *tp, u16 index, u16 size, void *data, u16 type)
 {
 	u16 limit = 64;
 	int ret = 0;
@@ -1283,8 +261,7 @@ static int generic_ocp_read(struct r8152 *tp, u16 index, u16 size,
 	return ret;
 }
 
-static int generic_ocp_write(struct r8152 *tp, u16 index, u16 byteen,
-			     u16 size, void *data, u16 type)
+int generic_ocp_write(struct r8152 *tp, u16 index, u16 byteen, u16 size, void *data, u16 type)
 {
 	int ret;
 	u16 byteen_start, byteen_end, byen;
@@ -1371,7 +348,7 @@ int usb_ocp_write(struct r8152 *tp, u16 index, u16 byteen, u16 size, void *data)
 	return generic_ocp_write(tp, index, byteen, size, data, MCU_TYPE_USB);
 }
 
-static u32 ocp_read_dword(struct r8152 *tp, u16 type, u16 index)
+u32 ocp_read_dword(struct r8152 *tp, u16 type, u16 index)
 {
 	__le32 data;
 
@@ -1380,14 +357,14 @@ static u32 ocp_read_dword(struct r8152 *tp, u16 type, u16 index)
 	return __le32_to_cpu(data);
 }
 
-static void ocp_write_dword(struct r8152 *tp, u16 type, u16 index, u32 data)
+void ocp_write_dword(struct r8152 *tp, u16 type, u16 index, u32 data)
 {
 	__le32 tmp = __cpu_to_le32(data);
 
 	generic_ocp_write(tp, index, BYTE_EN_DWORD, sizeof(tmp), &tmp, type);
 }
 
-static u16 ocp_read_word(struct r8152 *tp, u16 type, u16 index)
+u16 ocp_read_word(struct r8152 *tp, u16 type, u16 index)
 {
 	u32 data;
 	__le32 tmp;
@@ -1406,7 +383,7 @@ static u16 ocp_read_word(struct r8152 *tp, u16 type, u16 index)
 	return (u16)data;
 }
 
-static void ocp_write_word(struct r8152 *tp, u16 type, u16 index, u32 data)
+void ocp_write_word(struct r8152 *tp, u16 type, u16 index, u32 data)
 {
 	u32 mask = 0xffff;
 	__le32 tmp;
@@ -1427,7 +404,7 @@ static void ocp_write_word(struct r8152 *tp, u16 type, u16 index, u32 data)
 	generic_ocp_write(tp, index, byen, sizeof(tmp), &tmp, type);
 }
 
-static u8 ocp_read_byte(struct r8152 *tp, u16 type, u16 index)
+u8 ocp_read_byte(struct r8152 *tp, u16 type, u16 index)
 {
 	u32 data;
 	__le32 tmp;
@@ -1444,7 +421,7 @@ static u8 ocp_read_byte(struct r8152 *tp, u16 type, u16 index)
 	return (u8)data;
 }
 
-static void ocp_write_byte(struct r8152 *tp, u16 type, u16 index, u32 data)
+void ocp_write_byte(struct r8152 *tp, u16 type, u16 index, u32 data)
 {
 	u32 mask = 0xff;
 	__le32 tmp;
@@ -1465,7 +442,7 @@ static void ocp_write_byte(struct r8152 *tp, u16 type, u16 index, u32 data)
 	generic_ocp_write(tp, index, byen, sizeof(tmp), &tmp, type);
 }
 
-static u16 ocp_reg_read(struct r8152 *tp, u16 addr)
+u16 ocp_reg_read(struct r8152 *tp, u16 addr)
 {
 	u16 ocp_base, ocp_index;
 
@@ -1479,7 +456,7 @@ static u16 ocp_reg_read(struct r8152 *tp, u16 addr)
 	return ocp_read_word(tp, MCU_TYPE_PLA, ocp_index);
 }
 
-static void ocp_reg_write(struct r8152 *tp, u16 addr, u16 data)
+void ocp_reg_write(struct r8152 *tp, u16 addr, u16 data)
 {
 	u16 ocp_base, ocp_index;
 
@@ -1503,13 +480,13 @@ static inline int r8152_mdio_read(struct r8152 *tp, u32 reg_addr)
 	return ocp_reg_read(tp, OCP_BASE_MII + reg_addr * 2);
 }
 
-static void sram_write(struct r8152 *tp, u16 addr, u16 data)
+void sram_write(struct r8152 *tp, u16 addr, u16 data)
 {
 	ocp_reg_write(tp, OCP_SRAM_ADDR, addr);
 	ocp_reg_write(tp, OCP_SRAM_DATA, data);
 }
 
-static u16 sram_read(struct r8152 *tp, u16 addr)
+u16 sram_read(struct r8152 *tp, u16 addr)
 {
 	ocp_reg_write(tp, OCP_SRAM_ADDR, addr);
 	return ocp_reg_read(tp, OCP_SRAM_DATA);
@@ -1614,7 +591,7 @@ static int vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
 		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_MISC_0);
 		if ((ocp_data & AD_MASK) == 0x1000) {
 			/* test for MAC address pass-through bit */
-			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, EFUSE);
+			ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_EFUSE);
 			if ((ocp_data & PASS_THRU_MASK) != 1) {
 				netif_dbg(tp, probe, tp->netdev,
 						"No efuse for RTL8153-AD MAC pass through\n");
@@ -3854,1275 +2831,125 @@ static void rtl8153b_runtime_enable(struct r8152 *tp, bool enable)
 		r8153_queue_wake(tp, false);
 		rtl_runtime_suspend_enable(tp, false);
 		if (tp->udev->speed >= USB_SPEED_SUPER)
-			r8153b_u1u2en(tp, true);
-	}
-}
-
-static void rtl8153c_runtime_enable(struct r8152 *tp, bool enable)
-{
-	if (enable) {
-		r8153_queue_wake(tp, true);
-		r8153b_u1u2en(tp, false);
-		r8153_u2p3en(tp, false);
-		rtl_runtime_suspend_enable(tp, true);
-		r8153c_ups_en(tp, true);
-	} else {
-		r8153c_ups_en(tp, false);
-		r8153_queue_wake(tp, false);
-		rtl_runtime_suspend_enable(tp, false);
-		r8153b_u1u2en(tp, true);
-	}
-}
-
-static void rtl8156_runtime_enable(struct r8152 *tp, bool enable)
-{
-	if (enable) {
-		r8153_queue_wake(tp, true);
-		r8153b_u1u2en(tp, false);
-		r8153_u2p3en(tp, false);
-		rtl_runtime_suspend_enable(tp, true);
-	} else {
-		r8153_queue_wake(tp, false);
-		rtl_runtime_suspend_enable(tp, false);
-		r8153_u2p3en(tp, true);
-		if (tp->udev->speed >= USB_SPEED_SUPER)
-			r8153b_u1u2en(tp, true);
-	}
-}
-
-static void r8153_teredo_off(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	switch (tp->version) {
-	case RTL_VER_01:
-	case RTL_VER_02:
-	case RTL_VER_03:
-	case RTL_VER_04:
-	case RTL_VER_05:
-	case RTL_VER_06:
-	case RTL_VER_07:
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG);
-		ocp_data &= ~(TEREDO_SEL | TEREDO_RS_EVENT_MASK |
-			      OOB_TEREDO_EN);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, ocp_data);
-		break;
-
-	case RTL_VER_08:
-	case RTL_VER_09:
-	case RTL_TEST_01:
-	case RTL_VER_10:
-	case RTL_VER_11:
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_14:
-	case RTL_VER_15:
-	default:
-		/* The bit 0 ~ 7 are relative with teredo settings. They are
-		 * W1C (write 1 to clear), so set all 1 to disable it.
-		 */
-		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, 0xff);
-		break;
-	}
-
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_WDT6_CTRL, WDT6_SET_MODE);
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_REALWOW_TIMER, 0);
-	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TEREDO_TIMER, 0);
-}
-
-static void rtl_reset_bmu(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_BMU_RESET);
-	ocp_data &= ~(BMU_RESET_EP_IN | BMU_RESET_EP_OUT);
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_RESET, ocp_data);
-	ocp_data |= BMU_RESET_EP_IN | BMU_RESET_EP_OUT;
-	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_RESET, ocp_data);
-}
-
-/* Clear the bp to stop the firmware before loading a new one */
-static void rtl_clear_bp(struct r8152 *tp, u16 type)
-{
-	switch (tp->version) {
-	case RTL_VER_01:
-	case RTL_VER_02:
-	case RTL_VER_07:
-		break;
-	case RTL_VER_03:
-	case RTL_VER_04:
-	case RTL_VER_05:
-	case RTL_VER_06:
-		ocp_write_byte(tp, type, PLA_BP_EN, 0);
-		break;
-	case RTL_VER_08:
-	case RTL_VER_09:
-	case RTL_VER_10:
-	case RTL_VER_11:
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_14:
-	case RTL_VER_15:
-	default:
-		if (type == MCU_TYPE_USB) {
-			ocp_write_byte(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
-
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_10, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_11, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_12, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_13, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_14, 0);
-			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_15, 0);
-		} else {
-			ocp_write_byte(tp, MCU_TYPE_PLA, PLA_BP_EN, 0);
-		}
-		break;
-	}
-
-	ocp_write_word(tp, type, PLA_BP_0, 0);
-	ocp_write_word(tp, type, PLA_BP_1, 0);
-	ocp_write_word(tp, type, PLA_BP_2, 0);
-	ocp_write_word(tp, type, PLA_BP_3, 0);
-	ocp_write_word(tp, type, PLA_BP_4, 0);
-	ocp_write_word(tp, type, PLA_BP_5, 0);
-	ocp_write_word(tp, type, PLA_BP_6, 0);
-	ocp_write_word(tp, type, PLA_BP_7, 0);
-
-	/* wait 3 ms to make sure the firmware is stopped */
-	usleep_range(3000, 6000);
-	ocp_write_word(tp, type, PLA_BP_BA, 0);
-}
-
-static int rtl_phy_patch_request(struct r8152 *tp, bool request, bool wait)
-{
-	u16 data, check;
-	int i;
-
-	data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
-	if (request) {
-		data |= PATCH_REQUEST;
-		check = 0;
-	} else {
-		data &= ~PATCH_REQUEST;
-		check = PATCH_READY;
-	}
-	ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
-
-	for (i = 0; wait && i < 5000; i++) {
-		u32 ocp_data;
-
-		usleep_range(1000, 2000);
-		ocp_data = ocp_reg_read(tp, OCP_PHY_PATCH_STAT);
-		if ((ocp_data & PATCH_READY) ^ check)
-			break;
-	}
-
-	if (request && wait &&
-	    !(ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)) {
-		dev_err(&tp->intf->dev, "PHY patch request fail\n");
-		rtl_phy_patch_request(tp, false, false);
-		return -ETIME;
-	} else {
-		return 0;
-	}
-}
-
-static void rtl_patch_key_set(struct r8152 *tp, u16 key_addr, u16 patch_key)
-{
-	if (patch_key && key_addr) {
-		sram_write(tp, key_addr, patch_key);
-		sram_write(tp, SRAM_PHY_LOCK, PHY_PATCH_LOCK);
-	} else if (key_addr) {
-		u16 data;
-
-		sram_write(tp, 0x0000, 0x0000);
-
-		data = ocp_reg_read(tp, OCP_PHY_LOCK);
-		data &= ~PATCH_LOCK;
-		ocp_reg_write(tp, OCP_PHY_LOCK, data);
-
-		sram_write(tp, key_addr, 0x0000);
-	} else {
-		WARN_ON_ONCE(1);
-	}
-}
-
-static int
-rtl_pre_ram_code(struct r8152 *tp, u16 key_addr, u16 patch_key, bool wait)
-{
-	if (rtl_phy_patch_request(tp, true, wait))
-		return -ETIME;
-
-	rtl_patch_key_set(tp, key_addr, patch_key);
-
-	return 0;
-}
-
-static int rtl_post_ram_code(struct r8152 *tp, u16 key_addr, bool wait)
-{
-	rtl_patch_key_set(tp, key_addr, 0);
-
-	rtl_phy_patch_request(tp, false, wait);
-
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
-
-	return 0;
-}
-
-static bool rtl8152_is_fw_phy_speed_up_ok(struct r8152 *tp, struct fw_phy_speed_up *phy)
-{
-	u16 fw_offset;
-	u32 length;
-	bool rc = false;
-
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
-
-	fw_offset = __le16_to_cpu(phy->fw_offset);
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	if (fw_offset < sizeof(*phy) || length <= fw_offset) {
-		dev_err(&tp->intf->dev, "invalid fw_offset\n");
-		goto out;
-	}
-
-	length -= fw_offset;
-	if (length & 3) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(phy->fw_reg) != 0x9A00) {
-		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
-		goto out;
-	}
-
-	rc = true;
-out:
-	return rc;
-}
-
-static bool rtl8152_is_fw_phy_ver_ok(struct r8152 *tp, struct fw_phy_ver *ver)
-{
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
-	}
-
-	if (__le32_to_cpu(ver->blk_hdr.length) != sizeof(*ver)) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(ver->ver.addr) != SRAM_GPHY_FW_VER) {
-		dev_err(&tp->intf->dev, "invalid phy ver addr\n");
-		goto out;
-	}
-
-	rc = true;
-out:
-	return rc;
-}
-
-static bool rtl8152_is_fw_phy_fixup_ok(struct r8152 *tp, struct fw_phy_fixup *fix)
-{
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
-	}
-
-	if (__le32_to_cpu(fix->blk_hdr.length) != sizeof(*fix)) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(fix->setting.addr) != OCP_PHY_PATCH_CMD ||
-	    __le16_to_cpu(fix->setting.data) != BIT(7)) {
-		dev_err(&tp->intf->dev, "invalid phy fixup\n");
-		goto out;
-	}
-
-	rc = true;
-out:
-	return rc;
-}
-
-static bool rtl8152_is_fw_phy_union_ok(struct r8152 *tp, struct fw_phy_union *phy)
-{
-	u16 fw_offset;
-	u32 length;
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
-	}
-
-	fw_offset = __le16_to_cpu(phy->fw_offset);
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	if (fw_offset < sizeof(*phy) || length <= fw_offset) {
-		dev_err(&tp->intf->dev, "invalid fw_offset\n");
-		goto out;
-	}
-
-	length -= fw_offset;
-	if (length & 1) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
-
-	if (phy->pre_num > 2) {
-		dev_err(&tp->intf->dev, "invalid pre_num %d\n", phy->pre_num);
-		goto out;
-	}
-
-	if (phy->bp_num > 8) {
-		dev_err(&tp->intf->dev, "invalid bp_num %d\n", phy->bp_num);
-		goto out;
-	}
-
-	rc = true;
-out:
-	return rc;
-}
-
-static bool rtl8152_is_fw_phy_nc_ok(struct r8152 *tp, struct fw_phy_nc *phy)
-{
-	u32 length;
-	u16 fw_offset, fw_reg, ba_reg, patch_en_addr, mode_reg, bp_start;
-	bool rc = false;
-
-	switch (tp->version) {
-	case RTL_VER_04:
-	case RTL_VER_05:
-	case RTL_VER_06:
-		fw_reg = 0xa014;
-		ba_reg = 0xa012;
-		patch_en_addr = 0xa01a;
-		mode_reg = 0xb820;
-		bp_start = 0xa000;
-		break;
-	default:
-		goto out;
-	}
-
-	fw_offset = __le16_to_cpu(phy->fw_offset);
-	if (fw_offset < sizeof(*phy)) {
-		dev_err(&tp->intf->dev, "fw_offset too small\n");
-		goto out;
-	}
-
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	if (length < fw_offset) {
-		dev_err(&tp->intf->dev, "invalid fw_offset\n");
-		goto out;
-	}
-
-	length -= __le16_to_cpu(phy->fw_offset);
-	if (!length || (length & 1)) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(phy->fw_reg) != fw_reg) {
-		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(phy->ba_reg) != ba_reg) {
-		dev_err(&tp->intf->dev, "invalid base address register\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(phy->patch_en_addr) != patch_en_addr) {
-		dev_err(&tp->intf->dev,
-			"invalid patch mode enabled register\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(phy->mode_reg) != mode_reg) {
-		dev_err(&tp->intf->dev,
-			"invalid register to switch the mode\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(phy->bp_start) != bp_start) {
-		dev_err(&tp->intf->dev,
-			"invalid start register of break point\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(phy->bp_num) > 4) {
-		dev_err(&tp->intf->dev, "invalid break point number\n");
-		goto out;
-	}
-
-	rc = true;
-out:
-	return rc;
-}
-
-static bool rtl8152_is_fw_mac_ok(struct r8152 *tp, struct fw_mac *mac)
-{
-	u16 fw_reg, bp_ba_addr, bp_en_addr, bp_start, fw_offset;
-	bool rc = false;
-	u32 length, type;
-	int i, max_bp;
-
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
-		case RTL_VER_14:
-		case RTL_VER_15:
-			fw_reg = 0xf800;
-			bp_ba_addr = PLA_BP_BA;
-			bp_en_addr = PLA_BP_EN;
-			bp_start = PLA_BP_0;
-			max_bp = 8;
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
-		}
-	} else {
-		goto out;
-	}
-
-	fw_offset = __le16_to_cpu(mac->fw_offset);
-	if (fw_offset < sizeof(*mac)) {
-		dev_err(&tp->intf->dev, "fw_offset too small\n");
-		goto out;
-	}
-
-	length = __le32_to_cpu(mac->blk_hdr.length);
-	if (length < fw_offset) {
-		dev_err(&tp->intf->dev, "invalid fw_offset\n");
-		goto out;
-	}
-
-	length -= fw_offset;
-	if (length < 4 || (length & 3)) {
-		dev_err(&tp->intf->dev, "invalid block length\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(mac->fw_reg) != fw_reg) {
-		dev_err(&tp->intf->dev, "invalid register to load firmware\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(mac->bp_ba_addr) != bp_ba_addr) {
-		dev_err(&tp->intf->dev, "invalid base address register\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(mac->bp_en_addr) != bp_en_addr) {
-		dev_err(&tp->intf->dev, "invalid enabled mask register\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(mac->bp_start) != bp_start) {
-		dev_err(&tp->intf->dev,
-			"invalid start register of break point\n");
-		goto out;
-	}
-
-	if (__le16_to_cpu(mac->bp_num) > max_bp) {
-		dev_err(&tp->intf->dev, "invalid break point number\n");
-		goto out;
-	}
-
-	for (i = __le16_to_cpu(mac->bp_num); i < max_bp; i++) {
-		if (mac->bp[i]) {
-			dev_err(&tp->intf->dev, "unused bp%u is not zero\n", i);
-			goto out;
-		}
-	}
-
-	rc = true;
-out:
-	return rc;
-}
-
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
-	}
-
-	if (crypto_shash_digestsize(alg) != sizeof(fw_hdr->checksum)) {
-		rc = -EFAULT;
-		dev_err(&tp->intf->dev, "digestsize incorrect (%u)\n",
-			crypto_shash_digestsize(alg));
-		goto free_shash;
-	}
-
-	len = sizeof(*sdesc) + crypto_shash_descsize(alg);
-	sdesc = kmalloc(len, GFP_KERNEL);
-	if (!sdesc) {
-		rc = -ENOMEM;
-		goto free_shash;
-	}
-	sdesc->tfm = alg;
-
-	len = size - sizeof(fw_hdr->checksum);
-	rc = crypto_shash_digest(sdesc, fw_hdr->version, len, checksum);
-	kfree(sdesc);
-	if (rc)
-		goto free_shash;
-
-	if (memcmp(fw_hdr->checksum, checksum, sizeof(fw_hdr->checksum))) {
-		dev_err(&tp->intf->dev, "checksum fail\n");
-		rc = -EFAULT;
-	}
-
-free_shash:
-	crypto_free_shash(alg);
-out:
-	return rc;
-}
-
-static long rtl8152_check_firmware(struct r8152 *tp, struct rtl_fw *rtl_fw)
-{
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
-
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
-
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
-
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
-
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
-
-			if (test_bit(FW_FLAGS_NC, &fw_flags)) {
-				dev_err(&tp->intf->dev,
-					"multiple PHY NC encountered\n");
-				goto fail;
-			}
-
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
-
-			if (test_bit(FW_FLAGS_NC, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY_UNION_NC encountered\n");
-				goto fail;
-			}
-
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
-
-			if (test_bit(FW_FLAGS_NC1, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY NC1 encountered\n");
-				goto fail;
-			}
-
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
-
-			if (test_bit(FW_FLAGS_NC2, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY NC2 encountered\n");
-				goto fail;
-			}
-
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
-
-			if (test_bit(FW_FLAGS_UC2, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY UC2 encountered\n");
-				goto fail;
-			}
-
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
-
-			if (test_bit(FW_FLAGS_UC, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY UC encountered\n");
-				goto fail;
-			}
-
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
-
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
-
-			if (test_bit(FW_FLAGS_VER, &fw_flags)) {
-				dev_err(&tp->intf->dev, "multiple PHY version encountered");
-				goto fail;
-			}
-
-			if (!rtl8152_is_fw_phy_ver_ok(tp, (struct fw_phy_ver *)block)) {
-				dev_err(&tp->intf->dev, "check PHY version failed\n");
-				goto fail;
-			}
-			__set_bit(FW_FLAGS_VER, &fw_flags);
-			break;
-		default:
-			dev_warn(&tp->intf->dev, "Unknown type %u is found\n",
-				 type);
-			break;
-		}
-
-		/* next block */
-		i += ALIGN(__le32_to_cpu(block->length), 8);
-	}
-
-fw_end:
-	if (test_bit(FW_FLAGS_START, &fw_flags) && !test_bit(FW_FLAGS_STOP, &fw_flags)) {
-		dev_err(&tp->intf->dev, "without PHY_STOP\n");
-		goto fail;
-	}
-
-	return 0;
-fail:
-	return ret;
-}
-
-static void rtl_ram_code_speed_up(struct r8152 *tp, struct fw_phy_speed_up *phy, bool wait)
-{
-	u32 len;
-	u8 *data;
-
-	if (sram_read(tp, SRAM_GPHY_FW_VER) >= __le16_to_cpu(phy->version)) {
-		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
-		return;
-	}
-
-	len = __le32_to_cpu(phy->blk_hdr.length);
-	len -= __le16_to_cpu(phy->fw_offset);
-	data = (u8 *)phy + __le16_to_cpu(phy->fw_offset);
-
-	if (rtl_phy_patch_request(tp, true, wait))
-		return;
-
-	while (len) {
-		u32 ocp_data, size;
-		int i;
-
-		if (len < 2048)
-			size = len;
-		else
-			size = 2048;
-
-		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL);
-		ocp_data |= GPHY_PATCH_DONE | BACKUP_RESTRORE;
-		ocp_write_word(tp, MCU_TYPE_USB, USB_GPHY_CTRL, ocp_data);
-
-		generic_ocp_write(tp, __le16_to_cpu(phy->fw_reg), 0xff, size, data, MCU_TYPE_USB);
-
-		data += size;
-		len -= size;
-
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL);
-		ocp_data |= POL_GPHY_PATCH;
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL, ocp_data);
-
-		for (i = 0; i < 1000; i++) {
-			if (!(ocp_read_word(tp, MCU_TYPE_PLA, PLA_POL_GPIO_CTRL) & POL_GPHY_PATCH))
-				break;
-		}
-
-		if (i == 1000) {
-			dev_err(&tp->intf->dev, "ram code speedup mode timeout\n");
-			break;
-		}
-	}
-
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_OCP_GPHY_BASE, tp->ocp_base);
-	rtl_phy_patch_request(tp, false, wait);
-
-	if (sram_read(tp, SRAM_GPHY_FW_VER) == __le16_to_cpu(phy->version))
-		dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
-	else
-		dev_err(&tp->intf->dev, "ram code speedup mode fail\n");
-}
-
-static int rtl8152_fw_phy_ver(struct r8152 *tp, struct fw_phy_ver *phy_ver)
-{
-	u16 ver_addr, ver;
-
-	ver_addr = __le16_to_cpu(phy_ver->ver.addr);
-	ver = __le16_to_cpu(phy_ver->ver.data);
-
-	if (sram_read(tp, ver_addr) >= ver) {
-		dev_dbg(&tp->intf->dev, "PHY firmware has been the newest\n");
-		return 0;
-	}
-
-	sram_write(tp, ver_addr, ver);
-
-	dev_dbg(&tp->intf->dev, "PHY firmware version %x\n", ver);
-
-	return ver;
-}
-
-static void rtl8152_fw_phy_fixup(struct r8152 *tp, struct fw_phy_fixup *fix)
-{
-	u16 addr, data;
-
-	addr = __le16_to_cpu(fix->setting.addr);
-	data = ocp_reg_read(tp, addr);
-
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
-
-	ocp_reg_write(tp, addr, data);
-
-	dev_dbg(&tp->intf->dev, "applied ocp %x %x\n", addr, data);
-}
-
-static void rtl8152_fw_phy_union_apply(struct r8152 *tp, struct fw_phy_union *phy)
-{
-	__le16 *data;
-	u32 length;
-	int i, num;
-
-	num = phy->pre_num;
-	for (i = 0; i < num; i++)
-		sram_write(tp, __le16_to_cpu(phy->pre_set[i].addr),
-			   __le16_to_cpu(phy->pre_set[i].data));
-
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	length -= __le16_to_cpu(phy->fw_offset);
-	num = length / 2;
-	data = (__le16 *)((u8 *)phy + __le16_to_cpu(phy->fw_offset));
-
-	ocp_reg_write(tp, OCP_SRAM_ADDR, __le16_to_cpu(phy->fw_reg));
-	for (i = 0; i < num; i++)
-		ocp_reg_write(tp, OCP_SRAM_DATA, __le16_to_cpu(data[i]));
-
-	num = phy->bp_num;
-	for (i = 0; i < num; i++)
-		sram_write(tp, __le16_to_cpu(phy->bp[i].addr), __le16_to_cpu(phy->bp[i].data));
-
-	if (phy->bp_num && phy->bp_en.addr)
-		sram_write(tp, __le16_to_cpu(phy->bp_en.addr), __le16_to_cpu(phy->bp_en.data));
-
-	dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
+			r8153b_u1u2en(tp, true);
+	}
 }
 
-static void rtl8152_fw_phy_nc_apply(struct r8152 *tp, struct fw_phy_nc *phy)
+static void rtl8153c_runtime_enable(struct r8152 *tp, bool enable)
 {
-	u16 mode_reg, bp_index;
-	u32 length, i, num;
-	__le16 *data;
-
-	mode_reg = __le16_to_cpu(phy->mode_reg);
-	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_pre));
-	sram_write(tp, __le16_to_cpu(phy->ba_reg),
-		   __le16_to_cpu(phy->ba_data));
-
-	length = __le32_to_cpu(phy->blk_hdr.length);
-	length -= __le16_to_cpu(phy->fw_offset);
-	num = length / 2;
-	data = (__le16 *)((u8 *)phy + __le16_to_cpu(phy->fw_offset));
-
-	ocp_reg_write(tp, OCP_SRAM_ADDR, __le16_to_cpu(phy->fw_reg));
-	for (i = 0; i < num; i++)
-		ocp_reg_write(tp, OCP_SRAM_DATA, __le16_to_cpu(data[i]));
-
-	sram_write(tp, __le16_to_cpu(phy->patch_en_addr),
-		   __le16_to_cpu(phy->patch_en_value));
-
-	bp_index = __le16_to_cpu(phy->bp_start);
-	num = __le16_to_cpu(phy->bp_num);
-	for (i = 0; i < num; i++) {
-		sram_write(tp, bp_index, __le16_to_cpu(phy->bp[i]));
-		bp_index += 2;
+	if (enable) {
+		r8153_queue_wake(tp, true);
+		r8153b_u1u2en(tp, false);
+		r8153_u2p3en(tp, false);
+		rtl_runtime_suspend_enable(tp, true);
+		r8153c_ups_en(tp, true);
+	} else {
+		r8153c_ups_en(tp, false);
+		r8153_queue_wake(tp, false);
+		rtl_runtime_suspend_enable(tp, false);
+		r8153b_u1u2en(tp, true);
 	}
-
-	sram_write(tp, mode_reg, __le16_to_cpu(phy->mode_post));
-
-	dev_dbg(&tp->intf->dev, "successfully applied %s\n", phy->info);
 }
 
-static void rtl8152_fw_mac_apply(struct r8152 *tp, struct fw_mac *mac)
+static void rtl8156_runtime_enable(struct r8152 *tp, bool enable)
 {
-	u16 bp_en_addr, bp_index, type, bp_num, fw_ver_reg;
-	u32 length;
-	u8 *data;
-	int i;
-
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
-
-	fw_ver_reg = __le16_to_cpu(mac->fw_ver_reg);
-	if (fw_ver_reg && ocp_read_byte(tp, MCU_TYPE_USB, fw_ver_reg) >= mac->fw_ver_data) {
-		dev_dbg(&tp->intf->dev, "%s firmware has been the newest\n", type ? "PLA" : "USB");
-		return;
-	}
-
-	rtl_clear_bp(tp, type);
-
-	/* Enable backup/restore of MACDBG. This is required after clearing PLA
-	 * break points and before applying the PLA firmware.
-	 */
-	if (tp->version == RTL_VER_04 && type == MCU_TYPE_PLA &&
-	    !(ocp_read_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST) & DEBUG_OE)) {
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_PRE, DEBUG_LTSSM);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_MACDBG_POST, DEBUG_LTSSM);
-	}
-
-	length = __le32_to_cpu(mac->blk_hdr.length);
-	length -= __le16_to_cpu(mac->fw_offset);
-
-	data = (u8 *)mac;
-	data += __le16_to_cpu(mac->fw_offset);
-
-	generic_ocp_write(tp, __le16_to_cpu(mac->fw_reg), 0xff, length, data,
-			  type);
-
-	ocp_write_word(tp, type, __le16_to_cpu(mac->bp_ba_addr),
-		       __le16_to_cpu(mac->bp_ba_value));
-
-	bp_index = __le16_to_cpu(mac->bp_start);
-	bp_num = __le16_to_cpu(mac->bp_num);
-	for (i = 0; i < bp_num; i++) {
-		ocp_write_word(tp, type, bp_index, __le16_to_cpu(mac->bp[i]));
-		bp_index += 2;
+	if (enable) {
+		r8153_queue_wake(tp, true);
+		r8153b_u1u2en(tp, false);
+		r8153_u2p3en(tp, false);
+		rtl_runtime_suspend_enable(tp, true);
+	} else {
+		r8153_queue_wake(tp, false);
+		rtl_runtime_suspend_enable(tp, false);
+		r8153_u2p3en(tp, true);
+		if (tp->udev->speed >= USB_SPEED_SUPER)
+			r8153b_u1u2en(tp, true);
 	}
-
-	bp_en_addr = __le16_to_cpu(mac->bp_en_addr);
-	if (bp_en_addr)
-		ocp_write_word(tp, type, bp_en_addr,
-			       __le16_to_cpu(mac->bp_en_value));
-
-	if (fw_ver_reg)
-		ocp_write_byte(tp, MCU_TYPE_USB, fw_ver_reg,
-			       mac->fw_ver_data);
-
-	dev_dbg(&tp->intf->dev, "successfully applied %s\n", mac->info);
 }
 
-static void rtl8152_apply_firmware(struct r8152 *tp, bool power_cut)
+static void r8153_teredo_off(struct r8152 *tp)
 {
-	struct rtl_fw *rtl_fw = &tp->rtl_fw;
-	const struct firmware *fw;
-	struct fw_header *fw_hdr;
-	struct fw_phy_patch_key *key;
-	u16 key_addr = 0;
-	int i, patch_phy = 1;
-
-	if (IS_ERR_OR_NULL(rtl_fw->fw))
-		return;
-
-	fw = rtl_fw->fw;
-	fw_hdr = (struct fw_header *)fw->data;
-
-	if (rtl_fw->pre_fw)
-		rtl_fw->pre_fw(tp);
-
-	for (i = offsetof(struct fw_header, blocks); i < fw->size;) {
-		struct fw_block *block = (struct fw_block *)&fw->data[i];
+	u32 ocp_data;
 
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
+	switch (tp->version) {
+	case RTL_VER_01:
+	case RTL_VER_02:
+	case RTL_VER_03:
+	case RTL_VER_04:
+	case RTL_VER_05:
+	case RTL_VER_06:
+	case RTL_VER_07:
+		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG);
+		ocp_data &= ~(TEREDO_SEL | TEREDO_RS_EVENT_MASK |
+			      OOB_TEREDO_EN);
+		ocp_write_word(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, ocp_data);
+		break;
 
-		i += ALIGN(__le32_to_cpu(block->length), 8);
+	case RTL_VER_08:
+	case RTL_VER_09:
+	case RTL_TEST_01:
+	case RTL_VER_10:
+	case RTL_VER_11:
+	case RTL_VER_12:
+	case RTL_VER_13:
+	case RTL_VER_14:
+	case RTL_VER_15:
+	default:
+		/* The bit 0 ~ 7 are relative with teredo settings. They are
+		 * W1C (write 1 to clear), so set all 1 to disable it.
+		 */
+		ocp_write_byte(tp, MCU_TYPE_PLA, PLA_TEREDO_CFG, 0xff);
+		break;
 	}
 
-post_fw:
-	if (rtl_fw->post_fw)
-		rtl_fw->post_fw(tp);
-
-	strscpy(rtl_fw->version, fw_hdr->version, RTL_VER_SIZE);
-	dev_info(&tp->intf->dev, "load %s successfully\n", rtl_fw->version);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_WDT6_CTRL, WDT6_SET_MODE);
+	ocp_write_word(tp, MCU_TYPE_PLA, PLA_REALWOW_TIMER, 0);
+	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_TEREDO_TIMER, 0);
 }
 
-static void rtl8152_release_firmware(struct r8152 *tp)
+static void rtl_reset_bmu(struct r8152 *tp)
 {
-	struct rtl_fw *rtl_fw = &tp->rtl_fw;
+	u32 ocp_data;
 
-	if (!IS_ERR_OR_NULL(rtl_fw->fw)) {
-		release_firmware(rtl_fw->fw);
-		rtl_fw->fw = NULL;
-	}
+	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_BMU_RESET);
+	ocp_data &= ~(BMU_RESET_EP_IN | BMU_RESET_EP_OUT);
+	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_RESET, ocp_data);
+	ocp_data |= BMU_RESET_EP_IN | BMU_RESET_EP_OUT;
+	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_RESET, ocp_data);
 }
 
-static int rtl8152_request_firmware(struct r8152 *tp)
+int rtl_phy_patch_request(struct r8152 *tp, bool request, bool wait)
 {
-	struct rtl_fw *rtl_fw = &tp->rtl_fw;
-	long rc;
+	u16 data, check;
+	int i;
 
-	if (rtl_fw->fw || !rtl_fw->fw_name) {
-		dev_info(&tp->intf->dev, "skip request firmware\n");
-		rc = 0;
-		goto result;
+	data = ocp_reg_read(tp, OCP_PHY_PATCH_CMD);
+	if (request) {
+		data |= PATCH_REQUEST;
+		check = 0;
+	} else {
+		data &= ~PATCH_REQUEST;
+		check = PATCH_READY;
 	}
+	ocp_reg_write(tp, OCP_PHY_PATCH_CMD, data);
 
-	rc = request_firmware(&rtl_fw->fw, rtl_fw->fw_name, &tp->intf->dev);
-	if (rc < 0)
-		goto result;
-
-	rc = rtl8152_check_firmware(tp, rtl_fw);
-	if (rc < 0)
-		release_firmware(rtl_fw->fw);
-
-result:
-	if (rc) {
-		rtl_fw->fw = ERR_PTR(rc);
+	for (i = 0; wait && i < 5000; i++) {
+		u32 ocp_data;
 
-		dev_warn(&tp->intf->dev,
-			 "unable to load firmware patch %s (%ld)\n",
-			 rtl_fw->fw_name, rc);
+		usleep_range(1000, 2000);
+		ocp_data = ocp_reg_read(tp, OCP_PHY_PATCH_STAT);
+		if ((ocp_data & PATCH_READY) ^ check)
+			break;
 	}
 
-	return rc;
+	if (request && wait &&
+	    !(ocp_reg_read(tp, OCP_PHY_PATCH_STAT) & PATCH_READY)) {
+		dev_err(&tp->intf->dev, "PHY patch request fail\n");
+		rtl_phy_patch_request(tp, false, false);
+		return -ETIME;
+	} else {
+		return 0;
+	}
 }
 
 static void r8152_aldps_en(struct r8152 *tp, bool enable)
@@ -5441,156 +3268,6 @@ static void r8152b_enter_oob(struct r8152 *tp)
 	ocp_write_dword(tp, MCU_TYPE_PLA, PLA_RCR, ocp_data);
 }
 
-static int r8153_pre_firmware_1(struct r8152 *tp)
-{
-	int i;
-
-	/* Wait till the WTD timer is ready. It would take at most 104 ms. */
-	for (i = 0; i < 104; i++) {
-		u32 ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_WDT1_CTRL);
-
-		if (!(ocp_data & WTD1_EN))
-			break;
-		usleep_range(1000, 2000);
-	}
-
-	return 0;
-}
-
-static int r8153_post_firmware_1(struct r8152 *tp)
-{
-	/* set USB_BP_4 to support USB_SPEED_SUPER only */
-	if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER)
-		ocp_write_word(tp, MCU_TYPE_USB, USB_BP_4, BP4_SUPER_ONLY);
-
-	/* reset UPHY timer to 36 ms */
-	ocp_write_word(tp, MCU_TYPE_PLA, PLA_UPHY_TIMER, 36000 / 16);
-
-	return 0;
-}
-
-static int r8153_pre_firmware_2(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	r8153_pre_firmware_1(tp);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0);
-	ocp_data &= ~FW_FIX_SUSPEND;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN0, ocp_data);
-
-	return 0;
-}
-
-static int r8153_post_firmware_2(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	/* enable bp0 if support USB_SPEED_SUPER only */
-	if (ocp_read_byte(tp, MCU_TYPE_USB, USB_CSTMR) & FORCE_SUPER) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
-		ocp_data |= BIT(0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
-	}
-
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
-}
-
-static int r8153b_pre_firmware_1(struct r8152 *tp)
-{
-	/* enable fc timer and set timer to 1 second. */
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FC_TIMER,
-		       CTRL_TIMER_EN | (1000 / 8));
-
-	return 0;
-}
-
-static int r8153b_post_firmware_1(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	/* enable bp0 for RTL8153-BND */
-	ocp_data = ocp_read_byte(tp, MCU_TYPE_USB, USB_MISC_1);
-	if (ocp_data & BND_MASK) {
-		ocp_data = ocp_read_word(tp, MCU_TYPE_PLA, PLA_BP_EN);
-		ocp_data |= BIT(0);
-		ocp_write_word(tp, MCU_TYPE_PLA, PLA_BP_EN, ocp_data);
-	}
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
-	ocp_data |= FLOW_CTRL_PATCH_OPT;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
-	ocp_data |= FC_PATCH_TASK;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
-	ocp_data |= FW_IP_RESET_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
-
-	return 0;
-}
-
-static int r8153c_post_firmware_1(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_CTRL);
-	ocp_data |= FLOW_CTRL_PATCH_2;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_CTRL, ocp_data);
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
-	ocp_data |= FC_PATCH_TASK;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
-
-	return 0;
-}
-
-static int r8156a_post_firmware_1(struct r8152 *tp)
-{
-	u32 ocp_data;
-
-	ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1);
-	ocp_data |= FW_IP_RESET_EN;
-	ocp_write_word(tp, MCU_TYPE_USB, USB_FW_FIX_EN1, ocp_data);
-
-	/* Modify U3PHY parameter for compatibility issue */
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPHY3_MDCMDIO, 0x4026840e);
-	ocp_write_dword(tp, MCU_TYPE_USB, USB_UPHY3_MDCMDIO, 0x4001acc9);
-
-	return 0;
-}
-
 static void r8153_aldps_en(struct r8152 *tp, bool enable)
 {
 	u16 data;
@@ -7283,6 +4960,7 @@ static void r8156_hw_phy_cfg(struct r8152 *tp)
 		ocp_reg_write(tp, 0xbd2c, data);
 		break;
 	case RTL_VER_11:
+		/* 2.5G INRX */
 		data = ocp_reg_read(tp, 0xad16);
 		data |= 0x3ff;
 		ocp_reg_write(tp, 0xad16, data);
@@ -8226,7 +5904,7 @@ static int rtl8152_post_reset(struct usb_interface *intf)
 	/* reset the MAC address in case of policy change */
 	if (determine_ethernet_addr(tp, &sa) >= 0) {
 		rtnl_lock();
-		dev_set_mac_address (tp->netdev, &sa, NULL);
+		dev_set_mac_address(tp->netdev, &sa, NULL);
 		rtnl_unlock();
 	}
 
@@ -9347,14 +7025,6 @@ static int rtl_ops_init(struct r8152 *tp)
 	return ret;
 }
 
-#define FIRMWARE_8153A_2	"rtl_nic/rtl8153a-2.fw"
-#define FIRMWARE_8153A_3	"rtl_nic/rtl8153a-3.fw"
-#define FIRMWARE_8153A_4	"rtl_nic/rtl8153a-4.fw"
-#define FIRMWARE_8153B_2	"rtl_nic/rtl8153b-2.fw"
-#define FIRMWARE_8153C_1	"rtl_nic/rtl8153c-1.fw"
-#define FIRMWARE_8156A_2	"rtl_nic/rtl8156a-2.fw"
-#define FIRMWARE_8156B_2	"rtl_nic/rtl8156b-2.fw"
-
 MODULE_FIRMWARE(FIRMWARE_8153A_2);
 MODULE_FIRMWARE(FIRMWARE_8153A_3);
 MODULE_FIRMWARE(FIRMWARE_8153A_4);
@@ -9363,50 +7033,6 @@ MODULE_FIRMWARE(FIRMWARE_8153C_1);
 MODULE_FIRMWARE(FIRMWARE_8156A_2);
 MODULE_FIRMWARE(FIRMWARE_8156B_2);
 
-static int rtl_fw_init(struct r8152 *tp)
-{
-	struct rtl_fw *rtl_fw = &tp->rtl_fw;
-
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
-	}
-
-	return 0;
-}
-
 u8 rtl8152_get_version(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-- 
2.31.1

