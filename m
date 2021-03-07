Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD79330511
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 23:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhCGWth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 17:49:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhCGWtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 17:49:24 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00511C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 14:49:23 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id r25so12719901ljk.11
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 14:49:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=xGcF6VO6RhqxnWdds4o7BAkI6oY3+KGANwy1vOAjnOE=;
        b=I7ZTqO7YiTj+ZpeRW7dHkg3CMameJsAjLiO12cBoDaLqucFcMtXQ/0JdA39RWdTWWI
         9V7mVtTNSo5fBxzvDMseRfKxj3ama3DemZWcz/wp920hBtcRAQFaAyCIltH0jYXT8HZ8
         nER8M8p3rxQuSM8Jph9j9cVT+DwzXIc7Cw4B8RLDEKHAqObSX/Riz0GSrwxElA5BYj+/
         RLENJ+zkHcmFCR9dIaEr121zQeacq5UGKbtMsGfIvDWQjRUiQMpMy/RxRP9muvvFC/m0
         b1fSDkv9/GfDrsvMAW1y57gjcFfnMXDupgJEhLyxA3lcjIfSggsRe5Hrr2+ZK+NZWdtR
         W72g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xGcF6VO6RhqxnWdds4o7BAkI6oY3+KGANwy1vOAjnOE=;
        b=KgYLxWLL9qexUFLA98ba3S6UABrr7/RMaXwGzZpGgjYzv8cWlM8o5vU++G+RtJVLMf
         XKzIF7qi0DBBLXQFa75SuvQ23xfXUvWGPqbFlF+2kG1+0J8ySNswUxgXskp/yfScMtIG
         QjySEU4kk+qkYZV4qANSDmsj9gXP7VYpZja7dTRdVl2B3E89uGv4Ae3AlHZjf49Ie09V
         m5GeBYBD5K/QeKKR7lSYpqRJuECrVGeQzF/S0PfCjE4uVBty92weOlUdjCcziTeAZ37w
         cbNOeUTypgC/le67igK0E0ItyF7STSkzfJD5fbmJTSXpIGWY8CuxennO9BJvZ4NmMoIx
         CGHg==
X-Gm-Message-State: AOAM530ToSxjmExtiVTDe2xT1sGKuiV4+Yci0Y4cno6y6OxmvMYeBCP5
        B/+rj0M50eGsORW7OEjTr0PGMA==
X-Google-Smtp-Source: ABdhPJzZThLqjEAUIeGjaLGoU/rLOXCNW6+9l9W86niFmvkCfn3MnnKCsjmGYhzqbRLLQO1LuDQm1w==
X-Received: by 2002:a2e:535a:: with SMTP id t26mr11566322ljd.503.1615157362350;
        Sun, 07 Mar 2021 14:49:22 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id t200sm1170306lff.280.2021.03.07.14.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 14:49:22 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net] net: dsa: fix switchdev objects on bridge master mistakenly being applied on ports
In-Reply-To: <871rcqraui.fsf@waldekranz.com>
References: <20210307102156.2282877-1-olteanv@gmail.com> <874khnq9hh.fsf@waldekranz.com> <20210307154832.wcmbw7imachkdc3y@skbuf> <871rcqraui.fsf@waldekranz.com>
Date:   Sun, 07 Mar 2021 23:49:21 +0100
Message-ID: <87y2eypojy.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 07, 2021 at 21:02, Tobias Waldekranz <tobias@waldekranz.com> wrote:
> On Sun, Mar 07, 2021 at 17:48, Vladimir Oltean <olteanv@gmail.com> wrote:
>> On Sun, Mar 07, 2021 at 04:17:14PM +0100, Tobias Waldekranz wrote:
>>> Please wait before applying.
>>> 
>>> I need to do some more testing later (possibly tomorrow). But I am
>>> pretty sure that this patch does not work with the (admittedly somewhat
>>> exotic) combination of:
>>> 
>>> - Non-offloaded LAG
>>> - Bridge with VLAN filtering enabled.
>>> 
>>> When adding the LAG to the bridge, I get an error because mv88e6xxx
>>> tries to add VLAN 1 to the ports (which it should not do as the LAG is
>>> not offloaded).
>>
>> Weird, how are you testing, and why does it attempt to add VLAN 1? Is it
>> the mv88e6xxx driver itself that does this? Where from?
>>
>> The following is my test procedure:
>>
>> cat ./test_bond_no_offload.sh
>> #!/bin/bash
>>
>> ip link del bond0
>> for eth in swp0 swp1 swp2; do ip link set $eth down; done
>> ip link add bond0 type bond mode broadcast
>> ip link add br0 type bridge vlan_filtering 1
>> ip link set swp0 master bond0
>> ip link set swp1 master bond0
>> ip link set swp2 master br0
>> ip link set bond0 master br0
>> for eth in swp0 swp1 swp2 bond0 br0; do ip link set $eth up; done
>>
>> ./test_bond_no_offload.sh
>> [   27.004206] bond0 (unregistering): Released all slaves
>> [   27.068440] mscc_felix 0000:00:00.5 swp0: configuring for inband/qsgmii link mode
>> [   27.077811] 8021q: adding VLAN 0 to HW filter on device swp0
>> [   27.083728] bond0: (slave swp0): Enslaving as an active interface with an up link
>> Warning: dsa_core: Offloading not supported.
>> [   27.095035] mscc_felix 0000:00:00.5 swp1: configuring for inband/qsgmii link mode
>> [   27.104073] 8021q: adding VLAN 0 to HW filter on device swp1
>> [   27.109948] bond0: (slave swp1): Enslaving as an active interface with an up link
>> Warning: dsa_core: Offloading not supported.
>> [   27.120214] br0: port 1(swp2) entered blocking state
>> [   27.125407] br0: port 1(swp2) entered disabled state
>> [   27.131738] mscc_felix 0000:00:00.5: dsa_port_vlan_filtering: port 2 vlan_filtering 1
>> [   27.139625] mscc_felix 0000:00:00.5 swp2: dsa_slave_vlan_add: vid 1
>> [   27.149223] br0: port 2(bond0) entered blocking state
>> [   27.154341] br0: port 2(bond0) entered disabled state
>> [   27.159600] device bond0 entered promiscuous mode
>> [   27.164340] device swp0 entered promiscuous mode
>> [   27.169028] device swp1 entered promiscuous mode
>> [   27.173718] device swp2 entered promiscuous mode
>> [   27.187698] mscc_felix 0000:00:00.5 swp2: configuring for inband/qsgmii link mode
>> [   27.196312] 8021q: adding VLAN 0 to HW filter on device swp2
>> [   27.207605] 8021q: adding VLAN 0 to HW filter on device bond0
>> [   28.060872] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
>> [   28.067323] br0: port 2(bond0) entered blocking state
>> [   28.072406] br0: port 2(bond0) entered forwarding state
>> [   28.077751] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
>> # bridge link
>> 8: swp2@eth1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 master br0 state disabled priority 32 cost 100
>> 10: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 100
>> # bridge vlan add dev bond0 vid 100
>> # bridge vlan add dev swp2 vid 100
>> [   48.669422] mscc_felix 0000:00:00.5 swp2: dsa_slave_vlan_add: vid 100
>> # bridge vlan add dev br0 vid 100 self
>
> I ran the same test on my box (s/swp/eth/g just because that is what the
> ports are called on my board):
>
> root@envoy:~# dmesg -c
> root@envoy:~# ./test_bond_no_offload.sh
> Warning: dsa_core: Offloading not supported.
> Warning: dsa_core: Offloading not supported.
> RTNETLINK answers: Operation not supported
> root@envoy:~# dmesg -c
> [   40.392113] device eth3 left promiscuous mode
> [   40.392233] br0: port 1(eth3) entered disabled state
> [   40.468035] bond0 (unregistering): (slave eth1): Releasing backup interface
> [   40.480821] device eth1 left promiscuous mode
> [   40.487626] bond0 (unregistering): (slave eth2): Releasing backup interface
> [   40.508856] device eth2 left promiscuous mode
> [   40.508870] device chan0 left promiscuous mode
> [   40.515602] bond0 (unregistering): Released all slaves
> [   40.571520] mv88e6085 30be0000.ethernet-1:04 eth1: configuring for inband/2500base-x link mode
> [   40.574803] 8021q: adding VLAN 0 to HW filter on device eth1       
> [   40.576595] bond0: (slave eth1): Enslaving as an active interface with an up link    
> [   40.583908] mv88e6085 30be0000.ethernet-1:04 eth2: configuring for inband/sgmii link mode
> [   40.587225] 8021q: adding VLAN 0 to HW filter on device eth2 
> [   40.589014] bond0: (slave eth2): Enslaving as an active interface with an up link
> [   40.591622] br0: port 1(eth3) entered blocking state
> [   40.591642] br0: port 1(eth3) entered disabled state
> [   40.602894] br0: port 2(bond0) entered blocking state
> [   40.602931] br0: port 2(bond0) entered disabled state
> [   40.603172] device bond0 entered promiscuous mode
> [   40.603179] device eth1 entered promiscuous mode
> [   40.603183] device chan0 entered promiscuous mode
> [   40.603229] device eth2 entered promiscuous mode
> [   40.603284] device eth3 entered promiscuous mode
> [   40.605250] mv88e6085 30be0000.ethernet-1:04: p10: hw VLAN 1 already used by port 8 in br0
> [   40.605268] CPU: 0 PID: 1734 Comm: ip Not tainted 5.11.0 #197
> [   40.605276] Hardware name: lynx-2510 (DT)
> [   40.605281] Call trace: 
> [   40.605284]  dump_backtrace+0x0/0x1b0
> [   40.605301]  show_stack+0x20/0x70
> [   40.605310]  dump_stack+0xd0/0x12c
> [   40.605320]  mv88e6xxx_port_vlan_add+0x79c/0x810
> [   40.605333]  dsa_switch_event+0x600/0xc70
> [   40.605343]  raw_notifier_call_chain+0x5c/0x80
> [   40.605351]  dsa_tree_notify+0x1c/0x40
> [   40.605358]  dsa_port_vlan_add+0x58/0x80
> [   40.605365]  dsa_slave_vlan_rx_add_vid+0x80/0x130
> [   40.605372]  vlan_add_rx_filter_info+0x60/0x90
> [   40.605380]  vlan_vid_add+0xf4/0x1b0
> [   40.605386]  bond_vlan_rx_add_vid+0x78/0x110
> [   40.605394]  vlan_add_rx_filter_info+0x60/0x90
> [   40.605400]  vlan_vid_add+0xf4/0x1b0
> [   40.605406]  __vlan_add+0x6c8/0x840
> [   40.605415]  nbp_vlan_add+0xfc/0x180
> [   40.605423]  nbp_vlan_init+0x140/0x190
> [   40.605433]  br_add_if+0x558/0x740
> [   40.605440]  br_add_slave+0x1c/0x30
>
> (I added the dump_stack() just for demonstration purposes)
>
> So we are coming in from everyones favorite ndo: ndo_vlan_add_rx_vid!
>
> mv88e6xxx complains (rightly IMHO) that the hardware cannot offload VLAN
> 1 to two different bridges. It sees that eth3 is connected to br0, and
> the current port is trying to add the same VID to a different
> bridge. The second bridge in this case is in fact NULL.
>
> One could argue that mv88e6xxx could just skip config if dp->bridge_dev
> is not set. OTOH, the DSA layer manages all the intricacies of that in
> all other scenarios.
>
> Should we return early from the ndo if dp->bridge_dev is NULL? But then
> why do we implement those ndos at all?

If I understand Florian's original message (061f6a505ac3) correctly,
this was originally done to support HW that cannot control VLAN
filtering per port. I.e to support this setup:

  vlan1
    |
   br0     vlan2
  /   \      |
swp0  swp1  swp2

Where swp2 cannot be configured to ignore 1Q tags at the same time as
VLAN filtering is enabled on swp0 and swp1.

Florian, do I have that right?

If so, I think we can safely just `return 0` on these in mv88e6xxx (and
any other drivers where the HW can control this per port).

Adding a guard against configuring VLANs on unbridged user ports in
mv88e6xxx_port_vlan_add does seem to do the trick.
