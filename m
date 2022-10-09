Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8425F940B
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 01:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbiJIXw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 19:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiJIXvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 19:51:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC2361B0A;
        Sun,  9 Oct 2022 16:23:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 051BC60DD8;
        Sun,  9 Oct 2022 22:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A674C433D7;
        Sun,  9 Oct 2022 22:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354418;
        bh=NJCqAoZMT1hBBgidJI6oolu+SE17C6YShP1K46PYaBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j5Y7iMyoFZMBBEl05QSGm9v856y6Tcph/yVpOVM9Sqs9o5jnmAMHAf9dUE8aFTI4i
         isCdlWmMaz168chVQ7anIn5RUdS7WIia6HVeugjrkUMcHwiRHsJNjg62XjeUD/b2uY
         wKMCFXkA2P36Jr5WO4SU465Ly0haMkXFkHjPpXJi6NpHZWtIh3OHcANkPvaWjQyTQe
         IOKZHS0739g/HdI+I8xeWMskE3k/f0r0zFsSbHctP35OpEThT6Ff9E3+Y0H8gW7/t2
         vuvplVd1l+c29qHOMcQTToXgS3m6m6gEa9E0UEA3nJ5F67FszRk+JOY5eH0edkvl1O
         AKMb0+VMj2uFw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/23] wifi: rt2x00: set SoC wmac clock register
Date:   Sun,  9 Oct 2022 18:25:49 -0400
Message-Id: <20221009222557.1219968-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222557.1219968-1-sashal@kernel.org>
References: <20221009222557.1219968-1-sashal@kernel.org>
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
index 0c90bf0540b9..57fa472b5c4e 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -5567,6 +5567,27 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
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

