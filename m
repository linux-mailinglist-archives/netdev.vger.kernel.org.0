Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2532744EA6C
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhKLPkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235448AbhKLPjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:39:24 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01078C061766;
        Fri, 12 Nov 2021 07:36:14 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso7273923wms.3;
        Fri, 12 Nov 2021 07:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mrT39HXhsvQIv884aQ7FKStKCV5fQEcK++rSuH4MPzo=;
        b=VYsF1Y9o06tJw68/we3j63O01NDUIboRYOuJ5cVeqsU8EM2wMBCVrDogIoKXRIFFBn
         EOVgI8mNXXwumFhCDDD6wGDWNmuFTZ5NqHvuezriDmrR0LBkl2zwX3byZJbqzrLEF0ni
         L3RTA5eXfxsIlcOQuL5iW7hj3Ag4msuBPKg9JFsAGoNhJhjhwfyrdWvq25S6eBN+rREu
         j2m+4m+vxsCyEA51oOhL1kIIuCl/j6M12s+gKTuX9Tudu+oBouWtg4Qsrln6ltwxpJLM
         0btvhD/ad1wvaip9iRICMhQFC6YIQx4CIaiaiZeyNCOvLHVB8EPGnrrG5NWx9LTz4YOt
         y1OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrT39HXhsvQIv884aQ7FKStKCV5fQEcK++rSuH4MPzo=;
        b=LG/TTAgAuYLAm068FsqLIHSgGuvrWbPPDTgwA3YHPnBHC4WZ/G+s9qtAVHbVnIgR9l
         W3OTkjdMYd1i0Wx1nCfYi05cUsBa49kvLb9f8kvyKAw6w5nxAuGSCUWiwPrp/Nfwz6AM
         U38QyZFpAapJbaMdnbnjG4Gx4yqu6zVrZ6lGjvojzp582nR3CiH0WSgsFQZoKHcdAojt
         cRXmNoczfCK+SO6vZR2hdjyDgL5bSiLbO7y2h5AqB32FVYVyt6idvSLjWZkmuPl/JrPe
         Ra3tzk1Y/VZdsyzXmuQXuvWzQTlPfOSAqEa7xzHIR1IZuxEuygNmL4SgSCzXw0koZ/2t
         zVvA==
X-Gm-Message-State: AOAM53316tySoJzt7LtKJCDw4nnct5Z2qQWC9VymfGS+/yndOPme5sw4
        1gn5N/0l4NdlMook1G8+VIIh1R/0NCM=
X-Google-Smtp-Source: ABdhPJxT2oNv5R2LyXboxFQukgKDLcGexkgECiAkaD2/42/hD7cHOv1OMa4wS1FxvCkTwEMVSa5RaA==
X-Received: by 2002:a1c:cc19:: with SMTP id h25mr35813457wmb.57.1636731372432;
        Fri, 12 Nov 2021 07:36:12 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id az4sm4217543wmb.20.2021.11.12.07.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:12 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH v5 8/8] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Fri, 12 Nov 2021 16:35:57 +0100
Message-Id: <20211112153557.26941-9-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211112153557.26941-1-ansuelsmth@gmail.com>
References: <20211112153557.26941-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add LEDs definition example for qca8k using the offload trigger as the
default trigger and add all the supported offload triggers by the
switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/dsa/qca8k.yaml    | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
index 48de0ace265d..106d95adc1e8 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.yaml
@@ -64,6 +64,8 @@ properties:
                  internal mdio access is used.
                  With the legacy mapping the reg corresponding to the internal
                  mdio is the switch reg with an offset of -1.
+                 Each phy have at least 3 LEDs connected and can be declared
+                 using the standard LEDs structure.
 
     properties:
       '#address-cells':
@@ -340,6 +342,24 @@ examples:
 
                 internal_phy_port1: ethernet-phy@0 {
                     reg = <0>;
+
+                    leds {
+                        led@0 {
+                            reg = <0>;
+                            color = <LED_COLOR_ID_WHITE>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "offload-phy-activity";
+                        };
+
+                        led@1 {
+                            reg = <1>;
+                            color = <LED_COLOR_ID_AMBER>;
+                            function = LED_FUNCTION_LAN;
+                            function-enumerator = <1>;
+                            linux,default-trigger = "offload-phy-activity";
+                        };
+                    };
                 };
 
                 internal_phy_port2: ethernet-phy@1 {
-- 
2.32.0

