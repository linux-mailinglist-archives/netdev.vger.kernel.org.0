Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272CB2F0426
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 23:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbhAIWny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 17:43:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726223AbhAIWnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 17:43:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A009823888;
        Sat,  9 Jan 2021 22:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610232192;
        bh=k6kk6F01bGxYTyYPJrz+JYD1LJ/D00VjaUlcsERDN7s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mJaTtJSGwLwfAh64b8YhG+0VXdoFaFkZcHnZJ0uP/lzaYR7RbAuUauCujeY91wx1f
         lwo3TVT/JNUcf2mJZwjaAmo2w+L5b95L3pVCikDw2k0aUcB6IpyXGWJ5I9aYxteIaA
         qP0KmwcR16pJHNRLJT0/zZcS6R5plY7JX6RS5tB7eZ81Hzc71VtLaH0lHDelB2mEVq
         ugC6W8gCeg/+Gzrn/L+aruNbhe4Aw6zn51mXyVUz3CHGTchy/5zHaSNh7uGge2mF3Y
         btxGwst+qxjct623pc43ANWW0YY/GiYyla6anFvzcmrCXIXqnoTmCs0wyAURJQMJ5k
         rwon9JdJt/lIA==
Date:   Sat, 9 Jan 2021 14:43:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Schuermann <leon@is.currently.online>
Cc:     oliver@neukum.org, davem@davemloft.net, hayeswang@realtek.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] r8152: Add Lenovo Powered USB-C Travel Hub
Message-ID: <20210109144311.47760f7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87bldye9f4.fsf@is.currently.online>
References: <20210108202727.11728-1-leon@is.currently.online>
        <20210108202727.11728-2-leon@is.currently.online>
        <20210108182030.77839d11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87bldye9f4.fsf@is.currently.online>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 09 Jan 2021 10:39:27 +0100 Leon Schuermann wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Fri,  8 Jan 2021 21:27:27 +0100 Leon Schuermann wrote:  
> >> This USB-C Hub (17ef:721e) based on the Realtek RTL8153B chip used to
> >> work with the cdc_ether driver.  
> >
> > When you say "used to work" do you mean there was a regression where
> > the older kernels would work fine and newer don't? Or just "it works
> > most of the time"?  
> 
> Sorry, I should've clarified that. "Used to work" is supposed to say
> "the device used the generic cdc_ether driver", as in
> 
> [  +0.000004] usb 4-1.1: Product: Lenovo Powered Hub
> [  +0.000003] usb 4-1.1: Manufacturer: Lenovo
> [  +0.000002] usb 4-1.1: SerialNumber: xxxxxxxxx
> [  +0.024803] cdc_ether 4-1.1:2.0 eth0: register 'cdc_ether' at
>               usb-0000:2f:00.0-1.1, CDC Ethernet Device,
>               xx:xx:xx:xx:xx:xx
> 
> I guess it did technically work correctly, except for the reported issue
> when the host system suspends, which is fixed by using the dedicated
> Realtek driver. As far as I know this hasn't been fixed before, so it's
> not a regression.

I see. In the last release cycle there were patches for allowing
cdc_ether to drive RTL8153 devices when r8152 is not available. 
I wanted to double check with you that nothing changed here,
that's to say that the cdc_ether is not used even if r8152 is 
built after an upgrade to 5.11-rc.

> Should I update the commit message accordingly? Thanks!

Yes please, otherwise backporters may be confused about how 
to classify this change.
