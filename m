Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F345214EEB
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 21:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgGETiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 15:38:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727891AbgGETiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 15:38:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsASw-003jY0-IU; Sun, 05 Jul 2020 21:38:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/4] net: dsa: mv88e6xxx: vlan_tci is __be16
Date:   Sun,  5 Jul 2020 21:38:08 +0200
Message-Id: <20200705193810.890020-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705193810.890020-1-andrew@lunn.ch>
References: <20200705193810.890020-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The flow spec member vlan_tci is in network order. Hence comparisons
should be made again network order values.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 7627ea61e0ea..d995f5bf0d40 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1751,7 +1751,7 @@ static int mv88e6xxx_policy_insert(struct mv88e6xxx_chip *chip, int port,
 	}
 
 	if ((fs->flow_type & FLOW_EXT) && fs->m_ext.vlan_tci) {
-		if (fs->m_ext.vlan_tci != 0xffff)
+		if (fs->m_ext.vlan_tci != htons(0xffff))
 			return -EOPNOTSUPP;
 		vid = be16_to_cpu(fs->h_ext.vlan_tci) & VLAN_VID_MASK;
 	}
-- 
2.27.0.rc2

