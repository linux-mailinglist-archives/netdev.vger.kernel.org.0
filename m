Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B767406008
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 01:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349437AbhIIXZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 19:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhIIXZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 19:25:12 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2539DC061574;
        Thu,  9 Sep 2021 16:24:02 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id jg16so405979ejc.1;
        Thu, 09 Sep 2021 16:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7B2jVKUvjKXqdjzGbtYw/f224Fbf0aPkONNS6eLcB5Y=;
        b=Wnoc89U+kj2OdOEKWOyxhrVdnjJq4lDcZK7ZgPd5sL3EK4DKvCRC/x+i3MN98SVHsb
         U5UcSm4UQp9YkwZDjkZaoxhV25hkh2bX9O7lA4jlCsyeVyepHr6hPdCIcIav8vkp2wPR
         vp2jWI6/ePw2DCbmxFJeNOqUSJSI0YokfQMI0VbsFPOCg5K/GwbIvWUPGmuONsA6Prdt
         6uGbz/6NSG1i87sVaI39BKULi6WPLFaXFU92eiTZjJBfiBzE4Eb/KALy4ZxrJwRDYWRZ
         zPEtAMqfUad+OLK8I9FwOIH4NbbOL7rarwpu9CzLCLuI7FnzIIPA6HSMXrACgb8n4NNf
         Z+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7B2jVKUvjKXqdjzGbtYw/f224Fbf0aPkONNS6eLcB5Y=;
        b=ji3LnqMObrMbWb66ST2+LolDbTMow2eyKBL3BPQXLNPDzdPoOZ+eHwjfqfeoiivJ7g
         yiWi1VFpxwhFH7G8khFe3OZjkPJ2F9Z1vDrSdpeo9fWNI371TkmVPNpP7bRuKmCZ/EyL
         F5tou6W98Bw5MVihLTbtML5BvqpWVp5dUoqi+Tesg6aFPne2U5cMfP/BhR8hrl46wI+G
         KvA07TYKRm5aeGxGgh2/UzSRf9oB9vWZ6JJteS72wizQ7w0C7llubg7YYJMXQwXZieml
         aAd0TiECOIWfcy4dsETIHSacTmvtGmhMLwyRj1VYHJtsRnI6Br4SEeojepVbhkrmC93w
         8QEg==
X-Gm-Message-State: AOAM530j2Cp9oBy+0H2F4xiSdR8LW8vj6TxX+no9fMCCyqOXv7zbtgdo
        gcFvisO+gSkgY/p3ujiNgzvMluVjEK5T1w==
X-Google-Smtp-Source: ABdhPJw9HGJ2JRiaPVCz6cxxYLTuyeRjRowp5W57WWKcp8pcA30YFQ1jyNSqV72EIVrDWvsHxwa8HA==
X-Received: by 2002:a17:907:3e20:: with SMTP id hp32mr5934445ejc.536.1631229840601;
        Thu, 09 Sep 2021 16:24:00 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id dh16sm1492112edb.63.2021.09.09.16.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 16:24:00 -0700 (PDT)
Date:   Fri, 10 Sep 2021 02:23:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Saravana Kannan <saravanak@google.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, p.rosenberger@kunbus.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Message-ID: <20210909232358.aen6ep3m2zlktogv@skbuf>
References: <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909225457.figd5e5o3yw76mcs@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 01:54:57AM +0300, Vladimir Oltean wrote:
> On Thu, Sep 09, 2021 at 07:07:33PM +0200, Lino Sanfilippo wrote:
> > > It does not scale really well to have individual drivers call
> > > dsa_tree_shutdown() in their respective .shutdown callback, and in a
> > > multi-switch configuration, I am not sure what the results would
> > > look like.
> > >
> > > In premise, each driver ought to be able to call
> > > dsa_unregister_switch(), along with all of the driver specific
> > > shutdown and eventually, given proper device ordering the DSA tree
> > > would get automatically torn down, and then the DSA master's
> > > .shutdown() callback would be called.
> > >
> > > FWIW, the reason why we call .shutdown() in bcmgenet is to turn off
> > > DMA and clocks, which matters for kexec (DMA) as well as power
> > > savings (S5 mode).
> >
> > I agree with the scalability. Concerning the multi-switch case I dont
> > know about the possible issues (I am quite new to working with DSA).
> > So lets wait for Vladimirs solution.
> 
> I'm back for now and was able to spend a bit more time and understand
> what is happening.
> 
> So first things first: why does DSA call dev_hold long-term on the
> master, and where from?
> 
> Answer: it does so since commit 2f1e8ea726e9 ("net: dsa: link interfaces
> with the DSA master to get rid of lockdep warnings"), see this call path:
> 
> dsa_slave_create
> -> netdev_upper_dev_link
>    -> __netdev_upper_dev_link
>       -> __netdev_adjacent_dev_insert
>          -> dev_hold
> 
> Ok, so since DSA holds a reference to the master interface, it is
> natural that unregister_netdevice() will not finish, and it will hang
> the system.
> 
> Question 2: why does bcmgenet need to unregister the net device on
> shutdown?
> 
> See Florian's answer, it doesn't, strictly speaking, it just needs to
> turn off the DMA and some clocks.
> 
> Question 3: can we revert commit 2f1e8ea726e9?
> 
> Answer: not so easily, we are looking at >10 commits to revert, and find
> other solutions to some problems. We have built in the meantime on top
> of the fact that there is an upper/lower relationship between DSA user
> ports and the DSA master.
> 
> Question 4: how do other stacked interfaces deal with this?
> 
> Answer: as I said in the commit message of 2f1e8ea726e9, DSA is not
> VLAN, DSA has unique challenges of its own, like a tree of struct
> devices to manage, with their own lifetime. So what other drivers do is
> not really relevant. Anyway, to entertain the question: VLAN watches the
> NETDEV_UNREGISTER event emitted on the netdev notifier chain for its
> real_dev, and effectively unregisters itself. Now this is exactly why it
> is irrelevant, we can watch for NETDEV_UNREGISTER on the DSA master, but
> then what? There is nothing sensible to do. Consider that in the master
> unbind case (not shutdown), both the NETDEV_UNREGISTER code path will
> execute, and the unbind of the DSA switch itself, due to that device
> link. But let's say we delete the device link and leave only the
> NETDEV_UNREGISTER code path to do something. What?
> device_release_driver(ds->dev), most probably. That would effectively
> force the DSA unbind path. But surprise: the DSA unbind path takes the
> rtnl_mutex from quite a couple of places, and we are already under the
> rtnl_lock (held by the netdev notifier chain). So, unless we schedule
> the DSA device driver detach, there is an impending deadlock.
> Ok, let's entertain even that: detach the DSA driver in a scheduled work
> item, with the rtnl_lock not held. First off, we will trigger again the
> WARN_ON solved by commit 2f1e8ea726e9 (because the unregistering of the
> DSA master has "completed", but it still has an upper interface - us),
> and secondly, the unregister_netdev function will have already deleted
> stuff belonging to the DSA master, namely its sysfs entries. But DSA
> also touches the master's sysfs, namely the "tagging" file. So NULL
> pointer dereference on the master's sysfs.
> So very simply put, DSA cannot unbind itself from the switch device when
> the master net device unregisters. The best case scenario would be for
> DSA to unbind _before_ the net device even unregisters. That was the
> whole point of my attempt with the device links, to ensure shutdown
> _ordering_.
> 
> Question 5: can the device core actually be patched to call
> device_links_unbind_consumers() from device_shutdown()? This would
> actually simplify DSA's options, and make the device links live up to
> their documented expectations.
> 
> Answer: yes and no, technically it can, but it is an invasive change
> which will certainly introduce regressions. See the answer to question 2
> for an example. Technically .shutdown exists so that drivers can do
> something lightweight to quiesce the hardware, without really caring too
> much about data structure integrity (hey, the kernel is going to die
> soon anyway). But some drivers, like bcmgenet, do the same thing in
> .resume and .shutdown, which blurs the lines quite a lot. If the device
> links were to start calling .remove at shutdown time, potentially after
> .shutdown was already called, bcmgenet would effectively unregister its
> net device twice. Yikes.
> 
> Question 6: How about a patch on the device core that is more lightweight?
> Wouldn't it be sensible for device_shutdown() to just call ->remove if
> the device's bus has no ->shutdown, and the device's driver doesn't have
> a ->shutdown either?
> 
> Answer: This would sometimes work, the vast majority of DSA switch
> drivers, and Ethernet controllers (in this case used as DSA masters) do
> not have a .shutdown method implemented. But their bus does: PCI does,
> SPI controllers do, most of the time. So it would work for limited
> scenarios, but would be ineffective in the general sense.
> 
> Question 7: I said that .shutdown, as opposed to .remove, doesn't really
> care so much about the integrity of data structures. So how far should
> we really go to fix this issue? Should we even bother to unbind the
> whole DSA tree, when the sole problem is that we are the DSA master's
> upper, and that is keeping a reference on it?
> 
> Answer: Well, any solution that does unnecessary data structure teardown
> only delays the reboot for nothing. Lino's patch just bluntly calls
> dsa_tree_teardown() from the switch .shutdown method, and this leaks
> memory, namely dst->ports. But does this really matter? Nope, so let's
> extrapolate. In this case, IMO, the simplest possible solution would be
> to patch bcmgenet to not unregister the net device. Then treat every
> other DSA master driver in the same way as they come, one by one.
> Do you need to unregister_netdevice() at shutdown? No. Then don't.
> Is it nice? Probably not, but I'm not seeing alternatives.
> 
> Also, unless I'm missing something, Lino probably still sees the WARN_ON
> in bcmgenet's unregister_netdevice() about eth0 getting unregistered
> while having an upper interface. If not, it's by sheer luck that the DSA
> switch's ->shutdown gets called before bcmgenet's ->shutdown. But for
> this reason, it isn't a great solution either. If the device links can't
> guarantee us some sort of shutdown ordering (what we ideally want, as
> mentioned, is for the DSA switch driver to get _unbound_ (->remove)
> before the DSA master gets unbound or shut down).

I forgot about this, for completeness:

Question 8: Ok, so this is an even more lightweight variant of question 6.
To patch device_shutdown here:

 		if (dev->bus && dev->bus->shutdown) {
 			if (initcall_debug)
 				dev_info(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
 		} else if (dev->driver && dev->driver->shutdown) {
 			if (initcall_debug)
 				dev_info(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
+		} else {
+			__device_release_driver(dev, parent);
 		}

would go towards helping DSA in general, but it wouldn't help the situation at hand,
and it would introduce regressions.

So what about patching bcmgenet (and other drivers) to implement .shutdown in the following way:

	device_release_driver(&pdev->dev);

basically this should force-unbind the driver from the device, which
would quite nicely make the device link go into action and make DSA
unbind too.

Answer: device_release_driver calls device_lock(dev), and device_shutdown
also holds that lock when it calls our ->shutdown method. So unless the
device core would be so nice so as to provide a generic shutdown method
that just unbinds the device using an unlocked version of device_release_driver,
we are back to square one with this solution. Anything that needs to patch
the device core is more or less disqualified, especially for a bug fix.
