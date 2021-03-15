Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D9233BF7A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhCOPLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232168AbhCOPLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:11:44 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9B2C06174A;
        Mon, 15 Mar 2021 08:11:43 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id o14so5075333wrm.11;
        Mon, 15 Mar 2021 08:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O1N2OqCNFgom+EiBnr7giOeLHhpu49U0nM2JO0bzK6Y=;
        b=PNVpVLv8w7xRnHc8vR8nTBZmEQD7w62/nBIY2M2TXfaQaHtfBUeqLIGCCGQhHxE3R7
         dHSpV7Uo+5dZNatmaTmOCAhP2EPWEaYpokGQY5vDGZ5XDNl1GlRiLag0idOrMhZpNuRt
         K2/yJ+4LluSiR/LBhee3auqHdiZO6oV+0rZkjCpcVVP4Czp/q0UC9c1Bu6C0mRpcHDrs
         9QpfHe/XfHFqSBOZDxKqnDf2wSJqgIM0N6nEwfpyYc84CA7b2mpCCU+azoLZHe4l9JA/
         UU7u0EggUg36o3NuB2U1cTqe4Mu4klKrCEW5CbupXUNKJoHseLJn9swx/AaSs9fl00HE
         ujXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O1N2OqCNFgom+EiBnr7giOeLHhpu49U0nM2JO0bzK6Y=;
        b=lSQJ195mWziMvDJJrGaSqWNEGwv+W7JxAzG770dCTDO2TJEGm7H2G40RLnHbATjd/k
         oihvyKkgP34M3bJ+ShpltFiP6CGZgIIVNwNvsbswg9OcHxmkgJQrGtw/N5HQ7fYXpSDS
         1fW+euYGJRn9htUDjj10ox5jkpioKJEr2gOBkBefCT10C8gO50py0DbaobzdYS0ZNeSB
         abKvJG8tcKJJWzVOvZF7cRDlizmbocgh9Q93HWSMN3HRJA3F37cfCVDQkELD+/vL2t5i
         pcFxn06mwDbHs9+a1+9aRMMkS0b6N90vFvutDNd9ShLFhCQt1MIIQPWQD7/VwVWic68z
         6N+g==
X-Gm-Message-State: AOAM531jEDH/emwLaS36jmpDsupCNqFWH5l5FvGCIzkMSZH7uo5ShNdh
        /zI71uD9PeHh7JCPvG/p6ao=
X-Google-Smtp-Source: ABdhPJx0d3wLt4w25ijZW9A6tFi435cnmHcws5+AVIQgxbeRWHzOWvTOwK2MFqTSMrWhDKzneBmblw==
X-Received: by 2002:a5d:4312:: with SMTP id h18mr130179wrq.193.1615821102602;
        Mon, 15 Mar 2021 08:11:42 -0700 (PDT)
Received: from skynet.lan ([80.31.204.166])
        by smtp.gmail.com with ESMTPSA id f22sm12536675wmc.33.2021.03.15.08.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 08:11:42 -0700 (PDT)
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
Subject: [PATCH v2 net-next] net: dsa: b53: mmap: Add device tree support
Date:   Mon, 15 Mar 2021 16:11:40 +0100
Message-Id: <20210315151140.12636-1-noltari@gmail.com>
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
 v2: add change suggested by Florian Fainelli (less "OF-centric") and replace
  brcm,ports property with a ports child scan.

 drivers/net/dsa/b53/b53_mmap.c | 54 ++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index c628d0980c0b..94a4e3929ebf 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -16,6 +16,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/bits.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/io.h>
@@ -228,11 +229,64 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write64 = b53_mmap_write64,
 };
 
+static int b53_mmap_probe_of(struct platform_device *pdev,
+			     struct b53_platform_data **ppdata)
+{
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
+	struct device_node *of_ports, *of_port;
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

