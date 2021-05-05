Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3B137412D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234977AbhEEQgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234689AbhEEQeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11F4E61411;
        Wed,  5 May 2021 16:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232364;
        bh=4vldGFku7LwfIJmSZA2/UFDmjoW0JxY2jQPXpMy7jIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HkwUGybAl+27ZYg3NjrD64Rkd0pY/Q2CyVCOmY3sUx3TXpp3elGcl0BACkP8OUa8W
         EKXC/xdIA4jV7A88J0lrYF9iTn+WB2jbEVMDOl3arm9CiJtVYzq4ExV4DX+Tc37huG
         yQCJIrIiPYV7RStYrxoofVwzNdwpwgdVNPhAi5oT5nD8sU7PXgatYWNZaHn1gTJcRY
         mf/YWUwhd+xxiVNE1s8M1LcjRDk8tHwZmaMHa/7zn1+L6INyDesUfrAt7Cdrw4sKVd
         EizrUTn/E4XRkErKdYYAlnKctfMGLpo1Cm7py2EacoJBlbwhxOvt4dYkIFGZkllYqc
         koOfDvhjmFGvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sander Vanheule <sander@svanheule.net>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Stijn Segers <foss@volatilesystems.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 057/116] mt76: mt7615: support loading EEPROM for MT7613BE
Date:   Wed,  5 May 2021 12:30:25 -0400
Message-Id: <20210505163125.3460440-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
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
index 2eab23898c77..6dbaaf95ee38 100644
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

