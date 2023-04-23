Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5E36EBCA2
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 05:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjDWD2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 23:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjDWD2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 23:28:39 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C433268C
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:28:37 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-3294eacb2f6so8249045ab.3
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682220516; x=1684812516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X6ncj33axFGuFSNqzwi02ap0pe4Ng+6vF3DosaLcrFo=;
        b=fQy9CTKUG0L22usws+M5ZVn3UxJXTMl6i//ATEDOmL5kiiN+0VjPPBbj8lLVK1jzgg
         Vbu8AS5V3He6EUg0DsXZJq38hVRBkC7NT+pjn2dpnINnbQ8rEjI9TMPxkMrrK8YdPLdh
         p80QyTLJkPbYhTZrTDBwFJ+2wEHTsCs9GZClT6YMHZHGJSslrNWvUr6lvrFzpDwnzAHp
         v2df5P86NHRAMbRE9ckeGIfnBzWb/YyhBxsoc1/rHs+Ys0zH9dnmIOZsnGVu1B9SU+Xg
         6g9ou1lgFe2GZ1iIWsvuCY4+Y5ZgHh3I0Sy7r0GTxpW0zdL/1FaXcEqkWtWl8o0aw7wI
         gsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682220516; x=1684812516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6ncj33axFGuFSNqzwi02ap0pe4Ng+6vF3DosaLcrFo=;
        b=ErlFLUam3tAF221G4KALZaGzIN86BWRwk/7Ex+A04R7IWMpsL2P+u7RYxnV6PBQFx6
         wb1I//ORz6I6XjiV5NtrfBpe8wzdR00HyVJm2zh5XWNQBWRoZ6RRb5B88Sc832woQr+Z
         KD8HmGtliTWrS3amUUGlcLbLbbgnBvnXIpe5e2O7KoaSf6uJfVGUadz0wSmI7BsyGVCV
         +KvPFFh5vtco/TqXNj6gaFLhtJUZ9mFVraT0HQynw2KojbXdX+B1a6D71XVNfoWVWLpK
         w0rcU9imEPg1l+dBQAJU4+FQuJQEkrLc2ZKMTKW/E5ryaHda9thb8oRp0zMlxDry4ZG9
         MUFA==
X-Gm-Message-State: AAQBX9fJI+sqzjyueQ1gGgHCccXRBIz6mwIwIoqkotjDmtS1YTEHYAWV
        wCOnfrOFLFUiPtLklsni/Uk=
X-Google-Smtp-Source: AKy350YJCkf41Lbqop9xRXTdObTDu1KgSo4jSsAVqxIKfB2+YcVvTF3sdIkqyscsr5NRf2d4BGjHsg==
X-Received: by 2002:a6b:e50a:0:b0:763:5ead:f20b with SMTP id y10-20020a6be50a000000b007635eadf20bmr2857912ioc.16.1682220516304;
        Sat, 22 Apr 2023 20:28:36 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id t14-20020a5d884e000000b00760a612675dsm2158330ios.16.2023.04.22.20.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 20:28:35 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v4 3/5] Add ndo_hwtstamp_get/set support to vlan/maxvlan code path
Date:   Sat, 22 Apr 2023 21:28:35 -0600
Message-Id: <20230423032835.285406-1-glipus@gmail.com>
X-Mailer: git-send-email 2.39.2
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
  Changes in v4:
  - Moved hw timestamp get/set request processing logic
    from vlan_dev_ioctl() to .ndo_hwtstamp_get/set callbacks.
  - Use the shared generic_hwtstamp_get/set_lower() functions
    to handle ndo_hwtstamp_get/set requests.
  - Applay the same changes to macvlan driver.
---
 drivers/net/macvlan.c | 34 +++++++++++++---------------------
 net/8021q/vlan_dev.c  | 25 ++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 26 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 4a53debf9d7c..32683d859f5f 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -868,31 +868,22 @@ static int macvlan_change_mtu(struct net_device *dev, int new_mtu)
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
-
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
+	return generic_hwtstamp_get_lower(real_dev, cfg, extack);
+}
 
-	if (!err)
-		ifr->ifr_ifru = ifrr.ifr_ifru;
+static int macvlan_hwtstamp_set(struct net_device *dev,
+				struct kernel_hwtstamp_config *cfg,
+				struct netlink_ext_ack *extack)
+{
+	struct net_device *real_dev = macvlan_dev_real_dev(dev);
 
-	return err;
+	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
 }
 
 /*
@@ -1193,7 +1184,6 @@ static const struct net_device_ops macvlan_netdev_ops = {
 	.ndo_stop		= macvlan_stop,
 	.ndo_start_xmit		= macvlan_start_xmit,
 	.ndo_change_mtu		= macvlan_change_mtu,
-	.ndo_eth_ioctl		= macvlan_eth_ioctl,
 	.ndo_fix_features	= macvlan_fix_features,
 	.ndo_change_rx_flags	= macvlan_change_rx_flags,
 	.ndo_set_mac_address	= macvlan_set_mac_address,
@@ -1212,6 +1202,8 @@ static const struct net_device_ops macvlan_netdev_ops = {
 #endif
 	.ndo_get_iflink		= macvlan_dev_get_iflink,
 	.ndo_features_check	= passthru_features_check,
+	.ndo_hwtstamp_get	= macvlan_hwtstamp_get,
+	.ndo_hwtstamp_set	= macvlan_hwtstamp_set,
 };
 
 static void macvlan_dev_free(struct net_device *dev)
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 5920544e93e8..38a31dca3bb9 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -353,6 +353,24 @@ static int vlan_dev_set_mac_address(struct net_device *dev, void *p)
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
+	return generic_hwtstamp_set_lower(real_dev, cfg, extack);
+}
+
 static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct net_device *real_dev = vlan_dev_priv(dev)->real_dev;
@@ -364,14 +382,9 @@ static int vlan_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
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
@@ -842,6 +855,8 @@ static const struct net_device_ops vlan_netdev_ops = {
 	.ndo_fix_features	= vlan_dev_fix_features,
 	.ndo_get_iflink		= vlan_dev_get_iflink,
 	.ndo_fill_forward_path	= vlan_dev_fill_forward_path,
+	.ndo_hwtstamp_get	= vlan_hwtstamp_get,
+	.ndo_hwtstamp_set	= vlan_hwtstamp_set,
 };
 
 static void vlan_dev_free(struct net_device *dev)
-- 
2.39.2

