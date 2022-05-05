Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABE651C3A3
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376648AbiEEPTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 11:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242784AbiEEPSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 11:18:52 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F294F47054;
        Thu,  5 May 2022 08:15:12 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id y3so9301562ejo.12;
        Thu, 05 May 2022 08:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P9U8VtHTMpxS3daOmFxvM8CiEOLd4g2YjivTRqBj1gg=;
        b=pylu+FcH16PRiwGxvsJ4Lvm8VVlU35vFQHYuCBoWRDRpESWBGDwGuKu0dR9BNAcbqc
         cKx/JvbNE+O1OdTPQl6gHPG84lxarUomOauCC5h+37/TVx6QZovXxu0XTMAu09utWHin
         B/eI9jpxuzn/9GpIC0QSQx88YVt0w5HNWJVybF52KdYjdZjezHNF3nZKTU9MuzUAzgvl
         2E+gls8B87ahmQK74ZKRCUuaVIBgyVu1fyuwjwDFDVDcd/CxOz8RsmsRtJc7X9Gnzb6D
         VDPU8wCLdF5sluzx4F1K3U6m00TU/VoR2kCAedh8Qq955i57wWN5IVEaQf0zTaNKqaTM
         0kGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P9U8VtHTMpxS3daOmFxvM8CiEOLd4g2YjivTRqBj1gg=;
        b=Lao8he9CrL6bv3MSTmtyEmYok3GQv3hALya7AXShs8VChg19TrovSr4koYOJv7ukZG
         CtWvetLGm+3JNP7JViVbW0PNpegHoparhK8jOFDlszjp02TK/3gXygi+WXJFUq15u9ne
         6YAOoVb6MhKkUEZbKbQBy/0LhH16WA4uR+4WvQbfgM8SF4olev/e2gtgZRcY5KB621Vh
         klutoSfk2ITQ2GsogK55setrm7cpAmyuKwKmIJcnvghG/diUOUT65WQaJIlsoR/cAQXA
         rYveVoWsFZQFRkJbMtoN1CC+6qf09KJugKLQ2gc/zYSjoIAx2WvoR0ZLVq0OBSDszA0O
         w1vA==
X-Gm-Message-State: AOAM531nRd1/OicxJIRZBE6AgFigUmUbgckayVCQbwBWUU/CKEDOECBa
        cC8VW7UUbMvoYcA86JsN1bU=
X-Google-Smtp-Source: ABdhPJxbaNdvNnwR7fqSaGdLSEy4BrGkyc6cPNhTM1hE34Dag/JoDOsa5U4KH+iru1hh2yxHWfyfyg==
X-Received: by 2002:a17:907:1c87:b0:6f0:29ea:cc01 with SMTP id nb7-20020a1709071c8700b006f029eacc01mr26942736ejc.671.1651763711293;
        Thu, 05 May 2022 08:15:11 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id b21-20020aa7c915000000b0042617ba6380sm954779edt.10.2022.05.05.08.15.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 08:15:10 -0700 (PDT)
Date:   Thu, 5 May 2022 18:15:07 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     songliubraving@fb.com, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        robh+dt@kernel.org, andrew@lunn.ch, devicetree@vger.kernel.org,
        linux@armlinux.org.uk, andrii@kernel.org,
        UNGLinuxDriver@microchip.com, john.fastabend@gmail.com,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org,
        kpsingh@kernel.org, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, kafai@fb.com, yhs@fb.com,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        Woojung.Huh@microchip.com
Subject: Re: [Patch net-next v13 07/13] net: dsa: microchip: add LAN937x SPI
 driver
Message-ID: <20220505151507.5fp3lur74gs4faee@skbuf>
References: <20220504151755.11737-1-arun.ramadoss@microchip.com>
 <20220504151755.11737-8-arun.ramadoss@microchip.com>
 <20220504200726.pn7y73gt7wc2dpsg@skbuf>
 <52e682a1bcd2aac1097f2b4f1948066fe5bb6924.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52e682a1bcd2aac1097f2b4f1948066fe5bb6924.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 05, 2022 at 10:32:17AM +0000, Arun.Ramadoss@microchip.com wrote:
> > >  static int lan937x_switch_init(struct ksz_device *dev)
> > >  {
> > > +     int ret;
> > > +
> > >       dev->ds->ops = &lan937x_switch_ops;
> > > 
> > > +     /* Check device tree */
> > > +     ret = lan937x_check_device_id(dev);
> > > +     if (ret < 0)
> > > +             return ret;
> > > +
> > 
> > Can't this be called from lan937x_spi_probe() directly, why do you
> > need
> > to go through lan937x_switch_register() first?
> 
> lan937x_check_device_id function compares the dev->chip_id with the
> lan937x_switch_chip array and populate the some of the parameters of
> struct ksz_dev. The dev->chip_id is populated using the dev->dev_ops-
> >detect in the ksz_switch_register function. If lan937x_check_device_id
> needs to be called in spi_probe, then chip_id has to be identified as
> part of spi_probe function. Since ksz_switch_register handles the
> identifying the chip_id, checking the device_id is part of switch_init.
>  
>  if (dev->dev_ops->detect(dev))
>              return -EINVAL;
>  
>  ret = dev->dev_ops->init(dev);
>  if (ret)
>             return ret;

Whatever you do, please use a common pattern for all of ksz9477, ksz8,
and your lan937x. This includes validation of chip id, placement of the
chip_data and dev_ops structures, and reuse as much logic as possible.
The key is to limit the chip-specific information to structured data
(tables) wherever possible and let common code deal with them.

For example there is no reason why struct ksz_chip_data is redefined for
every switch, why copying from "chip" to "dev" is duplicated for every
switch, and yet, why every other switch copies from "chip" to "dev" in
the "switch_init" function yet lan937x does it from "check_device_id".
So much boilerplate, yet different in subtle ways, makes the code very
unpleasant to review.

I'm sure you'll find a straightforward way to code up a probing function.

> As per the comment, enable_spi_indirect_access function called twice
> https://lore.kernel.org/netdev/20220408232557.b62l3lksotq5vuvm@skbuf/
> I have removed the enable_spi_indirect_access in the lan937x_setup
> function in v13 patch 6. But it actually failed our regression.
> The SPI indirect is required for accessing the Internal phy registers.
> We have enabled it in lan937x_init before registering the
> mdio_register. We need it for reading the phy id.
> And another place enabled in lan937x_setup after lan937x_switch_reset
> function. When I removed enabling in setup function, switch_reset
> disables the spi indirecting addressing. Because of that further phy
> register r/w fails. In Summary, we need to enable spi indirect access
> in both the places, one for mdio_register and another after
> switch_reset. 
> 
> Can I enable it both the places? Kindly suggest. 

So you call lan937x_reset_switch() as the first thing in ds->ops->setup(),
and this momentarily breaks the earlier MDIO bus setup done from probe
-> ksz_switch_register() -> dev_ops->init().

So why don't you move the lan937x_enable_spi_indirect_access() and
lan937x_mdio_register() calls to ds->ops->setup(), _after_ the switch
soft reset, then?
