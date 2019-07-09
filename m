Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934906360C
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 14:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfGIMit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 08:38:49 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:39883 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbfGIMit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 08:38:49 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7671F208B;
        Tue,  9 Jul 2019 08:38:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 09 Jul 2019 08:38:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zlSnyT
        2gdCvBIytRrslBmeKEo2epBkiOPmNwpBcyZ3Q=; b=Q6icD2DRWLS7Hm+2BVE0ek
        DRPxoZHgRHvHVgzh9r9vVuYzzSFAF3rHdN0CF+Hiiid+VAb3C2MVlVBeH3/afLGY
        gKUBisq0keBNt4Us+UMQuLQUdEEA3zsoKorsP4X3YGu/Rn2LZ1Qx7pWuDF6v5eOY
        wa38B++nRwn+XziV9S9AL9AIHiiXCmziawLvrnwM5YTfJ6xKKX/s8Fmn2clzdjSt
        /KqTyb5IcyiPtKau6mbgF2ngLppQbwa1HElsyBJPseRGeF642amUi89XaXnH/Hd7
        q0EqVsKViYJz1+jprNXILTzWY4USZJqtfgd2Bs6aFi6aDo7rn9VKn02jtq/BvB3Q
        ==
X-ME-Sender: <xms:1ookXUtNx0n6V8m75criBtcYFDjwFjmOYYbWGNA-sznn7z8eHXQLFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrgedvgdehjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucffohhmrghinh
    epsghoohhtlhhinhdrtghomhdpghhithhhuhgsrdgtohhmpdhmrghrtgdrihhnfhhopdho
    iihlrggsshdrohhrghenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgv
    rhfuihiivgeptd
X-ME-Proxy: <xmx:1ookXcmt20u1qInUuolfmMaWsOr7MtOHqDk-0Y7GFskLVYBIi8gAFw>
    <xmx:1ookXfLY0IJNPlPDZxqAUYhYHColmZyEyuMUq1a-snd0DhlFAFzZGw>
    <xmx:1ookXWe5fyenpbBFcGDUS9U1-YMN-Y3qu_sEJPDsWYOuxhIn7HJiFw>
    <xmx:14okXV8Edil8bU6DngdN_Mu47pH2c1bK-Uv38z1YiCH4Qp-_2t3ZqA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1DA1A80060;
        Tue,  9 Jul 2019 08:38:45 -0400 (EDT)
Date:   Tue, 9 Jul 2019 15:38:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@mellanox.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data paths
Message-ID: <20190709123844.GA27309@splinter>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707.124541.451040901050013496.davem@davemloft.net>
 <20190708131908.GA13672@splinter>
 <20190708155158.3f75b57c@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708155158.3f75b57c@cakuba.netronome.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 08, 2019 at 03:51:58PM -0700, Jakub Kicinski wrote:
> On Mon, 8 Jul 2019 16:19:08 +0300, Ido Schimmel wrote:
> > On Sun, Jul 07, 2019 at 12:45:41PM -0700, David Miller wrote:
> > > From: Ido Schimmel <idosch@idosch.org>
> > > Date: Sun,  7 Jul 2019 10:58:17 +0300
> > >   
> > > > Users have several ways to debug the kernel and understand why a packet
> > > > was dropped. For example, using "drop monitor" and "perf". Both
> > > > utilities trace kfree_skb(), which is the function called when a packet
> > > > is freed as part of a failure. The information provided by these tools
> > > > is invaluable when trying to understand the cause of a packet loss.
> > > > 
> > > > In recent years, large portions of the kernel data path were offloaded
> > > > to capable devices. Today, it is possible to perform L2 and L3
> > > > forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
> > > > Different TC classifiers and actions are also offloaded to capable
> > > > devices, at both ingress and egress.
> > > > 
> > > > However, when the data path is offloaded it is not possible to achieve
> > > > the same level of introspection as tools such "perf" and "drop monitor"
> > > > become irrelevant.
> > > > 
> > > > This patchset aims to solve this by allowing users to monitor packets
> > > > that the underlying device decided to drop along with relevant metadata
> > > > such as the drop reason and ingress port.  
> > > 
> > > We are now going to have 5 or so ways to capture packets passing through
> > > the system, this is nonsense.
> > > 
> > > AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
> > > devlink thing.
> > > 
> > > This is insanity, too many ways to do the same thing and therefore the
> > > worst possible user experience.
> > > 
> > > Pick _ONE_ method to trap packets and forward normal kfree_skb events,
> > > XDP perf events, and these taps there too.
> > > 
> > > I mean really, think about it from the average user's perspective.  To
> > > see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
> > > listen on devlink but configure a special tap thing beforehand and then
> > > if someone is using XDP I gotta setup another perf event buffer capture
> > > thing too.  
> > 
> > Let me try to explain again because I probably wasn't clear enough. The
> > devlink-trap mechanism is not doing the same thing as other solutions.
> > 
> > The packets we are capturing in this patchset are packets that the
> > kernel (the CPU) never saw up until now - they were silently dropped by
> > the underlying device performing the packet forwarding instead of the
> > CPU.

Jakub,

It seems to me that most of the criticism is about consolidation of
interfaces because you believe I'm doing something you can already do
today, but this is not the case.

Switch ASICs have dedicated traps for specific packets. Usually, these
packets are control packets (e.g., ARP, BGP) which are required for the
correct functioning of the control plane. You can see this in the SAI
interface, which is an abstraction layer over vendors' SDKs:

https://github.com/opencomputeproject/SAI/blob/master/inc/saihostif.h#L157

We need to be able to configure the hardware policers of these traps and
read their statistics to understand how many packets they dropped. We
currently do not have a way to do any of that and we rely on hardcoded
defaults in the driver which do not fit every use case (from
experience):

https://elixir.bootlin.com/linux/v5.2/source/drivers/net/ethernet/mellanox/mlxsw/spectrum.c#L4103

We plan to extend devlink-trap mechanism to cover all these use cases. I
hope you agree that this functionality belongs in devlink given it is a
device-specific configuration and not a netdev-specific one.

That being said, in its current form, this mechanism is focused on traps
that correlate to packets the device decided to drop as this is very
useful for debugging.

Given that the entire configuration is done via devlink and that devlink
stores all the information about these traps, it seems logical to also
report these packets and their metadata to user space as devlink events.

If this is not desirable, we can try to call into drop_monitor from
devlink and add a new command (e.g., NET_DM_CMD_HW_ALERT), which will
encode all the information we currently have in DEVLINK_CMD_TRAP_REPORT.

IMO, this is less desirable, as instead of having one tool (devlink) to
interact with this mechanism we will need two (devlink & dropwatch).

Below I tried to answer all your questions and refer to all the points
you brought up.

> When you say silently dropped do you mean that mlxsw as of today
> doesn't have any counters exposed for those events?

Some of these packets are counted, but not all of them.

> If we wanted to consolidate this into something existing we can either
>  (a) add similar traps in the kernel data path;
>  (b) make these traps extension of statistics.
> 
> My knee jerk reaction to seeing the patches was that it adds a new
> place where device statistics are reported.

Not at all. This would be a step back. We can already count discards due
to VLAN membership on ingress on a per-port basis. A software maintained
global counter does not buy us anything.

By also getting the dropped packet - coupled with the drop reason and
ingress port - you can understand exactly why and on which VLAN the
packet was dropped. I wrote a Wireshark dissector for these netlink
packets to make our life easier. You can see the details in my comment
to the cover letter:

https://marc.info/?l=linux-netdev&m=156248736710238&w=2

In case you do not care about individual packets, but still want more
fine-grained statistics for your monitoring application, you can use
eBPF. For example, one thing we did is attaching a kprobe to
devlink_trap_report() with an eBPF program that dissects the incoming
skbs and maintains a counter per-{5 tuple, drop reason}. With
ebpf_exporter you can export these statistics to Prometheus on which you
can run queries and visualize the results with Grafana. This is
especially useful for tail and early drops since it allows you to
understand which flows contribute to most of the drops.

> Users who want to know why things are dropped will not get detailed
> breakdown from ethtool -S which for better or worse is the one stop
> shop for device stats today.

I hope I managed to explain why counters are not enough, but I also want
to point out that ethtool statistics are not properly documented and
this hinders their effectiveness. I did my best to document the exposed
traps in order to avoid the same fate:

https://patchwork.ozlabs.org/patch/1128585/

In addition, there are selftests to show how each trap can be triggered
to reduce the ambiguity even further:

https://patchwork.ozlabs.org/patch/1128610/

And a note in the documentation to make sure future functionality is
tested as well:

https://patchwork.ozlabs.org/patch/1128608/

> Having thought about it some more, however, I think that having a
> forwarding "exception" object and hanging statistics off of it is a
> better design, even if we need to deal with some duplication to get
> there.
> 
> IOW having an way to "trap all packets which would increment a
> statistic" (option (b) above) is probably a bad design.
> 
> As for (a) I wonder how many of those events have a corresponding event
> in the kernel stack?

Generic packet drops all have a corresponding kfree_skb() calls in the
kernel, but that does not mean that every packet dropped by the hardware
would also be dropped by the kernel if it were to be injected to its Rx
path. In my reply to Dave I gave buffer drops as an example.

There are also situations in which packets can be dropped due to
device-specific exceptions and these do not have a corresponding drop
reason in the kernel. See example here:

https://patchwork.ozlabs.org/patch/1128587/

> If we could add corresponding trace points and just feed those from
> the device driver, that'd obviously be a holy grail.

Unlike tracepoints, netlink gives you a structured and extensible
interface. For example, in Spectrum-1 we cannot provide the Tx port for
early/tail drops, whereas for Spectrum-2 and later we can. With netlink,
we can just omit the DEVLINK_ATTR_TRAP_OUT_PORT attribute for
Spectrum-1. You also get a programmatic interface that you can query for
this information:

# devlink -v trap show netdevsim/netdevsim10 trap ingress_vlan_filter
netdevsim/netdevsim10:
  name ingress_vlan_filter type drop generic true report false action drop group l2_drops
    metadata:
       input_port

Thanks
