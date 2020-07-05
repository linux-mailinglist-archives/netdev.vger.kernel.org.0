Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6634214F64
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgGEUgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:36:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47748 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbgGEUgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 16:36:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jsBNP-003k2L-S4; Sun, 05 Jul 2020 22:36:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/3] dsa: bcm_sf2: Initialize __be16 with a __be16 value
Date:   Sun,  5 Jul 2020 22:36:24 +0200
Message-Id: <20200705203625.891900-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200705203625.891900-1-andrew@lunn.ch>
References: <20200705203625.891900-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A __be16 variable should be initialised with a __be16 value.  So add a
htons(). In this case it is pointless, given the value being assigned
is 0xffff, but it stops sparse from warnings.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index f707edc641cf..b54339477853 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -348,8 +348,8 @@ static int bcm_sf2_cfp_ipv4_rule_set(struct bcm_sf2_priv *priv, int port,
 				     unsigned int queue_num,
 				     struct ethtool_rx_flow_spec *fs)
 {
+	__be16 vlan_tci = 0, vlan_m_tci = htons(0xffff);
 	struct ethtool_rx_flow_spec_input input = {};
-	__be16 vlan_tci = 0 , vlan_m_tci = 0xffff;
 	const struct cfp_udf_layout *layout;
 	unsigned int slice_num, rule_index;
 	struct ethtool_rx_flow_rule *flow;
@@ -629,8 +629,8 @@ static int bcm_sf2_cfp_ipv6_rule_set(struct bcm_sf2_priv *priv, int port,
 				     unsigned int queue_num,
 				     struct ethtool_rx_flow_spec *fs)
 {
+	__be16 vlan_tci = 0, vlan_m_tci = htons(0xffff);
 	struct ethtool_rx_flow_spec_input input = {};
-	__be16 vlan_tci = 0, vlan_m_tci = 0xffff;
 	unsigned int slice_num, rule_index[2];
 	const struct cfp_udf_layout *layout;
 	struct ethtool_rx_flow_rule *flow;
-- 
2.27.0.rc2

