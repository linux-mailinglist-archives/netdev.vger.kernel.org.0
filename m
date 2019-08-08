Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BED26863F3
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733311AbfHHOKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 10:10:06 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34215 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHHOKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 10:10:06 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id B1EE6E0007;
        Thu,  8 Aug 2019 14:10:02 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, sd@queasysnail.net, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, alexandre.belloni@bootlin.com,
        allan.nielsen@microchip.com, camelia.groza@nxp.com,
        Simon.Edelhaus@aquantia.com
Subject: [PATCH net-next v2 1/9] net: introduce the MACSEC netdev feature
Date:   Thu,  8 Aug 2019 16:05:52 +0200
Message-Id: <20190808140600.21477-2-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190808140600.21477-1-antoine.tenart@bootlin.com>
References: <20190808140600.21477-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduce a new netdev feature, which will be used by drivers
to state they can perform MACsec transformations in hardware.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 include/linux/netdev_features.h | 3 +++
 net/core/ethtool.c              | 1 +
 2 files changed, 4 insertions(+)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 4b19c544c59a..020f8542b92f 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -81,6 +81,8 @@ enum {
 	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
 
+	NETIF_F_HW_MACSEC_BIT,		/* Offload MACsec operations */
+
 	/*
 	 * Add your fresh new feature above and remember to update
 	 * netdev_features_strings[] in net/core/ethtool.c and maybe
@@ -150,6 +152,7 @@ enum {
 #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
 #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
+#define NETIF_F_HW_MACSEC	__NETIF_F(HW_MACSEC)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 6288e69e94fc..4a410e0ff179 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -111,6 +111,7 @@ static const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN]
 	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
 	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
+	[NETIF_F_HW_MACSEC_BIT] =	 "macsec-hw-offload",
 };
 
 static const char
-- 
2.21.0

