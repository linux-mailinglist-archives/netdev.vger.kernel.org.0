Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA7C406507
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 03:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238844AbhIJBWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 21:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238781AbhIJBWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 21:22:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CBFC0D9420;
        Thu,  9 Sep 2021 18:08:31 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id j13so83538edv.13;
        Thu, 09 Sep 2021 18:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=03qdsagNsXmq4FIpVeEfTnd5gNmIaodlU3qMppWE7Bc=;
        b=pJQvxhZAVuqT/HUDMY5YuHCyVBYtYVwgWF9wNIs+XJMv2kLPeTjq4H+lRROQTIzcyL
         izoYkfm7lBQ1liiUW4BnODzbCCiwSOY6PVd2n4FTTRAjVFnwtksDSSJMctSATtd78Udh
         HYHzfGUtQAKXLEIZgbnn2YCuAT6GiHT/vVkpDuyXGShEucZFOrNE37+5htqJcroRvQqr
         YKMMiPHiwN/QdBFG+plSCVWFw+1MU8qX5Fw7gYPGTmd3KaT9CKwAObF0CzJ6TDK9fBSW
         9cYu1gc+SWOraCt0RQIr7YKs/Req+didsotY4fDUGgg3db+WPtweWjVrP5sMBcgHEwl0
         C4Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=03qdsagNsXmq4FIpVeEfTnd5gNmIaodlU3qMppWE7Bc=;
        b=ylNek37Q7SKkyG3pFe0TnmLG4hkZIcXmTkZXDHpn6V3Pm7ooqhLjYy56zubIQEVEXh
         jyVYYSIbTvQPXqLA1Mjo7DMI+AGDbBgB55HVejlv8IlgnmpkIW/yAkwUiJfqIxx0Gdym
         9dip3Wzw1sX4cY1/e8t30llQPOye9AZmCUVRNbh52Auovfn4MrtwIpddzoMe2fGBa08T
         9mTAhy6b8elUA8xleiUnHk1redoHNyuA68W7Gdj6Z8dofGWdxyCS3cMHKrlD6TFoif1h
         QKKZAU95K9Row5xWCaqVj6a7eQqQG6FdOpeUJXwJGWwpF4oA0yDP0kjUszPaS/IDExwV
         hYPg==
X-Gm-Message-State: AOAM5316ZBf3dHGU+ghq4cXeu/99W9FkjCBqrIddl36iyvhkYvIyWVj5
        HqQdruGz6zVWj8hdYGfK1r4=
X-Google-Smtp-Source: ABdhPJwNmOEH+v80JEUqPtJKn6UxL/UqZCp1HBGer1+Pk97C7seu+Zy/5JWN9NtuD5JXNtpZpio+Ew==
X-Received: by 2002:a05:6402:40cf:: with SMTP id z15mr6125652edb.70.1631236110396;
        Thu, 09 Sep 2021 18:08:30 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id r18sm1745760edd.69.2021.09.09.18.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 18:08:29 -0700 (PDT)
Date:   Fri, 10 Sep 2021 04:08:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Saravana Kannan <saravanak@google.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210910010828.etdwmme6pqg4u5ik@skbuf>
References: <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
 <20210909232358.aen6ep3m2zlktogv@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909232358.aen6ep3m2zlktogv@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 02:23:58AM +0300, Vladimir Oltean wrote:
> On Fri, Sep 10, 2021 at 01:54:57AM +0300, Vladimir Oltean wrote:
> > On Thu, Sep 09, 2021 at 07:07:33PM +0200, Lino Sanfilippo wrote:
> > > > It does not scale really well to have individual drivers call
> > > > dsa_tree_shutdown() in their respective .shutdown callback, and in a
> > > > multi-switch configuration, I am not sure what the results would
> > > > look like.
> > > >
> > > > In premise, each driver ought to be able to call
> > > > dsa_unregister_switch(), along with all of the driver specific
> > > > shutdown and eventually, given proper device ordering the DSA tree
> > > > would get automatically torn down, and then the DSA master's
> > > > .shutdown() callback would be called.
> > > >
> > > > FWIW, the reason why we call .shutdown() in bcmgenet is to turn off
> > > > DMA and clocks, which matters for kexec (DMA) as well as power
> > > > savings (S5 mode).
> > >
> > > I agree with the scalability. Concerning the multi-switch case I dont
> > > know about the possible issues (I am quite new to working with DSA).
> > > So lets wait for Vladimirs solution.
> > 
> > I'm back for now and was able to spend a bit more time and understand
> > what is happening.
> > 
> > So first things first: why does DSA call dev_hold long-term on the
> > master, and where from?
> > 
> > Answer: it does so since commit 2f1e8ea726e9 ("net: dsa: link interfaces
> > with the DSA master to get rid of lockdep warnings"), see this call path:
> > 
> > dsa_slave_create
> > -> netdev_upper_dev_link
> >    -> __netdev_upper_dev_link
> >       -> __netdev_adjacent_dev_insert
> >          -> dev_hold
> > 
> > Ok, so since DSA holds a reference to the master interface, it is
> > natural that unregister_netdevice() will not finish, and it will hang
> > the system.
> > 
> > Question 2: why does bcmgenet need to unregister the net device on
> > shutdown?
> > 
> > See Florian's answer, it doesn't, strictly speaking, it just needs to
> > turn off the DMA and some clocks.
> > 
> > Question 3: can we revert commit 2f1e8ea726e9?
> > 
> > Answer: not so easily, we are looking at >10 commits to revert, and find
> > other solutions to some problems. We have built in the meantime on top
> > of the fact that there is an upper/lower relationship between DSA user
> > ports and the DSA master.
> > 
> > Question 4: how do other stacked interfaces deal with this?
> > 
> > Answer: as I said in the commit message of 2f1e8ea726e9, DSA is not
> > VLAN, DSA has unique challenges of its own, like a tree of struct
> > devices to manage, with their own lifetime. So what other drivers do is
> > not really relevant. Anyway, to entertain the question: VLAN watches the
> > NETDEV_UNREGISTER event emitted on the netdev notifier chain for its
> > real_dev, and effectively unregisters itself. Now this is exactly why it
> > is irrelevant, we can watch for NETDEV_UNREGISTER on the DSA master, but
> > then what? There is nothing sensible to do. Consider that in the master
> > unbind case (not shutdown), both the NETDEV_UNREGISTER code path will
> > execute, and the unbind of the DSA switch itself, due to that device
> > link. But let's say we delete the device link and leave only the
> > NETDEV_UNREGISTER code path to do something. What?
> > device_release_driver(ds->dev), most probably. That would effectively
> > force the DSA unbind path. But surprise: the DSA unbind path takes the
> > rtnl_mutex from quite a couple of places, and we are already under the
> > rtnl_lock (held by the netdev notifier chain). So, unless we schedule
> > the DSA device driver detach, there is an impending deadlock.
> > Ok, let's entertain even that: detach the DSA driver in a scheduled work
> > item, with the rtnl_lock not held. First off, we will trigger again the
> > WARN_ON solved by commit 2f1e8ea726e9 (because the unregistering of the
> > DSA master has "completed", but it still has an upper interface - us),
> > and secondly, the unregister_netdev function will have already deleted
> > stuff belonging to the DSA master, namely its sysfs entries. But DSA
> > also touches the master's sysfs, namely the "tagging" file. So NULL
> > pointer dereference on the master's sysfs.
> > So very simply put, DSA cannot unbind itself from the switch device when
> > the master net device unregisters. The best case scenario would be for
> > DSA to unbind _before_ the net device even unregisters. That was the
> > whole point of my attempt with the device links, to ensure shutdown
> > _ordering_.
> > 
> > Question 5: can the device core actually be patched to call
> > device_links_unbind_consumers() from device_shutdown()? This would
> > actually simplify DSA's options, and make the device links live up to
> > their documented expectations.
> > 
> > Answer: yes and no, technically it can, but it is an invasive change
> > which will certainly introduce regressions. See the answer to question 2
> > for an example. Technically .shutdown exists so that drivers can do
> > something lightweight to quiesce the hardware, without really caring too
> > much about data structure integrity (hey, the kernel is going to die
> > soon anyway). But some drivers, like bcmgenet, do the same thing in
> > .resume and .shutdown, which blurs the lines quite a lot. If the device
> > links were to start calling .remove at shutdown time, potentially after
> > .shutdown was already called, bcmgenet would effectively unregister its
> > net device twice. Yikes.
> > 
> > Question 6: How about a patch on the device core that is more lightweight?
> > Wouldn't it be sensible for device_shutdown() to just call ->remove if
> > the device's bus has no ->shutdown, and the device's driver doesn't have
> > a ->shutdown either?
> > 
> > Answer: This would sometimes work, the vast majority of DSA switch
> > drivers, and Ethernet controllers (in this case used as DSA masters) do
> > not have a .shutdown method implemented. But their bus does: PCI does,
> > SPI controllers do, most of the time. So it would work for limited
> > scenarios, but would be ineffective in the general sense.
> > 
> > Question 7: I said that .shutdown, as opposed to .remove, doesn't really
> > care so much about the integrity of data structures. So how far should
> > we really go to fix this issue? Should we even bother to unbind the
> > whole DSA tree, when the sole problem is that we are the DSA master's
> > upper, and that is keeping a reference on it?
> > 
> > Answer: Well, any solution that does unnecessary data structure teardown
> > only delays the reboot for nothing. Lino's patch just bluntly calls
> > dsa_tree_teardown() from the switch .shutdown method, and this leaks
> > memory, namely dst->ports. But does this really matter? Nope, so let's
> > extrapolate. In this case, IMO, the simplest possible solution would be
> > to patch bcmgenet to not unregister the net device. Then treat every
> > other DSA master driver in the same way as they come, one by one.
> > Do you need to unregister_netdevice() at shutdown? No. Then don't.
> > Is it nice? Probably not, but I'm not seeing alternatives.
> > 
> > Also, unless I'm missing something, Lino probably still sees the WARN_ON
> > in bcmgenet's unregister_netdevice() about eth0 getting unregistered
> > while having an upper interface. If not, it's by sheer luck that the DSA
> > switch's ->shutdown gets called before bcmgenet's ->shutdown. But for
> > this reason, it isn't a great solution either. If the device links can't
> > guarantee us some sort of shutdown ordering (what we ideally want, as
> > mentioned, is for the DSA switch driver to get _unbound_ (->remove)
> > before the DSA master gets unbound or shut down).
> 
> I forgot about this, for completeness:
> 
> Question 8: Ok, so this is an even more lightweight variant of question 6.
> To patch device_shutdown here:
> 
>  		if (dev->bus && dev->bus->shutdown) {
>  			if (initcall_debug)
>  				dev_info(dev, "shutdown\n");
>  			dev->bus->shutdown(dev);
>  		} else if (dev->driver && dev->driver->shutdown) {
>  			if (initcall_debug)
>  				dev_info(dev, "shutdown\n");
>  			dev->driver->shutdown(dev);
> +		} else {
> +			__device_release_driver(dev, parent);
>  		}
> 
> would go towards helping DSA in general, but it wouldn't help the situation at hand,
> and it would introduce regressions.
> 
> So what about patching bcmgenet (and other drivers) to implement .shutdown in the following way:
> 
> 	device_release_driver(&pdev->dev);
> 
> basically this should force-unbind the driver from the device, which
> would quite nicely make the device link go into action and make DSA
> unbind too.
> 
> Answer: device_release_driver calls device_lock(dev), and device_shutdown
> also holds that lock when it calls our ->shutdown method. So unless the
> device core would be so nice so as to provide a generic shutdown method
> that just unbinds the device using an unlocked version of device_release_driver,
> we are back to square one with this solution. Anything that needs to patch
> the device core is more or less disqualified, especially for a bug fix.

Question 9: can Lino's patch set be generalized to all DSA switches,
i.e. can all DSA drivers redirect their ->shutdown method to their
->remove method?

Answer: Apart from the fact that mdio_driver_register() does not provide
for a ->shutdown() method, which can be trivially addressed, we still
have issues. The fundamental problem is that some bus device drivers
implement ->shutdown as ->remove for their own device, see dspi_shutdown()
and dspi_remove() for an example.
When that happens, the DSA switch device attached to that bus will be
(a) once unbound from its driver (by dspi_shutdown -> dspi_remove ->
spi_unregister_controller -> device_for_each_child(...unregister), and
(b) once shut down (by its own ->shutdown method).

With the "ds" structure being naturally destroyed by the first call to
the ->remove function, a second call to ->remove is impossible to
succeed without tripping some NULL pointer, from the device's ->shutdown path.
Simply said, DSA is not designed to support an unbalanced number of
calls to dsa_register_switch and dsa_unregister_switch.

In fact, if Lino's ksz9897 switch was attached to the dspi driver for a
SPI controller, even his own patches would not work and result in this
unbalance of calls that I mentioned earlier. If we're going to fix it,
let's think of something that covers all cases at least.

Simply put, it looks like we need some guidance (again) from driver core
maintainers as to what should a ->suspend method _not_ do. Specifically,
if it is okay to redirect ->suspend to ->remove. It looks like in the
case of buses doing that, and child devices doing that too, the results
are not quite sane. And maybe that would give us some clue as to what to
do about the genet driver which does the same thing.
