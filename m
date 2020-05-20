Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358161DB195
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgETL01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726890AbgETLZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:25:41 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D66C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:40 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id m185so2463795wme.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75HMiSxkO2iGkQyQ4GVIN4XRI1pdsKTRs1XUFo380Tg=;
        b=f02nBXwLb4+yDOpRal5KJVxXzopqw7/nIX6xAZeUsGIgPvualoU9kAFP7hn05cf+Nt
         4iN992z6W9yhQF29Y26ynXaCtz+6FsZbP8aBQL1h2coANBLn9o1CgvTQlPIoaSUGQoU5
         qtE7Kg/XGNnDOtxs2MiIdXenBYl4gc/7g7JSA0xuF0npzrYh856vFbLpuh7EWgQel/yD
         +PJzkzPyDmCmB0wgJ0bh0iBQLqQNa1bUi26Wvj+iverCeG0+igs7RlReEDzBCf5hOei/
         UiGA+kRB/lRVBdgGPOhPKZWo3XcjKsYd7C0FQOUoTPHRZ4Gl8kDEn633FffNuzEXzVHE
         LLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75HMiSxkO2iGkQyQ4GVIN4XRI1pdsKTRs1XUFo380Tg=;
        b=LoISR9YoEo4CtcDovHZRxZVuFF110Kbs/bsEn8RQdYDPxFqKmRxTcz6fHKXVzlRckN
         TwOtoWweHAbF+jWAYQ+rnXDHduMJw2duoywPtCDQRNWamDy6yhhqp4QjAJFF9lVRhSHP
         IkEVqlQrPFIkFlNvpvttzlkWazPonppKubCc3GqI5h5YAHyJ5ebkhz1ptr+e8PXdMJ2q
         2uuoyxeRLwXBsSO/GlTRZ7hiGk7i0Y8rf5zINDrv92OXz57zzHt3829ERtq5WAXyfhod
         +47WTN5UYBcuR/d+vwvKjJXwjj+VI6DlKsfCVsdsf9RPis+OM/ir/ODt7znc0S0lL5m4
         qCZQ==
X-Gm-Message-State: AOAM530TSsEUORQkovJi/d9fIuWPqMv0E5T0Mp9OmQXSMrEv+SFH6Fvj
        WQ60VmwYsl9R0KgCdSgTUlPp2txeVyg=
X-Google-Smtp-Source: ABdhPJwE0xHr6PeSbtA1xNoXhD2SOoG7eWG3GrsBM9eyrqQ/EG9y2X0SgSbOAAb2NAS+YgXTC8DuJQ==
X-Received: by 2002:a1c:2184:: with SMTP id h126mr4173395wmh.122.1589973938809;
        Wed, 20 May 2020 04:25:38 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id v22sm2729265wml.21.2020.05.20.04.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:25:38 -0700 (PDT)
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
Subject: [PATCH v4 05/11] net: ethernet: mediatek: remove unnecessary spaces from Makefile
Date:   Wed, 20 May 2020 13:25:17 +0200
Message-Id: <20200520112523.30995-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200520112523.30995-1-brgl@bgdev.pl>
References: <20200520112523.30995-1-brgl@bgdev.pl>
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

