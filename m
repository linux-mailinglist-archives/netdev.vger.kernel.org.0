Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4732811FC
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbgJBMG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 08:06:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgJBMG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 08:06:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C3B820663;
        Fri,  2 Oct 2020 12:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601640386;
        bh=W9PW1sodJE9XhWdi70/XYrIUUown9uBZMGzpzuc3Wu8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u9vbVHEFySs2evwuo6RoodXw0q/5yMemCvvmBhMyEqIvdzuPbTgkWgrEoogr6iwO+
         u4+xuXmPKuCJ2uGJAhfGxFq+8H0p8U9hGOFv1R1rIxUJqBXf1nrk6saT54mzjBu/qQ
         XhYMVO9HMtyRjO8dxpWef6clHUCmf3FeBWkXjoxU=
Date:   Fri, 2 Oct 2020 14:06:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC] Status of orinoco_usb
Message-ID: <20201002120625.GA3341753@kroah.com>
References: <20201002103517.fhsi5gaepzbzo2s4@linutronix.de>
 <20201002113725.GB3292884@kroah.com>
 <20201002115358.6aqemcn5vqc5yqtw@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002115358.6aqemcn5vqc5yqtw@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 01:53:58PM +0200, Sebastian Andrzej Siewior wrote:
> On 2020-10-02 13:37:25 [+0200], Greg Kroah-Hartman wrote:
> > > Is it possible to end up here in softirq context or is this a relic?
> > 
> > I think it's a relic of where USB host controllers completed their urbs
> > in hard-irq mode.  The BH/tasklet change is a pretty recent change.
> 
> But the BH thingy for HCDs went in v3.12 for EHCI. XHCI was v5.5. My
> guess would be that people using orinoco USB are on EHCI :)

USB 3 systems run XHCI, which has a USB 2 controller in it, so these
types of things might not have been noticed yet.  Who knows :)

> > > Should it be removed?
> > 
> > We can move it out to drivers/staging/ and then drop it to see if anyone
> > complains that they have the device and is willing to test any changes.
> 
> Not sure moving is easy since it depends on other files in that folder.
> USB is one interface next to PCI for instance. Unless you meant to move
> the whole driver including all interfaces.
> I was suggesting to remove the USB bits.

I forgot this was tied into other code, sorry.  I don't know what to
suggest other than maybe try to fix it up the best that you can, and
let's see if anyone notices...

thanks,

greg k-h
