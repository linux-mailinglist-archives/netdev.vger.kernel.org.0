Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7736F3F0781
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhHRPHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235131AbhHRPHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:07:36 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03F0C061764;
        Wed, 18 Aug 2021 08:07:01 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id y34so5294815lfa.8;
        Wed, 18 Aug 2021 08:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hpXTPXK1ibNyRndd2z4OxzfYUmUkDAM0OJ5r1uqfGjw=;
        b=Lnby+xsvPy5y/+y/cRXf1EQaqsXKlWFS0cky80HAYrRYVQVy8eqTbjYWicQuzisYA+
         uwjAdyx1kNqoM5F55YZ1fZkDctN5X128018xYz9wVqfSk7JXbEaZ4Uhrbjl8DlIjEFZ6
         7FM4NjKn8Vxrmg1ojsBbPFZ89XF5cyOiw6S1/vKqRf8hJNYDQaLKd72L+K7Yi+0WPjlJ
         rN2xjezJ/+2LfGHyVDjTtlkXYdMb/9mMSeawQZV87M1PyF366luRkeiio5q8F5SBQ78I
         etNem7u2LoBeZVsB+0cxWgxWcQronQGCMxe/wCHVn8Roy6QsaO9gJ9n0FuS3juZEuHpo
         UAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hpXTPXK1ibNyRndd2z4OxzfYUmUkDAM0OJ5r1uqfGjw=;
        b=sT2m9xaPRf240uPjM0dtKx9KQIoZTzJHeZHbMPJpSZsgm5v05MYC7xxY6Tat+GgY7p
         Mv8x05xXLzyKskm8q2gaf4hOaBcSu1VIow5aY5hT7xgyovyrEfb3f5ORXJQDs7Muf3Ds
         Cv8h1II6/RWJGDnDgJWdufjPX3gUWGXYS9OVZvwu4kcRRvC69MWT22og9MyU9O/CuAVm
         kKctvcwNzao+bPdnuA04r/hl+0ww79/uPOsJK1NgrdpKE/TOe+tN1iBLuDXgEI0qxIcE
         7JiVIPFrdpuDrfE+4zrqbilBz1xNvUc8w+2EfwabT212UT025a2ibPPTM/65PKlnE60S
         u8PA==
X-Gm-Message-State: AOAM5307FYED4ZYyJiy44ALWTfZv6XjLK66f5OtMSf5U8ltIhHwIdNSB
        QlEq9Fi6glyvJl019V9NyOw=
X-Google-Smtp-Source: ABdhPJzCOWLA8LkvS1HCGXpzALuQrjOzmyeSXstCJmQqthtbcgF8x1zP9tMIe4OYOOtMS7EcwL4Weg==
X-Received: by 2002:a19:2d0e:: with SMTP id k14mr6573783lfj.409.1629299219839;
        Wed, 18 Aug 2021 08:06:59 -0700 (PDT)
Received: from localhost.localdomain ([46.235.66.127])
        by smtp.gmail.com with ESMTPSA id f14sm13489ljk.42.2021.08.18.08.06.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 08:06:59 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        andriy.shevchenko@linux.intel.com, christophe.jaillet@wanadoo.fr,
        kaixuxia@tencent.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>
Subject: [PATCH v3 1/2] net: pch_gbe: remove mii_ethtool_gset() error handling
Date:   Wed, 18 Aug 2021 18:06:30 +0300
Message-Id: <7e8946ac52de91a963beb7fa0354a19a21c5cf73.1629298981.git.paskripkin@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <YR0gTWn4G0xkekxF@smile.fi.intel.com>
References: <YR0gTWn4G0xkekxF@smile.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mii_ethtool_gset() does not return any errors, so error handling can be
omitted to make code more simple.

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---

Changes in v3:
	No changes

Changes in v2:
	inverted the order of patches

---
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 8 +-------
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c  | 4 +---
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index e351f3d1608f..539bddfab2d4 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -1031,13 +1031,7 @@ static void pch_gbe_watchdog(struct timer_list *t)
 		struct ethtool_cmd cmd = { .cmd = ETHTOOL_GSET };
 		netdev->tx_queue_len = adapter->tx_queue_len;
 		/* mii library handles link maintenance tasks */
-		if (mii_ethtool_gset(&adapter->mii, &cmd)) {
-			netdev_err(netdev, "ethtool get setting Error\n");
-			mod_timer(&adapter->watchdog_timer,
-				  round_jiffies(jiffies +
-						PCH_GBE_WATCHDOG_PERIOD));
-			return;
-		}
+		mii_ethtool_gset(&adapter->mii, &cmd);
 		hw->mac.link_speed = ethtool_cmd_speed(&cmd);
 		hw->mac.link_duplex = cmd.duplex;
 		/* Set the RGMII control. */
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c
index ed832046216a..3426f6fa2b57 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_phy.c
@@ -301,9 +301,7 @@ void pch_gbe_phy_init_setting(struct pch_gbe_hw *hw)
 	int ret;
 	u16 mii_reg;
 
-	ret = mii_ethtool_gset(&adapter->mii, &cmd);
-	if (ret)
-		netdev_err(adapter->netdev, "Error: mii_ethtool_gset\n");
+	mii_ethtool_gset(&adapter->mii, &cmd);
 
 	ethtool_cmd_speed_set(&cmd, hw->mac.link_speed);
 	cmd.duplex = hw->mac.link_duplex;
-- 
2.32.0

