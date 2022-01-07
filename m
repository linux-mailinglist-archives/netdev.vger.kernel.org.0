Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3837487B40
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348501AbiAGRRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:17:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240626AbiAGRRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 12:17:17 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F960C061574;
        Fri,  7 Jan 2022 09:17:16 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id u21so2066642edd.5;
        Fri, 07 Jan 2022 09:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4HfyCD4z5LlCQdyT/gsFiffDFskW7TptkN9s5F+4JIE=;
        b=NgVpolGDgb8qOW0gYva5rr50/Wga4a72Zt+69m6gNWWAzKVOMkEQ4Z2VmNc1FNdrOw
         P+eMAIT0hkVqG4oOoo9nasOOmjc6+WzCeNNLWCt/yd1IjJP8pLGVzPz1US+Ybh95e3f8
         N5/Cs1novqsGC0IQUMe0co/1QSAKbAuVN+AOJkk3L4/x9KnMx+h/fJ7LhUyuW531WI/v
         gXdsQPTjJdApphCc/4UeNU4/9qSpmlrRlFyDfN3/OHt1XMqEl2nYdQSdQLl0gHBcL0f4
         bviX9+Nd+CkEMnjIR+d3tNAKAAYLKhaq2T/BdHlokc77nFQxAUqV2kjIuhYxaKZOTyzP
         3xKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4HfyCD4z5LlCQdyT/gsFiffDFskW7TptkN9s5F+4JIE=;
        b=UnwO1p9b6wIJZuPj5ea5zPrSi1ujSClVeB+tpz8KGEgq0yEKa43oHHmMC0No+ldA7j
         +HO19b57HQeAwNVksP7GI/cp0KZdvbDGC2hKXagL6SuQK7tuC/OImhcrZHfYuqhVgmuF
         AkvOMCven5qH0zVAATEDIHZXaCCtUF/GTYzKWf9pf26TA05/IGOBwLPLxSSxR/nujUEa
         5hcRRv7zIkSJPCbDca9EE3TbI263hhpFz+Lzz4jt4oK+HHZjlJsDH1Odu0Cw2oLh+vxj
         VPOfwSPhYo1Mb8LqqXVCTq51GzC3yZAKkLmDP9B3dELF/4DqmzQPBbgrvQ0cRosQpO6l
         yRyg==
X-Gm-Message-State: AOAM530vdCMnwJCggNHK9/Qfxg/33iFGkZFnniar4G7EZuL6CgZsM7k+
        8P2fpo/vyecGQFrCJ2ZQr28=
X-Google-Smtp-Source: ABdhPJzRwGkLN0LxLTsbQiA8b2q6rven/SEwz0tMGMZwOfoFS4LXTSbn1jwzy6O55tgBkDeOQPj34w==
X-Received: by 2002:a17:907:7f29:: with SMTP id qf41mr49973282ejc.715.1641575834912;
        Fri, 07 Jan 2022 09:17:14 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id z22sm2359219edd.68.2022.01.07.09.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 09:17:14 -0800 (PST)
Date:   Fri, 7 Jan 2022 19:17:13 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next PATCH RFC v6 00/16] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20220107171713.funt5cijbcn2n2hm@skbuf>
References: <20211214224409.5770-1-ansuelsmth@gmail.com>
 <20211215102629.75q6odnxetitfl3w@skbuf>
 <61ba1928.1c69fb81.4ef9.360b@mx.google.com>
 <20211216233812.rpalegklcrd4ifzs@skbuf>
 <61d75798.1c69fb81.53557.d018@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d75798.1c69fb81.53557.d018@mx.google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 09:56:56PM +0100, Ansuel Smith wrote:
> On Fri, Dec 17, 2021 at 01:38:12AM +0200, Vladimir Oltean wrote:
> > On Wed, Dec 15, 2021 at 05:34:45PM +0100, Ansuel Smith wrote:
> > > > > I tested this with multicpu port and with port6 set as the unique port and
> > > > > it's sad.
> > > > > It seems they implemented this feature in a bad way and this is only
> > > > > supported with cpu port0. When cpu port6 is the unique port, the switch
> > > > > doesn't send ack packet. With multicpu port, packet ack are not duplicated
> > > > > and only cpu port0 sends them. This is the same for the MIB counter.
> > > > > For this reason this feature is enabled only when cpu port0 is enabled and
> > > > > operational.
> > > > 
> > > > Let's discuss this a bit (not the hardware limitation, that one is what
> > > > it is). When DSA has multiple CPU ports, right now both host-side
> > > > Ethernet ports are set up as DSA masters. By being a DSA master, I mean
> > > > that dev->dsa_ptr is a non-NULL pointer, so these interfaces expect to
> > > > receive packets that are trapped by the DSA packet_type handlers.
> > > > But due to the way in which dsa_tree_setup_default_cpu() is written,
> > > > by default only the first CPU port will be used. So the host port
> > > > attached to the second CPU port will be a DSA master technically, but it
> > > > will be an inactive one and won't be anyone's master (no dp->cpu_dp will
> > > > point to this master's dev->dsa_ptr). My idea of DSA support for
> > > > multiple CPU ports would be to be able to change the dp->cpu_dp mapping
> > > > through rtnetlink, on a per user port basis (yes, this implies we don't
> > > > have a solution for DSA ports).
> > > 
> > > I have a similar implementation that was proposed as RFC many times ago.
> > 
> > Yes, well, how to assign a user port to a CPU port seems not to be the
> > biggest problem that needs to be solved before support for multiple CPU
> > ports can fully go in.
> >
> 
> Hi,
> sorry for the delay.
> 
> I honestly think a start for multicpu that would improve the state would
> be start adding support to iproute for changing the master port.

Agree there, but since that would be new UAPI, we need to make sure it
works for all future work that we plan to do. And that future work also
includes LAG between CPU ports. In the current form that I have some
patches in, that would look like this:

ip link set eno2 down # old DSA master
ip link set eno2 master bond0
ip link set eno3 master bond0
# This is super annoying, because the bonding driver brings its ports up
# automatically, and on the other hand DSA wants its master to be down
# while changing the CPU port
ip link set eno2 down
ip link set eno3 down
ip link set bond0 down
# Changing the DSA master is done step by step. We pass through invalid
# intermediate steps, such as swp0 being under bond0, but swp1, swp2,
# swp3 still under eno2. We allow those invalid intermediate steps
# because the ports are down.
./ip link set swp0 type dsa master bond0
./ip link set swp1 type dsa master bond0
./ip link set swp2 type dsa master bond0
./ip link set swp3 type dsa master bond0
# Here is the point during which DSA should refuse to come up if it
# doesn't like something about the new configuration.
ip link set swp0 up # this also brings up the new DSA master, bond0

so yeah, it isn't great (not to mention it doesn't even work, yet).
The LAG FDB patch set I've posted today is part of the effort to see how
feasible it is to do LAG between CPU ports (FDB entries would be used
for CPU filtering).

> > > > My second observation is based on the fact that some switches support a
> > > > single CPU port, yet they are wired using two Ethernet ports towards the
> > > > host. The Felix and Seville switches are structured this way. I think
> > > > some Broadcom switches too.
> > > > Using the rtnetlink user API, a user could be able to migrate all user
> > > > ports between one CPU port and the other, and as long as the
> > > > configuration is valid, the switch driver should accept this (we perform
> > > > DSA master changing while all ports are down, and we could refuse going
> > > > up if e.g. some user ports are assigned to CPU port A and some user
> > > > ports to CPU port B). Nonetheless, the key point is that when a single
> > > > CPU port is used, the other CPU port kinda sits there doing nothing. So
> > > > I also have some patches that make the host port attached to this other
> > > > CPU port be a normal interface (not a DSA master).
> > > > The switch side of things is still a CPU port (not a user port, since
> > > > there still isn't any net device registered for it), but nonetheless, it
> > > > is a CPU port with no DSA tagging over it, hence the reason why the host
> > > > port isn't a DSA master. The patch itself that changes this behavior
> > > > sounds something like "only set up a host port as a DSA master if some
> > > > user ports are assigned to it".
> > > > As to why I'm doing it this way: the device tree should be fixed, and I
> > > > do need to describe the connection between the switch CPU ports and the
> > > > DSA masters via the 'ethernet = <&phandle>;' property. From a hardware
> > > > perspective, both switch ports A and B are CPU ports, equally. But this
> > > > means that DSA won't create a user port for the CPU port B, which would
> > > > be the more natural way to use it.
> > > > Now why this pertains to you: Vivien's initial stab at management over
> > > > Ethernet wanted to decouple a bit the concept of a DSA master (used for
> > > > the network stack) from the concept of a host port used for in-band
> > > > management (used for register access). Whereas our approach here is to
> > > > keep the two coupled, due to us saying "hey, if there's a direct
> > > > connection to the switch, this is a DSA master anyway, is it not?".
> > > > Well, here's one thing which you wouldn't be able to do if I pursue my
> > > > idea with lazy DSA master setup: if you decide to move all your user
> > > > ports using rtnetlink to CPU port 6, then the DSA master of CPU port 0
> > > > will cease to be a DSA master. So that will also prevent the management
> > > > protocol from working.
> > > 
> > > About the migration problem, wonder if we can just use a refcount that
> > > would represent the user of the master port. The port won't be DSA
> > > master anymore if no user are connected. A switch can increase this ref
> > > if the port is mandatory for some operation. (qca8k on state change
> > > operational would increase the ref and decrease and then the port can be
> > > removed from a DSA master) That should handle all the other switch and
> > > still permit a driver to ""bypass"" this behaviour.
> > 
> > Maybe. Although not quite like the way in which you propose. Remember
> > that the idea is for a DSA master to be a regular interface until it
> > gains a user. So there's the chicken and egg problem if you want to
> > become a user on ->master_state_change()... because it's not a master.
> > You'd have to specify upfront.
> > 
> 
> I mean we can really think of adding an option or a flag for the port
> that will be used to declare a cpu port as to be ignored by any disable
> procedure. From what I can remember some broadcom switch have some
> management port that can't be disabled for example so I can see an use
> where a flag of this kind would be useful. Some thing like declaring a
> port as a managament port and with this case any ""cleanup"" function
> will be ignored? That would solve the chicken-egg problem and dts won't
> have to be changed.

When you say "disable a CPU port", you mean "configure as not a CPU port"?
It might get tricky. DSA currently selects the lowest numbered port in
the device tree with 'ethernet = <&phandle>' as CPU port. If the second
possible CPU port, that we're adding, has a lower number than that, we'd
effectively change the default behavior with the new device tree.
We might need some hints from the driver even for that.

> > > > I don't want to break your use case, but then again, I'm wondering what
> > > > we could do to support the second CPU port working without DSA tagging,
> > > > without changing the device trees to declare it as a user port (which in
> > > > itself isn't bad, it's just that we need to support all use cases with a
> > > > single, unified device tree).
> > > 
> > > Just some info about the secondary CPU port.
> > > From Documentation the second cpu port in sgmii mode can be used also for
> > > other task so yes we should understand how to handle this. (base-x, mac
> > > and phy) This mode is set based on the phy mode and if the dsa port is a
> > > cpu port. Device tree changes can be accepted as AFAIK due to DSA not
> > > supporting multi cpu, CPU port 6 was never used/defined. (But I'm
> > > not sure... that is the case for all the device we have on openwrt)
> > 
> > What do you mean exactly by "other tasks"?
> > 
> 
> I never notice a device with this (actually we just find one that has 2
> qca8k switch that seems to be connected with the port6 port) but other
> task are for example interconnecting 2 switch or attach some external
> port like sfp. (I assume?)
> 
> > > Considering that introducing multicpu port would require a
> > > bit of rework, wonder if we should introduce some new bindings/node and
> > > fallback to a legacy (aka force first cpu port as the unique cpu port
> > > and ignore others) in the absence of this new implementation. (Hoping I
> > > didn't get all wrong with the main problem here)
> > 
> > The defaults would stay the same. (I've no idea why we would introduce
> > new device tree bindings? the only device tree change IMO would be to
> > declare the link between the second CPU port and its DSA master, if you
> > haven't done that already) But my key point was that, to some extent,
> > some change to the current behavior will still be required. Like right
> > now, a kernel 5.15 when it sees a device tree with 2 CPU ports will have
> > 2 DSA masters. Maybe kernel 5.17 will only start off with the first port
> > as a DSA master, and the other just a candidate. I'm hoping this won't
> 
> IMHO that would be the correct way. Just offer a secondary port and
> leave the user decide to use it or not. (Single CPU port by default and
> leave the user the choice to use the second with an init script)
> 
> > change observable behavior for the worse for anyone, because device
> > trees are supposed to be there to stay, not change on a whim. My hope is
> > based on the fact that as far as I can see, that second DSA master is
> > effectively useless. Which in fact creates the second problem: exactly
> > because the second host port is useless with the current code structure,
> > I can see people describing it as a user rather than CPU port in current
> > device trees, just to make some use out of it. But that restricts the
> > potential user base (and therefore appeal) of my change of behavior or
> > of multi-CPU port support in general, and this is a bit sad. I think we
> > should be all spending a bit more time with current-generation kernels
> > on "updated" device trees with multiple CPU ports defined, and see
> > what's broken and what could be improved, because otherwise we could be
> > leaving behind a huge mess when the device trees get updated, and we
> > need to run the occasional old kernel on them.
> > 
> 
> Anyway I think I didn't understand you from the start. Your problem was
> with user declaring any additional cpu port as an user port (that is not
> usable?) and not declaring the needed master.
> 
> Something like
> 
> port@6 {
> 				reg = <6>;
> 				label = "swp6";
> 				phy-mode = "sgmii"
> 			};
> 
> instead of (current way we use to declare secondary port on qca8k)
> 
> port@6 {
> 				reg = <6>;
> 				label = "cpu";
> 				ethernet = <&gmac2>;
> 				phy-mode = "sgmii";
> 
> 				fixed-link {
> 					speed = <1000>;
> 					full-duplex;
> 				};
> 			};

Yes, you basically have two options for your second CPU port, and you've
pointed out both options above.

If you describe it as you did in the second case, you'd have a 'correct'
device tree, but this makes that port unusable with all DSA code bases
that exist currently.

If you describe it as you did in the first case (CPU port as user port),
you'd have a functional port, but you wouldn't be able to make use of
multiple CPU ports in DSA without updating your device tree.

The idea is to be able to have the functionality gained by the first
device tree description (CPU port as user port), while having a device
tree that looks like the second description (both ports are proper CPU
ports). For the Felix driver, I've introduced the concept of a "forced
forwarding mask", and the second CPU port (port@6 in your example) is
part of that forced forwarding mask unconditionally, which emulates what
would happen if you'd put swp6 in a bridge with every other user port.

> > > But if I'm not wrong there was at the start some years ago an idea of a
> > > node used to declare master port separate from the generic port node but
> > > it was rejected?
> > 
> > I don't know anything about this.
> 
> One of the first RFC for multicpu port (somethin many years ago) from
> some Marvell devs was to declare an additional node (separate from the
> current one) that would declare cpu ports. But it was a bit useless and
> was dropped after some version.
> 
> Aside from these concern how should we proceed with this series? Should
> we first understand the multicpu problem?
> 
> Again sorry for the dealy.

I don't think this series has any dependency on the multiple CPU port
support. I just opened the discussion because I knew you were also
working on it, and I wanted to collect some information about the way in
which you need it to work for your systems.
