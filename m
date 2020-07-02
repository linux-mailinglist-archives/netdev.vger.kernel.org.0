Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593C9211B1B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 06:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgGBE3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 00:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgGBE3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 00:29:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA6AC08C5C1;
        Wed,  1 Jul 2020 21:29:49 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x3so6429134pfo.9;
        Wed, 01 Jul 2020 21:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OVEIjgo+3KNuOB+vFKlCBkTjGwZpPasz23+EtfM4OT0=;
        b=sDDj04JAtlk688hpG0D28hWUnvmmU6LfDBDVd9JVPeL+Tngvc/hVFd4q9YGQBA286A
         W13iphRuEHgMCdKGS//8TOCpU7dfZpRVq2PUM7EK3Ob2yE4c7i4mvNu3+8+MTAd7JmxS
         W6rD6Wy3cHgwSlD1vdx1eE7tK2BQFMey1OmodyUmeUcsj2p6unwRuplIs5YQNaT94uMT
         BFJAel8oLrVBpnG4uN8TfOBz9CCmSVRIGRkHMd8RBAj6KUkiw9KW86JVmGRAfjlGRYE6
         dJct0Ol78+3Tg2654IIkZ7VToasQ65eEs5QTAhqQzO+/VLaLckYfue8/HNeHfmyNjfv8
         VUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OVEIjgo+3KNuOB+vFKlCBkTjGwZpPasz23+EtfM4OT0=;
        b=REz1MJhzu0aA6Tfr/ChUr0rWccRbUNAfBUYesG84Mvrt8LdRldHzjHIsvIZaFvso5o
         8FoEmz3GT9MwFq9/6jfRMP7fJHh2YY2y0yRjSoIWPddjw9jCeNR9WbBBKoobPDwZS9Qa
         Bi0yIXZ+dEX1HG5wNHtPvQaJrFwNXL9zXVihe7x/ifgObAnNuvsVBrKdnvz651z5py2w
         tFLC6hT1u2ux9JfzCfLUaNPeuZ4TO6o5eQBPwAWijX6ju1Fae4Jvrx5q4x8mYjhwWZV2
         JKrdTUyGoN5C+t4h6m1XbgVCuZ7V35QhZwZPiSLxuGTcG9EK7fFihoKPQNUK4R8IvhF8
         LcHQ==
X-Gm-Message-State: AOAM532rdsDeZrXQFHEsj4UHY0bgmEID2MXELrK2wuslPPbHEWnZW5e/
        PneZxHrB9uUJJHVfGVhcin2W4v7B
X-Google-Smtp-Source: ABdhPJybOnM2Osn89cYgNTAuOn/m6lDpLxhzIy9LGGAKFJcaEPH9q0AzU4fh/neYKErWxGJY3PEeiA==
X-Received: by 2002:aa7:9ec2:: with SMTP id r2mr27238404pfq.265.1593664189129;
        Wed, 01 Jul 2020 21:29:49 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id np5sm6806248pjb.43.2020.07.01.21.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 21:29:48 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/4] net: Add cable test netdevice operations
Date:   Wed,  1 Jul 2020 21:29:39 -0700
Message-Id: <20200702042942.76674-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702042942.76674-1-f.fainelli@gmail.com>
References: <20200702042942.76674-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for decoupling the ethtool cable test from the PHY
library, add definitions for two new network device operations:

* ndo_cable_test_start
* ndo_cable_test_tdr_start

In a subsequent patch we will start making use of those.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 include/linux/netdevice.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 39e28e11863c..43f640579973 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -936,6 +936,8 @@ struct dev_ifalias {
 
 struct devlink;
 struct tlsdev_ops;
+struct phy_tdr_config;
+struct netlink_ext_ack;
 
 struct netdev_name_node {
 	struct hlist_node hlist;
@@ -1278,6 +1280,13 @@ struct netdev_net_notifier {
  * int (*ndo_tunnel_ctl)(struct net_device *dev, struct ip_tunnel_parm *p,
  *			 int cmd);
  *	Add, change, delete or get information on an IPv4 tunnel.
+ * int (*ndo_cable_test_start)(struct net_device *dev,
+ *			       struct netlink_ext_ack *extack);
+ *	Start a cable test.
+ * int (*ndo_cable_test_tdr_start)(struct net_device *dev,
+ *				   struct netlink_ext_ack *extack,
+ *				   const struct phy_tdr_config *config);
+ *	Start a raw TDR (Time Domain Reflectometry) cable test.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1485,6 +1494,11 @@ struct net_device_ops {
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
 	int			(*ndo_tunnel_ctl)(struct net_device *dev,
 						  struct ip_tunnel_parm *p, int cmd);
+	int			(*ndo_cable_test_start)(struct net_device *dev,
+							struct netlink_ext_ack *exact);
+	int			(*ndo_cable_test_tdr_start)(struct net_device *dev,
+							    struct netlink_ext_ack *exact,
+							    const struct phy_tdr_config *config);
 };
 
 /**
-- 
2.25.1

