Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29401DE644
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgEVMHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729365AbgEVMH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:07:27 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47563C08C5C2
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id t8so4289651wmi.0
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hGk6SHkwZ0/IFFGnE1iOAP01F59WjRCQF/3H+v3exE4=;
        b=BJ3OIkLmKDJd8mJGXMOAEO0RYtZ+BzOIsHcG2UTpazbPreZ6uDY2fuZCBNsWnHPZjT
         xuescNUhGBE8SFaTTfNfcabLq8y2VIiMaEMMogTnG1fWAg7mF5jI42aIffPUTPA+iePW
         H1+GJn6TtGrfuwlTv2N2j+z+8FJe8t5Tkty0XiPLO8fEfBDLOX5xVk8vM2bkcyuYUIiG
         6s5XAFWCd8aPysT8MuuczJuWiSYnGUnSFXTw1UdujFdRbRa6bEVoWEbUCrd77lm4pXBG
         BJzOUC0xV1s37znu6SdHGwFgX+Imn6MDlvjRUTS+1uVNKUo0q6QE4VM7f6spU26/iS3X
         hWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hGk6SHkwZ0/IFFGnE1iOAP01F59WjRCQF/3H+v3exE4=;
        b=Ns5Cwd0jAdpR2j/jH8p1XDyRHMP4dGBESHcry+r9rDNFz8u8i1EoaDxKNSeA+4YJAc
         Ug9+QwA6m+9tEg06QG6HJVkS2osbm9xFMSMU+4lDF7pI3D7v9d8VSSpe12+ifaFGTAzx
         bM1/xi679gqbDQOfnjQDe7JfFrkautECzct9z1PkVanACxfVJYpODDWp1F+Fo+ylvhlZ
         EXZ09PM1AcrqzVOGOcOKSoxqLZexUVGKLyuhU1j7KC/E+2vBSlJH7rZZk+VgSBxa0f6e
         GNrVf3YALRetSDZm2cXnFj4N2aBSBOBiRb3mB7oSYffi6g8ZLfK8Wm52IN8jp8qAYBpQ
         8qoQ==
X-Gm-Message-State: AOAM5325hwMW4OFhlVfN40CxElM8uDBU27ntDhcikNkL9ZLifYvawU+O
        Wrsyn4qOb47W68INqrihw5zNCg==
X-Google-Smtp-Source: ABdhPJzPM9n4wz+olrOocFVpzas4NvH7xuF1o9DtfGChG8Sh1pIB0aDKJyKMN7cmRko0riD9kvETNg==
X-Received: by 2002:a05:600c:2146:: with SMTP id v6mr13654376wml.142.1590149246036;
        Fri, 22 May 2020 05:07:26 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f128sm9946233wme.1.2020.05.22.05.07.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:07:25 -0700 (PDT)
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
Subject: [PATCH v5 04/11] net: ethernet: mediatek: rename Kconfig prompt
Date:   Fri, 22 May 2020 14:06:53 +0200
Message-Id: <20200522120700.838-5-brgl@bgdev.pl>
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

We'll soon by adding a second MediaTek Ethernet driver so modify the
Kconfig prompt.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/mediatek/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/Kconfig b/drivers/net/ethernet/mediatek/Kconfig
index 4968352ba188..5079b8090f16 100644
--- a/drivers/net/ethernet/mediatek/Kconfig
+++ b/drivers/net/ethernet/mediatek/Kconfig
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config NET_VENDOR_MEDIATEK
-	bool "MediaTek ethernet driver"
+	bool "MediaTek devices"
 	depends on ARCH_MEDIATEK || SOC_MT7621 || SOC_MT7620
 	---help---
 	  If you have a Mediatek SoC with ethernet, say Y.
-- 
2.25.0

