Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794AA6EBCA1
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 05:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjDWD2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 23:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjDWD2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 23:28:21 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80FF81FCC
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:28:19 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7606d44dbb5so322253839f.1
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 20:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682220499; x=1684812499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3GgoE2aOQOI5zItubNE1qgEZS1ikxgaHXPxaumgsPxE=;
        b=n/5DV0ulQhMkbgG1W6ufUeXLvXKMrs6M2IQ4iOHvYm0/YftlLaH2bfJVgqSe9Kd5gR
         7oNmDuT/Fkw6Ayh6gwCRferNnOQFWVjEGGqF8bKKiwVV685TWhkEJcomsqxITBMAmZMp
         jdSPFhraDbDE77WC/zx1PjnJCYFujclXlsPCDRzv2SpeDsVJMQBzKIF3oL6JWPq32cgI
         SDZ5sK0WLSgeyaoMGvPszI/elESJ/9mtI9fFObvGrYGwOFHgL5H8TDfdsn4Ovh6KOuvP
         YPIB2gcalXDQUcO1j4dyFdkwQKDcYrYoJHSYwbi4CuhxbuOEEtrF+ScU5iRRIWBXDXFX
         bwNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682220499; x=1684812499;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3GgoE2aOQOI5zItubNE1qgEZS1ikxgaHXPxaumgsPxE=;
        b=SN/3q1lcqYLAk0/ipI6TboAjwwYUnuqEddQ11yWpghQIPqgLH8XLWQ69qRYF51I3st
         JhFO6K46FPx79SmHxjcpDSZLTEZPdm/Wtf17A5sLHx3diofqR9oOgAmnW/nQuzIS1khW
         /h1e8VnyhWR5BASG3n95BiIS7RgTS/My9sF2Dx8jMq/7zKB+lLq1FUifwEaxiyo0micD
         flVwp4HwBd8pmynJCPrfgmHHtx5dkqphtfhk/OOnnbqQ6kutiKbLUTSLAkVds+ledwZ/
         JYtDcIMJI6KsMQ/8HTG0k0nnTCJHWWlW7WqlZ9sBqCZwN4RhqTmM3EJLevsEKBSL2amZ
         OhGw==
X-Gm-Message-State: AAQBX9cYUsqDrJpprkJsn8kfZkBA3aOfUuiTfL/oVhhvZPHlSQyippjE
        8Tk1pH4HkxhQaK517t46URU=
X-Google-Smtp-Source: AKy350ZhkZnXPMOu3Z5ALAOuHuTcE6+V0V/EoWGq9TgUkaY/ARfJpVAZnNRNXjUbdnABUk+V9mZPTQ==
X-Received: by 2002:a6b:f315:0:b0:74c:ae72:dc16 with SMTP id m21-20020a6bf315000000b0074cae72dc16mr2983099ioh.5.1682220498817;
        Sat, 22 Apr 2023 20:28:18 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id 18-20020a5d9c52000000b0076350d7c4b6sm1275122iof.36.2023.04.22.20.28.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 20:28:18 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: [RFC PATCH v4 2/5] Add ifreq pointer field to kernel_hwtstamp_config structure
Date:   Sat, 22 Apr 2023 21:28:17 -0600
Message-Id: <20230423032817.285371-1-glipus@gmail.com>
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

Considering the stackable nature of drivers there will be situations
where a driver implementing ndo_hwtstamp_get/set functions will have
to translate requests back to SIOCGHWTSTAMP/SIOCSHWTSTAMP IOCTLs
to pass them to lower level drivers that do not provide
ndo_hwtstamp_get/set callbacks. To simplify request translation in
such scenarios let's include a pointer to the original struct ifreq
to kernel_hwtstamp_config structure.

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Georgiev <glipus@gmail.com>

Notes:

  Changes in V4:
  - Introducing KERNEL_HWTSTAMP_FLAG_IFR_RESULT flag indicating that
    the operation results are returned in the ifr referred by
    struct kernel_hwtstamp_config instead of kernel_hwtstamp_config
    glags/tx_type/rx_filter fields.
  - Implementing generic_hwtstamp_set/set_lower() functions
    which will be used by vlan, maxvlan, bond and potentially
    other drivers translating ndo_hwtstamp_set/set calls to
    lower level drivers.
---
 include/linux/net_tstamp.h |  7 ++++
 include/linux/netdevice.h  |  6 +++
 net/core/dev_ioctl.c       | 80 +++++++++++++++++++++++++++++++++++---
 3 files changed, 87 insertions(+), 6 deletions(-)

diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
index 7c59824f43f5..5164dce3f9a0 100644
--- a/include/linux/net_tstamp.h
+++ b/include/linux/net_tstamp.h
@@ -20,6 +20,13 @@ struct kernel_hwtstamp_config {
 	int flags;
 	int tx_type;
 	int rx_filter;
+	struct ifreq *ifr;
+	int kernel_flags;
+};
+
+/* possible values for kernel_hwtstamp_config->kernel_flags */
+enum kernel_hwtstamp_flags {
+	KERNEL_HWTSTAMP_FLAG_IFR_RESULT = (1 << 0),
 };
 
 static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kernel_cfg,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ea10fb1dd6fc..40f4018b13f2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3939,6 +3939,12 @@ int put_user_ifreq(struct ifreq *ifr, void __user *arg);
 int dev_ioctl(struct net *net, unsigned int cmd, struct ifreq *ifr,
 		void __user *data, bool *need_copyout);
 int dev_ifconf(struct net *net, struct ifconf __user *ifc);
+int generic_hwtstamp_set_lower(struct net_device *dev,
+			       struct kernel_hwtstamp_config *kernel_cfg,
+			       struct netlink_ext_ack *extack);
+int generic_hwtstamp_get_lower(struct net_device *dev,
+			       struct kernel_hwtstamp_config *kernel_cfg,
+			       struct netlink_ext_ack *extack);
 int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *userdata);
 unsigned int dev_get_flags(const struct net_device *);
 int __dev_change_flags(struct net_device *dev, unsigned int flags,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index a157b9ab5237..da1d2391822f 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -265,14 +265,17 @@ static int dev_get_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 	if (!netif_device_present(dev))
 		return -ENODEV;
 
+	kernel_cfg.ifr = ifr;
 	err = ops->ndo_hwtstamp_get(dev, &kernel_cfg, NULL);
 	if (err)
 		return err;
 
-	hwtstamp_config_from_kernel(&config, &kernel_cfg);
+	if (!(kernel_cfg.kernel_flags & KERNEL_HWTSTAMP_FLAG_IFR_RESULT)) {
+		hwtstamp_config_from_kernel(&config, &kernel_cfg);
 
-	if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
-		return -EFAULT;
+		if (copy_to_user(ifr->ifr_data, &config, sizeof(config)))
+			return -EFAULT;
+	}
 
 	return 0;
 }
@@ -289,6 +292,7 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 		return -EFAULT;
 
 	hwtstamp_config_to_kernel(&kernel_cfg, &cfg);
+	kernel_cfg.ifr = ifr;
 
 	err = net_hwtstamp_validate(&kernel_cfg);
 	if (err)
@@ -311,14 +315,78 @@ static int dev_set_hwtstamp(struct net_device *dev, struct ifreq *ifr)
 	if (err)
 		return err;
 
-	hwtstamp_config_from_kernel(&cfg, &kernel_cfg);
+	if (!(kernel_cfg.kernel_flags & KERNEL_HWTSTAMP_FLAG_IFR_RESULT)) {
+		hwtstamp_config_from_kernel(&cfg, &kernel_cfg);
 
-	if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
-		return -EFAULT;
+		if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)))
+			return -EFAULT;
+	}
 
 	return 0;
 }
 
+int generic_hwtstamp_set_lower(struct net_device *dev,
+			       struct kernel_hwtstamp_config *kernel_cfg,
+			       struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct ifreq ifrr;
+	int err;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	if (ops->ndo_hwtstamp_set) {
+		kernel_cfg->kernel_flags &= ~KERNEL_HWTSTAMP_FLAG_IFR_RESULT;
+		err = ops->ndo_hwtstamp_set(dev, kernel_cfg, extack);
+		return err;
+	}
+
+	if (!kernel_cfg->ifr)
+		return -EOPNOTSUPP;
+
+	strscpy_pad(ifrr.ifr_name, dev->name, IFNAMSIZ);
+	ifrr.ifr_ifru = kernel_cfg->ifr->ifr_ifru;
+	err = dev_eth_ioctl(dev, &ifrr, SIOCSHWTSTAMP);
+	if (!err) {
+		kernel_cfg->ifr->ifr_ifru = ifrr.ifr_ifru;
+		kernel_cfg->kernel_flags |= KERNEL_HWTSTAMP_FLAG_IFR_RESULT;
+	}
+	return err;
+}
+EXPORT_SYMBOL(generic_hwtstamp_set_lower);
+
+int generic_hwtstamp_get_lower(struct net_device *dev,
+			       struct kernel_hwtstamp_config *kernel_cfg,
+			       struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct ifreq ifrr;
+	int err;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	if (ops->ndo_hwtstamp_get) {
+		kernel_cfg->kernel_flags &= ~KERNEL_HWTSTAMP_FLAG_IFR_RESULT;
+		err = ops->ndo_hwtstamp_get(dev, kernel_cfg, extack);
+		return err;
+	}
+
+	if (!kernel_cfg->ifr)
+		return -EOPNOTSUPP;
+
+	strscpy_pad(ifrr.ifr_name, dev->name, IFNAMSIZ);
+	ifrr.ifr_ifru = kernel_cfg->ifr->ifr_ifru;
+	err = dev_eth_ioctl(dev, &ifrr, SIOCGHWTSTAMP);
+	if (!err) {
+		kernel_cfg->ifr->ifr_ifru = ifrr.ifr_ifru;
+		kernel_cfg->kernel_flags |= KERNEL_HWTSTAMP_FLAG_IFR_RESULT;
+	}
+	return err;
+}
+EXPORT_SYMBOL(generic_hwtstamp_get_lower);
+
 static int dev_siocbond(struct net_device *dev,
 			struct ifreq *ifr, unsigned int cmd)
 {
-- 
2.39.2

