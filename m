Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572CE6B0AAF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 15:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjCHOMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 09:12:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjCHOLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 09:11:55 -0500
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E621C5A18B;
        Wed,  8 Mar 2023 06:11:07 -0800 (PST)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-17711f56136so3904840fac.12;
        Wed, 08 Mar 2023 06:11:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678284654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BG0LVvFn1C/Da2Gc5O3YD8isCIsXrAwtxSQEVgE87AI=;
        b=RuXhJut4bN5ftmAJRq/9tiPeccWmierAJ/UbTICusRzkQoNjOG8YL+iO6w9GSVNIuM
         MPtwwCiEy+25yUZFLSJsd3hKagE0EjYwuuHWlDHqKe5tzf12n1eJ8OjJtouxIvAr3QC7
         88GZUJLP+OkfWqJCL7HTpUXun+wYZU/uG+o3MEAa5LXcru31ZdoY7MX5vzll1Rv8Dzct
         zAzR5KnmZc84jvww4EXmvexiilrLMwn6PYBZvDlTfaWgpNgoc0KZZ7lol0aCX4VVNSwg
         cZ+eAEv1WLNX71i5WEP4zviOzQlZyshApKdpJpw7tMGOzzPVduiQ+NL3jgxyN0jZAyhZ
         ubGA==
X-Gm-Message-State: AO0yUKXuLLm7p33VFPZHs4Jkv2fwt77YSwXkDWEog9cgBmjuS5E4ggJk
        14ELtuV8z/AxECVO1tdDZw==
X-Google-Smtp-Source: AK7set/cT2sp1M7e47IzQCQD2W8xtmPnZuAp+jI6K0s2N6oikhajQ93ypk71x4/YPZM2+Kr1qDFxTg==
X-Received: by 2002:a05:6871:b11:b0:176:3849:4e96 with SMTP id fq17-20020a0568710b1100b0017638494e96mr10140723oab.13.1678284654485;
        Wed, 08 Mar 2023 06:10:54 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id f8-20020a9d2c08000000b00690dc5d9b9esm6498673otb.6.2023.03.08.06.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 06:10:54 -0800 (PST)
Received: (nullmailer pid 2719199 invoked by uid 1000);
        Wed, 08 Mar 2023 14:10:52 -0000
Date:   Wed, 8 Mar 2023 08:10:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Pavel Machek <pavel@ucw.cz>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        linux-leds@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-media@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-gpio@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Lee Jones <lee@kernel.org>, Kalle Valo <kvalo@kernel.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>, linux-usb@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Eric Dumazet <edumazet@google.com>,
        Mark Brown <broonie@kernel.org>,
        Robert Foss <rfoss@kernel.org>,
        Sebastian Reichel <sre@kernel.org>, linux-can@vger.kernel.org,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH] dt-bindings: Fix SPI and I2C bus node names in examples
Message-ID: <167828463126.2715010.4541489267949266802.robh@kernel.org>
References: <20230228215433.3944508-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228215433.3944508-1-robh@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue, 28 Feb 2023 15:54:33 -0600, Rob Herring wrote:
> SPI and I2C bus node names are expected to be "spi" or "i2c",
> respectively, with nothing else, a unit-address, or a '-N' index. A
> pattern of 'spi0' or 'i2c0' or similar has crept in. Fix all these
> cases. Mostly scripted with the following commands:
> 
> git grep -l '\si2c[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's/i2c[0-9] {/i2c {/'
> git grep -l '\sspi[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's/spi[0-9] {/spi {/'
> 
> With this, a few errors in examples were exposed and fixed.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Cc: Miguel Ojeda <ojeda@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Andrzej Hajda <andrzej.hajda@intel.com>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: Robert Foss <rfoss@kernel.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Bartosz Golaszewski <brgl@bgdev.pl>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Wolfgang Grandegger <wg@grandegger.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-clk@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-gpio@vger.kernel.org
> Cc: linux-i2c@vger.kernel.org
> Cc: linux-leds@vger.kernel.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-can@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-usb@vger.kernel.org
> ---
>  .../bindings/auxdisplay/holtek,ht16k33.yaml       |  2 +-
>  .../bindings/chrome/google,cros-ec-typec.yaml     |  2 +-
>  .../chrome/google,cros-kbd-led-backlight.yaml     |  2 +-
>  .../devicetree/bindings/clock/ti,lmk04832.yaml    |  2 +-
>  .../bindings/display/bridge/analogix,anx7625.yaml |  2 +-
>  .../bindings/display/bridge/anx6345.yaml          |  2 +-
>  .../bindings/display/bridge/lontium,lt8912b.yaml  |  2 +-
>  .../bindings/display/bridge/nxp,ptn3460.yaml      |  2 +-
>  .../bindings/display/bridge/ps8640.yaml           |  2 +-
>  .../bindings/display/bridge/sil,sii9234.yaml      |  2 +-
>  .../bindings/display/bridge/ti,dlpc3433.yaml      |  2 +-
>  .../bindings/display/bridge/toshiba,tc358762.yaml |  2 +-
>  .../bindings/display/bridge/toshiba,tc358768.yaml |  2 +-
>  .../bindings/display/panel/nec,nl8048hl11.yaml    |  2 +-
>  .../bindings/display/solomon,ssd1307fb.yaml       |  4 ++--
>  .../devicetree/bindings/eeprom/at25.yaml          |  2 +-
>  .../bindings/extcon/extcon-usbc-cros-ec.yaml      |  2 +-
>  .../bindings/extcon/extcon-usbc-tusb320.yaml      |  2 +-
>  .../devicetree/bindings/gpio/gpio-pca9570.yaml    |  2 +-
>  .../devicetree/bindings/gpio/gpio-pca95xx.yaml    |  8 ++++----
>  .../bindings/i2c/google,cros-ec-i2c-tunnel.yaml   |  2 +-
>  .../bindings/leds/cznic,turris-omnia-leds.yaml    |  2 +-
>  .../devicetree/bindings/leds/issi,is31fl319x.yaml |  2 +-
>  .../devicetree/bindings/leds/leds-aw2013.yaml     |  2 +-
>  .../devicetree/bindings/leds/leds-rt4505.yaml     |  2 +-
>  .../devicetree/bindings/leds/ti,tca6507.yaml      |  2 +-
>  .../bindings/media/i2c/aptina,mt9p031.yaml        |  2 +-
>  .../bindings/media/i2c/aptina,mt9v111.yaml        |  2 +-
>  .../devicetree/bindings/media/i2c/imx219.yaml     |  2 +-
>  .../devicetree/bindings/media/i2c/imx258.yaml     |  4 ++--
>  .../devicetree/bindings/media/i2c/mipi-ccs.yaml   |  2 +-
>  .../bindings/media/i2c/ovti,ov5648.yaml           |  2 +-
>  .../bindings/media/i2c/ovti,ov772x.yaml           |  2 +-
>  .../bindings/media/i2c/ovti,ov8865.yaml           |  2 +-
>  .../bindings/media/i2c/ovti,ov9282.yaml           |  2 +-
>  .../bindings/media/i2c/rda,rda5807.yaml           |  2 +-
>  .../bindings/media/i2c/sony,imx214.yaml           |  2 +-
>  .../bindings/media/i2c/sony,imx274.yaml           |  2 +-
>  .../bindings/media/i2c/sony,imx334.yaml           |  2 +-
>  .../bindings/media/i2c/sony,imx335.yaml           |  2 +-
>  .../bindings/media/i2c/sony,imx412.yaml           |  2 +-
>  .../devicetree/bindings/mfd/actions,atc260x.yaml  |  2 +-
>  .../devicetree/bindings/mfd/google,cros-ec.yaml   |  6 +++---
>  .../devicetree/bindings/mfd/ti,tps65086.yaml      |  2 +-
>  .../devicetree/bindings/mfd/x-powers,axp152.yaml  |  4 ++--
>  .../devicetree/bindings/net/asix,ax88796c.yaml    |  2 +-
>  .../bindings/net/can/microchip,mcp251xfd.yaml     |  2 +-
>  .../bindings/net/dsa/microchip,ksz.yaml           |  2 +-
>  .../bindings/net/nfc/samsung,s3fwrn5.yaml         |  2 +-
>  .../bindings/net/vertexcom-mse102x.yaml           |  2 +-
>  .../bindings/net/wireless/ti,wlcore.yaml          | 10 ++++++++--
>  .../devicetree/bindings/pinctrl/pinmux-node.yaml  |  2 +-
>  .../bindings/pinctrl/starfive,jh7100-pinctrl.yaml |  2 +-
>  .../devicetree/bindings/power/supply/bq2415x.yaml |  2 +-
>  .../devicetree/bindings/power/supply/bq24190.yaml |  2 +-
>  .../devicetree/bindings/power/supply/bq24257.yaml |  4 ++--
>  .../devicetree/bindings/power/supply/bq24735.yaml |  2 +-
>  .../devicetree/bindings/power/supply/bq2515x.yaml |  2 +-
>  .../devicetree/bindings/power/supply/bq25890.yaml |  2 +-
>  .../devicetree/bindings/power/supply/bq25980.yaml |  2 +-
>  .../devicetree/bindings/power/supply/bq27xxx.yaml | 15 ++++++++-------
>  .../bindings/power/supply/lltc,ltc294x.yaml       |  2 +-
>  .../bindings/power/supply/ltc4162-l.yaml          |  2 +-
>  .../bindings/power/supply/maxim,max14656.yaml     |  2 +-
>  .../bindings/power/supply/maxim,max17040.yaml     |  4 ++--
>  .../bindings/power/supply/maxim,max17042.yaml     |  2 +-
>  .../bindings/power/supply/richtek,rt9455.yaml     |  2 +-
>  .../bindings/power/supply/ti,lp8727.yaml          |  2 +-
>  .../bindings/regulator/active-semi,act8865.yaml   |  2 +-
>  .../regulator/google,cros-ec-regulator.yaml       |  2 +-
>  .../bindings/regulator/nxp,pf8x00-regulator.yaml  |  2 +-
>  .../devicetree/bindings/sound/everest,es8316.yaml |  2 +-
>  .../devicetree/bindings/sound/tas2562.yaml        |  2 +-
>  .../devicetree/bindings/sound/tas2770.yaml        |  2 +-
>  .../devicetree/bindings/sound/tas27xx.yaml        |  2 +-
>  .../devicetree/bindings/sound/tas5805m.yaml       |  2 +-
>  .../devicetree/bindings/sound/tlv320adcx140.yaml  |  2 +-
>  .../devicetree/bindings/sound/zl38060.yaml        |  2 +-
>  .../devicetree/bindings/usb/maxim,max33359.yaml   |  2 +-
>  .../bindings/usb/maxim,max3420-udc.yaml           |  2 +-
>  .../bindings/usb/mediatek,mt6360-tcpc.yaml        |  2 +-
>  .../devicetree/bindings/usb/richtek,rt1711h.yaml  |  2 +-
>  .../devicetree/bindings/usb/richtek,rt1719.yaml   |  2 +-
>  .../devicetree/bindings/usb/st,stusb160x.yaml     |  2 +-
>  .../devicetree/bindings/usb/ti,hd3ss3220.yaml     |  2 +-
>  .../devicetree/bindings/usb/ti,tps6598x.yaml      |  2 +-
>  86 files changed, 110 insertions(+), 103 deletions(-)
> 

Applied, thanks!

