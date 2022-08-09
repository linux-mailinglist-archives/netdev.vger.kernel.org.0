Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA9C658E0C7
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245356AbiHIUMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344354AbiHIUM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:12:26 -0400
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B59EA240AF;
        Tue,  9 Aug 2022 13:12:24 -0700 (PDT)
Received: by mail-il1-f170.google.com with SMTP id x2so1022481ilp.10;
        Tue, 09 Aug 2022 13:12:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=WUkjF1hW44OJlB6zV2lE0MdHWwyPru1UFrpuge8Byyc=;
        b=UzSQVHuZRE+PrAU5DW9+kKriDH+2pTe/jS3M8ZetKIPb4nw7SNYwMM0iokbsmCl5XI
         eECNnDNuEWfoK5EvmYiV1iW6JcOKtKLM0LfayGapqbKl+z3kd7sIKXoMHERnzDfl/j97
         +1xkmdHqVQ+t4WqZxvRkIbsN6HYEaciNor4USiEkY7pJlBmWoW4Einao3QN+4Rg4UWAz
         hNDXym/TjpB07FylUULDzf0kZ8xXLA9C/Ta3dG1LrUwrwRucAlTt2ly5kxNIDiVmha2p
         h4zeE2HQwikgYE5ETZCcl7M89/4AmYUBNI+/6R3VNBgo4NsGWm8WrkdW1i4aEPpmu/Rf
         UB/w==
X-Gm-Message-State: ACgBeo1+JBrNIJxdAo51P9I+93cyRZrkI+SBKbAJEi5D1sLSQdW6Qjgh
        rZirRqPaL+vRiQHL9fzfFw==
X-Google-Smtp-Source: AA6agR7N2Y3uJk3338InCxoOVR7ZiVaxAGsEIkzkBPWJorlAi7ctQt1dYa0O68zsUyqWWD3nqg40bg==
X-Received: by 2002:a05:6e02:1a61:b0:2e0:c417:4cb0 with SMTP id w1-20020a056e021a6100b002e0c4174cb0mr6969480ilv.186.1660075943909;
        Tue, 09 Aug 2022 13:12:23 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id p1-20020a92d681000000b002dd028f5ef5sm1397079iln.38.2022.08.09.13.12.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:12:23 -0700 (PDT)
Received: (nullmailer pid 2313642 invoked by uid 1000);
        Tue, 09 Aug 2022 20:12:18 -0000
Date:   Tue, 9 Aug 2022 14:12:18 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-renesas-soc@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Marek Vasut <marex@denx.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Andrew Lunn <andrew@lunn.ch>, Mans Rullgard <mans@mansr.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH v3 net-next 06/10] dt-bindings: net: dsa: make
 phylink bindings required for CPU/DSA ports
Message-ID: <20220809201218.GA2313609-robh@kernel.org>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806141059.2498226-7-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 06 Aug 2022 17:10:55 +0300, Vladimir Oltean wrote:
> It is desirable that new DSA drivers are written to expect that all
> their ports register with phylink, and not rely on the DSA core's
> workarounds to skip this process.
> 
> To that end, DSA is being changed to warn existing drivers when such DT
> blobs are in use, and to opt new drivers out of the workarounds.
> 
> Introduce another layer of validation in the DSA DT schema, and assert
> that CPU and DSA ports must have phylink-related properties present.
> 
> Suggested-by: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  .../devicetree/bindings/net/dsa/dsa-port.yaml   | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
