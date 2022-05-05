Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42C351C1A2
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 15:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345466AbiEEN7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 09:59:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380347AbiEEN7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 09:59:09 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A5F1834B;
        Thu,  5 May 2022 06:55:29 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i19so8873989eja.11;
        Thu, 05 May 2022 06:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ahkARIN+8V3yBAvDKNOhMu072AYtqbFU/lpjoQxJ3Ks=;
        b=gyhScaHs263fn2FMoFIaeIpmB1OR6lK4hIvTWKMnoqsCeTC4u7f5XlTXbu1qDGT80A
         7fcgacj4FhqraB8kY6V759+NYx4cX2hkWcGvb32qC9sVoAGgT0c4dRd6y7e+IOJSFnNl
         PHH4QW2DAEqWANTXLaKCgcW6G7rVVLpcz1Y9yRu2BHdODLKSj7bnvTA+PdIgmneIxKQn
         oC0YfGZpHfaQqXIvYNm6WzICki7T1sEtt3tFgVSroKZ0jNV5NchrvnoWG+0aocWXlN2T
         BarZsb5ZxvXwki1O9/qbU1o/HM708vc56H6LtIseoYFnr1ECso98W2oRXzZ4Y6JD/N+5
         dK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ahkARIN+8V3yBAvDKNOhMu072AYtqbFU/lpjoQxJ3Ks=;
        b=D4u2Bx7nQGaPPfrDj3pV00Lmfdiw/k60rB5PoCdnO62pcg9svUDiMyxJO5KZCHoziD
         kXTcAf0PuHML6/rerD111Bls12pBQEKXC14WCH+nswz4PtiwMrKXwEAHESV03Oe1oncC
         1JbxO7aVcqoGM0uQLFtHYqU0fqKzPHHEqDvsixxwzmXIsLAimxBbe+1UycAzlxxXTH3W
         N58PCQQCUM4fOcokmNsoqL6d/ES3tnc+XiHp2ahG5d67nFPG97NzDtpkXtxBuwEnjjZC
         W5NdspzxS/ccCYLmpUtedlNoF8UiZwx+S2cMW13ztJrynCUtLZEeSES+0l6EMrAgfOtb
         W3Ng==
X-Gm-Message-State: AOAM530qkHmiNA+u5cJAL+qMkR0iJ+fele4w1jWwkh8va5ml/G+StHDh
        IJ6zVwMCtErq0SCwjfJKiq8=
X-Google-Smtp-Source: ABdhPJzi3vKiAPWHMT0W9f/YUPiDcbp8oCkahrkdy1du7Mdl6X0NgMbhUvQRlzLOh3T78kfW8HG0HA==
X-Received: by 2002:a17:906:2646:b0:6d5:d889:c92b with SMTP id i6-20020a170906264600b006d5d889c92bmr27143703ejc.696.1651758928315;
        Thu, 05 May 2022 06:55:28 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e15-20020a50e44f000000b0042617ba63c7sm877949edm.81.2022.05.05.06.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 06:55:27 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, ansuelsmth@gmail.com,
        andrew@lunn.ch, vivien.didelot@gmail.com,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        John Crispin <john@phrozen.org>, linux-doc@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH RESEND 2/5] dt-bindings: net: allow Ethernet devices as LED triggers
Date:   Thu,  5 May 2022 15:55:09 +0200
Message-Id: <20220505135512.3486-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220505135512.3486-1-zajec5@gmail.com>
References: <20220505135512.3486-1-zajec5@gmail.com>
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

This allows specifying Ethernet interfaces and switch ports as triggers
for LEDs activity.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 4f15463611f8..ebeb4446d253 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -232,6 +232,9 @@ properties:
           required:
             - speed
 
+allOf:
+  - $ref: /schemas/leds/trigger-source.yaml
+
 additionalProperties: true
 
 ...
-- 
2.34.1

