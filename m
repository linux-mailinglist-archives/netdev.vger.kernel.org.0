Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5E92FFC8F
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 07:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbhAVGYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 01:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbhAVGYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 01:24:16 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEF9C06174A;
        Thu, 21 Jan 2021 22:23:35 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id 22so4196950qkf.9;
        Thu, 21 Jan 2021 22:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2jiQWzGRiVyC9PGi+1tFArEXO7Y2cXcpw8AScVWzwYo=;
        b=FKU8qh/iFz6Iycz0f/HyIvt51vCXfl3f16ZEzyLR1s8Nw8Y6GAyvpbSQMT9r9cTo6r
         5PiAHEfyNPaTYOUKcZCxJQVFTVsxYRLYjYBBYlWaB+fAeaw7Om7USIWYFMqXTEBqUCpx
         2XifSTZnAkaXnAGOmg8YRKmnTaTz7szK+whh2nDXI3syh4O6pLq6nHFSCgN4e4aGugbh
         jKuujEMWlh+X9XZjpwVnnINFqGSsGYjBZWzsFgNddOsHkgOXy9FTZvFoZeIa9VD8siQ0
         fI3VU7zCX0CzTOZy/MLmCy3FwT1bLonTJhUxrHQHJNVeuFhQC1GpyxeMX1tyGi1ew38r
         02gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2jiQWzGRiVyC9PGi+1tFArEXO7Y2cXcpw8AScVWzwYo=;
        b=jP29FAXJ5rOsWiURiI3jvT1o47rMDrnMXsd0zqJJAGrjLTxPf/lG4MCy9HB6+VVJoX
         qecV7O27LwrcWtk2qhpqRtUHka/BKnEoA2/ldo/vf+dt4AGAgnvLrHjb6G/QkYpzdSnl
         fJ1Zzw84jciZgIxhcaDpT8i1lZXhVKtXXjLtUQwSrRUM9nNUVE5R4+TMoGm02Hj78tLJ
         6+9TUPyqW3N1lGDbOa3tNvOydyG9EBpHCuoB2QuLD91Kw0GCcIy8KFIKFmXOsjzzfrvk
         iFz4+frr3FAAUEArypK7G7VfSE0ODZdJqjC7SXF3+qt0kPkHuO1vD8ANXKH9z2Wok+Gv
         emZA==
X-Gm-Message-State: AOAM531LCjD+LL3ZZrEO9etMw8M/aUa9eannErvSPqpLSCfdSu95POEr
        26kaunkIce7caCldq5NkUMg=
X-Google-Smtp-Source: ABdhPJyLriqxN5+FOiRb+be/raohZeaJksFYnlyUUwAI8fgNTuQblQcdEJLkqwi0wlzi79KK+fVKSg==
X-Received: by 2002:a37:7a46:: with SMTP id v67mr3497770qkc.16.1611296614825;
        Thu, 21 Jan 2021 22:23:34 -0800 (PST)
Received: from localhost.localdomain ([45.32.7.59])
        by smtp.gmail.com with ESMTPSA id e5sm5178886qtp.86.2021.01.21.22.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 22:23:34 -0800 (PST)
From:   Su Yanjun <suyanjun218@gmail.com>
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        thomas.kopp@microchip.com, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org, lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Su Yanjun <suyanjun218@gmail.com>
Subject: [PATCH v1] can: mcp251xfd: Add some sysfs debug interfaces for registers r/w
Date:   Fri, 22 Jan 2021 14:22:55 +0800
Message-Id: <20210122062255.202620-1-suyanjun218@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When i debug mcp2518fd, some method to track registers is
needed. This easy debug interface will be ok.

For example,
read a register at 0xe00:
echo 0xe00 > can_get_reg
cat can_get_reg

write a register at 0xe00:
echo 0xe00,0x60 > can_set_reg

Signed-off-by: Su Yanjun <suyanjun218@gmail.com>
---
 .../net/can/spi/mcp251xfd/mcp251xfd-core.c    | 132 ++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index ab8aad0a7594..d65abe5505d5 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -27,6 +27,131 @@
 
 #define DEVICE_NAME "mcp251xfd"
 
+/* Add sysfs debug interface for easy to debug
+ *
+ * For example,
+ *
+ * - read a register
+ * echo 0xe00 > can_get_reg
+ * cat can_get_reg
+ *
+ * - write a register
+ * echo 0xe00,0x1 > can_set_reg
+ *
+ */
+static int reg_offset;
+
+static int __get_param(const char *buf, char *off, char *val)
+{
+	int len;
+
+	if (!buf || !off || !val)
+		return -EINVAL;
+
+	len = 0;
+	while (*buf != ',') {
+		*off++ = *buf++;
+		len++;
+
+		if (len >= 16)
+			return -EINVAL;
+	}
+
+	buf++;
+
+	*off = '\0';
+
+	len = 0;
+	while (*buf) {
+		*val++ = *buf++;
+		len++;
+
+		if (len >= 16)
+			return -EINVAL;
+	}
+
+	*val = '\0';
+
+	return 0;
+}
+
+static ssize_t can_get_reg_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int err;
+	u32 val;
+	struct mcp251xfd_priv *priv;
+
+	priv = dev_get_drvdata(dev);
+
+	err = regmap_read(priv->map_reg, reg_offset, &val);
+	if (err)
+		return 0;
+
+	return sprintf(buf, "reg = 0x%08x, val = 0x%08x\n", reg_offset, val);
+}
+
+static ssize_t can_get_reg_store(struct device *dev,
+				 struct device_attribute *attr, const char *buf, size_t len)
+{
+	u32 off;
+
+	reg_offset = 0;
+
+	if (kstrtouint(buf, 0, &off) || (off % 4))
+		return -EINVAL;
+
+	reg_offset = off;
+
+	return len;
+}
+
+static ssize_t can_set_reg_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return 0;
+}
+
+static ssize_t can_set_reg_store(struct device *dev,
+				 struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct mcp251xfd_priv *priv;
+	u32 off, val;
+	int err;
+
+	char s1[16];
+	char s2[16];
+
+	if (__get_param(buf, s1, s2))
+		return -EINVAL;
+
+	if (kstrtouint(s1, 0, &off) || (off % 4))
+		return -EINVAL;
+
+	if (kstrtouint(s2, 0, &val))
+		return -EINVAL;
+
+	err = regmap_write(priv->map_reg, off, val);
+	if (err)
+		return -EINVAL;
+
+	return len;
+}
+
+static DEVICE_ATTR_RW(can_get_reg);
+static DEVICE_ATTR_RW(can_set_reg);
+
+static struct attribute *can_attributes[] = {
+	&dev_attr_can_get_reg.attr,
+	&dev_attr_can_set_reg.attr,
+	NULL
+};
+
+static const struct attribute_group can_group = {
+	.attrs = can_attributes,
+	NULL
+};
+
 static const struct mcp251xfd_devtype_data mcp251xfd_devtype_data_mcp2517fd = {
 	.quirks = MCP251XFD_QUIRK_MAB_NO_WARN | MCP251XFD_QUIRK_CRC_REG |
 		MCP251XFD_QUIRK_CRC_RX | MCP251XFD_QUIRK_CRC_TX |
@@ -2944,6 +3069,12 @@ static int mcp251xfd_probe(struct spi_device *spi)
 	if (err)
 		goto out_free_candev;
 
+	err = sysfs_create_group(&spi->dev.kobj, &can_group);
+	if (err) {
+		netdev_err(priv->ndev, "Create can group fail.\n");
+		goto out_free_candev;
+	}
+
 	err = can_rx_offload_add_manual(ndev, &priv->offload,
 					MCP251XFD_NAPI_WEIGHT);
 	if (err)
@@ -2972,6 +3103,7 @@ static int mcp251xfd_remove(struct spi_device *spi)
 	mcp251xfd_unregister(priv);
 	spi->max_speed_hz = priv->spi_max_speed_hz_orig;
 	free_candev(ndev);
+	sysfs_remove_group(&spi->dev.kobj, &can_group);
 
 	return 0;
 }
-- 
2.25.1

