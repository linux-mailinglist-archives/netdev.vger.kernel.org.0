Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9A613EE58
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 19:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393303AbgAPSIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 13:08:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405095AbgAPRiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:38:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80683246B1;
        Thu, 16 Jan 2020 17:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196330;
        bh=8QXMs7FWZw6UiJUPyG8O/nR49W6rWYfxOuxu4nbdrU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BSmpPKRhDCOEQmsJzxXaIUV2JJVmIA+GNgOhGXGiKmlQNd7dlQobYWPgLzPNFxB4/
         X7tFFaiyK4s/q/l71bnbE6sWJ7KANuAgUMUb4Y97NWbN1nWrCnxB0bkssYBpkikAI4
         T0JWxCYSu7MQ+MXfp3Rjyjj2KKLUYur2UTDKGdwE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sameeh Jubran <sameehj@amazon.com>,
        Netanel Belgazal <netanel@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 131/251] net: ena: fix ena_com_fill_hash_function() implementation
Date:   Thu, 16 Jan 2020 12:34:40 -0500
Message-Id: <20200116173641.22137-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 11bd7a00c0d8ffe33d1e926f8e789b4aea787186 ]

ena_com_fill_hash_function() didn't configure the rss->hash_func.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 2d196d521b83..912dc09bc7a7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2052,6 +2052,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		return -EINVAL;
 	}
 
+	rss->hash_func = func;
 	rc = ena_com_set_hash_function(ena_dev);
 
 	/* Restore the old function */
-- 
2.20.1

