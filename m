Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30F020B558
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgFZPxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730082AbgFZPxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:53:47 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B172C03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:47 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id q15so9274920wmj.2
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OHAzuFTcnXjRnCecFfdtoCttWR6EYSo9VB+Mynb0BCU=;
        b=MKa56Wr4oR9+OTmtV3S9SJ1MLBBE5u0EgzITpr0eYOyeblpLCSaAipT23Hb/rw5iHi
         JvyREVrUh1mArBn8SKWzt9gk/B5CsqVFdGtJ3B6JHISYoY5iiRuKEbRx8XNkjVXerqgu
         fW5XluGma4IBAnSC3CB97Vx1wJLfyGWpHpgvPnhhq6w1K0bWOZwUlfoXRAnwsq7/hQ0p
         vRz+nLEajgMbAGZ3XsjgRUKiYGU5nDZUYSS2wy2DYHfcp3vxcMSkSJ2WoF9Xun1lR27g
         aBIesvER+HSb4xUd9GNs1HDmoSH34Or8HSjDPeqBULN157iwyUlsLXeCrQqCIsa1Ufoc
         VOAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OHAzuFTcnXjRnCecFfdtoCttWR6EYSo9VB+Mynb0BCU=;
        b=gobCwCfcF83PKGu4dkqEcV0JnJ6pVQnvTuW8qTpZSSDh/MlaUGYpIUz6pyn5jxg30d
         +tih98eBTrHj9Y1KP2ULvaiD6+vAKTMcBhTjIIvshfVQ1F/7Kzu9UkO3OIh2CiF0kWHP
         Jt0mvse4IfQaHlNYqZisKy8yxi8VjRmbVv0lqd0BeHTOOmrYmt9lLpdmdrJ9qNW+cVRQ
         AGfw6Kxfjrhl3banMmf1BlYLocj1dAz1gXZ2/iFtcx/T6+z7KVlkofefHlTpUO6C9RSF
         QFus3bT0xoBIGUj9kVhJF5jBJKJhoe5EXJc8qMRMvFcnruvostujkaTvJVZznEy3frAr
         OSIw==
X-Gm-Message-State: AOAM530ZJV7xPEg8OEKgs//0no+5qhL0ojPGyzWTPXtpAOTpb3Nx6P5A
        X5K3IyrUSMzO5fpLzkSdt0HbEw==
X-Google-Smtp-Source: ABdhPJwwituQPOEL46rDs7SCGfIEASNzMaGomeXCnYCrU332v5ZNWT//XKF7nCnUdV0jddo1iNWX+w==
X-Received: by 2002:a1c:23d0:: with SMTP id j199mr3349659wmj.12.1593186826030;
        Fri, 26 Jun 2020 08:53:46 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id h142sm8242791wme.3.2020.06.26.08.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 08:53:45 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 2/6] net: phy: arrange headers in mdio_device.c alphabetically
Date:   Fri, 26 Jun 2020 17:53:21 +0200
Message-Id: <20200626155325.7021-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200626155325.7021-1-brgl@bgdev.pl>
References: <20200626155325.7021-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Keeping the headers in alphabetical order is better for readability and
allows to easily see if given header is already included.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/mdio_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index c1d345c3cab3..f60443e48622 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
@@ -20,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/unistd.h>
-#include <linux/delay.h>
 
 void mdio_device_free(struct mdio_device *mdiodev)
 {
-- 
2.26.1

