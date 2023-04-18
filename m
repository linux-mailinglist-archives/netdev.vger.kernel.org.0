Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 556326E5D8D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 11:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjDRJil (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 05:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231308AbjDRJik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 05:38:40 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B3D1BCA;
        Tue, 18 Apr 2023 02:38:39 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id j11so17198579ljq.10;
        Tue, 18 Apr 2023 02:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681810717; x=1684402717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lb7Hmi4qrMx3y4a0oEkH9YVxHmM21sJHrETGqqG+9Xk=;
        b=j0+H7Al1iBdQY1xKqRJyJwcwUhRfGBMDisXwRy29PxizwZTAUzpD6bW+61adKcZjCb
         6RUWyoIg2FAHyStLXH+3SffSmZMDluHYsEwQp2/yAOQklNRJ+hlmczDXSktw09yySv2l
         Tt8ER6C1f2impZbNVkRqlffjDGP9xNNcZImaK35al5VRW16bGl3u20IzQZ3A3VW77AIy
         nIfRuo7wD4qOiZhAap7BpKExmhoZ/ATgDG0OR/Zdp06lddvMmHl3jIHyNmVktyVHvY/4
         1ji/xcwUCl7VjtsQrEu4Lj/0umt5OvDHhGAAxHH+KK7IjHiIx88+WaI4Zk28CDNr6xOw
         oMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681810717; x=1684402717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lb7Hmi4qrMx3y4a0oEkH9YVxHmM21sJHrETGqqG+9Xk=;
        b=A4lMXVZiZWSm0NZo6222vkryqCkavS/1CNuFyUkRdAByKyYOwvA1AIeAdF43tADjvs
         xq68jp/qN8EtQlcus2v0Nd6ru4voGUDbPxL4uPehaeSXn+2ip1EIJ11E5f+vg0t75zSH
         miptYLCCTapo+aKyRMc6JbmUFyTTTIHSZ3zUflaLe84iQoJxRnra/vpFDaflJig1hv7m
         Kn6Xit9PadAyqV+Ws3ZG79gKfLfqqC47tdTo02Zo70PaNRVjCPGsO159b1E2RGq3Jfno
         qhASIU4vTv4neSLs2e0u+wSWdDPlOdBQA6RpImD/tsLrnAiNbJoKMtzbnTVEB0K/taTv
         Vocw==
X-Gm-Message-State: AAQBX9dXocteLqQOuYVLTVGL85BWRi+37Wfz2jJ+ZAdg9azkdorolsKR
        Y2+DC1gPUp3mHNbMMm6Geoc=
X-Google-Smtp-Source: AKy350Y2x+hHyvKcRq0EygCll3oxaYPxP0eJt1ReWSYTyB+WxGChHGASIbKWMjhZaV/r5vMB42Uqxw==
X-Received: by 2002:a2e:904c:0:b0:2a8:ddb0:baa6 with SMTP id n12-20020a2e904c000000b002a8ddb0baa6mr437460ljg.4.1681810717565;
        Tue, 18 Apr 2023 02:38:37 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id x27-20020a05651c105b00b002a8c2a4fe99sm967813ljm.28.2023.04.18.02.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 02:38:37 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V2 1/3] dt-bindings: net: wireless: qcom,ath11k: allow describing radios
Date:   Tue, 18 Apr 2023 11:38:20 +0200
Message-Id: <20230418093822.24005-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Qualcomm ath11k chipsets can have up to 3 radios. Each radio may need to
be additionally described by including its MAC or available frequency
ranges.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Fix dt_binding_check (add address + size cells & reg)
---
 .../bindings/net/wireless/qcom,ath11k.yaml    | 36 +++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
index 7d5f982a3d09..6a03638d20f1 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
@@ -78,6 +78,34 @@ properties:
     items:
       - const: wlan-smp2p-out
 
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+patternProperties:
+  "^radio@[0-2]$":
+    type: object
+
+    allOf:
+      - $ref: ieee80211.yaml#
+
+    properties:
+      reg:
+        maxItems: 1
+        description: Radio index
+
+      nvmem-cells:
+        items:
+          - description: NVMEM cell with the MAC address
+
+      nvmem-cell-names:
+        items:
+          - const: mac-address
+
+    unevaluatedProperties: false
+
 required:
   - compatible
   - reg
@@ -378,6 +406,14 @@ examples:
                           "wbm2host-tx-completions-ring1",
                           "tcl2host-status-ring";
         qcom,rproc = <&q6v5_wcss>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        radio@0 {
+            reg = <0x0>;
+            nvmem-cells = <&mac>;
+            nvmem-cell-names = "mac-address";
+        };
     };
 
   - |
-- 
2.34.1

