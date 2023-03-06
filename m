Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02D3F6AB9C5
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 10:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCFJ1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 04:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjCFJ1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 04:27:08 -0500
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4E722DF7
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 01:27:07 -0800 (PST)
Received: by mail-ua1-x92a.google.com with SMTP id d12so5942599uak.10
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 01:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20210112.gappssmtp.com; s=20210112; t=1678094826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhS37jgP1oSKDQocHToehtxxyITsXcT+owYbmJ0INPU=;
        b=4t56tDC/G+oovfdiW5rxFZCyYsIfw/WmqyS1QgC9FKLy44l3wGWvPNPrKaEI6mAvIe
         ELD4XcqhLxDYPapof54et2VAMu4KrZDT7kUwAj9Hrs6wS7u5XxJjEWAUEaYcKiG/Zn39
         LbYGMfhwfIZ4JLhat+2hMudxk6CM3YJdkOXGSLSfaulwOvc6XpKpqL1F+6VUjzq55xQy
         y2JSmDTTT0sTDy7JHDzT8MfLrGyiRKAqCmO15rXFhnzLrphpS2zddGj0+LqedgxxL0hV
         0N2PQS1jMZSutIFgUay8tQ8K/XSrnWtb4nxvfgnG2GPyXj9/IYPjvJKK9fj6DB19DqZ2
         l4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678094826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zhS37jgP1oSKDQocHToehtxxyITsXcT+owYbmJ0INPU=;
        b=tsn5xf1+06cpBgVfKxnv4Wl95vxiIq/kBm1dejzpm4IvF1qowZ9J2hm0GWItYe2DWi
         dMgmFzEErrcOMazh32KmPZUWh7cwrK7bNNc0mdLLPAZq2r4R3g+WyNg1/LogBuKRycgC
         R07NyongTc0XK9HC2WsgebAqZUADlFUcq5rrgIoljMf3Kc+Wvagd/N/I5xIRdVMEQVx3
         xqQr8ZFLs/YJkqJFpJKqRXD5GoJACrCJOytkC1ZaXZLZqcUUu9i6TdtVbp2b/P1GMpM2
         /63CDhyElqhGGbW7R0d3z4AeSL3l+q2+np5HxmG/ZaG7StUB5nIDcS2d2rD6bMin5tyD
         xwhw==
X-Gm-Message-State: AO0yUKVrP9Ft5VFGPsdKAUmwIWJfFpQYVdXi+6V+I+YpTp3b10ta6yw8
        tVAmpPiwalPyaZ+W8TbTgYmUtWkKcPWOiWgDVEaE3w==
X-Google-Smtp-Source: AK7set+CHskqiSsm+6Cmi6WHgSSwP4myqJ1YcVc2LU1gm2fnO90Xr69irT8NxRARr/yjxDC8cjTLGID26SceOFHbVxE=
X-Received: by 2002:a9f:3104:0:b0:687:afc8:ffb9 with SMTP id
 m4-20020a9f3104000000b00687afc8ffb9mr6636458uab.2.1678094826467; Mon, 06 Mar
 2023 01:27:06 -0800 (PST)
MIME-Version: 1.0
References: <20230228215433.3944508-1-robh@kernel.org>
In-Reply-To: <20230228215433.3944508-1-robh@kernel.org>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Mon, 6 Mar 2023 10:26:55 +0100
Message-ID: <CAMRc=Mfouay5Z6M6VYnBX7Pe+ahTVfvfQsJ+kToWAwZJxZWJZg@mail.gmail.com>
Subject: Re: [PATCH] dt-bindings: Fix SPI and I2C bus node names in examples
To:     Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Miguel Ojeda <ojeda@kernel.org>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Robert Foss <rfoss@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Kalle Valo <kvalo@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-clk@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28, 2023 at 10:54=E2=80=AFPM Rob Herring <robh@kernel.org> wrot=
e:
>
> SPI and I2C bus node names are expected to be "spi" or "i2c",
> respectively, with nothing else, a unit-address, or a '-N' index. A
> pattern of 'spi0' or 'i2c0' or similar has crept in. Fix all these
> cases. Mostly scripted with the following commands:
>
> git grep -l '\si2c[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's=
/i2c[0-9] {/i2c {/'
> git grep -l '\sspi[0-9] {' Documentation/devicetree/ | xargs sed -i -e 's=
/spi[0-9] {/spi {/'
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

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
