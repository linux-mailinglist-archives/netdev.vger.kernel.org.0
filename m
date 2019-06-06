Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825DD370A3
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 11:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbfFFJro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 05:47:44 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:45391 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728193AbfFFJrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 05:47:42 -0400
Received: by mail-lf1-f65.google.com with SMTP id u10so298040lfm.12
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 02:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NsVvPiBY4yVAfgVoOW5rwqcEUi8304y5zEW51I3/QB0=;
        b=Wdoh2MpFPPwEGDiEjo9yNWPvFiF5rNlEHiZaJf0n9Vg6FS4VUU2cc68GaQl4o2gqwy
         4dbJ3g7WEmat/ufCpfazLVbgV6ySmza2gxaYFAenGQnggpEoKYT0NNP+fPKzDviOplly
         V4mMdAPS/XxX37EVSGdaX+UcmhdKT4IrRkVpNMAbgC2gt8VMNs9PsvD/GD6B5RuHKt5c
         t/UzHJLvzB8BJNgCgTBSJ9KsV9zFkV8hfU8Yx2nTgZ+yWZl6uY6MS8YPGXRBG1hDMj9x
         L4RXjgeGsIVpXYaTYCaIyZyu1UZI8FSwWNUppmzZdyqw0fFmoG4R/pcy23fAlNtrw2K/
         yzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NsVvPiBY4yVAfgVoOW5rwqcEUi8304y5zEW51I3/QB0=;
        b=ToOVNVYGVYuzQArEZQ94wa32BOml2jm5RR0H6ewKux+ZpNbzCMIcjmROeAWF9uM8VN
         Usqp73aWzPCwdyQ88b6Vd3q5adgYU1sg9UmHjrzdiprToUYaDXYDUgz7tGrE3c5PhwxF
         QinliO/g5qJ1x0WWAWn9f9iJTtKgKxYi419lYtb3gZlSEMDDj51h77YdYQnMI+mBT3sM
         tHKOY266RpnNnxYQc6CCEaM9uzxk1ixNcIvU8MrtVvDILXuCaKvpfQHw2jjrkpvGO0wD
         iVLg6nNiA9mXYTsQZnH2df5eAXLpbVk+lruu0ylnpebTE9t3mwNRSt8w9vxPC7FgswfZ
         2bFQ==
X-Gm-Message-State: APjAAAXvEPH5oKriZY5pCU4A4HL9BNZLA0y+PEJx/lJkd+de0jI3yU54
        hLS92ZILr4JF4BG60v8aZyD6Hw==
X-Google-Smtp-Source: APXvYqwC1lw0i+elxeAauVlnzExuJPoAeIohV6gRyR/H/KWYyVWxRDSoL1E/QIVDRnsweZyms/BPzA==
X-Received: by 2002:ac2:4ac5:: with SMTP id m5mr22449224lfp.95.1559814460755;
        Thu, 06 Jun 2019 02:47:40 -0700 (PDT)
Received: from localhost (c-1c3670d5.07-21-73746f28.bbcust.telenor.se. [213.112.54.28])
        by smtp.gmail.com with ESMTPSA id d23sm258143ljj.38.2019.06.06.02.47.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 02:47:40 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     lgirdwood@gmail.com, broonie@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        marex@denx.de, stefan@agner.ch, airlied@linux.ie, daniel@ffwll.ch,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        b.zolnierkie@samsung.com, a.hajda@samsung.com, mchehab@kernel.org,
        p.zabel@pengutronix.de, hkallweit1@gmail.com, lee.jones@linaro.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-media@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH 8/8] drivers: regulator: 88pm800: fix warning same module names
Date:   Thu,  6 Jun 2019 11:47:36 +0200
Message-Id: <20190606094736.23970-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with CONFIG_MFD_88PM800 and CONFIG_REGULATOR_88PM800
enabled as loadable modules, we see the following warning:

warning: same module names found:
  drivers/regulator/88pm800.ko
  drivers/mfd/88pm800.ko

Rework to rename the name.

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/regulator/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/Makefile b/drivers/regulator/Makefile
index 76e78fa449a2..6906938071f5 100644
--- a/drivers/regulator/Makefile
+++ b/drivers/regulator/Makefile
@@ -11,7 +11,8 @@ obj-$(CONFIG_REGULATOR_VIRTUAL_CONSUMER) += virtual.o
 obj-$(CONFIG_REGULATOR_USERSPACE_CONSUMER) += userspace-consumer.o
 
 obj-$(CONFIG_REGULATOR_88PG86X) += 88pg86x.o
-obj-$(CONFIG_REGULATOR_88PM800) += 88pm800.o
+obj-$(CONFIG_REGULATOR_88PM800) += 88pm800-regulator.o
+88pm800-regulator-objs		:= 88pm800.o
 obj-$(CONFIG_REGULATOR_88PM8607) += 88pm8607.o
 obj-$(CONFIG_REGULATOR_CPCAP) += cpcap-regulator.o
 obj-$(CONFIG_REGULATOR_AAT2870) += aat2870-regulator.o
-- 
2.20.1

