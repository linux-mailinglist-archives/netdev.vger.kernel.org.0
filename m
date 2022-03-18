Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4964DDEE9
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239022AbiCRQ34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239284AbiCRQ2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:28:16 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8808EB45
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:26:56 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id r13so18033649ejd.5
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l7+B+GrWpRJmrdy4BeC8GMIxDHWVtQ3y8UP7nmH06fs=;
        b=Fzk2DkEyldlgMu5B/4kd0nSE7BgcnHuXTJS5y2+YYaeUbtgnT9dzYmG1RXKIq9pkOd
         M11y360IrYt8UfN4wKUXLl43PQKR2F4VxUMtt3T7u6rXKb0MajP1wqLcNU1OjruuCN2f
         WtCdVOb88VUozbKGCHp6bL01y6bl0YIa0b4hpR1WccnCsd+hayiERmtKMKQBAiNH02tR
         rq2DVcS4M/zHlsT6FKC1sfhWaGyzxL5u8nQ5Wp/AmcuLDcaXKYx5Rn6SHjmhkjIg3O9K
         z57LKo0X7WBB7ZRbezbEdYPbKX7Ey3Hld+/HJoHjttckZHlXxBbMDvL+ZuMP5J34bFrr
         JeRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l7+B+GrWpRJmrdy4BeC8GMIxDHWVtQ3y8UP7nmH06fs=;
        b=Kh0/Y0kTZ8k7Xx3QnsgdfXDLTcI3MdbZv/TI+3lmi1e1g2pGqWvsjm7Oj8QBFlEQkh
         9gGC0+zXSpjVxM4jtRHJFu4EmVTG1PxYq0lCB/ELvVLqriOWUvhtCpR1kp/Nxitce4kc
         AnGC2YPrXTqvY3tCIxXsum5kCJ3nfOJYfqjyJnAAcE+erDLa5AFlUR8jwOfBDmOzPhMf
         7neQ95CdbS56PumSf6p7ZwUPcI6/TY3ai3xNMwNWrOK/gBVrx4A27oQJUQcDQnKSfOum
         P3BKUScvi7SmcchLaSe2o8xbi9sJSmNkcCmn4ZDfz55AGA/hPhPVc5d2zPtAIpBwYFHU
         83JA==
X-Gm-Message-State: AOAM533Z+9bOfpSS/V/8h9ht6CuBGHcP2sAwAdwhJUmDWYZNJcHp6b9H
        pLubtruidiPIPmWqmJykpso=
X-Google-Smtp-Source: ABdhPJwAhgviqSnlSEHCMinVyqvoI5QriP1T4VmDKkKRERXFEqn6b790g1CBENMMtM20rVHIJYW3Rg==
X-Received: by 2002:a17:907:6089:b0:6db:a3d7:3fa9 with SMTP id ht9-20020a170907608900b006dba3d73fa9mr10076477ejc.593.1647620815156;
        Fri, 18 Mar 2022 09:26:55 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id y8-20020a50eb08000000b00418b114469csm4434893edp.52.2022.03.18.09.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 09:26:54 -0700 (PDT)
Date:   Fri, 18 Mar 2022 18:26:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
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
Message-ID: <20220318162653.b2myvmiurlfdxj6d@skbuf>
References: <20220301123104.226731-1-mattias.forsblad+netdev@gmail.com>
 <2d38e998-396f-db39-7ccf-2a991d4e02cb@gmail.com>
 <87ilsxo052.fsf@waldekranz.com>
 <20220317140525.e2iqiy2hs3du763l@skbuf>
 <87k0crk7zg.fsf@waldekranz.com>
 <20220318111150.2g2pjcajjqhpr3wk@skbuf>
 <87h77vjwd7.fsf@waldekranz.com>
 <20220318124451.jdclhe2dlgvggemr@skbuf>
 <87ee2zjlik.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee2zjlik.fsf@waldekranz.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 05:03:31PM +0100, Tobias Waldekranz wrote:
> On Fri, Mar 18, 2022 at 14:44, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Fri, Mar 18, 2022 at 01:09:08PM +0100, Tobias Waldekranz wrote:
> >> >> > So have you seriously considered making the bridge ports that operate in
> >> >> > 'dumb hub' mode have a pvid which isn't installed as a 'self' entry on
> >> >> > the bridge device?
> >> >> 
> >> >> Just so there's no confusion, you mean something like...
> >> >> 
> >> >>     ip link add dev br0 type bridge vlan_filtering 1 vlan_default_pvid 0
> >> >> 
> >> >>     for p in swp0 swp1; do
> >> >>         ip link set dev $p master br0
> >> >>         bridge vlan add dev $p vid 1 pvid untagged
> >> >>     done
> >> >> 
> >> >> ... right?
> >> >> 
> >> >> In that case, the repeater is no longer transparent with respect to
> >> >> tagged packets, which the application requires.
> >> >
> >> > If you are sure that there exists one VLAN ID which is never used (like
> >> > 4094), what you could do is you could set the port pvids to that VID
> >> > instead of 1, and add the entire VLAN_N_VID range sans that VID in the
> >> > membership list of the two ports, as egress-tagged.
> >> 
> >> Yeah, I've thought about this too. If the device's only role is to act
> >> as a repeater, then you can get away with it. But you will have consumed
> >> all rows in the VTU and half of the rows in the ATU (we add an entry for
> >> the broadcast address in every FID). So if you want to use your other
> >> ports for regular bridging you're left with a very limited feature set.
> >
> > But VLANs in other bridges would reuse the same FIDs, at least in the
> > current mv88e6xxx implementation with no FDB isolation, no? So even
> > though the VTU is maxed out, it wouldn't get 'more' maxed out.
> 
> I'm pretty sure that mv88e6xxx won't allow the same VID to be configured
> on multiple bridges. A quick test seems to support that:
> 
>    root@coronet:~# ip link add dev br0 type bridge vlan_filtering 1
>    root@coronet:~# ip link add dev br1 type bridge vlan_filtering 1
>    root@coronet:~# ip link set dev br0 up
>    root@coronet:~# ip link set dev br1 up
>    root@coronet:~# ip link set dev swp1 master br0
>    root@coronet:~# ip link set dev swp2 master br1
>    RTNETLINK answers: Operation not supported

Ok, I forgot about mv88e6xxx_port_check_hw_vlan() even though I was
there on multiple occasions. Thanks for reminding me.

> > As for the broadcast address needing to be present in the ATU, honestly
> > I don't know too much about that. I see that some switches have a
> > FloodBC bit, wouldn't that be useful?
> 
> mv88e6xxx can handle broadcast in two ways:
> 
> 1. Always flood broadcast, independent of all other settings.
> 
> 2. Treat broadcast as multicast, only allow flooding if unknown
>    multicast is allowed on the port, or if there's an entry in the ATU
>    (making it known) that allows it.
> 
> The kernel driver uses (2), because that is the only way (I know of)
> that we can support the BCAST_FLOOD flag. In order to make BCAST_FLOOD
> independent of MCAST_FLOOD, we have to load an entry allowing bc to
> egress on all ports by default. De Morgan comes back to guide us once
> more :)

Ok, so this alternative falls flat on its face due to excessive resource
usage. Next...

Does your application require bridged foreign interfaces with the other
switch ports? In other words, is there a reason to keep the CPU port in
the flood domain of the switch, other than current software limitations?
