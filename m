Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E836289AF
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237340AbiKNTrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237315AbiKNTro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:47:44 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3671D66C;
        Mon, 14 Nov 2022 11:47:42 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id y14so30929888ejd.9;
        Mon, 14 Nov 2022 11:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsR5K/bfZiGAjhy1k2auvOyy8yyn/K6mNHQVJ8yfpDI=;
        b=ZeQHAWrvk3y4OclcphYl2giFJsoB9YAD4mjThrT8JkPhz4G8goD5/Dy1B+Ds5OgasX
         ySY+ojVK7gYHpTWr8zCYt4q7tTt88m/dELqESRbHDj3i1EvkndQOd7C2F4QbVl9ygQDl
         q6M2Gd9LNSmRiOb/shmmL6BvEXhcolVPcOQZQv/ox/ORc/JsObNQrXQT6iWGSbzbP5vW
         QtQhJp8eIJQgjdmFnlCRbPvzJM1iynUMP36EhTOWQxobZD27iMwUhlZ17XGv5zhgztzJ
         3axxxNGXT4o947lYaWRiBoYDnVOlWqER4Oak+hIE4OL42uMLGbyBBoPjZPd8AG/F8+uj
         i2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tsR5K/bfZiGAjhy1k2auvOyy8yyn/K6mNHQVJ8yfpDI=;
        b=Rfweu0tpeQ5jkxXobaRT/3QkX7ASk0zwetBrGO+ggyWaQ1VoKTfBvHgdZGRxKoJ5lb
         iHrjqBOyGeEpqG0xJZsMqcDKzCawGawfhIsNtkhPpKScajVMeyzDPPnkhPENLWdEq3Ke
         BkgoUZ+ZzkW8gF5Kti+H9nLxiCZiL7TD0+YypKlo1mLBNXVGK+QO/vYiMNtVB801zRuU
         8ybp6LdhYX003J+BVljHTtkf69QyHgab98duJXMpuIx3/Yq9PkEdNX5+KR1+9kjHYHUq
         MF05eVHGNbmaS1O5Ivarq0o1GdxZ5vVGeCFnyw9zipSimfDav24DKhngqzXYfvzTDZsL
         53rg==
X-Gm-Message-State: ANoB5pmLTvmDGcbTZuZuPfUxol43TBxETihctCFHBM1hZF1dXXWqy2VQ
        9aWuP298CSjzdSG7zaLpbWs=
X-Google-Smtp-Source: AA0mqf6aybkpApXzIZ1nIwI3qDvVSWJCngobhH2a12ALXf2opCgKJrOW7XNMxrvJOtEfJQlOOCEP0g==
X-Received: by 2002:a17:906:970e:b0:7ad:ccae:a30d with SMTP id k14-20020a170906970e00b007adccaea30dmr11946651ejx.704.1668455260640;
        Mon, 14 Nov 2022 11:47:40 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id k8-20020a17090632c800b007a62215eb4esm4666405ejk.16.2022.11.14.11.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:47:40 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH v2 3/5] dt-bindings: net: ipq4019-mdio: require and validate clocks
Date:   Mon, 14 Nov 2022 20:47:32 +0100
Message-Id: <20221114194734.3287854-3-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114194734.3287854-1-robimarko@gmail.com>
References: <20221114194734.3287854-1-robimarko@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we can match the platforms requiring clocks by compatible start
using those to allow clocks per compatible and make them required.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
Changes in v2:
* Keep clocks under properties and disallow per compatible
---
 .../bindings/net/qcom,ipq4019-mdio.yaml       | 27 ++++++++++++++-----
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index f4918c9e6fd2..72561e3aeee3 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -9,9 +9,6 @@ title: Qualcomm IPQ40xx MDIO Controller
 maintainers:
   - Robert Marko <robert.marko@sartura.hr>
 
-allOf:
-  - $ref: "mdio.yaml#"
-
 properties:
   compatible:
     oneOf:
@@ -40,10 +37,8 @@ properties:
       address range is only required by the platform IPQ50xx.
 
   clocks:
-    maxItems: 1
-    description: |
-      MDIO clock source frequency fixed to 100MHZ, this clock should be specified
-      by the platform IPQ807x, IPQ60xx and IPQ50xx.
+    items:
+      - description: MDIO clock source frequency fixed to 100MHZ
 
 required:
   - compatible
@@ -51,6 +46,24 @@ required:
   - "#address-cells"
   - "#size-cells"
 
+allOf:
+  - $ref: "mdio.yaml#"
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,ipq5018-mdio
+              - qcom,ipq6018-mdio
+              - qcom,ipq8074-mdio
+    then:
+      required:
+        - clocks
+    else:
+      properties:
+        clocks: false
+
 unevaluatedProperties: false
 
 examples:
-- 
2.38.1

