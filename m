Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7E8024BA4F
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730689AbgHTMFb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 08:05:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730654AbgHTMFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 08:05:04 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0079C22B4D;
        Thu, 20 Aug 2020 12:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597925103;
        bh=NJ32BmIFgihAAZhAhjKEFu2hdvQMQjj1VvlRmUqjHBs=;
        h=From:To:Cc:Subject:Date:From;
        b=Q743CPKtujSGcC+4e2ik8LeVHUPU/2B1w5nONEeqilx5rCLH9MrAGiuYC6KT3q/gW
         U0UytFKtLy+XiIA0XprDzUtuJuXNOKWGJWO8ncJkmeAZRYKf39YJS6rIdZ6NCJ9Pz2
         WmI3VlaBYWKJckJa/OZqOumdEL8zActRq4YLXlyo=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH] ath9k_htc: Do not select MAC80211_LEDS by default
Date:   Thu, 20 Aug 2020 14:04:44 +0200
Message-Id: <20200820120444.8809-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ath9k_htc driver hides all LEDs related code behind
CONFIG_MAC80211_LEDS ifdefs so it does not really require the
MAC80211_LEDS.  The code builds and works just fine.  Convert the
"select" into "imply" to allow disabling LED trigger when not needed.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/net/wireless/ath/ath9k/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index d5e9af2dddd8..5effb3886631 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -177,10 +177,10 @@ config ATH9K_HTC
 	tristate "Atheros HTC based wireless cards support"
 	depends on USB && MAC80211
 	select ATH9K_HW
-	select MAC80211_LEDS
-	select LEDS_CLASS
-	select NEW_LEDS
 	select ATH9K_COMMON
+	imply NEW_LEDS
+	imply LEDS_CLASS
+	imply MAC80211_LEDS
 	help
 	  Support for Atheros HTC based cards.
 	  Chipsets supported: AR9271
-- 
2.17.1

