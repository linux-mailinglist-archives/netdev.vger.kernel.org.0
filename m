Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B065F8FF0
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:19:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiJIWTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiJIWSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:18:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D133718B;
        Sun,  9 Oct 2022 15:15:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58AEB60CF5;
        Sun,  9 Oct 2022 22:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D7AC433B5;
        Sun,  9 Oct 2022 22:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353578;
        bh=Nf/HQ7h/Z5nwQBjoAMYb7EpY/DT/8776VVnjScGaUA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jxFEvVpMUVk8AJkCSABuYUZfmm1ZMekSytRECLhu8BvgZYbpSTBTmiV2baojPz+IF
         xDTzcYoWJ+HZDEQ74Rd5WRhaG/nqSl0fMx2I2uTnWUFl90KRnfCcLuWqLPMQw6qdvh
         vxTk6o2+LEmBuMWJxkmcTL5VdWElsSvbPRzKy63apBSlDOz7IrYV8uucf2AFw6yTi+
         UoxgvabFCa1NACHFbUP5gFMj2+xQ22iTvELQuRuQYQvYawwB7z8eBBanQ47lAw3hci
         VBx39vdHED6tu70IgvQxPVOHgrY80vZpoH7HzmVoDJ56f+F3V+L2IrUznnkk0xzjV/
         6xsFLdeI+KNSQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        stf_xl@wp.pl, helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 62/77] wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
Date:   Sun,  9 Oct 2022 18:07:39 -0400
Message-Id: <20221009220754.1214186-62-sashal@kernel.org>
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

[ Upstream commit d3aad83d05aec0cfd7670cf0028f2ad4b81de92e ]

The function rt2800_iq_calibrate is intended for Rt5592 only.
Don't call it for MT7620 which has it's own calibration functions.

Reported-by: Serge Vasilugin <vasilugin@yandex.ru>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/31a1c34ddbd296b82f38c18c9ae7339059215fdc.1663445157.git.daniel@makrotopia.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 18102fbe36d6..de81b6060359 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4365,7 +4365,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2*rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
 
-		rt2800_iq_calibrate(rt2x00dev, rf->channel);
+		if (rt2x00_rt(rt2x00dev, RT5592))
+			rt2800_iq_calibrate(rt2x00dev, rf->channel);
 	}
 
 	bbp = rt2800_bbp_read(rt2x00dev, 4);
-- 
2.35.1

