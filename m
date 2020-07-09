Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B3F21A9C9
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 23:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgGIVft (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 17:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgGIVfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 17:35:46 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75206C08C5DC;
        Thu,  9 Jul 2020 14:35:44 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 5FD9F22FF5;
        Thu,  9 Jul 2020 23:35:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1594330538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=84ne4nXHSEC8l7CIFcYailprO/l8iEq22QSMWXO6DMc=;
        b=snagahQubulHTf4XE317rVThdYFrKtcPeNuRSHwkNQ6sxYQ2FTzXWmyGhiXokFzCmCC3eW
        AJ6RvGloO4qYhspacPjLqOE4tVFZmwm9CgeqBFWV0CaKOHAyvxgtCFwljzwjwplSEHTSzm
        8mG2OZxFa+edhzryX3NEh7k2JugG1rc=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v6 1/4] net: phy: add USXGMII link partner ability constants
Date:   Thu,  9 Jul 2020 23:35:23 +0200
Message-Id: <20200709213526.21972-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200709213526.21972-1-michael@walle.cc>
References: <20200709213526.21972-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The constants are taken from the USXGMII Singleport Copper Interface
specification. The naming are based on the SGMII ones, but with an MDIO_
prefix.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 include/uapi/linux/mdio.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
index 4bcb41c71b8c..784723072578 100644
--- a/include/uapi/linux/mdio.h
+++ b/include/uapi/linux/mdio.h
@@ -324,4 +324,30 @@ static inline __u16 mdio_phy_id_c45(int prtad, int devad)
 	return MDIO_PHY_ID_C45 | (prtad << 5) | devad;
 }
 
+/* UsxgmiiChannelInfo[15:0] for USXGMII in-band auto-negotiation.*/
+#define MDIO_LPA_USXGMII_EEE_CLK_STP	0x0080	/* EEE clock stop supported */
+#define MDIO_LPA_USXGMII_EEE		0x0100	/* EEE supported */
+#define MDIO_LPA_USXGMII_SPD_MASK	0x0e00	/* USXGMII speed mask */
+#define MDIO_LPA_USXGMII_FULL_DUPLEX	0x1000	/* USXGMII full duplex */
+#define MDIO_LPA_USXGMII_DPX_SPD_MASK	0x1e00	/* USXGMII duplex and speed bits */
+#define MDIO_LPA_USXGMII_10		0x0000	/* 10Mbps */
+#define MDIO_LPA_USXGMII_10HALF		0x0000	/* 10Mbps half-duplex */
+#define MDIO_LPA_USXGMII_10FULL		0x1000	/* 10Mbps full-duplex */
+#define MDIO_LPA_USXGMII_100		0x0200	/* 100Mbps */
+#define MDIO_LPA_USXGMII_100HALF	0x0200	/* 100Mbps half-duplex */
+#define MDIO_LPA_USXGMII_100FULL	0x1200	/* 100Mbps full-duplex */
+#define MDIO_LPA_USXGMII_1000		0x0400	/* 1000Mbps */
+#define MDIO_LPA_USXGMII_1000HALF	0x0400	/* 1000Mbps half-duplex */
+#define MDIO_LPA_USXGMII_1000FULL	0x1400	/* 1000Mbps full-duplex */
+#define MDIO_LPA_USXGMII_10G		0x0600	/* 10Gbps */
+#define MDIO_LPA_USXGMII_10GHALF	0x0600	/* 10Gbps half-duplex */
+#define MDIO_LPA_USXGMII_10GFULL	0x1600	/* 10Gbps full-duplex */
+#define MDIO_LPA_USXGMII_2500		0x0800	/* 2500Mbps */
+#define MDIO_LPA_USXGMII_2500HALF	0x0800	/* 2500Mbps half-duplex */
+#define MDIO_LPA_USXGMII_2500FULL	0x1800	/* 2500Mbps full-duplex */
+#define MDIO_LPA_USXGMII_5000		0x0a00	/* 5000Mbps */
+#define MDIO_LPA_USXGMII_5000HALF	0x0a00	/* 5000Mbps half-duplex */
+#define MDIO_LPA_USXGMII_5000FULL	0x1a00	/* 5000Mbps full-duplex */
+#define MDIO_LPA_USXGMII_LINK		0x8000	/* PHY link with copper-side partner */
+
 #endif /* _UAPI__LINUX_MDIO_H__ */
-- 
2.20.1

