Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC531E6E59
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436866AbgE1WEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436730AbgE1WEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 18:04:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91204C08C5C6;
        Thu, 28 May 2020 15:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Bt2h7rfOaK/tkLrJKxNWOCgPHxrv405JYv6YKsjsrUA=; b=j1r/mV0gy3+Rsbb9SW8Nbi6r6
        RRGZzanlnqaVZo79+jZJr7wL4NJUl4Sov4aLiCSBwynnChBEIVOZOHve7zQMKolFb/FEYNIG+k3Dx
        FLBN5kI0JL4PXrb037vulOaJAyD6Ce28f7tGN2doUcpkTEQpbgjARB3ErnkysUav80PHr9F1YzbgZ
        YKjJ8YR1IY5h04QbT33eXJeh+nLAtb8EEccvAa83Uao3E9J072WSXO7N9II99muKAWImY0Z91Uedl
        J08uBtu03yhHufdWWWyX3IS5iB8HjNFSpXFNa+Dl0/E7cjCceGQmQ4nb2I3j/HBZL3r0EiDcI1aHD
        lmYVsu6XQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:35846)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jeQdW-0006Y0-VU; Thu, 28 May 2020 23:04:27 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jeQdQ-0007pL-94; Thu, 28 May 2020 23:04:20 +0100
Date:   Thu, 28 May 2020 23:04:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200528220420.GY1551@shell.armlinux.org.uk>
References: <20200528121121.125189-1-tbogendoerfer@suse.de>
 <20200528130738.GT1551@shell.armlinux.org.uk>
 <20200528151733.f1bc2fcdcb312b19b2919be9@suse.de>
 <20200528135608.GU1551@shell.armlinux.org.uk>
 <20200528163335.8f730b5a3ddc8cd9beab367f@suse.de>
 <20200528144805.GW1551@shell.armlinux.org.uk>
 <20200528204312.df9089425162a22e89669cf1@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528204312.df9089425162a22e89669cf1@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 08:43:12PM +0200, Thomas Bogendoerfer wrote:
> On Thu, 28 May 2020 15:48:05 +0100
> Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> 
> > On Thu, May 28, 2020 at 04:33:35PM +0200, Thomas Bogendoerfer wrote:
> > > below is the dts part for the two network interfaces. The switch to
> > > the outside has two ports, which correlate to the two internal ports.
> > > And the switch propagates the link state of the external ports to
> > > the internal ports.
> > 
> > Okay, so this DTS hasn't been reviewed...
> 
> that's from our partner, I'm just using it. Stripping it down isn't
> the point for my now.
> 
> > This isn't correct - you are requesting that in-band status is used
> > (i.o.w. the in-band control word, see commit 4cba5c210365), but your
> > bug report wants to enable AN bypass because there is no in-band
> > control word.  This seems to be rather contradictory.
> > 
> > May I suggest you use a fixed-link here, which will not have any
> 
> afaik fixed-link will always be up, and we want to have the link state
> from the switch external ports.
> 
> > inband status, as there is no in-band control word being sent by
> > the switch?  That is also the conventional way of handling switch
> > links.
> 
> again, we want to propagte the external link state inside to all
> the internal nodes. So this will not work anymore with fixed-link.

Can you explain this please?  Just as we think we understand what's
going on here, you throw in a new comment that makes us confused.

You said previously that the mvpp2 was connected to a switch, which
makes us think that you've got some DSA-like setup going on here.
Does your switch drop its serdes link when all the external links
(presumably the 10G SFP+ cages) fail?

Both Andrew and myself wish to have a complete picture before we
move forward with this.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 424kbps up
