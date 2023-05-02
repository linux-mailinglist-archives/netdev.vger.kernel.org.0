Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0D66F3CBD
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233273AbjEBEb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjEBEb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:31:56 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FFC273F
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 21:31:55 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-763ae160c47so274301339f.3
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 21:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683001914; x=1685593914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZiQrbOmYut+4xGG+JMRh4ps4Y3zfa3UhXGIHY+uYOs=;
        b=bOSXH8EdqtvYGUd6OT+VzGeXpe6znOVUr0p+AFR+vw2SjXMHHmWM3UJX5TnWsDnQhh
         352f3WrMZl2MLZY3EMgQUqF0SVtn8V0t2Mo1NO3DJy+R5zK4r0xwF7aUa5ivMpnwXeI0
         nAmyO5Bcd1bsNWld9lSMZRMjpZOjiQE9DV7Zo2IE+S2uVZOk8edUteS7lB9sm+nhPCMl
         pk43Y8Ne4qeUJuNGXOsMHzAHBdbgXQBxmQW4bsvCQfmcueU2+j6wQnBNPzuF06ZypSQ7
         4Y7x78kqzuJkWsABgFpiEJ4jDXoNy2p5CESRwu7zlumQYy+KEhaPrjo9GkXhxdclMp2j
         R1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683001914; x=1685593914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZiQrbOmYut+4xGG+JMRh4ps4Y3zfa3UhXGIHY+uYOs=;
        b=MIfuksmY80WqItCYd42Y+fPOdP0TJdI9qBDph/1WuCqHDhpziycf22GmAXnZExDeLW
         UyOcrzJhRFDpMJYh2mvvh2AEwXS3wQMUpNfMXzQBNcTsdygZ5KGDaK40LwlgGLz+oTRL
         SvOmPpnT42G6KUxyVfFTo9eokc2G1lPaYpMX5oHsEGexIwTh23cVd/BIcIDMbLGuvShV
         AKyoRJ7avbkenLww2VhWM9AErD744Z+EkMSeEfdm5o1+mvUZfa0mS+mExUiSA7F1Uu93
         n0J930iOOGQkUB7JiNeE2XS9PHkkQ0QJOea+Mmyg9YvIG8kpC84cKqVGM4E/tBTazATl
         aUEw==
X-Gm-Message-State: AC+VfDzaP1suoo4hqUSbcha7rHEB6YbiS1d5mv37Oo355i6GztsqRrmc
        kDHNnhdoKr5criLcwcd6uvY=
X-Google-Smtp-Source: ACHHUZ6SG1SA6V0cE1ZGhdr0ej8LSo1btA6W2Kzgeq/i1brWV0hjPX5K70zu/DtFnjuzO+fnPcSw4Q==
X-Received: by 2002:a05:6602:22d5:b0:760:debf:6c42 with SMTP id e21-20020a05660222d500b00760debf6c42mr10129034ioe.20.1683001914275;
        Mon, 01 May 2023 21:31:54 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d980a000000b0076373f90e46sm8239781iol.33.2023.05.01.21.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 21:31:53 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: [RFC PATCH net-next v6 1/5] net: Add NDOs for hardware timestamp get/set
Date:   Mon,  1 May 2023 22:31:46 -0600
Message-Id: <20230502043150.17097-2-glipus@gmail.com>
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
Notes:
  Changes in v6:
  - The patch title was updated. No code changes.
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
index 08fbd4622ccf..7160135ca540 100644
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
2.40.1

