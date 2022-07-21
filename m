Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6169957CF22
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiGUPdB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiGUPck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:32:40 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282648722E
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:19 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id z25so3387776lfr.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KpbhzspuygFwG8vSA8m7O2wzJD0Js2bLL2ZwSFQUUh8=;
        b=Wb0rgx/+JD0lUO5OIbB13AO2kBj5vUIgEXqqA/A7qkzZbSkf6H5TybPzAc3jLDRWZz
         De4WQJnjI8sBvx/GegpfA1NIr8rFGrK6Aly5uAe3MV5JfBncMtME2wikDcSvchswZz2H
         bGSdBZ3Y/eaVXJx/oekM+nPU6YMkzGlhvS+Y09AUAaM7BodBFWsZtMuaEw5YVtimcJIS
         12YbKGbYvGnx4Nl49xdzjrX7XOE0OH5uVQJ28w4sEYFoPpSaJbKMOXPTslhG0MHUDNR2
         RTtCrW1myAJqWrWmhMA5zngFS4b5D3FkPX1I6gujjeNsueoKwdJpWBTxFNTF4BpJE2bo
         8+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KpbhzspuygFwG8vSA8m7O2wzJD0Js2bLL2ZwSFQUUh8=;
        b=A5vS8taEEjtgyVHpgN8A+e7UjsyGbbCVfTlfTfZqDaGbXMb7Z4mxIeN4vjinD8ISR7
         9UWqlTeTPUYM5snVZmSXkS8oy4sCOLMm5c/WimyAo4d4axdj4AztpQMbYxTYoEkKxNMJ
         XEpCh+KoxO0f2bZA6aN63C45TMT/u72PKh/QaFh6cOTjQGYu8INrCyw+sbfIagbKPaLS
         yt5Gy9cDobKv6lNS8eJX2y0RHSr742qMh61AoeThf0lnwADdvfUcxwlH70SR1+aQgeys
         m7cEVoVWZcgFUoOvgSgc4I/QoDnzcoAxN919adX8BZ/rC+zw9pKp9ClmPD8a3eJaAe5h
         bJbQ==
X-Gm-Message-State: AJIora89EkFk369w5C6Ol3jKgDuggMhSBM9C04WOyZkvpfQjWHzPHQmL
        2042Q7aR81Xlt5HTj/kv83JnWA==
X-Google-Smtp-Source: AGRyM1ubWL7w8E7CRaphPTSvA0k3fiWFSqprLYOLH+JjbjSiG740pSD/ln4Nfs04hmWe6t26JztkWg==
X-Received: by 2002:a05:6512:2809:b0:489:ff8e:44f2 with SMTP id cf9-20020a056512280900b00489ff8e44f2mr23393295lfb.70.1658417537183;
        Thu, 21 Jul 2022 08:32:17 -0700 (PDT)
Received: from krzk-bin.. (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id a27-20020ac25e7b000000b0048a2995772asm504604lfr.73.2022.07.21.08.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:32:16 -0700 (PDT)
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
Subject: [PATCH 4/6] dt-bindings: misc: explicitly list SPI CPHA and CPOL
Date:   Thu, 21 Jul 2022 17:31:53 +0200
Message-Id: <20220721153155.245336-5-krzysztof.kozlowski@linaro.org>
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
 Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml b/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
index b3c45c046ba5..a198848283d2 100644
--- a/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
+++ b/Documentation/devicetree/bindings/misc/olpc,xo1.75-ec.yaml
@@ -28,7 +28,10 @@ properties:
     description: GPIO uspecifier of the CMD pin
     maxItems: 1
 
-  spi-cpha: true
+  spi-cpha:
+    type: boolean
+    description:
+      The device requires shifted clock phase (CPHA) mode.
 
 required:
   - compatible
-- 
2.34.1

