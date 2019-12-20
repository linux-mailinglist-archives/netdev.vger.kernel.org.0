Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A91112820F
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 19:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfLTSPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 13:15:38 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40880 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbfLTSPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 13:15:35 -0500
Received: by mail-pg1-f193.google.com with SMTP id k25so5316440pgt.7;
        Fri, 20 Dec 2019 10:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QakoUc+CuB5FdvCqGoAyZHBAGb8SjShOj+fvk9TkftE=;
        b=oBeCyy0UsnFMqqfV5ZWeby4MWBZ2ocBcn+ayWqXrL0E5OTye/4/JdK8QhSJYOVRC8/
         bBIC38+W6rLLNMNWIv7g3lppyUnL/pJZLd/em0YOemc+3xAdwlrJe7xvNa5TkGCTk1nO
         rwErqgxf4L0KhElR/Rie99DGHLA6SdQizi9RqjW7+Iusz+5umKKTi5Uc0BeFozCPz2dG
         8QOjbB3kDJ3LYhMNwrKKi84Qk9V7ZMufpkOZJgYYSmkrDTfi22swD2MglVI5zUt2kmrY
         Ij69ydo2KGHFFoBT3odqMnjOCVKyD2LpTe9SEuDC8WeHw32AwtQFjhBBkIXrHi7e4H5N
         iwlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QakoUc+CuB5FdvCqGoAyZHBAGb8SjShOj+fvk9TkftE=;
        b=bYEEuHWYd+vgAPRC+UGmIoWw+7iHTS97qQVR3sOK7bI4je50f9HDJqCfr42tGnd92p
         hfbed4FQ7AOr8HH/28MUoB2Ivch0HkpdTlJ3s3c3SYdlsE+bIyuPOQcHNCT3lO/M/ILu
         fzn0I/a2S6ZttB2RR6NzHlAvSmy86OreiKWf5AC6pQE2CtZ7Gj9tImj6uPbn8+SZNPvp
         jg0rWRFaGHXgWZIuPrAEjdX+vKNT2hdZeROo4I+E4gPNzUgjRRy9wAfyKTNP7Tc9ms7h
         GiX5tKDOhfG3HtAePRtWMM9OI9C/UIul7bzQzlZh3OSpp64AEAxX6pn8GdnTlhvhDOcs
         rAPw==
X-Gm-Message-State: APjAAAX2dA65eWc6O2mhx4v3e1woP7+UEueN7+B3L7S5bcqZoVH6Dvj0
        LMpM8p6ayWuCBCyAxdGjybnZ8ci/
X-Google-Smtp-Source: APXvYqzWcjXBE6xxGTS4m8pEL6tZ92tPE74KVDQm+rz6m4qp8gy8iCxQISQ9KzMhjoyXGvMAC4OVPg==
X-Received: by 2002:a63:1f0c:: with SMTP id f12mr16790442pgf.247.1576865733783;
        Fri, 20 Dec 2019 10:15:33 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j28sm11833869pgb.36.2019.12.20.10.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 10:15:33 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: [PATCH V7 net-next 06/11] net: Introduce a new MII time stamping interface.
Date:   Fri, 20 Dec 2019 10:15:15 -0800
Message-Id: <e918fb63e41d5a75305982af03901044336ded91.1576865315.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576865315.git.richardcochran@gmail.com>
References: <cover.1576865315.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the stack supports time stamping in PHY devices.  However,
there are newer, non-PHY devices that can snoop an MII bus and provide
time stamps.  In order to support such devices, this patch introduces
a new interface to be used by both PHY and non-PHY devices.

In addition, the one and only user of the old PHY time stamping API is
converted to the new interface.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/phy/dp83640.c       | 47 +++++++++++++++++---------
 drivers/net/phy/phy.c           |  4 +--
 drivers/net/phy/phy_device.c    |  2 ++
 include/linux/mii_timestamper.h | 58 +++++++++++++++++++++++++++++++++
 include/linux/phy.h             | 41 ++++++-----------------
 net/core/timestamping.c         | 20 ++++++------
 6 files changed, 114 insertions(+), 58 deletions(-)
 create mode 100644 include/linux/mii_timestamper.h

diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 8f241b57fcf6..42624c91466d 100644
--- a/drivers/net/phy/dp83640.c
+++ b/drivers/net/phy/dp83640.c
@@ -98,6 +98,7 @@ struct dp83640_private {
 	struct list_head list;
 	struct dp83640_clock *clock;
 	struct phy_device *phydev;
+	struct mii_timestamper mii_ts;
 	struct delayed_work ts_work;
 	int hwts_tx_en;
 	int hwts_rx_en;
@@ -201,6 +202,14 @@ static void dp83640_gpio_defaults(struct ptp_pin_desc *pd)
 static LIST_HEAD(phyter_clocks);
 static DEFINE_MUTEX(phyter_clocks_lock);
 
+static int dp83640_hwtstamp(struct mii_timestamper *mii_ts,
+			    struct ifreq *ifr);
+static int dp83640_ts_info(struct mii_timestamper *mii_ts,
+			   struct ethtool_ts_info *info);
+static bool dp83640_rxtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type);
+static void dp83640_txtstamp(struct mii_timestamper *mii_ts,
+			     struct sk_buff *skb, int type);
 static void rx_timestamp_work(struct work_struct *work);
 
 /* extended register access functions */
@@ -1149,13 +1158,18 @@ static int dp83640_probe(struct phy_device *phydev)
 		goto no_memory;
 
 	dp83640->phydev = phydev;
-	INIT_DELAYED_WORK(&dp83640->ts_work, rx_timestamp_work);
+	dp83640->mii_ts.rxtstamp = dp83640_rxtstamp;
+	dp83640->mii_ts.txtstamp = dp83640_txtstamp;
+	dp83640->mii_ts.hwtstamp = dp83640_hwtstamp;
+	dp83640->mii_ts.ts_info  = dp83640_ts_info;
 
+	INIT_DELAYED_WORK(&dp83640->ts_work, rx_timestamp_work);
 	INIT_LIST_HEAD(&dp83640->rxts);
 	INIT_LIST_HEAD(&dp83640->rxpool);
 	for (i = 0; i < MAX_RXTS; i++)
 		list_add(&dp83640->rx_pool_data[i].list, &dp83640->rxpool);
 
+	phydev->mii_ts = &dp83640->mii_ts;
 	phydev->priv = dp83640;
 
 	spin_lock_init(&dp83640->rx_lock);
@@ -1196,6 +1210,8 @@ static void dp83640_remove(struct phy_device *phydev)
 	if (phydev->mdio.addr == BROADCAST_ADDR)
 		return;
 
+	phydev->mii_ts = NULL;
+
 	enable_status_frames(phydev, false);
 	cancel_delayed_work_sync(&dp83640->ts_work);
 
@@ -1319,9 +1335,10 @@ static int dp83640_config_intr(struct phy_device *phydev)
 	}
 }
 
-static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
+static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
 {
-	struct dp83640_private *dp83640 = phydev->priv;
+	struct dp83640_private *dp83640 =
+		container_of(mii_ts, struct dp83640_private, mii_ts);
 	struct hwtstamp_config cfg;
 	u16 txcfg0, rxcfg0;
 
@@ -1397,8 +1414,8 @@ static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
 
 	mutex_lock(&dp83640->clock->extreg_lock);
 
-	ext_write(0, phydev, PAGE5, PTP_TXCFG0, txcfg0);
-	ext_write(0, phydev, PAGE5, PTP_RXCFG0, rxcfg0);
+	ext_write(0, dp83640->phydev, PAGE5, PTP_TXCFG0, txcfg0);
+	ext_write(0, dp83640->phydev, PAGE5, PTP_RXCFG0, rxcfg0);
 
 	mutex_unlock(&dp83640->clock->extreg_lock);
 
@@ -1428,10 +1445,11 @@ static void rx_timestamp_work(struct work_struct *work)
 		schedule_delayed_work(&dp83640->ts_work, SKB_TIMESTAMP_TIMEOUT);
 }
 
-static bool dp83640_rxtstamp(struct phy_device *phydev,
+static bool dp83640_rxtstamp(struct mii_timestamper *mii_ts,
 			     struct sk_buff *skb, int type)
 {
-	struct dp83640_private *dp83640 = phydev->priv;
+	struct dp83640_private *dp83640 =
+		container_of(mii_ts, struct dp83640_private, mii_ts);
 	struct dp83640_skb_info *skb_info = (struct dp83640_skb_info *)skb->cb;
 	struct list_head *this, *next;
 	struct rxts *rxts;
@@ -1477,11 +1495,12 @@ static bool dp83640_rxtstamp(struct phy_device *phydev,
 	return true;
 }
 
-static void dp83640_txtstamp(struct phy_device *phydev,
+static void dp83640_txtstamp(struct mii_timestamper *mii_ts,
 			     struct sk_buff *skb, int type)
 {
 	struct dp83640_skb_info *skb_info = (struct dp83640_skb_info *)skb->cb;
-	struct dp83640_private *dp83640 = phydev->priv;
+	struct dp83640_private *dp83640 =
+		container_of(mii_ts, struct dp83640_private, mii_ts);
 
 	switch (dp83640->hwts_tx_en) {
 
@@ -1504,9 +1523,11 @@ static void dp83640_txtstamp(struct phy_device *phydev,
 	}
 }
 
-static int dp83640_ts_info(struct phy_device *dev, struct ethtool_ts_info *info)
+static int dp83640_ts_info(struct mii_timestamper *mii_ts,
+			   struct ethtool_ts_info *info)
 {
-	struct dp83640_private *dp83640 = dev->priv;
+	struct dp83640_private *dp83640 =
+		container_of(mii_ts, struct dp83640_private, mii_ts);
 
 	info->so_timestamping =
 		SOF_TIMESTAMPING_TX_HARDWARE |
@@ -1537,10 +1558,6 @@ static struct phy_driver dp83640_driver = {
 	.config_init	= dp83640_config_init,
 	.ack_interrupt  = dp83640_ack_interrupt,
 	.config_intr    = dp83640_config_intr,
-	.ts_info	= dp83640_ts_info,
-	.hwtstamp	= dp83640_hwtstamp,
-	.rxtstamp	= dp83640_rxtstamp,
-	.txtstamp	= dp83640_txtstamp,
 };
 
 static int __init dp83640_init(void)
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 80be4d691e5b..541ed01496bf 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -422,8 +422,8 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	case SIOCSHWTSTAMP:
-		if (phydev->drv && phydev->drv->hwtstamp)
-			return phydev->drv->hwtstamp(phydev, ifr);
+		if (phydev->mii_ts && phydev->mii_ts->hwtstamp)
+			return phydev->mii_ts->hwtstamp(phydev->mii_ts, ifr);
 		/* fall through */
 
 	default:
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 0887ed2bb050..ee45838f90c9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -919,6 +919,8 @@ static void phy_link_change(struct phy_device *phydev, bool up, bool do_carrier)
 			netif_carrier_off(netdev);
 	}
 	phydev->adjust_link(netdev);
+	if (phydev->mii_ts && phydev->mii_ts->link_state)
+		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
 }
 
 /**
diff --git a/include/linux/mii_timestamper.h b/include/linux/mii_timestamper.h
new file mode 100644
index 000000000000..36002386029c
--- /dev/null
+++ b/include/linux/mii_timestamper.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Support for generic time stamping devices on MII buses.
+ * Copyright (C) 2018 Richard Cochran <richardcochran@gmail.com>
+ */
+#ifndef _LINUX_MII_TIMESTAMPER_H
+#define _LINUX_MII_TIMESTAMPER_H
+
+#include <linux/device.h>
+#include <linux/ethtool.h>
+#include <linux/skbuff.h>
+
+struct phy_device;
+
+/**
+ * struct mii_timestamper - Callback interface to MII time stamping devices.
+ *
+ * @rxtstamp:	Requests a Rx timestamp for 'skb'.  If the skb is accepted,
+ *		the MII time stamping device promises to deliver it using
+ *		netif_rx() as soon as a timestamp becomes available. One of
+ *		the PTP_CLASS_ values is passed in 'type'.  The function
+ *		must return true if the skb is accepted for delivery.
+ *
+ * @txtstamp:	Requests a Tx timestamp for 'skb'.  The MII time stamping
+ *		device promises to deliver it using skb_complete_tx_timestamp()
+ *		as soon as a timestamp becomes available. One of the PTP_CLASS_
+ *		values is passed in 'type'.
+ *
+ * @hwtstamp:	Handles SIOCSHWTSTAMP ioctl for hardware time stamping.
+ *
+ * @link_state: Allows the device to respond to changes in the link
+ *		state.  The caller invokes this function while holding
+ *		the phy_device mutex.
+ *
+ * @ts_info:	Handles ethtool queries for hardware time stamping.
+ *
+ * Drivers for PHY time stamping devices should embed their
+ * mii_timestamper within a private structure, obtaining a reference
+ * to it using container_of().
+ */
+struct mii_timestamper {
+	bool (*rxtstamp)(struct mii_timestamper *mii_ts,
+			 struct sk_buff *skb, int type);
+
+	void (*txtstamp)(struct mii_timestamper *mii_ts,
+			 struct sk_buff *skb, int type);
+
+	int  (*hwtstamp)(struct mii_timestamper *mii_ts,
+			 struct ifreq *ifreq);
+
+	void (*link_state)(struct mii_timestamper *mii_ts,
+			   struct phy_device *phydev);
+
+	int  (*ts_info)(struct mii_timestamper *mii_ts,
+			struct ethtool_ts_info *ts_info);
+};
+
+#endif
diff --git a/include/linux/phy.h b/include/linux/phy.h
index fc51aacb03a7..a34266deba3c 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -17,6 +17,7 @@
 #include <linux/linkmode.h>
 #include <linux/mdio.h>
 #include <linux/mii.h>
+#include <linux/mii_timestamper.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
@@ -441,6 +442,7 @@ struct phy_device {
 	struct sfp_bus *sfp_bus;
 	struct phylink *phylink;
 	struct net_device *attached_dev;
+	struct mii_timestamper *mii_ts;
 
 	u8 mdix;
 	u8 mdix_ctrl;
@@ -546,29 +548,6 @@ struct phy_driver {
 	 */
 	int (*match_phy_device)(struct phy_device *phydev);
 
-	/* Handles ethtool queries for hardware time stamping. */
-	int (*ts_info)(struct phy_device *phydev, struct ethtool_ts_info *ti);
-
-	/* Handles SIOCSHWTSTAMP ioctl for hardware time stamping. */
-	int  (*hwtstamp)(struct phy_device *phydev, struct ifreq *ifr);
-
-	/*
-	 * Requests a Rx timestamp for 'skb'. If the skb is accepted,
-	 * the phy driver promises to deliver it using netif_rx() as
-	 * soon as a timestamp becomes available. One of the
-	 * PTP_CLASS_ values is passed in 'type'. The function must
-	 * return true if the skb is accepted for delivery.
-	 */
-	bool (*rxtstamp)(struct phy_device *dev, struct sk_buff *skb, int type);
-
-	/*
-	 * Requests a Tx timestamp for 'skb'. The phy driver promises
-	 * to deliver it using skb_complete_tx_timestamp() as soon as a
-	 * timestamp becomes available. One of the PTP_CLASS_ values
-	 * is passed in 'type'.
-	 */
-	void (*txtstamp)(struct phy_device *dev, struct sk_buff *skb, int type);
-
 	/* Some devices (e.g. qnap TS-119P II) require PHY register changes to
 	 * enable Wake on LAN, so set_wol is provided to be called in the
 	 * ethernet driver's set_wol function. */
@@ -942,7 +921,7 @@ static inline bool phy_polling_mode(struct phy_device *phydev)
  */
 static inline bool phy_has_hwtstamp(struct phy_device *phydev)
 {
-	return phydev && phydev->drv && phydev->drv->hwtstamp;
+	return phydev && phydev->mii_ts && phydev->mii_ts->hwtstamp;
 }
 
 /**
@@ -951,7 +930,7 @@ static inline bool phy_has_hwtstamp(struct phy_device *phydev)
  */
 static inline bool phy_has_rxtstamp(struct phy_device *phydev)
 {
-	return phydev && phydev->drv && phydev->drv->rxtstamp;
+	return phydev && phydev->mii_ts && phydev->mii_ts->rxtstamp;
 }
 
 /**
@@ -961,7 +940,7 @@ static inline bool phy_has_rxtstamp(struct phy_device *phydev)
  */
 static inline bool phy_has_tsinfo(struct phy_device *phydev)
 {
-	return phydev && phydev->drv && phydev->drv->ts_info;
+	return phydev && phydev->mii_ts && phydev->mii_ts->ts_info;
 }
 
 /**
@@ -970,30 +949,30 @@ static inline bool phy_has_tsinfo(struct phy_device *phydev)
  */
 static inline bool phy_has_txtstamp(struct phy_device *phydev)
 {
-	return phydev && phydev->drv && phydev->drv->txtstamp;
+	return phydev && phydev->mii_ts && phydev->mii_ts->txtstamp;
 }
 
 static inline int phy_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
 {
-	return phydev->drv->hwtstamp(phydev, ifr);
+	return phydev->mii_ts->hwtstamp(phydev->mii_ts, ifr);
 }
 
 static inline bool phy_rxtstamp(struct phy_device *phydev, struct sk_buff *skb,
 				int type)
 {
-	return phydev->drv->rxtstamp(phydev, skb, type);
+	return phydev->mii_ts->rxtstamp(phydev->mii_ts, skb, type);
 }
 
 static inline int phy_ts_info(struct phy_device *phydev,
 			      struct ethtool_ts_info *tsinfo)
 {
-	return phydev->drv->ts_info(phydev, tsinfo);
+	return phydev->mii_ts->ts_info(phydev->mii_ts, tsinfo);
 }
 
 static inline void phy_txtstamp(struct phy_device *phydev, struct sk_buff *skb,
 				int type)
 {
-	phydev->drv->txtstamp(phydev, skb, type);
+	phydev->mii_ts->txtstamp(phydev->mii_ts, skb, type);
 }
 
 /**
diff --git a/net/core/timestamping.c b/net/core/timestamping.c
index 7911235706a9..04840697fe79 100644
--- a/net/core/timestamping.c
+++ b/net/core/timestamping.c
@@ -13,7 +13,7 @@
 static unsigned int classify(const struct sk_buff *skb)
 {
 	if (likely(skb->dev && skb->dev->phydev &&
-		   skb->dev->phydev->drv))
+		   skb->dev->phydev->mii_ts))
 		return ptp_classify_raw(skb);
 	else
 		return PTP_CLASS_NONE;
@@ -21,7 +21,7 @@ static unsigned int classify(const struct sk_buff *skb)
 
 void skb_clone_tx_timestamp(struct sk_buff *skb)
 {
-	struct phy_device *phydev;
+	struct mii_timestamper *mii_ts;
 	struct sk_buff *clone;
 	unsigned int type;
 
@@ -32,22 +32,22 @@ void skb_clone_tx_timestamp(struct sk_buff *skb)
 	if (type == PTP_CLASS_NONE)
 		return;
 
-	phydev = skb->dev->phydev;
-	if (likely(phydev->drv->txtstamp)) {
+	mii_ts = skb->dev->phydev->mii_ts;
+	if (likely(mii_ts->txtstamp)) {
 		clone = skb_clone_sk(skb);
 		if (!clone)
 			return;
-		phydev->drv->txtstamp(phydev, clone, type);
+		mii_ts->txtstamp(mii_ts, clone, type);
 	}
 }
 EXPORT_SYMBOL_GPL(skb_clone_tx_timestamp);
 
 bool skb_defer_rx_timestamp(struct sk_buff *skb)
 {
-	struct phy_device *phydev;
+	struct mii_timestamper *mii_ts;
 	unsigned int type;
 
-	if (!skb->dev || !skb->dev->phydev || !skb->dev->phydev->drv)
+	if (!skb->dev || !skb->dev->phydev || !skb->dev->phydev->mii_ts)
 		return false;
 
 	if (skb_headroom(skb) < ETH_HLEN)
@@ -62,9 +62,9 @@ bool skb_defer_rx_timestamp(struct sk_buff *skb)
 	if (type == PTP_CLASS_NONE)
 		return false;
 
-	phydev = skb->dev->phydev;
-	if (likely(phydev->drv->rxtstamp))
-		return phydev->drv->rxtstamp(phydev, skb, type);
+	mii_ts = skb->dev->phydev->mii_ts;
+	if (likely(mii_ts->rxtstamp))
+		return mii_ts->rxtstamp(mii_ts, skb, type);
 
 	return false;
 }
-- 
2.20.1

