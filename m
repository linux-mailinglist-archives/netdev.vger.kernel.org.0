Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC21E447F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393242AbfJYHdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:33:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:34864 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726479AbfJYHdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 03:33:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C7075AFB7;
        Fri, 25 Oct 2019 07:33:05 +0000 (UTC)
Date:   Fri, 25 Oct 2019 09:33:04 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Marc Zyngier <maz@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] net: usb: lan78xx: Use phy_mac_interrupt() for interrupt
 handling
Message-ID: <20191025073304.zqw2yxaulkyopk5y@beryllium.lan>
References: <20191018082817.111480-1-dwagner@suse.de>
 <20191018131532.dsfhyiilsi7cy4cm@linutronix.de>
 <20191022101747.001b6d06@cakuba.netronome.com>
 <20191023074719.gcov5xfrcvns5tlg@beryllium.lan>
 <20191023080640.zcw2f2v7fpanoewm@beryllium.lan>
 <20191024104317.32bp32krrjmfb36p@linutronix.de>
 <20191024110610.lwwy75dkgwjdxml6@beryllium.lan>
 <20191024141216.wz2dcdxy4mrl2q5a@beryllium.lan>
 <78ab19da-2f30-86e0-fad1-667f5e6ba8b1@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78ab19da-2f30-86e0-fad1-667f5e6ba8b1@gmx.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

On Thu, Oct 24, 2019 at 07:25:37PM +0200, Stefan Wahren wrote:
> Am 24.10.19 um 16:12 schrieb Daniel Wagner:
> > On Thu, Oct 24, 2019 at 01:06:10PM +0200, Daniel Wagner wrote:
> >
> > Sebastians suggested to try the RPi kernel. The rpi-5.2.y kernel
> > behaves exactly the same. That is one PHY interrupt and later on NFS
> > timeouts.
> >
> > According their website the current shipped RPi kernel is in version
> > 4.18. Here is what happends with rpi-4.18.y:
> 
> No, it's 4.19. It's always a LTS kernel.

Ah okay and obviously, 4.19 works also nicely. No surprise here.

> I'm curious, what's the motivation behind this? The rpi tree contains
> additional hacks, so i'm not sure the results are comparable. Also the
> USB host driver is a different one.

The idea was to see what the PHY interrupt is doing. As it turns out
the RPi tree and mainline have almost the same infrastructure code
here (irqdomain). There are some additional tweaks in the RPi
kernel. My initial revert patch removed all this infrastructure code,
which is probably not a good idea. If the way forward is to steal the
bits and pieces from the RPi tree which should keep this code in
place.

With the local_irq_disable() patch, which I am going to send asap, the
warning which everyone is seeing should be gone. So one bug down.

> > There are no NFS timeouts and commands like 'apt update' work reasoble
> > fast. So no long delays or hangs. Time to burn this hardware.
> 
> Since enabling lan78xx for Raspberry Pi 3B+, we found a lot of driver
> issues. So i'm not really surprised, that there are still more of them.

If the vendor would work on fixing the bugs it would not be real
problem.

Thanks,
Daniel

