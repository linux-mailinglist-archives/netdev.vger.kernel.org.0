Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3423C2913BE
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 20:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439119AbgJQSzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 14:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:38330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439112AbgJQSzj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 14:55:39 -0400
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 128AB2073A
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 18:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602960938;
        bh=xE5kyr3XYBXffZgGF4kWpyNrMxsHDj4u3m9YzcRdVJQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Uv5R+lzJIzWSRyKyCpzPbFiQrkBEMKF1uXXsiZGZG+EeARtJJcQo7qXEOvDWlB8dX
         B6SvPO4vA72fkAxir79TKbPT8Gb5iyLi7B20maGg6oCdmggUIpPC1Sp4vuyBjpXk8G
         aeFJvpxIq6IMd5N1lEtuQa9+usMxFflGFMeuXdLU=
Received: by mail-oi1-f181.google.com with SMTP id s21so6950050oij.0
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 11:55:38 -0700 (PDT)
X-Gm-Message-State: AOAM531AhHhInuPHq6F8u56GHwOn3T2AUCFNTGfCdT4WpJJc+G+ThTr1
        cswtNtwN3tBIKxW7Swzr47tMHJCgzzubvECSfC8=
X-Google-Smtp-Source: ABdhPJypGgKKNSMkvBCTjuHI1MOLQVnfheKvVR82vYM5tBJmiexsP8YanBWqA47E0grs02uibc6jYhCtmQTEESDFIfI=
X-Received: by 2002:aca:d845:: with SMTP id p66mr6127082oig.47.1602960937466;
 Sat, 17 Oct 2020 11:55:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
 <20201017144430.GI456889@lunn.ch> <CAMj1kXHsNrRSkZfSJ_VatES+V1obLcvfo=Qab_4jy58Znpjy6Q@mail.gmail.com>
 <20201017151132.GK456889@lunn.ch> <CAMj1kXH+Z56dkZz8OYMhPuqbjPPCqW=UMV6w--=XXh87UyHVaQ@mail.gmail.com>
 <20201017161435.GA1768480@apalos.home> <CAMj1kXHXYprdC19m1S5p_LQ2BOHtDCbyCWCJ0eJ5xPxFv8hgoA@mail.gmail.com>
 <20201017180453.GM456889@lunn.ch> <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
 <20201017182738.GN456889@lunn.ch>
In-Reply-To: <20201017182738.GN456889@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 17 Oct 2020 20:55:26 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
Message-ID: <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 17 Oct 2020 at 20:27, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Oct 17, 2020 at 08:11:24PM +0200, Ard Biesheuvel wrote:
> > On Sat, 17 Oct 2020 at 20:04, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > I have tried this, and it seems to fix the issue. I will send out a
> > > > patch against the netsec driver.
> > >
> > > Please also fix the firmware so it does not pass rgmii.
> > >
> > > If there are pure DT systems, which do require phy-mode to be used, we
> > > will need to revert your proposed change in order to make the MAC
> > > driver work as it should, rather than work around the broken firmware.
> > >
> >
> > What do you mean by 'pure' DT system? Only EDK2 based firmware exists
> > for this platform
>
> Currently, only EDK2 based firmware exists. Is there anything stopping
> somebody using u-boot? ACPI is aimed for server class systems, on
> ARM. If anybody wants to use this SoC in am embedded setting, not
> server, then they are more likely to use DT, especially when you need
> a complex network, eg. an Ethernet switch. It seems like ACPI is too
> simple to support complex network hardware found in some embedded
> systems.
>
> > So what I propose to do is drop the handling of the [mandatory]
> > phy-mode device property from the netsec driver (which is really only
> > used by this board). As we don't really need a phy-mode to begin with,
> > and given that firmware exists in the field that passes the wrong
> > value, the only option I see for passing a value here is to use a
> > different, *optional* DT property (force-phy-mode or
> > phy-mode-override) that takes the place of phy-mode.
>
> No, sorry, this is an ACPI problem, not a DT problem. I don't want to
> accept DT hacks because of broken ACPI.
>
> We have been through this before, when the Atheros PHY fixed is RGMII
> delay support, and lots of platforms broke. Everybody just updated
> their DT and were happy. I see no reason why ACPI should be different.
>

I don't understand why you insist on framing this as a ACPI vs DT
issue. AFAICT, the only meaningful distinction here is between
firmware that configures the PHY and firmware that doesn't.

Broken firmware exists for this platform, and it provides incorrect DT
data as well as incorrect ACPI data, but it does configure the PHY.
Fixing that firmware involves fixing both, and it is easily updatable
on this platform, so it is almost as simple as dropping a new DT file
in your /boot partition. But you still need to do that.

So we can fix this firmware by just setting phy-mode to the empty string, right?

So the only question is how we deal with broken firmware. Again, I
don't see much point in distinguishing between DT and ACPI here, as in
both cases, the same action is required on the part of the user to
change something on their system before they can upgrade their kernel.
