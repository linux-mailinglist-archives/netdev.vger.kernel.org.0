Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C3B5B7749
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232420AbiIMRGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiIMRFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:05:45 -0400
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86477BB689;
        Tue, 13 Sep 2022 08:55:37 -0700 (PDT)
Received: by mail-ot1-f41.google.com with SMTP id br15-20020a056830390f00b0061c9d73b8bdso8375652otb.6;
        Tue, 13 Sep 2022 08:55:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=gp+xU4sE8xgnQ6QfOuz2cTyIgHVRPnIYNOZIMtkoz24=;
        b=g+02oqbnvb25VsTYwfYswkCy+JtrrHYAHYqDC2M296OMsAzIPUZRFAm1HzpVDwCHH3
         o+mEBa8nDSWaoyvpbasgOpv8iGTMATq0YjmIVO49Y8MdstvFxVBD8+DnaM1MKHBPBGj2
         f8ItH2FIX2U9JZXEMAouglM7fAJ+Y7feOY6nzlmjitzP75pjlUB0XesbatsTZmcJ/A4C
         hr7BYO5VPAMH22lauLziE/1gmSHqfpZx9xXPcRrnlU1QVbGifCzp1EAK6nThKMKF9pY6
         nTnc+XAP1BR2KTa7uiiZh/vUWsfK3i8geltpWRmUkF7H8SE87K5YpMJeboGUihzkqy1N
         gAQw==
X-Gm-Message-State: ACgBeo06897oBg4SkZlpG/6Z2CKcxQsx9agntHC5Jg2/605C0lNCiso3
        LYbRd7mLaenAXVXDGBH+iA==
X-Google-Smtp-Source: AA6agR4MQlnAHtl45e8P0paPvA3OMjCOfUqMmnYSQk6J/fNxNbf1aZVEL/1TNMQ265oczn67305usw==
X-Received: by 2002:a9d:1e2:0:b0:656:c789:2b52 with SMTP id e89-20020a9d01e2000000b00656c7892b52mr814035ote.112.1663084490183;
        Tue, 13 Sep 2022 08:54:50 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id 30-20020a9d0321000000b00655ca9a109bsm5224267otv.36.2022.09.13.08.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 08:54:49 -0700 (PDT)
Received: (nullmailer pid 3806977 invoked by uid 1000);
        Tue, 13 Sep 2022 15:54:48 -0000
Date:   Tue, 13 Sep 2022 10:54:48 -0500
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        John Crispin <john@phrozen.org>,
        linux-renesas-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Marek Vasut <marex@denx.de>,
        linux-mediatek@lists.infradead.org,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        George McCollister <george.mccollister@gmail.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 3/3] dt-bindings: net: dsa: remove label = "cpu"
 from examples
Message-ID: <20220913155448.GA3806944-robh@kernel.org>
References: <20220912175058.280386-1-vladimir.oltean@nxp.com>
 <20220912175058.280386-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912175058.280386-4-vladimir.oltean@nxp.com>
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

On Mon, 12 Sep 2022 20:50:58 +0300, Vladimir Oltean wrote:
> This is not used by the DSA dt-binding, so remove it from all examples.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/ar9331.txt       | 1 -
>  .../devicetree/bindings/net/dsa/arrow,xrs700x.yaml         | 1 -
>  Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml    | 2 --
>  .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml  | 1 -
>  Documentation/devicetree/bindings/net/dsa/lan9303.txt      | 2 --
>  Documentation/devicetree/bindings/net/dsa/lantiq-gswip.txt | 1 -
>  .../devicetree/bindings/net/dsa/mediatek,mt7530.yaml       | 7 -------
>  .../devicetree/bindings/net/dsa/microchip,ksz.yaml         | 2 --
>  Documentation/devicetree/bindings/net/dsa/qca8k.yaml       | 3 ---
>  Documentation/devicetree/bindings/net/dsa/realtek.yaml     | 2 --
>  .../devicetree/bindings/net/dsa/renesas,rzn1-a5psw.yaml    | 1 -
>  .../devicetree/bindings/net/dsa/vitesse,vsc73xx.txt        | 2 --
>  12 files changed, 25 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
