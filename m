Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993321D297D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgENIBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726278AbgENIAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:17 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B7FC061A0F
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:17 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id f13so757638wmc.5
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85LArQ1FkfasqQwvTGBUsmFOdZ74xT3FAzPREvSXT3E=;
        b=IQRdwUqxDe1qZmT8TGQLkrpl0kAdWhdhH11prXOwPTmEcd2xi6nmcFvKSdcBT3IQZY
         yRnKMO5FeNSeCf+SCHtG/N/4bKqB7p81H8ghcz05gj2Pwf2vXgntZAeQYV3l/jTSdocQ
         dPvmZEAfuzM8MzlXRUqGd/E7rGt2F1n4TM7+DJ6RnqP3U6YcLUe8aja3Yta4IW17s6Yy
         75hKtwdXvy9YC8snlGNetXjHz8nQEW6rafZF9NDCUU81TSHgCWq6rR7UDqYLVqUB6G9Z
         NxP5Y6Yp69XPoqS88noAVJoG/kGfFrZT6SAC3hTLsFU30y07APR+K/lBdiKhePIkHvpT
         9Kfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85LArQ1FkfasqQwvTGBUsmFOdZ74xT3FAzPREvSXT3E=;
        b=UhNi89+WN7J9IT9Fhejs6j0g+qO/HL7ZIieISh5yCWdWtpbM4Gxvl6qAg5wRJG28cP
         srJyWSySojt2cBeZzJ/JnqlmMuIJPWGSp7w37IU4FaT7CXmrNJQt277n5cqCJUt3mtt9
         VntkYSGAB1OpNLKUCRCbYuETZcstFYYq8t7TCUm2MnOrZOR/tFCP5cCA1PN2mVWI3jrq
         7kXMddgl9UnQT5yXK6g3VvoCGLPD17TiUEai8Yvzaw+DgYmNJgHivq+dmg7ZUD1mEVxd
         WV3J+/UbMqZua/T61FmaqTqBZEIXIOzYhYBnoFbRD4MWKd1Sl2n78s9y9aH1de7+UKvl
         gRIg==
X-Gm-Message-State: AGi0PuZBpwdSzOeyUtBnTWNbRJ8QdHcNm1mZQOJGE7hhCXRgXrhj93Co
        zeLYZ4/bRJt/81IJKAgnp53NUQ==
X-Google-Smtp-Source: APiQypIY9tAfCpn2AmTAwgro/2JmYcI8xIK57P9eBIyeDsZ7PCcAdgUe8VkM1x3xFdmKrxvg6IG6Gg==
X-Received: by 2002:a7b:c5d4:: with SMTP id n20mr49059541wmk.92.1589443216067;
        Thu, 14 May 2020 01:00:16 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:15 -0700 (PDT)
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
Subject: [PATCH v3 08/15] net: devres: define a separate devres structure for devm_alloc_etherdev()
Date:   Thu, 14 May 2020 09:59:35 +0200
Message-Id: <20200514075942.10136-9-brgl@bgdev.pl>
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

Not using a proxy structure to store struct net_device doesn't save
anything in terms of compiled code size or memory usage but significantly
decreases the readability of the code with all the pointer casting.

Define struct net_device_devres and use it in devm_alloc_etherdev_mqs().

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 net/devres.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/devres.c b/net/devres.c
index c1465d9f9019..b97b0c5a8216 100644
--- a/net/devres.c
+++ b/net/devres.c
@@ -7,30 +7,34 @@
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 
-static void devm_free_netdev(struct device *dev, void *res)
+struct net_device_devres {
+	struct net_device *ndev;
+};
+
+static void devm_free_netdev(struct device *dev, void *this)
 {
-	free_netdev(*(struct net_device **)res);
+	struct net_device_devres *res = this;
+
+	free_netdev(res->ndev);
 }
 
 struct net_device *devm_alloc_etherdev_mqs(struct device *dev, int sizeof_priv,
 					   unsigned int txqs, unsigned int rxqs)
 {
-	struct net_device **dr;
-	struct net_device *netdev;
+	struct net_device_devres *dr;
 
 	dr = devres_alloc(devm_free_netdev, sizeof(*dr), GFP_KERNEL);
 	if (!dr)
 		return NULL;
 
-	netdev = alloc_etherdev_mqs(sizeof_priv, txqs, rxqs);
-	if (!netdev) {
+	dr->ndev = alloc_etherdev_mqs(sizeof_priv, txqs, rxqs);
+	if (!dr->ndev) {
 		devres_free(dr);
 		return NULL;
 	}
 
-	*dr = netdev;
 	devres_add(dev, dr);
 
-	return netdev;
+	return dr->ndev;
 }
 EXPORT_SYMBOL(devm_alloc_etherdev_mqs);
-- 
2.25.0

