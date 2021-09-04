Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13444400D43
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 23:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbhIDWAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 18:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233001AbhIDWAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 18:00:11 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE483C061575;
        Sat,  4 Sep 2021 14:59:08 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z19so3925215edi.9;
        Sat, 04 Sep 2021 14:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Grc/l8kBAe5I8zCeS1cz/SgpafVqzUSKExXOoReTK4=;
        b=XQmop5UjJIiLoF0/MHiJ3Vlu6PbILWSdxhH2HoWHCSapUeglXwz1xWNRju1AgFMDp3
         TqF8yNZRrH8Tum5+3PkCs0SngNZbKRTwdY+zgrOv6e4sDpnUhof9cR600syqPaNaXLFy
         +428dfXkpFEXknOrxDxDhfxTkWExXpeMMsp9CIRhws3pylkNbtYm4AJt8gCi54VexKUU
         uWgjS6HWnw1v7O4JL41e0rOneZ6+mOebr0KfnYpLXOxAE9VFauixglNzboQeWSila8Nf
         R1GYVq51z4Hr8vIuEOxBAnd9up82ZQwrDs2FFW0PkC7rpxwP8SCInNs0GhqaQdDG99yg
         BiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2Grc/l8kBAe5I8zCeS1cz/SgpafVqzUSKExXOoReTK4=;
        b=Nts0UcK7jQ6+8m4wLgPLkXBMY8zG9KLguWrHetP+U593wwyBvymUCQtHaJ5z89Hscc
         85hgK7VLopHZzUe9bqq4Brr3UD64rdNFmxXs8iXGNajk2rZx0Fg8qGyO6u7qlRY8F0L6
         FzDNiLSneElRgdkI65TeWSnF3QD90DvpnWKuHwF5mpAmO4GWiqcfv7LxjcDugsw2t1Bv
         BUSUNVQXTNlnTOnZL//fn2NvPfHIS6NQOpLTjCvuE0I49ZFC7Aa2EWRcj7K4Dn5e9rNb
         vfAitJUUZbUEzm+vO7y0T8hF6Gigu5HLKgRVKufXAB3K0i8LpECq10NWWwqJOR76qAFj
         ClGg==
X-Gm-Message-State: AOAM531qoBPdKjkXia3NwuvmUVbYhbV1WA5p52ARIO3W5PYfwRBNAn5S
        PIFiDxXijByhiGmfBg4lq1E=
X-Google-Smtp-Source: ABdhPJwI5/aK/kElB2sgJijqRr029qM0BSNUaknD+egvgrpkBNe+0n8nfPKt3EQ2uPW8CaXulAi5vw==
X-Received: by 2002:a05:6402:550:: with SMTP id i16mr5800527edx.129.1630792747139;
        Sat, 04 Sep 2021 14:59:07 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id k22sm1554974eje.89.2021.09.04.14.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 14:59:06 -0700 (PDT)
Date:   Sun, 5 Sep 2021 00:59:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210904215905.7tcgmtayo73x53wy@skbuf>
References: <bd7c9398-5d3d-ccd8-8804-25074cff6bde@gmail.com>
 <20210902213303.GO22278@shell.armlinux.org.uk>
 <20210902213949.r3q5764wykqgjm4z@skbuf>
 <20210902222439.GQ22278@shell.armlinux.org.uk>
 <20210902224506.5h7bnybjbljs5uxz@skbuf>
 <YTFX7n9qj2cUh0Ap@lunn.ch>
 <20210902232607.v7uglvpqi5hyoudq@skbuf>
 <20210903000419.GR22278@shell.armlinux.org.uk>
 <20210903204822.cachpb2uh53rilzt@skbuf>
 <20210903220623.GA22278@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210903220623.GA22278@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ again, trimming the CC list, because I assume most people don't care,
  and if they do, the mailing lists are there for that ]

On Fri, Sep 03, 2021 at 11:06:23PM +0100, Russell King (Oracle) wrote:
> On Fri, Sep 03, 2021 at 11:48:22PM +0300, Vladimir Oltean wrote:
> > On Fri, Sep 03, 2021 at 01:04:19AM +0100, Russell King (Oracle) wrote:
> > > Removing a lock and then running the kernel is a down right stupid
> > > way to test to see if a lock is necessary.
> > > 
> > > That approach is like having built a iron bridge, covered it in paint,
> > > then you remove most the bolts, and then test to see whether it's safe
> > > for vehicles to travel over it by riding your bicycle across it and
> > > declaring it safe.
> > > 
> > > Sorry, but if you think "remove lock, run kernel, if it works fine
> > > the lock is unnecessary" is a valid approach, then you've just
> > > disqualified yourself from discussing this topic any further.
> > > Locking is done by knowing the code and code analysis, not by
> > > playing "does the code fail if I remove it" games. I am utterly
> > > shocked that you think that this is a valid approach.
> > 
> > ... and this is exactly why you will no longer get any attention from me
> > on this topic. Good luck.
> 
> Good, because your approach to this to me reads as "I don't think you
> know what the hell you're doing so I'm going to remove a lock to test
> whether it is needed." Effectively, that action is an insult towards
> me as the author of that code.

The reason why you aren't getting any of my attention is your attitude,
in case it was not clear.

You've transformed a few words I said and which were entirely
reasonable, "I don't know exactly why the SFP bus needs the rtnl_mutex,
I've removed those locks and will see what fails tomorrow", into a soap
opera based on something I did not say.

> And as I said, if you think that's a valid approach, then quite frankly
> I don't want you touching my code, because you clearly don't know what
> you're doing as you aren't willing to put the necessary effort in to
> understanding the code.
> 
> Removing a lock and running the kernel is _never_ a valid way to see
> whether the lock is required or not. The only way is via code analysis.

It is a completely valid approach for a simple reason: if there was an
obvious reason why the SFP bus code would have needed serialization
through the rtnetlink mutex, I could have found out by looking at all
the failed assertions and said to myself "oh, yeah, right, of course",
instead of spending several hours looking at the code, at which point I
would have had fewer chances of figuring out anyway.

Effectively, with no assertions failing except those from the phylink
upstream SFP ops (which aren't really an indication that any data
structures are protected, no comments, etc), things are much less
obvious. If I knew from the get-go it would come to this, I would have
asked, rest assured. I just did not want to ask an obvious question,
I was more or less thinking out loud about what I am going to do next.

> I wonder whether you'd take the same approach with filesystems or
> memory management code. Why don't you try removing some locks from
> those subsystems and see how long your filesystems last?

This is a completely irrelevant and wrong argument, of course there are
sandboxes in which incompetent people can do insane things without doing
any damage, even if the subsystems they are interested in are filesystems
and memory management. It brings exactly nothing to the discussion.

> You could have asked why the lock was necessary, and I would have
> described it. That would have been the civil approach. Maybe even
> put forward a hypothesis why you think the lock isn't necessary, but
> no, you decide that the best way to go about this is to remove the
> lock and see whether the kernel breaks.
> 
> It may shock you to know that those of us who have been working on
> the kernel for almost 30 years and have seen the evolution of the
> kernel from uniprocessor to SMP, have had to debug race conditions
> caused by a lack of locking know very well that you can have what
> seems to be a functioning kernel despite missing locks - and such a
> kernel can last quite a long time and only show up the race quite
> rarely. This is exactly why "lets remove the lock and see if it
> breaks" is a completely invalid approach. I'm sorry that you don't
> seem to realise just how stupid a suggestion that was.
> 
> I can tell you now: removing the locks you proposed will not show an
> immediate problem, but by removing those locks you will definitely
> open up race conditions between driver binding events on the SFP
> side and network usage on the netdev side which will only occur
> rarely.
> 
> And just because they only happen rarely is not a justification to
> remove locks, no matter how inconvenient those locks may be.

So I really wasn't going to do it, since I have absolutely no stake in
this, but I happened to be on a plane today for several hours with
literally nothing better to do, so I went through the phylink_create and
phylink_destroy code path, with the intention of seeing whether there is
something it does which fundamentally needs to be serialized by the
rtnetlink mutex.

If the mere idea of me removing a lock was insulting to you, I've no
idea what atrocity this might even compare to. But suffice to say, I
spent several hours and it is not obvious at all, based on code analysis
as you wish, why it must be the rtnl_lock and not any other mutex taken
by both the SFP module driver and the SFP upstream consumer (phylink),
with the same semantics except not the mega-bloated rtnetlink mutex.

These are my notes from the plane, it is a single pass (the second pass
will most likely not happen), again it is purely based on code analysis
as you requested, non-expert of course because it is the first time I
look at the details or even study the code paths, and I haven't even run
the code without the rtnetlink protection as I originally intended.

phylink_register_sfp
-> bus = sfp_bus_find_fwnode(fwnode)
   -> fwnode_property_get_reference_args(fwnode)
   -> bus = sfp_bus_get(fwnode)
      -> mutex_lock(&sfp_mutex)
      -> search for fwnode in sfp->fwnode of sfp_buses list # side note, the iterator in this function should have been named "bus", not "sfp", for consistency
         -> if found, kref_get(&sfp->kref)
         -> else allocate new sfp bus with this sfp->fwnode, and kref_init
      -> mutex_unlock(&sfp_mutex)
   -> fwnode_handle_put(fwnode)
-> pl->sfp_bus = bus
-> sfp_bus_add_upstream(bus, pl)
   -> rtnl_lock()
   -> kref_get(bus->kref) <- why? this increments from 1 to 2. Indicative of possibly concurrent code
   -> bus->upstream = pl
   -> if (bus->sfp) <- this code path does not populate bus->sfp, so unless code is running concurrently (?!) branch is not taken
      -> sfp_register_bus(bus)
   -> rtnl_unlock()
   -> if (ret) => sfp_bus_put(bus) <= on error this decrements the kref back from 2 to 1
      -> kref_put_mutex(&bus->kref, sfp_bus_release, &sfp_mutex)
-> sfp_bus_put(bus)
   -> on error, drops the kref from 1 to 0 and frees the bus under the sfp_mutex
   -> on normal path, drops the kref from 2 to 1

Ok, why would bus->sfp be non-NULL (how would the sfp_register_bus possibly be triggered by this function)?
sfp->bus is set from:

sfp_unregister_socket(bus)
-> rtnl_lock
-> if (bus->upstream_ops) sfp_unregister_bus(bus)
-> sfp_socket_clear(bus)
   -> bus->sfp = NULL
-> rtnl_unlock
-> sfp_bus_put(bus)

sfp_register_socket(dev, sfp, ops)
-> bus = sfp_bus_get(dev->fwnode)
-> rtnl_lock
-> bus->sfp_dev = dev;
-> bus->sfp = sfp;
-> bus->socket_ops = ops;
-> if (bus->upstream_ops) => sfp_register_bus(bus);
-> rtnl_unlock
-> on error => sfp_bus_put(bus)
-> return bus

Who calls sfp_register_socket and sfp_unregister_socket?

sfp_probe (the driver for the cage)
-> sfp->sfp_bus = sfp_register_socket(sfp->dev, sfp, &sfp_module_ops)

sfp_remove
-> sfp_unregister_socket(sfp->sfp_bus)

So sfp_register_bus can be called either by phylink_register_sfp(the upstream side) or sfp_probe(the cage side). They are serialized by the rtnl_mutex.
The bus is only registered when both sides are ready:
phylink_register_sfp registers the sfp_bus if sfp_probe was already called first
sfp_probe registers the sfp_bus if phylink_register_sfp was already called first

Finally, what does sfp_register_bus do?

sfp_register_bus(bus)
-> bus->upstream_ops->link_down(bus->upstream)
   -> phylink_sfp_link_down(pl)
      -> phylink_run_resolve_and_disable(pl, PHYLINK_DISABLE_LINK)
         -> appears to be patched by commit 87454b6edc1b ("net: phylink: avoid resolving link state too early")
            to do nothing when called from phylink_register_sfp, since phylink_create calls:
            __set_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state);
            before calling phylink_register_sfp
         -> probably does something only if phylink_start(pl) was called, and sfp_register_socket is called afterwards.
            In that case, it will do this:
            -> queue_work(system_power_efficient_wq, &pl->resolve);
            -> flush_work(&pl->resolve);
            So it will practically call phylink_resolve and wait for it to finish.
-> if bus->phydev exists by now => bus->upstream_ops->connect_phy(bus->upstream, bus->phydev)
   -> phylink_sfp_connect_phy(pl, phy)
      -> phylink_sfp_config
         -> does not seem to do anything requiring rtnl_mutex:
            it mostly seems to call phylink_validate and sfp_select_interface, which are stateless, and
            modify pl->supported, pl->link_config, pl->cur_link_an_mode, pl->link_port.
      -> It also calls phylink_mac_initial_config, but not from the phylink_create code path, because it checks PHYLINK_DISABLE_STOPPED again, as discussed
         -> phylink_mac_initial_config again appears to be stateless from phylink's perspective
   -> phylink_attach_phy
      -> phy_attach_direct
         # does not require rtnl_mutex, see the plethora of drivers which call variants of this function without holding this lock.
         # This is literally the premise that led to the discussion, which Florian pointed out: that you can differentiate between
         # drivers that connect to the PHY in .ndo_open from those that do so at probe time by looking at whether the rtnetlink mutex
         # is taken (which it will be from .ndo_open)
   -> phylink_bringup_phy
      -> phylink_validate, stateless
      -> populates phy->phylink and phy->phy_link_change, but not under mutex_lock(&phy->lock), which is probably fine because there are no concurrent readers
      -> mutex_lock(&phy->lock)
      -> mutex_lock(&pl->state_mutex) # serialize with phylink_disconnect_phy, phylink_ethtool_ksettings_set, phylink_ethtool_set_pauseparam, phylink_resolve, phylink_phy_change
      -> change pl->phydev, pl->phy_state, pl->supported, pl->link_config, phy->advertising
      -> mutex_unlock(&pl->state_mutex)
      -> mutex_unlock(&phy_lock)
      -> phy_request_interrupt
         -> request_threaded_irq
         -> phy_enable_interrupts
            -> calls driver, does not need rtnl_mutex
-> bus->registered = true;
-> bus->socket_ops->attach(bus->sfp);
   -> sfp_attach(sfp)
      -> sfp_sm_event(sfp, SFP_E_DEV_ATTACH)
         -> It must be said that all callers of this function are taking the rtnl_mutex, so there must be something going on in here.
         -> mutex_lock(&sfp->sm_mutex);
         -> sfp_sm_device
            -> Tracks the upstream's state as per the comment.
            -> changes sfp->sm_dev_state. I think the upstream state is changed on the attach event only if the sfp->sm_dev_state
               was SFP_DEV_DETACHED, otherwise nothing happens. The new upstream state appears to transition to SFP_DEV_DOWN.
         -> sfp_sm_module
            -> As per the comment, tracks the insert/remove state of the module, probes the on-board EEPROM, and sets up the power level.
            -> On SFP_E_DEV_ATTACH, it only does something if it was in the SFP_MOD_WAITDEV state.
               -> As per the comment, report the module insertion to the upstream device
                  -> sfp_module_insert(sfp->sfp_bus, &sfp->id);
                     -> bus->upstream_ops->module_insert(bus->upstream, bus)
                        -> phylink_sfp_module_insert
                           -> sets pl->sfp_port and pl->sfp_may_have_phy and pl->sfp_may_have_phy
                           -> optionally calls phylink_sfp_config, which as discussed above does not seem to need the rtnetlink mutex's protection
               -> transitions sfp->sm_mod_state into SFP_MOD_HPOWER and falls through into that state's handler
                  -> sfp_sm_mod_hpower
                     -> a bunch of i2c_reads and i2c_writes, probably do not need rtnl_mutex
                  -> transitions into SFP_MOD_WAITPWR and sets up a timer
         -> sfp_sm_main
            -> we should be entering with sfp->sm_dev_state == SFP_DEV_DOWN and god knows what sfp->sm_mod_state, because the module
               has its own life independent of the upstream attaching or not. Most interesting plausible module state is SFP_MOD_WAITDEV,
               which just became SFP_MOD_WAITPWR. The main state machins is probably in sfp->sm_state == SFP_S_DOWN too.
            -> Because sfp->sm_state is SFP_S_DOWN, the branch under "Some events are global" does probably not get executed at all.
            -> The SFP_S_DOWN handler under the "The main state machine" comment probably exists early too, because sfp->sm_dev_state
               is SFP_DEV_DOWN and not SFP_DEV_UP (freshly attached upstream)
            -> function exits doing nothing?!
-> if (bus->started) => bus->socket_ops->start
   # Since bus->started is set by sfp_upstream_start, which is called at the end of phylink_start, it means this piece of code is not meant to execute
   # from phylink_create's calling context, but from the other caller of sfp_register_bus: sfp_probe. Logically phylink_start comes after phylink_create.
   # So ignore.
-> bus->upstream_ops->attach(bus->upstream, bus)
   -> phylink_sfp_attach(pl, bus)
      -> pl->netdev->sfp_bus = bus
         # This is about the first thing touching the netdev I've seen, but since it's a simple pointer assignment and not anything
         # operating on complex/non-atomic data structures, not sure if this is the reason for rtnl_lock?

And sfp_unregister_bus, called by sfp_bus_del_upstream:
-> bus->upstream_ops->detach(bus->upstream, bus)
  -> phylink_sfp_detach
     -> pl->netdev->sfp_bus = NULL
-> bus->socket_ops->stop(bus->sfp)
   -> sfp_stop(sfp)
      -> sfp_sm_event(sfp, SFP_E_DEV_DOWN);
         -> sfp_sm_device
            -> let's say sfp->sm_dev_state was SFP_DEV_UP, with SFP_E_DEV_DOWN it becomes SFP_DEV_DOWN.
         -> sfp_sm_module
            # I won't go through the state machines again, if something in the teardown path needs
            # rtnetlink protection whereas in the setup path it did not, oh well...

So these are my notes, now please hit me hard, because I don't know, and
I won't look any further into it. Why does phylink_{create,destroy}
require serialization through the rtnetlink mutex?
