Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DD6282BB1
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgJDQNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:13:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgJDQNM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 12:13:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kP6dJ-0003eY-DK; Sun, 04 Oct 2020 18:13:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v3 6/7] net: dsa: Add helper for converting devlink port to ds and port
Date:   Sun,  4 Oct 2020 18:12:56 +0200
Message-Id: <20201004161257.13945-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201004161257.13945-1-andrew@lunn.ch>
References: <20201004161257.13945-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hide away from DSA drivers how devlink works.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index ca426cf9927b..c0185660881c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -701,6 +701,20 @@ static inline struct dsa_switch *dsa_devlink_to_ds(struct devlink *dl)
 	return dl_priv->ds;
 }
 
+static inline
+struct dsa_switch *dsa_devlink_port_to_ds(struct devlink_port *port)
+{
+	struct devlink *dl = port->devlink;
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+
+	return dl_priv->ds;
+}
+
+static inline int dsa_devlink_port_to_port(struct devlink_port *port)
+{
+	return port->index;
+}
+
 struct dsa_switch_driver {
 	struct list_head	list;
 	const struct dsa_switch_ops *ops;
-- 
2.28.0

