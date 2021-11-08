Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8ED04476EE
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 01:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbhKHA17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 19:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236824AbhKHA1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 19:27:55 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62597C061764;
        Sun,  7 Nov 2021 16:25:11 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id o8so55585911edc.3;
        Sun, 07 Nov 2021 16:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mrT39HXhsvQIv884aQ7FKStKCV5fQEcK++rSuH4MPzo=;
        b=PQf9IkCgbUfkwfSkTQ9cmvFGRVVwsMNE9Xg5lUXJGKHZtPH67mRBDLS80XrMBqdxW3
         VQ0m0So5rQ3oTOp21xjT6FUfC8kf37o9bkiULvgQHagAAmZPIHPPbCSrWbFBEjlkaCu4
         1AmzM6roYjsdsRj0Q9U+i2gUrbX/OfjksuYY3Fv607tgGSiNSJGFnKR+asNl/nKw4G3i
         ShGwK2HWodDj3FFLY54MmubjB8j+T5QYekye2MiGl5Gihj/UFwlbpq4mkj/MTeLfx0q6
         IAvx2YwYOpPKsOJSqXo2r3glSov8XT7esWwobddnEFRHzVkHI2hNOpJBiChli+UdLZZr
         APyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mrT39HXhsvQIv884aQ7FKStKCV5fQEcK++rSuH4MPzo=;
        b=WBGD2ifqIIMycS3bgFs7nBM5UXtJZgsWvSse7ygvIwXUU2wmX0ZQxlD/pLAuIrdWxZ
         FDwnXIguYSkKXpXhHpMDSExNJ6Mf/z7DwUxZtkzjklDXCZnShZH4K6PCoLa489GEHYcn
         50m5suFTc7+L46in0BF+vvLTyDSZNTH5XJ7Z6LfSY9FPCdXE8P4XGQPSBhvyrBJGFKf3
         HzvSgJOY+CiDyTfDYMkdOyOLpJsb3q19cWqLRH/s62Jm2IilMbISynF2npHPvu2nDtuy
         oIBNd1ovW4XNg32aUXWB15EOusUwe4rnP7wKUfclQnJ3CPcPkSTBy7j07sRj7dcspFNu
         hXCg==
X-Gm-Message-State: AOAM533yQId/z8iRqdxIbbno9wN0CA0433zl8FkkYZk4U6bHYHnDQxpx
        cB/H0tHPCBNEuqdMOLtxYtM=
X-Google-Smtp-Source: ABdhPJwNybOt935XNXrK3BecGp84QdcxIsF+iF0L8sukR/fp69tFDEPHghei89fatWJ7oUP4r6SRUQ==
X-Received: by 2002:aa7:c041:: with SMTP id k1mr101332405edo.330.1636331109888;
        Sun, 07 Nov 2021 16:25:09 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id bf8sm8537878edb.46.2021.11.07.16.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 16:25:09 -0800 (PST)
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v2 5/5] dt-bindings: net: dsa: qca8k: add LEDs definition example
Date:   Mon,  8 Nov 2021 01:25:00 +0100
Message-Id: <20211108002500.19115-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211108002500.19115-1-ansuelsmth@gmail.com>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
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

