Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36B446D498
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 14:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbhLHNsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 08:48:07 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:35698 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLHNsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 08:48:05 -0500
Received: by mail-oi1-f170.google.com with SMTP id m6so4216376oim.2;
        Wed, 08 Dec 2021 05:44:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=2FBGOv0PegNkvtOMGaZYa1BsopYp6ezUI2k+MFWsRkg=;
        b=nlLsGUpnHCqMAlLAFSY375HXjgICUEj8obcHsY6kaZ/Vx+bKE12600ErleFCALgEZ1
         +bUxXf4Tk7NNWbuQABWIQjahI+C9wO63fdkBdxirPwT4W2yNk7ArWv55BUOb1eOG07gM
         XJmVgmfu1I05eBUc3TOUawO4+aZDEXn5bGESflCZk39MnxZN1etnF87AV679kj0zAv2v
         jCijUWqgeICL5YH+EezRhrnlX2LTRd0rzR7Ad3rrkrX0bPoieujVJq4p5D1ZlqLu4SLu
         RWDDKqjlh3wlaBJM9mXsHhKvyv/xIUYqDD5uSmMPehvEstDSyG0cenyvGa3FQAA2rHJl
         XbIg==
X-Gm-Message-State: AOAM531+hYRQ6sn3rbnOo2Wa8YMBO1PwHNnvdNNzCKTMvGCEc95rbhCi
        Kg5taQ2oO7Li62HVJ1Eu9dWkitZCQw==
X-Google-Smtp-Source: ABdhPJy4QOKFBXVt9kjHp3l6spBp74LPhwun2A8oRCnVjLpYafUk8Begm5tyq5EWMDExu9pfz3il7Q==
X-Received: by 2002:a54:4402:: with SMTP id k2mr11425020oiw.141.1638971072200;
        Wed, 08 Dec 2021 05:44:32 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 109sm477713otv.30.2021.12.08.05.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 05:44:31 -0800 (PST)
Received: (nullmailer pid 3857740 invoked by uid 1000);
        Wed, 08 Dec 2021 13:44:28 -0000
From:   Rob Herring <robh@kernel.org>
To:     Biao Huang <biao.huang@mediatek.com>
Cc:     Jose Abreu <joabreu@synopsys.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, macpaul.lin@mediatek.com,
        netdev@vger.kernel.org, angelogioacchino.delregno@collabora.com,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        devicetree@vger.kernel.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        srv_heupstream@mediatek.com, dkirjanov@suse.de,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
In-Reply-To: <20211208054716.603-5-biao.huang@mediatek.com>
References: <20211208054716.603-1-biao.huang@mediatek.com> <20211208054716.603-5-biao.huang@mediatek.com>
Subject: Re: [PATCH net-next v7 4/6] net: dt-bindings: dwmac: Convert mediatek-dwmac to DT schema
Date:   Wed, 08 Dec 2021 07:44:28 -0600
Message-Id: <1638971068.792969.3857739.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Dec 2021 13:47:14 +0800, Biao Huang wrote:
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

Full log is available here: https://patchwork.ozlabs.org/patch/1565082


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

