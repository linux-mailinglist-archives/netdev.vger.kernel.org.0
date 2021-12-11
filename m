Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3658347173E
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 00:02:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhLKXCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 18:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhLKXCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 18:02:23 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE3BC061714
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 15:02:22 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id k37so24439418lfv.3
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 15:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=LoopTRoQUQprUq8G8iKDgLoEi9Mra0VoS4kNLRFyexI=;
        b=AKXftnvs7LxABPMmT+sSrqOfGmJhZNG3UrQdmicUlTP1FmJzxKPo/yl/amvsI6c3rv
         LSJj/GmsXBhoWLY26g80C30aGraeMMQrLGEpEHaULj8lD7gFY87llxhH/YYbF4A1c7Kp
         mJ2Z5eW2DiZm3Avud7z67EE/c/dm3FdxBB39/VgKWUN86uECCoMEhePHn8is5umP9Snk
         Oa3wfRgHUA6ueOzpmWZy5BFqnRzId0A+7LcPLIcxQYwd9r1yvk+r+9PSHPX/w2T6d96N
         5vME3RlqZcq6mp5Q+hRz73ZjppUBxa5jS+nN05K+8T3rfs+LvKELe4JWfuzP9CqJ2+Vp
         1MYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LoopTRoQUQprUq8G8iKDgLoEi9Mra0VoS4kNLRFyexI=;
        b=OQDcYhfQTVQSa2WihtyJD80JR0BEkORjW3wagTKkmQSi1sW7kqrJGnNM6KETENiP7B
         WVVtPFt2czlJsFnM1dh1TwlQoWuJAxkk1z1aTiqKqG6ljitm/vxe5kFpEF6HSRIOy6iM
         emJsbfm5MCBg1N0rDQDu3MPf6HxJZ6/UtDTTwxxL3vpMCpxueQ+6/oFskKvQfHCD/Bid
         /Yd+GgNT+zOS7Po1o5MPIgJd2W2/dfqRmqnl38B+mQr1EN4q+J+cC4zxHLrO0goa9q8u
         97RMhbVeSGvOTFoBYr4DUJ1E1/QOsMAHc96euU9HiA/fENh3Hn75LGMzQGFLLKHu44fp
         7iBA==
X-Gm-Message-State: AOAM5315/i/ASeeE6/PxCxKVJC/VY/UYh4ZQ/MsbadmqBiDueBrbm8x+
        Sh3O1qW4kQxPjgAnQrmJQ7gH1V5PsWLMZQ==
X-Google-Smtp-Source: ABdhPJzA4Y/mwjIZ1pycn4i7ahj8zKtB7/Bo3o6gzsCcT5qNeyjfEuANB+oj5mr2FSSvmorTht0EBA==
X-Received: by 2002:a05:6512:2827:: with SMTP id cf39mr20622469lfb.541.1639263741019;
        Sat, 11 Dec 2021 15:02:21 -0800 (PST)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id k11sm792331lfo.111.2021.12.11.15.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Dec 2021 15:02:20 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v1] net: dsa: mv88e6xxx: Trap PTP traffic
In-Reply-To: <87y24s9x5c.fsf@kmk-computers.de>
References: <20211209173337.24521-1-kurt@kmk-computers.de>
 <87y24t1fvk.fsf@waldekranz.com> <87y24s9x5c.fsf@kmk-computers.de>
Date:   Sun, 12 Dec 2021 00:02:19 +0100
Message-ID: <87r1ai21ac.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 18:39, Kurt Kanzenbach <kurt@kmk-computers.de> wrote:
> On Fri Dec 10 2021, Tobias Waldekranz wrote:
>> On Thu, Dec 09, 2021 at 18:33, Kurt Kanzenbach <kurt@kmk-computers.de> wrote:
>>> A time aware switch should trap PTP traffic to the management CPU. User space
>>> daemons such as ptp4l will process these messages to implement Boundary (or
>>> Transparent) Clocks.
>>>
>>> At the moment the mv88e6xxx driver for mv88e6341 doesn't trap these messages
>>> which leads to confusion when multiple end devices are connected to the
>>> switch. Therefore, setup PTP traps. Leverage the already implemented policy
>>> mechanism based on destination addresses. Configure the traps only if
>>> timestamping is enabled so that non time aware use case is still functioning.
>>
>> Do we know how PTP is supposed to work in relation to things like STP?
>> I.e should you be able to run PTP over a link that is currently in
>> blocking? It seems like being able to sync your clock before a topology
>> change occurs would be nice. In that case, these addresses should be
>> added to the ATU as MGMT instead of policy entries.
>
> Given the fact that the l2 p2p address is already considered as
> management traffic (see mv88e6390_g1_mgmt_rsvd2cpu()) maybe all PTP
> addresses could be treated as such.

The feedback from both Jakub and Richard seems to support that.

>
>>> +static int mv88e6341_setup_ptp_traps(struct mv88e6xxx_chip *chip, int port,
>>> +				     bool enable)
>>> +{
>>> +	static const u8 ptp_destinations[][ETH_ALEN] = {
>>> +		{ 0x01, 0x1b, 0x19, 0x00, 0x00, 0x00 }, /* L2 PTP */
>>> +		{ 0x01, 0x80, 0xc2, 0x00, 0x00, 0x0e }, /* L2 P2P */
>>> +		{ 0x01, 0x00, 0x5e, 0x00, 0x01, 0x81 }, /* IPv4 PTP */
>>> +		{ 0x01, 0x00, 0x5e, 0x00, 0x00, 0x6b }, /* IPv4 P2P */
>>> +		{ 0x33, 0x33, 0x00, 0x00, 0x01, 0x81 }, /* IPv6 PTP */
>>> +		{ 0x33, 0x33, 0x00, 0x00, 0x00, 0x6b }, /* IPv6 P2P */
>>
>> How does the L3 entries above play together with IGMP/MLD? I.e. what
>> happens if, after launching ptp4l, an IGMP report comes in on lanX,
>> requesting that same group? Would the policy entry not be overwritten by
>> mv88e6xxx_port_mdb_add?
>
> Just tested this. Yes it is overwritten without any detection or
> errors. Actually I did test UDP as well and didn't notice it. It
> obviously depends on the order of events.
>
>>
>> Eventually I think we will have many interfaces to configure static
>> entries in the ATU:
>>
>> 1. MDB entries from a bridge (already in place)
>> 2. User-configured entries through ethtool's rxnfc (already in place)
>> 3. Driver-internal consumers (this patch, MRP, etc.)
>> 4. User-configured entries through TC.
>>
>> Seems to me like we need to start tracking the owners for these to stop
>> them from stomping on one another.
>
> Agreed. Some mechanism is required. Any idea how to implement it? In
> case of PTP the management/policy entries should take precedence.

One approach would be to create a cache containing all static ATU
entries. That way we can easily track the owner of each entry. There are
also major performance advantages of being able to update memberships of
group entries without having to read the entry back from the ATU
first. This is especially important once we start handling router ports
correctly, in which case you have to update all active entries on every
add/remove.

Before going down that route though, I would suggest getting some
initial feedback from Andrew.

A complicating factor, no matter the implementation, is the relationship
between the bridge MDB and all other consumers of ATU entries. As an
example: If the driver first receives an MDB add for one of the L3 PTP
groups, and then a user starts up ptp4l, the driver can't then go back
to the bridge and say "remember that group entry that I said I loaded,
well I have removed it now". So whatever implementation we choose, I
think it needs to keep a shadow entry for the MDB that can be
re-inserted if the corresponding management or policy entry is removed.

You may simply want to allow all consumers to register any given group
with the cache. The cache would then internally elect the "best" entry
and install that to the ATU. Sort of what zebra/quagga/FRR does for
dynamic routing. The priority would probably be something like:

1. Management entry
2. Policy entry
3. MDB entry

This should still result in the proper forwarding of a registered groups
that are shadowed by management or policy entries. The bridge would know
(via skb->offload_fwd_mark) that the packet had not been forwarded in
hardware and would fallback to software forwarding. If the policy entry
was later removed (e.g. PTP was shut down) the MDB entry could be
reinstalled and offloading resumed.

>>
>>> +	};
>>> +	int ret, i;
>>> +
>>> +	for (i = 0; i < ARRAY_SIZE(ptp_destinations); ++i) {
>>> +		struct mv88e6xxx_policy policy = { };
>>> +
>>> +		policy.mapping	= MV88E6XXX_POLICY_MAPPING_DA;
>>> +		policy.action	= enable ? MV88E6XXX_POLICY_ACTION_TRAP :
>>> +			MV88E6XXX_POLICY_ACTION_NORMAL;
>>> +		policy.port	= port;
>>> +		policy.vid	= 0;
>>> +		ether_addr_copy(policy.addr, ptp_destinations[i]);
>>> +
>>> +		ret = mv88e6xxx_policy_apply(chip, port, &policy);
>>> +		if (ret)
>>> +			return ret;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>>  const struct mv88e6xxx_ptp_ops mv88e6165_ptp_ops = {
>>>  	.clock_read = mv88e6165_ptp_clock_read,
>>>  	.global_enable = mv88e6165_global_enable,
>>> @@ -419,6 +450,34 @@ const struct mv88e6xxx_ptp_ops mv88e6352_ptp_ops = {
>>>  	.cc_mult_dem = MV88E6XXX_CC_MULT_DEM,
>>>  };
>>>  
>>> +const struct mv88e6xxx_ptp_ops mv88e6341_ptp_ops = {
>>> +	.clock_read = mv88e6352_ptp_clock_read,
>>> +	.ptp_enable = mv88e6352_ptp_enable,
>>> +	.ptp_verify = mv88e6352_ptp_verify,
>>> +	.event_work = mv88e6352_tai_event_work,
>>> +	.port_enable = mv88e6352_hwtstamp_port_enable,
>>> +	.port_disable = mv88e6352_hwtstamp_port_disable,
>>> +	.setup_ptp_traps = mv88e6341_setup_ptp_traps,
>>
>> Is there any reason why this could not be added to the existing ops for
>> 6352 instead? Their ATU's are compatible, IIRC.
>
> No particular reason except that I don't have access to a 6352 device to
> test it.

Got it. Well I can hopefully be of assistance there. Anyway, I think we
can safely assume that they are compatible with respect to the ATU.
