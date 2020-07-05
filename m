Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989E8214F7A
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgGEUmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:42:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47800 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgGEUmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 16:42:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsBTG-003k9L-1Q; Sun, 05 Jul 2020 22:42:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] dsa: rtl8366: Pass GENMASK() signed bits
Date:   Sun,  5 Jul 2020 22:42:27 +0200
Message-Id: <20200705204227.892335-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Oddly, GENMASK() requires signed bit numbers, so that it can compare
them for < 0. If passed an unsigned type, we get warnings about the
test never being true.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/rtl8366.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/rtl8366.c b/drivers/net/dsa/rtl8366.c
index ac88caca5ad4..993cf3ac59d9 100644
--- a/drivers/net/dsa/rtl8366.c
+++ b/drivers/net/dsa/rtl8366.c
@@ -272,7 +272,7 @@ int rtl8366_init_vlan(struct realtek_smi *smi)
 			/* For the CPU port, make all ports members of this
 			 * VLAN.
 			 */
-			mask = GENMASK(smi->num_ports - 1, 0);
+			mask = GENMASK((int)smi->num_ports - 1, 0);
 		else
 			/* For all other ports, enable itself plus the
 			 * CPU port.
-- 
2.27.0.rc2

