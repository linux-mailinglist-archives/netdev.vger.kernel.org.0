Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD93D2B8578
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgKRUZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:25:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47714 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725794AbgKRUZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:25:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605731100;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vXycDmj0sBWENjPsDNx9Yuks+Q1CErWDvmTVjTp5ZEg=;
        b=N6DPZ3u6ml/EGlAjwbAOmDJsySpyJbodwgk66e2aZEdfcQRpyoJItNOQmAy7F99g/4GsUB
        OTOwqdf7FVSbrV94umQiGUHTvSoJpwfhvK6lhhXLXxgoL+r07mSM0xkLuWWLSuF9kebOBu
        jR5etvA6txp9AJIHalDrzp5cYK5OLig=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-OucWq-5yMDOBC9f4XtBORg-1; Wed, 18 Nov 2020 15:24:58 -0500
X-MC-Unique: OucWq-5yMDOBC9f4XtBORg-1
Received: by mail-wm1-f70.google.com with SMTP id o203so1302503wmo.3
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:24:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vXycDmj0sBWENjPsDNx9Yuks+Q1CErWDvmTVjTp5ZEg=;
        b=FQlLAXuQ4K5n+k+WZMSSkpiFrq43U1ikIN6icCutHgUENBuI+2oIBTBrM4FypW9bFv
         lcrJHwNFLMTD+Vk5rGxpUXZR45Iuc35Y3VZjQPGtugKnGQFq0TzY/vdcBt7Za57Ue3/L
         UMRnC6Z79uRsV/WtFRci3aVXdaHQ+q/XU1faD/YTIapt0u0jt77hP7E5tKBvBmBT4S5d
         ujYj8P9e8WZ6L6hZFi1bvu5JDdcY2dUuC/M8sLh73C4dQNcqZhNIFLNMao8lbZygtGTK
         6u79CKvTM51JVceB/fu7Qh4hND+jIxEl3lXsk8xpLD6+nvsfolkuZ/lxXZ8YguyKPc4n
         QSjQ==
X-Gm-Message-State: AOAM533Oydv1SPnbqA9VuknBZkTR412L32RExPG1hdmIEoEE9MtipcH0
        vJ4Ht5Xds9ju0EZShlgKHstph0ia0B1VPH+8AAA3RsJt37PqlI9ENtUPYmaqaMor7zoXYcv4cNw
        ptNYXAYifvXe00blR
X-Received: by 2002:a1c:9949:: with SMTP id b70mr859753wme.85.1605731096730;
        Wed, 18 Nov 2020 12:24:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwGcWohT9+kVQGdZ6MkxfvHsEWTkFPWhgbPFI7rpFvlEgK1VaovtVSIJcafCer+mYQu8PT75w==
X-Received: by 2002:a1c:9949:: with SMTP id b70mr859728wme.85.1605731096429;
        Wed, 18 Nov 2020 12:24:56 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id r9sm37531224wrg.59.2020.11.18.12.24.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 12:24:55 -0800 (PST)
Date:   Wed, 18 Nov 2020 21:24:53 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tom Parkin <tparkin@katalix.com>, netdev@vger.kernel.org,
        jchapman@katalix.com
Subject: Re: [RFC PATCH 0/2] add ppp_generic ioctl to bridge channels
Message-ID: <20201118202453.GB27575@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201109155237.69c2b867@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201110092834.GA30007@linux.home>
 <20201110084740.3e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201110084740.3e3418c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 08:47:40AM -0800, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 10:28:34 +0100 Guillaume Nault wrote:
> > On Mon, Nov 09, 2020 at 03:52:37PM -0800, Jakub Kicinski wrote:
> > > On Fri,  6 Nov 2020 18:16:45 +0000 Tom Parkin wrote:  
> > > > This small RFC series implements a suggestion from Guillaume Nault in
> > > > response to my previous submission to add an ac/pppoe driver to the l2tp
> > > > subsystem[1].
> > > > 
> > > > Following Guillaume's advice, this series adds an ioctl to the ppp code
> > > > to allow a ppp channel to be bridged to another.  Quoting Guillaume:
> > > > 
> > > > "It's just a matter of extending struct channel (in ppp_generic.c) with
> > > > a pointer to another channel, then testing this pointer in ppp_input().
> > > > If the pointer is NULL, use the classical path, if not, forward the PPP
> > > > frame using the ->start_xmit function of the peer channel."
> > > > 
> > > > This allows userspace to easily take PPP frames from e.g. a PPPoE
> > > > session, and forward them over a PPPoL2TP session; accomplishing the
> > > > same thing my earlier ac/pppoe driver in l2tp did but in much less code!  
> > > 
> > > I have little understanding of the ppp code, but I can't help but
> > > wonder why this special channel connection is needed? We have great
> > > many ways to redirect traffic between interfaces - bpf, tc, netfilter,
> > > is there anything ppp specific that is required here?  
> > 
> > I can see two viable ways to implement this feature. The one described
> > in this patch series is the simplest. The reason why it doesn't reuse
> > existing infrastructure is because it has to work at the link layer
> > (no netfilter) and also has to work on PPP channels (no network
> > device).
> > 
> > The alternative, is to implement a virtual network device for the
> > protocols we want to support (at least PPPoE and L2TP, maybe PPTP)
> > and teach tunnel_key about them. Then we could use iproute2 commands
> > like:
> >  # ip link add name pppoe0 up type pppoe external
> >  # ip link add name l2tp0 up type l2tp external
> >  # tc qdisc add dev pppoe0 ingress
> >  # tc qdisc add dev l2tp0 ingress
> >  # tc filter add dev pppoe0 ingress matchall                        \
> >      action tunnel_key set l2tp_version 2 l2tp_tid XXX l2tp_sid YYY \
> >      action mirred egress redirect dev pppoe0
> >  # tc filter add dev l2tp0 ingress matchall  \
> >      action tunnel_key set pppoe_sid ZZZ     \
> >      action mirred egress redirect dev l2tp0
> > 
> > Note: I've used matchall for simplicity, but a real uses case would
> > have to filter on the L2TP session and tunnel IDs and on the PPPoE
> > session ID.
> > 
> > As I said in my reply to the original thread, I like this idea, but
> > haven't thought much about the details. So there might be some road
> > blocks. Beyond modernising PPP and making it better integrated into the
> > stack, that should also bring the possibility of hardware offload (but
> > would any NIC vendor be interested?).
> 
> Integrating with the stack gives you access to all its features, other
> types of encap, firewalling, bpf, etc.
> 
> > I think the question is more about long term maintainance. Do we want
> > to keep PPP related module self contained, with low maintainance code
> > (the current proposal)? Or are we willing to modernise the
> > infrastructure, add support and maintain PPP features in other modules
> > like flower, tunnel_key, etc.?
> 
> Right, it's really not great to see new IOCTLs being added to drivers,
> but the alternative would require easily 50 times more code.
>  
> > Of course, I might have missed other ways to implement this feature.
> > But that's all I could think of for now.
> > 
> > And if anyone wants a quick recap about PPP (what are these PPP channel
> > and unit things? what's the relationship between PPPoE, L2TP and PPP?
> > etc.), just let me know.
> 
> Some pointers would be appreciated if you don't mind :)

Here's a high level view of:
  * the protocol,
  * the kernel implementation,
  * the context of this RFC,
  * and a few pointers at the end :)

Hope this helps. I've tried to keep it short. Feel free to ask for
clarifications and details.


The Point-to-Point Protocol
===========================

PPP is a layer 2 protocol. The header is a single field that identifies
the upper protocol (just like an Ethertype). PPP is point-to-point, so
there's no need for source and destination link layer addresses in the
header: whatever is sent on one end of the pipe is received by the host
on the other end, it's that simple (no shared medium, no switching).
Some protocols have been defined to tunnel PPP packets (PPPoE, L2TP).

PPP doesn't just define how to handle data frames, it also has control
protocols. The Link Control Protocol (LCP) is used to negotiate
link-layer parameters (maximum packet size, optionally request the peer
to authenticate, etc.). LCP is part of the PPP specification. All other
control protocols are defined in different RFCs, but they use the same
protocol structure as LCP.

Once both peers agree on the link parameters, they can proceed to the
optional authentication phase (if that was negotiated during the LCP
phase). There are several authentication protocols available; the one
to use is selected during the LCP phase.

Finally, the peers can negotiate whatever network protocol they want to
use: with PPP, all network protocols need to have an equivalent NCP
(Network Control Protocol). For example, IPv4 has IPCP, IPv6 has IPv6CP,
MPLS has MPLSCP, etc. In some cases, the NCP is used to negotiate
network specific parameters. For example IPCP allows each peer to
advertise its IPv4 address or to request an address from the remote
peer. NCPs are generally very simple. Some don't even have any
parameter to negotiate (like MPLSCP).

Once an NCP has been negotiated, the peers can exchange data packets of
that protocol. Of course several network protocols can be used
simultaneously.

PPP can run over physical links or be tunnelled into other protocols.
For example, PPPoE carries PPP over Ethernet and L2TP tunnels PPP into
UDP.

Kernel Implementation
=====================

The Linux kernel implementation exposes a /dev/ppp virtual file that's
used by user space to implement the control and authentication
protocols.

Typically, user space starts by opening /dev/ppp. By calling the
PPPIOCATTCHAN ioctl, it attaches the file descriptor to a lower layer
that implements the rx and tx handlers. The lower layer may be a serial
link, an L2TP or PPPoE session, etc. We don't have a networking device
yet, but the file descriptor can now receive and send data over the
link, which is enough to implement LCP and authentication protocols.
This is what ppp_generic.c calls a PPP channel.

Then, to create a network device, one needs to open another file
descriptor on /dev/ppp and call the PPPIOCNEWUNIT ioctl. Alternatively,
it's possible to use a netlink call instead of PPPIOCNEWUNIT to create
the netdevice and attach it to the new file descriptor. We now have
what ppp_generic.c calls a PPP unit.

The unit currently doesn't know how to send data on the wire, so one
needs to connect it to the channel. This is done by another ioctl:
PPPIOCCONNECT. Now, the PPP networking device is able to send data
packets on the wire, and the unit file descriptor can be used to
implement the network control protocols.

The reason for having channels and units is PPP multilink: one can
connect several channels to a given unit. In this case, the unit
will use all channels when sending packets. That's the PPP way to
do link aggregation.

Overlays
========

It's possible to encapsulate PPP into other protocols. For example,
the Linux kernel supports PPTP, L2TP and PPPoE. PPTP is (was?) often
used for VPNs. PPPoE and L2TP are typically used by ISPs to provide
DSL connections. The kernel implementation of these protocols provides
the lower layer necessary for PPP channels to send and receive data.

There's an ISP use case that isn't covered by the current
implementation though: "bridging" a PPPoE and an L2TP session together
(or two L2TP sessions together). This is used to stretch a PPP
connection across an IP network (essentially simulating circuit
switching on top of IP).

Tom's RFC addresses this use case, by adding a new ioctl to bridge two
channels together (each channel can run on a different lower layer
technology). Units aren't necessary in this use case, because only
the LCP and authentication protocols need to run on the hosts that do
only bridging: once the authentication succeeds, every packet received
on one channel is forwarded over the other channel. NCPs are still
negotiated end to end.

The other solution envisioned in this thread (virtual L2TP and PPPoE
devices in collect_md mode) wouldn't use ppp_generic.c at all:
act_mirred would directly redirect the PPP packets between the virtual
PPPoE or L2TP devices. I don't have any code for this approach though.

Pointers
========

  * Documentation/networking/ppp_generic.rst:
      Documentation for the kernel implementation (including the ioctls).

  * drivers/net/ppp/*:
      Kernel implementation of PPP, PPPoE, PPTP...

  * net/l2tp/*:
      Kernel implementation of L2TP (v2 and v3). The PPP-specific part
      is in l2tp_ppp.c.

  * RFC 1661:
      The PPP specification, including LCP (IPCP is in RFC 1332, IPv6CP
      in RFC 5072, MPLSCP in RFC 3032 section 4).

  * RFC 1990:
      The PPP multilink specification.

  * RFC 2516:
      The PPPoE specification.

  * RFC 2637:
      The PPTP specification.

  * RFC 2661:
    The L2TPv2 specification (L2TPv3, defined in RFC 3931, was defined
    later as a generalisation of L2TPv2 that could transport more than
    just PPP).

