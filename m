Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA55429822B
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 15:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415385AbgJYOeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 10:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1415116AbgJYOeT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 10:34:19 -0400
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1ECC421707
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603636458;
        bh=Vr8Ubwbevn/vNdBLeMlO4AStNBvRK/p63OEXNjL8EFA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jpOGdCy6plkGu95bEQ6G44bRyGap0Fz7BW5EBAs2lvUBGiQRv2Tm0dO6epHKoVojS
         dj6d9kOupdL2yDEcsKNli7I9EFTcSEc2v5mDfqm3eYo7fWtEYsiuOnCUMZ+AX3v6FG
         /dK/Fk4D+2NoQVLYd+YF3F/NHFI7AY4uSwu7LNF8=
Received: by mail-oi1-f177.google.com with SMTP id j7so7856041oie.12
        for <netdev@vger.kernel.org>; Sun, 25 Oct 2020 07:34:18 -0700 (PDT)
X-Gm-Message-State: AOAM532Wq/a1NTWDPi6zGbRGPmEZnYeJbCycbtN4KpfVPXPyPgEaxoD2
        BDZwjR9QzIGtBbFkjMhIleprwokUgdF0r5NU62Q=
X-Google-Smtp-Source: ABdhPJw+sxjXJl81GAR83/bCRwVm3IF4sIHeMnC7SMmG94kOUas109XlKNcQnabzIGYFUxKI/0EuHidCOchoZ0jkf9c=
X-Received: by 2002:aca:5a56:: with SMTP id o83mr7644212oib.47.1603636457422;
 Sun, 25 Oct 2020 07:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXEcrULejk+h1Jv42W=r7odQ9Z_G0XDX_KrEnYYPEVgHkA@mail.gmail.com>
 <20201017182738.GN456889@lunn.ch> <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
 <20201017194904.GP456889@lunn.ch> <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
 <20201017230226.GV456889@lunn.ch> <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
 <CAMj1kXF_mRBnTzee4j7+e9ogKiW=BXQ8-nbgq2wDcw0zaL1d5w@mail.gmail.com>
 <20201018154502.GZ456889@lunn.ch> <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
 <20201025142856.GC792004@lunn.ch>
In-Reply-To: <20201025142856.GC792004@lunn.ch>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 25 Oct 2020 15:34:06 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
Message-ID: <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
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

On Sun, 25 Oct 2020 at 15:29, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sun, Oct 25, 2020 at 03:16:36PM +0100, Ard Biesheuvel wrote:
> > On Sun, 18 Oct 2020 at 17:45, Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > However, that leaves the question why bbc4d71d63549bcd was backported,
> > > > although I understand why the discussion is a bit trickier there. But
> > > > if it did not fix a regression, only broken code that never worked in
> > > > the first place, I am not convinced it belongs in -stable.
> > >
> > > Please ask Serge Semin what platform he tested on. I kind of expect it
> > > worked for him, in some limited way, enough that it passed his
> > > testing.
> > >
> >
> > I'll make a note here that a rather large number of platforms got
> > broken by the same fix for the Realtek PHY driver:
> >
> > https://lore.kernel.org/lkml/?q=bbc4d71d6354
> >
> > I seriously doubt whether disabling TX/RX delay when it is enabled by
> > h/w straps is the right thing to do here.
>
> The device tree is explicitly asking for rgmii. If it wanted the
> hardware left alone, it should of used PHY_INTERFACE_MODE_NA.
>

Would you suggest that these DTs remove the phy-mode instead? As I
don't see anyone proposing that.

> But we might be able to compromise for a cycle or two. As far as i
> understand the hardware, we can read the strapping. If we find the
> strapping resisters are present, but rgmii is in DT, print a warning
> that the device tree needs upgrading, and ignore the DT mode. We can
> add this to stable, but not net-next.
>

That sounds reasonable, given how many different platforms seem to be
affected, and production ones may be running stable distro kernels,
and not expecting their Ethernet to fail without warning.
