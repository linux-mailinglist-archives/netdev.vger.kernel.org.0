Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472DC5F4712
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiJDQBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 12:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiJDQBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 12:01:42 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755CA60516;
        Tue,  4 Oct 2022 09:01:41 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id lt21so4572758ejb.0;
        Tue, 04 Oct 2022 09:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=076ekeHJUtZKNndz+8U+ypVvYOOKrZP8Jb4VjdyaYAQ=;
        b=af5TChXiZkuIToJtLSEBIu5Y/R4iXMbvgCQAChrVYn3cTih55NaV382oZh+1lMiBe3
         /zNwALDW8izkK2QR2A5MYtUiIzNjzzzFxRLjLLvdJD76hwNKgwy3vwqkdQ0UaeDyuqwv
         Pv8dScDP/9Riqa4JnDH5R3YmBum2dMkueh7eqWNoRbuJuacgjDLvqV7LcQQOhkEsV/p/
         IlJva5YocHABa2+FZDh+X5J927uY3AA6Pdjp9XIZcVpISc6H+vtnOLU+oJZPrPpDs61p
         iZJ6Ot+U6M4/mPuF1CGciqaGAZcDC8x+kHLVLB4kFwTANPF7xELYa+CzxISMQKmZTDxi
         hBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=076ekeHJUtZKNndz+8U+ypVvYOOKrZP8Jb4VjdyaYAQ=;
        b=NUTvuLQYigcdeFO3024gB28/REcpd4nXDPUrxEmftba5ot9IwgL39vMbxssbPJjKjE
         QASWXJZzOKvqJVqR0by3IrNDGHVQTeE4phhHtTSC2DykPJ292kIRfeb9hGlnB68tXW7t
         JL0cidYiUX2Z21NPQHMHxERyZoDlXs7rz/v1KiBrbfV3rWzV8aUjFIO+JBb/ThTLKmA7
         ac5vdDZ+qy+TjOamyJ7W/LbrPOU+wp+ZluqZrcQpMGZMcrhUzoBWuELfkMV+q5zJFYYK
         Svb3ASsUqDwyMVBbgbR3YkZ4vCTzCu0tv6k4Ey44oF93h5rtIhVNyUbuGi9t1t3WSlHI
         TMfA==
X-Gm-Message-State: ACrzQf3PvAa/9YWhoWK618RrhY5dqjxwPe7WXnfZG1XZZhsVYbwLhHyp
        3QHfc3DcERhHpaLPbXJ+SKA=
X-Google-Smtp-Source: AMsMyM4w8EA2+e/n3OuyrWeefhpZ+GCI9s+iwq00tHzWVmv5+UqHGkt/in9s6F+5Eq+7srB5ogJAlA==
X-Received: by 2002:a17:907:c03:b0:781:fd5a:c093 with SMTP id ga3-20020a1709070c0300b00781fd5ac093mr19438336ejc.89.1664899299783;
        Tue, 04 Oct 2022 09:01:39 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b24-20020a50ccd8000000b0044657ecfbb5sm1981806edj.13.2022.10.04.09.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 09:01:38 -0700 (PDT)
Date:   Tue, 4 Oct 2022 19:01:35 +0300
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
Message-ID: <20221004160135.lqugs6cf5b7fwkxq@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <20221004121517.4j5637hnioepsxgd@skbuf>
 <6444e5d1-0fc9-03e2-9b2a-ec19fa1e7757@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6444e5d1-0fc9-03e2-9b2a-ec19fa1e7757@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 04, 2022 at 04:59:02PM +0200, Krzysztof Kozlowski wrote:
> On 04/10/2022 14:15, Vladimir Oltean wrote:
> > On Tue, Oct 04, 2022 at 01:19:33PM +0200, Krzysztof Kozlowski wrote:
> >>> +  # Ocelot-ext VSC7512
> >>> +  - |
> >>> +    spi {
> >>> +        soc@0 {
> >>
> >> soc in spi is a bit confusing.
> > 
> > Do you have a better suggestion for a node name? This is effectively a
> > container for peripherals which would otherwise live under a /soc node,
> 
> /soc node implies it does not live under /spi node. Otherwise it would
> be /spi/soc, right?

Did you read what's written right below? I can explain if you want, but
there's no point if you're not going to read or ask other clarification
questions.

> > if they were accessed over MMIO by the internal microprocessor of the
> > SoC, rather than by an external processor over SPI.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The /spi/soc@0 node actually has a compatible of "mscc,vsc7512" which
Colin did not show in the example (it is not "simple-bus"). It is covered
by Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml. Still waiting
for a better suggestion for how to name the mfd container node.

> >> How is this example different than previous one (existing soc example)?
> >> If by compatible and number of ports, then there is no much value here.
> > 
> > The positioning relative to the other nodes is what's different.
> 
> Positioning of nodes is not worth another example, if everything else is
> the same. What is here exactly tested or shown by example? Using a
> device in SPI controller?

Everything is not the same, it is not the same hardware as what is currenly
covered by Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml.
The "existing soc example" (mscc,vsc9953-switch) has a different port
count, integration with a different SERDES, interrupt controller, pin
controller, things like that. The examples already differ in port count
and phy-mode values, I expect they will start diverging more in the
future. If you still believe it's not worth having an example of how to
instantiate a SPI-controlled VSC7512 because there also exists an
example of an MMIO-controlled VSC9953, then what can I say.

------ cut here ------

Unrelated to your "existing soc example" (the VSC9953), but relevant and
you may want to share your opinion on this:

The same hardware present in the VSC7514 SoC can also be driven by an
integrated MIPS processor, and in that case, it is indeed expected that
the same dt-bindings cover both the /soc and the /spi/soc@0/ relative
positioning of their OF node. This is true for simpler peripherals like
"mscc,ocelot-miim", "mscc,ocelot-pinctrl", "mscc,ocelot-sgpio". However
it is not true for the main switching IP of the SoC itself.

When driven by a switchdev driver, by the internal MIPS processor (the
DMA engine is what is used for packet I/O), the switching IP follows the
Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml binding
document.

When driven by a DSA driver (external processor, host frames are
redirected through an Ethernet port instead of DMA controller),
the switching IP follows the Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
document.

The switching IP is special in this regard because the hardware is not
used in the same way. The DSA dt-binding also needs the 'ethernet'
phandle to be present in a port node. The different placement of the
bindings according to the use case of the hardware is a bit awkward, but
is a direct consequence of the separation between DSA and pure switchdev
drivers that has existed thus far (and the fact that DSA has its own
folder in the dt-bindings, with common properties in dsa.yaml and
dsa-port.yaml etc). It is relatively uncommon for a switching IP to have
provisioning to be used in both modes, and for Linux to support both
modes (using different drivers), yet this is what we have here.
