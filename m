Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43B45804C7
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbiGYTvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiGYTve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:51:34 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EDB5FB3
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:51:33 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id w18so3288973lje.1
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ps5/CCHuqY7+cZdChN5ZBwBuVuATjoZQbxBn5m9FSk=;
        b=HjrTErUgQQ6O5qzdgEIN2RutjLDFe1LgytUqZMmdNM4nDv/E+FNm4AVLMCsdUYFdH0
         RNi4hBqdapWg0rVP/C1nGhVHAxdkJyX6cM3QqyDrlPkGkicdD2JPwd60gmvz7srKe2eG
         5Hwjy/kzl1Yxabl13vPhBDVHC+Amgexhq68yqwsgFc+3kwTNq7C+zQ3qhN0MVIy8qTXM
         lnuPlTIiYj8kVFdnLUehA56qcQ71ibOLyRe1vDDUvdPNc9lX5ri9Ez1XWvhaYrHH9W45
         4+Rg/MU1Tt4sfGx7odAqJWU4aLvJO0vw4rn7YBDFD9eKxrmOvmtco2BfjFnYWWdrDlN8
         rNWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2ps5/CCHuqY7+cZdChN5ZBwBuVuATjoZQbxBn5m9FSk=;
        b=yVW0/ybYRT3u/1Ps/DwTEx5wLiWu22dR1qIermFi77xuHbUhc7AcdvrlFLkk+OnWOH
         po3wyG7mw6fMP2pcG8LbrQZSY7xPuRjf6RytnW28B9CnsxLK4s2MtkVZ8nPLR/Flvq+Z
         IHuGGuNeMsFLfn4lZkMvkol0lxAxRW9vWEoofhENTtFU9td/O1qvkHarc8kXQ2GDR2kN
         JllhJh5M4i6BMMCt9PqoRhu+y9bQoqqXpa86PFOm4fwSwWRdSFZnp67Wd91eCgSbI587
         MMhvTEThRi16kW0B5Ze4rrgPv5/Y+wKLUXJeIKXfKi1jzUrmHnndl1PE5RUAlFSCCVnI
         5gcg==
X-Gm-Message-State: AJIora8kUHFh8O760Bu0NtKV7At9WupAz0rS0fSblSwGstpsCoQv7ZY1
        JssvGeNhnYHn8mvSlRVp+OkdTA==
X-Google-Smtp-Source: AGRyM1sYYBhch95RxeLVobgA3XR5XMMqveMrHinpaIfSvj6CqzsXX7nBefxB9ISmggR5ZGNwo3bVSQ==
X-Received: by 2002:a05:651c:158c:b0:250:a23d:2701 with SMTP id h12-20020a05651c158c00b00250a23d2701mr5123421ljq.475.1658778691203;
        Mon, 25 Jul 2022 12:51:31 -0700 (PDT)
Received: from krzk-bin.lan (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id a20-20020a056512201400b004790a4ce3e5sm2824973lfb.278.2022.07.25.12.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 12:51:30 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH 1/2] dt-bindings: net: cdns,macb: use correct xlnx prefix for Xilinx
Date:   Mon, 25 Jul 2022 21:51:26 +0200
Message-Id: <20220725195127.49765-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use correct vendor for Xilinx versions of Cadence MACB/GEM Ethernet
controller.  The Versal compatible was not released, so it can be
changed.  Zynq-7xxx and Ultrascale+ has to be kept in new and deprecated
form.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 Documentation/devicetree/bindings/net/cdns,macb.yaml | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 762deccd3640..77d3b73718e4 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -20,10 +20,17 @@ properties:
 
       - items:
           - enum:
-              - cdns,versal-gem       # Xilinx Versal
               - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
               - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
           - const: cdns,gem           # Generic
+        description: deprecated
+
+      - items:
+          - enum:
+              - xlnx,versal-gem       # Xilinx Versal
+              - xlnx,zynq-gem         # Xilinx Zynq-7xxx SoC
+              - xlnx,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
+          - const: cdns,gem           # Generic
 
       - items:
           - enum:
@@ -183,7 +190,7 @@ examples:
             #address-cells = <2>;
             #size-cells = <2>;
             gem1: ethernet@ff0c0000 {
-                    compatible = "cdns,zynqmp-gem", "cdns,gem";
+                    compatible = "xlnx,zynqmp-gem", "cdns,gem";
                     interrupt-parent = <&gic>;
                     interrupts = <0 59 4>, <0 59 4>;
                     reg = <0x0 0xff0c0000 0x0 0x1000>;
-- 
2.34.1

