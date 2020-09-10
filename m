Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF00264D9B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgIJSqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726639AbgIJQN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 12:13:26 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB9B121D91;
        Thu, 10 Sep 2020 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599754357;
        bh=4BDeDZK996n/Vh4H0ckJIlmceQtTA38A19o30K70hSY=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P+dpOwouw9W8ptrls/F7JGMUkPFTYFzDnueo5mMPnroDoY8BpUNfoD1JwbnzahIvC
         xGGxnEaSBxjbewiujbeG7eeBIJlqTnf+TIybcpsS6a1SLAR/0uVeND30tmqgMkzxLj
         BEODxoO3/Kn5F9Oal6M6tLn2BF6Y7fOAqYtT2a+4=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-nfc@lists.01.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v3 2/8] dt-bindings: net: nfc: s3fwrn5: Remove wrong vendor prefix from GPIOs
Date:   Thu, 10 Sep 2020 18:12:13 +0200
Message-Id: <20200910161219.6237-3-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200910161219.6237-1-krzk@kernel.org>
References: <20200910161219.6237-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The device tree property prefix describes the vendor, which in case of
S3FWRN5 chip is Samsung.  Therefore the "s3fwrn5" prefix for "en-gpios"
and "fw-gpios" is not correct and should be deprecated.  Introduce
properly named properties for these GPIOs and rename the fw-gpios" to
"wake-gpios" to better describe its purpose.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 .../bindings/net/nfc/samsung,s3fwrn5.yaml     | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
index f43d31a2d94b..cb0b8a560282 100644
--- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
@@ -14,30 +14,42 @@ properties:
   compatible:
     const: samsung,s3fwrn5-i2c
 
+  en-gpios:
+    maxItems: 1
+    description:
+      Output GPIO pin used for enabling/disabling the chip
+
   interrupts:
     maxItems: 1
 
   reg:
     maxItems: 1
 
+  wake-gpios:
+    maxItems: 1
+    description:
+      Output GPIO pin used to enter firmware mode and sleep/wakeup control
+
   s3fwrn5,en-gpios:
     maxItems: 1
+    deprecated: true
     description:
-      Output GPIO pin used for enabling/disabling the chip
+      Use en-gpios
 
   s3fwrn5,fw-gpios:
     maxItems: 1
+    deprecated: true
     description:
-      Output GPIO pin used to enter firmware mode and sleep/wakeup control
+      Use wake-gpios
 
 additionalProperties: false
 
 required:
   - compatible
+  - en-gpios
   - interrupts
   - reg
-  - s3fwrn5,en-gpios
-  - s3fwrn5,fw-gpios
+  - wake-gpios
 
 examples:
   - |
@@ -55,7 +67,7 @@ examples:
             interrupt-parent = <&gpa1>;
             interrupts = <3 IRQ_TYPE_LEVEL_HIGH>;
 
-            s3fwrn5,en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
-            s3fwrn5,fw-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
+            en-gpios = <&gpf1 4 GPIO_ACTIVE_HIGH>;
+            wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
         };
     };
-- 
2.17.1

