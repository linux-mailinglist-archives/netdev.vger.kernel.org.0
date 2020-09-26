Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF46279C8D
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgIZVHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:07:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57300 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbgIZVHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 17:07:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMHPU-00GJhD-3s; Sat, 26 Sep 2020 23:07:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 6/7] net: dsa: Add helper for converting devlink port to ds and port
Date:   Sat, 26 Sep 2020 23:06:31 +0200
Message-Id: <20200926210632.3888886-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200926210632.3888886-1-andrew@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
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
index f0bb64e5002f..24c925c192ec 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -686,6 +686,20 @@ static inline struct dsa_switch *dsa_devlink_to_ds(struct devlink *dl)
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

