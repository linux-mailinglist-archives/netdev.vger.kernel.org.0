Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990A81E6C37
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 22:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407140AbgE1UPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 16:15:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407128AbgE1UPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 16:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4POkvhyfkxI3mPZrBGf3TYBBAq2iHcysRl6pHV06SV0=; b=FPT4dGlyYustf3rSfQl+csHt7S
        pozgcKxl0/C57osavR4tKyWA+BCd1vYeg8e5CA7t1UnAQSaYlewmqUFJrWqLyxfQi6uiQnFmm59Jg
        mNdjIpMy/AaKIGDL4Jv22pYFvUH5nl4xiUzRyihV5uQRKAdsP2cLWKlv+UAshy2eiCY0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeOvy-003ZfX-1n; Thu, 28 May 2020 22:15:22 +0200
Date:   Thu, 28 May 2020 22:15:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: mvpp2: Enable autoneg bypass for
 1000BaseX/2500BaseX ports
Message-ID: <20200528201522.GD849697@lunn.ch>
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

Just for my understanding...

https://www.ambedded.com/ARM_Server_platform.html

seems to suggest there are 4 external ports. You want to pass the link
status of these four external ports to the CPU module?

	Andrew
