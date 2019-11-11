Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2988F73AF
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfKKMR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:17:59 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35275 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKKMR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 07:17:59 -0500
Received: by mail-ed1-f67.google.com with SMTP id r16so11773628edq.2
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 04:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85KE1bGsf40kFvJl5/bYHDS7rzfwXQA2rbej+m3UPeo=;
        b=WdShSI/7wdEClanOzqpRdFh+RN8cKEcaZzkoOb7Ox9aJaPiMMRsl7Srm0CIsBDMWNS
         syFZMqgcikbxUs5uXwpOua0AVGZJmU88XnODeXq7VSlu2K8GcXoEdMxcjTFPDqLLmJdJ
         61gQqgH8W3R4WxRPlVdrKchNsNVvwr7d9fUipQhglkJY0ZW0OW3TdGokoXMYntqZsA+c
         xFnEX2ytUXrIzzJX79V5n8TEJ3u6V+e3bKxe10KHsRdAgOw+Ve/U6ZCI84MWONTB8WP6
         88d5qeRtSED5qD+S8zoL2M3DSlrVes4YZnaCjaS821E2aBSEEo9ksxUt/Kgo6KQKsloD
         gvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85KE1bGsf40kFvJl5/bYHDS7rzfwXQA2rbej+m3UPeo=;
        b=GzbnGUkYrhw6sZZJmKOdAHrzd/eHDgy7QRJ4p1mcti9f0LK+47QmA2JlNSPyPA3JmN
         kuKqpJIcQCayxdMa9BAxLMQvPYXYJdzFNsTSmxmrhG/hWi41MyMZN9Qzok5GyiBP9U6L
         iM6X11tksqvoh400uP+1XR9kfGsdfDoAmwuLKAm7zQdqarzK/icgKwYi7wrf9qgG3kjh
         8Y+hagpcSLVX3n21qOY+onJm+gEVK6CbT9NUGe2lkXj53GsRj6urEMbtc0yt6gYD0ayJ
         j0hWlKbrNgmTmNYuaz0FpKb5A8PF6ks02mlc/WvBrrBKKll8LvUsKmccM1hrWFge2Ocn
         dmdA==
X-Gm-Message-State: APjAAAWknGKeS32hqKzfnPa1hBNU/Y/nTgL9kmEEPlJF+v0BY/O6W879
        9mMt5bTVhj1FLZam2qfSWlSQgkZVnbn7xuiFUIQ=
X-Google-Smtp-Source: APXvYqy49gA4f8S4VBu1Du2fu2JjyZY7O+hr2HMpTObeduwY1g8kIEoQyObsehskMRlJnEuMAFHrPHyVNGmqebRH/MQ=
X-Received: by 2002:a50:91c4:: with SMTP id h4mr26259411eda.36.1573474677240;
 Mon, 11 Nov 2019 04:17:57 -0800 (PST)
MIME-Version: 1.0
References: <20191109130301.13716-1-olteanv@gmail.com> <20191111121049.3hrammgeez5x6cm3@soft-dev3.microsemi.net>
In-Reply-To: <20191111121049.3hrammgeez5x6cm3@soft-dev3.microsemi.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 11 Nov 2019 14:17:46 +0200
Message-ID: <CA+h21hqj3ZL1t7RurXNOnEvN0G7i0Z8Vm9vp1L+HLtLCpA6sTw@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15] Accomodate DSA front-end into Ocelot
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 at 14:10, Horatiu Vultur
<horatiu.vultur@microchip.com> wrote:
>
> The 11/09/2019 15:02, Vladimir Oltean wrote:
> > External E-Mail
> >
> >
> > After the nice "change-my-mind" discussion about Ocelot, Felix and
> > LS1028A (which can be read here: https://lkml.org/lkml/2019/6/21/630),
> > we have decided to take the route of reworking the Ocelot implementation
> > in a way that is DSA-compatible.
> >
> > This is a large series, but hopefully is easy enough to digest, since it
> > contains mostly code refactoring. What needs to be changed:
> > - The struct net_device, phy_device needs to be isolated from Ocelot
> >   private structures (struct ocelot, struct ocelot_port). These will
> >   live as 1-to-1 equivalents to struct dsa_switch and struct dsa_port.
> > - The function prototypes need to be compatible with DSA (of course,
> >   struct dsa_switch will become struct ocelot).
> > - The CPU port needs to be assigned via a higher-level API, not
> >   hardcoded in the driver.
> >
> > What is going to be interesting is that the new DSA front-end of Ocelot
> > will need to have features in lockstep with the DSA core itself. At the
> > moment, some more advanced tc offloading features of Ocelot (tc-flower,
> > etc) are not available in the DSA front-end due to lack of API in the
> > DSA core. It also means that Ocelot practically re-implements large
> > parts of DSA (although it is not a DSA switch per se) - see the FDB API
> > for example.
> >
> > The code has been only compile-tested on Ocelot, since I don't have
> > access to any VSC7514 hardware. It was proven to work on NXP LS1028A,
> > which instantiates a DSA derivative of Ocelot. So I would like to ask
> > Alex Belloni if you could confirm this series causes no regression on
> > the Ocelot MIPS SoC.
> >
> > The goal is to get this rework upstream as quickly as possible,
> > precisely because it is a large volume of code that risks gaining merge
> > conflicts if we keep it for too long.
> >
> > This is but the first chunk of the LS1028A Felix DSA driver upstreaming.
> > For those who are interested, the concept can be seen on my private
> > Github repo, the user of this reworked Ocelot driver living under
> > drivers/net/dsa/vitesse/:
> > https://github.com/vladimiroltean/ls1028ardb-linux
>
> I have done some tests on Ocelot hardware and it seems to work fine.
>
> Acked-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>

Thanks, Horatiu!

> --
> /Horatiu

-Vladimir
