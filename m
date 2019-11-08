Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C73AF4AD1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390443AbfKHMLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:11:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:52258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732937AbfKHLjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856B5222CD;
        Fri,  8 Nov 2019 11:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213157;
        bh=HImH6DBQCdYDbrYV5nm8VU8wabB9MtuWvxvVxo2aZSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLWY03XZrU6/qpf6spJqM+Ys74t8ugya9QGjZTlDl0+Os5/3S98BKdaYKl+WgEFzg
         uugyIPRHxBK13ooP5KasOksHxWEZwk5uSlmwpH7jxKyZRePAvJc6UcajOEpBiXhoHs
         bQOQyC5iYm5y7NVqZZuA+9vhrtZp/9R6PxgauueA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 064/205] rtl8187: Fix warning generated when strncpy() destination length matches the sixe argument
Date:   Fri,  8 Nov 2019 06:35:31 -0500
Message-Id: <20191108113752.12502-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

[ Upstream commit 199ba9faca909e77ac533449ecd1248123ce89e7 ]

In gcc8, when the 3rd argument (size) of a call to strncpy() matches the
length of the first argument, the compiler warns of the possibility of an
unterminated string. Using strlcpy() forces a null at the end.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
index c2d5b495c179a..c089540116fa7 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/leds.c
@@ -146,7 +146,7 @@ static int rtl8187_register_led(struct ieee80211_hw *dev,
 	led->dev = dev;
 	led->ledpin = ledpin;
 	led->is_radio = is_radio;
-	strncpy(led->name, name, sizeof(led->name));
+	strlcpy(led->name, name, sizeof(led->name));
 
 	led->led_dev.name = led->name;
 	led->led_dev.default_trigger = default_trigger;
-- 
2.20.1

