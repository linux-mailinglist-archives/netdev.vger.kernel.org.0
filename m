Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32221404EFB
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349893AbhIIMQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:16:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239060AbhIIMMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27B9861A38;
        Thu,  9 Sep 2021 11:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188124;
        bh=PrlHO9V//nsNUl1uc4NBsy5zgOjPEtrfBnv8qKKmAsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bBWwJGAHCvXlxzcTNtYTIGrKwh9bfr4Jz0aZhQAfFHqxJxNH1ZdSpTfaGzAOmvtCj
         tsldl8jJ0sYtG1Hy3nD/acrbhOBq33wGwWQCaK9qjZa4df7+NlhMPtAlBPg0gbfeUv
         qPoRJTx2rIN63fQcgnQPMA/jn5TksJxUdjGPi3ZCDKc2FsDVKy4RMTU8wo5n5t2MWI
         Fn7bBEnFyi3T7iKI4l+TCiMeuwP2knIVAfYjSVl8NHydcf9Cms+xDS2T5AXhzyrtQd
         l9jh4A7VD1TDSPQ5OMBgEMg9J/BZ2ciF9ZW+5kV2/mvfoAWnRe+hoZlEif1Xtl6deq
         o8pCEKxz+zlXw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Elder <elder@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 100/219] net: ipa: fix IPA v4.9 interconnects
Date:   Thu,  9 Sep 2021 07:44:36 -0400
Message-Id: <20210909114635.143983-100-sashal@kernel.org>
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
index e41be790f45e..75b50a50e348 100644
--- a/drivers/net/ipa/ipa_data-v4.9.c
+++ b/drivers/net/ipa/ipa_data-v4.9.c
@@ -392,18 +392,13 @@ static const struct ipa_mem_data ipa_mem_data = {
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

