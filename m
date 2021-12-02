Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90D9465D46
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 05:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355360AbhLBEUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 23:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355335AbhLBEUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 23:20:48 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43BFC06174A;
        Wed,  1 Dec 2021 20:17:23 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y7so19350098plp.0;
        Wed, 01 Dec 2021 20:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sqMHXH/ut028Uv9GgMbyl0T/geqI+fdfbszgip1rFB0=;
        b=ql3VIdVxIqDWZsROgDF2tX7EG4VE/HEQ+JHSOnyMUq1ttA8jy+/gy0D7sI3jCkBoej
         NccGNN79jzngMl07kRdkeRLMhlKHZXBYnwTcGEJUA20URDodCpzniNRXSns4pQbWQ0sE
         Jg1eS1/heh6Mp1Fvwue/gpL/L1JIIIIJgYdoaQQoaDCqXLXgti0qJKGtHe14Zk8KCHAj
         IN1riJjwG5RDL/VleRyn4dNyrIXszptqqJkFbrnIQbX62voUbKY38OD8b5k9UTuLKlq1
         SK5R/aK+JfUeTgcKGTSYev6E45BQviiE8dyOrtZ5ECYAt0gzNHDihIIN8Sw/wKDzdU6W
         BcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sqMHXH/ut028Uv9GgMbyl0T/geqI+fdfbszgip1rFB0=;
        b=MAmkwkIVsO416UBxdNpOkEmY+t/e6WVH215R3/sXO7FsM8vJoADe252yDLt9VMvMzt
         W9COcGMmjh6MNW85AOJ1sQZI1xUpsFY1d2Qf76hRYpgfER54nMZdBhpefDdnwi50AESQ
         tAHLQKW0Y4VYnIbzLGHRU1gsNItSCavH9NS0KpBgKQWdYh6LemQOU+NNTafq+uUuhM7F
         9d0CYcUEQ4m9S1ZnCp8z4b9UW24qVycD/AfQlnR6G5gszfSVANO3MTcjExEaXFnkxHBe
         c9qKGXctCLIXGxwdaaayL6wmkSOhTkwyH19fcH/T+Oq45tmiTKI1rkJhUuApumwqFuLX
         fJsg==
X-Gm-Message-State: AOAM5320fmZWwmAYqZwugA5mwXFyGRAB/GTXwaxY8a8T89toVTN+Z62I
        McJoYIBGt1DOyPOYWNXRRoCoAe/gXP8=
X-Google-Smtp-Source: ABdhPJwQnAjWuHeiKIuwjZNmTA1xTAbcNC5QmpOWp73034u2V76kCUeRvbm9SH2WoonOL9cVJTjDyA==
X-Received: by 2002:a17:90a:fe0a:: with SMTP id ck10mr3182462pjb.216.1638418643155;
        Wed, 01 Dec 2021 20:17:23 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u13sm1070374pgp.27.2021.12.01.20.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 20:17:22 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     broonie@kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: dsa: b53: Add SPI ID table
Date:   Wed,  1 Dec 2021 20:17:20 -0800
Message-Id: <20211202041720.1013279-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently autoloading for SPI devices does not use the DT ID table, it
uses SPI modalises. Supporting OF modalises is going to be difficult if
not impractical, an attempt was made but has been reverted, so ensure
that module autoloading works for this driver by adding an id_table
listing the SPI IDs for everything.

Fixes: 96c8395e2166 ("spi: Revert modalias changes")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_spi.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_spi.c b/drivers/net/dsa/b53/b53_spi.c
index 01e37b75471e..2b88f03e5252 100644
--- a/drivers/net/dsa/b53/b53_spi.c
+++ b/drivers/net/dsa/b53/b53_spi.c
@@ -349,6 +349,19 @@ static const struct of_device_id b53_spi_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, b53_spi_of_match);
 
+static const struct spi_device_id b53_spi_ids[] = {
+	{ .name = "bcm5325" },
+	{ .name = "bcm5365" },
+	{ .name = "bcm5395" },
+	{ .name = "bcm5397" },
+	{ .name = "bcm5398" },
+	{ .name = "bcm53115" },
+	{ .name = "bcm53125" },
+	{ .name = "bcm53128" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(spi, b53_spi_ids);
+
 static struct spi_driver b53_spi_driver = {
 	.driver = {
 		.name	= "b53-switch",
@@ -357,6 +370,7 @@ static struct spi_driver b53_spi_driver = {
 	.probe	= b53_spi_probe,
 	.remove	= b53_spi_remove,
 	.shutdown = b53_spi_shutdown,
+	.id_table = b53_spi_ids,
 };
 
 module_spi_driver(b53_spi_driver);
-- 
2.25.1

