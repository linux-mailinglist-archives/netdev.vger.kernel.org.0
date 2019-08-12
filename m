Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44D958A9EE
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 23:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfHLVwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 17:52:35 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38284 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfHLVwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 17:52:34 -0400
Received: by mail-wm1-f66.google.com with SMTP id m125so928425wmm.3
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 14:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AziyKkw1tZbLD/raoXvfvt6OhxH4cG4tfyvndzRt878=;
        b=EqS3U1egE3lkiasjNHd6FoYqHFpLnvc2NDpTov+VfRWJD+sHvhi9pQfNQSCRDI+X6a
         A7QWqavELSUHBE/3XHLRrQWcgNo3551UdwtXTdGjDCBYtfgqHJfbTrJQIBMJSZrzdxGK
         nQA20OONyFe3GG6GLM+RxX6YplYTie1WwEBo0JpXGvlLRg7MTZw3tgHhhLnR0KUe+GJR
         bZp7x2a0KImpjDE1lxZR9zv6gPxBRsMRodyoSrNoqae02G7rEuAAo89zHbLDOLIK4JH7
         iHejfugxCbMl3hEdGJGlTHpGp68iW3n1k4E+xec+pq1CKsQQbeFOIEoQRnK6NFrBnO3s
         5ZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AziyKkw1tZbLD/raoXvfvt6OhxH4cG4tfyvndzRt878=;
        b=Wr/RGFliKsqAqUGqbNO3R3N/faCtwES7U3Nmgx3s3779yMCkgS9/ex5XXY+8Fv2Jfm
         /QiRnBy8R0IWJGa7my/DpcyRWrbGKA6a45+1Wwom98ReSmQdLe5lD9qE5S4BSx/TGYqM
         Mse4xG+Z/v+zX+/21oRrCIcsirV97vwPBIkcyLLm0gfEAqx9fySF261IFMPnGwHUn4JY
         nUsWYoDzYbeO2lzmPYAXDzilauY41cKnhQvkQUQQoyBDKgwPn6kXUNEILsVmYXymS460
         ype12UJ5oZp81iJnckLmdSZ3nmJ2q247PRluNEdTbzefUJzWL90E5g99BMsUrD7dP41g
         S1xQ==
X-Gm-Message-State: APjAAAUAymM8UMClndScCcwXPiAwf8IYEikRJZhYIsIcBNo2eShMd4ZV
        hFV/Wekg/bpD6bglpbEQYa6Ew/iL
X-Google-Smtp-Source: APXvYqzvjO6Vqt0gcSwe0PL+ocxw5psqGRs5GaCJkYg7CvyR8FU2c5Dm3nBBBDtJzc7kbneCn88yUw==
X-Received: by 2002:a1c:cfc6:: with SMTP id f189mr1149403wmg.18.1565646752047;
        Mon, 12 Aug 2019 14:52:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6? (p200300EA8F2F3200E9C14D4C1CCF09D6.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:e9c1:4d4c:1ccf:9d6])
        by smtp.googlemail.com with ESMTPSA id v16sm103953490wrn.28.2019.08.12.14.52.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:52:31 -0700 (PDT)
Subject: [PATCH net-next v2 2/3] net: phy: add phy_speed_down_core and
 phy_resolve_min_speed
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
Message-ID: <d0c44f84-d441-9d4e-96e1-d8abb7c0e508@gmail.com>
Date:   Mon, 12 Aug 2019 23:51:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <dca82a0e-e936-b60a-3a1c-9fdb1714d1d3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

phy_speed_down_core provides most of the functionality for
phy_speed_down. It makes use of new helper phy_resolve_min_speed that is
based on the sorting of the settings[] array. In certain cases it may be
helpful to be able to exclude legacy half duplex modes, therefore
prepare phy_resolve_min_speed() for it.

v2:
- rename __phy_speed_down to phy_speed_down_core

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy-core.c | 28 ++++++++++++++++++++++++++++
 include/linux/phy.h        |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
index 95f1e85d0..369903d9b 100644
--- a/drivers/net/phy/phy-core.c
+++ b/drivers/net/phy/phy-core.c
@@ -315,6 +315,34 @@ void phy_resolve_aneg_linkmode(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(phy_resolve_aneg_linkmode);
 
+static int phy_resolve_min_speed(struct phy_device *phydev, bool fdx_only)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(common);
+	int i = ARRAY_SIZE(settings);
+
+	linkmode_and(common, phydev->lp_advertising, phydev->advertising);
+
+	while (--i >= 0) {
+		if (test_bit(settings[i].bit, common)) {
+			if (fdx_only && settings[i].duplex != DUPLEX_FULL)
+				continue;
+			return settings[i].speed;
+		}
+	}
+
+	return SPEED_UNKNOWN;
+}
+
+int phy_speed_down_core(struct phy_device *phydev)
+{
+	int min_common_speed = phy_resolve_min_speed(phydev, true);
+
+	if (min_common_speed == SPEED_UNKNOWN)
+		return -EINVAL;
+
+	return __set_linkmode_max_speed(min_common_speed, phydev->advertising);
+}
+
 static void mmd_phy_indirect(struct mii_bus *bus, int phy_addr, int devad,
 			     u16 regnum)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 781f4810c..62fdc7ff2 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -665,6 +665,7 @@ size_t phy_speeds(unsigned int *speeds, size_t size,
 		  unsigned long *mask);
 void of_set_phy_supported(struct phy_device *phydev);
 void of_set_phy_eee_broken(struct phy_device *phydev);
+int phy_speed_down_core(struct phy_device *phydev);
 
 /**
  * phy_is_started - Convenience function to check whether PHY is started
-- 
2.22.0


