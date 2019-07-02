Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D047E5D666
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfGBSqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:46:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37855 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGBSqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:46:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id f17so2139951wme.2
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 11:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EOQlXtSUIUWdUv1xV5bpEHNs4oclO1ymwMrkWWwYjvk=;
        b=gTKYuoJIlrIDO94eZytCsDffRlpqgm/yZpBQy24uVhPP64pGUlCrMGXUEoogN2N7cv
         DN5MPjy1mPP4D174T/fMeqcAId8AVsMHz5shBIuH1PG0A6Ep0KtZvrSE6ZEwe/jZJtJK
         j7mS33pCZ0n2bnFY/WcgRXHX2U17nxt9qKFevys0dsOjLciS3WPN0UMHo+M0MSJWWN7l
         /cv7GITUfbs66TNTWkasEmd/OoT9ki7heXboq8lzHATPhiiNqnRUzPTsnHDxjcIyl958
         K0YXeyTzg0R+SEhT68gbcjRe8pwEE8xKRHvVZ5G009L0KuL66O1QYMemZ+zKSJ6GD3My
         x34w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=EOQlXtSUIUWdUv1xV5bpEHNs4oclO1ymwMrkWWwYjvk=;
        b=pHCNyNphhy49xsceTA+wHJ/Uu6b3Kd8maZse9MCWKOqduC8sCkRAYL5rfo0yjH6V/Q
         Bzhfgld/Qa+bg5Q3bGuypjCXEaC7KpFfcYR4yla4tkH83mPTuDPLjR4c8Xbqr/gOssNK
         YD3Lw9Xafu1RfbNkreVXLYB/BYWU+ZoKjBvo7H7CEFqCH4CoAh+KqQjXdAQP15miVeIO
         fUSP5WTou/0MmbxxP4ta0Uru3jmNajbAwE8wHz5FZVwXc15VGiAUyKPN+ZxlApddMzCb
         ozCICal6+SVTCihTLp/ge5hanUhbdZTl/j9ZDWg+Wke3DkrcDIZFF+rRViTC0fJnQx7Z
         MW9Q==
X-Gm-Message-State: APjAAAXqSCCOLelP2LCxKK2VxIAOo56lBM3w+JcTd0em9CSnCZ5CPXNj
        3l+PapyUH4oETGObafp30PjDsC7f
X-Google-Smtp-Source: APXvYqxv+o0lrqrytD1WpCfxtc6vOLyabbz1VNsAarAiJ1tFsqhlVfgn3fbiTfER7PWnpYc7Wqiqug==
X-Received: by 2002:a05:600c:c6:: with SMTP id u6mr4374603wmm.153.1562093175553;
        Tue, 02 Jul 2019 11:46:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:5180:2626:d7af:c0a1? (p200300EA8BD60C0051802626D7AFC0A1.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:5180:2626:d7af:c0a1])
        by smtp.googlemail.com with ESMTPSA id r131sm3737015wmf.4.2019.07.02.11.46.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 11:46:15 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] r8169: add random MAC address fallback
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <637b6d1f-85b1-dc9a-8e77-68ffcd82eae9@gmail.com>
Date:   Tue, 2 Jul 2019 20:46:09 +0200
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

It was reported that the GPD MicroPC is broken in a way that no valid
MAC address can be read from the network chip. The vendor driver deals
with this by assigning a random MAC address as fallback. So let's do
the same.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- fix broken commit message
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

