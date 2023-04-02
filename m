Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6856D36A7
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 11:48:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbjDBJsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 05:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbjDBJsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 05:48:36 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91D01BF7A
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 02:48:34 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p34so15371629wms.3
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 02:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680428913;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SAblUE03ymYuwzjrgwBcc3OSVWPRf9YpmAHrq+Quvv4=;
        b=NE9K05P0a/C7QVRXP6JzGXQk4tA7LUXr2rzefRgCJT8s0XRxCrhw9NtCuCtElJjtl5
         UXqX/YsYNyOm0TC8VOwQ2YZxBg8Uk31/2GFk1MRJH2mwz1Rfmqq2+2QlATOt4O8K0Mtz
         fTUav9U6C54I3a1rb7tk0cJ1rW5WELuAYtNErZNVbGzHJ0PT5WQCUx34ojPzYPtGV/NS
         Sahq0ZT9hVpzLPXmzV3VjNyK3f7DaV+sq/pc/GvsYf/rgU1QdRTd6x7WUcCHQ3Cr9hk8
         HoRBCElZlhxWlMJmS9PkB3XzZoSp1k/Z6vZ/+V6uNX4i2tsigjN1P54/cqkdqTbDjEys
         HRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680428913;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SAblUE03ymYuwzjrgwBcc3OSVWPRf9YpmAHrq+Quvv4=;
        b=3X9DhW0gWCjwsY3ltknbwND1D2sDLtAvJHHvHmPMB9/H1RjTohcDUkenQ1pt5fLpXk
         s2Ay9mUH+ZuZMWeABf7ay9x26MipVfWmM76g2eqjuaYInLswDOdAyh/TGgL2Wt4x1Mnk
         519+dx/lST311Mx40kbboKywSSjbULYzWYcTb2ZMPyq8YgzM+ZrpNR5tF87HP5UhxL7c
         TF87wl/LGq4qwiWdreelDc67fERLqqqre6gs+wNhg7pysos0rA62wcYGEKMrfc7I+Y+h
         VResJli3u/L2u550SqgYTwz0V1Fo2HkX8QyJhAZXy1Kug6kpbQQpx9/1IDoQ1k1FZlqJ
         Lqkg==
X-Gm-Message-State: AAQBX9eD6ZKBrfABaA7WaiQNHnHKOdC21nNi1UVDPtkf3zOu1oZbTZl6
        cR4lDDdnH41ELPV9pRvEGPo=
X-Google-Smtp-Source: AKy350ZhtmSaSxWUzMy58Et9f+xTTsKpUSRU7191r6Jg/6o1EPeVn/SlTvHPXO1IdVvx0Rx1kcM+lA==
X-Received: by 2002:a1c:ed17:0:b0:3f0:396b:8b9c with SMTP id l23-20020a1ced17000000b003f0396b8b9cmr7881598wmh.9.1680428913290;
        Sun, 02 Apr 2023 02:48:33 -0700 (PDT)
Received: from ?IPV6:2a01:c22:7b85:6800:129:5577:2076:7bf8? (dynamic-2a01-0c22-7b85-6800-0129-5577-2076-7bf8.c22.pool.telefonica.de. [2a01:c22:7b85:6800:129:5577:2076:7bf8])
        by smtp.googlemail.com with ESMTPSA id y22-20020a7bcd96000000b003ee42696acesm8559115wmj.16.2023.04.02.02.48.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 02:48:32 -0700 (PDT)
Message-ID: <602fd4ec-3448-d45b-034a-6110a4a454d6@gmail.com>
Date:   Sun, 2 Apr 2023 11:47:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: [PATCH net-next 5/7] net: phy: smss: prepare for making edpd wait
 period configurable
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
In-Reply-To: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a member edpd_max_wait_ms to the private data structure in preparation
of making the wait period configurable by supporting the edpd phy tunable.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/smsc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 25b9cd474..0cd433f01 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -33,6 +33,8 @@
 #define SPECIAL_CTRL_STS_AMDIX_ENABLE_	0x4000
 #define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
 
+#define EDPD_MAX_WAIT_DFLT		640
+
 struct smsc_hw_stat {
 	const char *string;
 	u8 reg;
@@ -46,6 +48,7 @@ static struct smsc_hw_stat smsc_hw_stats[] = {
 struct smsc_phy_priv {
 	unsigned int edpd_enable:1;
 	unsigned int edpd_mode_set_by_user:1;
+	unsigned int edpd_max_wait_ms;
 };
 
 static int smsc_phy_ack_interrupt(struct phy_device *phydev)
@@ -213,9 +216,13 @@ int lan87xx_read_status(struct phy_device *phydev)
 	if (err)
 		return err;
 
-	if (!phydev->link && priv && priv->edpd_enable) {
+	if (!phydev->link && priv && priv->edpd_enable &&
+	    priv->edpd_max_wait_ms) {
+		unsigned int max_wait = priv->edpd_max_wait_ms * 1000;
+		int rc;
+
 		/* Disable EDPD to wake up PHY */
-		int rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
+		rc = phy_read(phydev, MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
 			return rc;
 
@@ -229,7 +236,7 @@ int lan87xx_read_status(struct phy_device *phydev)
 		 */
 		read_poll_timeout(phy_read, rc,
 				  rc & MII_LAN83C185_ENERGYON || rc < 0,
-				  10000, 640000, true, phydev,
+				  10000, max_wait, true, phydev,
 				  MII_LAN83C185_CTRL_STATUS);
 		if (rc < 0)
 			return rc;
@@ -299,6 +306,7 @@ int smsc_phy_probe(struct phy_device *phydev)
 		return -ENOMEM;
 
 	priv->edpd_enable = true;
+	priv->edpd_max_wait_ms = EDPD_MAX_WAIT_DFLT;
 
 	if (device_property_present(dev, "smsc,disable-energy-detect"))
 		priv->edpd_enable = false;
-- 
2.40.0


