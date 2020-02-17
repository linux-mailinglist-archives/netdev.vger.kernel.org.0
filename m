Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67553161C59
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 21:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgBQUgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 15:36:18 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39835 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgBQUgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 15:36:17 -0500
Received: by mail-wr1-f68.google.com with SMTP id y11so21312262wrt.6
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 12:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MpJ4DvtYyO+oUgoMfkwYiiyleVaUnKf+mDfdXQCV8hE=;
        b=DhGweMnSe/LGx/J2Y0j0eepNswnTGVd4bIcQdmxhFKPEhoE/9rw6IHQWX7kAYZWdOJ
         5RhOyU0fnWmBWA1t9ssCG5paxupcZeAm68UA6yytI+w6N8dnkoW99K3BlXwf8xn31WzE
         mBaDPOMvHFdkna/ygMJaosAF6vxASqXmvFeO1PLZ346D8zzpyt/mKPkdGi1oedMbTLdY
         Fp+LyMaqkANlevYiwb21fhEUwdV/Fz1ersEraL6TVTH/aM6lklwQVdhzLpTpUKjuws6L
         TJ7eJsy1jD7qiFMw/0xAo4s1d8auhaFW4LqnM723W8P0MRZKpMF9guoPQxzDD1L7G2Gy
         aVig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MpJ4DvtYyO+oUgoMfkwYiiyleVaUnKf+mDfdXQCV8hE=;
        b=cCbZAJRYBq0HzoBDiwZ93MU+pcWaDjU+nl8hO70H4hH5uFg2MX357acnCGqM64k8GT
         0rpKq7Fe/MNfhJuxmqmmHoNVMGZRUGcw/ve7Hc872zzVJX3n29HZK39DiItyaLlt2sOJ
         tyuLzhxapxRBR/ikIKktBuuR2h9RDhXTpRM6gl4+jxeXYn1bb/n+y602QrOFKfejL+UF
         1qE01OvHLx4Q7/JRu/xEMAlxyZCbhgt71OWhrII3jeKQ3wgS+wFEEQs+4tSmxWealEKN
         L9as0G0CJjtSprhualNyQHrV4/kPkav8eozoC6NH1jGN97km8xf+PB+66fzT53jLTShr
         LelQ==
X-Gm-Message-State: APjAAAUJp41vrdspzTZ2NLsLlU81hSlYvqN8BJeCRBZkn8Pioin21g7q
        RuMpEfD1vy5zS2BX1mfINsNRk1r2
X-Google-Smtp-Source: APXvYqwQBuZaufWysqlFR1FQvqqduVv3itQNFIl3jZFudU5hBum2BEPvQ3EWyJRimuzOooi5Mzts9A==
X-Received: by 2002:adf:cd11:: with SMTP id w17mr25029094wrm.66.1581971775621;
        Mon, 17 Feb 2020 12:36:15 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:41c6:31a6:d880:888? (p200300EA8F29600041C631A6D8800888.dip0.t-ipconnect.de. [2003:ea:8f29:6000:41c6:31a6:d880:888])
        by smtp.googlemail.com with ESMTPSA id y7sm910840wmd.1.2020.02.17.12.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2020 12:36:15 -0800 (PST)
Subject: [PATCH net-next 2/2] r8169: let managed MDIO bus handling unregister
 the MDIO bus
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
Message-ID: <fe286040-382a-c705-bd10-f1a3cf318c34@gmail.com>
Date:   Mon, 17 Feb 2020 21:35:56 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <15ee7621-0e74-a3c1-0778-ca4fa6c2e3c6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make use of the recent extension to automagically unregister the MDIO
bus in case managed MDIO bus handling is used.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index ad4bb5ac6..5a9143b50 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5102,7 +5102,6 @@ static void rtl_remove_one(struct pci_dev *pdev)
 	netif_napi_del(&tp->napi);
 
 	unregister_netdev(dev);
-	mdiobus_unregister(tp->phydev->mdio.bus);
 
 	rtl_release_firmware(tp);
 
@@ -5244,10 +5243,8 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 		return ret;
 
 	tp->phydev = mdiobus_get_phy(new_bus, 0);
-	if (!tp->phydev) {
-		mdiobus_unregister(new_bus);
+	if (!tp->phydev)
 		return -ENODEV;
-	}
 
 	/* PHY will be woken up in rtl_open() */
 	phy_suspend(tp->phydev);
@@ -5585,7 +5582,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = register_netdev(dev);
 	if (rc)
-		goto err_mdio_unregister;
+		return rc;
 
 	netif_info(tp, probe, dev, "%s, %pM, XID %03x, IRQ %d\n",
 		   rtl_chip_infos[chipset].name, dev->dev_addr, xid,
@@ -5604,10 +5601,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pm_runtime_put_sync(&pdev->dev);
 
 	return 0;
-
-err_mdio_unregister:
-	mdiobus_unregister(tp->phydev->mdio.bus);
-	return rc;
 }
 
 static struct pci_driver rtl8169_pci_driver = {
-- 
2.25.0


