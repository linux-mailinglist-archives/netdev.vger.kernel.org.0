Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 765664BDC4F
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380833AbiBUQjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380781AbiBUQjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:09 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2960F22BD5;
        Mon, 21 Feb 2022 08:38:37 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::229])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 1847DD243E;
        Mon, 21 Feb 2022 16:29:15 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 971DFFF806;
        Mon, 21 Feb 2022 16:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460952;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/e2iZsxFY+H/44yYHExPJa6lTflMw/3gK08JNl6XbE4=;
        b=UC/wIbPYMT+4T+ynra4OxvY0MmvzqiCwd3KVJH2dNZOt70UaJPYg4rXhW5sS7ZS+igOLqo
        AAYoS2n2nrvsrKOkgtQ7rNYXNGTFZvGn2vhAmYOTvOJbcLrfAOHlpvF1r9K/dVjpoq7xOo
        kTg0aAkhBB9HC0WQJ7OzO6UX/1oyLcRm95lkS55mSvtYLm18InaFuJMXYXI5KiE4mJduF+
        DyIM3U1dzmYffdx8lIq2O80rPpludWnkuSJwj+bD+OoX/NiaQMlGbBlUmunVhVHPiptUBt
        TMQw32HqV6hQPwGti7YjKkdHeghrtl+jDYv3bK719dSHBtv2PGVZRHcQiGuF+Q==
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
Subject: [RFC 02/10] property: add fwnode_get_match_data()
Date:   Mon, 21 Feb 2022 17:26:44 +0100
Message-Id: <20220221162652.103834-3-clement.leger@bootlin.com>
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

Add fwnode_get_match_data() which is meant to be used as
device_get_match_data for fwnode_operations.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/base/property.c  | 12 ++++++++++++
 include/linux/property.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 434c2713fd99..6ffb3ac4509c 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1181,6 +1181,18 @@ const struct of_device_id *fwnode_match_node(const struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL(fwnode_match_node);
 
+const void *fwnode_get_match_data(const struct fwnode_handle *fwnode,
+				  const struct device *dev)
+{
+	const struct of_device_id *match;
+
+	match = fwnode_match_node(fwnode, dev->driver->of_match_table);
+	if (!match)
+		return NULL;
+
+	return match->data;
+}
+
 const void *device_get_match_data(struct device *dev)
 {
 	return fwnode_call_ptr_op(dev_fwnode(dev), device_get_match_data, dev);
diff --git a/include/linux/property.h b/include/linux/property.h
index 978ecf6be34e..7f727c492602 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -449,6 +449,9 @@ static inline void *device_connection_find_match(struct device *dev,
 const struct of_device_id *fwnode_match_node(const struct fwnode_handle *fwnode,
 					     const struct of_device_id *matches);
 
+const void *fwnode_get_match_data(const struct fwnode_handle *fwnode,
+				  const struct device *dev);
+
 /* -------------------------------------------------------------------------- */
 /* Software fwnode support - when HW description is incomplete or missing */
 
-- 
2.34.1

