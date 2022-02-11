Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555C34B1D76
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 05:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243255AbiBKEvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 23:51:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiBKEv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 23:51:29 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA87925D7
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 20:51:28 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id om7so7058334pjb.5
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 20:51:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NMbzTqJrDqGpOFAAKJnNQblqTURe9wfjfX/4YXj+su0=;
        b=qL7aUORypvezD1gu1u0kUvUwgm/BTW9/qRLiPi5dcX8p3JA4J3ERA+pcPyYKvpm7iL
         n0deWCpu+KINb9JtccR9cQ+DXKJKdiFgc6q8qCkE6Uev0vXIpqa5Dlw9z0YqcK+iDfFh
         16qp16Zisw5T6sB2ZPHplTbhS6G4PdFV3UN5mUV/Rqf+1HvyhtyxYdmDdr2WrRmQIQTg
         zpCNJsK+rOaAQn7me4t/ieVlf7hyTaIwst2VEqbjgHokKC72hbYNKW1kK7mqjp76axBU
         EHBoMpzu5sdoptPXWCig57tif4HnDSw5SvSafZDDO0jZYP0MlXDVXeDv7gPKobbjiz+P
         15Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NMbzTqJrDqGpOFAAKJnNQblqTURe9wfjfX/4YXj+su0=;
        b=Jh8cCRXzNRCH7l5oA/2WS0YYdkDf5j6u3Qn03cOX7wqKM70KBCA8GUdjtREAyquLP7
         3be9kYsYiEG2ZlgR48EczhhN5EK9IwFmzO7CSA1Ar4SKS2M4QAZwmtusqYXTxFaweV/O
         gc+UQOUE6haHw+CbbBot1l2Kwjf9s9+P0VG0PXo/VEWeSMaNMCn3Z3b2qP+ig7U+3DMB
         Y3kQ5UxoblNAWZe+V6Rl1qlR0+h1Lb/NRyqa7A2CsYo7ER8I7XKQG5lvGfDqWCCE0xSg
         +Mrkgfi4H0ARubmEnKMQV2KoWUkYFJwqh0oo5wMMf+sXELLgtMAxzrZr0keMOdGf5zwb
         srNA==
X-Gm-Message-State: AOAM53242MIuPw0gNWjwEBshY9oEQpMvyc5OZ4lgFVxn8cDqChL9lI2Z
        7/mzcc2553EJaPZoILKfUd776VFrcijBXReK9jI=
X-Google-Smtp-Source: ABdhPJwQDw/xslKAczJ/M7WLycAKbqiVs0mQVOCqAqwN4Qo1cR6mynPhGU+XGGWfCgibv82KK9s7kKsYR5eGHX5pjfY=
X-Received: by 2002:a17:902:cec5:: with SMTP id d5mr22800plg.143.1644555088259;
 Thu, 10 Feb 2022 20:51:28 -0800 (PST)
MIME-Version: 1.0
References: <20220209224538.9028-1-luizluca@gmail.com> <4b53b688-3769-c378-ec35-3286b3229303@gmail.com>
 <CAJq09z7QJ9qXteGMFCjYOVanu7iAP6aNO3=5a8cjYMAe+7TQfQ@mail.gmail.com> <878ruil1ud.fsf@bang-olufsen.dk>
In-Reply-To: <878ruil1ud.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Fri, 11 Feb 2022 01:51:16 -0300
Message-ID: <CAJq09z7Hu-dswU41km=L2YFbKyHUJ9JkDjUGwQN5RQqowY0=1A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: rtl8365mb: irq with realtek-mdio
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Alvin,

> > As far as I know, for supported models, yes. I'm not sure about models
> > rtl8363nb and rtl8364nb because they have only 2 user ports at 1 and
> > 3.
> > Anyway, they are not supported yet.
>
> I think the port number as defined in the device tree is always going to
> be the same as its PHY address on the internal bus. I had a look at the
> Realtek code and this seems to be the assumption there too.

One of the realtek-smi.txt examples (that I also copied to
realtek.yaml) does not respect that:

phy4: phy@4 {
   reg = <4>;
   interrupt-parent = <&switch_intc>;
   interrupts = <12>;
};

I don't know if 12 is a typo here.

It would only matter if I do create a default association when the
specific device tree-entry is missing. It wasn't supposed to
completely remove the device-tree declaration but to make it optional.
For now, I'll put this option aside.

> >> We could also change the DSA framework's way of creating the
> >> MDIO bus so as to be OF-aware.

It worked like a charm. I'll send it in reply to this email. I still
have some questions about it.

> We are not the only ones doing this. mv88e6xxx is another example. So
> Florian's suggestion seems like a good one, but we should be careful to
> maintain compatibility with older device trees. In some cases it is
> based on child node name (e.g. "mdio"), in others it is based on the
> child node compatible string (e.g. "realtek,smi-mdio",
> "marvell,mv88e6xxx-mdio-external").

The name "mdio" seems to be the de facto name. I'll use it. However,
it might be confusing with mdio-connected switches as you'll have an
mdio inside a switch inside another mdio. But it is exactly what it
is.

It would not affect drivers that are already allocating slave_mii_bus
by themselves. If the driver is fine with that, that's the end of the
case.

However, if a driver doesn't need any special properties inside the
mdio node, it might want to migrate to the default dsa slave_mii_bus.
For those already using "mdio" node name, they just need to drop their
code and move phy_read/write to dsa_switch_ops. Now, those using
different node names (like when they check the compatible strings)
will have a little more job. I believe we cannot rename a node "on the
fly". So, if the matched node name is not mdio, they still need to
allocate the slave_mii_bus. They will also need a different
dsa_switch_ops for each case because dsa_switch_ops->phy_read cannot
coexist with an externally allocated slave_mii_bus. Each driver needs
to plan their own migration path if they want to migrate.

For realtek-smi, the code does not require the node to be named "mdio"
but doc "realtek-smi.txt" and my new "realtek.yaml" does require it.
If I assume that, I could simply drop the code and migrate to
read/write to dsa_switch_ops.
If not, we need to maintain both code paths and warn the user for a
couple of releases until we drop the compatible string match.

> > If possible, I would like to define safe default values (like assuming
> > 1:1 mapping between the port number and its PHY address) for this
> > driver when interrupt-controller is present but
> > slave_mii_bus node is missing.
>
> You could just require the phy nodes to be described in the device
> tree. Then you don't need this extra port_setup code. Seems better IMO,
> or am I missing something?

Upstream devs seem to prefer more code than more device-tree confs. I
just wanted to reduce some device-tree copy/paste. I'm ok with using a
device-tree node.

---
Luiz
