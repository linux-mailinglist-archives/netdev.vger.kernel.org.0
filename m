Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B2D6062DD
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 16:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJTOVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 10:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiJTOVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 10:21:12 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BBD17653F;
        Thu, 20 Oct 2022 07:21:11 -0700 (PDT)
Received: by mail-ot1-f43.google.com with SMTP id a16-20020a056830101000b006619dba7fd4so11478766otp.12;
        Thu, 20 Oct 2022 07:21:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DRmvj/Qw7m4kPQR3vXMSaW6JmzIt/vfRx5j71ATZMPo=;
        b=LN/a7FVubtK7CtFQMBjbUYQPFN3ZABLJOszym3ac6/f3rs4Y3GgxFTuCm4OCT2bK3q
         7tHlq0rsT4yk8TWw+g9FQP2FGWVkWNIrV1VsDGV84eoIvXtTzqx35GtOUYYV7ERa+dUJ
         cEIGjXh2pXnbjpYkRkKaDkTgW3PEBlTLo8YH+33CfnXFUsKaI+IsytV8lDT3v1e0+Wpz
         rs/9PnyJ+K+l4fnhaB+v2dK6NCIAP4arDYGfkVyFY1h/9P+97h6LoCasXtFCFBoidL/7
         KdgfpSqHS8K1/8oGFYpQPoEGMzcgd5/xTLay56Fjc2a9T8uWcJQcVQB+TTDB0PTiiJaU
         pR1A==
X-Gm-Message-State: ACrzQf20X7sNn26UZ3G2z4XKn5r1sRcIHMtbz1Wo92Q89PLAXOeFXc02
        SLwL4fu/0gvV4/lwXijf2Q==
X-Google-Smtp-Source: AMsMyM6kgMpF5YggwgwsLirXF7Rn0lq5eGb6xz4yME8rs2ScP7Fq/R5S22HP4elC/sSX+ifGN97D+g==
X-Received: by 2002:a05:6830:2a0d:b0:656:bd3f:253f with SMTP id y13-20020a0568302a0d00b00656bd3f253fmr7105548otu.25.1666275671070;
        Thu, 20 Oct 2022 07:21:11 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id z15-20020a4ade4f000000b004767c273d3csm7559774oot.5.2022.10.20.07.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 07:21:10 -0700 (PDT)
Received: (nullmailer pid 1261301 invoked by uid 1000);
        Thu, 20 Oct 2022 14:21:10 -0000
Date:   Thu, 20 Oct 2022 09:21:10 -0500
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        linux-arm-kernel@lists.infradead.org,
        David Airlie <airlied@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nandhini Srikandan <nandhini.srikandan@intel.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sumit Gupta <sumitg@nvidia.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Cosmin Tanislav <cosmin.tanislav@analog.com>,
        Vinod Koul <vkoul@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Rashmi A <rashmi.a@intel.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-phy@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-iio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [PATCH] dt-bindings: Remove "status" from schema examples, again
Message-ID: <166627566746.1261189.15059225154291335125.robh@kernel.org>
References: <20221014205104.2822159-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014205104.2822159-1-robh@kernel.org>
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Oct 2022 15:51:04 -0500, Rob Herring wrote:
> There's no reason to have "status" properties in examples. "okay" is the
> default, and "disabled" turns off some schema checks ('required'
> specifically).
> 
> A meta-schema check for this is pending, so hopefully the last time to
> fix these.
> 
> Fix the indentation in intel,phy-thunderbay-emmc while we're here.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../arm/tegra/nvidia,tegra-ccplex-cluster.yaml    |  1 -
>  .../display/tegra/nvidia,tegra124-dpaux.yaml      |  1 -
>  .../display/tegra/nvidia,tegra186-display.yaml    |  2 --
>  .../bindings/iio/addac/adi,ad74413r.yaml          |  1 -
>  .../devicetree/bindings/net/cdns,macb.yaml        |  1 -
>  .../devicetree/bindings/net/nxp,dwmac-imx.yaml    |  1 -
>  .../bindings/phy/intel,phy-thunderbay-emmc.yaml   | 15 +++++++--------
>  7 files changed, 7 insertions(+), 15 deletions(-)
> 

Applied, thanks!
