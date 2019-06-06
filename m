Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D546370A1
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbfFFJrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:47:35 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39469 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728133AbfFFJrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:47:33 -0400
Received: by mail-lj1-f195.google.com with SMTP id v18so1369734ljh.6
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2Cqvkykb6IzlqW52A480gg6SUQ50ONET6S3EycqghE=;
        b=Ct2B8euOQrdzpG+cBAg47dgcUgrlI6vJX6UvUSSPeNwsKDpV+z4nSYOjKzI7W0wXTu
         r4jjtQhfwhUWEQvY5WPDdCcoU0aNZzPqjiQACNymjSE/whrVITUQW+sfJJRh67N7gAPV
         Y6aGOOnJIzpqaVpPjdK9zk+OILcF70TrXSnFDTE9d0Uy3ATZRk6SB8Wm0vsDLnuEgW9u
         Msd37JC1CJnUF4yMZWBh8aTUaup5fRhVX6rYUFH8B7T1WP2DESSOhwHMhzvxVFXo3gDL
         7pyLCCCDkdbKjJb4GMB88KOLLQZUiiIkR93f5TCKdSUkMPxl4b0iKh4nvjQxFwzkSw/n
         PuYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2Cqvkykb6IzlqW52A480gg6SUQ50ONET6S3EycqghE=;
        b=PVpX+Cz4rLG4ql/TadzWuU0OqpQYdpqadvfeE/o7/A41Blp/l+hH7GzWKmLHrHmwwI
         MqCvon6tWoGdMhXKEnkFffoLgMzjhtWED6kDBbCaMM3VLs/IGJXW3nzdPGIUS8g/gGEH
         76ncNvPdKTF5DNd2BhbaW9e8fLYPB7zxlWPQiSV0e+0rY2p5VNim7Rum3VIrUwbgY0m5
         V3tCI6ezciDwx8o8Wmv6i4csbREAFwnIdXJa/FPpm0ImGS4xGiuDz5Agsu1b1ZT9tFMC
         LmYuAYW/KQLsUpZuW0hTOKwTPuhjn/N8ugHM27VsWJuRWhjfEdpsZF6OqPkoRTdX8GX+
         nFKQ==
X-Gm-Message-State: APjAAAWWNrS9Vtx1fGXnvlSJ8378dzZvl9YQnQeQhOz7+8ILS/VgmwMB
        770dxBKa7Rx4xKfhvYirXtLBqQ==
X-Google-Smtp-Source: APXvYqzYFWFgXwM4oVScr/7MwzKqnuStv9TQA+4YHbIIppvBW9LTDZNPdBEJzK7doqcYm4prjjpeQg==
X-Received: by 2002:a2e:751c:: with SMTP id q28mr563236ljc.178.1559814451458;
        Thu, 06 Jun 2019 02:47:31 -0700 (PDT)
Received: from localhost (c-1c3670d5.07-21-73746f28.bbcust.telenor.se. [213.112.54.28])
        by smtp.gmail.com with ESMTPSA id y6sm256967ljj.20.2019.06.06.02.47.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 02:47:30 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     vivien.didelot@gmail.com, marex@denx.de, stefan@agner.ch,
        airlied@linux.ie, daniel@ffwll.ch, shawnguo@kernel.org,
        s.hauer@pengutronix.de, b.zolnierkie@samsung.com,
        a.hajda@samsung.com, mchehab@kernel.org, p.zabel@pengutronix.de,
        lee.jones@linaro.org, lgirdwood@gmail.com, broonie@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 6/8] drivers: net: phy: fix warning same module names
Date:   Thu,  6 Jun 2019 11:47:26 +0200
Message-Id: <20190606094727.23868-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with CONFIG_ASIX_PHY and CONFIG_USB_NET_AX8817X enabled as
loadable modules, we see the following warning:

warning: same module names found:
  drivers/net/phy/asix.ko
  drivers/net/usb/asix.ko

Rework so media coda matches the config fragment. Leaving
CONFIG_USB_NET_AX8817X as is since thats a well known module.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/net/phy/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 947c974bc69e..bab179b75a2a 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -52,7 +52,8 @@ ifdef CONFIG_HWMON
 aquantia-objs			+= aquantia_hwmon.o
 endif
 obj-$(CONFIG_AQUANTIA_PHY)	+= aquantia.o
-obj-$(CONFIG_ASIX_PHY)		+= asix.o
+obj-$(CONFIG_ASIX_PHY)		+= asix-phy.o
+asix-phy-objs			:= asix.o
 obj-$(CONFIG_AT803X_PHY)	+= at803x.o
 obj-$(CONFIG_BCM63XX_PHY)	+= bcm63xx.o
 obj-$(CONFIG_BCM7XXX_PHY)	+= bcm7xxx.o
-- 
2.20.1

