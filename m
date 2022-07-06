Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85468568CC2
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbiGFP33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232377AbiGFP32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:29:28 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E7413CFC
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 08:29:27 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id eq6so19735285edb.6
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 08:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fdjshnymZYrkhk6nFbxqJhMMz03n5UoY37ZB0yXg4vQ=;
        b=RznIoafXYhOSmK5+egCZNOvsHz0it9WrHSk3xjsuTWmCSRbslQNlh4pG9t7i/R59A/
         L171kr9CHc4QUvJjML77kXwti/P1rohfvtrxBQ2FY068noWZXOliIAYas8uQtkL/kQd2
         tLddNOoQphRtky1uFShKvk7Trox60KzgHoZMJ+NIgUyAMipsN2ns2OsHwZ+z4r3RF/rg
         o1ZXz9jGLyL9ofgYvgmeR/ZrnojL3KFL4eN/iMjn5ua3yPveOUMsDZJ9ZUw2eLxmYxFy
         UVYt9exUIKxxd+6jxb7803LEu0lAJLf2EdwW4j7+o2TEc9Kcu/ucesYG9hgSZAP2pdFD
         c+Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fdjshnymZYrkhk6nFbxqJhMMz03n5UoY37ZB0yXg4vQ=;
        b=pp725TO3lI9ChLVKf7Oe8jjPGfxhS12vOeBKWzLF262W3vNhB5a4ceJEZcjFKTZFGn
         XEnKZZJGNZ9biXoEmRXvk7uuKLlZxTiomDrC+ifFJIW6z+y0VZ/wKpPjgpnoOdoM6adv
         Rc7jMAp+zTB7FTv09aygU/d4JZTRDlIDnPnO77NziXnvPnvkvjZbaCOfAYcPA83uhFAJ
         fFvX3VhJZM5zurVxBbi4+viyrRF22bJ0/40InHBBSFn/dSCxRD2WaMMj1lChD4pTYI5i
         8eJZR9fqmT0BFw1JDWm9TUFJGm6VUhTBws/fA5E/4tn7Vq5eN+8EwG+8+p7wtwgcvcKt
         tbfg==
X-Gm-Message-State: AJIora9HtkViYM/k1rs6BkaeSujbDBE/5qmguyunTrWbT0w8r++fCsWo
        VZgE6bJBtfJmuCCHv2O1G/M=
X-Google-Smtp-Source: AGRyM1s1E2dudHQHIlJWFQR1vYxRcL8vf9K25Fd0cDxPTyIs4VMNa7FoF2eb3IiSaVLPy2yaNIBQOw==
X-Received: by 2002:aa7:cdcd:0:b0:43a:31e:114 with SMTP id h13-20020aa7cdcd000000b0043a031e0114mr30935709edw.231.1657121366090;
        Wed, 06 Jul 2022 08:29:26 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id v9-20020a170906292900b00722e50dab2csm819561ejd.109.2022.07.06.08.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 08:29:25 -0700 (PDT)
Date:   Wed, 6 Jul 2022 18:29:23 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
Message-ID: <20220706152923.mhc7vw7xkr7xkot4@skbuf>
References: <20220629035434.1891-1-luizluca@gmail.com>
 <CAJq09z44SNGFkCi_BCpQ+3DuXhKfGVsMubRYE7AezJsGGOboVA@mail.gmail.com>
 <20220629181455.boerjnqmvovmtzra@bang-olufsen.dk>
 <CAJq09z6iX9s75Y2G46V_CEMiAk2PSGW6fF4t4QSPbjEXgs1iTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJq09z6iX9s75Y2G46V_CEMiAk2PSGW6fF4t4QSPbjEXgs1iTQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 02:05:39PM -0300, Luiz Angelo Daros de Luca wrote:
> > Hi Luiz,
> >
> > On Wed, Jun 29, 2022 at 01:43:45PM -0300, Luiz Angelo Daros de Luca wrote:
> > > This RFC patch series cleans realtek-smi custom slave mii bus. Since
> > > fe7324b932, dsa generic code provides everything needed for
> > > realtek-smi driver. For extra caution, this series should be applied
> > > in two steps: the first 2 patches introduce the new code path that
> > > uses dsa generic code. It will show a warning message if the tree
> > > contains deprecated references. It will still fall back to the old
> > > code path if an "mdio"
> > > is not found.
> >
> > In principle I like your changes, but I'm not sure if what you are doing
> > is allowed, since DT is ABI. The fact that you have to split this into
> > two steps, with the first step warning about old "incompatible" DTs
> > (your point 3 below) before the second step breaks that compatibility,
> > suggests that you are aware that you could be breaking old DTs.
> 
> Thanks Alvin for your review. Yes, that is a good question for the ML.
> I don't know at what level we can break compatibility (DT and driver).
> That's why it is a RFC.

DT bindings are only extended in backwards-compatible ways. Only in the
case where you can prove that there is no DT user of a certain binding,
and that none should appear either, is when you can consider breaking
the backward compatibility. The idea here is that old DT blobs may live
forever and be provided by fixed firmware such as U-Boot, you can't
really force anyone to update them.

> > I'm not going to argue with you if you say "but the node with compatible
> > realtek,smi-mdio was also called mdio in the bindings, so it shouldn't
> > break old DTs", which is a valid point. But if that is your rationale,
> > then there's no need to split the series at all, right?
> 
> The DT requires "realtek,smi-mdio" but also mentions the "mdio" name,
> not a generic name as "mdioX". If we agree that the name "mdio" is
> already required by the DT bindings, it is the driver implementation
> that is not compliant. Even if we are not violating the DT bindings,
> we are changing the driver behavior. That's why I suggested the
> transition process. I do believe that it would be very, very rare to
> name that mdio as anything other than "mdio" and even the driver
> itself is too fresh to be widespread. In a non-RFC series, I would
> also drop the "realtek,smi-mdio" compatible string from the bindings
> (as it is back compatible).

Technically the MDIO node should be named "mdio", at least that's what
Documentation/devicetree/bindings/net/mdio.yaml says, that it should be
"mdio" or "mdio@something". And since the #address-cells of the DSA
switch OF node itself (parent of MDIO node) is 0, it can't really be
"mdio@something", so that leaves us with "mdio".

However I don't think there is any validation for the node name.

> > If you want to avoid that debate, what you could do instead is add a
> > const char *slave_mii_compatible; member to struct dsa_switch, and try
> > searching in dsa_switch_setup() for a child node with that compatible if
> > the lookup of a node named "mdio" fails. I don't know if this would help
> > you do the same thing with other drivers.
> 
> The DSA change to accept "mdio" was an improvement to avoid adding a
> custom slave mdio when you already have a single mdio and just need to
> point to a DT node. Adding compatible strings for that situation does
> not make much sense as a compatible string is not necessary when you
> are already restricting your case to a single mdio. For more complex
> setups, you still need to create your own slave mdio implementation.
> Some drivers already depend on the "mdio" name and this series is also
> a suggestion for them to try their drivers dropping their custom slave
> mdio implementations.

I think we are going down a slippery slope here. DSA providing generic
code to register an MDIO bus is not something I'd consider core
functionality, and I don't consider any duplication of concerns or logic
if drivers register their own MDIO buses.

Here you are effectively proposing to gratuitously break the DT binding,
the obvious question is, what is there to even gain from this?

And why do you even need to remove the compatible string from the MDIO
node, can't you just ignore it, does it bother you in any way?
