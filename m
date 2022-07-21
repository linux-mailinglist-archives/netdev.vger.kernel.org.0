Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85BF57D422
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 21:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbiGUTaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 15:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiGUTaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 15:30:11 -0400
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B524E6319;
        Thu, 21 Jul 2022 12:30:09 -0700 (PDT)
Received: by mail-il1-f178.google.com with SMTP id n13so1324627ilk.1;
        Thu, 21 Jul 2022 12:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S5oqoZILA3qJDwFMm5veai5D2xa9Jh2FvCXN1Y4esC4=;
        b=nTgFeGF+WKh8aJX1FBgmEISV+IMTMf+YlhImLj7qqtQWMTjUeJDkOo9fHoXAhFWA3F
         ujIvy0eKrJgSwM7chGowqHoeQmhREbUM1bKa5x4LcWpdlwNm57CXZB4YZIOOwGkPoOT+
         B0Q81LuFW1j3d8ZPPg5LFn43ckW9TCRJnFSmT1kvJ5/iGXRtKkMW2TnqiTnILEQ8BHEf
         lNxJoFMuF/dhZmSrxasx1VpzSG+dGL9v7JyQYcb8/Fm7FndhWbhdEnzZ2RsPdptioXxD
         j1qum4DbWDvfWYBYoWixyYAOoVIwQ+iEOmT7rufqpJe2QHPKLs/lmJlg9JHu23KSTBPr
         NzBQ==
X-Gm-Message-State: AJIora/0Ospsg15/sKCwOqAccp/XHOFpn0/h7psorxnIYZjEb+vxUcnq
        ChpE2OMgNeeI0QPj1CwRUQ==
X-Google-Smtp-Source: AGRyM1tXf8F5SuOd7u9OTYkcAFQnmVlNgUvsAqcBnI6RZZvikkHvaiVm4o7nZS8N3k7KCBJHQznkQQ==
X-Received: by 2002:a05:6e02:20ca:b0:2dc:90fa:af35 with SMTP id 10-20020a056e0220ca00b002dc90faaf35mr21707489ilq.302.1658431808875;
        Thu, 21 Jul 2022 12:30:08 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id y3-20020a029503000000b0033f347c26basm1149854jah.62.2022.07.21.12.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 12:30:08 -0700 (PDT)
Received: (nullmailer pid 1791625 invoked by uid 1000);
        Thu, 21 Jul 2022 19:30:04 -0000
Date:   Thu, 21 Jul 2022 13:30:04 -0600
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
Subject: Re: [PATCH 1/6] dt-bindings: panel: explicitly list SPI CPHA and CPOL
Message-ID: <20220721193004.GA1783390-robh@kernel.org>
References: <20220721153155.245336-1-krzysztof.kozlowski@linaro.org>
 <20220721153155.245336-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721153155.245336-2-krzysztof.kozlowski@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:31:50PM +0200, Krzysztof Kozlowski wrote:
> The spi-cpha and spi-cpol properties are device specific and should be
> accepted only if device really needs them.  Explicitly list them in
> device bindings in preparation of their removal from generic
> spi-peripheral-props.yaml schema.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
>  .../bindings/display/panel/lgphilips,lb035q02.yaml   | 10 ++++++++++
>  .../bindings/display/panel/samsung,ld9040.yaml       | 10 ++++++++++
>  .../bindings/display/panel/samsung,lms380kf01.yaml   | 12 +++++++++---
>  .../bindings/display/panel/samsung,lms397kf04.yaml   | 12 +++++++++---
>  .../bindings/display/panel/samsung,s6d27a1.yaml      | 12 +++++++++---
>  .../bindings/display/panel/sitronix,st7789v.yaml     | 10 ++++++++++
>  .../devicetree/bindings/display/panel/tpo,td.yaml    | 10 ++++++++++
>  7 files changed, 67 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/display/panel/lgphilips,lb035q02.yaml b/Documentation/devicetree/bindings/display/panel/lgphilips,lb035q02.yaml
> index 5e4e0e552c2f..0bd7bbad5b94 100644
> --- a/Documentation/devicetree/bindings/display/panel/lgphilips,lb035q02.yaml
> +++ b/Documentation/devicetree/bindings/display/panel/lgphilips,lb035q02.yaml
> @@ -21,6 +21,16 @@ properties:
>    enable-gpios: true
>    port: true
>  
> +  spi-cpha:
> +    type: boolean
> +    description:
> +      The device requires shifted clock phase (CPHA) mode.
> +
> +  spi-cpol:
> +    type: boolean
> +    description:
> +      The device requires inverse clock polarity (CPOL) mode.

Not great duplicating the type and description everywhere.

We can move the definition back to spi-controller.yaml, so then that 
does type checking of the property, but not presence/absence checks.

Rob
