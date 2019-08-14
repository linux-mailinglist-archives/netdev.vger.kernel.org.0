Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762FC8C753
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbfHNCRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:17:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729353AbfHNCRU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:17:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B14B20874;
        Wed, 14 Aug 2019 02:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565749039;
        bh=aZ38rz6VCA8Q/RCMofW28uLSJZbLCjFdNmOmpsDIwmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AFu0R71Rsv8leZwZ+mPMNE1wuJzsYDEolcR+Q+TJn9SVE9pVwMjDl7a2N18yjXYCv
         BJyDnoHnSfftSmRCBP2/Re7CiBoC9J3JCK31OBgUgUI1WRVkvL0DeS2Cr2y8FpvYJG
         djL1MvfYa6piT4A0x2fmp4JgFIKOc7uEvVMhBW0I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 54/68] net: stmmac: tc: Do not return a fragment entry
Date:   Tue, 13 Aug 2019 22:15:32 -0400
Message-Id: <20190814021548.16001-54-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jose Abreu <Jose.Abreu@synopsys.com>

[ Upstream commit 4a6a1385a4db5f42258a40fcd497cbfd22075968 ]

Do not try to return a fragment entry from TC list. Otherwise we may not
clean properly allocated entries.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 58ea18af9813a..37c0bc699cd9c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -37,7 +37,7 @@ static struct stmmac_tc_entry *tc_find_entry(struct stmmac_priv *priv,
 		entry = &priv->tc_entries[i];
 		if (!entry->in_use && !first && free)
 			first = entry;
-		if (entry->handle == loc && !free)
+		if ((entry->handle == loc) && !free && !entry->is_frag)
 			dup = entry;
 	}
 
-- 
2.20.1

