Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8D163FC42
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 00:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiLAXqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 18:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiLAXqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 18:46:32 -0500
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5957BEC47;
        Thu,  1 Dec 2022 15:46:31 -0800 (PST)
Received: by mail-ot1-f50.google.com with SMTP id t19-20020a9d7753000000b0066d77a3d474so1978731otl.10;
        Thu, 01 Dec 2022 15:46:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kku18D3Y88MWUX/tUqbmMS28F2KQx7nmZY37oV7FZwE=;
        b=W1IegVZt38qqnwHKTR0xhxFoWcKQpO1C+tjfEOdmXbVWQHpbGDJk3K+5Dp6F5XHsyO
         JI6GNIPpiCd8/F5yf12YcULwt6VoVBaa3htjGvE5ZeqrqF2p1X8H/ivAmlixMPwVy/jX
         WZbBIsKxukDePs9RFBR8G+KTG40285peDSfk3SOyYj/QwGsWGS/fB+id+HUqHaJspzWk
         mELGF7WiLTgne0scKSjPZ+R0BtOeanKLAABR0tiZSCZCv7TKntmdm0JslgxuJbcDvQv/
         X7tc6iK5TDljZlFhb5fCArgkZ4OBIOnhHOO3qlZabMN6nbTmJv25iHhFmWGmCtGObr7K
         vWeg==
X-Gm-Message-State: ANoB5pkcown+20I8exZ6psaZ1Cr1X4pg6pzJ50UAvz+RhJXVAvMSPjrs
        2arjxQ82MA76VENUSuDyzA==
X-Google-Smtp-Source: AA0mqf5ZGQasomoBdeMHUbWi+cUm7mHzdtQUSRq09o1u9VxkbZV92Lxt3/8ZuyZgJD7FgCKGDpaDTA==
X-Received: by 2002:a05:6830:1e63:b0:661:9030:6480 with SMTP id m3-20020a0568301e6300b0066190306480mr24758975otr.147.1669938390899;
        Thu, 01 Dec 2022 15:46:30 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id y2-20020a4ae702000000b0049427725e62sm2292185oou.19.2022.12.01.15.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 15:46:30 -0800 (PST)
Received: (nullmailer pid 1704103 invoked by uid 1000);
        Thu, 01 Dec 2022 23:46:28 -0000
Date:   Thu, 1 Dec 2022 17:46:28 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        linuxppc-dev@lists.ozlabs.org,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Ray Jui <rjui@broadcom.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Riesch <michael.riesch@wolfvision.net>,
        linux-mediatek@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-sunxi@lists.linux.dev,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>, soc@kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Fabio Estevam <festevam@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-rockchip@lists.infradead.org, netdev@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Samuel Holland <samuel@sholland.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        ", Andrew Lunn" <andrew@lunn.ch>, linux-arm-msm@vger.kernel.org,
        linux-mips@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Scott Branden <sbranden@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Heiko Stuebner <heiko@sntech.de>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Peng Fan <peng.fan@nxp.com>, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] dt-bindings: net: qca,ar71xx: remove label = "cpu"
 from examples
Message-ID: <166993831623.1702506.4546645219900752750.robh@kernel.org>
References: <20221130141040.32447-1-arinc.unal@arinc9.com>
 <20221130141040.32447-2-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221130141040.32447-2-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 30 Nov 2022 17:10:36 +0300, Arınç ÜNAL wrote:
> This is not used by the DSA dt-binding, so remove it from the examples.
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  Documentation/devicetree/bindings/net/qca,ar71xx.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
