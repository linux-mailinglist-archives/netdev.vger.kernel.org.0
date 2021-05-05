Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A455D374437
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235763AbhEEQzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235582AbhEEQvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:51:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5647361973;
        Wed,  5 May 2021 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232669;
        bh=PYEZy+o/d4XEqCxocBCi/YNgBQBtU3X4yF0Be6Eo66o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJX880rx0iwxtzGahorW7m1h0RFnWagvKiSoDuxEFPqdxvm4VK+we2aB0XU9Y2xuA
         YxUrq06/Vh6UL7fwSO+lStcC1YBcbhtAwadZfnBnOwbkWW9SYJFqqkKB/0jBdDbZ8O
         v023KSSX7frzD8tpfU5SBUOWosv2ymQ/OUNl3EP7x2jo3iPwYO0Dct6Ccv9xzd29lP
         aUXazPuEicT02FI+xnWIPS/VwPqQj8uen3b6Ssktbxz1JunWgCl3G0dHV66yamufCg
         Jsyz/t81RECsmQMpzkSqpyhDWP/3CKSo4Lz1FGnOyaIOLPmIIdg80grY6IB4nsLXt+
         w33RP5ZRPTaeA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sander Vanheule <sander@svanheule.net>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Stijn Segers <foss@volatilesystems.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 41/85] mt76: mt7615: support loading EEPROM for MT7613BE
Date:   Wed,  5 May 2021 12:36:04 -0400
Message-Id: <20210505163648.3462507-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 858ebf446bee7d5077bd99488aae617908c3f4fe ]

EEPROM blobs for MT7613BE radios start with (little endian) 0x7663,
which is also the PCI device ID for this device. The EEPROM is required
for the radio to work at useful power levels, otherwise only the lowest
power level is available.

Suggested-by: Georgi Vlaev <georgi.vlaev@konsulko.com>
Tested-by: Stijn Segers <foss@volatilesystems.org>
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index f4756bb946c3..e9cdcdc54d5c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -86,6 +86,7 @@ static int mt7615_check_eeprom(struct mt76_dev *dev)
 	switch (val) {
 	case 0x7615:
 	case 0x7622:
+	case 0x7663:
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.30.2

