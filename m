Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E9C35B6A1
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 20:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhDKSui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 14:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235559AbhDKSuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Apr 2021 14:50:37 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B54C061574;
        Sun, 11 Apr 2021 11:50:21 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id w23so822422ejb.9;
        Sun, 11 Apr 2021 11:50:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1ty1Czh9jzGSLSaBD6OEi4xCWXhhRsAdU4C4Zv9FtpA=;
        b=h3+qmfIBrq9SMeJ9SUE8NAWojFCjO7X2et0Sw+gRAkPQYksU2US98qcPxmvLS5TzV+
         DQilo4ce5ixh8uAyS2GG+n+9II/1YovjJDo8U5fx+obecVVnzfVHOMwY/rQUfSuruVnq
         sOR34pMGadXflXvK8AbUZiO5/bC7Y8cCJ6Y6jfSonAWoAqPQbcpaxjeiV/GjdNk3AyOC
         Jvkl6gDGOpRkw4sax8yuuhR0j39bhoTwZbP9RQTrnQy6htih2U00a1vjg7d3N/qTzNyb
         BeSaC4lxxJqgnvNpoATzfxfKJTJgwx/xh5LkB23CzkIJAxtPXTPRyyuL8FEuLUdszhMC
         RIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1ty1Czh9jzGSLSaBD6OEi4xCWXhhRsAdU4C4Zv9FtpA=;
        b=K+OEsv6iHJzurT5kJB4abnDSPd7k47k3Btd6Z9N0clD0Q9tSgTAoH6qGvNPdBa9hjo
         LZ9Yl9M600GEabhCOS1f0/FipiRBizfQwkSZdMH76YQxa6m5NURtoM0iZeQ13y+4+IJj
         jBlkaVnSiOorGORNfZ/8l+4AMuyUmwTPX+g5TiOyHGuzwLvpgaNEY1zyNNg1GOMYL2sN
         qGW+KXjJbuuW8GttGlE+54TtqD2HBkBBjKsRqh2QlpG7UkHPGybGGsyqfFdmN1WfkHdh
         qs8ax2AAgEnjYu8nxEv4W89c31qgVILioDE7+iDIinxlR6w69BZRkfRIwXHFXJuQI734
         WiVw==
X-Gm-Message-State: AOAM533gG9vMW072cD3J4mijjF1uM/aFtr1gj/ANIH1FYMj6xm95DeOY
        Q+S+l2clkdqq5Pq6m8HsTlA=
X-Google-Smtp-Source: ABdhPJxUGUHe1CqoDODRylrnVsXKIwWIFQxN50fgwFCqtCRDyBLMqI1LlpYkLW+8Ci1A+zZcBjW/1A==
X-Received: by 2002:a17:906:a0c2:: with SMTP id bh2mr23624798ejb.394.1618167019649;
        Sun, 11 Apr 2021 11:50:19 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a9sm5232003eda.13.2021.04.11.11.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 11:50:19 -0700 (PDT)
Date:   Sun, 11 Apr 2021 21:50:17 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
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
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210411185017.3xf7kxzzq2vefpwu@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411200135.35fb5985@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
> On Sat, 10 Apr 2021 15:34:46 +0200
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Hi,
> > this is a respin of the Marek series in hope that this time we can
> > finally make some progress with dsa supporting multi-cpu port.
> > 
> > This implementation is similar to the Marek series but with some tweaks.
> > This adds support for multiple-cpu port but leave the driver the
> > decision of the type of logic to use about assigning a CPU port to the
> > various port. The driver can also provide no preference and the CPU port
> > is decided using a round-robin way.
> 
> In the last couple of months I have been giving some thought to this
> problem, and came up with one important thing: if there are multiple
> upstream ports, it would make a lot of sense to dynamically reallocate
> them to each user port, based on which user port is actually used, and
> at what speed.
> 
> For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
> ports support at most 1 Gbps. Round-robin would assign:
>   CPU port 0 - Port 0
>   CPU port 1 - Port 1
>   CPU port 0 - Port 2
>   CPU port 1 - Port 3
>   CPU port 0 - Port 4
> 
> Now suppose that the user plugs ethernet cables only into ports 0 and 2,
> with 1, 3 and 4 free:
>   CPU port 0 - Port 0 (plugged)
>   CPU port 1 - Port 1 (free)
>   CPU port 0 - Port 2 (plugged)
>   CPU port 1 - Port 3 (free)
>   CPU port 0 - Port 4 (free)
> 
> We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
> CPU, and the second CPU port is not used at all.
> 
> A mechanism for automatic reassignment of CPU ports would be ideal here.
> 
> What do you guys think?

The reason why I don't think this is such a great idea is because the
CPU port assignment is a major reconfiguration step which should at the
very least be done while the network is down, to avoid races with the
data path (something which this series does not appear to handle).
And if you allow the static user-port-to-CPU-port assignment to change
every time a link goes up/down, I don't think you really want to force
the network down through the entire switch basically.

So I'd be tempted to say 'tough luck' if all your ports are not up, and
the ones that are are assigned statically to the same CPU port. It's a
compromise between flexibility and simplicity, and I would go for
simplicity here. That's the most you can achieve with static assignment,
just put the CPU ports in a LAG if you want better dynamic load balancing
(for details read on below).

But this brings us to another topic, which I've been discussing with
Florian. I am also interested in the multi CPU ports topic for the
NXP LS1028A SoC, which uses the felix driver for its embedded switch.
I need to explain some of the complexities there, in order to lay out
what are the aspects which should ideally be supported.

The Ocelot switch family (which Felix is a part of) doesn't actually
support more than one "NPI" port as it's called (when the CPU port
module's queues are linked to an Ethernet port, which is what DSA calls
the "CPU port"). So you'd be tempted to say that a DSA setup with
multiple CPU ports is not realizable for this SoC.

But in fact, there are 2 Ethernet ports connecting the embedded switch
and the CPU, one port is at 2.5Gbps and the other is at 1Gbps. We can
dynamically choose which one is the NPI port through device tree
(arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi), and at the moment, we
choose the 2.5Gbps port as DSA CPU port, and we disable the 1Gbps
internal port. If we wanted to, we could enable the second internal port
as an internally-facing user port, but that's a bit awkward due to
multi-homing. Nonetheless, this is all that's achievable using the NPI
port functionality.

However, due to some unrelated issues, the Felix switch has ended up
supporting two tagging protocols in fact. So there is now an option
through which the user can run this command:

  echo ocelot-8021q > /sys/class/net/eno2/dsa/tagging

(where eno2 is the DSA master)
and the switch will disable the NPI port and set up some VLAN
pushing/popping rules through which DSA gets everything it needs to
offer absolutely the same services towards the upper network stack
layer, but without enabling the hardware functionality for a CPU port
(as far as the switch hardware is aware, it is unmanaged).

This opens up some possibilities because we no longer have the
limitation that there can be only 1 NPI port in the system. As you'd
have it, I believe that any DSA switch with a fully programmable "port
forwarding matrix" (aka a bitmap which answers the question "can port i
send packets to port j?") is capable to some degree of supporting
multiple DSA CPU ports, in the statically-assigned fashion that this
patch series attempts to achieve. Namely, you just configure the port
forwarding matrix to allow user port i to flood traffic to one CPU port
but not to the other, and you disable communication between the CPU
ports.

But there is something which is even more interesting about Felix with
the ocelot-8021q tagger. Since Marek posted his RFC and until Ansuel
posted the follow-up, things have happened, and now both Felix and the
Marvell driver support LAG offload via the bonding and/or team drivers.
At least for Felix, when using the ocelot-8021q tagged, it should be
possible to put the two CPU ports in a hardware LAG, and the two DSA
masters in a software LAG, and let the bond/team upper of the DSA
masters be the CPU port.

I would like us to keep the door open for both alternatives, and to have
a way to switch between static user-to-CPU port assignment, and LAG.
I think that if there are multiple 'ethernet = ' phandles present in the
device tree, DSA should populate a list of valid DSA masters, and then
call into the driver to allow it to select which master it prefers for
each user port. This is similar to what Ansuel added with 'port_get_preferred_cpu',
except that I chose "DSA master" and not "CPU port" for a specific reason.
For LAG, the DSA master would be bond0.

In fact, in my case, this CPU port election procedure should also be
repeated when the tagging protocol changes, because Felix will be forced
to choose the same DSA master for all user ports at probe time, because
it boots up with the standard NPI-based "ocelot" tagger. So it can only
make use of the second CPU port when the tagging protocol changes.

Changing the DSA tagging protocol has to be done with the network down
(ip link set eno2 down && ip link set eno3 down). If we were to bring
eno2 and eno3 back up now, DSA or the driver would choose one of the DSA
masters for every port, round robin or what not. But we don't bring
the masters up yet, we create a bonding interface and we enslave eno2
and eno3 to it. DSA should detect this and add bond0 to its list of
candidates for a DSA master. Only now we bring up the masters, and the
port_get_preferred_cpu() function (or however it might end up being
named) should give the driver the option to select bond0 as a valid DSA
master.

Using bond0 as a DSA master would need some changes to DSA, because
currently it won't work. Namely, the RX data path needs the netdev->dsa_ptr
populated on the DSA master, whose type is a struct dsa_port *cpu_dp.
So, logically, we need a *cpu_dp corresponding to bond0.

One idea to solve this is to reuse something we already have: the
current struct dsa_switch_tree :: lags array of net devices. These hold
pointers to bonding interfaces now, but we could turn them into an array
of struct dsa_port "logical ports". The idea is that through this
change, every LAG offloaded by DSA will have a corresponding "logical
dp" which isn't present in the dst->ports list. Since every struct
dsa_port already has a lag_dev pointer, transforming the "dst->lags"
array from an array of LAG net devices into an array of logical DSA
ports will cover the existing use case as well: a logical port will
always have the dp->lag_dev pointer populated with the bonding/team
interface it offloads.

So if we make this change, we can populate bond0->dsa_ptr with this
"logical dp". This way we need to make no other changes to the RX data
path, and from the PoV of the data path itself, it isn't even a 'multi
CPU port' setup.

As for TX, that should already be fine: we call dev_queue_xmit() towards
bond0 because that's our master, and bond0 deals with xmit hashing
towards eno2 or eno3 on a per-packet basis, and that's what we want.

To destroy this setup, the user just needs to run 'ip link del bond0'
(with the link down I think) and DSA should call 'port_get_preferred_cpu'
again, but without bond0 in the list this time. The setup should revert
to its state with static assignment of user to CPU ports.

[ of course, I haven't tried any of this, I am just imagining things ]

I deliberately gave this very convoluted example because I would like
the progress that we make to be in this general direction. If I
understand your use cases, I believe they should be covered.
