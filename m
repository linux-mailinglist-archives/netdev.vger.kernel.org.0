Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B78FC480D1E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237294AbhL1VCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:02:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhL1VCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:02:40 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F3CC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 13:02:39 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id j18so40525384wrd.2
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 13:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:to:cc:content-language
         :subject:content-transfer-encoding;
        bh=KTNNB8Gazwf17/yaGpHolRJvfa9KIrx12W556P4gHzQ=;
        b=Pm2bC+Mc3mIX7xF2cXg/EySVQOsXvvt784ekydTZtIEJ6hLGzkv8GnFb6XBbXNuxjy
         cMRH6W1nWql0O4JIfrRpd+Si47Qq9I2E4bIVhG4b+3NWubHsnYJD8dDKdS8cpfL35Agt
         OhtHYbZs2JlNZ0P8ekEKpULRSS440RoSjiG4Q1ywkymNkZ4PkZpFqXGc8y2+Z8gucHLy
         a1HiefMHfxPcOs368egeMW2tYt5Rg0rsx8kMj4y79PG1WmeDIGJu3MxUDn0A68YEJWJL
         l18m5cxGa3h2iHO7O/sFueNxn653MFP1bzIId7caCNRdy6ZqWa3ghgBARRXLCNmwku/P
         FPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from:to
         :cc:content-language:subject:content-transfer-encoding;
        bh=KTNNB8Gazwf17/yaGpHolRJvfa9KIrx12W556P4gHzQ=;
        b=OC3MQXRN20ffCIEGhGv7chklTx0LY2r7CET+W/dKqHDU/2W7oTOQwJsf6ru3dvG69D
         sSqRy5qBJkBdpboQMNb8syZkyRGCZaEkjvynO8ipSzs7DRWbIq5E982rndqHrS7FdAbm
         6imAKwM3ijhaKO8c7eOXDg1tPDwdYsSuoRKA66kYXTwIAEfxvI7S5wbT/gKGHSki+13A
         6xGBUs6VDAO93/8L/jq78IGnI9BCHy83aZqFppT7ZJ8QghGyGW/d16eWcumKlAXo6S0I
         +wmn0g+s8r+nQR/7AMLfKHu9TlRiVC3Y6bVn204Udy9WCLTTVedOTcNoo+q8HdfBQxHC
         5oCQ==
X-Gm-Message-State: AOAM5318H/AIdf9iSO2+bpXRHzKJvXzh45T6MhPCejH8tY2jNx85i5bl
        B2Ggtvg17csA5pZeQPwBKBA=
X-Google-Smtp-Source: ABdhPJy/xlveaGkDlX8CZSlRXOHqOimKp1Mb/cDISmaKfxS14euEPkgHPDeB2tWWTS53w5EDUQn5aw==
X-Received: by 2002:adf:aa9d:: with SMTP id h29mr17500668wrc.120.1640725358089;
        Tue, 28 Dec 2021 13:02:38 -0800 (PST)
Received: from ?IPV6:2003:ea:8f24:fd00:1db4:9082:d8f:5ea5? (p200300ea8f24fd001db490820d8f5ea5.dip0.t-ipconnect.de. [2003:ea:8f24:fd00:1db4:9082:d8f:5ea5])
        by smtp.googlemail.com with ESMTPSA id c8sm18989587wrp.40.2021.12.28.13.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Dec 2021 13:02:37 -0800 (PST)
Message-ID: <3cd24763-f307-78f5-76ed-a5fbf315fb28@gmail.com>
Date:   Tue, 28 Dec 2021 22:02:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Language: en-US
Subject: [PATCH net-next] r8169: don't use pci_irq_vector() in atomic context
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Since referenced change pci_irq_vector() can't be used in atomic
context any longer. This conflicts with our usage of this function
in rtl8169_netpoll(). Therefore store the interrupt number in
struct rtl8169_private.

Fixes: 495c66aca3da ("genirq/msi: Convert to new functions")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 3d6843332..7161a5b1c 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -615,6 +615,7 @@ struct rtl8169_private {
 	struct ring_info tx_skb[NUM_TX_DESC];	/* Tx data buffers */
 	u16 cp_cmd;
 	u32 irq_mask;
+	int irq;
 	struct clk *clk;
 
 	struct {
@@ -4712,7 +4713,7 @@ static int rtl8169_close(struct net_device *dev)
 
 	cancel_work_sync(&tp->wk.work);
 
-	free_irq(pci_irq_vector(pdev, 0), tp);
+	free_irq(tp->irq, tp);
 
 	phy_disconnect(tp->phydev);
 
@@ -4733,7 +4734,7 @@ static void rtl8169_netpoll(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	rtl8169_interrupt(pci_irq_vector(tp->pci_dev, 0), tp);
+	rtl8169_interrupt(tp->irq, tp);
 }
 #endif
 
@@ -4767,8 +4768,7 @@ static int rtl_open(struct net_device *dev)
 	rtl_request_firmware(tp);
 
 	irqflags = pci_dev_msi_enabled(pdev) ? IRQF_NO_THREAD : IRQF_SHARED;
-	retval = request_irq(pci_irq_vector(pdev, 0), rtl8169_interrupt,
-			     irqflags, dev->name, tp);
+	retval = request_irq(tp->irq, rtl8169_interrupt, irqflags, dev->name, tp);
 	if (retval < 0)
 		goto err_release_fw_2;
 
@@ -4785,7 +4785,7 @@ static int rtl_open(struct net_device *dev)
 	return retval;
 
 err_free_irq:
-	free_irq(pci_irq_vector(pdev, 0), tp);
+	free_irq(tp->irq, tp);
 err_release_fw_2:
 	rtl_release_firmware(tp);
 	rtl8169_rx_clear(tp);
@@ -5360,6 +5360,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_err(&pdev->dev, "Can't allocate interrupt\n");
 		return rc;
 	}
+	tp->irq = pci_irq_vector(pdev, 0);
 
 	INIT_WORK(&tp->wk.work, rtl_task);
 
@@ -5435,8 +5436,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return rc;
 
 	netdev_info(dev, "%s, %pM, XID %03x, IRQ %d\n",
-		    rtl_chip_infos[chipset].name, dev->dev_addr, xid,
-		    pci_irq_vector(pdev, 0));
+		    rtl_chip_infos[chipset].name, dev->dev_addr, xid, tp->irq);
 
 	if (jumbo_max)
 		netdev_info(dev, "jumbo features [frames: %d bytes, tx checksumming: %s]\n",
-- 
2.34.1

