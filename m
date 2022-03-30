Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14CCF4EC31E
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 14:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbiC3MWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 08:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244674AbiC3MUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 08:20:11 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A892D28255D
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 05:09:23 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bq8so27126281ejb.10
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 05:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VQZNTn4chB8HsIhd2R2geeeG8uDU3P3wHFpVmodVoH4=;
        b=nHEb7vSCy4NzuRejiTYc7hRVjo1kWtL+i0lDNqmnzjjUkeWbrFqSFRgahMiY9r99WF
         S4n9uMOVsU0/loIf1vZVLzWoK/2SrgUs8Z3oEcAb0TxcHDAU9c5yAahbRoD/HiH2QUpr
         x4nXEjVd/CA0+a4z7zf/w5eAoseAVCoyMJ1ExWJiRnGij79sEMCJYtKyMqQpoB3wNtRi
         EvYNUlr6uZJlbo7rlf2YronbYfdUCXHeFTnI0BjePAowU/6+Q1j5pS8RYGmVKFqO2VBx
         UoOYe8o2uLbChqE6CVIqnMD22BJA3jMcUtkOMddRKPiXkgge9U/dv4Y4POVRWje+FK6u
         opZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VQZNTn4chB8HsIhd2R2geeeG8uDU3P3wHFpVmodVoH4=;
        b=n1mTkP6Pd+xDbg7VqOwYzmwJjZ041ncjCOJjduSbAttmQjuOmObUpiJKu4v8bvYJDa
         MtzcIUZ5BHLzEj8Y1GpVDX82b1zvejYx0S7mf9vEhytrVQO7WpOMPeVHDgC7KvfECge5
         cwrOuKHRAOE0KDBJGsZu+qEGZ+2+2K+DtKmnV5dyReExa6IMeQO2Z07doY4ytqz+lH6M
         Tvy9S/VZxUi7iWX0J/TW1utWDvjzKM5f7GflK6OQ/gDYYMwPZK+jZAVfDcOSRGnpT9c8
         V3cLOyxs2Yirwa+EORIuBb8ni29rCHU+ZC5yaRHZvfNkQhP4rtEJbyDAAFNtOgScHJ6L
         1yPA==
X-Gm-Message-State: AOAM5311KNU/xHWIO5GYJcfanbUOkEl1Dgq8gA/3JhuObj22A46CpwSa
        fnlYZkJhxx0nJuUbgEqeYzc=
X-Google-Smtp-Source: ABdhPJyHGff1+urOp9Wm2VWD8AKOJSJ1Z/1a5NLJf9K9G9kDZFRGQUBbTefYxsh2ypftzluLjzVt9w==
X-Received: by 2002:a17:906:68c2:b0:6b4:9f26:c099 with SMTP id y2-20020a17090668c200b006b49f26c099mr39983172ejr.41.1648642161466;
        Wed, 30 Mar 2022 05:09:21 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7c7c3000000b00410d407da2esm1908588eds.13.2022.03.30.05.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 05:09:20 -0700 (PDT)
Date:   Wed, 30 Mar 2022 15:09:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Mattias Forsblad <mattias.forsblad@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [RFC PATCH net-next 0/2] net: tc: dsa: Implement offload of
 matchall for bridged DSA ports
Message-ID: <20220330120919.ibmwui3jwfexjes4@skbuf>
References: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220330113116.3166219-1-mattias.forsblad@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 01:31:14PM +0200, Mattias Forsblad wrote:
> Greetings,
> 
> This series implements offloading of tc matchall filter to HW
> for bridged DSA ports.
> 
> Background
> When using a non-VLAN filtering bridge we want to be able to drop
> traffic directed to the CPU port so that the CPU doesn't get unnecessary loaded.
> This is specially important when we have disabled learning on user ports.
> 
> A sample configuration could be something like this:
> 
>        br0
>       /   \
>    swp0   swp1
> 
> ip link add dev br0 type bridge stp_state 0 vlan_filtering 0
> ip link set swp0 master br0
> ip link set swp1 master br0
> ip link set swp0 type bridge_slave learning off
> ip link set swp1 type bridge_slave learning off
> ip link set swp0 up
> ip link set swp1 up
> ip link set br0 up
> 
> After discussions here: https://lore.kernel.org/netdev/YjMo9xyoycXgSWXS@shredder/
> it was advised to use tc to set an ingress filter that could then
> be offloaded to HW, like so:
> 
> tc qdisc add dev br0 clsact
> tc filter add dev br0 ingress pref 1 proto all matchall action drop
> 
> Limitations
> If there is tc rules on a bridge and all the ports leave the bridge
> and then joins the bridge again, the indirect framwork doesn't seem
> to reoffload them at join. The tc rules need to be torn down and
> re-added.
> 
> The first part of this serie uses the flow indirect framework to
> setup monitoring of tc qdisc and filters added to a bridge.
> The second part offloads the matchall filter to HW for Marvell
> switches.
> 
> Mattias Forsblad (2):
>   net: tc: dsa: Add the matchall filter with drop action for bridged DSA ports.
>   net: dsa: Implement tc offloading for drop target.
> 
>  drivers/net/dsa/mv88e6xxx/chip.c |  23 +++-
>  include/net/dsa.h                |  13 ++
>  net/dsa/dsa2.c                   |   5 +
>  net/dsa/dsa_priv.h               |   3 +
>  net/dsa/port.c                   |   1 +
>  net/dsa/slave.c                  | 217 ++++++++++++++++++++++++++++++-
>  6 files changed, 258 insertions(+), 4 deletions(-)
> 
> -- 
> 2.25.1
> 

Have you considered point b of my argument here?
https://patchwork.kernel.org/project/netdevbpf/patch/20220317065031.3830481-5-mattias.forsblad@gmail.com/#24782383

To make that argument even clearer, the following script produces:

#!/bin/bash

ip netns add ns0
ip netns add ns1
ip link add veth0 type veth peer name veth1
ip link add veth2 type veth peer name veth3
ip link add br0 type bridge && ip link set br0 up
ip link set veth0 netns ns0
ip link set veth3 netns ns1
ip -n ns0 addr add 192.168.100.1/24 dev veth0 && ip -n ns0 link set veth0 up
ip -n ns1 addr add 192.168.100.2/24 dev veth3 && ip -n ns1 link set veth3 up
ip addr add 192.168.100.3/24 dev br0
ip link set veth1 master br0 && ip link set veth1 up
ip link set veth2 master br0 && ip link set veth2 up
tc qdisc add dev br0 clsact
tc filter add dev br0 ingress matchall action drop
echo "Pinging another bridge port" && ip netns exec ns0 ping -c 3 192.168.100.2
echo "Pinging the bridge" && ip netns exec ns0 ping -c 3 192.168.100.3
ip netns del ns0
ip netns del ns1
ip link del br0

[ 1857.000393] br0: port 1(veth1) entered blocking state
[ 1857.005537] br0: port 1(veth1) entered disabled state
[ 1857.011433] device veth1 entered promiscuous mode
[ 1857.047291] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
[ 1857.054019] br0: port 1(veth1) entered blocking state
[ 1857.059205] br0: port 1(veth1) entered forwarding state
[ 1857.064791] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[ 1857.124507] br0: port 2(veth2) entered blocking state
[ 1857.129658] br0: port 2(veth2) entered disabled state
[ 1857.135585] device veth2 entered promiscuous mode
[ 1857.209748] br0: port 2(veth2) entered blocking state
[ 1857.214900] br0: port 2(veth2) entered forwarding state
[ 1857.220680] IPv6: ADDRCONF(NETDEV_CHANGE): veth3: link becomes ready
Pinging another bridge port
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
64 bytes from 192.168.100.2: icmp_seq=1 ttl=64 time=0.508 ms
64 bytes from 192.168.100.2: icmp_seq=2 ttl=64 time=0.222 ms
64 bytes from 192.168.100.2: icmp_seq=3 ttl=64 time=0.405 ms

--- 192.168.100.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2051ms
rtt min/avg/max/mdev = 0.222/0.378/0.508/0.118 ms
Pinging the bridge
PING 192.168.100.3 (192.168.100.3) 56(84) bytes of data.
^C
--- 192.168.100.3 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2040ms

filter protocol all pref 49152 matchall chain 0
filter protocol all pref 49152 matchall chain 0 handle 0x1
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1 installed 12 sec used 6 sec
        Action statistics:
        Sent 936 bytes 16 pkt (dropped 16, overlimits 0 requeues 0)
        backlog 0b 0p requeues 0

[ 1870.189158] br0: port 1(veth1) entered disabled state
[ 1870.204061] device veth1 left promiscuous mode
[ 1870.208751] br0: port 1(veth1) entered disabled state
[ 1870.232677] device veth2 left promiscuous mode
[ 1870.237814] br0: port 2(veth2) entered disabled state

Now imagine that veth0 is a DSA switch interface which monitors and
offloads the drop rule. How could it distinguish between pinging veth3
and pinging br0, so as to comply with software semantics?
