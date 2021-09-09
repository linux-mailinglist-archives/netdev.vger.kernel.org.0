Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112354049DF
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238913AbhIILnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:43:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237351AbhIILm6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2146611F0;
        Thu,  9 Sep 2021 11:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187708;
        bh=a+IUpkiYDT9FlnSCzYyC3f+PXqV+/LEvRXZ0gkxuO3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rrm2murnTko82OvJuRtpS+T4WtueX3py/iDyetgqj4YtHrAif+u5XJXuR4wIqyXSA
         b/62FALWsHXPkWTQsCJ5oe8T2sZzPO+NoWoY+ST/NI/xpZk2Hs2ouIJ0j7YPk5j0qs
         6M/rjJjBnDso6ZlqVEtkvj2xx3OZG13dXhgr9qD5WMrZiUFr/tY78ooUFDBnA4FPtV
         5+s8Y3J4vFgncoPGBmg1VoRquQx4ozMuUHxMkSy+/QsvZJfhIo+xhIBNnTEDkq1i5h
         jmEakNkr9kloXSDzaD6JUri6FbQO+mDyWDFzr4Wu+vA01YGgK0NNCZRVDE0+RFa4ah
         Zkk/IuqgWxVlA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 032/252] net: ipa: fix IPA v4.11 interconnect data
Date:   Thu,  9 Sep 2021 07:37:26 -0400
Message-Id: <20210909114106.141462-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 9353efbd504f..598b410cd7ab 100644
--- a/drivers/net/ipa/ipa_data-v4.11.c
+++ b/drivers/net/ipa/ipa_data-v4.11.c
@@ -368,18 +368,13 @@ static const struct ipa_mem_data ipa_mem_data = {
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

