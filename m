Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4394EF074
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 16:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347582AbiDAOfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348167AbiDAOds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:33:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2717C292BB4;
        Fri,  1 Apr 2022 07:31:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0682B82507;
        Fri,  1 Apr 2022 14:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB6CC2BBE4;
        Fri,  1 Apr 2022 14:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823468;
        bh=AHSkIi7sAyuh9lQQb1qJyTgGEnakqQVbl7rHrpR4dG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EkvxzVjq48adhOhN4sFzSnKwzxrKLDvH1HYy5Q0pgCTfboLUNS5ExGX/h3K3dnZ6T
         DFo4Q5Lz+xKf33RMfEvjJ8SihP4IDVs3czbYsfGom1WODwPAuCJm1lwRLzxhfEOKtG
         8BgXrRjINkH4PV0WHcpFsbqxCIqNsX5fIMEVxpLrOchv7tTq9MQN76j6MnrffNcez1
         RkRz7z7XB8HXcfKJIRwYk/lYm41c8gnoVdxHToah4X3qkMLrhwtZP0C4icnstszPkk
         e6OHfZDWmqIL5IeVrMpFYD0XAN8GDMGerimpsqZ81RV713nBtqCmYtK7/QwOSMHe+W
         Xj2651UiCG0iQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, xing.song@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 103/149] mt76: mt7615: Fix assigning negative values to unsigned variable
Date:   Fri,  1 Apr 2022 10:24:50 -0400
Message-Id: <20220401142536.1948161-103-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401142536.1948161-1-sashal@kernel.org>
References: <20220401142536.1948161-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 9273ffcc9a11942bd586bb42584337ef3962b692 ]

Smatch reports the following:
drivers/net/wireless/mediatek/mt76/mt7615/mac.c:1865
mt7615_mac_adjust_sensitivity() warn: assigning (-110) to unsigned
variable 'def_th'
drivers/net/wireless/mediatek/mt76/mt7615/mac.c:1865
mt7615_mac_adjust_sensitivity() warn: assigning (-98) to unsigned
variable 'def_th'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index ec25e5a95d44..dd4ab6063440 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1835,7 +1835,7 @@ mt7615_mac_adjust_sensitivity(struct mt7615_phy *phy,
 	struct mt7615_dev *dev = phy->dev;
 	int false_cca = ofdm ? phy->false_cca_ofdm : phy->false_cca_cck;
 	bool ext_phy = phy != &dev->phy;
-	u16 def_th = ofdm ? -98 : -110;
+	s16 def_th = ofdm ? -98 : -110;
 	bool update = false;
 	s8 *sensitivity;
 	int signal;
-- 
2.34.1

