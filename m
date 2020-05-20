Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE161DB199
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgETLZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgETLZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:25:36 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAABC08C5C1
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:34 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n18so2462482wmj.5
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MAzJNRl7denaMJiKd3+TRewxkBzsyKS+1FyrOm5aCWE=;
        b=JNXV5es6bVnc90JsNslvmJSDVtTWg6voKEZtsMvHPli1CC6BviGCNJs19aTP1ai09t
         fqgtC4/xo1QX2QKXZKz8VkKEeFn7e/7dGgrlpWl4mHmIg1xbRnP/KpaITQctqjDFxy5h
         QamSWG1CBpwGBTega0WNOLPVCbyvxduZuqc0kuUu4SzUXgWl839m9RIiqg89wFz0D4DH
         aOskFeVXLjz9VqXX+WLOQSeIuA5r+yiIDXS1EBW9WuPr+5o7pvUq5BSCvjD79BDICYCJ
         sUFaWoufIx40GJY4YtMmHXFu4kDfrwlsgnBo5DAny0IMpwZYqe5BSeqgo9A4VtekPGj4
         XBNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MAzJNRl7denaMJiKd3+TRewxkBzsyKS+1FyrOm5aCWE=;
        b=ApJYc+eMd1o2JlLhoPtn8mKiEhUio7LB/NIn5babXdTByIeiUsv3OhZYwmhinZnrBM
         1g9dB7M2l0rjQhyzylOQc0zEQQKJFvixfud8PssTvIaFcZ5IbXDi/DtZbgxEuhhvVL1t
         xcdZFX8JSS9s+PkVa6tCL4ED1KjotH0tsNKvS02o9aORsXwdkn/jIzdKWW03R+L3F147
         sQNMO9iDEwosUe9+p7j+1pBdjpPratHney1vayrwRZTpA0S9RT9VU0KEDq9Y3DCK4FiX
         UtXtgTH9o46QuWY9V7V4Wxrj6NuqqWZpvUKy8D84WJaef7k65siKaw1V/LzX7IDBQ1Xk
         1pcw==
X-Gm-Message-State: AOAM531hOvGFbOkOEeq7IM2PWHNfjwxBneSEqjJ6GrMRI9v7+qlcUkFW
        gCZ8WISprWDlmeHl+cDoDZOyFw==
X-Google-Smtp-Source: ABdhPJzW5vlDbLSisa2PSw+E6LNVAep4nrZ3vKsnzEHLsDBwF4hpuoLIWC8DU2L9XBtcraMXVql0Bg==
X-Received: by 2002:a1c:6156:: with SMTP id v83mr4104320wmb.28.1589973933005;
        Wed, 20 May 2020 04:25:33 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id v22sm2729265wml.21.2020.05.20.04.25.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:25:32 -0700 (PDT)
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
Subject: [PATCH v4 01/11] dt-bindings: convert the binding document for mediatek PERICFG to yaml
Date:   Wed, 20 May 2020 13:25:13 +0200
Message-Id: <20200520112523.30995-2-brgl@bgdev.pl>
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

Convert the DT binding .txt file for MediaTek's peripheral configuration
controller to YAML. There's one special case where the compatible has
three positions. Otherwise, it's a pretty normal syscon.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../arm/mediatek/mediatek,pericfg.txt         | 36 -----------
 .../arm/mediatek/mediatek,pericfg.yaml        | 63 +++++++++++++++++++
 2 files changed, 63 insertions(+), 36 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt
 create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml

diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt
deleted file mode 100644
index ecf027a9003a..000000000000
--- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.txt
+++ /dev/null
@@ -1,36 +0,0 @@
-Mediatek pericfg controller
-===========================
-
-The Mediatek pericfg controller provides various clocks and reset
-outputs to the system.
-
-Required Properties:
-
-- compatible: Should be one of:
-	- "mediatek,mt2701-pericfg", "syscon"
-	- "mediatek,mt2712-pericfg", "syscon"
-	- "mediatek,mt7622-pericfg", "syscon"
-	- "mediatek,mt7623-pericfg", "mediatek,mt2701-pericfg", "syscon"
-	- "mediatek,mt7629-pericfg", "syscon"
-	- "mediatek,mt8135-pericfg", "syscon"
-	- "mediatek,mt8173-pericfg", "syscon"
-	- "mediatek,mt8183-pericfg", "syscon"
-- #clock-cells: Must be 1
-- #reset-cells: Must be 1
-
-The pericfg controller uses the common clk binding from
-Documentation/devicetree/bindings/clock/clock-bindings.txt
-The available clocks are defined in dt-bindings/clock/mt*-clk.h.
-Also it uses the common reset controller binding from
-Documentation/devicetree/bindings/reset/reset.txt.
-The available reset outputs are defined in
-dt-bindings/reset/mt*-resets.h
-
-Example:
-
-pericfg: power-controller@10003000 {
-	compatible = "mediatek,mt8173-pericfg", "syscon";
-	reg = <0 0x10003000 0 0x1000>;
-	#clock-cells = <1>;
-	#reset-cells = <1>;
-};
diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
new file mode 100644
index 000000000000..1340c6288024
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,pericfg.yaml
@@ -0,0 +1,63 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,pericfg.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: MediaTek Peripheral Configuration Controller
+
+maintainers:
+  - Bartosz Golaszewski <bgolaszewski@baylibre.com>
+
+description:
+  The Mediatek pericfg controller provides various clocks and reset outputs
+  to the system.
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+        - enum:
+          - mediatek,mt2701-pericfg
+          - mediatek,mt2712-pericfg
+          - mediatek,mt7622-pericfg
+          - mediatek,mt7629-pericfg
+          - mediatek,mt8135-pericfg
+          - mediatek,mt8173-pericfg
+          - mediatek,mt8183-pericfg
+        - const: syscon
+      - items:
+        # Special case for mt7623 for backward compatibility
+        - const: mediatek,mt7623-pericfg
+        - const: mediatek,mt2701-pericfg
+        - const: syscon
+
+  reg:
+    maxItems: 1
+
+  '#clock-cells':
+    const: 1
+
+  '#reset-cells':
+    const: 1
+
+required:
+  - compatible
+  - reg
+
+examples:
+  - |
+    pericfg@10003000 {
+        compatible = "mediatek,mt8173-pericfg", "syscon";
+        reg = <0x10003000 0x1000>;
+        #clock-cells = <1>;
+        #reset-cells = <1>;
+    };
+
+  - |
+    pericfg@10003000 {
+        compatible =  "mediatek,mt7623-pericfg", "mediatek,mt2701-pericfg", "syscon";
+        reg = <0x10003000 0x1000>;
+        #clock-cells = <1>;
+        #reset-cells = <1>;
+    };
-- 
2.25.0

