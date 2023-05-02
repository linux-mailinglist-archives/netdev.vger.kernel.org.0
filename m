Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1256F3CBE
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbjEBEcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233286AbjEBEb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:31:57 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB249273A
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 21:31:55 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-76375982b6aso261956039f.1
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 21:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683001915; x=1685593915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i4dXJVblBjfmsi29jlImQ6psqGmHx6Xz2r6UEIXvBeI=;
        b=EbNt4whF2EfO/lIb9eZXgyIGmr4dc+NZT96OIBwQWgQBci72AO8av9jK25vESiR2j0
         3YcVaP8/TlPONzoHFwbmRtGnlKQS6kNh1e1MT0wfvsSijhUPWSmrCwUyYNb6I0xASiab
         bwYSUSWcRICSsX27ZIr1ZmrmKGFaRXIvhGvTp4MENV8/1X/VTIWakoKFp+c82i3OsbUu
         NoqOPosZOsFF6Sv8p3fpBH+0o2CH9KbgbD+9w+Z6UJuX4n/U574ozJpDbmn7IQlFQa1a
         imWV/Uh+sDKUMEfxTKgrUTZsdLLfvZXj5ef1fKVMTNWoLgPClhsS5M+VxpWaeJbhyTga
         IWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683001915; x=1685593915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i4dXJVblBjfmsi29jlImQ6psqGmHx6Xz2r6UEIXvBeI=;
        b=Ze8ykRyx0RFOczRlNxPkiBJlAVucvkAvHkLboPmKiVbQnhy/2vhTw5Z+YfC6cd6aeY
         uoSchH/eL2tIaUpU9Hc6BdDS7AcgAjg+IfNEpYSwz56N/tbiOEIstg3Q6M7Tkv/ZzGSR
         XBwy+DLIHRn1wp38s2xXBznQfkBqiuYIJqHsaxYIgfEXkPqiabZUXYzuuGT1EzdZ4jCA
         vx/DtM12Xdo6wApztXkmdnmoqCOixwqbjUjVPoWeBq6K0gMmGbbI6yGfS6bAWW1E7tPs
         Ssl5bYXXD+ZC6hH0dQLE5kqJUyA9ltOf+Wp7zaXl2hng7HfdC5W5LW3sGqyl9LlakM8v
         PLJA==
X-Gm-Message-State: AC+VfDzCID+VbjgdnqaHxkp0NPqfDQov7EC08crmPLh67NVLbaQTcG0z
        n1mmJr+MrQKg7fKIpKOBLkIVu8yb8oejlQ==
X-Google-Smtp-Source: ACHHUZ6xXKPfucFCAiG9mzSIFt2dQPi5P1FDSuz1ifD9N1ioLHUVx+2/MtafAxtvyt9NIfBGxlI3eQ==
X-Received: by 2002:a05:6602:20c8:b0:753:568:358e with SMTP id 8-20020a05660220c800b007530568358emr11832993ioz.20.1683001915158;
        Mon, 01 May 2023 21:31:55 -0700 (PDT)
Received: from lenovot480s.. (c-73-78-138-46.hsd1.co.comcast.net. [73.78.138.46])
        by smtp.gmail.com with ESMTPSA id a10-20020a5d980a000000b0076373f90e46sm8239781iol.33.2023.05.01.21.31.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 21:31:54 -0700 (PDT)
From:   Maxim Georgiev <glipus@gmail.com>
To:     kory.maincent@bootlin.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, glipus@gmail.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, liuhangbin@gmail.com
Subject: [RFC PATCH net-next v6 2/5] net: Add ifreq pointer field to kernel_hwtstamp_config structure
Date:   Mon,  1 May 2023 22:31:47 -0600
Message-Id: <20230502043150.17097-3-glipus@gmail.com>
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
  Changes in v6:
  - Patch title was updated. No code changes.
  Changes in v5:
  - kernel_hwtstamp_config kdoc is updated with the new field
    descriptions.
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
 include/linux/net_tstamp.h |  9 +++++
 include/linux/netdevice.h  |  6 +++
 net/core/dev_ioctl.c       | 80 +++++++++++++++++++++++++++++++++++---
 3 files changed, 89 insertions(+), 6 deletions(-)

diff --git a/include/linux/net_tstamp.h b/include/linux/net_tstamp.h
index 7c59824f43f5..91d2738bf0a0 100644
--- a/include/linux/net_tstamp.h
+++ b/include/linux/net_tstamp.h
@@ -11,6 +11,8 @@
  * @flags: see struct hwtstamp_config
  * @tx_type: see struct hwtstamp_config
  * @rx_filter: see struct hwtstamp_config
+ * @ifr: pointer to ifreq structure from the original IOCTL request
+ * @kernel_flags: possible flags defined by kernel_hwtstamp_flags below
  *
  * Prefer using this structure for in-kernel processing of hardware
  * timestamping configuration, over the inextensible struct hwtstamp_config
@@ -20,6 +22,13 @@ struct kernel_hwtstamp_config {
 	int flags;
 	int tx_type;
 	int rx_filter;
+	struct ifreq *ifr;
+	int kernel_flags;
+};
+
+/* possible values for kernel_hwtstamp_config->kernel_flags */
+enum kernel_hwtstamp_flags {
+	KERNEL_HWTSTAMP_FLAG_IFR_RESULT = BIT(0),
 };
 
 static inline void hwtstamp_config_to_kernel(struct kernel_hwtstamp_config *kernel_cfg,
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7160135ca540..42e96b12fd21 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3942,6 +3942,12 @@ int put_user_ifreq(struct ifreq *ifr, void __user *arg);
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
2.40.1

