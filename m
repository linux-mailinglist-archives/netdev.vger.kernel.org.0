Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6664115F3D8
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404640AbgBNSPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:15:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbgBNPvr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A88F524676;
        Fri, 14 Feb 2020 15:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695506;
        bh=wKF6to/Ae7L+wJeSIQu3UCpCEcTa0xmUwfpSPCOZrZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvScXVCZZGKbdhDLBBA8Pf1/tP6aX9MO+p+8ZaCwgzXkSUkc96Hr73x+FgaAS4iqc
         p5Qp3Ws/4Bp5FgBfZMjynkEPkUM0ZTkCvcdfilJVqVylr0uTI6L3b7ndalN9MlNgOa
         S29QIkVTgPNXErNpIPm+NWd6v6U4hg0CSbaifSVU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 132/542] mt76: mt7615: fix max_nss in mt7615_eeprom_parse_hw_cap
Date:   Fri, 14 Feb 2020 10:42:04 -0500
Message-Id: <20200214154854.6746-132-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d08f3010f4a32eec3c8aa771f03a1b342a1472fa ]

Fix u8 cast reading max_nss from MT_TOP_STRAP_STA register in
mt7615_eeprom_parse_hw_cap routine

Fixes: acf5457fd99db ("mt76: mt7615: read {tx,rx} mask from eeprom")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index eccad4987ac83..17e277bf39e0f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -92,8 +92,9 @@ static int mt7615_check_eeprom(struct mt76_dev *dev)
 
 static void mt7615_eeprom_parse_hw_cap(struct mt7615_dev *dev)
 {
-	u8 val, *eeprom = dev->mt76.eeprom.data;
+	u8 *eeprom = dev->mt76.eeprom.data;
 	u8 tx_mask, rx_mask, max_nss;
+	u32 val;
 
 	val = FIELD_GET(MT_EE_NIC_WIFI_CONF_BAND_SEL,
 			eeprom[MT_EE_WIFI_CONF]);
-- 
2.20.1

