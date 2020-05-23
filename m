Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 474081DF797
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 15:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387894AbgEWN1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 09:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387881AbgEWN12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 09:27:28 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73D5C08C5C4
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 06:27:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id u12so7875876wmd.3
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 06:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ONT3vRSeVRfEE12bPXzs+yYjP//BMjbMroWZWOBsM7g=;
        b=zXGySE29onLTxz3KlDEKLrBZoY6D4JfFiFwNCAQEsaN0Ue1lCSE0cFDtjB5glen5hf
         GpBUnIenKwWi8UyeKz9QEs+24f7Ew6x1qeX/2zG8bze2muYu/Z/ExTsKrBWsykAXN+VA
         sr3LHySTm7WGu7mIc7Qtyp4SgPSTIk4yBfKpE7Hbn121fk66KsH3Br0OhrzjMWsGOVpH
         MjT2tOUaB/PC3Kvg9BiAVE+sb1fQeHj/KA47f4HERf78tYLh/PfIAmhULEzLHMzjs3KI
         EBgrzPb21BrFyh7XwJ/KdeCcdgruYTjLs7YfHGNDlxjOwY/waUeoZFx7rXmiSkjv267s
         rwmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ONT3vRSeVRfEE12bPXzs+yYjP//BMjbMroWZWOBsM7g=;
        b=KWAk4We/mwKs5fTCsGs2ZejRS2pUgDOdfj+2vNu/PRl4DF2rkJq6P9/Ieey5SnoCI4
         VcX6CHUfp/RRzFaXgpGjaOx2EYgAgw19yOHrh9+il8OobkDtjlpkb49glkJu49sOjvBw
         pNydHWOYf6gnbdIJZ5Ysy7XfXEUQ0uqexG50keEhDsMaG1Zsqsr5/vh+7T9nSnEUbFve
         pJEHVx0/On1Uw5pV0cSQV0zjW+cpoX5MYDk1dWtR/aLF025mi9hvAhKIPad2ZAGyUKaE
         GH33K4id3u/1sQcxbKwsLEZu8JMV1AnFrmY/B8+FG7pChW+6LCeKwlpSShib78dJCiy/
         8nwQ==
X-Gm-Message-State: AOAM5310vXS6GOBXcabxdbSihdFYcXpBtEXpk54OHNb8vgVV2gdy7DXI
        zwxhRIuwMEjx6TwKlCtMpdXrtw==
X-Google-Smtp-Source: ABdhPJyCQeCyp/Z7zfBD8KySrZNmyBzGf1kVuRCo1R5Ao5q3l4Ezr4kGNvE/pPs4RmWXLElvmDBbfw==
X-Received: by 2002:a1c:4e0c:: with SMTP id g12mr964734wmh.25.1590240445253;
        Sat, 23 May 2020 06:27:25 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id g69sm8098703wmg.15.2020.05.23.06.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 06:27:24 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 4/5] net: devres: provide devm_register_netdev()
Date:   Sat, 23 May 2020 15:27:10 +0200
Message-Id: <20200523132711.30617-5-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200523132711.30617-1-brgl@bgdev.pl>
References: <20200523132711.30617-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Provide devm_register_netdev() - a device resource managed variant
of register_netdev(). This new helper will only work for net_device
structs that are also already managed by devres.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../driver-api/driver-model/devres.rst        |  1 +
 include/linux/netdevice.h                     |  2 +
 net/devres.c                                  | 55 +++++++++++++++++++
 3 files changed, 58 insertions(+)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index 50df28d20fa7..fc242ed4bde5 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -375,6 +375,7 @@ MUX
 NET
   devm_alloc_etherdev()
   devm_alloc_etherdev_mqs()
+  devm_register_netdev()
 
 PER-CPU MEM
   devm_alloc_percpu()
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a18f8fdf4260..1a96e9c4ec36 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4280,6 +4280,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 int register_netdev(struct net_device *dev);
 void unregister_netdev(struct net_device *dev);
 
+int devm_register_netdev(struct device *dev, struct net_device *ndev);
+
 /* General hardware address lists handling functions */
 int __hw_addr_sync(struct netdev_hw_addr_list *to_list,
 		   struct netdev_hw_addr_list *from_list, int addr_len);
diff --git a/net/devres.c b/net/devres.c
index b97b0c5a8216..57a6a88d11f6 100644
--- a/net/devres.c
+++ b/net/devres.c
@@ -38,3 +38,58 @@ struct net_device *devm_alloc_etherdev_mqs(struct device *dev, int sizeof_priv,
 	return dr->ndev;
 }
 EXPORT_SYMBOL(devm_alloc_etherdev_mqs);
+
+static void devm_netdev_release(struct device *dev, void *this)
+{
+	struct net_device_devres *res = this;
+
+	unregister_netdev(res->ndev);
+}
+
+static int netdev_devres_match(struct device *dev, void *this, void *match_data)
+{
+	struct net_device_devres *res = this;
+	struct net_device *ndev = match_data;
+
+	return ndev == res->ndev;
+}
+
+/**
+ *	devm_register_netdev - resource managed variant of register_netdev()
+ *	@dev: managing device for this netdev - usually the parent device
+ *	@ndev: device to register
+ *
+ *	This is a devres variant of register_netdev() for which the unregister
+ *	function will be call automatically when the managing device is
+ *	detached. Note: the net_device used must also be resource managed by
+ *	the same struct device.
+ */
+int devm_register_netdev(struct device *dev, struct net_device *ndev)
+{
+	struct net_device_devres *dr;
+	int ret;
+
+	/* struct net_device must itself be managed. For now a managed netdev
+	 * can only be allocated by devm_alloc_etherdev_mqs() so the check is
+	 * straightforward.
+	 */
+	if (WARN_ON(!devres_find(dev, devm_free_netdev,
+				 netdev_devres_match, ndev)))
+		return -EINVAL;
+
+	dr = devres_alloc(devm_netdev_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	ret = register_netdev(ndev);
+	if (ret) {
+		devres_free(dr);
+		return ret;
+	}
+
+	dr->ndev = ndev;
+	devres_add(ndev->dev.parent, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL(devm_register_netdev);
-- 
2.25.0

