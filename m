Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759D03082F
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 07:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfEaF4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 01:56:34 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34792 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfEaF4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 01:56:32 -0400
Received: by mail-pf1-f193.google.com with SMTP id c14so3084966pfi.1;
        Thu, 30 May 2019 22:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j6QhJ/YAoNjHjmqNiP92X22jZ24Buaoh6Cd2jfMctq0=;
        b=WsyueiezYBbU/NquHQsKRENNdrI5ATkxaOwoDMrf0yph01dajJ/ZUM8B66/qGztCzB
         KUl+OYaqz4+VRRJyW/z/rEboj5kPzXe6J9b+YDMEoZu5XE+nVE0b5IzJNDmvf4I61ltx
         CYZXExABlFH0Cksx1dmewH4aBV6b63tkhsP5BJdfECopgLXni6ey91Dae5n5tC02Ju6w
         QJSiDo+4LqZTYiAVC6w4LPRuPBgbmOESlIKNNB+lxSDL2yNg8xrxd99p/DKb5F3mNjbF
         VO11IQmpnmDNKZSVnHLhkSo1w4zyNqVucrCXPrGRuWXWnbG2C21hstf8E4QfGBLPny6a
         YA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j6QhJ/YAoNjHjmqNiP92X22jZ24Buaoh6Cd2jfMctq0=;
        b=tWeQMH3AqAwkGAc4N6fI3/ggRxBmkVpjIJ4JGGNqcPgbz7M5A3m8jzeo9Kzo9Crz9J
         S3c/eNtBsk5epT10AcYA/W9xDhve08u75sJYEHG+eiPMqlj1Ppz1rUxoCyZX0UJzG8QT
         5hWI9Soc9xGWZ6/XxuiZhV1iZDgZasFlJ+7K9ceE2473J9hjgwZnnJ7d9FmRCbfpxUVb
         48axiWvoNZ/A5K8GsdT+yeaGgJihUzBHLmUtzyOONIdGiYQ7tsI5WrAgZpJtf+pYIoYN
         zXLjG8AKqklQDHUTBSBiDjZ+uxb8evXsdvcKefNcpT3i2BJ9Xw6pY47fExnUqrj3uy3h
         gTsg==
X-Gm-Message-State: APjAAAUXohj1ftFMP8WRlkV0dD/SAuybdNeaOoKRUWckJyUkL4HXuzV6
        Ja10bE3TO3fX6qtO9T9foBJU4cou
X-Google-Smtp-Source: APXvYqxa2U+/OauBDG2u6Q1HOdXtcuuxj04Y1oMu7GTf1OYged4G1bpAL2lj3n3+S4XIk/v15/KseA==
X-Received: by 2002:a63:441c:: with SMTP id r28mr4662123pga.255.1559282191511;
        Thu, 30 May 2019 22:56:31 -0700 (PDT)
Received: from localhost.localdomain (c-73-222-71-142.hsd1.ca.comcast.net. [73.222.71.142])
        by smtp.gmail.com with ESMTPSA id u2sm4554184pjv.30.2019.05.30.22.56.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 22:56:30 -0700 (PDT)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH V5 net-next 2/6] net: Introduce a new MII time stamping interface.
Date:   Thu, 30 May 2019 22:56:22 -0700
Message-Id: <aa253fc4c1ab387c63aa24bf0c14563861266f5b.1559281985.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <cover.1559281985.git.richardcochran@gmail.com>
References: <cover.1559281985.git.richardcochran@gmail.com>
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
 drivers/net/macvlan.c           |  4 +--
 drivers/net/phy/dp83640.c       | 47 +++++++++++++++++++++++-----------
 drivers/net/phy/phy.c           |  4 +--
 drivers/net/phy/phy_device.c    |  2 ++
 include/linux/mii_timestamper.h | 56 +++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h             | 25 ++----------------
 net/8021q/vlan_dev.c            |  4 +--
 net/core/ethtool.c              |  4 +--
 net/core/timestamping.c         | 20 +++++++--------
 9 files changed, 110 insertions(+), 56 deletions(-)
 create mode 100644 include/linux/mii_timestamper.h

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 0ccabde8e9c9..8f7868d31612 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1056,8 +1056,8 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 	const struct ethtool_ops *ops = real_dev->ethtool_ops;
 	struct phy_device *phydev = real_dev->phydev;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		 return phydev->drv->ts_info(phydev, info);
+	if (phydev && phydev->mii_ts && phydev->mii_ts->ts_info) {
+		return phydev->mii_ts->ts_info(phydev->mii_ts, info);
 	} else if (ops->get_ts_info) {
 		return ops->get_ts_info(real_dev, info);
 	} else {
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
index 6580094161a9..a87a72818e89 100644
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
@@ -1133,13 +1142,18 @@ static int dp83640_probe(struct phy_device *phydev)
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
@@ -1180,6 +1194,8 @@ static void dp83640_remove(struct phy_device *phydev)
 	if (phydev->mdio.addr == BROADCAST_ADDR)
 		return;
 
+	phydev->mii_ts = NULL;
+
 	enable_status_frames(phydev, false);
 	cancel_delayed_work_sync(&dp83640->ts_work);
 
@@ -1303,9 +1319,10 @@ static int dp83640_config_intr(struct phy_device *phydev)
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
 
@@ -1381,8 +1398,8 @@ static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
 
 	mutex_lock(&dp83640->clock->extreg_lock);
 
-	ext_write(0, phydev, PAGE5, PTP_TXCFG0, txcfg0);
-	ext_write(0, phydev, PAGE5, PTP_RXCFG0, rxcfg0);
+	ext_write(0, dp83640->phydev, PAGE5, PTP_TXCFG0, txcfg0);
+	ext_write(0, dp83640->phydev, PAGE5, PTP_RXCFG0, rxcfg0);
 
 	mutex_unlock(&dp83640->clock->extreg_lock);
 
@@ -1412,10 +1429,11 @@ static void rx_timestamp_work(struct work_struct *work)
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
@@ -1461,11 +1479,12 @@ static bool dp83640_rxtstamp(struct phy_device *phydev,
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
 
@@ -1488,9 +1507,11 @@ static void dp83640_txtstamp(struct phy_device *phydev,
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
@@ -1521,10 +1542,6 @@ static struct phy_driver dp83640_driver = {
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
index 84671d868a80..1137bef6a752 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -470,8 +470,8 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		return 0;
 
 	case SIOCSHWTSTAMP:
-		if (phydev->drv && phydev->drv->hwtstamp)
-			return phydev->drv->hwtstamp(phydev, ifr);
+		if (phydev->mii_ts && phydev->mii_ts->hwtstamp)
+			return phydev->mii_ts->hwtstamp(phydev->mii_ts, ifr);
 		/* fall through */
 
 	default:
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2c879ba01f35..055087654b2c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -915,6 +915,8 @@ static void phy_link_change(struct phy_device *phydev, bool up, bool do_carrier)
 			netif_carrier_off(netdev);
 	}
 	phydev->adjust_link(netdev);
+	if (phydev->mii_ts && phydev->mii_ts->link_state)
+		phydev->mii_ts->link_state(phydev->mii_ts, phydev);
 }
 
 /**
diff --git a/include/linux/mii_timestamper.h b/include/linux/mii_timestamper.h
new file mode 100644
index 000000000000..8586eed2f3b9
--- /dev/null
+++ b/include/linux/mii_timestamper.h
@@ -0,0 +1,56 @@
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
index dc4b51060ebc..ad63820a89d2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -22,6 +22,7 @@
 #include <linux/linkmode.h>
 #include <linux/mdio.h>
 #include <linux/mii.h>
+#include <linux/mii_timestamper.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
@@ -443,6 +444,7 @@ struct phy_device {
 
 	struct phylink *phylink;
 	struct net_device *attached_dev;
+	struct mii_timestamper *mii_ts;
 
 	u8 mdix;
 	u8 mdix_ctrl;
@@ -548,29 +550,6 @@ struct phy_driver {
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
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index c546c4228075..12b832d32c59 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -682,8 +682,8 @@ static int vlan_ethtool_get_ts_info(struct net_device *dev,
 	const struct ethtool_ops *ops = vlan->real_dev->ethtool_ops;
 	struct phy_device *phydev = vlan->real_dev->phydev;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		 return phydev->drv->ts_info(phydev, info);
+	if (phydev && phydev->mii_ts && phydev->mii_ts->ts_info) {
+		return phydev->mii_ts->ts_info(phydev->mii_ts, info);
 	} else if (ops->get_ts_info) {
 		return ops->get_ts_info(vlan->real_dev, info);
 	} else {
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 4a593853cbf2..e6cb3c987677 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -2168,8 +2168,8 @@ static int ethtool_get_ts_info(struct net_device *dev, void __user *useraddr)
 	memset(&info, 0, sizeof(info));
 	info.cmd = ETHTOOL_GET_TS_INFO;
 
-	if (phydev && phydev->drv && phydev->drv->ts_info) {
-		err = phydev->drv->ts_info(phydev, &info);
+	if (phydev && phydev->mii_ts && phydev->mii_ts->ts_info) {
+		err = phydev->mii_ts->ts_info(phydev->mii_ts, &info);
 	} else if (ops->get_ts_info) {
 		err = ops->get_ts_info(dev, &info);
 	} else {
diff --git a/net/core/timestamping.c b/net/core/timestamping.c
index 42689d5c468c..95c45c4dc0f9 100644
--- a/net/core/timestamping.c
+++ b/net/core/timestamping.c
@@ -26,7 +26,7 @@
 static unsigned int classify(const struct sk_buff *skb)
 {
 	if (likely(skb->dev && skb->dev->phydev &&
-		   skb->dev->phydev->drv))
+		   skb->dev->phydev->mii_ts))
 		return ptp_classify_raw(skb);
 	else
 		return PTP_CLASS_NONE;
@@ -34,7 +34,7 @@ static unsigned int classify(const struct sk_buff *skb)
 
 void skb_clone_tx_timestamp(struct sk_buff *skb)
 {
-	struct phy_device *phydev;
+	struct mii_timestamper *mii_ts;
 	struct sk_buff *clone;
 	unsigned int type;
 
@@ -45,22 +45,22 @@ void skb_clone_tx_timestamp(struct sk_buff *skb)
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
@@ -75,9 +75,9 @@ bool skb_defer_rx_timestamp(struct sk_buff *skb)
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
2.11.0

