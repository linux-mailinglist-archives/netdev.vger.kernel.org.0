Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B821580C26
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbiGZHIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237738AbiGZHIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:08:09 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A792A739
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:08:07 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id o12so15529006ljc.3
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 00:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CQeBl6bdxDYeiutOoPw95UwPjf3Fy7w8iw/mWArASvw=;
        b=zN85OL0I7XcwDr5+NXdtzJE9Fh3X0ESA9e60K/bAmY6lQrfN2CIkjbxud/H/HRN2fw
         muTda+NOORh3cEyWpi5ozfGxPXzvtigjCWdz4AIk8MUlCHZkp7rNa9RgGg6nAPXnrJ5F
         4yYZ+IoOWFP2YNiSz9lnmoiafKNxzZ2aCNd3mrgfI70ksFwdRwGRKVf6NmlJ6BzXalX9
         MBGiQGnySWa8nbgtlLJti+8eFDBXfMPeKJMcwv9TOE7meEDePeDxl7AjeUMzaGUGNoxB
         vUlxM+fhzkgizMJIEpR4phP1vxNhJdRcAxRCS2kuz1jnutS92Uy5m/6bQSKZazfwBucD
         zhew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CQeBl6bdxDYeiutOoPw95UwPjf3Fy7w8iw/mWArASvw=;
        b=virB/DlLUZtYMwQog2UiyfXSWD65S8ULDxnXpHxGAcPLYTxxXXf3VIgZBzmYweVszr
         QYIZKZdIEi3rGvmIwbT5Mrc2e6GeY97R7mOxSFEg+iGdSuA8f7FWLycALmjYSxcGYnVm
         Gh+TqIAorEHQ70or83EoB5M6+od/6a9beryvJwXXnl57k/eyG7Nqi0e17l0vnpUg6m/C
         KCqoTfKFH5V+nHRmTPYgIsNoXzPbHFsmAQgjQifsLR8m8+1ktqOfy7geF66wYnWUsGlL
         durDRcNhw7d7GmBh27Qf2asVqvQ1AET65ZqvaVXOxefHuEfCjgzMuaTzEBKAwdq1+L8P
         EbTg==
X-Gm-Message-State: AJIora+AeYHNH07/q7eXgUkdGB+FLtaeAINz8ggHfByWQBKHdP2Wz9MH
        ITzX0oBj0s0d/fenRHR7fKjMhw==
X-Google-Smtp-Source: AGRyM1s9JECEg8k5On7lZDQn848nND8BHmVl/cB0lI4TDayD/8sEB5lu+MN960QDnjoslc2ylg71sA==
X-Received: by 2002:a05:651c:516:b0:25d:e010:fb97 with SMTP id o22-20020a05651c051600b0025de010fb97mr5315117ljp.445.1658819285763;
        Tue, 26 Jul 2022 00:08:05 -0700 (PDT)
Received: from krzk-bin.lan (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id q23-20020a05651232b700b0047f6b4a53cdsm3045061lfe.172.2022.07.26.00.08.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 00:08:05 -0700 (PDT)
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
        Rob Herring <robh@kernel.org>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH v2 1/2] dt-bindings: net: cdns,macb: use correct xlnx prefix for Xilinx
Date:   Tue, 26 Jul 2022 09:08:01 +0200
Message-Id: <20220726070802.26579-1-krzysztof.kozlowski@linaro.org>
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
Reviewed-by: Rob Herring <robh@kernel.org>

---

Changes since v1:
1. Correct deprecated:true.
2. Add Rb tag.

Cc: Harini Katakam <harini.katakam@xilinx.com>
Cc: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
---
 Documentation/devicetree/bindings/net/cdns,macb.yaml | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
index 762deccd3640..dfb2860ca771 100644
--- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
+++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
@@ -20,10 +20,17 @@ properties:
 
       - items:
           - enum:
-              - cdns,versal-gem       # Xilinx Versal
               - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
               - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
           - const: cdns,gem           # Generic
+        deprecated: true
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

