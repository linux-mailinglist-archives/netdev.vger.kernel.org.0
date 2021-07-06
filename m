Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D71CF3BCDA1
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 13:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbhGFLWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:22:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhGFLT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:19:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2389261CC8;
        Tue,  6 Jul 2021 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570227;
        bh=dnqI7cLIPgkr4vrDpYP0+IEltAy8NgRLsokYw1F1ts4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y9XqmIgJ3eHYVfNKtFQfM0Qwr70K9V1OMSJFsk8tuaWzB09P8AZPVlSGqC/zTny8d
         crIqA8ddNMqa9MJaNuaK9qphVDM3nw3W9XsuIBENO0kXX86lUB23dp1V1DRZp/1fb8
         wcFX0Km2olyvIfuYoFuK6dJWbfDfJULRBpJEhlxP/3gAm3S/s1PWwrrD8Ezg1QVAlN
         apSpkVMdzs0ABoMp5snQdPcXPgwQwlycQyw8V3y60Scp6qygAW5CRcK94LxYRzcZvL
         svceHNUHslhb959C5mYt99lkLTv7fe9fuIspSRsGZxqeZO1O4Bc7ek5DrsWWsTdQeu
         anAJ59diyljMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 132/189] mt76: mt7921: reset wfsys during hw probe
Date:   Tue,  6 Jul 2021 07:13:12 -0400
Message-Id: <20210706111409.2058071-132-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 01f7da40917923bf9d8fd8d5c9a6ed646004e47c ]

This patch fixes a mcu hang during device probe on
Marvell ESPRESSObin after a hot reboot.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/dma.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
index 71e664ee7652..a70f0bd875f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/dma.c
@@ -402,6 +402,10 @@ int mt7921_dma_init(struct mt7921_dev *dev)
 	if (ret)
 		return ret;
 
+	ret = mt7921_wfsys_reset(dev);
+	if (ret)
+		return ret;
+
 	/* init tx queue */
 	ret = mt7921_init_tx_queues(&dev->phy, MT7921_TXQ_BAND0,
 				    MT7921_TX_RING_SIZE);
-- 
2.30.2

