Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD42E4BE7E8
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380867AbiBUQjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380799AbiBUQjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:10 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0080C23BFD;
        Mon, 21 Feb 2022 08:38:39 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::229])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 66D90D256D;
        Mon, 21 Feb 2022 16:30:00 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8CE4EFF812;
        Mon, 21 Feb 2022 16:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=URJAXhlDauk/l4yfi8v6pFwWxIgQSIBOv7Iyc/z2WsI=;
        b=iLM0m5Zhw8xCMe5DS5xURtrpDXGzRBjyN+Hhy7M5/KVA/Mx7uv6KQuU6hNdVlevMepJ1YQ
        jv834IIM0c45I/AYxhIT0e5Ow8+4B0Gn0evf0wQ8bIyCCVrJMvykTkePjo97Qx7bgcX7Cp
        qHobEt4AwL6j4eiyDYAOUnBIzZ+bTr/ba6rTAzde/58k14ewYeafcNrgEsNQ4l3kEdlwGX
        tSkUhWqE3cubuZgVXJxWAyU11EUM63qOfWXu+7nYOlyAVJW9IsrkC4k52uoVgZ7+wFe7+F
        G6Qwjq6uOfA4ZvVStOOjBmK8VHYM+36VT9X11UpwcxepSVTiAJb8Dr9Qr/LRWg==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC 07/10] i2c: of: use fwnode_get_i2c_adapter_by_node()
Date:   Mon, 21 Feb 2022 17:26:49 +0100
Message-Id: <20220221162652.103834-8-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220221162652.103834-1-clement.leger@bootlin.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the new fwnode function does the same check that was done by
of_get_i2c_adapter_by_node(), call this one to avoid code duplication.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/i2c/i2c-core-of.c | 30 ------------------------------
 include/linux/i2c.h       |  5 ++++-
 2 files changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/i2c/i2c-core-of.c b/drivers/i2c/i2c-core-of.c
index 3ed74aa4b44b..be7d66aa0f49 100644
--- a/drivers/i2c/i2c-core-of.c
+++ b/drivers/i2c/i2c-core-of.c
@@ -113,17 +113,6 @@ void of_i2c_register_devices(struct i2c_adapter *adap)
 	of_node_put(bus);
 }
 
-static int of_dev_or_parent_node_match(struct device *dev, const void *data)
-{
-	if (dev->of_node == data)
-		return 1;
-
-	if (dev->parent)
-		return dev->parent->of_node == data;
-
-	return 0;
-}
-
 /* must call put_device() when done with returned i2c_client device */
 struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
 {
@@ -142,25 +131,6 @@ struct i2c_client *of_find_i2c_device_by_node(struct device_node *node)
 }
 EXPORT_SYMBOL(of_find_i2c_device_by_node);
 
-/* must call put_device() when done with returned i2c_adapter device */
-struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
-{
-	struct device *dev;
-	struct i2c_adapter *adapter;
-
-	dev = bus_find_device(&i2c_bus_type, NULL, node,
-			      of_dev_or_parent_node_match);
-	if (!dev)
-		return NULL;
-
-	adapter = i2c_verify_adapter(dev);
-	if (!adapter)
-		put_device(dev);
-
-	return adapter;
-}
-EXPORT_SYMBOL(of_find_i2c_adapter_by_node);
-
 /* must call i2c_put_adapter() when done with returned i2c_adapter device */
 struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node)
 {
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 9b480a8b0a76..d1f384b805ad 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -974,7 +974,10 @@ struct i2c_adapter *fwnode_find_i2c_adapter_by_node(struct fwnode_handle *node);
 struct i2c_client *of_find_i2c_device_by_node(struct device_node *node);
 
 /* must call put_device() when done with returned i2c_adapter device */
-struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node);
+static inline struct i2c_adapter *of_find_i2c_adapter_by_node(struct device_node *node)
+{
+	return fwnode_find_i2c_adapter_by_node(of_fwnode_handle(node));
+}
 
 /* must call i2c_put_adapter() when done with returned i2c_adapter device */
 struct i2c_adapter *of_get_i2c_adapter_by_node(struct device_node *node);
-- 
2.34.1

