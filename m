Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8F06B10B8
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 19:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbjCHSMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 13:12:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjCHSL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 13:11:57 -0500
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09410CE96E;
        Wed,  8 Mar 2023 10:11:55 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id e9-20020a056830200900b00694651d19f6so6569443otp.12;
        Wed, 08 Mar 2023 10:11:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678299114;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SIxmU/QtppDrzLwRQM4/EQwwRkPiWGOq6+7u8fs1B9E=;
        b=KIyuip82zCUZ3tJBEAdGR5DkYNQRqUvHETB03T4NSIDff0TZ7j0LLeGC0ZvsCHkVpO
         GvJBnpLTNwMq83/0Q97eqj8cKhHM56QS0P0UioJdqeeP+QGVB5kYlysDCyJFGIt3nUwy
         z2738obH1ONby9hp1Otqi1fpQ2KBm3e0H0urqmMVazligMQ3uvPXn/V1/aJ7+mUK/4dY
         k65T2FaU0RXHLHK8n1XaZB2aRHy5vps0STG3Uz6Zwr1T4O9fveR5EP90SCuKbes3iNml
         qRG2tZyapqo0fXYb9KWkbO5bvs/NmqQ+2N46pX0TPL/p0jYemuIQctyUhEkRfUNars3r
         b0Fg==
X-Gm-Message-State: AO0yUKWdmfc/jHC+sH+MEv0+HxemLfU3fdDt9d60yiayCrAmbZPoXboo
        yHCHE95J7hfCY9PXMsrGmQ==
X-Google-Smtp-Source: AK7set9H8k0goZQjGPEgNkkixy3gs3vd/sHKzFTM0Gx4xSIKWRHwsc1ffnNsJ1R+prua9m2CbtMAgg==
X-Received: by 2002:a9d:7103:0:b0:690:d498:56d2 with SMTP id n3-20020a9d7103000000b00690d49856d2mr7763163otj.4.1678299114187;
        Wed, 08 Mar 2023 10:11:54 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id d1-20020a056830138100b0068bb73bd95esm6636451otq.58.2023.03.08.10.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Mar 2023 10:11:53 -0800 (PST)
Received: (nullmailer pid 3526245 invoked by uid 1000);
        Wed, 08 Mar 2023 18:11:52 -0000
Date:   Wed, 8 Mar 2023 12:11:52 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-riscv@lists.infradead.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        freedreno@lists.freedesktop.org, Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Abhinav Kumar <quic_abhinavk@quicinc.com>,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Stephen Boyd <sboyd@kernel.org>,
        Mark Brown <broonie@kernel.org>, Sean Paul <sean@poorly.run>,
        netdev@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-kernel@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-spi@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marc Zyngier <maz@kernel.org>, dri-devel@lists.freedesktop.org,
        alsa-devel@alsa-project.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-clk@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: yamllint: Require a space after a comment
 '#'
Message-ID: <167828471597.2730705.13533520056770041535.robh@kernel.org>
References: <20230303214223.49451-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303214223.49451-1-robh@kernel.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 03 Mar 2023 15:42:23 -0600, Rob Herring wrote:
> Enable yamllint to check the prefered commenting style of requiring a
> space after a comment character '#'. Fix the cases in the tree which
> have a warning with this enabled. Most cases just need a space after the
> '#'. A couple of cases with comments which were not intended to be
> comments are revealed. Those were in ti,sa2ul.yaml, ti,cal.yaml, and
> brcm,bcmgenet.yaml.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Rob Clark <robdclark@gmail.com>
> Cc: Abhinav Kumar <quic_abhinavk@quicinc.com>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Sean Paul <sean@poorly.run>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Kishon Vijay Abraham I <kishon@kernel.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Conor Dooley <conor.dooley@microchip.com>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: freedreno@lists.freedesktop.org
> Cc: linux-media@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-phy@lists.infradead.org
> Cc: linux-gpio@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-riscv@lists.infradead.org
> Cc: linux-spi@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/.yamllint   |  2 +-
>  .../bindings/clock/qcom,a53pll.yaml           |  4 ++--
>  .../devicetree/bindings/crypto/ti,sa2ul.yaml  |  4 ++--
>  .../bindings/display/msm/qcom,mdp5.yaml       |  2 +-
>  .../interrupt-controller/arm,gic.yaml         |  4 ++--
>  .../loongson,pch-msi.yaml                     |  2 +-
>  .../bindings/media/renesas,vin.yaml           |  4 ++--
>  .../devicetree/bindings/media/ti,cal.yaml     |  4 ++--
>  .../bindings/net/brcm,bcmgenet.yaml           |  2 --
>  .../bindings/net/cortina,gemini-ethernet.yaml |  6 ++---
>  .../devicetree/bindings/net/mdio-gpio.yaml    |  4 ++--
>  .../phy/marvell,armada-cp110-utmi-phy.yaml    |  2 +-
>  .../bindings/phy/phy-stm32-usbphyc.yaml       |  2 +-
>  .../phy/qcom,sc7180-qmp-usb3-dp-phy.yaml      |  2 +-
>  .../bindings/pinctrl/pinctrl-mt8192.yaml      |  2 +-
>  .../regulator/nxp,pca9450-regulator.yaml      |  8 +++----
>  .../regulator/rohm,bd71828-regulator.yaml     | 20 ++++++++--------
>  .../regulator/rohm,bd71837-regulator.yaml     |  6 ++---
>  .../regulator/rohm,bd71847-regulator.yaml     |  6 ++---
>  .../bindings/soc/renesas/renesas.yaml         |  2 +-
>  .../devicetree/bindings/soc/ti/ti,pruss.yaml  |  2 +-
>  .../bindings/sound/amlogic,axg-tdm-iface.yaml |  2 +-
>  .../bindings/sound/qcom,lpass-rx-macro.yaml   |  4 ++--
>  .../bindings/sound/qcom,lpass-tx-macro.yaml   |  4 ++--
>  .../bindings/sound/qcom,lpass-va-macro.yaml   |  4 ++--
>  .../sound/qcom,q6dsp-lpass-ports.yaml         |  2 +-
>  .../bindings/sound/simple-card.yaml           | 24 +++++++++----------
>  .../bindings/spi/microchip,mpfs-spi.yaml      |  2 +-
>  28 files changed, 65 insertions(+), 67 deletions(-)
> 

Applied, thanks!

