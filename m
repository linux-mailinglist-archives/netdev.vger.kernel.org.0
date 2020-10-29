Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9709429EE81
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgJ2Ojm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:39:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52338 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgJ2Ojm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 10:39:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kY95S-004Azi-U5; Thu, 29 Oct 2020 15:39:34 +0100
Date:   Thu, 29 Oct 2020 15:39:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
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
        Masahisa Kojima <masahisa.kojima@linaro.org>
Subject: Re: realtek PHY commit bbc4d71d63549 causes regression
Message-ID: <20201029143934.GO878328@lunn.ch>
References: <CAMj1kXEY5jK7z+_ezDX733zbtHnaGUNCkJ_gHcPqAavOQPOzBQ@mail.gmail.com>
 <20201017230226.GV456889@lunn.ch>
 <CAMj1kXGO=5MsbLYvng4JWdNhJ3Nb0TSFKvnT-ZhjF2xcO9dZaw@mail.gmail.com>
 <CAMj1kXF_mRBnTzee4j7+e9ogKiW=BXQ8-nbgq2wDcw0zaL1d5w@mail.gmail.com>
 <20201018154502.GZ456889@lunn.ch>
 <CAMj1kXGQDeOGj+2+tMnPhjoPJRX+eTh8-94yaH_bGwDATL7pkg@mail.gmail.com>
 <20201025142856.GC792004@lunn.ch>
 <CAMj1kXEM6a9wZKqqLjVACa+SHkdd0L6rRNcZCNjNNsmC-QxoxA@mail.gmail.com>
 <20201025144258.GE792004@lunn.ch>
 <20201029142100.GA70245@apalos.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029142100.GA70245@apalos.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What about reverting the realtek PHY commit from stable?
> As Ard said it doesn't really fix anything (usage wise) and causes a bunch of
> problems.
> 
> If I understand correctly we have 3 options:
> 1. 'Hack' the  drivers in stable to fix it (and most of those hacks will take 
>    a long time to remove)
> 2. Update DTE of all affected devices, backport it to stable and force users to
> update
> 3. Revert the PHY commit
> 
> imho [3] is the least painful solution.

The PHY commit is correct, in that it fixes a bug. So i don't want to
remove it.

Backporting it to stable is what is causing most of the issues today,
combined with a number of broken DT descriptions. So i would be happy
for stable to get a patch which looks at the strapping, sees ID is
enabled via strapping, warns the DT blob is FUBAR, and then ignores
the requested PHY-mode. That gives developers time to fix their broken
DT.

	  Andrew
