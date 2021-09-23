Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7F9416700
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 22:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243190AbhIWU7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 16:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhIWU7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 16:59:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA578C061574;
        Thu, 23 Sep 2021 13:57:36 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y8so6845016pfa.7;
        Thu, 23 Sep 2021 13:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KHgOgmrouOYZZcqRYMh0usWhvdx5OfrwOvmD1G6LDZo=;
        b=QXDmWv36pjZMnDchbHBhFidlKPULmI8gZTTf+Ilm5srTv79RULKDaP9b3xPYKgV/iI
         3YOOggHXoDyX8buY0cXm1VmUDyrqTwkEMSqa77fuIqeANg+22TbkoPzoWrmpiQhyoKf7
         V5Bf8GOMjzCBSfkrOX+qVNGJBXVC+f9e06ndS1t5ig+TGBD4DocX68eaovceQR5nsiJ8
         MKcWvQdw/D2ZZfpTRgU4/86NfNhqjCrcYsoDe+gQGiCv6aYAD5CSQfZPHmKBLko0goiF
         K4xviazouGy2EEQ9gNf4r4hVj28eU+HbbsExgDv/UMQX5IOxYqJ2s6VjZu2PVen7HZEn
         2ZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KHgOgmrouOYZZcqRYMh0usWhvdx5OfrwOvmD1G6LDZo=;
        b=JIvpM3dpT19ztmUgrz5n6WPAb0SM0MSjlt2UhpxZqKmsGQ8sFCGbmaGqerN2Sqyq+z
         /sBFJlZXI1fnr8I0CcwQPwyrt3NhTNP+n6bXOD09NtCi0JcRBni4RqTqL10jXk67yTP4
         PiS0oLyRoWEJRLJprduF4porewonilaEjI4GCp4/R/Hn5SlgnHy0SgHd4WPvy8Vgj44n
         rGP70HuWeiWEDLNw0oZTwjC/laZ4wTi08SS75xFTyIvVfyUSBXggAmGEL1XoDwILYGNx
         LeCeJo8E7U8TfwtKQoXZJ5yIsk63wX/8HpRalQQr/DSG23nHeV1Gparq9Mx4zNEO7tZt
         Upzg==
X-Gm-Message-State: AOAM532SHhGZy9QVUxHYtqfi3I7Adx4sEYHb4zr1x6uraPQwg0/1DgHV
        uiQxRcmOPuY7DMRHrALCLErKvM0ACsQ=
X-Google-Smtp-Source: ABdhPJzldSPJZzniruXpuHn2U1KzSPnuaUfda3zFl3AXwtxZ12YtQFQpsWY9AX1ChKTTduvvnhiG8w==
X-Received: by 2002:a62:407:0:b0:447:c104:2529 with SMTP id 7-20020a620407000000b00447c1042529mr6270072pfe.8.1632430655463;
        Thu, 23 Sep 2021 13:57:35 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q21sm5873359pjg.55.2021.09.23.13.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 13:57:34 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: phy: broadcom: Fix PHY_BRCM_IDDQ_SUSPEND definition
Date:   Thu, 23 Sep 2021 13:57:32 -0700
Message-Id: <20210923205732.507795-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An extraneous number was added during the inclusion of that change,
correct that such that we use a single bit as is expected by the PHY
driver.

Reported-by: Justin Chen <justinpopo6@gmail.com>
Fixes: d6da08ed1425 ("net: phy: broadcom: Add IDDQ-SR mode")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/brcmphy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index b119d6819d6c..27d9b6683f0e 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -67,7 +67,7 @@
 #define PHY_BRCM_CLEAR_RGMII_MODE	0x00000004
 #define PHY_BRCM_DIS_TXCRXC_NOENRGY	0x00000008
 #define PHY_BRCM_EN_MASTER_MODE		0x00000010
-#define PHY_BRCM_IDDQ_SUSPEND		0x000000220
+#define PHY_BRCM_IDDQ_SUSPEND		0x00000020
 
 /* Broadcom BCM7xxx specific workarounds */
 #define PHY_BRCM_7XXX_REV(x)		(((x) >> 8) & 0xff)
-- 
2.25.1

