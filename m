Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F36D25620CF
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiF3RFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbiF3RFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:05:51 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E87396BA
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 10:05:50 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id t21so58007pfq.1
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 10:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2DzZyyP+EHdUM11CQ9+2xsAsuhYBRgZ3iiVCJqkHWJ4=;
        b=NiyJpXMiZ8M0DhCXGQZfnAaX/3y0+PsO1idlGFN84TRLQDL/HhIyHDJYx3RLyRXUfF
         L+nuZB/ZSkefvq3caiZ7+NGTvA2b25Pe/IfuzFMpMYAVft3V73PrzLDILYbSB9Qw45bD
         BtZqQG0jtZNKETpfWZ1Xe7s+90R0Z0/v7FA2Nu9PfQ+MCopVgxhyb1JOl1wcnuqsglVB
         WPlKQiB3zKXMJOez6udGZ7WrX/3/EVsAN/0s4xc0sKtwx+6B8HB2r1bBMz4teCtXH2do
         5Y1xALP9xmfT5bHqCddQC6QDT5XHvheWMnUSMKjZojzvhzwwNvjgu47UcwpQoltD9GF9
         qebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2DzZyyP+EHdUM11CQ9+2xsAsuhYBRgZ3iiVCJqkHWJ4=;
        b=IHo/1u+KGAJsurwVY2cF2GeByOXkx/WQ3YC0UcmK2U+xLsR6OgMcNd/08bkkYH0RO/
         KsxkGVcus3PSnlmB/VZjJzKeQd3Hoq/phABtIKbGe4b+7SnJ0/OR4qUPkhKoqDjtEDBz
         F099BNUpgbNRUOqHXQ43sxxcAup+djkNoeBtdzKr0rN6ylyHMP334/0HdleZ/+Azv9k0
         tKdYWMlE1NjTgZ10UzT0/BG9DxDqYYBdeaOmfkbFGGtTr4cdR/mpzD0Asv1arh2Y3G/y
         gM4vKpPjuq2VZ2KaDHuOoUagSZ/n1OJnhqX/dmFZmrhY56xrJWLa9/fIh79vpbH9de4T
         xpNw==
X-Gm-Message-State: AJIora9v/5/QKfFnB8u4oOM/00gVxY3BZ5TRbRzhPbFBbnp4wKXikT42
        iHmQTy73dl/HWZzRqSskWHDAoUUwukMzUeLWG4g=
X-Google-Smtp-Source: AGRyM1tiwdTAh5LDHVgaC8tUJO5lPDvJZgI0nfWRoGZF6OUHiy8ta9JXln6N3tkVfUQfN+cSyB+rkHuVm+AqEk8gIbw=
X-Received: by 2002:a62:aa10:0:b0:525:22bb:b028 with SMTP id
 e16-20020a62aa10000000b0052522bbb028mr15655873pff.21.1656608750184; Thu, 30
 Jun 2022 10:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220629035434.1891-1-luizluca@gmail.com> <CAJq09z44SNGFkCi_BCpQ+3DuXhKfGVsMubRYE7AezJsGGOboVA@mail.gmail.com>
 <20220629181455.boerjnqmvovmtzra@bang-olufsen.dk>
In-Reply-To: <20220629181455.boerjnqmvovmtzra@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Thu, 30 Jun 2022 14:05:39 -0300
Message-ID: <CAJq09z6iX9s75Y2G46V_CEMiAk2PSGW6fF4t4QSPbjEXgs1iTQ@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
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

> Hi Luiz,
>
> On Wed, Jun 29, 2022 at 01:43:45PM -0300, Luiz Angelo Daros de Luca wrote:
> > This RFC patch series cleans realtek-smi custom slave mii bus. Since
> > fe7324b932, dsa generic code provides everything needed for
> > realtek-smi driver. For extra caution, this series should be applied
> > in two steps: the first 2 patches introduce the new code path that
> > uses dsa generic code. It will show a warning message if the tree
> > contains deprecated references. It will still fall back to the old
> > code path if an "mdio"
> > is not found.
>
> In principle I like your changes, but I'm not sure if what you are doing
> is allowed, since DT is ABI. The fact that you have to split this into
> two steps, with the first step warning about old "incompatible" DTs
> (your point 3 below) before the second step breaks that compatibility,
> suggests that you are aware that you could be breaking old DTs.

Thanks Alvin for your review. Yes, that is a good question for the ML.
I don't know at what level we can break compatibility (DT and driver).
That's why it is a RFC.

> I'm not going to argue with you if you say "but the node with compatible
> realtek,smi-mdio was also called mdio in the bindings, so it shouldn't
> break old DTs", which is a valid point. But if that is your rationale,
> then there's no need to split the series at all, right?

The DT requires "realtek,smi-mdio" but also mentions the "mdio" name,
not a generic name as "mdioX". If we agree that the name "mdio" is
already required by the DT bindings, it is the driver implementation
that is not compliant. Even if we are not violating the DT bindings,
we are changing the driver behavior. That's why I suggested the
transition process. I do believe that it would be very, very rare to
name that mdio as anything other than "mdio" and even the driver
itself is too fresh to be widespread. In a non-RFC series, I would
also drop the "realtek,smi-mdio" compatible string from the bindings
(as it is back compatible).

> If you want to avoid that debate, what you could do instead is add a
> const char *slave_mii_compatible; member to struct dsa_switch, and try
> searching in dsa_switch_setup() for a child node with that compatible if
> the lookup of a node named "mdio" fails. I don't know if this would help
> you do the same thing with other drivers.

The DSA change to accept "mdio" was an improvement to avoid adding a
custom slave mdio when you already have a single mdio and just need to
point to a DT node. Adding compatible strings for that situation does
not make much sense as a compatible string is not necessary when you
are already restricting your case to a single mdio. For more complex
setups, you still need to create your own slave mdio implementation.
Some drivers already depend on the "mdio" name and this series is also
a suggestion for them to try their drivers dropping their custom slave
mdio implementations.

> Btw, I think the first patch in the series is kind of pointless. You can
> just do the rename of ds_ops_mdio to ds_ops in the last patch, adding
> your justification in the commit message: "while we're at it, rename
> ds_ops_mdio etc...".

As a RFC, I'm trying to split each change in such a way they can be
merged individually. I believe that the new names make it clearer why
we have two structures. Even if the idea behind this series did not
get accepted, that first patch might be useful for someone reading the
driver for the first time.

Regards,

>
> Kind regards,
> Alvin
>
> >
> > >
> > > The last patch cleans all the deprecated code while keeping the kernel
> > > messages. However, if there is no "mdio" node but there is a node with
> > > the old compatible stings "realtek,smi-mdio", it will show an error. It
> > > should still work but it will use polling instead of interruptions.
> > >
> > > My idea, if accepted, is to submit patches 1 and 2 now. After a
> > > reasonable period, submit patch 3.
> > >
> > > I don't have an SMI-connected device and I'm asking for testers. It
> > > would be nice to test the first 2 patches with:
> > > 1) "mdio" without a compatible string. It should work without warnings.
> > > 2) "mdio" with a compatible string. It should work with a warning asking
> > > to remove the compatible string
> > > 3) "xxx" node with compatible string. It should work with a warning
> > > asking to rename "xxx" to "mdio" and remove the compatible string
> > >
> > > In all those cases, the switch should still keep using interruptions.
> > >
> > > After that, the last patch can be applied. The same tests can be
> > > performed:
> > > 1) "mdio" without a compatible string. It should work without warnings.
> > > 2) "mdio" with a compatible string. It should work with a warning asking
> > > to remove the compatible string
> > > 3) "xxx" node with compatible string. It should work with an error
> > > asking to rename "xxx" to "mdio" and remove the compatible string. The
> > > switch will use polling instead of interruptions.
> > >
> > > This series might inspire other drivers as well. Currently, most dsa
> > > driver implements a custom slave mii, normally only defining a
> > > phy_{read,write} and loading properties from an "mdio" OF node. Since
> > > fe7324b932, dsa generic code can do all that if the mdio node is named
> > > "mdio".  I believe most drivers could simply drop their slave mii
> > > implementations and add phy_{read,write} to the dsa_switch_ops. For
> > > drivers that look for an "mdio-like" node using a compatible string, it
> > > might need some type of transition to let vendors update their OF tree.
> > >
> > > Regards,
> > >
> > > Luiz
> > >
> >
> > I might have forgotten to add a new line after the subject. It ate the
> > first paragraph. I'm top-posting it.
> >
> > Regards,
> >
> > Luiz
