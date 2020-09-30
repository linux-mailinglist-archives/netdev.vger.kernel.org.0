Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E2D27EADD
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 16:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgI3OZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 10:25:33 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51506 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729903AbgI3OZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 10:25:32 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20200930142530euoutp02350ac342f8e09f61ff790aa0fe46cb68~5ld_WT4k01577315773euoutp025
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 14:25:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20200930142530euoutp02350ac342f8e09f61ff790aa0fe46cb68~5ld_WT4k01577315773euoutp025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1601475930;
        bh=kP2QzYD1TnWIEDUfY/0I4ABiDInwgfu2E8ovgtbGEoY=;
        h=From:To:Cc:Subject:Date:References:From;
        b=h46DHNgfDX0956sxTSt4iIjOxRzhW51SWlAMhPMSDRPqAOtPHZqHTokmzDTsJvZsL
         ETl6cUmigPBzG/vuDOyRnLE9/8o1FF9awhzv8Czyw0X+JRcD2lGWTxpjstqWcjJdJv
         CKAQ3y9WNR9lnGMPki4NMPTdTAcIwLEjDIbuK/Q8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200930142529eucas1p131ec3a946a690ac0d51cfbfbdc4f507c~5ld_EmdQF1309213092eucas1p1J;
        Wed, 30 Sep 2020 14:25:29 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id E4.D8.06318.955947F5; Wed, 30
        Sep 2020 15:25:29 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20200930142529eucas1p12ae6db625be4a7bdfaf2ca60bf94cb8e~5ld9wIWq60905309053eucas1p1e;
        Wed, 30 Sep 2020 14:25:29 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200930142529eusmtrp297140ed147c9e5bdf05298048480b330~5ld9vfJWY2289522895eusmtrp2d;
        Wed, 30 Sep 2020 14:25:29 +0000 (GMT)
X-AuditID: cbfec7f5-38bff700000018ae-1e-5f7495599243
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 70.E4.06314.955947F5; Wed, 30
        Sep 2020 15:25:29 +0100 (BST)
Received: from localhost (unknown [106.120.51.46]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20200930142529eusmtip16114ca8a128c9a9f2d803f874bf74c77~5ld9kPY5Z0381403814eusmtip1k;
        Wed, 30 Sep 2020 14:25:29 +0000 (GMT)
From:   =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Cc:     b.zolnierkie@samsung.com, m.szyprowski@samsung.com,
        =?UTF-8?q?=C5=81ukasz=20Stelmach?= <l.stelmach@samsung.com>
Subject: [PATCH] net/smscx5xx: change to of_get_mac_address()
 eth_platform_get_mac_address()
Date:   Wed, 30 Sep 2020 16:25:25 +0200
Message-Id: <20200930142525.23261-1-l.stelmach@samsung.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Organization: Samsung R&D Institute Poland
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsWy7djP87qRU0viDU7v1rLYOGM9q8Wc8y0s
        Fhe29bFa3Dy0gtFi0bJWZou1R+6yWxxbIGbR/OkVk8XviRfZHDg9tqy8yeSxaVUnm8edH0sZ
        Pfq2rGL0+N98mcXj8ya5ALYoLpuU1JzMstQifbsErowlJ/exF1wSrFi05QBLA+NNvi5GTg4J
        AROJTzevM3UxcnEICaxglOjdt5IFwvnCKPH3/zs2COczo8TLmV/YYVoetnyDqlrOKDG/p4sd
        wnnOKHFt7gxGkCo2AUeJ/qUnWEESIgI/GCV+/u4ASzALlEpsPf6WGcQWFoiTOHDwHBuIzSKg
        KjHr6xSwGl4Ba4nuKVuh1slLtC/fzgYRF5Q4OfMJC4jNL6AlsabpOgvETHmJ5q2zmUGWSQis
        Y5e40fMQ6CUOIMdFonFfMcQcYYlXx7dAzZSR+L9zPlRJvcTkSWYQrT2MEtvm/GCBqLGWuHPu
        FxtIDbOApsT6XfoQYUeJI9O+s0O08knceCsIcQGfxKRt05khwrwSHW1CENUqEuv690ANlJLo
        fbWCEcL2kLg1+xbLBEbFWUj+moXkl1kIexcwMq9iFE8tLc5NTy02zkst1ytOzC0uzUvXS87P
        3cQITEOn/x3/uoNx35+kQ4wCHIxKPLwT8krihVgTy4orcw8xSnAwK4nwOp09HSfEm5JYWZVa
        lB9fVJqTWnyIUZqDRUmc13jRy1ghgfTEktTs1NSC1CKYLBMHp1QDI0O3ncvjUh+naxOe/ZLo
        dZL242f8pO35v6Cj3GlR7Qf5Uwc3b766/x23A7O9kR+TooTHvIo+szvzV53xTuWwuc+Zn9hw
        8OCEGhcjvqun7677q6z1fofdglQ3J8szdj/zouo2zNbNKZyh9Vjy5KOfs5Q/p+af/pGqUVyp
        OFv5yP3ke38uS//iV2Ipzkg01GIuKk4EAOyJYz8/AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsVy+t/xu7qRU0viDd59EbbYOGM9q8Wc8y0s
        Fhe29bFa3Dy0gtFi0bJWZou1R+6yWxxbIGbR/OkVk8XviRfZHDg9tqy8yeSxaVUnm8edH0sZ
        Pfq2rGL0+N98mcXj8ya5ALYoPZui/NKSVIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9
        O5uU1JzMstQifbsEvYwlJ/exF1wSrFi05QBLA+NNvi5GTg4JAROJhy3fWLoYuTiEBJYySqyd
        2MvaxcgBlJCSWDk3HaJGWOLPtS42iJqnjBJ35s1nBEmwCThK9C89wQqSEBH4wyjx98Z1dpBm
        ZoFyiRcHA0FqhAViJDZu2sECYrMIqErM+joFrJdXwFqie8pWdogF8hLty7ezQcQFJU7OfMIC
        MUZdYv08IZAwv4CWxJqm62BjmIHKm7fOZp7AKDALSccshI5ZSKoWMDKvYhRJLS3OTc8tNtQr
        TswtLs1L10vOz93ECIyhbcd+bt7BeGlj8CFGAQ5GJR7eCXkl8UKsiWXFlbmHGCU4mJVEeJ3O
        no4T4k1JrKxKLcqPLyrNSS0+xGgK9M5EZinR5HxgfAP1GJoamltYGpobmxubWSiJ83YIHIwR
        EkhPLEnNTk0tSC2C6WPi4JRqYJx49eeWdworOVcl1C0N8J8r/veC6+o+k6nvdliuXMqx89GV
        vDaf/JO3jj7tnP141gpuSydHH1Fjp90/Oq4Kit3rXMVpJxjwla3T+Ltyj+msaIkP6Y3T8wT2
        lP3ICFANb9Z8FD+jWlv1SNEnmX9fhL+4G394a3TjUomo1VINdk/DbXGhF28ZnVViKc5INNRi
        LipOBACCKJPstwIAAA==
X-CMS-MailID: 20200930142529eucas1p12ae6db625be4a7bdfaf2ca60bf94cb8e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20200930142529eucas1p12ae6db625be4a7bdfaf2ca60bf94cb8e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20200930142529eucas1p12ae6db625be4a7bdfaf2ca60bf94cb8e
References: <CGME20200930142529eucas1p12ae6db625be4a7bdfaf2ca60bf94cb8e@eucas1p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use more generic eth_platform_get_mac_address() which can get a MAC
address from other than DT platform specific sources too. Check if the
obtained address is valid.

Signed-off-by: Łukasz Stelmach <l.stelmach@samsung.com>
---
 drivers/net/usb/smsc75xx.c | 13 +++++++------
 drivers/net/usb/smsc95xx.c | 13 +++++++------
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 9556d431885f..8689835a5214 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -757,13 +757,14 @@ static int smsc75xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 
 static void smsc75xx_init_mac_address(struct usbnet *dev)
 {
-	const u8 *mac_addr;
-
 	/* maybe the boot loader passed the MAC address in devicetree */
-	mac_addr = of_get_mac_address(dev->udev->dev.of_node);
-	if (!IS_ERR(mac_addr)) {
-		ether_addr_copy(dev->net->dev_addr, mac_addr);
-		return;
+	if (!eth_platform_get_mac_address(&dev->udev->dev,
+			dev->net->dev_addr)) {
+		if (is_valid_ether_addr(dev->net->dev_addr)) {
+			/* device tree values are valid so use them */
+			netif_dbg(dev, ifup, dev->net, "MAC address read from the device tree\n");
+			return;
+		}
 	}
 
 	/* try reading mac address from EEPROM */
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 601fb40a2a0a..ea0d5f04dc3a 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -755,13 +755,14 @@ static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 
 static void smsc95xx_init_mac_address(struct usbnet *dev)
 {
-	const u8 *mac_addr;
-
 	/* maybe the boot loader passed the MAC address in devicetree */
-	mac_addr = of_get_mac_address(dev->udev->dev.of_node);
-	if (!IS_ERR(mac_addr)) {
-		ether_addr_copy(dev->net->dev_addr, mac_addr);
-		return;
+	if (!eth_platform_get_mac_address(&dev->udev->dev,
+			dev->net->dev_addr)) {
+		if (is_valid_ether_addr(dev->net->dev_addr)) {
+			/* device tree values are valid so use them */
+			netif_dbg(dev, ifup, dev->net, "MAC address read from the device tree\n");
+			return;
+		}
 	}
 
 	/* try reading mac address from EEPROM */
-- 
2.26.2

