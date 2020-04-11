Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8790D1A59A9
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730836AbgDKXiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728822AbgDKXIE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:08:04 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19243214D8;
        Sat, 11 Apr 2020 23:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646484;
        bh=vr0eU8N+DcfIEeHCMZcV+a3ZvG1NoSo5bc/6p6NwcV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jePnjNFEmT8PAv33ZVabp+i6/dAGjrKSygxzyR0rVDFpgyktpy9qlrfx0ATqeqr6H
         +jB92hg0fD6YdNc+3RL9EK0IVNC9W28m0SfZ61v/85NWxUv2XuEx6NEIHyt6m+MIFV
         TSTRcgwPvzQcGp1l9MvoNycEh5sx3jJYezWdLZlA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.5 049/121] mt76: mt7615: disable 5 GHz on MT7622
Date:   Sat, 11 Apr 2020 19:05:54 -0400
Message-Id: <20200411230706.23855-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit c3ad5e9d00af19c53dec1d8ae647a78ac377b593 ]

It is not supported by the chip, so avoid issues with potentially wrong
EEPROM configurations.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index 17e277bf39e0f..cb05a07135a03 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -111,6 +111,9 @@ static void mt7615_eeprom_parse_hw_cap(struct mt7615_dev *dev)
 		break;
 	}
 
+	if (is_mt7622(&dev->mt76))
+		dev->mt76.cap.has_5ghz = false;
+
 	/* read tx-rx mask from eeprom */
 	val = mt76_rr(dev, MT_TOP_STRAP_STA);
 	max_nss = val & MT_TOP_3NSS ? 3 : 4;
-- 
2.20.1

