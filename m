Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3742B1D9E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 15:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgKMOoH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 09:44:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726267AbgKMOoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 09:44:07 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kdaIz-006rmR-72; Fri, 13 Nov 2020 15:44:01 +0100
Date:   Fri, 13 Nov 2020 15:44:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Jernej =?utf-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steve McIntyre <steve@einval.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>, Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201113144401.GM1456319@lunn.ch>
References: <20201017230226.GV456889@lunn.ch>
 <20201029143934.GO878328@lunn.ch>
 <20201029144644.GA70799@apalos.home>
 <2697795.ZkNf1YqPoC@kista>
 <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2hBpQAsRekNyauUF1MgdO8CON=77MNSd0E-U1TWNT-gA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Sadly, there is one board - Pine64 Plus - where HW settings are wrong and it
> > actually needs SW override. Until this Realtek PHY driver fix was merged, it
> > was unclear what magic value provided by Realtek to board manufacturer does.
> >
> > Reference:
> > https://lore.kernel.org/netdev/20191001082912.12905-3-icenowy@aosc.io/
> 
> I have merged the fixes from the allwinner tree now, but I still think we
> need something better than this, as the current state breaks any existing
> dtb file that has the incorrect values, and this really should not have been
> considered for backporting to stable kernels.

Hi Arnd

This PHY driver bug hiding DT bug is always hard to handle. We have
been though it once before with the Atheros PHY. All the buggy DT
files were fixed in about one cycle.

Now that we know there is a board which really does want rgmii when it
says rgmii, we cannot simply ignore it in the PHY driver.

But the whole story is muddy because of the backport to stable.  It
might make sense to revert the stable change, and just leave HEAD
broken. That then gives people more time to fix DT blobs. But we have
to consider Pine64 Plus, are we happy breaking that for a while, when
it is actually doing everything correct, and is bug free?

	 Andrew
