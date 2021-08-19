Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1873F1A1A
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbhHSNNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239794AbhHSNNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:13:07 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69F1C061575
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:12:30 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id x12so9018914wrr.11
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V09boSFG66nz8jPL2ItfwtlzK7dZXPHZLQbwCkrST28=;
        b=o8fK1m3ttjkL4PWcg9GbTcBzaZMP2B2d0mmLqVkR82YcS70BVKRa3L4O0GNXZGOrgP
         hhP9y0VY0dTUz/lnJh9PWmMnEWwNwOe5TmEolP88YG8CdEUT8TU4GqtImS1htQZHRiDI
         kG05kYVxn3PQvcCWnhUvZIsGXR1EnI9YJm9KstIEfrpK/l3zUpthVFzVBxN4N39jP/sX
         /4GRqM3xR6LGHAg6js/35OxlcAeK2UsdLF1bitMaNxeSNqNPVt8w3nNt6NSipM2KjS3u
         ktxUssRWCcoSnNVM+dImZt5wRxyklMfubzaIJaNX9momWbTMPKF4Mpx1jnu5dZsBRZuw
         sF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V09boSFG66nz8jPL2ItfwtlzK7dZXPHZLQbwCkrST28=;
        b=OlFrfEjiuIYvYCfQgrq1MV0/sE+b/mIyBo//rwKfovkC2FgZsZTqWtsfM+NQaBlHjg
         8DZphTm12wXtuXdSzG+EP12CbswPm2BnzEyrFYW1t/BEb6XaMkPy0nOx3XFnnFk8U7pU
         C08mBiXWZj57Au4/oeet4gw+RKhENfwan9T3dxxCPKaOb7fuEGoyChDS62rhYdgag+vr
         H8LX+7sPM5kFgVOx5OWvj7zlW92xaM2aaaRETUW5y5OS0KUF2rn3ncaHCxWe+DVlMTDy
         vDZYeQSwWSfxPvrg0Xod7xZQfIxZMbKk6p5TXML7Iu5ANgaChM0TZ31OAkJ7AsIyDjtF
         Ncdw==
X-Gm-Message-State: AOAM531RtO0tPhWKec1wAFi375azoDfQIDs7vERuXEkO4Q8HKXeAJ0VK
        s2Ovxk8LXTEp2KrKUF9a3B73vQ==
X-Google-Smtp-Source: ABdhPJzVPprl4Ghl6UnsNll/DcE2oidNlSshbGPael1zWBN8Zwx/CkhTcVSIMyzbYsPCaB9EvCjKIA==
X-Received: by 2002:a5d:4088:: with SMTP id o8mr3761276wrp.34.1629378749495;
        Thu, 19 Aug 2021 06:12:29 -0700 (PDT)
Received: from hornet.engleder.at (dynamic-2el0lv6sxxeorz8a81-pd01.res.v6.highway.a1.net. [2001:871:23a:b9:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id d4sm3087088wrc.34.2021.08.19.06.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 06:12:29 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 2/3] net: phy: Uniform PHY driver access
Date:   Thu, 19 Aug 2021 15:11:53 +0200
Message-Id: <20210819131154.6586-3-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210819131154.6586-1-gerhard@engleder-embedded.com>
References: <20210819131154.6586-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct phy_device contains a pointer to the PHY driver and nearly
everywhere this pointer is used to access the PHY driver. Only
mdio_bus_phy_may_suspend() is still using to_phy_driver() instead of the
PHY driver pointer. Uniform PHY driver access by eliminating
to_phy_driver() use in mdio_bus_phy_may_suspend().

Only phy_bus_match() and phy_probe() are still using to_phy_driver(),
because PHY driver pointer is not available there.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/phy/phy_device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index ba5ad86ec826..9e2891d8e8dd 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -233,11 +233,9 @@ static DEFINE_MUTEX(phy_fixup_lock);
 
 static bool mdio_bus_phy_may_suspend(struct phy_device *phydev)
 {
-	struct device_driver *drv = phydev->mdio.dev.driver;
-	struct phy_driver *phydrv = to_phy_driver(drv);
 	struct net_device *netdev = phydev->attached_dev;
 
-	if (!drv || !phydrv->suspend)
+	if (!phydev->drv->suspend)
 		return false;
 
 	/* PHY not attached? May suspend if the PHY has not already been
-- 
2.20.1

