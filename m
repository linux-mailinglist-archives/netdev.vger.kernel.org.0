Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB7D2F252E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbhALA6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:58:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727261AbhALA6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 19:58:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31E6922510;
        Tue, 12 Jan 2021 00:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610413058;
        bh=CAs1nlA+1s1zeNCU9zjes48V/Qhq5PGxzrZG/M5JCMs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OS7Ygjdurr4piuyIcRgwoGxjFQZ1eKz8v17HJholGHZ+cmySzJXoc53P/Ueqsciq7
         yuPxnGcmteCddMzkUMXoi1qqYOjQAZB806IdMYNRn5EbPkCtzcMbwbSWe4u33DZrYk
         Pz27YU7fAzjQ60dY3ryumtFUlOhLFS9Ns9FC/AEwnq1s0m7jI1xWcQOYZ+wb69v43k
         ZtqVxlsU2s2vc30v/mTBzMqK5Vl1LjuNbqxSBT+7d+vTO8WoPNnUACV6SqA3PmRyk6
         29e+50TwGd1Qti7aqTqR89/C69DDUYUwvf+JX+6vigtJPw7CvAtrFOEDZUAryjt1A0
         t2v+rzMqbJkrw==
Date:   Mon, 11 Jan 2021 16:57:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     stefanc@marvell.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mw@semihalf.com, rmk+kernel@armlinux.org.uk, atenart@kernel.org
Subject: Re: [PATCH net ] net: mvpp2: Remove Pause and Asym_Pause support
Message-ID: <20210111165737.092f02c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X/zxnyyTRf0xsYmd@lunn.ch>
References: <1610306582-16641-1-git-send-email-stefanc@marvell.com>
        <20210111163653.6483ae82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <X/zxnyyTRf0xsYmd@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 01:47:27 +0100 Andrew Lunn wrote:
> On Mon, Jan 11, 2021 at 04:36:53PM -0800, Jakub Kicinski wrote:
> > On Sun, 10 Jan 2021 21:23:02 +0200 stefanc@marvell.com wrote:  
> > > From: Stefan Chulski <stefanc@marvell.com>
> > > 
> > > Packet Processor hardware not connected to MAC flow control unit and
> > > cannot support TX flow control.
> > > This patch disable flow control support.
> > > 
> > > Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> > > Signed-off-by: Stefan Chulski <stefanc@marvell.com>  
> > 
> > I'm probably missing something, but why not 4bb043262878 ("net: mvpp2:
> > phylink support")?  
> 
> Hi Jakub
> 
> Before that change, it used phylib. The same is true with phylib, you
> need to tell phylib it should not advertise pause. How you do it is
> different, but the basic issue is the same. Anybody doing a backport
> past 4bb043262878is going to need a different fix, but the basic issue
> is there all the way back to when the driver was added.

Thanks for confirming, I didn't see any code being removed which would
tell phylib pause is supported, so I wanted to make sure phylib
defaults to on / gets it from some register. 

Applied now, thanks!
