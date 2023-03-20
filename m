Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968386C2008
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbjCTSg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjCTSgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:36:25 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326283B3D3;
        Mon, 20 Mar 2023 11:28:31 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id o7so11333515wrg.5;
        Mon, 20 Mar 2023 11:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679336898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wBzYAsnhwBXQjuDBSUi3W2CxjTGmsinwQoaQBA9bPe4=;
        b=LZseDZkYJFkhIVIhJL2gKIkzIILl70R0rcE/fJlazuQ99VDYo5BFBKv5NPSc2tIXao
         UGnwHl/l0lwVwYLb6d1VcEXWP8qxWs1bwdZHsOTpkJszlKhBs7hbMzZ2QY31XPiL4OAk
         cmevn0aflhW53QaZqAYvE1P+1xsNZVTpuyCqDQm0DCFl2yg+fVdE9Wm+OMdP4VR9A8vv
         scKz3thGieD2guw+gjBk0i5WmhUbWjo8JWM6kS+iNEpPPHEC2n6AVCEyGtjw0YbHZ0AI
         O20spQDIvLzSE53lu/vdZX2M8+21NMw5HMqJtW9u0yYN01Ha+SftOow6MjdeY0taVGgY
         0bLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679336898;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wBzYAsnhwBXQjuDBSUi3W2CxjTGmsinwQoaQBA9bPe4=;
        b=HotnTUtBvhJscbYk5Mz5ELTKpUBo2bheLkzuSMeym4YslcbJalkwlOEfE7ucjulIiR
         YeUIl+XtQDcpwObSGK2WK9F2zs7IC7kMu1/4dVjOWn5gh/1GHeim+qtW4QuvQgmSnMSz
         Eb3wjDZ+2iXtZHblWZ0lxjr/2PQHBtx5TC77fMNoLjOiFNGWSGt3uSvfpnsBqaI+r3kx
         4PUT62kNXKt0YYwgywEEY5DTgNVME35mq3ocG3AvZ8DkLwj0/OSJoA9SsjrepdFTsGD6
         2aCkvU6/tqi8yvKBil1QWedfdma0lESvSR4k1Mt2YZ3XeOQQkFuu6nujQrRwxHBhbWzd
         UlIQ==
X-Gm-Message-State: AO0yUKWxkhfjfXCWY8HO+vyMqJGjevQdYfbFIuufZlmNmSBlpKc996yw
        Nq4Ow/V5kUginze2G2yQnPzkadDJxXv8SA==
X-Google-Smtp-Source: AK7set8i5rAV3G6eH8OIJXGRRSUyt2hMx+4UyWe+q2DIAbYn/VvBJ9t9PjbuOtJr529JxYFF8OPUrA==
X-Received: by 2002:adf:ef06:0:b0:2d8:4e4:8ce3 with SMTP id e6-20020adfef06000000b002d804e48ce3mr260775wro.4.1679336898096;
        Mon, 20 Mar 2023 11:28:18 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id e9-20020adffc49000000b002be5bdbe40csm9496592wrs.27.2023.03.20.11.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 11:28:17 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [RFC PATCH] drivers: net: dsa: b53: mmap: add phy ops
Date:   Mon, 20 Mar 2023 19:28:13 +0100
Message-Id: <20230320182813.963508-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, B53 MMAP BCM63xx devices with an external switch hang when
performing PHY read and write operations due to invalid registers access.
This adds support for PHY ops by using the internal bus from mdio-mux-bcm6368
when probed by device tree and also falls back to direct MDIO registers if not.

This is an alternative to:
- https://patchwork.kernel.org/project/netdevbpf/cover/20230317113427.302162-1-noltari@gmail.com/
- https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-2-noltari@gmail.com/
- https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-3-noltari@gmail.com/
- https://patchwork.kernel.org/project/netdevbpf/patch/20230317113427.302162-4-noltari@gmail.com/
As discussed, it was an ABI break and not the correct way of fixing the issue.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_mmap.c    | 86 +++++++++++++++++++++++++++++++
 include/linux/platform_data/b53.h |  1 +
 2 files changed, 87 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index 706df04b6cee..7deca1c557c5 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -19,14 +19,25 @@
 #include <linux/bits.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_mdio.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/b53.h>
 
 #include "b53_priv.h"
 
+#define REG_MDIOC		0xb0
+#define  REG_MDIOC_EXT_MASK	BIT(16)
+#define  REG_MDIOC_REG_SHIFT	20
+#define  REG_MDIOC_PHYID_SHIFT	25
+#define  REG_MDIOC_RD_MASK	BIT(30)
+#define  REG_MDIOC_WR_MASK	BIT(31)
+
+#define REG_MDIOD		0xb4
+
 struct b53_mmap_priv {
 	void __iomem *regs;
+	struct mii_bus *bus;
 };
 
 static int b53_mmap_read8(struct b53_device *dev, u8 page, u8 reg, u8 *val)
@@ -216,6 +227,69 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
 	return 0;
 }
 
+static inline void b53_mmap_mdio_read(struct b53_device *dev, int phy_id,
+				      int loc, u16 *val)
+{
+	uint32_t reg;
+
+	b53_mmap_write32(dev, 0, REG_MDIOC, 0);
+
+	reg = REG_MDIOC_RD_MASK |
+	      (phy_id << REG_MDIOC_PHYID_SHIFT) |
+	      (loc << REG_MDIOC_REG_SHIFT);
+
+	b53_mmap_write32(dev, 0, REG_MDIOC, reg);
+	udelay(50);
+	b53_mmap_read16(dev, 0, REG_MDIOD, val);
+}
+
+static inline int b53_mmap_mdio_write(struct b53_device *dev, int phy_id,
+				      int loc, u16 val)
+{
+	uint32_t reg;
+
+	b53_mmap_write32(dev, 0, REG_MDIOC, 0);
+
+	reg = REG_MDIOC_WR_MASK |
+	      (phy_id << REG_MDIOC_PHYID_SHIFT) |
+	      (loc << REG_MDIOC_REG_SHIFT) |
+	      val;
+
+	b53_mmap_write32(dev, 0, REG_MDIOC, reg);
+	udelay(50);
+
+	return 0;
+}
+
+static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int reg,
+			       u16 *value)
+{
+	struct b53_mmap_priv *priv = dev->priv;
+	struct mii_bus *bus = priv->bus;
+
+	if (bus)
+		*value = mdiobus_read_nested(bus, addr, reg);
+	else
+		b53_mmap_mdio_read(dev, addr, reg, value);
+
+	return 0;
+}
+
+static int b53_mmap_phy_write16(struct b53_device *dev, int addr, int reg,
+				u16 value)
+{
+	struct b53_mmap_priv *priv = dev->priv;
+	struct mii_bus *bus = priv->bus;
+	int ret;
+
+	if (bus)
+		ret = mdiobus_write_nested(bus, addr, reg, value);
+	else
+		ret = b53_mmap_mdio_write(dev, addr, reg, value);
+
+	return ret;
+}
+
 static const struct b53_io_ops b53_mmap_ops = {
 	.read8 = b53_mmap_read8,
 	.read16 = b53_mmap_read16,
@@ -227,6 +301,8 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write32 = b53_mmap_write32,
 	.write48 = b53_mmap_write48,
 	.write64 = b53_mmap_write64,
+	.phy_read16 = b53_mmap_phy_read16,
+	.phy_write16 = b53_mmap_phy_write16,
 };
 
 static int b53_mmap_probe_of(struct platform_device *pdev,
@@ -234,6 +310,7 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *of_ports, *of_port;
+	struct device_node *mdio;
 	struct device *dev = &pdev->dev;
 	struct b53_platform_data *pdata;
 	void __iomem *mem;
@@ -251,6 +328,14 @@ static int b53_mmap_probe_of(struct platform_device *pdev,
 	pdata->chip_id = (u32)device_get_match_data(dev);
 	pdata->big_endian = of_property_read_bool(np, "big-endian");
 
+	mdio = of_parse_phandle(np, "mii-bus", 0);
+	if (!mdio)
+		return -EINVAL;
+
+	pdata->bus = of_mdio_find_bus(mdio);
+	if (!pdata->bus)
+		return -EPROBE_DEFER;
+
 	of_ports = of_get_child_by_name(np, "ports");
 	if (!of_ports) {
 		dev_err(dev, "no ports child node found\n");
@@ -297,6 +382,7 @@ static int b53_mmap_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv->regs = pdata->regs;
+	priv->bus = pdata->bus;
 
 	dev = b53_switch_alloc(&pdev->dev, &b53_mmap_ops, priv);
 	if (!dev)
diff --git a/include/linux/platform_data/b53.h b/include/linux/platform_data/b53.h
index 6f6fed2b171d..be0c5bfdedad 100644
--- a/include/linux/platform_data/b53.h
+++ b/include/linux/platform_data/b53.h
@@ -32,6 +32,7 @@ struct b53_platform_data {
 	/* only used by MMAP'd driver */
 	unsigned big_endian:1;
 	void __iomem *regs;
+	struct mii_bus *bus;
 };
 
 #endif
-- 
2.30.2

