Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5A331A669
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 22:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhBLU7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 15:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231865AbhBLU60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 15:58:26 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D19AC061756;
        Fri, 12 Feb 2021 12:57:46 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id x9so477863plb.5;
        Fri, 12 Feb 2021 12:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dwmciB3pTNwaIWJFsxZaCQR8SUWVkirrLZDjakBcESE=;
        b=ZipO9dHyac6j5wc6ijVotyxnuKsojDI+CYsjl0YR1C17ksYUpSc+RNSk6Jhsxlpe7L
         Ng4qsNjEVbavsvu/gUrd/92lagnrgAJJdeS/IX8eYSBbRyxWcAEMa6pmSXvwNkNjgYCj
         1t4/WB/88nGTzb/cVHZAe53loIvuZ5dFwb7CbneMDzbDh0Oae4sbQHm/cuO6D1czNEgd
         hYbJC9IoYz0ZKNgu7DpjMXKQQ7NgRGtJLtwcFaE6SvgTocFy4NYT89BPVm/3W2DXx8nY
         H4/ZfF0Umdjou07AK8U37tkHwUW77QkT1kA/xNIwabKaLBw56YMhn0osrrNAqrYV08FS
         gJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dwmciB3pTNwaIWJFsxZaCQR8SUWVkirrLZDjakBcESE=;
        b=ZoD8h/IEKJ1eWkcw5CE6PfGa8o1D6jngGlUtR9SFvRAoA+ae4Qkma3p+GGQa1ZNipn
         Nh6gPSKFF8lROwvb143f8hEDxJR7b7ONuRkJHsxxLttmWlMzaza8hfOVMzYFMgEaxrXc
         xHcI53ZCRJzKNAj1xOUlyZnEyuEmNGb83gKShVkIhUHIOn7ql+OTjXxOTFkCqmjAYfA1
         WIfuRt0tg8II8hAr3GuubSpeybqyXJqTvXW/vZwIK1EsecTaPj3iTmi9Mi2Tk5oDgnN8
         3MJ0SyTDAkOOxz0vhiOl5QqVkd2KDvsZggzwpbjUp9mUMz+HAOhz/lG7uj3sBwc8vyB9
         5duA==
X-Gm-Message-State: AOAM531dwVIqlyimdeARwCrzzqUn6WKs4BcHKuI+awTcP2LPCTco8aGz
        B8nBRXyMntvtEeCnWUtvbZuS3hy2Huc=
X-Google-Smtp-Source: ABdhPJxKLchfNaCa0OZyevwo53CBHBtpJROnAgssY4gVPrWZiARfvtxtGOEsECETqWc1EUu4NVl9kw==
X-Received: by 2002:a17:90a:67ca:: with SMTP id g10mr4159160pjm.166.1613163455250;
        Fri, 12 Feb 2021 12:57:35 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a141sm9891628pfa.189.2021.02.12.12.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 12:57:28 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Chan <mchan@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM ETHERNET PHY
        DRIVERS), linux-kernel@vger.kernel.org (open list),
        olteanv@gmail.com, michael@walle.cc
Subject: [PATCH net-next 1/3] net: phy: broadcom: Remove unused flags
Date:   Fri, 12 Feb 2021 12:57:19 -0800
Message-Id: <20210212205721.2406849-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212205721.2406849-1-f.fainelli@gmail.com>
References: <20210212205721.2406849-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have a number of unused flags defined today and since we are scarce
on space and may need to introduce new flags in the future remove and
shift every existing flag down into a contiguous assignment. No
functional change.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/brcmphy.h | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index de9430d55c90..da7bf9dfef5b 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -61,19 +61,15 @@
 #define PHY_BCM_OUI_5			0x03625e00
 #define PHY_BCM_OUI_6			0xae025000
 
-#define PHY_BCM_FLAGS_MODE_COPPER	0x00000001
-#define PHY_BCM_FLAGS_MODE_1000BX	0x00000002
-#define PHY_BCM_FLAGS_INTF_SGMII	0x00000010
-#define PHY_BCM_FLAGS_INTF_XAUI		0x00000020
-#define PHY_BRCM_WIRESPEED_ENABLE	0x00000100
-#define PHY_BRCM_AUTO_PWRDWN_ENABLE	0x00000200
-#define PHY_BRCM_RX_REFCLK_UNUSED	0x00000400
-#define PHY_BRCM_STD_IBND_DISABLE	0x00000800
-#define PHY_BRCM_EXT_IBND_RX_ENABLE	0x00001000
-#define PHY_BRCM_EXT_IBND_TX_ENABLE	0x00002000
-#define PHY_BRCM_CLEAR_RGMII_MODE	0x00004000
-#define PHY_BRCM_DIS_TXCRXC_NOENRGY	0x00008000
-#define PHY_BRCM_EN_MASTER_MODE		0x00010000
+#define PHY_BCM_FLAGS_MODE_1000BX	0x00000001
+#define PHY_BRCM_AUTO_PWRDWN_ENABLE	0x00000002
+#define PHY_BRCM_RX_REFCLK_UNUSED	0x00000004
+#define PHY_BRCM_STD_IBND_DISABLE	0x00000008
+#define PHY_BRCM_EXT_IBND_RX_ENABLE	0x00000010
+#define PHY_BRCM_EXT_IBND_TX_ENABLE	0x00000020
+#define PHY_BRCM_CLEAR_RGMII_MODE	0x00000040
+#define PHY_BRCM_DIS_TXCRXC_NOENRGY	0x00000080
+#define PHY_BRCM_EN_MASTER_MODE		0x00000100
 
 /* Broadcom BCM7xxx specific workarounds */
 #define PHY_BRCM_7XXX_REV(x)		(((x) >> 8) & 0xff)
-- 
2.25.1

