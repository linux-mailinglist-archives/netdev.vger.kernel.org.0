Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826C52980EB
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 10:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1414680AbgJYJDX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 05:03:23 -0400
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:34772 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgJYJDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 05:03:23 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Oct 2020 05:03:21 EDT
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id 6EB8120E68
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 08:56:27 +0000 (UTC)
Received: from relay4.mymailcheap.com (relay4.mymailcheap.com [137.74.80.156])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id EC913260EB;
        Sun, 25 Oct 2020 08:56:22 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay4.mymailcheap.com (Postfix) with ESMTPS id 9EC953F162;
        Sun, 25 Oct 2020 09:56:20 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 6ACE32A7E3;
        Sun, 25 Oct 2020 09:56:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1603616180;
        bh=iJnmX9F8tnZvTq4GdfzoPprSXY74hA51WxZv5NOC0gg=;
        h=From:To:Cc:Subject:Date:From;
        b=m12FutUCttNfpiOCWO/aNLxlObMPavdx31g0bUu7IceCAeMmetgJdEPBvDKdPzv8G
         7N1T2LEzF794HdXorXCZND8TsC370V6WMCdEeJmeoVwLjRAn/Jlh6/YrJQkz4yag4L
         ucpi0gwmBXxyXWqFsoFJ0AjondUda9CEVyGVv60s=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PNgqQXGn6izx; Sun, 25 Oct 2020 09:56:19 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Sun, 25 Oct 2020 09:56:19 +0100 (CET)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 2426D400C0;
        Sun, 25 Oct 2020 08:56:18 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="T/s/rDeW";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from ice-e5v2.lan (unknown [59.41.160.66])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 6366B400C5;
        Sun, 25 Oct 2020 08:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1603616172; bh=iJnmX9F8tnZvTq4GdfzoPprSXY74hA51WxZv5NOC0gg=;
        h=From:To:Cc:Subject:Date:From;
        b=T/s/rDeWFiPzqVvvDxg0O67+toD8MoS1eMJ0ft4fZv/qO0QGzJbIuJlAEqZKR1KWr
         axl0CUv4lK0pAS1XaR8pJPo69Dmo+0INkbui171Eey3qkx50KWGze38plWyLf+kJwD
         92/j8aXvIAqHvL477fYGkraK1JHM2gq7IT19EEGQ=
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willy Liu <willy.liu@realtek.com>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com, Icenowy Zheng <icenowy@aosc.io>
Subject: [PATCH] net: phy: realtek: omit setting PHY-side delay when "rgmii" specified
Date:   Sun, 25 Oct 2020 16:55:56 +0800
Message-Id: <20201025085556.2861021-1-icenowy@aosc.io>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2426D400C0
X-Spamd-Result: default: False [6.40 / 20.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.00)[~all];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[aosc.io:+];
         FREEMAIL_TO(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,kernel.org,realtek.com,siol.net];
         RCVD_NO_TLS_LAST(0.10)[];
         RECEIVED_SPAMHAUS_PBL(0.00)[59.41.160.66:received];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[dt];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         RCPT_COUNT_TWELVE(0.00)[12];
         MID_CONTAINS_FROM(1.00)[];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1];
         RCVD_COUNT_TWO(0.00)[2];
         SUSPICIOUS_RECIPS(1.50)[]
X-Rspamd-Server: mail20.mymailcheap.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there are many boards that just set "rgmii" as phy-mode in the
device tree, and leave the hardware [TR]XDLY pins to set PHY delay mode.

In order to keep old device tree working, omit setting delay for just
"RGMII" without any internal delay suffix, otherwise many devices are
broken.

The definition of "rgmii" in the DT binding document is "RX and TX
delays are added by MAC when required", which at least literally do not
forbid the PHY to add delays.

Fixes: bbc4d71d6354 ("net: phy: realtek: fix rtl8211e rx/tx delay config")
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
---
 drivers/net/phy/realtek.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index fb1db713b7fb..7d32db1c789f 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -189,11 +189,6 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val, val);
 
 	switch (phydev->interface) {
-	case PHY_INTERFACE_MODE_RGMII:
-		val_txdly = 0;
-		val_rxdly = 0;
-		break;
-
 	case PHY_INTERFACE_MODE_RGMII_RXID:
 		val_txdly = 0;
 		val_rxdly = RTL8211F_RX_DELAY;
@@ -253,9 +248,6 @@ static int rtl8211e_config_init(struct phy_device *phydev)
 
 	/* enable TX/RX delay for rgmii-* modes, and disable them for rgmii. */
 	switch (phydev->interface) {
-	case PHY_INTERFACE_MODE_RGMII:
-		val = RTL8211E_CTRL_DELAY | 0;
-		break;
 	case PHY_INTERFACE_MODE_RGMII_ID:
 		val = RTL8211E_CTRL_DELAY | RTL8211E_TX_DELAY | RTL8211E_RX_DELAY;
 		break;
-- 
2.28.0
