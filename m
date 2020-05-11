Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE4F1CDE5E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgEKPJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729967AbgEKPIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:32 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9C0C061A0E
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:31 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id w19so4952728wmc.1
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85LArQ1FkfasqQwvTGBUsmFOdZ74xT3FAzPREvSXT3E=;
        b=TS/jxxw2AM8c/MW/14NfrNB+SUbDqKCeR6Tz9KN+jE/qC/yYIXQFmcqxM1np2Xwhd1
         6HzzHOawVFx9Avhhy9m+y8TIrHmrRiIGgsdRGMba4aTqK1P3Std1fQ15kyhU37lGQ4Gd
         /blU29VDw8JrGSg8cn8jWRHVrLGz1I02RRR881foQUGlY83hYx6HEVM8++7zYk9AB2gK
         kCA8E+nT8RvG/vdg9BjOvynD4T+aWghR+0uibegwQAvlB7FNBaDmFNw22bU9G5Dh38Sa
         blrzdx+xnrmAR8BnZBhhos2friW6xXn07zxAXVWX+4YWhBxExBXWL9JMoRRwyxerZJMn
         S1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85LArQ1FkfasqQwvTGBUsmFOdZ74xT3FAzPREvSXT3E=;
        b=sptp8Sr4VlYy4t6UYs5c8P1XEiLt7RSxldJBGMEzDUmctTgqjE1SFYrX3PIMbruyNN
         tSjb8AkyfRXH8zXgq70hRemB1fsvlIV2wuR3K6WML10CkkONcvE4nejudMCGfc9vPuqj
         xfd7BgjP16RbkSYHQr9drPw907wi8+kp8t4QzqN7FsNynHT7DFCRGFU40VAXPxp3HDv+
         pETFAEtt03JExAYcxh1dMiC3FlapfQ5K/2WusR3ANpqD0A8D0OS2UyV8s14EP4QVwdiL
         LVBJzT/vU78/JhDGQCpqzt+VeEEPDkNl2zsLgI4O0ysH6QMdHZCs8m++Endk3yL2VoHy
         lkkA==
X-Gm-Message-State: AGi0PubRYozpDnGr5FcZN78A25zUyHXSDHatYfzj0XI8IujvXX4B0S8U
        WqsTv1XlAwYJLlFKM9AFmZ/34eGFE34=
X-Google-Smtp-Source: APiQypIUoY5y9pMCyWMprTL71A7BiL4tQc7BbrlTT1FoaZIkxIS6pMCmPRg9IsmwTOLUcwtTuQxL3g==
X-Received: by 2002:a1c:abc3:: with SMTP id u186mr31368123wme.42.1589209710040;
        Mon, 11 May 2020 08:08:30 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:29 -0700 (PDT)
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
Subject: [PATCH v2 07/14] net: devres: define a separate devres structure for devm_alloc_etherdev()
Date:   Mon, 11 May 2020 17:07:52 +0200
Message-Id: <20200511150759.18766-8-brgl@bgdev.pl>
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

