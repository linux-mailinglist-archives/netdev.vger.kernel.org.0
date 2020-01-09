Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B90BB136125
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 20:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgAITfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 14:35:40 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35933 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730605AbgAITfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 14:35:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id z3so8692368wru.3
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 11:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9AGzoXyCKCjz5pOEoG+N7Kolh5tH6DRvHiYk0Cmzpao=;
        b=J2xBVxC2tOvsw9EZBTjEvzIRk0r8Eu76Keb9z1QCjgOH3M29OuayErxzxAxZC7iJd2
         nSuotyFD1tZKrINTdbKGCO2c7e50b3+MQVfnSX+5oKcfGdPfm7DiOaKpqLtrURUIqy9D
         PAqxMkWbq2xqRbNXtC+KaGUZYijklcMvm2PMWHzvGaK4Kz5wrCRZgrBL/t4fS9Gzle2m
         e2+wFJ3nTXICc6uptgxHZq2E8DqYK6/JFbTPlgTDgQXGikaALi932yEh+YBDHk7XvAND
         WIVE17poclNSYmDvIU69FcTVtIAhwjUZX2xfXhCkHprKS8N7VQJ5NFwv7v6Ym+paokti
         9bcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9AGzoXyCKCjz5pOEoG+N7Kolh5tH6DRvHiYk0Cmzpao=;
        b=PiRp3rJ8GDEsnIyihL6XzBirkKKR1TPnvh7zi0a68968tdMhc5I9HHH7YDwSIf7+9m
         FjtVnOs04A9JJlha2lIXSUbMuZaoQuCDLFz6EbMAH2TRUyxcVqfR3n0xmnP8FuFoaXBx
         r28/bQQcoU0ufg0UHZUot002PBMt9FyDHqQvthHUN73FWYDCr2Zox1rijlvNpzNI3emQ
         0/76iYb1ey0pBERL3YMA46GvKofnwg8LKItUkoWSxz45X53/balnDRYpbl8MuCIIyiLz
         sBOZBPMwH6YPpw7ujA1AHhh2oCq2wLhj5JnRYV97OEdCYnIlcyHCmdJ9ubtUg+wMpqh4
         NHiA==
X-Gm-Message-State: APjAAAXcA5UTK+fGrMJWuprcgIfdQb6iqAhugkudaGR7z6VWFXQsR5eK
        NnwBntdiqrMCkgaYg48M7RWRxacl
X-Google-Smtp-Source: APXvYqx2A6+62ScJJGcbYYcISgqDjqg9P/iN5JLn3vIp2IP+b9UFOKz2MNUdw4J2oaQNhwhAC5eSCA==
X-Received: by 2002:a05:6000:1142:: with SMTP id d2mr11804671wrx.253.1578598537633;
        Thu, 09 Jan 2020 11:35:37 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id u24sm3817510wml.10.2020.01.09.11.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 11:35:37 -0800 (PST)
Subject: [PATCH net-next 03/15] r8169: move RTL8169scd Gigabyte PHY quirk
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Message-ID: <61d202d7-7ce8-414d-6ed3-3a85b502467a@gmail.com>
Date:   Thu, 9 Jan 2020 20:26:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <7e03fe05-ba95-c3c0-9a68-306b6450a141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation of factoring out rtl8169scd_hw_phy_config() move this
quirk to rtl8169_init_phy().

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7277d39f5..3514de25d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2425,17 +2425,6 @@ static void rtl8169sb_hw_phy_config(struct rtl8169_private *tp,
 	phy_write_paged(phydev, 0x0002, 0x01, 0x90d0);
 }
 
-static void rtl8169scd_hw_phy_config_quirk(struct rtl8169_private *tp)
-{
-	struct pci_dev *pdev = tp->pci_dev;
-
-	if ((pdev->subsystem_vendor != PCI_VENDOR_ID_GIGABYTE) ||
-	    (pdev->subsystem_device != 0xe000))
-		return;
-
-	phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
-}
-
 static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp,
 				     struct phy_device *phydev)
 {
@@ -2480,8 +2469,6 @@ static void rtl8169scd_hw_phy_config(struct rtl8169_private *tp,
 	};
 
 	rtl_writephy_batch(tp, phy_reg_init);
-
-	rtl8169scd_hw_phy_config_quirk(tp);
 }
 
 static void rtl8169sce_hw_phy_config(struct rtl8169_private *tp,
@@ -3633,6 +3620,11 @@ static void rtl8169_init_phy(struct rtl8169_private *tp)
 		RTL_W8(tp, 0x82, 0x01);
 	}
 
+	if (tp->mac_version == RTL_GIGA_MAC_VER_05 &&
+	    tp->pci_dev->subsystem_vendor == PCI_VENDOR_ID_GIGABYTE &&
+	    tp->pci_dev->subsystem_device == 0xe000)
+		phy_write_paged(tp->phydev, 0x0001, 0x10, 0xf01b);
+
 	/* We may have called phy_speed_down before */
 	phy_speed_up(tp->phydev);
 
-- 
2.24.1


