Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726B5374278
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbhEEQq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:50934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235711AbhEEQow (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:44:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E674A6187E;
        Wed,  5 May 2021 16:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232529;
        bh=8yJkIxt9x7tQEgrOODyGrEM6YzQvSvK7Fau7oWoTmiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D6yFZrE84o9jtEu5oHgPB9dFewA50dmyoEFmwulKI+cNTrkxop5phc1FRy7mXEHJi
         hlUgW/NwBP4+BHJTmSFkFcUAePhfXfUqrcYu477c4LQqOAuAM++P3r/H4TMIXt+Asi
         yvaxLNc6Y9N11WoZ5PPp+JqgH6IzCuMZr9ZNuHykdo1UxWJ91yTubevXx2BSw9LXN1
         TEDKUmngsdRMd/nnS05h8Jd2ILxI2jNetozzHSIoxZ8vDlWTM8KkS7k81TaNY3lP4S
         PF44n0aB97SvoNnRL9Y2cD4ucAcQAWCM0GZDnsWPYGm6kPUtUP3u6M6dWUCmQKWOs8
         cwvIRwq6iRk4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sander Vanheule <sander@svanheule.net>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Stijn Segers <foss@volatilesystems.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 052/104] mt76: mt7615: support loading EEPROM for MT7613BE
Date:   Wed,  5 May 2021 12:33:21 -0400
Message-Id: <20210505163413.3461611-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
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
index 3232ebd5eda6..a31fa2017f52 100644
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

