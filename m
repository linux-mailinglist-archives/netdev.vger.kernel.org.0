Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE051644823
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 16:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiLFPho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 10:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbiLFPhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 10:37:43 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C726596;
        Tue,  6 Dec 2022 07:37:40 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v8so20833356edi.3;
        Tue, 06 Dec 2022 07:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d2aBoo/MYw9aBXVIt2KwK6USjefW0Af7yl2CPwd0c+Y=;
        b=m1EAVUMRFBrbV5dDsnZXZAN6o4Dfn+5ZtDOmrO8InSOtQNuaJvKLypbDPCae4W7nE0
         dfGD1nkqiZScFBTSAXrMo0ZYe2c1/zVQEXWKzjEE/KgtRZQbpO8vm8KF8jscF0w39kOW
         8sTLlLy4mNogAyostv9wzFo5TXgGdzil1/3PrPjSfDo7IP96v0UG+VhXwnB0BKfvXmO8
         FFuGHXpT6zM7CxvyVazsGMwfTMxxfOeIgZ7gYjT1KBwuMeazUAC4V5uenFL9hHPQMLbx
         Dw6eDRVh9wTONI2EA6Ckn+eJeXox5pcjHEve47WYEX74zlrscsKFc7Y4D9701dsFQWgG
         AuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d2aBoo/MYw9aBXVIt2KwK6USjefW0Af7yl2CPwd0c+Y=;
        b=IYrooWkrO2WXFdhdgwyB/iD0faluzJqQaNs6y+jml0N+gTIDByvp2IFzbXVGgOeyD4
         LMl5sYiNa4iGaHQRoaX3D5HxaZfpg9cWHAEdqIgrkiLM/wlPDVontN04nufxIJrKe8iH
         imFSCJKbb4cfB3zc9edVxusbxHwJyseQwR2uQGN1pNRQCVoORt96+Li70ZTO2vcybooG
         sv7MAHngqqbUG7oQf4kXsjo3mKKNIKgtehh1PEP5cu7gmHDZHR24tsh9emqTJA/Pbr6i
         0r9z2cCJMNS1uJH2KcYEU9zU9EdWoAAyN9ZOf6/UKmDjtleMeVwDD7+uCk0EnzPfpE9f
         wEjw==
X-Gm-Message-State: ANoB5pmhH78nXngF8WUUybvv3lbBtUa6TmFAQoV1DcfIL5lCFuycKIrq
        /yPEMoZXirMiz4cEduxKudk=
X-Google-Smtp-Source: AA0mqf7e8IIimBlKAfh2D9udgEdKCjOXXkqfj6vyYRzkBhGRJ8OJs9j1GbXUw6+eZQEmwekG0p8zRw==
X-Received: by 2002:a05:6402:1045:b0:461:68e1:ced5 with SMTP id e5-20020a056402104500b0046168e1ced5mr13559071edu.142.1670341058481;
        Tue, 06 Dec 2022 07:37:38 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id e14-20020a170906314e00b007aee7ca1199sm7614767eje.10.2022.12.06.07.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 07:37:38 -0800 (PST)
Date:   Tue, 6 Dec 2022 17:37:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v4 net-next 3/9] dt-bindings: net: dsa: utilize base
 definitions for standard dsa switches
Message-ID: <20221206153734.4os4effdzlt2calg@skbuf>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-1-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202204559.162619-4-colin.foster@in-advantage.com>
 <20221202204559.162619-4-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 12:45:53PM -0800, Colin Foster wrote:
> diff --git a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> index 259a0c6547f3..5888e3a0169a 100644
> --- a/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/arrow,xrs700x.yaml
> @@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
>  title: Arrow SpeedChips XRS7000 Series Switch Device Tree Bindings
>  
>  allOf:
> -  - $ref: dsa.yaml#
> +  - $ref: dsa.yaml#/$defs/ethernet-ports
>  
>  maintainers:
>    - George McCollister <george.mccollister@gmail.com>
> diff --git a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> index 1219b830b1a4..5bef4128d175 100644
> --- a/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/brcm,b53.yaml
> @@ -66,7 +66,7 @@ required:
>    - reg
>  
>  allOf:
> -  - $ref: dsa.yaml#
> +  - $ref: dsa.yaml#/$defs/ethernet-ports

I'm wondering if "ethernet-ports" is the best name for this schema.
Not very scientific, but what about "just-standard-props"?
