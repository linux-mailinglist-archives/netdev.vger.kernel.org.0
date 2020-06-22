Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2233F2033CA
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbgFVJle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgFVJl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:27 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975CBC061796
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:26 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g75so6113981wme.5
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bqh6HxDlaYo+eDyI7otJcwguVt4xZOU026/4uSBRTYc=;
        b=SP7AoO6jktrfliyzCx/xTv9Acl8xJ9sY7iCwKrfwfyNggXkndAn+GiE89e2CakhX93
         EtFpneu7Irbs7xZzUb0hX6BSHQi3UozkzhV+p6SQq9kyi9aHVpBp5CBCwNTmulsZslat
         S7C/Z8dksydKPXBjvs5GBreCNnBfxtAnumAazOf9/1wvwfZCe7m8JALCSbuOLvoF5Rou
         xBK1gJiM8i95SvZeb+tQiaOslV7j4IZb68JOC/jIisPOWeaDQtMQzPIITSrjs4DzZlJ8
         MzF704Nbnte2Zw7NGj8nJyLAt5+AEeIUcZgDNWKDwvTp1MOa2y3CoFw3Vypbd5fd3vFk
         FLZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bqh6HxDlaYo+eDyI7otJcwguVt4xZOU026/4uSBRTYc=;
        b=lB7JTroSdp8x+JV1vVvHb3ZyfPLZTq3ZEEi9/mqdEV7doBn6n1jND/Ay8gE0ZZbsRf
         19aXlhGjnTd+mRtdXL2zYdEzliGjcc/LdleDkHGaqlrcHOmys0DZsISAVWOJmIxjr4Jj
         uvY+8uEjcdFHMYsA7yZgzLcxJsb7MtFXZQU8noZKizX7xtwJwSkafsal5vy8P+qUSqWc
         8WEEVIWEML79eUpZaAUgOvGrGUBsJjjFmhrRUf8l3mJKkFpeuJ1h9FxyBT1wk+3rYXVW
         JIxlHY3VRwfQED6WuvhN9YbjHpuJNyY9jLPAxSw1wGq80nuoBD+3ZtMHllr/P1a+27k9
         3BDw==
X-Gm-Message-State: AOAM531gRHdA4Sxn2/9hyt+AuU/t/x+i/hWH2MgqnjLyCe+IoVKEe2Sa
        U0PTUlgxRIKoOxdrbKgVHFkndw==
X-Google-Smtp-Source: ABdhPJxp7i5US20/aRii1o/KsIXINrL2pr4jmYkXOUQGOXKf71p0QdlmezcpuamEmuUdwfDNh3u4dA==
X-Received: by 2002:a1c:a3c5:: with SMTP id m188mr17121192wme.152.1592818885393;
        Mon, 22 Jun 2020 02:41:25 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:24 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 02/15] net: phy: arrange headers in mdio_device.c alphabetically
Date:   Mon, 22 Jun 2020 11:37:31 +0200
Message-Id: <20200622093744.13685-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622093744.13685-1-brgl@bgdev.pl>
References: <20200622093744.13685-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Keeping the headers in alphabetical order is better for readability and
allows to easily see if given header is already included.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/mdio_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index c1d345c3cab3..f60443e48622 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -6,6 +6,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/gpio.h>
 #include <linux/gpio/consumer.h>
@@ -20,7 +21,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/unistd.h>
-#include <linux/delay.h>
 
 void mdio_device_free(struct mdio_device *mdiodev)
 {
-- 
2.26.1

