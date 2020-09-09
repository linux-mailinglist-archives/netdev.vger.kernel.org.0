Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2707263ADC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgIJCrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:47:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730374AbgIJB7z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:59:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG9z5-00DzpK-MS; Thu, 10 Sep 2020 01:58:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 1/9] net: devlink: regions: Add a priv member to the regions ops struct
Date:   Thu, 10 Sep 2020 01:58:19 +0200
Message-Id: <20200909235827.3335881-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200909235827.3335881-1-andrew@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver may have multiple regions which can be dumped using one
function. However, for this to work, additional information is
needed. Add a priv member to the ops structure for the driver to use
however it likes.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/devlink.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index eaec0a8cc5ef..86ce644260b3 100644
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

