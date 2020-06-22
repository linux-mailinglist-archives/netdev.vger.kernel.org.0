Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A002033C3
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbgFVJmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727102AbgFVJlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:37 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F849C061795
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:37 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so15932835wrs.11
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yy6XgmLu+rdPXztYG22qHG3UQylFLO0aZanRZZZSG+U=;
        b=UtNEe+Y7D5ArH7Qe/vs7TUd5yHPcILffWoYh4wTCQdtMBq36DtKsydxvi6z3a7HbGS
         FB2blBliY4Y+cVZyVIBbNCz/TMBZbmhI+WrSDUrAZc+nT9RqNVT9ahaolMbn+oxd3MXf
         1G7L1Tcb6rs72hInUAFR8sZDDUZyVq9WQ8aEF0wR9UhVHcEeuUBRsA99mkWAfVG8D7Fm
         zKsJUFL1xKBJ0gZxZlQvxrVGukdEa54zY4pSR0TYGGrqagLXr4OzxpZFMV8ttxXXVHQU
         uiUpPpCNqmeepGbSEiBWxIRbMBVFfKFJKOIFmK8bRZsbBYVxA3/rlPTyqTaIaGU38MYj
         ac8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yy6XgmLu+rdPXztYG22qHG3UQylFLO0aZanRZZZSG+U=;
        b=WrOW08t40W8f+SbsDgZhEDJv/kGTf6+Brvv+FbEu6slj8GprBvdbf6LVga5RWxi2N3
         6CDdBtKBt6pa/t+6O6u+MAZn1iYzHqlgy1uThTGwUg9OMf1VNHqlClrFzQajzM5q8Cuk
         PlQNGe0bDDlPMf5JOQxtn1zcflCS4LG5GWuWzZtfcWX34ck4o8Q4alw9KHDNCQi9QhhD
         0uUDias9+UAfId2MI6uXXk+aL8PK436dYBr++ghYTZDyflUBNddNB7og/SvV0UlJxZXi
         tIvxRhbe9QAC3G0g+S6N74cFtr5NHMcrtYNcmuxK7brHHm8qDPfpXbgAm3fZl30pY8+W
         bjzA==
X-Gm-Message-State: AOAM5304//9YyHjIM3sCXPiY+iZE9q5PcDMfVNfQ0LlSYqhooSlZg6tk
        maLp56HLc0Ul4HGIJyZAFuXZbA==
X-Google-Smtp-Source: ABdhPJyFGfPZiEZAaPA05Oy9u/8YECmNenqKkrnMxPg4aIkaLDansk5+kyg8mkF5tPJf9KrUB0gUSQ==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr17998302wru.79.1592818896247;
        Mon, 22 Jun 2020 02:41:36 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:35 -0700 (PDT)
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
Subject: [PATCH 08/15] net: phy: check the PHY presence in get_phy_id()
Date:   Mon, 22 Jun 2020 11:37:37 +0200
Message-Id: <20200622093744.13685-9-brgl@bgdev.pl>
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

get_phy_id() is only called from get_phy_device() so the check for the
0x1fffffff value can be pulled into the former. This way it'll be easier
to remove get_phy_device() later on.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/phy_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8037a9663a85..eccbf6aea63d 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -806,6 +806,10 @@ static int get_phy_id(struct mii_bus *bus, int addr, u32 *phy_id,
 
 	*phy_id |= phy_reg;
 
+	/* If the phy_id is mostly Fs, there is no device there */
+	if ((*phy_id & 0x1fffffff) == 0x1fffffff)
+		return -ENODEV;
+
 	return 0;
 }
 
@@ -832,10 +836,6 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	if (r)
 		return ERR_PTR(r);
 
-	/* If the phy_id is mostly Fs, there is no device there */
-	if ((phy_id & 0x1fffffff) == 0x1fffffff)
-		return ERR_PTR(-ENODEV);
-
 	return phy_device_create(bus, addr, phy_id, is_c45, &c45_ids);
 }
 EXPORT_SYMBOL(get_phy_device);
-- 
2.26.1

