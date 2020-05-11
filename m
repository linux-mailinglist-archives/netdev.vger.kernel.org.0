Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0B01CDE60
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgEKPJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730335AbgEKPId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A86DBC05BD0A
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id y24so19748666wma.4
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWd28US49vQEgzroCkPuJ7+0dlvqHFnp/0U0KdCKzj4=;
        b=yAQ17n5n0Nlko9kUD5JQSnw1SO35zKfJ9pXExg53viUdxqF46z7vVVUbrm9CWq90zL
         +HofwZUQ8AbrUTRLoP8u6HuvjPcGWT1dWbdMdcEI78zuOFvRNeUhJIX4AVRT7hVXwaHk
         XWusk6ttYjMboQZLrX8kOFDqUbovXiFSXfu65aAk2VN4fPdxjQc0gOha7ctZgiP0eOGx
         dF3x26U8pZeznqL5/e98wKIPJGv1G8lqk4flKSM8JrivLFxREQL3SIRzc9H2gzU6YiwM
         I3OTfRJjC6rxKB4a9taLddxcX1g6NaMR3yg3mW3DPp2Wdo1cxWQOBlb6ABfVCkV2cl/0
         57Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWd28US49vQEgzroCkPuJ7+0dlvqHFnp/0U0KdCKzj4=;
        b=l7WFVusAL81Wz98wbh6EjVTteI+9uU12RZupDHrW7Oq6lgl7PO8pBT+vlWl0mvnX+c
         OTqJ9oswo5Jz7z0giZfucijtGpHKrktQMT6+pcY3hRzUq+lC7GokLzyrMV4Wbe/SL1as
         F7qvw/oj+gsXn1n6sMKB4+xIql49W1GQdfTL4tV5nWcoVZHq8aKFZW/cnECuuBWoLYrV
         zBAaey/nJ64dSisITO49rQo5D1+UcfeB1sKfNIBmT4p0XbVmD3jgKi6SER2k09HJsLeS
         2+ZGGnBC+o6Ifrk/+r2irpMLgNvlTzIfvuGytFHuAX+JT3D42nKWQb/Vh8QunNluyN/r
         qh2g==
X-Gm-Message-State: AGi0PubRQZHDT+6XnBWNLwuIw+vvUpt1GkOlRHzrIA8rV9o6KlOQiE+7
        mqGFbiefpsJ+bobszyn5PguQoQ==
X-Google-Smtp-Source: APiQypJeAulXahA6ibdKhNLx3DmiIqJmPwxXGG8leQ4jK/xVuJNuMwJOUsf0YZ2hS4FiT/g7qkEqmg==
X-Received: by 2002:a1c:790e:: with SMTP id l14mr31328411wme.174.1589209711412;
        Mon, 11 May 2020 08:08:31 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:30 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH v2 08/14] net: devres: provide devm_register_netdev()
Date:   Mon, 11 May 2020 17:07:53 +0200
Message-Id: <20200511150759.18766-9-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200511150759.18766-1-brgl@bgdev.pl>
References: <20200511150759.18766-1-brgl@bgdev.pl>
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
 include/linux/netdevice.h |  2 ++
 net/devres.c              | 55 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 933c6808a87f..d3d1b9251ae5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4220,6 +4220,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
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

