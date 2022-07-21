Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32CFB57CF2A
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiGUPdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:33:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbiGUPco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:32:44 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060F180F6C
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:22 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a23so945106lfm.10
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zSAEKIvtye5jS07a7SCopVWWSkQdxtLbeG/Qb/jLxOk=;
        b=Rvdze6Ay/jzmEJuWKHz6d8GONFosd5gpWdYWi/JRN1OjKN2i1Jk8wdvsduQ4H8k8JL
         UdwErw84gZ4T/ZzSfJ5NynfzzrkFsWvRk7AQLb9rYAPas3wqT0gUiMpE9V1wXzOAsmHF
         7EXEizMpX5vmdqwD6YyQM96dzP5GLBGnrBDS1/XmKVJk143W6ioev/IgPkh1VLk2Wzvz
         /oNmvFAOYhtfbU0Cy1XasqHa9Dek8OUzjDtO10bNzcSElFT/9iZWpMTF0hdbY2dMa4En
         sAR44Y7lA86ATER7P2GVmQOnk/BllCZ1FFLpXhxAkOtjuJVpIUurtPbYYw/BlC/KIOGq
         IdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zSAEKIvtye5jS07a7SCopVWWSkQdxtLbeG/Qb/jLxOk=;
        b=pP+FeyEJUagFJE9EM8zDrJrJitssq+LWH6l2dljUrdY5B9MeqClCUYXEsMMrE2VMZY
         jlhT83d83LXvNbPOQtSHCxUd27MJDO78ATNNdqTm/qUUShyXgJpo8sFRCNwjDm+rBHZB
         634CwvflVlQily2983gCVXTrho5TzvzBofZA+ruYCD9PPASAJdQ3+BpUQ+GpGH8sNrqr
         e8ZyWNJHF/LdK40oefWx26juiDnFJkRVtlxj2cyS/PjhDlufhUZtZT9BynOIUDBCfp13
         cT2lyXgnoOM9Sp0+t28CTwz5+sD0u8NQw9Ln0oOkAKNlNzvG7G9BLeI8RK/2xbRCwAah
         R9RQ==
X-Gm-Message-State: AJIora/iwiftNU9vcokzPt3zYcWPB0jdi+tGyOLf44uYX2aOa4E6s5e3
        ItxhFEAq+wJ/hWX4nuXNfHlHNQ==
X-Google-Smtp-Source: AGRyM1t1GsMxf5C4K7kyBGZWAKDxo4V4V9DKDdnTuEaHQtbYw9EAmvVhKT4eVr1iIzVSWR6scvBZrQ==
X-Received: by 2002:ac2:47f6:0:b0:488:b649:9f77 with SMTP id b22-20020ac247f6000000b00488b6499f77mr24197373lfp.559.1658417542316;
        Thu, 21 Jul 2022 08:32:22 -0700 (PDT)
Received: from krzk-bin.. (89-162-31-138.fiber.signal.no. [89.162.31.138])
        by smtp.gmail.com with ESMTPSA id a27-20020ac25e7b000000b0048a2995772asm504604lfr.73.2022.07.21.08.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:32:21 -0700 (PDT)
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
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 6/6] spi: dt-bindings: drop CPHA and CPOL from common properties
Date:   Thu, 21 Jul 2022 17:31:55 +0200
Message-Id: <20220721153155.245336-7-krzysztof.kozlowski@linaro.org>
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
accepted only if device really needs them.  Drop them from common
spi-peripheral-props.yaml schema (each device schema will list them
instead).

Suggested-by: Jonathan Cameron <jic23@kernel.org>
Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 .../devicetree/bindings/spi/spi-peripheral-props.yaml  | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml b/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml
index 9d63a58b46a0..ce048e782e80 100644
--- a/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml
+++ b/Documentation/devicetree/bindings/spi/spi-peripheral-props.yaml
@@ -34,16 +34,6 @@ properties:
     description:
       The device requires 3-wire mode.
 
-  spi-cpha:
-    $ref: /schemas/types.yaml#/definitions/flag
-    description:
-      The device requires shifted clock phase (CPHA) mode.
-
-  spi-cpol:
-    $ref: /schemas/types.yaml#/definitions/flag
-    description:
-      The device requires inverse clock polarity (CPOL) mode.
-
   spi-cs-high:
     $ref: /schemas/types.yaml#/definitions/flag
     description:
-- 
2.34.1

