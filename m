Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177D31B1878
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgDTVaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726017AbgDTVaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:30:04 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F12C061A0E
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:30:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id i10so13998931wrv.10
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 14:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6LFshShX9HGZc8I/01BpEYGIfOcYS2dXQ6TeVJz431k=;
        b=QaEmv8tl8TsFHnCma9TgSkfWTbuZb5D6KgFaX/cjXSpXh9+ii3lVmmuo0UmXwjhtsM
         t0KGoHL7crTKQCNCD69OGHbDaBL0/zGQCw/wSpmEbRcP1vakj+kKz7EesXoQ1CI9dy6/
         ywwCBTaAf5o8g0/A9VJlNCJITaCIoyvZFQyTl3zt9tDRzJW/zPEiKj+LzDZ6CVFGmDl8
         6LldIdcXBvKUoutCiJuNOVE55S2GibZsmyehyPnWp4sjmDMIrmC32f4YuGqGgiJH1rNR
         Eb0mYyDn6iyb2RGLaEd7N+45N4ntYrnlYm4VlDCGC/I9x4GfUMDd5e8eECEBLhDtCB1O
         wkHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6LFshShX9HGZc8I/01BpEYGIfOcYS2dXQ6TeVJz431k=;
        b=cKV80MPn6MxccDkUV4MiNWPoOUHTpHZXtxgTCYHUXtQRc5UFf/RHYa8AU+Pb+67aLN
         itTtEBBsQKMr4Z/Ksr+uWXj7oJl6xnFrzsMB+Qiqfh7dC9tFkfdDsJNQFefTNtR7KAmb
         wS6EZXrJwZURAPYGzX4QwdSgLM1SMbZTHOvQBeGzDU4m4dxhxHjPqXVO6kcJVhjBQapp
         /+xGJKeut/Kkxb3oDg4coajJ9pe97jLoB1QSMBPBSGKLH/esyFSe/OmXCO1T8UZPdtGU
         mn3lFcb0HkGECf8Igk2EW2cSJS8NMsL2CdSph61XlufYOayOhbrmatPWodA3tNd5g55C
         EIvQ==
X-Gm-Message-State: AGi0PuaN971yJ+SakOl74qvoW2lwQOC5MNwNVQDXhpB0pAxk1sIH2YKU
        skloJ9FG7JTTYAsVuLIhkoj0M4Y9
X-Google-Smtp-Source: APiQypJ/iwO0mBOR/caylyGMQiBWRHLeiS46AIC78JGyLq1KypWKSAC28Pc1UhgFZWKfFPpLScX9QQ==
X-Received: by 2002:a5d:428a:: with SMTP id k10mr20830860wrq.59.1587418201327;
        Mon, 20 Apr 2020 14:30:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:7101:507:3ef2:1ef1? (p200300EA8F296000710105073EF21EF1.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7101:507:3ef2:1ef1])
        by smtp.googlemail.com with ESMTPSA id s14sm826845wmh.18.2020.04.20.14.30.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 14:30:00 -0700 (PDT)
Subject: [PATCH net-next 2/2] r8169: use devm_mdiobus_register
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9b83837d-d246-ffb0-0c52-8d4c5064e7e4@gmail.com>
Message-ID: <fbd2d99e-f732-58be-d056-3362f919b973@gmail.com>
Date:   Mon, 20 Apr 2020 23:29:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <9b83837d-d246-ffb0-0c52-8d4c5064e7e4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new function devm_mdiobus_register() to simplify the driver.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bb8dcdb17..b3a7217ce 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5187,20 +5187,18 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
 	new_bus->read = r8169_mdio_read_reg;
 	new_bus->write = r8169_mdio_write_reg;
 
-	ret = mdiobus_register(new_bus);
+	ret = devm_mdiobus_register(new_bus);
 	if (ret)
 		return ret;
 
 	tp->phydev = mdiobus_get_phy(new_bus, 0);
 	if (!tp->phydev) {
-		mdiobus_unregister(new_bus);
 		return -ENODEV;
 	} else if (!tp->phydev->drv) {
 		/* Most chip versions fail with the genphy driver.
 		 * Therefore ensure that the dedicated PHY driver is loaded.
 		 */
 		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
-		mdiobus_unregister(new_bus);
 		return -EUNATCH;
 	}
 
@@ -5525,7 +5523,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	rc = register_netdev(dev);
 	if (rc)
-		goto err_mdio_unregister;
+		return rc;
 
 	netif_info(tp, probe, dev, "%s, %pM, XID %03x, IRQ %d\n",
 		   rtl_chip_infos[chipset].name, dev->dev_addr, xid,
@@ -5544,10 +5542,6 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pm_runtime_put_sync(&pdev->dev);
 
 	return 0;
-
-err_mdio_unregister:
-	mdiobus_unregister(tp->phydev->mdio.bus);
-	return rc;
 }
 
 static struct pci_driver rtl8169_pci_driver = {
-- 
2.26.1


