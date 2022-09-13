Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B875B7717
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231859AbiIMRCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231793AbiIMRCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:02:07 -0400
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C255FC2F8E;
        Tue, 13 Sep 2022 08:52:36 -0700 (PDT)
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1280590722dso33310597fac.1;
        Tue, 13 Sep 2022 08:52:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=5zitqPC3jMtJbaLdwQVMwLjdGwbT3nTG1S1emU8nL1U=;
        b=sAy8pBfjvKtajL62pv16X9ckRrfyBV2Mt9MBDIvvcUdaEVQR19tvYoZDQRBEvXyFHT
         baxCotSb8jwDGSbp1TKY9jV1x0Kmc++1SR90m1pnI+VOASngCj1VNWef+YLkVRaZLmyZ
         qeYccj1OcvZ02e5y7YwkbZjdFdv1JYoEht9XFURyMqikKvB6truRhF0fdY21pHUhoLzK
         bPDp7WqQL1+4DMOghNUc6JnzQH76RDGTtkO2GtsrwsY8ZskMHIY5B+GvNjO2133jZ7bp
         5zkzRactxbKoCdX8+VGCGzA2szxst20qFpOWuvSaDrfkkTq2M6x9MurRmFmvPJ4Rd7nm
         +ckg==
X-Gm-Message-State: ACgBeo21Oqg8G7I9IlVq81P+ddNLicjG6hflFN7p2WrlQ+7YhI1cAgCC
        sLGg4aTZEMeJ8YYEkaUYkA==
X-Google-Smtp-Source: AA6agR7MSb86Jh0ODTdi1vPWAkVgAwcB/GFNDkT4A6alMUaihbsgFK1AzksLP6OGUPFazQIqjFTFcQ==
X-Received: by 2002:a05:6808:2119:b0:34f:ca73:ee72 with SMTP id r25-20020a056808211900b0034fca73ee72mr1922974oiw.247.1663084320424;
        Tue, 13 Sep 2022 08:52:00 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id r196-20020acaa8cd000000b0034fd36e95bfsm1740582oie.31.2022.09.13.08.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 08:52:00 -0700 (PDT)
Received: (nullmailer pid 3802793 invoked by uid 1000);
        Tue, 13 Sep 2022 15:51:58 -0000
Date:   Tue, 13 Sep 2022 10:51:58 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Paolo Abeni <pabeni@redhat.com>,
        John Crispin <john@phrozen.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Rob Herring <robh+dt@kernel.org>, Marek Vasut <marex@denx.de>,
        netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: dsa: mt7530: stop
 requiring phy-mode on CPU ports
Message-ID: <20220913155158.GA3802757-robh@kernel.org>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912175058.280386-3-vladimir.oltean@nxp.com>
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

On Mon, 12 Sep 2022 20:50:57 +0300, Vladimir Oltean wrote:
> The common dsa-port.yaml does this (and more) since commit 2ec2fb8331af
> ("dt-bindings: net: dsa: make phylink bindings required for CPU/DSA
> ports").
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml | 3 ---
>  1 file changed, 3 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
