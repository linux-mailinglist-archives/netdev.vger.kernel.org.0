Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57235404B3D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbhIILvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:55120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239649AbhIILs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:48:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5D666126A;
        Thu,  9 Sep 2021 11:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187813;
        bh=uLZ/voZxpdGW5MEY6zifV7PeAzyie8gXGgGTSK/r0Kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0K7207guq27SbIg1AdZDUt54EvRyUhBQ3S179iYweJD+Q7FNCAh1ItKj9HDikavf
         4iL8YKNSruIn9uFHZdhhahpwb69FEmmq1la8hbu6HqxOOU600pEtW8ADa8N7MVhNSu
         SZA4Ks61MIVATLnHIQ2xCetHUJa9cyjmbKduHZmAVP50Mr+WYJuKKfmd0aDtT62YUg
         DYbU+sQda2rnPH779c8nPt4fVxV94ZjQ6/qMxvPeEsiS3nAR+AZlKS8uAvOrcG/hra
         aj+6XR80yznaqjLhduEAG6jVgoCmfJ1L75Ql4YrJmEMedI9P3035ytpQ/5a8tkvWlL
         GInLlUsXJ97+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 114/252] net: ipa: fix IPA v4.9 interconnects
Date:   Thu,  9 Sep 2021 07:38:48 -0400
Message-Id: <20210909114106.141462-114-sashal@kernel.org>
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

[ Upstream commit 0fd75f5760b6a7a7f35dff46a6cdc4f6d1a86ee8 ]

Three interconnects are defined for IPA version 4.9, but there
should only be two.  They should also use names that match what's
used for other platforms (and specified in the Device Tree binding).

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_data-v4.9.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-v4.9.c b/drivers/net/ipa/ipa_data-v4.9.c
index 798d43e1eb13..4cce5dce9215 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -416,18 +416,13 @@ static const struct ipa_mem_data ipa_mem_data = {
 /* Interconnect rates are in 1000 byte/second units */
 static const struct ipa_interconnect_data ipa_interconnect_data[] = {
 	{
-		.name			= "ipa_to_llcc",
+		.name			= "memory",
 		.peak_bandwidth		= 600000,	/* 600 MBps */
 		.average_bandwidth	= 150000,	/* 150 MBps */
 	},
-	{
-		.name			= "llcc_to_ebi1",
-		.peak_bandwidth		= 1804000,	/* 1.804 GBps */
-		.average_bandwidth	= 150000,	/* 150 MBps */
-	},
 	/* Average rate is unused for the next interconnect */
 	{
-		.name			= "appss_to_ipa",
+		.name			= "config",
 		.peak_bandwidth		= 74000,	/* 74 MBps */
 		.average_bandwidth	= 0,		/* unused */
 	},
-- 
2.30.2

