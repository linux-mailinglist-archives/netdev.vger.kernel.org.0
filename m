Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7056BEB50
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjCQOc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCQOc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:32:26 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BC3CE41D2;
        Fri, 17 Mar 2023 07:32:24 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso8221411pjc.1;
        Fri, 17 Mar 2023 07:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679063543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ql/zdBJDeLRDSUxw95W4+2gggxiw7x88sF41ZLZTxPI=;
        b=G8BnuzI/q5jammsw96GfnpG3RkYrmk6f/1z0PS65xiN1YntZb9NOPEkVvjZm1SA70d
         RDJC74X536uHF0T6DT0RKqhgboa9weP0+mJHS057RN9EbUmDDSThYBHybXh5LSYEJKDp
         TwDNGKswUaUT//Z5rSJAk54oCstTt3zWGImIhmgenR/vJ7b+sVYkVUZ/b3fsWJn9hGhy
         GSKXsoZjSXDWHmucgxyR3csfMRw7czVeIJcUcTKO4f8/Axyc0Z/imA48SPnpSf36obvX
         ppPvDSfiRtdFLZCWYYAYHDF3p3uk+9ICs8B28nfWp+iB5CDkoAcDUpF4G4m7RkYoN8DB
         SdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679063543;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ql/zdBJDeLRDSUxw95W4+2gggxiw7x88sF41ZLZTxPI=;
        b=U3qlfpEana8mlUXOn1FGpZE9BCmZrtTO9TTiXQLDsyah/Mg16eZ827cGh9fqpy3zM5
         cx5Y7lK4V8talvROuk3JY1YlZepeSlOCMMUqxGQotdT4b8AwGmwpdsXp4Hx1fu58TlmK
         e+uJjQ9FpDT+Ci6AirfSlSOoKdebIKZOgOB6f8jqz+18zA30wjcX7Oi0NfrC7voEyFpH
         1ucD9Hy3F2SMiLXqLAfqpxUstmXEKz+951nhZZxqeJoiXn2TeEhJVRZSgxmylijHQsuc
         P8QzyZ5+nuFhSczNA8AUEbeuCL4Ng97Tb/Ipl+sG8iD673AhFkj5JbaErBdqSHaAvfFj
         zvbg==
X-Gm-Message-State: AO0yUKWK7hzRcLBVxK6AWcDOP98z6fWxehJPX4LknJhXy8VV1gMF2ba3
        clu4htXQL4W+lNTld4Tckw4=
X-Google-Smtp-Source: AK7set/8e3cOF1HaxryykGcAhFutzH0UBVPGQDROm4uuL2ydUzUHiO8YQBcfNSpVp9UP0DQTuGWYrg==
X-Received: by 2002:a17:902:e74c:b0:199:4be8:be48 with SMTP id p12-20020a170902e74c00b001994be8be48mr3432942plf.19.1679063543567;
        Fri, 17 Mar 2023 07:32:23 -0700 (PDT)
Received: from d.home.yangfl.dn42 ([104.28.213.203])
        by smtp.gmail.com with ESMTPSA id jj5-20020a170903048500b0019edcc30d9bsm1643554plb.155.2023.03.17.07.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 07:32:20 -0700 (PDT)
From:   David Yang <mmyangfl@gmail.com>
Cc:     David Yang <mmyangfl@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] net: phy: hisi-festa: Add support for HiSilicon Festa PHYs
Date:   Fri, 17 Mar 2023 22:30:42 +0800
Message-Id: <20230317143042.291260-1-mmyangfl@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HiSilicon Festa PHYs were used on some HiSilicon SoCs. This patch injects
firmwares found on vendor kernels.

Signed-off-by: David Yang <mmyangfl@gmail.com>
---
 drivers/net/phy/Kconfig      |   5 ++
 drivers/net/phy/Makefile     |   1 +
 drivers/net/phy/hisi-festa.c | 169 +++++++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+)
 create mode 100644 drivers/net/phy/hisi-festa.c

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 54874555c..e7551e9b3 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -177,6 +177,11 @@ config DAVICOM_PHY
 	help
 	  Currently supports dm9161e and dm9131
 
+config HISI_FESTA_PHY
+	tristate "HiSilicon Festa PHYs"
+	help
+	  Supports the HiSilicon Festa PHYs.
+
 config ICPLUS_PHY
 	tristate "ICPlus PHYs"
 	help
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index b5138066b..2c5aded6b 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_DP83869_PHY)	+= dp83869.o
 obj-$(CONFIG_DP83TC811_PHY)	+= dp83tc811.o
 obj-$(CONFIG_DP83TD510_PHY)	+= dp83td510.o
 obj-$(CONFIG_FIXED_PHY)		+= fixed_phy.o
+obj-$(CONFIG_HISI_FESTA_PHY)	+= hisi-festa.o
 obj-$(CONFIG_ICPLUS_PHY)	+= icplus.o
 obj-$(CONFIG_INTEL_XWAY_PHY)	+= intel-xway.o
 obj-$(CONFIG_LSI_ET1011C_PHY)	+= et1011c.o
diff --git a/drivers/net/phy/hisi-festa.c b/drivers/net/phy/hisi-festa.c
new file mode 100644
index 000000000..ab54ed3ca
--- /dev/null
+++ b/drivers/net/phy/hisi-festa.c
@@ -0,0 +1,169 @@
+// SPDX-License-Identifier: GPL-2.0-or-later OR MIT
+/*
+ * Driver for HiSilicon Festa PHYs
+ *
+ * This module does nothing than firmware injection. If you don't use firmware,
+ * simply blacklist this module.
+ *
+ * Copyright (c) 2023 David Yang
+ */
+#include <linux/errno.h>
+#include <linux/firmware.h>
+#include <linux/init.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/phy.h>
+
+#define PHY_ID_HISILICON_FESTAV200	0x20669813
+#define PHY_ID_HISILICON_FESTAV220	0x20669823
+#define PHY_ID_HISILICON_FESTAV300	0x20669833
+#define PHY_ID_HISILICON_FESTAV320	0x20669843
+#define PHY_ID_HISILICON_FESTAV330	0x20669853
+#define PHY_ID_HISILICON_FESTAV331	0x20669863
+
+#define MII_EXPMD	0x1d	/* Expanded memory data */
+#define MII_EXPMA	0x1e	/* Expanded memory address */
+
+/* bus->mdio_lock should be locked when using this function */
+static inline int hisi_festa_read_expanded(struct phy_device *phydev, u16 addr)
+{
+	__phy_write(phydev, MII_EXPMA, addr);
+	return __phy_read(phydev, MII_EXPMD);
+}
+
+/* bus->mdio_lock should be locked when using this function */
+static inline int hisi_festa_write_expanded(struct phy_device *phydev, u16 addr, u8 val)
+{
+	__phy_write(phydev, MII_EXPMA, addr);
+	__phy_write(phydev, MII_EXPMD, val);
+	return 0;
+}
+
+/* bus->mdio_lock should be locked when using this function */
+static inline int hisi_festa_write_expanded_mem(struct phy_device *phydev, u16 addr,
+						const u8 *data, int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		hisi_festa_write_expanded(phydev, addr + i, data[i]);
+	return 0;
+}
+
+static int hisi_festa_write_fw(struct phy_device *phydev, const struct firmware *fw)
+{
+	static const u8 prologue[] = {0xbd, 0x34, 0x00, 0x39};
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+
+	ret = __phy_set_bits(phydev, MII_BMCR, BMCR_PDOWN);
+	if (ret) {
+		phydev_err(phydev, "cannot suspend device\n");
+		goto out;
+	}
+
+	hisi_festa_write_expanded_mem(phydev, 0x33f9, prologue, sizeof(prologue));
+	/* mask jump instruction */
+	hisi_festa_write_expanded(phydev, 0x3400, 0x39);
+	hisi_festa_write_expanded_mem(phydev, 0x3401, fw->data + 1, fw->size - 1);
+	/* now release firmware */
+	hisi_festa_write_expanded(phydev, 0x3400, fw->data[0]);
+	hisi_festa_write_expanded(phydev, 0x33f8, 0x01);
+
+	ret = __phy_clear_bits(phydev, MII_BMCR, BMCR_PDOWN);
+
+out:
+	phy_unlock_mdio_bus(phydev);
+	return ret;
+}
+
+static int hisi_festa_patch_fw(struct phy_device *phydev)
+{
+	int ret;
+	char fw_name[64];
+	const struct firmware *fw;
+
+	snprintf(fw_name, sizeof(fw_name), "hisilicon/festa.%08x.ucode", phydev->phy_id);
+
+	ret = request_firmware(&fw, fw_name, &phydev->mdio.dev);
+	if (ret) {
+		/* err message already printed by request_firmware */
+		return -EAGAIN;
+	}
+
+	if (fw->data[0] != 0x01 || fw->data[1] != 0xcc) {
+		phydev_err(phydev, "%s does not look like valid firmware; refused to load\n",
+			   fw_name);
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = hisi_festa_write_fw(phydev, fw);
+	if (ret) {
+		phydev_err(phydev, "download firmware %s failed\n", fw_name);
+		goto out;
+	}
+
+	phydev_info(phydev, "using firmware %s\n", fw_name);
+
+out:
+	release_firmware(fw);
+	return ret;
+}
+
+static int hisi_festa_config_init(struct phy_device *phydev)
+{
+	hisi_festa_patch_fw(phydev);
+	/* ok, use programmed firmware */
+	return 0;
+}
+
+static struct phy_driver hisi_festa_driver[] = {
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV200),
+		.name        = "HiSilicon Festa v200/v210",
+		.config_init = hisi_festa_config_init,
+	},
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV220),
+		.name        = "HiSilicon Festa v220",
+		.config_init = hisi_festa_config_init,
+	},
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV300),
+		.name        = "HiSilicon Festa v300",
+		.config_init = hisi_festa_config_init,
+	},
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV320),
+		.name        = "HiSilicon Festa v320",
+		.config_init = hisi_festa_config_init,
+	},
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV330),
+		.name        = "HiSilicon Festa v330",
+		.config_init = hisi_festa_config_init,
+	},
+	{
+		PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV331),
+		.name        = "HiSilicon Festa v331",
+		.config_init = hisi_festa_config_init,
+	},
+};
+
+module_phy_driver(hisi_festa_driver);
+
+static struct mdio_device_id __maybe_unused hisi_festa_tbl[] = {
+	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV200) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV220) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV300) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV320) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV330) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_HISILICON_FESTAV331) },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, hisi_festa_tbl);
+MODULE_DESCRIPTION("HiSilicon Festa PHY driver");
+MODULE_LICENSE("Dual MIT/GPL");
-- 
2.39.2

