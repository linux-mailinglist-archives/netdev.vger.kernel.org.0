Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9BAB1D297B
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgENIBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726147AbgENIAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:20 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D110CC061A0E
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id w7so2555394wre.13
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fUZXOnych6qxhX4bjLeYEoW62tw45yoi4lvLz/fDZMU=;
        b=r+BJUHQIIa1axFh6WUc2DdvLc0SNaDkJzsiGYipq89vB/+fXNjYGdskx0PK6KLYu9Q
         fKqyJyLI0YmBJ0jHwnP7dK5acWOLOi3UNd/CPOVaw7M+6SLsx9FY7GKR+qTRSd+R2aB8
         FuCV9RfTAXq3uBTv2q4twSBcPYt3wgFVT3r6AQ6s6XQgoIEtpwHr8cohlti6kXbzhfHB
         kd48GeCqei40W0Fm+MvOL9jeeworbOzZdyEvqlQxglT7yd7TTjAGnpMoQPXWVR8/Yp4X
         aMUyp/vslroyFy0rg7y9UkmOjFbiD96xRByaMmYhOux1egWzjwBlEup1K1INXm1e7CnM
         oxrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fUZXOnych6qxhX4bjLeYEoW62tw45yoi4lvLz/fDZMU=;
        b=rmFDHAeFB1VrPMKaFXx6eyae2A5UKPy8LrcvgQ6MZzyY9gGnWtCYxaKA4E2XjBwEgZ
         nb0epNFaEBsMLDinnkU0VtBlh9LYdVOvQ6SBeAfl73LOFokshftz6ZBtC1XK3oXkcFHF
         eFEpmHNulgRo7/ZoopKKRGnq2YmaCHy1b749ZezChTlDAwB6kVdIR00uBhIMMwFTiXLt
         1JFGaRpiu9C7lQeYFpWPT2tEdr1SSqk1M+kCusic2zeQeqwnh1QRNCNTVstnYchZ89UU
         sX/7K0kTcDH4xp0O20YQQ1U39lq/djsXs37WPqB89YG/VWeo2LoKmQmdriHtzkk/WO3U
         hGRw==
X-Gm-Message-State: AOAM532VWapANH3cbILQXc4VnPpMLMteav6H/Jh8dfHCJduEglB4c1+K
        cUJlX9tz6O2Ir0VEVY/BHrUx+w==
X-Google-Smtp-Source: ABdhPJzAzG6VyddDmgoHYvTU5SDSbk+AJ5I9Gy3n+7jEXEiPlpK/0wzyJd6PPnc4HGuK5CdsX1NyKA==
X-Received: by 2002:adf:b1c1:: with SMTP id r1mr3867472wra.76.1589443217531;
        Thu, 14 May 2020 01:00:17 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:16 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH v3 09/15] net: devres: provide devm_register_netdev()
Date:   Thu, 14 May 2020 09:59:36 +0200
Message-Id: <20200514075942.10136-10-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200514075942.10136-1-brgl@bgdev.pl>
References: <20200514075942.10136-1-brgl@bgdev.pl>
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
index 130a668049ab..c4ad728993dd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4208,6 +4208,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
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

