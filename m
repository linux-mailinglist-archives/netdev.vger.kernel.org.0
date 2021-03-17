Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4584E33E55B
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 02:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhCQBDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 21:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:41574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232455AbhCQBAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 21:00:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15DEA64FCA;
        Wed, 17 Mar 2021 01:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942816;
        bh=SIHhCZxrnfKiMp4P1TEUPAcpCiMriRCZ0H/FHgexX0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VB6/BNQbv3Bu8eyei2NnuK9xbDydTgUEkpABjD3QIpNkzEars9FIblzR4j7QLYRLC
         zm+kCW2lu/DLTihSsG8BhApo/Gji5uA3tmjgi0x1XpJFNs8J/FPzI/T78s4bhtaoIj
         AoI51gzHRpHLMQsUMu5TD/Qdup0L5MOeQqJg/Z0jRKad6JEL5KAK7SlrdkgLWKcSfk
         gFtx5n+qRwpgeXMfv7P+2UBSV1Q+v1nJ1+l9jfSvi0cU2VhOvNzUOtAGF7b1Tqo0Vz
         I2mamTkrcV4S/BNmao/SnLwafPSWcvx13BvsKTiJMKtR+EdfoDAlyOeu8HG7a1qvq4
         erUJ1o0zaXx2g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/14] sun/niu: fix wrong RXMAC_BC_FRM_CNT_COUNT count
Date:   Tue, 16 Mar 2021 21:00:00 -0400
Message-Id: <20210317010008.727496-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317010008.727496-1-sashal@kernel.org>
References: <20210317010008.727496-1-sashal@kernel.org>
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
index 85f3a2c0d4dd..cc3b025ab7a7 100644
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

