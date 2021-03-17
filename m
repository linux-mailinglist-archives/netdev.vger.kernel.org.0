Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC5733E34C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 01:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhCQA42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 20:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:32836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhCQAzz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:55:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 084E664F9C;
        Wed, 17 Mar 2021 00:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942555;
        bh=BVLHeJV5ydperMmxlfgOHF9N8L7iAkwX5Oxqg+cpIPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyMQhrfxaeglENoXVL5biqug/QQ0se/UOzWGuTDXpCq5gbikGpUtQhAlKo/nVJiFp
         hwdpeXpbmVVO1kairECe5ync9VtDiEoAxHRnlGwNdvHZj8x+zOabhSu095fbKk8O3b
         WDxnCuj9Oxgrqto8mvgHm8cCv68qzfj7oP3wpF1rf1TYZcGeJM92lNobIaHMb/oknJ
         6EowP1oU29C5C20GM7MTJqfn3dAv/4N14Q8K+bdDUf0R//ceSx1TigcVkQow/mOzeo
         UPJYCIZ3zD9Ll34uePdypruAYxo5oilUM2xUIxzQy15a8/3qvbyIZmsICFOS8N/JB9
         +Yazl85B42yow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 15/61] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
Date:   Tue, 16 Mar 2021 20:54:49 -0400
Message-Id: <20210317005536.724046-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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

