Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C275381CE
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240620AbiE3OT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241390AbiE3ORd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:17:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 593A58FFAE;
        Mon, 30 May 2022 06:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B3C5B80D89;
        Mon, 30 May 2022 13:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C0CC3411A;
        Mon, 30 May 2022 13:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918363;
        bh=YjcHEhCxy8AQgAgWf5d6Py/JLOr5IKgh0bz0IGQIrzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bF4YDI83Mi95WcUNiuxvx8CpC4lkVaQm28dwC2KGozZ9BHnir5Joz/DGNIIjCeaKt
         aSxFN2+r0SyI3nzGd+XQLVgDTNptEPOrCqoomQEBKoH2X4w8QzgVXq4VWtHMrj2G2r
         +KGfFmByibTxeL/M/L4LVEfgKFE8lg2R+FUCJQWLAIPlV6M+JGLltvlO0sYPTlYpLl
         JyeXf2lns/ySps2PWg3ZQSVd+UO3fZ/KUXmaeo/FGUs9EHgUFamvAUWv2lmINqswzd
         cXRJzFvcTLP+HzGI5knkpuAu4Lzj/qhWkzMMVlByE6BOxcOwSnOHu/RKZTtPm8usgr
         TmjT2o/fSZPag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        pkshih@realtek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 54/76] rtlwifi: Use pr_warn instead of WARN_ONCE
Date:   Mon, 30 May 2022 09:43:44 -0400
Message-Id: <20220530134406.1934928-54-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit ad732da434a2936128769216eddaece3b1af4588 ]

This memory allocation failure can be triggered by fault injection or
high pressure testing, resulting a WARN.

Fix this by replacing WARN with pr_warn.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220511014453.1621366-1-dzm91@hust.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 06e073defad6..c6e4fda7e431 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1015,7 +1015,7 @@ int rtl_usb_probe(struct usb_interface *intf,
 	hw = ieee80211_alloc_hw(sizeof(struct rtl_priv) +
 				sizeof(struct rtl_usb_priv), &rtl_ops);
 	if (!hw) {
-		WARN_ONCE(true, "rtl_usb: ieee80211 alloc failed\n");
+		pr_warn("rtl_usb: ieee80211 alloc failed\n");
 		return -ENOMEM;
 	}
 	rtlpriv = hw->priv;
-- 
2.35.1

