Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5247F5F8167
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 02:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJHAAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 20:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJHAAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 20:00:23 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5354E633;
        Fri,  7 Oct 2022 17:00:20 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id r17so14394242eja.7;
        Fri, 07 Oct 2022 17:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVLnZqvhTBfdrD/rpbk8s88lKhxzuxRMhD6iuSoTzTM=;
        b=VLxjm/ZwMrut0hC++7v1tTJAnrNGKahiWLQBqfsd2W4jl8ikED+YZG44JDvqx0Zgrz
         v6lRpUHVIMISd7B/Aj0/1yWAc8BqBAwu+IKQ9CemkaNLT3GR4iZDeHogXu5SKfrWMTX+
         kiE6Mfxi/medNFcxkNBG0UmENEct0Y5VU2VGxtAQw/zW2UiyiMkfRjFWGlnh/se2H9Ow
         EK0vf2iS7Pt7DRoQykhc0MnNSsFX2UL0Un/ika0P45uFcygSVpNHWuDAw4wUmVAAE1/l
         f/Lb131/8dPXeTQ0E19YJv/aQCJIzRVAdSNIS7pzygqQkuhY5v4+VsUtY00Bfm7I8AT+
         2/Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVLnZqvhTBfdrD/rpbk8s88lKhxzuxRMhD6iuSoTzTM=;
        b=698r61SUk3yfo3k9qA4JujjX3GiMHgOnaM0HYQxEecaYhShWVBQJ3yhIgiCA2HSwDA
         KLFsLHNqda2WQlFUUK5cvOUn/LmgQYWb2yXmV6VEYZNhDk6KgTGlGEAF/JbuKsWJg4v4
         jkEMSsBAnGMf1rK5DCymRyTAPK0XP3UR0XzEIvEPlyDMjaDr16+iJRZEUbxutU4xaag0
         TCbp6av9qE0Gp9FRX6WLsF4/g1KxUFRC5Sx6hTUNJaVsWeYQ7pkFo/QJs2iZQ6cnsD2I
         o1KBn6mlNwQthmfVHK+Sgt7STMvLEMCSGbtXBVcDrl40WrKqf53k9zuo/la3zv6KCKZ2
         4fGA==
X-Gm-Message-State: ACrzQf1IuhOCZkSryvzdELH30V2ylMITrSVzHlD5RAB06Rcm7fE4Lyf1
        TGCafpnXQTzYM8pZUrHWgQs=
X-Google-Smtp-Source: AMsMyM5Rcptdf4eV1AtZvS8RHnOOeft9a4CH02/JzQgia/qPCzUEiKoiwmlr43qTEV96ulG7+aJvmw==
X-Received: by 2002:a17:907:2d8e:b0:783:8d26:645 with SMTP id gt14-20020a1709072d8e00b007838d260645mr5663741ejc.535.1665187218711;
        Fri, 07 Oct 2022 17:00:18 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906310a00b0078d01a38cc8sm1911884ejx.35.2022.10.07.17.00.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 17:00:17 -0700 (PDT)
Date:   Sat, 8 Oct 2022 03:00:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Message-ID: <20221008000014.vs2m3vei5la2r2nd@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 06:09:59PM +0200, Krzysztof Kozlowski wrote:
> >> I don't understand how your answer relates to "reg=<0 0>;". How is it
> >> going to become 0x71010000 if there is no other reg/ranges set in parent
> >> nodes. The node has only one IO address, but you say the switch has 20
> >> addresses...
> >>
> >> Are we talking about same hardware?
> > 
> > Yes. The switch driver for both the VSC7512 and VSC7514 use up to ~20 regmaps
> > depending on what capabilities it is to have. In the 7514 they are all
> > memory-mapped from the device tree. While the 7512 does need these
> > regmaps, they are managed by the MFD, not the device tree. So there
> > isn't a _need_ for them to be here, since at the end of the day they're
> > ignored.
> > 
> > The "reg=<0 0>;" was my attempt to indicate that they are ignored, but I
> > understand that isn't desired. So moving forward I'll add all the
> > regmaps back into the device tree.
> 
> You need to describe the hardware. If hardware has IO address space, how
> does it matter that some driver needs or needs not something?

What do you mean by IO address space exactly? It is a SPI device with registers.
Does that constitute an IO address space to you?

The driver need matters because you don't usually see DT nodes of SPI,
I2C, MDIO devices describing the address space of their registers, and
having child nodes with unit addresses in that address space. Only when
those devices are so complex that the need arises to identify smaller
building blocks is when you will end up needing that. And this is an
implementation detail which shapes how the dt-bindings will look like.

> You mentioned that address space is mapped to regmaps. Regmap is Linux
> specific implementation detail, so this does not answer at all about
> hardware.
>
> On the other hand, if your DTS design requires this is a child of
> something else and by itself it does not have address space, it would be
> understandable to skip unit address entirely... but so far it is still
> confusing, especially that you use arguments related to implementation
> to justify the DTS.

If Colin skips the unit address entirely, then how could he distinguish
between the otherwise identical MDIO controllers mdio@7107009c and
mdio@710700c0 from Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml?
The ethernet-switch node added here is on the same hierarchical level
with the MDIO controller nodes, so it must have a unit address just like
them.

But I don't support Colin's choice of "reg=<0 0>;" either. A choice must
be made between 2 options:
- mapping all 20 regions of the SPI address space into "reg" values
- mapping a single region from the smallest until the largest address of
  those 20, and hope nothing overlaps with some other peripheral, or
  worse, that this region will never need to be expanded to the left.

What information do you need to provide some best practices that can be
applied here and are more useful than "you need to describe the
hardware"? Verilog/VHDL is what the hardware description that's
independent of software implementation is, good luck parsing that.
