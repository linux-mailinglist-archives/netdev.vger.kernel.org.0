Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9EC62FD76
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242129AbiKRS7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242708AbiKRSvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:51:07 -0500
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED038FB34;
        Fri, 18 Nov 2022 10:51:06 -0800 (PST)
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-13bd2aea61bso7025518fac.0;
        Fri, 18 Nov 2022 10:51:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uuUisE6muQ2a8H+UFn8jxcAB9pjTtgR2YYMbLsdm6pE=;
        b=q6/krNcxLDhH+PPOpUwZYkvchYDTm7eWhaX0eYBTljiGoDHn0PWUmB15+HkCXDS/TS
         ORQ0RX0HArB2TQdipzBQQrTK8dtUKDS30UrOWMEGef6kyqqaXaaqzzUGgv5AKuUzmLHD
         j/eCXjRxU5x1XxhcTFEIeMSEQd2XeWxOXvyGM68heOvWeiaWg5m9pWadHG+DrJsmNRa4
         cA06nKwzY0zXxxpfLapAZvinaNOHF3uED9RX5VV6yQH0XUVBdyLZsUJ46sh7jmc5VpqV
         Squpj9NHDcO9zBMxvnYporvZQI5Kr5ctKGLrGbcgHcyZEJ+QLKk8MOY6082fdiaSptxF
         LwyA==
X-Gm-Message-State: ANoB5pkOavWlPDXNgkceQ1saNAtWxPgS5JVzIZ8lefo6uBTURG9CXIe+
        uOWjqo/O6SSYkrB0Kl8gAA==
X-Google-Smtp-Source: AA0mqf6bf2HY2HW6lGRmiXPWhAMZr4bJ2EvTFxkJh7esTNkKUL2fjgko3ZlpdrkN1JGLcX4aBxGgag==
X-Received: by 2002:a05:6870:bf0b:b0:136:66d0:b853 with SMTP id qh11-20020a056870bf0b00b0013666d0b853mr4647233oab.161.1668797465890;
        Fri, 18 Nov 2022 10:51:05 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id i25-20020a056871029900b0010c727a3c79sm2408247oae.26.2022.11.18.10.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 10:51:05 -0800 (PST)
Received: (nullmailer pid 856961 invoked by uid 1000);
        Fri, 18 Nov 2022 18:50:54 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-media@vger.kernel.org, Vinod Koul <vkoul@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-amlogic@lists.infradead.org, linux-watchdog@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-rtc@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>, netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-mmc@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-phy@lists.infradead.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-pci@vger.kernel.org, devicetree@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-4-3f025599b968@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org> 
 <20221117-b4-amlogic-bindings-convert-v1-4-3f025599b968@linaro.org>
Message-Id: <166879731312.851419.16320390143824776926.robh@kernel.org>
Subject: Re: [PATCH 04/12] dt-bindings: watchdog: convert meson-wdt.txt to dt-schema
Date:   Fri, 18 Nov 2022 12:50:54 -0600
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 18 Nov 2022 15:33:30 +0100, Neil Armstrong wrote:
> Convert the Amlogic Meson6 SoCs Watchdog timer bindings to dt-schema.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../bindings/watchdog/amlogic,meson6-wdt.yaml      | 39 ++++++++++++++++++++++
>  .../devicetree/bindings/watchdog/meson-wdt.txt     | 21 ------------
>  2 files changed, 39 insertions(+), 21 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20221117-b4-amlogic-bindings-convert-v1-4-3f025599b968@linaro.org


watchdog@9900: compatible: ['amlogic,meson8m2-wdt', 'amlogic,meson8b-wdt'] is too long
	arch/arm/boot/dts/meson8m2-mxiii-plus.dtb

watchdog@9900: Unevaluated properties are not allowed ('compatible', 'interrupts' were unexpected)
	arch/arm/boot/dts/meson8m2-mxiii-plus.dtb

watchdog@9900: Unevaluated properties are not allowed ('interrupts' was unexpected)
	arch/arm/boot/dts/meson6-atv1200.dtb
	arch/arm/boot/dts/meson8b-ec100.dtb
	arch/arm/boot/dts/meson8b-mxq.dtb
	arch/arm/boot/dts/meson8b-odroidc1.dtb
	arch/arm/boot/dts/meson8-minix-neo-x8.dtb

