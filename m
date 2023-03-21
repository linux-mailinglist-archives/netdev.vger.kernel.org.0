Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D616C34E7
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 15:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjCUO62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 10:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbjCUO61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 10:58:27 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AF45231CD;
        Tue, 21 Mar 2023 07:58:24 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id l27so5687298wrb.2;
        Tue, 21 Mar 2023 07:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679410703;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=bgXEnYwzn/S6BlOb++Eaqru+i6YXyzKGwwPJBmaxtD4=;
        b=ga4YMD0irqHN4ilQrJ2QMVEbWHArwcWv2PG1FGLGI3et3uRUC94zk6BZpYLXtYwFfq
         Ww9fw7+pA7jFvc7QMMl9umhdWEA/kXceI4gCT4ZS+u6cf5+k8wZDH1mBjOQF2IZwG0eP
         BbF2RgvFUaLtqL8bqcA2Zc3372cO+99MGl3tVQ4B1oDiwwkK2/0cyJ9S8MYkfaLa2oaM
         7HxJWl67A3Jb7WSMyAi9EIoCBfiTwvWCOacUirjCW8pP1pNszz6QJU7mkI3miHldqUgt
         Enrh0ZOQr8wcVepDFsJOkm3WoNuy9MeBo+P0WBP6DG/Eu1lLdMhF71YyTtIOzp8Xc7lc
         HGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679410703;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgXEnYwzn/S6BlOb++Eaqru+i6YXyzKGwwPJBmaxtD4=;
        b=a9+x/9qzfIRngLeOzY0OOHw89nWNN+4oMrkdQvKAF5yUi7l1bg19op5s0SYepETJje
         WjHnneGUlA8BmvxJJe8wqu2ieCTcT4vIAltxMS/ltRpPiV4aaaBSSJ1JJGGTvCGNLRoZ
         VayF6L6FRRHAn9UKu53tpC5Ah48XHQZsZhGjTNuRaOHFVYnogAbTgQeZEhYXnl9osOMC
         uMcNCgHHyeM1fMrkv2OU/GQzSXF+B1ML31ODcf9L3/Vb1/NBecwYoYl3G4iLber+i7Ns
         TMlM9lGg2OLx5kEjfYvI+B0rOw8iAE5N84xI3bFNhgyFy6kvo2QcszpVol6YWDwoiFD9
         ylDw==
X-Gm-Message-State: AO0yUKXtikfmCn0WNPInC3gW7PD0+wszW8t7AYz7KrNxzyxvU3o+IJBA
        ieZ6m2SVz+bOw18eECYPDZ8=
X-Google-Smtp-Source: AK7set+K7ppr5kVHCtHkrUaYjB+7uxp7G1eEctUkA+c9/tYtmX8WRNtLlnpL/VsrO7ZBl1mm/ABfEA==
X-Received: by 2002:adf:f2c8:0:b0:2d2:22eb:824a with SMTP id d8-20020adff2c8000000b002d222eb824amr2419295wrp.34.1679410702538;
        Tue, 21 Mar 2023 07:58:22 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id d5-20020adfef85000000b002cfed482e9asm11556989wro.61.2023.03.21.07.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 07:58:22 -0700 (PDT)
Message-ID: <6419c60e.df0a0220.1949a.c432@mx.google.com>
X-Google-Original-Message-ID: <ZBli4hn6oPZzQZk0@Ansuel-xps.>
Date:   Tue, 21 Mar 2023 08:55:14 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 04/15] leds: Provide stubs for when CLASS_LED
 is disabled
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-5-ansuelsmth@gmail.com>
 <aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.ch>
 <64189d72.190a0220.8d965.4a1c@mx.google.com>
 <5ee3c2cf-8100-4f35-a2df-b379846a8736@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ee3c2cf-8100-4f35-a2df-b379846a8736@lunn.ch>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 08:31:36PM +0100, Andrew Lunn wrote:
> On Mon, Mar 20, 2023 at 06:52:47PM +0100, Christian Marangi wrote:
> > On Sun, Mar 19, 2023 at 11:49:02PM +0100, Andrew Lunn wrote:
> > > > +#if IS_ENABLED(CONFIG_LEDS_CLASS)
> > > >  enum led_default_state led_init_default_state_get(struct fwnode_handle *fwnode);
> > > > +#else
> > > > +static inline enum led_default_state
> > > > +led_init_default_state_get(struct fwnode_handle *fwnode)
> > > > +{
> > > > +	return LEDS_DEFSTATE_OFF;
> > > > +}
> > > > +#endif
> > > 
> > > 0-day is telling me i have this wrong. The function is in led-core.c,
> > > so this should be CONFIG_NEW_LEDS, not CONFIG_LEDS_CLASS.
> > > 
> > 
> > Any idea why? NEW_LEDS just enable LEDS_CLASS selection so why we need
> > to use that? Should not make a difference (in theory)
> 
> 0-day came up with a configuration which resulted in NEW_LEDS enabled
> but LEDS_CLASS disabled. That then resulted in multiple definitions of 
> led_init_default_state_get() when linking.
> 
> I _guess_ this is because select is used, which is not mandatory. So
> randconfig can turn off something which is enabled by select.
> 
> I updated my tree, and so far 0-day has not complained, but it can
> take a few days when it is busy.
> 

BTW yes I repro the problem.

Checked the makefile and led-core.c is compiled with NEW_LEDS and
led-class is compiled with LEDS_CLASS.

led_init_default_state_get is in led-core.c and this is the problem with
using LEDS_CLASS instead of NEW_LEDS...

But actually why we are putting led_init_default_state_get behind a
config? IMHO we should compile it anyway.

So my suggestion is to keep the LEDS_CLASS and just remove the part for 
led_init_default_state_get.

Also why IS_ENABLED instead of a simple ifdef? (in leds.h there is a mix
of both so I wonder if we should use one or the other)

-- 
	Ansuel
