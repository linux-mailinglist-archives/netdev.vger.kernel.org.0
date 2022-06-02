Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC9B53BB2B
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbiFBOtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbiFBOta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:49:30 -0400
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BBF178557;
        Thu,  2 Jun 2022 07:49:28 -0700 (PDT)
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-f314077115so7043060fac.1;
        Thu, 02 Jun 2022 07:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=+SLUeshYYRHHBiExGyMNYhWtwhte/6gxD1JnckYeRpI=;
        b=pZ5FXhjhKlDoP88MQ9kWlwxTTQxJG+Mgf5RsOD1pyOYl09PZGSI4473FW2zg/f7/bn
         EqhaL9r27NZ06pvLhMFfYaMWQfIYsQc7KLHpn5h5pn7OxDU7VinzFMxpfu7Uw4L9Ae8U
         nnWhMUiNlgpexR3L+b1mhwESYD6Nz48pNYft0Fi+o46TjfbyxxPiB+M8kmBOLt7FYpxL
         GEI6M1X3WP8U/RpcaS/3RB+bsx/ZRmXMH3dWBs71AbgptQZ8lcNVG/Denaz4vMXmW6bx
         e6C/v4BlpE7mQTsxS71ZAuFxfZIARVh9e62+3rl6FICIIgbLTTR4mIgyjOM/A6enfti9
         FbjQ==
X-Gm-Message-State: AOAM5300kN192WjruTdR38Sfu1Ybzd8BMSivwQuFLE89jb1JCrx6DvqK
        rfohGwwZWRFZ/ESrFDHU+Q==
X-Google-Smtp-Source: ABdhPJxIzt4j7P1KqTn80l1LO7apZYo2bBKUcKBQ6UzAcOedmsCpzdyfNCQxPCnSvCvrWKW3CoRHNg==
X-Received: by 2002:a05:6870:3308:b0:f1:9e97:5a9d with SMTP id x8-20020a056870330800b000f19e975a9dmr18614142oae.127.1654181367787;
        Thu, 02 Jun 2022 07:49:27 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 12-20020aca120c000000b00325cda1ffa5sm2281218ois.36.2022.06.02.07.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 07:49:27 -0700 (PDT)
Received: (nullmailer pid 2296230 invoked by uid 1000);
        Thu, 02 Jun 2022 14:49:26 -0000
Date:   Thu, 2 Jun 2022 09:49:26 -0500
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Pascal Eberhard <pascal.eberhard@se.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Jose Abreu <joabreu@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-renesas-soc@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Herve Codina <herve.codina@bootlin.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v6 10/16] dt-bindings: net: snps,dwmac: add
 "power-domains" property
Message-ID: <20220602144926.GA2296137-robh@kernel.org>
References: <20220530084917.91130-1-clement.leger@bootlin.com>
 <20220530084917.91130-11-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220530084917.91130-11-clement.leger@bootlin.com>
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

On Mon, 30 May 2022 10:49:11 +0200, Clément Léger wrote:
> Since the stmmac driver already uses pm_runtime*() functions, describe
> "power-domains" property in the binding.
> 
> Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Signed-off-by: Clément Léger <clement.leger@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
