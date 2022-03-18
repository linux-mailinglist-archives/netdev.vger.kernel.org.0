Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017EE4DD96B
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 13:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbiCRMKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 08:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiCRMKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 08:10:33 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B286B1F083D
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 05:09:14 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id p14so2456140lfe.4
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 05:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Becet34HA9AMGmgieFPyONEJRmnsBg3Xef/c13+mEd0=;
        b=SmlA9j1oGcwnOzwE5laSxpc8F5b5qOChuI6+x5VDXTTMNacdtDx6rJjbFNyiUuJ5wp
         Tw4ivy9sqGluWF+FQoKSTqOi+mx6fKCa/lehtDMJcZoZL6fbeJ098mJQEwrPYqGMfcfI
         j4MpFPj9HiqV3IunkfVBlbeiQWCquWCibuA74l/QK+2+EUfR5dnjJ8y1ib/9t+jdybe0
         U1kNvrUtcIPwTfRqf77yEMF12fVH2lUcFzPXErQUR1/X9TKmobzdN2VCPnBWvHG1gJLq
         89W9YIj1KgT5t3ro2sspAO083P6rFn8yt7m1Yx2qSVIr846tFaLtHPYTcAevbqHJ32Dy
         aRog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Becet34HA9AMGmgieFPyONEJRmnsBg3Xef/c13+mEd0=;
        b=fZsyV3O4TSPTR5U/SE1o2Nd0VxK9Y2jNU7Oh9CqzyI/casofmjlWZXMqCezpj6ooVg
         6K2/xtioXfcWV3BwGf6Cs/Asx9iLAF4o8lV+WBPKkYLmHKETJlTx6KKOWIay6CFJY27I
         n/SlRY4wtydpveaJU7wsVK4pDnW62qHKPJf/HHtfjqIDgLS34rqJ0dygd5yntIXCbAbb
         oY96y4vkX0mFCQIjtsyTOmfgvxHpo6bNAbvJvboQSIv/J32w6nb9EG+Rkr2am/pWiSpO
         S9vxometPD7EsjLMP2U6YGH95hKNa+3gjl3H/se8t6h18PP1wNAPmtqhPNg9Bk6KpLI5
         5ITQ==
X-Gm-Message-State: AOAM531Ii3ncRzSZssKZav14uO9vB/Fj/coB22zlaZcxdA9y8mrvxLNo
        PqKNMf6QispvpfGv8uvbVHsvyg==
X-Google-Smtp-Source: ABdhPJyFPBgGciCP7poW3cVKqQ2Ps2Rz1mJkD/MULTjU7uc3Ihb2Dd/K/BkK5xkUjfAnut8xhHbmGA==
X-Received: by 2002:a19:dc0f:0:b0:439:702c:d83b with SMTP id t15-20020a19dc0f000000b00439702cd83bmr5631283lfg.192.1647605350838;
        Fri, 18 Mar 2022 05:09:10 -0700 (PDT)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id n5-20020a196f45000000b004487ff4c12esm819993lfk.105.2022.03.18.05.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 05:09:09 -0700 (PDT)
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
In-Reply-To: <20220318111150.2g2pjcajjqhpr3wk@skbuf>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
 <87ilsxo052.fsf@waldekranz.com> <20220317140525.e2iqiy2hs3du763l@skbuf>
 <87k0crk7zg.fsf@waldekranz.com> <20220318111150.2g2pjcajjqhpr3wk@skbuf>
Date:   Fri, 18 Mar 2022 13:09:08 +0100
Message-ID: <87h77vjwd7.fsf@waldekranz.com>
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

On Fri, Mar 18, 2022 at 13:11, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Mar 18, 2022 at 08:58:11AM +0100, Tobias Waldekranz wrote:
>> On Thu, Mar 17, 2022 at 16:05, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > Hello Tobias,
>> >
>> > On Tue, Mar 01, 2022 at 10:04:09PM +0100, Tobias Waldekranz wrote:
>> >> On Tue, Mar 01, 2022 at 09:14, Florian Fainelli <f.fainelli@gmail.com> wrote:
>> >> > On 3/1/2022 4:31 AM, Mattias Forsblad wrote:
>> >> >> Greetings,
>> >> >> 
>> >> >> This series implements a new bridge flag 'local_receive' and HW
>> >> >> offloading for Marvell mv88e6xxx.
>> >> >> 
>> >> >> When using a non-VLAN filtering bridge we want to be able to limit
>> >> >> traffic to the CPU port to lessen the CPU load. This is specially
>> >> >> important when we have disabled learning on user ports.
>> >> >> 
>> >> >> A sample configuration could be something like this:
>> >> >> 
>> >> >>         br0
>> >> >>        /   \
>> >> >>     swp0   swp1
>> >> >> 
>> >> >> ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
>> >> >> ip link set swp0 master br0
>> >> >> ip link set swp1 master br0
>> >> >> ip link set swp0 type bridge_slave learning off
>> >> >> ip link set swp1 type bridge_slave learning off
>> >> >> ip link set swp0 up
>> >> >> ip link set swp1 up
>> >> >> ip link set br0 type bridge local_receive 0
>> >> >> ip link set br0 up
>> >> >> 
>> >> >> The first part of the series implements the flag for the SW bridge
>> >> >> and the second part the DSA infrastructure. The last part implements
>> >> >> offloading of this flag to HW for mv88e6xxx, which uses the
>> >> >> port vlan table to restrict the ingress from user ports
>> >> >> to the CPU port when this flag is cleared.
>> >> >
>> >> > Why not use a bridge with VLAN filtering enabled? I cannot quite find it 
>> >> > right now, but Vladimir recently picked up what I had attempted before 
>> >> > which was to allow removing the CPU port (via the bridge master device) 
>> >> > from a specific group of VLANs to achieve that isolation.
>> >> >
>> >> 
>> >> Hi Florian,
>> >> 
>> >> Yes we are aware of this work, which is awesome by the way! For anyone
>> >> else who is interested, I believe you are referring to this series:
>> >> 
>> >> https://lore.kernel.org/netdev/20220215170218.2032432-1-vladimir.oltean@nxp.com/
>> >> 
>> >> There are cases though, where you want a TPMR-like setup (or "dumb hub"
>> >> mode, if you will) and ignore all tag information.
>> >> 
>> >> One application could be to use a pair of ports on a switch as an
>> >> ethernet extender/repeater for topologies that span large physical
>> >> distances. If this repeater is part of a redundant topology, you'd to
>> >> well to disable learning, in order to avoid dropping packets when the
>> >> surrounding active topology changes. This, in turn, will mean that all
>> >> flows will be classified as unknown unicast. For that reason it is very
>> >> important that the CPU be shielded.
>> >
>> > So have you seriously considered making the bridge ports that operate in
>> > 'dumb hub' mode have a pvid which isn't installed as a 'self' entry on
>> > the bridge device?
>> 
>> Just so there's no confusion, you mean something like...
>> 
>>     ip link add dev br0 type bridge vlan_filtering 1 vlan_default_pvid 0
>> 
>>     for p in swp0 swp1; do
>>         ip link set dev $p master br0
>>         bridge vlan add dev $p vid 1 pvid untagged
>>     done
>> 
>> ... right?
>> 
>> In that case, the repeater is no longer transparent with respect to
>> tagged packets, which the application requires.
>
> If you are sure that there exists one VLAN ID which is never used (like
> 4094), what you could do is you could set the port pvids to that VID
> instead of 1, and add the entire VLAN_N_VID range sans that VID in the
> membership list of the two ports, as egress-tagged.

Yeah, I've thought about this too. If the device's only role is to act
as a repeater, then you can get away with it. But you will have consumed
all rows in the VTU and half of the rows in the ATU (we add an entry for
the broadcast address in every FID). So if you want to use your other
ports for regular bridging you're left with a very limited feature set.

> This is 'practical transparency' - if true transparency is required then
> yes, this doesn't work.
>
>> >> You might be tempted to solve this using flooding filters of the
>> >> switch's CPU port, but these go out the window if you have another
>> >> bridge configured, that requires that flooding of unknown traffic is
>> >> enabled.
>> >
>> > Not if CPU flooding can be managed on a per-user-port basis.
>> 
>> True, but we aren't lucky enough to have hardware that can do that :)
>> 
>> >> Another application is to create a similar setup, but with three ports,
>> >> and have the third one be used as a TAP.
>> >
>> > Could you expand more on this use case?
>> 
>> Its just the standard use-case for a TAP really. You have some link of
>> interest that you want to snoop, but for some reason there is no way of
>> getting a PCAP from the station on either side:
>> 
>>    Link of interest
>>           |
>> .-------. v .-------.
>> | Alice +---+  Bob  |
>> '-------'   '-------'
>> 
>> So you insert a hub in the middle, and listen on a third port:
>> 
>> .-------.   .-----.   .-------.
>> | Alice +---+ TAP +---+  Bob  |
>> '-------'   '--+--'   '-------'
>>                |
>>  PC running tcpdump/wireshark
>> 
>> The nice thing about being able to set this up in Linux is that if your
>> hardware comes with a mix of media types, you can dynamically create the
>> TAP for the job at hand. E.g. if Alice and Bob are communicating over a
>> fiber, but your PC only has a copper interface, you can bridge to fiber
>> ports with one copper; if you need to monitor a copper link 5min later,
>> you just swap out the fiber ports for two copper ports.
>> 
>> >> >> Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
>> >> >
>> >> > I don't believe this tag has much value since it was presumably carried 
>> >> > over from an internal review. Might be worth adding it publicly now, though.
>> >> 
>> >> I think Mattias meant to replicate this tag on each individual
>> >> patch. Aside from that though, are you saying that a tag is never valid
>> >> unless there is a public message on the list from the signee? Makes
>> >> sense I suppose. Anyway, I will send separate tags for this series.
