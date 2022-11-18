Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968A362FD0B
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242768AbiKRSvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235502AbiKRSu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:50:58 -0500
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15048C0B3;
        Fri, 18 Nov 2022 10:50:55 -0800 (PST)
Received: by mail-oi1-f172.google.com with SMTP id n186so6294576oih.7;
        Fri, 18 Nov 2022 10:50:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=date:subject:message-id:references:in-reply-to:cc:to:from
         :mime-version:content-transfer-encoding:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AEGisTxdolA6TJB3qImtZFl0Ek6u4ZDhP6CL8w75bQo=;
        b=YZWNei94SVp8T8gnoS2hCQpeH6znfsgErh2YuUHnuljMlPFX/Q8wTahu1wd0FsE4FC
         P3AG99UOyY3GJiOkI+PlwEbQ3Ra1bVHoqIj6IB00gi6plBDIcvlD3rghC+05Y/TcgC2F
         eMDmMHcbhVR7d6UCO6s6k3wnJVjVnBtzzJK+xtoHfIywO9BY3PQ1eBE+MCcrKJ7br9Qu
         qQFLq+byrb1d4FBp7/nCSPLXvPtQo6s7RuiVzl8Rb3YHOCw7k0FqYN/tHoJIkO+s4Fiy
         PMlTJ+k+9rhtvZBm+05ztWIDqq2OntlxEly2kvrgJya4zXEaCpvG7jxLQgR6Bcc66q4r
         e62g==
X-Gm-Message-State: ANoB5plySIqP/kfJ+ggW63CNMKWsyTgtHGpx6OozNFDtb3VhYHd31Ce8
        xcRx4H6SbacaVlTuAl+HRw==
X-Google-Smtp-Source: AA0mqf41OMDQLBy2vrDxYSCq614dvKht2GD0zl0kCDAuuXBa962QTC+b9/Mrb78yb8+vJHmZs3z4Lg==
X-Received: by 2002:a05:6808:20a:b0:35a:eae4:b8c5 with SMTP id l10-20020a056808020a00b0035aeae4b8c5mr4164391oie.155.1668797455071;
        Fri, 18 Nov 2022 10:50:55 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q11-20020a9d630b000000b0066da36d2c45sm1893619otk.22.2022.11.18.10.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 10:50:54 -0800 (PST)
Received: (nullmailer pid 856957 invoked by uid 1000);
        Fri, 18 Nov 2022 18:50:54 -0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Rob Herring <robh@kernel.org>
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-amlogic@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        linux-kernel@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-phy@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-watchdog@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-media@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        Jerome Brunet <jbrunet@baylibre.com>,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        linux-rtc@vger.kernel.org,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v1-1-3f025599b968@linaro.org>
References: <20221117-b4-amlogic-bindings-convert-v1-0-3f025599b968@linaro.org> 
 <20221117-b4-amlogic-bindings-convert-v1-1-3f025599b968@linaro.org>
Message-Id: <166879731050.850509.16574480348039079520.robh@kernel.org>
Subject: Re: [PATCH 01/12] dt-bindings: firmware: convert meson_sm.txt to dt-schema
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


On Fri, 18 Nov 2022 15:33:27 +0100, Neil Armstrong wrote:
> Convert the Amlogic Secure Monitor bindings to dt-schema.
> 
> Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
> ---
>  .../bindings/firmware/amlogic,meson-gxbb-sm.yaml   | 36 ++++++++++++++++++++++
>  .../bindings/firmware/meson/meson_sm.txt           | 15 ---------
>  2 files changed, 36 insertions(+), 15 deletions(-)
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20221117-b4-amlogic-bindings-convert-v1-1-3f025599b968@linaro.org


secure-monitor: compatible:0: 'amlogic,meson-gxbb-sm' was expected
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

secure-monitor: compatible: ['amlogic,meson-gx-sm', 'amlogic,meson-gxbb-sm'] is too long
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

