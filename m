Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABBE1DB21A
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgETLon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbgETLo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:44:28 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FBDC061A0F
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:44:27 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id w7so2759072wre.13
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85LArQ1FkfasqQwvTGBUsmFOdZ74xT3FAzPREvSXT3E=;
        b=QKJkcBbxZWCWLDG+YrYnBrkZXE/At601H5ASh1l5Ykv2TDwcxDwOGjyKJsXAUk5Ye6
         u9JtDQ7XjNeR8tEvIJPP7Dsnsf/DOUsYU0eQ1O9/8p1dFPiOjfYAQ7gs2/qv2DaWHJ4Z
         +jOzPTB+Cruz1bL6UuIiAubhlBSrq+VRpYTp04Nj55Wj8pVVVjXig9kitcMgGZ6q0YvQ
         bCZ6WMB0VizDGqrwGTeiW4x63tgAFYMpcxaw2qIfhl5iQEgvmZEXm6jEeFI3aaICjzzO
         G6Pxsib9tcNmBDhDTDV6DZqfrqxl3owEhBwBZOZpvRW9LCq4ua/rZhJZEuW9j91e6Zup
         IrBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85LArQ1FkfasqQwvTGBUsmFOdZ74xT3FAzPREvSXT3E=;
        b=EGywvcC0GaWKGUNbbWw9mPTay7otTtTmNsJd5+VO5m9Q46iHXNJgbgI9xAnum5fQAf
         7zDQvojTlbr+cO2YamC+uBCT4BRV+pD9Ffeyvi4eNp+kqmO/F7Z6gO0yOth3kKNwnAS9
         74s0qVz/DoFkyMnZUEHIlxhEBqq7pcr5BrTsPHqEjD9P5xe05kcZujeFhOPnX6glqJWr
         cpL3ARks3EEFTH26X7q1RhhUoqlC/w9oxPS9S9ocDbiCERrHswf6Xl/8H7t4CpIx6oL4
         C4MfI5h7W8a4FxD/04WTCd5K1dbPlRkoPnre3efHh54IpPMSUzAHtWdK4nVcOjSizdoT
         Dw0w==
X-Gm-Message-State: AOAM533ko2lH03ZrOvIh229xrSXXNF/CFI0xDFLJN7vnvvWRdXDIJAMS
        w2eutK8gMlfw2jxlhCCvybiUwg==
X-Google-Smtp-Source: ABdhPJypM/wspBT4F6w8EO4JCWTG6tul8aOv8l7s4hm9WSskupdfPjKVvCbnp9cT4bd0cBC63dS4xg==
X-Received: by 2002:adf:9447:: with SMTP id 65mr3890042wrq.331.1589975066452;
        Wed, 20 May 2020 04:44:26 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id q2sm2530782wrx.60.2020.05.20.04.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:44:25 -0700 (PDT)
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
Subject: [PATCH 3/5] net: devres: define a separate devres structure for devm_alloc_etherdev()
Date:   Wed, 20 May 2020 13:44:13 +0200
Message-Id: <20200520114415.13041-4-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200520114415.13041-1-brgl@bgdev.pl>
References: <20200520114415.13041-1-brgl@bgdev.pl>
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

