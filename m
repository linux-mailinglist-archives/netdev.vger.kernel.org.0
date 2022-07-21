Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6F857D42C
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 21:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiGUTcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 15:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiGUTcb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 15:32:31 -0400
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A79DF1B;
        Thu, 21 Jul 2022 12:32:27 -0700 (PDT)
Received: by mail-il1-f179.google.com with SMTP id o17so1108517ils.9;
        Thu, 21 Jul 2022 12:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RW1s9d0AAPQ8Q1ggcxkOL30thDKSyaQDJk2AQocHRzI=;
        b=hfqDZJKaSHT3oBUj9Lx8hiNTtsLfX9DdevN7s0z+3z105M/J6aa/5ipG/8hkSt3l4Q
         R1P9Noq73VxDygCFAI9rxy2mfh5L9Wr1lL+d16M4Hkl9iYiuXi30xOI/+kfNhGDn3NyI
         AIFw7/gv7MYZwlQwxbAv3C6ffIbQrePLeiH/jQ+hFH3+0FfDoRfgmeQlg6NU74atioLm
         zugIJigUvlbHhGMPmrv2oW9bWy8zrFfyzaZEJhsfHNbgUvCa3Fu8rt510jYhfbsAK59c
         uoQyNJAnxCdewS/be/Wv85TBbZJ/RXli5pnFIU86vICOd7dYRQt18WMLcKdgTLoJ+Sly
         IHNw==
X-Gm-Message-State: AJIora+8CSmEgdf7jvtGnKkqRFvJJ5PYVAb/sFZ66B0bkL80aGiK/SX9
        w/cNfLEak6qiqNh2mRlrNw==
X-Google-Smtp-Source: AGRyM1urApMk3RmAgAk80eaJYDGIiCddCIb635mCXcyV8VHha7Y/DzXmZJzaV4JfmCjlsWC3fhIGUw==
X-Received: by 2002:a92:b70e:0:b0:2dd:10f0:6f8d with SMTP id k14-20020a92b70e000000b002dd10f06f8dmr2526356ili.321.1658431946785;
        Thu, 21 Jul 2022 12:32:26 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id f19-20020a056638113300b0033f3ab94271sm1126125jar.139.2022.07.21.12.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 12:32:26 -0700 (PDT)
Received: (nullmailer pid 1794689 invoked by uid 1000);
        Thu, 21 Jul 2022 19:32:22 -0000
Date:   Thu, 21 Jul 2022 13:32:22 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
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
        =?UTF-8?Q?M=C3=A5rten_Lindahl?= <martenli@axis.com>,
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
Subject: Re: [PATCH 3/6] dt-bindings: iio: explicitly list SPI CPHA and CPOL
Message-ID: <20220721193222.GA1792785-robh@kernel.org>
References: <20220721153155.245336-1-krzysztof.kozlowski@linaro.org>
 <20220721153155.245336-4-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721153155.245336-4-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:31:52PM +0200, Krzysztof Kozlowski wrote:
> The spi-cpha and spi-cpol properties are device specific and should be
> accepted only if device really needs them.  Explicitly list them in
> device bindings in preparation of their removal from generic
> spi-peripheral-props.yaml schema.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../devicetree/bindings/iio/accel/adi,adxl345.yaml   | 10 ++++++++--
>  .../devicetree/bindings/iio/adc/adi,ad7192.yaml      | 10 ++++++++--
>  .../devicetree/bindings/iio/adc/adi,ad7292.yaml      |  5 ++++-
>  .../devicetree/bindings/iio/adc/adi,ad7606.yaml      | 10 ++++++++--
>  .../devicetree/bindings/iio/adc/adi,ad7768-1.yaml    | 10 ++++++++--
>  .../bindings/iio/adc/microchip,mcp3201.yaml          | 12 ++++++++++--
>  .../devicetree/bindings/iio/adc/ti,adc084s021.yaml   | 11 +++++++++--
>  .../devicetree/bindings/iio/adc/ti,ads124s08.yaml    |  5 ++++-
>  .../devicetree/bindings/iio/adc/ti,ads131e08.yaml    |  5 ++++-
>  .../devicetree/bindings/iio/addac/adi,ad74413r.yaml  |  5 ++++-
>  .../devicetree/bindings/iio/dac/adi,ad5592r.yaml     |  5 ++++-
>  .../devicetree/bindings/iio/dac/adi,ad5755.yaml      | 10 ++++++++--
>  .../devicetree/bindings/iio/dac/adi,ad5758.yaml      |  6 +++++-
>  .../devicetree/bindings/iio/dac/adi,ad5766.yaml      |  5 ++++-
>  .../devicetree/bindings/iio/dac/ti,dac082s085.yaml   |  9 +++++++--
>  .../bindings/iio/gyroscope/adi,adxrs290.yaml         | 10 ++++++++--
>  .../devicetree/bindings/iio/imu/adi,adis16460.yaml   | 12 +++++++++---
>  .../devicetree/bindings/iio/imu/adi,adis16475.yaml   | 10 ++++++++--
>  .../devicetree/bindings/iio/imu/adi,adis16480.yaml   | 11 +++++++++--
>  .../bindings/iio/imu/invensense,icm42600.yaml        | 12 ++++++++++--
>  .../bindings/iio/proximity/ams,as3935.yaml           |  5 ++++-
>  .../devicetree/bindings/iio/resolver/adi,ad2s90.yaml | 10 ++++++++--
>  .../bindings/iio/temperature/maxim,max31855k.yaml    |  6 +++++-
>  .../bindings/iio/temperature/maxim,max31856.yaml     |  6 +++++-
>  .../bindings/iio/temperature/maxim,max31865.yaml     |  6 +++++-
>  25 files changed, 166 insertions(+), 40 deletions(-)

This whole patch can be dropped which will make merging easier.

Rob
