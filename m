Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AF13947E4
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhE1UXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhE1UXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 16:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF02F61176;
        Fri, 28 May 2021 20:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622233286;
        bh=ShC22oAUAdxHAtnYmzAyi/z4/Un2HvMMUBZrfLSqu6c=;
        h=Date:From:To:Cc:Subject:From;
        b=AKnnG4t7ki3XnBO1UrgNzk0Dk/gBg7lPGHNjYYXIBT5RKxtehQuyfDwR3w66gnadw
         lrbVLShU/o1u5Y7CETUBhRDbg11hdcMcnUFS/dwrszBfO/kBhwMASRCTtIzBV4ysxi
         3Yu8vRKTFQsOU7I66GeD+HKqNTtzpgd/mYtfTRJgxAlC4B4gLDrfbu8M1r41+PPqMX
         CYPxR5B3w16KXyJAJflNcaP3QR19aBBB+uCPok6l60VZ2cFyBFSby8OO9OUB80tW4+
         X8+xIgdzuswIyaobq9G7TJBBu+hn0aFK0F1BqZB3WdFzpvZXtA88ilmTL0lP5jLMeC
         rhVpFq5Zp1qMQ==
Date:   Fri, 28 May 2021 15:22:25 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] octeontx2-pf: Fix fall-through warning for Clang
Message-ID: <20210528202225.GA39855@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
JFYI: We had thousands of these sorts of warnings and now we are down
      to just 25 in linux-next. This is one of those last remaining
      warnings.

 drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
index 0b4fa92ba821..80b769079d51 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_flows.c
@@ -551,6 +551,7 @@ static int otx2_prepare_ipv6_flow(struct ethtool_rx_flow_spec *fsp,
 			req->features |= BIT_ULL(NPC_IPPROTO_AH);
 		else
 			req->features |= BIT_ULL(NPC_IPPROTO_ESP);
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

