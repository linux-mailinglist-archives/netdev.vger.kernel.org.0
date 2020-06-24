Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A980D207948
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405043AbgFXQfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404625AbgFXQfu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:35:50 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C7AC0613ED
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:35:49 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id v8so2759148iox.2
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 09:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sp0WLMHGJPSAAMQoilN1mZe9srYQKmzrBKtnNiwXpVs=;
        b=Gs5a8ysDongBqjpVPsiQWEdpD5YRNoaq5AdJr4nWs/zYkTf9M+ghwGa2A+vl53WV6M
         JRhhJVQhyuX8Tjd445UrEkqaFeRBOHvtFUzLBeMPO0HX9mrLGqK4lDzsj6o3kvYnXAtP
         U9yDgHUDz7mk9brV9quovHVYMfYdpE1wplg8iEBwg4dESo1GeYGKG147fTWViUWPXVaS
         FR6tX7MIy3c334Uz8RjbHxPZg9QBgw0WiGsyG1tVXNjq2ij/nw+U3r3cmvFLDwDYK1qw
         EoXeQw+M9J5xE1EYWjQsHsb+8MY6uK1Y0nyljUOAVmAheLR3MwqkhUPIAU1EoVLOMvau
         PLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sp0WLMHGJPSAAMQoilN1mZe9srYQKmzrBKtnNiwXpVs=;
        b=TQ4/EO7t2L5uMaxScxaCO44gKPs/vVTlfksKtOxySrvDeH1nGP0w5ZG/nB6HA9j8dj
         eQRd2JUtUzfbPpohvG3qNx4YQYIddqVADx3YFDw0Dt0jMphYSpCAm1XSfqrbQ+ttSP6c
         Ir8k91UZqjumpi3WIWergHRC7iOJw50wGT7qgCY+fswhpooJE3M6sDMaZljzcrBuH3+u
         pMscYxZCk57s4nGrX6zlabzA9POg9gNLgMSFEDVE7huT3vAJ1kIlBoScuR6ENscmi+vU
         nxaTkwmG9bWUwJ7EGNefc8TkMqPHJDiYlkZFA+VxWDGjVNi32O5s9KFkQp772nDydHKb
         G2pQ==
X-Gm-Message-State: AOAM531k1TmkqANy5z7ygvpWhkZ35lEwn0s+DNAwvzi6wffRimmViRXn
        4GR26FmvvRMLPcOpma67qNpOJsbHP9DPvip1lkU9XQ==
X-Google-Smtp-Source: ABdhPJxqogL8HjW0xO8Djm9BN68/4TRrqeL4aSvgA3Rvp4v39IWyLfFQicLhQQMp3WEw0MNQuACTa3lGvzsxsAPhLOs=
X-Received: by 2002:a6b:b252:: with SMTP id b79mr32690628iof.31.1593016548397;
 Wed, 24 Jun 2020 09:35:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200622093744.13685-1-brgl@bgdev.pl> <20200622093744.13685-10-brgl@bgdev.pl>
 <20200622133940.GL338481@lunn.ch> <20200622135106.GK4560@sirena.org.uk>
 <dca54c57-a3bd-1147-63b2-4631194963f0@gmail.com> <20200624094302.GA5472@sirena.org.uk>
 <CAMRc=McBxJdujCyjQF3NA=bCWHF1dx8xJ1Nc2snmqukvJ_VyoQ@mail.gmail.com> <f806586d-a6d7-99af-bba4-d1e7d28be192@gmail.com>
In-Reply-To: <f806586d-a6d7-99af-bba4-d1e7d28be192@gmail.com>
From:   Bartosz Golaszewski <brgl@bgdev.pl>
Date:   Wed, 24 Jun 2020 18:35:37 +0200
Message-ID: <CAMRc=MfQFgrJC3nvuJgZobixa6MLeMw-tdg_3e1yNDityU5XSw@mail.gmail.com>
Subject: Re: [PATCH 09/15] net: phy: delay PHY driver probe until PHY registration
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 6:06 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>

[snip!]

> >
> > This has evolved into several new concepts being proposed vs my
> > use-case which is relatively simple. The former will probably take
> > several months of development, reviews and discussions and it will
> > block supporting the phy supply on pumpkin boards upstream. I would
> > prefer not to redo what other MAC drivers do (phy-supply property on
> > the MAC node, controlling it from the MAC driver itself) if we've
> > already established it's wrong.
>
> You are not new to Linux development, so none of this should come as a
> surprise to you. Your proposed solution has clearly short comings and is
> a hack, especially around the PHY_ID_NONE business to get a phy_device
> only then to have the real PHY device ID. You should also now that "I
> need it now because my product deliverable depends on it" has never been
> received as a valid argument to coerce people into accepting a solution
> for which there are at review time known deficiencies to the proposed
> approach.
>

Don't get me wrong, I understand that full well. On the other hand a
couple years ago I put a significant amount of work into the concept
of early platform device drivers for linux clocksource, clock and
interrupt drivers. Every reviewer had his own preferred approach and
after something like three completely different submissions and
several conversations at conferences I simply gave up due to all the
bikeshedding. It just wasn't moving forward and frankly: I expect any
changes to the core driver model to follow a similar path of most
resistance.

I will give it a shot but at some point getting the job done is better
than not getting it done just because the solution isn't perfect. IMO
this approach is still slightly more correct than controlling the
PHY's supply from the MAC driver.

Bartosz
