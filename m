Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878446E2BAF
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 23:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjDNVYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 17:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjDNVYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 17:24:08 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3318992;
        Fri, 14 Apr 2023 14:24:07 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id 2adb3069b0e04-4ec8149907aso59172e87.1;
        Fri, 14 Apr 2023 14:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681507445; x=1684099445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gDb9suLeMmDXYkFPInhtMzdY2pA7Y5KvvTt2BcPxE3I=;
        b=awJPcKfBAXLyWGxTwZm6y9UX+aY2BzjtCmOBus1CqQSkyNeQmmz8nRUGk+jPEazoAI
         g3KuRBvU5rrAsXmDGBmFuO9pSpLWu3Sm03rSo3UPUmfIHIJnSUU9y3hshLAkfUbvumH2
         OWt2PigY/fd2XyBxf/0M6sj9sTVe4GW/XeE3/t94C+fWs7OuF0p5XScS7R0L+m+88Du6
         o9mRM59+CUVTQlvxmZ9f4Z7KQ5H3s7UuCcHHqOiX5AXt4MnR7vRWX232seX7WMKZpxQJ
         dF8ddCCxGe0MT0L7YRZjfTzeBU+wM1JXNBSLC9ih/4ZSbUeekZwq8JsBZorCJrdqXvaK
         fImg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681507445; x=1684099445;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gDb9suLeMmDXYkFPInhtMzdY2pA7Y5KvvTt2BcPxE3I=;
        b=LDpn4cFnSqjlrAHIdEgddpfojU6CZQabXnNdXqRXbBcipvX5VjDKw/2KOiZN8zPou1
         oTTA5A2Nmb26KuNevkGINZO1mOBBkGvYlNw+8bIN4OWzLeFlDwUJq8VrHwpbuu3/RlNy
         honJQPUxF0IbYhRD73/MVSfi2ZB+H9X3r+tfw+OUrEPe0pDyNVc7xmFcf0SFtDdIUGLL
         Pw35f0o7iBrOPnAyLgNqhydnEFf2qOOSjnkcbLUwKxn9uDzHOn7Ky7+5WW1OH4nwMqTS
         ksBjv4dFPrvGQ3QmRSK0+CE33pyQBbKURHykHqnEd+DwSjPL8SY4CSyShzEY8ZwYHtPL
         HRVw==
X-Gm-Message-State: AAQBX9fnsv2ALfv91+sTgrSfXGFQV1KMWnNkwVxThfLCBy4ukITFdVCX
        QGU1P8tW2bnRVASvnS6rt1U=
X-Google-Smtp-Source: AKy350ar4o6C12qHdo/3lHnjJ1p/y0xMDLyWJ0mQBOVvayVlRK4Gx9xII2Txxl0wFlnvqyYKcHOAxA==
X-Received: by 2002:ac2:554a:0:b0:4ec:89d3:a8ae with SMTP id l10-20020ac2554a000000b004ec89d3a8aemr60754lfk.47.1681507445270;
        Fri, 14 Apr 2023 14:24:05 -0700 (PDT)
Received: from localhost.lan (031011218106.poznan.vectranet.pl. [31.11.218.106])
        by smtp.gmail.com with ESMTPSA id m11-20020a056512014b00b004ecad67a925sm961263lfo.66.2023.04.14.14.24.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 14:24:04 -0700 (PDT)
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
Subject: [PATCH 1/3] dt-bindings: net: wireless: qcom,ath11k: allow describing radios
Date:   Fri, 14 Apr 2023 23:23:54 +0200
Message-Id: <20230414212356.9326-1-zajec5@gmail.com>
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
 .../bindings/net/wireless/qcom,ath11k.yaml    | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
index 7d5f982a3d09..ed660d563e09 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
@@ -78,6 +78,24 @@ properties:
     items:
       - const: wlan-smp2p-out
 
+patternProperties:
+  "^radio@[0-2]$":
+    type: object
+
+    allOf:
+      - $ref: ieee80211.yaml#
+
+    properties:
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
@@ -378,6 +396,14 @@ examples:
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

