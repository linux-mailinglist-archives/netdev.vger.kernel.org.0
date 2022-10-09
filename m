Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995E95F92CC
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbiJIWvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbiJIWtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:49:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65771476C5;
        Sun,  9 Oct 2022 15:26:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B61E60C34;
        Sun,  9 Oct 2022 22:24:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40947C433D7;
        Sun,  9 Oct 2022 22:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354245;
        bh=29BCPCbZfYMbwNEpy/5MBOlEcHtdxVBIrRAdPeoNTg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fj2iME+idBNwfkGILfy3+wNE9GFCl2dU4p4iHQLHGkb8Hyh3byWpTw7LmTVJtFUsa
         exmtaOSJFRrhuOgMZ+w+PdHz3hBao4S6Bnonu5ZMuJaqanPBFe00+Q6BL71P1x4Id2
         +9HVGMJW0K+etiZxWIo15YupcG/cHOUg/gld2IakazJ5mJRLvCf4Vlt+Y7uAAIcN0h
         89OMVjUPU/Zsnk4lNXO4nx9SFQoX70YIPhUyHZEIKWv9rEMmnTJ1SpO5Y5xTS+/KOW
         Kp0ED99enfPhMGGUeXgYkYcDxYqNtx6xY0/zoVNWdJkkkZRRWsChMfgD55oRhpW/5P
         mVRoVveuyQhGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        stf_xl@wp.pl, helmut.schaa@googlemail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/29] wifi: rt2x00: don't run Rt5592 IQ calibration on MT7620
Date:   Sun,  9 Oct 2022 18:22:56 -0400
Message-Id: <20221009222304.1218873-21-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222304.1218873-1-sashal@kernel.org>
References: <20221009222304.1218873-1-sashal@kernel.org>
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
index c99f1912e266..9b56a4df2e94 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -4355,7 +4355,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		reg = (rf->channel <= 14 ? 0x1c : 0x24) + 2*rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
 
-		rt2800_iq_calibrate(rt2x00dev, rf->channel);
+		if (rt2x00_rt(rt2x00dev, RT5592))
+			rt2800_iq_calibrate(rt2x00dev, rf->channel);
 	}
 
 	bbp = rt2800_bbp_read(rt2x00dev, 4);
-- 
2.35.1

