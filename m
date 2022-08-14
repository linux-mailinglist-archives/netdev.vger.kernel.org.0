Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5868591F05
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 10:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiHNIEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 04:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiHNIEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 04:04:08 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C9F41D21;
        Sun, 14 Aug 2022 01:04:08 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y13so8729710ejp.13;
        Sun, 14 Aug 2022 01:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=W7rVIy9LgPuGOyNEr9sl2d2jbeBBA5kMSa3lkDzmdp4=;
        b=G+q4sNnv3yGylW6B9iStR0y7AGSsHVli4No6S/hy1CuerZJ2gHVX6UCQl+h+4T9wJM
         MW8uZT3wa3u7EgAuYcWQyjO4JSjqcoSXDUp1e8uuqbJGIu1HSyx1gGOmWaWUWbmzC4j0
         Yne5lNAId+QgE1A8fF1YFm3jPIo2Ha+I2QOvqxX8tjOz+mwuFfcaUDVpIzVUkAXfStKm
         d8RqgODreU3lGgh70YWLqrzQVu06IvWld51jQoGVrt7Yr0fQhg/ORakDLUgBKluggdtK
         6nS/HgrQphKtOgC8FYrDyQquIgBhX35Jm+R7DEbmNVL7bjLzcxHapudZY76tiCRA9ai0
         pTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=W7rVIy9LgPuGOyNEr9sl2d2jbeBBA5kMSa3lkDzmdp4=;
        b=uhwWgsB6X7RYlLns6qoDXmFLCIePUxx/gPkm+c5+4gz/2EkTQ4CaQwlQE7iJil3EAW
         imeFx0vSQ3GeyGrPnfpYRPoKDe+q1JCQsyg8AvheBqs1o78wm4Wme726UCaREYgBcGZH
         BGr6xk3slRfJ35UKyakiHEbFsBKDqYCRSi6Kdb7My4XnP2wv9GonWNVZJ+agEykDpC3U
         ZiAC9veAxEvfBeK0VKcjBaTKSvHTcuQlEUU5OhCjAyK9M27K7FYeQ8zkcix6M/Edjz32
         kCKmPhRXwYzyTvcFllECaRNHDYvqktnpxN0qx/5c+6uC/B+5NhX+MpU3EC+6IHoeUlJl
         5jRg==
X-Gm-Message-State: ACgBeo18/SGM1oGfhJ93Lt/1Et3qPiayWX/vAzLn66lRSTrUH5ITEMyQ
        ox+ReK/k9XaUxfmTVrfHObQ=
X-Google-Smtp-Source: AA6agR7+7vX1Egkr5tNdwGbV6SP9IM6/P27XD7Ekos/rVAJGdFsq6lOJAvnXray3IhWueXoEcXb8Rw==
X-Received: by 2002:a17:907:3f94:b0:731:6473:b36c with SMTP id hr20-20020a1709073f9400b007316473b36cmr7468623ejc.525.1660464246432;
        Sun, 14 Aug 2022 01:04:06 -0700 (PDT)
Received: from skbuf ([188.26.57.212])
        by smtp.gmail.com with ESMTPSA id g1-20020a17090604c100b0073100dfa7b0sm2685103eja.8.2022.08.14.01.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 01:04:03 -0700 (PDT)
Date:   Sun, 14 Aug 2022 11:04:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 07/10] net: dsa: microchip: warn about not
 supported synclko properties on KSZ9893 chips
Message-ID: <20220814080400.6wxvwv3rxgzhx2pp@skbuf>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-8-o.rempel@pengutronix.de>
 <20220802113633.73rxlb2kmihivwpx@skbuf>
 <20220805115601.GB10667@pengutronix.de>
 <20220805134234.ps4qfjiachzm7jv4@skbuf>
 <20220813143215.GA12534@pengutronix.de>
 <Yve/MSMc/4klJPFL@lunn.ch>
 <20220813161850.GB12534@pengutronix.de>
 <YvgMnfSkEeD8jwIG@lunn.ch>
 <20220814042608.GC12534@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220814042608.GC12534@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 14, 2022 at 06:26:08AM +0200, Oleksij Rempel wrote:
> Heh :) Currently with "unevaluatedProperties: false" restrictions do not
> work at all. At least for me. For example with this change I have no
> warnings:
> diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> index 1e26d876d1463..da38ad98a152f 100644
> --- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> @@ -120,6 +120,7 @@ examples:
>              ethernet-switch@1 {
>                      reg = <0x1>;
>                      compatible = "nxp,sja1105t";
> +                    something-random-here;
>  
>                      ethernet-ports {
>                              #address-cells = <1>;
> 
> make dt_binding_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> 
> So the main question is, is it broken for all or just for me? If it is
> just me, what i'm doing wrong?

Might it be due to the additionalProperties: true from spi-peripheral-props.yaml?
