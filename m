Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8114128B13
	for <lists+netdev@lfdr.de>; Sat, 21 Dec 2019 20:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727106AbfLUTgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Dec 2019 14:36:44 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41973 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbfLUTgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Dec 2019 14:36:43 -0500
Received: by mail-pl1-f196.google.com with SMTP id bd4so5534123plb.8;
        Sat, 21 Dec 2019 11:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+LgVazWFqvVcdctdDKHy4vuxqcL6YZfeaQzb1I4YFjU=;
        b=WlaS7byVzvG1Wlro8BIzXOv1kC2r2PnuHfrhpNThLLwCGXpy61kSKxnQOxyFVp8h1d
         C1dQKYsu211z+iYkO2RX6o80c+81ulcRfU/wY42cMKCsSg/IHusFRPs4vDadpZpcR9aS
         /H1081xabVqu+XznpOakrTEZ3JjKmi/xbQ321gehTsgU8keXVeFkkKGZRYAfHrEpUyyh
         958epaOMAGT3Cub3jvWPOEMV/F0axi7HuWdjuy5rUCQz9Swh9Qopn/kcRqZRAzX8CcRi
         ZnaMJapYky8EVm6jXQSJdBXx8R74AoGgQJmlCZhQYATniYkVvKsGYuLTxdlJbWyjvl9H
         SinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+LgVazWFqvVcdctdDKHy4vuxqcL6YZfeaQzb1I4YFjU=;
        b=byo7kbg8TyyHhiAweFXZAiKnAH3v6XOzlwjeYZidttIArXydyfbx2X0rm8ILJ93L8q
         h+/+PMjeyvA+YJIJe+M03tx9l/Be2NRHsDbwUL4OJaLsPxLEvq0vwo9fuZK5I1wW8UhM
         31eM1/GChKrqsKvyWPKH/vpsEAMIaiE7bZppSuuy2aXpIM3z49u897r+K/i+nQrOsu4k
         LqW3KQDpiCCFUdw88WCQ30o+0l1jm3doj1+NSMjBqJLqBt6Gb/6FjsFUX94mHYJElaLN
         kE5OgR/BoLTT4Ps47pkWLquUAXAwhFIcmyFa3fvQ0MMA8dN2CzUjup/ivlGb9Y9Q7521
         5IIg==
X-Gm-Message-State: APjAAAVqymZ6e6vLaiR9Ed60qZ22uxi7g7Zk3wIp2ZVc+nV7Ojbp0N0M
        7xiIK/ikTZNfIiXJW19E2CNpTETP
X-Google-Smtp-Source: APXvYqy+Ex51csdgdISZG+G9ikjtP1SCgW4Ef9+vFCZjpcaXFapDQKz8n7OPURMrV56bc+tGgLhfRQ==
X-Received: by 2002:a17:902:7042:: with SMTP id h2mr2814272plt.271.1576957002655;
        Sat, 21 Dec 2019 11:36:42 -0800 (PST)
Received: from localhost.localdomain (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id y197sm18512603pfc.79.2019.12.21.11.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 11:36:42 -0800 (PST)
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
Subject: [PATCH V8 net-next 01/12] net: phy: Introduce helper functions for time stamping support.
Date:   Sat, 21 Dec 2019 11:36:27 -0800
Message-Id: <5d7df80cc0dfce0204124f7dc4283c7126f24c33.1576956342.git.richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576956342.git.richardcochran@gmail.com>
References: <cover.1576956342.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some parts of the networking stack and at least one driver test fields
within the 'struct phy_device' in order to query time stamping
capabilities and to invoke time stamping methods.  This patch adds a
functional interface around the time stamping fields.  This will allow
insulating the callers from future changes to the details of the time
stamping implemenation.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/phy.h | 60 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 5032d453ac66..fc51aacb03a7 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -936,6 +936,66 @@ static inline bool phy_polling_mode(struct phy_device *phydev)
 	return phydev->irq == PHY_POLL;
 }
 
+/**
+ * phy_has_hwtstamp - Tests whether a PHY time stamp configuration.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_hwtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->hwtstamp;
+}
+
+/**
+ * phy_has_rxtstamp - Tests whether a PHY supports receive time stamping.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_rxtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->rxtstamp;
+}
+
+/**
+ * phy_has_tsinfo - Tests whether a PHY reports time stamping and/or
+ * PTP hardware clock capabilities.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_tsinfo(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->ts_info;
+}
+
+/**
+ * phy_has_txtstamp - Tests whether a PHY supports transmit time stamping.
+ * @phydev: the phy_device struct
+ */
+static inline bool phy_has_txtstamp(struct phy_device *phydev)
+{
+	return phydev && phydev->drv && phydev->drv->txtstamp;
+}
+
+static inline int phy_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
+{
+	return phydev->drv->hwtstamp(phydev, ifr);
+}
+
+static inline bool phy_rxtstamp(struct phy_device *phydev, struct sk_buff *skb,
+				int type)
+{
+	return phydev->drv->rxtstamp(phydev, skb, type);
+}
+
+static inline int phy_ts_info(struct phy_device *phydev,
+			      struct ethtool_ts_info *tsinfo)
+{
+	return phydev->drv->ts_info(phydev, tsinfo);
+}
+
+static inline void phy_txtstamp(struct phy_device *phydev, struct sk_buff *skb,
+				int type)
+{
+	phydev->drv->txtstamp(phydev, skb, type);
+}
+
 /**
  * phy_is_internal - Convenience function for testing if a PHY is internal
  * @phydev: the phy_device struct
-- 
2.20.1

