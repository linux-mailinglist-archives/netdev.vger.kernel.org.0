Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBE232E300
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCEHgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEHgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 02:36:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6820864FE6;
        Fri,  5 Mar 2021 07:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614929808;
        bh=+iTAwGMeDUvHGR5clPzwIseO0cS42L2xO9DfdLZW3IA=;
        h=Date:From:To:Cc:Subject:From;
        b=UkE6W2cjONK1dDtVGySpnsxP9GFZpk5y2JqSi8PHFwgpRM6J2XZJapdfBwaWsqz/R
         MjYLaBGth0UWXvrKiJ+WkQ9KSrTpDEdS27RRBqONNVPYDUPbBv9P7QbZGGnSVvAIHA
         zYhnxRFErALLuNNg9AXhlXddy2eSAHjJRXeYnyRC8drmZyBx3bDD1mSS4ILki/ZMWH
         +wSucDCHtRCEf6RlUg81jfQ0u+bZF4dcIWX0FZpUPzLEZwhFi4R4xafzkOKD04YxJ5
         L+eTwsD5Vgd7SqlC+Ef0cCSWbByTgimnXALNsQMIN1ski253Z7TgTcDzZD7L9vU9n/
         lT0hus9EjmEuw==
Date:   Fri, 5 Mar 2021 01:36:44 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: cassini: Fix fall-through warnings for Clang
Message-ID: <20210305073644.GA122509@embeddedor>
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

