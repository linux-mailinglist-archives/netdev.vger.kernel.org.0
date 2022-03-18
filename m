Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 021C44DDD97
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238437AbiCRQF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238440AbiCRQFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:05:15 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E0854BFF
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:03:35 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id r21so4661430ljp.8
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=R0PvazlU6kQAc3NShJoFijyL74m3JrlMKSvz1wflKqU=;
        b=JC8sMzEO7gqIUIhy0J9UMmuFHQK+66HVvXq+mENRi3T9TRPZmHYt87ws8EkwaGYM9H
         UXsDqtTnA07/K3hk8fak+GMT4I2ff3cGhYbX6Kc6nDNC+n6f1Dy3oGW5slKYp5Cu6dpD
         AQkVYLhrF+GypKXM/v8gNY2ZR9Wg6U34krKV3k/SDa2t75jkf7E24ynelGRqYAINuvOy
         yXL+4nK0BKGHCYCXR4Ixp4DtaEyJD3kDghOSE93IToiqo8hsc+wdVxxvPQEBgF05Qv0W
         dIbDtlfyWaH8TALQJ82ynsEG+zapsFHXqI97DY79uX1iKtIP0I3xcYVARNyQx++VzPVf
         hWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=R0PvazlU6kQAc3NShJoFijyL74m3JrlMKSvz1wflKqU=;
        b=lhycVx07w/3jIWdiF8Luj+zJlY6JfpDaP98b+awwqIEEA3X/6DEIwoLrauIRMgxTd1
         2G8d174vvbB+h0geipGyq23Y7Ek5IrMW0w1SLg0kSPCms49VIHufT8d6cs+S/hHXYw5q
         Qe37CymGMja+tgmDYDJs5lv8vMtT5fwgOHKZYs1aZ1pm5vH8c/DQCZZSfOFU132wFJ6e
         78l15Pb2qeCkCIGQsCOTzCGee8mLw6+J8RML9gGbXYf80+KMTcye3xf7eD0MfSQp4ZZU
         xul2pIGC5WQoXWBQLgniaIHmQxwS6JePtqZx8txYbXJICJWq0VIrO3eF27ODN1RLGvkv
         vQhQ==
X-Gm-Message-State: AOAM533xOPGOvf99SLGfgw8jw+bzhyfC1j7m4oCgOLHr3J6dHz9pG3MI
        oyiLwZyHLFvaSz9fct0usv6tOw==
X-Google-Smtp-Source: ABdhPJxeOmtx0EgKLgXhIkTTRriHULUAKpEcyoiy1/XalAIOBP82pcvU0p/fW11SKGdLQauMoIdNlQ==
X-Received: by 2002:a2e:bf0b:0:b0:246:84be:7b11 with SMTP id c11-20020a2ebf0b000000b0024684be7b11mr6270434ljr.145.1647619413867;
        Fri, 18 Mar 2022 09:03:33 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id c20-20020a196554000000b0044a1181c527sm137043lfj.9.2022.03.18.09.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:03:33 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mattias Forsblad <mattias.forsblad+netdev@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 0/3] bridge: dsa: switchdev: mv88e6xxx:
 Implement local_receive bridge flag
In-Reply-To: <20220318124451.jdclhe2dlgvggemr@skbuf>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
 <87ilsxo052.fsf@waldekranz.com> <20220317140525.e2iqiy2hs3du763l@skbuf>
 <87k0crk7zg.fsf@waldekranz.com> <20220318111150.2g2pjcajjqhpr3wk@skbuf>
 <87h77vjwd7.fsf@waldekranz.com> <20220318124451.jdclhe2dlgvggemr@skbuf>
Date:   Fri, 18 Mar 2022 17:03:31 +0100
Message-ID: <87ee2zjlik.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 14:44, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Mar 18, 2022 at 01:09:08PM +0100, Tobias Waldekranz wrote:
>> >> > So have you seriously considered making the bridge ports that operate in
>> >> > 'dumb hub' mode have a pvid which isn't installed as a 'self' entry on
>> >> > the bridge device?
>> >> 
>> >> Just so there's no confusion, you mean something like...
>> >> 
>> >>     ip link add dev br0 type bridge vlan_filtering 1 vlan_default_pvid 0
>> >> 
>> >>     for p in swp0 swp1; do
>> >>         ip link set dev $p master br0
>> >>         bridge vlan add dev $p vid 1 pvid untagged
>> >>     done
>> >> 
>> >> ... right?
>> >> 
>> >> In that case, the repeater is no longer transparent with respect to
>> >> tagged packets, which the application requires.
>> >
>> > If you are sure that there exists one VLAN ID which is never used (like
>> > 4094), what you could do is you could set the port pvids to that VID
>> > instead of 1, and add the entire VLAN_N_VID range sans that VID in the
>> > membership list of the two ports, as egress-tagged.
>> 
>> Yeah, I've thought about this too. If the device's only role is to act
>> as a repeater, then you can get away with it. But you will have consumed
>> all rows in the VTU and half of the rows in the ATU (we add an entry for
>> the broadcast address in every FID). So if you want to use your other
>> ports for regular bridging you're left with a very limited feature set.
>
> But VLANs in other bridges would reuse the same FIDs, at least in the
> current mv88e6xxx implementation with no FDB isolation, no? So even
> though the VTU is maxed out, it wouldn't get 'more' maxed out.

I'm pretty sure that mv88e6xxx won't allow the same VID to be configured
on multiple bridges. A quick test seems to support that:

   root@coronet:~# ip link add dev br0 type bridge vlan_filtering 1
   root@coronet:~# ip link add dev br1 type bridge vlan_filtering 1
   root@coronet:~# ip link set dev br0 up
   root@coronet:~# ip link set dev br1 up
   root@coronet:~# ip link set dev swp1 master br0
   root@coronet:~# ip link set dev swp2 master br1
   RTNETLINK answers: Operation not supported

> As for the broadcast address needing to be present in the ATU, honestly
> I don't know too much about that. I see that some switches have a
> FloodBC bit, wouldn't that be useful?

mv88e6xxx can handle broadcast in two ways:

1. Always flood broadcast, independent of all other settings.

2. Treat broadcast as multicast, only allow flooding if unknown
   multicast is allowed on the port, or if there's an entry in the ATU
   (making it known) that allows it.

The kernel driver uses (2), because that is the only way (I know of)
that we can support the BCAST_FLOOD flag. In order to make BCAST_FLOOD
independent of MCAST_FLOOD, we have to load an entry allowing bc to
egress on all ports by default. De Morgan comes back to guide us once
more :)

>> > This is 'practical transparency' - if true transparency is required then
>> > yes, this doesn't work.
>> >
>> >> >> You might be tempted to solve this using flooding filters of the
>> >> >> switch's CPU port, but these go out the window if you have another
>> >> >> bridge configured, that requires that flooding of unknown traffic is
>> >> >> enabled.
>> >> >
>> >> > Not if CPU flooding can be managed on a per-user-port basis.
>> >> 
>> >> True, but we aren't lucky enough to have hardware that can do that :)
>> >> 
>> >> >> Another application is to create a similar setup, but with three ports,
>> >> >> and have the third one be used as a TAP.
>> >> >
>> >> > Could you expand more on this use case?
>> >> 
>> >> Its just the standard use-case for a TAP really. You have some link of
>> >> interest that you want to snoop, but for some reason there is no way of
>> >> getting a PCAP from the station on either side:
>> >> 
>> >>    Link of interest
>> >>           |
>> >> .-------. v .-------.
>> >> | Alice +---+  Bob  |
>> >> '-------'   '-------'
>> >> 
>> >> So you insert a hub in the middle, and listen on a third port:
>> >> 
>> >> .-------.   .-----.   .-------.
>> >> | Alice +---+ TAP +---+  Bob  |
>> >> '-------'   '--+--'   '-------'
>> >>                |
>> >>  PC running tcpdump/wireshark
>> >> 
>> >> The nice thing about being able to set this up in Linux is that if your
>> >> hardware comes with a mix of media types, you can dynamically create the
>> >> TAP for the job at hand. E.g. if Alice and Bob are communicating over a
>> >> fiber, but your PC only has a copper interface, you can bridge to fiber
>> >> ports with one copper; if you need to monitor a copper link 5min later,
>> >> you just swap out the fiber ports for two copper ports.
>> >> 
>> >> >> >> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
>> >> >> >
>> >> >> > I don't believe this tag has much value since it was presumably carried 
>> >> >> > over from an internal review. Might be worth adding it publicly now, though.
>> >> >> 
>> >> >> I think Mattias meant to replicate this tag on each individual
>> >> >> patch. Aside from that though, are you saying that a tag is never valid
>> >> >> unless there is a public message on the list from the signee? Makes
>> >> >> sense I suppose. Anyway, I will send separate tags for this series.
