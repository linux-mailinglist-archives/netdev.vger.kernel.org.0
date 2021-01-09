Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E5F2F0478
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 00:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAIXvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 18:51:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAIXvl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 18:51:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24DBC23372;
        Sat,  9 Jan 2021 23:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610236260;
        bh=q3/EpVs/HD96L/VzPoeYor4NABlAiiwtj+i/DIAPdRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OlVufy2WVeROpMsuvh8VwG/j/TX93YE3SZxSyfNGDr7cTvJYYJvMMxR1KGQvJmmU9
         SyPjdtoDM9YHjpRwdbZGOUIUzMmtGUt3HXUDwDRzHfJfHxfsuJCo3BaAZcHHM0UGZY
         iwavBmRa+whqHXZZSz1ay8R9td6iqtgVUo18dk06Kc3v9+zDjRLGpfvjg0BOkwx91e
         laRB0F/1SNmlDS+95JfYYdhjUTgU8+/IBOU3HRQNnfWAbRTVtwXLtgJTa77msju6oS
         CzZhuL9JM7f8W+vN6wKG/kH8+3JpxvpXINPt958f/dCGCPFaQGuKt6vPeAyHsN1x6T
         98mSX2yfBg06A==
Received: by pali.im (Postfix)
        id 607587FE; Sun, 10 Jan 2021 00:50:56 +0100 (CET)
Date:   Sun, 10 Jan 2021 00:50:56 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] net: sfp: assume that LOS is not implemented if
 both LOS normal and inverted is set
Message-ID: <20210109235056.zqgzo63e356xnq6q@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210106153749.6748-1-pali@kernel.org>
 <20210106153749.6748-3-pali@kernel.org>
 <X/c8xJcwj8Y1t3u4@lunn.ch>
 <20210109154601.GZ1551@shell.armlinux.org.uk>
 <20210109191447.hunwx4fc4d4lox5f@pali>
 <20210109231954.GC1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210109231954.GC1551@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 09 January 2021 23:19:54 Russell King - ARM Linux admin wrote:
> On Sat, Jan 09, 2021 at 08:14:47PM +0100, Pali Rohár wrote:
> > On Saturday 09 January 2021 15:46:01 Russell King - ARM Linux admin wrote:
> > > On Thu, Jan 07, 2021 at 05:54:28PM +0100, Andrew Lunn wrote:
> > > > On Wed, Jan 06, 2021 at 04:37:48PM +0100, Pali Rohár wrote:
> > > > > From: Russell King <rmk+kernel@armlinux.org.uk>
> > > > > 
> > > > > Some GPON SFP modules (e.g. Ubiquiti U-Fiber Instant) have set both
> > > > > SFP_OPTIONS_LOS_INVERTED and SFP_OPTIONS_LOS_NORMAL bits in their EEPROM.
> > > > > 
> > > > > Such combination of bits is meaningless so assume that LOS signal is not
> > > > > implemented.
> > > > > 
> > > > > This patch fixes link carrier for GPON SFP module Ubiquiti U-Fiber Instant.
> > > > > 
> > > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > > Signed-off-by: Pali Rohár <pali@kernel.org>
> > > > 
> > > > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > > 
> > > I'd like to send this patch irrespective of discussion on the other
> > > patches - I already have it committed in my repository with a different
> > > description, but the patch content is the same.
> > > 
> > > Are you happy if I transfer Andrew's r-b tag, and convert yours to an
> > > acked-by before I send it?
> > > 
> > > I'd also like to add a patch that allows 2.5G if no other modes are
> > > found, but the bitrate specified by the module allows 2.5G speed - much
> > > like we do for 1G speeds.
> > 
> > Russell, should I send a new version of patch series without this patch?
> 
> I think there's some work to be done for patch 1, so I was thinking of
> sending this with another SFP patch. It's really a bug fix since the
> existing code doesn't behave very well if both bits are set - it will
> toggle state on every RX_LOS event received irrespective of the RX_LOS
> state.

Ok! So I will fix what is needed for patch 1, send it with patch 3 as
next version and let patch 2 to you.
