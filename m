Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7755346809E
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 00:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383522AbhLCXiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 18:38:00 -0500
Received: from mail-ot1-f49.google.com ([209.85.210.49]:37847 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383433AbhLCXhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 18:37:53 -0500
Received: by mail-ot1-f49.google.com with SMTP id h19-20020a9d3e53000000b0056547b797b2so5388972otg.4;
        Fri, 03 Dec 2021 15:34:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=GE0Zk+eX8sZDvupP4sJ6Ohc20e/z8kxjxl7o4izocKY=;
        b=LEwadYRErEUe0KjWhZze3VleEKu9o7JzSh8xGEZwRCGLGP0Qo42WSTzMebJDpdhRlj
         H6pY9gecUdwPrlab42Dt0CXyS1sT1W0ilH9Jp2kM616dIZbD/ITsSdntK+U44SwspwV5
         lDwnqKCiZoX60uuktFi/gfCNqHA+2z52sLISQ7uRph8pXl4GFTJrvfjEx/Nr2Rlztxqr
         evVjtaqNfBeMZ/GkLlE5gc10eJ8vEDY45eUPbeAKh6O6ZXNPS01r5IzbIiivQt9IvGva
         HI9grcVW2MIia9neAPJy7IAS+mR4yCVDzMfDa5wmk0Pz2KpHAqgqiHnqs2hfr9FZ1YAi
         vBGw==
X-Gm-Message-State: AOAM530/9laHdhbkPVILU54XJxRm971/h6L2kdx18zLjX3p5TmG5ZVeT
        j7Sij5w1+cqQi4rHpFxojhb7zcHOdg==
X-Google-Smtp-Source: ABdhPJy3PCupkz+n/wmG78XL1Oz6xk1rXf5k7wFa5WXphozZiozk+A42lWVF0CAkCDKJY7uEHFyW9w==
X-Received: by 2002:a9d:2486:: with SMTP id z6mr19250720ota.210.1638574468140;
        Fri, 03 Dec 2021 15:34:28 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id c41sm939822otu.7.2021.12.03.15.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Dec 2021 15:34:27 -0800 (PST)
Received: (nullmailer pid 1043011 invoked by uid 1000);
        Fri, 03 Dec 2021 23:34:15 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        srv_heupstream@mediatek.com, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, dkirjanov@suse.de,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Matthias Brugger <matthias.bgg@gmail.com>,
        angelogioacchino.delregno@collabora.com, davem@davemloft.net,
        macpaul.lin@mediatek.com, Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        devicetree@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
In-Reply-To: <20211203063418.14892-5-biao.huang@mediatek.com>
References: <20211203063418.14892-1-biao.huang@mediatek.com> <20211203063418.14892-5-biao.huang@mediatek.com>
Subject: Re: [PATCH v4 4/7] net-next: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
Date:   Fri, 03 Dec 2021 17:34:15 -0600
Message-Id: <1638574455.270026.1043010.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 03 Dec 2021 14:34:15 +0800, Biao Huang wrote:
> Convert mediatek-dwmac to DT schema, and delete old mediatek-dwmac.txt.
> And there are some changes in .yaml than .txt, others almost keep the same:
>   1. compatible "const: snps,dwmac-4.20".
>   2. delete "snps,reset-active-low;" in example, since driver remove this
>      property long ago.
>   3. add "snps,reset-delay-us = <0 10000 10000>" in example.
>   4. the example is for rgmii interface, keep related properties only.
> 
> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
> ---
>  .../bindings/net/mediatek-dwmac.txt           |  91 ----------
>  .../bindings/net/mediatek-dwmac.yaml          | 156 ++++++++++++++++++
>  2 files changed, 156 insertions(+), 91 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 

Running 'make dtbs_check' with the schema in this patch gives the
following warnings. Consider if they are expected or the schema is
incorrect. These may not be new warnings.

Note that it is not yet a requirement to have 0 warnings for dtbs_check.
This will change in the future.

Full log is available here: https://patchwork.ozlabs.org/patch/1563125


ethernet@1101c000: clock-names: ['axi', 'apb', 'mac_main', 'ptp_ref'] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: clocks: [[27, 34], [27, 37], [6, 154], [6, 155]] is too short
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: ['mediatek,mt2712-gmac'] does not contain items matching the given schema
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: compatible: 'oneOf' conditional failed, one must be fixed:
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

ethernet@1101c000: Unevaluated properties are not allowed ('compatible', 'reg', 'interrupts', 'interrupt-names', 'mac-address', 'clock-names', 'clocks', 'power-domains', 'snps,axi-config', 'snps,mtl-rx-config', 'snps,mtl-tx-config', 'snps,txpbl', 'snps,rxpbl', 'clk_csr', 'phy-mode', 'phy-handle', 'snps,reset-gpio', 'mdio' were unexpected)
	arch/arm64/boot/dts/mediatek/mt2712-evb.dt.yaml

