Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84125F9116
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiJIWa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiJIW1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:27:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0221B85D;
        Sun,  9 Oct 2022 15:18:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3146AB80DDD;
        Sun,  9 Oct 2022 22:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A9FC433D7;
        Sun,  9 Oct 2022 22:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353902;
        bh=F5C9xZeKmsTJNbgIxGRpnScpQISfkO8XGRXBB5xjG3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBkt+ZT8uNStTKgysnK7x2lw0rxzq82IRVk7aJmGtgzvbFMiwbbsbyz0e6SaiqaFo
         9z6c9mKqHGz/XRfyHyEFlfoqb4AjdbXyTDXVF88WzIgcB8q8tFh1xu1zw00/SbGDd8
         UcNm/D7bJpMWxP1hDIuavIjcHIqNWKHj8NwaB1bKZNAO04U+VoJUJNfKUBrvVQvknS
         Sy41wX2MeTWWTAWMhYa0D8hnPlOQ5vQCKp7AfaHGeLnP6+NjyGuQk+mfnsG/1jBCxs
         ekR5cJfw6q6QxdWMzOFuMKBYkr7dXxk+Qbdu47t0d1jVl4ZHdR0XQ5HAbc/dFj67CP
         1zhUfeawJF6aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        stf_xl@wp.pl, helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 58/73] wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
Date:   Sun,  9 Oct 2022 18:14:36 -0400
Message-Id: <20221009221453.1216158-58-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
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
index cbdaf7992f98..b4fb4d1bff57 100644
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

