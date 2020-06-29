Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9697920E051
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbgF2UpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731590AbgF2TN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 15:13:59 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7529DC00E3DA
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:21 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f18so8223752wrs.0
        for <netdev@vger.kernel.org>; Mon, 29 Jun 2020 05:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rcgV1UNGKm4K4QD82m2Udcr1uoHRVa+LAuPxtdS553M=;
        b=bhKeRr58llmIS9VKgVFyB6mAC7XOTgR+vC4RJRrwyWIr5sh0Pep1GPWHLAgwGzpwAc
         MGPqTye+7rp41hJ0FSDOVSH+p83Zt/3ZFe7cwcMshyi04ZZeZpr/muoHkBS6d3gEFsqC
         gL9tprIlM/mTLQfg0PC3ySsy+WIP8DkfosTU4J5ojN9iLGjwYxKS/OZIJyN/rXYZmrgt
         b/PirIRVemOkzEXXswFvaL53RJkfuhhqpelHeBzIZhnZXZ+/gqm1xcXkTKom438Uu5E3
         dMbEgvGvBvjLo2LDuXkeV0gRZt75ZzMGwBn8D2w+jiehl1HPOVrLev1YO1EDLxfeZxlK
         6RTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rcgV1UNGKm4K4QD82m2Udcr1uoHRVa+LAuPxtdS553M=;
        b=KzueCMQnZYUye+MP2p4Tio9st0KjJqojFx3lDrB4PGhVcMUzAUgrO/iKHTUg0PLRti
         qJY6yIvVRTvP4jxZyNGBV13EU7XeUSt5KpM6mFuDVru5h1ioSu9GHqt1ztgaIufBBLtX
         oygu7W/k+XYxi2C5hB9fIi7xzL3tOZ8p6cipKaAdgd4bY7f4jJC9zxqdkD9A8sxW/zro
         Pzl3dsgBVfKmixex4/e4OyEn1gWfinGN4z0/Ltzsn1VNriE5ny2FYZuN1QDppRNM4KOf
         PsbGbGOXLgtA0A9eGFe8MPNw0MmK8R+fQA3bM3vYHozfkSqS6F+aZLJy/ArkAsQnfA71
         70uQ==
X-Gm-Message-State: AOAM533BM3nRfVY6+PCIueswPdrTDYw5SwZQI5HMGNlfreFWVqvB2who
        4+daQuGiQ1ujXN5KdfpzyNMlhg==
X-Google-Smtp-Source: ABdhPJwlADkzSAVFbK3JmZ+v+w78Y8jXO+OaWZ19/qk/J/aygV+blBomdVtOyQPcaDByMnxBjS6U2A==
X-Received: by 2002:adf:c185:: with SMTP id x5mr18180867wre.403.1593432260279;
        Mon, 29 Jun 2020 05:04:20 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id d81sm25274347wmc.0.2020.06.29.05.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 05:04:19 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v2 06/10] phy: mdio: add kerneldoc for __devm_mdiobus_register()
Date:   Mon, 29 Jun 2020 14:03:42 +0200
Message-Id: <20200629120346.4382-7-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200629120346.4382-1-brgl@bgdev.pl>
References: <20200629120346.4382-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This function is not documented. Add a short kerneldoc description.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/mdio_devres.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/phy/mdio_devres.c b/drivers/net/phy/mdio_devres.c
index f0b4b6cfe5e3..3ee887733d4a 100644
--- a/drivers/net/phy/mdio_devres.c
+++ b/drivers/net/phy/mdio_devres.c
@@ -2,6 +2,13 @@
 
 #include <linux/phy.h>
 
+/**
+ * __devm_mdiobus_register - Resource-managed variant of mdiobus_register()
+ * @bus:	MII bus structure to register
+ * @owner:	Owning module
+ *
+ * Returns 0 on success, negative error number on failure.
+ */
 int __devm_mdiobus_register(struct mii_bus *bus, struct module *owner)
 {
 	int ret;
-- 
2.26.1

