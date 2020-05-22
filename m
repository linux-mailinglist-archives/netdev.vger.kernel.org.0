Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8F71DE637
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgEVMHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729073AbgEVMHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:07:30 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B8EC05BD43
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:28 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z4so8432280wmi.2
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=75HMiSxkO2iGkQyQ4GVIN4XRI1pdsKTRs1XUFo380Tg=;
        b=I7AimdvAZOh1g/UByPwXTG3z06QWyuPRsDF0Y6Dye4Brq8bAXcTR36UrTTrcFRmV0z
         ApTCDxKUugYCbGqBd6jh4pdAjVZB5LNOe18if99Ec/1JIe97HNEOCfXfXu10oJmV6OmW
         9t9TvWm6ZFXkqUfNvBW38GHqf+KiIY4Ck6Bq5FNSeB4KhtkBbVYBv+DU7/Q4cvNK6bT2
         boLjHlkp7E1pzNHDzgB/i418XwGyHKXG/cG9h7nTX2pmZoouvxti476UwfnpJePKI4ng
         bURCFe9jqs2O8IdxAxqztdqMugBYRUqdY248cJi+D+VgWvkQ0FT0ORMOETRpJjaJitXR
         6orA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=75HMiSxkO2iGkQyQ4GVIN4XRI1pdsKTRs1XUFo380Tg=;
        b=AX9Wv8yd73t5l50b5u4R7GeaJsPT0nlJ/E6qZPgLHJlOGhxj4dI6N/mYkxWmZzEKIt
         Zb4m8ir3K+x5WsNmvifD/yH5tBLsx5CTiJdaJtaMAVR0rm7x53LZSjEuXtwLegf9YhXZ
         z5ckth1qLkKz6AGliE1allr7OM+ea0lzCMFR61oiu6/7UVyLpEMME7QoXSs/ngrQE8P1
         xRRJ57dt41hvP6dtlhNFWYTDJVDXQFJEvGKfJtjg0Aqo1NqR5gKSr6XTzAmHhs0bhAWD
         ne8IgE/VaCQqguO74r19RGNEAoP0kyfKAsu35hsjqBg4Bat98yFAUkwwBS76vWimayo/
         xqtg==
X-Gm-Message-State: AOAM530G9lhUUoEI64p4pGnuA4D2zLrnt/isM9V831B2OLX4uy52PErJ
        U0VVfo/5SDEYt3jCwu0ze8L5Rg==
X-Google-Smtp-Source: ABdhPJwEi7VyHt7K7+omiVssnygbzQxiUSCPmAIEWo/ISCAmaztuxM/ZHSeqf8g+5/jkvW5bZaKWMg==
X-Received: by 2002:a1c:e188:: with SMTP id y130mr14051662wmg.105.1590149247468;
        Fri, 22 May 2020 05:07:27 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f128sm9946233wme.1.2020.05.22.05.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:07:26 -0700 (PDT)
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
Subject: [PATCH v5 05/11] net: ethernet: mediatek: remove unnecessary spaces from Makefile
Date:   Fri, 22 May 2020 14:06:54 +0200
Message-Id: <20200522120700.838-6-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522120700.838-1-brgl@bgdev.pl>
References: <20200522120700.838-1-brgl@bgdev.pl>
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

