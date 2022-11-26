Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E1763971F
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 17:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiKZQWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 11:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKZQWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 11:22:43 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCD326A;
        Sat, 26 Nov 2022 08:22:42 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 9so6637602pfx.11;
        Sat, 26 Nov 2022 08:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xN3ydGNmt/NIkyDnxS01qJwZNhn0e4E8fz0G/KiL0Cs=;
        b=mMFp9jNqoQmZDOo5IFAg0tIYHe/kgkCWuwfLlikHbCI7u+xPrH3Y8ZwQrsuYgJC7D8
         0aNVwrTKqV/ZT1k5ebhirDDgAePTk6t4BaGGGoHbHeUmli58hf3jhB64AbSs9IYLsLXq
         BAAlmTZ8fGPPmHBqIOPxb7WGvtfITVb7UhkOBRVMX6CKLIIJxHz8wNQmMYF+rHGol/qs
         fZ+W+GuoO8hAD/04WErVZ37dlMYmIre/0TMkr7ULtWBDh7wd/lyfKxiKqvIoxy/VSdR6
         JV4Ctvs9MfazyvUQrPvzF/iToznlIFHAzTwkn//xvV6IyemqIOsXZQtmXxzCy9k4OiLK
         fxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xN3ydGNmt/NIkyDnxS01qJwZNhn0e4E8fz0G/KiL0Cs=;
        b=zhZcrL2uSvaH66CnHGingTlca7CMXw2RNyDOyXMwXePIf8ANuz2YG5lgdOCPjwlcdw
         JheichDHtIZW0EwN4GzrtUjx1au740Q9ZKaYO9bRQDuVfJoWb0OCHgLEFubqutCTcPj8
         r2/8eQzu9WYYiIk0Ujxjfa7sEbt2JU2nSxFgkpe33ubHBt1a9q3XMxa+l2Ur9jXfb/gm
         Zc9YLOmFVAjAOZISKV3ayEdSLnCuzDCYWDO53Mf8wZ2B6LQ1B5qCBRfuEWK+cHRHMB2e
         tv9Smnf+u+0bbor9qpfz/hGjBH17sBirNnr3ZDoxfxhv/2borJPQcwWAzirtndrtRB3v
         HOaA==
X-Gm-Message-State: ANoB5pnCHuNAYyIHzzeMTAqehugzsRH20sM8BEM3fx0zyxLNtVgs/U2X
        wmvWuENtOXvY2pf5WjwK4Bt/6Qhbhwecpw==
X-Google-Smtp-Source: AA0mqf4ycb3jBH52eDbJbmnV6m77cSgMHGAdmTjWqprSRStUdTi+JQIs39EeVWUNLWM/PxH88+7Zig==
X-Received: by 2002:a63:2310:0:b0:457:a1a5:3ce with SMTP id j16-20020a632310000000b00457a1a503cemr20611837pgj.416.1669479761623;
        Sat, 26 Nov 2022 08:22:41 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id y14-20020a63e24e000000b00460ea630c1bsm4169601pgj.46.2022.11.26.08.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Nov 2022 08:22:41 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     linux-can@vger.kernel.org
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 3/6] can: etas_es58x: export product information through devlink_ops::info_get()
Date:   Sun, 27 Nov 2022 01:22:08 +0900
Message-Id: <20221126162211.93322-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ES58x devices report below product information through a custom usb
string:

  * the firmware version
  * the bootloader version
  * the hardware revision

Parse this string, store the results in struct es58x_dev, export the
firmware version through devlink's "fw" name and the hardware revision
through devlink's "board.rev" name.

devlink does not yet have a name suited for the bootloader and so this
last piece of information is exposed to the userland for through a
custom name: "bl".

Those devlink entries are not critical to use the device, if parsing
fails, print an informative log message and continue to probe the
device.

In addition to that, report the device serial number which is
available in usb_device::serial.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c   |   1 +
 drivers/net/can/usb/etas_es58x/es58x_core.h   |  67 ++++++
 .../net/can/usb/etas_es58x/es58x_devlink.c    | 194 ++++++++++++++++++
 3 files changed, 262 insertions(+)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index c6e598e4800c..d29c1bf90d73 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2250,6 +2250,7 @@ static int es58x_probe(struct usb_interface *intf,
 	if (ret)
 		return ret;
 
+	es58x_parse_product_info(es58x_dev);
 	devlink_register(priv_to_devlink(es58x_dev));
 
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index bf24375580e5..9481f0764131 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -356,6 +356,39 @@ struct es58x_operators {
 	int (*get_timestamp)(struct es58x_device *es58x_dev);
 };
 
+/**
+ * struct es58x_sw_version - Version number of the firmware or the
+ *	bootloader.
+ * @major: Version major number, represented on two digits.
+ * @minor: Version minor number, represented on two digits.
+ * @revision: Version revision number, represented on two digits.
+ *
+ * The firmware and the bootloader share the same format: "xx.xx.xx"
+ * where 'x' is a digit. Both can be retrieved from the product
+ * information string.
+ */
+struct es58x_sw_version {
+	u8 major;
+	u8 minor;
+	u8 revision;
+};
+
+/**
+ * struct es58x_hw_revision - Hardware revision number.
+ * @letter: Revision letter.
+ * @major: Version major number, represented on three digits.
+ * @minor: Version minor number, represented on three digits.
+ *
+ * The hardware revision uses its own format: "axxx/xxx" where 'a' is
+ * a letter and 'x' a digit. It can be retrieved from the product
+ * information string.
+ */
+struct es58x_hw_revision {
+	char letter;
+	u16 major;
+	u16 minor;
+};
+
 /**
  * struct es58x_device - All information specific to an ES58X device.
  * @dev: Device information.
@@ -373,6 +406,9 @@ struct es58x_operators {
  *	queue wake/stop logic should prevent this URB from getting
  *	empty. Please refer to es58x_get_tx_urb() for more details.
  * @tx_urbs_idle_cnt: number of urbs in @tx_urbs_idle.
+ * @firmware_version: The firmware version number.
+ * @bootloader_version: The bootloader version number.
+ * @hardware_revision: The hardware revision number.
  * @ktime_req_ns: kernel timestamp when es58x_set_realtime_diff_ns()
  *	was called.
  * @realtime_diff_ns: difference in nanoseconds between the clocks of
@@ -408,6 +444,10 @@ struct es58x_device {
 	struct usb_anchor tx_urbs_idle;
 	atomic_t tx_urbs_idle_cnt;
 
+	struct es58x_sw_version firmware_version;
+	struct es58x_sw_version bootloader_version;
+	struct es58x_hw_revision hardware_revision;
+
 	u64 ktime_req_ns;
 	s64 realtime_diff_ns;
 
@@ -420,6 +460,32 @@ struct es58x_device {
 	union es58x_urb_cmd rx_cmd_buf;
 };
 
+/**
+ * es58x_sw_version_is_set() - Check if the version is a valid number.
+ * @sw_ver: Version number of either the firmware or the bootloader.
+ *
+ * If &es58x_sw_version.major, &es58x_sw_version.minor and
+ * &es58x_sw_version.revision are all zero, the product string could
+ * not be parsed and the version number is invalid.
+ */
+static inline bool es58x_sw_version_is_set(struct es58x_sw_version *sw_ver)
+{
+	return sw_ver->major || sw_ver->minor || sw_ver->revision;
+}
+
+/**
+ * es58x_hw_revision_is_set() - Check if the revision is a valid number.
+ * @hw_rev: Revision number of the hardware.
+ *
+ * If &es58x_hw_revision.letter, &es58x_hw_revision.major and
+ * &es58x_hw_revision.minor are all zero, the product string could not
+ * be parsed and the hardware revision number is invalid.
+ */
+static inline bool es58x_hw_revision_is_set(struct es58x_hw_revision *hw_rev)
+{
+	return hw_rev->letter || hw_rev->major || hw_rev->minor;
+}
+
 /**
  * es58x_sizeof_es58x_device() - Calculate the maximum length of
  *	struct es58x_device.
@@ -693,6 +759,7 @@ int es58x_send_msg(struct es58x_device *es58x_dev, u8 cmd_type, u8 cmd_id,
 		   const void *msg, u16 cmd_len, int channel_idx);
 
 /* es58x_devlink.c. */
+void es58x_parse_product_info(struct es58x_device *es58x_dev);
 extern const struct devlink_ops es58x_dl_ops;
 
 /* es581_4.c. */
diff --git a/drivers/net/can/usb/etas_es58x/es58x_devlink.c b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
index af6ca7ada23f..7b67682b952e 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_devlink.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_devlink.c
@@ -7,7 +7,201 @@
  * Copyright (c) 2022 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
  */
 
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/usb.h>
 #include <net/devlink.h>
 
+#include "es58x_core.h"
+
+/* USB descriptor index containing the product information string. */
+#define ES58X_PROD_INFO_IDX 6
+
+/**
+ * es58x_parse_sw_version() - Extract boot loader or firmware version.
+ * @es58x_dev: ES58X device.
+ * @prod_info: USB custom string returned by the device.
+ * @prefix: Select which information should be parsed. Set it to "FW"
+ *	to parse the firmware version or to "BL" to parse the
+ *	bootloader version.
+ *
+ * The @prod_info string contains the firmware and the bootloader
+ * version number all prefixed by a magic string and concatenated with
+ * other numbers. Depending on the device, the firmware (bootloader)
+ * format is either "FW_Vxx.xx.xx" ("BL_Vxx.xx.xx") or "FW:xx.xx.xx"
+ * ("BL:xx.xx.xx") where 'x' represents a digit. @prod_info must
+ * contains the common part of those prefixes: "FW" or "BL".
+ *
+ * Parse @prod_info and store the version number in
+ * &es58x_dev.firmware_version or &es58x_dev.bootloader_version
+ * according to @prefix value.
+ *
+ * Return: zero on success, -EINVAL if @prefix contains an invalid
+ *	value and -EBADMSG if @prod_info could not be parsed.
+ */
+static int es58x_parse_sw_version(struct es58x_device *es58x_dev,
+				  const char *prod_info, const char *prefix)
+{
+	struct es58x_sw_version *version;
+	int major, minor, revision;
+
+	if (!strcmp(prefix, "FW"))
+		version = &es58x_dev->firmware_version;
+	else if (!strcmp(prefix, "BL"))
+		version = &es58x_dev->bootloader_version;
+	else
+		return -EINVAL;
+
+	/* Go to prefix */
+	prod_info = strstr(prod_info, prefix);
+	if (!prod_info)
+		return -EBADMSG;
+	/* Go to beginning of the version number */
+	while (!isdigit(*prod_info)) {
+		prod_info++;
+		if (!*prod_info)
+			return -EBADMSG;
+	}
+
+	if (sscanf(prod_info, "%2u.%2u.%2u", &major, &minor, &revision) != 3)
+		return -EBADMSG;
+
+	version->major = major;
+	version->minor = minor;
+	version->revision = revision;
+
+	return 0;
+}
+
+/**
+ * es58x_parse_hw_rev() - Extract hardware revision number.
+ * @es58x_dev: ES58X device.
+ * @prod_info: USB custom string returned by the device.
+ *
+ * @prod_info contains the hardware revision prefixed by a magic
+ * string and conquenated together with other numbers. Depending on
+ * the device, the hardware revision format is either
+ * "HW_VER:axxx/xxx" or "HR:axxx/xxx" where 'a' represents a letter
+ * and 'x' a digit.
+ *
+ * Parse @prod_info and store the hardware revision number in
+ * &es58x_dev.hardware_revision.
+ *
+ * Return: zero on success, -EBADMSG if @prod_info could not be
+ *	parsed.
+ */
+static int es58x_parse_hw_rev(struct es58x_device *es58x_dev,
+			      const char *prod_info)
+{
+	char letter;
+	int major, minor;
+
+	/* The only occurrence of 'H' is in the hardware revision prefix. */
+	prod_info = strchr(prod_info, 'H');
+	if (!prod_info)
+		return -EBADMSG;
+	/* Go to beginning of the hardware revision */
+	prod_info = strchr(prod_info, ':');
+	if (!prod_info)
+		return -EBADMSG;
+	prod_info++;
+
+	if (sscanf(prod_info, "%c%3u/%3u", &letter, &major, &minor) != 3)
+		return -EBADMSG;
+
+	es58x_dev->hardware_revision.letter = letter;
+	es58x_dev->hardware_revision.major = major;
+	es58x_dev->hardware_revision.minor = minor;
+
+	return 0;
+}
+
+/**
+ * es58x_parse_product_info() - Parse the ES58x product information
+ *	string.
+ * @es58x_dev: ES58X device.
+ *
+ * Retrieve the product information string and parse it to extract the
+ * firmware version, the bootloader version and the hardware
+ * revision.
+ *
+ * If the function fails, simply emit a log message and continue
+ * because product information is not critical for the driver to
+ * operate.
+ */
+void es58x_parse_product_info(struct es58x_device *es58x_dev)
+{
+	char *prod_info;
+
+	prod_info = usb_cache_string(es58x_dev->udev, ES58X_PROD_INFO_IDX);
+	if (!prod_info) {
+		dev_warn(es58x_dev->dev,
+			 "could not retrieve the product info string\n");
+		return;
+	}
+
+	if (es58x_parse_sw_version(es58x_dev, prod_info, "FW") ||
+	    es58x_parse_sw_version(es58x_dev, prod_info, "BL") ||
+	    es58x_parse_hw_rev(es58x_dev, prod_info))
+		dev_info(es58x_dev->dev,
+			 "could not parse product info: '%s'\n", prod_info);
+
+	kfree(prod_info);
+}
+
+/**
+ * es58x_devlink_info_get() - Report the product information.
+ * @devlink: Devlink.
+ * @req: skb wrapper where to put requested information.
+ * @extack: Unused.
+ *
+ * Report the firmware version, the bootloader version, the hardware
+ * revision and the serial number through netlink.
+ *
+ * Return: zero on success, errno when any error occurs.
+ */
+static int es58x_devlink_info_get(struct devlink *devlink,
+				  struct devlink_info_req *req,
+				  struct netlink_ext_ack *extack)
+{
+	struct es58x_device *es58x_dev = devlink_priv(devlink);
+	struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
+	struct es58x_sw_version *bl_ver = &es58x_dev->bootloader_version;
+	struct es58x_hw_revision *hw_rev = &es58x_dev->hardware_revision;
+	char buf[max(sizeof("xx.xx.xx"), sizeof("axxx/xxx"))];
+	int ret = 0;
+
+	if (es58x_sw_version_is_set(fw_ver)) {
+		snprintf(buf, sizeof(buf), "%02u.%02u.%02u",
+			 fw_ver->major, fw_ver->minor, fw_ver->revision);
+		ret = devlink_info_version_running_put(req,
+						       DEVLINK_INFO_VERSION_GENERIC_FW,
+						       buf);
+		if (ret)
+			return ret;
+	}
+
+	if (es58x_sw_version_is_set(bl_ver)) {
+		snprintf(buf, sizeof(buf), "%02u.%02u.%02u",
+			 bl_ver->major, bl_ver->minor, bl_ver->revision);
+		ret = devlink_info_version_running_put(req, "bl", buf);
+		if (ret)
+			return ret;
+	}
+
+	if (es58x_hw_revision_is_set(hw_rev)) {
+		snprintf(buf, sizeof(buf), "%c%03u/%03u",
+			 hw_rev->letter, hw_rev->major, hw_rev->minor);
+		ret = devlink_info_version_fixed_put(req,
+						     DEVLINK_INFO_VERSION_GENERIC_BOARD_REV,
+						     buf);
+		if (ret)
+			return ret;
+	}
+
+	return devlink_info_serial_number_put(req, es58x_dev->udev->serial);
+}
+
 const struct devlink_ops es58x_dl_ops = {
+	.info_get = es58x_devlink_info_get,
 };
-- 
2.37.4

