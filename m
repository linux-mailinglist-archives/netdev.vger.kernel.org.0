Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E86F531CD6
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbiEWQ4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239229AbiEWQ4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:56:14 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40F4E40;
        Mon, 23 May 2022 09:56:12 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-edeb6c3642so19212178fac.3;
        Mon, 23 May 2022 09:56:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FfAOhZNasQcy6TRDHmB8U+mc653MKDmGV3a61UnarkE=;
        b=4KkfVM5goTSkVfLLz4yJUTYK9jwLwzP8f/PpRo8aB8IkJKQi4ENdB4cz/bZLj0eHjb
         YEXOmwJPZz219J0oESUvV2cbqkJIpqB2mqP/ypOKRIxZB5Q9ecba77zNia8ciYFPTPbk
         vrPNx2dzj7Nu7sb5kIUa1SknUEJwHpW4RVMX3HI+Rcflbis/zJ+RO3KVWPHkHoMAjboW
         RPDv58ohM5ox6JZFx3SnjCEC6tUT4eWwAHijPFqTXLOB6kbQmb/HSuAr60U1UXZA/cFV
         IF9PfZ6TLKCtKhg8wZAkXPMRJlyHYLB34KalgVgU4A29QzcRkpiOUSSNuUBlkObVOCfG
         wCkw==
X-Gm-Message-State: AOAM533vkLoWrjdNEctnWHVHHnoq5MUMqieCqa4zrXOERLLWtvOXgsOu
        fOCXzySz8awOAEzcFjzLRA==
X-Google-Smtp-Source: ABdhPJzG3ZFQrmj1v1yitS4jTC5DzQZmWnfRLp9MNvhBwUQ6yufF6JdEMRoPfxaQK0q/QMOIiKOBDg==
X-Received: by 2002:a05:6870:5823:b0:f2:2dfd:8df0 with SMTP id r35-20020a056870582300b000f22dfd8df0mr6004573oap.157.1653324972043;
        Mon, 23 May 2022 09:56:12 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id eb38-20020a056870a8a600b000edf5a12baasm3976216oab.46.2022.05.23.09.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 09:56:11 -0700 (PDT)
Received: (nullmailer pid 1750116 invoked by uid 1000);
        Mon, 23 May 2022 16:56:09 -0000
Date:   Mon, 23 May 2022 11:56:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Reichel <sre@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        dri-devel@lists.freedesktop.org, linux-gpio@vger.kernel.org,
        linux-input@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-media@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix properties without any type
Message-ID: <20220523165609.GA1743214-robh@kernel.org>
References: <20220519211411.2200720-1-robh@kernel.org>
 <6ae55a29-0b29-f53c-c9bd-fae929f3caf7@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ae55a29-0b29-f53c-c9bd-fae929f3caf7@linaro.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 05:03:41PM +0200, Krzysztof Kozlowski wrote:
> On 19/05/2022 23:14, Rob Herring wrote:
> > Now that the schema tools can extract type information for all
> > properties (in order to decode dtb files), finding properties missing
> > any type definition is fairly trivial though not yet automated.
> > 
> > Fix the various property schemas which are missing a type. Most of these
> > tend to be device specific properties which don't have a vendor prefix.
> > A vendor prefix is how we normally ensure a type is defined.
> > 
> > Signed-off-by: Rob Herring <robh@kernel.org>
> > ---
> >  .../arm/hisilicon/controller/hip04-bootwrapper.yaml       | 5 +++--
> >  .../bindings/display/bridge/toshiba,tc358768.yaml         | 1 +
> >  .../devicetree/bindings/display/panel/panel-timing.yaml   | 5 +++++
> >  .../bindings/display/panel/raydium,rm67191.yaml           | 1 +
> >  .../bindings/display/panel/samsung,s6e8aa0.yaml           | 1 +
> >  .../devicetree/bindings/gpio/fairchild,74hc595.yaml       | 1 +
> >  .../devicetree/bindings/input/google,cros-ec-keyb.yaml    | 1 +
> >  .../devicetree/bindings/input/matrix-keymap.yaml          | 4 ++++
> >  Documentation/devicetree/bindings/media/i2c/adv7604.yaml  | 3 ++-
> >  Documentation/devicetree/bindings/mux/reg-mux.yaml        | 8 ++++++--
> >  Documentation/devicetree/bindings/net/cdns,macb.yaml      | 1 +
> >  Documentation/devicetree/bindings/net/ingenic,mac.yaml    | 1 +
> >  .../devicetree/bindings/net/ti,davinci-mdio.yaml          | 1 +
> >  .../devicetree/bindings/net/wireless/ti,wlcore.yaml       | 2 ++
> >  .../devicetree/bindings/pci/snps,dw-pcie-ep.yaml          | 6 ++++--
> >  Documentation/devicetree/bindings/pci/snps,dw-pcie.yaml   | 2 ++
> >  .../devicetree/bindings/pinctrl/canaan,k210-fpioa.yaml    | 2 ++
> >  Documentation/devicetree/bindings/power/avs/qcom,cpr.yaml | 1 +
> >  .../devicetree/bindings/power/supply/battery.yaml         | 7 ++++++-
> >  .../devicetree/bindings/power/supply/charger-manager.yaml | 1 +
> >  Documentation/devicetree/bindings/rng/st,stm32-rng.yaml   | 1 +
> >  Documentation/devicetree/bindings/serial/8250.yaml        | 1 +
> >  .../devicetree/bindings/sound/audio-graph-card2.yaml      | 3 +++
> >  .../devicetree/bindings/sound/imx-audio-hdmi.yaml         | 3 +++
> >  Documentation/devicetree/bindings/usb/smsc,usb3503.yaml   | 1 +
> >  25 files changed, 55 insertions(+), 8 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml b/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
> > index 7378159e61df..483caf0ce25b 100644
> > --- a/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
> > +++ b/Documentation/devicetree/bindings/arm/hisilicon/controller/hip04-bootwrapper.yaml
> > @@ -17,14 +17,15 @@ properties:
> >        - const: hisilicon,hip04-bootwrapper
> >  
> >    boot-method:
> > +    $ref: /schemas/types.yaml#/definitions/uint32-array
> >      description: |
> >        Address and size of boot method.
> >        [0]: bootwrapper physical address
> >        [1]: bootwrapper size
> >        [2]: relocation physical address
> >        [3]: relocation size
> > -    minItems: 1
> > -    maxItems: 2
> > +    minItems: 2
> > +    maxItems: 4
> >  
> >  required:
> >    - compatible
> > diff --git a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
> > index 3bd670b8e5cd..0b6f5bef120f 100644
> > --- a/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
> > +++ b/Documentation/devicetree/bindings/display/bridge/toshiba,tc358768.yaml
> > @@ -58,6 +58,7 @@ properties:
> >  
> >              properties:
> >                data-lines:
> > +                $ref: /schemas/types.yaml#/definitions/uint32
> >                  enum: [ 16, 18, 24 ]
> >  
> >        port@1:
> > diff --git a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> > index 7749de95ee40..229e3b36ee29 100644
> > --- a/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> > +++ b/Documentation/devicetree/bindings/display/panel/panel-timing.yaml
> > @@ -146,6 +146,7 @@ properties:
> >        Horizontal sync pulse.
> >        0 selects active low, 1 selects active high.
> >        If omitted then it is not used by the hardware
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> >      enum: [0, 1]
> >  
> >    vsync-active:
> > @@ -153,6 +154,7 @@ properties:
> >        Vertical sync pulse.
> >        0 selects active low, 1 selects active high.
> >        If omitted then it is not used by the hardware
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> >      enum: [0, 1]
> >  
> >    de-active:
> > @@ -160,6 +162,7 @@ properties:
> >        Data enable.
> >        0 selects active low, 1 selects active high.
> >        If omitted then it is not used by the hardware
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> >      enum: [0, 1]
> >  
> >    pixelclk-active:
> > @@ -169,6 +172,7 @@ properties:
> >        sample data on rising edge.
> >        Use 1 to drive pixel data on rising edge and
> >        sample data on falling edge
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> >      enum: [0, 1]
> >  
> >    syncclk-active:
> > @@ -179,6 +183,7 @@ properties:
> >        sample sync on rising edge of pixel clock.
> >        Use 1 to drive sync on rising edge and
> >        sample sync on falling edge of pixel clock
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> >      enum: [0, 1]
> >  
> >    interlaced:
> > diff --git a/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml b/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
> > index 745dd247c409..617aa8c8c03a 100644
> > --- a/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
> > +++ b/Documentation/devicetree/bindings/display/panel/raydium,rm67191.yaml
> > @@ -24,6 +24,7 @@ properties:
> >  
> >    dsi-lanes:
> >      description: Number of DSI lanes to be used must be <3> or <4>
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> >      enum: [3, 4]
> >  
> >    v3p3-supply:
> > diff --git a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
> > index ca959451557e..1cdc91b3439f 100644
> > --- a/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
> > +++ b/Documentation/devicetree/bindings/display/panel/samsung,s6e8aa0.yaml
> > @@ -36,6 +36,7 @@ properties:
> >  
> >    init-delay:
> >      description: delay after initialization sequence [ms]
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> >  
> >    panel-width-mm:
> >      description: physical panel width [mm]
> > diff --git a/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml b/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> > index 5fe19fa5f67c..a99e7842ca17 100644
> > --- a/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> > +++ b/Documentation/devicetree/bindings/gpio/fairchild,74hc595.yaml
> > @@ -26,6 +26,7 @@ properties:
> >      const: 2
> >  
> >    registers-number:
> > +    $ref: /schemas/types.yaml#/definitions/uint32
> >      description: Number of daisy-chained shift registers
> >  
> >    enable-gpios:
> > diff --git a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> > index e8f137abb03c..aa61fe64be63 100644
> > --- a/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> > +++ b/Documentation/devicetree/bindings/input/google,cros-ec-keyb.yaml
> > @@ -31,6 +31,7 @@ properties:
> >      type: boolean
> >  
> >    function-row-physmap:
> > +    $ref: /schemas/types.yaml#/definitions/uint32-array
> >      minItems: 1
> >      maxItems: 15
> >      description: |
> > diff --git a/Documentation/devicetree/bindings/input/matrix-keymap.yaml b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> > index 6699d5e32dca..9f703bb51e12 100644
> > --- a/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> > +++ b/Documentation/devicetree/bindings/input/matrix-keymap.yaml
> > @@ -27,6 +27,10 @@ properties:
> >        column and linux key-code. The 32-bit big endian cell is packed as:
> >            row << 24 | column << 16 | key-code
> >  
> > +  linux,no-autorepeat:
> > +    type: boolean
> > +    description: Disable keyrepeat
> 
> This should be rather a separate patch - it's documenting a missing
> property, not only a type.

Yes, I've dropped this hunk while applying.

Rob
