Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D672235C43E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 12:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239482AbhDLKnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 06:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237523AbhDLKnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 06:43:01 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67576C061574;
        Mon, 12 Apr 2021 03:42:43 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id bx20so13307218edb.12;
        Mon, 12 Apr 2021 03:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0V7bmJwZrfaCcSD3fadrsclKhaxkka86rlw6YQqxFdo=;
        b=gEef5uT064jkyLHOkzRMwos5+PJVnleBJBFbr1fpRkADUDGxCkaaPBwKdzgdVunrzR
         656qqfEFtlPNHerswXYSVHhj8uEHBZFg/74L1kqmaHqx/rQSmJjULBeojtpsuBGB5iAU
         LkHpAsTotjUTa8sS376o5Dpww0DWy4MOe7jRyMo7EoTrYSctiF7e5OjrdzGfdUDT988R
         E9wEF1ucNHFZPGofr0hByuhrisSTW6TrmZ8hT50S28hZh6OLQkiHHCJAgKVvEyLIx7GV
         nnHFkKg5go9NwMq/hnb4litnvaCbCGnQbNhcFvJ2C23jQNfn45fcN7mzZt2tGrrK1+Km
         kUNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0V7bmJwZrfaCcSD3fadrsclKhaxkka86rlw6YQqxFdo=;
        b=pMNiik5pj39iVsPZeeQFJTKcqXhLF4z/Vh90Li2aEg/qkpjupkq2KC3N3/J844MfFw
         u+q6LJk4B8zeXL6dBi8XVvwjhjzWAdIZFmXXyaTAcvgmcdHWCaZxEyAYAO4jWpVDi+RH
         4TTizPg2cNmb4hfoeIAEES5KFgkvgYnlYc02LJFclr3ymeUeRVMpuQEr0Kb+5XbFMdX2
         ESx/JID+d8//x8MUvwou7yJ2w0dJasokGUsuhWcrp8p6aS4dTvislrWR4yAaAsAuU/rP
         CbUaSnlvt918+BX97qqiXgE1QkOj2oAWwmflc7SflOFPb/tPW2dcHnxEoVbLgZHW0HKT
         pzig==
X-Gm-Message-State: AOAM533149hN8wJQ+O1ZK6fa7DgLykoqxZXoYtk4C2mN/ameEXTWwL0m
        YSBM5hr9Hd1uLLWCkCg4F0I=
X-Google-Smtp-Source: ABdhPJzmq0Q+VU8bKotsJHkluNOoZ9oHy2IaUhW964SBueZrXx8ZoZveeHwWDtJTQ4NyAKgUoN6otQ==
X-Received: by 2002:a05:6402:42c9:: with SMTP id i9mr28937182edc.35.1618224161997;
        Mon, 12 Apr 2021 03:42:41 -0700 (PDT)
Received: from Ansuel-xps.localdomain (host-79-34-220-97.business.telecomitalia.it. [79.34.220.97])
        by smtp.gmail.com with ESMTPSA id d6sm6446409edr.21.2021.04.12.03.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 03:42:41 -0700 (PDT)
Date:   Mon, 12 Apr 2021 07:04:35 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek Behun <marek.behun@nic.cz>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <YHPU452sWbJ5Ciss@Ansuel-xps.localdomain>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
 <20210411185017.3xf7kxzzq2vefpwu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411185017.3xf7kxzzq2vefpwu@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 09:50:17PM +0300, Vladimir Oltean wrote:
> On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
> > On Sat, 10 Apr 2021 15:34:46 +0200
> > Ansuel Smith <ansuelsmth@gmail.com> wrote:
> > 
> > > Hi,
> > > this is a respin of the Marek series in hope that this time we can
> > > finally make some progress with dsa supporting multi-cpu port.
> > > 
> > > This implementation is similar to the Marek series but with some tweaks.
> > > This adds support for multiple-cpu port but leave the driver the
> > > decision of the type of logic to use about assigning a CPU port to the
> > > various port. The driver can also provide no preference and the CPU port
> > > is decided using a round-robin way.
> > 
> > In the last couple of months I have been giving some thought to this
> > problem, and came up with one important thing: if there are multiple
> > upstream ports, it would make a lot of sense to dynamically reallocate
> > them to each user port, based on which user port is actually used, and
> > at what speed.
> > 
> > For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
> > ports support at most 1 Gbps. Round-robin would assign:
> >   CPU port 0 - Port 0
> >   CPU port 1 - Port 1
> >   CPU port 0 - Port 2
> >   CPU port 1 - Port 3
> >   CPU port 0 - Port 4
> > 
> > Now suppose that the user plugs ethernet cables only into ports 0 and 2,
> > with 1, 3 and 4 free:
> >   CPU port 0 - Port 0 (plugged)
> >   CPU port 1 - Port 1 (free)
> >   CPU port 0 - Port 2 (plugged)
> >   CPU port 1 - Port 3 (free)
> >   CPU port 0 - Port 4 (free)
> > 
> > We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
> > CPU, and the second CPU port is not used at all.
> > 
> > A mechanism for automatic reassignment of CPU ports would be ideal here.
> > 
> > What do you guys think?
> 
> The reason why I don't think this is such a great idea is because the
> CPU port assignment is a major reconfiguration step which should at the
> very least be done while the network is down, to avoid races with the
> data path (something which this series does not appear to handle).
> And if you allow the static user-port-to-CPU-port assignment to change
> every time a link goes up/down, I don't think you really want to force
> the network down through the entire switch basically.
> 
> So I'd be tempted to say 'tough luck' if all your ports are not up, and
> the ones that are are assigned statically to the same CPU port. It's a
> compromise between flexibility and simplicity, and I would go for
> simplicity here. That's the most you can achieve with static assignment,
> just put the CPU ports in a LAG if you want better dynamic load balancing
> (for details read on below).
> 
> But this brings us to another topic, which I've been discussing with
> Florian. I am also interested in the multi CPU ports topic for the
> NXP LS1028A SoC, which uses the felix driver for its embedded switch.
> I need to explain some of the complexities there, in order to lay out
> what are the aspects which should ideally be supported.
> 
> The Ocelot switch family (which Felix is a part of) doesn't actually
> support more than one "NPI" port as it's called (when the CPU port
> module's queues are linked to an Ethernet port, which is what DSA calls
> the "CPU port"). So you'd be tempted to say that a DSA setup with
> multiple CPU ports is not realizable for this SoC.
> 
> But in fact, there are 2 Ethernet ports connecting the embedded switch
> and the CPU, one port is at 2.5Gbps and the other is at 1Gbps. We can
> dynamically choose which one is the NPI port through device tree
> (arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi), and at the moment, we
> choose the 2.5Gbps port as DSA CPU port, and we disable the 1Gbps
> internal port. If we wanted to, we could enable the second internal port
> as an internally-facing user port, but that's a bit awkward due to
> multi-homing. Nonetheless, this is all that's achievable using the NPI
> port functionality.
> 
> However, due to some unrelated issues, the Felix switch has ended up
> supporting two tagging protocols in fact. So there is now an option
> through which the user can run this command:
> 
>   echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging
> 
> (where eno2 is the DSA master)
> and the switch will disable the NPI port and set up some VLAN
> pushing/popping rules through which DSA gets everything it needs to
> offer absolutely the same services towards the upper network stack
> layer, but without enabling the hardware functionality for a CPU port
> (as far as the switch hardware is aware, it is unmanaged).
> 
> This opens up some possibilities because we no longer have the
> limitation that there can be only 1 NPI port in the system. As you'd
> have it, I believe that any DSA switch with a fully programmable "port
> forwarding matrix" (aka a bitmap which answers the question "can port i
> send packets to port j?") is capable to some degree of supporting
> multiple DSA CPU ports, in the statically-assigned fashion that this
> patch series attempts to achieve. Namely, you just configure the port
> forwarding matrix to allow user port i to flood traffic to one CPU port
> but not to the other, and you disable communication between the CPU
> ports.
> 
> But there is something which is even more interesting about Felix with
> the ocelot-8021q tagger. Since Marek posted his RFC and until Ansuel
> posted the follow-up, things have happened, and now both Felix and the
> Marvell driver support LAG offload via the bonding and/or team drivers.
> At least for Felix, when using the ocelot-8021q tagged, it should be
> possible to put the two CPU ports in a hardware LAG, and the two DSA
> masters in a software LAG, and let the bond/team upper of the DSA
> masters be the CPU port.
> 
> I would like us to keep the door open for both alternatives, and to have
> a way to switch between static user-to-CPU port assignment, and LAG.
> I think that if there are multiple 'ethernet = ' phandles present in the
> device tree, DSA should populate a list of valid DSA masters, and then
> call into the driver to allow it to select which master it prefers for
> each user port. This is similar to what Ansuel added with 'port_get_preferred_cpu',
> except that I chose "DSA master" and not "CPU port" for a specific reason.
> For LAG, the DSA master would be bond0.
> 
> In fact, in my case, this CPU port election procedure should also be
> repeated when the tagging protocol changes, because Felix will be forced
> to choose the same DSA master for all user ports at probe time, because
> it boots up with the standard NPI-based "ocelot" tagger. So it can only
> make use of the second CPU port when the tagging protocol changes.
> 
> Changing the DSA tagging protocol has to be done with the network down
> (ip link set eno2 down && ip link set eno3 down). If we were to bring
> eno2 and eno3 back up now, DSA or the driver would choose one of the DSA
> masters for every port, round robin or what not. But we don't bring
> the masters up yet, we create a bonding interface and we enslave eno2
> and eno3 to it. DSA should detect this and add bond0 to its list of
> candidates for a DSA master. Only now we bring up the masters, and the
> port_get_preferred_cpu() function (or however it might end up being
> named) should give the driver the option to select bond0 as a valid DSA
> master.
> 
> Using bond0 as a DSA master would need some changes to DSA, because
> currently it won't work. Namely, the RX data path needs the netdev->dsa_ptr
> populated on the DSA master, whose type is a struct dsa_port *cpu_dp.
> So, logically, we need a *cpu_dp corresponding to bond0.
> 
> One idea to solve this is to reuse something we already have: the
> current struct dsa_switch_tree :: lags array of net devices. These hold
> pointers to bonding interfaces now, but we could turn them into an array
> of struct dsa_port "logical ports". The idea is that through this
> change, every LAG offloaded by DSA will have a corresponding "logical
> dp" which isn't present in the dst->ports list. Since every struct
> dsa_port already has a lag_dev pointer, transforming the "dst->lags"
> array from an array of LAG net devices into an array of logical DSA
> ports will cover the existing use case as well: a logical port will
> always have the dp->lag_dev pointer populated with the bonding/team
> interface it offloads.
> 
> So if we make this change, we can populate bond0->dsa_ptr with this
> "logical dp". This way we need to make no other changes to the RX data
> path, and from the PoV of the data path itself, it isn't even a 'multi
> CPU port' setup.
> 
> As for TX, that should already be fine: we call dev_queue_xmit() towards
> bond0 because that's our master, and bond0 deals with xmit hashing
> towards eno2 or eno3 on a per-packet basis, and that's what we want.
> 
> To destroy this setup, the user just needs to run 'ip link del bond0'
> (with the link down I think) and DSA should call 'port_get_preferred_cpu'
> again, but without bond0 in the list this time. The setup should revert
> to its state with static assignment of user to CPU ports.
> 
> [ of course, I haven't tried any of this, I am just imagining things ]
> 
> I deliberately gave this very convoluted example because I would like
> the progress that we make to be in this general direction. If I
> understand your use cases, I believe they should be covered.

To sum up all these comments, we really wants all the same thing.
- Switch driver that can comunicate some type of preference with the CPU
  assignement logic.
- Userspace that can change the CPU.
I really think that to make some progress with this, we should really try
to add support for some very basic implementation of this. I think the series
I posted achieve this, the switch driver to actually enable multi-cpu
support requires the get_preferred_port function to be declared so every
driver must be changed to support this or the old implementation is used
(and this is not a bad thing since some tweaks are always needed or 99%
of the time the second cpu will cause some problem)

