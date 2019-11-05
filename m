Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A280EF98B
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 10:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730784AbfKEJfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 04:35:37 -0500
Received: from simonwunderlich.de ([79.140.42.25]:35596 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730583AbfKEJfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 04:35:36 -0500
Received: from kero.packetmixer.de (p200300C5970F5D00F0ACF07C9CF9C7D8.dip0.t-ipconnect.de [IPv6:2003:c5:970f:5d00:f0ac:f07c:9cf9:c7d8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id 103D66205D;
        Tue,  5 Nov 2019 10:35:35 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4/5] batman-adv: Use 'fallthrough' pseudo keyword
Date:   Tue,  5 Nov 2019 10:35:30 +0100
Message-Id: <20191105093531.11398-5-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105093531.11398-1-sw@simonwunderlich.de>
References: <20191105093531.11398-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

The usage of the '/* fall through */' comments in switches are no longer
marked as non-deprecated variant of implicit fall throughs for switch
statements. The commit 294f69e662d1 ("compiler_attributes.h: Add
'fallthrough' pseudo keyword for switch/case use") introduced a replacement
keyword which should be used instead.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
---
 net/batman-adv/multicast.c      | 2 +-
 net/batman-adv/soft-interface.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 1d5bdf3a4b65..f9ec8e7507b6 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -1421,7 +1421,7 @@ batadv_mcast_forw_mode(struct batadv_priv *bat_priv, struct sk_buff *skb,
 		if (*orig)
 			return BATADV_FORW_SINGLE;
 
-		/* fall through */
+		fallthrough;
 	case 0:
 		return BATADV_FORW_NONE;
 	default:
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index 5ee8e9a100f9..697f2da12487 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -230,7 +230,7 @@ static netdev_tx_t batadv_interface_tx(struct sk_buff *skb,
 			break;
 		}
 
-		/* fall through */
+		fallthrough;
 	case ETH_P_BATMAN:
 		goto dropped;
 	}
@@ -455,7 +455,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 		if (vhdr->h_vlan_encapsulated_proto != htons(ETH_P_BATMAN))
 			break;
 
-		/* fall through */
+		fallthrough;
 	case ETH_P_BATMAN:
 		goto dropped;
 	}
-- 
2.20.1

