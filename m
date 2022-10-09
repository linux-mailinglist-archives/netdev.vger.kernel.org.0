Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553885F906C
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiJIWYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiJIWXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:23:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B2915821;
        Sun,  9 Oct 2022 15:17:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 134F9B80DE6;
        Sun,  9 Oct 2022 22:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E58C433D7;
        Sun,  9 Oct 2022 22:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353586;
        bh=5c7vIPknLGWDgnfWcLuRVY7n/9ucMfEhHISPPQPSWSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7gnCbogMvw1of1yI1FMAQo/5Xqal6X8BgSjQzqb3pasrhfst6FPHh8/jyZQI7lYO
         f9fKe890Q+CEKEmoPoOOlJ2t+P1tYHM53ZhGadL3lUKG8aPjVbOjZBbtbj7u+f2tkE
         G4BgugeW98xSGsXVjmhb8/gm61GZ5DvARRSTOUImYD5Ycj/AfMs3eJC5IIbioJFpeT
         Fz2yvq0RLjTY2kVwJRq34OyAsTdbr1hbNuEoLwAHGbJhhIJRcs3OUwMuJGsyZ19lI5
         EUAW0TWnrUuFiyyIOhMA7Sy/QI0PTm3i+n4AmMUi7nPDIE0gV+n5LtmSKVHJedqh/G
         g48pANAAEyMkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 65/77] wifi: rt2x00: set SoC wmac clock register
Date:   Sun,  9 Oct 2022 18:07:42 -0400
Message-Id: <20221009220754.1214186-65-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009220754.1214186-1-sashal@kernel.org>
References: <20221009220754.1214186-1-sashal@kernel.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit cbde6ed406a51092d9e8a2df058f5f8490f27443 ]

Instead of using the default value 33 (pci), set US_CYC_CNT init based
on Programming guide:
If available, set chipset bus clock with fallback to cpu clock/3.

Reported-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/3e275d259f476f597dab91a9c395015ef3fe3284.1663445157.git.daniel@makrotopia.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/ralink/rt2x00/rt2800lib.c    | 21 +++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index fec85db7dbc7..b30b062243bb 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -6131,6 +6131,27 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		reg = rt2800_register_read(rt2x00dev, US_CYC_CNT);
 		rt2x00_set_field32(&reg, US_CYC_CNT_CLOCK_CYCLE, 125);
 		rt2800_register_write(rt2x00dev, US_CYC_CNT, reg);
+	} else if (rt2x00_is_soc(rt2x00dev)) {
+		struct clk *clk = clk_get_sys("bus", NULL);
+		int rate;
+
+		if (IS_ERR(clk)) {
+			clk = clk_get_sys("cpu", NULL);
+
+			if (IS_ERR(clk)) {
+				rate = 125;
+			} else {
+				rate = clk_get_rate(clk) / 3000000;
+				clk_put(clk);
+			}
+		} else {
+			rate = clk_get_rate(clk) / 1000000;
+			clk_put(clk);
+		}
+
+		reg = rt2800_register_read(rt2x00dev, US_CYC_CNT);
+		rt2x00_set_field32(&reg, US_CYC_CNT_CLOCK_CYCLE, rate);
+		rt2800_register_write(rt2x00dev, US_CYC_CNT, reg);
 	}
 
 	reg = rt2800_register_read(rt2x00dev, HT_FBK_CFG0);
-- 
2.35.1

