Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698382033AA
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgFVJls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgFVJlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEF9C061796
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u26so13127066wmn.1
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H6LOSRZxGizpxzfF22Sv14N1k+l2XBln54kSc7WXTbU=;
        b=fwhLeGUTHzaOn5r0hKFAxOrI/4bP6cRMLAZ9vxuMsWmVTbLCLBfuv2c3zx2K+9WkzC
         4510agGDHbhXy4FxLo2y6wSgQ64p20rVWdVPiqvbTzNx3rKJ0wAQIRkSuhTdzUPDyq33
         EGJ7dP781SaoA69mOAe2VG//Mj+PraeucVuHaZFWBoluRKQxOPm81fI00ykep20zlmSB
         RPZYYFefMuTBJhmo6T+gCbA2sk4rO/dFZ8SsuCQmoiiBtm5IHQMXEHE2Tj3zbDGXmqd+
         33R1jARght4O0k5GCattCXLy0yW2yV908NCQr9OgF+g3eygrEUkhQhtDWFMWiBtAcU50
         OBog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H6LOSRZxGizpxzfF22Sv14N1k+l2XBln54kSc7WXTbU=;
        b=Tlw/MVMfJ/6oKXPmOssTZISVNuNTCpMm/JkxBADrBlS7W0qqxPNEI0+HRmEKsfRtc7
         fdIrYNHcBzikQewHlYJqILcmDuMHQ9u+5dniumIoEti5mui9Cu7ieRXuIxAp6BypQDah
         Jb5E3oAvFV8z4TKlQXfS/2NNBpV/pRtB9hXOzTeeDlFVvk+KjtPu66gugc+QkuY39RVU
         Hi/senv0AbEG7cWXp9k9/cGJ+yYekt5KXw3WekH5GrqrNDZHN8WJjpb5F+3/Vdd6Xfti
         nPIWJOlwhEDfhK0HrNYqR+w3hL7d4miEvMu7GeHMBFa5uQbkHlWS8C7e8yHsslPg4dIg
         GuAg==
X-Gm-Message-State: AOAM530NHe4Gzz0KqI+f4V6GnudlkCzpXf/CvrkvMyIjgGFzxzGtv6UQ
        auVwG1315qgIumsCkdP52zsTkw==
X-Google-Smtp-Source: ABdhPJxKaZTzwaRgXjyD3lQOmmZEDuZrxf5WMvWd8aJTlxKoe6V5StaOUPB2OradOOO/ubvV2pVenA==
X-Received: by 2002:a1c:1fd1:: with SMTP id f200mr17253456wmf.162.1592818903618;
        Mon, 22 Jun 2020 02:41:43 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:43 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 12/15] dt-bindings: mdio: add phy-supply property to ethernet phy node
Date:   Mon, 22 Jun 2020 11:37:41 +0200
Message-Id: <20200622093744.13685-13-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622093744.13685-1-brgl@bgdev.pl>
References: <20200622093744.13685-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The phy-supply property is often added to MAC nodes but this is wrong
conceptually. These supplies should be part of the PHY node on the
MDIO bus. Add phy-supply property at PHY level to mdio.yaml.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 Documentation/devicetree/bindings/net/mdio.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
index d6a3bf8550eb..9c10012c2093 100644
--- a/Documentation/devicetree/bindings/net/mdio.yaml
+++ b/Documentation/devicetree/bindings/net/mdio.yaml
@@ -90,6 +90,10 @@ patternProperties:
           Delay after the reset was deasserted in microseconds. If
           this property is missing the delay will be skipped.
 
+      phy-supply:
+        description:
+          Phandle to the regulator that provides the supply voltage to the PHY.
+
     required:
       - reg
 
-- 
2.26.1

