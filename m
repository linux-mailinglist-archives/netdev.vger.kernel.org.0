Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20BAE6DC10C
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 20:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjDISrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 14:47:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjDISrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 14:47:52 -0400
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5307A3583;
        Sun,  9 Apr 2023 11:47:49 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 88CC7604F5;
        Sun,  9 Apr 2023 20:47:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681066066; bh=S6XLw+f5An0Ft9HC9mqe9bxnVEEAMY89H2G0ABTSRxs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=NFvYb53gPLspwZ0Pp5+6NYwV+NSki4ChITTouNgYEGRD1t+CokTxr1OTsWoIUd0un
         WJeiWK29c4uYR6ECb/izZpzdcEoWTzklO95kJMq2KQ6Z+vdoL7yMUhUs+FhmpqoWnD
         dOGBbBtRSxbzNh+o6A39tNwzeyhRb/90oRJ+RfMQRChKUIJszJPp3SXdm49rT5hdt8
         7YFikomZqmKf4uZAYf2y6WV1jAobburoMJx5SY7eCtqNIhIJC/6//NqsgMKfhKDiiL
         eWl/xJO1TcweToepQRJIugIKIVIs08EAGL/lNbHLxtDk9vfFgXDa1O0+aguYU+cuMC
         ZFlcrnqdtYrDw==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id H1edn5FftWM6; Sun,  9 Apr 2023 20:47:44 +0200 (CEST)
Received: from [192.168.1.4] (unknown [94.250.188.177])
        by domac.alu.hr (Postfix) with ESMTPSA id 6C10B604ED;
        Sun,  9 Apr 2023 20:47:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.unizg.hr; s=mail;
        t=1681066064; bh=S6XLw+f5An0Ft9HC9mqe9bxnVEEAMY89H2G0ABTSRxs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=0R/M3Roxm9IbnJE4H8iy97rUCOO339FN7ua/OMCsEkDWYpbQQIzK9RpM6Ja6HDc09
         zyxvviB+7buj/6l/3qXNtOTAkiMMNj80kL5xR820VDuwKuICbgOJPSUpg/VLNqvuTC
         s+LhNZkeLxqg+v//BxHHYvG86fNLQ3S6NaLWFZeobejRKsQLQrZARcvtRUjyVlao+t
         z+XvS16b5KmACYrcHD1uYrnk5lpXiIjFxiMUM8P0M4ARg1r/A+sUOwJDs8HLGuglqQ
         6bn+8CtDd7F1y32vGugYpwCUZAsxEis/9c9FKeJlTQMsnLb7l0g5VXu7Y0abnzm4Zt
         50AXU2fDUuD+g==
Message-ID: <67b3fa90-ad29-29f1-e6f3-fb674d255a1e@alu.unizg.hr>
Date:   Sun, 9 Apr 2023 20:47:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [BUG] [FIXED: TESTED] kmemleak in rtnetlink_rcv() triggered by
 selftests/drivers/net/team in build cdc9718d5e59
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
Content-Language: en-US, hr
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
In-Reply-To: <ZDLyZX545Cw+aLhE@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09. 04. 2023. 19:14, Ido Schimmel wrote:
> On Sun, Apr 09, 2023 at 01:49:30PM +0200, Mirsad Goran Todorovac wrote:
>> Hi all,
>>
>> There appears to be a memleak triggered by the selftest drivers/net/team.
> 
> Thanks for the report. Not sure it's related to team, see below.

Not at all, I'm really encouraged that this leak is fixed so quickly and neatly.

Now it isn't clear to me why I did not cut the possibility in half,
but I assumed that it was the drivers/net/team, and it wouldn't work
for me without the former.

They say that the assumption is the mother of all blunders :-)

I was lucky to choose the right entry function and the maintainers,
at least I hope so.

(Additionally, I saw that bond_enslave() is Jay and Andy's support, so
I added them to Cc:, if that's not a problem.)

>> # cat /sys/kernel/debug/kmemleak
>> unreferenced object 0xffff8c18def8ee00 (size 256):
>>   comm "ip", pid 5727, jiffies 4294961159 (age 954.244s)
>>   hex dump (first 32 bytes):
>>     00 20 09 de 18 8c ff ff 00 00 00 00 00 00 00 00  . ..............
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>>     [<ffffffffb6dbc00b>] vlan_vid_add+0x11b/0x290
>>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>>     [<ffffffffc176515e>] 0xffffffffc176515e
> 
> Don't know what this is. Might be another issue.

I really couldn't tell.

>>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
>> unreferenced object 0xffff8c18250d3700 (size 32):
>>   comm "ip", pid 5727, jiffies 4294961159 (age 954.244s)
>>   hex dump (first 32 bytes):
>>     a0 ee f8 de 18 8c ff ff a0 ee f8 de 18 8c ff ff  ................
>>     81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
>>   backtrace:
>>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>>     [<ffffffffb6dbc064>] vlan_vid_add+0x174/0x290
>>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>>     [<ffffffffc176515e>] 0xffffffffc176515e
>>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
>> unreferenced object 0xffff8c1846e16800 (size 256):
>>   comm "ip", pid 7837, jiffies 4295135225 (age 258.160s)
>>   hex dump (first 32 bytes):
>>     00 20 f7 de 18 8c ff ff 00 00 00 00 00 00 00 00  . ..............
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>>     [<ffffffffb6dbc00b>] vlan_vid_add+0x11b/0x290
>>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>>     [<ffffffffc177115e>] bond_enslave+0x34e/0x1840 [bonding]
> 
> This shows that the issue is related to the bond driver, not team.

Now it seems obvious. But I am not that deep into the bond and team drivers
to tell without your help.

>>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
>> unreferenced object 0xffff8c184c5ff2a0 (size 32):
> 
> This is 'struct vlan_vid_info'
> 
>>   comm "ip", pid 7837, jiffies 4295135225 (age 258.160s)
>>   hex dump (first 32 bytes):
>>     a0 68 e1 46 18 8c ff ff a0 68 e1 46 18 8c ff ff  .h.F.....h.F....
>>     81 00 00 00 01 00 00 00 cc cc cc cc cc cc cc cc  ................
>             ^ VLAN ID 0

This is expert insight. Looks all Greek to me.

>>   backtrace:
>>     [<ffffffffb60fb25c>] slab_post_alloc_hook+0x8c/0x3e0
>>     [<ffffffffb6102b39>] __kmem_cache_alloc_node+0x1d9/0x2a0
>>     [<ffffffffb607684e>] kmalloc_trace+0x2e/0xc0
>>     [<ffffffffb6dbc064>] vlan_vid_add+0x174/0x290
>>     [<ffffffffb6dbcffc>] vlan_device_event+0x19c/0x880
>>     [<ffffffffb5dde4d7>] raw_notifier_call_chain+0x47/0x70
>>     [<ffffffffb6ab6940>] call_netdevice_notifiers_info+0x50/0xa0
>>     [<ffffffffb6ac7574>] dev_open+0x94/0xa0
>>     [<ffffffffc177115e>] bond_enslave+0x34e/0x1840 [bonding]
>>     [<ffffffffb6ada6b0>] do_set_master+0x90/0xb0
>>     [<ffffffffb6adc5f4>] do_setlink+0x514/0x11f0
>>     [<ffffffffb6ae4507>] __rtnl_newlink+0x4e7/0xa10
>>     [<ffffffffb6ae4a8c>] rtnl_newlink+0x4c/0x70
>>     [<ffffffffb6adf334>] rtnetlink_rcv_msg+0x184/0x5d0
>>     [<ffffffffb6b6ad1e>] netlink_rcv_skb+0x5e/0x110
>>     [<ffffffffb6ada0e9>] rtnetlink_rcv+0x19/0x20
> 
> VLAN ID 0 is automatically added by the 8021q driver when a net device
> is opened. In this case it's a device being enslaved to a bond. I
> believe the issue was exposed by the new bond test that was added in
> commit 222c94ec0ad4 ("selftests: bonding: add tests for ether type
> changes") as part of v6.3-rc3.
> 
> The VLAN is supposed to be removed by the 8021q driver when a net device
> is closed and the bond driver indeed calls dev_close() when a slave is
> removed. However, this function is a NOP when 'IFF_UP' is not set.
> Unfortunately, when a bond changes its type to Ethernet this flag is
> incorrectly cleared in bond_ether_setup(), causing this VLAN to linger.
> As far as I can tell, it's not a new issue.
> 
> Temporary fix is [1]. Please test it although we might end up with a
> different fix (needs more thinking and it's already late here).

This fix worked.

In case you submit a formal temporary patch, please add

Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>

at your convenience.

The issue doesn't seem exploitable without proper privileges, but it is a nice fix
nevertheless.

> Reproduced using [2]. You can see in the before/after output how the
> flag is cleared/retained [3].
> 
> [1]
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 236e5219c811..50dc068dc259 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1777,14 +1777,15 @@ void bond_lower_state_changed(struct slave *slave)
>  
>  /* The bonding driver uses ether_setup() to convert a master bond device
>   * to ARPHRD_ETHER, that resets the target netdevice's flags so we always
> - * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE if it was set
> + * have to restore the IFF_MASTER flag, and only restore IFF_SLAVE and IFF_UP
> + * if they were set
>   */
>  static void bond_ether_setup(struct net_device *bond_dev)
>  {
> -	unsigned int slave_flag = bond_dev->flags & IFF_SLAVE;
> +	unsigned int flags = bond_dev->flags & (IFF_SLAVE | IFF_UP);
>  
>  	ether_setup(bond_dev);
> -	bond_dev->flags |= IFF_MASTER | slave_flag;
> +	bond_dev->flags |= IFF_MASTER | flags;
>  	bond_dev->priv_flags &= ~IFF_TX_SKB_SHARING;
>  }
>  
> [2]
> #!/bin/bash
> 
> ip link add name t-nlmon type nlmon
> ip link add name t-dummy type dummy
> ip link add name t-bond type bond mode active-backup
> 
> ip link set dev t-bond up
> ip link set dev t-nlmon master t-bond
> ip link set dev t-nlmon nomaster
> ip link show dev t-bond
> ip link set dev t-dummy master t-bond
> ip link show dev t-bond
> 
> ip link del dev t-bond
> ip link del dev t-dummy
> ip link del dev t-nlmon
> 
> [3]
> Before:
> 
> 12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
>     link/netlink
> 12: t-bond: <BROADCAST,MULTICAST,MASTER,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether ce:b2:31:0a:53:83 brd ff:ff:ff:ff:ff:ff
> 
> After:
> 
> 12: t-bond: <NO-CARRIER,BROADCAST,MULTICAST,MASTER,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
>     link/netlink
> 12: t-bond: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 5a:18:e7:85:11:73 brd ff:ff:ff:ff:ff:ff

Thank you once again for your patch and your quick response!

Please consider Cc:-ing me for testing the official patch in the original environment.

(Though it is a known HW, there might be BIOS update and fw issues.)

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

