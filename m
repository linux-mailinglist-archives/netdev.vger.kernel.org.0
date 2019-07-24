Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BEB74092
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:04:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbfGXVEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:04:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53460 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726238AbfGXVEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:04:14 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so43031820wmj.3
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 14:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=/VTcZRYyeDHm96EuRKOarrc5llUZM2/rbDHFTP/yLOo=;
        b=JfZZWJuTRkDrO3uxBzq8SpDETRg1AX6BKJEVLcq6D2W3L/2mUWFuPoO4w37coJiyVS
         1K2mXZWGfpDW9+/dtxP9bcRop7tWzeBm/mHMvsiXrkfx7O6T1Hx1rv8Jy9S3X2ivkSDp
         H7Ab33TKGFMgCEAPikZQz+66MJdM1TVF3A2ZahXVwA4pnos+jrByxCo3odQwlLqNQPUb
         lI35K6cnzmDL/OeeKnHMejb0Lz9X5P0EbxkqZgX2K/qTq1ivyLnCJwuBLRS2nMpISGe0
         kuSVnkR4EzLInAtt4w42vy/Tr52vgL2dHWMbCssbN3AKcylqJanyVtTrEaIfWaEvUuwZ
         OxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=/VTcZRYyeDHm96EuRKOarrc5llUZM2/rbDHFTP/yLOo=;
        b=JvwOU5u0QNF8ai7uja+HGhH9yjHZc3YC6qhUac2QHkLe8Yjmt6yOkbZcVEfZSnNh7P
         0x1h4/+e8iuGLsPguF04WA5yTrgLKwbCPY201q0aq9UtMR8PHvyMiUPznaOcsQ0etXVu
         UasLZou0fn6bIfBD87HOh4Ueod5YR+zGp2k88dt/TAHS4zDQbBB32ZKZrlgIeYLvBSOL
         HjFqiYwaMJNXEzHsm0sVZVfLI7CQor0BsHUavgKxql0G53pj3i1twlaf2ay5noiaBUwl
         OiBN1fEEjI26+RTlvPRjn0MtbmuUyYHtlQayEl6D7y/OCq52CR92S0FSfmIdhouMBDip
         01Xg==
X-Gm-Message-State: APjAAAVdSrz8VYXLH/Zgfn8Vl80XjDXKj1ZhZ9gfDg5E1Hlr8viiYXKU
        yLh7weJUcVn0rdRxStH6Emm8S/zi
X-Google-Smtp-Source: APXvYqxW3fWJfiya8AY+WQuoAR+14jeioPC7ZrUuujHrN35OfI0z7/a8AhzZWHc8mUfrSgzbDU0ptg==
X-Received: by 2002:a1c:7ec7:: with SMTP id z190mr74285307wmc.17.1564002252226;
        Wed, 24 Jul 2019 14:04:12 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:60e4:dd99:f7ec:c519? (p200300EA8F43420060E4DD99F7ECC519.dip0.t-ipconnect.de. [2003:ea:8f43:4200:60e4:dd99:f7ec:c519])
        by smtp.googlemail.com with ESMTPSA id x83sm49191198wmb.42.2019.07.24.14.04.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 14:04:11 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: improve rtl_set_rx_mode
Message-ID: <d9900738-0eaf-63cc-dbbf-41ca05539794@gmail.com>
Date:   Wed, 24 Jul 2019 23:04:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch improves and simplifies rtl_set_rx_mode a little.
No functional change intended.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 52 ++++++++++-------------
 1 file changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9c743d2fc..c39d3a77c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -61,7 +61,7 @@
 
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
    The RTL chips use a 64 element hash table based on the Ethernet CRC. */
-static const int multicast_filter_limit = 32;
+#define	MC_FILTER_LIMIT	32
 
 #define TX_DMA_BURST	7	/* Maximum PCI burst, '7' is unlimited */
 #define InterFrameGap	0x03	/* 3 means InterFrameGap = the shortest one */
@@ -4147,53 +4147,45 @@ static void rtl8169_set_magic_reg(struct rtl8169_private *tp, unsigned mac_versi
 static void rtl_set_rx_mode(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
-	u32 mc_filter[2];	/* Multicast hash filter */
-	int rx_mode;
-	u32 tmp = 0;
+	/* Multicast hash filter */
+	u32 mc_filter[2] = { 0xffffffff, 0xffffffff };
+	u32 rx_mode = AcceptBroadcast | AcceptMyPhys | AcceptMulticast;
+	u32 tmp;
 
 	if (dev->flags & IFF_PROMISC) {
 		/* Unconditionally log net taps. */
 		netif_notice(tp, link, dev, "Promiscuous mode enabled\n");
-		rx_mode =
-		    AcceptBroadcast | AcceptMulticast | AcceptMyPhys |
-		    AcceptAllPhys;
-		mc_filter[1] = mc_filter[0] = 0xffffffff;
-	} else if ((netdev_mc_count(dev) > multicast_filter_limit) ||
-		   (dev->flags & IFF_ALLMULTI)) {
-		/* Too many to filter perfectly -- accept all multicasts. */
-		rx_mode = AcceptBroadcast | AcceptMulticast | AcceptMyPhys;
-		mc_filter[1] = mc_filter[0] = 0xffffffff;
+		rx_mode |= AcceptAllPhys;
+	} else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
+		   dev->flags & IFF_ALLMULTI ||
+		   tp->mac_version == RTL_GIGA_MAC_VER_35) {
+		/* accept all multicasts */
+	} else if (netdev_mc_empty(dev)) {
+		rx_mode &= ~AcceptMulticast;
 	} else {
 		struct netdev_hw_addr *ha;
 
-		rx_mode = AcceptBroadcast | AcceptMyPhys;
 		mc_filter[1] = mc_filter[0] = 0;
 		netdev_for_each_mc_addr(ha, dev) {
-			int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
-			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
-			rx_mode |= AcceptMulticast;
+			u32 bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
+			mc_filter[bit_nr >> 5] |= BIT(bit_nr & 31);
+		}
+
+		if (tp->mac_version > RTL_GIGA_MAC_VER_06) {
+			tmp = mc_filter[0];
+			mc_filter[0] = swab32(mc_filter[1]);
+			mc_filter[1] = swab32(tmp);
 		}
 	}
 
 	if (dev->features & NETIF_F_RXALL)
 		rx_mode |= (AcceptErr | AcceptRunt);
 
-	tmp = (RTL_R32(tp, RxConfig) & ~RX_CONFIG_ACCEPT_MASK) | rx_mode;
-
-	if (tp->mac_version > RTL_GIGA_MAC_VER_06) {
-		u32 data = mc_filter[0];
-
-		mc_filter[0] = swab32(mc_filter[1]);
-		mc_filter[1] = swab32(data);
-	}
-
-	if (tp->mac_version == RTL_GIGA_MAC_VER_35)
-		mc_filter[1] = mc_filter[0] = 0xffffffff;
-
 	RTL_W32(tp, MAR0 + 4, mc_filter[1]);
 	RTL_W32(tp, MAR0 + 0, mc_filter[0]);
 
-	RTL_W32(tp, RxConfig, tmp);
+	tmp = RTL_R32(tp, RxConfig);
+	RTL_W32(tp, RxConfig, (tmp & ~RX_CONFIG_ACCEPT_MASK) | rx_mode);
 }
 
 DECLARE_RTL_COND(rtl_csiar_cond)
-- 
2.22.0

