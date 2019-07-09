Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFEB63DE7
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfGIWei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:34:38 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43269 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfGIWei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 18:34:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id w17so323772qto.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 15:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cUSW+0D7P3c1996ZbfgrHZh5Azm+LM3XEjRDgnW/tN8=;
        b=s9vcKGAAQhfZOEr87wJ29fvVVAM7dE92VCG03ewNfMwa1ZNvNkhrfPz2jGDue+wl2L
         xsPC+9KcVl4zwaTJPjoLurU9YSTtad2qLCKX78+RCvsGU/eVl3PFblo/p6/uqpkyJAyK
         rh9BojM2VytLhGYEjHh1zxKnDKiZUytGtmrKIi3BmjpFlbF5Gd6EsKExUQD3QlCSJPhL
         VgxfGj78+tqRLVZ4Gsj8GJq+2aYCXTQiLGAGhOPseASgfvXCw3BJeP+c2h/q1rF0JA+r
         jzt8lMdf7UQfR98ZYAZmlDumHFkurJrzUzbdmGjqpJu8hn1ImDmfTNDf46b06LlHTHX3
         3Akw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cUSW+0D7P3c1996ZbfgrHZh5Azm+LM3XEjRDgnW/tN8=;
        b=sWyGNWenYOFTFg8rlovPmU+0CyL0ZfpTq28cfAHCplKmSsgMBx6h53Wf0nsWfJBArn
         Pq3lY70fAUaqol36RJ30fH2Uq5GhnLbBUgFUm/zoMV5VCkTPLrwfnNRi/ZF0kAjJmXR1
         5JoM0KED8V1T7Tt19kfu/a+R8nIg5nS2p76fnRg10g7r/CFV0Zgn7+3aexqwkLeRri16
         Hi9rgFDzG4Uv253DzhYGQPtaPceQ7xUFRK+hSp9/wAHS/O8szVFuWm8jYY1UE8urB7pQ
         8Rrtr2E1kxMze9T2i6HOHcU0+u75rCn/nkLX88Pe88olZrNsuOss7siqo+2pb4nz8+Dz
         jAiw==
X-Gm-Message-State: APjAAAX6iV3+PV6XqyCAuzslq735P8TmxUwst9nLmVvkBpu4+pBNMuAM
        wYmeXZmWU7efc9HTO2FAlNnUAg==
X-Google-Smtp-Source: APXvYqy/0bjBAr8lNeG0QvZnuDUhQl54M1bXJrU/6r2598M0/KpwSTmu6JcxZGRFaJ9OMXXuxqimLA==
X-Received: by 2002:a0c:99e9:: with SMTP id y41mr21307541qve.186.1562711676647;
        Tue, 09 Jul 2019 15:34:36 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o71sm177853qke.18.2019.07.09.15.34.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 15:34:36 -0700 (PDT)
Date:   Tue, 9 Jul 2019 15:34:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andy@greyhouse.net, pablo@netfilter.org,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@mellanox.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: Re: [PATCH net-next 00/11] Add drop monitor for offloaded data
 paths
Message-ID: <20190709153430.5f0f5295@cakuba.netronome.com>
In-Reply-To: <20190709123844.GA27309@splinter>
References: <20190707075828.3315-1-idosch@idosch.org>
        <20190707.124541.451040901050013496.davem@davemloft.net>
        <20190708131908.GA13672@splinter>
        <20190708155158.3f75b57c@cakuba.netronome.com>
        <20190709123844.GA27309@splinter>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 9 Jul 2019 15:38:44 +0300, Ido Schimmel wrote:
> On Mon, Jul 08, 2019 at 03:51:58PM -0700, Jakub Kicinski wrote:
> > On Mon, 8 Jul 2019 16:19:08 +0300, Ido Schimmel wrote:  
> > > On Sun, Jul 07, 2019 at 12:45:41PM -0700, David Miller wrote:  
> > > > From: Ido Schimmel <idosch@idosch.org>
> > > > Date: Sun,  7 Jul 2019 10:58:17 +0300
> > > >     
> > > > > Users have several ways to debug the kernel and understand why a packet
> > > > > was dropped. For example, using "drop monitor" and "perf". Both
> > > > > utilities trace kfree_skb(), which is the function called when a packet
> > > > > is freed as part of a failure. The information provided by these tools
> > > > > is invaluable when trying to understand the cause of a packet loss.
> > > > > 
> > > > > In recent years, large portions of the kernel data path were offloaded
> > > > > to capable devices. Today, it is possible to perform L2 and L3
> > > > > forwarding in hardware, as well as tunneling (IP-in-IP and VXLAN).
> > > > > Different TC classifiers and actions are also offloaded to capable
> > > > > devices, at both ingress and egress.
> > > > > 
> > > > > However, when the data path is offloaded it is not possible to achieve
> > > > > the same level of introspection as tools such "perf" and "drop monitor"
> > > > > become irrelevant.
> > > > > 
> > > > > This patchset aims to solve this by allowing users to monitor packets
> > > > > that the underlying device decided to drop along with relevant metadata
> > > > > such as the drop reason and ingress port.    
> > > > 
> > > > We are now going to have 5 or so ways to capture packets passing through
> > > > the system, this is nonsense.
> > > > 
> > > > AF_PACKET, kfree_skb drop monitor, perf, XDP perf events, and now this
> > > > devlink thing.
> > > > 
> > > > This is insanity, too many ways to do the same thing and therefore the
> > > > worst possible user experience.
> > > > 
> > > > Pick _ONE_ method to trap packets and forward normal kfree_skb events,
> > > > XDP perf events, and these taps there too.
> > > > 
> > > > I mean really, think about it from the average user's perspective.  To
> > > > see all drops/pkts I have to attach a kfree_skb tracepoint, and not just
> > > > listen on devlink but configure a special tap thing beforehand and then
> > > > if someone is using XDP I gotta setup another perf event buffer capture
> > > > thing too.    
> > > 
> > > Let me try to explain again because I probably wasn't clear enough. The
> > > devlink-trap mechanism is not doing the same thing as other solutions.
> > > 
> > > The packets we are capturing in this patchset are packets that the
> > > kernel (the CPU) never saw up until now - they were silently dropped by
> > > the underlying device performing the packet forwarding instead of the
> > > CPU.  
> 
> Jakub,
> 
> It seems to me that most of the criticism is about consolidation of
> interfaces because you believe I'm doing something you can already do
> today, but this is not the case.

To be clear I'm not opposed to the patches, I'm just trying to
facilitate a discussion.

> Switch ASICs have dedicated traps for specific packets. Usually, these
> packets are control packets (e.g., ARP, BGP) which are required for the
> correct functioning of the control plane. You can see this in the SAI
> interface, which is an abstraction layer over vendors' SDKs:
> 
> https://github.com/opencomputeproject/SAI/blob/master/inc/saihostif.h#L157
> 
> We need to be able to configure the hardware policers of these traps and
> read their statistics to understand how many packets they dropped. We
> currently do not have a way to do any of that and we rely on hardcoded
> defaults in the driver which do not fit every use case (from
> experience):
> 
> https://elixir.bootlin.com/linux/v5.2/source/drivers/net/ethernet/mellanox/mlxsw/spectrum.c#L4103
> 
> We plan to extend devlink-trap mechanism to cover all these use cases. I
> hope you agree that this functionality belongs in devlink given it is a
> device-specific configuration and not a netdev-specific one.

No disagreement on providing knobs for traps.

> That being said, in its current form, this mechanism is focused on traps
> that correlate to packets the device decided to drop as this is very
> useful for debugging.

That'd be mixing two things - trap configuration and tracing exceptions
in one API. That's a little suboptimal but not too terrible, especially
if there is a higher level APIs users can default to.

> Given that the entire configuration is done via devlink and that devlink
> stores all the information about these traps, it seems logical to also
> report these packets and their metadata to user space as devlink events.
> 
> If this is not desirable, we can try to call into drop_monitor from
> devlink and add a new command (e.g., NET_DM_CMD_HW_ALERT), which will
> encode all the information we currently have in DEVLINK_CMD_TRAP_REPORT.
> 
> IMO, this is less desirable, as instead of having one tool (devlink) to
> interact with this mechanism we will need two (devlink & dropwatch).
> 
> Below I tried to answer all your questions and refer to all the points
> you brought up.
> 
> > When you say silently dropped do you mean that mlxsw as of today
> > doesn't have any counters exposed for those events?  
> 
> Some of these packets are counted, but not all of them.
> 
> > If we wanted to consolidate this into something existing we can either
> >  (a) add similar traps in the kernel data path;
> >  (b) make these traps extension of statistics.
> > 
> > My knee jerk reaction to seeing the patches was that it adds a new
> > place where device statistics are reported.  
> 
> Not at all. This would be a step back. We can already count discards due
> to VLAN membership on ingress on a per-port basis. A software maintained
> global counter does not buy us anything.
> 
> By also getting the dropped packet - coupled with the drop reason and
> ingress port - you can understand exactly why and on which VLAN the
> packet was dropped. I wrote a Wireshark dissector for these netlink
> packets to make our life easier. You can see the details in my comment
> to the cover letter:
> 
> https://marc.info/?l=linux-netdev&m=156248736710238&w=2
> 
> In case you do not care about individual packets, but still want more
> fine-grained statistics for your monitoring application, you can use
> eBPF. For example, one thing we did is attaching a kprobe to
> devlink_trap_report() with an eBPF program that dissects the incoming
> skbs and maintains a counter per-{5 tuple, drop reason}. With
> ebpf_exporter you can export these statistics to Prometheus on which you
> can run queries and visualize the results with Grafana. This is
> especially useful for tail and early drops since it allows you to
> understand which flows contribute to most of the drops.

No question that the mechanism is useful.

> > Users who want to know why things are dropped will not get detailed
> > breakdown from ethtool -S which for better or worse is the one stop
> > shop for device stats today.  
> 
> I hope I managed to explain why counters are not enough, but I also want
> to point out that ethtool statistics are not properly documented and
> this hinders their effectiveness. I did my best to document the exposed
> traps in order to avoid the same fate:
> 
> https://patchwork.ozlabs.org/patch/1128585/
> 
> In addition, there are selftests to show how each trap can be triggered
> to reduce the ambiguity even further:
> 
> https://patchwork.ozlabs.org/patch/1128610/
> 
> And a note in the documentation to make sure future functionality is
> tested as well:
> 
> https://patchwork.ozlabs.org/patch/1128608/
> 
> > Having thought about it some more, however, I think that having a
> > forwarding "exception" object and hanging statistics off of it is a
> > better design, even if we need to deal with some duplication to get
> > there.
> > 
> > IOW having an way to "trap all packets which would increment a
> > statistic" (option (b) above) is probably a bad design.
> > 
> > As for (a) I wonder how many of those events have a corresponding event
> > in the kernel stack?  
> 
> Generic packet drops all have a corresponding kfree_skb() calls in the
> kernel, but that does not mean that every packet dropped by the hardware
> would also be dropped by the kernel if it were to be injected to its Rx
> path.

The notion that all SW events get captured by kfree_skb() would not be
correct. We have the kfree_skb(), and xdp_exception(), and drivers can
drop packets if various allocations fail.. the situation is already not
great.

I think that having a single useful place where users can look to see
all traffic exception events would go a long way. Software side as I
mentioned is pretty brutal, IDK how many users are actually willing to
decode stack traces to figure out why their system is dropping
packets :/  

> In my reply to Dave I gave buffer drops as an example.

The example of buffer drops is also probably the case where having the
packet is least useful, but yes, I definitely agree devices need a way
of reporting events that can't happen in SW.

> There are also situations in which packets can be dropped due to
> device-specific exceptions and these do not have a corresponding drop
> reason in the kernel. See example here:
> 
> https://patchwork.ozlabs.org/patch/1128587/
> 
> > If we could add corresponding trace points and just feed those from
> > the device driver, that'd obviously be a holy grail.  
> 
> Unlike tracepoints, netlink gives you a structured and extensible
> interface. For example, in Spectrum-1 we cannot provide the Tx port for
> early/tail drops, whereas for Spectrum-2 and later we can. With netlink,
> we can just omit the DEVLINK_ATTR_TRAP_OUT_PORT attribute for
> Spectrum-1. You also get a programmatic interface that you can query for
> this information:
> 
> # devlink -v trap show netdevsim/netdevsim10 trap ingress_vlan_filter
> netdevsim/netdevsim10:
>   name ingress_vlan_filter type drop generic true report false action drop group l2_drops
>     metadata:
>        input_port

Right, you can set or not set skb fields to some extent but its
definitely not as flexible as netlink.
