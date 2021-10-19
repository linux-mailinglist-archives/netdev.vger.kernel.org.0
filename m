Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0B9433E6A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbhJSSbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:31:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47348 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234738AbhJSSbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=K4bmpxjUABK2VjQu377WvFa/RSa+W3Zp84SaOUJXuSk=; b=R+Gf+Ofnbuja4TXNg0EcZhF4sH
        b65vWitDJDTM4WliSU0kUbJoItMn9vxcem1ewn3OIVgPLRfEHbbrJdfeMLZCkuB5MoZQszSh84oBt
        iyWL2FH5QDOuCjK1cX/Plya6EdwWAT/usfyfZvUErmiAyP/vwwZpoCdLwW/nG6v7+ado=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mctrc-00B75E-Ax; Tue, 19 Oct 2021 20:29:28 +0200
Date:   Tue, 19 Oct 2021 20:29:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sfc: Fix reading non-legacy supported link modes
Message-ID: <YW8OiIpcncIaANzN@lunn.ch>
References: <20211017171657.85724-1-erik@kryo.se>
 <YW7idC0/+zq6dDNv@lunn.ch>
 <CAGgu=sCBUU29tkjqOP9j7EZJL-T4O6NoTDNB+-PFNhUkOTdWuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGgu=sCBUU29tkjqOP9j7EZJL-T4O6NoTDNB+-PFNhUkOTdWuw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 07:41:46PM +0200, Erik Ekman wrote:
> On Tue, 19 Oct 2021 at 17:21, Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > On Sun, Oct 17, 2021 at 07:16:57PM +0200, Erik Ekman wrote:
> > > Everything except the first 32 bits was lost when the pause flags were
> > > added. This makes the 50000baseCR2 mode flag (bit 34) not appear.
> > >
> > > I have tested this with a 10G card (SFN5122F-R7) by modifying it to
> > > return a non-legacy link mode (10000baseCR).
> >
> > Does this need a Fixes: tag? Should it be added to stable?
> >
> 
> The speed flags in use that can be lost are for 50G and 100G.
> The affected devices are ones based on the Solarflare EF100 networking
> IP in Xilinx FPGAs supporting 10/25/40/100-gigabit.
> I don't know how widespread these are, and if there might be enough
> users for adding this to stable.
> 
> The gsettings api code for sfc was added in 7cafe8f82438ced6d ("net:
> sfc: use new api ethtool_{get|set}_link_ksettings")
> and the bug was introduced then, but bits would only be lost after
> support for 25/50/100G was added in
> 5abb5e7f916ee8d2d ("sfc: add bits for 25/50/100G supported/advertised speeds").
> Not sure which of these should be used for a Fixes tag.

I would you this second one, since that is when it becomes visible to
users.

	Andrew
