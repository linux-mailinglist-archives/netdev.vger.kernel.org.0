Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8673562FD0D
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242681AbiKRSvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242644AbiKRSvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:51:02 -0500
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766A079E25;
        Fri, 18 Nov 2022 10:51:00 -0800 (PST)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-13be3ef361dso6929198fac.12;
        Fri, 18 Nov 2022 10:51:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=9ZEyhvgIkjObPnrJ2/dp9ATGlB6fWPvCU9H7pSpDxZU=;
        b=OZ1FTXe7Gh7kvBRqShQePMwBoSbS5QPml9EiKTDbeLm4JypI5/EXNrhYaut21EuKIl
         U+nk/a7RqWWauNsKFIWKot/KDcBK1ZgOrYyRMFayItrUZ6WjEnAurHq3Xe7BwNtFY86u
         6VwsKN/sE2TOEhm7/AACZzHhjkq0YiUsxw+DhXBqWC11IvRtmBA/IBgeIcRnokshWtG9
         DMn+wBfgCHxSU6lf5BQzhZ2PCtu6YNdBo2MY5uOC7AnkQLspZrKGdJ52BvhxBwGXZwQ8
         3zCYwQB/ekF0VfwTmO9wG9DVtnB0ltDlY/8WU8AU9vx15Og1urEvGOosQCugK0ApXSdP
         y3Vw==
X-Gm-Message-State: ANoB5pmQN5Ec+rA794UL6OR/A60i6thbnESc17DwgfXg3UHI+TUKBPX9
        hDf6Ipsziyg75Io+HGYmeg==
X-Google-Smtp-Source: AA0mqf4Qt/xgfku9KmZ2RGjFgxxdPXhg0D/QQKgiTA8V2ods2mh+Z8i6W2f00I3oV94/oUmuX/PNkA==
X-Received: by 2002:a05:6870:960b:b0:13b:a720:efa1 with SMTP id d11-20020a056870960b00b0013ba720efa1mr7695302oaq.16.1668797459565;
        Fri, 18 Nov 2022 10:50:59 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id e18-20020a05683013d200b0063696cbb6bdsm1841768otq.62.2022.11.18.10.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 10:50:59 -0800 (PST)
Received: (nullmailer pid 856965 invoked by uid 1000);
        Fri, 18 Nov 2022 18:50:54 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-media@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-phy@lists.infradead.org, devicetree@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Kevin Hilman <khilman@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-pci@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Eric Dumazet <edumazet@google.com>, linux-rtc@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-amlogic@lists.infradead.org, Vinod Koul <vkoul@kernel.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-10-3f025599b968@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org> 
 <20221117-b4-amlogic-bindings-convert-v1-10-3f025599b968@linaro.org>
Message-Id: <166879731763.852137.10737377868850361519.robh@kernel.org>
Subject: Re: [PATCH 10/12] dt-bindings: mmc: convert amlogic,meson-gx.txt to dt-schema
Date:   Fri, 18 Nov 2022 12:50:54 -0600
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 18 Nov 2022 15:33:36 +0100, Neil Armstrong wrote:
> Convert the Amlogic SD / eMMC controller for S905/GXBB family SoCs
> to dt-schema.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../bindings/mmc/amlogic,meson-gx-mmc.yaml         | 78 ++++++++++++++++++++++
>  .../devicetree/bindings/mmc/amlogic,meson-gx.txt   | 39 -----------
>  2 files changed, 78 insertions(+), 39 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20221117-b4-amlogic-bindings-convert-v1-10-3f025599b968@linaro.org


mmc@70000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-meta.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-telos.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-hub.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-play2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-mecool-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p231.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-vero4k-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-p281.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-tx3-mini.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-hwacom-amazetv.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc-v2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-p212.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-gt1-ultimate.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-mecool-kiii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-minix-neo-u9h.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-s912-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-wetek-core2.dtb

mmc@70000: Unevaluated properties are not allowed ('compatible' was unexpected)
	arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-meta.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-telos.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-hub.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-play2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-mecool-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p231.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-vero4k-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-p281.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-tx3-mini.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-hwacom-amazetv.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc-v2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-p212.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-gt1-ultimate.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-mecool-kiii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-minix-neo-u9h.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-s912-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-wetek-core2.dtb

mmc@72000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-meta.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-telos.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-hub.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-play2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-mecool-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p231.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-vero4k-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-p281.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-tx3-mini.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-hwacom-amazetv.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc-v2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-p212.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-gt1-ultimate.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-mecool-kiii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-minix-neo-u9h.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-s912-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-wetek-core2.dtb

mmc@72000: Unevaluated properties are not allowed ('compatible' was unexpected)
	arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-meta.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-telos.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-hub.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-play2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-mecool-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p231.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-vero4k-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-p281.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-tx3-mini.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-hwacom-amazetv.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc-v2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-p212.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-gt1-ultimate.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-mecool-kiii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-minix-neo-u9h.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-s912-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-wetek-core2.dtb

mmc@74000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-meta.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-telos.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-hub.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-play2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-mecool-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p231.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-vero4k-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-p281.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-tx3-mini.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-hwacom-amazetv.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc-v2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-p212.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-gt1-ultimate.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-mecool-kiii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-minix-neo-u9h.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-s912-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-wetek-core2.dtb

mmc@74000: Unevaluated properties are not allowed ('compatible' was unexpected)
	arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-odroidc2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-p201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-meta.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-vega-s95-telos.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-hub.dtb
	arch/arm64/boot/dts/amlogic/meson-gxbb-wetek-play2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-libretech-ac.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s805x-p241.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-mecool-kii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p230.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-p231.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905d-vero4k-plus.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-jethome-jethub-j80.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-p281.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905w-tx3-mini.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-hwacom-amazetv.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-khadas-vim.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-libretech-cc-v2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-nexbox-a95x.dtb
	arch/arm64/boot/dts/amlogic/meson-gxl-s905x-p212.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-gt1-ultimate.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-mecool-kiii-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-minix-neo-u9h.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-nexbox-a1.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q200.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-q201.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-rbox-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-s912-libretech-pc.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-vega-s96.dtb
	arch/arm64/boot/dts/amlogic/meson-gxm-wetek-core2.dtb

sd@5000: $nodename:0: 'sd@5000' does not match '^mmc(@.*)?$'
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

sd@5000: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'broken-cd', 'bus-width', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'mmc-pwrseq', 'vmmc-supply', 'vqmmc-supply' were unexpected)
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-2.dtb
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j110-rev-3.dtb

sd@5000: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'bus-width', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'mmc-pwrseq', 'non-removable', 'sd-uhs-sdr104', 'vmmc-supply', 'vqmmc-supply', 'wifi@1' were unexpected)
	arch/arm64/boot/dts/amlogic/meson-axg-s400.dtb

sd@5000: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'bus-width', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'mmc-pwrseq', 'non-removable', 'vmmc-supply', 'vqmmc-supply', 'wifi@1' were unexpected)
	arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j100.dtb

sd@ffe03000: $nodename:0: 'sd@ffe03000' does not match '^mmc(@.*)?$'
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

sd@ffe03000: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'bus-width', 'cap-sd-highspeed', 'disable-wp', 'keep-power-in-suspend', 'max-frequency', 'mmc-pwrseq', 'non-removable', 'sd-uhs-sdr104', 'vmmc-supply', 'vqmmc-supply' were unexpected)
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-a95xf3-air-gbit.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-h96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air-gbit.dtb

sd@ffe03000: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'bus-width', 'cap-sd-highspeed', 'disable-wp', 'keep-power-in-suspend', 'max-frequency', 'mmc-pwrseq', 'non-removable', 'sd-uhs-sdr50', 'vmmc-supply', 'vqmmc-supply', 'wifi@1' were unexpected)
	arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-sei510.dtb
	arch/arm64/boot/dts/amlogic/meson-g12a-x96-max.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-khadas-vim3l.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dtb

sd@ffe03000: Unevaluated properties are not allowed ('#address-cells', '#size-cells', 'bus-width', 'cap-sd-highspeed', 'disable-wp', 'keep-power-in-suspend', 'max-frequency', 'mmc-pwrseq', 'non-removable', 'vmmc-supply', 'vqmmc-supply', 'wifi@1' were unexpected)
	arch/arm64/boot/dts/amlogic/meson-g12b-a311d-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gsking-x.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-gtking-pro.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-s922x-khadas-vim3.dtb
	arch/arm64/boot/dts/amlogic/meson-g12b-ugoos-am6.dtb

sd@ffe05000: $nodename:0: 'sd@ffe05000' does not match '^mmc(@.*)?$'
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

sd@ffe05000: Unevaluated properties are not allowed ('bus-width', 'cap-sd-highspeed', 'cd-gpios', 'disable-wp', 'max-frequency', 'sd-uhs-sdr104', 'sd-uhs-sdr12', 'sd-uhs-sdr25', 'sd-uhs-sdr50', 'vmmc-supply', 'vqmmc-supply' were unexpected)
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dtb

sd@ffe05000: Unevaluated properties are not allowed ('bus-width', 'cap-sd-highspeed', 'cd-gpios', 'disable-wp', 'max-frequency', 'vmmc-supply', 'vqmmc-supply' were unexpected)
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
	arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air.dtb
	arch/arm64/boot/dts/amlogic/meson-sm1-x96-air-gbit.dtb

