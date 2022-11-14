Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB006289B1
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 20:47:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbiKNTrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 14:47:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237317AbiKNTrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 14:47:45 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6799FCE7;
        Mon, 14 Nov 2022 11:47:43 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id kt23so30939200ejc.7;
        Mon, 14 Nov 2022 11:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glNDNFAfAsfXidR8J1WHl6noXHXVVdrjbyk1bVQ214c=;
        b=CqkzHSGTH6uK2lOWBNvwyNbDC4h+ic5Ll+AESO6gP6iTJpbNd6dZXC/6zrDf47U+id
         vVVCVszg9LBYlv1xLJ027liR+VjwwAm8S8rJa5qRsPONBsphs12vSJFIfr60J65Rg8f7
         6ngfHGfwzmqT/zPd7/Fv9Z2QNr+ydulRB0qDq6kVPt36BpFVY5fWt+LM5VS5Atlq6yTs
         Ykv5lcBYTFVlQ7FQfaUUkd3cS7BcEusrnxgqYFR2Fi6fOQg12wEyxXkdta3Kfak5recc
         4XsvUzA8b5csu1RGe+DFwuGtPQbEPb2dTbpV3cQKM+eYsiOY7fWZbOe6CvgaquXARtZ0
         mWNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=glNDNFAfAsfXidR8J1WHl6noXHXVVdrjbyk1bVQ214c=;
        b=zONTxmouTOrcLqH3ndNliB7/LHY9gYSbL5Ik0YmivbwIc5cyIa4RmGbFiyXw/5L2DB
         zkpcj5rr97V6D8dMdrDJeH88hP0O4ucEfAQfP9TXkzm5yvuL3weQnormqV5y9vvgDPqM
         aCQdPgqhGB2aT35PPbxgC/9bNI3IIvJv/ShZNk7PHPgtUQg89AEcKEUbZTb0bVP7lJnY
         VwtnoDogcWu5hoVW41Ka+9HPxKh4ezTyX+VleAQABxh0AzoB3Bsm9Qv6AmH6B4QulJmd
         0CMUXyhzSzIef524b0xQtAtabsefufN99nfahICGNmGDqfmMx74/NqtCgNHIEAN95tBY
         PI+w==
X-Gm-Message-State: ANoB5pkZEF8p4ZnpavkwGvYb+NccyUrMKmF6sh7JQv5mkAQ0Ui5/upbF
        2KxyGLuULv7FRm0IDPQrOEA=
X-Google-Smtp-Source: AA0mqf6Rtlng3QP5iz13QOjL4kXYR0UZ30Nt1vtYZyACQBuiufJsZ/9wHyV12hwwtKkOXfb6K5WExA==
X-Received: by 2002:a17:907:9a85:b0:7ad:b45c:dbca with SMTP id km5-20020a1709079a8500b007adb45cdbcamr11637004ejc.388.1668455262224;
        Mon, 14 Nov 2022 11:47:42 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id k8-20020a17090632c800b007a62215eb4esm4666405ejk.16.2022.11.14.11.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 11:47:41 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH v2 4/5] dt-bindings: net: ipq4019-mdio: document required clock-names
Date:   Mon, 14 Nov 2022 20:47:33 +0100
Message-Id: <20221114194734.3287854-4-robimarko@gmail.com>
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

IPQ5018, IPQ6018 and IPQ8074 require clock-names to be set as driver is
requesting the clock based on it and not index, so document that and make
it required for the listed SoC-s.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
Changes in v2:
* Define clock-names under properties and disallow it per compatible
like clocks
---
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml          | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index 72561e3aeee3..7631ecc8fd01 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -40,6 +40,10 @@ properties:
     items:
       - description: MDIO clock source frequency fixed to 100MHZ
 
+  clock-names:
+    items:
+      - const: gcc_mdio_ahb_clk
+
 required:
   - compatible
   - reg
@@ -60,9 +64,11 @@ allOf:
     then:
       required:
         - clocks
+        - clock-names
     else:
       properties:
         clocks: false
+        clock-names: false
 
 unevaluatedProperties: false
 
-- 
2.38.1

