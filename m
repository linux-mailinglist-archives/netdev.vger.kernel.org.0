Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028BD4BE505
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380911AbiBUQj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380788AbiBUQjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:10 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE2022BE8;
        Mon, 21 Feb 2022 08:38:37 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id F103FC2458;
        Mon, 21 Feb 2022 16:29:16 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 8A417FF815;
        Mon, 21 Feb 2022 16:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w8VXJLW2FAIIFmTtYZLQHDFFw7si1/w4sSkhBjrOQnI=;
        b=pEzyFYzNzHAqzU266UJ1CEeViLXPnqIXs7PsoQwbDM3DfG20pTF/W/4ida1KoDfZEkd7/U
        ZhQBjh8pOzwuy+oIGXzUT632IAZLLf1uy13+beH/oW53pSzIjYq3xayNS0I7aJpabVcqWu
        YBaJxLKsChgwMMlYpwbyYephOlCn51B00BSX7E7t8JIcUTEEKGiV7V4l6ReAiruQ7mqdvb
        EOL/id9lbhV31J57324G09Bug277sdAPHBYX9Wrq4WrPB1lN7kZH4ZCcnMYcwOMsrherii
        tx6iGY0V8d+sJ2t6EajUmurjr2T7ieZ4EWja7cqe06jSUz1XL+Ak049/gIAQSw==
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
Subject: [RFC 05/10] property: add fwnode_property_read_string_index()
Date:   Mon, 21 Feb 2022 17:26:47 +0100
Message-Id: <20220221162652.103834-6-clement.leger@bootlin.com>
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

Add fwnode_property_read_string_index() function which allows to
retrieve a string from an array by its index. This function is the
equivalent of of_property_read_string_index() but for fwnode support.

Signed-off-by: Clément Léger <clement.leger@bootlin.com>
---
 drivers/base/property.c  | 48 ++++++++++++++++++++++++++++++++++++++++
 include/linux/property.h |  3 +++
 2 files changed, 51 insertions(+)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index cd1c30999fd9..00d9f171329c 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -487,6 +487,54 @@ int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 }
 EXPORT_SYMBOL_GPL(fwnode_property_match_string);
 
+struct read_index_data {
+	const char **string;
+	int index;
+};
+
+static int read_string_index(const char **values, int nval, void *data)
+{
+	struct read_index_data *cb_data = data;
+
+	if (cb_data->index >= nval)
+		return -EINVAL;
+
+	*cb_data->string = values[cb_data->index];
+
+	return 0;
+}
+
+/**
+ * fwnode_property_read_string_index - read a string in an array using an index
+ * and return a pointer to the string
+ * @fwnode: Firmware node to get the property of
+ * @propname: Name of the property holding the array
+ * @index: Index of the string to look for
+ * @string: Pointer to the string if found
+ *
+ * Find a string by a given index in a string array and if it is found return
+ * the string value in @string.
+ *
+ * Return: %0 if the property was found (success),
+ *	   %-EINVAL if given arguments are not valid,
+ *	   %-ENODATA if the property does not have a value,
+ *	   %-EPROTO if the property is not an array of strings,
+ *	   %-ENXIO if no suitable firmware interface is present.
+ */
+int fwnode_property_read_string_index(const struct fwnode_handle *fwnode,
+				      const char *propname, int index,
+				      const char **string)
+{
+	struct read_index_data cb_data;
+
+	cb_data.index = index;
+	cb_data.string = string;
+
+	return fwnode_property_string_match(fwnode, propname, read_string_index,
+					    &cb_data);
+}
+EXPORT_SYMBOL_GPL(fwnode_property_read_string_index);
+
 /**
  * fwnode_property_get_reference_args() - Find a reference with arguments
  * @fwnode:	Firmware node where to look for the reference
diff --git a/include/linux/property.h b/include/linux/property.h
index 7f727c492602..f6ede3840c40 100644
--- a/include/linux/property.h
+++ b/include/linux/property.h
@@ -70,6 +70,9 @@ int fwnode_property_read_string_array(const struct fwnode_handle *fwnode,
 				      size_t nval);
 int fwnode_property_read_string(const struct fwnode_handle *fwnode,
 				const char *propname, const char **val);
+int fwnode_property_read_string_index(const struct fwnode_handle *fwnode,
+				      const char *propname, int index,
+				      const char **string);
 int fwnode_property_match_string(const struct fwnode_handle *fwnode,
 				 const char *propname, const char *string);
 int fwnode_property_get_reference_args(const struct fwnode_handle *fwnode,
-- 
2.34.1

