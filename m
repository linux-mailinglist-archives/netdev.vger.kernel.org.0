Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4524B19E7CF
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 23:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgDDVwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 17:52:36 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46175 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbgDDVwf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 17:52:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id j17so12804116wru.13
        for <netdev@vger.kernel.org>; Sat, 04 Apr 2020 14:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=DReh+m2sV442fpSa7MA4bp8iS9396BX3SQSNtvZqhfA=;
        b=TgejOJhEv1+Yw6uPK22p15qr2z85Uq0cb5nqDpGDBPxXqDVQ81GutK6nG7ZvCErlnq
         EL09VTH46XoYzriqfpbIWs9XTKIUfVXLvotGq1bVBy396AccpAjs0gFEbM2g6KXUt7nk
         obFdIPzTOOZ2mFAlFAEJmOAsBj6TyCAYrZrg6nElv7NodDVgBkIpz+AZdl/42TG7tlud
         vyVcjI2ioj1x9eZODmZg55mVvbJT8qTWad1domLQNovUBYpNhhEO8tpv+dKxr1YrZJk1
         yJeXwKp5VTzFhJbgqE3BxyLB4cG/8q2fchMv/t3CxCJyh0TxdERxX7/HHN+QwnpGtI3z
         unUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=DReh+m2sV442fpSa7MA4bp8iS9396BX3SQSNtvZqhfA=;
        b=gXWEWUaraepQflpBqo8VP4acR/hfKFG23/GOIDOX0CM4FVIFF1y41LrVA708hTp1zt
         dQCySXEZTmqZlBrX34YPN/iW5gdgcpq4iOJjFcksLqbA4pfIqGJSbWcB+48bPX6vy9rw
         S/KaF/ybW7MXiLzku66VreMDorOvtJxSxkgKZnbnhP7zvhctXBAHiO2uqtCqqld8lqLH
         Zl7kBLRsi1qGrF82YF6DJUm9mA1Myw+ru6aMQWJQkABxaY+dIC9V6M0mWJmQ0OeYdxr6
         fLofZWT5nT4xfo5ROL1BsGxs+5FFp9kPMzzPwhAqkIvulX06WdtL2BQWuiCFIvbKwQTk
         qWpg==
X-Gm-Message-State: AGi0PuZniYBvqgjNPPPW1NtIX8BcAojcty1m90LbA/YMzKzYz+jaWBRI
        my/cH4F60UJ4Hy1wiUclvuVrYeIi
X-Google-Smtp-Source: APiQypKJWuMD9mxp+x9U+he8TZeO/qm9HabrljC8GT4DO9CnINUy51kCgurA8L/KFVdWPqFfTt4NbA==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr17123316wrp.403.1586037152844;
        Sat, 04 Apr 2020 14:52:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d970:6d48:923e:d477? (p200300EA8F296000D9706D48923ED477.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d970:6d48:923e:d477])
        by smtp.googlemail.com with ESMTPSA id r14sm17654878wmg.0.2020.04.04.14.52.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Apr 2020 14:52:32 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net 5.7] r8169: change back SG and TSO to be disabled by
 default
Message-ID: <168255ae-6b41-f458-fb67-3a3e853be5a6@gmail.com>
Date:   Sat, 4 Apr 2020 23:52:25 +0200
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
This version of the fix applies on 5.7.
---
 drivers/net/ethernet/realtek/r8169_main.c | 29 +++++++++++------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 55cb5730b..bf5bf0597 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5441,9 +5441,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	netif_napi_add(dev, &tp->napi, rtl8169_poll, NAPI_POLL_WEIGHT);
 
-	dev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
-		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_CTAG_TX |
-		NETIF_F_HW_VLAN_CTAG_RX;
+	dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_RXCSUM |
+			   NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX;
 	dev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 		NETIF_F_HIGHDMA;
 	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
@@ -5460,26 +5459,26 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/* Disallow toggling */
 		dev->hw_features &= ~NETIF_F_HW_VLAN_CTAG_RX;
 
+	if (rtl_chip_supports_csum_v2(tp))
+		dev->hw_features |= NETIF_F_IPV6_CSUM;
+
+	dev->features |= dev->hw_features;
+
+	/* There has been a number of reports that using SG/TSO results in
+	 * tx timeouts. However for a lot of people SG/TSO works fine.
+	 * Therefore disable both features by default, but allow users to
+	 * enable them. Use at own risk!
+	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
-		dev->hw_features |= NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
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
-	}
-
-	dev->features |= dev->hw_features;
-
 	dev->hw_features |= NETIF_F_RXALL;
 	dev->hw_features |= NETIF_F_RXFCS;
 
-- 
2.26.0

