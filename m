Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EADC3EBE25
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235272AbhHMWDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:03:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbhHMWDM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 18:03:12 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9C4C0613A4
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:42 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id r9so13061996lfn.3
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 15:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zdoJvRdg/wiFMUqCvkYyo5RNQaUscCsPcncLCMhtPj8=;
        b=f8XsZ752SQAycow7/iB1RfXwOm+G3Zp1Tz6qAUMBy1R6O2FZ9qoZ22yYdqZBOZyxI5
         v3G4fUbh1rqqvN0qM0LRurSHXB2l8P7hv7TZMN7RWpSX3vg4fT7qmMPSZ39ySSJKgCIW
         zh0+qsnpHTjybYQ3emFBesytEPSiPLomOk4WZXeUhPXg7xMDJr9+NHnSschXrogQNu5N
         77WWZPs6lfHmzNq54qZN0YjSYLmR9rmbF3K0Fo2aMcIyQKTIaHj/SLjEi3pg6/KSlvZx
         ljYhoxKherijbquT7IqBSmIQaeVMhPNxIXhfLLXjGWkgkaNWo67yeVYHxLWob2WT+y2H
         tdVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zdoJvRdg/wiFMUqCvkYyo5RNQaUscCsPcncLCMhtPj8=;
        b=CKrGc8ayhZBpOFUxmA52ef2MkXQVKjeFbzPv//VV0YlmsubGM7onxNHRN0N3CI2wyH
         u7OuVCixxBx57ghCcohQszJPzBie+CIsMLu5RJxfU4IlYTFUPD6apY/C8PNU4TOt0ysr
         BMLkwt8nxSyzGzRVrSGBw2pjF25gpbqrRWAcuf+X4YSI3P0UXmJRcYTpGkNCUh82CWFe
         BON8+0Xq45+xAx64vCxTds29ZR4lMdaxUBiiUVgfuIoV1BisKSEL4KAj4DYBUub6KaFA
         75EC1apksJJQxDjzwJS943yODUGSeDiDFjr04VcVmzuRR/b+513Np5ttDJZ6y2sQyU6j
         FP3w==
X-Gm-Message-State: AOAM532Hn9c0c5FworOrE5EvrCUPpjHs15G8JlAJm3N3mhTmnOWB8Io0
        kfZYrs4ApwCMTqFIBhZulfRFgrPolshjcw==
X-Google-Smtp-Source: ABdhPJxe0oddE+SnbYcUknKoKmvFBnFFiwpK0p+40INIEZBanyAowK9scIelaK+O/i9oOfhCzlKfAg==
X-Received: by 2002:ac2:5496:: with SMTP id t22mr3086990lfk.445.1628892160938;
        Fri, 13 Aug 2021 15:02:40 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s17sm274912ljp.61.2021.08.13.15.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 15:02:40 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH net-next 5/6 v2] ixp4xx_eth: Add devicetree bindings
Date:   Sat, 14 Aug 2021 00:00:10 +0200
Message-Id: <20210813220011.921211-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210813220011.921211-1-linus.walleij@linaro.org>
References: <20210813220011.921211-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree bindings for the IXP46x PTP Timer, a companion
to the IXP4xx ethernet in newer platforms.

Cc: devicetree@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 .../bindings/net/intel,ixp46x-ptp-timer.yaml  | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml

diff --git a/Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml b/Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml
new file mode 100644
index 000000000000..8b9b3f915d92
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,ixp46x-ptp-timer.yaml
@@ -0,0 +1,54 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2018 Linaro Ltd.
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/intel,ixp46x-ptp-timer.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Intel IXP46x PTP Timer (TSYNC)
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description: |
+  The Intel IXP46x PTP timer is known in the manual as IEEE1588 Hardware
+  Assist and Time Synchronization Hardware Assist TSYNC provides a PTP
+  timer. It exists in the Intel IXP45x and IXP46x XScale SoCs.
+
+properties:
+  compatible:
+    const: intel,ixp46x-ptp-timer
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: Interrupt to trigger master mode snapshot from the
+          PRP timer, usually a GPIO interrupt.
+      - description: Interrupt to trigger slave mode snapshot from the
+          PRP timer, usually a GPIO interrupt.
+
+  interrupt-names:
+    items:
+      - const: master
+      - const: slave
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    ptp-timer@c8010000 {
+        compatible = "intel,ixp46x-ptp-timer";
+        reg = <0xc8010000 0x1000>;
+        interrupt-parent = <&gpio0>;
+        interrupts = <8 IRQ_TYPE_EDGE_FALLING>, <7 IRQ_TYPE_EDGE_FALLING>;
+        interrupt-names = "master", "slave";
+    };
-- 
2.31.1

