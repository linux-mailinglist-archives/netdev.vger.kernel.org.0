Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31003143351
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 22:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbgATVUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 16:20:07 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40358 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgATVUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 16:20:06 -0500
Received: by mail-wm1-f68.google.com with SMTP id t14so812489wmi.5
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 13:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q4W7SncJJeCKhGmNl4kdclLjj2pOCqXPJ7fcBuOXUms=;
        b=QbKCH4av6QHJFr4V/8xX9/dmrcaAz23I+3q9IzJV4YgH+kvxEZU/vjj+HYREaL5v5r
         Ev2S0koXlnSXrFjNIbbRR594DW3HG7iOsDwgsXOhxFTPaWlFnNoTji+Aycqf1S/X1N/5
         GREHSlaNBD4W96M2zNvvBVyytbk73UIOgNsZUovWog4v/u65Es+u3hBYYR4YcTP7DQgl
         40etcGkERHR/uNhqLy16bzEdmyZmggsu3ep8r/QpfCKvmyIe/YQIH2EgTH4dkurwHH79
         3nokNq08IM9M/RR7Prk3SSDmd3ZUv5g752Aby3FlmU1pvnQkI1eKoTfRvGl9G760PROG
         PnUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q4W7SncJJeCKhGmNl4kdclLjj2pOCqXPJ7fcBuOXUms=;
        b=Sv2m9ZIYtn9hQzwFlYpaPyr0X6VbFWS7DqTO8CAo1u+wtZuUasD0JGjp2KtQ5+W4Ld
         IieOJkHD0l3TG+kGocjy+jar3ztOZOuD0F7XBSbV9fyYFdqskO6ZhXo5V/pHU68Kx0Jf
         Oi1Qf4xv7enNi369xm5UdT0NJpc3baRPEykZ+kVbhXOeNT2PCxgwxGfunxQSfk37RPL0
         r5UXEv0VwzTE2f83NV/me6qhvf19dNb+CtQuAqG/CehJArHcGioXDcRI9xh4RQohMqFn
         yQhHRio3HlJJ8o/DkxmeH8iE9owyzUitPQilonuvm9k704GstH9w0wNPYStspu6Ra2Q6
         Igmg==
X-Gm-Message-State: APjAAAUyLU8HiWgRHzGfU6VkC3uVDXTmBonluh+lnEyBPfnUzZq5jw67
        pYaInQaqpbb9CINsTS0/u1MsXccs
X-Google-Smtp-Source: APXvYqw8bD4yOG9OMeMPtakIwii7HC89QfL3uzxf9vNgvrQ2Qw/aHw+oimpHXD+unoc3tuVB0CLVvw==
X-Received: by 2002:a1c:238a:: with SMTP id j132mr669102wmj.183.1579555204517;
        Mon, 20 Jan 2020 13:20:04 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id e12sm48873750wrn.56.2020.01.20.13.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jan 2020 13:20:04 -0800 (PST)
Subject: [PATCH net-next 1/3] net: phy: rename phy_do_ioctl to
 phy_do_ioctl_running
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mark Einon <mark.einon@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
Message-ID: <b2117c4e-c440-83da-7f73-0ddd3e6887fe@gmail.com>
Date:   Mon, 20 Jan 2020 22:16:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <a7a6dc1f-b4d4-e36f-7408-31e4715d947f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We just added phy_do_ioctl, but it turned out that we need another
version of this function that doesn't check whether net_device is
running. So rename phy_do_ioctl to phy_do_ioctl_running.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 +-
 drivers/net/phy/phy.c                     | 6 +++---
 include/linux/phy.h                       | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 175f951b6..7a5fe1137 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5158,7 +5158,7 @@ static const struct net_device_ops rtl_netdev_ops = {
 	.ndo_fix_features	= rtl8169_fix_features,
 	.ndo_set_features	= rtl8169_set_features,
 	.ndo_set_mac_address	= rtl_set_mac_address,
-	.ndo_do_ioctl		= phy_do_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode	= rtl_set_rx_mode,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= rtl8169_netpoll,
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index da05b3480..cf25fa3be 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -433,19 +433,19 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 EXPORT_SYMBOL(phy_mii_ioctl);
 
 /**
- * phy_do_ioctl - generic ndo_do_ioctl implementation
+ * phy_do_ioctl_running - generic ndo_do_ioctl implementation
  * @dev: the net_device struct
  * @ifr: &struct ifreq for socket ioctl's
  * @cmd: ioctl cmd to execute
  */
-int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	if (!netif_running(dev) || !dev->phydev)
 		return -ENODEV;
 
 	return phy_mii_ioctl(dev->phydev, ifr, cmd);
 }
-EXPORT_SYMBOL(phy_do_ioctl);
+EXPORT_SYMBOL(phy_do_ioctl_running);
 
 void phy_queue_state_machine(struct phy_device *phydev, unsigned long jiffies)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 996c4df11..28e8d8102 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1231,7 +1231,7 @@ void phy_ethtool_ksettings_get(struct phy_device *phydev,
 int phy_ethtool_ksettings_set(struct phy_device *phydev,
 			      const struct ethtool_link_ksettings *cmd);
 int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd);
-int phy_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
+int phy_do_ioctl_running(struct net_device *dev, struct ifreq *ifr, int cmd);
 void phy_request_interrupt(struct phy_device *phydev);
 void phy_free_interrupt(struct phy_device *phydev);
 void phy_print_status(struct phy_device *phydev);
-- 
2.25.0


