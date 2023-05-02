Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43DDE6F3CBF
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbjEBEcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjEBEb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:31:59 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF4E4215
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 21:31:57 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id ca18e2360f4ac-76983b8a1f5so69870639f.0
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 21:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683001916; x=1685593916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilatR2KkApwPQ+dLScq/1Zwt9VdF0R2vfroZOKzv62I=;
        b=co/yAMlE5bPts3Or3JiDdPYEg3mtT7mk2dKdd2BIFH/uLlbCXl/gGDpeqEGOEa8Tx1
         3QkumJj5Rt9zIqapqaKOBExtlvwy+ogGuQ5M8wPa4uP0GVspmwH02lDMUhTdsdN3Hvxr
         +HZLpLkIOIf/N3MrKbEnV8WKuTNd8P98Uj+wGaXO6Vn+hRA7t5QMi1t95Swe8d2/yKK4
         0eZUsj1di7bZaT47pMCVAXnYzdK8i4zcjP8m86T4XciR8qo+qyIZ/Y2c+mw/i0I0Qj9E
         4ZFouY9pEBSRHuzNJ5pF/HnzBPFZ/WW4maL2TSy5G5I+oiKMF4FBFaBaU88V+P1I0phQ
         z6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683001916; x=1685593916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ilatR2KkApwPQ+dLScq/1Zwt9VdF0R2vfroZOKzv62I=;
        b=TT+3d0htRPJqlbojXx905XSupNAVg1HNvMaZNuPqKxOZL6Bgq36s8gppuf72XzUFQn
         uQ5n5n0APiIlQ2UpOOK65H69veHA38AolAV/UIKNrXLPfdpt0KA1XxcL8jh58vReaUJt
         YLVUBTAvfIgz+Zshf/49cCcC9lXcs0RHcRIzFxH9f6KBLoyFr8kQ+Vaxjxk/LYmqTQ7k
         3SxIE9c/9Y4MbyyRYbpd/8TLHIgU4JzLuD0daJ76ham3d4nSrV9sLpmThPfs9cuhfKTG
         CBnQXGLfS2zs1zqLxjXYvRPAs7u4N5DZy9cAr14SHJ8YFrk0c1Ikr6ADpB0lmoyhzIL8
         8TDw==
X-Gm-Message-State: AC+VfDy8X6g/AHlqPpjHgogYFurIy3xY2TvwJrDlBO3W8eDhm/YlifFY
        Qzc1ScHuJ+Gb8VjzkuTft0A=
X-Google-Smtp-Source: ACHHUZ5eaeQEXrMSydZi1EQEPAo/AvY0YkcjVyh/3yq3ZdrBZXofi8ZWUvxQw0GzOTXhQED1jqXO8Q==
X-Received: by 2002:a6b:5c0a:0:b0:760:ec21:a8af with SMTP id z10-20020a6b5c0a000000b00760ec21a8afmr13175972ioh.0.1683001916355;
        Mon, 01 May 2023 21:31:56 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d980a000000b0076373f90e46sm8239781iol.33.2023.05.01.21.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 21:31:55 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: [RFC PATCH net-next v6 3/5] vlan/macvlan: Add ndo_hwtstamp_get/set support to vlan/macvlan code path
Date:   Mon,  1 May 2023 22:31:48 -0600
Message-Id: <20230502043150.17097-4-glipus@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230502043150.17097-1-glipus@gmail.com>
References: <20230502043150.17097-1-glipus@gmail.com>
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

This patch makes VLAN and MACVLAN drivers to use the newly
introduced ndo_hwtstamp_get/set API to pass hw timestamp
requests to underlying NIC drivers in case if these drivers
implement ndo_hwtstamp_get/set functions. Otherwise VLAN
subsystems falls back to calling ndo_eth_ioctl.

Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
Notes:
  Changes in v6:
  - Patch title was updated. No code changes.
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
index 870e4935d6e6..66423eaad84d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -354,6 +354,27 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
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
@@ -365,14 +386,9 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
@@ -1081,6 +1097,8 @@ static const struct net_device_ops vlan_netdev_ops = {
 	.ndo_fix_features	= vlan_dev_fix_features,
 	.ndo_get_iflink		= vlan_dev_get_iflink,
 	.ndo_fill_forward_path	= vlan_dev_fill_forward_path,
+	.ndo_hwtstamp_get	= vlan_hwtstamp_get,
+	.ndo_hwtstamp_set	= vlan_hwtstamp_set,
 };
 
 static void vlan_dev_free(struct net_device *dev)
-- 
2.40.1

