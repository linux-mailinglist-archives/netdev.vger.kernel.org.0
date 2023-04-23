Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34186EBCA0
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 05:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjDWD1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 23:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjDWD1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 23:27:50 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 948521FCC
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:27:49 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-760f4dcfdf4so321261439f.2
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682220469; x=1684812469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wo/pA3JfWPnhr3873Y/T/4AhC8WxshHyfwZ3E9LgLtg=;
        b=KbzYHFLp/CKU2WRzwsKeSwHRcQfdQRDROS2yPjdJ/Qx0MISC7LUbiu7IB7EycerCW6
         OzR4M8Yiy2ANB+GwF6ED5fZv9006CYVjjq3ij6rWk3e1uYipgNm1/8cjW/5DUUV1+NSU
         0L44DvDVWAs9EnlDjjstII3AOBUrRRXstLbevd1ZC1+tcNm3gQHg3YcHifWWc+EaSsof
         gt4Hn7JRx/vLBMC2Rn3r62r4muYvHweD5qrbUqoUaP7t5zlMZnYBZ7B9xcrN983w3H57
         wWvegiJvg5af8AcVfXclyvsWIpFfmJTh2rD+6FU9n2YEpt7p0OwHdemQXHrNClnAy3L0
         vRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682220469; x=1684812469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wo/pA3JfWPnhr3873Y/T/4AhC8WxshHyfwZ3E9LgLtg=;
        b=Ty0keo9D/vqcjbfFUdrra9avTJJnl1PyaM+cNuD148yOyg6oEhuUv3zaMYE0qxnsuc
         s829P3R02IFnOjgZQBT0sTI7b0wX4rDp8KQqkaA1RiL7NtnrYoN95JUK9m8d05eFISJO
         rvjrr4nVhD9d3c5wyEGl5J8yvVGDamtW043KBWmLav7/C1nKhb4hIQI8MlfxOziZEA04
         NUDW2DaNDVrpl9iOYLVcn/H+KMZmUv1AkhtT0YsyiKHEiw4irg47gNHcIJLfaPib2q/5
         bqTix5oVBodPvHkTFC99p17RJDaRgXIuG1VU0YukMSt6Qa+CFMcREfkcvMGIZh3IOtgG
         pnBA==
X-Gm-Message-State: AAQBX9dRzFoQ5V7HZJjR8uMDlK2sqQBqXQBecw1IW+LtCounVyhztRed
        wzJ0PGOaEpU6XsOiSbvRJ2c=
X-Google-Smtp-Source: AKy350abqy6y0H/62WCfNBzyddlPYKZYZnUaPxGzuFvEQxBOiHkzaYycDlD9qHWwDq+v6+mNBxKS9w==
X-Received: by 2002:a5e:aa07:0:b0:752:ee32:322d with SMTP id s7-20020a5eaa07000000b00752ee32322dmr2915494ioe.18.1682220468890;
        Sat, 22 Apr 2023 20:27:48 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id y24-20020a027318000000b0040fbc31614esm2357450jab.54.2023.04.22.20.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 20:27:48 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v4 1/5] Add NDOs for hardware timestamp get/set
Date:   Sat, 22 Apr 2023 21:27:47 -0600
Message-Id: <20230423032747.285295-1-glipus@gmail.com>
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

Current NIC driver API demands drivers supporting hardware timestamping
to implement handling logic for SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs.
Handling these IOCTLs requires dirivers to implement request parameter
structure translation between user and kernel address spaces, handling
possible translation failures, etc. This translation code is pretty much
identical across most of the NIC drivers that support SIOCGHWTSTAMP/
SIOCSHWTSTAMP.
This patch extends NDO functiuon set with ndo_hwtstamp_get/set
functions, implements SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTL translation
to ndo_hwtstamp_get/set function calls including parameter structure
translation and translation error handling.

This patch is sent out as RFC.
It still pending on basic testing.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>
---
Changes in v4:
- Renamed hwtstamp_kernel_to_config() function to
  hwtstamp_config_from_kernel().
- Added struct kernel_hwtstamp_config zero initialization
  in dev_get_hwtstamp() and in dev_get_hwtstamp().

Changes in v3:
- Moved individual driver conversions to separate patches

Changes in v2:
- Introduced kernel_hwtstamp_config structure
- Added netlink_ext_ack* and kernel_hwtstamp_config* as NDO hw timestamp
  function parameters
- Reodered function variable declarations in dev_hwtstamp()
- Refactored error handling logic in dev_hwtstamp()
- Split dev_hwtstamp() into GET and SET versions
- Changed net_hwtstamp_validate() to accept struct hwtstamp_config *
  as a parameter
---
 include/linux/net_tstamp.h |  8 ++++++++
 include/linux/netdevice.h  | 16 +++++++++++++++
 net/core/dev_ioctl.c       | 42 +++++++++++++++++++++++++++++++++++---
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
index fd67f3cc0c4b..7c59824f43f5 100644
--- a/include/linux/net_tstamp.h
+++ b/include/linux/net_tstamp.h
@@ -30,4 +30,12 @@ static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kern
 	kernel_cfg->rx_filter = cfg->rx_filter;
 }
 
+static inline void hwtstamp_config_from_kernel(struct hwtstamp_config *cfg,
+					       const struct kernel_hwtstamp_config *kernel_cfg)
+{
+	cfg->flags = kernel_cfg->flags;
+	cfg->tx_type = kernel_cfg->tx_type;
+	cfg->rx_filter = kernel_cfg->rx_filter;
+}
+
 #endif /* _LINUX_NET_TIMESTAMPING_H_ */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a6a3e9457d6c..ea10fb1dd6fc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -57,6 +57,7 @@
 struct netpoll_info;
 struct device;
 struct ethtool_ops;
+struct kernel_hwtstamp_config;
 struct phy_device;
 struct dsa_port;
 struct ip_tunnel_parm;
@@ -1415,6 +1416,15 @@ struct netdev_net_notifier {
  *	Get hardware timestamp based on normal/adjustable time or free running
  *	cycle counter. This function is required if physical clock supports a
  *	free running cycle counter.
+ *	int (*ndo_hwtstamp_get)(struct net_device *dev,
+ *				struct kernel_hwtstamp_config *kernel_config,
+ *				struct netlink_ext_ack *extack);
+ *	Get hardware timestamping parameters currently configured for NIC
+ *	device.
+ *	int (*ndo_hwtstamp_set)(struct net_device *dev,
+ *				struct kernel_hwtstamp_config *kernel_config,
+ *				struct netlink_ext_ack *extack);
+ *	Set hardware timestamping parameters for NIC device.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1649,6 +1659,12 @@ struct net_device_ops {
 	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
 						  const struct skb_shared_hwtstamps *hwtstamps,
 						  bool cycles);
+	int			(*ndo_hwtstamp_get)(struct net_device *dev,
+						    struct kernel_hwtstamp_config *kernel_config,
+						    struct netlink_ext_ack *extack);
+	int			(*ndo_hwtstamp_set)(struct net_device *dev,
+						    struct kernel_hwtstamp_config *kernel_config,
+						    struct netlink_ext_ack *extack);
 };
 
 struct xdp_metadata_ops {
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 3730945ee294..a157b9ab5237 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -254,12 +254,33 @@ static int dev_eth_ioctl(struct net_device *dev,
 
 static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
-	return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct kernel_hwtstamp_config kernel_cfg = {};
+	struct hwtstamp_config config;
+	int err;
+
+	if (!ops->ndo_hwtstamp_get)
+		return dev_eth_ioctl(dev, ifr, SIOCGHWTSTAMP);
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	err = ops->ndo_hwtstamp_get(dev, &kernel_cfg, NULL);
+	if (err)
+		return err;
+
+	hwtstamp_config_from_kernel(&config, &kernel_cfg);
+
+	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 {
-	struct kernel_hwtstamp_config kernel_cfg;
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct kernel_hwtstamp_config kernel_cfg = {};
 	struct netlink_ext_ack extack = {};
 	struct hwtstamp_config cfg;
 	int err;
@@ -280,7 +301,22 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 		return err;
 	}
 
-	return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
+	if (!ops->ndo_hwtstamp_set)
+		return dev_eth_ioctl(dev, ifr, SIOCSHWTSTAMP);
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	err = ops->ndo_hwtstamp_set(dev, &kernel_cfg, NULL);
+	if (err)
+		return err;
+
+	hwtstamp_config_from_kernel(&cfg, &kernel_cfg);
+
+	if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
+		return -EFAULT;
+
+	return 0;
 }
 
 static int dev_siocbond(struct net_device *dev,
-- 
2.39.2

