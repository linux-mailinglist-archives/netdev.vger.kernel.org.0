Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1BB5C930
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 08:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbfGBGSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 02:18:53 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35623 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfGBGSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 02:18:53 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so1865917wml.0
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 23:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=jwZi0018qUB5CHidxDKKx41C6zt1VKosai416bkz7EI=;
        b=Z4sI/Xsg2jtC5wq8+M0X4AYLaEbneXmEjwHAjUBlrwTtg3AqpXn0kqtgTOa/M2Kczc
         2m3zWvyoNsXxTPLGsAEXfEWRlt/0m3PQ08d6DjgkkViqROEYEq6PIQnB0KaFD9SeO7OP
         IXgdgVKKKS16vryiwtzSf6ViZEfHx1E8zRS4ZnARljOkkSP1BzyZBs1VuFO1yM2DPI+p
         PWxIXEwi6QIaLsqOhBuXNXh/9C3QuzzXH3nBV9LG0W3lJzooaasDUeIXI/afDxl+R09s
         xmYSXMjqVnVA1sbIfTgn35ixKD/vBpSQnZzWi88r++uC0H76Pne1lmsj8PnVWU66DprE
         Qjfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=jwZi0018qUB5CHidxDKKx41C6zt1VKosai416bkz7EI=;
        b=IKK90solQXJaU2LiWg1UXImeHa/4vE7qf9OCETttYCmbgR4wWL9JkGHAhJCsnZw/F/
         W26KDtImtlLOGO8QxUvtpDuE/CZmq/+4StUlDQeRmQEWeee/R25p4DS7omF6fR7XEfiu
         /m2TJ0cIVdKuCGpup8Vr3qRh9kXJHes0ZBptUZ2AhVhVB/JqW87f8cDFFm2zFnASpBtM
         CsnHMqI/JF5sb5uBpOrbVkLm/onmfNk4eWJDvRdRf6qwYbfM7WjZ8z+6gjRijCHvaa0I
         Rm2fJY3qXh1pe8SWV/dH0qT0hrzbjzTt5IKPJTbEzfL84CaC3fwxsl5y/3MLkZeGDg8/
         QKNQ==
X-Gm-Message-State: APjAAAW0BEoy+E3Kws/jevV8ZIEwoJPEKT4kYTNwrqX0W9h4fhw71y/z
        q6wJzZqO0AtYKfNP+ZSgrUy9VO3i
X-Google-Smtp-Source: APXvYqwqPpjcLaHYkUvCnv8J5NWbqGwMZu+7ACvcgukvbKUVHQrJJF3JRzaYGz3/7I8SP9vycrhXqg==
X-Received: by 2002:a1c:6545:: with SMTP id z66mr1937550wmb.77.1562048330913;
        Mon, 01 Jul 2019 23:18:50 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:d5f3:78fc:5357:f218? (p200300EA8BD60C00D5F378FC5357F218.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:d5f3:78fc:5357:f218])
        by smtp.googlemail.com with ESMTPSA id k82sm1854062wma.15.2019.07.01.23.18.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 23:18:50 -0700 (PDT)
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] r8169: add random MAC address fallback
Message-ID: <61a7754f-bdf9-f69a-296d-47353a78c8b4@gmail.com>
Date:   Tue, 2 Jul 2019 08:18:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From 1c8bacf724f1450e5256c68fbff407305faf9cbd Mon Sep 17 00:00:00 2001



Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 40 +++++++++++++++--------
 1 file changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 450c74dc1..d6c137b7f 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -6651,13 +6651,36 @@ static int rtl_get_ether_clk(struct rtl8169_private *tp)
 	return rc;
 }
 
+static void rtl_init_mac_address(struct rtl8169_private *tp)
+{
+	struct net_device *dev = tp->dev;
+	u8 *mac_addr = dev->dev_addr;
+	int rc, i;
+
+	rc = eth_platform_get_mac_address(tp_to_dev(tp), mac_addr);
+	if (!rc)
+		goto done;
+
+	rtl_read_mac_address(tp, mac_addr);
+	if (is_valid_ether_addr(mac_addr))
+		goto done;
+
+	for (i = 0; i < ETH_ALEN; i++)
+		mac_addr[i] = RTL_R8(tp, MAC0 + i);
+	if (is_valid_ether_addr(mac_addr))
+		goto done;
+
+	eth_hw_addr_random(dev);
+	dev_warn(tp_to_dev(tp), "can't read MAC address, setting random one\n");
+done:
+	rtl_rar_set(tp, mac_addr);
+}
+
 static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
-	/* align to u16 for is_valid_ether_addr() */
-	u8 mac_addr[ETH_ALEN] __aligned(2) = {};
 	struct rtl8169_private *tp;
 	struct net_device *dev;
-	int chipset, region, i;
+	int chipset, region;
 	int jumbo_max, rc;
 
 	dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
@@ -6749,16 +6772,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	u64_stats_init(&tp->rx_stats.syncp);
 	u64_stats_init(&tp->tx_stats.syncp);
 
-	/* get MAC address */
-	rc = eth_platform_get_mac_address(&pdev->dev, mac_addr);
-	if (rc)
-		rtl_read_mac_address(tp, mac_addr);
-
-	if (is_valid_ether_addr(mac_addr))
-		rtl_rar_set(tp, mac_addr);
-
-	for (i = 0; i < ETH_ALEN; i++)
-		dev->dev_addr[i] = RTL_R8(tp, MAC0 + i);
+	rtl_init_mac_address(tp);
 
 	dev->ethtool_ops = &rtl8169_ethtool_ops;
 
-- 
2.22.0

