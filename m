Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0A562FD5C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbiKRSvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiKRSu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:50:58 -0500
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D369B8CF11;
        Fri, 18 Nov 2022 10:50:57 -0800 (PST)
Received: by mail-oi1-f172.google.com with SMTP id n186so6294667oih.7;
        Fri, 18 Nov 2022 10:50:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k/ee9MiYM54ZuabkBQ/+PieDZU39cYWg6HtAgSwxpls=;
        b=bEV6fb1eT54bWlkpcyqazB8Z/zxFT0Xp2RwhYuyc6VMqNAhGeuk3a/JFjYq8g4iraB
         0O0HD2VwufUVWZUgwoaXUuAZLLL/3UavosSR/WePqqbcGX/dxTHKIawNCj6kkgVY9zu/
         4mL/SmqOOgSanvy9WzAZ8/YnQDNFEphSL9lAfAcXEukLzJezNAg9f8LZsRWeT6jhja2j
         Kq9Z6pEdh6/UlyraisSNxOc5Yir8w12rV3ZFPnxpweeh2ekjRorS1dP79upYypfM6LhQ
         X1qx42Ea2GhU2sNsd6saQFEcbpN9K0SlCUqr2Cmd8LGH+uTX2qF18BfEXeYC1wLIqkx0
         H9ng==
X-Gm-Message-State: ANoB5pnbiH+tbeZTyJP/lS6SBux4fKDpNMZvl7XjBzAxs6BpJtzTCB/3
        aAd5AINPa3dQE3DxjlSycA==
X-Google-Smtp-Source: AA0mqf4e21GRZkvWRvpSWmFSf0jhJjI8oAjyXchPeZTiL+IQp+8Fo3DKEDFsXheGcyees+YCBTMuIw==
X-Received: by 2002:aca:2113:0:b0:35a:d72:5504 with SMTP id 19-20020aca2113000000b0035a0d725504mr4073684oiz.209.1668797457330;
        Fri, 18 Nov 2022 10:50:57 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id e19-20020a0568301e5300b00637032a39a3sm1883737otj.6.2022.11.18.10.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 10:50:56 -0800 (PST)
Received: (nullmailer pid 856967 invoked by uid 1000);
        Fri, 18 Nov 2022 18:50:54 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-amlogic@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-watchdog@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-phy@lists.infradead.org,
        Jerome Brunet <jbrunet@baylibre.com>,
        devicetree@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-media@vger.kernel.org, linux-rtc@vger.kernel.org,
        Vinod Koul <vkoul@kernel.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-11-3f025599b968@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org> 
 <20221117-b4-amlogic-bindings-convert-v1-11-3f025599b968@linaro.org>
Message-Id: <166879731890.853508.15161413381354216091.robh@kernel.org>
Subject: Re: [PATCH 11/12] dt-bindings: pcie: convert amlogic,meson-pcie.txt
 to dt-schema
Date:   Fri, 18 Nov 2022 12:50:54 -0600
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 18 Nov 2022 15:33:37 +0100, Neil Armstrong wrote:
> Convert the Amlogic Meson AXG DWC PCIE SoC controller bindings to
> dt-schema.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../devicetree/bindings/pci/amlogic,axg-pcie.yaml  | 129 +++++++++++++++++++++
>  .../devicetree/bindings/pci/amlogic,meson-pcie.txt |  70 -----------
>  2 files changed, 129 insertions(+), 70 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20221117-b4-amlogic-bindings-convert-v1-11-3f025599b968@linaro.org


pcie@f9800000: clock-names:0: 'pclk' was expected
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

pcie@f9800000: clock-names:1: 'port' was expected
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

pcie@f9800000: clock-names:2: 'general' was expected
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

pcie@f9800000: Unevaluated properties are not allowed ('clock-names' was unexpected)
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

pcie@fa000000: clock-names:0: 'pclk' was expected
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

pcie@fa000000: clock-names:1: 'port' was expected
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

pcie@fa000000: clock-names:2: 'general' was expected
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

pcie@fa000000: Unevaluated properties are not allowed ('clock-names' was unexpected)
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

pcie@fc000000: clock-names:0: 'pclk' was expected
	arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-u200.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-a311d-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gsking-x.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-s922x-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air-gbit.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-h96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air-gbit.dtb

pcie@fc000000: clock-names:1: 'port' was expected
	arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-u200.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-a311d-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gsking-x.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-s922x-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air-gbit.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-h96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air-gbit.dtb

pcie@fc000000: clock-names:2: 'general' was expected
	arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-u200.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-a311d-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gsking-x.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-s922x-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air-gbit.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-h96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air-gbit.dtb

pcie@fc000000: Unevaluated properties are not allowed ('clock-names', 'power-domains' were unexpected)
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air-gbit.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-h96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air-gbit.dtb

pcie@fc000000: Unevaluated properties are not allowed ('clock-names' was unexpected)
	arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-u200.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-a311d-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gsking-x.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-odroid-n2-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-s922x-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dtb

