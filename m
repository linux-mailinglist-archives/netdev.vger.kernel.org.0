Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B65A1D7C3F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgERPDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727036AbgERPDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:03:23 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1848CC061A0C;
        Mon, 18 May 2020 08:03:23 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id y18so5078466pfl.9;
        Mon, 18 May 2020 08:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q0vJRwaWiHDVlGbG3eVh8/uWQVt4wHmZxTm6RgydJQg=;
        b=iC18Lt1F9S0QFmiy4w8gAPf9ngNJphTTHweMRteryTOpuIddajPWCthBnN/60KUdX2
         AeoXNZnevaZiRDGOqujyYZk9lQKYvubij7TsyyiAeifkWphQpeekEdx601BFlR7vhZ3E
         cMYsRAffHe1qpRzuxgWFZoxIYX6tRiAo9yd41QrHHuZS91aH8WXhC8xIp85qfKW3JroU
         N3uUvA9CKdnaldcQUC5OshIuuMc9FFbYalXNMszjfK8MwnfpxsmXagQdimhgQmyCPwAk
         X4j29MG9Q8fphqnM9mz4NLN7p9KJ7RbMqkQG0a6njvPax0UgThhe2qbnfquK3v0y7aRr
         iPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q0vJRwaWiHDVlGbG3eVh8/uWQVt4wHmZxTm6RgydJQg=;
        b=YXEP7i3ZRaBQIyIP5Je/3VsWj+XP4xIxmTiLHiTiEKilVHMseI4C204yotAMlUZuV1
         pngA8ZhrkkqK22+z395a/4HRhhpwVUwnWUuyh/pu2wtLjI/4KH/g6DU6f4zCpyWM/Vp/
         HiYHvHiG8HX3rgn6f9VToTuTWnk0HVYjc3s095v3xgZbSpVI24tK821obg6bJe+WhTqo
         Sz732Izq7B49ohkE2DQVXM6hq6tLnf2+zMaPe9HWiw/zlRui5nGCpmT+g0jfsY3TsLcG
         XELaheDWS5lY3Jnzwj0tuG2768XpnZZCouUMN+N07yCMtZB8biglvJjH7Og5OD6OiVj9
         gK5g==
X-Gm-Message-State: AOAM530iOtY7bZDqJO4wIXay3x0o6VVLyKM82crmRmU1F5w4AKOCJMct
        rXm91iezp+kOt74DQOzTsjw=
X-Google-Smtp-Source: ABdhPJy0cN4s+kAwOA6UoSUDKcF5V6dFfDZ6hRyOGNVqB8Vkht1ipy/lVMrfS40Y1q+zHnKfH0zROw==
X-Received: by 2002:aa7:81cf:: with SMTP id c15mr17732953pfn.211.1589814202338;
        Mon, 18 May 2020 08:03:22 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.209])
        by smtp.gmail.com with ESMTPSA id k1sm7963142pgh.78.2020.05.18.08.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:03:21 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        netdev@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, bjorn@helgaas.com,
        linux-kernel-mentees@lists.linuxfoundation.org, rjw@rjwysocki.net,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, skhan@linuxfoundation.org
Subject: [PATCH net-next v3 1/2] realtek/8139too: use generic power management
Date:   Mon, 18 May 2020 20:32:13 +0530
Message-Id: <20200518150214.100491-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518150214.100491-1-vaibhavgupta40@gmail.com>
References: <20200518150214.100491-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

compile-tested only

With legacy PM hooks, it was the responsibility
of a driver to manage PCI states and also
device's power state. The generic approach is
to let PCI core handle the work.

PCI core passes "struct device*" as an argument
to the .suspend() and .resume() callbacks. As
these callabcks work with "struct net_device*",
extract it from "struct device*" using
dev_get_drv_data().

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/ethernet/realtek/8139too.c | 26 +++++++-------------------
 1 file changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 5caeb8368eab..227139d42227 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -2603,17 +2603,13 @@ static void rtl8139_set_rx_mode (struct net_device *dev)
 	spin_unlock_irqrestore (&tp->lock, flags);
 }
 
-#ifdef CONFIG_PM
-
-static int rtl8139_suspend (struct pci_dev *pdev, pm_message_t state)
+static int __maybe_unused rtl8139_suspend(struct device *device)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 	struct rtl8139_private *tp = netdev_priv(dev);
 	void __iomem *ioaddr = tp->mmio_addr;
 	unsigned long flags;
 
-	pci_save_state (pdev);
-
 	if (!netif_running (dev))
 		return 0;
 
@@ -2631,38 +2627,30 @@ static int rtl8139_suspend (struct pci_dev *pdev, pm_message_t state)
 
 	spin_unlock_irqrestore (&tp->lock, flags);
 
-	pci_set_power_state (pdev, PCI_D3hot);
-
 	return 0;
 }
 
-
-static int rtl8139_resume (struct pci_dev *pdev)
+static int __maybe_unused rtl8139_resume(struct device *device)
 {
-	struct net_device *dev = pci_get_drvdata (pdev);
+	struct net_device *dev = dev_get_drvdata(device);
 
-	pci_restore_state (pdev);
 	if (!netif_running (dev))
 		return 0;
-	pci_set_power_state (pdev, PCI_D0);
+
 	rtl8139_init_ring (dev);
 	rtl8139_hw_start (dev);
 	netif_device_attach (dev);
 	return 0;
 }
 
-#endif /* CONFIG_PM */
-
+static SIMPLE_DEV_PM_OPS(rtl8139_pm_ops, rtl8139_suspend, rtl8139_resume);
 
 static struct pci_driver rtl8139_pci_driver = {
 	.name		= DRV_NAME,
 	.id_table	= rtl8139_pci_tbl,
 	.probe		= rtl8139_init_one,
 	.remove		= rtl8139_remove_one,
-#ifdef CONFIG_PM
-	.suspend	= rtl8139_suspend,
-	.resume		= rtl8139_resume,
-#endif /* CONFIG_PM */
+	.driver.pm	= &rtl8139_pm_ops,
 };
 
 
-- 
2.26.2

