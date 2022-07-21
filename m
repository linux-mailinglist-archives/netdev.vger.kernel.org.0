Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B729557CF26
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiGUPdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbiGUPcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:32:43 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4C37FE79
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:21 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a13so2082153ljr.11
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qkcak79PKqus0FBcBxREwIPQ11TDFoKGG7oCkfoXPQc=;
        b=SwxDA2lsFKhk6eufWqim1Ro7JRbs5otwloShXKdIpq6ZcJReMBAY58gN0E7UQp6NHa
         wSI10aoScdzw8YSJQKeSc8ZiJ2/jQrOCKox3W9A7U/I4/PTgvHSf9xW7a1onx8EY9iYk
         BwZQ4PSquN8zdyaSiAFB/pFTprslWTyuIlKIe7mpnyuqWJ+aqoU9wNkMOSOkuizT6zdW
         8Ju7sAzettoIlO1AWlALjN59qJamLNafzIFzH9m8ccBNUht5Z2U3T63oAK2mFdYRALZa
         LdJNeykJiUPFRDhNj+y5tpsvd0/5F8ceDQgABQr50RMi820tS3INbLiOe9iCmBOrhtxQ
         /Hww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qkcak79PKqus0FBcBxREwIPQ11TDFoKGG7oCkfoXPQc=;
        b=j3fzG4OHHACQk4N9jA7iyQKKCdkOIiboq5WV6zUbzLrqY7wBtrP5dXhpu1NfmEooy9
         ge71f0rY3WbanCZsxhlkSxIPhhLMmCFL7rrxFuAJmJRckxvrkw7ccvlCS8+3D9e//XH6
         tQVvlrrjdVuQODu1ECrKkQRjXLq6S3/+6EWJApQyQJD1xneqDm4NGbMDrmlrGk2qSBW/
         +UxTSVVyl3LPUVVYqqElxrIwXxpKCwaOlo38RP81JS2QNawqesNdBocF0+eEX2kluwpU
         NMRy7IcVgh+UNGpFXjd1p+ObByg4C2+gf21GB8loQrvew2d2Xk87ADVer5fTlP0ZkCcO
         f7Gw==
X-Gm-Message-State: AJIora+krMJiGo7AVGF5YCCbWccLZQ8o0/RY1IOaR3NGsy256eqZCvlL
        0PSt/ROSGmLLX8CYaXwjoIcXHA==
X-Google-Smtp-Source: AGRyM1t5FpFk3c1ZpM6yYyF3OrMRK1RSMfVVWmGiA4wJJR3dTOcfJAhsvvr1fmUCOx5XIdCoKvqclQ==
X-Received: by 2002:a2e:b947:0:b0:25d:d6f6:adaf with SMTP id 7-20020a2eb947000000b0025dd6f6adafmr3741489ljs.230.1658417539757;
        Thu, 21 Jul 2022 08:32:19 -0700 (PDT)
Received: from krzk-bin.. (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id a27-20020ac25e7b000000b0048a2995772asm504604lfr.73.2022.07.21.08.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:32:19 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Markuss Broks <markuss.broks@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Marcelo Schmitt <marcelo.schmitt1@gmail.com>,
        Tomislav Denis <tomislav.denis@avl.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Nishant Malpani <nish.malpani25@gmail.com>,
        Dragos Bogdan <dragos.bogdan@analog.com>,
        Nuno Sa <nuno.sa@analog.com>,
        Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Marek Belisko <marek@goldelico.com>,
        "H. Nikolaus Schaller" <hns@goldelico.com>,
        Christian Eggers <ceggers@arri.de>,
        Beniamin Bia <beniamin.bia@analog.com>,
        Stefan Popa <stefan.popa@analog.com>,
        Oskar Andero <oskar.andero@gmail.com>,
        =?UTF-8?q?M=C3=A5rten=20Lindahl?= <martenli@axis.com>,
        Dan Murphy <dmurphy@ti.com>, Sean Nyekjaer <sean@geanix.com>,
        Cristian Pop <cristian.pop@analog.com>,
        Lukas Wunner <lukas@wunner.de>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Matheus Tavares <matheus.bernardino@usp.br>,
        Sankar Velliangiri <navin@linumiz.com>,
        Lubomir Rintel <lkundrak@v3.sk>,
        Stefan Wahren <stefan.wahren@in-tech.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-fbdev@vger.kernel.org, netdev@vger.kernel.org,
        linux-spi@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5/6] dt-bindings: net: explicitly list SPI CPHA and CPOL
Date:   Thu, 21 Jul 2022 17:31:54 +0200
Message-Id: <20220721153155.245336-6-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220721153155.245336-1-krzysztof.kozlowski@linaro.org>
References: <20220721153155.245336-1-krzysztof.kozlowski@linaro.org>
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

The spi-cpha and spi-cpol properties are device specific and should be
accepted only if device really needs them.  Explicitly list them in
device bindings in preparation of their removal from generic
spi-peripheral-props.yaml schema.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/net/nfc/marvell,nci.yaml     | 12 ++++++++++--
 .../devicetree/bindings/net/vertexcom-mse102x.yaml   | 12 +++++++++---
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
index 1bcaf6ba822c..00b3918a9bf2 100644
--- a/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
+++ b/Documentation/devicetree/bindings/net/nfc/marvell,nci.yaml
@@ -56,8 +56,16 @@ properties:
     description: |
       For UART type of connection. Specifies that the chip is using RTS/CTS.
 
-  spi-cpha: true
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
+
   spi-max-frequency: true
 
 required:
diff --git a/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
index 8156a9aeb589..9dc1609f6d06 100644
--- a/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
+++ b/Documentation/devicetree/bindings/net/vertexcom-mse102x.yaml
@@ -34,9 +34,15 @@ properties:
   interrupts:
     maxItems: 1
 
-  spi-cpha: true
-
-  spi-cpol: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
+
+  spi-cpol:
+    type: boolean
+    description:
+      The device requires inverse clock polarity (CPOL) mode.
 
   spi-max-frequency:
     minimum: 6000000
-- 
2.34.1

