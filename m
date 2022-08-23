Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1FD859D0F6
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 08:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240548AbiHWGCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 02:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240549AbiHWGCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 02:02:10 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C05405FF49;
        Mon, 22 Aug 2022 23:02:09 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id x19so11911998plc.5;
        Mon, 22 Aug 2022 23:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=NvGvQzFB0ozvqye6TlBt72hA2XeFJRaYoqL5R2NvJN4=;
        b=aa/FNbu286jkKwQUjQcjg9brlMPdJPy3a0j7sSMc5yBNcqKaULuazPcfi1utZeBd7y
         8W3LVRBQkO2Fwk+HU3FuwZv4qb0jPDbtNWo5EGAK+Z2x8cKmtM2fpc9X8DJ+/3f9ySi6
         f99kaKrXeG0WyfwP+v6LVEgx6VT9bUEmSMTzajrwTolXODCLgBqntbcKr0EvmFUJ0B7q
         CnEc5erBc6sMpOWBLG4B10s2bhc7PPUkEM/lqzVejQjEx4PWPv23WGbeMsi9D3qgr90Q
         uBk80UHIz+M8pzlUO/q5FlbH8eoNEw+Od3XWENwexrBdUa1Fp4aXNS5YIqPErWqOjN6a
         fThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=NvGvQzFB0ozvqye6TlBt72hA2XeFJRaYoqL5R2NvJN4=;
        b=sbbkw0zSLQvWJtP9qFnQBRf72lkRFew/obrKkRat/0nitSZLi17KxwGpxAyq7K1Fps
         GZERcJM7PHaC0LOu3U1cYJs+Sl6ZPnNvP+UAMffyVppSuUoeOM0H599FYxnHFI5jvwT6
         mVV3VbE4/TEVEQbYi/hg9dO7Ryzq8UY7Z4HsE1PNX9Pc7JRzoTzaU9JHwRwAu+0fkHwV
         6XNbUzprkM7KS4/yccSIHTeo2lQ9P2mIaM4hK4bfYml/tTXU6dJM9NpEQyqNq6QZ+DyA
         PspdGRMRtn4Edeet3OPKnI2X+dHANMLWx53MfIFzn+ua/XuzZX+ocfIy6/fA8/msLoYw
         J7Sw==
X-Gm-Message-State: ACgBeo2ozBE2BmLHe//RNAbDfC6z6wkwNo1qgXErUy4GBkusruztb7/m
        4AmbH5NKmClV/CWa16DHyBM=
X-Google-Smtp-Source: AA6agR4rPYAjCopNScCV/Bn5ZXnNtyPRlX60jgns2XshzEnrty3ZT9jOXB1FU02tMb0QA815eeaUiA==
X-Received: by 2002:a17:902:9341:b0:172:775e:9573 with SMTP id g1-20020a170902934100b00172775e9573mr23469570plp.128.1661234528811;
        Mon, 22 Aug 2022 23:02:08 -0700 (PDT)
Received: from localhost.localdomain (lily-optiplex-3070.dynamic.ucsd.edu. [2607:f720:1300:3033::1:4dd])
        by smtp.googlemail.com with ESMTPSA id oc9-20020a17090b1c0900b001f56a5e5d2fsm736059pjb.2.2022.08.22.23.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 23:02:08 -0700 (PDT)
From:   lily <floridsleeves@gmail.com>
To:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lily <floridsleeves@gmail.com>
Subject: [PATCH v1] drivers/net/ethernet: check return value of e1e_rphy()
Date:   Mon, 22 Aug 2022 23:02:00 -0700
Message-Id: <20220823060200.1452663-1-floridsleeves@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

e1e_rphy() could return error value, which need to be checked.

Signed-off-by: Li Zhong <floridsleeves@gmail.com>
---
 drivers/net/ethernet/intel/e1000e/phy.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
index fd07c3679bb1..15ac302fdee0 100644
--- a/drivers/net/ethernet/intel/e1000e/phy.c
+++ b/drivers/net/ethernet/intel/e1000e/phy.c
@@ -2697,9 +2697,12 @@ static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
 void e1000_power_up_phy_copper(struct e1000_hw *hw)
 {
 	u16 mii_reg = 0;
+	int ret;
 
 	/* The PHY will retain its settings across a power down/up cycle */
-	e1e_rphy(hw, MII_BMCR, &mii_reg);
+	ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
+	if (ret)
+		return ret;
 	mii_reg &= ~BMCR_PDOWN;
 	e1e_wphy(hw, MII_BMCR, mii_reg);
 }
@@ -2715,9 +2718,12 @@ void e1000_power_up_phy_copper(struct e1000_hw *hw)
 void e1000_power_down_phy_copper(struct e1000_hw *hw)
 {
 	u16 mii_reg = 0;
+	int ret;
 
 	/* The PHY will retain its settings across a power down/up cycle */
-	e1e_rphy(hw, MII_BMCR, &mii_reg);
+	ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
+	if (ret)
+		return ret;
 	mii_reg |= BMCR_PDOWN;
 	e1e_wphy(hw, MII_BMCR, mii_reg);
 	usleep_range(1000, 2000);
@@ -3037,7 +3043,9 @@ s32 e1000_link_stall_workaround_hv(struct e1000_hw *hw)
 		return 0;
 
 	/* Do not apply workaround if in PHY loopback bit 14 set */
-	e1e_rphy(hw, MII_BMCR, &data);
+	ret_val = e1e_rphy(hw, MII_BMCR, &data);
+	if (ret_val)
+		return ret_val;
 	if (data & BMCR_LOOPBACK)
 		return 0;
 
-- 
2.25.1

