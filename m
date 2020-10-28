Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552C829DBC6
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390822AbgJ2ANk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50768 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390815AbgJ2ANi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:38 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZe5-003tyF-Rd; Wed, 28 Oct 2020 01:48:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Pravin B Shelar <pshelar@ovn.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] net: openvswitch: Fix kerneldoc warnings
Date:   Wed, 28 Oct 2020 01:48:49 +0100
Message-Id: <20201028004849.930094-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/openvswitch/flow.c:303: warning: Function parameter or member 'key_vh' not described in 'parse_vlan_tag'
net/openvswitch/flow.c:303: warning: Function parameter or member 'skb' not described in 'parse_vlan_tag'
net/openvswitch/flow.c:303: warning: Function parameter or member 'untag_vlan' not described in 'parse_vlan_tag'
net/openvswitch/vport.c:122: warning: Function parameter or member 'parms' not described in 'ovs_vport_alloc'

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/openvswitch/flow.c  | 4 ++++
 net/openvswitch/vport.c | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
index b03d142ec82e..c7f34d6a9934 100644
--- a/net/openvswitch/flow.c
+++ b/net/openvswitch/flow.c
@@ -294,6 +294,10 @@ static bool icmp6hdr_ok(struct sk_buff *skb)
 
 /**
  * Parse vlan tag from vlan header.
+ * @skb: skb containing frame to parse
+ * @key_vh: pointer to parsed vlan tag
+ * @untag_vlan: should the vlan header be removed from the frame
+ *
  * Returns ERROR on memory error.
  * Returns 0 if it encounters a non-vlan or incomplete packet.
  * Returns 1 after successfully parsing vlan tag.
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 82d801f063b7..4ed7e52c7012 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -111,10 +111,12 @@ struct vport *ovs_vport_locate(const struct net *net, const char *name)
  *
  * @priv_size: Size of private data area to allocate.
  * @ops: vport device ops
+ * @parms: information about new vport.
  *
  * Allocate and initialize a new vport defined by @ops.  The vport will contain
  * a private data area of size @priv_size that can be accessed using
- * vport_priv().  vports that are no longer needed should be released with
+ * vport_priv().  Some parameters of the vport will be initialized from @parms.
+ * @vports that are no longer needed should be released with
  * vport_free().
  */
 struct vport *ovs_vport_alloc(int priv_size, const struct vport_ops *ops,
-- 
2.28.0

