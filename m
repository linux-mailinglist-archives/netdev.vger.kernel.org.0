Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB6D2FA980
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 20:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407933AbhARTAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 14:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407939AbhARS7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:59:44 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF40BC061573
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:59:02 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id f11so19327466ljm.8
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 10:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=l6FC8u4PDDL17G2dp/X/8mL9VnL0qcXyJeGOVdlL6eM=;
        b=r9TWP7mCwnG2kueOHL6sk07v8/+S9m6n9OhToKAzJPHnJ4SLRTuZEqU2IhUPSZ4u+P
         mlBArBMv87EoezYljiJjW5mFqZiasi1dUe2RTM2scGbaGJ0IhENWjwD7iLppehRnQ5j8
         x3+juh+kQQyCCV1eGZmS0yPpIh8/6FImt/l1c7/ZF1F7kqX8s2rLoP6uweHCnLEu3LiH
         61EwXI6iPSzJDpMz+sbGgkTfNNq+GjRTK+2f7UVQvrJ+kw/MP9bbMSCFDNJjDHRxggBP
         oK3gIWcKQjzimV2nSEal0tJrI4Sm8E0C1mHNCjScobKOaoBJ9eKTFhqIq60+83a+6GRN
         /fmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=l6FC8u4PDDL17G2dp/X/8mL9VnL0qcXyJeGOVdlL6eM=;
        b=ZL10wHoHf7gtQwwhzdyTIG/1ETyVwjkm/EyInfRRU4cf2sn82BeAVQtxR8hWmnzKvP
         NXfNPmSEHrxR6DzOg42X4e5zstiAXaF5MwiaWtc3BZNRsg47F7SpzfikThFdeDtWzl2+
         o+p32y/dtZwNuvsNRPqxz9LsOamIYRQchSoDJ6yaT5rV7CQIFNc2MHAi2OrrYwBAlwkP
         W3y5Rxal8ZDAlRw4Yl+HhiC3dMNKMXz0zYQWl25IEWZ6wltKkaC8uIsusKmQ1/sYlhqL
         UwpLpUCuXV0lxJtCf/yiMIx231dCCABgZQbwxb6N9Axj3kpU3AqkItVTXBoyIcHcLGsX
         CBUw==
X-Gm-Message-State: AOAM533z4t5W+0L/R+wCWpBmTCyhgo6qMXkSpMb5Gc1tYi4o7BPF75N2
        FAmBb49Ux3vOcUTselkLQAUBUg==
X-Google-Smtp-Source: ABdhPJyltCMZ+NOUyc0Zww553henFgqZo3ywv7vS3g4wHQ+xemcshTAdtIz6y3e03RCKKs4z1oMLCQ==
X-Received: by 2002:a2e:2417:: with SMTP id k23mr397849ljk.373.1610996341317;
        Mon, 18 Jan 2021 10:59:01 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id 29sm1990190lfr.304.2021.01.18.10.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 10:59:00 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, netdev@vger.kernel.org, jiri@resnulli.us,
        idosch@idosch.org, stephen@networkplumber.org
Subject: Re: [RFC net-next 2/7] net: bridge: switchdev: Include local flag in FDB notifications
In-Reply-To: <20210117193009.io3nungdwuzmo5f7@skbuf>
References: <20210116012515.3152-1-tobias@waldekranz.com> <20210116012515.3152-3-tobias@waldekranz.com> <20210117193009.io3nungdwuzmo5f7@skbuf>
Date:   Mon, 18 Jan 2021 19:58:59 +0100
Message-ID: <87turejclo.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 21:30, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Tobias,
>
> On Sat, Jan 16, 2021 at 02:25:10AM +0100, Tobias Waldekranz wrote:
>> Some switchdev drivers, notably DSA, ignore all dynamically learned
>> address notifications (!added_by_user) as these are autonomously added
>> by the switch. Previously, such a notification was indistinguishable
>> from a local address notification. Include a local bit in the
>> notification so that the two classes can be discriminated.
>>
>> This allows DSA-like devices to add local addresses to the hardware
>> FDB (with the CPU as the destination), thereby avoiding flows towards
>> the CPU being flooded by the switch as unknown unicast.
>>
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>
> In an ideal world, the BR_FDB_LOCAL bit of an FDB entry is what you
> would probably want to use as an indication that the packet must be
> delivered upstream by the hardware, considering that this is what the
> software data path does:
>
> br_handle_frame_finish:
> 		if (test_bit(BR_FDB_LOCAL, &dst->flags))
> 			return br_pass_frame_up(skb);

That was my thinking, yes.

> However, we are not in an ideal world, but in a cacophony of nonsensical
> flags that must be passed to the 'bridge fdb add' command. For example,
> I noticed this usage pattern in your patch 6/7:
>
> |    br0
> |    / \
> | swp0 dummy0
> |
> | $ bridge fdb add 02:00:de:ad:00:01 dev dummy0 vlan 1 master
>
> Do you know that this command doesn't do what you think it does
> (assuming that 02:00:de:ad:00:01 is not the MAC address of dummy0)?
>
> The command you wrote will add a _local_ FDB entry on dummy0.
> I tried it on a DSA switch interface (swp0):
>
> $ bridge fdb add 02:00:de:ad:00:01 dev swp0 vlan 1 master
> [ 3162.165561] rtnl_fdb_add: addr 02:00:de:ad:00:01 vid 1 ndm_state NUD_NOARP|NUD_PERMANENT
> [ 3162.172487] fdb_add_entry: fdb 02:00:de:ad:00:01 state NUD_NOARP|NUD_PERMANENT, fdb_to_nud NUD_REACHABLE, flags 0x0
> [ 3162.180515] mscc_felix 0000:00:00.5 swp0: local fdb: 02:00:de:ad:00:01 vid 1
>
> So, after your patches, this command syntax will stop adding a
> front-facing FDB entry on swp0. It will add a CPU-facing FDB entry
> instead.

Ah I see, no I was not aware of that. I just saw that the entry towards
the CPU was added to the ATU, which it would in both cases. I.e. from
the switch's POV, in this setup:

   br0
   / \ (A)
swp0 dummy0
       (B)

A "local" entry like (A), or a "static" entry like (B) means the same
thing to the switch: "it is somewhere behind my CPU-port".

> You know why the bridge neighbour state is NUD_NOARP|NUD_PERMANENT in
> rtnl_fdb_add? Well, because iproute2 set it that way:
>
> 	/* Assume permanent */
> 	if (!(req.ndm.ndm_state&(NUD_PERMANENT|NUD_REACHABLE)))
> 		req.ndm.ndm_state |= NUD_PERMANENT;
>
> See iproute2 commit 0849e60a10d0 ("bridge: manage VXLAN based forwarding
> tables"). I know so little about VXLAN's use of the bridge command, that
> I cannot tell why it was decided to "assume permanent" (which seems to
> have changed the default behavior for everybody).
>
> Otherwise said, even if not mentioned in the man page, the default FDB
> entry type is NUD_PERMANENT (which, in short, means a "local" entry, see
> a more detailed explanation at the end).
>
> The man page just says:
>
>    bridge fdb add - add a new fdb entry
>        This command creates a new fdb entry.
>
>        LLADDR the Ethernet MAC address.
>
>        dev DEV
>               the interface to which this address is associated.
>
>               local - is a local permanent fdb entry
>
>               static - is a static (no arp) fdb entry
>
> which is utterly misleading and useless. It does not say:
> (a) what a local FDB entry is
> (b) that if neither "local" or "static"|"dynamic" is specified,
>     "local" is default
>
> This already creates pretty bad premises. You would have needed to
> explicitly add "static" to your command. Not only you, but in fact also
> thousands of other people who already have switchdev deployments using
> the 'bridge fdb' command.
>
> So, in short, if everybody with switchdev hardware used the 'bridge fdb'
> command correctly so far, your series would have been great. But in
> fact, nobody did (me included). So we need to be more creative.
>
> For example, there's that annoying "self" flag.
> As far as I understand, there is zero reason for a DSA driver to use the
> "self" flag, since that means "bypass the bridge FDB and just call the
> .ndo_fdb_add of the device driver, which in the case of DSA is
> dsa_legacy_fdb_add". Instead you would just use the "master" flag, which
> makes the operation be propagated through br_fdb_add and the software
> FDB has a chance to be updated.
>
> Only that there's no one preventing you from using the 'self' and
> 'master' flags together. Which means that the FDB would be offloaded to
> the device twice: once through the SWITCHDEV_FDB_ADD_TO_DEVICE
> notification emitted by br_fdb_add, and once through dsa_legacy_fdb_add.
> Contradict me if I'm wrong, but I'm thinking that you may have missed
> this detail that bridge fdb addresses are implicitly 'local' because you
> also used some 'self master' commands, and the "to-CPU" address
> installed through switchdev was immediately overwritten by the correct
> one installed through dsa_legacy_fdb_add.
>
> So I think there is a very real issue in that the FDB entries with the
> is_local bit was never specified to switchdev thus far, and now suddenly
> is. I'm sorry, but what you're saying in the commit message, that
> "!added_by_user has so far been indistinguishable from is_local" is
> simply false.

Alright, so how do you do it? Here is the struct:

    struct switchdev_notifier_fdb_info {
	struct switchdev_notifier_info info; /* must be first */
	const unsigned char *addr;
	u16 vid;
	u8 added_by_user:1,
	   offloaded:1;
    };


Which field separates a local address on swp0 from a dynamically learned
address on swp0?

> What I'm saying is that some of the is_local addresses should have been
> rejected by DSA from day one, like this one:
>
> bridge fdb add dev swp0 00:01:02:03:04:05 master
>
> but nonetheless DSA is happy to accept it anyway, because switchdev
> doesn't tell it it's local. Yay.

Yes that is a real problem, for sure.

> It looks like Mellanox have been telling their users to explicitly use
> the "static" keyword when they mean a static FDB entry:
> https://github.com/Mellanox/mlxsw/wiki/Bridge#forwarding-database-configuration
> which, I mean, is great for them, but pretty much sucks for everybody
> else, because Documentation/networking/switchdev.rst just says:
>
> The switchdev driver should implement ndo_fdb_add, ndo_fdb_del and ndo_fdb_dump
> to support static FDB entries installed to the device.  Static bridge FDB
> entries are installed, for example, using iproute2 bridge cmd::
>
> 	bridge fdb add ADDR dev DEV [vlan VID] [self]
>
> which of course is completely bogus anyway (it indicates 'self', it
> doesn't indicate 'master' at all, it doesn't say anything about 'static').
>
> Look, I'd be more than happy to accept that I'm the only idiot who
> misread the existing documentation on 'bridge fdb', but I fear that this
> is far from true. If we want to make progress with this patch, some user
> space breakage will be necessary - and I think I'm in favour of doing
> that.

Trust me, you are not. There is a running joke about being able to
describe what "master" and "self" really means here at the office :)

Ok, so just to see if I understand this correctly:

The situation today it that `bridge fdb add ADDR dev DEV master` results
in flows towards ADDR being sent to:

1. DEV if DEV belongs to a DSA switch.
2. To the host if DEV was a non-offloaded interface.

With this series applied both would result in (2) which, while
idiosyncratic, is as intended. But this of course runs the risk of
breaking existing scripts which rely on the current behavior.

Correct?
