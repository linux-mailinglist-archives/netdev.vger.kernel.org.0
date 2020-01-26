Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A93F1499D3
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 10:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgAZJkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 04:40:55 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40412 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgAZJky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 04:40:54 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so7318607wrn.7
        for <netdev@vger.kernel.org>; Sun, 26 Jan 2020 01:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=4nJNE4cCsndkAg/OOwMd1FBSu+xtxvy3cuwALImcbQw=;
        b=iAfvaHZg2+5krTKKhDZz4DL9HdY9e+CCJbfwuY5bgTlCozaDMaOl7qadRRCrs4rg17
         /KR/3FQk3UMXza241tS9SkR31xxpmzluVRilUP2OiaBb1OscyIn2ekarCmEjwaLRKm/S
         paqEVJx552aLKuXU+v7UAfZpHjA17Dg9mgDOzy7O4dYS5CpHyPXsasnul0l+8Z3SOstX
         YAet+4TQ9ON1IyQiP+YJl0aO0Wp3fLbonMpx1XUpUTF66HuFsg67zRXBzBhpLs/7ukWC
         WWQMoRm+d5V+Znqrw97p4hNyRzSnhfyAu7tW/uEriifjSWtroo3M0gQIQqCjol/2JiFR
         Uh+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=4nJNE4cCsndkAg/OOwMd1FBSu+xtxvy3cuwALImcbQw=;
        b=gL4GhgScvazzucKPtr1cfmw/3PE08RexIjeA+Sj52QEKPyseXSm66GexuSIzKnm0j5
         lWg9TcDj2wghG5Uj1yrFBSe8E+w4cbV48ZyCO7Zbh8orm4ybk2wWk9S3sBkhFRNgMOfo
         TZvXv1OmFChiJI/2H/fiZKiNQ+OSvO11PXjKXmC5tZ801au5qGm2LAKCkXpoPe8H/CML
         yl3yPUwGjotSjolBM9migDcEo23ph7RbG5Ju4+K/9pGbN24n82QwQVgIfyN3dy6BINYs
         0iIemDLuEXmBROOD6Yh6yVhgO2O4Y6ZFBmYB9i98HwEYup7uVrBHhFoZmVbgRTe8BaDE
         OEAA==
X-Gm-Message-State: APjAAAWP2SMwC/BOaXCZD/33tjTKjXRI6Jm9PpxVZKtCBosAWYnKqCgr
        GCMkK6hbyssLVzAO0mgHyMC5rdUB
X-Google-Smtp-Source: APXvYqzEeOV0DXjhwmSARrRLDVLLwReKJEIUIJWt3eyuVnq1/OZx8fSybb/l6Hbc0L1blq7Lz3PqZQ==
X-Received: by 2002:adf:c746:: with SMTP id b6mr14219557wrh.298.1580031651821;
        Sun, 26 Jan 2020 01:40:51 -0800 (PST)
Received: from ?IPv6:2003:ea:8f36:6800:dd33:fcb2:e552:4598? (p200300EA8F366800DD33FCB2E5524598.dip0.t-ipconnect.de. [2003:ea:8f36:6800:dd33:fcb2:e552:4598])
        by smtp.googlemail.com with ESMTPSA id o7sm13774020wmh.11.2020.01.26.01.40.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jan 2020 01:40:51 -0800 (PST)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: don't set min_mtu/max_mtu if not needed
Message-ID: <d3d3dbf8-03f1-f964-a937-18f7f48452c8@gmail.com>
Date:   Sun, 26 Jan 2020 10:40:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Defaults for min_mtu and max_mtu are set by ether_setup(), which is
called from devm_alloc_etherdev(). Let rtl_jumbo_max() only return
a positive value if actually jumbo packets are supported. This also
allows to remove constant Jumbo_1K which is a little misleading anyway.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7a5fe1137..aaa316be6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -85,7 +85,6 @@
 #define RTL_R16(tp, reg)		readw(tp->mmio_addr + (reg))
 #define RTL_R32(tp, reg)		readl(tp->mmio_addr + (reg))
 
-#define JUMBO_1K	ETH_DATA_LEN
 #define JUMBO_4K	(4*1024 - ETH_HLEN - 2)
 #define JUMBO_6K	(6*1024 - ETH_HLEN - 2)
 #define JUMBO_7K	(7*1024 - ETH_HLEN - 2)
@@ -1494,7 +1493,7 @@ static netdev_features_t rtl8169_fix_features(struct net_device *dev,
 	if (dev->mtu > TD_MSS_MAX)
 		features &= ~NETIF_F_ALL_TSO;
 
-	if (dev->mtu > JUMBO_1K &&
+	if (dev->mtu > ETH_DATA_LEN &&
 	    tp->mac_version > RTL_GIGA_MAC_VER_06)
 		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_ALL_TSO);
 
@@ -5360,7 +5359,7 @@ static int rtl_jumbo_max(struct rtl8169_private *tp)
 {
 	/* Non-GBit versions don't support jumbo frames */
 	if (!tp->supports_gmii)
-		return JUMBO_1K;
+		return 0;
 
 	switch (tp->mac_version) {
 	/* RTL8169 */
@@ -5591,10 +5590,9 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 
-	/* MTU range: 60 - hw-specific max */
-	dev->min_mtu = ETH_ZLEN;
 	jumbo_max = rtl_jumbo_max(tp);
-	dev->max_mtu = jumbo_max;
+	if (jumbo_max)
+		dev->max_mtu = jumbo_max;
 
 	rtl_set_irq_mask(tp);
 
@@ -5624,7 +5622,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		   (RTL_R32(tp, TxConfig) >> 20) & 0xfcf,
 		   pci_irq_vector(pdev, 0));
 
-	if (jumbo_max > JUMBO_1K)
+	if (jumbo_max)
 		netif_info(tp, probe, dev,
 			   "jumbo features [frames: %d bytes, tx checksumming: %s]\n",
 			   jumbo_max, tp->mac_version <= RTL_GIGA_MAC_VER_06 ?
-- 
2.25.0

