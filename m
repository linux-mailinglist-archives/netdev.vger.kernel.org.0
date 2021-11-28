Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9B460633
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 13:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242823AbhK1Mor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 07:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357448AbhK1Mmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 07:42:45 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CC75C0613E0
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:52 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id z8so28946417ljz.9
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 04:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1EfcGdLjQUtK7/5MZ3LTCPhBBgh6JFpaX3qkMx9GGyA=;
        b=DVhW81hrjMa8XpqZ335BvysMZxYu+Tq1u9d53Xa4khI1uaoCy9H1UPdZ+zw5+hNEPC
         UgSFvwm4MVCAk5EPAzDRW/74rDVymVNszFMUD0MUd7JE9+D9t37VDdvvdnWRMzB6rtvg
         9uDquM3BbtRRATTXoR4eDV5KLFNiMbkYM2Ntr7rcQ3kE9HY2nUgoLayBRxZGxicIpsOu
         dhxUqU4rBD//knoylX+Dg8IEec4LIvnil2IZvHB5H2xzaq+kYDPnjg/J93IPvfTTYQU0
         9Wh+MOkEIKQskfWjOsDvH90tg7YgYNKn/+uZgsUjS15gZ2v1qjb2DXibJLwPErcsjLQM
         hZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1EfcGdLjQUtK7/5MZ3LTCPhBBgh6JFpaX3qkMx9GGyA=;
        b=KnZCyimJ4RP73QkTLAmfrPWc/Hmg3XhV/Q3TEqSnE91S8LTQnfo/1zfxUraUcev4Qs
         u74JdeKRk6QLVq/Aeos8uDooF6mv0Ey7T3CLgULH6zxNqPhAkUOhthwrr+6tgbtRKX9+
         j8B0nG853n+jymnKf9gOqJaL2dD8GGiI2/+tS7TsxUxpzH8IAdkCmjNj6tsBnObcmPGf
         biR6Ew+tLJH8im3HNQViM8tljWZTFPXXXgctUOva/U9h3Xapeizq+i1Lfxl53EvitgTg
         zS8MAwTie8ebUGlg3I+Z6xucxvAwI2Q3Rj8rl0nO+IqF84X7PA2AeKcsHwvHWpacHvZ6
         mCug==
X-Gm-Message-State: AOAM530d1l+xb7hDxsms3CauQpym1UGvK78oxVytWTf/TZ4rN3cSdTXk
        Aj6PiDl8IzaaDU+r9jgsq7g=
X-Google-Smtp-Source: ABdhPJwUsqNplg89zv0PwwxznW/Tv5cNWkmB99pdFoeGDrcuo9xPPCYwDnrmpwucWPTWiqzE3CZTFA==
X-Received: by 2002:a05:651c:1503:: with SMTP id e3mr43602086ljf.182.1638103130871;
        Sun, 28 Nov 2021 04:38:50 -0800 (PST)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id v198sm976533lfa.89.2021.11.28.04.38.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Nov 2021 04:38:50 -0800 (PST)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, M Chetan Kumar <m.chetan.kumar@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/5] net: wwan: core: make debugfs optional
Date:   Sun, 28 Nov 2021 15:38:37 +0300
Message-Id: <20211128123837.22829-6-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
References: <20211128123837.22829-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current WWAN debugfs interface does not take too much space, but it is
useless without driver-specific debugfs interfaces. To avoid overloading
debugfs with empty directories, make the common WWAN debugfs interface
optional. And force its selection if any driver-specific interface (only
IOSM at the moment) is enabled by user.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/Kconfig     | 9 +++++++++
 drivers/net/wwan/wwan_core.c | 8 ++++++++
 include/linux/wwan.h         | 7 +++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig
index e204e74edcec..6e1ef08650c9 100644
--- a/drivers/net/wwan/Kconfig
+++ b/drivers/net/wwan/Kconfig
@@ -16,6 +16,14 @@ config WWAN
 
 if WWAN
 
+config WWAN_DEBUGFS
+	bool "WWAN subsystem common debugfs interface"
+	depends on DEBUG_FS
+	help
+	  Enables common debugfs infrastructure for WWAN devices.
+
+	  If unsure, say N.
+
 config WWAN_HWSIM
 	tristate "Simulated WWAN device"
 	help
@@ -83,6 +91,7 @@ config IOSM
 config IOSM_DEBUGFS
 	bool "IOSM Debugfs support"
 	depends on IOSM && DEBUG_FS
+	select WWAN_DEBUGFS
 	help
 	  Enables debugfs driver interface for traces collection.
 
diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 5bf62dc35ac7..b41104129d1a 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -146,6 +146,7 @@ static struct wwan_device *wwan_dev_get_by_name(const char *name)
 	return to_wwan_dev(dev);
 }
 
+#ifdef CONFIG_WWAN_DEBUGFS
 struct dentry *wwan_get_debugfs_dir(struct device *parent)
 {
 	struct wwan_device *wwandev;
@@ -157,6 +158,7 @@ struct dentry *wwan_get_debugfs_dir(struct device *parent)
 	return wwandev->debugfs_dir;
 }
 EXPORT_SYMBOL_GPL(wwan_get_debugfs_dir);
+#endif
 
 /* This function allocates and registers a new WWAN device OR if a WWAN device
  * already exist for the given parent, it gets a reference and return it.
@@ -207,8 +209,10 @@ static struct wwan_device *wwan_create_dev(struct device *parent)
 	}
 
 	wwandev_name = kobject_name(&wwandev->dev.kobj);
+#ifdef CONFIG_WWAN_DEBUGFS
 	wwandev->debugfs_dir = debugfs_create_dir(wwandev_name,
 						  wwan_debugfs_dir);
+#endif
 
 done_unlock:
 	mutex_unlock(&wwan_register_lock);
@@ -240,7 +244,9 @@ static void wwan_remove_dev(struct wwan_device *wwandev)
 		ret = device_for_each_child(&wwandev->dev, NULL, is_wwan_child);
 
 	if (!ret) {
+#ifdef CONFIG_WWAN_DEBUGFS
 		debugfs_remove_recursive(wwandev->debugfs_dir);
+#endif
 		device_unregister(&wwandev->dev);
 	} else {
 		put_device(&wwandev->dev);
@@ -1140,7 +1146,9 @@ static int __init wwan_init(void)
 		goto destroy;
 	}
 
+#ifdef CONFIG_WWAN_DEBUGFS
 	wwan_debugfs_dir = debugfs_create_dir("wwan", NULL);
+#endif
 
 	return 0;
 
diff --git a/include/linux/wwan.h b/include/linux/wwan.h
index 1646aa3e6779..b84ccf7d34da 100644
--- a/include/linux/wwan.h
+++ b/include/linux/wwan.h
@@ -171,6 +171,13 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 
 void wwan_unregister_ops(struct device *parent);
 
+#ifdef CONFIG_WWAN_DEBUGFS
 struct dentry *wwan_get_debugfs_dir(struct device *parent);
+#else
+static inline struct dentry *wwan_get_debugfs_dir(struct device *parent)
+{
+	return NULL;
+}
+#endif
 
 #endif /* __WWAN_H */
-- 
2.32.0

