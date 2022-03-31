Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097DA4ED52F
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiCaIIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiCaIIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:08:12 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60FEFD16
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:06:23 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id p15so40047743lfk.8
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GiOKcvxrYk9kL4NA4yphL6GBfyykUgWRL0QO9jrahHo=;
        b=HFMuBfL4jMEbjxUUEO9YGtY/S3V9zi2P44ncaeJr7U+c5D2X+rPK8XNWwDeVlO4m7a
         80keey6zI85P+8yaqzo9laMaeq57mKwPaUeJOb5fVZyWpJulyg9CzfLl0oX3kRdU1kHD
         PHE7YTMTSShS+Zfth6ywrdM7z6aZaHp9a1mr8vF1xh/iZ4aIxORuDWqLQEJbvONtWtxP
         SAoUga0zxRq2FI+7QJGctmnWhnI09/8lcYbtzK/QoctBpow/zaPQE0dOdmM0GXn95lLs
         r4llWgcq5UnHr91fvD6XLGTnhaes75Rb7QFC8gDt/E86tIOwFBb+QjTAqe9X1C90BXzt
         2xig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GiOKcvxrYk9kL4NA4yphL6GBfyykUgWRL0QO9jrahHo=;
        b=bxftKuLSkiXs1i1e80lFxKL/wwGM6Nupt/S0bXv0zKskyusxJ0l95AvP5acOgqxg1s
         BDa7clUPzDUtsAwDfXLKMc5Z7LU+GrvbOYnB49k7CoUJflnSPfink9W3zY3BK8chtfvI
         o8gtl2Rbjg4W/pT8/4rRTWHFz2IVAG3YGkiCTBmaGIDFz8ITj24SNx0At/uKJDk0o2QJ
         dd/GKiqo/YckpkBLHbHTQTdEXCKMp9qLVXnkwhjC+pbnHvlCB1D/a+imdiCAPC1gInD5
         iJ4Dxnsiq+Fy+jryuDl5aHOvU65u7rgVvDjqsV+BA5HkR5auJCMvgLQSczIgvE2Vpm7I
         Kmzg==
X-Gm-Message-State: AOAM532lcM2t6ctebx1pcoX6LAc72I88zWP1yRvlTC01HhrYe/sm0Kha
        JL5ocybjz50unhi5ieTLlT4gyXi6qV/C2w==
X-Google-Smtp-Source: ABdhPJxOkOCGWQvWV4+V8ayILHJZEEh20drbo2/GN7jU8iESBEeIHWgjaL5DN049HW+s210mSrh60Q==
X-Received: by 2002:a05:6512:3a83:b0:44a:5878:24d6 with SMTP id q3-20020a0565123a8300b0044a587824d6mr9640107lfu.426.1648713981919;
        Thu, 31 Mar 2022 01:06:21 -0700 (PDT)
Received: from [10.0.1.14] (h-98-128-237-157.A259.priv.bahnhof.se. [98.128.237.157])
        by smtp.gmail.com with ESMTPSA id q10-20020a196e4a000000b0044ac90ec3fcsm239561lfk.79.2022.03.31.01.06.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 01:06:21 -0700 (PDT)
Message-ID: <744ca0a6-95a3-cc81-5b09-ff417ffde401@gmail.com>
Date:   Thu, 31 Mar 2022 10:06:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH net-next 0/2] net: tc: dsa: Implement offload of
 matchall for bridged DSA ports
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
References: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
 <20220330120919.ibmwui3jwfexjes4@skbuf>
From:   Mattias Forsblad <mattias.forsblad@gmail.com>
In-Reply-To: <20220330120919.ibmwui3jwfexjes4@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-03-30 14:09, Vladimir Oltean wrote:
> On Wed, Mar 30, 2022 at 01:31:14PM +0200, Mattias Forsblad wrote:
>> Greetings,
>>
>> This series implements offloading of tc matchall filter to HW
>> for bridged DSA ports.
>>
>> Background
>> When using a non-VLAN filtering bridge we want to be able to drop
>> traffic directed to the CPU port so that the CPU doesn't get unnecessary loaded.
>> This is specially important when we have disabled learning on user ports.
>>
>> A sample configuration could be something like this:
>>
>>        br0
>>       /   \
>>    swp0   swp1
>>
>> ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
>> ip link set swp0 master br0
>> ip link set swp1 master br0
>> ip link set swp0 type bridge_slave learning off
>> ip link set swp1 type bridge_slave learning off
>> ip link set swp0 up
>> ip link set swp1 up
>> ip link set br0 up
>>
>> After discussions here: https://lore.kernel.org/netdev/YjMo9xyoycXgSWXS@shredder/
>> it was advised to use tc to set an ingress filter that could then
>> be offloaded to HW, like so:
>>
>> tc qdisc add dev br0 clsact
>> tc filter add dev br0 ingress pref 1 proto all matchall action drop
>>
>> Limitations
>> If there is tc rules on a bridge and all the ports leave the bridge
>> and then joins the bridge again, the indirect framwork doesn't seem
>> to reoffload them at join. The tc rules need to be torn down and
>> re-added.
>>
>> The first part of this serie uses the flow indirect framework to
>> setup monitoring of tc qdisc and filters added to a bridge.
>> The second part offloads the matchall filter to HW for Marvell
>> switches.
>>
>> Mattias Forsblad (2):
>>   net: tc: dsa: Add the matchall filter with drop action for bridged DSA ports.
>>   net: dsa: Implement tc offloading for drop target.
>>
>>  drivers/net/dsa/mv88e6xxx/chip.c |  23 +++-
>>  include/net/dsa.h                |  13 ++
>>  net/dsa/dsa2.c                   |   5 +
>>  net/dsa/dsa_priv.h               |   3 +
>>  net/dsa/port.c                   |   1 +
>>  net/dsa/slave.c                  | 217 ++++++++++++++++++++++++++++++-
>>  6 files changed, 258 insertions(+), 4 deletions(-)
>>
>> -- 
>> 2.25.1
>>
> 
> Have you considered point b of my argument here?
> https://patchwork.kernel.org/project/netdevbpf/patch/20220317065031.3830481-5-mattias.forsblad@gmail.com/#24782383
> 
> To make that argument even clearer, the following script produces:
> 
> #!/bin/bash
> 
> ip netns add ns0
> ip netns add ns1
> ip link add veth0 type veth peer name veth1
> ip link add veth2 type veth peer name veth3
> ip link add br0 type bridge && ip link set br0 up
> ip link set veth0 netns ns0
> ip link set veth3 netns ns1
> ip -n ns0 addr add 192.168.100.1/24 dev veth0 && ip -n ns0 link set veth0 up
> ip -n ns1 addr add 192.168.100.2/24 dev veth3 && ip -n ns1 link set veth3 up
> ip addr add 192.168.100.3/24 dev br0
> ip link set veth1 master br0 && ip link set veth1 up
> ip link set veth2 master br0 && ip link set veth2 up
> tc qdisc add dev br0 clsact
> tc filter add dev br0 ingress matchall action drop
> echo "Pinging another bridge port" && ip netns exec ns0 ping -c 3 192.168.100.2
> echo "Pinging the bridge" && ip netns exec ns0 ping -c 3 192.168.100.3
> ip netns del ns0
> ip netns del ns1
> ip link del br0
> 
> [ 1857.000393] br0: port 1(veth1) entered blocking state
> [ 1857.005537] br0: port 1(veth1) entered disabled state
> [ 1857.011433] device veth1 entered promiscuous mode
> [ 1857.047291] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
> [ 1857.054019] br0: port 1(veth1) entered blocking state
> [ 1857.059205] br0: port 1(veth1) entered forwarding state
> [ 1857.064791] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
> [ 1857.124507] br0: port 2(veth2) entered blocking state
> [ 1857.129658] br0: port 2(veth2) entered disabled state
> [ 1857.135585] device veth2 entered promiscuous mode
> [ 1857.209748] br0: port 2(veth2) entered blocking state
> [ 1857.214900] br0: port 2(veth2) entered forwarding state
> [ 1857.220680] IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready
> Pinging another bridge port
> PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
> 64 bytes from 192.168.100.2: icmp_seq=1 ttl=64 time=0.508 ms
> 64 bytes from 192.168.100.2: icmp_seq=2 ttl=64 time=0.222 ms
> 64 bytes from 192.168.100.2: icmp_seq=3 ttl=64 time=0.405 ms
> 
> --- 192.168.100.2 ping statistics ---
> 3 packets transmitted, 3 received, 0% packet loss, time 2051ms
> rtt min/avg/max/mdev = 0.222/0.378/0.508/0.118 ms
> Pinging the bridge
> PING 192.168.100.3 (192.168.100.3) 56(84) bytes of data.
> ^C
> --- 192.168.100.3 ping statistics ---
> 3 packets transmitted, 0 received, 100% packet loss, time 2040ms
> 
> filter protocol all pref 49152 matchall chain 0
> filter protocol all pref 49152 matchall chain 0 handle 0x1
>   not_in_hw
>         action order 1: gact action drop
>          random type none pass val 0
>          index 1 ref 1 bind 1 installed 12 sec used 6 sec
>         Action statistics:
>         Sent 936 bytes 16 pkt (dropped 16, overlimits 0 requeues 0)
>         backlog 0b 0p requeues 0
> 
> [ 1870.189158] br0: port 1(veth1) entered disabled state
> [ 1870.204061] device veth1 left promiscuous mode
> [ 1870.208751] br0: port 1(veth1) entered disabled state
> [ 1870.232677] device veth2 left promiscuous mode
> [ 1870.237814] br0: port 2(veth2) entered disabled state
> 
> Now imagine that veth0 is a DSA switch interface which monitors and
> offloads the drop rule. How could it distinguish between pinging veth3
> and pinging br0, so as to comply with software semantics?

Hi Vladimir,
thanks for your comments. The patch series takes in account that a foreign
interface is bridged and doesn't offload the rule in this case (dsa_slave_check_offload).

Regarding your previous comment point b. Tobias could see some problems
with that approach. I'd think he will comment on that.
