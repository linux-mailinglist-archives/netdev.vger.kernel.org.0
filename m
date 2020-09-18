Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F712704BB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgIRTL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:11:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgIRTL2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 15:11:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJLn1-00FH91-PY; Fri, 18 Sep 2020 21:11:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 1/9] net: devlink: regions: Add a priv member to the regions ops struct
Date:   Fri, 18 Sep 2020 21:11:01 +0200
Message-Id: <20200918191109.3640779-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918191109.3640779-1-andrew@lunn.ch>
References: <20200918191109.3640779-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver may have multiple regions which can be dumped using one
function. However, for this to work, additional information is
needed. Add a priv member to the ops structure for the driver to use
however it likes.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/devlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 48b1c1ef1ebd..c83cb6ceff78 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -542,12 +542,14 @@ struct devlink_info_req;
  *            the data variable must be updated to point to the snapshot data.
  *            The function will be called while the devlink instance lock is
  *            held.
+ * @priv: Pointer to driver private data for the region operation
  */
 struct devlink_region_ops {
 	const char *name;
 	void (*destructor)(const void *data);
 	int (*snapshot)(struct devlink *devlink, struct netlink_ext_ack *extack,
 			u8 **data);
+	void *priv;
 };
 
 struct devlink_fmsg;
-- 
2.28.0

