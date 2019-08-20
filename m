Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D322396C74
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 00:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730991AbfHTWgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 18:36:51 -0400
Received: from vps.xff.cz ([195.181.215.36]:47996 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730273AbfHTWgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 18:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1566340607; bh=uO4kjYw8eB31sD3ScgjYOEeWdoCbwJKmQbVJ8Gl4dXA=;
        h=Date:From:To:Cc:Subject:References:X-My-GPG-KeyId:From;
        b=IftA8aves13TnC73lV44LsdRpB+WM1z5DbPR9sKEE0wpwYniJBHO24p0/pqcqfo25
         hEm6tnj57PULGtClE7RjsDcPw0UkOMVpUuA5zVdFG/o+XPEPHNtI/pd6/OTrMAQ1Om
         B7Zx6T5OvA32ApNOziJ88cyVi19SfdFutjpj/p7I=
Date:   Wed, 21 Aug 2019 00:36:47 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 2/6] dt-bindings: net: sun8i-a83t-emac: Add phy-io-supply
 property
Message-ID: <20190820223647.n3a2mtdzigkbpc6x@core.my.home>
Mail-Followup-To: Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <mripard@kernel.org>, Chen-Yu Tsai <wens@csie.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com
References: <20190820145343.29108-1-megous@megous.com>
 <20190820145343.29108-3-megous@megous.com>
 <CAL_JsqLHeA6A_+ZgmCzC42Y6yJrEq6+D3vKn8ETh2D7LJ+1_-g@mail.gmail.com>
 <20190820163433.sr4lvjxmmhjtbtcb@core.my.home>
 <CAL_JsqJHNL91KMAP5ya97eiyTypGniCJ+tbP=NchPJK502i5FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqJHNL91KMAP5ya97eiyTypGniCJ+tbP=NchPJK502i5FQ@mail.gmail.com>
X-My-GPG-KeyId: EBFBDDE11FB918D44D1F56C1F9F0A873BE9777ED
 <https://xff.cz/key.txt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 20, 2019 at 11:57:06AM -0500, Rob Herring wrote:
> On Tue, Aug 20, 2019 at 11:34 AM Ondřej Jirman <megous@megous.com> wrote:
> >
> > On Tue, Aug 20, 2019 at 11:20:22AM -0500, Rob Herring wrote:
> > > On Tue, Aug 20, 2019 at 9:53 AM <megous@megous.com> wrote:
> > > >
> > > > From: Ondrej Jirman <megous@megous.com>
> > > >
> > > > Some PHYs require separate power supply for I/O pins in some modes
> > > > of operation. Add phy-io-supply property, to allow enabling this
> > > > power supply.
> > >
> > > Perhaps since this is new, such phys should have *-supply in their nodes.
> >
> > Yes, I just don't understand, since external ethernet phys are so common,
> > and they require power, how there's no fairly generic mechanism for this
> > already in the PHY subsystem, or somewhere?
> 
> Because generic mechanisms for this don't work. For example, what
> happens when the 2 supplies need to be turned on in a certain order
> and with certain timings? And then add in reset or control lines into
> the mix... You can see in the bindings we already have some of that.

I've looked at the emac bindings that have phy-supply, and don't see reason
why this can't be generic for the phy. Just like there's generic reset
properties for phys, now. Some bindings, like fsl-fec.txt even list
custom reset properties for phy as deprecated, and recommend using
generic ones.

From the point of the view of the emac driver, it just wants to power on/power
off the phy, and wait until it's ready to be communicated with.

It's probably better to have power supplies of the phy covered by generic
phy code, because then you don't have to duplicate all this special power
up logic in every emac driver, whenever a HW designer decides to combine
such emac with external phy that requires some special hadnling on powerup.

At the moment, this lack of flexibility is hacked around by adding multiple
regulators to the DTS, and making them dependent on each other (even if one
doesn't supply the other), just because this makes the regulator core driver
enable them all. Power up delays for the PHY are described as enable-ramp-delays
on the regulators (actual regulator ramp delay + wait time for PHY to initialize).

Basically just hacking the DT so that the Linux kernel in the end does what's
necessary, instead of DT describing the actual HW.

Adding a single supply property to the phy node, as you suggest will do nothing
to help this situation. It will just result in a more complicated dwmac-sun8i
driver and will not help anyone in the future.

So I think, maybe phy powerup should be moved to generic code, just like the
phy reset code was. Generic code can have multiple supplies and some generic
way to specify power up order and timings.

But I guess, this patch series is a dead end.

> > It looks like other ethernet mac drivers also implement supplies on phys
> > on the EMAC nodes. Just grep phy-supply through dt-bindings/net.
> >
> > Historical reasons, or am I missing something? It almost seems like I must
> > be missing something, since putting these properties to phy nodes
> > seems so obvious.
> 
> Things get added one by one and one new property isn't that
> controversial. We've generally learned the lesson and avoid this
> pattern now, but ethernet phys are one of the older bindings.

Understood. So maybe the solution suggested above would improve the situation
eventually?

regards,
	o.

> Rob
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
