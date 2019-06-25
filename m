Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48DC2526EE
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbfFYIlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:41:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36715 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730895AbfFYIly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:41:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so2019819wmm.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 01:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DX+MgW2DwUPYowxaoHKHKMXY71CSmeiudxHn3r781vM=;
        b=lAhq1Zg3aWW1dBC5RWdOmOBiyRpT0z9ulrqTWD4M1qsOQ6R6m6hHrTislTxgfLn1vh
         TRSppcEqiKNftCt+9slBR9kPXM/N1bJNy5uhwW9BX8MzIc/RhOliX3TfQ1oCW57XhM2N
         dhlzht9U4SWq7Iy1zzpNf6TWn37xkoHuCjFQMM7gzJI45w7m8bRBYgw3+EN7f6G1cgOV
         3t9Bi2nDxDo1zYxkE+mjaAUQw3ZUaVa4UaQOitjpKXxwIsqruGcISgPMUj0LRplpkHI3
         ylZx4j93s0mmQMXEYQO4czoVFiPW2rFgJdw86Nn4csnVfnM/zwJyWaK0SMpRqNl4z3Ex
         2SMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DX+MgW2DwUPYowxaoHKHKMXY71CSmeiudxHn3r781vM=;
        b=Yald6S8SwL81zJvzlFamAbbHPQC5hc7bm7ngeW++HPfunESM3+71liEaYK4TtXQgW7
         PaRsAyksci3WFnByUf8X21AL9UqvtvfqiUi3YvOG/5hLF8UYwBcYMZPg48hGlNCu0qIN
         WgeDNCgoXasJ8EZzsz42h1Dgf+wIcyYBs+pHWX5pwol484T2Ncphqvr3RcQlNoshNy7o
         uEFzd0PU6u6x2UnTMhR1KkHyqDB0njt8+DlYTgkpTuvu8lHJ9afBX+bhkvClVyfwaE0I
         14302INmLZtfaO2Ped/H7Ody2LNzVReJ82QhgfVJz23QPdRksBGbn735J8W8XtQiW4fh
         zRzg==
X-Gm-Message-State: APjAAAXMo5PJ60A3Q/lrEtxDxa0YQLFCDYXlh+6pMmAlNsCgKBtMu5kj
        uYvjOb6SoRAba/EZRBjxh/6cUqlq
X-Google-Smtp-Source: APXvYqyanDLDXpx7+FgesD7dQoZqH+lDmsHWwTZbbTfXhd6cuZpY041FravNOT2WJ5dINHCg1vZp1w==
X-Received: by 2002:a1c:4054:: with SMTP id n81mr19190425wma.78.1561452112587;
        Tue, 25 Jun 2019 01:41:52 -0700 (PDT)
Received: from debian64.daheim (pD9E29981.dip0.t-ipconnect.de. [217.226.153.129])
        by smtp.gmail.com with ESMTPSA id f7sm7751316wrv.38.2019.06.25.01.41.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 01:41:51 -0700 (PDT)
Received: from chuck by debian64.daheim with local (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1hfh1T-0002SW-9Z; Tue, 25 Jun 2019 10:41:51 +0200
From:   Christian Lamparter <chunkeey@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v1 2/2] net: dsa: qca8k: introduce reset via gpio feature
Date:   Tue, 25 Jun 2019 10:41:51 +0200
Message-Id: <36b1e912b47bc079a78e06e05a33213833715314.1561452044.git.chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <08e0fd513620f03a2207b9f32637cdb434ed8def.1561452044.git.chunkeey@gmail.com>
References: <08e0fd513620f03a2207b9f32637cdb434ed8def.1561452044.git.chunkeey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The QCA8337(N) has a RESETn signal on Pin B42 that
triggers a chip reset if the line is pulled low.
The datasheet says that: "The active low duration
must be greater than 10 ms".

This can hopefully fix some of the issues related
to pin strapping in OpenWrt for the EA8500 which
suffers from detection issues after a SoC reset.

Please note that the qca8k_probe() function does
currently require to read the chip's revision
register for identification purposes.

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
---
 drivers/net/dsa/qca8k.c | 15 +++++++++++++++
 drivers/net/dsa/qca8k.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index c4fa400efdcc..27709f866c23 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -14,6 +14,7 @@
 #include <linux/of_platform.h>
 #include <linux/if_bridge.h>
 #include <linux/mdio.h>
+#include <linux/gpio.h>
 #include <linux/etherdevice.h>
 
 #include "qca8k.h"
@@ -1046,6 +1047,20 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	priv->bus = mdiodev->bus;
 	priv->dev = &mdiodev->dev;
 
+	priv->reset_gpio = devm_gpiod_get_optional(priv->dev, "reset",
+						   GPIOD_ASIS);
+	if (IS_ERR(priv->reset_gpio))
+		return PTR_ERR(priv->reset_gpio);
+
+	if (priv->reset_gpio) {
+		gpiod_set_value_cansleep(priv->reset_gpio, 1);
+		/* The active low duration must be greater than 10 ms
+		 * and checkpatch.pl wants 20 ms.
+		 */
+		msleep(20);
+		gpiod_set_value_cansleep(priv->reset_gpio, 0);
+	}
+
 	/* read the switches ID register */
 	id = qca8k_read(priv, QCA8K_REG_MASK_CTRL);
 	id >>= QCA8K_MASK_CTRL_ID_S;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 91557433ce2f..42d6ea24eb14 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -10,6 +10,7 @@
 
 #include <linux/delay.h>
 #include <linux/regmap.h>
+#include <linux/gpio.h>
 
 #define QCA8K_NUM_PORTS					7
 
@@ -174,6 +175,7 @@ struct qca8k_priv {
 	struct mutex reg_mutex;
 	struct device *dev;
 	struct dsa_switch_ops ops;
+	struct gpio_desc *reset_gpio;
 };
 
 struct qca8k_mib_desc {
-- 
2.20.1

