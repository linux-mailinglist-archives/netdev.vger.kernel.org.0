Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD12658D96F
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 15:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242718AbiHINf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 09:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235660AbiHINf6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 09:35:58 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1311012;
        Tue,  9 Aug 2022 06:35:57 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id f30so10424829pfq.4;
        Tue, 09 Aug 2022 06:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=tGbfSymHJ+zxuolTJeDnvn9lzIe0OwQIg8yMo09fobQ=;
        b=SxeL4oMkbs91TTe014uyXFykJHKU9/1Aqpcimyt1wM44ts92liZQyV7SlDhgr3S4TD
         4tqUJDSFBxurNQ//KNNWEcpUWFLKMil/sDLu117bVFl8dzCGkiLgzCDrl3LaEp3WLKo/
         Yi+lAQePzMSHce1/Z84t+jZSAkdYV3DZUR83zmajPd5kpaUFWP1tSXnm+dgqmp+sxhFg
         atF6gAoXkwo29eggDTfjpWdS0pZNsvcTWXiCsfVAWqpp0wp32pNmAStakhn5SlxrcGBZ
         lFu8N2T/x6si0XaYIh10+ZWBAOJa8gOnYDQeHIJ0YEM/pOhnTlUtBTpLkHADZwpl7JAm
         IVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=tGbfSymHJ+zxuolTJeDnvn9lzIe0OwQIg8yMo09fobQ=;
        b=m0nXM9cHlyOtHL0EQ7FJxdghHYfD/HfjdwEdtxOOSBcWHeLmeZNl2ehP1Iw7VN/lTh
         GDsI0tPe2utzypNUUf6aAzILRohVpRScm5Kn0wB9+MpVBmAiJs2GNvKxEkfbn1Qr/28B
         kRUGliWlY0eq3c+DMnZJB4VcA/HQHz9Q4Vg4i1D5RAh1jiLEpIDeoTSPzrTbRwV9bGpQ
         TNKhU6xxumGQUv2tYYVN7Fw2MLzfXPidCJWEvYOmBOCG4kQvnqk+Y83bnFWv7S9irXEp
         qCgtM6FmkobD1FZYWh8D+FuPiuKmDBYkLDKEOH9dB4Q95JmZRcnJUzoIwgfqZRULTU6g
         Yktg==
X-Gm-Message-State: ACgBeo2kt8Os+EEA1AY8FkH146njKuDe3WIVDcYwjohxhE3NWMtcUupo
        3FqniiD473HXiPtP8IzXb7/pAZehwRf1N6To
X-Google-Smtp-Source: AA6agR5wNX9vgz02VMgAva9mLj9N6h5i0d3uDED1NVeMhsiRpwuS9Yh2L/wypOPOvWHpabpZMOnKWw==
X-Received: by 2002:a63:d117:0:b0:41a:f0ee:f194 with SMTP id k23-20020a63d117000000b0041af0eef194mr18709156pgg.588.1660052157022;
        Tue, 09 Aug 2022 06:35:57 -0700 (PDT)
Received: from pipi-desktop.testerjoe ([101.88.11.237])
        by smtp.gmail.com with ESMTPSA id g64-20020a625243000000b0052d6ad246a4sm10829525pfb.144.2022.08.09.06.35.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 06:35:56 -0700 (PDT)
From:   Linjun Bao <meljbao@gmail.com>
Cc:     meljbao@gmail.com, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] igc: Remove _I_PHY_ID check for i225 devices
Date:   Tue,  9 Aug 2022 21:35:01 +0800
Message-Id: <20220809133502.37387-1-meljbao@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Source commit 7c496de538ee ("igc: Remove _I_PHY_ID checking"),
remove _I_PHY_ID check for i225 device, since i225 devices only
have one PHY vendor.

Signed-off-by: Linjun Bao <meljbao@gmail.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c | 10 +---------
 drivers/net/ethernet/intel/igc/igc_main.c |  3 +--
 drivers/net/ethernet/intel/igc/igc_phy.c  |  6 ++----
 3 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index db289bcce21d..d66429eb14a5 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -187,15 +187,7 @@ static s32 igc_init_phy_params_base(struct igc_hw *hw)
 
 	igc_check_for_copper_link(hw);
 
-	/* Verify phy id and set remaining function pointers */
-	switch (phy->id) {
-	case I225_I_PHY_ID:
-		phy->type	= igc_phy_i225;
-		break;
-	default:
-		ret_val = -IGC_ERR_PHY;
-		goto out;
-	}
+	phy->type = igc_phy_i225;
 
 out:
 	return ret_val;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9ba05d9aa8e0..b8297a63a7fd 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2884,8 +2884,7 @@ bool igc_has_link(struct igc_adapter *adapter)
 		break;
 	}
 
-	if (hw->mac.type == igc_i225 &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (hw->mac.type == igc_i225) {
 		if (!netif_carrier_ok(adapter->netdev)) {
 			adapter->flags &= ~IGC_FLAG_NEED_LINK_UPDATE;
 		} else if (!(adapter->flags & IGC_FLAG_NEED_LINK_UPDATE)) {
diff --git a/drivers/net/ethernet/intel/igc/igc_phy.c b/drivers/net/ethernet/intel/igc/igc_phy.c
index 6156c76d765f..1be112ce6774 100644
--- a/drivers/net/ethernet/intel/igc/igc_phy.c
+++ b/drivers/net/ethernet/intel/igc/igc_phy.c
@@ -235,8 +235,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 			return ret_val;
 	}
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID) {
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL) {
 		/* Read the MULTI GBT AN Control Register - reg 7.32 */
 		ret_val = phy->ops.read_reg(hw, (STANDARD_AN_REG_MASK <<
 					    MMD_DEVADDR_SHIFT) |
@@ -376,8 +375,7 @@ static s32 igc_phy_setup_autoneg(struct igc_hw *hw)
 		ret_val = phy->ops.write_reg(hw, PHY_1000T_CTRL,
 					     mii_1000t_ctrl_reg);
 
-	if ((phy->autoneg_mask & ADVERTISE_2500_FULL) &&
-	    hw->phy.id == I225_I_PHY_ID)
+	if (phy->autoneg_mask & ADVERTISE_2500_FULL)
 		ret_val = phy->ops.write_reg(hw,
 					     (STANDARD_AN_REG_MASK <<
 					     MMD_DEVADDR_SHIFT) |
-- 
2.25.1

