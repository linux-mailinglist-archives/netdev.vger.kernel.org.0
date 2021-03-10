Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B993333574
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhCJFhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:37:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:32864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhCJFhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A2F64F59;
        Wed, 10 Mar 2021 05:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615354624;
        bh=RDP5Y0cDfj6qdPT09J7Z4A2qZKPFQUibGd169OqR0KA=;
        h=Date:From:To:Cc:Subject:From;
        b=h14KtR2wkN0vZpZYqZ087aeBH3QX9HeQ2q54I4YwjIkkzIp4PI1raOZRVxP/r3JkU
         osYw/0vz31OYNdOGjgxZX3SIqRWKwiTrBlzE/qr0JuOp2XO/gWaFpGGuFipbvBdqrE
         554A3h+2Dks1B73CluYDtG4EQTOe2gh9OHxkHtxfxKKnIgpGbG7iLjH2Ld6FpnsJKQ
         +CYiokdtPE4caMPKbSxPMgCRBsSfQUTbuMrGhXmWVdIT/VVRAs24nm2cOVSvXq7opr
         NaejNHtV6L19MO7gTNQnBnu4Yhl+hxzKkJ/D0/7Bf/Soc7CtMD1aFgH2LKNOFbmPVU
         vw/K8Y6Z+VrHg==
Date:   Tue, 9 Mar 2021 23:37:02 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: cassini: Fix fall-through warnings for
 Clang
Message-ID: <20210310053702.GA285422@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 Changes in RESEND:
 - None. Resending now that net-next is open.

 drivers/net/ethernet/sun/cassini.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index 9ff894ba8d3e..54f45d8c79a7 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -1599,6 +1599,7 @@ static inline int cas_mdio_link_not_up(struct cas *cp)
 			cas_phy_write(cp, MII_BMCR, val);
 			break;
 		}
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

