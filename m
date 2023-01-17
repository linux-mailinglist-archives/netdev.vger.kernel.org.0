Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F4366E606
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 19:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbjAQScH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 13:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbjAQSah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 13:30:37 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D18B39CE3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:01:28 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id v17so5256109oie.5
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 10:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bc4HH8wLLn6R3Oilqb4e8+1SbIPrlAa0QQfg12ZrZs=;
        b=pbx0Tgwf4mH7q9k59cNhZH4hjrD52u7p7F6cKIcinUWF2lxDNeOdlmMHIlBDGtEaaR
         GjLj/WaJs3f29Y6ZwQVIqpeEYxgx/dAWsTRBG3h43We4D7nCwLXSEuNYdHWebAjyMJci
         60Whwq3+BGdC4O3FriBPhisSVQDmK1jwhJS80jut56sKYIhzNmtsRFDCawFmKJf+XgfB
         +t/FeqFXMG+6c+tzvkVcJbtEIg4U2/eB6dCqQ+NXmB4qYzshsxawPoqWqdCWfKtvZgdC
         Yy460lMVcnGAw/H56ZXxaVlrO/f11wXoeYPXzj8hLV/+7JR4eYFeZHvDP1fAZEsl3kXV
         Nmbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bc4HH8wLLn6R3Oilqb4e8+1SbIPrlAa0QQfg12ZrZs=;
        b=W7+9k32Pl/DTgwIAnCzYyGj1lTkaz6Q5TIn6PsDeXKEOLvNmV+i+VEflZoQ5fmynty
         dM3vuZaFuej3Tj/Q+nwbnbwf5Lo4MBdYscm/uHXkFi0L1KyebxkoYWTXITB75Uxu6NA/
         wRTqKzwkGHLiI3hN1P5KbC7yG4duDyldZ1ih80rv+5GK2/y/TJwxUHcNvT84rwogkIy4
         IpmGqPfDk7fZCJ0EunAF5rwNbeF0/Pfa70j8v3dn7c2gaFmx8sa4EIs5K+aaSuXoxwbh
         LuvXTVpidB3U0Srh603nJw5HYvURqYrSDw4dVpKy2jahFj7LAhmRBa4y6/5MJUz4RWY7
         oavw==
X-Gm-Message-State: AFqh2kogDLSvJaenpkG0pobYyKn90QEucaRmJy1RPwefZxe2WOHGIHUN
        oPKC3HPY2KYoShWzxCWXZhUhiy3CmldegXpErK6Y9A==
X-Google-Smtp-Source: AMrXdXt/smakKDlhF1dsjQk8jEd8B2AEaeFU0TbuUPk6cOkfp60MGAqgtCGwcN/FUEDa/S61/rN9fNov5CNTV3vGN60=
X-Received: by 2002:a05:6808:124f:b0:35e:18a6:10ea with SMTP id
 o15-20020a056808124f00b0035e18a610eamr265907oiv.239.1673978487199; Tue, 17
 Jan 2023 10:01:27 -0800 (PST)
MIME-Version: 1.0
References: <20230116173420.1278704-1-mw@semihalf.com> <20230116173420.1278704-3-mw@semihalf.com>
 <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk> <20230116181618.2iz54jywj7rqzygu@skbuf>
 <Y8XJ3WoP+YKCjTlF@lunn.ch> <CAPv3WKc8gfBb7BDf5kwyPCNRxmS_H8AgQKRitbsqvL7ihbP1DA@mail.gmail.com>
 <20230117163453.o7pv7cdvgeobne4b@skbuf>
In-Reply-To: <20230117163453.o7pv7cdvgeobne4b@skbuf>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 17 Jan 2023 19:01:20 +0100
Message-ID: <CAPv3WKewRYwgTvNWYMdxwZvJfgj3__H3GYiKu__DHQf0fJPLEw@mail.gmail.com>
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API to fwnode_
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hkallweit1@gmail.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

wt., 17 sty 2023 o 17:34 Vladimir Oltean <olteanv@gmail.com> napisa=C5=82(a=
):
>
> On Tue, Jan 17, 2023 at 05:05:53PM +0100, Marcin Wojtas wrote:
> > In the past couple of years, a number of subsystems have migrated to a
> > more generic HW description abstraction (e.g. a big chunk of network,
> > pinctrl, gpio). ACPI aside, with this patchset one can even try to
> > describe the switch topology with the swnode (I haven't tried that
> > though). I fully agree that there should be no 0-day baggage in the
> > DSA ACPI binding (FYI the more fwnode- version of the
> > dsa_shared_port_validate_of() cought one issue in the WIP ACPI
> > description in my setup). On the other hand, I find fwnode_/device_
> > APIs really helpful for most of the cases - ACPI/OF/swnode differences
> > can be hidden to a generic layer and the need of maintaining separate
> > code paths related to the hardware description on the driver/subsystem
> > level is minimized. An example could be found in v1 of this series,
> > the last 4 patches in [1] show that it can be done in a simple /
> > seamless way, especially given the ACPI (fwnode) PHY description in
> > phylink is already settled and widely used. I am aware at the end of
> > the day, after final review all this can be more complex.
> >
> > I expect that the actual DSA ACPI support acceptance will require a
> > lot of discussions and decisions, on whether certain solutions are
> > worth migrating from OF world or require spec modification. For now my
> > goal was to migrate to a more generic HW description API, and so to
> > allow possible follow-up ACPI-related modifications, and additions to
> > be extracted and better tracked.
>
> I have a simple question.
>
> If you expect that the DSA ACPI bindings will require a lot of
> discussions, then how do you know that what you convert to fwnode now
> will be needed later, and why do you insist to mechanically convert
> everything to fwnode without having that discussion first?
>

Ok, let me clarify. From the technical standpoint, I think it is
fairly easy and to a very big extent, we should be able to reuse, what
is already existing - I made it work with a really minimal set of
changes, using a standard nodes' hierarchy and generic methods in the
ACPI tables. As more difficult, I consider getting this solution
accepted by the ACPI and the network subsystem maintainers, also given
the OF quirks/legacy stuff, that apparently needs to be ruled out in
such circumstances. However, I perceive a preparation step, with
migrating to the more generic HW description API in the generic
net/dsa, as a sort of improvement, but I get your point and I will
wait with resubmitting these changes again.

> You see the lack of a need to maintain separate code paths between OF
> and ACPI as useful. Yet the DSA maintainers don't, and in some cases
> this is specifically what they want to avoid. So a mechanical conversion
> will end up making absolutely no progress.

Fair enough. I'll keep it on hold until MDIOSerialBus gets accepted
and repost a bigger, combined patchset with all changes like in the
v1.

Best regards,
Marcin
