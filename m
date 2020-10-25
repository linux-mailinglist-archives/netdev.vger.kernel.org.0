Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5447529822F
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 15:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415755AbgJYOnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 10:43:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1415744AbgJYOnB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Oct 2020 10:43:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kWhEY-003RGN-OR; Sun, 25 Oct 2020 15:42:58 +0100
Date:   Sun, 25 Oct 2020 15:42:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
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
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201025144258.GE792004@lunn.ch>
References: <CAMj1kXHwYkd0L63K3+e_iwfoSYEUOmYdWf_cKv90_qVXSxEesg@mail.gmail.com>
 <20201017194904.GP456889@lunn.ch>
 <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
 <20201017230226.GV456889@lunn.ch>
 <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
 <CAMj1kXF_mRBnTzee4j7+e9ogKiW=BXQ8-nbgq2wDcw0zaL1d5w@mail.gmail.com>
 <20201018154502.GZ456889@lunn.ch>
 <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
 <20201025142856.GC792004@lunn.ch>
 <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 03:34:06PM +0100, Ard Biesheuvel wrote:
> On Sun, 25 Oct 2020 at 15:29, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sun, Oct 25, 2020 at 03:16:36PM +0100, Ard Biesheuvel wrote:
> > > On Sun, 18 Oct 2020 at 17:45, Andrew Lunn <andrew@lunn.ch> wrote:
> > > >
> > > > > However, that leaves the question why bbc4d71d63549bcd was backported,
> > > > > although I understand why the discussion is a bit trickier there. But
> > > > > if it did not fix a regression, only broken code that never worked in
> > > > > the first place, I am not convinced it belongs in -stable.
> > > >
> > > > Please ask Serge Semin what platform he tested on. I kind of expect it
> > > > worked for him, in some limited way, enough that it passed his
> > > > testing.
> > > >
> > >
> > > I'll make a note here that a rather large number of platforms got
> > > broken by the same fix for the Realtek PHY driver:
> > >
> > > https://lore.kernel.org/lkml/?q=bbc4d71d6354
> > >
> > > I seriously doubt whether disabling TX/RX delay when it is enabled by
> > > h/w straps is the right thing to do here.
> >
> > The device tree is explicitly asking for rgmii. If it wanted the
> > hardware left alone, it should of used PHY_INTERFACE_MODE_NA.
> >
> 
> Would you suggest that these DTs remove the phy-mode instead? As I
> don't see anyone proposing that.

What is also O.K, for most MAC drivers. Some might enforce it is
present, in which case, you can set it to "", which will get parsed as
PHY_INTERFACE_MODE_NA. But a few MAC drivers might configure there MII
bus depending on the PHY mode, RGMII vs GMII.

    Andrew
