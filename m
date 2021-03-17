Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBF433ECE6
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 10:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCQJXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 05:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCQJX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 05:23:28 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41BAC06174A;
        Wed, 17 Mar 2021 02:23:19 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id 61so1022510wrm.12;
        Wed, 17 Mar 2021 02:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vsnRXrdfNNV8r6+zoFy3IPxAWVXVzygUhvBzm3feAYQ=;
        b=FkYPLnLJz9Hw+zcXvNhdMZzcoX185NSwE7qWJKn7y+2P+W1srRRsTnfj0eMltHjWLl
         ZVRgzwzll+g3T/KUVHMSmgkay6kkl0kuTmX8LzYdn9HmytkiFPeCtjWMj41F6EH0FhxU
         zF6VHJdfQ7HkcpuSStbjCaQZRVtLPB7tjzSc6RU4fUF6nRNidbpvlNqGZi4SrnYWBgL1
         XXGbcMaFSsbgRpjXtCQZia+VoezZzS6pKIKRSB1rShncAyfV26hSzcbvc2SCxhYxvux3
         W0CCGjHLGdrGQcYZuJEm0VGiCF+9SjayTVW+wni/IGWUnFZBXU/Y1/UDg2wrghHnWpe2
         6S7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vsnRXrdfNNV8r6+zoFy3IPxAWVXVzygUhvBzm3feAYQ=;
        b=XDEXDHMmyLfvGF4uYmtW4slctjRSVDwbBQKL8nxivURvsLHaBuveFvX+Tc7Dipkigs
         4UIVCrHBW87YIzWyz4/QqhB7n4V5Ur3S/IrYHYWO/AucEIguctyfqO1iyzMlMPWXL1pV
         9GYpRux+3jXhwV7xoUewKVdSH4bxvPoDCL5FrgNRpSczagUQp+KEQcXxOAk0n6iaaUrH
         NgXpDkcZjK/VhgAAz1l8BcbhbumkWk11347IRKmp89IVtV5C0kkRCuDh6HawX4mo/oNY
         8AUNJLlOoVIN+iohaSnCjkvmHcYT5nz+EIe/t4sW+8BmFt8m3+l4gta6KAcyPkB8aMi8
         AJBw==
X-Gm-Message-State: AOAM530XGvo3D9//6DAvKQAHQk/EJOC9ZntlIBkwPrvcCz1+djkIpziQ
        iwbr6y5yV+BVo7UXlsJsc5w=
X-Google-Smtp-Source: ABdhPJwk59Mj9lXDDZH5B2Te2QsGXs3dDelPaoKkCfD/f+JSryKckcsZF34ZaRpMIyObQ11LYPAO+A==
X-Received: by 2002:adf:d0c9:: with SMTP id z9mr3426268wrh.396.1615972998696;
        Wed, 17 Mar 2021 02:23:18 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id k4sm32764582wrd.9.2021.03.17.02.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:23:18 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     jonas.gorski@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v3 net-next] net: dsa: b53: mmap: Add device tree support
Date:   Wed, 17 Mar 2021 10:23:17 +0100
Message-Id: <20210317092317.3922-1-noltari@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add device tree support to b53_mmap.c while keeping platform devices support.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
---
 drivers/net/dsa/b53/b53_mmap.c | 55 ++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index c628d0980c0b..82680e083cc2 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -16,6 +16,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/bits.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/io.h>
@@ -228,11 +229,65 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write64 = b53_mmap_write64,
 };
 
+static int b53_mmap_probe_of(struct platform_device *pdev,
+			     struct b53_platform_data **ppdata)
+{
+	struct device_node *np = pdev->dev.of_node;
+	struct device_node *of_ports, *of_port;
+	struct device *dev = &pdev->dev;
+	struct b53_platform_data *pdata;
+	void __iomem *mem;
+
+	mem = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(mem))
+		return PTR_ERR(mem);
+
+	pdata = devm_kzalloc(dev, sizeof(struct b53_platform_data),
+			     GFP_KERNEL);
+	if (!pdata)
+		return -ENOMEM;
+
+	pdata->regs = mem;
+	pdata->chip_id = BCM63XX_DEVICE_ID;
+	pdata->big_endian = of_property_read_bool(np, "big-endian");
+
+	of_ports = of_get_child_by_name(np, "ports");
+	if (!of_ports) {
+		dev_err(dev, "no ports child node found\n");
+		return -EINVAL;
+	}
+
+	for_each_available_child_of_node(of_ports, of_port) {
+		u32 reg;
+
+		if (of_property_read_u32(of_port, "reg", &reg))
+			continue;
+
+		if (reg < B53_CPU_PORT)
+			pdata->enabled_ports |= BIT(reg);
+	}
+
+	of_node_put(of_ports);
+	*ppdata = pdata;
+
+	return 0;
+}
+
 static int b53_mmap_probe(struct platform_device *pdev)
 {
+	struct device_node *np = pdev->dev.of_node;
 	struct b53_platform_data *pdata = pdev->dev.platform_data;
 	struct b53_mmap_priv *priv;
 	struct b53_device *dev;
+	int ret;
+
+	if (!pdata && np) {
+		ret = b53_mmap_probe_of(pdev, &pdata);
+		if (ret) {
+			dev_err(&pdev->dev, "OF probe error\n");
+			return ret;
+		}
+	}
 
 	if (!pdata)
 		return -EINVAL;
-- 
2.20.1

