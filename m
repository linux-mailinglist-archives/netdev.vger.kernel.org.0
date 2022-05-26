Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384B053565C
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 01:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237601AbiEZXTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 19:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiEZXTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 19:19:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36472E52A8;
        Thu, 26 May 2022 16:19:04 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i27so5604596ejd.9;
        Thu, 26 May 2022 16:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+BqwmdTcK+KDA2kwf/xtmIwFsx/ogHDu3MhALkXgSMs=;
        b=NC+0LJ1Y9JUlHIBbnIZ7V3FgMxQ+MJA8+ucckqMMFPk4wCwh/figE8o+6ioP+6OguO
         LZrO/hfA7F/iKOiSKrbEBHUZg8cS/nkR8zKxMMeUiLi2B0KpYcpfnlWN4Of3mmLH2GBz
         d8BAcX8yTzu3xjM217Y1hP/KxCCdk5LQThsD10gJsw8jUbPxzr+e6pdhRXEKbcxa2Vis
         Sf2kwZhQwCuor3cwTOWt6Sr8GijiS+5jiOJPXed0jN/NV7m/dfZVDux5vlJr5SV88uke
         xMiVohIDC3oUCSr5s8iTkswZbXbD9IrQnx8BbLFBVikbasiH9PN0QfTCIviBz/2rrjAg
         hZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+BqwmdTcK+KDA2kwf/xtmIwFsx/ogHDu3MhALkXgSMs=;
        b=rizP5ZFzu0C4fNDEdtJ+2wmwsc7G0K3lXgpxpSOo0UJrBL5wsORIJN+UIyjCe09zcs
         LK3t321Ck42vIHPXMTe7nWL7UU5clvHFFq+VZeD/Pr2hnvE9T45N7S2qrDRgS4Tp35ev
         OSDzY9yEjqBVX4cF4xhZ3yoAJwxDZzU3P33rn8OG0m9k2RwUcOYmELMxIqKAtZ++ADCU
         Vlyl9q43epboZ6EPQ9OjsPO5gqMgYn0C0XIai0Eltqkn3MhopCWQnYmmNZ336ZJtpgZq
         16kFEPhHjVZ7pLru+XumA0xsgoXPv/UHAF13t4MQutHC+SpE+JhXs1wDjSH3ByKinUuw
         CM7A==
X-Gm-Message-State: AOAM530gGcchJCwbr7joXzlfzEx5PhbZw8FGTxMAnz5metcH7KsJJ0+i
        BxW65fZmYnaIZ2na85B8kJ8=
X-Google-Smtp-Source: ABdhPJyVAy1Oi9U0Q22Wizfjf/aAKD7ZaKUWFMy3eDy0HKVs9cWZeDp9klmNgESJKFzoDTFx+FybJQ==
X-Received: by 2002:a17:906:99c5:b0:6fe:b069:4ab6 with SMTP id s5-20020a17090699c500b006feb0694ab6mr28506177ejn.436.1653607142622;
        Thu, 26 May 2022 16:19:02 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id n13-20020a170906118d00b006fec50645ebsm878443eja.204.2022.05.26.16.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 16:19:01 -0700 (PDT)
Date:   Fri, 27 May 2022 02:18:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Marek Vasut <marex@denx.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net/dsa: Add spi-peripheral-props.yaml
 references
Message-ID: <20220526231859.qstxkxqdetiawozv@skbuf>
References: <20220525205752.2484423-1-robh@kernel.org>
 <20220526003216.7jxopjckccugh3ft@skbuf>
 <20220526220450.GB315754-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220526220450.GB315754-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 26, 2022 at 05:04:50PM -0500, Rob Herring wrote:
> On Thu, May 26, 2022 at 03:32:16AM +0300, Vladimir Oltean wrote:
> > Also needed by nxp,sja1105.yaml and the following from brcm,b53.yaml:
> > 	brcm,bcm5325
> > 	brcm,bcm5365
> > 	brcm,bcm5395
> > 	brcm,bcm5397
> > 	brcm,bcm5398
> > 	brcm,bcm53115
> > 	brcm,bcm53125
> > 	brcm,bcm53128
> 
> Okay. Looks like you missed bcm5389?

I went to the end of drivers/net/dsa/b53/b53_spi.c and copied the
compatible strings. "brcm,bcm5389" is marked in b53_mdio.c, so I would
guess not.
