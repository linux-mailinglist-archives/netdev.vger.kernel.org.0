Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424343DC920
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 02:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhHAAcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 20:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhHAAcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 20:32:11 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1100CC061799
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:32:01 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id m9so18680328ljp.7
        for <netdev@vger.kernel.org>; Sat, 31 Jul 2021 17:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2L3zqMoEN0w93t8aXl7IFgGCX2iAcHglMaP4nZ8ctSY=;
        b=y7e1B3fQA3oBbsmb6Z9mqvMhwd1C3RPDyREPH7bd2n7yzHeDNlalEAqxF6KRU6NV6U
         r8inAJ6sVfaBWMv6+k9Y0TMKbjCxwCY02DdCtcTpoRKPlKu6F22Mp8BPuT8PIthm9/MF
         eBmLVXgz4oCNMbuGiDM5weCWnY9CLgLeMxZMPcav2OREzw/FB85j8uwIFrojhP23vPFS
         2GKKHfRtd0P+AQWCwpMqYgKHybUJpEOHZGmK4Y1oa5XhpUhVF34uOQeZYzWuwZHOC6RB
         mJEswIVsxdVtNEDp6L2LY6uWNWcfV2LGJ+SNrXoHAwTdMXR+7MtHCjHIDIBkdbypCaSl
         2JFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2L3zqMoEN0w93t8aXl7IFgGCX2iAcHglMaP4nZ8ctSY=;
        b=Hlm/gW6U7aeqxjSTB5DBYiYLMQtMBfsXYfcFbRTDGC5FsrzIfXx051ccG9RX0mvEbz
         Q2UAlvdRoBcZNV8v5s8tCf2V6vSgyNvF0M0oWHcoy+/apkBStU3bDz/tb94eVFAyPJQv
         TpYw7WG5HojKRqqes3XREa4spc9mPK7Qjk+I44JQDysoCIV29/wPZtxKen+ITxGKZha6
         virYtOU03Yj2nldzGuKfWDvF+c3af4bzSJfd8lFd7XtpL0bp9fu2ZJ1F4/ZNKPUlFZ2S
         T53/Xo8ltR0J4IJuH5imoJYS4HJb0ioB7c1l+dCDz3QUaH6inuE/fpYJ5A2VwLthwwe4
         7tEA==
X-Gm-Message-State: AOAM532FSHLS8h5DsdCfJPKDO99lVEVfygEH3lowPKMIpECsFSvebk75
        zjVoH8tgY2Ar4abVkD06uCKkl0zGYzEapA==
X-Google-Smtp-Source: ABdhPJxSRJ7YrhcdiDDqAugoBonIOkD4I22a2BHeZCwN+bY7kwDcvsjG89iL4hAV7j81NDBECUk80A==
X-Received: by 2002:a2e:9cc3:: with SMTP id g3mr6599789ljj.83.1627777919339;
        Sat, 31 Jul 2021 17:31:59 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r6sm485255ljk.76.2021.07.31.17.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 17:31:59 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Imre Kaloz <kaloz@openwrt.org>, Krzysztof Halasa <khalasa@piap.pl>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next 5/6] ixp4xx_eth: Add devicetree bindings
Date:   Sun,  1 Aug 2021 02:27:36 +0200
Message-Id: <20210801002737.3038741-6-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210801002737.3038741-1-linus.walleij@linaro.org>
References: <20210801002737.3038741-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree bindings for the IXP46x PTP Timer, a companion
to the IXP4xx ethernet in newer platforms.

Cc: devicetree@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
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

