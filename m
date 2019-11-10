Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5BDF6A6F
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKJRAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:00:47 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35507 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKJRAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 12:00:46 -0500
Received: by mail-ed1-f68.google.com with SMTP id r16so10064884edq.2
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 09:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ljK8Hs0++npJrSXpORUXvZl0zNOvtiEx3+TTGNivwow=;
        b=Klsxu0piXKd8/Wo7PO0ZD/EhUXNYiSHRQaFeEcq8xSCSSS5FUXhxHJirl2Ay7f8FTI
         N251lgLQdFjehd6k5xb8FDoPeCbXduFqiNS60RtBav62XZheHvwTakv0DyJNzgyKfMNg
         VS8gThgEqit2kgRpEtBdUIETAZYjbATQpVJxgDa890Pq3ywlBWMSZKUS7sPdNOVp0ybo
         1KNV6BdKKDf4J1XMjZpAa9d6jz/b1qrwb07TMCxmRdtt6cPcXTdY6zqaY1YZIXaFTMy6
         mcKPMXLG+ehloUO34F7zqO6n/b3FLBBwo8J5P1m9gJ4rxdvrnQwmM9+kyl4f6294Al2P
         DKzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ljK8Hs0++npJrSXpORUXvZl0zNOvtiEx3+TTGNivwow=;
        b=Ipa2pFxxn8PKsSeX2/Bj9bTI5KPWvkpOnMIT/LPVONZ3CAVzC5UmvZ2Be5aEEBQYtu
         UnwvBgaICLXpbmCDB0O9e0dsaR+RglS8H/tUIhDIERZp9Zt1EiHI9Ez+8KUkIFuFuYHH
         QIthqEf/h3lvwF2cr0kgxZ0O3R8VJjwfLLo4Fr8d1dpOzYgwg0sadPNpaXcExHLtJr/t
         L5Vdi4fPlC5LE9z6GWxNKczgCfmE2dpfW6Edal5CgyNvVZBOicYqnTBCfOiGY8Hh4Pb/
         lrEx4Nip11ySHLe6TyG4cbkpF0Sg8QO7p5Q4DNeU1D7KObDssWYa2NHKK4BoC4SRoFgL
         voVw==
X-Gm-Message-State: APjAAAWCIeMhbJbP8yNjB7qH/QWKHL8NSfBAECVbYpN0BGohtxLj7QzR
        LxvPgsSaQ5QhgvcnmDE5sRmOLGLHa6NgDx+MDCQ=
X-Google-Smtp-Source: APXvYqwTBV6ldDhgxJZfgv8g1wIst9aUFDKBqL5thaMY9OPo7nS8+uPufwV+J1IPcI25rdxAS/gXfwOxD7MPk8VYgdA=
X-Received: by 2002:a17:906:1812:: with SMTP id v18mr18959092eje.86.1573405244894;
 Sun, 10 Nov 2019 09:00:44 -0800 (PST)
MIME-Version: 1.0
References: <20191109130301.13716-1-olteanv@gmail.com> <20191109130301.13716-16-olteanv@gmail.com>
 <20191110165031.GF25889@lunn.ch>
In-Reply-To: <20191110165031.GF25889@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 10 Nov 2019 19:00:33 +0200
Message-ID: <CA+h21hoDvAX7NgUL0VxkBwyaAst6cr_-xTz9=7T+CANqV=Zv9A@mail.gmail.com>
Subject: Re: [PATCH net-next 15/15] net: mscc: ocelot: don't hardcode the
 number of the CPU port
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
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 10 Nov 2019 at 18:50, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Nov 09, 2019 at 03:03:01PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > VSC7514 is a 10-port switch with 2 extra "CPU ports" (targets in the
> > queuing subsystem for terminating traffic locally).
>
> So maybe that answers my last question.
>
> > There are 2 issues with hardcoding the CPU port as #10:
> > - It is not clear which snippets of the code are configuring something
> >   for one of the CPU ports, and which snippets are just doing something
> >   related to the number of physical ports.
> > - Actually any physical port can act as a CPU port connected to an
> >   external CPU (in addition to the local CPU). This is called NPI mode
> >   (Node Processor Interface) and is the way that the 6-port VSC9959
> >   (Felix) switch is integrated inside NXP LS1028A (the "local management
> >   CPU" functionality is not used there).
>
> So i'm having trouble reading this and spotting the difference between
> the DSA concept of a CPU port and the two extra "CPU ports". Maybe
> using the concept of virtual ports would help?
>
> Are the physical ports number 0-9, and so port #10 is the first extra
> "CPU port", aka a virtual port? And so that would not work for DSA,
> where you need a physical port.
>
>       Andrew

Right. See my other answer which links to Ocelot documentation. The
3.14 chapter "CPU Port Module" should clarify. The switch core has a
number of CPU ports (typically 2) which are to be integrated with
SoC-specific frame transfer abilities, typically DMA. The way this was
integrated in LS1028A is described by: "It is also possible to use a
regular front port as a CPU port. This is known as a Node Processor
Interface (NPI)." So the embedded switch and the rest of the system
are strangers and talk over Ethernet (the 2 "virtual" CPU ports are
not used), hence the reason why the "normal" (virtual, etc) CPU ports
are better modelled as switchdev and the "NPI" CPU port is better
modelled as DSA.
