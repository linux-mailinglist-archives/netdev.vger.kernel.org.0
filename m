Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D66F58E0B7
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242756AbiHIUL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235181AbiHIUL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:11:27 -0400
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E78ECBCBE;
        Tue,  9 Aug 2022 13:11:26 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id y82so3671610iof.7;
        Tue, 09 Aug 2022 13:11:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/I2Ja6XlxwcieIUidG502lTi7iL51Mti4IAwPoXPOmU=;
        b=PwPGnLG3MdDSlV3gE/Tl9yXixlU+61hj543UTuKI5gEoGxOaLqDRA+P8EdRtwb6qvd
         f56L67tilerrFdLS6b2CYb7k5JYq7BK/5duMstt4ryd0CfgIO6aYGrrEFrOgDIdmxZsC
         ziaH93a8tgjNQHe8kPtW+C1YlySjKttwvdl/ItaZxeGXZ0HAFPdEgv9MghTWIuhAwMD5
         eouqjSE11RfaGaiXtMv/A52HxjRmW2Ks9sx8hWT5KZRB1JBD7zSZTAFDJXlyLT3wffm3
         wJuMn8IdWNnW+dAjKoltX/5nKUI/kIdpiz4RWN0BlTReK2GuaGHtnsnecXaQNU0bCKeX
         0PfQ==
X-Gm-Message-State: ACgBeo0dImeAGh/zQXuUy3nm3b290c7UJ4AgPnHiz+ymsbLyaKutuMZ6
        h1OO/dMPW4yZlKMflLiVX7ACaDsCUw==
X-Google-Smtp-Source: AA6agR6snIHDs0uwwy0szzwmoh1CHRJPNX8Dh+5m1O71oLUPUk8uxSeIzywwrAiXShMHxzEm1X852w==
X-Received: by 2002:a05:6602:490:b0:678:d781:446d with SMTP id y16-20020a056602049000b00678d781446dmr10242465iov.115.1660075886081;
        Tue, 09 Aug 2022 13:11:26 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id q2-20020a02cf02000000b00339ceeec5edsm6728349jar.12.2022.08.09.13.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:11:25 -0700 (PDT)
Received: (nullmailer pid 2311531 invoked by uid 1000);
        Tue, 09 Aug 2022 20:11:21 -0000
Date:   Tue, 9 Aug 2022 14:11:21 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Mans Rullgard <mans@mansr.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Sean Wang <sean.wang@mediatek.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        devicetree@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Marek Vasut <marex@denx.de>, Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Dumazet <edumazet@google.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [RFC PATCH v3 net-next 01/10] dt-bindings: net: dsa: xrs700x:
 add missing CPU port phy-mode to example
Message-ID: <20220809201121.GA2311497-robh@kernel.org>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806141059.2498226-2-vladimir.oltean@nxp.com>
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

On Sat, 06 Aug 2022 17:10:50 +0300, Vladimir Oltean wrote:
> Judging by xrs700x_phylink_get_caps(), I deduce that this switch
> supports the RGMII modes on port 3, so state this phy-mode in the
> example, such that users are encouraged to not rely on avoiding phylink
> for this port.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
