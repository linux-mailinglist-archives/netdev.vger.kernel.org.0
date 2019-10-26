Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 864F4E5FF6
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 00:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfJZW6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 18:58:47 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35959 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfJZW6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 18:58:47 -0400
Received: by mail-ed1-f66.google.com with SMTP id bm15so4874613edb.3
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 15:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P/Ugsl7XIxjg/QCuqwUudFlCF92K2LNOHdehACrO+9M=;
        b=fkwAyfYEKmcEtjK6GMobHlY4kCPN3I3RzfBe92slzkQhs6m189UyhJc0cgtCWDjSDA
         kkxKP1czMsnAjUin7Bvifqc9G95DiaiABPAPINcPe0G9mXck5a5fvwvvzPGL+tRQtCQj
         rdvpK7BiVVLUlRgTV83zUzLktJIKm5CFYRN4SkRI02htePOikfFE+B4/X+hoyVDHZenz
         mUOe5fK8sNwBY63CGF0l5Qi9kzsRWhfJTrjNM81evjqiF5g4sD24s6RCE32oKQB+6dy7
         oRA+cDrPi1p/Sh/DtcHhQpVP6rNXz8AQzDbz7gOwkSjxLtO3pgKBWXm+nYiF4Q0flblM
         +UwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P/Ugsl7XIxjg/QCuqwUudFlCF92K2LNOHdehACrO+9M=;
        b=N0yxOHxKdEANPUf9KUv2OdS16kLY7G8HFDAQp2PlfU3Cx8trr6ptb4fEVj7Xp749Rx
         e3TlOe7DVdiqruBP7lw7d7SZ/HzKnTOUINDTPPVOgWS308qhwNPqwJG5tE6/lWxLFufi
         pAdmQ0WfELSrcytmqh0PFnE7tIwSA4naTYWe1Yk7CBY7ldh63cmsjvpdjQuWFiiK9TBO
         39D0XUwVfjUcsw3pEQbMUzwtWeZdP+Rzg6s2g6YgaRjhh58vjNaTilPrLbbIp9qvrGZ8
         J/E0Dux28bbG64+D5remLXRGxQGVoGzqldm5IIkBpfuuH+cX+opFvu2GjbzbNuvxyWcA
         oKzw==
X-Gm-Message-State: APjAAAWZoqcSOsgHDaQTALOfQAk0YE9EMtjluwC1L9q8uBLIyTlWye+W
        hsLXnhei+/WEYvHXd1DbxSBq+I4UKbhHW+Uzmzo=
X-Google-Smtp-Source: APXvYqyBHuLQYFyEqFyJY738LyaR9Gnzvw1vvnU7Ax1AZEJBgo2pyn7GHsdYp2kUSzj8GdaQYiXKTLwJhMpHcd8w9so=
X-Received: by 2002:a17:906:d9d0:: with SMTP id qk16mr9470389ejb.70.1572130725447;
 Sat, 26 Oct 2019 15:58:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191026180427.14039-1-olteanv@gmail.com> <20191026180427.14039-3-olteanv@gmail.com>
 <5a0b7e8b-851e-2523-c6c1-da6fbd0c3dac@gmail.com>
In-Reply-To: <5a0b7e8b-851e-2523-c6c1-da6fbd0c3dac@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 27 Oct 2019 01:58:34 +0300
Message-ID: <CA+h21ho76-Kxjc6R7eHcdHMBag1cu9pZMdbaFYXgT_u4-Fy9pQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net: mscc: ocelot: refuse to overwrite the port's
 native vlan
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Oct 2019 at 23:34, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 10/26/2019 11:04 AM, Vladimir Oltean wrote:
> > The switch driver keeps a "vid" variable per port, which signifies _the_
> > VLAN ID that is stripped on that port's egress (aka the native VLAN on a
> > trunk port).
> >
> > That is the way the hardware is designed (mostly). The port->vid is
> > programmed into REW:PORT:PORT_VLAN_CFG:PORT_VID and the rewriter is told
> > to send all traffic as tagged except the one having port->vid.
> >
> > There exists a possibility of finer-grained egress untagging decisions:
> > using the VCAP IS1 engine, one rule can be added to match every
> > VLAN-tagged frame whose VLAN should be untagged, and set POP_CNT=1 as
> > action. However, the IS1 can hold at most 512 entries, and the VLANs are
> > in the order of 6 * 4096.
> >
> > So the code is fine for now. But this sequence of commands:
> >
> > $ bridge vlan add dev swp0 vid 1 pvid untagged
> > $ bridge vlan add dev swp0 vid 2 untagged
> >
> > makes untagged and pvid-tagged traffic be sent out of swp0 as tagged
> > with VID 1, despite user's request.
> >
> > Prevent that from happening. The user should temporarily remove the
> > existing untagged VLAN (1 in this case), add it back as tagged, and then
> > add the new untagged VLAN (2 in this case).>
> > Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> > Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > Fixes: 7142529f1688 ("net: mscc: ocelot: add VLAN filtering")
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>

Thanks, Florian.

> [snip]
>
> > +     if (untagged && port->vid != vid) {
> > +             if (port->vid) {
> > +                     dev_err(ocelot->dev,
> > +                             "Port already has a native VLAN: %d\n",
> > +                             port->vid);
>
> This sounds like a extended netlink ack candidate for improving user
> experience, but this should do for now.
> --
> Florian

I know what you're saying. I wanted to drag in minimal dependencies
for the fix. The driver is going to see major rework anyway soon (will
gain a DSA front-end), hence the reason why I copied the DSA people to
the fixes. Having extack propagate to more drivers is always welcome,
and DSA would be a good start to see that being implemented.

Regards,
-Vladimir
