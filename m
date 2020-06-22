Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3923F203457
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 12:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgFVKC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 06:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgFVKBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 06:01:16 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4A8C061798
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:15 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y20so15094875wmi.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 03:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vANIsXo74NzXiDIyR10LVPoVvN0SF3cCppVREngNaSg=;
        b=xtlQ6vt2ftcI+XabUk5dlYEY+EoWH8nR8xcQ0FineEvTFIyHxwdZru/XNV/dfPCuwH
         p+2SV3EvOLiwS1nhvc60TsvMW4YNirrfN8g/xcNwpKisI/ZQhpTItmGFfFpSHrXsGu+S
         b7MvvTAW41tXqhs9scOYapiZqZ36Pfyhf81lebKF4vMaR5ghYo5mQz1TbDxar4ISYJoU
         r97GfAQhf4HMDRDYdamUBfw7XB2G5c/8Yd3xQBk2wd2NRH8kL2poxNolBqJT2m6c+bYv
         ZbtsK6uSEB72jNc60WhrddXbm/mQa5m5tZApNrkGL3PmfTcjFpfrBr+Em/UQj5iDvDis
         u71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vANIsXo74NzXiDIyR10LVPoVvN0SF3cCppVREngNaSg=;
        b=ZDArhzjipVLJtbWSZOFyTQ6D2pb15VRh6rQyL+0ag+xqp2X0l1uTH8EDbE4QdFsJX2
         BbO3ToKFjWeMC57LPVDRvEK2SqW9WE2S0rnx9dC/ygHO97axnKG59P33tka43Kfuvjey
         /8ky8Aw1BlRchu8AAnXznkeHZCw2A9VPHgpsETePihn2d7i226oXVM/auESlEMmY+lpE
         E3DeKsBRIevznxmVgD9JcSkTxK3SbQwSGTAD4rdQHCEV3K1d79NzCzbxCARxeSk22Fh3
         44yXgLvZeqCJM1VRBW9rDDqeuBFgRu95i3KoKVYW0qmcw8F9A7jC9fE1PHTOokhX6/Ln
         wiWg==
X-Gm-Message-State: AOAM531wHLMTXcChcLMFUGIyHJpcdg11SDvt3Wddo8HrajV69vZt22AE
        ZHCuENUFc7L1YJbJVFZzZmwZaA==
X-Google-Smtp-Source: ABdhPJzUHixuKfQa4u9XvxcXJoOatBovm5nA4dkuN9R2ixW6hpip+ioKdNDg9ycFUOAJ0KD49goWaA==
X-Received: by 2002:a1c:c1:: with SMTP id 184mr17443884wma.74.1592820073899;
        Mon, 22 Jun 2020 03:01:13 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id x205sm16822187wmx.21.2020.06.22.03.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 03:01:12 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 05/11] Documentation: devres: add missing mdio helper
Date:   Mon, 22 Jun 2020 12:00:50 +0200
Message-Id: <20200622100056.10151-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622100056.10151-1-brgl@bgdev.pl>
References: <20200622100056.10151-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

We have a devres variant of mdiobus_register() but it's not listed in
devres.rst. Add it under other mdio devm functions.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 Documentation/driver-api/driver-model/devres.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index e0b58c392e4f..5463fc8a60c1 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -343,6 +343,7 @@ MDIO
   devm_mdiobus_alloc()
   devm_mdiobus_alloc_size()
   devm_mdiobus_free()
+  devm_mdiobus_register()
 
 MEM
   devm_free_pages()
-- 
2.26.1

