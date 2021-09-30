Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA9D41E291
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347647AbhI3UQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346172AbhI3UQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 16:16:57 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6DDFC06176C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 13:15:14 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id m132so15908359ybf.8
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 13:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Me7vW3q+q6rLanOt9S2VuLazMhOi6957p7rnr+uLOIk=;
        b=R2FWQW45NNofSeNJjPfUjNyFFGod2AQS1fmBgJZAaTIHwyU6++wv5vI9m/2JPTk8rX
         WugZ1flWTFEs6XzqN2uc0P9GJhlwnkMJi7s1WBXdivpSy2fMM/O+5pPhuHqBVXAPJYFl
         loP65unlQa3cHJwxa30sHAZSocSa7V3A2W1azPmBVwsIyYnFpWOoKZ5yPA5lvIAY7F4D
         zCfHC1tvrXhOYtLb8oeHcNk0yi5McHmEsrfMmA/omIIeXH3BjGTZpsNhuIBWsS+o383z
         gRayEQmmxLWZktUXQsvBfi4jicmQIVD8Nwjrx3KQHpZfz9ItFqgTCFCXT53dhpq8j1dW
         oCzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Me7vW3q+q6rLanOt9S2VuLazMhOi6957p7rnr+uLOIk=;
        b=vMzyOXEUvuXyJ95yhe741MZ/xe5Xx8RE8CtLj9nC0TfYhef0JFqUpitk1cSxcpsvKZ
         7NHLRXP9s4857IMRvatc7rWLj4qTxokPVkrC0tUK16cch/koOdHGC5cUlH1NgNFbu55Y
         hVsJJW6/zd0i3ua/QrTcG6q8Y/S4j2dN3ql7nt2Q5EKirQpU+CqiNPiCCz+RMWmqYrMY
         Cm9JJXhQxFC9szZJenJ2Eu2yRCzVrzhGUVXA7eM7/sCwl5lXwV44IV/FLGB0XDJJGtUC
         2GChmfrOrv9u93KSV2R5BZWV8VLBBlllfxKVC00yVMqj1E+vm4pjXJEipGKgwPEK7iCF
         bceQ==
X-Gm-Message-State: AOAM531WKeKLYD7fOCWLsIIhNHjr4O4rL+7dPOxWmKPlHjxVPG+PuxpZ
        NZPySZwNAjKoKwfgsgB3Tjxexo0yt5uXVMJLcBua2Q==
X-Google-Smtp-Source: ABdhPJyz2NYXeBQwRc9kkgNI9ar1T2WvDJpjlb3i7GnpyBRAvqGnbL4ZtbOFN5XbF1suUYAXztX67XYEMBOQNXZt/yU=
X-Received: by 2002:a25:db91:: with SMTP id g139mr1313912ybf.391.1633032913793;
 Thu, 30 Sep 2021 13:15:13 -0700 (PDT)
MIME-Version: 1.0
References: <YS4rw7NQcpRmkO/K@lunn.ch> <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch> <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch> <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
 <20210930134343.ztq3hgianm34dvqb@skbuf> <YVXDAQc6RMvDjjFu@lunn.ch>
 <CAGETcx8emDg1rojU=_rrQJ3ezpx=wTukFdbBV-uXiu1EQ87=wQ@mail.gmail.com>
 <YVYSMMMkmHQn6n2+@lunn.ch> <CAGETcx-L7zhfd72+aRmapb=nAbbFGR5NX0aFK-V9K1WT4ubohA@mail.gmail.com>
 <cb193c3d-e75d-3b1e-f3f4-0dcd1e982407@gmail.com>
In-Reply-To: <cb193c3d-e75d-3b1e-f3f4-0dcd1e982407@gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 30 Sep 2021 13:14:37 -0700
Message-ID: <CAGETcx_G3haECnv-FS4L16PCmpfbCB3hhqHssT2E8d1fw5D3zw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 1:06 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>
> On 9/30/21 12:48 PM, Saravana Kannan wrote:
> > On Thu, Sep 30, 2021 at 12:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >>
> >>> Btw, do we have non-DSA networking devices where fw_devlink=on
> >>> delaying PHY probes is causing an issue?
> >>
> >> I don't know if issues have been reported, but the realtek driver has
> >> had problems in the past when the generic driver is used. Take a look
> >> at r8169_mdio_register(), it does something similar to DSA.
> >
> > Does it have the issue of having the PHY as its child too and then
> > depending on it to bind to a driver? I can't tell because I didn't
> > know how to find that info for a PCI device.
>
> Yes, r8169 includes a MDIO bus controller, and the PHY is internal to
> the Ethernet MAC. These are AFAIR the relevant changes to this discussion:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=16983507742cbcaa5592af530872a82e82fb9c51
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=11287b693d03830010356339e4ceddf47dee34fa
>
>
> >
> >>
> >> What is going to make things interesting is that phy_attach_direct()
> >> is called in two different contexts. During the MAC drivers probe, it
> >> is O.K. to return EPROBE_DEFER, and let the MAC driver try again
> >> later, if we know there is a specific PHY driver for it. But when
> >> called during the MAC drivers open() op, -EPROBE_DEFER is not
> >> allowed. What to do then is an interesting question.
> >
> > Yeah, basically before doing an open() it'll have to call an API to
> > say "just bind with whatever you got". Or something along those lines.
> > I already know how to get that to work. I'll send some RFC soonish (I
> > hope).
>
> I don't think this is going to scale, we have dozens and dozens of
> drivers that connect to the PHY during ndo_open().

Whichever code calls ->ndo_open() can't that mark all the PHYs that'll
be used as "needs to be ready now"? In any case, if we can have an API
that allows a less greedy Generic PHY binding, we could slowly
transition drivers over or at least move them over as they hit issues
with Gen PHY. Anyway, I'll think discussing it over code would be
easier. I'll also have more context as I try to make changes. So,
let's continue this on my future RFC.

-Saravana

> It is not realistic
> to audit them all, just like the opposite case where the drivers do
> probe MDIO/PHY during their .probe() call is not realistic either.
> --
> Florian
