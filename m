Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4044233969
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgG3T6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:58:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbgG3T6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:58:20 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CEC0C061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:20 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id r4so23035776wrx.9
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bD+tlWKGYJmK6IErzRDU+kSXmxRUCbHyRUrK85FGou4=;
        b=JtTD/ifWxqgH9YgiEFTpjC+W1WPCgmkb2rfyOTRvDHdUs/tLyjJvafIlBfdyKJtWIv
         iu3LbnWMkPazvwPvyvpuo4qPF4JQ9Rzgb82XJttcmDNvyaH4iQUIyIIfltOL0Mq7XPzZ
         JwPloJY8nFZq3lpTryZeGoilMhOKhWy9GYZJ9karg/zjqCFxBjVMmKchua96CaCWtwUb
         g9kL2bzMPF1hCr9lGY4mZEwR9tfgdGKZsRIrCyLbJcXDaMvz9q+WCo+6mIQWQ8f7XILq
         MQ81JyMLmTZ82OK98hm4AJx9mFZAGQCc/U1BVgu+R8UOjD2p7FZuq/2Z0m/9ZrfSWq3Q
         Qreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bD+tlWKGYJmK6IErzRDU+kSXmxRUCbHyRUrK85FGou4=;
        b=DEEBA3i92osaYobYCzBFW6+D4g+pYunxdpPa3opHwGADhPnAPf07DTPtEmWaIeS5e7
         EMc4klPAqXED8qPV6uktGqdF8+V26sGvIwgrzHJJaXLs6VVw2kPeCrDifPWB7abIV7DJ
         YpFg0Je6Pu/yt1JU3CgQ70WmdOYNI3qVDTjAyFKVJGcrk1E8d3//0ws0BLgnzohEJ+R/
         DRMlpdkhKI4xZF5Erk4AR22FQOUl+WOBu0LuI9ZWCiW7HSA7uztG5nUEmiDiv1DqrW5s
         nKBZSvnWN39BktESwqf4jheTitw37HD6FUuQYcfuV45aJGPkYHkvl9WbZ7Yy31HxhzOB
         1UMg==
X-Gm-Message-State: AOAM531Q46bSVS8TXMwaaIS6UgkPCHWL0PFF7ifci/AaH0qwVj4583AS
        UAfe2aZugyGiVHDl+aUXBePO8mWTKbZ2bA==
X-Google-Smtp-Source: ABdhPJxIqFNo4ds2OvtIb44Zrvo2J/Ffbdudg5BRbH6TFxqAHgAnz3gd6fmCWZZ0AkAQ0L1Sje3iVQ==
X-Received: by 2002:a5d:4906:: with SMTP id x6mr352552wrq.142.1596139098652;
        Thu, 30 Jul 2020 12:58:18 -0700 (PDT)
Received: from xps13.lan (3e6b1cc1.rev.stofanet.dk. [62.107.28.193])
        by smtp.googlemail.com with ESMTPSA id z6sm11326993wml.41.2020.07.30.12.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 12:58:18 -0700 (PDT)
From:   Bruno Thomsen <bruno.thomsen@gmail.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Bruno Thomsen <bruno.thomsen@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: [PATCH v2 3/4 net-next] net: mdiobus: add reset-post-delay-us handling
Date:   Thu, 30 Jul 2020 21:57:48 +0200
Message-Id: <20200730195749.4922-4-bruno.thomsen@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730195749.4922-1-bruno.thomsen@gmail.com>
References: <20200730195749.4922-1-bruno.thomsen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Load new "reset-post-delay-us" value from MDIO properties,
and if configured to a greater then zero delay do a
flexible sleeping delay after MDIO bus reset deassert.
This allows devices to exit reset state before start
bus communication.

Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>
---
 drivers/net/phy/mdio_bus.c | 2 ++
 drivers/of/of_mdio.c       | 2 ++
 include/linux/phy.h        | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 5df3782b05b4..0af20faad69d 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -556,6 +556,8 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 		gpiod_set_value_cansleep(gpiod, 1);
 		fsleep(bus->reset_delay_us);
 		gpiod_set_value_cansleep(gpiod, 0);
+		if (bus->reset_post_delay_us > 0)
+			fsleep(bus->reset_post_delay_us);
 	}
 
 	if (bus->reset) {
diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index eb84507de28a..cb32d7ef4938 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -268,6 +268,8 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
 	/* Get bus level PHY reset GPIO details */
 	mdio->reset_delay_us = DEFAULT_GPIO_RESET_DELAY;
 	of_property_read_u32(np, "reset-delay-us", &mdio->reset_delay_us);
+	mdio->reset_post_delay_us = 0;
+	of_property_read_u32(np, "reset-post-delay-us", &mdio->reset_post_delay_us);
 
 	/* Register the MDIO bus */
 	rc = mdiobus_register(mdio);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 0403eb799913..3a09d2bf69ea 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -293,6 +293,8 @@ struct mii_bus {
 
 	/* GPIO reset pulse width in microseconds */
 	int reset_delay_us;
+	/* GPIO reset deassert delay in microseconds */
+	int reset_post_delay_us;
 	/* RESET GPIO descriptor pointer */
 	struct gpio_desc *reset_gpiod;
 
-- 
2.26.2

