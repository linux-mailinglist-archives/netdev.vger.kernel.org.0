Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DFA2BABC3
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 15:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgKTOTB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 09:19:01 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:36423 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgKTOTB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 09:19:01 -0500
X-Originating-IP: 90.55.104.168
Received: from bootlin.com (atoulouse-258-1-33-168.w90-55.abo.wanadoo.fr [90.55.104.168])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 21FF320007;
        Fri, 20 Nov 2020 14:18:55 +0000 (UTC)
Date:   Fri, 20 Nov 2020 15:18:52 +0100
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201120151852.369f6d23@bootlin.com>
In-Reply-To: <20201120135517.GH1804098@lunn.ch>
References: <20201119152246.085514e1@bootlin.com>
        <20201119145500.GL1551@shell.armlinux.org.uk>
        <20201119162451.4c8d220d@bootlin.com>
        <87k0uh9dd0.fsf@waldekranz.com>
        <20201119231613.GN1551@shell.armlinux.org.uk>
        <87eekoanvj.fsf@waldekranz.com>
        <20201120103601.313a166b@bootlin.com>
        <20201120102538.GP1551@shell.armlinux.org.uk>
        <20201120135517.GH1804098@lunn.ch>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell, Andrew,

On Fri, 20 Nov 2020 14:55:17 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

>On Fri, Nov 20, 2020 at 10:25:38AM +0000, Russell King - ARM Linux admin wrote:
>> On Fri, Nov 20, 2020 at 10:36:01AM +0100, Maxime Chevallier wrote:  
>> > So maybe we could be a bit more generic, with something along these lines :
>> > 
>> >     ethernet-phy@0 {
>> >         ...
>> > 
>> >         mdi {
>> >             port@0 {
>> >                 media = "10baseT", "100baseT", "1000baseT";
>> >                 pairs = <1>;
>> > 	    };
>> > 
>> >             port@1 {
>> >                 media = "1000baseX", "10gbaseR"
>> >             };
>> >         };
>> >     };  
>> 
>> Don't forget that TP requires a minimum of two pairs.  
>
>Hi Russell
>
>Well, actually, there are automotive PHYs which use just one pair, so
>called T1 PHYs. We have drivers for i think two so far, with one more
>on the way.
>
>You also have to watch out for 'clever' PHYs. The Aquantia PHY can do
>1000Base-T2, i.e. 1G over two pairs. This might be a proprietary
>extension, rather than standardized, but it shows it can be done. So
>you have to be careful about assumptions based on the number of pairs.

You're right that the "pairs" property might not be needed, if we
have an appropriate media string for each mode ( maybe "1000baseT1" and
"1000baseT2" for the 2 modes you're referencing ? ).

I can also see other use-cases where having an indication of the nature
of the media interface we want to use for a PHY can be useful.

If the overall idea of having such a representation of the mdi info is
something that you can see being adopted, I'll work on a first draft
implementation to see what this looks like.

Thanks for you inputs !

Maxime
