Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC418405115
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:42:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245603AbhIIMdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:33:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242477AbhIIM1Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:27:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DDFD61B23;
        Thu,  9 Sep 2021 11:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188326;
        bh=HbKdG9aytO0ioDG/KY7sAZQbkCDdECINTMrITFOu0ZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EcYgWuztIeKf84LYDMnRLTQWeR/+nq3GiRLiaFFIN4qokIVMio52/x6eWoZO70VWS
         NTWnT8WbLHdcsiuUa3YMksDFpgPHtz1aSqsHC7nFxDVRH9lO9mHKPL8+jY+TIqGrzC
         SLwUeWilpJMdSsrZFfUVNulxlThk8rOEtag/OVrglU2nMhikrBbz7sGlULvP4KZGEe
         LRyxF8t2Fj4nhKFJg0gl1W5IE+3uHpDG2LAxku1fOnW8lY5lMKL6T5Vmy0vSA15Qtp
         P4L6Ttxnb4x+58MAg1X2RYRAHdJIMaE6T8j8f6OzHU9LyfwVvdlX2IB4rzfOo7isK4
         V//CTc8t+4RLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@corigine.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 037/176] nfp: fix return statement in nfp_net_parse_meta()
Date:   Thu,  9 Sep 2021 07:48:59 -0400
Message-Id: <20210909115118.146181-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

[ Upstream commit 4431531c482a2c05126caaa9fcc5053a4a5c495b ]

The return type of the function is bool and while NULL do evaluate to
false it's not very nice, fix this by explicitly returning false. There
is no functional change.

Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 437226866ce8..dfc1f32cda2b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1697,7 +1697,7 @@ nfp_net_parse_meta(struct net_device *netdev, struct nfp_meta_parsed *meta,
 		case NFP_NET_META_RESYNC_INFO:
 			if (nfp_net_tls_rx_resync_req(netdev, data, pkt,
 						      pkt_len))
-				return NULL;
+				return false;
 			data += sizeof(struct nfp_net_tls_resync_req);
 			break;
 		default:
-- 
2.30.2

