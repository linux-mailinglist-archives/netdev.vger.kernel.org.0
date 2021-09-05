Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93F78400DB9
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 02:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234654AbhIEAmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 20:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbhIEAmV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Sep 2021 20:42:21 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ADEC061575;
        Sat,  4 Sep 2021 17:41:18 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id mf2so5770654ejb.9;
        Sat, 04 Sep 2021 17:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rJe7cTJzsthv2SN5ncAaHrD67dkwlr1kekGPxhAIzBk=;
        b=j5RnQ4SOFxyv91V1KCR84iacQnW1ph39+rFsIStZGiV13BCeZi12Ho4GLz6MHQpww+
         GcL0409xrR4QFlVDET3h7ZfuOixUdx3I6EJor2pWz340Lj09VD9LhDcAFzRkZjgtJvoB
         4qzLMf2NmovW39j50lTcGaDcBEOp5fOY74bxZxKjKESm3R9tgwD1k1QNcxtwGlAHcOHO
         9y6DxLn8z5LWzpjEVmBA8z8714QapQibBkjB1i21pUqrv3ouOK5RdzAawbC+B7+BI5P1
         bJ6And0rtv6w/vN69y34Z/QD+eArlYQ30eceAqmOVBWPYqPs/HECEny3/84nrFydu4HZ
         Y4Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rJe7cTJzsthv2SN5ncAaHrD67dkwlr1kekGPxhAIzBk=;
        b=rOCE817n+dH/xcHuPyLqXAzeqSw93KtQ9hFRNK0beuPrWcSlzyPp0b1YpRDmgy1f+c
         qN6mkN8dv4gPfyeZR4CQyn9Ce6KwKFg6gsWp1upFYW9VfSrjDXOFbN4To4BavCBnI/8M
         TwW1PO9ALJugSZN52BApvh7hugD2ZjVtMVJNgqoM59oFQiz0rEwlvp3JYovCxPKZ1/WU
         MZRFCLzzzNNhU1HBso/Rvz9x/3VW7Z2RIKGDYOHSAfr1YoPE8Qw60ij8uqroCX20iVce
         tW/ly2h56sbV4++xnsuZ0U6QcevNE88y3rJbRuhJ0vSyx+CugAiMq2DuLhMqi2kUMRi5
         1jGg==
X-Gm-Message-State: AOAM530J/itqAixkDeJWDmbjDDS2sqE3Sb6k1KSYWuQ6XJu92fgkBjiA
        AXZ2CjO73jePu/oYUPlpPMvzkZOOpUiUYg==
X-Google-Smtp-Source: ABdhPJxdCTnIasU2oDM3gJkatNdgZAahb8tIYqDmuss+d8XEm51yYaqm1oNOxhRX1w8YLO+mQYmg7g==
X-Received: by 2002:a17:906:c20d:: with SMTP id d13mr6509404ejz.259.1630802477097;
        Sat, 04 Sep 2021 17:41:17 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id l18sm2045734edr.83.2021.09.04.17.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 17:41:16 -0700 (PDT)
Date:   Sun, 5 Sep 2021 03:41:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/3] net: phy: don't bind genphy in
 phy_attach_direct if the specific driver defers probe
Message-ID: <20210905004115.wl6moyrgassyzzya@skbuf>
References: <20210902213949.r3q5764wykqgjm4z@skbuf>
 <20210902222439.GQ22278@shell.armlinux.org.uk>
 <20210902224506.5h7bnybjbljs5uxz@skbuf>
 <YTFX7n9qj2cUh0Ap@lunn.ch>
 <20210902232607.v7uglvpqi5hyoudq@skbuf>
 <20210903000419.GR22278@shell.armlinux.org.uk>
 <20210903204822.cachpb2uh53rilzt@skbuf>
 <20210903220623.GA22278@shell.armlinux.org.uk>
 <20210904215905.7tcgmtayo73x53wy@skbuf>
 <YTQAdJDMnPqbpxKk@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTQAdJDMnPqbpxKk@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 12:25:40AM +0100, Russell King (Oracle) wrote:
> On Sun, Sep 05, 2021 at 12:59:05AM +0300, Vladimir Oltean wrote:
> > [ again, trimming the CC list, because I assume most people don't care,
> >   and if they do, the mailing lists are there for that ]
> > 
> > On Fri, Sep 03, 2021 at 11:06:23PM +0100, Russell King (Oracle) wrote:
> > > On Fri, Sep 03, 2021 at 11:48:22PM +0300, Vladimir Oltean wrote:
> > > > On Fri, Sep 03, 2021 at 01:04:19AM +0100, Russell King (Oracle) wrote:
> > > > > Removing a lock and then running the kernel is a down right stupid
> > > > > way to test to see if a lock is necessary.
> > > > > 
> > > > > That approach is like having built a iron bridge, covered it in paint,
> > > > > then you remove most the bolts, and then test to see whether it's safe
> > > > > for vehicles to travel over it by riding your bicycle across it and
> > > > > declaring it safe.
> > > > > 
> > > > > Sorry, but if you think "remove lock, run kernel, if it works fine
> > > > > the lock is unnecessary" is a valid approach, then you've just
> > > > > disqualified yourself from discussing this topic any further.
> > > > > Locking is done by knowing the code and code analysis, not by
> > > > > playing "does the code fail if I remove it" games. I am utterly
> > > > > shocked that you think that this is a valid approach.
> > > > 
> > > > ... and this is exactly why you will no longer get any attention from me
> > > > on this topic. Good luck.
> > > 
> > > Good, because your approach to this to me reads as "I don't think you
> > > know what the hell you're doing so I'm going to remove a lock to test
> > > whether it is needed." Effectively, that action is an insult towards
> > > me as the author of that code.
> > 
> > The reason why you aren't getting any of my attention is your attitude,
> > in case it was not clear.
> > 
> > You've transformed a few words I said and which were entirely
> > reasonable, "I don't know exactly why the SFP bus needs the rtnl_mutex,
> > I've removed those locks and will see what fails tomorrow", into a soap
> > opera based on something I did not say.
> 
> You really don't understand, do you.
> 
> I will say again: you can not remove a lock and then run-time test
> to see whether that lock is required. It doesn't just work like that,
> and the more you persist to assert that it does, the more stupid you
> look to all those who have had years of kernel programming experience.
> So please continue...
> 
> > > And as I said, if you think that's a valid approach, then quite frankly
> > > I don't want you touching my code, because you clearly don't know what
> > > you're doing as you aren't willing to put the necessary effort in to
> > > understanding the code.
> > > 
> > > Removing a lock and running the kernel is _never_ a valid way to see
> > > whether the lock is required or not. The only way is via code analysis.
> > 
> > It is a completely valid approach for a simple reason: if there was an
> > obvious reason why the SFP bus code would have needed serialization
> > through the rtnetlink mutex, I could have found out by looking at all
> > the failed assertions and said to myself "oh, yeah, right, of course",
> > instead of spending several hours looking at the code, at which point I
> > would have had fewer chances of figuring out anyway.
> 
> If we want to answer the question of "why rtnl_mutex" then one first
> has to understand the locking strategy and why I ended up there. It
> is _not_ simple.
> 
> > > I wonder whether you'd take the same approach with filesystems or
> > > memory management code. Why don't you try removing some locks from
> > > those subsystems and see how long your filesystems last?
> > 
> > This is a completely irrelevant and wrong argument, of course there are
> > sandboxes in which incompetent people can do insane things without doing
> > any damage, even if the subsystems they are interested in are filesystems
> > and memory management. It brings exactly nothing to the discussion.
> 
> It is entirely relevant - it is about your approach to testing whether
> a lock is necessary or not. Your stated approach is "lets remove the
> lock and then run the kernel and see if anything breaks." I assert
> that approach is completely invalid.
> 
> > If the mere idea of me removing a lock was insulting to you, I've no
> > idea what atrocity this might even compare to. But suffice to say, I
> > spent several hours and it is not obvious at all, based on code analysis
> > as you wish, why it must be the rtnl_lock and not any other mutex taken
> > by both the SFP module driver and the SFP upstream consumer (phylink),
> > with the same semantics except not the mega-bloated rtnetlink mutex.
> > 
> > These are my notes from the plane, it is a single pass (the second pass
> > will most likely not happen), again it is purely based on code analysis
> > as you requested, non-expert of course because it is the first time I
> > look at the details or even study the code paths, and I haven't even run
> > the code without the rtnetlink protection as I originally intended.
> > 
> > phylink_register_sfp
> > -> bus = sfp_bus_find_fwnode(fwnode)
> >    -> fwnode_property_get_reference_args(fwnode)
> >    -> bus = sfp_bus_get(fwnode)
> >       -> mutex_lock(&sfp_mutex)
> >       -> search for fwnode in sfp->fwnode of sfp_buses list # side note, the iterator in this function should have been named "bus", not "sfp", for consistency
> >          -> if found, kref_get(&sfp->kref)
> >          -> else allocate new sfp bus with this sfp->fwnode, and kref_init
> >       -> mutex_unlock(&sfp_mutex)
> >    -> fwnode_handle_put(fwnode)
> > -> pl->sfp_bus = bus
> > -> sfp_bus_add_upstream(bus, pl)
> >    -> rtnl_lock()
> >    -> kref_get(bus->kref) <- why? this increments from 1 to 2. Indicative of possibly concurrent code
> >    -> bus->upstream = pl
> >    -> if (bus->sfp) <- this code path does not populate bus->sfp, so unless code is running concurrently (?!) branch is not taken
> >       -> sfp_register_bus(bus)
> >    -> rtnl_unlock()
> >    -> if (ret) => sfp_bus_put(bus) <= on error this decrements the kref back from 2 to 1
> >       -> kref_put_mutex(&bus->kref, sfp_bus_release, &sfp_mutex)
> > -> sfp_bus_put(bus)
> >    -> on error, drops the kref from 1 to 0 and frees the bus under the sfp_mutex
> >    -> on normal path, drops the kref from 2 to 1
> 
> First question "why? this increments from 1 to 2. Indicative of possibly
> concurrent code" - you appear to have answered that already in two lines
> immediately above.
> 
> In the case of a pre-existing bus being found, then the krefs will be
> one higher than the numerical values you have given above.
> 
> > Ok, why would bus->sfp be non-NULL (how would the sfp_register_bus possibly be triggered by this function)?
> 
> You've already answered that above. "else allocate new sfp bus with this
> sfp->fwnode, and kref_init". In that case, bus->sfp will be NULL because
> the socket hasn't been registered.
> 
> > sfp->bus is set from:
> > 
> > sfp_unregister_socket(bus)
> > -> rtnl_lock
> > -> if (bus->upstream_ops) sfp_unregister_bus(bus)
> > -> sfp_socket_clear(bus)
> >    -> bus->sfp = NULL
> > -> rtnl_unlock
> > -> sfp_bus_put(bus)
> > 
> > sfp_register_socket(dev, sfp, ops)
> > -> bus = sfp_bus_get(dev->fwnode)
> > -> rtnl_lock
> > -> bus->sfp_dev = dev;
> > -> bus->sfp = sfp;
> > -> bus->socket_ops = ops;
> > -> if (bus->upstream_ops) => sfp_register_bus(bus);
> > -> rtnl_unlock
> > -> on error => sfp_bus_put(bus)
> > -> return bus
> > 
> > Who calls sfp_register_socket and sfp_unregister_socket?
> > 
> > sfp_probe (the driver for the cage)
> > -> sfp->sfp_bus = sfp_register_socket(sfp->dev, sfp, &sfp_module_ops)
> > 
> > sfp_remove
> > -> sfp_unregister_socket(sfp->sfp_bus)
> > 
> > So sfp_register_bus can be called either by phylink_register_sfp(the upstream side) or sfp_probe(the cage side). They are serialized by the rtnl_mutex.
> 
> So here you have established the need for serialisation. However, I
> don't think you have completely grasped it fully.
> 
> Not only do these two need to be serialised, but also the calls
> through sfp_bus, to prevent bus->sfp, bus->socket_ops,
> bus->upstream_ops, or bus->upstream changing beneath us.
> 
> Sure, bus->sfp, bus->socket_ops isn't going to change except when the
> SFP cage is being removed once setup - but these may be dereferenced
> by a call from the network side. The same is true of calls going the
> other way.
> 
> So, we now have a concrete reason why we need serialisation here,
> agreed?
> 
> Let's take a moment, and assume the sfp-bus layer uses its own private
> mutex to achieve this, which would be taken whenever either side calls
> one of the interface functions so that dereferences of bus->sfp,
> bus->socket_ops, bus->upstream_ops and bus->upstream are all safe.
> 
> sfp_get_module_info() and sfp_get_module_eeprom() are called from
> ethtool operations. So, lockdep will see rtnl taken first, then our
> private mutex. As soon as any two locks nest, it creates an immediate
> nesting rule for these two locks to avoid an AB-BA deadlock. We must
> always take our private mutex before rtnl, otherwise we have the
> possibility of an AB-BA deadlock.
> 
> The next part of the puzzle is how we add and remove PHYs.
> 
> Pick any ethtool implementation that dereferences the net device
> "phydev" member, for example linkstate_get_sqi(). This happens to
> take the phydev->lock, but that is not important - the important
> point is that netdev->phydev must be a valid phydev or NULL and
> must not change while the ethtool call is being processed. Which
> lock guarantees that? It's the rtnl lock.
> 
> So, to safely change netdev->phydev on a published or running net
> device, we must be holding the rtnl lock.
> 
> Okay, now lets go back to the sfp_bus layer, and lets consider the
> case where a PHY is being removed - and continue to assume that we
> are using our private locks in that code. The SFP cage code has
> called sfp_remove_phy(), which takes our lock and then calls
> through to the disconnect_phy method.
> 
> The disconnect_phy() needs to take the rtnl lock to safely remove the
> phydev from the network device... but we've taken our private lock.
> 
> So, we end up with two paths, one which takes the locks in the order
> AB and another which takes them in order BA. Lockdep will spot that
> and will complain.
> 
> What ways can that be solved?
> 
> - One can fall back and just use the rtnl lock.
> - One could refcount the structures on both sides, and adding code
>   to handle the case where one side or the other goes away - but
>   even with that, it's still unsafe.
> 
>   Consider sfp_get_module_eeprom(). This will sleep while i2c is
>   read (many network drivers will sleep here under the rtnl lock.)
>   The SFP cage module gets removed mid-call. There's absolutely
>   nothing to prevent that happening. We don't get a look in while
>   the i2c adapter is sleeping to abort that. Maybe the SFP cage
>   gets removed. We now have lost its code, so when the i2c adapter
>   returns, we get a kernel oops because the code we were going to
>   execute on function return has been removed.
> 
> As soon as you start thinking "we can add a lock here instead of rtnl"
> then things start getting really difficult because of netdev holding
> rtnl when making some calls through to the SFP cage code, and rtnl
> needing to be held when changing the phydev in the network interface
> side.
> 
> It isn't nice, I know. I wish it wasn't that way, and we could have
> finer grained locking, but I don't see any possibilities to avoid the
> AB-BA deadlock problem without introducing even more code and/or
> creating bugs in the process of doing so.
> 
> 
> Now, if you take your approach of "lets remove the rtnl lock and see
> whether anything breaks" I can tell you now - you likely won't notice
> anything break from a few hundred boots. However, removing the lock
> _provably_ opens a race between threads loading or removing the SFP
> cage code and actions happening in the netdev layer.
> 
> This is why your approach is invalid. You can not prove a negative.
> You can not prove that a lock isn't needed by removing it. Computing
> does not work that way.
> 
> I don't write code to "work 99% of the time". I write code to try to
> achieve reliable operation, and that means having the necessary locks
> in place to avoid races and prevent kernel oops.
> 
> One of the things that having been involved in Linux for so long
> teaches you is that a race, no matter how rare, will get found.

I haven't fully digested everything you've said, but if I were to
summarize the basic idea, it is that
(a) the rtnetlink mutex fundamentally serializes accesses to
    netdev->phydev on a registered interface, which renders my comment
    about phy_attach_direct not needing rtnl_lock invalid, since phylink
    needs to deal with PHYs appearing and disappearing on SFP modules
    while the netdev attached to the sfp upstream is already registered.
    This would mean that if we were to replace the rtnl mutex with
    something else, it'd have to be a netdev->phy_lock which is held at
    all times when netdev->phydev is accessed. Of course, that would be
    its own discussion, which functions should take this lock on their
    own and which should expect it to already be held.
(b) the sfp upstream and module drivers need to synchronize on a shared
    lock that is taken top-level by both parties, and the rtnetlink
    mutex is currently used for that. Could the sfp bus not have exactly
    that, a shared mutex (a pointer), created by whomever creates the
    sfp bus first, and destroyed by whomever puts the last reference on
    the sfp bus? This would act as the top-level mutex, and netdev->phy_lock
    would be accessed from within the individual functions that need to
    touch that (probably just the upstream side). The sfp_mutex lock
    inside sfp_bus_get could probably act as preliminary serialization
    until the shared lock is fully published and held by the side that
    created the lock in the first place.

The entire reason I'm asking is because I got the impression that you
are not fully satisfied with the only apparent solution to the dpaa2
deadlock problem, which is to force all callers of phylink_{create,destroy}
to take the rtnl mutex top-level, because it would not be needed for
most of the operations, and it would make the design even harder to
untangle later on. If you are satisfied with that solution, my bad.
