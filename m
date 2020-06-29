Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212E320E27B
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390186AbgF2VFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731086AbgF2TMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:12:43 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC91C0F26C8
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:13 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 17so15845378wmo.1
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hz0iVZuquqaAZG91zpdXr2Uyq4D9Tl6Yab1oO2oLyu4=;
        b=VvL4yO6jCcGsEdtzYiLzKqRQKd+CJHaFyeqJWf7CcFeUmtn3q8wK56Ka3u84RH2/TB
         NB1CiAymp//XtqnFz5/H+ApJeRCUh/SqYJkad+wuFzUrSypwMyamn05nNgh9bLzgio/4
         QBu82NPhZZT4p9ki5bX41KR4ZogP7bglHyn0k1CHfqSTORfkjFmMOuW3F+ZcTgaapo1B
         kH2qepefaYlMyQ/1lvRS5epPqtlijcTGvri5VRyh7kANgzWCz96TsJFHbd1OpXN75CnZ
         b9jNoyvkUTRs0Vyin0UkoI4pBwLsrwpFCWDaCSYqIKh9GuRWgBS4RIRv05e4D75Eph+2
         us+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hz0iVZuquqaAZG91zpdXr2Uyq4D9Tl6Yab1oO2oLyu4=;
        b=JW15dXh4BcprLAecfiQUZsufgNqMGH8CcmZUO0ryyLFg7yzki9zscwVN5KqZzdE01t
         F5JzvSF1H4VOVyz86bWXv+GPghPZySTwHn0OgHMLaK9+8QgUB43Ve0msQEIycgY2/l1G
         uMKJIpy7CzarfzlrGcPh41v+hnmW7ZeHHtRHEWttZxO0ba+qS7HGPI+SFYHp30Z4PUoo
         wA8y9o/N7uXrAd0r5ISSDmCweDv9o3X91/4/DKRr1QJ9vjpF02UskNc5e+XgkLxsbdEd
         pd7RBd+Owp1nB5ASG6HD0J8klZs24DBRNOBi681sjKtc/dWzuvUzZhasYWDM5IQFYXam
         /bRQ==
X-Gm-Message-State: AOAM530MtVxlEY3Rudw64NWd58CnpwXwh9N+F6x1/vyj8Ia4KKYUx7JT
        Yhz4AHfGWajFBbTXhmATVUAo+A==
X-Google-Smtp-Source: ABdhPJwR+XCjvBHh7hN27yb4wbyQ2NgRHNnJda5bGoNm1j9W8pobPb9+mBDwQzfYrDFvbqSH7NAqWg==
X-Received: by 2002:a7b:cc8b:: with SMTP id p11mr17632537wma.180.1593432252690;
        Mon, 29 Jun 2020 05:04:12 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id d81sm25274347wmc.0.2020.06.29.05.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:04:12 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 01/10] net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()
Date:   Mon, 29 Jun 2020 14:03:37 +0200
Message-Id: <20200629120346.4382-2-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200629120346.4382-1-brgl@bgdev.pl>
References: <20200629120346.4382-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This function may fail. Check its return value and propagate the error
code.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 97a423ecf808..8752b5eea091 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11175,10 +11175,14 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			IXGBE_LINK_SPEED_10GB_FULL | IXGBE_LINK_SPEED_1GB_FULL,
 			true);
 
-	ixgbe_mii_bus_init(hw);
+	err = ixgbe_mii_bus_init(hw);
+	if (err)
+		goto err_netdev;
 
 	return 0;
 
+err_netdev:
+	unregister_netdev(netdev);
 err_register:
 	ixgbe_release_hw_control(adapter);
 	ixgbe_clear_interrupt_scheme(adapter);
-- 
2.26.1

