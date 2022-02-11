Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40F34B2F00
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 22:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347346AbiBKVB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 16:01:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242588AbiBKVB1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 16:01:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373BBA5
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 13:01:22 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id b13so18434336edn.0
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 13:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yaFdbfTPpfLHwcsY5UeufWgTKmWySiisXtojBRnMWow=;
        b=etGEJRrdDqYO6rMAJKnStpc94oSTOyWEf6bQOPTMooAXuruwcmlD2ZIq+PZcLVNohu
         TyEHvCK3Rd6wdTSqn1feJXGduO5pA5BOQWjMnO51Y4ePj8seS1l/AVN6VvHtMz4Qezvp
         NaeXHP+MaM/QHQik6Ag19ixeUGU2f0CxhI0dphyE7myHzZGbP6I88CX7Hoa0u4oPxywl
         NweXkCWCUBqeuxqJYf36Awwb/Hg6tRqR0UdKOGD8Vslxx27DlkNKgJr9QHCWGTqJovbM
         aMqx/8uxjrLkWTOKlCFcKOjDMwt7lXdN5Cw3INAayB+b7LodMv76d6AjTAvWwKry6w+g
         BdHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yaFdbfTPpfLHwcsY5UeufWgTKmWySiisXtojBRnMWow=;
        b=v7e06jcVBqFhDBkg6EbxWAI6BpXFpY1yWizPGx2ZAmDrQZFE35i0eRAFGe7kXVuppD
         sWvdf3xYBJNOJibRzCmYcZuSZfQioOBAFpV6i2yFFk0+k+Ei92fpghH/graroZVPlpbM
         xCa6InoA1DcAPl/EQf5I/YInUnYP/mGLDc7GhaeLE7kirBqtstDDJ0BMDAq2vfLJNFao
         KTu+lhBpmVUP4CAx5mTCPbTg9yL2mKyRS0DrXfS0DUCJEz6D7nN99D7FnsMixBIfOpRy
         sULe8zvJMsx3YIFCmgbHvWMC1gny7QG6A2xQfTlmWBFhm1kv86XOaOAHOw1pMPIg87IC
         OWZQ==
X-Gm-Message-State: AOAM530S7mTWuFR+uqz/SnEqM2WwBVYTO73A6FWl/ns2NN5Rrq2O+2Ao
        9c5chgaLdvpbBl7r7owlb/E=
X-Google-Smtp-Source: ABdhPJz9OAbZRjKTtmGzzkUUGdDMF2YU5e6UhppIzl7nb93BgYqhwc00D1smprPM+sn/PPYDM8VXFQ==
X-Received: by 2002:a50:bb0c:: with SMTP id y12mr3907440ede.421.1644613280546;
        Fri, 11 Feb 2022 13:01:20 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id p4sm7262128ejm.47.2022.02.11.13.01.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 13:01:20 -0800 (PST)
Date:   Fri, 11 Feb 2022 23:01:18 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>
Subject: Re: [PATCH net-next v2 0/5] Add support for locked bridge ports (for
 802.1X)
Message-ID: <20220211210118.tqhm7wk4lhenwjko@skbuf>
References: <20220209130538.533699-1-schultz.hans+netdev@gmail.com>
 <ef92ed7a-62aa-a5d0-3656-6a918927c239@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ef92ed7a-62aa-a5d0-3656-6a918927c239@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 10:11:38AM -0800, Florian Fainelli wrote:
> It makes sense that we are using the bridge layer to support 802.1x but
> this leaves behind the case of standalone ports which people might want
> to use. Once we cover the standalone ports there is also a question of
> what to do in the case of a regular Ethernet NIC, and whether it can
> actually support 802.1x properly given their MAC filtering capabilities

The hardware implementations I'm aware of heavily revolve around what is
fundamentally the bridging service. But I've downloaded the 802.1X-2010
standard and there's nothing limiting it to a bridge. It can also apply
to a router, or an end point station. Not sure where that leaves us,
though. A more generic concept would be a MAC SA filter, which is kept
in sync with the bridge FDB by a user space daemon in case the bridge is
used on a port. But in whichever way I think about it, I don't see a
unified way of modeling this MAC SA filter in a way that lends itself
easily to switchdev offloading. On a standalone NIC, it would probably
make more sense for it to be an eBPF program. But for a switch, you just
expand simple information like "drop anything that wasn't learned" into
"drop anything that isn't this, that or the other", and the switch
driver has to parse all that just to figure out "oh, so you mean drop
anything that wasn't learned? well I have a bit for that".

Either we try to find a unified solution, or we let user space do
different things depending on whether a bridge is in use or not.

> (my guess is that most cannot without breaking communication with other
> stations connecting through the same port).

If the hardware support requires dropping packets with unknown MAC SA,
then yes, probably. DSA standalone ports disable MAC SA learning and
operate with empty FDBs on them these days. So we'd cut off all traffic
on that port if we don't change something in this model. And even if we
change something, we also need to take FDB isolation into account, using
a separate FID for authenticated MACs, with no forwarding other than to
the CPU. I'm probably thinking too far ahead though.

> Looking at what Broadcom Roboswitch support, the model you propose
> should be working, it makes me wonder if we need to go a bit beyond what
> can be configurable besides blocked/not-blocked and have different
> levels of strictness. These switches do the following on a per-port
> basis you can:
> 
> - set the EAP destination MAC address if different than 01:80:C2:00:00:03
> 
> - enable EAP frame with destination MAC address specified
> 
> - set the EAP block mode:
> 	0 - disabled
> 	1 - only the frames with the EAP reserved multicast address will be
> forwarded, otherwise frames will be dropped
> 	3 - only the frames with the EAP reserved multicast address will be
> forwarded. Forwarding verifies that each egress port is enabled for EAP
> + BLK_MODE

What's the difference between 1 and 3? At 1, when you say that EAP
reserved multicast packets will be forwarded, do you actually mean they
will be trapped to CPU?

> - set the EAP mode:
> 	0 - disabled
> 	2 - extended mode: check MAC SA, port, drop if unknown
> 	3 - simplified mode: check SA, port, trap to management if SA is unknown
> 
> We have a number of vectors that can be used to accept specific MAC SA
> addresses.
> 
> Then we have a global register that allows us to configure whether we
> want to allow ARP, DHCP, BPDU, RMC, RARP or the frames with the
> specified destination IP address/masks being specified. I would assume
> that the two registers allowing us to specify a destination IP/subnet
> might be used to park unauthenticated stations to a "guest" VLAN maybe?
> 
> So with that said, it looks like we may not need a method beyond just
> setting the port state. In your case, it sounds like you would program
> the mv88e6xxx switch's ATU with the MAC addresses learned from the
> bridge via the standard FDB learning notification?
> 
> In the case of Broadcom switches, I suppose the same should be done,
> however instead of programming the main FDB, we would have to program
> the multi-port vector when the port is in blocked state. This becomes a
> switch driver detail.
> 
> I would like other maintainers of switch drivers to chime in to know
> whether microchip, Qualcomm/Atheros and Mediatek have similar features
> or not.
> 
> Does that make sense?
> 
> Time to dust off my freeradius settings to test this out, it's been
> nearly 15 years since I last did this, time to see if EAP-TTLS or
> EAP-PEAP are more streamlined on the client side :)

The Microchip Ocelot switch family (and most probably others too) has 2
kinds of support for 802.1X access control.

- Port-based, this essentially revolves around putting a port in the
  BLOCKING STP state. IEEE 802.1X uses MAC address 01-80-C2-00-00-03, so
  that will continue to be trapped to the CPU regardless of STP state.

- MAC-based, this essentially revolves around "learn frames" (frames
  with unknown MAC SA). There are 2 sub-groups here, solution 1 is
  secure CPU-based learning, where learn frames are trapped to the CPU,
  and solution 2 is no-learning, where learn frames are just dropped.
  In both cases, the host must program the FDB to allow that MAC SA to
  be forwarded to other ports. I'm thinking that the no-learning method
  is what would resemble the closest this new BR_PORT_LOCKED flag.
  The secure learning procedure is probably useful when you want to
  bypass the MAC authentication process for a dumb device like a printer
  that doesn't speak 802.1X but you want it to be nonetheless whitelisted.

With the difference that MAC-based authentication allows you to have
more than 1 MAC SA behind an 802.1X switch port (like another switch),
and port-based authentication doesn't have that kind of flexibility.

Of course, there's also the TCAM where a custom policy could be enabled
per MAC SA.

The NXP SJA1105P/Q/R/S and SJA1110 of course have to be snowflakes here
as well. There is a "DRPNOLEARN" bit (drop frames which couldn't be
learned), but it's global, not per port, and it doesn't affect frames
which weren't learned due to learning being disabled on a port - just
due to the FDB space reserved for dynamic entries getting depleted.
I could probably hack around that by reserving zero space for dynamic
FDB entries, but again, that would be a setting per switch, not per port.
There's just something about this switch that makes my skin itch :)
This switch family also supports "port enforcement" per FDB entry, where
the switch blocks station migrations/spoofing attempts by dropping a
given MAC SA if the FDB has that address pointing towards a different
port than it was received on. Not sure whether this is something useful
in the context of 802.1X. Looking at Ocelot switches again, I see the
definition of a "learn frame" is actually expanded to cover these kind
of frames too (not just unknown MAC SA). So all that's described above
for learn frames should apply for spoofed traffic too.
