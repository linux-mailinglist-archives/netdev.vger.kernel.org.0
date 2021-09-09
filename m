Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FA3404DF8
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348442AbhIIMHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:07:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:42148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347788AbhIIME2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:04:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1DAD6187D;
        Thu,  9 Sep 2021 11:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188028;
        bh=2ZQgAdSqM3Z1B/NFboHJ5P2AqXD4GDXImXq2D9M7XEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KINcNcCBBbvbrOe2QstnrbfRUhJX1bpFIBLa2crU9mClGRUM5PLNLNpnK2drlxpHq
         BgFq/KwEA8IBurstZ6L8PeWgmY5z5jHzsMSaUtqcY/xRhK64N2PPNwyjHeRb4+6vZN
         O6IeXNiT3S3jSp9wW1DKsfkI/bPlmXagYRuknQt+2Np70bSk7zXqKsUvyElIilQGuI
         o1Qltz2yfeRCMTgrYAke2HXDaSek6rQRUT7R84gjxWY36pkTZgfVlZXhq6UMXj7ZwB
         L8l+ErB2iofZSgG+fQvaF0mTLu4cw3j52JjarwtD7rKFtr+OiGP0oFID2inKp5omyW
         ybSf5HHXe8u9g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 025/219] net: ipa: fix IPA v4.11 interconnect data
Date:   Thu,  9 Sep 2021 07:43:21 -0400
Message-Id: <20210909114635.143983-25-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Elder <elder@linaro.org>

[ Upstream commit 0ac26271344478ff718329fa9d4ef81d4bcbc43b ]

Currently three interconnects are defined for the Qualcomm SC7280
SoC, but this was based on a misunderstanding.  There should only be
two interconnects defined:  one between the IPA and system memory;
and another between the AP and IPA config space.  The bandwidths
defined for the memory and config interconnects do not match what I
understand to be proper values, so update these.

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_data-v4.11.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v4.11.c b/drivers/net/ipa/ipa_data-v4.11.c
index 05806ceae8b5..157f8d47058b 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -346,18 +346,13 @@ static const struct ipa_mem_data ipa_mem_data = {
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
 		.name			= "memory",
-		.peak_bandwidth		= 465000,	/* 465 MBps */
-		.average_bandwidth	= 80000,	/* 80 MBps */
-	},
-	/* Average rate is unused for the next two interconnects */
-	{
-		.name			= "imem",
-		.peak_bandwidth		= 68570,	/* 68.57 MBps */
-		.average_bandwidth	= 80000,	/* 80 MBps (unused?) */
+		.peak_bandwidth		= 600000,	/* 600 MBps */
+		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
+	/* Average rate is unused for the next interconnect */
 	{
 		.name			= "config",
-		.peak_bandwidth		= 30000,	/* 30 MBps */
+		.peak_bandwidth		= 74000,	/* 74 MBps */
 		.average_bandwidth	= 0,		/* unused */
 	},
 };
-- 
2.30.2

