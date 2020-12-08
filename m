Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CCD2D2E56
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 16:34:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729846AbgLHPeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 10:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729457AbgLHPeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 10:34:03 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A35C061749
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 07:33:22 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id d20so23992692lfe.11
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 07:33:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version:content-transfer-encoding;
        bh=aag/5wRPJ34SVeu06FKVofa5ndUzz11JeaWLp4CrCZs=;
        b=nWzak6wrU9hDSZGasgln5AQeqTNZH9CFMQGPa8O22oLAwRJXUqTGHO9K/6Pz4iXgCl
         rwGTjJSb2y5vsrYDz0amlcV9P0KvBXtTPuuOpxTIU+lwNv7ctMvnlgCRY4UoXO/T2K33
         KBlBH809NB7PzxhOhLcQ3XHYa+i/YoC2Cq75R3MWNnZXna3sN+E2ric39r/qKwC9ABnu
         j3wHZy19d8vydB9KheyWMQxC3a6Z2nXB6f68r1BHY8eG79tL4iAtW5woNso/Bn4FJj3Y
         YBcbaD84nEj2Cyd3qehGwoKOt902NtcSMbKLpHW3c9po9fqMlo60Y9vuBAOkPznK6xW3
         ibaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=aag/5wRPJ34SVeu06FKVofa5ndUzz11JeaWLp4CrCZs=;
        b=lEo+Pw7bU8MQXBW9TDeHdYI22iHwGzGY7bPy7WzylJyY2HjdGY8r0PSR1zEFFs1/S2
         t+6nm4tG/hHsP9/fL+YFBVH2tn9+1CJ82Au3RJf5CLDM8W/1dR6juFQixKhnLllcX1r8
         6BAP8qh2b17e+/t1s4jH+TTYTHzv/sj5gNhfqQFjZOj8HmcT+xusH5Sd8LVlIj/o3woH
         ki4yqPeU4xA7kUyuaobd7ZfG/FEEbgyRyXgeUiqgu1r9bYEsIXcarzRgsvtyFdIiAv2k
         A/GH0T/3fMnuHC4/7I3O7HOqRK+Sm41Af+b9KEy/0ZY7iYqynDr1+CxHAjow5J2roU0i
         LUkQ==
X-Gm-Message-State: AOAM531neHY+ssA1dmmHWofAeEaCnXdyPOMCGu6I8D80dH7Iu8aFUgHN
        MFcyqJifkqS124w8x/4IBK5GR/X47eOg+2/m
X-Google-Smtp-Source: ABdhPJwAKVRY8s0fdkyYhfkLYgYQ91b9YogV/QPWHIvZ1UCP8ImREZrqO/4u665JRQ2xQ42Zt+ryMQ==
X-Received: by 2002:a19:650c:: with SMTP id z12mr10528702lfb.582.1607441600770;
        Tue, 08 Dec 2020 07:33:20 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id b7sm3265330lfo.24.2020.12.08.07.33.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 07:33:19 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201208112350.kuvlaxqto37igczk@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201208112350.kuvlaxqto37igczk@skbuf>
Date:   Tue, 08 Dec 2020 16:33:19 +0100
Message-ID: <87mtyo5n40.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 13:23, Vladimir Oltean <olteanv@gmail.com> wrote:
> Hi Tobias,
>
> On Wed, Dec 02, 2020 at 10:13:54AM +0100, Tobias Waldekranz wrote:
>> Monitor the following events and notify the driver when:
>>
>> - A DSA port joins/leaves a LAG.
>> - A LAG, made up of DSA ports, joins/leaves a bridge.
>> - A DSA port in a LAG is enabled/disabled (enabled meaning
>>   "distributing" in 802.3ad LACP terms).
>>
>> Each LAG interface to which a DSA port is attached is represented by a
>> `struct dsa_lag` which is globally reachable from the switch tree and
>> from each associated port.
>>
>> When a LAG joins a bridge, the DSA subsystem will treat that as each
>> individual port joining the bridge. The driver may look at the port's
>> LAG pointer to see if it is associated with any LAG, if that is
>> required. This is analogue to how switchdev events are replicated out
>> to all lower devices when reaching e.g. a LAG.
>>
>> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> ---
>>
>> +struct dsa_lag {
>> +	struct net_device *dev;
>> +	int id;
>> +
>> +	struct list_head ports;
>> +
>> +	/* For multichip systems, we must ensure that each hash bucket
>> +	 * is only enabled on a single egress port throughout the
>> +	 * whole tree, lest we send duplicates. Therefore we must
>> +	 * maintain a global list of active tx ports, so that each
>> +	 * switch can figure out which buckets to enable on which
>> +	 * ports.
>> +	 */
>> +	struct list_head tx_ports;
>> +	int num_tx;
>> +
>> +	refcount_t refcount;
>> +};
>
> Sorry it took so long. I wanted to understand:
> (a) where are the challenged for drivers to uniformly support software
>     bridging when they already have code for bridge offloading. I found
>     the following issues:
>     - We have taggers that unconditionally set skb->offload_fwd_mark =3D =
1,
>       which kind of prevents software bridging. I'm not sure what the
>       fix for these should be.

At least on mv88e6xxx you would not be able to determine this simply
from looking at the tag. Both in standalone mode and bridged mode, you
would receive FORWARDs with the same source. You could look at
dp->bridge_dev to figure it out though.

>     - Source address is a big problem, but this time not in the sense
>       that it traditionally has been. Specifically, due to address
>       learning being enabled, the hardware FDB will set destinations to
>       take the autonomous fast path. But surprise, the autonomous fast
>       path is blocked, because as far as the switch is concerned, the
>       ports are standalone and not offloading the bridge. We have drivers
>       that don't disable address learning when they operate in standalone
>       mode, which is something they definitely should do.

Some hardware can function with it on (e.g. mv88e6xxx can associate an
FDB per port), but there is no reason to do it, so yes it should be
disabled.

>     There is nothing actionable for you in this patch set to resolve this.
>     I just wanted to get an idea.
> (b) Whether struct dsa_lag really brings us any significant benefit. I
>     found that it doesn't. It's a lot of code added to the DSA core, that
>     should not really belong in the middle layer. I need to go back and
>     quote your motivation in the RFC:
>
> | All LAG configuration is cached in `struct dsa_lag`s. I realize that
> | the standard M.O. of DSA is to read back information from hardware
> | when required. With LAGs this becomes very tricky though. For example,
> | the change of a link state on one switch will require re-balancing of
> | LAG hash buckets on another one, which in turn depends on the total
> | number of active links in the LAG. Do you agree that this is
> | motivated?
>
>     After reimplementing bonding offload in ocelot, I have found
>     struct dsa_lag to not provide any benefit. All the information a
>     driver needs is already provided through the
>     struct net_device *lag_dev argument given to lag_join and lag_leave,
>     and through the struct netdev_lag_lower_state_info *info given to
>     lag_change. I will send an RFC to you and the list shortly to prove
>     that this information is absolutely sufficient for the driver to do
>     decent internal bookkeeping, and that DSA should not really care
>     beyond that.

Do you have a multi-chip setup? If not then I understand that `struct
dsa_lag` does not give you anything extra. In a multi-chip scenario
things become harder. Example:

.-----.   .-----.
| sw0 +---+ sw1 |
'-+-+-'3 3'--+--'
  1 2        1

Let's say that sw0p1, sw0p2 and sw1p1 are in a LAG. This system can hash
flows into 8 buckets. So with all ports active you would need an
allocation like this:

sw0p1: 0,1,2
sw0p2: 3,4,5
sw1p1: 6,7

For some reason, the system determines that sw0p2 is now inactive and
the LAG should be rebalanced over the two remaining active links:

sw0p1: 0,1,2,3
sw0p2: -
sw1p1: 4,5,6,7

In order for sw0 and sw1 to agree on the assignment they need access to
a shared view of the LAG at the tree level, both about the set of active
ports and their ordering. This is `struct dsa_lag`s main raison d'=C3=AAtre.

The same goes for when a port joins/leaves a LAG. For example, if sw1p1
was to leave the LAG, we want to make sure that we do not needlessly
flood LAG traffic over the backplane (sw0p3<->sw1p3). If you want to
solve this at the ds level without `struct dsa_lag`, you need a refcount
per backplane port in order to figure out if the leaving port was the
last one behind that backplane port.


>     There are two points to be made:
>     - Recently we have seen people with non-DSA (pure switchdev) hardware
>       being compelled to write DSA drivers, because they noticed that a
>       large part of the middle layer had already been written, and it
>       presents an API with a lot of syntactic sugar. Maybe there is a
>       larger issue here in that the switchdev offloading APIs are fairly
>       bulky and repetitive, but that does not mean that we should be
>       encouraging the attitude "come to DSA, we have cookies".
>       https://lwn.net/ml/linux-kernel/20201125232459.378-1-lukma@denx.de/

I think you are right, but having written a (no DSA) switchdev driver
myself, I understand where that desire comes from. I have found myself
looking/copying stuff from mlxsw and dsa that could have been provided
as a shared switchdev library. Things demuxing all of the different
events to figure out when uppers change etc.

>     - Remember that the only reason why the DSA framework and the
>       syntactic sugar exists is that we are presenting the hardware a
>       unified view for the ports which have a struct net_device registere=
d,
>       and the ports which don't (DSA links and CPU ports). The argument
>       really needs to be broken down into two:
>       - For cross-chip DSA links, I can see why it was convenient for
>         you to have the dsa_lag_by_dev(ds->dst, lag_dev) helper. But
>         just as we currently have a struct net_device *bridge_dev in
>         struct dsa_port, so we could have a struct net_device *bond,
>         without the extra fat of struct dsa_lag, and reference counting,
>         active ports, etc etc, would become simpler (actually inexistent
>         as far as the DSA layer is concerned). Two ports are in the same
>         bond if they have the same struct net_device *bond, just as they
>         are bridged if they have the same struct net_device *bridge_dev.
>       - For CPU ports, this raises an important question, which is
>         whether LAG on switches with multiple CPU ports is ever going to
>         be a thing. And if it is, how it is even going to be configured
>         from the user's perspective. Because on a multi-CPU port system,
>         you should actually see it as two bonding interfaces back to back.
>         First, there's the bonding interface that spans the DSA masters.
>         That needs no hardware offloading. Then there's the bonding
>         interface that is the mirror image of that, and spans the CPU
>         ports. I think this is a bit up in the air now. Because with

Aside. On our devices we use the term cpu0, cpu1 etc. to refer to a
switch port that is connected to a CPU. The CPU side of those
connections are chan0, chan1 ("channel"). I am not saying we have to
adopt those, but some unambiguous terms would be great in these
conversations.

>         your struct dsa_lag or without, we still have no bonding device
>         associated with it, so things like the balancing policy are not
>         really defined.
>

I have a different take on that. I do not think you need to create a
user-visible LAG at all in that case. You just setup the hardware to
treat the two CPU ports as a static LAG based on the information from
the DT. Then you attach the same rx handler to both. On tx you hash and
loadbalance on flows that allow it (FORWARDs on mv88e6xxx) and use the
primary CPU port for control traffic (FROM_CPU).

The CPU port is completely defined by the DT today, so I do not see why
we could not add balancing policy to that if it is ever required.

> I would like you to reiterate some of the reasons why you prefer having
> struct dsa_lag.

I hope I did that already. But I will add that if there was a dst->priv
for the drivers to use as they see fit, I guess the bookkeeping could be
moved into the mv88e6xxx driver instead if you feel it pollutes the DSA
layer. Maybe you can not assume that all chips in a tree use a
compatible driver though?

Are there any other divers that support multi-chip that might want to
use the same thing?
