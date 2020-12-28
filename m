Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73702E6C29
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730355AbgL1Wzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729599AbgL1WB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 17:01:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44CBD22242;
        Mon, 28 Dec 2020 22:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609192876;
        bh=wec/s1ZvNiaME84+G8xSzIgFQT3HelyHFMLRjeKLA2M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o2H5SkWKqEWuONe1tw7qjOrj9Q/Luk3LZobtjzgjtIHN7/kCc0enOEu2AyyWEJzIJ
         jf7YQM+/a+Yn9Dfloar8Gq2iQtkcve5vigwBRs4G4E/RtiUMCZzoxidlEUN9rcZl/a
         qqVmj1NtF7IMu6fALKWnQR/laXZWXR6QhY+iadpgewXKWkEu23EhvVvPFLTtW/mlmS
         0pGhO780BtPKciKT76JX7FN7+Yre8ClPkCLU2YVcJ42Mm+XxSwOTpxGCXVhUBUgo1r
         /qCUrn969nJEbQduH/hCr5rAN24BV8cjXLCx89gISQxRL/08NNYcIB2BXmLdMu6gno
         AGUxiQsF8kzqw==
Date:   Mon, 28 Dec 2020 14:01:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hongwei Zhang <hongweiz@ami.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org, David S Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: Re: [Aspeed, v2 2/2] net: ftgmac100: Change the order of getting
 MAC address
Message-ID: <20201228140115.6af4d510@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201222210034.GC3198262@lunn.ch>
References: <20201221205157.31501-2-hongweiz@ami.com>
        <20201222201437.5588-3-hongweiz@ami.com>
        <96c355a2-ab7e-3cf0-57e7-16369da78035@gmail.com>
        <20201222210034.GC3198262@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 22:00:34 +0100 Andrew Lunn wrote:
> On Tue, Dec 22, 2020 at 09:46:52PM +0100, Heiner Kallweit wrote:
> > On 22.12.2020 21:14, Hongwei Zhang wrote:  
> > > Dear Reviewer,
> > > 
> > > Use native MAC address is preferred over other choices, thus change the order
> > > of reading MAC address, try to read it from MAC chip first, if it's not
> > >  availabe, then try to read it from device tree.
> > > 
> > > Hi Heiner,
> > >   
> > >> From:	Heiner Kallweit <hkallweit1@gmail.com>
> > >> Sent:	Monday, December 21, 2020 4:37 PM  
> > >>> Change the order of reading MAC address, try to read it from MAC chip 
> > >>> first, if it's not availabe, then try to read it from device tree.
> > >>>  
> > >> This commit message leaves a number of questions. It seems the change isn't related at all to the 
> > >> change that it's supposed to fix.
> > >>
> > >> - What is the issue that you're trying to fix?
> > >> - And what is wrong with the original change?  
> > > 
> > > There is no bug or something wrong with the original code. This patch is for
> > > improving the code. We thought if the native MAC address is available, then
> > > it's preferred over MAC address from dts (assuming both sources are available).
> > > 
> > > One possible scenario, a MAC address is set in dts and the BMC image is 
> > > compiled and loaded into more than one platform, then the platforms will
> > > have network issue due to the same MAC address they read.
> > >   
> > 
> > Typically the DTS MAC address is overwritten by the boot loader, e.g. uboot.
> > And the boot loader can read it from chip registers. There are more drivers
> > trying to read the MAC address from DTS first. Eventually, I think, the code
> > here will read the same MAC address from chip registers as uboot did before.  
> 
> Do we need to worry about, the chip contains random junk, which passes
> the validitiy test? Before this patch the value from DT would be used,
> and the random junk is ignored. Is this change possibly going to cause
> a regression?

Hongwei, please address Andrew's questions.

Once the discussion is over please repost the patches as
git-format-patch would generate them. The patch 2/2 of this 
series is not really a patch, which confuses all patch handling 
systems.

It also appears that 35c54922dc97 ("ARM: dts: tacoma: Add reserved
memory for ramoops") does not exist upstream.
