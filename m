Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A17825E83F
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 16:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgIEOD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 10:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgIEODk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 10:03:40 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCC0C061245
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 07:03:39 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o21so9303800wmc.0
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 07:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=konsulko.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r8t3Bq+9skdVRp16Sgumk9QASfxctZ6a3tE/UOz3Dr0=;
        b=Gria/rGZtf5NviLuBNOj1xcUjLakfLU0YYMYCY1Srrxmvda1Jtf/1IY5bd2SRNBPxf
         3mFM3UJaAby/XtcbVlFw8iE0iXPRMFYnCqv3B1nYi3oZBuhms/61/ayYQm9jR2p7kYnn
         z4fvyqbZwJW4JGwrT51CK1prPgmKIqnWltI84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r8t3Bq+9skdVRp16Sgumk9QASfxctZ6a3tE/UOz3Dr0=;
        b=s0x+tvbWD2gRDFQmEFvfzoTnZ4udkNLtqYPU3NV1FsnY/X6gGpL/RbNdsthzfgiaTu
         ash5k/ftx0JRkhn2YcLp+DCNZ8Ko790ub5mrgPYeIlGFP2RjTdAFRHVAtxRjJ4wkY2w7
         4HgGbxAObPgS1gSRkrYhpgJgCacxaxnFvgMasqq+v9K2WazlYNlPsqmOXTqPMR63U9l4
         mz5aN8f24InD4zJ3Naqvqk+90vh80IJQxHkjRIdMfHNfEQf8i15wtBoI+YbWHSERmZfd
         S67xluKAUCIYqvoMjz7Ts5m5S241EXYvhKGAhD2by05GHdM/4ml6jOtVEnQ82+M+HIlk
         dGKQ==
X-Gm-Message-State: AOAM533L+wAsEu779ouaXWEDOWKpCdoU0LUX7TKVMKM8HVaOft5HstI/
        W4cYXKPuV9MvoY7ndw3atAcbuQ==
X-Google-Smtp-Source: ABdhPJworfGD5wUy1AnwxD8eagfKJNqIiq5UmENXJDNcoe6f2+TMHNr2wvEBc3nBVx6+YaxNVRvX5g==
X-Received: by 2002:a1c:56d6:: with SMTP id k205mr12253247wmb.88.1599314617538;
        Sat, 05 Sep 2020 07:03:37 -0700 (PDT)
Received: from ar2.home.b5net.uk ([213.48.11.149])
        by smtp.gmail.com with ESMTPSA id b2sm17390369wmh.47.2020.09.05.07.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 07:03:37 -0700 (PDT)
From:   Paul Barker <pbarker@konsulko.com>
To:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Paul Barker <pbarker@konsulko.com>, netdev@vger.kernel.org
Subject: [PATCH 1/4] net: dsa: microchip: Make switch detection more informative
Date:   Sat,  5 Sep 2020 15:03:22 +0100
Message-Id: <20200905140325.108846-2-pbarker@konsulko.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200905140325.108846-1-pbarker@konsulko.com>
References: <20200905140325.108846-1-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To make switch detection more informative print the result of the
ksz9477/ksz9893 compatibility check. With debug output enabled also
print the contents of the Chip ID registers as a 40-bit hex string.

As this detection is the first communication with the switch performed
by the driver, making it easy to see any errors here will help identify
issues with SPI data corruption or reset sequencing.

Signed-off-by: Paul Barker <pbarker@konsulko.com>
---
 drivers/net/dsa/microchip/ksz9477.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index 3cb22d149813..a48f5edab561 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -13,6 +13,7 @@
 #include <linux/if_bridge.h>
 #include <net/dsa.h>
 #include <net/switchdev.h>
+#include <linux/printk.h>
 
 #include "ksz9477_reg.h"
 #include "ksz_common.h"
@@ -1426,10 +1427,12 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 	/* Default capability is gigabit capable. */
 	dev->features = GBIT_SUPPORT;
 
+	dev_dbg(dev->dev, "Switch detect: ID=%08x%02x\n", id32, data8);
 	id_hi = (u8)(id32 >> 16);
 	id_lo = (u8)(id32 >> 8);
 	if ((id_lo & 0xf) == 3) {
 		/* Chip is from KSZ9893 design. */
+		dev_info(dev->dev, "Found KSZ9893\n");
 		dev->features |= IS_9893;
 
 		/* Chip does not support gigabit. */
@@ -1438,6 +1441,7 @@ static int ksz9477_switch_detect(struct ksz_device *dev)
 		dev->mib_port_cnt = 3;
 		dev->phy_port_cnt = 2;
 	} else {
+		dev_info(dev->dev, "Found KSZ9477 or compatible\n");
 		/* Chip uses new XMII register definitions. */
 		dev->features |= NEW_XMII;
 
-- 
2.28.0

