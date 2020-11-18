Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3E842B84E7
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 20:28:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgKRT0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 14:26:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:37862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgKRT0Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 14:26:25 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 460992225B;
        Wed, 18 Nov 2020 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605727584;
        bh=3CQXL+ovbwQRrEeiRNI+D75ASvQ0tZnqqOg+LLeBH5Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TnyJnyBpyge8Uv5o8kypygK4cFziwBAPATp6Y8XIsc3Uv0C6xTR8Z6H6G018PHc8H
         5PE0Ai0ux8JAenRZwW+ppUvhFqeEscvZbCMQ87OV1Keu/vlj82CYc/kD9yW736gqZb
         4zAOeevpXM/VHCJkSkhaIeZIjQaopEktoMxyNWk0=
Date:   Wed, 18 Nov 2020 11:26:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Ruslan V. Sushko" <rus@sushko.dev>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Wait for EEPROM done after HW
 reset
Message-ID: <20201118112623.4eb9bb8a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201118191017.GH1800835@lunn.ch>
References: <20201116164301.977661-1-rus@sushko.dev>
        <20201118105251.0f3c9ac8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20201118191017.GH1800835@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 20:10:17 +0100 Andrew Lunn wrote:
> On Wed, Nov 18, 2020 at 10:52:51AM -0800, Jakub Kicinski wrote:
> > On Mon, 16 Nov 2020 08:43:01 -0800 Ruslan V. Sushko wrote:  
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > 
> > > When the switch is hardware reset, it reads the contents of the
> > > EEPROM. This can contain instructions for programming values into
> > > registers and to perform waits between such programming. Reading the
> > > EEPROM can take longer than the 100ms mv88e6xxx_hardware_reset() waits
> > > after deasserting the reset GPIO. So poll the EEPROM done bit to
> > > ensure it is complete.
> > > 
> > > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: Ruslan Sushko <rus@sushko.dev>  
> > 
> > Andrew, do we need this in net?  
> 
> I was wondering about that. I actually recommend leaving the EEPROM
> empty. The driver has no idea what magic the EEPROM has done, and so
> will stomp over it, or make assumptions which are not true about
> register values.
> 
> But Zodiac has valid use cases of putting stuff into the EEPROM, and
> they are aware of the danger. And this patch has got lost at least
> once, causing lots of head scratching. So getting it into 5.10 makes
> sense for them. I don't think it needs to go further back.
> 
> Not sure what Fixes: tag to use.

Ack, sound reasonable. Applying to net and not queuing, thanks!
