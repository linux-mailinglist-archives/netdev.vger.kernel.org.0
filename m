Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553634507F8
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236543AbhKOPPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:15:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:48760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236613AbhKOPOH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 10:14:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A4663220;
        Mon, 15 Nov 2021 15:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636989071;
        bh=bcYj6Q8GqW3I6MVVnrq9F0y/4nVV0WtB/ff9SHPv/1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oVAV31zxNYUbO3vOu66A5bmeKWJdoSrD63BgGkXXimGVpQl9BrK4ouz7LRnKuGVRK
         tzAvwoKaCKD5bG4pC2lxyEEcr+Nd0d0U3CeYrieWavPI/uQ38bPJxtJ81+LgFlExKe
         An98zMle9CdEKpcteKDJuQbVwBVKGsc6tiIh1E2pNC4FxvZ4kROiFp/b8yTjv7uz0M
         5SMomBb1U5LsAzlyGi9fATkW6KingQS768UnF94UUZLfLMPNnMrp6Z3V+HYqoofL6+
         s+cAU5JMLwIEw6M/cn78s79/SOUrK0pOAdXv7MLhlv+C53R9cIY/OtzM50J37AA90O
         V0sm7io13zyCA==
Date:   Mon, 15 Nov 2021 07:11:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        sundeep subbaraya <sundeep.lkml@gmail.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Andrew Lunn <andrew@lunn.ch>, <argeorge@cisco.com>
Subject: Re: [EXT] Re: [net-next PATCH 1/2] octeontx2-pf: Add devlink param
 to init and de-init serdes
Message-ID: <20211115071109.1bf4875b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <952e8bb0-bc1e-5600-92f2-de4d6744fcb0@nvidia.com>
References: <YXmWb2PZJQhpMfrR@shredder>
        <BY3PR18MB473794E01049EC94156E2858C6859@BY3PR18MB4737.namprd18.prod.outlook.com>
        <YXnRup1EJaF5Gwua@shredder>
        <CALHRZuqpaqvunTga+8OK4GSa3oRao-CBxit6UzRvN3a1-T0dhA@mail.gmail.com>
        <YXqq19HxleZd6V9W@shredder>
        <CALHRZuoOWu0sEWjuanrYxyAVEUaO4-wea5+mET9UjPyoOrX5NQ@mail.gmail.com>
        <YYeajTs6d4j39rJ2@shredder>
        <20211108075450.1dbdedc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YY0uB7OyTRCoNBJQ@shredder>
        <20211111084719.600f072d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YZDK6JxwcoPvk/Zx@shredder>
        <952e8bb0-bc1e-5600-92f2-de4d6744fcb0@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Nov 2021 20:19:59 -0800 Roopa Prabhu wrote:
> On 11/14/21 12:38 AM, Ido Schimmel wrote:
> > On Thu, Nov 11, 2021 at 08:47:19AM -0800, Jakub Kicinski wrote:  
> >> Hm. How do we come up with the appropriate wording here...
> >>
> >> I meant keeping the "PHY level link" up? I think we agree that all the
> >> cases should behave like SFP power behaves today?
> >>
> >> The API is to control or query what is forcing the PHY link to stay up
> >> after the netdev was set down. IOW why does the switch still see link
> >> up if the link is down on Linux.  
> > The SFP power policy doesn't affect that. In our systems (and I believe
> > many others), by default, the transceivers are transitioned to high
> > power mode upon plug-in, but the link is still down when the netdev is
> > down because the MAC/PHY are not operational.

Ah, GTK!

> > With SRIOV/Multi-Host, the MAC/PHY are always operational which is why
> > your link partner has a carrier even when the netdev is down.

I see, I think you're talking about something like IFLA_VF_LINK_STATE_*
but for the PF. That could make sense, although I don't think it was
ever requested.

> >> I don't think we should report carrier up when netdev is down?  
> > This is what happens today, but it's misleading because the carrier is
> > always up with these systems. When I take the netdev down, I expect my
> > link partner to lose carrier. If this doesn't happen, then I believe the
> > netdev should always report IFF_UP. Alternatively, to avoid user space
> > breakage, this can be reported via a new attribute such as "protoup".

Sounds sensible.

> >> "proto" in "protodown" refers to STP, right?  
> > Not really. I believe the main use case was vrrp / mlag. 

VRRP is a proto, mlag maybe a little less clear-cut.

> > The "protdown_reason" is just a bitmap of user enumerated reasons to keep
> > the interface down. See commit 829eb208e80d ("rtnetlink: add support for
> > protodown reason") for details.  
> 
> correct. Its equivalent to errDisable found on most commercial switch OS'es.
> 
> Can be used for any control-plane/mgmt-plane/protocol wanting to hold 
> the link down.
> 
> Other use-cases where this can be used (as also quoted by other vendors):
> 
> mismatch of link properties

What link properties?

> Link Flapping detection and disable link
> Port Security Violation

Port security as established by a .. protocol like 802.1X ?

> Broadcast Storms
> etc

Why not take the entire interface down for bcast storm?

> >> Not sure what "proto" in "protoup" would be.  
> > sriov/multi-host/etc ?  
> 
> agree. Would be nice to re-use protodown ndo and state/reason here

You are the experts so correct me please but the point of protodown 
is that the the link is held down for general traffic but you can 
still exchange protocol messages on it. STP, VRRP, LAG, 802.1X etc.

For anything that does not require special message exchange the link
can be just brought down completely.

In my head link held up is a completely different beast, the local host
does not participate or otherwise pay attention to any communication on
the link. It's about what other entities do with the link.

But if you prefer "protoup" strongly that's fine, I guess.
