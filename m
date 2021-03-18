Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139C43410C9
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 00:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbhCRXS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 19:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhCRXSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 19:18:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 919D1C06174A;
        Thu, 18 Mar 2021 16:18:50 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id j3so8660778edp.11;
        Thu, 18 Mar 2021 16:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dTCfAq5P0MgC071JugduihaECH7SS6WNQnlDroPoC7w=;
        b=l5pP4QZwFjoB65FDA7HBSvunKidRXPr9pFi4DGUmVPT1kO739zxn7cw2XZMpeVm9AQ
         2PFxVJzPMW0VC6Dr3pDu2a76EAzSiD+kFDqaK9bkcmS31kdG8qH46PnTlNf4LYpbBWYa
         543ujLkjp67TbmPtg+qpMbuxeIts0/BJYPOud4nmvQ848ukve5OHtzCtPzYtShMdY0ky
         vCT+p3JQ1vDE4+mIyUcB+5TpcY/Judc+fpJULMi5JONkR0WKBNcSKhLqEA/e2d/eXzVJ
         Hj+mXylupCbcqZugRty1aotAQ2/A7x447Jaip8km2dYWKrVeRcG6VFLGASgGeJqZNxj7
         Y4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dTCfAq5P0MgC071JugduihaECH7SS6WNQnlDroPoC7w=;
        b=sXUNP+WAAg6SCmjj9TaxUMEs/Eg4zRIJnZXnzkrSEGMLOynrPPGGfjPtv9590YdlkQ
         0qZ+y1KekdBpZzuCAcgrihHllQBK2Q5gFjFSTjq6VjcNi/8/ukUubZL0Y8Pm9WOsGmQ/
         xjkWI8n0Y6IF43A3fzjISq/bWQZ6v8zcbUao00cNyZIdy2VkOglhuh5xiseNNk1Tz8UJ
         kOY3zUNNViSekXfmvxyGNNnGwSkTMDmp6Nw1RvCn6/zUsz4pCdyr+802Zx8/g0y0kcu5
         7x0jfivwgAmwpKg8hX7eoEeVLatW4J3gISHSGGkvXQgfpn8FYmbAPJdxyImAiDDksruh
         44jg==
X-Gm-Message-State: AOAM533iJkGRLF4D/2LqvV0vUqzv7hGN5YasvrgPINz8scbl3MnNR8HB
        4KxNbsxSJopMrZziYha5Wcc=
X-Google-Smtp-Source: ABdhPJwVCOp8tLravildRabpv2Gjjos7zn8TOjhBBPjB3Nn/q0KGxlPJdz7AvesTdyoDJk7U+FfQsQ==
X-Received: by 2002:a50:fe08:: with SMTP id f8mr6397077edt.217.1616109529320;
        Thu, 18 Mar 2021 16:18:49 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id bx24sm2801131ejc.88.2021.03.18.16.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 16:18:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 04/16] net: dsa: sync up with bridge port's STP state when joining
Date:   Fri, 19 Mar 2021 01:18:17 +0200
Message-Id: <20210318231829.3892920-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210318231829.3892920-1-olteanv@gmail.com>
References: <20210318231829.3892920-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

It may happen that we have the following topology:

ip link add br0 type bridge stp_state 1
ip link add bond0 type bond
ip link set bond0 master br0
ip link set swp0 master bond0
ip link set swp1 master bond0

STP decides that it should put bond0 into the BLOCKING state, and
that's that. The ports that are actively listening for the switchdev
port attributes emitted for the bond0 bridge port (because they are
offloading it) and have the honor of seeing that switchdev port
attribute can react to it, so we can program swp0 and swp1 into the
BLOCKING state.

But if then we do:

ip link set swp2 master bond0

then as far as the bridge is concerned, nothing has changed: it still
has one bridge port. But this new bridge port will not see any STP state
change notification and will remain FORWARDING, which is how the
standalone code leaves it in.

Add a function to the bridge which retrieves the current STP state, such
that drivers can synchronize to it when they may have missed switchdev
events.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/if_bridge.h |  6 ++++++
 net/bridge/br_stp.c       | 14 ++++++++++++++
 net/dsa/port.c            |  7 +++++++
 3 files changed, 27 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index b979005ea39c..920d3a02cc68 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -136,6 +136,7 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 				    __u16 vid);
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
+u8 br_port_get_stp_state(const struct net_device *dev);
 #else
 static inline struct net_device *
 br_fdb_find_port(const struct net_device *br_dev,
@@ -154,6 +155,11 @@ br_port_flag_is_set(const struct net_device *dev, unsigned long flag)
 {
 	return false;
 }
+
+static inline u8 br_port_get_stp_state(const struct net_device *dev)
+{
+	return BR_STATE_DISABLED;
+}
 #endif
 
 #endif
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 21c6781906aa..86b5e05d3f21 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -64,6 +64,20 @@ void br_set_state(struct net_bridge_port *p, unsigned int state)
 	}
 }
 
+u8 br_port_get_stp_state(const struct net_device *dev)
+{
+	struct net_bridge_port *p;
+
+	ASSERT_RTNL();
+
+	p = br_port_get_rtnl(dev);
+	if (!p)
+		return BR_STATE_DISABLED;
+
+	return p->state;
+}
+EXPORT_SYMBOL_GPL(br_port_get_stp_state);
+
 /* called under bridge lock */
 struct net_bridge_port *br_get_port(struct net_bridge *br, u16 port_no)
 {
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 346c50467810..785374744462 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -171,12 +171,19 @@ static int dsa_port_inherit_brport_flags(struct dsa_port *dp,
 static int dsa_port_switchdev_sync(struct dsa_port *dp,
 				   struct netlink_ext_ack *extack)
 {
+	struct net_device *brport_dev = dsa_port_to_bridge_port(dp);
+	u8 stp_state;
 	int err;
 
 	err = dsa_port_inherit_brport_flags(dp, extack);
 	if (err)
 		return err;
 
+	stp_state = br_port_get_stp_state(brport_dev);
+	err = dsa_port_set_state(dp, stp_state);
+	if (err && err != -EOPNOTSUPP)
+		return err;
+
 	return 0;
 }
 
-- 
2.25.1

