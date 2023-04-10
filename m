Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4ED86DCA31
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 19:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbjDJRtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 13:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjDJRtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 13:49:19 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [IPv6:2001:b68:2:2800::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7477CA1;
        Mon, 10 Apr 2023 10:49:17 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 0EE71604F6;
        Mon, 10 Apr 2023 19:49:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681148955; bh=U3pOROzhqYD9ZwfVhRy9Mx+ap6JQKY0JT2AwmgsNr1k=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=lV8QPspVC8DkjFOn/+CTjNHHc7EshLx2Xa7Ap9MKBvdiaC+K9d90w73AfYSXzSdwO
         G+8CwuyNexu+XACu9dsGsIkdcQYLQwBQwpmrUnFOCa81u3SqJ6Dk0gX4J0uFrYH320
         uk1wpQ/2MtDkK2YPkmlfb5jfAgA6rUrH7YI4vC0p6RDU2clGfouhb51k4Uxa9kHW/L
         j2pwYcMyj+UtE9TBpQilpiO/Zub+evl8pwXPvlx/9r16TSBoMfZlIbzmTuNbn2/kND
         dS1YHhL4fyexkMRInafMRqTGCB8UlYNMni6mNEs09MhyqfJEhr1g8zEXz4WU1P5acJ
         WbN0fVAM08ekA==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CI-TJC3QQVxi; Mon, 10 Apr 2023 19:49:11 +0200 (CEST)
Received: from [192.168.1.4] (unknown [94.250.188.177])
        by domac.alu.hr (Postfix) with ESMTPSA id 6BA58604ED;
        Mon, 10 Apr 2023 19:49:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681148951; bh=U3pOROzhqYD9ZwfVhRy9Mx+ap6JQKY0JT2AwmgsNr1k=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=GRrY7ZCIBmyI6/oBENVauha7oHHcH+cZ51o15yYqKw+xRo2SYSkH/vmifnEKN6b4Q
         Xvcn8GD0e4a18wO5MY3pWPjA1s3BAq8oyC+jpzpmxvi3hfpYUh0ZkpBJIDpVfcCoS8
         XGzRf5lGlMDZKRJdaZOchV4JGtMVwkQ0U1jHE4tCtWgHNie4HbIY+XW/jKH17ZUabC
         aJ3HjHHkyv2BjF9Mocj/07l2+jcmZquZVOv8L7g421PelkD7/9gyuJV3NXCkfHyxHB
         lZoajKOqPiTYaWBZw9dN9apUEvZSZD1WVzdo1KRDabojSpfi6+HX9DcmxGJ/1errl2
         UoifOoLYtbwzg==
Message-ID: <8dcec198-93ba-a78c-ab5b-ee7e516b80eb@alu.unizg.hr>
Date:   Mon, 10 Apr 2023 19:49:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [BUG] [TESTING: HANG] kmemleak in rtnetlink_rcv() triggered by
 selftests/drivers/net/team in build cdc9718d5e59
Content-Language: en-US, hr
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <78a8a03b-6070-3e6b-5042-f848dab16fb8@alu.unizg.hr>
 <ZDLyZX545Cw+aLhE@shredder>
 <67b3fa90-ad29-29f1-e6f3-fb674d255a1e@alu.unizg.hr>
 <7650b2eb-0aee-a2b0-2e64-c9bc63210f67@alu.unizg.hr>
In-Reply-To: <7650b2eb-0aee-a2b0-2e64-c9bc63210f67@alu.unizg.hr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10. 04. 2023. 19:34, Mirsad Goran Todorovac wrote:
> On 09. 04. 2023. 20:47, Mirsad Goran Todorovac wrote:
>> On 09. 04. 2023. 19:14, Ido Schimmel wrote:
>>> On Sun, Apr 09, 2023 at 01:49:30PM +0200, Mirsad Goran Todorovac wrote:
>>>> Hi all,
>>>>
>>>> There appears to be a memleak triggered by the selftest drivers/net/team.
>>>
>>> Thanks for the report. Not sure it's related to team, see below.
>>
>> Not at all, I'm really encouraged that this leak is fixed so quickly and neatly.
>>
>> Now it isn't clear to me why I did not cut the possibility in half,
>> but I assumed that it was the drivers/net/team, and it wouldn't work
>> for me without the former.
>>
>> They say that the assumption is the mother of all blunders :-)
>>
>> I was lucky to choose the right entry function and the maintainers,
>> at least I hope so.
>>
>> (Additionally, I saw that bond_enslave() is Jay and Andy's support, so
>> I added them to Cc:, if that's not a problem.)
>>
>>>> # cat /sys/kernel/debug/kmemleak
>>>> unreferenced object 0xffff8c18def8ee00 (size 256):
>>>>   comm "ip", pid 5727, jiffies 4294961159 (age 954.244s)
>>>>   hex dump (first 32 bytes):
>>>>     00 20 09 de 18 8c ff ff 00 00 00 00 00 00 00 00  . ..............
>>>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>>   backtrace:
>>>>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>>>>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>>>>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>>>>     [<ffffffffb6dbc00b>] vlan_vid_add+0x11b/0x290
>>>>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>>>>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>>>>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>>>>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>>>>     [<ffffffffc176515e>] 0xffffffffc176515e
>>>
>>> Don't know what this is. Might be another issue.
>>
>> I really couldn't tell.
>>
>>>>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>>>>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>>>>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>>>>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>>>>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>>>>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>>>>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
>>>> unreferenced object 0xffff8c18250d3700 (size 32):
>>>>   comm "ip", pid 5727, jiffies 4294961159 (age 954.244s)
>>>>   hex dump (first 32 bytes):
>>>>     a0 ee f8 de 18 8c ff ff a0 ee f8 de 18 8c ff ff  ................
>>>>     81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
>>>>   backtrace:
>>>>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>>>>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>>>>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>>>>     [<ffffffffb6dbc064>] vlan_vid_add+0x174/0x290
>>>>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>>>>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>>>>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>>>>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>>>>     [<ffffffffc176515e>] 0xffffffffc176515e
>>>>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>>>>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>>>>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>>>>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>>>>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>>>>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>>>>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
>>>> unreferenced object 0xffff8c1846e16800 (size 256):
>>>>   comm "ip", pid 7837, jiffies 4295135225 (age 258.160s)
>>>>   hex dump (first 32 bytes):
>>>>     00 20 f7 de 18 8c ff ff 00 00 00 00 00 00 00 00  . ..............
>>>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>>>   backtrace:
>>>>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>>>>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>>>>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>>>>     [<ffffffffb6dbc00b>] vlan_vid_add+0x11b/0x290
>>>>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>>>>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>>>>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>>>>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>>>>     [<ffffffffc177115e>] bond_enslave+0x34e/0x1840 [bonding]
>>>
>>> This shows that the issue is related to the bond driver, not team.
>>
>> Now it seems obvious. But I am not that deep into the bond and team drivers
>> to tell without your help.
>>
>>>>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>>>>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>>>>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>>>>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>>>>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>>>>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>>>>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
>>>> unreferenced object 0xffff8c184c5ff2a0 (size 32):
>>>
>>> This is 'struct vlan_vid_info'
>>>
>>>>   comm "ip", pid 7837, jiffies 4295135225 (age 258.160s)
>>>>   hex dump (first 32 bytes):
>>>>     a0 68 e1 46 18 8c ff ff a0 68 e1 46 18 8c ff ff  .h.F.....h.F....
>>>>     81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
>>>             ^ VLAN ID 0
>>
>> This is expert insight. Looks all Greek to me.
>>
>>>>   backtrace:
>>>>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>>>>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>>>>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>>>>     [<ffffffffb6dbc064>] vlan_vid_add+0x174/0x290
>>>>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>>>>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>>>>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>>>>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>>>>     [<ffffffffc177115e>] bond_enslave+0x34e/0x1840 [bonding]
>>>>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>>>>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>>>>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>>>>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>>>>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>>>>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>>>>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
>>>
>>> VLAN ID 0 is automatically added by the 8021q driver when a net device
>>> is opened. In this case it's a device being enslaved to a bond. I
>>> believe the issue was exposed by the new bond test that was added in
>>> commit 222c94ec0ad4 ("selftests: bonding: add tests for ether type
>>> changes") as part of v6.3-rc3.
>>>
>>> The VLAN is supposed to be removed by the 8021q driver when a net device
>>> is closed and the bond driver indeed calls dev_close() when a slave is
>>> removed. However, this function is a NOP when 'IFF_UP' is not set.
>>> Unfortunately, when a bond changes its type to Ethernet this flag is
>>> incorrectly cleared in bond_ether_setup(), causing this VLAN to linger.
>>> As far as I can tell, it's not a new issue.
>>>
>>> Temporary fix is [1]. Please test it although we might end up with a
>>> different fix (needs more thinking and it's already late here).
>>
>> This fix worked.
>>
>> In case you submit a formal temporary patch, please add
>>
>> Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
>>
>> at your convenience.
>>
>> The issue doesn't seem exploitable without proper privileges, but it is a nice fix
>> nevertheless.
>>
>>> Reproduced using [2]. You can see in the before/after output how the
>>> flag is cleared/retained [3].
>>>
>>> [1]
>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>> index 236e5219c811..50dc068dc259 100644
>>> --- a/drivers/net/bonding/bond_main.c
>>> +++ b/drivers/net/bonding/bond_main.c
>>> @@ -1777,14 +1777,15 @@ void bond_lower_state_changed(struct slave *slave)
>>>  
>>>  /* The bonding driver uses ether_setup() to convert a master bond device
>>>   * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
>>> - * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
>>> + * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE and IFF_UP
>>> + * if they were set
>>>   */
>>>  static void bond_ether_setup(struct net_device *bond_dev)
>>>  {
>>> -	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
>>> +	unsigned int flags = bond_dev->flags & (IFF_SLAVE | IFF_UP);
>>>  
>>>  	ether_setup(bond_dev);
>>> -	bond_dev->flags |= IFF_MASTER | slave_flag;
>>> +	bond_dev->flags |= IFF_MASTER | flags;
>>>  	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>>>  }
>>>  
>>> [2]
>>> #!/bin/bash
>>>
>>> ip link add name t-nlmon type nlmon
>>> ip link add name t-dummy type dummy
>>> ip link add name t-bond type bond mode active-backup
>>>
>>> ip link set dev t-bond up
>>> ip link set dev t-nlmon master t-bond
>>> ip link set dev t-nlmon nomaster
>>> ip link show dev t-bond
>>> ip link set dev t-dummy master t-bond
>>> ip link show dev t-bond
>>>
>>> ip link del dev t-bond
>>> ip link del dev t-dummy
>>> ip link del dev t-nlmon
>>>
>>> [3]
>>> Before:
>>>
>>> 12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
>>>     link/netlink
>>> 12: t-bond: <BROADCAST,MULTICAST,MASTER,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>>>     link/ether ce:b2:31:0a:53:83 brd ff:ff:ff:ff:ff:ff
>>>
>>> After:
>>>
>>> 12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
>>>     link/netlink
>>> 12: t-bond: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>>>     link/ether 5a:18:e7:85:11:73 brd ff:ff:ff:ff:ff:ff
>>
>> Thank you once again for your patch and your quick response!
>>
>> Please consider Cc:-ing me for testing the official patch in the original environment.
>>
>> (Though it is a known HW, there might be BIOS update and fw issues.)
> 
> Hi, Ido,
> 
> I've ran "make kselftest" with vanilla torvalds tree 6.3-rc5 + your patch.
> 
> It failed two lines after "enslaved device client - ns-A IP" which passed OK.
> 
> Is this hang for 5 hours in selftests: net: fcnal-test.sh test, at the line
> (please see to the end):
> 
> # ###########################################################################
> # IPv4 address binds
> # ###########################################################################
> # 
> # 
> # #################################################################
> # No VRF
> # 
> # SYSCTL: net.ipv4.ping_group_range=0 2147483647
> # 
> # TEST: Raw socket bind to local address - ns-A IP                              [ OK ]
> # TEST: Raw socket bind to local address after device bind - ns-A IP            [ OK ]
> # TEST: Raw socket bind to local address - ns-A loopback IP                     [ OK ]
> # TEST: Raw socket bind to local address after device bind - ns-A loopback IP   [ OK ]
> # TEST: Raw socket bind to nonlocal address - nonlocal IP                       [ OK ]
> # TEST: TCP socket bind to nonlocal address - nonlocal IP                       [ OK ]
> # TEST: ICMP socket bind to nonlocal address - nonlocal IP                      [ OK ]
> # TEST: ICMP socket bind to broadcast address - broadcast                       [ OK ]
> # TEST: ICMP socket bind to multicast address - multicast                       [ OK ]
> # TEST: TCP socket bind to local address - ns-A IP                              [ OK ]
> # TEST: TCP socket bind to local address after device bind - ns-A IP            [ OK ]
> # 
> # #################################################################
> # With VRF
> # 
> # SYSCTL: net.ipv4.ping_group_range=0 2147483647
> # 
> # TEST: Raw socket bind to local address - ns-A IP                              [ OK ]
> # TEST: Raw socket bind to local address after device bind - ns-A IP            [ OK ]
> # TEST: Raw socket bind to local address after VRF bind - ns-A IP               [ OK ]
> # TEST: Raw socket bind to local address - VRF IP                               [ OK ]
> # TEST: Raw socket bind to local address after device bind - VRF IP             [ OK ]
> # TEST: Raw socket bind to local address after VRF bind - VRF IP                [ OK ]
> # TEST: Raw socket bind to out of scope address after VRF bind - ns-A loopback IP  [ OK ]
> # TEST: Raw socket bind to nonlocal address after VRF bind - nonlocal IP        [ OK ]
> # TEST: TCP socket bind to nonlocal address after VRF bind - nonlocal IP        [ OK ]
> # TEST: ICMP socket bind to nonlocal address after VRF bind - nonlocal IP       [ OK ]
> # TEST: ICMP socket bind to broadcast address after VRF bind - broadcast        [ OK ]
> # TEST: ICMP socket bind to multicast address after VRF bind - multicast        [ OK ]
> # TEST: TCP socket bind to local address - ns-A IP                              [ OK ]
> # TEST: TCP socket bind to local address after device bind - ns-A IP            [ OK ]
> # TEST: TCP socket bind to local address - VRF IP                               [ OK ]
> # TEST: TCP socket bind to local address after device bind - VRF IP             [ OK ]
> # TEST: TCP socket bind to invalid local address for VRF - ns-A loopback IP     [ OK ]
> # TEST: TCP socket bind to invalid local address for device bind - ns-A loopback IP  [ OK ]
> # 
> # ###########################################################################
> # Run time tests - ipv4
> # ###########################################################################
> # 
> # TEST: Device delete with active traffic - ping in - ns-A IP                   [ OK ]
> # TEST: Device delete with active traffic - ping in - VRF IP                    [ OK ]
> # TEST: Device delete with active traffic - ping out - ns-B IP                  [ OK ]
> # TEST: TCP active socket, global server - ns-A IP                              [ OK ]
> # TEST: TCP active socket, global server - VRF IP                               [ OK ]
> # TEST: TCP active socket, VRF server - ns-A IP                                 [ OK ]
> # TEST: TCP active socket, VRF server - VRF IP                                  [ OK ]
> # TEST: TCP active socket, enslaved device server - ns-A IP                     [ OK ]
> # TEST: TCP active socket, VRF client - ns-A IP                                 [ OK ]
> # TEST: TCP active socket, enslaved device client - ns-A IP                     [ OK ]
> # TEST: TCP active socket, global server, VRF client, local - ns-A IP           [ OK ]
> # TEST: TCP active socket, global server, VRF client, local - VRF IP            [ OK ]
> # TEST: TCP active socket, VRF server and client, local - ns-A IP               [ OK ]
> # TEST: TCP active socket, VRF server and client, local - VRF IP                [ OK ]
> # TEST: TCP active socket, global server, enslaved device client, local - ns-A IP  [ OK ]
> # TEST: TCP active socket, VRF server, enslaved device client, local - ns-A IP  [ OK ]
> # TEST: TCP active socket, enslaved device server and client, local - ns-A IP   [ OK ]
> # TEST: TCP passive socket, global server - ns-A IP                             [ OK ]
> # TEST: TCP passive socket, global server - VRF IP                              [ OK ]
> # TEST: TCP passive socket, VRF server - ns-A IP                                [ OK ]
> # TEST: TCP passive socket, VRF server - VRF IP                                 [ OK ]
> # TEST: TCP passive socket, enslaved device server - ns-A IP                    [ OK ]
> # TEST: TCP passive socket, VRF client - ns-A IP                                [ OK ]
> # TEST: TCP passive socket, enslaved device client - ns-A IP                    [ OK ]
> # TEST: TCP passive socket, global server, VRF client, local - ns-A IP          [ OK ]
> 
> Hope this helps.
> 
> I also have a iwlwifi DEADLOCK and I don't know if these should be reported independently.
> (I don't think it is related to the patch.)
> 
> The iwlwifi team probably has Easter Monday, so there is no rush whatsoever.
> 
> I may try to rebuild w/o the patch and re-run the tests, but now I need to do something
> for my day job.
> 
> No need to thank, this is what kernel testers are for ;-)

P.S.

Please find the kernel log in the usual directory:

→ https://domac.alu.unizg.hr/~mtodorov/linux/bugreports/drivers_net/journalctl-last-5000l.log

Have a nice day.

And happy rest of the holidays, if you had any.

Best regards,
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

"I see something approaching fast ... Will it be friends with me?"

