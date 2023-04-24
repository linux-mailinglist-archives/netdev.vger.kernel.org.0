Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8126D87C7
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 22:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbjDEUIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 16:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbjDEUHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 16:07:47 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7B24C21;
        Wed,  5 Apr 2023 13:07:41 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-4fa3ca41384so679766a12.2;
        Wed, 05 Apr 2023 13:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680725259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJkzZyW368OF5IzauI/80LW/g39kx0Cr+Psuc4Tf5mI=;
        b=hAhTyalBg7pXsorvMHR7RRxwMOe7unuI2V6Nj/q/XcBIdNEJuXKY2a/gaw6FSTSZBz
         z1k8XJtCwMc5L+Z0ETsnxLt10peQCiTjeQzAjQvVYOrjT13jp085TkRCsuYo8DeizsAf
         sFGzA2oEl+azFukBb6VRe2gzQzklDn/xXXHa0F4Y1BYjcnej+KBjCfEvfhstQxuvMjVE
         BHaeFetPFlEMW/tVak0q3hEy1UZ+6DGMm1dcRuJNdpziz8UNB4vV6/vY6LlvzPUcpzJ9
         X1Lo5KPjJK6cJh5adB3vXrs0dPoriQlPqf0ijUABWeQzvLgsJFGJGP+CY3V4fVf7yjCs
         Crfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680725259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJkzZyW368OF5IzauI/80LW/g39kx0Cr+Psuc4Tf5mI=;
        b=QNslEcTYqD1kd4FYtBqrSbBWsHYQSuntc6U5l164TdVRjY9IMn7m2DDKnmndGol0QE
         6wJqViJBPCru1VBKJwpJaQoHcXJsy0qjTjiqSHpukY1H9NryMdrMiqtTrEfb0EwrYxki
         wPX8w4VB6wBKMz1cZeF2BBIOSX5YdRP+rsZcU3OSC8ngcvRHg/ueqramwSe5zgS+W8qR
         OX1b+HtI0KJlDpZVmtGcMKyXol2HiDbQ3OpRa70uu+f9fDioidqor0Ef1S11ryPanHpu
         r+/K9gRuE/9LyWlthY50WC4zhOL9w0ztJqaFkcRTG1yaHCtOMiHbs7Jbi2hSw/OmUbIo
         rFvg==
X-Gm-Message-State: AAQBX9eg2dzI2YepXI22CXzI+4ziQnwx9FyW9OMnXyFutTjej7i9Fkoy
        iNmfAcOW8krjLv/u0+SLk5aDYyUxtVCL8Q==
X-Google-Smtp-Source: AKy350YfB2RmuIwW+PoVKgg372VKkuMhnAEqN2HW5TqND/Hzf4Mc7F+vTdfbY9hj8S2ma6NpIOjv8Q==
X-Received: by 2002:aa7:c796:0:b0:500:2cc6:36da with SMTP id n22-20020aa7c796000000b005002cc636damr3297997eds.19.1680725258576;
        Wed, 05 Apr 2023 13:07:38 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7a4e-3100-0000-0000-0000-0e63.c22.pool.telefonica.de. [2a01:c22:7a4e:3100::e63])
        by smtp.googlemail.com with ESMTPSA id a23-20020a170906369700b0092a59ee224csm7724873ejc.185.2023.04.05.13.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 13:07:38 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Morgan <macromorgan@hotmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v5 2/9] wifi: rtw88: sdio: Add HCI implementation for SDIO based chipsets
Date:   Wed,  5 Apr 2023 22:07:22 +0200
Message-Id: <20230405200729.632435-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
References: <20230405200729.632435-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a sub-driver for SDIO based chipsets which implements the following
functionality:
- register accessors for 8, 16 and 32 bits for all states of the card
  (including usage of 4x 8 bit access for one 32 bit buffer if the card
  is not fully powered on yet - or if it's fully powered on then 1x 32
  bit access is used)
- checking whether there's space in the TX FIFO queue to transmit data
- transfers from the host to the device for actual network traffic,
  reserved pages (for firmware download) and H2C (host-to-card)
  transfers
- receiving data from the device
- deep power saving state

The transmit path is optimized so DMA-capable SDIO host controllers can
directly use the buffers provided because the buffer's physical
addresses are 8 byte aligned.

The receive path is prepared to support RX aggregation where the
chipset combines multiple MAC frames into one bigger buffer to reduce
SDIO transfer overhead.

Co-developed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
Changes since v4:
- use reverse xmas tree sorting in various places as suggested by
  Simon Horman
- use simplified return !!(addr & RTW_SDIO_BUS_MSK) statement
- fixed "Informaion" -> "Information" typo as spotted by Simon Horman

Changes since v3:
- consistently use IS_ALIGNED instead of open-coding it
- move rtw_sdio_request_irq() before rtw_register_hw() to fix a
  potential race condition (originally reported on the rtw89 driver,
  but it can also affect rtw88 - at least in theory)
- fix rtw_sdio_free_irq() / module removal by using
  sdio_{claim,release}_host() around sdio_release_irq()
- introduce rtw_sdio_{read,write}w (16 bit) helpers
- fix missing -ETIMEDOUT return in rtw_sdio_read_indirect{8,32}
- don't use indirect access for SDIO 2.0 cards (fixes reading/writing
  registers on RTW_WCPU_11N cards)
- factor out common code from indirect read logic
- add indirect write logic (which was missing before and could have
  caused abnormal IO - thanks to Ping-Ke for clarifying this!)

Changes since v2:
- add sdio.h include in patch 2 already (instead of patch 3) as
  suggested by Larry Finger (thank you!) so the build doesn't break
  during bisect
- move #include "main.h" from sdio.h to sdio.c
- sort includes in sdio.c alphabetically as suggested by Ping-Ke
  (except main.h, which must be included before other rtw88 headers)
- don't use memcpy to copy struct ieee80211_rx_status in
  rtw_sdio_rx_skb() as suggested by Ping-Ke
- prevent infinite looping in rtw_sdio_rx_isr() by limiting the number
  of bytes to process for one interrupt (if more bytes need to be
  received the interrupt will immediately fire again - tested by
  limiting to one transfer, which then hurt RX performance a lot as it
  went down from 19Mbit/s to 0.5Mbit/s). 64k was chosen as it doesn't
  hurt RX performance and still prevents infinite loops
- don't disable RX aggregation for RTL8822CS anymore (either the most
  recent firmware v9.9.14 had some impact on this or an update of my
  main AP's firmware improved this) the RX throughput is within 5%
  regardless of whether RX aggregation is enabled or disabled
- fix suspend/resume cycle by enabling MMC_PM_KEEP_POWER in
  rtw_sdio_suspend() as for example reported by Chris Morgan
- fix smatch false positive "uninitialized symbol 'ret'" in
  rtw_sdio_read_indirect_bytes() by initializing ret to 0 (Ping-Ke
  suggested that it may be because "it considers 'count = 0' is
  possible"). Thanks for the suggestion!

Changes since v1:
- fixed size_t printk format in rtw_sdio_{read,write}_port as reported
  by the Intel kernel test robot
- return -EINVAL from the 11n wcpu case in rtw_sdio_check_free_txpg to
  fix an uninitialized variable (pages_free) warning as reported by
  the Intel kernel test robot
- rename all int *ret to int *err_ret for better consistency with the
  sdio_readX functions as suggested by Ping-Ke
- fix typos to use "if (!*err_ret ..." (to read the error code)
  instead of "if (!err_ret ..." (which just checks if a non-null
  pointer was passed) in rtw_sdio_read_indirect{8,32})
- use a u8 tmp variable for reading the indirect status (BIT(4)) in
  rtw_sdio_read_indirect32
- change buf[0] to buf[i] in rtw_sdio_read_indirect_bytes
- remove stray semicolon after rtw_sdio_get_tx_qsel
- add proper BIT_RXDMA_AGG_PG_TH, BIT_DMA_AGG_TO_V1, BIT_HCI_SUS_REQ,
  BIT_HCI_RESUME_RDY and BIT_SDIO_PAD_E5 macros as suggested by
  Ping-Ke (thanks for sharing these names!)
- use /* ... */ style for copyright comments
- don't infinitely loop in rtw_sdio_process_tx_queue and limit the
  number of skbs to process per queue to 1000 in rtw_sdio_tx_handler
- add bus_claim check to rtw_sdio_read_port() so it works similar to
  rtw_sdio_write_port() (meaning it can be used from interrupt and
  non interrupt context)
- enable RX aggregation on all chips except RTL8822CS (where it hurts
  RX performance)
- use rtw_tx_fill_txdesc_checksum() helper instead of open-coding it
- re-use RTW_FLAG_POWERON instead of a new .power_switch callback
- added Ulf's Reviewed-by (who had a look at the SDIO specific bits,
  thank you!)


 drivers/net/wireless/realtek/rtw88/Kconfig  |    3 +
 drivers/net/wireless/realtek/rtw88/Makefile |    3 +
 drivers/net/wireless/realtek/rtw88/debug.h  |    1 +
 drivers/net/wireless/realtek/rtw88/mac.c    |    1 +
 drivers/net/wireless/realtek/rtw88/mac.h    |    1 -
 drivers/net/wireless/realtek/rtw88/reg.h    |   12 +
 drivers/net/wireless/realtek/rtw88/sdio.c   | 1394 +++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/sdio.h   |  178 +++
 8 files changed, 1592 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/sdio.h

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index 651ab56d9c6b..cdf9cb478ee2 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -16,6 +16,9 @@ config RTW88_CORE
 config RTW88_PCI
 	tristate
 
+config RTW88_SDIO
+	tristate
+
 config RTW88_USB
 	tristate
 
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index fe7293ee87b4..892cad60ba31 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -59,5 +59,8 @@ rtw88_8821cu-objs		:= rtw8821cu.o
 obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
 rtw88_pci-objs			:= pci.o
 
+obj-$(CONFIG_RTW88_SDIO)	+= rtw88_sdio.o
+rtw88_sdio-objs			:= sdio.o
+
 obj-$(CONFIG_RTW88_USB)		+= rtw88_usb.o
 rtw88_usb-objs			:= usb.o
diff --git a/drivers/net/wireless/realtek/rtw88/debug.h b/drivers/net/wireless/realtek/rtw88/debug.h
index 066792dd96af..a9149c6c2b48 100644
--- a/drivers/net/wireless/realtek/rtw88/debug.h
+++ b/drivers/net/wireless/realtek/rtw88/debug.h
@@ -24,6 +24,7 @@ enum rtw_debug_mask {
 	RTW_DBG_ADAPTIVITY	= 0x00008000,
 	RTW_DBG_HW_SCAN		= 0x00010000,
 	RTW_DBG_STATE		= 0x00020000,
+	RTW_DBG_SDIO		= 0x00040000,
 
 	RTW_DBG_ALL		= 0xffffffff
 };
diff --git a/drivers/net/wireless/realtek/rtw88/mac.c b/drivers/net/wireless/realtek/rtw88/mac.c
index cfdfc8a2c836..2fcba43a6f72 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.c
+++ b/drivers/net/wireless/realtek/rtw88/mac.c
@@ -7,6 +7,7 @@
 #include "reg.h"
 #include "fw.h"
 #include "debug.h"
+#include "sdio.h"
 
 void rtw_set_channel_mac(struct rtw_dev *rtwdev, u8 channel, u8 bw,
 			 u8 primary_ch_idx)
diff --git a/drivers/net/wireless/realtek/rtw88/mac.h b/drivers/net/wireless/realtek/rtw88/mac.h
index 3172aa5ac4de..58c3dccc14bb 100644
--- a/drivers/net/wireless/realtek/rtw88/mac.h
+++ b/drivers/net/wireless/realtek/rtw88/mac.h
@@ -7,7 +7,6 @@
 
 #define RTW_HW_PORT_NUM		5
 #define cut_version_to_mask(cut) (0x1 << ((cut) + 1))
-#define SDIO_LOCAL_OFFSET	0x10250000
 #define DDMA_POLLING_COUNT	1000
 #define C2H_PKT_BUF		256
 #define REPORT_BUF		128
diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
index 8852b24d6c2a..2a2ae2081f34 100644
--- a/drivers/net/wireless/realtek/rtw88/reg.h
+++ b/drivers/net/wireless/realtek/rtw88/reg.h
@@ -87,6 +87,7 @@
 #define BIT_LTE_MUX_CTRL_PATH	BIT(26)
 #define REG_HCI_OPT_CTRL	0x0074
 #define BIT_USB_SUS_DIS		BIT(8)
+#define BIT_SDIO_PAD_E5		BIT(18)
 
 #define REG_AFE_CTRL_4		0x0078
 #define BIT_CK320M_AFE_EN	BIT(4)
@@ -185,6 +186,9 @@
 	(((x) & BIT_MASK_TXDMA_VIQ_MAP) << BIT_SHIFT_TXDMA_VIQ_MAP)
 #define REG_TXDMA_PQ_MAP	0x010C
 #define BIT_RXDMA_ARBBW_EN	BIT(0)
+#define BIT_RXSHFT_EN		BIT(1)
+#define BIT_RXDMA_AGG_EN	BIT(2)
+#define BIT_TXDMA_BW_EN		BIT(3)
 #define BIT_SHIFT_TXDMA_BEQ_MAP	8
 #define BIT_MASK_TXDMA_BEQ_MAP	0x3
 #define BIT_TXDMA_BEQ_MAP(x)                                                   \
@@ -283,10 +287,18 @@
 #define REG_H2C_TAIL		0x0248
 #define REG_H2C_READ_ADDR	0x024C
 #define REG_H2C_INFO		0x0254
+#define REG_RXDMA_AGG_PG_TH	0x0280
+#define BIT_RXDMA_AGG_PG_TH	GENMASK(7, 0)
+#define BIT_DMA_AGG_TO_V1	GENMASK(15, 8)
+#define BIT_EN_PRE_CALC		BIT(29)
 #define REG_RXPKT_NUM		0x0284
 #define BIT_RXDMA_REQ		BIT(19)
 #define BIT_RW_RELEASE		BIT(18)
 #define BIT_RXDMA_IDLE		BIT(17)
+#define REG_RXDMA_STATUS	0x0288
+#define REG_RXDMA_DPR		0x028C
+#define REG_RXDMA_MODE		0x0290
+#define BIT_DMA_MODE		BIT(1)
 #define REG_RXPKTNUM		0x02B0
 
 #define REG_INT_MIG		0x0304
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
new file mode 100644
index 000000000000..af0459a79899
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -0,0 +1,1394 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright (C) 2021 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+ * Copyright (C) 2021 Jernej Skrabec <jernej.skrabec@gmail.com>
+ *
+ * Based on rtw88/pci.c:
+ *   Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio_func.h>
+#include "main.h"
+#include "debug.h"
+#include "fw.h"
+#include "ps.h"
+#include "reg.h"
+#include "rx.h"
+#include "sdio.h"
+#include "tx.h"
+
+#define RTW_SDIO_INDIRECT_RW_RETRIES			50
+
+static bool rtw_sdio_is_bus_addr(u32 addr)
+{
+	return !!(addr & RTW_SDIO_BUS_MSK);
+}
+
+static bool rtw_sdio_bus_claim_needed(struct rtw_sdio *rtwsdio)
+{
+	return !rtwsdio->irq_thread ||
+	       rtwsdio->irq_thread != current;
+}
+
+static u32 rtw_sdio_to_bus_offset(struct rtw_dev *rtwdev, u32 addr)
+{
+	switch (addr & RTW_SDIO_BUS_MSK) {
+	case WLAN_IOREG_OFFSET:
+		addr &= WLAN_IOREG_REG_MSK;
+		addr |= FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+				   REG_SDIO_CMD_ADDR_MAC_REG);
+		break;
+	case SDIO_LOCAL_OFFSET:
+		addr &= SDIO_LOCAL_REG_MSK;
+		addr |= FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+				   REG_SDIO_CMD_ADDR_SDIO_REG);
+		break;
+	default:
+		rtw_warn(rtwdev, "Cannot convert addr 0x%08x to bus offset",
+			 addr);
+	}
+
+	return addr;
+}
+
+static bool rtw_sdio_use_memcpy_io(struct rtw_dev *rtwdev, u32 addr,
+				   u8 alignment)
+{
+	return IS_ALIGNED(addr, alignment) &&
+	       test_bit(RTW_FLAG_POWERON, rtwdev->flags);
+}
+
+static void rtw_sdio_writel(struct rtw_dev *rtwdev, u32 val, u32 addr,
+			    int *err_ret)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	u8 buf[4];
+	int i;
+
+	if (rtw_sdio_use_memcpy_io(rtwdev, addr, 4)) {
+		sdio_writel(rtwsdio->sdio_func, val, addr, err_ret);
+		return;
+	}
+
+	*(__le32 *)buf = cpu_to_le32(val);
+
+	for (i = 0; i < 4; i++) {
+		sdio_writeb(rtwsdio->sdio_func, buf[i], addr + i, err_ret);
+		if (*err_ret)
+			return;
+	}
+}
+
+static void rtw_sdio_writew(struct rtw_dev *rtwdev, u16 val, u32 addr,
+			    int *err_ret)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	u8 buf[2];
+	int i;
+
+	if (rtw_sdio_use_memcpy_io(rtwdev, addr, 2)) {
+		sdio_writew(rtwsdio->sdio_func, val, addr, err_ret);
+		return;
+	}
+
+	*(__le16 *)buf = cpu_to_le16(val);
+
+	for (i = 0; i < 2; i++) {
+		sdio_writeb(rtwsdio->sdio_func, buf[i], addr + i, err_ret);
+		if (*err_ret)
+			return;
+	}
+}
+
+static u32 rtw_sdio_readl(struct rtw_dev *rtwdev, u32 addr, int *err_ret)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	u8 buf[4];
+	int i;
+
+	if (rtw_sdio_use_memcpy_io(rtwdev, addr, 4))
+		return sdio_readl(rtwsdio->sdio_func, addr, err_ret);
+
+	for (i = 0; i < 4; i++) {
+		buf[i] = sdio_readb(rtwsdio->sdio_func, addr + i, err_ret);
+		if (*err_ret)
+			return 0;
+	}
+
+	return le32_to_cpu(*(__le32 *)buf);
+}
+
+static u16 rtw_sdio_readw(struct rtw_dev *rtwdev, u32 addr, int *err_ret)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	u8 buf[2];
+	int i;
+
+	if (rtw_sdio_use_memcpy_io(rtwdev, addr, 2))
+		return sdio_readw(rtwsdio->sdio_func, addr, err_ret);
+
+	for (i = 0; i < 2; i++) {
+		buf[i] = sdio_readb(rtwsdio->sdio_func, addr + i, err_ret);
+		if (*err_ret)
+			return 0;
+	}
+
+	return le16_to_cpu(*(__le16 *)buf);
+}
+
+static u32 rtw_sdio_to_io_address(struct rtw_dev *rtwdev, u32 addr,
+				  bool direct)
+{
+	if (!direct)
+		return addr;
+
+	if (!rtw_sdio_is_bus_addr(addr))
+		addr |= WLAN_IOREG_OFFSET;
+
+	return rtw_sdio_to_bus_offset(rtwdev, addr);
+}
+
+static bool rtw_sdio_use_direct_io(struct rtw_dev *rtwdev, u32 addr)
+{
+	return !rtw_sdio_is_sdio30_supported(rtwdev) ||
+		rtw_sdio_is_bus_addr(addr);
+}
+
+static int rtw_sdio_indirect_reg_cfg(struct rtw_dev *rtwdev, u32 addr, u32 cfg)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	unsigned int retry;
+	u32 reg_cfg;
+	int ret;
+	u8 tmp;
+
+	reg_cfg = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_CFG);
+
+	rtw_sdio_writel(rtwdev, addr | cfg | BIT_SDIO_INDIRECT_REG_CFG_UNK20,
+			reg_cfg, &ret);
+	if (ret)
+		return ret;
+
+	for (retry = 0; retry < RTW_SDIO_INDIRECT_RW_RETRIES; retry++) {
+		tmp = sdio_readb(rtwsdio->sdio_func, reg_cfg + 2, &ret);
+		if (!ret && (tmp & BIT(4)))
+			return 0;
+	}
+
+	return -ETIMEDOUT;
+}
+
+static u8 rtw_sdio_indirect_read8(struct rtw_dev *rtwdev, u32 addr,
+				  int *err_ret)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	u32 reg_data;
+
+	*err_ret = rtw_sdio_indirect_reg_cfg(rtwdev, addr,
+					     BIT_SDIO_INDIRECT_REG_CFG_READ);
+	if (*err_ret)
+		return 0;
+
+	reg_data = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_DATA);
+	return sdio_readb(rtwsdio->sdio_func, reg_data, err_ret);
+}
+
+static int rtw_sdio_indirect_read_bytes(struct rtw_dev *rtwdev, u32 addr,
+					u8 *buf, int count)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < count; i++) {
+		buf[i] = rtw_sdio_indirect_read8(rtwdev, addr + i, &ret);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static u16 rtw_sdio_indirect_read16(struct rtw_dev *rtwdev, u32 addr,
+				    int *err_ret)
+{
+	u32 reg_data;
+	u8 buf[2];
+
+	if (!IS_ALIGNED(addr, 2)) {
+		*err_ret = rtw_sdio_indirect_read_bytes(rtwdev, addr, buf, 2);
+		if (*err_ret)
+			return 0;
+
+		return le16_to_cpu(*(__le16 *)buf);
+	}
+
+	*err_ret = rtw_sdio_indirect_reg_cfg(rtwdev, addr,
+					     BIT_SDIO_INDIRECT_REG_CFG_READ);
+	if (*err_ret)
+		return 0;
+
+	reg_data = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_DATA);
+	return rtw_sdio_readw(rtwdev, reg_data, err_ret);
+}
+
+static u32 rtw_sdio_indirect_read32(struct rtw_dev *rtwdev, u32 addr,
+				    int *err_ret)
+{
+	u32 reg_data;
+	u8 buf[4];
+
+	if (!IS_ALIGNED(addr, 4)) {
+		*err_ret = rtw_sdio_indirect_read_bytes(rtwdev, addr, buf, 4);
+		if (*err_ret)
+			return 0;
+
+		return le32_to_cpu(*(__le32 *)buf);
+	}
+
+	*err_ret = rtw_sdio_indirect_reg_cfg(rtwdev, addr,
+					     BIT_SDIO_INDIRECT_REG_CFG_READ);
+	if (*err_ret)
+		return 0;
+
+	reg_data = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_DATA);
+	return rtw_sdio_readl(rtwdev, reg_data, err_ret);
+}
+
+static u8 rtw_sdio_read8(struct rtw_dev *rtwdev, u32 addr)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool direct, bus_claim;
+	int ret;
+	u8 val;
+
+	direct = rtw_sdio_use_direct_io(rtwdev, addr);
+	addr = rtw_sdio_to_io_address(rtwdev, addr, direct);
+	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
+
+	if (bus_claim)
+		sdio_claim_host(rtwsdio->sdio_func);
+
+	if (direct)
+		val = sdio_readb(rtwsdio->sdio_func, addr, &ret);
+	else
+		val = rtw_sdio_indirect_read8(rtwdev, addr, &ret);
+
+	if (bus_claim)
+		sdio_release_host(rtwsdio->sdio_func);
+
+	if (ret)
+		rtw_warn(rtwdev, "sdio read8 failed (0x%x): %d", addr, ret);
+
+	return val;
+}
+
+static u16 rtw_sdio_read16(struct rtw_dev *rtwdev, u32 addr)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool direct, bus_claim;
+	int ret;
+	u16 val;
+
+	direct = rtw_sdio_use_direct_io(rtwdev, addr);
+	addr = rtw_sdio_to_io_address(rtwdev, addr, direct);
+	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
+
+	if (bus_claim)
+		sdio_claim_host(rtwsdio->sdio_func);
+
+	if (direct)
+		val = rtw_sdio_readw(rtwdev, addr, &ret);
+	else
+		val = rtw_sdio_indirect_read16(rtwdev, addr, &ret);
+
+	if (bus_claim)
+		sdio_release_host(rtwsdio->sdio_func);
+
+	if (ret)
+		rtw_warn(rtwdev, "sdio read16 failed (0x%x): %d", addr, ret);
+
+	return val;
+}
+
+static u32 rtw_sdio_read32(struct rtw_dev *rtwdev, u32 addr)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool direct, bus_claim;
+	u32 val;
+	int ret;
+
+	direct = rtw_sdio_use_direct_io(rtwdev, addr);
+	addr = rtw_sdio_to_io_address(rtwdev, addr, direct);
+	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
+
+	if (bus_claim)
+		sdio_claim_host(rtwsdio->sdio_func);
+
+	if (direct)
+		val = rtw_sdio_readl(rtwdev, addr, &ret);
+	else
+		val = rtw_sdio_indirect_read32(rtwdev, addr, &ret);
+
+	if (bus_claim)
+		sdio_release_host(rtwsdio->sdio_func);
+
+	if (ret)
+		rtw_warn(rtwdev, "sdio read32 failed (0x%x): %d", addr, ret);
+
+	return val;
+}
+
+static void rtw_sdio_indirect_write8(struct rtw_dev *rtwdev, u8 val, u32 addr,
+				     int *err_ret)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	u32 reg_data;
+
+	reg_data = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_DATA);
+	sdio_writeb(rtwsdio->sdio_func, val, reg_data, err_ret);
+	if (*err_ret)
+		return;
+
+	*err_ret = rtw_sdio_indirect_reg_cfg(rtwdev, addr,
+					     BIT_SDIO_INDIRECT_REG_CFG_WRITE);
+}
+
+static void rtw_sdio_indirect_write16(struct rtw_dev *rtwdev, u16 val, u32 addr,
+				      int *err_ret)
+{
+	u32 reg_data;
+
+	if (!IS_ALIGNED(addr, 2)) {
+		addr = rtw_sdio_to_io_address(rtwdev, addr, true);
+		rtw_sdio_writew(rtwdev, val, addr, err_ret);
+		return;
+	}
+
+	reg_data = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_DATA);
+	rtw_sdio_writew(rtwdev, val, reg_data, err_ret);
+	if (*err_ret)
+		return;
+
+	*err_ret = rtw_sdio_indirect_reg_cfg(rtwdev, addr,
+					     BIT_SDIO_INDIRECT_REG_CFG_WRITE |
+					     BIT_SDIO_INDIRECT_REG_CFG_WORD);
+}
+
+static void rtw_sdio_indirect_write32(struct rtw_dev *rtwdev, u32 val,
+				      u32 addr, int *err_ret)
+{
+	u32 reg_data;
+
+	if (!IS_ALIGNED(addr, 4)) {
+		addr = rtw_sdio_to_io_address(rtwdev, addr, true);
+		rtw_sdio_writel(rtwdev, val, addr, err_ret);
+		return;
+	}
+
+	reg_data = rtw_sdio_to_bus_offset(rtwdev, REG_SDIO_INDIRECT_REG_DATA);
+	rtw_sdio_writel(rtwdev, val, reg_data, err_ret);
+
+	*err_ret = rtw_sdio_indirect_reg_cfg(rtwdev, addr,
+					     BIT_SDIO_INDIRECT_REG_CFG_WRITE |
+					     BIT_SDIO_INDIRECT_REG_CFG_DWORD);
+}
+
+static void rtw_sdio_write8(struct rtw_dev *rtwdev, u32 addr, u8 val)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool direct, bus_claim;
+	int ret;
+
+	direct = rtw_sdio_use_direct_io(rtwdev, addr);
+	addr = rtw_sdio_to_io_address(rtwdev, addr, direct);
+	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
+
+	if (bus_claim)
+		sdio_claim_host(rtwsdio->sdio_func);
+
+	if (direct)
+		sdio_writeb(rtwsdio->sdio_func, val, addr, &ret);
+	else
+		rtw_sdio_indirect_write8(rtwdev, val, addr, &ret);
+
+	if (bus_claim)
+		sdio_release_host(rtwsdio->sdio_func);
+
+	if (ret)
+		rtw_warn(rtwdev, "sdio write8 failed (0x%x): %d", addr, ret);
+}
+
+static void rtw_sdio_write16(struct rtw_dev *rtwdev, u32 addr, u16 val)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool direct, bus_claim;
+	int ret;
+
+	direct = rtw_sdio_use_direct_io(rtwdev, addr);
+	addr = rtw_sdio_to_io_address(rtwdev, addr, direct);
+	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
+
+	if (bus_claim)
+		sdio_claim_host(rtwsdio->sdio_func);
+
+	if (direct)
+		rtw_sdio_writew(rtwdev, val, addr, &ret);
+	else
+		rtw_sdio_indirect_write16(rtwdev, val, addr, &ret);
+
+	if (bus_claim)
+		sdio_release_host(rtwsdio->sdio_func);
+
+	if (ret)
+		rtw_warn(rtwdev, "sdio write16 failed (0x%x): %d", addr, ret);
+}
+
+static void rtw_sdio_write32(struct rtw_dev *rtwdev, u32 addr, u32 val)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool direct, bus_claim;
+	int ret;
+
+	direct = rtw_sdio_use_direct_io(rtwdev, addr);
+	addr = rtw_sdio_to_io_address(rtwdev, addr, direct);
+	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
+
+	if (bus_claim)
+		sdio_claim_host(rtwsdio->sdio_func);
+
+	if (direct)
+		rtw_sdio_writel(rtwdev, val, addr, &ret);
+	else
+		rtw_sdio_indirect_write32(rtwdev, val, addr, &ret);
+
+	if (bus_claim)
+		sdio_release_host(rtwsdio->sdio_func);
+
+	if (ret)
+		rtw_warn(rtwdev, "sdio write32 failed (0x%x): %d", addr, ret);
+}
+
+static u32 rtw_sdio_get_tx_addr(struct rtw_dev *rtwdev, size_t size,
+				enum rtw_tx_queue_type queue)
+{
+	u32 txaddr;
+
+	switch (queue) {
+	case RTW_TX_QUEUE_BCN:
+	case RTW_TX_QUEUE_H2C:
+	case RTW_TX_QUEUE_HI0:
+		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+				    REG_SDIO_CMD_ADDR_TXFF_HIGH);
+		break;
+	case RTW_TX_QUEUE_VI:
+	case RTW_TX_QUEUE_VO:
+		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+				    REG_SDIO_CMD_ADDR_TXFF_NORMAL);
+		break;
+	case RTW_TX_QUEUE_BE:
+	case RTW_TX_QUEUE_BK:
+		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+				    REG_SDIO_CMD_ADDR_TXFF_LOW);
+		break;
+	case RTW_TX_QUEUE_MGMT:
+		txaddr = FIELD_PREP(REG_SDIO_CMD_ADDR_MSK,
+				    REG_SDIO_CMD_ADDR_TXFF_EXTRA);
+		break;
+	default:
+		rtw_warn(rtwdev, "Unsupported queue for TX addr: 0x%02x\n",
+			 queue);
+		return 0;
+	}
+
+	txaddr += DIV_ROUND_UP(size, 4);
+
+	return txaddr;
+};
+
+static int rtw_sdio_read_port(struct rtw_dev *rtwdev, u8 *buf, size_t count)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
+	u32 rxaddr = rtwsdio->rx_addr++;
+	int ret;
+
+	if (bus_claim)
+		sdio_claim_host(rtwsdio->sdio_func);
+
+	ret = sdio_memcpy_fromio(rtwsdio->sdio_func, buf,
+				 RTW_SDIO_ADDR_RX_RX0FF_GEN(rxaddr), count);
+	if (ret)
+		rtw_warn(rtwdev,
+			 "Failed to read %zu byte(s) from SDIO port 0x%08x",
+			 count, rxaddr);
+
+	if (bus_claim)
+		sdio_release_host(rtwsdio->sdio_func);
+
+	return ret;
+}
+
+static int rtw_sdio_check_free_txpg(struct rtw_dev *rtwdev, u8 queue,
+				    size_t count)
+{
+	unsigned int pages_free, pages_needed;
+
+	if (rtw_chip_wcpu_11n(rtwdev)) {
+		u32 free_txpg;
+
+		free_txpg = rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG);
+
+		switch (queue) {
+		case RTW_TX_QUEUE_BCN:
+		case RTW_TX_QUEUE_H2C:
+		case RTW_TX_QUEUE_HI0:
+		case RTW_TX_QUEUE_MGMT:
+			/* high */
+			pages_free = free_txpg & 0xff;
+			break;
+		case RTW_TX_QUEUE_VI:
+		case RTW_TX_QUEUE_VO:
+			/* normal */
+			pages_free = (free_txpg >> 8) & 0xff;
+			break;
+		case RTW_TX_QUEUE_BE:
+		case RTW_TX_QUEUE_BK:
+			/* low */
+			pages_free = (free_txpg >> 16) & 0xff;
+			break;
+		default:
+			rtw_warn(rtwdev, "Unknown mapping for queue %u\n", queue);
+			return -EINVAL;
+		}
+
+		/* add the pages from the public queue */
+		pages_free += (free_txpg >> 24) & 0xff;
+	} else {
+		u32 free_txpg[3];
+
+		free_txpg[0] = rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG);
+		free_txpg[1] = rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG + 4);
+		free_txpg[2] = rtw_sdio_read32(rtwdev, REG_SDIO_FREE_TXPG + 8);
+
+		switch (queue) {
+		case RTW_TX_QUEUE_BCN:
+		case RTW_TX_QUEUE_H2C:
+		case RTW_TX_QUEUE_HI0:
+			/* high */
+			pages_free = free_txpg[0] & 0xfff;
+			break;
+		case RTW_TX_QUEUE_VI:
+		case RTW_TX_QUEUE_VO:
+			/* normal */
+			pages_free = (free_txpg[0] >> 16) & 0xfff;
+			break;
+		case RTW_TX_QUEUE_BE:
+		case RTW_TX_QUEUE_BK:
+			/* low */
+			pages_free = free_txpg[1] & 0xfff;
+			break;
+		case RTW_TX_QUEUE_MGMT:
+			/* extra */
+			pages_free = free_txpg[2] & 0xfff;
+			break;
+		default:
+			rtw_warn(rtwdev, "Unknown mapping for queue %u\n", queue);
+			return -EINVAL;
+		}
+
+		/* add the pages from the public queue */
+		pages_free += (free_txpg[1] >> 16) & 0xfff;
+	}
+
+	pages_needed = DIV_ROUND_UP(count, rtwdev->chip->page_size);
+
+	if (pages_needed > pages_free) {
+		rtw_dbg(rtwdev, RTW_DBG_SDIO,
+			"Not enough free pages (%u needed, %u free) in queue %u for %zu bytes\n",
+			pages_needed, pages_free, queue, count);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+static int rtw_sdio_write_port(struct rtw_dev *rtwdev, struct sk_buff *skb,
+			       enum rtw_tx_queue_type queue)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool bus_claim;
+	size_t txsize;
+	u32 txaddr;
+	int ret;
+
+	txaddr = rtw_sdio_get_tx_addr(rtwdev, skb->len, queue);
+	if (!txaddr)
+		return -EINVAL;
+
+	txsize = sdio_align_size(rtwsdio->sdio_func, skb->len);
+
+	ret = rtw_sdio_check_free_txpg(rtwdev, queue, txsize);
+	if (ret)
+		return ret;
+
+	if (!IS_ALIGNED((unsigned long)skb->data, RTW_SDIO_DATA_PTR_ALIGN))
+		rtw_warn(rtwdev, "Got unaligned SKB in %s() for queue %u\n",
+			 __func__, queue);
+
+	bus_claim = rtw_sdio_bus_claim_needed(rtwsdio);
+
+	if (bus_claim)
+		sdio_claim_host(rtwsdio->sdio_func);
+
+	ret = sdio_memcpy_toio(rtwsdio->sdio_func, txaddr, skb->data, txsize);
+
+	if (bus_claim)
+		sdio_release_host(rtwsdio->sdio_func);
+
+	if (ret)
+		rtw_warn(rtwdev,
+			 "Failed to write %zu byte(s) to SDIO port 0x%08x",
+			 txsize, txaddr);
+
+	return ret;
+}
+
+static void rtw_sdio_init(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	rtwsdio->irq_mask = REG_SDIO_HIMR_RX_REQUEST | REG_SDIO_HIMR_CPWM1;
+}
+
+static void rtw_sdio_enable_rx_aggregation(struct rtw_dev *rtwdev)
+{
+	u8 size, timeout;
+
+	if (rtw_chip_wcpu_11n(rtwdev)) {
+		size = 0x6;
+		timeout = 0x6;
+	} else {
+		size = 0xff;
+		timeout = 0x1;
+	}
+
+	/* Make the firmware honor the size limit configured below */
+	rtw_write32_set(rtwdev, REG_RXDMA_AGG_PG_TH, BIT_EN_PRE_CALC);
+
+	rtw_write8_set(rtwdev, REG_TXDMA_PQ_MAP, BIT_RXDMA_AGG_EN);
+
+	rtw_write16(rtwdev, REG_RXDMA_AGG_PG_TH,
+		    FIELD_PREP(BIT_RXDMA_AGG_PG_TH, size) |
+		    FIELD_PREP(BIT_DMA_AGG_TO_V1, timeout));
+
+	rtw_write8_set(rtwdev, REG_RXDMA_MODE, BIT_DMA_MODE);
+}
+
+static void rtw_sdio_enable_interrupt(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	rtw_write32(rtwdev, REG_SDIO_HIMR, rtwsdio->irq_mask);
+}
+
+static void rtw_sdio_disable_interrupt(struct rtw_dev *rtwdev)
+{
+	rtw_write32(rtwdev, REG_SDIO_HIMR, 0x0);
+}
+
+static u8 rtw_sdio_get_tx_qsel(struct rtw_dev *rtwdev, struct sk_buff *skb,
+			       u8 queue)
+{
+	switch (queue) {
+	case RTW_TX_QUEUE_BCN:
+		return TX_DESC_QSEL_BEACON;
+	case RTW_TX_QUEUE_H2C:
+		return TX_DESC_QSEL_H2C;
+	case RTW_TX_QUEUE_MGMT:
+		if (rtw_chip_wcpu_11n(rtwdev))
+			return TX_DESC_QSEL_HIGH;
+		else
+			return TX_DESC_QSEL_MGMT;
+	case RTW_TX_QUEUE_HI0:
+		return TX_DESC_QSEL_HIGH;
+	default:
+		return skb->priority;
+	}
+}
+
+static int rtw_sdio_setup(struct rtw_dev *rtwdev)
+{
+	/* nothing to do */
+	return 0;
+}
+
+static int rtw_sdio_start(struct rtw_dev *rtwdev)
+{
+	rtw_sdio_enable_rx_aggregation(rtwdev);
+	rtw_sdio_enable_interrupt(rtwdev);
+
+	return 0;
+}
+
+static void rtw_sdio_stop(struct rtw_dev *rtwdev)
+{
+	rtw_sdio_disable_interrupt(rtwdev);
+}
+
+static void rtw_sdio_deep_ps_enter(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	bool tx_empty = true;
+	u8 queue;
+
+	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_TX_WAKE)) {
+		/* Deep PS state is not allowed to TX-DMA */
+		for (queue = 0; queue < RTK_MAX_TX_QUEUE_NUM; queue++) {
+			/* BCN queue is rsvd page, does not have DMA interrupt
+			 * H2C queue is managed by firmware
+			 */
+			if (queue == RTW_TX_QUEUE_BCN ||
+			    queue == RTW_TX_QUEUE_H2C)
+				continue;
+
+			/* check if there is any skb DMAing */
+			if (skb_queue_len(&rtwsdio->tx_queue[queue])) {
+				tx_empty = false;
+				break;
+			}
+		}
+	}
+
+	if (!tx_empty) {
+		rtw_dbg(rtwdev, RTW_DBG_PS,
+			"TX path not empty, cannot enter deep power save state\n");
+		return;
+	}
+
+	set_bit(RTW_FLAG_LEISURE_PS_DEEP, rtwdev->flags);
+	rtw_power_mode_change(rtwdev, true);
+}
+
+static void rtw_sdio_deep_ps_leave(struct rtw_dev *rtwdev)
+{
+	if (test_and_clear_bit(RTW_FLAG_LEISURE_PS_DEEP, rtwdev->flags))
+		rtw_power_mode_change(rtwdev, false);
+}
+
+static void rtw_sdio_deep_ps(struct rtw_dev *rtwdev, bool enter)
+{
+	if (enter && !test_bit(RTW_FLAG_LEISURE_PS_DEEP, rtwdev->flags))
+		rtw_sdio_deep_ps_enter(rtwdev);
+
+	if (!enter && test_bit(RTW_FLAG_LEISURE_PS_DEEP, rtwdev->flags))
+		rtw_sdio_deep_ps_leave(rtwdev);
+}
+
+static void rtw_sdio_tx_kick_off(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	queue_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work);
+}
+
+static void rtw_sdio_link_ps(struct rtw_dev *rtwdev, bool enter)
+{
+	/* nothing to do */
+}
+
+static void rtw_sdio_interface_cfg(struct rtw_dev *rtwdev)
+{
+	u32 val;
+
+	rtw_read32(rtwdev, REG_SDIO_FREE_TXPG);
+
+	val = rtw_read32(rtwdev, REG_SDIO_TX_CTRL);
+	val &= 0xfff8;
+	rtw_write32(rtwdev, REG_SDIO_TX_CTRL, val);
+}
+
+static struct rtw_sdio_tx_data *rtw_sdio_get_tx_data(struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	BUILD_BUG_ON(sizeof(struct rtw_sdio_tx_data) >
+		     sizeof(info->status.status_driver_data));
+
+	return (struct rtw_sdio_tx_data *)info->status.status_driver_data;
+}
+
+static void rtw_sdio_tx_skb_prepare(struct rtw_dev *rtwdev,
+				    struct rtw_tx_pkt_info *pkt_info,
+				    struct sk_buff *skb,
+				    enum rtw_tx_queue_type queue)
+{
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	unsigned long data_addr, aligned_addr;
+	size_t offset;
+	u8 *pkt_desc;
+
+	pkt_desc = skb_push(skb, chip->tx_pkt_desc_sz);
+
+	data_addr = (unsigned long)pkt_desc;
+	aligned_addr = ALIGN(data_addr, RTW_SDIO_DATA_PTR_ALIGN);
+
+	if (data_addr != aligned_addr) {
+		/* Ensure that the start of the pkt_desc is always aligned at
+		 * RTW_SDIO_DATA_PTR_ALIGN.
+		 */
+		offset = RTW_SDIO_DATA_PTR_ALIGN - (aligned_addr - data_addr);
+
+		pkt_desc = skb_push(skb, offset);
+
+		/* By inserting padding to align the start of the pkt_desc we
+		 * need to inform the firmware that the actual data starts at
+		 * a different offset than normal.
+		 */
+		pkt_info->offset += offset;
+	}
+
+	memset(pkt_desc, 0, chip->tx_pkt_desc_sz);
+
+	pkt_info->qsel = rtw_sdio_get_tx_qsel(rtwdev, skb, queue);
+
+	rtw_tx_fill_tx_desc(pkt_info, skb);
+	rtw_tx_fill_txdesc_checksum(rtwdev, pkt_info, pkt_desc);
+}
+
+static int rtw_sdio_write_data(struct rtw_dev *rtwdev,
+			       struct rtw_tx_pkt_info *pkt_info,
+			       struct sk_buff *skb,
+			       enum rtw_tx_queue_type queue)
+{
+	int ret;
+
+	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
+
+	ret = rtw_sdio_write_port(rtwdev, skb, queue);
+	dev_kfree_skb_any(skb);
+
+	return ret;
+}
+
+static int rtw_sdio_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
+					 u32 size)
+{
+	struct rtw_tx_pkt_info pkt_info = {};
+	struct sk_buff *skb;
+
+	skb = rtw_tx_write_data_rsvd_page_get(rtwdev, &pkt_info, buf, size);
+	if (!skb)
+		return -ENOMEM;
+
+	return rtw_sdio_write_data(rtwdev, &pkt_info, skb, RTW_TX_QUEUE_BCN);
+}
+
+static int rtw_sdio_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
+{
+	struct rtw_tx_pkt_info pkt_info = {};
+	struct sk_buff *skb;
+
+	skb = rtw_tx_write_data_h2c_get(rtwdev, &pkt_info, buf, size);
+	if (!skb)
+		return -ENOMEM;
+
+	return rtw_sdio_write_data(rtwdev, &pkt_info, skb, RTW_TX_QUEUE_H2C);
+}
+
+static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
+			     struct rtw_tx_pkt_info *pkt_info,
+			     struct sk_buff *skb)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	enum rtw_tx_queue_type queue = rtw_tx_queue_mapping(skb);
+	struct rtw_sdio_tx_data *tx_data;
+
+	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
+
+	tx_data = rtw_sdio_get_tx_data(skb);
+	tx_data->sn = pkt_info->sn;
+
+	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
+
+	return 0;
+}
+
+static void rtw_sdio_tx_err_isr(struct rtw_dev *rtwdev)
+{
+	u32 val = rtw_read32(rtwdev, REG_TXDMA_STATUS);
+
+	rtw_write32(rtwdev, REG_TXDMA_STATUS, val);
+}
+
+static void rtw_sdio_rx_skb(struct rtw_dev *rtwdev, struct sk_buff *skb,
+			    u32 pkt_offset, struct rtw_rx_pkt_stat *pkt_stat,
+			    struct ieee80211_rx_status *rx_status)
+{
+	*IEEE80211_SKB_RXCB(skb) = *rx_status;
+
+	if (pkt_stat->is_c2h) {
+		skb_put(skb, pkt_stat->pkt_len + pkt_offset);
+		rtw_fw_c2h_cmd_rx_irqsafe(rtwdev, pkt_offset, skb);
+		return;
+	}
+
+	skb_put(skb, pkt_stat->pkt_len);
+	skb_reserve(skb, pkt_offset);
+
+	rtw_rx_stats(rtwdev, pkt_stat->vif, skb);
+
+	ieee80211_rx_irqsafe(rtwdev->hw, skb);
+}
+
+static void rtw_sdio_rxfifo_recv(struct rtw_dev *rtwdev, u32 rx_len)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	const struct rtw_chip_info *chip = rtwdev->chip;
+	u32 pkt_desc_sz = chip->rx_pkt_desc_sz;
+	struct ieee80211_rx_status rx_status;
+	struct rtw_rx_pkt_stat pkt_stat;
+	struct sk_buff *skb, *split_skb;
+	u32 pkt_offset, curr_pkt_len;
+	size_t bufsz;
+	u8 *rx_desc;
+	int ret;
+
+	bufsz = sdio_align_size(rtwsdio->sdio_func, rx_len);
+
+	skb = dev_alloc_skb(bufsz);
+	if (!skb)
+		return;
+
+	ret = rtw_sdio_read_port(rtwdev, skb->data, bufsz);
+	if (ret) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
+
+	while (true) {
+		rx_desc = skb->data;
+		chip->ops->query_rx_desc(rtwdev, rx_desc, &pkt_stat,
+					 &rx_status);
+		pkt_offset = pkt_desc_sz + pkt_stat.drv_info_sz +
+			     pkt_stat.shift;
+
+		curr_pkt_len = ALIGN(pkt_offset + pkt_stat.pkt_len,
+				     RTW_SDIO_DATA_PTR_ALIGN);
+
+		if ((curr_pkt_len + pkt_desc_sz) >= rx_len) {
+			/* Use the original skb (with it's adjusted offset)
+			 * when processing the last (or even the only) entry to
+			 * have it's memory freed automatically.
+			 */
+			rtw_sdio_rx_skb(rtwdev, skb, pkt_offset, &pkt_stat,
+					&rx_status);
+			break;
+		}
+
+		split_skb = dev_alloc_skb(curr_pkt_len);
+		if (!split_skb) {
+			rtw_sdio_rx_skb(rtwdev, skb, pkt_offset, &pkt_stat,
+					&rx_status);
+			break;
+		}
+
+		skb_copy_header(split_skb, skb);
+		memcpy(split_skb->data, skb->data, curr_pkt_len);
+
+		rtw_sdio_rx_skb(rtwdev, split_skb, pkt_offset, &pkt_stat,
+				&rx_status);
+
+		/* Move to the start of the next RX descriptor */
+		skb_reserve(skb, curr_pkt_len);
+		rx_len -= curr_pkt_len;
+	}
+}
+
+static void rtw_sdio_rx_isr(struct rtw_dev *rtwdev)
+{
+	u32 rx_len, total_rx_bytes = 0;
+
+	while (total_rx_bytes < SZ_64K) {
+		if (rtw_chip_wcpu_11n(rtwdev))
+			rx_len = rtw_read16(rtwdev, REG_SDIO_RX0_REQ_LEN);
+		else
+			rx_len = rtw_read32(rtwdev, REG_SDIO_RX0_REQ_LEN);
+
+		if (!rx_len)
+			break;
+
+		rtw_sdio_rxfifo_recv(rtwdev, rx_len);
+
+		total_rx_bytes += rx_len;
+	}
+}
+
+static void rtw_sdio_handle_interrupt(struct sdio_func *sdio_func)
+{
+	struct ieee80211_hw *hw = sdio_get_drvdata(sdio_func);
+	struct rtw_sdio *rtwsdio;
+	struct rtw_dev *rtwdev;
+	u32 hisr;
+
+	rtwdev = hw->priv;
+	rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	rtwsdio->irq_thread = current;
+
+	hisr = rtw_read32(rtwdev, REG_SDIO_HISR);
+
+	if (hisr & REG_SDIO_HISR_TXERR)
+		rtw_sdio_tx_err_isr(rtwdev);
+	if (hisr & REG_SDIO_HISR_RX_REQUEST) {
+		hisr &= ~REG_SDIO_HISR_RX_REQUEST;
+		rtw_sdio_rx_isr(rtwdev);
+	}
+
+	rtw_write32(rtwdev, REG_SDIO_HISR, hisr);
+
+	rtwsdio->irq_thread = NULL;
+}
+
+static int __maybe_unused rtw_sdio_suspend(struct device *dev)
+{
+	struct sdio_func *func = dev_to_sdio_func(dev);
+	struct ieee80211_hw *hw = dev_get_drvdata(dev);
+	struct rtw_dev *rtwdev = hw->priv;
+	int ret;
+
+	ret = sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
+	if (ret)
+		rtw_err(rtwdev, "Failed to host PM flag MMC_PM_KEEP_POWER");
+
+	return ret;
+}
+
+static int __maybe_unused rtw_sdio_resume(struct device *dev)
+{
+	return 0;
+}
+
+SIMPLE_DEV_PM_OPS(rtw_sdio_pm_ops, rtw_sdio_suspend, rtw_sdio_resume);
+EXPORT_SYMBOL(rtw_sdio_pm_ops);
+
+static int rtw_sdio_claim(struct rtw_dev *rtwdev, struct sdio_func *sdio_func)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	int ret;
+
+	sdio_claim_host(sdio_func);
+
+	ret = sdio_enable_func(sdio_func);
+	if (ret) {
+		rtw_err(rtwdev, "Failed to enable SDIO func");
+		goto err_release_host;
+	}
+
+	ret = sdio_set_block_size(sdio_func, RTW_SDIO_BLOCK_SIZE);
+	if (ret) {
+		rtw_err(rtwdev, "Failed to set SDIO block size to 512");
+		goto err_disable_func;
+	}
+
+	rtwsdio->sdio_func = sdio_func;
+
+	rtwsdio->sdio3_bus_mode = mmc_card_uhs(sdio_func->card);
+
+	sdio_set_drvdata(sdio_func, rtwdev->hw);
+	SET_IEEE80211_DEV(rtwdev->hw, &sdio_func->dev);
+
+	sdio_release_host(sdio_func);
+
+	return 0;
+
+err_disable_func:
+	sdio_disable_func(sdio_func);
+err_release_host:
+	sdio_release_host(sdio_func);
+	return ret;
+}
+
+static void rtw_sdio_declaim(struct rtw_dev *rtwdev,
+			     struct sdio_func *sdio_func)
+{
+	sdio_claim_host(sdio_func);
+	sdio_disable_func(sdio_func);
+	sdio_release_host(sdio_func);
+}
+
+static struct rtw_hci_ops rtw_sdio_ops = {
+	.tx_write = rtw_sdio_tx_write,
+	.tx_kick_off = rtw_sdio_tx_kick_off,
+	.setup = rtw_sdio_setup,
+	.start = rtw_sdio_start,
+	.stop = rtw_sdio_stop,
+	.deep_ps = rtw_sdio_deep_ps,
+	.link_ps = rtw_sdio_link_ps,
+	.interface_cfg = rtw_sdio_interface_cfg,
+
+	.read8 = rtw_sdio_read8,
+	.read16 = rtw_sdio_read16,
+	.read32 = rtw_sdio_read32,
+	.write8 = rtw_sdio_write8,
+	.write16 = rtw_sdio_write16,
+	.write32 = rtw_sdio_write32,
+	.write_data_rsvd_page = rtw_sdio_write_data_rsvd_page,
+	.write_data_h2c = rtw_sdio_write_data_h2c,
+};
+
+static int rtw_sdio_request_irq(struct rtw_dev *rtwdev,
+				struct sdio_func *sdio_func)
+{
+	int ret;
+
+	sdio_claim_host(sdio_func);
+	ret = sdio_claim_irq(sdio_func, &rtw_sdio_handle_interrupt);
+	sdio_release_host(sdio_func);
+
+	if (ret) {
+		rtw_err(rtwdev, "failed to claim SDIO IRQ");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
+					struct sk_buff *skb)
+{
+	struct rtw_sdio_tx_data *tx_data = rtw_sdio_get_tx_data(skb);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hw *hw = rtwdev->hw;
+
+	/* enqueue to wait for tx report */
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS) {
+		rtw_tx_report_enqueue(rtwdev, skb, tx_data->sn);
+		return;
+	}
+
+	/* always ACK for others, then they won't be marked as drop */
+	ieee80211_tx_info_clear_status(info);
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+	else
+		info->flags |= IEEE80211_TX_STAT_ACK;
+
+	ieee80211_tx_status_irqsafe(hw, skb);
+}
+
+static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
+				      enum rtw_tx_queue_type queue)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	struct sk_buff *skb;
+	int ret;
+
+	skb = skb_dequeue(&rtwsdio->tx_queue[queue]);
+	if (!skb)
+		return;
+
+	ret = rtw_sdio_write_port(rtwdev, skb, queue);
+	if (ret) {
+		skb_queue_head(&rtwsdio->tx_queue[queue], skb);
+		return;
+	}
+
+	if (queue <= RTW_TX_QUEUE_VO)
+		rtw_sdio_indicate_tx_status(rtwdev, skb);
+	else
+		dev_kfree_skb_any(skb);
+}
+
+static void rtw_sdio_tx_handler(struct work_struct *work)
+{
+	struct rtw_sdio_work_data *work_data =
+		container_of(work, struct rtw_sdio_work_data, work);
+	struct rtw_sdio *rtwsdio;
+	struct rtw_dev *rtwdev;
+	int limit, queue;
+
+	rtwdev = work_data->rtwdev;
+	rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_TX_WAKE))
+		rtw_sdio_deep_ps_leave(rtwdev);
+
+	for (queue = RTK_MAX_TX_QUEUE_NUM - 1; queue >= 0; queue--) {
+		for (limit = 0; limit < 1000; limit++) {
+			rtw_sdio_process_tx_queue(rtwdev, queue);
+
+			if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
+				break;
+		}
+	}
+}
+
+static void rtw_sdio_free_irq(struct rtw_dev *rtwdev,
+			      struct sdio_func *sdio_func)
+{
+	sdio_claim_host(sdio_func);
+	sdio_release_irq(sdio_func);
+	sdio_release_host(sdio_func);
+}
+
+static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	int i;
+
+	rtwsdio->txwq = create_singlethread_workqueue("rtw88_sdio: tx wq");
+	if (!rtwsdio->txwq) {
+		rtw_err(rtwdev, "failed to create TX work queue\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
+		skb_queue_head_init(&rtwsdio->tx_queue[i]);
+	rtwsdio->tx_handler_data = kmalloc(sizeof(*rtwsdio->tx_handler_data),
+					   GFP_KERNEL);
+	if (!rtwsdio->tx_handler_data)
+		goto err_destroy_wq;
+
+	rtwsdio->tx_handler_data->rtwdev = rtwdev;
+	INIT_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_handler);
+
+	return 0;
+
+err_destroy_wq:
+	destroy_workqueue(rtwsdio->txwq);
+	return -ENOMEM;
+}
+
+static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	int i;
+
+	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
+		skb_queue_purge(&rtwsdio->tx_queue[i]);
+
+	flush_workqueue(rtwsdio->txwq);
+	destroy_workqueue(rtwsdio->txwq);
+	kfree(rtwsdio->tx_handler_data);
+}
+
+int rtw_sdio_probe(struct sdio_func *sdio_func,
+		   const struct sdio_device_id *id)
+{
+	struct ieee80211_hw *hw;
+	struct rtw_dev *rtwdev;
+	int drv_data_size;
+	int ret;
+
+	drv_data_size = sizeof(struct rtw_dev) + sizeof(struct rtw_sdio);
+	hw = ieee80211_alloc_hw(drv_data_size, &rtw_ops);
+	if (!hw) {
+		dev_err(&sdio_func->dev, "failed to allocate hw");
+		return -ENOMEM;
+	}
+
+	rtwdev = hw->priv;
+	rtwdev->hw = hw;
+	rtwdev->dev = &sdio_func->dev;
+	rtwdev->chip = (struct rtw_chip_info *)id->driver_data;
+	rtwdev->hci.ops = &rtw_sdio_ops;
+	rtwdev->hci.type = RTW_HCI_TYPE_SDIO;
+
+	ret = rtw_core_init(rtwdev);
+	if (ret)
+		goto err_release_hw;
+
+	rtw_dbg(rtwdev, RTW_DBG_SDIO,
+		"rtw88 SDIO probe: vendor=0x%04x device=%04x class=%02x",
+		id->vendor, id->device, id->class);
+
+	ret = rtw_sdio_claim(rtwdev, sdio_func);
+	if (ret) {
+		rtw_err(rtwdev, "failed to claim SDIO device");
+		goto err_deinit_core;
+	}
+
+	rtw_sdio_init(rtwdev);
+
+	ret = rtw_sdio_init_tx(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to init SDIO TX queue\n");
+		goto err_sdio_declaim;
+	}
+
+	ret = rtw_chip_info_setup(rtwdev);
+	if (ret) {
+		rtw_err(rtwdev, "failed to setup chip information");
+		goto err_destroy_txwq;
+	}
+
+	ret = rtw_sdio_request_irq(rtwdev, sdio_func);
+	if (ret)
+		goto err_destroy_txwq;
+
+	ret = rtw_register_hw(rtwdev, hw);
+	if (ret) {
+		rtw_err(rtwdev, "failed to register hw");
+		goto err_free_irq;
+	}
+
+	return 0;
+
+err_free_irq:
+	rtw_sdio_free_irq(rtwdev, sdio_func);
+err_destroy_txwq:
+	rtw_sdio_deinit_tx(rtwdev);
+err_sdio_declaim:
+	rtw_sdio_declaim(rtwdev, sdio_func);
+err_deinit_core:
+	rtw_core_deinit(rtwdev);
+err_release_hw:
+	ieee80211_free_hw(hw);
+
+	return ret;
+}
+EXPORT_SYMBOL(rtw_sdio_probe);
+
+void rtw_sdio_remove(struct sdio_func *sdio_func)
+{
+	struct ieee80211_hw *hw = sdio_get_drvdata(sdio_func);
+	struct rtw_dev *rtwdev;
+
+	if (!hw)
+		return;
+
+	rtwdev = hw->priv;
+
+	rtw_unregister_hw(rtwdev, hw);
+	rtw_sdio_disable_interrupt(rtwdev);
+	rtw_sdio_free_irq(rtwdev, sdio_func);
+	rtw_sdio_declaim(rtwdev, sdio_func);
+	rtw_sdio_deinit_tx(rtwdev);
+	rtw_core_deinit(rtwdev);
+	ieee80211_free_hw(hw);
+}
+EXPORT_SYMBOL(rtw_sdio_remove);
+
+void rtw_sdio_shutdown(struct device *dev)
+{
+	struct sdio_func *sdio_func = dev_to_sdio_func(dev);
+	const struct rtw_chip_info *chip;
+	struct ieee80211_hw *hw;
+	struct rtw_dev *rtwdev;
+
+	hw = sdio_get_drvdata(sdio_func);
+	if (!hw)
+		return;
+
+	rtwdev = hw->priv;
+	chip = rtwdev->chip;
+
+	if (chip->ops->shutdown)
+		chip->ops->shutdown(rtwdev);
+}
+EXPORT_SYMBOL(rtw_sdio_shutdown);
+
+MODULE_AUTHOR("Martin Blumenstingl");
+MODULE_AUTHOR("Jernej Skrabec");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless SDIO driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
new file mode 100644
index 000000000000..3c659ed180f0
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright (C) 2021 Martin Blumenstingl <martin.blumenstingl@googlemail.com>
+ * Copyright (C) 2021 Jernej Skrabec <jernej.skrabec@gmail.com>
+ */
+
+#ifndef __REG_SDIO_H_
+#define __REG_SDIO_H_
+
+/* I/O bus domain address mapping */
+#define SDIO_LOCAL_OFFSET			0x10250000
+#define WLAN_IOREG_OFFSET			0x10260000
+#define FIRMWARE_FIFO_OFFSET			0x10270000
+#define TX_HIQ_OFFSET				0x10310000
+#define TX_MIQ_OFFSET				0x10320000
+#define TX_LOQ_OFFSET				0x10330000
+#define TX_EPQ_OFFSET				0x10350000
+#define RX_RX0FF_OFFSET				0x10340000
+
+#define RTW_SDIO_BUS_MSK			0xffff0000
+#define SDIO_LOCAL_REG_MSK			0x00000fff
+#define WLAN_IOREG_REG_MSK			0x0000ffff
+
+/* SDIO Tx Control */
+#define REG_SDIO_TX_CTRL			(SDIO_LOCAL_OFFSET + 0x0000)
+
+/*SDIO status timeout*/
+#define REG_SDIO_TIMEOUT			(SDIO_LOCAL_OFFSET + 0x0002)
+
+/* SDIO Host Interrupt Mask */
+#define REG_SDIO_HIMR				(SDIO_LOCAL_OFFSET + 0x0014)
+#define REG_SDIO_HIMR_RX_REQUEST		BIT(0)
+#define REG_SDIO_HIMR_AVAL			BIT(1)
+#define REG_SDIO_HIMR_TXERR			BIT(2)
+#define REG_SDIO_HIMR_RXERR			BIT(3)
+#define REG_SDIO_HIMR_TXFOVW			BIT(4)
+#define REG_SDIO_HIMR_RXFOVW			BIT(5)
+#define REG_SDIO_HIMR_TXBCNOK			BIT(6)
+#define REG_SDIO_HIMR_TXBCNERR			BIT(7)
+#define REG_SDIO_HIMR_BCNERLY_INT		BIT(16)
+#define REG_SDIO_HIMR_C2HCMD			BIT(17)
+#define REG_SDIO_HIMR_CPWM1			BIT(18)
+#define REG_SDIO_HIMR_CPWM2			BIT(19)
+#define REG_SDIO_HIMR_HSISR_IND			BIT(20)
+#define REG_SDIO_HIMR_GTINT3_IND		BIT(21)
+#define REG_SDIO_HIMR_GTINT4_IND		BIT(22)
+#define REG_SDIO_HIMR_PSTIMEOUT			BIT(23)
+#define REG_SDIO_HIMR_OCPINT			BIT(24)
+#define REG_SDIO_HIMR_ATIMEND			BIT(25)
+#define REG_SDIO_HIMR_ATIMEND_E			BIT(26)
+#define REG_SDIO_HIMR_CTWEND			BIT(27)
+/* the following two are RTL8188 SDIO Specific */
+#define REG_SDIO_HIMR_MCU_ERR			BIT(28)
+#define REG_SDIO_HIMR_TSF_BIT32_TOGGLE		BIT(29)
+
+/* SDIO Host Interrupt Service Routine */
+#define REG_SDIO_HISR				(SDIO_LOCAL_OFFSET + 0x0018)
+#define REG_SDIO_HISR_RX_REQUEST		BIT(0)
+#define REG_SDIO_HISR_AVAL			BIT(1)
+#define REG_SDIO_HISR_TXERR			BIT(2)
+#define REG_SDIO_HISR_RXERR			BIT(3)
+#define REG_SDIO_HISR_TXFOVW			BIT(4)
+#define REG_SDIO_HISR_RXFOVW			BIT(5)
+#define REG_SDIO_HISR_TXBCNOK			BIT(6)
+#define REG_SDIO_HISR_TXBCNERR			BIT(7)
+#define REG_SDIO_HISR_BCNERLY_INT		BIT(16)
+#define REG_SDIO_HISR_C2HCMD			BIT(17)
+#define REG_SDIO_HISR_CPWM1			BIT(18)
+#define REG_SDIO_HISR_CPWM2			BIT(19)
+#define REG_SDIO_HISR_HSISR_IND			BIT(20)
+#define REG_SDIO_HISR_GTINT3_IND		BIT(21)
+#define REG_SDIO_HISR_GTINT4_IND		BIT(22)
+#define REG_SDIO_HISR_PSTIMEOUT			BIT(23)
+#define REG_SDIO_HISR_OCPINT			BIT(24)
+#define REG_SDIO_HISR_ATIMEND			BIT(25)
+#define REG_SDIO_HISR_ATIMEND_E			BIT(26)
+#define REG_SDIO_HISR_CTWEND			BIT(27)
+/* the following two are RTL8188 SDIO Specific */
+#define REG_SDIO_HISR_MCU_ERR			BIT(28)
+#define REG_SDIO_HISR_TSF_BIT32_TOGGLE		BIT(29)
+
+/* HCI Current Power Mode */
+#define REG_SDIO_HCPWM				(SDIO_LOCAL_OFFSET + 0x0019)
+/* RXDMA Request Length */
+#define REG_SDIO_RX0_REQ_LEN			(SDIO_LOCAL_OFFSET + 0x001C)
+/* OQT Free Page */
+#define REG_SDIO_OQT_FREE_PG			(SDIO_LOCAL_OFFSET + 0x001E)
+/* Free Tx Buffer Page */
+#define REG_SDIO_FREE_TXPG			(SDIO_LOCAL_OFFSET + 0x0020)
+/* HCI Current Power Mode 1 */
+#define REG_SDIO_HCPWM1				(SDIO_LOCAL_OFFSET + 0x0024)
+/* HCI Current Power Mode 2 */
+#define REG_SDIO_HCPWM2				(SDIO_LOCAL_OFFSET + 0x0026)
+/* Free Tx Page Sequence */
+#define REG_SDIO_FREE_TXPG_SEQ			(SDIO_LOCAL_OFFSET + 0x0028)
+/* HTSF Information */
+#define REG_SDIO_HTSFR_INFO			(SDIO_LOCAL_OFFSET + 0x0030)
+#define REG_SDIO_HCPWM1_V2			(SDIO_LOCAL_OFFSET + 0x0038)
+/* H2C */
+#define REG_SDIO_H2C				(SDIO_LOCAL_OFFSET + 0x0060)
+/* HCI Request Power Mode 1 */
+#define REG_SDIO_HRPWM1				(SDIO_LOCAL_OFFSET + 0x0080)
+/* HCI Request Power Mode 2 */
+#define REG_SDIO_HRPWM2				(SDIO_LOCAL_OFFSET + 0x0082)
+/* HCI Power Save Clock */
+#define REG_SDIO_HPS_CLKR			(SDIO_LOCAL_OFFSET + 0x0084)
+/* SDIO HCI Suspend Control */
+#define REG_SDIO_HSUS_CTRL			(SDIO_LOCAL_OFFSET + 0x0086)
+#define BIT_HCI_SUS_REQ				BIT(0)
+#define BIT_HCI_RESUME_RDY			BIT(1)
+/* SDIO Host Extension Interrupt Mask Always */
+#define REG_SDIO_HIMR_ON			(SDIO_LOCAL_OFFSET + 0x0090)
+/* SDIO Host Extension Interrupt Status Always */
+#define REG_SDIO_HISR_ON			(SDIO_LOCAL_OFFSET + 0x0091)
+
+#define REG_SDIO_INDIRECT_REG_CFG		(SDIO_LOCAL_OFFSET + 0x0040)
+#define BIT_SDIO_INDIRECT_REG_CFG_WORD		BIT(16)
+#define BIT_SDIO_INDIRECT_REG_CFG_DWORD		BIT(17)
+#define BIT_SDIO_INDIRECT_REG_CFG_WRITE		BIT(18)
+#define BIT_SDIO_INDIRECT_REG_CFG_READ		BIT(19)
+#define BIT_SDIO_INDIRECT_REG_CFG_UNK20		BIT(20)
+#define REG_SDIO_INDIRECT_REG_DATA		(SDIO_LOCAL_OFFSET + 0x0044)
+
+/* Sdio Address for SDIO Local Reg, TRX FIFO, MAC Reg */
+#define REG_SDIO_CMD_ADDR_MSK			GENMASK(16, 13)
+#define REG_SDIO_CMD_ADDR_SDIO_REG		0
+#define REG_SDIO_CMD_ADDR_MAC_REG		8
+#define REG_SDIO_CMD_ADDR_TXFF_HIGH		4
+#define REG_SDIO_CMD_ADDR_TXFF_LOW		6
+#define REG_SDIO_CMD_ADDR_TXFF_NORMAL		5
+#define REG_SDIO_CMD_ADDR_TXFF_EXTRA		7
+#define REG_SDIO_CMD_ADDR_RXFF			7
+
+#define RTW_SDIO_BLOCK_SIZE			512
+#define RTW_SDIO_ADDR_RX_RX0FF_GEN(_id)		(0x0e000 | ((_id) & 0x3))
+
+#define RTW_SDIO_DATA_PTR_ALIGN			8
+
+struct sdio_func;
+struct sdio_device_id;
+
+struct rtw_sdio_tx_data {
+	u8 sn;
+};
+
+struct rtw_sdio_work_data {
+	struct work_struct work;
+	struct rtw_dev *rtwdev;
+};
+
+struct rtw_sdio {
+	struct sdio_func *sdio_func;
+
+	u32 irq_mask;
+	u8 rx_addr;
+	bool sdio3_bus_mode;
+
+	void *irq_thread;
+
+	struct workqueue_struct *txwq;
+	struct rtw_sdio_work_data *tx_handler_data;
+	struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
+};
+
+extern const struct dev_pm_ops rtw_sdio_pm_ops;
+
+int rtw_sdio_probe(struct sdio_func *sdio_func,
+		   const struct sdio_device_id *id);
+void rtw_sdio_remove(struct sdio_func *sdio_func);
+void rtw_sdio_shutdown(struct device *dev);
+
+static inline bool rtw_sdio_is_sdio30_supported(struct rtw_dev *rtwdev)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	return rtwsdio->sdio3_bus_mode;
+}
+
+#endif
-- 
2.40.0

