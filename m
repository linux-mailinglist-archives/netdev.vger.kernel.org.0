Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84695270E9D
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 16:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgISOn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 10:43:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbgISOn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 10:43:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJe5h-00FNaV-64; Sat, 19 Sep 2020 16:43:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Chris Healy <cphealy@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next RFC v1 3/4] net: dsa: Add helper for converting devlink port to ds and port
Date:   Sat, 19 Sep 2020 16:43:31 +0200
Message-Id: <20200919144332.3665538-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919144332.3665538-1-andrew@lunn.ch>
References: <20200919144332.3665538-1-andrew@lunn.ch>
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
index 01da896b2998..a24d5158ee0c 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -685,6 +685,20 @@ static inline struct dsa_switch *dsa_devlink_to_ds(struct devlink *dl)
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

