Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FD2851A5
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389086AbfHGRFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:05:01 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40609 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388480AbfHGRE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:04:59 -0400
Received: by mail-pl1-f196.google.com with SMTP id a93so41660471pla.7
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 10:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8vhZ9nsrUD9hIgyTDzwXKunAVA/2Wy6GZsnqTKgw2n8=;
        b=Ao2pGRXOpKDk4nbYtcHDtkTBYFkyLx4Yni5jQwZYVlY8sDhj/4xgjNVN9qOgXiwL/J
         Hj2OphsBVTd0gxtiFwK/jvT8Gv1DTq2dJOXWmqdchM0bF5BJWkC3iCG3eF9OjtXp+fhc
         nmdczgH0b4eZWwT+GNRaNSasLDOJCBYHcVdnE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8vhZ9nsrUD9hIgyTDzwXKunAVA/2Wy6GZsnqTKgw2n8=;
        b=JA8E3fQGW2UuTr+3cksNx1ZRDkITOwJWnR2ChB0xfZz9uKk3A5JTQJpNXXoshnV2Ro
         Cm4ykrD7QHkcEb5iYBWOgwD6TL+BDowf353ZptMWg8B5YDl+PlOjjIk6Vut9ks/IWuO2
         7AeHNiPG7IjFam639GPxkQgSO1qL8CYylxOdNt9Cy2OLKGMo3VdUyNHF6tM2k38yalxX
         MTJJR1dk3i1r9Dlx/yBz6VuzhEcUUtL6g/54Q0F7whGZwpN4aPsq2P+OaNggIE/rFCTS
         dVd78Z/2S8YMInAvyYioHXTa4FSsV32Z6QPkZz4FKPtOJQFERJcQPcawlvk9oEgmXgVA
         vubQ==
X-Gm-Message-State: APjAAAV2723ZF7xLOY646seoIVhLEIpDPtNG9xLgQTmgKLYMR/N5kGF/
        n8q/hNhFYh/NRgEfIIw1m7rjgw==
X-Google-Smtp-Source: APXvYqxU13J673ziusogsa1/C6DTIQqz7ShxegM9+j0/+rcB+5nM8TkT9NV+jdgAZa9cwmloa9LJKA==
X-Received: by 2002:a17:902:968c:: with SMTP id n12mr9486680plp.59.1565197498966;
        Wed, 07 Aug 2019 10:04:58 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id p187sm146394184pfg.89.2019.08.07.10.04.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 10:04:58 -0700 (PDT)
From:   Matthias Kaehlcke <mka@chromium.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH v5 1/4] dt-bindings: net: phy: Add subnode for LED configuration
Date:   Wed,  7 Aug 2019 10:04:46 -0700
Message-Id: <20190807170449.205378-2-mka@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190807170449.205378-1-mka@chromium.org>
References: <20190807170449.205378-1-mka@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The LED behavior of some Ethernet PHYs is configurable. Add an
optional 'leds' subnode with a child node for each LED to be
configured. The binding aims to be compatible with the common
LED binding (see devicetree/bindings/leds/common.txt).

A LED can be configured to be:

- 'on' when a link is active, some PHYs allow configuration for
  certain link speeds
  speeds
- 'off'
- blink on RX/TX activity, some PHYs allow configuration for
  certain link speeds

For the configuration to be effective it needs to be supported by
the hardware and the corresponding PHY driver.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
Changes in v5:
- renamed triggers from 'phy_link_<speed>_active' to 'phy-link-<speed>'
- added entries for 'phy-link-<speed>-activity'
- added 'phy-link' and 'phy-link-activity' for triggers with any link
  speed
- added entry for trigger 'none'

Changes in v4:
- patch added to the series
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index f70f18ff821f..98ba320f828b 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -153,6 +153,50 @@ properties:
       Delay after the reset was deasserted in microseconds. If
       this property is missing the delay will be skipped.
 
+patternProperties:
+  "^leds$":
+    type: object
+    description:
+      Subnode with configuration of the PHY LEDs.
+
+    patternProperties:
+      "^led@[0-9]+$":
+        type: object
+        description:
+          Subnode with the configuration of a single PHY LED.
+
+    properties:
+      reg:
+        description:
+          The ID number of the LED, typically corresponds to a hardware ID.
+        $ref: "/schemas/types.yaml#/definitions/uint32"
+
+      linux,default-trigger:
+        description:
+          This parameter, if present, is a string specifying the trigger
+          assigned to the LED. Supported triggers are:
+            "none" - LED will be solid off
+            "phy-link" - LED will be solid on when a link is active
+            "phy-link-10m" - LED will be solid on when a 10Mb/s link is active
+            "phy-link-100m" - LED will be solid on when a 100Mb/s link is active
+            "phy-link-1g" - LED will be solid on when a 1Gb/s link is active
+            "phy-link-10g" - LED will be solid on when a 10Gb/s link is active
+            "phy-link-activity" - LED will be on when link is active and blink
+                                  off with activity.
+            "phy-link-10m-activity" - LED will be on when 10Mb/s link is active
+                                      and blink off with activity.
+            "phy-link-100m-activity" - LED will be on when 100Mb/s link is
+                                       active and blink off with activity.
+            "phy-link-1g-activity" - LED will be on when 1Gb/s link is active
+                                     and blink off with activity.
+            "phy-link-10g-activity" - LED will be on when 10Gb/s link is active
+                                      and blink off with activity.
+
+        $ref: "/schemas/types.yaml#/definitions/string"
+
+    required:
+      - reg
+
 required:
   - reg
 
@@ -173,5 +217,20 @@ examples:
             reset-gpios = <&gpio1 4 1>;
             reset-assert-us = <1000>;
             reset-deassert-us = <2000>;
+
+            leds {
+                #address-cells = <1>;
+                #size-cells = <0>;
+
+                led@0 {
+                    reg = <0>;
+                    linux,default-trigger = "phy-link-1g";
+                };
+
+                led@1 {
+                    reg = <1>;
+                    linux,default-trigger = "phy-link-100m-activity";
+                };
+            };
         };
     };
-- 
2.22.0.770.g0f2c4a37fd-goog

