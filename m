Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E322F94E7
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 20:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730188AbhAQTca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 14:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730175AbhAQTbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 14:31:06 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F04C061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 11:30:13 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id r12so9360852ejb.9
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 11:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dcLyz+GWZuNVr9WfWedIIgcVFUehLL+7Ps5PE0VNe9Y=;
        b=HKi5pc1T5E+808Rk2X7168laXsy9Wono2yg6uGwqoU5xt0VBgUdR5yR8y/PfmTjC8U
         vVpdC50S+t+YHDz+HLVxULd+B6a45Xm5WGWF9GbnB4dst+v2iBYZvgZ/+Go3e9HREq7b
         q1AuB0rVy/7tcTQPOoBduBLgCZ6YFruVMv2VASBt5xAFydTDfdo9uJ5boFmpxPEwJjWi
         AMeHJfNBpaQ7A1hk6dB1/GXgKEJVL9CqpIAK2vPmz9e4oPRGPXNgQXdRdwicjYEntul5
         bCTqDola3LPu91IllllVsJ1YymvY2AzOWk7cSRrf1fTqpnje8hgcr+gjMYDjcssBF3jE
         2yiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dcLyz+GWZuNVr9WfWedIIgcVFUehLL+7Ps5PE0VNe9Y=;
        b=WisUsLWHZKKS7pdAxb8VjP+AUrDWGVkgdF7f+9sGZhhfozH+riofNcLYsqlYL8L14j
         1+Ep3wsfWsWnczsBaVCP0TGYlM27Ie8Ek9vNvHxa5+N8xWDL5uQF5jzZGyMW+fhIJJ62
         Ma4sK26ePxYXfxyJWY73RL8lSnYcb5X+fVVcPL8u2ytw5nt52AL1F8S4R9zfiTYeSLDN
         sEfgoyjGyHVdk2Q5Qj6FDiS7Dw4jX2uOEkhmdI9aT8s8CDJxwprUHh9CRdnY+kZvHIaE
         XxruJoSKkBA9E7WgBQXhLk7qk623RU3QbSr9j3Ta5lrAqsgLXBsLYC7dPSwyhHZ6a88C
         LB1A==
X-Gm-Message-State: AOAM533XHst7vnKOStDbN102Jjk4qZxnf04rrHICjdRWm7rxgSr1cP+j
        yVxptSHKfo6uSgHX1Dil5kM=
X-Google-Smtp-Source: ABdhPJzc832KoOFD9zqcAFPbEfwmGcBMAoY8YhSV8Wm0OWLdYva9360S8q7paICO7W4ftvJuAVWsbg==
X-Received: by 2002:a17:906:1741:: with SMTP id d1mr15807845eje.182.1610911811837;
        Sun, 17 Jan 2021 11:30:11 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id o11sm3177226eds.19.2021.01.17.11.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 11:30:11 -0800 (PST)
Date:   Sun, 17 Jan 2021 21:30:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, netdev@vger.kernel.org, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in
 FDB notifications
Message-ID: <20210117193009.io3nungdwuzmo5f7@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com>
 <20210116012515.3152-3-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210116012515.3152-3-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tobias,

On Sat, Jan 16, 2021 at 02:25:10AM +0100, Tobias Waldekranz wrote:
> Some switchdev drivers, notably DSA, ignore all dynamically learned
> address notifications (!added_by_user) as these are autonomously added
> by the switch. Previously, such a notification was indistinguishable
> from a local address notification. Include a local bit in the
> notification so that the two classes can be discriminated.
>
> This allows DSA-like devices to add local addresses to the hardware
> FDB (with the CPU as the destination), thereby avoiding flows towards
> the CPU being flooded by the switch as unknown unicast.
>
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---

In an ideal world, the BR_FDB_LOCAL bit of an FDB entry is what you
would probably want to use as an indication that the packet must be
delivered upstream by the hardware, considering that this is what the
software data path does:

br_handle_frame_finish:
		if (test_bit(BR_FDB_LOCAL, &dst->flags))
			return br_pass_frame_up(skb);

However, we are not in an ideal world, but in a cacophony of nonsensical
flags that must be passed to the 'bridge fdb add' command. For example,
I noticed this usage pattern in your patch 6/7:

|    br0
|    / \
| swp0 dummy0
|
| $ bridge fdb add 02:00:de:ad:00:01 dev dummy0 vlan 1 master

Do you know that this command doesn't do what you think it does
(assuming that 02:00:de:ad:00:01 is not the MAC address of dummy0)?

The command you wrote will add a _local_ FDB entry on dummy0.
I tried it on a DSA switch interface (swp0):

$ bridge fdb add 02:00:de:ad:00:01 dev swp0 vlan 1 master
[ 3162.165561] rtnl_fdb_add: addr 02:00:de:ad:00:01 vid 1 ndm_state NUD_NOARP|NUD_PERMANENT
[ 3162.172487] fdb_add_entry: fdb 02:00:de:ad:00:01 state NUD_NOARP|NUD_PERMANENT, fdb_to_nud NUD_REACHABLE, flags 0x0
[ 3162.180515] mscc_felix 0000:00:00.5 swp0: local fdb: 02:00:de:ad:00:01 vid 1

So, after your patches, this command syntax will stop adding a
front-facing FDB entry on swp0. It will add a CPU-facing FDB entry
instead.

You know why the bridge neighbour state is NUD_NOARP|NUD_PERMANENT in
rtnl_fdb_add? Well, because iproute2 set it that way:

	/* Assume permanent */
	if (!(req.ndm.ndm_state&(NUD_PERMANENT|NUD_REACHABLE)))
		req.ndm.ndm_state |= NUD_PERMANENT;

See iproute2 commit 0849e60a10d0 ("bridge: manage VXLAN based forwarding
tables"). I know so little about VXLAN's use of the bridge command, that
I cannot tell why it was decided to "assume permanent" (which seems to
have changed the default behavior for everybody).

Otherwise said, even if not mentioned in the man page, the default FDB
entry type is NUD_PERMANENT (which, in short, means a "local" entry, see
a more detailed explanation at the end).

The man page just says:

   bridge fdb add - add a new fdb entry
       This command creates a new fdb entry.

       LLADDR the Ethernet MAC address.

       dev DEV
              the interface to which this address is associated.

              local - is a local permanent fdb entry

              static - is a static (no arp) fdb entry

which is utterly misleading and useless. It does not say:
(a) what a local FDB entry is
(b) that if neither "local" or "static"|"dynamic" is specified,
    "local" is default

This already creates pretty bad premises. You would have needed to
explicitly add "static" to your command. Not only you, but in fact also
thousands of other people who already have switchdev deployments using
the 'bridge fdb' command.

So, in short, if everybody with switchdev hardware used the 'bridge fdb'
command correctly so far, your series would have been great. But in
fact, nobody did (me included). So we need to be more creative.

For example, there's that annoying "self" flag.
As far as I understand, there is zero reason for a DSA driver to use the
"self" flag, since that means "bypass the bridge FDB and just call the
.ndo_fdb_add of the device driver, which in the case of DSA is
dsa_legacy_fdb_add". Instead you would just use the "master" flag, which
makes the operation be propagated through br_fdb_add and the software
FDB has a chance to be updated.

Only that there's no one preventing you from using the 'self' and
'master' flags together. Which means that the FDB would be offloaded to
the device twice: once through the SWITCHDEV_FDB_ADD_TO_DEVICE
notification emitted by br_fdb_add, and once through dsa_legacy_fdb_add.
Contradict me if I'm wrong, but I'm thinking that you may have missed
this detail that bridge fdb addresses are implicitly 'local' because you
also used some 'self master' commands, and the "to-CPU" address
installed through switchdev was immediately overwritten by the correct
one installed through dsa_legacy_fdb_add.

So I think there is a very real issue in that the FDB entries with the
is_local bit was never specified to switchdev thus far, and now suddenly
is. I'm sorry, but what you're saying in the commit message, that
"!added_by_user has so far been indistinguishable from is_local" is
simply false.

What I'm saying is that some of the is_local addresses should have been
rejected by DSA from day one, like this one:

bridge fdb add dev swp0 00:01:02:03:04:05 master

but nonetheless DSA is happy to accept it anyway, because switchdev
doesn't tell it it's local. Yay.

It looks like Mellanox have been telling their users to explicitly use
the "static" keyword when they mean a static FDB entry:
https://github.com/Mellanox/mlxsw/wiki/Bridge#forwarding-database-configuration
which, I mean, is great for them, but pretty much sucks for everybody
else, because Documentation/networking/switchdev.rst just says:

The switchdev driver should implement ndo_fdb_add, ndo_fdb_del and ndo_fdb_dump
to support static FDB entries installed to the device.  Static bridge FDB
entries are installed, for example, using iproute2 bridge cmd::

	bridge fdb add ADDR dev DEV [vlan VID] [self]

which of course is completely bogus anyway (it indicates 'self', it
doesn't indicate 'master' at all, it doesn't say anything about 'static').

Look, I'd be more than happy to accept that I'm the only idiot who
misread the existing documentation on 'bridge fdb', but I fear that this
is far from true. If we want to make progress with this patch, some user
space breakage will be necessary - and I think I'm in favour of doing
that.


Appendix:

The bridge FDB netlink UAPI is modeled as a neighbouring protocol for
PF_BRIDGE, similar to what ARP is for IPv4 and ND is for IPv6. There is
this forced correlation between generic neighbour states (NUD ==
"Network Unreachability Detection") and types of FDB entries:
- NUD_NOARP:
Normally this state is used to denote a neighbour that doesn't need any
protocol to resolve the mapping between L3 address and L2 address.
It seems to be mostly used when the neigh->dev does not implement
header_ops (net device has no L2 header), and therefore no neighbor
resolution is needed, because there is no L2 addressing on that device.
For PF_BRIDGE, all FDB entries are NUD_NOARP, except for 'dynamic' ones
(see below).

- NUD_PERMANENT:
Normally this state means that the L2 address of the neighbor has been
statically configured by the user and therefore there is no need for a
neighbour resolution.
For PF_BRIDGE though, it means that an FDB entry is 'local', i.e. the L2
address belongs to a local interface.

- NUD_REACHABLE:
Normally this state means that the L2 address has been resolved by the
neighbouring protocol.
For PF_BRIDGE, this flag must be interpreted together with NUD_NOARP for
full meaning.
NUD_REACHABLE=true, NUD_NOARP=true: static FDB entry
NUD_REACHABLE=true, NUD_NOARP=false: dynamic FDB entry
