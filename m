Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711DF5F810B
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 01:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJGXKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 19:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiJGXKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 19:10:18 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7099B6685C;
        Fri,  7 Oct 2022 16:10:15 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id b2so14291298eja.6;
        Fri, 07 Oct 2022 16:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Ff2Jx6NqQG39IX2GQ6H1L2VLrUXyrTBZ4zR3/wpS5c=;
        b=TQ5hNUCStSck7y6p1Whdcoa73KeayH7AuFrs4Vax9jNIbKtGXCBkCEef+hIQ6xnu6w
         aY6IcLczj5cWmILYkbZMZaw6BHtJhX2V8pDIHgxKM1RCwqIWlJ6tztZ+WHlvDEn4BbOF
         4BehIlne49rE5evLVCO4K6HEIE6T82rct3LWJ4v4FWAdYL7dtxuWU7GHfd3EGTZ0rIJd
         QiMBMCxMdf1KlekypSIKA9AqbHlSHjBwglLu93SNbeCKQT3cHDSyNB60YyHvYAk7Kkiy
         aQGHJkPQhA20ArdgC6nmOEzUQn/wlcvveoO0fUq86m528h50e1qBUJEhMuMLTpfmMtCh
         padQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ff2Jx6NqQG39IX2GQ6H1L2VLrUXyrTBZ4zR3/wpS5c=;
        b=7KtqB7u6rZyMXOrE20nHvO9nkLIHuKEoFYYyHeSMWNrO5ZDeKmJvxcyuVNtl+gpfrb
         Q1jSAJuplmro0uiEAVcXHjQLe362R7x2HsK6F9Ee+JGCCnitr4POIxgDq2bWR6fBr6bJ
         ulu17P2WBdONpPSnyHZlF194juVD52d6u8YDrdDcn0yx7ZXqP44WqaoEzF3RqfEeRooY
         fRlVhfKywDwl4tYdngAEwoiaXtWQpdBOCLBfvp6nlaFH94sFlRNPBT3F4obTffdOaER4
         15cqSU9dgBORxF+CnhNjMn37PJs9JVa2boOqZHrV3GYv0nfMH+TniwIj9D1A/0de98T3
         ki5A==
X-Gm-Message-State: ACrzQf2nhXbgBs+/AGjk4+D5d6uXBPZ9MJOGKZm+C+4x7Nrkpi5ZRdI7
        Bcy0ch6bm9SaD+koQGbpEVk=
X-Google-Smtp-Source: AMsMyM66DYwy3KBDvU1hRrO+OD2oPJcipG0iAaxGdBoANV2842BWfe3qlyxCBJ8EjIHQNyZFVsfo6Q==
X-Received: by 2002:a17:907:3da2:b0:78d:3b45:11d9 with SMTP id he34-20020a1709073da200b0078d3b4511d9mr5812419ejc.87.1665184213952;
        Fri, 07 Oct 2022 16:10:13 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id p17-20020a17090653d100b0078d175d6dc5sm1815909ejo.201.2022.10.07.16.10.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 16:10:12 -0700 (PDT)
Date:   Sat, 8 Oct 2022 02:10:09 +0300
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
Message-ID: <20221007231009.qgcirfezgib5vu6y@skbuf>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <20221004121517.4j5637hnioepsxgd@skbuf>
 <6444e5d1-0fc9-03e2-9b2a-ec19fa1e7757@linaro.org>
 <20221004160135.lqugs6cf5b7fwkxq@skbuf>
 <cae8e149-ef1e-66c6-20f5-067e3fd8c586@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cae8e149-ef1e-66c6-20f5-067e3fd8c586@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 10:09:06AM +0200, Krzysztof Kozlowski wrote:
> > The /spi/soc@0 node actually has a compatible of "mscc,vsc7512" which
> > Colin did not show in the example (it is not "simple-bus"). It is covered
> > by Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml. Still waiting
> > for a better suggestion for how to name the mfd container node.
> 
> Then still the /spi node does not seem related. If I understand
> correctly, your device described in this bindings is a child of soc@0.
> Sounds fine. How that soc@0 is connected to the parent - via SPI or
> whatever - is not related to this binding, is it? It is related to the
> soc binding, but not here.

It's an example, it's meant to be informative. It is the first DSA
driver of its kind. When everybody else ATM puts the ethernet-switch node
under the &spi controller node, this puts it under &spi/soc@<chip-select>/,
for reasons that have to do with scalability. If the examples aren't a
good place to make this more obvious, I don't know why we don't just
tell people to RTFD.

> > Unrelated to your "existing soc example" (the VSC9953), but relevant and
> > you may want to share your opinion on this:
> > 
> > The same hardware present in the VSC7514 SoC can also be driven by an
> > integrated MIPS processor, and in that case, it is indeed expected that
> > the same dt-bindings cover both the /soc and the /spi/soc@0/ relative
> > positioning of their OF node. This is true for simpler peripherals like
> > "mscc,ocelot-miim", "mscc,ocelot-pinctrl", "mscc,ocelot-sgpio". However
> > it is not true for the main switching IP of the SoC itself.
> > 
> > When driven by a switchdev driver, by the internal MIPS processor (the
> > DMA engine is what is used for packet I/O), the switching IP follows the
> > Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml binding
> > document.
> > 
> > When driven by a DSA driver (external processor, host frames are
> > redirected through an Ethernet port instead of DMA controller),
> > the switching IP follows the Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> > document.
> > 
> > The switching IP is special in this regard because the hardware is not
> > used in the same way. The DSA dt-binding also needs the 'ethernet'
> > phandle to be present in a port node. The different placement of the
> > bindings according to the use case of the hardware is a bit awkward, but
> > is a direct consequence of the separation between DSA and pure switchdev
> > drivers that has existed thus far (and the fact that DSA has its own
> > folder in the dt-bindings, with common properties in dsa.yaml and
> > dsa-port.yaml etc). It is relatively uncommon for a switching IP to have
> > provisioning to be used in both modes, and for Linux to support both
> > modes (using different drivers), yet this is what we have here.
> 
> Is there a question here to me? What shall I do with this paragraph? You
> know, I do not have a problem of lack of material to read...

For mscc,vsc7514-switch we have a switchdev driver. For mscc,vsc7512-switch,
Colin is working on a DSA driver. Their dt-bindings currently live in
different folders. The mscc,vsc7514-switch can also be used together
with a DSA driver, and support for that will inevitably be added. When
it will, how and where do you recommend the dt-bindings should be added?
In net/dsa/mscc,ocelot.yaml, together with the other switches used in
DSA mode, or in net/mscc,vsc7514-switch.yaml, because its compatible
string already exists there? We can't have a compatible string present
in multiple schemas, right?

This matters because it has implications upon what Colin should do with
the mscc,vsc7512-switch. If your answer to my question is "add $ref: dsa.yaml#
to net/mscc,vsc7514-switch.yaml", then I don't see why we wouldn't do
that now, and wait until the vsc7514 to make that move anyway.
