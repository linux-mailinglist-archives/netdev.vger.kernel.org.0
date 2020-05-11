Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC0D1CDE5D
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730253AbgEKPI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730232AbgEKPI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:08:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A298EC05BD0A
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:26 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i15so11388772wrx.10
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75HMiSxkO2iGkQyQ4GVIN4XRI1pdsKTRs1XUFo380Tg=;
        b=IONh+DpnmejFuXALAwr/I/OjxLG9/eNbjfLpyONcGQibovX8pI46VIZgC9xXwCv98H
         Ky9NUKjT2vd6Ug4cS8NQuuG/ijvNN86K2vpP/v5IdxeXFOrdi9TwLnprkwDDJXsKFnuw
         /vRoJJX2IslmnZxnrfWaBBRCyW1JbduGoxT58Yx/n3jOInNrLcgpirPWOVnp07i32Q7+
         vjHPKCdqY5TRz9Krgcho0oar/Ep/f5M5qDpMJgBk88UWDXbKxzhxsOeSaIA8vbRlD2Eo
         XUzGSDPMVx702v2gEp1ifsTebqSwhxEbem43H0bhsSH+4P7qfxv5J+IWtyUaPlnHxjuF
         Fq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75HMiSxkO2iGkQyQ4GVIN4XRI1pdsKTRs1XUFo380Tg=;
        b=qt1dI9QUHqohhGMtaQvIa+daHSyzTWHbFYoesipiO5pb4YqiqG0706L+W/x3DGqG7q
         3RwedDXfaKSj7LQy4DX9kaU5YaOcno01rgJJ5CRAlpKLQM22CzZpGHnw1xa6vWI4xzFH
         P5jkAKD5a/SrmCmyGeFVSUzwm8HbZyIN5Es9MAj2P3UnBW1XG1ZPFziEBosh4n6IkBOi
         8d2Ys5+CRjy3rKq3Im+mEpTbHQm8UoA8hgXH5xofM6dtVo82vYVUh6uch7i+X4YxU859
         zVBNVH1mhGaRr+IVydn6Ot4LL7PgrwasvYwlgf1D1Ij4QDzka+LD0o+w2JYj+sriN7S1
         YgvQ==
X-Gm-Message-State: AGi0PuYO7FnaxV9YNBAgQgRuIGo+yeD7njef5CbsH9i9FsxuzCBb/hkL
        PXeTJ7W0cZ76frWuMN9dnsIt4Q==
X-Google-Smtp-Source: APiQypIP0Bn3KOIOBxC1UBNqcqDai8qWfKN8IcFL5zqV14Hb8VXZDCZKqkzaVDqG/Ivki43uegY3ag==
X-Received: by 2002:adf:f3cc:: with SMTP id g12mr8322148wrp.427.1589209705382;
        Mon, 11 May 2020 08:08:25 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 94sm3514792wrf.74.2020.05.11.08.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:08:24 -0700 (PDT)
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
Subject: [PATCH v2 04/14] net: ethernet: mediatek: remove unnecessary spaces from Makefile
Date:   Mon, 11 May 2020 17:07:49 +0200
Message-Id: <20200511150759.18766-5-brgl@bgdev.pl>
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

The Makefile formatting in the kernel tree usually doesn't use tabs,
so remove them before we add a second driver.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/Makefile b/drivers/net/ethernet/mediatek/Makefile
index 2d8362f9341b..3362fb7ef859 100644
--- a/drivers/net/ethernet/mediatek/Makefile
+++ b/drivers/net/ethernet/mediatek/Makefile
@@ -3,5 +3,5 @@
 # Makefile for the Mediatek SoCs built-in ethernet macs
 #
 
-obj-$(CONFIG_NET_MEDIATEK_SOC)                 += mtk_eth.o
+obj-$(CONFIG_NET_MEDIATEK_SOC) += mtk_eth.o
 mtk_eth-y := mtk_eth_soc.o mtk_sgmii.o mtk_eth_path.o
-- 
2.25.0

