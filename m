Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4A00F6A8C
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbfKJRWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:22:15 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:39886 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfKJRWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 12:22:14 -0500
Received: by mail-ed1-f68.google.com with SMTP id l25so10065716edt.6
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 09:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sp9vz2AR+hqFZv53VPiIsQrRDWMCrMtHCoYSMiNV1lI=;
        b=RkPv1Y3PBAmH7kr0pc90X6MBW4GZ+BX1rv+HQe8OKqvjH/9ahgFu/GXH1BiKurSE+n
         Ufl35UeWqsPAAZHU6k0R1KJyUpX6qxkOr1Ch7BZsMmff+kjib0o+F9EAlI1bOKBd/mpD
         0BFOk2MmRAPtZXIBHFiStYds4vICbHjNpq+VtsBEkGoldrMIuswt/BS5BJO+2ugKOqfK
         TUnaZjHB418bWFz2qCVvbqBeHdfbNTGdnr4egfGiLDf0QY0nAmlgTq7zfMxmMg/ahLO8
         HnOjMMJQuXpi1EKBHkEEZR7Bj2YoVpDjXP1Yf7bD9VgTS+01OjZaNbq85gJVkRo/HKKN
         criw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sp9vz2AR+hqFZv53VPiIsQrRDWMCrMtHCoYSMiNV1lI=;
        b=k3B4U8OYkEW4MBJbRLBN14S3+ysBYKE+rStDs6CxCCsfgnI9hADD7HQVbRgFXhpypH
         2cSSla6e8OwbCjDiJEdQU+KU97THJkuevo7UEknRg3622PDDr+r663Jl8Wi0t+QZWxGa
         O55b4fSicyRPjlmelw2yv2M3nDOy7swI4wzWkk9EG8dFqRNxyOcHc+oAcrptSFsf+MIU
         ekBU2RYNTjkiiGNyuON2TfBrrA1CdsgliQcN+xl35BzK/QbicbYlZlWSaxORRVFDBdqT
         dSOT9AhOfX4RjIAE56MkAYSugNxNm8OdYymEaNHmvMx0I0LplGHApaxUi5CB2dNYfjBb
         +D7A==
X-Gm-Message-State: APjAAAWOMJnfibDDAXLLwc/WW87AXu+tVNxCH7AtO6edztu6KGnCmNk5
        RGQSgzFFvNMMnRF36+dqWyp6Qp2vNyGkjC2l0u0=
X-Google-Smtp-Source: APXvYqyAlXpDHmpg+8emTM9sLZDprPmTV2yRzNiIqnGfJATd2RLjny+6KDLTzdZJBnNZyNDGgYSXFn/zw9bwu9hfzZ8=
X-Received: by 2002:a17:906:4910:: with SMTP id b16mr18832593ejq.133.1573406532872;
 Sun, 10 Nov 2019 09:22:12 -0800 (PST)
MIME-Version: 1.0
References: <20191109130301.13716-1-olteanv@gmail.com> <20191110171611.GI25889@lunn.ch>
In-Reply-To: <20191110171611.GI25889@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 10 Nov 2019 19:22:02 +0200
Message-ID: <CA+h21hoLu-Q38D9RSNV4be=Za3TSnWdpgY4d4Zczt=pNXC2QEA@mail.gmail.com>
Subject: Re: [PATCH net-next 00/15] Accomodate DSA front-end into Ocelot
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 at 19:16, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Nov 09, 2019 at 03:02:46PM +0200, Vladimir Oltean wrote:
> > After the nice "change-my-mind" discussion about Ocelot, Felix and
> > LS1028A (which can be read here: https://lkml.org/lkml/2019/6/21/630),
> > we have decided to take the route of reworking the Ocelot implementation
> > in a way that is DSA-compatible.
> >
> > This is a large series, but hopefully is easy enough to digest, since it
> > contains mostly code refactoring.
>
> I just skimmed over the patches. Apart from the naming confusion at
> the end, it all looks O.K.
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>

Thanks a lot! Would it be too early if I also posted the Felix DSA
driver as well?

> > It also means that Ocelot practically re-implements large parts of
> > DSA (although it is not a DSA switch per se)
>
> Would it make sense to refactor parts of the DSA core and export them
> as helper function?

Where it helps, I'll sure consider doing that. We'll anyway need to
add support for tc-flower in DSA, filter blocks and all of that. At
the moment, only the FDB dump code was slightly duplicated, but then
again, that's because some boilerplate is needed, and it was there
anyway. So far it's manageable.

>
>    Andrew
