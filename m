Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3E65333561
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhCJFdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:60224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232131AbhCJFdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:33:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3964264FE7;
        Wed, 10 Mar 2021 05:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615354399;
        bh=tPOLvHWlyO1O6LPs+6mBheK5snXKGRuNdiwmdhTzTzo=;
        h=Date:From:To:Cc:Subject:From;
        b=cNrMkyW8LEYy/LT/y+lO0d9wuK+DUDpdCeUI1tCNXigoY4K2/wgWR4oG/6iSwux+w
         JV5jcTm+Mi46vw+uEpBPzjvkKFBpcAIrMHjs6tN2RMPnJRmv0E1jzYp6cc5RZEwu90
         KlVyz5llhtzU8zaEGuPvm/L7AxSF6SLC0N7pJ7oji4hbCJ2I9HkxQ3aFTFMfqizZsF
         Qrw2GxhyAODZDspmJXgSeldksiQkMH/3A9eq/15+vXA3wqNUExTWwdeqavnyGSpOJk
         5RoQGghyPFrcWepNbPf6K9i2Bhlhga5TZrEFSFSByWgKirCwBfIcMjqvC5VJmdK2DF
         FahXi6ThqVEkw==
Date:   Tue, 9 Mar 2021 23:33:16 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: mscc: ocelot: Fix fall-through warnings
 for Clang
Message-ID: <20210310053316.GA285225@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://github.com/KSPP/linux/issues/115
---
 Changes in RESEND:
 - None. Resendig now that net-next is open.

 drivers/net/ethernet/mscc/ocelot_vcap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 37a232911395..7945393a0655 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -761,6 +761,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 			vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_ETYPE,
 					   etype.value, etype.mask);
 		}
+		break;
 	}
 	default:
 		break;
-- 
2.27.0

