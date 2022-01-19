Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173CD4938AD
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353840AbiASKfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:35:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348607AbiASKfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:35:48 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4DCC061574;
        Wed, 19 Jan 2022 02:35:48 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id m11so8934533edi.13;
        Wed, 19 Jan 2022 02:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OSDFZdcVmsxc9n5bq5153WrX2NPdR5H36ptL4DF/Ld8=;
        b=YzN3hIDiV3bsIYsBRldtIUseIA+Xg7yiUwxhkQBN4CpuDkGRGuFL7tAwCFTPYxhsRL
         HPHBSnHmlPJjpHnwXFn3XLaO3n9wa1rhK6vn59VsHIzMFUB6Jaq/3jsmguiQSKRchg1F
         Rt8vJSiYrulpQPWwPqPi3M8d7DsPrMLpe1PuuNpPMpczmmAtVSklZu+pQaTuoZw/CFJz
         zmTnBvK6MUoD+sXbx5PZpdbapVrA4zutuPKb+I0hcI1WoSE1tZMwas+pgK6nHJrD6hKt
         eeU6QEdcKx7a9glyGv2v53ut+S9OpX/JqVokRLDZ4YgZwe4DtxLJ2DYjxyR/R4KjvJPB
         tM2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OSDFZdcVmsxc9n5bq5153WrX2NPdR5H36ptL4DF/Ld8=;
        b=DBjtVoWcNr/kqj3BWH6XNdTL4pmhrF90JG/EZtgC7boQa/08IcD8rpxiWq/zlWx/VI
         hnbtbUlYQDS8ioChF5I0H7MN2IMWQ0/tpc6Icuzi+AKOBy6sAxRHCaF8H0T0KaUqIL+k
         +VFYAW8wqY7pnYM0MFUEBeXpXjQEAZfMDW5DuSYmGgLj10A3G2+KBua9qT5oSzIoQUrj
         e41d6WX0U1dRGCYtQeSTH3Psvw36x7GjuBMyIA9Mgns2yfs0iNSyOIggeQ7n4kqaccn/
         4w0WSo4OkqYdgXLvOllUlFXwgGuo5EpiAEX62vqot39F8UFLvqW8nzUZLBhwMWXCATh0
         ALAg==
X-Gm-Message-State: AOAM533cM4yUAB0Wyi2CH9YokUaZltYgQQtEqVrywxgPnDZM2/qxvx/L
        GmTPiRRGivP2II1MhA8bnMZaTjlJwMd0Sw==
X-Google-Smtp-Source: ABdhPJxftTapCLkxAI0MUlBNg1QEZq+09+lN2uAiNmyiN4LnLKb1WAquBvnPN+ndGN2eyHqbgIspAw==
X-Received: by 2002:a05:6402:4310:: with SMTP id m16mr13576339edc.344.1642588546591;
        Wed, 19 Jan 2022 02:35:46 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id go41sm6349344ejc.200.2022.01.19.02.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 02:35:46 -0800 (PST)
Date:   Wed, 19 Jan 2022 12:35:42 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Chun-Kuang Hu <chunkuang.hu@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Vinod Koul <vkoul@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Viresh Kumar <vireshk@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-ide@vger.kernel.org, linux-crypto@vger.kernel.org,
        dri-devel@lists.freedesktop.org, dmaengine@vger.kernel.org,
        linux-pm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Improve phandle-array schemas
Message-ID: <20220119103542.el3yuqds6ihpkthn@skbuf>
References: <20220119015038.2433585-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119015038.2433585-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 07:50:38PM -0600, Rob Herring wrote:
> The 'phandle-array' type is a bit ambiguous. It can be either just an
> array of phandles or an array of phandles plus args. Many schemas for
> phandle-array properties aren't clear in the schema which case applies
> though the description usually describes it.
> 
> The array of phandles case boils down to needing:
> 
> items:
>   maxItems: 1
> 
> The phandle plus args cases should typically take this form:
> 
> items:
>   - items:
>       - description: A phandle
>       - description: 1st arg cell
>       - description: 2nd arg cell
> 
> With this change, some examples need updating so that the bracketing of
> property values matches the schema.
> ---
(...)
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> index 702df848a71d..c504feeec6db 100644
> --- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
> @@ -34,6 +34,8 @@ properties:
>        full routing information must be given, not just the one hop
>        routes to neighbouring switches
>      $ref: /schemas/types.yaml#/definitions/phandle-array
> +    items:
> +      maxItems: 1
>  
>    ethernet:
>      description:

For better or worse, the mainline cases of this property all take the
form of:

arch/arm64/boot/dts/marvell/armada-3720-turris-mox.dts
				link = <&switch1port9 &switch2port9>;
				link = <&switch1port10 &switch0port10>;
arch/arm/boot/dts/vf610-zii-dev-rev-b.dts
						link = <&switch1port6
							&switch2port9>;
						link = <&switch1port5
							&switch0port5>;
arch/arm/boot/dts/vf610-zii-scu4-aib.dts
						link = <&switch1port10
							&switch3port10
							&switch2port10>;
						link = <&switch3port10
							&switch2port10>;
						link = <&switch1port9
							&switch0port10>;

So not really an array of phandles.
