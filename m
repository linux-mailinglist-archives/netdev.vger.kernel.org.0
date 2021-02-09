Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D541314F0D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 13:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhBIMh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 07:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhBIMhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 07:37:54 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87393C06178C
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 04:37:13 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id a17so22091455ljq.2
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 04:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=dp2/Yyn+Nvj/ORiR/zBP8Aijq2eR2MP6XOPOex6Vg3A=;
        b=MuZh103+OAj6XXbs7B8F3Y7XRPR8d1VUeYirFAeRFIe73Pm6euPoF4Tqzc2CrZv8PD
         npf5UZo8El2rpmYjUL0T8LxeunY4XkQXJDjzcpX1voZXo9b2BDEwjhGH/aFAhh22U28X
         4kM1DliNgWKCJmCrXiJdCzWvjLibeVYptx5mtOS/XvE8RLqf+0Db+oiWcpvLJ6DiPj+x
         GtactdODwlHW9xI1Z3hWQN7qohjGqGDxQfLwPX2/8+9tytjmfOiQ4r9A6s1X/Cnro51r
         W1wDSwgzJhjUIss0Fo/BsVF3PN74C15ZpDET/8MVGlon9I0P2NxGLn7vHoOx6pDkm2CZ
         hztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=dp2/Yyn+Nvj/ORiR/zBP8Aijq2eR2MP6XOPOex6Vg3A=;
        b=TMkuEETK6ACqIG/3YvzkTYoJ3rK7kVzQOkViJQo2U06PafHWn8JJRhbNqV8ZGEAvCz
         SQRdY2xQERXMFVS7f05RHgiSPbumC62p1DJGGa0tkA7fOpEUozxunZxNk1NUDEKZZJua
         HH9hwISuvf1MbGtRCJsmA5CC9MZuxzJuP2oTF8o+PYX7QOEWXHA59BWtSeK5OJGQKNQq
         DIzVHt5Gu8D4UGFKsW6PscUcQk0vRdU5eNbTXCkl5ztqBDf3vrWmP04EpPyknNk1qyqt
         CkkAXo2TR6gV99MUVol1Do4jRvfPSMh+YMBzIaakdJMGAZUbG0AziEY/GcdR0uKhGXZK
         5BIg==
X-Gm-Message-State: AOAM53033vXjM19bus7g48uCv52PUCW77Zbbk3hCDXUE82vT0EI9vBYy
        9H93mTKdlqR9JYjdfRJyRDCVfw==
X-Google-Smtp-Source: ABdhPJw1WVrHc6Xfjj4qcr3YM4W3dJ1gaVjQhHK9TYWLCs3MYIYDiQTAD+84eqLp00T/jwlJoC9hxw==
X-Received: by 2002:a2e:9bce:: with SMTP id w14mr14249808ljj.120.1612874231943;
        Tue, 09 Feb 2021 04:37:11 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id t24sm725872ljd.56.2021.02.09.04.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 04:37:11 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 5/7] net: marvell: prestera: add LAG support
In-Reply-To: <YCG7lEncISjQwEOk@lunn.ch>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu> <20210203165458.28717-6-vadym.kochan@plvision.eu> <20210204211647.7b9a8ebf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <87v9b249oq.fsf@waldekranz.com> <20210208130557.56b14429@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <YCG7lEncISjQwEOk@lunn.ch>
Date:   Tue, 09 Feb 2021 13:37:10 +0100
Message-ID: <87mtwd4du1.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 23:30, Andrew Lunn <andrew@lunn.ch> wrote:
>> > I took a quick look at it, and what I found left me very puzzled. I hope
>> > you do not mind me asking a generic question about the policy around
>> > switchdev drivers. If someone published a driver using something similar
>> > to the following configuration flow:
>> > 
>> > iproute2  daemon(SDK)
>> >    |        ^    |
>> >    :        :    : user/kernel boundary
>> >    v        |    |
>> > netlink     |    |
>> >    |        |    |
>> >    v        |    |
>> >  driver     |    |
>> >    |        |    |
>> >    '--------'    |
>> >                  : kernel/hardware boundary
>> >                  v
>> >                 ASIC
>> > 
>> > My guess is that they would be (rightly IMO) told something along the
>> > lines of "we do not accept drivers that are just shims for proprietary
>> > SDKs".
>> > 
>> > But it seems like if that same someone has enough area to spare in their
>> > ASIC to embed a CPU, it is perfectly fine to run that same SDK on it,
>> > call it "firmware", and then push a shim driver into the kernel tree.
>> > 
>> > iproute2
>> >    |
>> >    :               user/kernel boundary
>> >    v
>> > netlink
>> >    |
>> >    v
>> >  driver
>> >    |
>> >    |
>> >    :               kernel/hardware boundary
>> >    '-------------.
>> >                  v
>> >              daemon(SDK)
>> >                  |
>> >                  v
>> >                 ASIC
>> > 
>> > What have we, the community, gained by this? In the old world, the
>> > vendor usually at least had to ship me the SDK in source form. Having
>> > seen the inside of some of those sausage factories, they are not the
>> > kinds of code bases that I want at the bottom of my stack; even less so
>> > in binary form where I am entirely at the vendor's mercy for bugfixes.
>> > 
>> > We are talking about a pure Ethernet fabric here, so there is no fig
>> > leaf of "regulatory requirements" to hide behind, in contrast to WiFi
>> > for example.
>> > 
>> > Is it the opinion of the netdev community that it is OK for vendors to
>> > use this model?
>
> What i find interesting is the comparison between Microchip Sparx5 and
> Marvell Prestera. They offer similar capabilities. Both have a CPU on
> them. As you say Marvell is pushing their SDK into this CPU, black
> box. Microchip decided to open everything, no firmware, the kernel
> driver is directly accessing the hardware, the datasheet is available,
> and microchip engineers are here on the list.

Indeed, it is a very stark difference in approach. Perhaps a silly
example, but it speaks to their developer focus, just the fact that they
have an online register reference on GitHub[1] amazed me. What a breath
of fresh air! ...and speaks to the general state of things, I guess :)

Unsurprisingly the team behind it are also really great to work with!

> I really hope that Sparx5 takes off, and displaces Prestera. In terms

We are certainly keeping our eyes on it!

> of being able to solve issues, we the community can work with
> Sparx5. Prestera is too much a black box.

I would only add that I still, perhaps naively, hope Marvell will
eventually see the benefits of having a truly open driver.

> 	Andrew

[1]: https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html
