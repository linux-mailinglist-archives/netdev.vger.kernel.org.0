Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBB3F34B493
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 06:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhC0F4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 01:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhC0F43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 01:56:29 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B4AC0613AA;
        Fri, 26 Mar 2021 22:56:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ha17so3564829pjb.2;
        Fri, 26 Mar 2021 22:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=212MoIVRmwK8MrQbEae/kGIbB/Uja/t6Mnpd6kWTsUU=;
        b=HbGy5MIdIAKe4cdEy4h9zPL3jYPNEHDEnmVLXXNVZkMGe/AO9bdLYBPicsmc1D6K7b
         TSl+S59c/H0nU/SfV81A+TIaoIgjOqHk+2dcWihriXQKYB4/ZiTzklSU1DEahfZB/xjc
         ERXYt2QndXOT/Gj6bUGMTAiPWG4uUhgbsyebfu9m1UnHEEYgoa2CGlv/Ue3isanBJMlG
         Y01qsuK8z/mfxdc6dh7MnEdVpW7UlQEy94DIiTBClQPIWPVqFZ0WYRDCRGOSlpxTGSZa
         qRVeVTXWW3YY7lkG2MP1+KVMwERh58/+7lwb21fGIvD/ob9SEGbXut3Cn0MnJSlwIgri
         BnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=212MoIVRmwK8MrQbEae/kGIbB/Uja/t6Mnpd6kWTsUU=;
        b=QVxYdLwARLbHIC1rnd+HqQ05schcTLZ2tgWu5HBX3dxoKekp1yn5GsjijjamnSpGM+
         n9p2pbYhtzSQqYE1higH3Hzx0MBoqsZ+lMVAHWaBs+EG7nfQTYAYZZnq/pJj+fIk8Fyk
         jsquMxPGZCs9d++duoV2c5TP9qkKTmCwlkuG3EuRQ+9Rjj523zwAL0aanoPgNlUqyq9H
         YCiv3fZ01MLYZFfLM5UxjOM8d3kFoBmh8Le3QHUKZNrEONCFspcO1Sw8KO0t9zH9sNQr
         B/3Kut4onOyz38hWnoDPQ5XTfcXVyOBnJbW7ZIls2vJyD5Bykky2y/2YLjEHZTBOp8XT
         f86A==
X-Gm-Message-State: AOAM533G6CZZTnSyT1wpRIdmtynQzAxmL301L1vOe8opNj10rQA6HxSl
        wISmWuGxWKD4EvANAZete8o=
X-Google-Smtp-Source: ABdhPJxzA9XdjlCSbCP7CyG6gFx1hOmk9q2sUZ/8rk9EuAHbpFGpjIXBzMuVYbvLKRFForn/2YjhaQ==
X-Received: by 2002:a17:90b:307:: with SMTP id ay7mr16895037pjb.110.1616824587295;
        Fri, 26 Mar 2021 22:56:27 -0700 (PDT)
Received: from z640-arch.lan ([2602:61:7344:f100::678])
        by smtp.gmail.com with ESMTPSA id q25sm10477521pfh.34.2021.03.26.22.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 22:56:27 -0700 (PDT)
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
Subject: [PATCH net-next] net: dsa: mt7530: clean up core and TRGMII clock setup
Date:   Fri, 26 Mar 2021 22:55:43 -0700
Message-Id: <20210327055543.473099-1-ilya.lipnitskiy@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Three minor changes:

- When disabling PLL, there is no need to call core_write_mmd_indirect
  directly, use the core_write wrapper instead like the rest of the code
  in the function does. This change helps with consistency and
  readability. Move the comment to the definition of
  core_write_mmd_indirect where it belongs.

- Disable both core and TRGMII Tx clocks prior to reconfiguring.
  Previously, only the core clock was disabled, but not TRGMII Tx clock.
  So disable both, then configure them, then re-enable both, for
  consistency.

- The core clock enable bit (REG_GSWCK_EN) is written redundantly three
  times. Simplify the code and only write the register only once at the
  end of clock reconfiguration to enable both core and TRGMII Tx clocks.

Tested on Ubiquiti ER-X running the GMAC0 and MT7530 in TRGMII mode.

Signed-off-by: Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
---
 drivers/net/dsa/mt7530.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index c442a5885fca..d779f40d46d9 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -67,6 +67,11 @@ static const struct mt7530_mib_desc mt7530_mib[] = {
 	MIB_DESC(1, 0xb8, "RxArlDrop"),
 };
 
+/* Since phy_device has not yet been created and
+ * phy_[read,write]_mmd_indirect is not available, we provide our own
+ * core_write_mmd_indirect with core_{clear,write,set} wrappers to
+ * complete this function.
+ */
 static int
 core_read_mmd_indirect(struct mt7530_priv *priv, int prtad, int devad)
 {
@@ -435,19 +440,13 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
 			     TD_DM_DRVP(8) | TD_DM_DRVN(8));
 
-	/* Setup core clock for MT7530 */
-	/* Disable MT7530 core clock */
-	core_clear(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
+	/* Disable MT7530 core and TRGMII Tx clocks */
+	core_clear(priv, CORE_TRGMII_GSW_CLK_CG,
+		   REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-	/* Disable PLL, since phy_device has not yet been created
-	 * provided for phy_[read,write]_mmd_indirect is called, we
-	 * provide our own core_write_mmd_indirect to complete this
-	 * function.
-	 */
-	core_write_mmd_indirect(priv,
-				CORE_GSWPLL_GRP1,
-				MDIO_MMD_VEND2,
-				0);
+	/* Setup core clock for MT7530 */
+	/* Disable PLL */
+	core_write(priv, CORE_GSWPLL_GRP1, 0);
 
 	/* Set core clock into 500Mhz */
 	core_write(priv, CORE_GSWPLL_GRP2,
@@ -460,11 +459,7 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 		   RG_GSWPLL_POSDIV_200M(2) |
 		   RG_GSWPLL_FBKDIV_200M(32));
 
-	/* Enable MT7530 core clock */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
-
 	/* Setup the MT7530 TRGMII Tx Clock */
-	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 	core_write(priv, CORE_PLL_GROUP5, RG_LCDDS_PCW_NCPO1(ncpo1));
 	core_write(priv, CORE_PLL_GROUP6, RG_LCDDS_PCW_NCPO0(0));
 	core_write(priv, CORE_PLL_GROUP10, RG_LCDDS_SSC_DELTA(ssc_delta));
@@ -478,6 +473,8 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
 	core_write(priv, CORE_PLL_GROUP7,
 		   RG_LCDDS_PCW_NCPO_CHG | RG_LCCDS_C(3) |
 		   RG_LCDDS_PWDB | RG_LCDDS_ISO_EN);
+
+	/* Enable MT7530 core and TRGMII Tx clocks */
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG,
 		 REG_GSWCK_EN | REG_TRGMIICK_EN);
 
-- 
2.31.0

