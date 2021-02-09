Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D9D315A87
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234761AbhBJADO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234832AbhBIXNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 18:13:38 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C622AC061756;
        Tue,  9 Feb 2021 15:02:24 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id b16so300315lji.13;
        Tue, 09 Feb 2021 15:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X0q5IddP/axEMBWVjCa6ciUtMnAzBD6gUjo6LmKWOyA=;
        b=GYbLjjN/fgc6z2PzwEc5CNjOPrb473XoKRJvAkH0Tr1EBs0VvjvubgLoeoVjciY/X2
         Vv+6F9uDG39yWAtdKY25+CAaw2Nwc3YuIQFwLYvoeTBbTNPR4iRUJrHiGYxkw+YVOEr9
         CB7rdxOvqzWp/Bb9vC50jrOGDpWBQoYi4NX85uxtlmlfL28Ueq0HC5X75UlznilsIXLj
         4MSyOLJTv0961PAX22fh6DF918/WPuXJdxOQB5k2Fs21bN+3v5VSDCImGtfW5P5ApYTX
         Q7Y9bgdkc7nxLkwwfDQTO+ROgLlm8J7InpnFBry/jUDNPww42l6n35c9LEKdZYQuG/yB
         Gp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X0q5IddP/axEMBWVjCa6ciUtMnAzBD6gUjo6LmKWOyA=;
        b=sn2Dus+BocahPFM5BqM4mPcxUD8SJwNhUFFiNT/tDf2TLhWL2tsu+LO+xbHo71p/Lx
         XpbM1VZ8UGTzQ8VZgCOKY74E+09FY+huRjgVRLJyv2KAz38WKkm6gYh/FHMw4gXZXWjc
         a/+KFunv9r/8LAhvt26CrTlg7sVYQPHxEiV7PaZQtCgP/vuivhYO8so4OOTaVhIBPPsl
         9kn0h5DecgNHbg+wZrywx3F86sh8EznEB2FPUkgwqmt4INJwkEcmwIevy5/PXskIkpkM
         fMhdQS5SWaIskvZhyXEkbuWisBA3uhMjDpaBb/YOSoZLGrM4rTFP5gm2IhvFhAXiE/qK
         KzZA==
X-Gm-Message-State: AOAM530cXzUc3Fmve6xZxoscoS0rIlgSuJ2qrIPoYyecomj2ROvU/Jbf
        kTmDxskkgg0myEOkT+zQnMg=
X-Google-Smtp-Source: ABdhPJwLnpLBZ1j3UK9bLzh5+q+RSJuysGTwcLRGymdof3VdhLvdxeDjLIQkXLUKX3+GSmWs3IxCJQ==
X-Received: by 2002:a2e:7a18:: with SMTP id v24mr63752ljc.55.1612911743331;
        Tue, 09 Feb 2021 15:02:23 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id g20sm1364211lfr.50.2021.02.09.15.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 15:02:22 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3 net-next 1/2] dt-bindings: net: document BCM4908 Ethernet controller
Date:   Wed, 10 Feb 2021 00:01:29 +0100
Message-Id: <20210209230130.4690-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210207222632.10981-2-zajec5@gmail.com>
References: <20210207222632.10981-2-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 is a family of SoCs with integrated Ethernet controller.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V3: Use ethernet-controller.yaml#
    Rename "compatible" value (use "-")
    Drop "interrupt-names" until it's needed
---
 .../bindings/net/brcm,bcm4908-enet.yaml       | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
new file mode 100644
index 000000000000..5050974c8550
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,bcm4908-enet.yaml
@@ -0,0 +1,43 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,bcm4908-enet.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM4908 Ethernet controller
+
+description: Broadcom's Ethernet controller integrated into BCM4908 family SoCs
+
+maintainers:
+  - Rafał Miłecki <rafal@milecki.pl>
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+
+properties:
+  compatible:
+    const: brcm,bcm4908-enet
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    description: RX interrupt
+
+required:
+  - reg
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@80002000 {
+        compatible = "brcm,bcm4908-enet";
+        reg = <0x80002000 0x1000>;
+
+        interrupts = <GIC_SPI 86 IRQ_TYPE_LEVEL_HIGH>;
+    };
-- 
2.26.2

