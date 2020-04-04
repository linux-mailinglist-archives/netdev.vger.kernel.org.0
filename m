Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C512C19E7CE
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 23:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgDDVwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 17:52:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45676 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgDDVwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 17:52:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id v5so1928659wrp.12
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 14:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5lrE+S1rzLt0JCnocihY/+rP5bffPnyxF/7Y8Xyby6k=;
        b=hAuiih8p8aRNETv568F2swIezVXdV8XAFRH/852MU9wSoLGVIreeNzsLou2y3fXG57
         /mt+KoRqLnWkdB8NCEma7QHQp57UCif9h2hqY+10f8MBRF4k7REvIDH4uo2F2sjeNCKG
         VtEQzFBOlYFiVMgmgaXaJxXqZ2tDVWwKpgNjUhtUy18e2qVCjN1hAkzgYn3bGxzErffj
         M4FILNI+qE7j/afAqYosMZnogcPOa6xnpSEKV5V3sUuH2nnwamV7oyYbBlu4wJeii6QT
         lMvfCDaFJR9EK7YmFDdYEDsBpCokRHB5eSOy4Wjv1fPyFvmcAQUEQIZJPOQ7iyWF8IYC
         XbFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=5lrE+S1rzLt0JCnocihY/+rP5bffPnyxF/7Y8Xyby6k=;
        b=E7nNxZihlWOmWH6SjBUoAVOVJf8S2OFa5TPkmQHaNLY0ZYbqMS8Yy4SAQVsg27cLy7
         FyExRa2sUCX/ex2TIrlyc0Fe+q+kK0TJUN84bhcc7fgGfB+yAm45Vz0gpu4mgFQy3V+X
         VvkpGGLvHev3n7hcXJ6N7R8kxT3Xpdj7rHzG1ljU1WzA7Dmtj3W5Gzbgw1jxwdxbBlCq
         kXuA/T+VFD3/x0YuCXo72vRGO45/eVoNl7uIPvpGjEO5Gwo5E3XJ8n3Un4Fpgq6YADwD
         I6xIhQutpRA3v+gMfh4NWxMSecjQPKCCv/ai06nzWt8d+dqLcL5D7J4msXuyEd0YMdM2
         lgYg==
X-Gm-Message-State: AGi0Pubc1VrY4br33gjgbgsHi+yLXKde/HdQAzzOGVEheXuEmWmcuWVw
        FyQmrbRaEBk4/euRtoblzced82B2
X-Google-Smtp-Source: APiQypI4UJJ5zbmL/0tBxYRVTDwxySZoayiGuVic1mAnQ+57zfSccC5HrH9Ax/rP39pATc+quFD9lw==
X-Received: by 2002:a5d:68c4:: with SMTP id p4mr16237523wrw.308.1586037151662;
        Sat, 04 Apr 2020 14:52:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d970:6d48:923e:d477? (p200300EA8F296000D9706D48923ED477.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d970:6d48:923e:d477])
        by smtp.googlemail.com with ESMTPSA id b85sm906451wmb.21.2020.04.04.14.52.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Apr 2020 14:52:31 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net 5.4 5.5 5.6] r8169: change back SG and TSO to be disabled
 by default
Message-ID: <df332145-0446-66a6-610d-28822e452bc2@gmail.com>
Date:   Sat, 4 Apr 2020 23:48:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There has been a number of reports that using SG/TSO on different chip
versions results in tx timeouts. However for a lot of people SG/TSO
works fine. Therefore disable both features by default, but allow users
to enable them. Use at own risk!

Fixes: 93681cd7d94f ("r8169: enable HW csum and TSO")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
This version of the fix applies on 5.4 - 5.6.
---
 drivers/net/ethernet/realtek/r8169_main.c | 34 +++++++++++------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 791d99b9e..929adcc91 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5549,12 +5549,10 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	dev->features |= NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
+	dev->features |= NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+			 NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
+	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
 	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 		NETIF_F_HIGHDMA;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
@@ -5572,25 +5570,25 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (rtl_chip_supports_csum_v2(tp)) {
-		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
-		dev->features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
+		dev->hw_features |= NETIF_F_IPV6_CSUM;
+		dev->features |= NETIF_F_IPV6_CSUM;
+	}
+
+	/* There has been a number of reports that using SG/TSO results in
+	 * tx timeouts. However for a lot of people SG/TSO works fine.
+	 * Therefore disable both features by default, but allow users to
+	 * enable them. Use at own risk!
+	 */
+	if (rtl_chip_supports_csum_v2(tp)) {
+		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V2;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
 	} else {
+		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO;
 		dev->gso_max_size = RTL_GSO_MAX_SIZE_V1;
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
 	}
 
-	/* RTL8168e-vl and one RTL8168c variant are known to have a
-	 * HW issue with TSO.
-	 */
-	if (tp->mac_version == RTL_GIGA_MAC_VER_34 ||
-	    tp->mac_version == RTL_GIGA_MAC_VER_22) {
-		dev->vlan_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
-		dev->hw_features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
-		dev->features &= ~(NETIF_F_ALL_TSO | NETIF_F_SG);
-	}
-
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 
-- 
2.26.0

