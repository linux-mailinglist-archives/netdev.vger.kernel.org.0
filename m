Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7FE394794
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 21:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhE1T7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 15:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:37010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhE1T7H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 15:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A27B76139A;
        Fri, 28 May 2021 19:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622231852;
        bh=tQpTxrP2joGOYQdqOzFop8WIaDhpH3bLD1I/70SrXG0=;
        h=Date:From:To:Cc:Subject:From;
        b=WCauMO5ihg0wfEB80CFuTyAeRgG33OTri97341Ag7I1KxKxMbTj8+xZIRqiurLfg9
         ZYDGHeC2PubIwrX8RBvYTGBD9Q5IOsecZ3HsWWOoLPeBeHAa33kuhr3lP92TFzg9S/
         fGh6J5fg+a9wu168fnz0ww8Ic7/+0t+pvDzy1vAHHatrRGbqA3R53qxg0XLshplsCf
         5BDN5UD3eMHlLqfXUmUrk5WUC1MwHVK42Kb2zCzAQfw2hXNVXbFgqjUtwaSaHNGcF0
         RK/WkOELcSmXHMHo52JwUln3GWH+iLN5RaRD2Pb3JClboh6IV76ynOb9h4Ginzz/UV
         la+LOGu8vYwqg==
Date:   Fri, 28 May 2021 14:58:31 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: axienet: Fix fall-through warning for Clang
Message-ID: <20210528195831.GA39131@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding a fallthrough statement instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
JFYI: We had thousands of these sorts of warnings and now we are down
      to just 25 in linux-next. This is one of those last remaining
      warnings.

 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index b508c9453f40..e29ad9a86a3c 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1543,6 +1543,7 @@ static void axienet_validate(struct phylink_config *config,
 	case PHY_INTERFACE_MODE_MII:
 		phylink_set(mask, 100baseT_Full);
 		phylink_set(mask, 10baseT_Full);
+		fallthrough;
 	default:
 		break;
 	}
-- 
2.27.0

