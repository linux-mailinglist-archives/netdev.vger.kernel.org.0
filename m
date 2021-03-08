Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33237331808
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbhCHUA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbhCHUAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 15:00:52 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22421C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 12:00:52 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id d3so22971613lfg.10
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 12:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=m699D057sh07mcXOd7f37MebUOnSkaFViVaFPIKw2kc=;
        b=JWGfoOmqk67mtJ8qNNxKmCkCQ2nJORNO7Z68NP5O1urYeLHgBlxJ76DeZurm/MfvYn
         vNM5pMx2kAjNXogsoFOiBBPWju3+NFuUNjzRWNMxmM9N2MPIZdaxLJx29JCec1zQtLUm
         cIYS/eKSJY6egXUAtO9vBDlcbLiYKs+YTPBOIM6FX9nAZSQTX+eqft4T9OTkMDznM+HL
         xd/H6NtdYXAX6AQoofwtCEHMI2a0sGqigHg3UBkW7i3/oGrLz0NaNR+ivczSFiXyHH0z
         JcRgeONtmlrXZqME2H302ADOzapChyjIGr03BaWhHyQwxKP2APXDdCz4geXGZKO2YisV
         LiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=m699D057sh07mcXOd7f37MebUOnSkaFViVaFPIKw2kc=;
        b=jGxAikh1uPPCQAXCas/s5Xy7zMrW64/jqvdCgh5qryhGwCGAbbuhSqjyLoBNczQJ+B
         HRBIA7+7wNVEW2VBPot1UFmx8gYYvjxqJwClycj4t9dKDGuF2pT1s+RK0ABWJsDvwjvJ
         pXsCcG23O0y2lD57v7goNafMit3ITBcGrjiZnv03sti6bJgPQTYuPLTEll6SRA/IFRMs
         rck2oW6vISvTl3080BBtUvg4JffCBfWOQsPH1bVkA4dOD7Nlziihborn3hU7WGi3FNyu
         WllXnh1kId+6wNqkHNNSPZUfL+MyaRMXjbMcE0FIDuP+rARTm0tLkOr3dpd9lIeI/wNm
         Kuuw==
X-Gm-Message-State: AOAM532GMBkt0x5xP8zhN5A/PWWoPKmS+dihuFQerqsd9CgRiJlsLqJ3
        0WNu8F8swfkbpXjTYcqjWOqU53FcO5sgeg==
X-Google-Smtp-Source: ABdhPJx2WuDRg13aJHE0DYjk9jVKCRPbOQfJAbC2Jj5U86VH2Vb1tjhhJvFEts6VpXNnQTseGRjsNQ==
X-Received: by 2002:a19:8b45:: with SMTP id n66mr15317459lfd.252.1615233650259;
        Mon, 08 Mar 2021 12:00:50 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id b25sm1621244ljo.80.2021.03.08.12.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:00:49 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: dsa: Accept software VLANs for stacked interfaces
In-Reply-To: <20210308170027.jdehraoyntgqkjo4@skbuf>
References: <20210308150405.3694678-1-tobias@waldekranz.com> <20210308150405.3694678-2-tobias@waldekranz.com> <20210308154446.ceqp56bh65bsarlt@skbuf> <20210308170027.jdehraoyntgqkjo4@skbuf>
Date:   Mon, 08 Mar 2021 21:00:49 +0100
Message-ID: <87pn09pg9a.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 08, 2021 at 19:00, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Mon, Mar 08, 2021 at 05:44:46PM +0200, Vladimir Oltean wrote:
>> On Mon, Mar 08, 2021 at 04:04:04PM +0100, Tobias Waldekranz wrote:
>> > The dsa_slave_vlan_rx_{add,kill}_vid ndos are required for hardware
>> > that can not control VLAN filtering per port, rather it is a device
>> > global setting, in order to support VLAN uppers on non-bridged ports.
>> > 
>> > For hardware that can control VLAN filtering per port, it is perfectly
>> > fine to fallback to software VLANs in this scenario. So, make sure
>> > that this "error" does not leave the DSA layer as vlan_add_vid does
>> > not know the meaning of it.
>> > 
>> > The blamed commit removed this exemption by not advertising the
>> > feature if the driver did not implement VLAN offloading. But as we
>> > know see, the assumption that if a driver supports VLAN offloading, it
>> > will always use it, does not hold in certain edge cases.
>> > 
>> > Fixes: 9b236d2a69da ("net: dsa: Advertise the VLAN offload netdev ability only if switch supports it")
>> > Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
>> > ---
>> 
>> So these NDOs exist for drivers that need the 'rx-vlan-filter: on'
>> feature in ethtool -k, which can be due to any of the following reasons:
>> 1. vlan_filtering_is_global = true, some ports are under a VLAN-aware
>>    bridge while others are standalone (this is what you described)
>> 2. Hellcreek. This driver needs it because in standalone mode, it uses
>>    unique VLANs per port to ensure separation. For separation of untagged
>>    traffic, it uses different PVIDs for each port, and for separation of
>>    VLAN-tagged traffic, it never accepts 8021q uppers with the same vid
>>    on two ports.
>> 3. the ports that are under a VLAN-aware bridge should also set this
>>    feature, for 8021q uppers having a VID not claimed by the bridge.
>>    In this case, the driver will essentially not even know that the VID
>>    is coming from the 8021q layer and not the bridge.
>> 
>> If a driver does not fall under any of the above 3 categories, there is
>> no reason why it should advertise the 'rx-vlan-filter' feature, therefore
>> no reason why it should implement these NDOs, and return -EOPNOTSUPP.
>> 
>> We are essentially saying the same thing, except what I propose is to
>> better manage the 'rx-vlan-filter' feature of the DSA net devices. After
>> your patches, the network stack still thinks that mv88e6xxx ports in
>> standalone mode have VLAN filtering enabled, which they don't. That
>> might be confusing. Not only that, but any other driver that is

Alright, we do not want to lie to the stack, got it...

>> VLAN-unaware in standalone mode will similarly have to ignore VLANs
>> coming from the 8021q layer, which may add uselessly add to their
>> complexity. Let me prepare an alternative patch series and let's see how
>> they compare against each other.
>> 
>> As far as I see, mv88e6xxx needs to treat the VLAN NDOs in case 3 only,
>> and DSA will do that without any sort of driver-level awareness. It's
>> all the other cases (standalone ports mode) that are bothering you.
>
> So I stopped from sending an alternative solution, because neither mine
> nor yours will fix this situation:
>
> ip link add link lan0 name lan0.100 type vlan id 100
> ip addr add 192.168.100.1/24 dev lan0.100
> ping 192.168.100.2 # should work
> ip link add br0 type bridge vlan_filtering 0
> ip link set lan0 master br0
> ping 192.168.100.2 # should still work
> ip link set br0 type bridge vlan_filtering 1
> ping 192.168.100.2 # should still work
>
> Basically my point is that you disregard the vlan_vid_add from the
> lan0.100 upper now because you think you don't need it, but one day will
> come when you will. We've had that problem for a very long while now
> with bridge VLANs, and it wasn't even completely solved yet (that's why
> ds->configure_vlan_while_not_filtering is still a thing). It's
> fundamentally the same with VLANs added by the 8021q layer. I think you
> should see what you can do to make mv88e6xxx stop complaining and accept
> the VLANs from the 8021q uppers even if they aren't needed right away.

...hang on, are we OK with lying or not? Yes, I guess?

> It's a lot easier that way, otherwise you will end up having to replay
> them somehow.

I think vlan_for_each should be enough to perform the replay when
toggling VLAN filtering on a port?

More importantly, there are other sequences that we do not guard against
today:

- Adding VID to a bridge port that is used on an 1Q upper of another
  bridged port.

    .100  br0
       \  / \
       lan0 lan1

    $ ip link add dev br0 type bridge vlan_filtering 1
    $ ip link add dev lan0.100 link lan0 type vlan id 100
    $ ip link set dev lan0 master br0
    $ ip link set dev lan1 master br0
    $ bridge vlan add dev lan1 vid 100 # This should fail

    After this sequence, the switch will forward VID 100 tagged frames
    between lan0 and lan1.

- Briding two ports that both have 1Q uppers using the same VID.

    .100  br0  .100
       \  / \  /
       lan0 lan1

    $ ip link add dev br0 type bridge vlan_filtering 1
    $ ip link add dev lan0.100 link lan0 type vlan id 100
    $ ip link add dev lan1.100 link lan1 type vlan id 100
    $ ip link set dev lan0 master br0
    $ ip link set dev lan1 master br0 # This should fail

    This is also allowed by DSA today, and produces the same switch
    config as the previous sequence.

So in summary:

- Try to design some generic VLAN validation that can be used when:
  - Adding VLANs to standalone ports.
  - Adding VLANs to bridged ports.
  - Toggling VLAN filtering on ports.
- Remove 1/2.
- Rework 2/2 to:
  - `return 0` when adding a VLAN to a non-bridged port, not -EOPNOTSUPP.
  - Lazy load/unload VIDs from VLAN uppers when toggling filtering on a
    port using vlan_for_each or similar.

Does that sound reasonable?

Are we still in net territory or is this more suited for net-next?
