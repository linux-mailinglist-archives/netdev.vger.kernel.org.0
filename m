Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92A71425815
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 18:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbhJGQjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 12:39:19 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:59112
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233594AbhJGQjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 12:39:18 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id F02DB3FFF7;
        Thu,  7 Oct 2021 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633624643;
        bh=E8Q4CQuRm8cbCNJqvryKYn2lWPwQIPy9ce6P0ED1Ws8=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=Hy1U6K3zAjrKLqZNPam6gGoBVJo6eDslidugbXsiih6oupaP+9q/zTnSoF5EZftJw
         TvP+ooApQdno0VF9Kx87WqOH+VKDjCvjwd+pc6Ymc7FH9E3xYijco4dENPS7YRWZDL
         LTUjwIEStJx7f+SwDq9yJlAmTWO9dqc+o52bHiiA3F0JmAkr67rl6aPURrFITL4EjO
         qDPSBlsGXUd64N2ogb+lKivVXjgR+cGfu9IxKc/Pjjhgn9RnMjmcXSmfNX7jUrvyBG
         pH+m58gYqRPnGl6+dzTVgNoNTTS2iTaubPgK/6Ygyu22vgIuZNPuWcW9JJnE9NPbZR
         tYVWmlJHy6j2g==
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192ee: Remove redundant initialization of variable version
Date:   Thu,  7 Oct 2021 17:37:22 +0100
Message-Id: <20211007163722.20165-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable version is being initialized with a value that is
never read, it is being updated afterwards in both branches of
an if statement. The assignment is redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
index 88fa2e593fef..76189283104c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c
@@ -1430,7 +1430,7 @@ static enum version_8192e _rtl92ee_read_chip_version(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
-	enum version_8192e version = VERSION_UNKNOWN;
+	enum version_8192e version;
 	u32 value32;
 
 	rtlphy->rf_type = RF_2T2R;
-- 
2.32.0

