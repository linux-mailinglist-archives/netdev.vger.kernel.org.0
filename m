Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D612141E32
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 14:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgASNdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 08:33:17 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34735 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASNdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 08:33:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id w5so12842672wmi.1
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 05:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=glamX5jkvHht+OG3TLQWSWSKBc+4fcxu4JSqdKxXl1g=;
        b=mRD2GxasM6DWOOzu7/48q4GLuHwUmn5/40mfAhFVa90r+QO63c4iPRM5bRU9RaBcyb
         F4Rz5I946zdCxNGHTxh5oLJ19jj5klDp60mRXlKxXs949AfgEq3jtVMkdMDxIXP6b09V
         on0udrHmCmKi5PW8OqV+/vI5So+BP3AFbC2txezRfK3QmE3K8oWDrf3dJ4EyRbyKFOA/
         CKVO/ExJhn572OMBkEP57SXt1Nf+4GqE4prir2MnsHefcEs7IEUD5/12Gtff1G1QKuHd
         onkQV7xmdFAgPRSCAjgaVj7h625T3+/hjTG3x8jrujv7o1t+OG6IEq1oWWirHnPeLroW
         jyzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=glamX5jkvHht+OG3TLQWSWSKBc+4fcxu4JSqdKxXl1g=;
        b=CBuZVVuurlm1UvlFTPEOilcxj85wMSLLHynRFD0wYbH9xdRug7gvfWW5Pq7eLtN53g
         +tdb1FWvoU/wSC4OnWFEo75EdE/akiv6ZRqtQ+hfvMj39DzeWhA5u0eO/8AXt2JRlyHq
         KU32i86uwNvawJN1sGd286fQPdi4SLnj/UBSvlgiFy1j0JU4shdRgvyGKm5CMnRVYyl8
         FaqwBtKf/Gyzc+RfytuRpxwf+bxgApD+1NYijayYPQ966t0PQWnDzffiJMnBIf/iTxqn
         NfhMBwtUftRuVMFa/+1fbvqGQX5KEACbjo2z+yLMw2MhmOi/TBcAWudgMgmI9e2WTyNL
         IjLA==
X-Gm-Message-State: APjAAAVpyGmk/So5sVKyRD0R4YaWvY+ldd+xjJmFbRtluOgUjKQpMTre
        AMiW7AhagZn00vFTyOlnxOLjs6wE
X-Google-Smtp-Source: APXvYqxEAKHJVwDyGKGbXcnfnltC/KumrQGwp7R1VBftqhhQKuDjSGfWcEMcr5np9spBcAPSnO74cw==
X-Received: by 2002:a05:600c:230d:: with SMTP id 13mr14909554wmo.12.1579440795150;
        Sun, 19 Jan 2020 05:33:15 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id y20sm1407475wmi.25.2020.01.19.05.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 05:33:14 -0800 (PST)
Subject: [PATCH net-next 2/2] r8169: use generic ndo_do_ioctl handler
 phy_do_ioctl
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
Message-ID: <56187416-0469-c1a9-ed4c-9c969f8f3acd@gmail.com>
Date:   Sun, 19 Jan 2020 14:32:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <520c07a1-dd26-1414-0a2f-7f0d491589d1@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace rtl8169_ioctl with new generic function phy_do_ioctl.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6d699df7d..175f951b6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2298,16 +2298,6 @@ static int rtl_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static int rtl8169_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
-{
-	struct rtl8169_private *tp = netdev_priv(dev);
-
-	if (!netif_running(dev))
-		return -ENODEV;
-
-	return phy_mii_ioctl(tp->phydev, ifr, cmd);
-}
-
 static void rtl_wol_suspend_quirk(struct rtl8169_private *tp)
 {
 	switch (tp->mac_version) {
@@ -5168,7 +5158,7 @@ static const struct net_device_ops rtl_netdev_ops = {
 	.ndo_fix_features	= rtl8169_fix_features,
 	.ndo_set_features	= rtl8169_set_features,
 	.ndo_set_mac_address	= rtl_set_mac_address,
-	.ndo_do_ioctl		= rtl8169_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl,
 	.ndo_set_rx_mode	= rtl_set_rx_mode,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= rtl8169_netpoll,
-- 
2.25.0


