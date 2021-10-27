Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265DC43BE68
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 02:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235097AbhJ0AR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 20:17:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60694 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231934AbhJ0ARv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 20:17:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QRQCWyUN0gunmnnuPg07djUb3lnRU9WfdiA+eRyQ9C4=; b=lKPSXdloXem3B7S8pgGKWc8kyU
        Tt64+25jf1IpfznRy2PZrKvU2ScgnMB6grVeFMLaoma/6ABFAZCKYaDGF1IG5vLmxhmfdu8ISeCHU
        kHZkwpXxNg/myZxtqB6smHnv5qul6bEtlmXJzbmOarw+Lk2kW0b44eR2+O3Xvr3meRuA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mfWbD-00BprH-2Y; Wed, 27 Oct 2021 02:15:23 +0200
Date:   Wed, 27 Oct 2021 02:15:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Schlabbach <Robert.Schlabbach@gmx.net>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: Re: ixgbe: How to do this without a module parameter?
Message-ID: <YXiaG1q6Uw1xUsJx@lunn.ch>
References: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
 <87k0i0bz2a.fsf@toke.dk>
 <YXcdmyONutFH8E6l@lunn.ch>
 <trinity-cc7ee762-b84d-4980-b38c-a8083fd0c1ff-1635292252562@3c-app-gmx-bs06>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-cc7ee762-b84d-4980-b38c-a8083fd0c1ff-1635292252562@3c-app-gmx-bs06>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 01:50:52AM +0200, Robert Schlabbach wrote:
> "Andrew Lunn" <andrew@lunn.ch> wrote:
> > > Personally I wouldn't mind having this (symbolic names) for all the
> > > supported advertised modes; I also think it's a pain to have to go
> > > lookup the bit values whenever I need to change this...
> >
> > Something like this has been talked about before, but nobody ever
> > spent the time to do it. ethtool has all the needed strings, so it
> > should not be too hard to actually do for link modes.
> 
> It appears somebody already did, because I found that my Debian 11.1
> server (with kernel version 5.14) actually takes this command:
> 
> $ ethtool -s eno3 advertise 2500baseT/Full on 5000baseT/Full on
> 
> The parsing seems to be implemented in the kernel, because when I copy
> the binary over to my Ubuntu machine (with kernel version 4.15), any
> attempt to specify a link mode name only yields:

Actually, it might not be. A kernel that old might not have netlink
ethtool, just the old ioctl interface. It could be the command line
parsing is dependent on which API is used to the kernel.

ethtool --debug 255 eno3

will show you the netlink messages going back and forth.

	Andrew
