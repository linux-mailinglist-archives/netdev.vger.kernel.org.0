Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5472BB334
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730556AbgKTSa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:30:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:50388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729980AbgKTSa5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:30:57 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A826E2415A;
        Fri, 20 Nov 2020 18:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897056;
        bh=+iTAwGMeDUvHGR5clPzwIseO0cS42L2xO9DfdLZW3IA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KhkWf5Il35KaQWp09Ulk+GtAJG4QFzX+179FY78zH44QRF2YzHewBI2Q3iYwTGOMZ
         SuyCkBcsPkl7mnYR1WKQDChHIwjKwgb+nrKUeUyaxzxidfxhzCRV5xfcUp/r+f5X/6
         iR8KwMy9xiTrkZJNN/Wkh5xq/APi/0U4QMrGaDD8=
Date:   Fri, 20 Nov 2020 12:31:02 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 043/141] net: cassini: Fix fall-through warnings for Clang
Message-ID: <30b387eebc875f8083a84b0571460820692fa0d8.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
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

