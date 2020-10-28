Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579FA29DBC1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725940AbgJ2ANb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390799AbgJ2ANa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZEs-003tgs-Pi; Wed, 28 Oct 2020 01:22:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/2] net: marvell: mvneta: Fix trigraph warning with W=1
Date:   Wed, 28 Oct 2020 01:22:34 +0100
Message-Id: <20201028002235.928999-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028002235.928999-1-andrew@lunn.ch>
References: <20201028002235.928999-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/marvell/mvneta.c: In function ‘mvneta_tx_tso’:
drivers/net/ethernet/marvell/mvneta.c:2651:39: warning: trigraph ??! ignored, use -trigraphs to enable [-Wtrigraphs]
 2651 |   pr_info("*** Is this even  possible???!?!?\n");

Simply the questioning exclamation to a plain question to avoid the warning.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 54b0bf574c05..55f4c49c1278 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2648,7 +2648,7 @@ static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 		return 0;
 
 	if (skb_headlen(skb) < (skb_transport_offset(skb) + tcp_hdrlen(skb))) {
-		pr_info("*** Is this even  possible???!?!?\n");
+		pr_info("*** Is this even  possible????\n");
 		return 0;
 	}
 
-- 
2.28.0

