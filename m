Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11A8404E74
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237246AbhIIMLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:11:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345229AbhIIMHF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:07:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23CCE61980;
        Thu,  9 Sep 2021 11:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188059;
        bh=CCqSZBrjoqhbOd+VZEKVATTkTGbF+yGwyIWlC/YNMf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxlsHaFbBfEsbA2PyvSjho02a4es2g9zvClbejdIGYmffJ+i6kuuWvx0omqtHj4pY
         E7na6+/lvtlZgsF3D/5KsFRtIO7ReiwNJ9Axwo+He1nwtCeGzT6dnVEC6c7nGheIr2
         5TpKlp6HvzMPBW02cYx2fFBQzNAhk78UVvFzMoF9KvbzDCVF6C9VnouLKWnQjc1/wH
         6MAQ9zFL93kMj0QhVg4uL9+lMHkSltZElSrrkscUq+x1kjv8X5cUVYOosxxx330QaF
         M+vuF/E0dpIZq6i7lSGyic37PegmPuiGmcjtS6bzdbB9Fq9E3VB7IUvUQHZOraBELp
         2sqmYcKWoHwGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, oss-drivers@corigine.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 049/219] nfp: fix return statement in nfp_net_parse_meta()
Date:   Thu,  9 Sep 2021 07:43:45 -0400
Message-Id: <20210909114635.143983-49-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index eeb30680b4dc..0a0a26376bea 100644
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

