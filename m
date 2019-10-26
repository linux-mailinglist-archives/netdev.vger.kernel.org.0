Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383CBE5BFB
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfJZNVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728864AbfJZNVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:21:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C6221D7F;
        Sat, 26 Oct 2019 13:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096076;
        bh=x2wnJ8OUjPAxL2CD9D+kFE/pTOwvfYrmM6VQmvOedIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQ+AhTwgBaBHKgj5iIT6q1R6/F4wA69Z46yz6Su/Q5KzVRppfW4OblA/LO+cwlAe+
         Bq7amH2WNM4yC5SBCCbencboPoyncMauF4nMWcYXG93riviA5hhwcx10xspcSVYZy2
         BppXPFh7cA+EHCvpmFKFEzV/libVMfphm7BrYzuU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 05/33] net: stmmac: gmac4+: Not all Unicast addresses may be available
Date:   Sat, 26 Oct 2019 09:20:42 -0400
Message-Id: <20191026132110.4026-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 25683bab09a70542b9f8e3e28f79b3369e56701f ]

Some setups may not have all Unicast addresses filters available. Check
the number of available filters before trying to setup it.

Fixes: 477286b53f55 ("stmmac: add GMAC4 core support")
Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 8445af580cb69..e5566c121525d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -438,7 +438,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	}
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > GMAC_MAX_PERFECT_ADDRESSES) {
+	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
 		/* Switch to promiscuous mode if more than 128 addrs
 		 * are required
 		 */
-- 
2.20.1

