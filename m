Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D69640B88F
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhINUBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 16:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233937AbhINUBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 16:01:08 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E99C061762;
        Tue, 14 Sep 2021 12:59:50 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4H8Dhh4hKbzQkBj;
        Tue, 14 Sep 2021 21:59:48 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
From:   =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 9/9] mwifiex: Fix copy-paste mistake when creating virtual interface
Date:   Tue, 14 Sep 2021 21:59:09 +0200
Message-Id: <20210914195909.36035-10-verdre@v0yd.nl>
In-Reply-To: <20210914195909.36035-1-verdre@v0yd.nl>
References: <20210914195909.36035-1-verdre@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC866188F
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BSS priority here for a new P2P_CLIENT device was accidentally set
to an enum that's certainly not meant for this. Since
MWIFIEX_BSS_ROLE_STA is 0 anyway, we can just set the bss_priority to 0
instead here.

Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 0eb31201a82b..d62a20de3ada 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -3054,7 +3054,7 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 		priv->bss_type = MWIFIEX_BSS_TYPE_P2P;
 
 		priv->frame_type = MWIFIEX_DATA_FRAME_TYPE_ETH_II;
-		priv->bss_priority = MWIFIEX_BSS_ROLE_STA;
+		priv->bss_priority = 0;
 		priv->bss_role = MWIFIEX_BSS_ROLE_STA;
 		priv->bss_started = 0;
 
-- 
2.31.1

