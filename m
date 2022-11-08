Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F401620951
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 07:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbiKHGGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 01:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiKHGGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 01:06:09 -0500
Received: from gw.atmark-techno.com (gw.atmark-techno.com [13.115.124.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CB8A3F059
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 22:06:09 -0800 (PST)
Received: from gw.atmark-techno.com (localhost [127.0.0.1])
        by gw.atmark-techno.com (Postfix) with ESMTP id 7173260153
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:56:05 +0900 (JST)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        by gw.atmark-techno.com (Postfix) with ESMTPS id 5411A60141
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 14:56:03 +0900 (JST)
Received: by mail-pl1-f197.google.com with SMTP id t3-20020a170902e84300b00186ab03043dso10669070plg.20
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 21:56:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a8ltF6Z7hveQcIoHTD+Ocqy8FGU/fVCDeqON4Kuh0Nw=;
        b=qebrFLI1At11PS9+lEbN6am4rCtWDBilY3h2l90pxCNYyvVotRbXQCU6TjIzw5ZRNX
         A8G+j04T+TNYHHr63PjLtdmta+ZeLcElWUQPSlrqDJWd0q1sDwytjrHEfpxGEo+kUZQI
         QDi0BJzTIhoUrDwxlKERmApRBzWHmAb4mDGU827qCfmRW/hcZ29ScujSM10Eu5/My6vv
         EB4IxNHvVLp3VyszafCMY2NNOglloPGDRGX+euttv+N+7khNdlN5zmk6C2+io0l6SjZ4
         qsS9qwl14NT/rnW32iPwYIiIzGPxn/6lA+kXHt2xtNAkMTOcwaok3UZ9PnDCZvubkiFQ
         cSyQ==
X-Gm-Message-State: ACrzQf0LZVxWz+DAm9KfWTGuM5IcfDr5cyCBIB5Ea0XGoPrxaak1kgtY
        Bipog5d/Fy3dz9r5NyiAi7h72AP9Qr07xHs/rI2fpWiBtCkX46NtVbxJd67RF77geL2wgTlAbvS
        sLc0bM3+0dtweF1ejzSPV
X-Received: by 2002:a17:902:c948:b0:187:2d90:9fab with SMTP id i8-20020a170902c94800b001872d909fabmr38509292pla.42.1667886962291;
        Mon, 07 Nov 2022 21:56:02 -0800 (PST)
X-Google-Smtp-Source: AMsMyM51AQAM3Z9fEXEvq6HmWSn1u66y5bNSh60R/YuoHRFzhZ5NB8hMybzH+M6NCCVrPHnP1znooQ==
X-Received: by 2002:a17:902:c948:b0:187:2d90:9fab with SMTP id i8-20020a170902c94800b001872d909fabmr38509273pla.42.1667886962062;
        Mon, 07 Nov 2022 21:56:02 -0800 (PST)
Received: from pc-zest.atmarktech (103.131.189.35.bc.googleusercontent.com. [35.189.131.103])
        by smtp.gmail.com with ESMTPSA id q8-20020a170902a3c800b00186ad73e2d5sm5950422plb.208.2022.11.07.21.56.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Nov 2022 21:56:01 -0800 (PST)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.96)
        (envelope-from <martinet@pc-zest>)
        id 1osHaa-0098Kr-1g;
        Tue, 08 Nov 2022 14:56:00 +0900
From:   Dominique Martinet <dominique.martinet@atmark-techno.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, mizo@atmark-techno.com,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [RFC PATCH 1/2] dt-bindings: net: h4-bluetooth: add new bindings for hci_h4
Date:   Tue,  8 Nov 2022 14:55:30 +0900
Message-Id: <20221108055531.2176793-2-dominique.martinet@atmark-techno.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221108055531.2176793-1-dominique.martinet@atmark-techno.com>
References: <20221108055531.2176793-1-dominique.martinet@atmark-techno.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree binding to support defining a bluetooth device using the h4
uart protocol

This was tested with a NXP wireless+BT AW-XM458 module, but might
benefit others as the H4 protocol seems often used.

Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
---
 .../devicetree/bindings/net/h4-bluetooth.yaml | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/h4-bluetooth.yaml

diff --git a/Documentation/devicetree/bindings/net/h4-bluetooth.yaml b/Documentation/devicetree/bindings/net/h4-bluetooth.yaml
new file mode 100644
index 000000000000..5d11b89ca386
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/h4-bluetooth.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/h4-bluetooth.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: H4 Bluetooth
+
+maintainers:
+  - Dominique Martinet <dominique.martinet@atmark-techno.com>
+
+description:
+  H4 is a common bluetooth over uart protocol.
+  For example, the AW-XM458 is a WiFi + BT module where the WiFi part is
+  connected over PCI (M.2), while BT is connected over serial speaking
+  the H4 protocol. Its firmware is sent on the PCI side.
+
+properties:
+  compatible:
+    enum:
+      - nxp,aw-xm458-bt
+
+  max-speed: true
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+    #include <dt-bindings/clock/imx8mp-clock.h>
+
+    uart1 {
+        pinctrl-names = "default";
+        pinctrl-0 = <&pinctrl_uart1>;
+        assigned-clocks = <&clk IMX8MP_CLK_UART1>;
+        assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_80M>;
+        status = "okay";
+        fsl,dte-mode = <1>;
+        fsl,uart-has-rtscts;
+
+
+        bluetooth {
+            compatible = "nxp,aw-xm458-bt";
+            max-speed = <3000000>;
+        };
+    };
-- 
2.35.1


