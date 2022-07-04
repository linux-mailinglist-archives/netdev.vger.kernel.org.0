Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0144D5652C3
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 12:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiGDKxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 06:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbiGDKxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 06:53:11 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC5CBE2C;
        Mon,  4 Jul 2022 03:53:10 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u12-20020a05600c210c00b003a02b16d2b8so5420566wml.2;
        Mon, 04 Jul 2022 03:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4weMpjvNiH7V9U3sbXbzJxXZClEc9I2GMKVTP6AA2c0=;
        b=P/c9/IGQEPreCQ0nHotpRmWlzk39e7XMKW9T1rPAbMMpTnQ47CZMILeQACoGFMJqXj
         XqtSTeHGSTDhG21kzL36QiDSkWLlqw0l3u/wHq535AB+7dEIByE6VaRgseGxScnqzu3a
         AynlarYdZFNfiVu9g8fw1POFreKLUKD+tTkT+baijQlbwAMytXb8Ye7LUyNOchS4Yak7
         l7Dwawiw/vOv0Cw+muKgJmPI2Wpx/MONt1B82xSSAXi7euyoPQwEfgHhRun+sLzMIZrJ
         rbR/fcrwD1D+hmje51P59xSsw5xq/0AMNGa/4PlyV12zRbhTchJcOfYVxFgotRPgNINp
         XX1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4weMpjvNiH7V9U3sbXbzJxXZClEc9I2GMKVTP6AA2c0=;
        b=cNKhajcd5udmuBSv1g9UZgfznw79zqfwuBJiA3v3iTm50j9jJBH71LpBlWFdYz9Pjm
         y1hxsfreMuT9MdS2pzkbbvcKhBasOiOCTcDNE0QGKf1BN/Xx4k6wiKe+CFUSnFxOk44t
         bdxdXG2dcT52Pko8MW6hn2k2ZxDviXjFQduEKaQDqxeKB69hqfoz+ERfVgBmg51GiKB2
         w1NYS8fgqFfdIv4TswLqsC5MMgS9cRqfvvdiOOqqI0kKPRmJFWgBDlraPcgkw2Vkgjh3
         W/o1SMpNEOrBX2Pwdf+5n913eJt2qfPv2j2lRkgjFAqgtHdgyS9+VZ2A3H8F7UlaMA8C
         9tBQ==
X-Gm-Message-State: AJIora/H4hsrYhUYvjoXQrQKzOd560YGboJ2MCNb9XlumDtTjGEXafbe
        FSmgoK2sxcTycCFCeCrNFv8vj7e9n8r1dk9x
X-Google-Smtp-Source: AGRyM1v3rotBr0o2IFPa2Oszpyd49EUK6GjimhNUEb5xJaX04pIc3hhz3Bnr2maVLeqLXFi2YAsyXQ==
X-Received: by 2002:a7b:c410:0:b0:3a0:2d7d:732a with SMTP id k16-20020a7bc410000000b003a02d7d732amr32454903wmi.113.1656931989088;
        Mon, 04 Jul 2022 03:53:09 -0700 (PDT)
Received: from localhost (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.gmail.com with ESMTPSA id j31-20020a05600c1c1f00b003a18d352893sm10907140wms.42.2022.07.04.03.53.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jul 2022 03:53:08 -0700 (PDT)
From:   Colin Ian King <colin.i.king@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-amlogic@lists.infradead.org
Subject: [PATCH] dt-bindings: Fix spelling mistakes in documentation yaml files "is is" -> "is"
Date:   Mon,  4 Jul 2022 11:53:07 +0100
Message-Id: <20220704105307.552247-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are several occurrances of duplicated words "is" on the documentation
yaml files. Fix these.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml   | 2 +-
 Documentation/devicetree/bindings/mfd/ti,lp87524-q1.yaml       | 2 +-
 Documentation/devicetree/bindings/mfd/ti,lp87561-q1.yaml       | 2 +-
 Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml       | 2 +-
 Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml b/Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml
index a4b4452afc1d..a04882e101f3 100644
--- a/Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml
+++ b/Documentation/devicetree/bindings/arm/arm,vexpress-juno.yaml
@@ -139,7 +139,7 @@ patternProperties:
       the connection between the motherboard and any tiles. Sometimes the
       compatible is placed directly under this node, sometimes it is placed
       in a subnode named "motherboard-bus". Sometimes the compatible includes
-      "arm,vexpress,v2?-p1" sometimes (on software models) is is just
+      "arm,vexpress,v2?-p1" sometimes (on software models) is just
       "simple-bus". If the compatible is placed in the "motherboard-bus" node,
       it is stricter and always has two compatibles.
     type: object
diff --git a/Documentation/devicetree/bindings/mfd/ti,lp87524-q1.yaml b/Documentation/devicetree/bindings/mfd/ti,lp87524-q1.yaml
index f6cac4b1079c..3549a32452ec 100644
--- a/Documentation/devicetree/bindings/mfd/ti,lp87524-q1.yaml
+++ b/Documentation/devicetree/bindings/mfd/ti,lp87524-q1.yaml
@@ -26,7 +26,7 @@ properties:
   '#gpio-cells':
     description:
       The first cell is the pin number.
-      The second cell is is used to specify flags.
+      The second cell is used to specify flags.
       See ../gpio/gpio.txt for more information.
     const: 2
 
diff --git a/Documentation/devicetree/bindings/mfd/ti,lp87561-q1.yaml b/Documentation/devicetree/bindings/mfd/ti,lp87561-q1.yaml
index dc5a29b5ef7d..43a3f7ccaf36 100644
--- a/Documentation/devicetree/bindings/mfd/ti,lp87561-q1.yaml
+++ b/Documentation/devicetree/bindings/mfd/ti,lp87561-q1.yaml
@@ -26,7 +26,7 @@ properties:
   '#gpio-cells':
     description:
       The first cell is the pin number.
-      The second cell is is used to specify flags.
+      The second cell is used to specify flags.
       See ../gpio/gpio.txt for more information.
     const: 2
 
diff --git a/Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml b/Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml
index 012d25111054..373c4f89c4ea 100644
--- a/Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml
+++ b/Documentation/devicetree/bindings/mfd/ti,lp87565-q1.yaml
@@ -28,7 +28,7 @@ properties:
   '#gpio-cells':
     description:
       The first cell is the pin number.
-      The second cell is is used to specify flags.
+      The second cell is used to specify flags.
       See ../gpio/gpio.txt for more information.
     const: 2
 
diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 608e1d62bed5..3eb0513d824c 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -149,7 +149,7 @@ properties:
       - description:
           The first register range should be the one of the DWMAC controller
       - description:
-          The second range is is for the Amlogic specific configuration
+          The second range is for the Amlogic specific configuration
           (for example the PRG_ETHERNET register range on Meson8b and newer)
 
 required:
-- 
2.35.3

