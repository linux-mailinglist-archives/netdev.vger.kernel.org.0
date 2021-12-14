Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDD24743C9
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234542AbhLNNpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:45:40 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41898 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhLNNpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:45:38 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639489537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Up+YJsrenXH2pWJjQWcSJ+3utOp2O9a7aLTUvqCnEwc=;
        b=Ci2zbwaLelSJkNT2VCy1kGPk0RoACJwAAE5eckpabE3V2e94wB+aos4uz3VmOkCDgVq7Nb
        7WAstHtZ5stT92M+RT6A+xumAuvdvmTsMMU2DbYRR86E3pTgGQ31JUX8YxDxtq40BLBaYc
        w8peJ8VuJ7CvdZJWGD7dkPn7aZE0rtZgUkrOfhxQlv1lpTQAx/VSSFkxD7BQ2BSzsX/UTO
        KcTJIyfQQsOt934fpV/up+WGPFGwW11ZxI7Ij7UY0EH2YTKnYG66RH4rtLUOUHJ/vwGVdt
        2PPdTH+7Cc1Qu8MBY3Qmz8pOtrXwNfLtmIFiyNx2dFVR6zMych7H0cwdxzKVpg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639489537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Up+YJsrenXH2pWJjQWcSJ+3utOp2O9a7aLTUvqCnEwc=;
        b=71Dw59q4nwgTF8+l3idC7A9nEAYqzJgKESrfYAi4QX91Gw6IPnhzjdr2bNoSdr1cuF9BQ/
        Rt6qoH5vC84l3zDg==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v2 3/4] net: dsa: hellcreek: Allow PTP P2P measurements on blocked ports
Date:   Tue, 14 Dec 2021 14:45:07 +0100
Message-Id: <20211214134508.57806-4-kurt@linutronix.de>
In-Reply-To: <20211214134508.57806-1-kurt@linutronix.de>
References: <20211214134508.57806-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow PTP peer delay measurements on blocked ports by STP. In case of topology
changes the PTP stack can directly start with the correct delays.

Fixes: ddd56dfe52c9 ("net: dsa: hellcreek: Add PTP clock support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 17d3a4a3582e..cc0e4465bbbf 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1070,7 +1070,7 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.portmask     = 0x03,	/* Management ports */
 		.age	      = 0,
 		.is_obt	      = 0,
-		.pass_blocked = 0,
+		.pass_blocked = 1,
 		.is_static    = 1,
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
-- 
2.30.2

