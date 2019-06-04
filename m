Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B46E352EF
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 01:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbfFDXDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 19:03:32 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:33406 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbfFDXDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 19:03:32 -0400
Received: by mail-ed1-f53.google.com with SMTP id h9so1435647edr.0
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 16:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uKQdCr6tU7n6JPTFpbXSSqRPhVKIuzgqJRc+zrRgb7I=;
        b=n/l+K5U0HGk5OnETHYSZQ/lZSsD318337tZGjBoiwh11hJFS+9qsK/KA66bs7aM4nJ
         oVJhtpVLqJfN0+1Ys217y1IpENFfoFjoMsmy8JVl37J8k1QWt8XPDDBRrmBgXoCrWzfX
         n3qpECFzO/tP+zu+JIpDVUu0drAyfvrxrSrpRTBisRGtTb9TZtNUKdFLBh5HDzx3RvVh
         L/MW4SDN+wbW9IdZ65oRnY4ZbFqN+TXq8x+2ee7TMjydXM2y61SHyzx8FyQJ+9oXQ7Y9
         hq3HrKfanS6z5DTrnvItmLv/k9/xX5fxWhmNW3RgQTAhDs7h/eUfcvdYaVrwXDWFhcYZ
         WTRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uKQdCr6tU7n6JPTFpbXSSqRPhVKIuzgqJRc+zrRgb7I=;
        b=EMUjhH6Th/JUCu+4Z0Q6Epjt4NEsMJSE1BCsY77B/A0PdrI5krVdKzkkyysemfMUK+
         Ve4T4btfpbVx1QwURrcy60QPTFqY/d2b8AojHNdo49Nu6K8OfUQag6LKRCqBJ08igGHY
         06PDrM/ohG4aTdH4EMQsJSGwxNkLaOD/AgkIQWEnT51dDPrFUwO7xpRIe5vnRJsY9FKd
         nVJCSB8sXYUhVaprutDbNgwafeK0Q5UAJgGWTSzzMSD2ue9kNetGWv7mIRKRUj8qSfOL
         GYttDfMWDC5xuZR/WvKDm3C9ntmYR7bD8LJgYrqaIN+NP6GEWjg7PpmsnUcp8bMS3XKU
         eOnw==
X-Gm-Message-State: APjAAAXdftUrUEl6+W9cRT8Ip6L3EucKthrTSOLLDYAtB45EeRjLiSaV
        OJ2jwfMEc4B9Fx5HcuDDeJPYWAGzpk8ZzUNO3ojZp0lO
X-Google-Smtp-Source: APXvYqwGpRXgKDwCBIjrKoa02Muqihavl8HMEozs0lHv8WQowHkeZQblHaFlqBxWdFogmY6YjIMTKVjUazrdYlIj1Bo=
X-Received: by 2002:a17:906:1483:: with SMTP id x3mr31858557ejc.90.1559689409940;
 Tue, 04 Jun 2019 16:03:29 -0700 (PDT)
MIME-Version: 1.0
References: <52888d1f-2f7d-bfa1-ca05-73887b68153d@gmail.com>
 <20190604200713.GV19627@lunn.ch> <CA+h21hrJPAoieooUKY=dBxoteJ32DfAXHYtfm0rVi25g9gKuxg@mail.gmail.com>
 <20190604211221.GW19627@lunn.ch> <CA+h21hrqsH9FYtTOrCV+Bb0YANQvSnW9Uq=SoS7AJv9Wcw3A3w@mail.gmail.com>
 <31cc0e5e-810c-86ea-7766-ec37008c5f9d@gmail.com> <20190604214845.wlelh454qfnrs42s@shell.armlinux.org.uk>
 <CA+h21hrOPCVoDwbQa9uFVu3uVWtoP+2Vp2z94An2qtv=u8wWKg@mail.gmail.com>
 <20190604221626.4vjtsexoutqzblkl@shell.armlinux.org.uk> <CA+h21hrkQkBocwigiemhN_H+QJ3yWZaJt+aoBWhZiW3BNNQOXw@mail.gmail.com>
 <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk>
In-Reply-To: <20190604225919.xpkykt2z3a7utiet@shell.armlinux.org.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 5 Jun 2019 02:03:19 +0300
Message-ID: <CA+h21hrT+XPfqePouzKB4UUfUawck831bKhAY6-BOunnvbmT1g@mail.gmail.com>
Subject: Re: Cutting the link on ndo_stop - phy_stop or phy_disconnect?
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Jun 2019 at 01:59, Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Jun 05, 2019 at 01:44:08AM +0300, Vladimir Oltean wrote:
> > You caught me.
> >
> > But even ignoring the NIC case, isn't the PHY state machine
> > inconsistent with itself? It is ok with callink phy_suspend upon
> > ndo_stop, but it won't call phy_suspend after phy_connect, when the
> > netdev is implicitly stopped?
>
> The PHY state machine isn't inconsistent with itself, but it does
> have strange behaviour.
>
> When the PHY is attached, the PHY is resumed and the state machine
> is in PHY_READY state.  If it goes through a start/stop cycle, the
> state machine transitions to PHY_HALTED and attempts to place the
> PHY into a low power state.  So the PHY state is consistent with
> the state machine state (we don't end up in the same state but with
> the PHY in a different state.)
>
> What we do have is a difference between the PHY state (and state
> machine state) between the boot scenario, and the interface up/down
> scenario, the latter behaviour having been introduced by a commit
> back in 2013:
>
>     net: phy: suspend phydev when going to HALTED
>
>     When phydev is going to HALTED state, we can try to suspend it to
>     safe more power. phy_suspend helper will check if PHY can be suspended,
>     so just call it when entering HALTED state.
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up

I am really not into the PHYLIB internals, but basically what you're
telling me is that running "ip link set dev eth0 down" is a
stronger/more imperative condition than not running "ip link set dev
eth0 up"... Does it also suspend the PHY if I put the interface down
while it was already down?

-Vladimir
