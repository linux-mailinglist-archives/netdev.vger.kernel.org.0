Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FB4443442
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 18:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhKBRGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 13:06:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43588 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229764AbhKBRGO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 13:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=X1SxFyX2iqG03dwv1qmgxvXJLlaFcfbpylT4dZkBbAw=; b=a2vA1DpjvFQw/0UgaG2h8+FT/n
        y58OwNpdtFaL8zlejTqZbZ1aE4/bSrURZfq6pyvPN5DLL+HPEcVc1xo6MXj6p7QWAZL6o8RVZQb8l
        PUQWXkBwcTUaQ8lD8VfX/lTWnAg0kRJ9pvAS5Gkj0f81UzsH8JRU7Z4gvT9MURTwfY3U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mhxC9-00CQGA-AX; Tue, 02 Nov 2021 18:03:33 +0100
Date:   Tue, 2 Nov 2021 18:03:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 0/5] Code movement to br_switchdev.c
Message-ID: <YYFvZRCo4Ac4/Zll@lunn.ch>
References: <20211027162119.2496321-1-vladimir.oltean@nxp.com>
 <YYACSc+qv2jMzg/B@nanopsycho>
 <20211102111159.f5rxiqxnramrnerh@skbuf>
 <YYEl4QS6iYSJtzJP@nanopsycho>
 <20211102120206.ak2j7dnhx6clvd46@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102120206.ak2j7dnhx6clvd46@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 02, 2021 at 12:02:06PM +0000, Vladimir Oltean wrote:
> On Tue, Nov 02, 2021 at 12:49:53PM +0100, Jiri Pirko wrote:
> > Tue, Nov 02, 2021 at 12:11:59PM CET, vladimir.oltean@nxp.com wrote:
> > >On Mon, Nov 01, 2021 at 04:05:45PM +0100, Jiri Pirko wrote:
> > >> Wed, Oct 27, 2021 at 06:21:14PM CEST, vladimir.oltean@nxp.com wrote:
> > >> >This is one more refactoring patch set for the Linux bridge, where more
> > >> >logic that is specific to switchdev is moved into br_switchdev.c, which
> > >> >is compiled out when CONFIG_NET_SWITCHDEV is disabled.
> > >> 
> > >> Looks good.
> > >> 
> > >> While you are at it, don't you plan to also move switchdev.c into
> > >> br_switchdev.c and eventually rename to br_offload.c ?
> > >> 
> > >> Switchdev is about bridge offloading only anyway.
> > >
> > >You mean I should effectively make switchdev part of the bridge?
> > 
> > Yes.
> 
> Ok, have you actually seen the commit message linked below? Basically it
> says that there are drivers that depend on switchdev.c being this
> neutral third party, forwarding events on notifier chains back and forth
> between the bridge and the drivers. If we make switchdev.c part of the
> bridge, then drivers can no longer be compiled without bridge support.

This is something i test every so often, building without the
bridge. The simplest DSA drivers just provide a 'port multiplexor', no
offload at all. You can put IP addresses on the interfaces and
software route between them etc.

So i would prefer this use case does not break.

   Andrew
