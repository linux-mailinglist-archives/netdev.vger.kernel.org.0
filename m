Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB91E5B58
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729362AbfJZNWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728258AbfJZNWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:22:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DB4222C1;
        Sat, 26 Oct 2019 13:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096142;
        bh=/188A5AV3dmrQIx72hiPDcmOUbywvXgwVDruUKUM3fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJFJhtkJKhOphjn8a4KvqXSgtpIP2QsoloQa9EeOr7vrhh4I+DUR7g1WwuWVYknze
         8mvQbq2q13EkG034J83pFLtTe4bBeH4Fyhei/p6v2aEi4JRHBNcqhEOArNJdM6C/OI
         ZTMs7K840s28kBPYheImBeJdpSR/4obLG3cv/fjk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/21] net: stmmac: gmac4+: Not all Unicast addresses may be available
Date:   Sat, 26 Oct 2019 09:22:00 -0400
Message-Id: <20191026132217.4380-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132217.4380-1-sashal@kernel.org>
References: <20191026132217.4380-1-sashal@kernel.org>
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
index f46f2bfc2cc09..4216c0a5eaf5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -168,7 +168,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	}
 
 	/* Handle multiple unicast addresses */
-	if (netdev_uc_count(dev) > GMAC_MAX_PERFECT_ADDRESSES) {
+	if (netdev_uc_count(dev) > hw->unicast_filter_entries) {
 		/* Switch to promiscuous mode if more than 128 addrs
 		 * are required
 		 */
-- 
2.20.1

