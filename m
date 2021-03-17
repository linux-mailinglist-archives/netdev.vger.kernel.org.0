Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE9A33E504
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhCQBAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232269AbhCQA7F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 20:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DA3964FB2;
        Wed, 17 Mar 2021 00:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942740;
        bh=WIwfRpLbW8AQsrwe2q3oRugDd9oVKxzLiXTk6KavXtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MjfeBrTslDKXoOFGs4xo2fBjsgaURCrR4/vOGt0kX/wO9E2RGzMql8anEE4sYjfxr
         xLgtiEnij4PyTuwsZKUpI0RfKaa6LKCRSLeyahL0Oz2Gzcg1+507RlPbUrH9XPbUWu
         DIDw+lzZ2/65+bON2l573nrQ6jWnDo7go+iWSaZvoD6OgLMoTrueRt9Lr1wH1rjZZF
         e15ElWB9799YqFLvmlZBGD3jOKEfnQz6ks/nn+sw2HowQVn6Wxhz0gj8b0wCweNdhz
         5Ah+6yCM7AMtVa8sSR/erPpn4IjlBW7JUzTD8EWhwSaH2UWn8INMenOPzP2AbSZzFq
         cvcPPjJ4dLaYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/23] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
Date:   Tue, 16 Mar 2021 20:58:34 -0400
Message-Id: <20210317005850.726479-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005850.726479-1-sashal@kernel.org>
References: <20210317005850.726479-1-sashal@kernel.org>
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
index d84501441edd..602a2025717a 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3933,8 +3933,6 @@ static void niu_xmac_interrupt(struct niu *np)
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

