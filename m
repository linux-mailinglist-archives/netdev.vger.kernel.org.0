Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A6E5EA54
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbfGCRV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:21:27 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44029 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfGCRV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:21:26 -0400
Received: by mail-lj1-f195.google.com with SMTP id 16so3274071ljv.10;
        Wed, 03 Jul 2019 10:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmYvquEADVAMciJoVWVna+nWEH18FTud+FJTYj28hHk=;
        b=Xs2EPHtuaSZGrWvCpsXjY9TqhScmwra8dX5FPpUgi15DJpI1QQyVZ/nEqwn7dqDBkb
         qS8B4wpiUjKQK/OucG+QsCCJPlZPtkjMaedZIJz0OD8lG5qfVZcwlYOWFG/E3jqzLEcM
         qlzFWJakyUhILPaXkfPG/6qnn83ud+OQ3UitIHBKqdRUuSRt0vllFayCiQlHhwT9xI0q
         LhNLp+INqQkPs/2uXT7q/Do/5/Q53sw6Xkw1wJyW7QrjQBo6dgLB4zo0qRElYdYn5+Mf
         0lHnod9m+2p7q5iM7O+2RiiS/rCukRBeX1hfWzDWhNRt9nw0cHuZQR3zoIf6+1N6iPUF
         Yayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmYvquEADVAMciJoVWVna+nWEH18FTud+FJTYj28hHk=;
        b=hbRPv33FdZGimlr1+6rbIA942QdiIXvCk0BncmuUGnDXdD3+dajjjc0ZZU2mrywEYp
         IkHf4QpN+/QIu7M/ia3QNAMws4pwAStiDoysvBymp/U7AqWxGuzUCP4M6dm4QOfSKlmu
         NyhOhZGs1D5rD6OfZ72dyY+sWGsZncaUHcGkVaATsIG7s1giHPdEmv3nt1mqbijQDYdW
         BViW5gVbjcOsVfn4ivcUUV9IzSPQC93WeVkL4CHLSgoXXtmWJvrhI3i4U3Zd07ZNwisF
         hoL8Khfnm/sZFcvT9tKkh0/pCM0dbd4RVjXpPnrj45vmrlYnVz53zdkWn7q9mMnrhkO7
         Nlmw==
X-Gm-Message-State: APjAAAXbQlqGvQnjKmFxmCOiKioBvVjG0fh/yePpN+MWIitYX0PiC4oA
        QOIND6monHFxMiQjamigRHk=
X-Google-Smtp-Source: APXvYqwtoRqmRijNXeN0NdmQdzAxlK3Bi5IyzgiPpH2z7dLB3SyqrtHGbJOEwifAY9jQqng9stekJg==
X-Received: by 2002:a2e:98f:: with SMTP id 137mr20858418ljj.232.1562174484805;
        Wed, 03 Jul 2019 10:21:24 -0700 (PDT)
Received: from krolik-desktop.lan ([91.238.216.6])
        by smtp.gmail.com with ESMTPSA id 11sm581165ljc.66.2019.07.03.10.21.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 10:21:23 -0700 (PDT)
From:   Pawel Dembicki <paweldembicki@gmail.com>
Cc:     Pawel Dembicki <paweldembicki@gmail.com>, linus.walleij@linaro.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] net: dsa: vsc73xx: Assert reset if iCPU is enabled
Date:   Wed,  3 Jul 2019 19:19:24 +0200
Message-Id: <20190703171924.31801-5-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703171924.31801-1-paweldembicki@gmail.com>
References: <20190703171924.31801-1-paweldembicki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver allow to use devices with disabled iCPU only.

Some devices have pre-initialised iCPU by bootloader.
That state make switch unmanaged. This patch force reset
if device is in unmanaged state. In the result chip lost
internal firmware from RAM and it can be managed.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 36 ++++++++++++--------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 10063f31d9a3..4525702faf68 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -417,22 +417,8 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 	}
 
 	if (val == 0xffffffff) {
-		dev_info(vsc->dev, "chip seems dead, assert reset\n");
-		gpiod_set_value_cansleep(vsc->reset, 1);
-		/* Reset pulse should be 20ns minimum, according to datasheet
-		 * table 245, so 10us should be fine
-		 */
-		usleep_range(10, 100);
-		gpiod_set_value_cansleep(vsc->reset, 0);
-		/* Wait 20ms according to datasheet table 245 */
-		msleep(20);
-
-		ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
-				   VSC73XX_ICPU_MBOX_VAL, &val);
-		if (val == 0xffffffff) {
-			dev_err(vsc->dev, "seems not to help, giving up\n");
-			return -ENODEV;
-		}
+		dev_info(vsc->dev, "chip seems dead.\n");
+		return -EAGAIN;
 	}
 
 	ret = vsc73xx_read(vsc, VSC73XX_BLOCK_SYSTEM, 0,
@@ -483,9 +469,8 @@ static int vsc73xx_detect(struct vsc73xx *vsc)
 	}
 	if (icpu_si_boot_en && !icpu_pi_en) {
 		dev_err(vsc->dev,
-			"iCPU enabled boots from SI, no external memory\n");
-		dev_err(vsc->dev, "no idea how to deal with this\n");
-		return -ENODEV;
+			"iCPU enabled boots from PI/SI, no external memory\n");
+		return -EAGAIN;
 	}
 	if (!icpu_si_boot_en && icpu_pi_en) {
 		dev_err(vsc->dev,
@@ -1158,6 +1143,19 @@ int vsc73xx_probe(struct vsc73xx *vsc)
 		msleep(20);
 
 	ret = vsc73xx_detect(vsc);
+	if (ret == -EAGAIN) {
+		dev_err(vsc->dev,
+			"Chip seams to be out of control. Assert reset and try again.\n");
+		gpiod_set_value_cansleep(vsc->reset, 1);
+		/* Reset pulse should be 20ns minimum, according to datasheet
+		 * table 245, so 10us should be fine
+		 */
+		usleep_range(10, 100);
+		gpiod_set_value_cansleep(vsc->reset, 0);
+		/* Wait 20ms according to datasheet table 245 */
+		msleep(20);
+		ret = vsc73xx_detect(vsc);
+	}
 	if (ret) {
 		dev_err(dev, "no chip found (%d)\n", ret);
 		return -ENODEV;
-- 
2.20.1

