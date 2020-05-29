Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59E3F1E828C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgE2Pw2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 May 2020 11:52:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:51454 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727076AbgE2Pw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 11:52:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1532AACB8;
        Fri, 29 May 2020 15:52:26 +0000 (UTC)
Date:   Fri, 29 May 2020 17:52:25 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-Id: <20200529175225.a3be1b4faaa0408e165435ad@suse.de>
In-Reply-To: <20200529145928.GF869823@lunn.ch>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
        <20200528130738.GT1551@shell.armlinux.org.uk>
        <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
        <20200528135608.GU1551@shell.armlinux.org.uk>
        <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
        <20200528144805.GW1551@shell.armlinux.org.uk>
        <20200528204312.df9089425162a22e89669cf1@suse.de>
        <20200528220420.GY1551@shell.armlinux.org.uk>
        <20200529130539.3fe944fed7228e2b061a1e46@suse.de>
        <20200529145928.GF869823@lunn.ch>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 May 2020 16:59:28 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> On Fri, May 29, 2020 at 01:05:39PM +0200, Thomas Bogendoerfer wrote:
> > On Thu, 28 May 2020 23:04:20 +0100
> > Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> > 
> > > Can you explain this please?  Just as we think we understand what's
> > > going on here, you throw in a new comment that makes us confused.
> > 
> > sorry about that.
> > 
> > > You said previously that the mvpp2 was connected to a switch, which
> > > makes us think that you've got some DSA-like setup going on here.
> > > Does your switch drop its serdes link when all the external links
> > > (presumably the 10G SFP+ cages) fail?
> > > 
> > > Both Andrew and myself wish to have a complete picture before we
> > > move forward with this.
> > 
> > full understandable, I'll try by a small picture, which just
> > covers one switch:
> > 
> >         external ports
> >       |  |          |  |
> > *-----------------------------*
> > |     1  1          2  2      |
> > |                             |
> > |           switch            |
> > |                             |
> > |   1   2            1   2    |
> > *-----------------------------*
> >     |   |            |   |
> >     |   |            |   |
> > *----------*     *----------*
> > |   1   2  |     |   1   2  |
> > |          |     |          |
> > |  node 1  | ... |  node 8  |
> > |          |     |          |
> > *----------*     *----------*
> > 
> > External ports a grouped in ports to network 1 and network 2. If one of the
> > external ports has an established link, this link state will be propagated
> > to the internal ports. Same when both external ports of a network are down.
> 
> By propagated, you mean if the external link is down, the link between
> the switch and node 1 will also be forced down, at the SERDES level?

yes

> And if external ports are down, the nodes cannot talk to each other?

correct

> External link down causes the whole in box network to fall apart? That
> seems a rather odd design.

as I'm not an expert in ceph, I can't judge. But I'll bring it up.

> > I have no control over the software running on the switch, therefore I can't
> > enable autoneg on the internal links.
> 
> O.K. So that means using in-band signalling in DT is clearly
> wrong. There is no signalling....
> 
> What you are actually interested in is the sync state of the SERDES?
> The link is up if the SERDES has sync.

yes, that's what I need. How can I do that ?

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
