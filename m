Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9798813F89B
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437556AbgAPTTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:19:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731611AbgAPQyM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E86812176D;
        Thu, 16 Jan 2020 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193651;
        bh=OzFODw4fgcmPhpz8E8cgdKYNHhUMu9ketHJs8OPWZQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7ifsK/NcQq8eYKGbGo/0xDU7rp/wLTiVeRLW/B0Ofg6KoujqKPNzFGY/3z9vSM3R
         eR6gxRXOEin3hNHlb95Ykf3xySSkexWancXvfpJQ3j8nF4W4YDYCUKbmAOKskOrlR7
         5CoKFzUR1aQn+Sq8EMvlY+Zik2MpPySEY1txYZso=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 181/205] ath9k: use iowrite32 over __raw_writel
Date:   Thu, 16 Jan 2020 11:42:36 -0500
Message-Id: <20200116164300.6705-181-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit 22d0d5ae7a089967e9295a06694aa3e8a812b15e ]

This patch changes the ath9k_pci_owl_loader to use the
same iowrite32 memory accessor that ath9k_pci is using
to communicate with the PCI(e) chip.

This will fix endian issues that came up during testing
with loaned AVM Fritz!Box 7360 (Lantiq MIPS SoCs + AR9287).

Fixes: 5a4f2040fd07 ("ath9k: add loader for AR92XX (and older) pci(e)")
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c b/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
index 159490f5a111..60731e07f681 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
+++ b/drivers/net/wireless/ath/ath9k/ath9k_pci_owl_loader.c
@@ -84,7 +84,7 @@ static int ath9k_pci_fixup(struct pci_dev *pdev, const u16 *cal_data,
 			val = swahb32(val);
 		}
 
-		__raw_writel(val, mem + reg);
+		iowrite32(val, mem + reg);
 		usleep_range(100, 120);
 	}
 
-- 
2.20.1

