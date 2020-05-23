Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBBF1DF795
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 15:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbgEWN11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 09:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387860AbgEWN10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 09:27:26 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1088DC08C5C2
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 06:27:25 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id t8so6174159wmi.0
        for <netdev@vger.kernel.org>; Sat, 23 May 2020 06:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=85LArQ1FkfasqQwvTGBUsmFOdZ74xT3FAzPREvSXT3E=;
        b=mp9fRUIz3f7zzigyw8CU4tWQdJuD/cNnqmRAvK/VRG+g0juXIdGy1ACtv8QzDSAVvX
         zZTtdlmptVqzrDUoGctCNcVv+sp+kvHHQLKobjmUSABO5WlVbnS7ZjDu5eL8ghHSECVm
         K66u1sz1Vvr9cojS1puCVm7MHqwqSP+KeNpcs0Ikin3L/OSp6a6ja1mHMqLhXZ7QSF33
         cmQ40C5Sb89UJ4E1ZZShWVrrBxftRA6RfclHz/BjVeWTuoRi2J+VvqnLv5AlUcR7mc7l
         F0zaODP7z0PlC5yJ+Y5QhZw5HjxWCqux45s0hgaopOwzgqaGcyNlp2dO1XJ/1y0vfKmZ
         FmJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=85LArQ1FkfasqQwvTGBUsmFOdZ74xT3FAzPREvSXT3E=;
        b=IsfSW0cWQar6TD1LzhscBKYze8Ctd7dj+dZSw6b9jzFBgiQlRvK++QC7MxvjS7RrcM
         q1W4cOfF2HKbuD99Nk2bJma0yq/Z/iiaXE2oM+jaHEnasofvLMSuL6NZ1JlZjXeE6D6C
         JTwitzJ5ffR5RaGRl0ixU2iDsaO4M8DSpHQlk9mi0uL/3st9Y5KI1j7YuCzvUL75uACK
         L1HPYC9mRzQW7g9/WoLIAmBCUBa3L6qytjAN3O+MEKAxdEqwop05a5yq6RqjevPHCCE3
         F5JQWCpJb0ebHc3m2Ur3UTE/FI8dDanLNrbNo6zMZv8bowmpPkn6nBr+Bv1muRgaDqou
         Ca+Q==
X-Gm-Message-State: AOAM530GcMnvagMGKgno+v0kCeujl76CCVEZ6OqUIW094ers+selZ8BW
        rcqGFcJRygmPc5oAF6FPYIFIFA==
X-Google-Smtp-Source: ABdhPJw0PA+P0HcUXiWXYQRZQG2lReeBtiQJfZFPYkFAcWtI7Dg+DCbBae2YfDUJLHDk1mI3Rm2NpA==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr18521019wme.154.1590240443748;
        Sat, 23 May 2020 06:27:23 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id g69sm8098703wmg.15.2020.05.23.06.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 06:27:23 -0700 (PDT)
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
Subject: [PATCH v2 3/5] net: devres: define a separate devres structure for devm_alloc_etherdev()
Date:   Sat, 23 May 2020 15:27:09 +0200
Message-Id: <20200523132711.30617-4-brgl@bgdev.pl>
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

