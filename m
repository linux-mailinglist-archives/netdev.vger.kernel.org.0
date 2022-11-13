Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EAB6271BE
	for <lists+netdev@lfdr.de>; Sun, 13 Nov 2022 19:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiKMSrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 13:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233909AbiKMSre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 13:47:34 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D0EFCED;
        Sun, 13 Nov 2022 10:47:33 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id k2so23588401ejr.2;
        Sun, 13 Nov 2022 10:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cF1JXmpvIU3CzjntusQxhImrsMqCHteTbq+Gdn0gF3w=;
        b=VwulM1DxMMZAdPmKaU5pRHcknEnSWhZ+ZS+cm/qhesVu753uIxQqRNTW3WprlBk2Z4
         AUCGknMqRMaS2ptUFyOcpkoQqiKhijCWaNEnUnZc8tFUOeZ7rdvq6eRhHXEEmwQs7Y9+
         9svKmgz38DDhlYcIwXdn7NlI1I9n3XTxiLjFYV+JgLebR0MU6IxGplS26TuikyKB0RsN
         qWuSZKFEeHRu4+268tGLwB5jcPjXBUlajXd5k+k7DB2nA5jXNoLDH4yHXJNZ6P42rhB7
         9Cjc05UV0uwqp3phf/FiQBO69VT7FYlBn7r0v7EpgKFMMYBufXswZTyQvWwonH38cHMP
         oPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cF1JXmpvIU3CzjntusQxhImrsMqCHteTbq+Gdn0gF3w=;
        b=J7lk0Rxs7OW3MgX1nTOcXVF1ObjX+NvMOATt56zDiHn/k4KQNKZnjg6XyiFgOs8Qbs
         wSbZbXgR6oU2WrarJQkRXn6IRbLkV1lpQewPQHUSsnejJhtTaZMf6NJ/pw2A8AZl0yqc
         6hschcrWhnUaI2L2j1OCiD7W6thLCnfJ+JBHnHp2e4sRruYRmVfl497EpVcdZL1zQKH+
         fZ2WKAD+vmi38Ox8NLDYdnNIdG5WreP4uKSoLdyRIOjZhrdNHqOw+h+EzRxu9r8ZWMHf
         eusl5rCdvOW5cNInM6qa2213EGxMD5T6uEz15CJLN08SOC/PGB9lenZtpsN9SZUvfdqk
         BBOA==
X-Gm-Message-State: ANoB5pnpoBxk2W8bfvkNdP1dKdLEbgpWXUjeKm25rBu2tUkdQjwepMd0
        Tjkvdp3p9ap/2Ql2KoU548In9UBd4Bky4g==
X-Google-Smtp-Source: AA0mqf4AOAg99Nr8UQojmJv5ffuuHVE4LG9bwbnrO4f91z2yI6QvjiE3MtOGyX1+pOhT+uDad6iJuA==
X-Received: by 2002:a17:907:2168:b0:78d:48ac:9041 with SMTP id rl8-20020a170907216800b0078d48ac9041mr8107636ejb.361.1668365251410;
        Sun, 13 Nov 2022 10:47:31 -0800 (PST)
Received: from fedora.. (dh207-97-48.xnet.hr. [88.207.97.48])
        by smtp.googlemail.com with ESMTPSA id a2-20020aa7d742000000b004623028c594sm3760050eds.49.2022.11.13.10.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Nov 2022 10:47:30 -0800 (PST)
From:   Robert Marko <robimarko@gmail.com>
To:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Robert Marko <robimarko@gmail.com>
Subject: [PATCH 1/5] dt-bindings: net: ipq4019-mdio: document IPQ6018 compatible
Date:   Sun, 13 Nov 2022 19:47:23 +0100
Message-Id: <20221113184727.44923-1-robimarko@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Document IPQ6018 compatible that is already being used in the DTS along
with the fallback IPQ4019 compatible as driver itself only gets probed
on IPQ4019 and IPQ5018 compatibles.

This is also required in order to specify which platform require clock to
be defined and validate it in schema.

Signed-off-by: Robert Marko <robimarko@gmail.com>
---
 .../devicetree/bindings/net/qcom,ipq4019-mdio.yaml  | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
index ad8b2b41c140..2463c0bad203 100644
--- a/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
+++ b/Documentation/devicetree/bindings/net/qcom,ipq4019-mdio.yaml
@@ -14,9 +14,16 @@ allOf:
 
 properties:
   compatible:
-    enum:
-      - qcom,ipq4019-mdio
-      - qcom,ipq5018-mdio
+    oneOf:
+      - items:
+          - enum:
+              - qcom,ipq4019-mdio
+              - qcom,ipq5018-mdio
+
+      - items:
+          - enum:
+              - qcom,ipq6018-mdio
+          - const: qcom,ipq4019-mdio
 
   "#address-cells":
     const: 1
-- 
2.38.1

