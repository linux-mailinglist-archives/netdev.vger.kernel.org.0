Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A155A33E4F8
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231882AbhCQBBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232394AbhCQA7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CE1164F9B;
        Wed, 17 Mar 2021 00:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942771;
        bh=S/s1ydsHP6u/33WtsdVONQgmijJEw4UF4jc/RGVkxg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=COUQOWxLdJKPd8SgNkM07Wgs8cmTuKMedYYDsYl/i7HZSrq5otLO/N7fBDRY38aMS
         tVFaPdBJAmQmf1vHm5wVqfwSW3jOOE3fMuABnorK22KAaV98yoIcL2isJOSwvw8wmm
         UZF92RZ7WGAchcyiQv7LqHMJoWwyFQP0nID8Et0SJHALKdCl2jdFRL7sEpJiVSCvO6
         9s4NMCByVk8HkmgAmFE9hG5Yrza87H0uvyF3eMRTXAqqr4N+4OTyBYCCd8YAfJcPBg
         wtRLmHwpBBM5M2y8/mUMriwACOe/UUAG9/L5yvBYVdxYmaBi0UF4hYz5asBvqQw9hu
         d26Dh5J2Rheyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 08/21] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
Date:   Tue, 16 Mar 2021 20:59:07 -0400
Message-Id: <20210317005920.726931-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005920.726931-1-sashal@kernel.org>
References: <20210317005920.726931-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Efremov <efremov@linux.com>

[ Upstream commit 155b23e6e53475ca3b8c2a946299b4d4dd6a5a1e ]

RXMAC_BC_FRM_CNT_COUNT added to mp->rx_bcasts twice in a row
in niu_xmac_interrupt(). Remove the second addition.

Signed-off-by: Denis Efremov <efremov@linux.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sun/niu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 411a69bea1d4..32ab44d00790 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3948,8 +3948,6 @@ static void niu_xmac_interrupt(struct niu *np)
 		mp->rx_mcasts += RXMAC_MC_FRM_CNT_COUNT;
 	if (val & XRXMAC_STATUS_RXBCAST_CNT_EXP)
 		mp->rx_bcasts += RXMAC_BC_FRM_CNT_COUNT;
-	if (val & XRXMAC_STATUS_RXBCAST_CNT_EXP)
-		mp->rx_bcasts += RXMAC_BC_FRM_CNT_COUNT;
 	if (val & XRXMAC_STATUS_RXHIST1_CNT_EXP)
 		mp->rx_hist_cnt1 += RXMAC_HIST_CNT1_COUNT;
 	if (val & XRXMAC_STATUS_RXHIST2_CNT_EXP)
-- 
2.30.1

