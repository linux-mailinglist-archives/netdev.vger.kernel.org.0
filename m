Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 153E02EBEF7
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbhAFNoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFNox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 08:44:53 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF6C06134D;
        Wed,  6 Jan 2021 05:44:12 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id m5so2470342wrx.9;
        Wed, 06 Jan 2021 05:44:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O0eZ/FWcbLMpPB1nKvHEdiJgH7uCG3jk9noO3gR5ju8=;
        b=YyammdhJo+QwllRxTXF/Ita14CK7RoS2yhZ0SyGM3FH7fXdKNjkJQnnegKYp9Xa2iE
         V4u20z5g+e4DqHbxFZTbyDYuorcMsyiRNKO3PHp9+6SeZ6mKpU7G0sy0bAK2aQ+Su6yN
         Yt1qjVupSYETmPwUOvl5szPpUMWss7qNLFg31znLT3zxi4ceqC6KAsyxIz8Nki4acmie
         Gz3Gq4Kda5cGVc7LzQ27NfKq8z1E8+s6Zu2gKv2VRUTPsQRgPrFdTb4YrEj4ifhMIFoI
         Sa1IxKjZdz1a5Efr6fm7KQtnJZry3WhC4REjwePhhCkPQp4MIFxTqTgEKIUsIyrpGy1e
         zzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O0eZ/FWcbLMpPB1nKvHEdiJgH7uCG3jk9noO3gR5ju8=;
        b=F2BE0iUNCeZMtlnCc1uc6r3hWlaXGj06SHpBo/zDNDncYd08odSmkj2ADIAteBu62l
         YJKzgmNnOXguHRSQrA7FLA8SBFcTLWQMbANEsXXs7kIySrHDoOjWHRieLk7kxw6kFCj2
         qLqE76cZjWTgvpkttJdgFpo2C6X8USzGiknfDkTxvW6vfPIh6/DhMw4isfEdFoiZmoYT
         +9YJH2+01HoYmYT9bcMza2E6kb14A8XHAQ8tcH708XJLk46NMn0l7fPJKzpnCNq+n9bG
         yBA6QrCGAR7YgH4SmexH1kmcqgInp5KxsS50bMqfEb/jbBGk2cx6XIPowEenc19tUI/D
         E1TQ==
X-Gm-Message-State: AOAM533fHM1L08Nz3or+mvLsdjBCEIUswGXQr+tUnydQxD3p5IV+Cyhx
        JafrvuSSljvS0EeylgfzQIA=
X-Google-Smtp-Source: ABdhPJxisIty1iQaxAOzuAu/5/SkGMbljM5mr3vpOB39Q4Od0Mjn7hqsqsh4IOdGoGVVl8nS3jCMQw==
X-Received: by 2002:adf:bb0e:: with SMTP id r14mr4500993wrg.159.1609940650942;
        Wed, 06 Jan 2021 05:44:10 -0800 (PST)
Received: from localhost.localdomain (p200300f13711ec00428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3711:ec00:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id f14sm3085351wme.14.2021.01.06.05.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 05:44:10 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, jianxin.pan@amlogic.com,
        narmstrong@baylibre.com, khilman@baylibre.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jbrunet@baylibre.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 1/5] dt-bindings: net: dwmac-meson: use picoseconds for the RGMII RX delay
Date:   Wed,  6 Jan 2021 14:42:47 +0100
Message-Id: <20210106134251.45264-2-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
References: <20210106134251.45264-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amlogic Meson G12A, G12B and SM1 SoCs have a more advanced RGMII RX
delay register which allows picoseconds precision. Deprecate the old
"amlogic,rx-delay-ns" in favour of the generic "rx-internal-delay-ps"
property.

For older SoCs the only known supported values were 0ns and 2ns. The new
SoCs have support for RGMII RX delays between 0ps and 3000ps in 200ps
steps.

Don't carry over the description for the "rx-internal-delay-ps" property
and inherit that from ethernet-controller.yaml instead.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 .../bindings/net/amlogic,meson-dwmac.yaml     | 55 +++++++++++++++++--
 1 file changed, 49 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 1f133f4a2924..0467441d7037 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -74,17 +74,60 @@ allOf:
             Any configuration is ignored when the phy-mode is set to "rmii".
 
         amlogic,rx-delay-ns:
+          deprecated: true
           enum:
             - 0
             - 2
           default: 0
           description:
-            The internal RGMII RX clock delay (provided by this IP block) in
-            nanoseconds. When phy-mode is set to "rgmii" then the RX delay
-            should be explicitly configured. When the phy-mode is set to
-            either "rgmii-id" or "rgmii-rxid" the RX clock delay is already
-            provided by the PHY. Any configuration is ignored when the
-            phy-mode is set to "rmii".
+            The internal RGMII RX clock delay in nanoseconds. Deprecated, use
+            rx-internal-delay-ps instead.
+
+        rx-internal-delay-ps:
+          default: 0
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
+        rx-internal-delay-ps:
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
+        rx-internal-delay-ps:
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
2.30.0

