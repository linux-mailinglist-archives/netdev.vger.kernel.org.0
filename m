Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310A86A30F2
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230522AbjBZOz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjBZOxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:53:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0281ACEB;
        Sun, 26 Feb 2023 06:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AE0F60C49;
        Sun, 26 Feb 2023 14:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5291C433EF;
        Sun, 26 Feb 2023 14:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422795;
        bh=+14XCMTWc3gY7mt1/8x0nU+oBB/YTuN02xrNh9fKVpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kdqg9RVCWDgmFbPckE6rkFwIw5ZhWjg/eSMJC5GuKeUw63oYNGYC6IoAUuRup+gje
         +ETbU2D4vpO5v4AH//nQlV87iRiE3IM0cpfPdLjzzdOi7lVfnbXvC7mrO5CbtdSa5K
         b58YVHARvopPROF+Oml4IPYAS67QAY0GVch6czOogGPrri5/7FjqTa5YRCFnVA1rz1
         Ie/d/aNkrVyPx/vz7yFJ+eeYNAgCv+Mq1y2gh5TMri+pUDm+H7ZIsBKfDQIo6CNmvx
         r3EBVma1LRPpc0LB89oIUA4/q3vus2ktTbm5r0yqRQp04+n3XeJaqbj/1Y7jBFUMOf
         s4wyS/GgyeUMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong-Zhe Yang <kevin_yang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 48/53] wifi: rtw89: debug: avoid invalid access on RTW89_DBG_SEL_MAC_30
Date:   Sun, 26 Feb 2023 09:44:40 -0500
Message-Id: <20230226144446.824580-48-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230226144446.824580-1-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit c074da21dd346e0cfef5d08b0715078d7aea7f8d ]

Only 8852C chip has valid pages on RTW89_DBG_SEL_MAC_30. To other chips,
this section is an address hole. It will lead to crash if trying to access
this section on chips except for 8852C. So, we avoid that.

Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230119063529.61563-2-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/debug.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/debug.c b/drivers/net/wireless/realtek/rtw89/debug.c
index 8297e35bfa52b..6730eea930ece 100644
--- a/drivers/net/wireless/realtek/rtw89/debug.c
+++ b/drivers/net/wireless/realtek/rtw89/debug.c
@@ -615,6 +615,7 @@ rtw89_debug_priv_mac_reg_dump_select(struct file *filp,
 	struct seq_file *m = (struct seq_file *)filp->private_data;
 	struct rtw89_debugfs_priv *debugfs_priv = m->private;
 	struct rtw89_dev *rtwdev = debugfs_priv->rtwdev;
+	const struct rtw89_chip_info *chip = rtwdev->chip;
 	char buf[32];
 	size_t buf_size;
 	int sel;
@@ -634,6 +635,12 @@ rtw89_debug_priv_mac_reg_dump_select(struct file *filp,
 		return -EINVAL;
 	}
 
+	if (sel == RTW89_DBG_SEL_MAC_30 && chip->chip_id != RTL8852C) {
+		rtw89_info(rtwdev, "sel %d is address hole on chip %d\n", sel,
+			   chip->chip_id);
+		return -EINVAL;
+	}
+
 	debugfs_priv->cb_data = sel;
 	rtw89_info(rtwdev, "select mac page dump %d\n", debugfs_priv->cb_data);
 
-- 
2.39.0

