Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EA5307F58
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhA1UQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbhA1UQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 15:16:32 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D24C061573;
        Thu, 28 Jan 2021 12:16:17 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id h6so7409302oie.5;
        Thu, 28 Jan 2021 12:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NbR4sKxTe8Xk3QFUJ5MkOhNqu5cUJjYRre+fhp43tDA=;
        b=L8DUiqGCZH3HOJzJkaJ0fHmbCboh54IwZiDIfsVyDJhm3hr0gnI4829XA07Gjdd/r7
         bngJuJd49M9IDX9alXP6s88kDs2HCIqVskFPws0r4lg4s4jlHztDzu3xyCFXbbL62AoX
         GX9+RnP81/r0BGvKyC6E1KAbOfvOhj+JAO3PbPHU6NjeYY8FhNDe9PZmZ7oOytX2pmOC
         hhbTn2PhmpmH6NQVkMzgc3E7jsshGGKE/CA7Xf+/8g3l+MZ4MHB6C5fg7VLDe9TuBobE
         uZloJoytl7Kzgynd65ahFvyqImzB1bLbsEdjvi+dz/ickIR/sU5xG7L+lGw194O2BbDt
         bPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=NbR4sKxTe8Xk3QFUJ5MkOhNqu5cUJjYRre+fhp43tDA=;
        b=DsW6KEhv3PDO4G5mQvQtcNvRvU9mPQmfQKhU7QImimpoLevAJadv0OFfCV6rOfOI1+
         kUUgX10FrIS/xv7nnx2pMsPnYx/bQpPog1NQaFmj7QCwRLTyBJWTLYLIAIGW8qmt16hC
         ksB23inoct/oyOhYN1s3kQAYv/HMNyTM1DboDT2LDNxIpjPIJGnfHWsP047cK13LsWG1
         GxZy1HikVF76ejFO9W2qyTweMTPLXgJRqkQORMjSC+ZJJkkGr2CUu0H7ZBdmCm9BHcZY
         7HpUHz+nT01lT1zcpttZ70N9bAytR0rHKSb1km3NGDRRGwKpsom5feYLk19XBVlkpyAX
         Buhg==
X-Gm-Message-State: AOAM532SY4ocVjIFCcRX3YLXw7c2zXXgxOO4YB5DRcPGlRJuR9HNNA2d
        AYBDBWBIHN0JSB52MMCl1Qc=
X-Google-Smtp-Source: ABdhPJwKTddIgafMAXCVLpPKj0eoCZh5EsWbxp66w4cnhr28RJ4ur9qbLj/Jah4JdGXJ7rwQk5sKww==
X-Received: by 2002:a54:458d:: with SMTP id z13mr663924oib.45.1611864976977;
        Thu, 28 Jan 2021 12:16:16 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 2sm1204743otg.6.2021.01.28.12.16.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Jan 2021 12:16:16 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 28 Jan 2021 12:16:14 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Wolfram Sang <wolfram@the-dreams.de>,
        linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Cleanup standard unit properties
Message-ID: <20210128201614.GA162245@roeck-us.net>
References: <20210128194515.743252-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128194515.743252-1-robh@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 01:45:15PM -0600, Rob Herring wrote:
> Properties with standard unit suffixes already have a type and don't need
> type definitions. They also default to a single entry, so 'maxItems: 1'
> can be dropped.
> 
> adi,ad5758 is an oddball which defined an enum of arrays. While a valid
> schema, it is simpler as a whole to only define scalar constraints.
> 
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Serge Semin <fancer.lancer@gmail.com>
> Cc: Wolfram Sang <wolfram@the-dreams.de>
> Cc: linux-hwmon@vger.kernel.org

Acked-by: Guenter Roeck <linux@roeck-us.net>

> Cc: linux-i2c@vger.kernel.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-mmc@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-rtc@vger.kernel.org
> Cc: linux-serial@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-watchdog@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/arm/cpus.yaml         |  1 -
>  .../bindings/extcon/wlf,arizona.yaml          |  1 -
>  .../bindings/hwmon/adi,ltc2947.yaml           |  1 -
>  .../bindings/hwmon/baikal,bt1-pvt.yaml        |  8 ++--
>  .../devicetree/bindings/hwmon/ti,tmp513.yaml  |  1 -
>  .../devicetree/bindings/i2c/i2c-gpio.yaml     |  2 -
>  .../bindings/i2c/snps,designware-i2c.yaml     |  3 --
>  .../bindings/iio/adc/maxim,max9611.yaml       |  1 -
>  .../bindings/iio/adc/st,stm32-adc.yaml        |  1 -
>  .../bindings/iio/adc/ti,palmas-gpadc.yaml     |  2 -
>  .../bindings/iio/dac/adi,ad5758.yaml          | 41 ++++++++++++-------
>  .../bindings/iio/health/maxim,max30100.yaml   |  1 -
>  .../input/touchscreen/touchscreen.yaml        |  2 -
>  .../bindings/mmc/mmc-controller.yaml          |  1 -
>  .../bindings/mmc/mmc-pwrseq-simple.yaml       |  2 -
>  .../bindings/net/ethernet-controller.yaml     |  2 -
>  .../devicetree/bindings/net/snps,dwmac.yaml   |  1 -
>  .../bindings/power/supply/battery.yaml        |  3 --
>  .../bindings/power/supply/bq2515x.yaml        |  1 -
>  .../bindings/regulator/dlg,da9121.yaml        |  1 -
>  .../bindings/regulator/fixed-regulator.yaml   |  2 -
>  .../devicetree/bindings/rtc/rtc.yaml          |  2 -
>  .../devicetree/bindings/serial/pl011.yaml     |  2 -
>  .../devicetree/bindings/sound/sgtl5000.yaml   |  2 -
>  .../bindings/watchdog/watchdog.yaml           |  1 -
>  25 files changed, 29 insertions(+), 56 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.yaml b/Documentation/devicetree/bindings/arm/cpus.yaml
> index 14cd727d3c4b..f02fd10de604 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.yaml
> +++ b/Documentation/devicetree/bindings/arm/cpus.yaml
> @@ -232,7 +232,6 @@ properties:
>        by this cpu (see ./idle-states.yaml).
>  
>    capacity-dmips-mhz:
> -    $ref: '/schemas/types.yaml#/definitions/uint32'
>      description:
>        u32 value representing CPU capacity (see ./cpu-capacity.txt) in
>        DMIPS/MHz, relative to highest capacity-dmips-mhz
> diff --git a/Documentation/devicetree/bindings/extcon/wlf,arizona.yaml b/Documentation/devicetree/bindings/extcon/wlf,arizona.yaml
> index 5fe784f487c5..efdf59abb2e1 100644
> --- a/Documentation/devicetree/bindings/extcon/wlf,arizona.yaml
> +++ b/Documentation/devicetree/bindings/extcon/wlf,arizona.yaml
> @@ -85,7 +85,6 @@ properties:
>    wlf,micd-timeout-ms:
>      description:
>        Timeout for microphone detection, specified in milliseconds.
> -    $ref: "/schemas/types.yaml#/definitions/uint32"
>  
>    wlf,micd-force-micbias:
>      description:
> diff --git a/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml b/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> index eef614962b10..bf04151b63d2 100644
> --- a/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adi,ltc2947.yaml
> @@ -49,7 +49,6 @@ properties:
>      description:
>        This property controls the Accumulation Dead band which allows to set the
>        level of current below which no accumulation takes place.
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      maximum: 255
>      default: 0
>  
> diff --git a/Documentation/devicetree/bindings/hwmon/baikal,bt1-pvt.yaml b/Documentation/devicetree/bindings/hwmon/baikal,bt1-pvt.yaml
> index 00a6511354e6..5d3ce641fcde 100644
> --- a/Documentation/devicetree/bindings/hwmon/baikal,bt1-pvt.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/baikal,bt1-pvt.yaml
> @@ -73,11 +73,9 @@ properties:
>      description: |
>        Temperature sensor trimming factor. It can be used to manually adjust the
>        temperature measurements within 7.130 degrees Celsius.
> -    maxItems: 1
> -    items:
> -      default: 0
> -      minimum: 0
> -      maximum: 7130
> +    default: 0
> +    minimum: 0
> +    maximum: 7130
>  
>  additionalProperties: false
>  
> diff --git a/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml b/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> index 8020d739a078..1502b22c77cc 100644
> --- a/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/ti,tmp513.yaml
> @@ -52,7 +52,6 @@ properties:
>    ti,bus-range-microvolt:
>      description: |
>        This is the operating range of the bus voltage in microvolt
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [16000000, 32000000]
>      default: 32000000
>  
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-gpio.yaml b/Documentation/devicetree/bindings/i2c/i2c-gpio.yaml
> index cc3aa2a5e70b..ff99344788ab 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-gpio.yaml
> +++ b/Documentation/devicetree/bindings/i2c/i2c-gpio.yaml
> @@ -39,11 +39,9 @@ properties:
>  
>    i2c-gpio,delay-us:
>      description: delay between GPIO operations (may depend on each platform)
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>    i2c-gpio,timeout-ms:
>      description: timeout to get data
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>    # Deprecated properties, do not use in new device tree sources:
>    gpios:
> diff --git a/Documentation/devicetree/bindings/i2c/snps,designware-i2c.yaml b/Documentation/devicetree/bindings/i2c/snps,designware-i2c.yaml
> index c22b66b6219e..d9293c57f573 100644
> --- a/Documentation/devicetree/bindings/i2c/snps,designware-i2c.yaml
> +++ b/Documentation/devicetree/bindings/i2c/snps,designware-i2c.yaml
> @@ -66,21 +66,18 @@ properties:
>      default: 400000
>  
>    i2c-sda-hold-time-ns:
> -    maxItems: 1
>      description: |
>        The property should contain the SDA hold time in nanoseconds. This option
>        is only supported in hardware blocks version 1.11a or newer or on
>        Microsemi SoCs.
>  
>    i2c-scl-falling-time-ns:
> -    maxItems: 1
>      description: |
>        The property should contain the SCL falling time in nanoseconds.
>        This value is used to compute the tLOW period.
>      default: 300
>  
>    i2c-sda-falling-time-ns:
> -    maxItems: 1
>      description: |
>        The property should contain the SDA falling time in nanoseconds.
>        This value is used to compute the tHIGH period.
> diff --git a/Documentation/devicetree/bindings/iio/adc/maxim,max9611.yaml b/Documentation/devicetree/bindings/iio/adc/maxim,max9611.yaml
> index 9475a9e6e920..95774a55629d 100644
> --- a/Documentation/devicetree/bindings/iio/adc/maxim,max9611.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/maxim,max9611.yaml
> @@ -23,7 +23,6 @@ properties:
>      maxItems: 1
>  
>    shunt-resistor-micro-ohms:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description: |
>        Value in micro Ohms of the shunt resistor connected between the RS+ and
>        RS- inputs, across which the current is measured.  Value needed to compute
> diff --git a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> index 6364ede9bb5f..a58334c3bb76 100644
> --- a/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/st,stm32-adc.yaml
> @@ -248,7 +248,6 @@ patternProperties:
>            Resolution (bits) to use for conversions:
>              - can be 6, 8, 10 or 12 on stm32f4
>              - can be 8, 10, 12, 14 or 16 on stm32h7 and stm32mp1
> -        $ref: /schemas/types.yaml#/definitions/uint32
>  
>        st,adc-channels:
>          description: |
> diff --git a/Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml b/Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml
> index 692dacd0fee5..7b895784e008 100644
> --- a/Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml
> +++ b/Documentation/devicetree/bindings/iio/adc/ti,palmas-gpadc.yaml
> @@ -42,7 +42,6 @@ properties:
>      const: 1
>  
>    ti,channel0-current-microamp:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description: Channel 0 current in uA.
>      enum:
>        - 0
> @@ -51,7 +50,6 @@ properties:
>        - 20
>  
>    ti,channel3-current-microamp:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description: Channel 3 current in uA.
>      enum:
>        - 0
> diff --git a/Documentation/devicetree/bindings/iio/dac/adi,ad5758.yaml b/Documentation/devicetree/bindings/iio/dac/adi,ad5758.yaml
> index 626ccb6fe21e..fd4edca34a28 100644
> --- a/Documentation/devicetree/bindings/iio/dac/adi,ad5758.yaml
> +++ b/Documentation/devicetree/bindings/iio/dac/adi,ad5758.yaml
> @@ -46,31 +46,42 @@ properties:
>        two properties must be present:
>  
>    adi,range-microvolt:
> -    $ref: /schemas/types.yaml#/definitions/int32-array
>      description: |
>        Voltage output range specified as <minimum, maximum>
> -    enum:
> -      - [[0, 5000000]]
> -      - [[0, 10000000]]
> -      - [[-5000000, 5000000]]
> -      - [[-10000000, 10000000]]
> +    oneOf:
> +      - items:
> +          - const: 0
> +          - enum: [5000000, 10000000]
> +      - items:
> +          - const: -5000000
> +          - const: 5000000
> +      - items:
> +          - const: -10000000
> +          - const: 10000000
>  
>    adi,range-microamp:
> -    $ref: /schemas/types.yaml#/definitions/int32-array
>      description: |
>        Current output range specified as <minimum, maximum>
> -    enum:
> -      - [[0, 20000]]
> -      - [[0, 24000]]
> -      - [[4, 24000]]
> -      - [[-20000, 20000]]
> -      - [[-24000, 24000]]
> -      - [[-1000, 22000]]
> +    oneOf:
> +      - items:
> +          - const: 0
> +          - enum: [20000, 24000]
> +      - items:
> +          - const: 4
> +          - const: 24000
> +      - items:
> +          - const: -20000
> +          - const: 20000
> +      - items:
> +          - const: -24000
> +          - const: 24000
> +      - items:
> +          - const: -1000
> +          - const: 22000
>  
>    reset-gpios: true
>  
>    adi,dc-dc-ilim-microamp:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      enum: [150000, 200000, 250000, 300000, 350000, 400000]
>      description: |
>        The dc-to-dc converter current limit.
> diff --git a/Documentation/devicetree/bindings/iio/health/maxim,max30100.yaml b/Documentation/devicetree/bindings/iio/health/maxim,max30100.yaml
> index 64b862637039..967778fb0ce8 100644
> --- a/Documentation/devicetree/bindings/iio/health/maxim,max30100.yaml
> +++ b/Documentation/devicetree/bindings/iio/health/maxim,max30100.yaml
> @@ -21,7 +21,6 @@ properties:
>      description: Connected to ADC_RDY pin.
>  
>    maxim,led-current-microamp:
> -    $ref: /schemas/types.yaml#/definitions/uint32-array
>      minItems: 2
>      maxItems: 2
>      description: |
> diff --git a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> index a771a15f053f..046ace461cc9 100644
> --- a/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> +++ b/Documentation/devicetree/bindings/input/touchscreen/touchscreen.yaml
> @@ -70,11 +70,9 @@ properties:
>  
>    touchscreen-x-mm:
>      description: horizontal length in mm of the touchscreen
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>    touchscreen-y-mm:
>      description: vertical length in mm of the touchscreen
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>  dependencies:
>    touchscreen-size-x: [ touchscreen-size-y ]
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> index df4ee4c778ae..e141330c1114 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> +++ b/Documentation/devicetree/bindings/mmc/mmc-controller.yaml
> @@ -261,7 +261,6 @@ properties:
>        waiting for I/O signalling and card power supply to be stable,
>        regardless of whether pwrseq-simple is used. Default to 10ms if
>        no available.
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      default: 10
>  
>    supports-cqe:
> diff --git a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
> index 6cd57863c1db..226fb191913d 100644
> --- a/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
> +++ b/Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.yaml
> @@ -41,13 +41,11 @@ properties:
>      description:
>        Delay in ms after powering the card and de-asserting the
>        reset-gpios (if any).
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>    power-off-delay-us:
>      description:
>        Delay in us after asserting the reset-gpios (if any)
>        during power off of the card.
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>  required:
>    - compatible
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index 0965f6515f9e..dac4aadb6e2e 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -122,7 +122,6 @@ properties:
>        such as flow control thresholds.
>  
>    rx-internal-delay-ps:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description: |
>        RGMII Receive Clock Delay defined in pico seconds.
>        This is used for controllers that have configurable RX internal delays.
> @@ -140,7 +139,6 @@ properties:
>        is used for components that can have configurable fifo sizes.
>  
>    tx-internal-delay-ps:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description: |
>        RGMII Transmit Clock Delay defined in pico seconds.
>        This is used for controllers that have configurable TX internal delays.
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index b2f6083f556a..9ac77b8cb767 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -208,7 +208,6 @@ properties:
>        Triplet of delays. The 1st cell is reset pre-delay in micro
>        seconds. The 2nd cell is reset pulse in micro seconds. The 3rd
>        cell is reset post-delay in micro seconds.
> -    $ref: /schemas/types.yaml#/definitions/uint32-array
>      minItems: 3
>      maxItems: 3
>  
> diff --git a/Documentation/devicetree/bindings/power/supply/battery.yaml b/Documentation/devicetree/bindings/power/supply/battery.yaml
> index 0c7e2e44793b..c3b4b7543591 100644
> --- a/Documentation/devicetree/bindings/power/supply/battery.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/battery.yaml
> @@ -83,21 +83,18 @@ properties:
>        for each of the battery capacity lookup table.
>  
>    operating-range-celsius:
> -    $ref: /schemas/types.yaml#/definitions/uint32-array
>      description: operating temperature range of a battery
>      items:
>        - description: minimum temperature at which battery can operate
>        - description: maximum temperature at which battery can operate
>  
>    ambient-celsius:
> -    $ref: /schemas/types.yaml#/definitions/uint32-array
>      description: safe range of ambient temperature
>      items:
>        - description: alert when ambient temperature is lower than this value
>        - description: alert when ambient temperature is higher than this value
>  
>    alert-celsius:
> -    $ref: /schemas/types.yaml#/definitions/uint32-array
>      description: safe range of battery temperature
>      items:
>        - description: alert when battery temperature is lower than this value
> diff --git a/Documentation/devicetree/bindings/power/supply/bq2515x.yaml b/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
> index 75a56773be4a..813d6afde606 100644
> --- a/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
> +++ b/Documentation/devicetree/bindings/power/supply/bq2515x.yaml
> @@ -50,7 +50,6 @@ properties:
>      maxItems: 1
>  
>    input-current-limit-microamp:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description: Maximum input current in micro Amps.
>      minimum: 50000
>      maximum: 500000
> diff --git a/Documentation/devicetree/bindings/regulator/dlg,da9121.yaml b/Documentation/devicetree/bindings/regulator/dlg,da9121.yaml
> index 6f2164f7bc57..228018c87bea 100644
> --- a/Documentation/devicetree/bindings/regulator/dlg,da9121.yaml
> +++ b/Documentation/devicetree/bindings/regulator/dlg,da9121.yaml
> @@ -62,7 +62,6 @@ properties:
>      description: IRQ line information.
>  
>    dlg,irq-polling-delay-passive-ms:
> -    $ref: "/schemas/types.yaml#/definitions/uint32"
>      minimum: 1000
>      maximum: 10000
>      description: |
> diff --git a/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml b/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
> index d3d0dc13dd8b..8850c01bd470 100644
> --- a/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
> +++ b/Documentation/devicetree/bindings/regulator/fixed-regulator.yaml
> @@ -72,11 +72,9 @@ properties:
>  
>    startup-delay-us:
>      description: startup time in microseconds
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>    off-on-delay-us:
>      description: off delay time in microseconds
> -    $ref: /schemas/types.yaml#/definitions/uint32
>  
>    enable-active-high:
>      description:
> diff --git a/Documentation/devicetree/bindings/rtc/rtc.yaml b/Documentation/devicetree/bindings/rtc/rtc.yaml
> index d30dc045aac6..0ec3551f12dd 100644
> --- a/Documentation/devicetree/bindings/rtc/rtc.yaml
> +++ b/Documentation/devicetree/bindings/rtc/rtc.yaml
> @@ -27,7 +27,6 @@ properties:
>        1: chargeable
>  
>    quartz-load-femtofarads:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description:
>        The capacitive load of the quartz(x-tal), expressed in femto
>        Farad (fF). The default value shall be listed (if optional),
> @@ -47,7 +46,6 @@ properties:
>      deprecated: true
>  
>    trickle-resistor-ohms:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description:
>        Selected resistor for trickle charger. Should be given
>        if trickle charger should be enabled.
> diff --git a/Documentation/devicetree/bindings/serial/pl011.yaml b/Documentation/devicetree/bindings/serial/pl011.yaml
> index c23c93b400f0..07fa6d26f2b4 100644
> --- a/Documentation/devicetree/bindings/serial/pl011.yaml
> +++ b/Documentation/devicetree/bindings/serial/pl011.yaml
> @@ -88,14 +88,12 @@ properties:
>      description:
>        Rate at which poll occurs when auto-poll is set.
>        default 100ms.
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      default: 100
>  
>    poll-timeout-ms:
>      description:
>        Poll timeout when auto-poll is set, default
>        3000ms.
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      default: 3000
>  
>  required:
> diff --git a/Documentation/devicetree/bindings/sound/sgtl5000.yaml b/Documentation/devicetree/bindings/sound/sgtl5000.yaml
> index d116c174b545..70b4a8831073 100644
> --- a/Documentation/devicetree/bindings/sound/sgtl5000.yaml
> +++ b/Documentation/devicetree/bindings/sound/sgtl5000.yaml
> @@ -41,14 +41,12 @@ properties:
>        values of 2k, 4k or 8k. If set to 0 it will be off. If this node is not
>        mentioned or if the value is unknown, then micbias resistor is set to
>        4k.
> -    $ref: "/schemas/types.yaml#/definitions/uint32"
>      enum: [ 0, 2, 4, 8 ]
>  
>    micbias-voltage-m-volts:
>      description: The bias voltage to be used in mVolts. The voltage can take
>        values from 1.25V to 3V by 250mV steps. If this node is not mentioned
>        or the value is unknown, then the value is set to 1.25V.
> -    $ref: "/schemas/types.yaml#/definitions/uint32"
>      enum: [ 1250, 1500, 1750, 2000, 2250, 2500, 2750, 3000 ]
>  
>    lrclk-strength:
> diff --git a/Documentation/devicetree/bindings/watchdog/watchdog.yaml b/Documentation/devicetree/bindings/watchdog/watchdog.yaml
> index 4e2c26cd981d..e3dfb02f0ca5 100644
> --- a/Documentation/devicetree/bindings/watchdog/watchdog.yaml
> +++ b/Documentation/devicetree/bindings/watchdog/watchdog.yaml
> @@ -19,7 +19,6 @@ properties:
>      pattern: "^watchdog(@.*|-[0-9a-f])?$"
>  
>    timeout-sec:
> -    $ref: /schemas/types.yaml#/definitions/uint32
>      description:
>        Contains the watchdog timeout in seconds.
>  
> -- 
> 2.27.0
> 
