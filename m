Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF7722B3820
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 19:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgKOSxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 13:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727487AbgKOSwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 13:52:46 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758C8C0613D1;
        Sun, 15 Nov 2020 10:52:44 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id o9so21335382ejg.1;
        Sun, 15 Nov 2020 10:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E+18CrNfDdc6Xjlrzu0P7r7p/VFLVBF4d9iMMGcM4qU=;
        b=qpYQKM6MaTg09ytOZkAKsNMsrZ3Qtc1ndV3ioZIhLQrmezuEhIpVYiCj3TskTOc7z9
         4SWnoyUIRksTLrJqex8tVOZY1ojC3CnIYaO8moeO1Sqz8ndphdgffDHgdiULllerTlIM
         5guOynfVSUHYigqGDM5pctfg1eqhsFIPUshY6bngIQpHNh9lb4GBE6RkW2j19s0+m040
         DsgTIBHKB0m/kciFb7fD4HDd1DWahbRPtLxqze3lC3oSGS19cdzEEzsmdEegRKEZbLxx
         Vnf1KTliHLBwmzkCkpR3t+QzpHu+h6pzTpXdljaUvBkEx79pdrzKLntjYn1ap6+4th4r
         8Ulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E+18CrNfDdc6Xjlrzu0P7r7p/VFLVBF4d9iMMGcM4qU=;
        b=dec6kJsJyAl9JEPwTVw56F0TVbtbNN0J3vuVe1DoPFFTr+QTnw8YMh+/zoUMojMCwo
         Z6a0/4CJtl86NeQKqh/Gf9RmxDeJVOHsSyqwzZZnbKNLJUkEuMa8hJRm+I5AB7HeDnvH
         7ADVwn2P0yQMSeMW/ADLAlchnf6B75XMKy+7l13iE0Wchk5j2GAj4uwANrlPkGfX21b7
         YTyOA4wgQyOu0jtJA2aj8341I/YZak5tzazAYoFLAzmuu2L/nztW+Nnvp8LM4WCBovOa
         HOjH1NAZ8m1UTgzzTlw+GwRUWocnZ4OBDzL+imVJIO6mHsgtiniQ9v/AmFB1MuP4sgBb
         ixGQ==
X-Gm-Message-State: AOAM5331UjfNfKn6dwDie3UJtkory7xAFX2hm2IFuuNKLrGwrIqb0r4V
        n7ZFrHVAywUZVaYeFtST+Ys=
X-Google-Smtp-Source: ABdhPJyMRtxi/13PoZcT9VMOoxSgXzahBF89j9Fi+8jpVaj8nVR13EInIWvMqwHEwtotej7ruZbGoA==
X-Received: by 2002:a17:906:4a98:: with SMTP id x24mr11318257eju.304.1605466363133;
        Sun, 15 Nov 2020 10:52:43 -0800 (PST)
Received: from localhost.localdomain (p4fc3ea77.dip0.t-ipconnect.de. [79.195.234.119])
        by smtp.googlemail.com with ESMTPSA id i13sm9233520ejv.84.2020.11.15.10.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 10:52:42 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org
Cc:     jianxin.pan@amlogic.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, khilman@baylibre.com,
        narmstrong@baylibre.com, jbrunet@baylibre.com, andrew@lunn.ch,
        f.fainelli@gmail.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v2 1/5] dt-bindings: net: dwmac-meson: use picoseconds for the RGMII RX delay
Date:   Sun, 15 Nov 2020 19:52:06 +0100
Message-Id: <20201115185210.573739-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
References: <20201115185210.573739-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
delay register which allows picoseconds precision. Deprecate the old
"amlogic,rx-delay-ns" in favour of a new "amlogic,rgmii-rx-delay-ps"
property.

For older SoCs the only known supported values were 0ns and 2ns. The new
SoCs have 200ps precision and support RGMII RX delays between 0ps and
3000ps.

While here, also update the description of the RX delay to indicate
that:
- with "rgmii" or "rgmii-id" the RX delay should be specified
- with "rgmii-id" or "rgmii-rxid" the RX delay is added by the PHY so
  any configuration on the MAC side is ignored
- with "rmii" the RX delay is not applicable and any configuration is
  ignored

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../bindings/net/amlogic,meson-dwmac.yaml     | 61 +++++++++++++++++--
 1 file changed, 56 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 6b057b117aa0..62a1e92a645c 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -74,17 +74,68 @@ allOf:
             Any configuration is ignored when the phy-mode is set to "rmii".
 
         amlogic,rx-delay-ns:
+          deprecated: true
           enum:
             - 0
             - 2
           default: 0
+          description:
+            The internal RGMII RX clock delay in nanoseconds. Deprecated, use
+            amlogic,rgmii-rx-delay-ps instead.
+
+        amlogic,rgmii-rx-delay-ps:
+          default: 0
           description:
             The internal RGMII RX clock delay (provided by this IP block) in
-            nanoseconds. When phy-mode is set to "rgmii" then the RX delay
-            should be explicitly configured. When the phy-mode is set to
-            either "rgmii-id" or "rgmii-rxid" the RX clock delay is already
-            provided by the PHY. Any configuration is ignored when the
-            phy-mode is set to "rmii".
+            picoseconds. When phy-mode is set to "rgmii" or "rgmii-id" then
+            the RX delay should be explicitly configured. When the phy-mode
+            is set to either "rgmii-id" or "rgmii-rxid" the RX clock delay
+            is already provided by the PHY so any configuration here is
+            ignored. Also any configuration is ignored when the phy-mode is
+            set to "rmii".
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - amlogic,meson8b-dwmac
+              - amlogic,meson8m2-dwmac
+              - amlogic,meson-gxbb-dwmac
+              - amlogic,meson-axg-dwmac
+    then:
+      properties:
+        amlogic,rgmii-rx-delay-ps:
+          enum:
+            - 0
+            - 2000
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - amlogic,meson-g12a-dwmac
+    then:
+      properties:
+        amlogic,rgmii-rx-delay-ps:
+          enum:
+            - 0
+            - 200
+            - 400
+            - 600
+            - 800
+            - 1000
+            - 1200
+            - 1400
+            - 1600
+            - 1800
+            - 2000
+            - 2200
+            - 2400
+            - 2600
+            - 2800
+            - 3000
 
 properties:
   compatible:
-- 
2.29.2

