Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7167533E3D2
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbhCQA5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231211AbhCQA5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39B4064FC7;
        Wed, 17 Mar 2021 00:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942632;
        bh=BVLHeJV5ydperMmxlfgOHF9N8L7iAkwX5Oxqg+cpIPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyX+9FO69nk8n1njZQJPvdWBV6he/wKS9ky1yK7gqiNI+h23CQ0xyFT5tUGvozD8k
         RklOIYZabDx33HSti24XRlQcp8txOjEuoX946VhPYAsltnhVTzLLCnD92lvka1Wvg7
         C2Qg1YCA1e/FYROzXozAMuiIKObku/xv+AASP8YEAqZUISZqWjhOCtYiK8GOu1yw5L
         YZlRrBbstoDnxnEmDzgrwp6QQSNt+vSX2HY+3BbGoExRBw26q4KRPRr+aUE21xijZt
         V42bpB6C37PsVfSqrZYc7u7qSZEpyfe8o9hMKpuJmfPFFasVaJRYePJyNUPz07nyvu
         uOaqzk8hqXcMw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/54] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
Date:   Tue, 16 Mar 2021 20:56:13 -0400
Message-Id: <20210317005654.724862-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index 68695d4afacd..707ccdd03b19 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3931,8 +3931,6 @@ static void niu_xmac_interrupt(struct niu *np)
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

