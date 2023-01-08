Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7DC66143F
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 10:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjAHJLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 04:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjAHJLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 04:11:38 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F78B65DC;
        Sun,  8 Jan 2023 01:11:34 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 983D8604F1;
        Sun,  8 Jan 2023 10:11:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673169091; bh=TnCx8MnHw+76fXaOHxoEMNtZFF3k2xtIXTAR7hD526s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=OYlAsPQ4VtpK9KujKktkCX131KHoTKntQvYNMmdpgNcmrPuiTc1QCPCC1fi3S7nSt
         flVLZxC4PrX93ULE9CVIgw+KY80sK+Ud5og3/ecwq/wpSjE61NHrJLMtVtoN972/l3
         9ogZf4L/JIGYbPxXPDV4LpLcsIa6ggWF9+Z1yvz86B/C+tOwqO1d2P15LAFpi1DnRI
         7/ZDaKrJBcEB+NSfH5hRaCay15qwLuBMST/qqQrkAX1A1qhX3ub3INrtHfQLKWQMJB
         Bw4drkvU9+CViPrcKzK+bLgZAWWPLURJh9uXPC4QHg2dUAmsfCz1YRcIWbboEg+z/F
         wN/iyEM4wCK5g==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eBtGShARrNjI; Sun,  8 Jan 2023 10:11:26 +0100 (CET)
Received: from [192.168.0.12] (unknown [188.252.196.35])
        by domac.alu.hr (Postfix) with ESMTPSA id 23A1A604F0;
        Sun,  8 Jan 2023 10:11:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1673169086; bh=TnCx8MnHw+76fXaOHxoEMNtZFF3k2xtIXTAR7hD526s=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bVRojJllrqCedLa4v85mqVwohqxqLfo2sB63LNaYYHis8IV/c4e7vJTGbNuEFrbid
         /nd4FZvrvRVeTzUuNl96oPd+HXKypgD02b1DJuSFRlibBvfuhs1M/yunq9hHrAteUf
         78i/MEFsfUxfRDp53NekvAUO/KVnyw8gmlfsxD9BWk59oowT576gKRaM3zNLhyx1ai
         Wg4rIEA0czmMiodjzNruVbbxRohJFsul2oroWKilaCGPyw/3yM7Q93ftSJAaa2gXc0
         rjFApwe0ZnMdv0MwFwwnxCyfwwFhOep6oxeHXJ08PGxsPoetsiJUSEPnA5X+WRj3qZ
         Hr3vZ8f56kKQQ==
Message-ID: <81fdf2bc-4842-96d8-b124-43d0bd5ec124@alu.unizg.hr>
Date:   Sun, 8 Jan 2023 10:11:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: BUG: tools/testing/selftests/net/l2_tos_ttl_inherit.sh hangs when
 selftest restarted
Content-Language: en-US, hr
To:     Guillaume Nault <gnault@redhat.com>
Cc:     linux-kselftest@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias May <matthias.may@westermo.com>
References: <924f1062-ab59-9b88-3b43-c44e73a30387@alu.unizg.hr>
 <Y7i5cT1AlyC53hzN@debian> <5ef41d3c-8d81-86b3-c571-044636702342@alu.unizg.hr>
 <Y7lpO9IHtSIyHVej@debian>
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <Y7lpO9IHtSIyHVej@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07. 01. 2023. 13:44, Guillaume Nault wrote:
> [Cc: Matthias since he's the original author of the script]
> 
> On Sat, Jan 07, 2023 at 02:17:07AM +0100, Mirsad Goran Todorovac wrote:
>> On 07. 01. 2023. 01:14, Guillaume Nault wrote:
>>> On Fri, Jan 06, 2023 at 02:44:11AM +0100, Mirsad Goran Todorovac wrote:
>>>> [root@pc-mtodorov linux_torvalds]# tools/testing/selftests/net/l2_tos_ttl_inherit.sh
>>>> ┌────────┬───────┬───────┬──────────────┬──────────────┬───────┬────────┐
>>>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>>>> │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
>>>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>>>> │    gre │     4 │     4 │ inherit 0xc4 │  inherit 116 │ false │Cannot create namespace file "/var/run/netns/testing": File exists
>>>> RTNETLINK answers: File exists
>>>> RTNETLINK answers: File exists
>>>> RTNETLINK answers: File exists
>>>
>>> You probably have leftovers from a previous test case. In particular
>>> the "testing" network name space already exists, which prevents the
>>> script from creating it. You can delete it manually with
>>> "ip netns del testing". If this netns is there because of a previous
>>> incomplete run of l2_tos_ttl_inherit.sh, then you'll likely need to
>>> also remove the tunnel interface it created in your current netns
>>> ("ip link del tep0").
>>
>> Thanks, it worked :)
> 
> Good to know.
> 
>>> Ideally this script wouldn't touch the current netns and would clean up
>>> its environment in all cases upon exit. I have a patch almost ready
>>> that does just that.
>>
>> As these interfaces were not cleared by "make kselftest-clean",
>> this patch with a cleanup trap would be most welcome.
> 
> Yes, I'll send a patch soon.
> 
>> However, after the cleanup above, the ./l2_tos_ttl_inherit.sh
>> script hangs at the spot where it did in the first place (but
>> only on Lenovo desktop 10TX000VCR with BIOS M22KT49A from
>> 11/10/2022, AlmaLinux 8.7, and kernel 6.2-rc2; not on Lenovo
>> Ideapad3 with Ubuntu 22.10, where it worked like a charm with
>> the same kernel RC).
>>
>> The point of hang is this:
>>
>> [root@pc-mtodorov net]# ./l2_tos_ttl_inherit.sh
>> ┌────────┬───────┬───────┬──────────────┬──────────────┬───────┬────────┐
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │    gre │     4 │     4 │ inherit 0xb8 │  inherit 102 │ false │     OK │
>> │    gre │     4 │     4 │ inherit 0x10 │   inherit 53 │  true │     OK │
>> │    gre │     4 │     4 │   fixed 0xa8 │    fixed 230 │ false │     OK │
>> │    gre │     4 │     4 │   fixed 0x0c │     fixed 96 │  true │     OK │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │    gre │     4 │     6 │ inherit 0xbc │  inherit 159 │ false │     OK │
>> │    gre │     4 │     6 │ inherit 0x5c │  inherit 242 │  true │     OK │
>> │    gre │     4 │     6 │   fixed 0x38 │    fixed 113 │ false │     OK │
>> │    gre │     4 │     6 │   fixed 0x78 │     fixed 34 │  true │     OK │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │    gre │     4 │ other │ inherit 0xec │   inherit 69 │ false │     OK │
>> │    gre │     4 │ other │ inherit 0xf0 │  inherit 201 │  true │     OK │
>> │    gre │     4 │ other │   fixed 0xec │     fixed 14 │ false │     OK │
>> │    gre │     4 │ other │   fixed 0xe4 │     fixed 15 │  true │     OK │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │    gre │     6 │     4 │ inherit 0xc4 │   inherit 21 │ false │     OK │
>> │    gre │     6 │     4 │ inherit 0xc8 │  inherit 230 │  true │     OK │
>> │    gre │     6 │     4 │   fixed 0x24 │    fixed 193 │ false │     OK │
>> │    gre │     6 │     4 │   fixed 0x1c │    fixed 200 │  true │     OK │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │    gre │     6 │     6 │ inherit 0xe4 │   inherit 81 │ false │     OK │
>> │    gre │     6 │     6 │ inherit 0xa4 │  inherit 130 │  true │     OK │
>> │    gre │     6 │     6 │   fixed 0x18 │    fixed 140 │ false │     OK │
>> │    gre │     6 │     6 │   fixed 0xc8 │    fixed 175 │  true │     OK │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │    gre │     6 │ other │ inherit 0x74 │  inherit 142 │ false │     OK │
>> │    gre │     6 │ other │ inherit 0x50 │  inherit 125 │  true │     OK │
>> │    gre │     6 │ other │   fixed 0x90 │     fixed 84 │ false │     OK │
>> │    gre │     6 │ other │   fixed 0xb8 │    fixed 240 │  true │     OK │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
>> ├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
>> │  vxlan │     4 │     4 │ inherit 0xb4 │   inherit 93 │ false │
>>
>> Developers usually ask for bash -x output of the script that failed or hung
>> when reporting problems (too long for an email):
>>
>> https://domac.alu.unizg.hr/~mtodorov/linux/selftests/net-namespace-20230106/bash-l2_tos_ttl_inherit.html
> 
> Tcpdump blocks until it captures an encapsulated ICMP Echo Request. But
> it seems that it doesn't see any. When the script is hanging, what's the
> result of "ip route get 198.19.0.2"?
> 
> The output of following commands might also help debugging the problem (run
> them while the script is still hanging):
>   ip link show
>   ip address show
>   ip route show
>   tcpdump --immediate-mode -p -v -i veth0 -n # Kill it manually after a few seconds
>   ping -c 3 198.19.0.2

OK, but is is copious:

[root@pc-mtodorov marvin]# ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether f4:93:9f:f0:a5:f5 brd ff:ff:ff:ff:ff:ff
3: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 52:54:00:56:df:f2 brd ff:ff:ff:ff:ff:ff
51: gre0@NONE: <NOARP> mtu 1476 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/gre 0.0.0.0 brd 0.0.0.0
52: gretap0@NONE: <BROADCAST,MULTICAST> mtu 1462 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
53: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
55: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/tunnel6 :: brd :: permaddr bae0:176c:6eed::
56: ip6gre0@NONE: <NOARP> mtu 1448 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/gre6 :: brd :: permaddr ca5f:978e:c395::
67: veth-outside@if66: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 9e:d6:a5:cb:0a:2b brd ff:ff:ff:ff:ff:ff link-netns test-ns
78: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
79: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
80: ip6_vti0@NONE: <NOARP> mtu 1332 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/tunnel6 :: brd :: permaddr c2fe:1782:e33d::
81: ip_vti0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
1110: veth0@if1111: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 6e:c5:68:82:23:e4 brd ff:ff:ff:ff:ff:ff link-netns testing
1112: tep0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether da:73:bd:1b:a4:5f brd ff:ff:ff:ff:ff:ff
100: ifb0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 32
    link/ether 36:3a:ca:87:f6:d7 brd ff:ff:ff:ff:ff:ff
101: ifb1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 32
    link/ether ce:76:dd:e7:dd:fc brd ff:ff:ff:ff:ff:ff
[root@pc-mtodorov marvin]# 

[root@pc-mtodorov marvin]# ip address show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet 10.0.0.1/32 scope global lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether f4:93:9f:f0:a5:f5 brd ff:ff:ff:ff:ff:ff
    inet 193.198.186.200/27 brd 193.198.186.223 scope global dynamic noprefixroute enp1s0
       valid_lft 26499sec preferred_lft 26499sec
    inet6 2001:b68:2:2a00::1098/128 scope global dynamic noprefixroute 
       valid_lft 2591173sec preferred_lft 603973sec
    inet6 fe80::f693:9fff:fef0:a5f5/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 52:54:00:56:df:f2 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
       valid_lft forever preferred_lft forever
51: gre0@NONE: <NOARP> mtu 1476 qdisc noop state DOWN group default qlen 1000
    link/gre 0.0.0.0 brd 0.0.0.0
52: gretap0@NONE: <BROADCAST,MULTICAST> mtu 1462 qdisc noop state DOWN group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
53: erspan0@NONE: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN group default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
55: ip6tnl0@NONE: <NOARP> mtu 1452 qdisc noop state DOWN group default qlen 1000
    link/tunnel6 :: brd :: permaddr bae0:176c:6eed::
56: ip6gre0@NONE: <NOARP> mtu 1448 qdisc noop state DOWN group default qlen 1000
    link/gre6 :: brd :: permaddr ca5f:978e:c395::
67: veth-outside@if66: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 9e:d6:a5:cb:0a:2b brd ff:ff:ff:ff:ff:ff link-netns test-ns
    inet6 fe80::9cd6:a5ff:fecb:a2b/64 scope link 
       valid_lft forever preferred_lft forever
78: tunl0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
79: sit0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/sit 0.0.0.0 brd 0.0.0.0
80: ip6_vti0@NONE: <NOARP> mtu 1332 qdisc noop state DOWN group default qlen 1000
    link/tunnel6 :: brd :: permaddr c2fe:1782:e33d::
81: ip_vti0@NONE: <NOARP> mtu 1480 qdisc noop state DOWN group default qlen 1000
    link/ipip 0.0.0.0 brd 0.0.0.0
1110: veth0@if1111: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 6e:c5:68:82:23:e4 brd ff:ff:ff:ff:ff:ff link-netns testing
    inet 198.18.0.1/24 scope global veth0
       valid_lft forever preferred_lft forever
1112: tep0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether da:73:bd:1b:a4:5f brd ff:ff:ff:ff:ff:ff
    inet 198.19.0.1/24 brd 198.19.0.255 scope global tep0
       valid_lft forever preferred_lft forever
100: ifb0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 32
    link/ether 36:3a:ca:87:f6:d7 brd ff:ff:ff:ff:ff:ff
101: ifb1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 32
    link/ether ce:76:dd:e7:dd:fc brd ff:ff:ff:ff:ff:ff
[root@pc-mtodorov marvin]# 

[root@pc-mtodorov marvin]# ip route show
default via 193.198.186.193 dev enp1s0 proto dhcp src 193.198.186.200 metric 100 
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown 
193.198.186.192/27 dev enp1s0 proto kernel scope link src 193.198.186.200 metric 100 
198.18.0.0/24 dev veth0 proto kernel scope link src 198.18.0.1 
198.19.0.0/24 dev tep0 proto kernel scope link src 198.19.0.1 
[root@pc-mtodorov marvin]# 

[root@pc-mtodorov marvin]# tcpdump --immediate-mode -p -v -i veth0 -n
dropped privs to tcpdump
tcpdump: listening on veth0, link-type EN10MB (Ethernet), capture size 262144 bytes
08:30:22.835825 IP (tos 0x0, ttl 64, id 2490, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.1.35195 > 198.18.0.2.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 198.19.0.2 tell 198.19.0.1, length 28
08:30:22.835926 IP (tos 0x0, ttl 64, id 1388, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
08:30:22.835976 IP (tos 0xc0, ttl 64, id 29533, offset 0, flags [none], proto ICMP (1), length 106)
    198.18.0.1 > 198.18.0.2: ICMP host 198.18.0.1 unreachable - admin prohibited filter, length 86
        IP (tos 0x0, ttl 64, id 1388, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
08:30:23.859770 IP (tos 0x0, ttl 64, id 2585, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.1.35195 > 198.18.0.2.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 198.19.0.2 tell 198.19.0.1, length 28
08:30:23.859803 IP (tos 0x0, ttl 64, id 1465, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
08:30:23.859852 IP (tos 0xc0, ttl 64, id 29535, offset 0, flags [none], proto ICMP (1), length 106)
    198.18.0.1 > 198.18.0.2: ICMP host 198.18.0.1 unreachable - admin prohibited filter, length 86
        IP (tos 0x0, ttl 64, id 1465, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
08:30:24.888024 IP (tos 0x0, ttl 64, id 2652, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.1.35195 > 198.18.0.2.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 198.19.0.2 tell 198.19.0.1, length 28
08:30:24.888094 IP (tos 0x0, ttl 64, id 1630, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
08:30:24.888131 IP (tos 0xc0, ttl 64, id 29607, offset 0, flags [none], proto ICMP (1), length 106)
    198.18.0.1 > 198.18.0.2: ICMP host 198.18.0.1 unreachable - admin prohibited filter, length 86
        IP (tos 0x0, ttl 64, id 1630, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
08:30:25.911810 IP (tos 0x0, ttl 64, id 2658, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.1.35195 > 198.18.0.2.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 198.19.0.2 tell 198.19.0.1, length 28
08:30:25.911876 IP (tos 0x0, ttl 64, id 1698, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
08:30:25.911920 IP (tos 0xc0, ttl 64, id 29757, offset 0, flags [none], proto ICMP (1), length 106)
    198.18.0.1 > 198.18.0.2: ICMP host 198.18.0.1 unreachable - admin prohibited filter, length 86
        IP (tos 0x0, ttl 64, id 1698, offset 0, flags [none], proto UDP (17), length 78)
    198.18.0.2.35195 > 198.18.0.1.vxlan: VXLAN, flags [I] (0x08), vni 100
ARP, Ethernet (len 6), IPv4 (len 4), Reply 198.19.0.2 is-at a6:45:d5:c4:93:1f, length 28
^C
12 packets captured
12 packets received by filter
0 packets dropped by kernel
[root@pc-mtodorov marvin]# 

[root@pc-mtodorov marvin]# ping -c 3 198.19.0.2
PING 198.19.0.2 (198.19.0.2) 56(84) bytes of data.
From 198.19.0.1 icmp_seq=1 Destination Host Unreachable
From 198.19.0.1 icmp_seq=2 Destination Host Unreachable
From 198.19.0.1 icmp_seq=3 Destination Host Unreachable

--- 198.19.0.2 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2017ms
pipe 2
[root@pc-mtodorov marvin]# 

 
> Also, can you please try the below patch?
> 
> -------- >8 --------
> 
> Isolate testing environment and ensure everything is cleaned up on
> exit.
> 
> diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
> index dca1e6f777a8..f11756e7df2f 100755
> --- a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
> +++ b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
> @@ -12,19 +12,27 @@
>  # In addition this script also checks if forcing a specific field in the
>  # outer header is working.
>  
> +# Return 4 by default (Kselftest SKIP code)
> +ERR=4
> +
>  if [ "$(id -u)" != "0" ]; then
>  	echo "Please run as root."
> -	exit 0
> +	exit $ERR
>  fi
>  if ! which tcpdump > /dev/null 2>&1; then
>  	echo "No tcpdump found. Required for this test."
> -	exit 0
> +	exit $ERR
>  fi
>  
>  expected_tos="0x00"
>  expected_ttl="0"
>  failed=false
>  
> +readonly NS0=$(mktemp -u ns0-XXXXXXXX)
> +readonly NS1=$(mktemp -u ns1-XXXXXXXX)
> +
> +RUN_NS0="ip netns exec ${NS0}"
> +
>  get_random_tos() {
>  	# Get a random hex tos value between 0x00 and 0xfc, a multiple of 4
>  	echo "0x$(tr -dc '0-9a-f' < /dev/urandom | head -c 1)\
> @@ -61,7 +69,6 @@ setup() {
>  	local vlan="$5"
>  	local test_tos="0x00"
>  	local test_ttl="0"
> -	local ns="ip netns exec testing"
>  
>  	# We don't want a test-tos of 0x00,
>  	# because this is the value that we get when no tos is set.
> @@ -94,14 +101,15 @@ setup() {
>  	printf "│%7s │%6s │%6s │%13s │%13s │%6s │" \
>  	"$type" "$outer" "$inner" "$tos" "$ttl" "$vlan"
>  
> -	# Create 'testing' netns, veth pair and connect main ns with testing ns
> -	ip netns add testing
> -	ip link add type veth
> -	ip link set veth1 netns testing
> -	ip link set veth0 up
> -	$ns ip link set veth1 up
> -	ip addr flush dev veth0
> -	$ns ip addr flush dev veth1
> +	# Create netns NS0 and NS1 and connect them with a veth pair
> +	ip netns add "${NS0}"
> +	ip netns add "${NS1}"
> +	ip link add name veth0 netns "${NS0}" type veth \
> +		peer name veth1 netns "${NS1}"
> +	ip -netns "${NS0}" link set dev veth0 up
> +	ip -netns "${NS1}" link set dev veth1 up
> +	ip -netns "${NS0}" address flush dev veth0
> +	ip -netns "${NS1}" address flush dev veth1
>  
>  	local local_addr1=""
>  	local local_addr2=""
> @@ -127,51 +135,59 @@ setup() {
>  		if [ "$type" = "gre" ]; then
>  			type="gretap"
>  		fi
> -		ip addr add 198.18.0.1/24 dev veth0
> -		$ns ip addr add 198.18.0.2/24 dev veth1
> -		ip link add name tep0 type $type $local_addr1 remote \
> -		198.18.0.2 tos $test_tos ttl $test_ttl $vxlan $geneve
> -		$ns ip link add name tep1 type $type $local_addr2 remote \
> -		198.18.0.1 tos $test_tos ttl $test_ttl $vxlan $geneve
> +		ip -netns "${NS0}" address add 198.18.0.1/24 dev veth0
> +		ip -netns "${NS1}" address add 198.18.0.2/24 dev veth1
> +		ip -netns "${NS0}" link add name tep0 type $type $local_addr1 \
> +			remote 198.18.0.2 tos $test_tos ttl $test_ttl         \
> +			$vxlan $geneve
> +		ip -netns "${NS1}" link add name tep1 type $type $local_addr2 \
> +			remote 198.18.0.1 tos $test_tos ttl $test_ttl         \
> +			$vxlan $geneve
>  	elif [ "$outer" = "6" ]; then
>  		if [ "$type" = "gre" ]; then
>  			type="ip6gretap"
>  		fi
> -		ip addr add fdd1:ced0:5d88:3fce::1/64 dev veth0
> -		$ns ip addr add fdd1:ced0:5d88:3fce::2/64 dev veth1
> -		ip link add name tep0 type $type $local_addr1 \
> -		remote fdd1:ced0:5d88:3fce::2 tos $test_tos ttl $test_ttl \
> -		$vxlan $geneve
> -		$ns ip link add name tep1 type $type $local_addr2 \
> -		remote fdd1:ced0:5d88:3fce::1 tos $test_tos ttl $test_ttl \
> -		$vxlan $geneve
> +		ip -netns "${NS0}" address add fdd1:ced0:5d88:3fce::1/64 \
> +			dev veth0 nodad
> +		ip -netns "${NS1}" address add fdd1:ced0:5d88:3fce::2/64 \
> +			dev veth1 nodad
> +		ip -netns "${NS0}" link add name tep0 type $type $local_addr1 \
> +			remote fdd1:ced0:5d88:3fce::2 tos $test_tos           \
> +			ttl $test_ttl $vxlan $geneve
> +		ip -netns "${NS1}" link add name tep1 type $type $local_addr2 \
> +			remote fdd1:ced0:5d88:3fce::1 tos $test_tos           \
> +			ttl $test_ttl $vxlan $geneve
>  	fi
>  
>  	# Bring L2-tunnel link up and create VLAN on top
> -	ip link set tep0 up
> -	$ns ip link set tep1 up
> -	ip addr flush dev tep0
> -	$ns ip addr flush dev tep1
> +	ip -netns "${NS0}" link set tep0 up
> +	ip -netns "${NS1}" link set tep1 up
> +	ip -netns "${NS0}" address flush dev tep0
> +	ip -netns "${NS1}" address flush dev tep1
>  	local parent
>  	if $vlan; then
>  		parent="vlan99-"
> -		ip link add link tep0 name ${parent}0 type vlan id 99
> -		$ns ip link add link tep1 name ${parent}1 type vlan id 99
> -		ip link set ${parent}0 up
> -		$ns ip link set ${parent}1 up
> -		ip addr flush dev ${parent}0
> -		$ns ip addr flush dev ${parent}1
> +		ip -netns "${NS0}" link add link tep0 name ${parent}0 \
> +			type vlan id 99
> +		ip -netns "${NS1}" link add link tep1 name ${parent}1 \
> +			type vlan id 99
> +		ip -netns "${NS0}" link set dev ${parent}0 up
> +		ip -netns "${NS1}" link set dev ${parent}1 up
> +		ip -netns "${NS0}" address flush dev ${parent}0
> +		ip -netns "${NS1}" address flush dev ${parent}1
>  	else
>  		parent="tep"
>  	fi
>  
>  	# Assign inner IPv4/IPv6 addresses
>  	if [ "$inner" = "4" ] || [ "$inner" = "other" ]; then
> -		ip addr add 198.19.0.1/24 brd + dev ${parent}0
> -		$ns ip addr add 198.19.0.2/24 brd + dev ${parent}1
> +		ip -netns "${NS0}" address add 198.19.0.1/24 brd + dev ${parent}0
> +		ip -netns "${NS1}" address add 198.19.0.2/24 brd + dev ${parent}1
>  	elif [ "$inner" = "6" ]; then
> -		ip addr add fdd4:96cf:4eae:443b::1/64 dev ${parent}0
> -		$ns ip addr add fdd4:96cf:4eae:443b::2/64 dev ${parent}1
> +		ip -netns "${NS0}" address add fdd4:96cf:4eae:443b::1/64 \
> +			dev ${parent}0 nodad
> +		ip -netns "${NS1}" address add fdd4:96cf:4eae:443b::2/64 \
> +			dev ${parent}1 nodad
>  	fi
>  }
>  
> @@ -192,10 +208,10 @@ verify() {
>  		ping_dst="198.19.0.3" # Generates ARPs which are not IPv4/IPv6
>  	fi
>  	if [ "$tos_ttl" = "inherit" ]; then
> -		ping -i 0.1 $ping_dst -Q "$expected_tos" -t "$expected_ttl" \
> -		2>/dev/null 1>&2 & ping_pid="$!"
> +		${RUN_NS0} ping -i 0.1 $ping_dst -Q "$expected_tos"          \
> +			 -t "$expected_ttl" 2>/dev/null 1>&2 & ping_pid="$!"
>  	else
> -		ping -i 0.1 $ping_dst 2>/dev/null 1>&2 & ping_pid="$!"
> +		${RUN_NS0} ping -i 0.1 $ping_dst 2>/dev/null 1>&2 & ping_pid="$!"
>  	fi
>  	local tunnel_type_offset tunnel_type_proto req_proto_offset req_offset
>  	if [ "$type" = "gre" ]; then
> @@ -216,10 +232,12 @@ verify() {
>  				req_proto_offset="$((req_proto_offset + 4))"
>  				req_offset="$((req_offset + 4))"
>  			fi
> -			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
> -			ip[$tunnel_type_offset] = $tunnel_type_proto and \
> -			ip[$req_proto_offset] = 0x01 and \
> -			ip[$req_offset] = 0x08 2>/dev/null | head -n 1)"
> +			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
> +				-i veth0 -n                                   \
> +				ip[$tunnel_type_offset] = $tunnel_type_proto and \
> +				ip[$req_proto_offset] = 0x01 and              \
> +				ip[$req_offset] = 0x08 2>/dev/null            \
> +				| head -n 1)"
>  		elif [ "$inner" = "6" ]; then
>  			req_proto_offset="44"
>  			req_offset="78"
> @@ -231,10 +249,12 @@ verify() {
>  				req_proto_offset="$((req_proto_offset + 4))"
>  				req_offset="$((req_offset + 4))"
>  			fi
> -			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
> -			ip[$tunnel_type_offset] = $tunnel_type_proto and \
> -			ip[$req_proto_offset] = 0x3a and \
> -			ip[$req_offset] = 0x80 2>/dev/null | head -n 1)"
> +			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
> +				-i veth0 -n                                   \
> +				ip[$tunnel_type_offset] = $tunnel_type_proto and \
> +				ip[$req_proto_offset] = 0x3a and              \
> +				ip[$req_offset] = 0x80 2>/dev/null            \
> +				| head -n 1)"
>  		elif [ "$inner" = "other" ]; then
>  			req_proto_offset="36"
>  			req_offset="45"
> @@ -250,11 +270,13 @@ verify() {
>  				expected_tos="0x00"
>  				expected_ttl="64"
>  			fi
> -			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
> -			ip[$tunnel_type_offset] = $tunnel_type_proto and \
> -			ip[$req_proto_offset] = 0x08 and \
> -			ip[$((req_proto_offset + 1))] = 0x06 and \
> -			ip[$req_offset] = 0x01 2>/dev/null | head -n 1)"
> +			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
> +				-i veth0 -n                                   \
> +				ip[$tunnel_type_offset] = $tunnel_type_proto and \
> +				ip[$req_proto_offset] = 0x08 and              \
> +				ip[$((req_proto_offset + 1))] = 0x06 and      \
> +				ip[$req_offset] = 0x01 2>/dev/null            \
> +				| head -n 1)"
>  		fi
>  	elif [ "$outer" = "6" ]; then
>  		if [ "$type" = "gre" ]; then
> @@ -273,10 +295,12 @@ verify() {
>  				req_proto_offset="$((req_proto_offset + 4))"
>  				req_offset="$((req_offset + 4))"
>  			fi
> -			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
> -			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
> -			ip6[$req_proto_offset] = 0x01 and \
> -			ip6[$req_offset] = 0x08 2>/dev/null | head -n 1)"
> +			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
> +				-i veth0 -n                                   \
> +				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
> +				ip6[$req_proto_offset] = 0x01 and             \
> +				ip6[$req_offset] = 0x08 2>/dev/null           \
> +				| head -n 1)"
>  		elif [ "$inner" = "6" ]; then
>  			local req_proto_offset="72"
>  			local req_offset="106"
> @@ -288,10 +312,12 @@ verify() {
>  				req_proto_offset="$((req_proto_offset + 4))"
>  				req_offset="$((req_offset + 4))"
>  			fi
> -			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
> -			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
> -			ip6[$req_proto_offset] = 0x3a and \
> -			ip6[$req_offset] = 0x80 2>/dev/null | head -n 1)"
> +			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
> +				-i veth0 -n                                   \
> +				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
> +				ip6[$req_proto_offset] = 0x3a and             \
> +				ip6[$req_offset] = 0x80 2>/dev/null           \
> +				| head -n 1)"
>  		elif [ "$inner" = "other" ]; then
>  			local req_proto_offset="64"
>  			local req_offset="73"
> @@ -307,15 +333,17 @@ verify() {
>  				expected_tos="0x00"
>  				expected_ttl="64"
>  			fi
> -			out="$(tcpdump --immediate-mode -p -c 1 -v -i veth0 -n \
> -			ip6[$tunnel_type_offset] = $tunnel_type_proto and \
> -			ip6[$req_proto_offset] = 0x08 and \
> -			ip6[$((req_proto_offset + 1))] = 0x06 and \
> -			ip6[$req_offset] = 0x01 2>/dev/null | head -n 1)"
> +			out="$(${RUN_NS0} tcpdump --immediate-mode -p -c 1 -v \
> +				-i veth0 -n                                   \
> +				ip6[$tunnel_type_offset] = $tunnel_type_proto and \
> +				ip6[$req_proto_offset] = 0x08 and             \
> +				ip6[$((req_proto_offset + 1))] = 0x06 and     \
> +				ip6[$req_offset] = 0x01 2>/dev/null           \
> +				| head -n 1)"
>  		fi
>  	fi
>  	kill -9 $ping_pid
> -	wait $ping_pid 2>/dev/null
> +	wait $ping_pid 2>/dev/null || true
>  	result="FAIL"
>  	if [ "$outer" = "4" ]; then
>  		captured_ttl="$(get_field "ttl" "$out")"
> @@ -351,11 +379,35 @@ verify() {
>  }
>  
>  cleanup() {
> -	ip link del veth0 2>/dev/null
> -	ip netns del testing 2>/dev/null
> -	ip link del tep0 2>/dev/null
> +	ip netns del "${NS0}" 2>/dev/null
> +	ip netns del "${NS1}" 2>/dev/null
>  }
>  
> +exit_handler() {
> +	# Don't exit immediately if one of the intermediate commands fails.
> +	# We might be called at the end of the script, when the network
> +	# namespaces have already been deleted. So cleanup() may fail, but we
> +	# still need to run until 'exit $ERR' or the script won't return the
> +	# correct error code.
> +	set +e
> +
> +	cleanup
> +
> +	exit $ERR
> +}
> +
> +# Restore the default SIGINT handler (just in case) and exit.
> +# The exit handler will take care of cleaning everything up.
> +interrupted() {
> +	trap - INT
> +
> +	exit $ERR
> +}
> +
> +set -e
> +trap exit_handler EXIT
> +trap interrupted INT
> +
>  printf "┌────────┬───────┬───────┬──────────────┬"
>  printf "──────────────┬───────┬────────┐\n"
>  for type in gre vxlan geneve; do
> @@ -385,6 +437,10 @@ done
>  printf "└────────┴───────┴───────┴──────────────┴"
>  printf "──────────────┴───────┴────────┘\n"
>  
> +# All tests done.
> +# Set ERR appropriately: it will be returned by the exit handler.
>  if $failed; then
> -	exit 1
> +	ERR=1
> +else
> +	ERR=0
>  fi

Wow, Guillaueme, this patch actually made things unstuck :)

[root@pc-mtodorov linux_torvalds]# git apply ../net-inherit-guilllaume1.patch
[root@pc-mtodorov linux_torvalds]# cd tools/testing/selftests/net
[root@pc-mtodorov net]# ./l2_tos_ttl_inherit.sh
┌────────┬───────┬───────┬──────────────┬──────────────┬───────┬────────┐
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     4 │     4 │ inherit 0x80 │  inherit 186 │ false │     OK │
│    gre │     4 │     4 │ inherit 0xd0 │  inherit 168 │  true │     OK │
│    gre │     4 │     4 │   fixed 0xcc │    fixed 234 │ false │     OK │
│    gre │     4 │     4 │   fixed 0xf4 │    fixed 144 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     4 │     6 │ inherit 0x08 │  inherit 252 │ false │     OK │
│    gre │     4 │     6 │ inherit 0x10 │  inherit 171 │  true │     OK │
│    gre │     4 │     6 │   fixed 0x5c │    fixed 151 │ false │     OK │
│    gre │     4 │     6 │   fixed 0xc0 │    fixed 140 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     4 │ other │ inherit 0xf4 │    inherit 8 │ false │     OK │
│    gre │     4 │ other │ inherit 0x44 │  inherit 231 │  true │     OK │
│    gre │     4 │ other │   fixed 0x40 │    fixed 143 │ false │     OK │
│    gre │     4 │ other │   fixed 0xa8 │     fixed 13 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     6 │     4 │ inherit 0xe4 │  inherit 114 │ false │     OK │
│    gre │     6 │     4 │ inherit 0xd8 │  inherit 190 │  true │     OK │
│    gre │     6 │     4 │   fixed 0x60 │    fixed 255 │ false │     OK │
│    gre │     6 │     4 │   fixed 0x48 │     fixed 90 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     6 │     6 │ inherit 0xb4 │  inherit 179 │ false │     OK │
│    gre │     6 │     6 │ inherit 0x68 │   inherit 95 │  true │     OK │
│    gre │     6 │     6 │   fixed 0x0c │     fixed 96 │ false │     OK │
│    gre │     6 │     6 │   fixed 0x38 │     fixed 98 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│    gre │     6 │ other │ inherit 0x44 │   inherit 54 │ false │     OK │
│    gre │     6 │ other │ inherit 0xec │   inherit 82 │  true │     OK │
│    gre │     6 │ other │   fixed 0xf0 │      fixed 3 │ false │     OK │
│    gre │     6 │ other │   fixed 0x90 │    fixed 183 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  vxlan │     4 │     4 │ inherit 0xa8 │  inherit 157 │ false │     OK │
│  vxlan │     4 │     4 │ inherit 0x9c │  inherit 159 │  true │     OK │
│  vxlan │     4 │     4 │   fixed 0x88 │     fixed 21 │ false │     OK │
│  vxlan │     4 │     4 │   fixed 0x84 │    fixed 241 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  vxlan │     4 │     6 │ inherit 0x78 │  inherit 115 │ false │     OK │
│  vxlan │     4 │     6 │ inherit 0x3c │   inherit 21 │  true │     OK │
│  vxlan │     4 │     6 │   fixed 0xf4 │     fixed 61 │ false │     OK │
│  vxlan │     4 │     6 │   fixed 0x0c │     fixed 24 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  vxlan │     4 │ other │ inherit 0xa0 │  inherit 112 │ false │     OK │
│  vxlan │     4 │ other │ inherit 0x2c │  inherit 236 │  true │     OK │
│  vxlan │     4 │ other │   fixed 0x20 │    fixed 166 │ false │     OK │
│  vxlan │     4 │ other │   fixed 0x18 │    fixed 129 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  vxlan │     6 │     4 │ inherit 0xa0 │   inherit 69 │ false │     OK │
│  vxlan │     6 │     4 │ inherit 0x4c │  inherit 100 │  true │     OK │
│  vxlan │     6 │     4 │   fixed 0x38 │      fixed 1 │ false │     OK │
│  vxlan │     6 │     4 │   fixed 0x34 │    fixed 109 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  vxlan │     6 │     6 │ inherit 0x18 │  inherit 156 │ false │     OK │
│  vxlan │     6 │     6 │ inherit 0x88 │  inherit 104 │  true │     OK │
│  vxlan │     6 │     6 │   fixed 0x44 │    fixed 179 │ false │     OK │
│  vxlan │     6 │     6 │   fixed 0x84 │    fixed 107 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  vxlan │     6 │ other │ inherit 0x54 │   inherit 98 │ false │     OK │
│  vxlan │     6 │ other │ inherit 0x5c │  inherit 121 │  true │     OK │
│  vxlan │     6 │ other │   fixed 0x3c │     fixed 54 │ false │     OK │
│  vxlan │     6 │ other │   fixed 0x58 │    fixed 239 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│ geneve │     4 │     4 │ inherit 0x58 │   inherit 33 │ false │     OK │
│ geneve │     4 │     4 │ inherit 0x28 │   inherit 98 │  true │     OK │
│ geneve │     4 │     4 │   fixed 0x98 │     fixed 60 │ false │     OK │
│ geneve │     4 │     4 │   fixed 0x78 │    fixed 152 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│ geneve │     4 │     6 │ inherit 0x14 │  inherit 124 │ false │     OK │
│ geneve │     4 │     6 │ inherit 0x24 │  inherit 147 │  true │     OK │
│ geneve │     4 │     6 │   fixed 0x38 │    fixed 178 │ false │     OK │
│ geneve │     4 │     6 │   fixed 0x78 │     fixed 38 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│ geneve │     4 │ other │ inherit 0xc0 │   inherit 68 │ false │     OK │
│ geneve │     4 │ other │ inherit 0x64 │  inherit 136 │  true │     OK │
│ geneve │     4 │ other │   fixed 0x7c │    fixed 115 │ false │     OK │
│ geneve │     4 │ other │   fixed 0x9c │     fixed 68 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│  Type  │ outer | inner │     tos      │      ttl     │  vlan │ result │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│ geneve │     6 │     4 │ inherit 0xa0 │   inherit 89 │ false │     OK │
│ geneve │     6 │     4 │ inherit 0x5c │  inherit 123 │  true │     OK │
│ geneve │     6 │     4 │   fixed 0x4c │     fixed 54 │ false │     OK │
│ geneve │     6 │     4 │   fixed 0x70 │     fixed 12 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│ geneve │     6 │     6 │ inherit 0xc0 │  inherit 161 │ false │     OK │
│ geneve │     6 │     6 │ inherit 0x60 │   inherit 47 │  true │     OK │
│ geneve │     6 │     6 │   fixed 0xb4 │    fixed 135 │ false │     OK │
│ geneve │     6 │     6 │   fixed 0x48 │     fixed 35 │  true │     OK │
├────────┼───────┼───────┼──────────────┼──────────────┼───────┼────────┤
│ geneve │     6 │ other │ inherit 0xd0 │  inherit 100 │ false │     OK │
│ geneve │     6 │ other │ inherit 0x3c │  inherit 149 │  true │     OK │
│ geneve │     6 │ other │   fixed 0x2c │    fixed 182 │ false │     OK │
│ geneve │     6 │ other │   fixed 0x68 │    fixed 215 │  true │     OK │
└────────┴───────┴───────┴──────────────┴──────────────┴───────┴────────┘
[root@pc-mtodorov net]# 

The entire tools/tests/selftests/net section now had a PASS w "OK", save for a couple of tests here:

not ok 1 selftests: nci: nci_dev # exit=1
not ok 12 selftests: net: nat6to4.o
not ok 13 selftests: net: run_netsocktests # exit=1
not ok 29 selftests: net: udpgro_bench.sh # exit=255
not ok 30 selftests: net: udpgro.sh # exit=255
not ok 37 selftests: net: fcnal-test.sh # TIMEOUT 1500 seconds
not ok 38 selftests: net: l2tp.sh # exit=2
not ok 46 selftests: net: icmp_redirect.sh # exit=1
not ok 55 selftests: net: vrf_route_leaking.sh # exit=1
not ok 59 selftests: net: udpgro_fwd.sh # exit=1
not ok 60 selftests: net: udpgro_frglist.sh # exit=255
not ok 61 selftests: net: veth.sh # exit=1
not ok 68 selftests: net: srv6_end_dt46_l3vpn_test.sh # exit=1
not ok 69 selftests: net: srv6_end_dt4_l3vpn_test.sh # exit=1
not ok 75 selftests: net: arp_ndisc_evict_nocarrier.sh # exit=255
not ok 83 selftests: net: test_ingress_egress_chaining.sh # exit=1
not ok 1 selftests: net/hsr: hsr_ping.sh # TIMEOUT 45 seconds
not ok 3 selftests: net/mptcp: mptcp_join.sh # exit=1

If you are interested in additional diagnostics, this is a very interesting part of the
Linux kernel testing ...

There was apparent hang in selftest/net/fcnal-test.sh as well.
I can help you with the diagnostics if you wish? Thanks.

If I could make them all work both on Ubuntu 22.10 kinetic kudu and AlmaLinux 8.7
stone smilodon (CentOS fork), this would be a milestone for me :)

Have a nice day!

Regards,
Mirsad

-- 
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu
 
System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union


