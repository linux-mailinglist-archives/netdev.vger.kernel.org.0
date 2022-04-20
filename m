Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5655089FE
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 16:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354200AbiDTOGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 10:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242928AbiDTOGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 10:06:18 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C803B43AC6
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:03:29 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id p18so2421770wru.5
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 07:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timebeat-app.20210112.gappssmtp.com; s=20210112;
        h=from:mime-version:date:subject:cc:to:message-id;
        bh=bbz7fVi1FgMNrNhXymQe56IZ479gDKzcHkiYm1Nuo7w=;
        b=54cmaRWMfyKrEyBk+8/TxNV/WCo7LNh80z826RY6U+QyyidIZF3J6RM+XEt0KGc4gg
         +rb5r5KrcVQvnYpNee5HRWuMKc6cSEOyAB/4448wSvfbbSUDRFttYrU5wNHSARCitxdv
         DFQvOzxb+MPDtso0F7ndzCU4C4mnzcj17l8uhOQiW30Z6mp10Qig8y2tEYKvJB1qDi04
         G2MSrE7+kAGzA58hpRCF1+4Zj+31R0o36AmY2zIIo8OcUnB8VAZ5LmARA09XFZyNa8IB
         W08ng1kXPPC8FMi9QSXZWt8NuSYsPoIMCcTa0GNyhO9cyLNMlNgFR3IBp94V6haC6uwH
         CbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:mime-version:date:subject:cc:to:message-id;
        bh=bbz7fVi1FgMNrNhXymQe56IZ479gDKzcHkiYm1Nuo7w=;
        b=SgudeHqkdETtYBSPY9iWU/B8dZh8IoFoOdrAIqRCGSBwoVTTlwyE+YYDWQDrXMHyE8
         QBw48htOxQQxXh14LmsYWSZdPIJtosjD0jsCAIYwu7aDPyC4DOUDRPlLP08G8dACiyFU
         SElvWx1B+50WE2dvwyELicvyhmrlYuYsh/drnVyoJGAwHtRZm/rdM6fw0iZIPi8VPTEQ
         5DsB/zhmeWvYWwv7tetMfXE8T3A+phqzFKlq5cmkNrbc6VMv/Y9ANDD2fdd9aik1SD2+
         H3exVbNZgbR7NiASGdu2lSxZSsmzFE1jSnIGq4U1u6LkVdwZ/3uEQBJkeVKM7s9QqT6S
         chSQ==
X-Gm-Message-State: AOAM530FZ/kL1w8Cbk1bRTWbboL24IyB9WCrF7oNr3nzgTOgL11lzKuQ
        C1kguLJinTFe1GaQvfVh2RETWUXojzLbew==
X-Google-Smtp-Source: ABdhPJy2he+mH8jwZr8dxCWku7ogG3/hGPMFSqLyot8CyNhwN4/lmJmXB7FU2PwfFsYRHo14vczXOg==
X-Received: by 2002:adf:f7cd:0:b0:207:a25c:24c4 with SMTP id a13-20020adff7cd000000b00207a25c24c4mr15918375wrq.528.1650463407931;
        Wed, 20 Apr 2022 07:03:27 -0700 (PDT)
Received: from smtpclient.apple ([95.175.197.5])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600002cb00b0020a88c4ecb5sm11757592wry.3.2022.04.20.07.03.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 07:03:27 -0700 (PDT)
From:   Lasse Johnsen <lasse@timebeat.app>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_020459A3-9970-424F-8372-99FDFDDFCECB"
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Date:   Wed, 20 Apr 2022 15:03:26 +0100
Subject: Support for IEEE1588 timestamping in the BCM54210PE PHY using the
 kernel mii_timestamper interface
Cc:     richardcochran@gmail.com,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>
To:     netdev@vger.kernel.org
Message-Id: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NEUTRAL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Apple-Mail=_020459A3-9970-424F-8372-99FDFDDFCECB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hello,


The attached set of patches adds support for the IEEE1588 functionality =
on the BCM54210PE PHY using the Linux Kernel mii_timestamper interface. =
The BCM54210PE PHY can be found in the Raspberry PI Compute Module 4 and =
the work has been undertaken by Timebeat.app on behalf of Raspberry PI =
with help and support from the nice engineers at Broadcom.


Design:

After the ethernet frames are identified using the ptp_classify_raw =
function, they are parsed through the mii_timestamper interface to the =
bcm54210pe_rxtstamp and bcm54210pe_txtstamp functions via the =
skb_defer_rx_timestamp and skb_clone_tx_timestamp kernel functions.=20

In both cases these functions enqueue the sk_buff ptrs and schedules a =
work struct thread that attaches timestamps and forward the skbs =
upstream via the netif_rx_ni and skb_complete_tx_timestamp in the =
bcm54210pe_run_rx_timestamp_match_thread and =
bcm54210pe_run_tx_timestamp_match_thread functions in a non-interrupt =
context.=20

The driver uses poll style behaviour triggered by the rx or tx of =
frames, but does not use a formal interrupt handler.

In addition to gettime, settime and adjtime and adjfine, I've =
implemented the gettimex64 function to provide the best possible sync of =
the kernel clock from the PHC. However, as the PHY is separated from the =
MAC by the MDIO bus, I cannot lock and prevent the scheduler from =
interrupting the 3-timestamp process, but performance is nonetheless =
reasonable and the kernel clock sees offset variations in the 1-2us =
range.


Features:

In addition the driver add support for perout and extts functionality =
using ptp_clock_request structs as provided for by the standard =
SO_TIMESTAMPING API.


Test & Performance:

We have tested the features and accuracy in our lab and are able as a =
client to run at -7 intervals without significant performance impact on =
a Raspberry PI CM4 on an IO board. We are able to maintain =
synchronisation of the PHC within +/-10ns of its grandmaster PTP source =
and the system clock within 1-2us of the PHC.


I look forward to receiving your feedback.


All the best,

Lasse


--Apple-Mail=_020459A3-9970-424F-8372-99FDFDDFCECB
Content-Disposition: attachment;
	filename=bcm54210pe-1588.patch.txt
Content-Type: text/plain;
	x-unix-mode=0644;
	name="bcm54210pe-1588.patch.txt"
Content-Transfer-Encoding: quoted-printable

=46rom bf2ec31ad461f2213e4f3850649e1d00953cf86d Mon Sep 17 00:00:00 2001
From: Lasse Johnsen <l@ssejohnsen.me>
Date: Sat, 5 Feb 2022 09:34:19 -0500
Subject: [PATCH] Added support for IEEE1588 timestamping for the =
BCM54210PE
 PHY using the kernel mii_timestamper interface

---
 arch/arm/configs/bcm2711_defconfig            |    1 +
 arch/arm64/configs/bcm2711_defconfig          |    1 +
 .../net/ethernet/broadcom/genet/bcmgenet.c    |   16 +-
 drivers/net/phy/Makefile                      |    1 +
 drivers/net/phy/bcm54210pe_ptp.c              | 1406 +++++++++++++++++
 drivers/net/phy/bcm54210pe_ptp.h              |  111 ++
 drivers/net/phy/broadcom.c                    |   21 +-
 drivers/ptp/Kconfig                           |   17 +
 8 files changed, 1572 insertions(+), 2 deletions(-)
 create mode 100755 drivers/net/phy/bcm54210pe_ptp.c
 create mode 100755 drivers/net/phy/bcm54210pe_ptp.h

diff --git a/arch/arm/configs/bcm2711_defconfig =
b/arch/arm/configs/bcm2711_defconfig
index 8f4ae82cade4f..c7f3cce0024b7 100644
--- a/arch/arm/configs/bcm2711_defconfig
+++ b/arch/arm/configs/bcm2711_defconfig
@@ -1402,6 +1402,7 @@ CONFIG_MAXIM_THERMOCOUPLE=3Dm
 CONFIG_MAX31856=3Dm
 CONFIG_PWM_BCM2835=3Dm
 CONFIG_PWM_PCA9685=3Dm
+CONFIG_GENERIC_PHY=3Dy
 CONFIG_RPI_AXIPERF=3Dm
 CONFIG_NVMEM_RMEM=3Dm
 CONFIG_EXT4_FS=3Dy
diff --git a/arch/arm64/configs/bcm2711_defconfig =
b/arch/arm64/configs/bcm2711_defconfig
index 75333e69ef741..2af6b2fc5dcda 100644
--- a/arch/arm64/configs/bcm2711_defconfig
+++ b/arch/arm64/configs/bcm2711_defconfig
@@ -1409,6 +1409,7 @@ CONFIG_MAXIM_THERMOCOUPLE=3Dm
 CONFIG_MAX31856=3Dm
 CONFIG_PWM_BCM2835=3Dm
 CONFIG_PWM_PCA9685=3Dm
+CONFIG_GENERIC_PHY=3Dy
 CONFIG_RPI_AXIPERF=3Dm
 CONFIG_ANDROID=3Dy
 CONFIG_ANDROID_BINDER_IPC=3Dy
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c =
b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index bd1f419bc47ae..2fa6258103025 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -39,8 +39,11 @@
=20
 #include <asm/unaligned.h>
=20
+#include <linux/ptp_classify.h>
+
 #include "bcmgenet.h"
=20
+
 /* Maximum number of hardware queues, downsized if needed */
 #define GENET_MAX_MQ_CNT	4
=20
@@ -2096,7 +2099,18 @@ static netdev_tx_t bcmgenet_xmit(struct sk_buff =
*skb, struct net_device *dev)
 	}
=20
 	GENET_CB(skb)->last_cb =3D tx_cb_ptr;
-	skb_tx_timestamp(skb);
+
+	// Timestamping
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))
+	{
+		//skb_shinfo(skb)->tx_flags |=3D SKBTX_IN_PROGRESS;
+		skb_pull(skb, skb_mac_offset(skb)); // Feels like this =
pull should really be part of ptp_classify_raw...
+		skb_clone_tx_timestamp(skb);
+	}
+	else if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_SW_TSTAMP))
+	{
+		skb_tstamp_tx(skb, NULL);
+	}
=20
 	/* Decrement total BD count and advance our write pointer */
 	ring->free_bds -=3D nr_frags + 1;
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index a13e402074cf8..528192d59d793 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -46,6 +46,7 @@ obj-$(CONFIG_BCM84881_PHY)	+=3D bcm84881.o
 obj-$(CONFIG_BCM87XX_PHY)	+=3D bcm87xx.o
 obj-$(CONFIG_BCM_CYGNUS_PHY)	+=3D bcm-cygnus.o
 obj-$(CONFIG_BCM_NET_PHYLIB)	+=3D bcm-phy-lib.o
+obj-$(CONFIG_BCM54120PE_PHY)	+=3D bcm54210pe_ptp.o
 obj-$(CONFIG_BROADCOM_PHY)	+=3D broadcom.o
 obj-$(CONFIG_CICADA_PHY)	+=3D cicada.o
 obj-$(CONFIG_CORTINA_PHY)	+=3D cortina.o
diff --git a/drivers/net/phy/bcm54210pe_ptp.c =
b/drivers/net/phy/bcm54210pe_ptp.c
new file mode 100755
index 0000000000000..c4882c84229f9
--- /dev/null
+++ b/drivers/net/phy/bcm54210pe_ptp.c
@@ -0,0 +1,1406 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ *  drivers/net/phy/bcm54210pe_ptp.c
+ *
+ * IEEE1588 (PTP), perout and extts for BCM54210PE PHY
+ *
+ * Authors: Carlos Fernandez, Kyle Judd, Lasse Johnsen
+ * License: GPL
+ */
+
+#include <linux/gpio/consumer.h>
+#include <linux/ip.h>                                                   =
                            =20
+#include <linux/net_tstamp.h>
+#include <linux/mii.h>
+#include <linux/phy.h>                                                  =
                            =20
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>                                     =
                            =20
+#include <linux/udp.h>
+#include <asm/unaligned.h>=20
+#include <linux/brcmphy.h>
+#include <linux/irq.h>
+#include <linux/workqueue.h>
+#include <linux/gpio.h>
+#include <linux/if_ether.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
+
+#include "bcm54210pe_ptp.h"
+#include "bcm-phy-lib.h"
+
+#define PTP_CONTROL_OFFSET		32
+#define PTP_TSMT_OFFSET 		0
+#define PTP_SEQUENCE_ID_OFFSET		30
+#define PTP_CLOCK_ID_OFFSET		20
+#define PTP_CLOCK_ID_SIZE		8
+#define PTP_SEQUENCE_PORT_NUMER_OFFSET  (PTP_CLOCK_ID_OFFSET + =
PTP_CLOCK_ID_SIZE)
+
+#define EXT_SELECT_REG			0x17
+#define EXT_DATA_REG			0x15
+
+#define EXT_ENABLE_REG1			0x17
+#define EXT_ENABLE_DATA1		0x0F7E
+#define EXT_ENABLE_REG2			0x15
+#define EXT_ENABLE_DATA2		0x0000
+
+#define EXT_1588_SLICE_REG		0x0810
+#define EXT_1588_SLICE_DATA		0x0101
+
+#define ORIGINAL_TIME_CODE_0 		0x0854
+#define ORIGINAL_TIME_CODE_1 		0x0855
+#define ORIGINAL_TIME_CODE_2 		0x0856
+#define ORIGINAL_TIME_CODE_3 		0x0857
+#define ORIGINAL_TIME_CODE_4 		0x0858
+
+#define TIME_STAMP_REG_0		0x0889
+#define TIME_STAMP_REG_1		0x088A
+#define TIME_STAMP_REG_2		0x088B
+#define TIME_STAMP_REG_3		0x08C4
+#define TIME_STAMP_INFO_1		0x088C
+#define TIME_STAMP_INFO_2		0x088D
+#define INTERRUPT_STATUS_REG		0x085F
+#define INTERRUPT_MASK_REG		0x085E
+#define EXT_SOFTWARE_RESET		0x0F70
+#define EXT_RESET1			0x0001 //RESET
+#define EXT_RESET2			0x0000 //NORMAL OPERATION
+#define GLOBAL_TIMESYNC_REG		0x0FF5
+
+#define TX_EVENT_MODE_REG		0x0811
+#define RX_EVENT_MODE_REG		0x0819
+#define TX_TSCAPTURE_ENABLE_REG		0x0821
+#define RX_TSCAPTURE_ENABLE_REG		0x0822
+#define TXRX_1588_OPTION_REG		0x0823
+
+#define TX_TS_OFFSET_LSB		0x0834
+#define TX_TS_OFFSET_MSB		0x0835
+#define RX_TS_OFFSET_LSB		0x0844
+#define RX_TS_OFFSET_MSB		0x0845
+#define NSE_DPPL_NCO_1_LSB_REG		0x0873
+#define NSE_DPPL_NCO_1_MSB_REG		0x0874
+
+#define NSE_DPPL_NCO_2_0_REG		0x0875
+#define NSE_DPPL_NCO_2_1_REG		0x0876
+#define NSE_DPPL_NCO_2_2_REG		0x0877
+
+#define NSE_DPPL_NCO_3_0_REG		0x0878
+#define NSE_DPPL_NCO_3_1_REG		0x0879
+#define NSE_DPPL_NCO_3_2_REG		0x087A
+
+#define NSE_DPPL_NCO_4_REG		0x087B
+
+#define NSE_DPPL_NCO_5_0_REG		0x087C
+#define NSE_DPPL_NCO_5_1_REG		0x087D
+#define NSE_DPPL_NCO_5_2_REG		0x087E
+
+#define NSE_DPPL_NCO_6_REG		0x087F
+
+#define NSE_DPPL_NCO_7_0_REG		0x0880
+#define NSE_DPPL_NCO_7_1_REG		0x0881
+
+#define DPLL_SELECT_REG			0x085b
+#define TIMECODE_SEL_REG		0x08C3
+#define SHADOW_REG_CONTROL		0x085C
+#define SHADOW_REG_LOAD			0x085D
+
+#define PTP_INTERRUPT_REG		0x0D0C
+
+#define CTR_DBG_REG			0x088E
+#define HEART_BEAT_REG4			0x08ED
+#define HEART_BEAT_REG3			0x08EC
+#define HEART_BEAT_REG2			0x0888
+#define	HEART_BEAT_REG1			0x0887
+#define	HEART_BEAT_REG0			0x0886
+=09
+#define READ_END_REG			0x0885
+
+static bool bcm54210pe_fetch_timestamp(u8 txrx, u8 message_type, u16 =
seq_id, struct bcm54210pe_private *private, u64 *timestamp)
+{
+	struct bcm54210pe_circular_buffer_item *item;=20
+	struct list_head *this, *next;
+
+	u8 index =3D (txrx * 4) + message_type;
+
+	if(index >=3D CIRCULAR_BUFFER_COUNT)
+	{
+		return false;
+	}
+
+	list_for_each_safe(this, next, =
&private->circular_buffers[index])
+	{
+		item =3D list_entry(this, struct =
bcm54210pe_circular_buffer_item, list);
+
+		if(item->sequence_id =3D=3D seq_id && item->is_valid)
+		{
+			item->is_valid =3D false;
+			*timestamp =3D item->time_stamp;
+			mutex_unlock(&private->timestamp_buffer_lock);
+			return true;
+		}
+	}
+
+	return false;
+}
+
+static void bcm54210pe_read_sop_time_register(struct bcm54210pe_private =
*private)
+{
+	struct phy_device *phydev =3D private->phydev;
+	struct bcm54210pe_circular_buffer_item *item;
+	u16 fifo_info_1, fifo_info_2;
+	u8 tx_or_rx, msg_type, index;
+	u16 sequence_id;
+	u64 timestamp;
+	u16 Time[4];
+
+	mutex_lock(&private->timestamp_buffer_lock);
+
+	while(bcm_phy_read_exp(phydev, INTERRUPT_STATUS_REG) & 2)
+	{
+		mutex_lock(&private->clock_lock);
+
+		// Flush out the FIFO
+		bcm_phy_write_exp(phydev, READ_END_REG, 1);
+
+		Time[3] =3D bcm_phy_read_exp(phydev, TIME_STAMP_REG_3);
+		Time[2] =3D bcm_phy_read_exp(phydev, TIME_STAMP_REG_2);
+		Time[1] =3D bcm_phy_read_exp(phydev, TIME_STAMP_REG_1);
+		Time[0] =3D bcm_phy_read_exp(phydev, TIME_STAMP_REG_0);
+
+		fifo_info_1 =3D bcm_phy_read_exp(phydev, =
TIME_STAMP_INFO_1);
+		fifo_info_2 =3D bcm_phy_read_exp(phydev, =
TIME_STAMP_INFO_2);
+
+		bcm_phy_write_exp(phydev, READ_END_REG, 2);
+		bcm_phy_write_exp(phydev, READ_END_REG, 0);
+
+		mutex_unlock(&private->clock_lock);
+
+		msg_type =3D (u8) ((fifo_info_2 & 0xF000) >> 12);
+		tx_or_rx =3D (u8) ((fifo_info_2 & 0x0800) >> 11); // 1 =3D=
 TX, 0 =3D RX
+		sequence_id =3D fifo_info_1;
+
+		timestamp =3D four_u16_to_ns(Time);
+
+		index =3D (tx_or_rx * 4) + msg_type;
+
+		if(index < CIRCULAR_BUFFER_COUNT)
+		{
+			item =3D =
list_first_entry_or_null(&private->circular_buffers[index], struct =
bcm54210pe_circular_buffer_item, list);
+		}
+
+		if(item =3D=3D NULL) {
+			continue;
+		}
+
+		list_del_init(&item->list);
+
+		item->msg_type =3D msg_type;
+		item->sequence_id =3D sequence_id;
+		item->time_stamp =3D timestamp;
+		item->is_valid =3D true;
+
+		list_add_tail(&item->list, =
&private->circular_buffers[index]);
+	}
+
+	mutex_unlock(&private->timestamp_buffer_lock);
+}
+
+static void bcm54210pe_run_rx_timestamp_match_thread(struct work_struct =
*w)
+{
+	struct bcm54210pe_private *private =3D
+		container_of(w, struct bcm54210pe_private, rxts_work);
+
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct ptp_header *hdr;
+	struct sk_buff *skb;
+
+	u8 msg_type;
+	u16 sequence_id;
+	u64 timestamp;
+	int x, type;
+
+	skb =3D skb_dequeue(&private->rx_skb_queue);
+
+	while (skb !=3D NULL) {
+
+		// Yes....  skb_defer_rx_timestamp just did this but =
<ZZZzzz>....
+		skb_push(skb, ETH_HLEN);
+		type =3D ptp_classify_raw(skb);
+		skb_pull(skb, ETH_HLEN);
+
+		hdr =3D ptp_parse_header(skb, type);
+
+		if (hdr =3D=3D NULL) {
+			goto dequeue;
+		}
+
+		msg_type =3D ptp_get_msgtype(hdr, type);
+		sequence_id =3D be16_to_cpu(hdr->sequence_id);
+
+		timestamp =3D 0;
+
+		for (x =3D 0; x < 10; x++) {
+			bcm54210pe_read_sop_time_register(private);
+			if (bcm54210pe_fetch_timestamp(0, msg_type, =
sequence_id,
+						       private, =
&timestamp)) {
+				break;
+			}
+
+			udelay(private->fib_sequence[x] *
+			       private->fib_factor_rx);
+		}
+
+		shhwtstamps =3D skb_hwtstamps(skb);
+
+		if (!shhwtstamps) {
+			goto dequeue;
+		}
+
+		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+		shhwtstamps->hwtstamp =3D ns_to_ktime(timestamp);
+
+	dequeue:
+		netif_rx_ni(skb);
+		skb =3D skb_dequeue(&private->rx_skb_queue);
+	}
+}
+
+static void bcm54210pe_run_tx_timestamp_match_thread(struct work_struct =
*w)
+{
+	struct bcm54210pe_private *private =3D
+		container_of(w, struct bcm54210pe_private, txts_work);
+
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct sk_buff *skb;
+
+	struct ptp_header *hdr;
+	u8 msg_type;
+	u16 sequence_id;
+	u64 timestamp;
+	int x;
+
+	timestamp =3D 0;
+	skb =3D skb_dequeue(&private->tx_skb_queue);
+
+	while (skb !=3D NULL) {
+		int type =3D ptp_classify_raw(skb);
+		hdr =3D ptp_parse_header(skb, type);
+
+		if (!hdr) {
+			return;
+		}
+
+		msg_type =3D ptp_get_msgtype(hdr, type);
+		sequence_id =3D be16_to_cpu(hdr->sequence_id);
+
+		for (x =3D 0; x < 10; x++) {
+			bcm54210pe_read_sop_time_register(private);
+			if (bcm54210pe_fetch_timestamp(1, msg_type, =
sequence_id,
+						       private, =
&timestamp)) {
+				break;
+			}
+			udelay(private->fib_sequence[x] * =
private->fib_factor_tx);
+		}
+		shhwtstamps =3D skb_hwtstamps(skb);
+
+		if (!shhwtstamps) {
+			kfree_skb(skb);
+			goto dequeue;
+		}
+
+		memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+		shhwtstamps->hwtstamp =3D ns_to_ktime(timestamp);
+
+		skb_complete_tx_timestamp(skb, shhwtstamps);
+
+	dequeue:
+		skb =3D skb_dequeue(&private->tx_skb_queue);
+	}
+}
+
+static int bcm54210pe_config_1588(struct phy_device *phydev)
+{
+	int err;
+
+	err =3D bcm_phy_write_exp(phydev, PTP_INTERRUPT_REG, 0x3c02 );
+
+	err |=3D  bcm_phy_write_exp(phydev, GLOBAL_TIMESYNC_REG, =
0x0001); //Enable global timesync register.
+	err |=3D  bcm_phy_write_exp(phydev, EXT_1588_SLICE_REG, 0x0101); =
//ENABLE TX and RX slice 1588
+	err |=3D  bcm_phy_write_exp(phydev, TX_EVENT_MODE_REG, 0xFF00); =
//Add 80bit timestamp + NO CPU MODE in TX
+	err |=3D  bcm_phy_write_exp(phydev, RX_EVENT_MODE_REG, 0xFF00); =
//Add 32+32 bits timestamp + NO CPU mode in RX
+	err |=3D  bcm_phy_write_exp(phydev, TIMECODE_SEL_REG, 0x0101); =
//Select 80 bit counter
+	err |=3D  bcm_phy_write_exp(phydev, TX_TSCAPTURE_ENABLE_REG, =
0x0001); //Enable timestamp capture in TX
+	err |=3D  bcm_phy_write_exp(phydev, RX_TSCAPTURE_ENABLE_REG, =
0x0001); //Enable timestamp capture in RX
+
+	//Enable shadow register
+	err |=3D bcm_phy_write_exp(phydev, SHADOW_REG_CONTROL, 0x0000);
+	err |=3D bcm_phy_write_exp(phydev, SHADOW_REG_LOAD, 0x07c0);
+
+
+	// Set global mode and trigger immediate framesync to load =
shaddow registers
+	err |=3D  bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, 0xC020);
+
+	//15, 33 or 41 - experimental
+	printk("DEBUG: GPIO %d IRQ %d\n", 15, gpio_to_irq(41));
+
+	// Enable Interrupt behaviour (eventhough we get no interrupts)
+	err |=3D bcm54210pe_interrupts_enable(phydev,true, false);
+=09
+	return err;=20
+}
+
+static int bcm54210pe_gettimex(struct ptp_clock_info *info,
+			       struct timespec64 *ts,
+			       struct ptp_system_timestamp *sts)
+{
+
+	struct bcm54210pe_ptp *ptp =3D container_of(info, struct =
bcm54210pe_ptp, caps);
+	return bcm54210pe_get80bittime(ptp->chosen, ts, sts);
+}
+
+// Must be called under clock_lock
+static void bcm54210pe_read80bittime_register(struct phy_device =
*phydev, u64 *time_stamp_80, u64 *time_stamp_48)
+{
+	u16 Time[5];
+	u64 ts[3];
+	u64 cumulative;
+
+	bcm_phy_write_exp(phydev, CTR_DBG_REG, 0x400);
+	Time[4] =3D bcm_phy_read_exp(phydev, HEART_BEAT_REG4);
+	Time[3] =3D bcm_phy_read_exp(phydev, HEART_BEAT_REG3);
+	Time[2] =3D bcm_phy_read_exp(phydev, HEART_BEAT_REG2);
+	Time[1] =3D bcm_phy_read_exp(phydev, HEART_BEAT_REG1);
+	Time[0] =3D bcm_phy_read_exp(phydev, HEART_BEAT_REG0);
+
+	// Set read end bit
+	bcm_phy_write_exp(phydev, CTR_DBG_REG, 0x800);
+	bcm_phy_write_exp(phydev, CTR_DBG_REG, 0x000);
+
+	*time_stamp_80 =3D four_u16_to_ns(Time);
+
+	if (time_stamp_48 !=3D NULL) {
+
+
+		ts[2] =3D (((u64)Time[2]) << 32);
+		ts[1] =3D (((u64)Time[1]) << 16);
+		ts[0] =3D ((u64)Time[0]);
+
+		cumulative =3D 0;
+		cumulative |=3D ts[0];
+		cumulative |=3D ts[1];
+		cumulative |=3D ts[2];
+
+		*time_stamp_48 =3D cumulative;
+	}
+}
+
+// Must be called under clock_lock
+static void bcm54210pe_read48bittime_register(struct phy_device =
*phydev, u64 *time_stamp)
+{
+	u16 Time[3];
+	u64 ts[3];
+	u64 cumulative;
+
+	bcm_phy_write_exp(phydev, CTR_DBG_REG, 0x400);
+	Time[2] =3D bcm_phy_read_exp(phydev, HEART_BEAT_REG2);
+	Time[1] =3D bcm_phy_read_exp(phydev, HEART_BEAT_REG1);
+	Time[0] =3D bcm_phy_read_exp(phydev, HEART_BEAT_REG0);
+
+	// Set read end bit
+	bcm_phy_write_exp(phydev, CTR_DBG_REG, 0x800);
+	bcm_phy_write_exp(phydev, CTR_DBG_REG, 0x000);
+
+
+	ts[2] =3D (((u64)Time[2]) << 32);
+	ts[1] =3D (((u64)Time[1]) << 16);
+	ts[0] =3D ((u64)Time[0]);
+
+	cumulative =3D 0;
+	cumulative |=3D ts[0];
+	cumulative |=3D ts[1];
+	cumulative |=3D ts[2];
+
+	*time_stamp =3D cumulative;
+}
+
+static int bcm54210pe_get80bittime(struct bcm54210pe_private *private,
+				   struct timespec64 *ts,
+				   struct ptp_system_timestamp *sts)
+{
+	struct phy_device *phydev;
+	u16 nco_6_register_value;
+	int i;
+	u64 time_stamp_48, time_stamp_80, control_ts;
+
+	phydev =3D private->phydev;
+
+	// Capture timestamp on next framesync
+	nco_6_register_value =3D 0x2000;
+
+	// Lock
+	mutex_lock(&private->clock_lock);
+
+	// We share frame sync events with extts, so we need to ensure =
no event has occurred as we are about to boot the registers, so....
+
+	// If extts is enabled
+	if (private->extts_en) {
+
+		// Halt framesyncs generated by the sync in pin
+		bcm_phy_modify_exp(phydev, NSE_DPPL_NCO_6_REG, 0x003C, =
0x0000);
+
+		// Read what's in the 8- bit register
+		bcm54210pe_read48bittime_register(phydev, &control_ts);
+
+		// If it matches neither the last gettime or extts =
timestamp
+		if (control_ts !=3D private->last_extts_ts && control_ts =
!=3D private->last_immediate_ts[0]) { // FIXME: This is a bug
+
+			// Odds are this is a extts not yet logged as an =
event
+			//printk("extts triggered by get80bittime\n");
+			bcm54210pe_trigger_extts_event(private, =
control_ts);
+		}
+	}
+
+	// Heartbeat register selection. Latch 80 bit Original time =
coude counter into Heartbeat register
+	// (this is undocumented)
+	bcm_phy_write_exp(phydev, DPLL_SELECT_REG, 0x0040);
+
+	// Amend to base register
+	nco_6_register_value =3D bcm54210pe_get_base_nco6_reg(private, =
nco_6_register_value, false);
+
+	// Set the NCO register
+	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, =
nco_6_register_value);
+
+	// Trigger framesync
+	if (sts !=3D NULL) {
+
+		// If we are doing a gettimex call
+		ptp_read_system_prets(sts);
+		bcm_phy_modify_exp(phydev, NSE_DPPL_NCO_6_REG, 0x003C, =
0x0020);
+		ptp_read_system_postts(sts);
+
+	} else {
+
+		// or if we are doing a gettime call
+		bcm_phy_modify_exp(phydev, NSE_DPPL_NCO_6_REG, 0x003C, =
0x0020);
+	}
+
+	for (i =3D 0; i < 5;i++) {
+
+		bcm54210pe_read80bittime_register(phydev, =
&time_stamp_80, &time_stamp_48);
+
+		if (time_stamp_80 !=3D 0) {
+			break;
+		}
+	}
+
+	// Convert to timespec64
+	ns_to_ts(time_stamp_80, ts);
+
+	// If we are using extts
+	if(private->extts_en) {
+
+		// Commit last timestamp
+	   	private->last_immediate_ts[0] =3D time_stamp_48;
+	    	private->last_immediate_ts[1] =3D time_stamp_80;
+
+		// Heartbeat register selection. Latch 48 bit Original =
time coude counter into Heartbeat register
+		// (this is undocumented)
+		bcm_phy_write_exp(phydev, DPLL_SELECT_REG, 0x0000);
+
+		// Rearm framesync for sync in pin
+		nco_6_register_value =3D =
bcm54210pe_get_base_nco6_reg(private, nco_6_register_value, false);
+		bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, =
nco_6_register_value);
+	}
+
+	mutex_unlock(&private->clock_lock);
+
+	return 0;
+}
+
+static int bcm54210pe_gettime(struct ptp_clock_info *info, struct =
timespec64 *ts)
+{
+	int err;
+	err =3D bcm54210pe_gettimex(info, ts, NULL);
+	return err;
+}
+
+static int bcm54210pe_get48bittime(struct bcm54210pe_private *private, =
u64 *timestamp)
+{
+	u16 nco_6_register_value;
+	int i, err;
+
+	struct phy_device *phydev =3D private->phydev;
+
+	// Capture timestamp on next framesync
+	nco_6_register_value =3D 0x2000;
+
+	mutex_lock(&private->clock_lock);
+
+	// Heartbeat register selection. Latch 48 bit Original time =
coude counter into Heartbeat register
+	// (this is undocumented)
+	err =3D bcm_phy_write_exp(phydev, DPLL_SELECT_REG, 0x0000);
+
+	// Amend to base register
+	nco_6_register_value =3D
+		bcm54210pe_get_base_nco6_reg(private, =
nco_6_register_value, false);
+
+	// Set the NCO register
+	err |=3D bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, =
nco_6_register_value);
+
+	// Trigger framesync
+	err |=3D bcm_phy_modify_exp(phydev, NSE_DPPL_NCO_6_REG, 0x003C, =
0x0020);
+
+	for (i =3D 0; i < 5; i++) {
+
+		bcm54210pe_read48bittime_register(phydev,timestamp);
+
+		if (*timestamp !=3D 0) {
+			break;
+		}
+	}
+	mutex_unlock(&private->clock_lock);
+
+	return err;
+}
+
+static int bcm54210pe_settime(struct ptp_clock_info *info, const struct =
timespec64 *ts)
+{
+	u16 shadow_load_register, nco_6_register_value;
+	u16 original_time_codes[5], local_time_codes[3];
+	struct bcm54210pe_ptp *ptp;
+	struct phy_device *phydev;
+
+	ptp =3D container_of(info, struct bcm54210pe_ptp, caps);
+	phydev =3D ptp->chosen->phydev;
+
+	shadow_load_register =3D 0;
+	nco_6_register_value =3D 0;
+
+	// Assign original time codes (80 bit)
+	original_time_codes[4] =3D (u16) ((ts->tv_sec & =
0x0000FFFF00000000) >> 32);
+	original_time_codes[3] =3D (u16) ((ts->tv_sec  & =
0x00000000FFFF0000) >> 16);
+	original_time_codes[2] =3D (u16) (ts->tv_sec  & =
0x000000000000FFFF);
+	original_time_codes[1] =3D (u16) ((ts->tv_nsec & =
0x00000000FFFF0000) >> 16);
+	original_time_codes[0] =3D (u16) (ts->tv_nsec & =
0x000000000000FFFF);
+
+	// Assign original time codes (48 bit)
+	local_time_codes[2] =3D 0x4000;
+	local_time_codes[1] =3D (u16) (ts->tv_nsec >> 20);
+	local_time_codes[0] =3D (u16) (ts->tv_nsec >> 4);
+
+	// Set Time Code load bit in the shadow load register
+	shadow_load_register |=3D 0x0400;
+
+	// Set Local Time load bit in the shadow load register
+	shadow_load_register |=3D 0x0080;
+
+	mutex_lock(&ptp->chosen->clock_lock);
+
+	// Write Original Time Code Register
+	bcm_phy_write_exp(phydev, ORIGINAL_TIME_CODE_0, =
original_time_codes[0]);
+	bcm_phy_write_exp(phydev, ORIGINAL_TIME_CODE_1, =
original_time_codes[1]);
+	bcm_phy_write_exp(phydev, ORIGINAL_TIME_CODE_2, =
original_time_codes[2]);
+	bcm_phy_write_exp(phydev, ORIGINAL_TIME_CODE_3, =
original_time_codes[3]);
+	bcm_phy_write_exp(phydev, ORIGINAL_TIME_CODE_4, =
original_time_codes[4]);
+
+	// Write Local Time Code Register
+	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_0_REG, =
local_time_codes[0]);
+	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_1_REG, =
local_time_codes[1]);
+	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_2_REG, =
local_time_codes[2]);
+
+	// Write Shadow register
+	bcm_phy_write_exp(phydev, SHADOW_REG_CONTROL, 0x0000);
+	bcm_phy_write_exp(phydev, SHADOW_REG_LOAD, =
shadow_load_register);
+
+	// Set global mode and nse_init
+	nco_6_register_value =3D =
bcm54210pe_get_base_nco6_reg(ptp->chosen, nco_6_register_value, true);
+
+	// Write to register
+	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, =
nco_6_register_value);
+
+	// Trigger framesync
+	bcm_phy_modify_exp(phydev, NSE_DPPL_NCO_6_REG, 0x003C, 0x0020);
+
+	// Set the second on set
+	ptp->chosen->second_on_set =3D ts->tv_sec;
+
+	mutex_unlock(&ptp->chosen->clock_lock);
+
+	return 0;
+}
+
+static int bcm54210pe_adjfine(struct ptp_clock_info *info, long =
scaled_ppm)
+{=09
+	int err;
+	u16 lo, hi;
+	u32 corrected_8ns_interval, base_8ns_interval;
+	bool negative;
+
+	struct bcm54210pe_ptp *ptp =3D container_of(info, struct =
bcm54210pe_ptp, caps);
+	struct phy_device *phydev =3D ptp->chosen->phydev;
+
+	negative =3D false;
+        if ( scaled_ppm < 0 ) {
+		negative =3D true;
+		scaled_ppm =3D -scaled_ppm;
+	}
+
+	// This is not completely accurate but very fast
+	scaled_ppm >>=3D 7;
+
+	// Nominal counter increment is 8ns
+	base_8ns_interval =3D 1 << 31;
+
+	// Add or subtract differential
+	if (negative) {
+		corrected_8ns_interval =3D base_8ns_interval - =
scaled_ppm;
+	} else {
+		corrected_8ns_interval =3D base_8ns_interval + =
scaled_ppm;
+	}
+
+	// Load up registers
+	hi =3D (corrected_8ns_interval & 0xFFFF0000) >> 16;
+	lo =3D (corrected_8ns_interval & 0x0000FFFF);
+
+	mutex_lock(&ptp->chosen->clock_lock);
+
+	// Set freq_mdio_sel to 1
+	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_2_2_REG, 0x4000);
+
+	// Load 125MHz frequency reqcntrl
+	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_1_MSB_REG, hi);
+	bcm_phy_write_exp(phydev, NSE_DPPL_NCO_1_LSB_REG, lo);
+
+	// On next framesync load freq from freqcntrl
+	bcm_phy_write_exp(phydev, SHADOW_REG_LOAD, 0x0040);
+
+	// Trigger framesync
+	err =3D bcm_phy_modify_exp(phydev, NSE_DPPL_NCO_6_REG, 0x003C, =
0x0020);
+
+	mutex_unlock(&ptp->chosen->clock_lock);
+
+	return err;
+}
+
+static int bcm54210pe_adjtime(struct ptp_clock_info *info, s64 delta)
+{
+	int err;
+	struct timespec64 ts;
+	u64 now;
+
+	err =3D bcm54210pe_gettime(info, &ts);
+	if (err < 0)
+		return err;
+
+	now =3D ktime_to_ns(timespec64_to_ktime(ts));
+	ts =3D ns_to_timespec64(now + delta);
+
+	err =3D bcm54210pe_settime(info, &ts);
+
+	return err;
+}
+
+
+static int bcm54210pe_extts_enable(struct bcm54210pe_private *private, =
int enable)
+{
+	int err;
+	struct phy_device *phydev;
+	u16 nco_6_register_value;
+
+	phydev =3D private->phydev;
+
+	if (enable) {
+
+		if (!private->extts_en) {
+
+			// Set enable per_out
+			private->extts_en =3D true;
+			err =3D bcm_phy_write_exp(phydev, =
NSE_DPPL_NCO_4_REG, 0x0001);
+
+			nco_6_register_value =3D 0;
+			nco_6_register_value =3D =
bcm54210pe_get_base_nco6_reg(private, nco_6_register_value, false);
+
+			err =3D bcm_phy_write_exp(phydev, =
NSE_DPPL_NCO_7_0_REG, 0x0100);
+			err =3D bcm_phy_write_exp(phydev, =
NSE_DPPL_NCO_7_1_REG, 0x0200);
+			err =3D bcm_phy_write_exp(phydev, =
NSE_DPPL_NCO_6_REG, nco_6_register_value);
+
+			schedule_delayed_work(&private->extts_ws, =
msecs_to_jiffies(1));
+		}
+
+	} else {
+		private->extts_en =3D false;
+		err =3D bcm_phy_write_exp(phydev, NSE_DPPL_NCO_4_REG, =
0x0000);
+
+	}
+
+	return err;
+}
+
+static void bcm54210pe_run_extts_thread(struct work_struct *extts_ws)
+{
+	struct bcm54210pe_private *private;
+	struct phy_device *phydev;
+	u64 interval, time_stamp_48, time_stamp_80;
+
+	private =3D container_of((struct delayed_work *)extts_ws, struct =
bcm54210pe_private, extts_ws);
+	phydev =3D private->phydev;
+
+	interval =3D 10;	// in ms - long after we are gone from =
this earth, discussions will be had and
+	  		// songs will be sung about whether this =
interval is short enough....
+			// Before you complain let me say that in =
Timebeat.app up to ~150ms allows
+			// single digit ns servo accuracy. If your =
client / servo is not as cool: Do better :-)
+
+	mutex_lock(&private->clock_lock);
+
+	bcm54210pe_read80bittime_register(phydev, &time_stamp_80, =
&time_stamp_48);
+
+
+	if (private->last_extts_ts !=3D time_stamp_48 &&
+	    private->last_immediate_ts[0] !=3D time_stamp_48 &&
+	    private->last_immediate_ts[1] !=3D time_stamp_80) {
+
+		bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, 0xE000);
+		bcm54210pe_trigger_extts_event(private, time_stamp_48);
+		bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, 0xE004);
+	}
+
+	mutex_unlock(&private->clock_lock);
+
+	// Do we need to reschedule
+	if (private->extts_en) {
+		schedule_delayed_work(&private->extts_ws, =
msecs_to_jiffies(interval));
+	}
+}
+
+// Must be called under clock_lock
+static void bcm54210pe_trigger_extts_event(struct bcm54210pe_private =
*private, u64 time_stamp)
+{
+
+	struct ptp_clock_event event;
+	struct timespec64 ts;
+
+	event.type =3D PTP_CLOCK_EXTTS;
+	event.timestamp =3D =
convert_48bit_to_80bit(private->second_on_set, time_stamp);
+	event.index =3D 0;
+
+	ptp_clock_event(private->ptp->ptp_clock, &event);
+
+    	private->last_extts_ts =3D time_stamp;
+
+	ns_to_ts(time_stamp, &ts);
+}
+
+static int bcm54210pe_perout_enable(struct bcm54210pe_private *private, =
s64 period, s64 pulsewidth, int enable)
+{
+	struct phy_device *phydev;
+	u16 nco_6_register_value, frequency_hi, frequency_lo, =
pulsewidth_reg, pulse_start_hi, pulse_start_lo;
+	int err;
+
+	phydev =3D private->phydev;
+
+	if (enable) {
+		frequency_hi =3D 0;
+		frequency_lo =3D 0;
+		pulsewidth_reg =3D 0;
+		pulse_start_hi =3D 0;
+		pulse_start_lo =3D 0;
+
+		// Convert interval pulse spacing (period) and =
pulsewidth to 8 ns units
+		period /=3D 8;
+		pulsewidth /=3D 8;
+
+		// Mode 2 only: If pulsewidth is not explicitly set with =
PTP_PEROUT_DUTY_CYCLE
+		if (pulsewidth =3D=3D 0) {
+			if (period < 2500) {
+				// At a frequency at less than 20us =
(2500 x 8ns) set pulse length to 1/10th of the interval pulse spacing
+				pulsewidth =3D period / 10;
+
+				// Where the interval pulse spacing is =
short, ensure we set a pulse length of 8ns
+				if (pulsewidth =3D=3D 0) {
+					pulsewidth =3D 1;
+				}
+
+			} else {
+				// Otherwise set pulse with to 4us (8ns =
x 500 =3D 4us)
+				pulsewidth =3D 500;
+			}
+		}
+
+		if (private->perout_mode =3D=3D SYNC_OUT_MODE_1) {
+
+			// Set period
+			private->perout_period =3D period;
+
+			if (!private->perout_en) {
+
+				// Set enable per_out
+				private->perout_en =3D true;
+				=
schedule_delayed_work(&private->perout_ws, msecs_to_jiffies(1));
+			}
+
+			err =3D 0;
+
+		} else if (private->perout_mode =3D=3D SYNC_OUT_MODE_2) =
{
+
+			// Set enable per_out
+			private->perout_en =3D true;
+
+			// Calculate registers
+			frequency_lo 	 =3D (u16)period; 			=
// Lowest 16 bits of 8ns interval pulse spacing [15:0]
+			frequency_hi	 =3D (u16) (0x3FFF & (period >> =
16));	// Highest 14 bits of 8ns interval pulse spacing [29:16]
+			frequency_hi	|=3D (u16) pulsewidth << 14; 		=
// 2 lowest bits of 8ns pulse length [1:0]
+			pulsewidth_reg	 =3D (u16) (0x7F & (pulsewidth =
>> 2));	// 7 highest bit  of 8 ns pulse length [8:2]
+
+			// Get base value
+			nco_6_register_value =3D =
bcm54210pe_get_base_nco6_reg(
+				private, nco_6_register_value, true);
+
+			mutex_lock(&private->clock_lock);
+
+			// Write to register
+			err =3D bcm_phy_write_exp(phydev, =
NSE_DPPL_NCO_6_REG,
+						nco_6_register_value);
+
+			// Set sync out pulse interval spacing and pulse =
length
+			err |=3D bcm_phy_write_exp(
+				phydev, NSE_DPPL_NCO_3_0_REG, =
frequency_lo);
+			err |=3D bcm_phy_write_exp(
+				phydev, NSE_DPPL_NCO_3_1_REG, =
frequency_hi);
+			err |=3D bcm_phy_write_exp(phydev,
+						 NSE_DPPL_NCO_3_2_REG,
+						 pulsewidth_reg);
+
+			// On next framesync load sync out frequency
+			err |=3D bcm_phy_write_exp(phydev, =
SHADOW_REG_LOAD,
+						 0x0200);
+
+			// Trigger immediate framesync framesync
+			err |=3D bcm_phy_modify_exp(
+				phydev, NSE_DPPL_NCO_6_REG, 0x003C, =
0x0020);
+
+			mutex_unlock(&private->clock_lock);
+		}
+	} else {
+
+		// Set disable pps
+		private->perout_en =3D false;
+
+		// Get base value
+		nco_6_register_value =3D =
bcm54210pe_get_base_nco6_reg(private, nco_6_register_value, false);
+
+		mutex_lock(&private->clock_lock);
+
+		// Write to register
+		err =3D bcm_phy_write_exp(phydev, NSE_DPPL_NCO_6_REG, =
nco_6_register_value);
+
+		mutex_unlock(&private->clock_lock);
+	}
+
+	return err;
+}
+
+static void bcm54210pe_run_perout_mode_one_thread(struct work_struct =
*perout_ws)
+{
+	struct bcm54210pe_private *private;
+	u64 local_time_stamp_48bits; //, local_time_stamp_80bits;
+	u64 next_event, time_before_next_pulse, period;
+	u16 nco_6_register_value, pulsewidth_nco3_hack;
+	u64 wait_one, wait_two;
+
+	private =3D container_of((struct delayed_work *)perout_ws, =
struct bcm54210pe_private, perout_ws);
+	period =3D private->perout_period * 8;
+	pulsewidth_nco3_hack =3D 250; // The BCM chip is broken. It does =
not respect this in sync out mode 1
+
+	nco_6_register_value =3D 0;
+
+	// Get base value
+	nco_6_register_value =3D bcm54210pe_get_base_nco6_reg(private, =
nco_6_register_value, false);
+
+	// Get 48 bit local time
+	bcm54210pe_get48bittime(private, &local_time_stamp_48bits);
+
+	// Calculate time before next event and next event time
+	time_before_next_pulse =3D  period - (local_time_stamp_48bits % =
period);
+	next_event =3D local_time_stamp_48bits + time_before_next_pulse;
+
+	// Lock
+	mutex_lock(&private->clock_lock);
+
+	// Set pulsewidth (test reveal this does not work), but =
registers need content or no pulse will exist
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_3_1_REG, =
pulsewidth_nco3_hack << 14);
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_3_2_REG, =
pulsewidth_nco3_hack >> 2);
+
+	// Set sync out pulse interval spacing and pulse length
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_5_0_REG, =
next_event & 0xFFF0);
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_5_1_REG, =
next_event >> 16);
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_5_2_REG, =
next_event >> 32);
+
+	// On next framesync load sync out frequency
+	bcm_phy_write_exp(private->phydev, SHADOW_REG_LOAD, 0x0200);
+
+	// Write to register with mode one set for sync out
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_6_REG, =
nco_6_register_value || 0x0001);
+
+	// Trigger immediate framesync framesync
+	bcm_phy_modify_exp(private->phydev, NSE_DPPL_NCO_6_REG, 0x003C, =
0x0020);
+
+	// Unlock
+	mutex_unlock(&private->clock_lock);
+
+	// Wait until 1/10 period after the next pulse
+	wait_one =3D (time_before_next_pulse / 1000000) + (period / =
1000000 / 10);
+	mdelay(wait_one);
+
+	// Lock
+	mutex_lock(&private->clock_lock);
+
+	// Clear pulse by bumping sync_out_match to max (this pulls sync =
out down)
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_5_0_REG, =
0xFFF0);
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_5_1_REG, =
0xFFFF);
+	bcm_phy_write_exp(private->phydev, NSE_DPPL_NCO_5_2_REG, =
0xFFFF);
+
+	// On next framesync load sync out frequency
+	bcm_phy_write_exp(private->phydev, SHADOW_REG_LOAD, 0x0200);
+
+	// Trigger immediate framesync framesync
+	bcm_phy_modify_exp(private->phydev, NSE_DPPL_NCO_6_REG, 0x003C, =
0x0020);
+
+	// Unlock
+	mutex_unlock(&private->clock_lock);
+
+	// Calculate wait before we reschedule the next pulse
+	wait_two =3D (period / 1000000) - (2 * (period / 10000000));
+
+	// Do we need to reschedule
+	if (private->perout_en) {
+		schedule_delayed_work(&private->perout_ws, =
msecs_to_jiffies(wait_two));
+	}
+}
+
+
+bool bcm54210pe_rxtstamp(struct mii_timestamper *mii_ts, struct sk_buff =
*skb, int type)
+{
+	struct bcm54210pe_private *private =3D container_of(mii_ts, =
struct bcm54210pe_private, mii_ts);
+
+	if (private->hwts_rx_en) {
+		skb_queue_tail(&private->rx_skb_queue, skb);
+		schedule_work(&private->rxts_work);
+		return true;
+	}
+
+	return false;
+}
+
+void bcm54210pe_txtstamp(struct mii_timestamper *mii_ts, struct sk_buff =
*skb, int type)
+{
+	struct bcm54210pe_private *private =3D container_of(mii_ts, =
struct bcm54210pe_private, mii_ts);
+
+	switch (private->hwts_tx_en)
+	{
+		case HWTSTAMP_TX_ON:
+		{=09
+			skb_shinfo(skb)->tx_flags |=3D =
SKBTX_IN_PROGRESS;
+			skb_queue_tail(&private->tx_skb_queue, skb);
+			schedule_work(&private->txts_work);
+			break;
+		}
+		case HWTSTAMP_TX_OFF:
+		{=09
+	=09
+		}
+		default:
+		{
+			kfree_skb(skb);
+			break;
+		}
+	}
+}
+
+int bcm54210pe_ts_info(struct mii_timestamper *mii_ts, struct =
ethtool_ts_info *info)
+{
+	struct bcm54210pe_private *bcm54210pe =3D container_of(mii_ts, =
struct bcm54210pe_private, mii_ts);
+
+	info->so_timestamping =3D
+		SOF_TIMESTAMPING_TX_HARDWARE |
+		SOF_TIMESTAMPING_RX_HARDWARE |
+		SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	info->phc_index =3D ptp_clock_index(bcm54210pe->ptp->ptp_clock);
+	info->tx_types =3D
+		(1 << HWTSTAMP_TX_OFF) |
+		(1 << HWTSTAMP_TX_ON) ;
+      	info->rx_filters =3D
+                (1 << HWTSTAMP_FILTER_NONE) |
+                (1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
+                (1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
+	return 0;
+}
+
+int bcm54210pe_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq =
*ifr)
+{
+	struct bcm54210pe_private *device =3D container_of(mii_ts, =
struct bcm54210pe_private, mii_ts);
+
+	struct hwtstamp_config cfg;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.flags) /* reserved for future extensions */
+		return -EINVAL;
+
+	if (cfg.tx_type < 0 || cfg.tx_type > HWTSTAMP_TX_ONESTEP_SYNC)
+		return -ERANGE;
+
+	device->hwts_tx_en =3D cfg.tx_type;
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		device->hwts_rx_en =3D 0;
+		device->layer =3D 0;
+		device->version =3D 0;
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		device->hwts_rx_en =3D 1;
+		device->layer =3D PTP_CLASS_L4;
+		device->version =3D PTP_CLASS_V1;
+		cfg.rx_filter =3D HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		device->hwts_rx_en =3D 1;
+		device->layer =3D PTP_CLASS_L4;
+		device->version =3D PTP_CLASS_V2;
+		cfg.rx_filter =3D HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		device->hwts_rx_en =3D 1;
+		device->layer =3D PTP_CLASS_L2;
+		device->version =3D PTP_CLASS_V2;
+		cfg.rx_filter =3D HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		device->hwts_rx_en =3D 1;
+		device->layer =3D PTP_CLASS_L4 | PTP_CLASS_L2;
+		device->version =3D PTP_CLASS_V2;
+		cfg.rx_filter =3D HWTSTAMP_FILTER_PTP_V2_EVENT;
+		break;
+	default:
+		return -ERANGE;
+	}
+=09
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT =
: 0;
+}
+
+static int bcm54210pe_feature_enable(struct ptp_clock_info *info, =
struct ptp_clock_request *req, int on)
+{
+	struct bcm54210pe_ptp *ptp =3D container_of(info, struct =
bcm54210pe_ptp, caps);
+	s64 period, pulsewidth;
+	struct timespec64 ts;
+
+	switch (req->type) {
+
+	case PTP_CLK_REQ_PEROUT :
+
+		period =3D 0;
+		pulsewidth =3D 0;
+
+		// Check if pin func is set correctly
+		if (ptp->chosen->sdp_config[SYNC_OUT_PIN].func !=3D =
PTP_PF_PEROUT) {
+			return -EOPNOTSUPP;
+		}
+
+		// No other flags supported
+		if (req->perout.flags & ~PTP_PEROUT_DUTY_CYCLE) {
+			return -EOPNOTSUPP;
+		}
+
+		// Check if a specific pulsewidth is set
+		if ((req->perout.flags & PTP_PEROUT_DUTY_CYCLE) > 0) {
+
+			if (ptp->chosen->perout_mode =3D=3D =
SYNC_OUT_MODE_1) {
+				return -EOPNOTSUPP;
+			}
+
+			// Extract pulsewidth
+			ts.tv_sec =3D req->perout.on.sec;
+			ts.tv_nsec =3D req->perout.on.nsec;
+			pulsewidth =3D timespec64_to_ns(&ts);
+
+			// 9 bits in 8ns units, so max =3D 4,088ns
+			if (pulsewidth > 511 * 8) {
+				return -ERANGE;
+			}
+		}
+
+		// Extract pulse spacing interval (period)
+		ts.tv_sec =3D req->perout.period.sec;
+		ts.tv_nsec =3D req->perout.period.nsec;
+		period =3D timespec64_to_ns(&ts);
+
+		// 16ns is minimum pulse spacing interval (a value of 16 =
will result in 8ns high followed by 8 ns low)
+		if (period !=3D 0 && period < 16) {
+			return -ERANGE;
+		}
+
+		return bcm54210pe_perout_enable(ptp->chosen, period, =
pulsewidth, on);
+
+	case PTP_CLK_REQ_EXTTS:
+
+		if (ptp->chosen->sdp_config[SYNC_IN_PIN].func !=3D =
PTP_PF_EXTTS) {
+			return -EOPNOTSUPP;
+		}
+
+		return bcm54210pe_extts_enable(ptp->chosen, on);
+
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+
+static int bcm54210pe_ptp_verify_pin(struct ptp_clock_info *info, =
unsigned int pin,
+			      enum ptp_pin_function func, unsigned int =
chan)
+{
+	switch (func) {
+	case PTP_PF_NONE:
+		return 0;
+		break;
+	case PTP_PF_EXTTS:
+		if (pin =3D=3D SYNC_IN_PIN)
+			return 0;
+		break;
+	case PTP_PF_PEROUT:
+		if (pin =3D=3D SYNC_OUT_PIN)
+			return 0;
+		break;
+	case PTP_PF_PHYSYNC:
+		break;
+	}
+	return -1;
+}
+
+static const struct ptp_clock_info bcm54210pe_clk_caps =3D {
+        .owner          =3D THIS_MODULE,
+        .name           =3D "BCM54210PE_PHC",
+        .max_adj        =3D 100000000,
+        .n_alarm        =3D 0,
+        .n_pins         =3D 2,
+        .n_ext_ts       =3D 1,
+        .n_per_out      =3D 1,
+        .pps            =3D 0,
+        .adjtime        =3D &bcm54210pe_adjtime,
+        .adjfine        =3D &bcm54210pe_adjfine,
+        .gettime64      =3D &bcm54210pe_gettime,
+	.gettimex64	=3D &bcm54210pe_gettimex,
+        .settime64      =3D &bcm54210pe_settime,
+	.enable		=3D &bcm54210pe_feature_enable,
+	.verify		=3D &bcm54210pe_ptp_verify_pin,
+};
+
+static int bcm54210pe_interrupts_enable(struct phy_device *phydev, bool =
fsync_en, bool sop_en)
+{
+	u16 interrupt_mask;
+
+	interrupt_mask =3D 0;
+
+	if (fsync_en) {
+		interrupt_mask |=3D 0x0001;
+	}
+
+	if (sop_en) {
+		interrupt_mask |=3D 0x0002;
+	}
+
+	return bcm_phy_write_exp(phydev, INTERRUPT_MASK_REG, =
interrupt_mask);
+}
+
+static int bcm54210pe_sw_reset(struct phy_device *phydev)
+{
+	u16 err;
+	u16 aux;
+       =20
+	err =3D  bcm_phy_write_exp(phydev, EXT_SOFTWARE_RESET, =
EXT_RESET1);
+	err =3D bcm_phy_read_exp(phydev, EXT_ENABLE_REG1);
+        if (err < 0)
+                return err;
+
+        err =3D bcm_phy_write_exp(phydev, EXT_SOFTWARE_RESET, =
EXT_RESET2);
+	aux =3D bcm_phy_read_exp(phydev, EXT_SOFTWARE_RESET);
+        return err;
+}
+
+int bcm54210pe_probe(struct phy_device *phydev)
+{
+	int x, y;
+	struct bcm54210pe_ptp *ptp;
+        struct bcm54210pe_private *bcm54210pe;
+	struct ptp_pin_desc *sync_in_pin_desc, *sync_out_pin_desc;
+
+	bcm54210pe_sw_reset(phydev);
+	bcm54210pe_config_1588(phydev);
+
+	bcm54210pe =3D kzalloc(sizeof(struct bcm54210pe_private), =
GFP_KERNEL);
+        if (!bcm54210pe) {
+		return -ENOMEM;
+	}
+
+	ptp =3D kzalloc(sizeof(struct bcm54210pe_ptp), GFP_KERNEL);
+        if (!ptp) {
+		return -ENOMEM;
+	}
+
+	bcm54210pe->phydev =3D phydev;
+	bcm54210pe->ptp =3D ptp;
+
+	bcm54210pe->mii_ts.rxtstamp =3D bcm54210pe_rxtstamp;
+	bcm54210pe->mii_ts.txtstamp =3D bcm54210pe_txtstamp;
+	bcm54210pe->mii_ts.hwtstamp =3D bcm54210pe_hwtstamp;
+	bcm54210pe->mii_ts.ts_info  =3D bcm54210pe_ts_info;
+
+
+	phydev->mii_ts =3D &bcm54210pe->mii_ts;
+
+	// Initialisation of work_structs and similar
+	INIT_WORK(&bcm54210pe->txts_work, =
bcm54210pe_run_tx_timestamp_match_thread);
+	INIT_WORK(&bcm54210pe->rxts_work, =
bcm54210pe_run_rx_timestamp_match_thread);
+	INIT_DELAYED_WORK(&bcm54210pe->perout_ws, =
bcm54210pe_run_perout_mode_one_thread);
+	INIT_DELAYED_WORK(&bcm54210pe->extts_ws, =
bcm54210pe_run_extts_thread);
+
+	// SKB queues
+	skb_queue_head_init(&bcm54210pe->tx_skb_queue);
+	skb_queue_head_init(&bcm54210pe->rx_skb_queue);
+
+	for (x =3D 0; x < CIRCULAR_BUFFER_COUNT; x++)
+	{=20
+		INIT_LIST_HEAD(&bcm54210pe->circular_buffers[x]);
+=09
+		for (y =3D 0; y < CIRCULAR_BUFFER_ITEM_COUNT; y++)
+		{ =
list_add(&bcm54210pe->circular_buffer_items[x][y].list, =
&bcm54210pe->circular_buffers[x]); }
+	}
+
+	// Caps
+	memcpy(&bcm54210pe->ptp->caps, &bcm54210pe_clk_caps, =
sizeof(bcm54210pe_clk_caps));
+	bcm54210pe->ptp->caps.pin_config =3D bcm54210pe->sdp_config;
+
+	// Mutex
+	mutex_init(&bcm54210pe->clock_lock);
+	mutex_init(&bcm54210pe->timestamp_buffer_lock);
+
+	// Features
+	bcm54210pe->one_step =3D false;
+	bcm54210pe->extts_en =3D false;
+	bcm54210pe->perout_en =3D false;
+	bcm54210pe->perout_mode =3D SYNC_OUT_MODE_1;
+
+	// Fibonacci RSewoke style progressive backoff scheme
+	bcm54210pe->fib_sequence[0] =3D 1;
+	bcm54210pe->fib_sequence[1] =3D 1;
+	bcm54210pe->fib_sequence[2] =3D 2;
+	bcm54210pe->fib_sequence[3] =3D 3;
+	bcm54210pe->fib_sequence[4] =3D 5;
+	bcm54210pe->fib_sequence[5] =3D 8;
+	bcm54210pe->fib_sequence[6] =3D 13;
+	bcm54210pe->fib_sequence[7] =3D 21;
+	bcm54210pe->fib_sequence[8] =3D 34;
+	bcm54210pe->fib_sequence[9] =3D 55;
+
+	//bcm54210pe->fib_sequence =3D {1, 1, 2, 3, 5, 8, 13, 21, 34, =
55};
+	bcm54210pe->fib_factor_rx =3D 10;
+	bcm54210pe->fib_factor_tx =3D 10;
+
+	// Pin descriptions
+	sync_in_pin_desc =3D &bcm54210pe->sdp_config[SYNC_IN_PIN];
+	snprintf(sync_in_pin_desc->name, sizeof(sync_in_pin_desc->name), =
"SYNC_IN");
+	sync_in_pin_desc->index =3D SYNC_IN_PIN;
+	sync_in_pin_desc->func =3D PTP_PF_NONE;
+
+	sync_out_pin_desc =3D &bcm54210pe->sdp_config[SYNC_OUT_PIN];
+	snprintf(sync_out_pin_desc->name, =
sizeof(sync_out_pin_desc->name), "SYNC_OUT");
+	sync_out_pin_desc->index =3D SYNC_OUT_PIN;
+	sync_out_pin_desc->func =3D PTP_PF_NONE;
+
+	ptp->chosen =3D bcm54210pe;
+	phydev->priv =3D bcm54210pe;
+	ptp->caps.owner =3D THIS_MODULE;
+
+	bcm54210pe->ptp->ptp_clock =3D =
ptp_clock_register(&bcm54210pe->ptp->caps, &phydev->mdio.dev);
+
+	if (IS_ERR(bcm54210pe->ptp->ptp_clock)) {
+                        return PTR_ERR(bcm54210pe->ptp->ptp_clock);
+	}
+
+	return 0;
+}
+
+static u16 bcm54210pe_get_base_nco6_reg(struct bcm54210pe_private =
*private, u16 val, bool do_nse_init)
+{
+
+	// Set Global mode to CPU system
+	val |=3D 0xC000;
+
+	// NSE init
+	if (do_nse_init) {
+		val |=3D 0x1000;
+	}
+
+	if (private->extts_en) {
+		val |=3D 0x2004;
+	}
+
+	if(private->perout_en) {
+		if (private->perout_mode =3D=3D SYNC_OUT_MODE_1) {
+			val |=3D 0x0001;
+		} else if (private->perout_mode =3D=3D SYNC_OUT_MODE_2) =
{
+			val |=3D 0x0002;
+		}
+	}
+
+	return val;
+}
+
+
+static u64 convert_48bit_to_80bit(u64 second_on_set, u64 ts)
+{
+	return (second_on_set * 1000000000) + ts;
+}
+
+static u64 four_u16_to_ns(u16 *four_u16)
+{
+	u32 seconds;
+	u32 nanoseconds;
+	struct timespec64 ts;
+	u16 *ptr;
+
+	nanoseconds =3D 0;
+	seconds =3D 0;
+
+
+	ptr =3D (u16 *)&nanoseconds;
+	*ptr =3D four_u16[0]; ptr++; *ptr =3D four_u16[1];
+
+	ptr =3D (u16 *)&seconds;
+	*ptr =3D four_u16[2]; ptr++; *ptr =3D four_u16[3];
+
+	ts.tv_sec =3D seconds;
+	ts.tv_nsec =3D nanoseconds;
+
+	return ts_to_ns(&ts);
+}
+
+static u64 ts_to_ns(struct timespec64 *ts)
+{
+	return ((u64)ts->tv_sec * (u64)1000000000) + ts->tv_nsec;
+}
+
+static void ns_to_ts(u64 time_stamp, struct timespec64 *ts)
+{
+	ts->tv_sec  =3D ( (u64)time_stamp / (u64)1000000000 );
+	ts->tv_nsec =3D ( (u64)time_stamp % (u64)1000000000 );
+}
diff --git a/drivers/net/phy/bcm54210pe_ptp.h =
b/drivers/net/phy/bcm54210pe_ptp.h
new file mode 100755
index 0000000000000..483dafc2d4514
--- /dev/null
+++ b/drivers/net/phy/bcm54210pe_ptp.h
@@ -0,0 +1,111 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ *  drivers/net/phy/bcm54210pe_ptp.h
+ *
+* IEEE1588 (PTP), perout and extts for BCM54210PE PHY
+ *
+ * Authors: Carlos Fernandez, Kyle Judd, Lasse Johnsen
+ * License: GPL
+ */
+
+#include <linux/ptp_clock_kernel.h>
+#include <linux/list.h>
+
+#define CIRCULAR_BUFFER_COUNT 8
+#define CIRCULAR_BUFFER_ITEM_COUNT 32
+
+#define SYNC_IN_PIN 0
+#define SYNC_OUT_PIN 1
+
+#define SYNC_OUT_MODE_1 1
+#define SYNC_OUT_MODE_2 2
+
+#define DIRECTION_RX 0
+#define DIRECTION_TX 1
+
+struct bcm54210pe_ptp {
+	struct ptp_clock_info caps;
+	struct ptp_clock *ptp_clock;
+	struct bcm54210pe_private *chosen;
+};
+
+struct bcm54210pe_circular_buffer_item {
+	struct list_head list;
+
+	u8 msg_type;
+	u16 sequence_id;
+	u64 time_stamp;
+	bool is_valid;
+};
+
+struct bcm54210pe_private {
+	struct phy_device *phydev;
+	struct bcm54210pe_ptp *ptp;
+	struct mii_timestamper mii_ts;
+	struct ptp_pin_desc sdp_config[2];
+
+	int ts_tx_config;
+	int tx_rx_filter;
+
+	bool one_step;
+	bool perout_en;
+	bool extts_en;
+
+	int second_on_set;
+
+	int perout_mode;
+	int perout_period;
+	int perout_pulsewidth;
+
+	u64 last_extts_ts;
+	u64 last_immediate_ts[2];
+
+	struct sk_buff_head tx_skb_queue;
+	struct sk_buff_head rx_skb_queue;
+
+	struct bcm54210pe_circular_buffer_item
+		circular_buffer_items[CIRCULAR_BUFFER_COUNT]
+				     [CIRCULAR_BUFFER_ITEM_COUNT];
+	struct list_head circular_buffers[CIRCULAR_BUFFER_COUNT];
+
+	struct work_struct txts_work, rxts_work;
+	struct delayed_work perout_ws, extts_ws;
+	struct mutex clock_lock, timestamp_buffer_lock;
+
+	int fib_sequence[10];
+
+	int fib_factor_rx;
+	int fib_factor_tx;
+
+	int hwts_tx_en;
+	int hwts_rx_en;
+	int layer;
+	int version;
+};
+
+static bool bcm54210pe_rxtstamp(struct mii_timestamper *mii_ts, struct =
sk_buff *skb, int type);
+static void bcm54210pe_txtstamp(struct mii_timestamper *mii_ts, struct =
sk_buff *skb, int type);
+static void bcm54210pe_run_rx_timestamp_match_thread(struct work_struct =
*w);
+static void bcm54210pe_run_tx_timestamp_match_thread(struct work_struct =
*w);
+static void bcm54210pe_read_sop_time_register(struct bcm54210pe_private =
*private);
+static bool bcm54210pe_fetch_timestamp(u8 txrx, u8 message_type, u16 =
seq_id, struct bcm54210pe_private *private, u64 *timestamp);
+
+static u16  bcm54210pe_get_base_nco6_reg(struct bcm54210pe_private =
*private, u16 val, bool do_nse_init);
+static int  bcm54210pe_interrupts_enable(struct phy_device *phydev, =
bool fsync_en, bool sop_en);
+static int  bcm54210pe_gettimex(struct ptp_clock_info *info, struct =
timespec64 *ts, struct ptp_system_timestamp *sts);
+static int  bcm54210pe_get80bittime(struct bcm54210pe_private *private, =
struct timespec64 *ts, struct ptp_system_timestamp *sts);
+static int  bcm54210pe_get48bittime(struct bcm54210pe_private *private, =
u64 *time_stamp);
+static void bcm54210pe_read80bittime_register(struct phy_device =
*phydev, u64 *time_stamp_80, u64 *time_stamp_48);
+static void bcm54210pe_read48bittime_register(struct phy_device =
*phydev, u64 *time_stamp);
+
+static int  bcm54210pe_perout_enable(struct bcm54210pe_private =
*private, s64 period, s64 pulsewidth, int on);
+static void bcm54210pe_run_perout_mode_one_thread(struct work_struct =
*perout_ws);
+
+static int  bcm54210pe_extts_enable(struct bcm54210pe_private *private, =
int enable);
+static void bcm54210pe_run_extts_thread(struct work_struct *extts_ws);
+static void bcm54210pe_trigger_extts_event(struct bcm54210pe_private =
*private, u64 timestamp);
+
+static u64  convert_48bit_to_80bit(u64 second_on_set, u64 ts);
+static u64  four_u16_to_ns(u16 *four_u16);
+static u64  ts_to_ns(struct timespec64 *ts);
+static void ns_to_ts(u64 time_stamp, struct timespec64 *ts);
diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 8b0ac38742d06..c8b79522cf3ad 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -15,6 +15,11 @@
 #include <linux/phy.h>
 #include <linux/brcmphy.h>
 #include <linux/of.h>
+#include <linux/irq.h>
+
+#if IS_ENABLED (CONFIG_BCM54120PE_PHY)
+extern int bcm54210pe_probe(struct phy_device *phydev);
+#endif
=20
 #define BRCM_PHY_MODEL(phydev) \
 	((phydev)->drv->phy_id & (phydev)->drv->phy_id_mask)
@@ -778,7 +783,20 @@ static struct phy_driver broadcom_drivers[] =3D {
 	.config_init	=3D bcm54xx_config_init,
 	.ack_interrupt	=3D bcm_phy_ack_intr,
 	.config_intr	=3D bcm_phy_config_intr,
-}, {
+},
+
+#if IS_ENABLED (CONFIG_BCM54120PE_PHY)
+{
+	.phy_id		=3D PHY_ID_BCM54213PE,
+	.phy_id_mask	=3D 0xffffffff,
+        .name           =3D "Broadcom BCM54210PE",
+        /* PHY_GBIT_FEATURES */
+        .config_init    =3D bcm54xx_config_init,
+        .ack_interrupt  =3D bcm_phy_ack_intr,
+        .config_intr    =3D bcm_phy_config_intr,
+	.probe		=3D bcm54210pe_probe,
+#elif
+{=20
 	.phy_id		=3D PHY_ID_BCM54213PE,
 	.phy_id_mask	=3D 0xffffffff,
 	.name		=3D "Broadcom BCM54213PE",
@@ -786,6 +804,7 @@ static struct phy_driver broadcom_drivers[] =3D {
 	.config_init	=3D bcm54xx_config_init,
 	.ack_interrupt	=3D bcm_phy_ack_intr,
 	.config_intr	=3D bcm_phy_config_intr,
+#endif
 }, {
 	.phy_id		=3D PHY_ID_BCM5461,
 	.phy_id_mask	=3D 0xfffffff0,
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
index 3e377f3c69e5d..975a62286a9c6 100644
--- a/drivers/ptp/Kconfig
+++ b/drivers/ptp/Kconfig
@@ -87,6 +87,23 @@ config PTP_1588_CLOCK_INES
 	  core.  This clock is only useful if the MII bus of your MAC
 	  is wired up to the core.
=20
+ config BCM54120PE_PHY
+	tristate "Add suport for ptp in bcm54210pe PHYs"
+	depends on NETWORK_PHY_TIMESTAMPING
+	depends on PHYLIB
+	depends on PTP_1588_CLOCK
+	depends on BCM_NET_PHYLIB
+        select NET_PTP_CLASSIFY
+	help
+	  This driver adds support for using the BCM54210PE as a PTP
+	  clock. This clock is only useful if your PTP programs are
+	  getting hardware time stamps on the PTP Ethernet packets
+	  using the SO_TIMESTAMPING API.
+
+	  In order for this to work, your MAC driver must also
+	  implement the skb_tx_timestamp() function.
+
+
 config PTP_1588_CLOCK_PCH
 	tristate "Intel PCH EG20T as PTP clock"
 	depends on X86_32 || COMPILE_TEST

--Apple-Mail=_020459A3-9970-424F-8372-99FDFDDFCECB--
