Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF411FA623
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfKMBvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 20:51:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727505AbfKMBvB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 20:51:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78F85222D3;
        Wed, 13 Nov 2019 01:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609860;
        bh=cSP2I36sgXizIVf9FnNRZCxT9E+EkRMfG2cJCSFnRmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hzXlZLa4mt9tPTQ8oeWRy2OuwyuWhUIBSfNH9qg4j0r8ZvVbveBKhp/8zFivbHQsp
         /dKCnaz9YFOg0YMJ5JQm5BJeQ7MGXCYHhxRqP1cip53o/M6VbCvKfOjViywct74foT
         Qg9PodwtuDWjH9FSz4uLYhLJpId0qoox+ztAczOE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 026/209] rtlwifi: btcoex: Use proper enumerated types for Wi-Fi only interface
Date:   Tue, 12 Nov 2019 20:47:22 -0500
Message-Id: <20191113015025.9685-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 31138a827d1b3d6e4855bddb5a1e44e7b32309c0 ]

Clang warns when one enumerated type is implicitly converted to another.

drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1327:34:
warning: implicit conversion from enumeration type 'enum
btc_chip_interface' to different enumeration type 'enum
wifionly_chip_interface' [-Wenum-conversion]
                wifionly_cfg->chip_interface = BTC_INTF_PCI;
                                             ~ ^~~~~~~~~~~~
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1330:34:
warning: implicit conversion from enumeration type 'enum
btc_chip_interface' to different enumeration type 'enum
wifionly_chip_interface' [-Wenum-conversion]
                wifionly_cfg->chip_interface = BTC_INTF_USB;
                                             ~ ^~~~~~~~~~~~
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c:1333:34:
warning: implicit conversion from enumeration type 'enum
btc_chip_interface' to different enumeration type 'enum
wifionly_chip_interface' [-Wenum-conversion]
                wifionly_cfg->chip_interface = BTC_INTF_UNKNOWN;
                                             ~ ^~~~~~~~~~~~~~~~
3 warnings generated.

Use the values from the correct enumerated type, wifionly_chip_interface.

BTC_INTF_UNKNOWN = WIFIONLY_INTF_UNKNOWN = 0
BTC_INTF_PCI = WIFIONLY_INTF_PCI = 1
BTC_INTF_USB = WIFIONLY_INTF_USB = 2

Link: https://github.com/ClangBuiltLinux/linux/issues/135
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c   | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
index b026e80940a4d..6fbf8845a2ab6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
@@ -1324,13 +1324,13 @@ bool exhalbtc_initlize_variables_wifi_only(struct rtl_priv *rtlpriv)
 
 	switch (rtlpriv->rtlhal.interface) {
 	case INTF_PCI:
-		wifionly_cfg->chip_interface = BTC_INTF_PCI;
+		wifionly_cfg->chip_interface = WIFIONLY_INTF_PCI;
 		break;
 	case INTF_USB:
-		wifionly_cfg->chip_interface = BTC_INTF_USB;
+		wifionly_cfg->chip_interface = WIFIONLY_INTF_USB;
 		break;
 	default:
-		wifionly_cfg->chip_interface = BTC_INTF_UNKNOWN;
+		wifionly_cfg->chip_interface = WIFIONLY_INTF_UNKNOWN;
 		break;
 	}
 
-- 
2.20.1

