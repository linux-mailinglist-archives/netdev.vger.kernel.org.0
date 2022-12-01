Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA1663FA79
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 23:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiLAWXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 17:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiLAWWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 17:22:54 -0500
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4371D33E;
        Thu,  1 Dec 2022 14:22:52 -0800 (PST)
Received: by mail-ot1-f48.google.com with SMTP id l42-20020a9d1b2d000000b0066c6366fbc3so1887090otl.3;
        Thu, 01 Dec 2022 14:22:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F07P6a/Id33CTcYtj1QCwp4RFu2lFYRJBzRNDlUTKzo=;
        b=V1OOSPJWnD0gFZeWB+Feetb125GE01ZpVRpPB6MYjazlZXaQ9on6G6Tqx5Szl3YaPw
         8yioE5jgNZvaha9QwZQLe5J00hD/Opt50+yewjSeXcp13u99rFownLgOsGQrugsE4kfF
         YVZl8VuzQ+glIOK0N37pjH+6XyIy373+UOQHDdfOg1Ts8NacV70YnkBj8nsGHFTL14EF
         Ps4rA7EiuMBAVLKnSSLwkE2NL2/RXJEHeSZVQufrza74ZITLaMGdP/I777PljvpyzQlO
         MVtXcG4ky0U69E7XDvMPMW+4rnr6d3XRIHr3orUeYTl3OmpPLRavSbBUST00+WiKgO19
         f90Q==
X-Gm-Message-State: ANoB5plwP4wxBa1qwwPdtVQ0BR340fkubqNJ1VEoNTxPBVmQTwxrQXfj
        nyUXvnXC0kaM0BrbB+hc/A==
X-Google-Smtp-Source: AA0mqf4n7wg2fqdZVJhfDsF8YXv6rxBcsnnPoHmh1X60/W19nHTako7iT34gJHJ0FBsF+pOjEubToA==
X-Received: by 2002:a05:6830:57:b0:66d:de4e:9e9c with SMTP id d23-20020a056830005700b0066dde4e9e9cmr29635794otp.176.1669933371714;
        Thu, 01 Dec 2022 14:22:51 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t14-20020a0568080b2e00b0035a6003bb81sm2345682oij.0.2022.12.01.14.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 14:22:51 -0800 (PST)
Received: (nullmailer pid 1551805 invoked by uid 1000);
        Thu, 01 Dec 2022 22:22:49 -0000
Date:   Thu, 1 Dec 2022 16:22:49 -0600
From:   Rob Herring <robh@kernel.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        linux-renesas-soc@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        UNGLinuxDriver@microchip.com, Jakub Kicinski <kuba@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>, devicetree@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        ", John Crispin" <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v3 net-next 01/10] dt-bindings: net: dsa: sf2: fix
 brcm,use-bcm-hdr documentation
Message-ID: <166993336761.1551697.12498585251946226273.robh@kernel.org>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
 <20221127224734.885526-2-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221127224734.885526-2-colin.foster@in-advantage.com>
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


On Sun, 27 Nov 2022 14:47:25 -0800, Colin Foster wrote:
> The property use-bcm-hdr was documented as an entry under the ports node
> for the bcm_sf2 DSA switch. This property is actually evaluated for each
> port. Correct the documentation to match the actual behavior and properly
> reference dsa-port.yaml for additional properties of the node.
> 
> Suggested-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---
> 
> v3
>   * New patch
> 
> ---
>  .../devicetree/bindings/net/dsa/brcm,sf2.yaml     | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
