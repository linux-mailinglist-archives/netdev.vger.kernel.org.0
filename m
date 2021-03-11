Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D45B336A0F
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 03:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhCKCML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 21:12:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbhCKCLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 21:11:41 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01FD7C061574;
        Wed, 10 Mar 2021 18:11:41 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id t18so2683202pjs.3;
        Wed, 10 Mar 2021 18:11:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4eB/nkDB8WywIt0l6dz2tHl2O8kDpGdV2lwOJHNqcUc=;
        b=b4fS6+abyBz8ouSM5tHvmYgX9bb8z6+u9VUhLMiMV9jrTiyC2A4gEf4pIffMxuJhZ7
         xlU9OT2EWfcs9T5AH+7h6LCr6oOqOOReMeVdkgI2YNQmnFSxmzJPrL0l3gIaPYC/X1Cf
         aFCC5yhhkEckVapXl5kPVaH2moliSCMNX8lOSBD2RSsdA6zmp8CnCQAikmxyr7Mmr5VX
         rUij/JW2eOIS5j59Ywgd3jHJl+uYlkKqgguKDnrS/mDQOFXco2QIlW7iJPHpJKDvP7Ib
         TNxh4jFHeCltbWILufmG8SbzXyC3JAyo/jimfC+7wOj/E3AvXXWWUiFE11t68tcjUJ5y
         mllw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4eB/nkDB8WywIt0l6dz2tHl2O8kDpGdV2lwOJHNqcUc=;
        b=kuHGYz7LaDOm5kHI/MEzB2UWJ88rYj4J4iOmSCvUQc73ms7JtWeAOHEz4TYNIR1PTt
         +r7yTyEVx4cS2mNoRRaNWIy//9X002BeOkYDkSs78x17mvICLYnK/H0DnhuJf39KeD/A
         1lSHJkVt+G+KEZizRFCyOPGmtVVHV8lm2Ydye+gssFL3G5zue9eeXI0Z8uuBeU9ZgegM
         rlCrgK9dKLV4pT+Ii/8qFSczlDFRcB7wh5iQm1bev0t4pTGx6fMN1gdLEqYtQTOYRnhd
         v/9INIjqX2urjzNnHfTNFJ7nJOJrhPqOuMVQsTB8tkMDABp4JmjqmrURVwDi3Xs1qXNI
         RUbA==
X-Gm-Message-State: AOAM531uUHTE8LCqp6/k72MVPEZ1RUtraggUUQ30c8FoLwYXM2vp0qVY
        Ddggm96P0vXr7u2IcZ5jvSY=
X-Google-Smtp-Source: ABdhPJwpHtrc/BuEVZnFuQctlYwyq5FgZvAVXrzXzQNwkqcADujjyNsApngDaYJlHkujwOA1RmiubQ==
X-Received: by 2002:a17:902:b942:b029:e4:87be:be8c with SMTP id h2-20020a170902b942b02900e487bebe8cmr5525396pls.81.1615428700577;
        Wed, 10 Mar 2021 18:11:40 -0800 (PST)
Received: from z640-arch.lan ([2602:61:738f:1000::678])
        by smtp.gmail.com with ESMTPSA id p190sm672603pga.78.2021.03.10.18.11.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 18:11:40 -0800 (PST)
From:   Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
To:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Subject: [PATCH net-next,v2 3/3] net: dsa: mt7530: disable TRGMII clock at reconfigure
Date:   Wed, 10 Mar 2021 18:09:54 -0800
Message-Id: <20210311020954.842341-3-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com>
References: <20210311020954.842341-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Disable both core and TRGMII Tx clocks prior to reconfiguring.
Previously, only the core clock was disabled, but not TRGMII Tx clock.
So disable both, then configure them, then re-enable both, for
consistency.

Reword the comment about core_write_mmd_indirect for clarity.

Tested on Ubiquiti ER-X running the GMAC and MT7530 in TRGMII mode.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/dsa/mt7530.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 80a35caf920e..7ef5e7c23e05 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -435,15 +435,18 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
 			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
-	/* Setup core clock for MT7530 */
-	/* Disable MT7530 core clock */
-	core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
-
-	/* Disable PLL, since phy_device has not yet been created
-	 * provided for phy_[read,write]_mmd_indirect is called, we
-	 * provide our own core_write_mmd_indirect to complete this
-	 * function.
+	/* Since phy_device has not yet been created and
+	 * phy_[read,write]_mmd_indirect is not available, we provide our own
+	 * core_write_mmd_indirect with core_{clear,write,set} wrappers to
+	 * complete this function.
 	 */
+
+	/* Disable MT7530 core and TRGMII Tx clocks */
+	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
+		   REG_GSWCK_EN | REG_TRGMIICK_EN);
+
+	/* Setup core clock for MT7530 */
+	/* Disable PLL */
 	core_write(priv, CORE_GSWPLL_GRP1, 0);
 
 	/* Set core clock into 500Mhz */
-- 
2.30.2

