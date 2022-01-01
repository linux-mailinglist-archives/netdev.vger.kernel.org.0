Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322B74827E8
	for <lists+netdev@lfdr.de>; Sat,  1 Jan 2022 17:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiAAQEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jan 2022 11:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiAAQEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Jan 2022 11:04:34 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F29C061574
        for <netdev@vger.kernel.org>; Sat,  1 Jan 2022 08:04:33 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b13so118806626edd.8
        for <netdev@vger.kernel.org>; Sat, 01 Jan 2022 08:04:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AR4qBgQPY1NhzwpJQrmQEwKtnBOmgSDQoo/xEaMNtF0=;
        b=n2WqMglcFVnzKGauA8AfdD8tNQ4FBdDK2w94Y02sNJ4mlRekng/e9/q4+eu5BY53tR
         gxnpSP6XRxttS9sOmi92xTFN7Vao6RseAWHMzs5zYvxo0/CAl91eQV5WIAc3i2tThaHl
         LmYJ1ZbaE7QKlzcrvDVuzD+iInXSbz2V9TPMMXOxbjy9vMNm6HAGBq+TzEl5QbEPJKB4
         ivINDZc0YTRTMwdAYXJJX4DvYh30lL0geaGqS8fMhFf+V/krI9AZNDk6gVUgWAd3ymwb
         a02M8Riv9Gnwepo/1edCnqCMxVtdgWUI3QTEyUzoPsXSAk7PQhXHKrnOcCw32c7CgHSb
         M1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AR4qBgQPY1NhzwpJQrmQEwKtnBOmgSDQoo/xEaMNtF0=;
        b=wYeLW3S3H+q1VxYJkFWCJn67zKq9vQOSQVdePd9SooUJpUIoCecXH1ipj+kpbstyad
         TnFabJ5j6C7kBPt2z+2aYibK8eaVvf/hr1Vu2c77XsDTIng4vkz0KZ+zPWc/KHJXODII
         XdvXQnhXwphon9cGAnNA53sXQhuTRo8McoZKVUy0wHyGlFfFO70BY0D5ZtQFDI0zUfk3
         6aEJcbIdgw89I0sLTj/VyTOOp38o12ht7sEX04cDlRJfoCdhrKK4L192aeUyB7ELiZKc
         5im4pFGy5RYDCEpwC8I7Nh3xGmpCGAn7ERfEFijZqpwLfSQnXjrZdz6XERIOCCMZUVyW
         O0hQ==
X-Gm-Message-State: AOAM5318mZhabhoVshA3oegGNI2y0sXoTcn245Uj/hnTe712AWeOaMzQ
        agSEv7IZ1/zIKFOr3AzhIug=
X-Google-Smtp-Source: ABdhPJxG12JVbZTYMBlpfrI3FDCREUtbm/4Wd5bkwNtAdL2EuLedzZKphE7wbNxFrlH1UA96Hdl5Dg==
X-Received: by 2002:aa7:d984:: with SMTP id u4mr38609283eds.300.1641053071450;
        Sat, 01 Jan 2022 08:04:31 -0800 (PST)
Received: from skbuf ([188.25.255.2])
        by smtp.gmail.com with ESMTPSA id qw4sm9287422ejc.55.2022.01.01.08.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Jan 2022 08:04:30 -0800 (PST)
Date:   Sat, 1 Jan 2022 18:04:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: packets trickling out of STP-blocked ports
Message-ID: <20220101160429.hmvjahhapob4gkol@skbuf>
References: <20211230230740.GA1510894@euler>
 <20211231002823.de3ugpurq3fv343b@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231002823.de3ugpurq3fv343b@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 02:28:23AM +0200, Vladimir Oltean wrote:
> Traditionally, DSA has made a design decision that all switch ports
> inherit the single MAC address of the DSA master. IOW, if you have 1 DSA
> master and 4 switch ports, you have 5 interfaces in the system with the
> same MAC address. It was like this for a long time, and relatively
> recently, Xiaofei Shen added the ability for individual DSA interfaces
> to have their own MAC address stored in the device tree.

I thought a bit more in the back of my head and I need to make a
correction to what I said. It doesn't matter that DSA interfaces have
the same MAC address, because swp2 and swp3 are both bridge ports, and
therefore, their MAC addresses are both local FDB entries, even if
unique. So the bridge would still complain that it receives packets with
a MAC SA equal to a local FDB entry.

ip link add veth0 type veth peer name veth1
ip link add br0 type bridge
ip link set veth0 master br0
[   84.987666] br0: port 1(veth0) entered blocking state
[   84.992857] br0: port 1(veth0) entered disabled state
[   84.998172] device veth0 entered promiscuous mode
ip link set veth1 master br0
[   87.083140] br0: port 2(veth1) entered blocking state
[   87.088280] br0: port 2(veth1) entered disabled state
[   87.093625] device veth1 entered promiscuous mode
ip link set br0 type bridge stp_state 1
ip link set br0 up
ip link set veth0 up
ip link set veth1 up
[  116.758260] IPv6: ADDRCONF(NETDEV_CHANGE): veth1: link becomes ready
[  116.764899] br0: port 2(veth1) entered blocking state
[  116.771353] br0: port 2(veth1) entered listening state
[  116.778272] IPv6: ADDRCONF(NETDEV_CHANGE): veth0: link becomes ready
[  116.785703] br0: port 1(veth0) entered blocking state
[  116.790776] br0: port 1(veth0) entered listening state
[  117.112892] br0: port 2(veth1) entered blocking state
[  132.312686] br0: port 1(veth0) entered learning state
[  133.740183] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[  145.752889] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[  147.672675] br0: port 1(veth0) entered forwarding state
[  147.677978] br0: topology change detected, propagating
[  147.683388] IPv6: ADDRCONF(NETDEV_CHANGE): br0: link becomes ready
[  149.741219] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[  176.472805] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[  181.742095] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[  238.552814] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[  245.742659] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
bridge link
6: veth1@veth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state blocking priority 32 cost 2
7: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2

Looking at br_fdb_update(), the print is pretty harmless - the bridge is
smart enough to not actually relearn the local FDB entry towards an
external port. No FDB update is being done. The print is also
rate-limited. So it's just that - a warning. I am not sure whether it's
worth disabling IPv6 Router Solicitations, given that, as mentioned,
basically any other traffic sent through the plain bridge port will
trigger this. I consider it a non-problem.

ip addr add 192.168.100.1/24 dev veth1
ping 192.168.100.2
PING 192.168.100.[ 1434.033119] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
2 (192.168.100.2) 56(84) bytes of data.
[ 1435.112977] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[ 1436.152991] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[ 1437.193428] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
From 192.168.100.1 icmp_seq=1 Destination Host Unreachable
From 192.168.100.1 icmp_seq=2 Destination Host Unreachable
From 192.168.100.1 icmp_seq=3 Destination Host Unreachable
[ 1438.232784] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[ 1438.260075] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[ 1439.272769] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
[ 1440.312904] br0: received packet on veth0 with own address as source address (addr:c2:fc:33:30:4c:bf, vlan:0)
From 192.168.100.1 icmp_seq=4 Destination Host Unreachable
^C
--- 192.168.100.2 ping statistics ---
7 packets transmitted, 0 received, +4 errors, 100% packet loss, time 6280ms
pipe 4
