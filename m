Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B0C31A664
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhBLU7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231830AbhBLU6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 15:58:22 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5728C06178C;
        Fri, 12 Feb 2021 12:57:39 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id d13so491227plg.0;
        Fri, 12 Feb 2021 12:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dGkVhP9lrZbfNVwJrj0ni02dmAFFlEtayaUfK2Zwqrw=;
        b=XxdkgWXRS9/yLkEo2KGQz0o3WHM4xZIwpnC3ml6CCPANFlJvi+8FlMFgPLVlCzhU9B
         5ygi0XrIJkpHlCXAfsEvqClAMAz+QUAC+D9BJSsLc0y/c5VdJ28apsJppqXBMojYLoH4
         tYMMplDbJ27ZVMK8nOcA9PEgN4m/688P0h8tgrtnKBYRfZ+Uqvnjkl/kc+OjReQwDYNH
         zJNJiOOddugW0qWSuXIOq0lKnLMZ6YN8lM368eOzaJuPTAsru+kInsRwiPUipwcklTqH
         7hNKjvTZAvilPhU4yRAXh26KPGLxPBHczYz3P0ckjYcWoRM7aqL4/LJzT8+WQOSZVEGw
         lgnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dGkVhP9lrZbfNVwJrj0ni02dmAFFlEtayaUfK2Zwqrw=;
        b=S8A5hZBg+hn2Lh8hYTw57+zUcEjwkNBginYkSul3djkUX6hpE4FALHapSytwfxQwbR
         g8hxDwc3wyOoM3FdacGBJ7KYqPlIMRdfHrPUZ7fNIVJiN0c7+DyJXr7Thud7XzZVZNhg
         thOohSORB4OibvXIMrh+0Yi6/ULE4wgpY/my0e9k8eIsPUJOoPqPlnWXgaX080GDLtg9
         9WfELIRAyLBDu6wi4LDI43nXVM5Iv0QoqBi3h4KzC607A37sV3+x/OQpduXQMtFfbqHp
         cmwEPMwllbTb2MNvbcbOSQoEM9wcW6BBvKNif7QyNZbLfzLbcq0MjFgaGe0LuG7Aw7Dd
         DVPQ==
X-Gm-Message-State: AOAM5332Lv5p0jZyQ7HiKf0RFejNJAZ8P7FSG3Qg7JGqeHCsuPY52Gx9
        J4CA/wmCbSVwZYGofV7+9tsX/4ViFDg=
X-Google-Smtp-Source: ABdhPJyVnQb7pMf/S+48H5BGK7MBA4beWpA91xIgMJgZePiwrGIuvju/US7GJZ/7SlwT315lJy/Rxw==
X-Received: by 2002:a17:902:8602:b029:e2:8386:7aed with SMTP id f2-20020a1709028602b02900e283867aedmr4397311plo.36.1613163459096;
        Fri, 12 Feb 2021 12:57:39 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a141sm9891628pfa.189.2021.02.12.12.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 12:57:38 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list),
        olteanv@gmail.com, michael@walle.cc
Subject: [PATCH net-next 3/3] net: phy: broadcom: Allow BCM54210E to configure APD
Date:   Fri, 12 Feb 2021 12:57:21 -0800
Message-Id: <20210212205721.2406849-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212205721.2406849-1-f.fainelli@gmail.com>
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BCM54210E/BCM50212E has been verified to work correctly with the
auto-power down configuration done by bcm54xx_adjust_rxrefclk(), add it
to the list of PHYs working.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/broadcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index 0472b3470c59..cb790bd802ff 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -195,6 +195,7 @@ static void bcm54xx_adjust_rxrefclk(struct phy_device *phydev)
 	if (BRCM_PHY_MODEL(phydev) != PHY_ID_BCM57780 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM50610M &&
+	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54210E &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54810 &&
 	    BRCM_PHY_MODEL(phydev) != PHY_ID_BCM54811)
 		return;
-- 
2.25.1

