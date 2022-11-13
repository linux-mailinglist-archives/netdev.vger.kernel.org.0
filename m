Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C32626DA3
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 05:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235172AbiKMEDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 23:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbiKMEC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 23:02:56 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C5813F5E;
        Sat, 12 Nov 2022 20:02:48 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m6so8247882pfb.0;
        Sat, 12 Nov 2022 20:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tJBg5PwdywZBY7zF7Ud5t+PwmAlKrob+uTB2RMTOkrI=;
        b=VbNdGk9HXpySdCR92sMgx3mLV4UJ5FwV3J3yC4U5NtfLmLflbzSrQH4P4VkNhF4yfY
         Rd8LIX0vhhNQo+yhhyCysa7ERgzA24AI4QNSemunQHAtjy8NCFGIglVN6I+PsgMX/sYP
         U3FVpWg+Jn0JGWYlEpK6Dw5cVDNfx2jPom1+VYASyxn29mxTt1dnkQzRfWtdxU7Ftoit
         Cd5jE7JMDQ805LuqpXfWk22d9ayBjLZEmM43+2dcKeGVAUjDheei0RxqVDe3ONu6vSVD
         nK1PBMfzLAXTSmVRZ8SeYIxuZK7fJnvKXIrXxSqEVSZXFhC/hj2+pi5Uma4FgsAKyLGa
         5Jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tJBg5PwdywZBY7zF7Ud5t+PwmAlKrob+uTB2RMTOkrI=;
        b=mSqSc8VRd2egroMSjf7usOoEucF0YgBoTx4hGVMYJqhXQaVhXc9V4A+g/BFiUuS0qp
         ZCFhAO93y2FI4A6O3IJrXb7IONmRKmc1aBtKL7LaiPjM9qqU69gtnXMu2IEP9jT4u0WD
         m+6IuEyY1lqCQAszLBa9+xVfF5kJrmpH8Jihgf0kc5m0sI80/HaFkPkj5/TQFKWREkln
         FSo9X07D1DUeh1W1d+9yRYSyNFhhJSn/a4eRN3OPxkzI230TxBpzxxghafBCYeFasoNe
         41OmCeUDwgRs9JeROltvrN1h7gq+fKGvyA8q+j/PdW1VdQeS9tHasAuKB1w4Oq49m+m2
         jSeQ==
X-Gm-Message-State: ANoB5plYaMtcEQ5oKvdavNM0MB2WVbHXcB8fdOyR79kUDPDxE2OR2smv
        oDOpN70iDm+o4lAucAiJJaKaiiqc0OPs8g==
X-Google-Smtp-Source: AA0mqf4QNaLAuXHsSPwOwAzQJmnBbgGW0GKeqzKAnRYwe+KW1WfYivzbY7hNbY7uNJspxZi5/KR9DQ==
X-Received: by 2002:a63:4e16:0:b0:43c:4724:1719 with SMTP id c22-20020a634e16000000b0043c47241719mr7491893pgb.251.1668312166558;
        Sat, 12 Nov 2022 20:02:46 -0800 (PST)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a5ac500b00200461cfa99sm7122686pji.11.2022.11.12.20.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 20:02:46 -0800 (PST)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v3 2/3] can: etas_es58x: export firmware, bootloader and hardware versions in sysfs
Date:   Sun, 13 Nov 2022 13:01:07 +0900
Message-Id: <20221113040108.68249-3-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.37.4
In-Reply-To: <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221113040108.68249-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ES58x devices report below information in their usb product info
string:

  * the firmware version
  * the bootloader version
  * the hardware revision

Parse this string, store the results in struct es58x_dev and create
three new sysfs entries.

Those sysfs entries are not critical to use the device, if parsing
fails, print an informative log message and continue to probe the
device.

Now that these value are available in sysfs, no more need to print
them in the kernel log so remove es58x_get_product_info().

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/usb/etas_es58x/Makefile      |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c  |  49 +---
 drivers/net/can/usb/etas_es58x/es58x_core.h  |  51 ++++
 drivers/net/can/usb/etas_es58x/es58x_sysfs.c | 231 +++++++++++++++++++
 4 files changed, 286 insertions(+), 47 deletions(-)
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_sysfs.c

diff --git a/drivers/net/can/usb/etas_es58x/Makefile b/drivers/net/can/usb/etas_es58x/Makefile
index a129b4aa0215..8f37aa3e32d3 100644
--- a/drivers/net/can/usb/etas_es58x/Makefile
+++ b/drivers/net/can/usb/etas_es58x/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_CAN_ETAS_ES58X) += etas_es58x.o
-etas_es58x-y = es58x_core.o es581_4.o es58x_fd.o
+etas_es58x-y = es58x_core.o es581_4.o es58x_fd.o es58x_sysfs.o
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 25f863b4f5f0..c5109117f8e6 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2119,48 +2119,6 @@ static void es58x_free_netdevs(struct es58x_device *es58x_dev)
 	}
 }
 
-/**
- * es58x_get_product_info() - Get the product information and print them.
- * @es58x_dev: ES58X device.
- *
- * Do a synchronous call to get the product information.
- *
- * Return: zero on success, errno when any error occurs.
- */
-static int es58x_get_product_info(struct es58x_device *es58x_dev)
-{
-	struct usb_device *udev = es58x_dev->udev;
-	const int es58x_prod_info_idx = 6;
-	/* Empirical tests show a prod_info length of maximum 83,
-	 * below should be more than enough.
-	 */
-	const size_t prod_info_len = 127;
-	char *prod_info;
-	int ret;
-
-	prod_info = kmalloc(prod_info_len, GFP_KERNEL);
-	if (!prod_info)
-		return -ENOMEM;
-
-	ret = usb_string(udev, es58x_prod_info_idx, prod_info, prod_info_len);
-	if (ret < 0) {
-		dev_err(es58x_dev->dev,
-			"%s: Could not read the product info: %pe\n",
-			__func__, ERR_PTR(ret));
-		goto out_free;
-	}
-	if (ret >= prod_info_len - 1) {
-		dev_warn(es58x_dev->dev,
-			 "%s: Buffer is too small, result might be truncated\n",
-			 __func__);
-	}
-	dev_info(es58x_dev->dev, "Product info: %s\n", prod_info);
-
- out_free:
-	kfree(prod_info);
-	return ret < 0 ? ret : 0;
-}
-
 /**
  * es58x_init_es58x_dev() - Initialize the ES58X device.
  * @intf: USB interface.
@@ -2243,10 +2201,6 @@ static int es58x_probe(struct usb_interface *intf,
 	if (IS_ERR(es58x_dev))
 		return PTR_ERR(es58x_dev);
 
-	ret = es58x_get_product_info(es58x_dev);
-	if (ret)
-		return ret;
-
 	for (ch_idx = 0; ch_idx < es58x_dev->num_can_ch; ch_idx++) {
 		ret = es58x_init_netdev(es58x_dev, ch_idx);
 		if (ret) {
@@ -2255,6 +2209,8 @@ static int es58x_probe(struct usb_interface *intf,
 		}
 	}
 
+	es58x_create_file(es58x_dev->dev);
+
 	return ret;
 }
 
@@ -2272,6 +2228,7 @@ static void es58x_disconnect(struct usb_interface *intf)
 	dev_info(&intf->dev, "Disconnecting %s %s\n",
 		 es58x_dev->udev->manufacturer, es58x_dev->udev->product);
 
+	es58x_remove_file(es58x_dev->dev);
 	es58x_free_netdevs(es58x_dev);
 	es58x_free_urbs(es58x_dev);
 	usb_set_intfdata(intf, NULL);
diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.h b/drivers/net/can/usb/etas_es58x/es58x_core.h
index 640fe0a1df63..d3756ff07da5 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.h
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.h
@@ -356,6 +356,45 @@ struct es58x_operators {
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
+ *
+ * If @major, @minor and @revision are all zero, the product string
+ * could not be parsed and the version number is invalid.
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
+ *
+ * If @letter, @major and @minor are all zero, the product string
+ * could not be parsed and the hardware revision number is invalid.
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
@@ -373,6 +412,9 @@ struct es58x_operators {
  *	queue wake/stop logic should prevent this URB from getting
  *	empty. Please refer to es58x_get_tx_urb() for more details.
  * @tx_urbs_idle_cnt: number of urbs in @tx_urbs_idle.
+ * @firmware_version: The firmware version number.
+ * @bootloader_version: The bootloader version number.
+ * @hardware_revision: The hardware revision number.
  * @ktime_req_ns: kernel timestamp when es58x_set_realtime_diff_ns()
  *	was called.
  * @realtime_diff_ns: difference in nanoseconds between the clocks of
@@ -408,6 +450,10 @@ struct es58x_device {
 	struct usb_anchor tx_urbs_idle;
 	atomic_t tx_urbs_idle_cnt;
 
+	struct es58x_sw_version firmware_version;
+	struct es58x_sw_version bootloader_version;
+	struct es58x_hw_revision hardware_revision;
+
 	u64 ktime_req_ns;
 	s64 realtime_diff_ns;
 
@@ -674,6 +720,7 @@ static inline enum es58x_flag es58x_get_flags(const struct sk_buff *skb)
 	return es58x_flags;
 }
 
+/* Prototypes from es58x_core.c. */
 int es58x_can_get_echo_skb(struct net_device *netdev, u32 packet_idx,
 			   u64 *tstamps, unsigned int pkts);
 int es58x_tx_ack_msg(struct net_device *netdev, u16 tx_free_entries,
@@ -691,6 +738,10 @@ int es58x_rx_cmd_ret_u32(struct net_device *netdev,
 int es58x_send_msg(struct es58x_device *es58x_dev, u8 cmd_type, u8 cmd_id,
 		   const void *msg, u16 cmd_len, int channel_idx);
 
+/* Prototypes from es58x_sysfs.c. */
+void es58x_create_file(struct device *dev);
+void es58x_remove_file(struct device *dev);
+
 extern const struct es58x_parameters es581_4_param;
 extern const struct es58x_operators es581_4_ops;
 
diff --git a/drivers/net/can/usb/etas_es58x/es58x_sysfs.c b/drivers/net/can/usb/etas_es58x/es58x_sysfs.c
new file mode 100644
index 000000000000..db1d57b6cda5
--- /dev/null
+++ b/drivers/net/can/usb/etas_es58x/es58x_sysfs.c
@@ -0,0 +1,231 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/* Driver for ETAS GmbH ES58X USB CAN(-FD) Bus Interfaces.
+ *
+ * File es58x_sysfs.c: parse the product information string and
+ * populate sysfs.
+ *
+ * Copyright (c) 2022 Vincent Mailhol <mailhol.vincent@wanadoo.fr>
+ */
+
+#include <linux/ctype.h>
+#include <linux/device.h>
+#include <linux/string.h>
+#include <linux/usb.h>
+
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
+ * firmware_version_show() - Emit the firmware version in sysfs.
+ * @dev: Device.
+ * @attr: Device attribute, not used.
+ * @buf: Where to write the firmware version.
+ *
+ * Return: number of bytes written.
+ */
+static ssize_t firmware_version_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct es58x_device *es58x_dev = dev_get_drvdata(dev);
+	struct es58x_sw_version *fw_ver = &es58x_dev->firmware_version;
+
+	return sysfs_emit(buf, "%02u.%02u.%02u\n",
+			  fw_ver->major, fw_ver->minor, fw_ver->revision);
+}
+static DEVICE_ATTR_RO(firmware_version);
+
+/**
+ * bootloader_version_show() - Emit the bootloader version in sysfs.
+ * @dev: Device.
+ * @attr: Device attribute, not used.
+ * @buf: Where to write the bootloader version.
+ *
+ * Return: number of bytes written.
+ */
+static ssize_t bootloader_version_show(struct device *dev,
+				       struct device_attribute *attr, char *buf)
+{
+	struct es58x_device *es58x_dev = dev_get_drvdata(dev);
+	struct es58x_sw_version *bl_ver = &es58x_dev->bootloader_version;
+
+	return sysfs_emit(buf, "%02u.%02u.%02u\n",
+			  bl_ver->major, bl_ver->minor, bl_ver->revision);
+}
+static DEVICE_ATTR_RO(bootloader_version);
+
+/**
+ * es58x_parse_hw_rev() - Extract hardware revision number
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
+ * hardware_revision_show() - Emit the hardware revision in sysfs.
+ * @dev: Device.
+ * @attr: Device attribute, not used.
+ * @buf: Where to write the hardware revision.
+ *
+ * Return: number of bytes written.
+ */
+static ssize_t hardware_revision_show(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct es58x_device *es58x_dev = dev_get_drvdata(dev);
+	struct es58x_hw_revision *hw_rev = &es58x_dev->hardware_revision;
+
+	return sysfs_emit(buf, "%c%03u/%03u\n",
+			  hw_rev->letter, hw_rev->major, hw_rev->minor);
+}
+static DEVICE_ATTR_RO(hardware_revision);
+
+/**
+ * es58x_create_file() - Expose the product information through sysfs.
+ * @dev: Device.
+ *
+ * Retrieve the product information string and parse it to extract the
+ * firmware version, the bootloader version and the hardware
+ * revision. Then create three sysfs entries.
+ *
+ * If the parsing fails, simply emit an informative log message and
+ * continue because these files are not critical for the driver to
+ * operate.
+ */
+void es58x_create_file(struct device *dev)
+{
+	struct es58x_device *es58x_dev = dev_get_drvdata(dev);
+	char *prod_info;
+
+	prod_info = usb_cache_string(es58x_dev->udev, ES58X_PROD_INFO_IDX);
+	if (!prod_info) {
+		dev_warn(dev, "could not retrieve the product info string\n");
+		return;
+	}
+
+	if (!es58x_parse_sw_version(es58x_dev, prod_info, "FW"))
+		device_create_file(dev, &dev_attr_firmware_version);
+	else
+		dev_info(dev, "parsing error: can not create firmware_version sysfs entry\n");
+
+	if (!es58x_parse_sw_version(es58x_dev, prod_info, "BL"))
+		device_create_file(dev, &dev_attr_bootloader_version);
+	else
+		dev_info(dev, "parsing error: can not create bootloader_version sysfs entry\n");
+
+	if (!es58x_parse_hw_rev(es58x_dev, prod_info))
+		device_create_file(dev, &dev_attr_hardware_revision);
+	else
+		dev_info(dev, "parsing error: can not create hardware_revision sysfs entry\n");
+
+	kfree(prod_info);
+}
+
+/**
+ * es58x_remove_file() - Remove sysfs files created by es58x_create_file().
+ * @dev: Device.
+ *
+ * device_remove_file() checks if the sysfs file exists before trying
+ * to remove it so it is safe to call it even if these files were not
+ * created by es58x_create_file() due of a parsing error.
+ */
+void es58x_remove_file(struct device *dev)
+{
+	device_remove_file(dev, &dev_attr_firmware_version);
+	device_remove_file(dev, &dev_attr_bootloader_version);
+	device_remove_file(dev, &dev_attr_hardware_revision);
+}
-- 
2.37.4

