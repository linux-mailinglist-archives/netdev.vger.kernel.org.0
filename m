Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033806EED1B
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 06:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbjDZEzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 00:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239308AbjDZEzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 00:55:04 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB2A26AC
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 21:55:02 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-32b1c8ff598so52595495ab.3
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 21:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682484902; x=1685076902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bckHqJ9P8dQXZkc4IL18BweR5iJjZqVnmzZENp6Yixk=;
        b=CWiqkCfSJXgA+b7kNrf6stT7VrfaP2FMgIIxMISpdYQmkcxWfrNkYg0qTdTN6UR3Dv
         XTIcQcNcmeMCiqNeXgH38ANSV8GLLDqQq3/DJvwujKULHXQMqPQHQpSUmAImXKprbLKZ
         gl8Cw87/LoWuQ5pLl/0CPigINlyyNH9i8KQo/6EIdy9oGbP5PYfyyNVvjP8JoYjtC9aA
         ayn9R2PG5ZU4fd+8GBjqfwSWSRWm6wP0L3bYIRYTMi/bZRmK5vywDtzq46AcAOOi4cHm
         n68b4MZt2xs2R3lRf0E8D6D2pHwrzmcSSicBszWPiX8KEh4MiwYW2h4PryzICpS9f4wU
         Ubew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682484902; x=1685076902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bckHqJ9P8dQXZkc4IL18BweR5iJjZqVnmzZENp6Yixk=;
        b=WQDPDJIheUkGZRG66qCrwhCyHD65ralNmZVzeLnVOj2EWE/jqnU1S8zz+XX3qx4a7Z
         sWwHOm96pJG56Z4BT3NhK4niLJz08LK/SONkRhYvp+4CEz9AfAxXGGmVZUoWxaXKptsk
         t61Pazd0j1YhcUXZHShkIkBiPr9Hj2n48QhnnEonL5d8SXmiPKGBSoBI4TeBNV2JAuxK
         mZ7wbF/kPTTfUbVTuvuH8NPdjHHJ1PXNiZQSGKQuJ/zdI2B9RDiUGY3j34BeIeOXMeJJ
         uBIQLG/C4tL7acOpdMOn2okLB8v/u3AC68C+IJLjCvAREe+/s7QVtgJ+/nGFX2Q4MSgL
         VnrA==
X-Gm-Message-State: AAQBX9fCoN+xxNYBbSO+J6RV52i9tZiIpPxn3zD19mJzw0KqSKrqyYtZ
        O0KQymRGLJHRIIUtHbMUC5s=
X-Google-Smtp-Source: AKy350btyWtbrg5lUL6rXjqwc41pbCb5K8NhY6q8xGdbsXsJAwP6MY0udr2n7FX5mdTCpHddiWSkPQ==
X-Received: by 2002:a92:dd08:0:b0:32a:85f7:eaac with SMTP id n8-20020a92dd08000000b0032a85f7eaacmr10976077ilm.5.1682484901999;
        Tue, 25 Apr 2023 21:55:01 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id t27-20020a02b19b000000b004054d7eede5sm4663446jah.22.2023.04.25.21.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 21:55:01 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: [RFC PATCH v5 3/5] Add ndo_hwtstamp_get/set support to vlan/maxvlan code path
Date:   Tue, 25 Apr 2023 22:55:00 -0600
Message-Id: <20230426045500.389893-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <CAP5jrPEZ12UFbNC4gtah9RFxVZrbHDMCr8DQ_vBCtMY+6FWr7Q@mail.gmail.com>
References: <CAP5jrPEZ12UFbNC4gtah9RFxVZrbHDMCr8DQ_vBCtMY+6FWr7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes VLAN and MAXVLAN drivers to use the newly
introduced ndo_hwtstamp_get/set API to pass hw timestamp
requests to underlying NIC drivers in case if these drivers
implement ndo_hwtstamp_get/set functions. Otherwise VLAN
subsystems falls back to calling ndo_eth_ioctl.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
Notes:
  Changes in v5:
  - Re-introduced the net namespace check which
    was dropped in v4.
  Changes in v4:
  - Moved hw timestamp get/set request processing logic
    from vlan_dev_ioctl() to .ndo_hwtstamp_get/set callbacks.
  - Use the shared generic_hwtstamp_get/set_lower() functions
    to handle ndo_hwtstamp_get/set requests.
  - Applay the same changes to macvlan driver.
---
 drivers/net/macvlan.c | 35 +++++++++++++++--------------------
 net/8021q/vlan_dev.c  | 28 +++++++++++++++++++++++-----
 2 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4a53debf9d7c..58515c9fdf49 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -868,31 +868,25 @@ static int macvlan_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int macvlan_eth_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int macvlan_hwtstamp_get(struct net_device *dev,
+				struct kernel_hwtstamp_config *cfg,
+				struct netlink_ext_ack *extack)
 {
 	struct net_device *real_dev = macvlan_dev_real_dev(dev);
-	const struct net_device_ops *ops = real_dev->netdev_ops;
-	struct ifreq ifrr;
-	int err = -EOPNOTSUPP;
 
-	strscpy(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
-	ifrr.ifr_ifru = ifr->ifr_ifru;
+	return generic_hwtstamp_get_lower(real_dev, cfg, extack);
+}
 
-	switch (cmd) {
-	case SIOCSHWTSTAMP:
-		if (!net_eq(dev_net(dev), &init_net))
-			break;
-		fallthrough;
-	case SIOCGHWTSTAMP:
-		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
-			err = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
-		break;
-	}
+static int macvlan_hwtstamp_set(struct net_device *dev,
+				struct kernel_hwtstamp_config *cfg,
+				struct netlink_ext_ack *extack)
+{
+	struct net_device *real_dev = macvlan_dev_real_dev(dev);
 
-	if (!err)
-		ifr->ifr_ifru = ifrr.ifr_ifru;
+	if (!net_eq(dev_net(dev), &init_net))
+		return -EOPNOTSUPP;
 
-	return err;
+	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
 }
 
 /*
@@ -1193,7 +1187,6 @@ static const struct net_device_ops macvlan_netdev_ops = {
 	.ndo_stop		= macvlan_stop,
 	.ndo_start_xmit		= macvlan_start_xmit,
 	.ndo_change_mtu		= macvlan_change_mtu,
-	.ndo_eth_ioctl		= macvlan_eth_ioctl,
 	.ndo_fix_features	= macvlan_fix_features,
 	.ndo_change_rx_flags	= macvlan_change_rx_flags,
 	.ndo_set_mac_address	= macvlan_set_mac_address,
@@ -1212,6 +1205,8 @@ static const struct net_device_ops macvlan_netdev_ops = {
 #endif
 	.ndo_get_iflink		= macvlan_dev_get_iflink,
 	.ndo_features_check	= passthru_features_check,
+	.ndo_hwtstamp_get	= macvlan_hwtstamp_get,
+	.ndo_hwtstamp_set	= macvlan_hwtstamp_set,
 };
 
 static void macvlan_dev_free(struct net_device *dev)
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 5920544e93e8..02c64d4f8d3e 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -353,6 +353,27 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
+static int vlan_hwtstamp_get(struct net_device *dev,
+			     struct kernel_hwtstamp_config *cfg,
+			     struct netlink_ext_ack *extack)
+{
+	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+
+	return generic_hwtstamp_get_lower(real_dev, cfg, extack);
+}
+
+static int vlan_hwtstamp_set(struct net_device *dev,
+			     struct kernel_hwtstamp_config *cfg,
+			     struct netlink_ext_ack *extack)
+{
+	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
+
+	if (!net_eq(dev_net(dev), &init_net))
+		return -EOPNOTSUPP;
+
+	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
+}
+
 static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
@@ -364,14 +385,9 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	ifrr.ifr_ifru = ifr->ifr_ifru;
 
 	switch (cmd) {
-	case SIOCSHWTSTAMP:
-		if (!net_eq(dev_net(dev), dev_net(real_dev)))
-			break;
-		fallthrough;
 	case SIOCGMIIPHY:
 	case SIOCGMIIREG:
 	case SIOCSMIIREG:
-	case SIOCGHWTSTAMP:
 		if (netif_device_present(real_dev) && ops->ndo_eth_ioctl)
 			err = ops->ndo_eth_ioctl(real_dev, &ifrr, cmd);
 		break;
@@ -842,6 +858,8 @@ static const struct net_device_ops vlan_netdev_ops = {
 	.ndo_fix_features	= vlan_dev_fix_features,
 	.ndo_get_iflink		= vlan_dev_get_iflink,
 	.ndo_fill_forward_path	= vlan_dev_fill_forward_path,
+	.ndo_hwtstamp_get	= vlan_hwtstamp_get,
+	.ndo_hwtstamp_set	= vlan_hwtstamp_set,
 };
 
 static void vlan_dev_free(struct net_device *dev)
-- 
2.39.2

