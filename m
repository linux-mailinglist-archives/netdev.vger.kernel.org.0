Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64BC58E0BA
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 22:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244201AbiHIULp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 16:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242787AbiHIULn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 16:11:43 -0400
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8372D2529A;
        Tue,  9 Aug 2022 13:11:42 -0700 (PDT)
Received: by mail-io1-f50.google.com with SMTP id v185so10484331ioe.11;
        Tue, 09 Aug 2022 13:11:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=O7HyUi1f0ct7jTcgS94yy1BXUesuJlz9DhUnCLRbuzo=;
        b=tHwYoyxMIb5Ky8AtbLjR00bLLbxM8pQFOEIQYYvxLdQwGDaWiIeXBRqAJkOO7sWu/0
         S5zHsQEXhErUrxAfmpW9HERS2sxRWDIBHNq3zTVmXybboYDlNnt+uJeHnvG9e15hJhuK
         DxSc+hYCdflN1mi3IMBeu8tXfrBk6sQmjxXWV+bksxTBfdPUuPEsoYwjaWvoQYi9dgbJ
         iMAQhuGvqKqn9q1aszK8b+6YAyXVfPmc54wF5ufh63Fgp+9TgkhyT9BPFboXYa/ZIW64
         aDdZaFtrCvAow+lNW/K1v05B/+18FJGrdwPfnROA2J9x5HLyw6+Vg5ExJcYVCll+gY8T
         9Hiw==
X-Gm-Message-State: ACgBeo14XJK9L5lGhijNTJdrYppdmLtiNJYQfF+YsvRgjt0j/Z+oaPov
        vpjFc6mlLEGiEpUjppGdqA==
X-Google-Smtp-Source: AA6agR5KNR1iNXBpflAdtpiggKTLjG7yChdjG4ZWxFrMi569KUIrNbjVLoqn8zln7/MRDKRAympSiw==
X-Received: by 2002:a02:661e:0:b0:342:c2ba:38ac with SMTP id k30-20020a02661e000000b00342c2ba38acmr8982398jac.143.1660075901657;
        Tue, 09 Aug 2022 13:11:41 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id e13-20020a92690d000000b002dc1d6652cesm1395714ilc.13.2022.08.09.13.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:11:41 -0700 (PDT)
Received: (nullmailer pid 2312049 invoked by uid 1000);
        Tue, 09 Aug 2022 20:11:35 -0000
Date:   Tue, 9 Aug 2022 14:11:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        linux-renesas-soc@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        UNGLinuxDriver@microchip.com, Marek Vasut <marex@denx.de>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Mans Rullgard <mans@mansr.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Sean Wang <sean.wang@mediatek.com>, netdev@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v3 net-next 02/10] dt-bindings: net: dsa: hellcreek:
 add missing CPU port phy-mode/fixed-link to example
Message-ID: <20220809201135.GA2312015-robh@kernel.org>
References: <20220806141059.2498226-1-vladimir.oltean@nxp.com>
 <20220806141059.2498226-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220806141059.2498226-3-vladimir.oltean@nxp.com>
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

On Sat, 06 Aug 2022 17:10:51 +0300, Vladimir Oltean wrote:
> Looking at hellcreek_phylink_get_caps(), I see that depending on whether
> is_100_mbits is set, speeds of 1G or of 100M will be advertised. The
> de1soc_r1_pdata sets is_100_mbits to true.
> 
> The PHY modes declared in the capabilities are MII, RGMII and GMII. GMII
> doesn't support 100Mbps, and as for RGMII, it would be a bit implausible
> to me to support this PHY mode but limit it to only 25 MHz. So I've
> settled on MII as a phy-mode in the example, and a fixed-link of
> 100Mbps.
> 
> As a side note, there exists such a thing as "rev-mii", because the MII
> protocol is asymmetric, and "mii" is the designation for the MAC side
> (expected to be connected to a PHY), and "rev-mii" is the designation
> for the PHY side (expected to be connected to a MAC). I wonder whether
> "mii" or "rev-mii" should actually be used here, since this is a CPU
> port and presumably connected to another MAC.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v2->v3: patch is new
> 
>  .../devicetree/bindings/net/dsa/hirschmann,hellcreek.yaml   | 6 ++++++
>  1 file changed, 6 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
