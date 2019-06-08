Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE1E39F11
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbfFHLkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:40:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727688AbfFHLki (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 07:40:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3FE4214C6;
        Sat,  8 Jun 2019 11:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559994037;
        bh=uQ4XZcvhcYF7ErpL8NqDn7A//9BnoY8UspE4kMWvs74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TBKswamPsRf+PDwKOQ+nMab5jZRvmVUUun3LBMbPFSBI5955gWyGi15/oery5s0C
         +XIC8jb4U4wvxFKo/OC2tKvrxDmz3ayaLT+IsWDqOMuolHXF6tDUtuiY23Gp1A1qBb
         m+99DJ6Oxb9quqVP8xilvkmr5bVmZmiF0WLTVWdQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 31/70] dpaa2-eth: Use PTR_ERR_OR_ZERO where appropriate
Date:   Sat,  8 Jun 2019 07:39:10 -0400
Message-Id: <20190608113950.8033-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190608113950.8033-1-sashal@kernel.org>
References: <20190608113950.8033-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Radulescu <ruxandra.radulescu@nxp.com>

[ Upstream commit bd8460fa4de46e9d6177af4fe33bf0763a7af4b7 ]

Use PTR_ERR_OR_ZERO instead of PTR_ERR in cases where
zero is a valid input. Reported by smatch.

Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 57cbaa38d247..df371c81a706 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1966,7 +1966,7 @@ alloc_channel(struct dpaa2_eth_priv *priv)
 
 	channel->dpcon = setup_dpcon(priv);
 	if (IS_ERR_OR_NULL(channel->dpcon)) {
-		err = PTR_ERR(channel->dpcon);
+		err = PTR_ERR_OR_ZERO(channel->dpcon);
 		goto err_setup;
 	}
 
@@ -2022,7 +2022,7 @@ static int setup_dpio(struct dpaa2_eth_priv *priv)
 		/* Try to allocate a channel */
 		channel = alloc_channel(priv);
 		if (IS_ERR_OR_NULL(channel)) {
-			err = PTR_ERR(channel);
+			err = PTR_ERR_OR_ZERO(channel);
 			if (err != -EPROBE_DEFER)
 				dev_info(dev,
 					 "No affine channel for cpu %d and above\n", i);
-- 
2.20.1

