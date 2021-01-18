Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D497F2FAC3B
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 22:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394526AbhARVJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 16:09:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:32808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389300AbhARVJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 16:09:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F9DB2225E;
        Mon, 18 Jan 2021 21:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611004097;
        bh=rpYvfChIYT1ZHXeq+b+1zRTI7YXpjh33vZxhlYW9Q+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MNIadjjWU+U6VKbcgyB6tbo1reOaH5apu0AUZYL0S3gNVopZ4W6knOpyzsB16ijsn
         iLFawFtTNiDNRZeNzX1unLr5jPW5XTwpKP427nK/12IkJtYzv9omu0za7j4D1A4yQt
         PhRMHx3uO5Jl20sSVU64n3WX0jsbV7ACwAmL7KM5myulDBjxY3PQxKan9gaDudjPBO
         lBhaYbMEzWzTC/blVN5L5HPN3sga0nzxCi0a+iJkF7UBL6EUWDxRxoc78zfIDlsoJc
         dShBl7yRomhD9XFnSAZS1QLAqGcw3kigyTDiSjTFprV7iUGiYODUMy6fYKteBFkGlx
         GN6rF+d4fHyxA==
Date:   Mon, 18 Jan 2021 13:08:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH 0/2] net: dsa: mv88e6xxx: fix vlan filtering for 6250
Message-ID: <20210118130816.19e7d50d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <97021b7f-d1d9-b33f-f6ef-de3df83c17e5@prevas.dk>
References: <20210116023937.6225-1-rasmus.villemoes@prevas.dk>
        <20210117210858.276rk6svvqbfbfol@skbuf>
        <97021b7f-d1d9-b33f-f6ef-de3df83c17e5@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 14:22:57 +0100 Rasmus Villemoes wrote:
> On 17/01/2021 22.08, Vladimir Oltean wrote:
> > Hi Rasmus,
> > 
> > On Sat, Jan 16, 2021 at 03:39:34AM +0100, Rasmus Villemoes wrote:  
> >> I finally managed to figure out why enabling VLAN filtering on the
> >> 6250 broke all (ingressing) traffic,
> >> cf. https://lore.kernel.org/netdev/6424c14e-bd25-2a06-cf0b-f1a07f9a3604@prevas.dk/
> >> .
> >>
> >> The first patch is the minimal fix and for net, while the second one
> >> is a little cleanup for net-next.
> >>
> >> Rasmus Villemoes (2):
> >>   net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext
> >>   net: dsa: mv88e6xxx: use mv88e6185_g1_vtu_getnext() for the 6250  
> > 
> > It's strange to put a patch for net and one for net-next in the same
> > series.   
> 
> Well, maybe, but one is a logical continuation of the other, and
> including the second one preempted review comments saying "why don't you
> merge the two implementations".
> 
> > But is there any reason why you don't just apply the second patch to
> > "net"?  
> 
> That's not really for me to decide? I thought net was just for the
> things that needed fixing and should be sent to -stable - which is the
> only reason I even split this in two, so there's a minimal logical fix
> for the 6250. Otherwise I'd just have squashed the two, so that I don't
> add lines only to delete them, along with the rest of the function, later.
> 
> Jakub, David, it's up to you.

Vladimir is right, this is a strange way to post things. In the future
please send just the "net" changes first and include a note in the
cover letter or under "---" saying something like "cleanup of XYZ is
left for a followup in -next".

I've applied patch 1 please resend the cleanup after net->net-next
merge (~Friday).

Thanks!
