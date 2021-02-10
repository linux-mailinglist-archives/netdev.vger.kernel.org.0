Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86748317217
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 22:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233701AbhBJVMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 16:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbhBJVK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 16:10:59 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F98DC061786
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:10:19 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id a25so4806354ljn.0
        for <netdev@vger.kernel.org>; Wed, 10 Feb 2021 13:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=7jzT4yQV/3o40DXtn9iE3lZb0m+HGGF9DEeJMiokY9M=;
        b=IHcYtUHQAmCy5OlCieLV5eSZz3tNWaJGWbtXTATHhiDZKReims23rOPBBj5fQGzNki
         +3g30uBVDEArZE/pwAQgqJk9u+0OliV4fiURYdddDpjqdOLkxRahqjDPLyeENtpwx75b
         2KgMCyldhKozMNsupkqgoxWcGOdhsJWQV0KWmNZpbtJmG307WoXRsDS2haZjBKszSZZO
         pMYVZkjK8prBB8fyCncCXW6Alyoz4Wli7sd6ehoVagmojRXnMswWwx61DpuAgOQWTarH
         IEYBTVZeFKDDkPWWIlQXLmdDqxlj1/0x/05l2feiPZ0gOBx6G1IrnTiTDW90jfs23qFr
         n86A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7jzT4yQV/3o40DXtn9iE3lZb0m+HGGF9DEeJMiokY9M=;
        b=YjMtkJhISC1n5WvYN1CQgQNpiaWKK9B+zkfPj2UqZDFddlTttK62fra3NlPIcZAewp
         GS9zBX/ZQ287bTrrRnTw38Na7OJw6Z3zzfJ3yUJyFIbLTJVahlC9joFqmwAsatha5xh5
         wmvBDFd9IWUM0GYnpyMmqiJVaT2Nien8K+Ori/ENjLs45+V22JayaCH/kux0hzXLF1g9
         TxnyN6ENxHP62wW/ckZlM//xNWhh5+xBo0Fwx91yzRAXSqgJY75SErlmSF+iWgKm9VOB
         z7o9sYR8zutAtkydCFJWJpFxP6aiZLBPZfZkHLVy4YmRKZNYBdzr9m4VSdWCUGsv4XIO
         JUHQ==
X-Gm-Message-State: AOAM5322OBtJGl7UvRcFHboO2wWk+rB0cdgrT6O+j1asDh2l6gOzz/Us
        04K/gjz19AgpZktRXDGmMydkyWG+5HBlHyeo
X-Google-Smtp-Source: ABdhPJzX3GROgsX2nAkUGQztsAU6PcFafJaQJkWag9H45UQzT9FhI2os/df+03IknR2gMS+wrvonPg==
X-Received: by 2002:a2e:b443:: with SMTP id o3mr3063422ljm.130.1612991416993;
        Wed, 10 Feb 2021 13:10:16 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id s9sm28384lfr.231.2021.02.10.13.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 13:10:16 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] add HSR offloading support for DSA switches
In-Reply-To: <CAFSKS=NQN-OaQwYT8Crev33mUON3+6zYCss_nHoCD2gOzeYWTw@mail.gmail.com>
References: <20210204215926.64377-1-george.mccollister@gmail.com> <87sg6648nw.fsf@waldekranz.com> <CAFSKS=OO8oi=757b9DqOMpS4X6jqf5rg+X=GO8G-hOQ+S7LaKQ@mail.gmail.com> <87k0rh487y.fsf@waldekranz.com> <CAFSKS=NQN-OaQwYT8Crev33mUON3+6zYCss_nHoCD2gOzeYWTw@mail.gmail.com>
Date:   Wed, 10 Feb 2021 22:10:14 +0100
Message-ID: <87eehn4ojt.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 11:04, George McCollister <george.mccollister@gmail.com> wrote:
> On Tue, Feb 9, 2021 at 8:38 AM Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>
>> On Mon, Feb 08, 2021 at 15:09, George McCollister <george.mccollister@gmail.com> wrote:
>> > On Mon, Feb 8, 2021 at 2:16 PM Tobias Waldekranz <tobias@waldekranz.com> wrote:
>> >>
>> >> On Thu, Feb 04, 2021 at 15:59, George McCollister <george.mccollister@gmail.com> wrote:
>> >> > Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
>> >> > removal, forwarding and duplication on DSA switches.
>> >> > This series adds offloading to the xrs700x DSA driver.
>> >> >
>> >> > Changes since RFC:
>> >> >  * Split hsr and dsa patches. (Florian Fainelli)
>> >> >
>> >> > Changes since v1:
>> >> >  * Fixed some typos/wording. (Vladimir Oltean)
>> >> >  * eliminate IFF_HSR and use is_hsr_master instead. (Vladimir Oltean)
>> >> >  * Make hsr_handle_sup_frame handle skb_std as well (required when offloading)
>> >> >  * Don't add hsr tag for HSR v0 supervisory frames.
>> >> >  * Fixed tag insertion offloading for PRP.
>> >> >
>> >> > George McCollister (4):
>> >> >   net: hsr: generate supervision frame without HSR/PRP tag
>> >> >   net: hsr: add offloading support
>> >> >   net: dsa: add support for offloading HSR
>> >> >   net: dsa: xrs700x: add HSR offloading support
>> >> >
>> >> >  Documentation/networking/netdev-features.rst |  21 ++++++
>> >> >  drivers/net/dsa/xrs700x/xrs700x.c            | 106 +++++++++++++++++++++++++++
>> >> >  drivers/net/dsa/xrs700x/xrs700x_reg.h        |   5 ++
>> >> >  include/linux/if_hsr.h                       |  27 +++++++
>> >> >  include/linux/netdev_features.h              |   9 +++
>> >> >  include/net/dsa.h                            |  13 ++++
>> >> >  net/dsa/dsa_priv.h                           |  11 +++
>> >> >  net/dsa/port.c                               |  34 +++++++++
>> >> >  net/dsa/slave.c                              |  14 ++++
>> >> >  net/dsa/switch.c                             |  24 ++++++
>> >> >  net/dsa/tag_xrs700x.c                        |   7 +-
>> >> >  net/ethtool/common.c                         |   4 +
>> >> >  net/hsr/hsr_device.c                         |  46 ++----------
>> >> >  net/hsr/hsr_device.h                         |   1 -
>> >> >  net/hsr/hsr_forward.c                        |  33 ++++++++-
>> >> >  net/hsr/hsr_forward.h                        |   1 +
>> >> >  net/hsr/hsr_framereg.c                       |   2 +
>> >> >  net/hsr/hsr_main.c                           |  11 +++
>> >> >  net/hsr/hsr_main.h                           |   8 +-
>> >> >  net/hsr/hsr_slave.c                          |  10 ++-
>> >> >  20 files changed, 331 insertions(+), 56 deletions(-)
>> >> >  create mode 100644 include/linux/if_hsr.h
>> >> >
>> >> > --
>> >> > 2.11.0
>> >>
>> >> Hi George,
>> >>
>> >> I will hopefully have some more time to look into this during the coming
>> >> weeks. What follows are some random thoughts so far, I hope you can
>> >> accept the windy road :)
>> >>
>> >> Broadly speaking, I gather there are two common topologies that will be
>> >> used with the XRS chip: "End-device" and "RedBox".
>> >>
>> >> End-device:    RedBox:
>> >>  .-----.       .-----.
>> >>  | CPU |       | CPU |
>> >>  '--+--'       '--+--'
>> >>     |             |
>> >> .---0---.     .---0---.
>> >> |  XRS  |     |  XRS  3--- Non-redundant network
>> >> '-1---2-'     '-1---2-'
>> >>   |   |         |   |
>> >>  HSR Ring      HSR Ring
>> >
>> > There is also the HSR-HSR use case and HSR-PRP use case.
>>
>> HSR-HSR is also known as a "QuadBox", yes? HSR-PRP is the same thing,
>> but having two PRP networks on one side and an HSR ring on the other?
>
> Yes. I believe you are correct.
> From the spec:
> "QuadBox
> Quadruple port device connecting two peer HSR rings, which behaves as
> an HSR node in
> each ring and is able to filter the traffic and forward it from ring to ring."
>
>>
>> >> From the looks of it, this series only deals with the end-device
>> >> use-case. Is that right?
>> >
>> > Correct. net/hsr doesn't support this use case right now. It will
>> > stomp the outgoing source MAC with that of the interface for instance.
>>
>> Good to know! When would that behavior be required? Presumably it is not
>> overriding the SA just for fun?
>
> Over the last few weeks I've looked over that code for way longer than
> I'd like to admit and I'm still not sure. As far as I can tell, the
> original authors have disappeared. My guess is it has something to do
> with a configuration in which they had each redundant interface set to
> a different MAC address and wanted the frames to go out with the
> associated MAC address. As far as I can tell this is a violation of
> the spec.

Alright, so maybe a "Works for Me (TM)" solution initially, where any
devince stacking was out of scope.

>>
>> > It also doesn't implement a ProxyNodeTable (though that actually
>> > wouldn't matter if you were offloading to the xrs700x I think). Try
>> > commenting out the ether_addr_copy() line in hsr_xmit and see if it
>> > makes your use case work.
>>
>> So what is missing is basically to expand the current facility for
>> generating sequence numbers to maintain a table of such associations,
>> keyed by the SA?
>
> For the software implementation it would also need to use the
> ProxyNodeTable to prevent forwarding matching frames on the ring and
> delivering them to the hsr master port. It's also supposed to drop
> frames coming in on a redundant port if the source address is in the
> ProxyNodeTable.

This whole thing sounds an awful lot like an FDB. I suppose an option
would be to implement the RedBox/QuadBox roles in the bridge, perhaps by
building on the work done for MRP? Feel free to tell me I'm crazy :)

>>
>> Is the lack of that table the reason for enforcing that the SA match the
>> HSR netdev?
>
> Could be.
>
>>
>> >> I will be targeting a RedBox setup, and I believe that means that the
>> >> remaining port has to be configured as an "interlink". (HSR/PRP is still
>> >> pretty new to me). Is that equivalent to a Linux config like this:
>> >
>> > Depends what you mean by configured as an interlink. I believe bit 9
>> > of HSR_CFG in the switch is only supposed to be used for the HSR-HSR
>> > and HSR-PRP use case, not HSR-SAN.
>>
>> Interesting, section 6.4.1 of the XRS manual states: "The interlink port
>> can be either in HSR, PRP or normal (non-HSR, non-PRP) mode." Maybe the
>> term is overloaded?
>
> Yeah I guess since it's the only port that can be used for QuadBox
> they call it the interlink port even if it doesn't have the HSR/PRP
> mode enabled with the interlink bit set.

Right, that makes sense.

>>
>> >>       br0
>> >>      /   \
>> >>    hsr0   \
>> >>    /  \    \
>> >> swp1 swp2 swp3
>> >>
>> >> Or are there some additional semantics involved in forwarding between
>> >> the redundant ports and the interlink?
>> >
>> > That sounds right.
>> >
>> >>
>> >> The chip is very rigid in the sense that most roles are statically
>> >> allocated to specific ports. I think we need to add checks for this.
>> >
>> > Okay. I'll look into this. Though a lot of the restrictions have to do
>> > with using the third gigabit port for an HSR/PRP interlink (not
>> > HSR-SAN) which I'm not currently supporting anyway.
>>
>> But nothing is stopping me from trying to setup an HSR ring between port
>> (2,3) or (1,3), right? And that is not supported by the chip as I
>> understand it from looking at table 25.
>
> Yeah. That's why I said I'd look into it :). Wasn't an issue for my
> board since port 0 isn't connected and port 3 is used as the CPU
> facing port.

Fair enough :)

>>
>> >> Looking at the packets being generated on the redundant ports, both
>> >> regular traffic and supervision frames seem to be HSR-tagged. Are
>> >> supervision frames not supposed to be sent with an outer ethertype of
>> >> 0x88fb? The manual talks about the possibility of setting up a policy
>> >> entry to bypass HSR-tagging (section 6.1.5), is this what that is for?
>> >
>> > This was changed between 62439-3:2010 and 62439-3:2012.
>> > "Prefixing the supervision frames on HSR by an HSR tag to simplify the hardware
>> > implementation and introduce a unique EtherType for HSR to simplify
>> > processing."
>>
>> Thank you, that would have taken me a long time to figure out :)
>>
>> > The Linux HSR driver calls the former HSR v0 and the later HSR v1. I'm
>> > not sure what their intention was with this feature. The inbound
>> > policies are pretty flexible so maybe they didn't have anything so
>> > specific in mind.
>>
>> Now that I think of it, maybe you want things like LLDP to still operate
>> hop-by-hop over the ring?
>
> Not sure. Would need to look into it.
>
>>
>> > I don't think the xrs7000 series could offload HSR v0 anyway because
>> > the tag ether type is different.
>> >
>> >>
>> >> In the DSA layer (dsa_slave_changeupper), could we merge the two HSR
>> >> join/leave calls somehow? My guess is all drivers are going to end up
>> >> having to do the same dance of deferring configuration until both ports
>> >> are known.
>> >
>> > Describe what you mean a bit more. Do you mean join and leave should
>> > each only be called once with both hsr ports being passed in?
>>
>> Exactly. Maybe we could use `netdev_for_each_lower_dev` to figure out if
>> the other port has already been switched over to the new upper or
>> something. I find it hard to believe that there is any hardware out
>> there that can do something useful with a single HSR/PRP port anyway.
>
> If one port failed maybe it would still be useful to join one port if
> the switch supported it? Maybe this couldn't ever happen anyway due
> the way hsr is designed.
>
> How were you thinking this would work? Would it just not use
> dsa_port_notify() and call a switch op directly after the second
> port's dsa_slave_changeupper() call? Or would we instead keep port

Yeah this is what I was thinking. But I understand where Vladimir is
coming from. Fundamentally, I am also on the library side of the
"library vs. framework" spectrum.

> notifiers and calls to dsa_switch_hsr_join for each port and just make
> dsa_switch_hsr_join() not call the switch op to create the HSR until
> the second port called it? I'm not all that familiar with how these
> dsa notifiers work and would prefer to stick with using a similar
> mechanism to the bridge and lag support. It would be nice to get some
> feedback from the DSA maintainers on how they would prefer it to work
> if they indeed had a preference at all.
