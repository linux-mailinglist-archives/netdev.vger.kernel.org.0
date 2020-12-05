Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218E72CFF61
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 22:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgLEVud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 16:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725270AbgLEVud (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 16:50:33 -0500
Date:   Sat, 5 Dec 2020 13:49:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607204992;
        bh=gXfixLh3Wl0pMJNSTP6c2WRTbt7SK2Gprz8Bo/ScJsc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=TRWi71Oe7UAI05PhXqqdv7ut2pUsbmaiKTLD91p5uF0wLTBQAfWGCKge0aoGgBJlm
         2Wtona7IoppMtbU2Gtaxc9paZFmo0qkya8lUzezlMm1JD6dQJG4J8fJSdoNsBczFhF
         JEzhucXHQyz3fOXesAtotAyZ4IHHu2wV3TIvw1NVl4T4RQ7jRPU11RgDHCtoEfS3QA
         PZt/hqkNbHiY9E5Mi1bHtKoI+oA4KLURdxKn84100AwKK+Pf9IJnKyl1N84/pb0JVl
         aRTv6M2hQzQm/tXonS/4R9Bwc4pbvfUlSgOiZEffBGQ9eGULbkf4Ii2bMjGvA6Ydzu
         wmq2P+ba5DUVw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] vrf: packets with lladdr src needs dst at input
 with orig_iif when needs strict
Message-ID: <20201205134951.21aff7a6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201205002227.GA8699@ICIPI.localdomain>
References: <20201204030604.18828-1-ssuryaextr@gmail.com>
        <6199335a-c50f-6f04-48e2-e71129372a35@gmail.com>
        <20201204153748.00715355@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <20201205002227.GA8699@ICIPI.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 19:22:27 -0500 Stephen Suryaputra wrote:
> On Fri, Dec 04, 2020 at 03:37:48PM -0800, Jakub Kicinski wrote:
> > On Fri, 4 Dec 2020 09:32:04 -0700 David Ahern wrote:  
> > > On 12/3/20 8:06 PM, Stephen Suryaputra wrote:  
> > > > Depending on the order of the routes to fe80::/64 are installed on the
> > > > VRF table, the NS for the source link-local address of the originator
> > > > might be sent to the wrong interface.
> > > > 
> > > > This patch ensures that packets with link-local addr source is doing a
> > > > lookup with the orig_iif when the destination addr indicates that it
> > > > is strict.
> > > > 
> > > > Add the reproducer as a use case in self test script fcnal-test.sh.
> > > > 
> > > > Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
> > > > ---
> > > >  drivers/net/vrf.c                         | 10 ++-
> > > >  tools/testing/selftests/net/fcnal-test.sh | 95 +++++++++++++++++++++++
> > > >  2 files changed, 103 insertions(+), 2 deletions(-)  
> > > 
> > > Reviewed-by: David Ahern <dsahern@kernel.org>  
> > 
> > Should I put something like:
> > 
> > Fixes: b4869aa2f881 ("net: vrf: ipv6 support for local traffic to local addresses")
> > 
> > on this?  
> 
> I was conflicted when I was about to put Fixes tag on this patch because
> it could either be b4869aa2f881 that you mentioned above, or 6f12fa7755301
> ("vrf: mark skb for multicast or link-local as enslaved to VRF"). So, I
> decided not to put it, but may be I should so that this is qualified to
> be queued to stable?

Yeah, probably doesn't matter that much in practice. Either one would
work, since the patch won't apply without 6f12fa7755301.

I added the one I mentioned and applied to net.

Thanks!
