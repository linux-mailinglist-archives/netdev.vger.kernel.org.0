Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187543E1443
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241189AbhHEL6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:58:52 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33640 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhHEL6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:58:52 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175BwRV8079026;
        Thu, 5 Aug 2021 06:58:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628164707;
        bh=t18hAq+J+DEmJAZPpHWlWfFRXrS+bDlU8hCbnHWmfsw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=jjjPtkcE4TmgfCIIW5AK6CJqYkzjL/IBZxk4q5oIdo4+oWDp7xfZcRsZ9s/7ttglp
         evIj7PcOtdAe5vgKC68qCqYltULNAzGktY9Wf23BzU5wh6PLHJAaIxcOyuStKNe9+l
         cOa5U9XBmo8Tv2M4C8z52hHOlh+Eko1dkQnSAtFk=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175BwRKQ114375
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 06:58:27 -0500
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 06:58:27 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 06:58:27 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175BwPSj017621;
        Thu, 5 Aug 2021 06:58:25 -0500
Subject: Re: [PATCH net-next 1/4] ethtool: runtime-resume netdev parent before
 ethtool ioctl ops
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
 <cb44d295-5267-48a7-b7c7-e4bf5b884e7a@gmail.com>
 <b4744988-4463-6463-243a-354cd87c4ced@ti.com>
 <75bdf142-f5f4-9a98-bf85-ac2cbbf1179b@gmail.com>
 <5b401877-51a2-7a67-09b4-4227a82ce027@ti.com>
 <4d84eaea-a5be-9790-8884-a2555fabf507@gmail.com>
 <ad83fe47-e9ef-73cb-06fa-765cd69f5a6d@ti.com>
 <DB8PR04MB6795F537BABC94F5893FC271E6F29@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <173d7f59-6b26-1a64-f766-a1a2ea0f3fb7@ti.com>
Date:   Thu, 5 Aug 2021 14:58:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795F537BABC94F5893FC271E6F29@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/08/2021 14:11, Joakim Zhang wrote:
> 
>> -----Original Message-----
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>> Sent: 2021年8月5日 16:21
>> To: Heiner Kallweit <hkallweit1@gmail.com>; Jakub Kicinski
>> <kuba@kernel.org>; David Miller <davem@davemloft.net>
>> Cc: netdev@vger.kernel.org; Linux PM list <linux-pm@vger.kernel.org>;
>> Andrew Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>
>> Subject: Re: [PATCH net-next 1/4] ethtool: runtime-resume netdev parent
>> before ethtool ioctl ops
>>
>>
>>
>> On 04/08/2021 22:33, Heiner Kallweit wrote:
>>> On 04.08.2021 10:43, Grygorii Strashko wrote:
>>>>
>>>>
>>>> On 04/08/2021 00:32, Heiner Kallweit wrote:
>>>>> On 03.08.2021 22:41, Grygorii Strashko wrote:
>>>>>>
>>>>>>
>>>>>> On 01/08/2021 13:36, Heiner Kallweit wrote:
>>>>>>> If a network device is runtime-suspended then:
>>>>>>> - network device may be flagged as detached and all ethtool ops
>>>>>>> (even if not
>>>>>>>       accessing the device) will fail because
>>>>>>> netif_device_present() returns
>>>>>>>       false
>>>>>>> - ethtool ops may fail because device is not accessible (e.g.
>>>>>>> because being
>>>>>>>       in D3 in case of a PCI device)
>>>>>>>
>>>>>>> It may not be desirable that userspace can't use even simple
>>>>>>> ethtool ops that not access the device if interface or link is
>>>>>>> down. To be more friendly to userspace let's ensure that device is
>>>>>>> runtime-resumed when executing the respective ethtool op in kernel.
>>>>>>>
>>>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>>> ---
>>>>>>>      net/ethtool/ioctl.c | 18 +++++++++++++++---
>>>>>>>      1 file changed, 15 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c index
>>>>>>> baa5d1004..b7ff9abe7 100644
>>>>>>> --- a/net/ethtool/ioctl.c
>>>>>>> +++ b/net/ethtool/ioctl.c
>>>>>>> @@ -23,6 +23,7 @@
>>>>>>>      #include <linux/rtnetlink.h>
>>>>>>>      #include <linux/sched/signal.h>
>>>>>>>      #include <linux/net.h>
>>>>>>> +#include <linux/pm_runtime.h>
>>>>>>>      #include <net/devlink.h>
>>>>>>>      #include <net/xdp_sock_drv.h>
>>>>>>>      #include <net/flow_offload.h>
>>>>>>> @@ -2589,7 +2590,7 @@ int dev_ethtool(struct net *net, struct
>>>>>>> ifreq *ifr)
>>>>>>>          int rc;
>>>>>>>          netdev_features_t old_features;
>>>>>>>      -    if (!dev || !netif_device_present(dev))
>>>>>>> +    if (!dev)
>>>>>>>              return -ENODEV;
>>>>>>>            if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
>>>>>>> @@ -2645,10 +2646,18 @@ int dev_ethtool(struct net *net, struct
>>>>>>> ifreq *ifr)
>>>>>>>                  return -EPERM;
>>>>>>>          }
>>>>>>>      +    if (dev->dev.parent)
>>>>>>> +        pm_runtime_get_sync(dev->dev.parent);
>>>>>>
>>>>>> the PM Runtime should allow to wake up parent when child is resumed if
>> everything is configured properly.
>>>>>>
>>>>> Not sure if there's any case yet where the netdev-embedded device is
>> power-managed.
>>>>> Typically only the parent (e.g. a PCI device) is.
>>>>>
>>>>>> rpm_resume()
>>>>>> ...
>>>>>>        if (!parent && dev->parent) {
>>>>>>     --> here
>>>>>>
>>>>> Currently we don't get that far because we will bail out here already:
>>>>>
>>>>> else if (dev->power.disable_depth > 0)
>>>>>           retval = -EACCES;
>>>>>
>>>>> If netdev-embedded device isn't power-managed then disable_depth is 1.
>>>>
>>>> Right. But if pm_runtime_enable() is added for ndev->dev then PM
>>>> runtime will start working for it and should handle parent properly -
>>>> from my experience, every time any code need manipulate with "parent" or
>> smth. else to make PM runtime working it means smth. is wrong.
>>>>
>>>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c index
>>>> f6197774048b..33b72b788aa2 100644
>>>> --- a/net/core/net-sysfs.c
>>>> +++ b/net/core/net-sysfs.c
>>>> @@ -1963,6 +1963,7 @@ int netdev_register_kobject(struct net_device
>>>> *ndev)
>>>>           }
>>>>
>>>>           pm_runtime_set_memalloc_noio(dev, true);
>>>> +       pm_runtime_enable(dev);
>>>>
>>>>           return error;
>>>>    }
>>>>
>>>>
>>>>>
>>>>>> So, hence PM runtime calls are moved to from drivers to net_core
>>>>>> wouldn't be more correct approach to enable PM runtime for netdev->dev
>> and lets PM runtime do the job?
>>>>>>
>>>>> Where would netdev->dev be runtime-resumed so that
>> netif_device_present() passes?
>>>>
>>>> That's the biggest issues here. Some driver uses
>>>> netif_device_detach() in PM runtime and, this way, introduces custom
>> dependency between Core device PM (runtime) sate and Net core, other driver
>> does not do.
>>>> Does it means every driver with PM runtime now have to be updated to
>> indicate it PM state to Net core with netif_device_detach()?
>>>
>>> No, that's not needed.
>>>
>>>> Why? Why return value from pm_runtime_get calls is not enough?
>>>>
>>>> Believe me it's terrible idea to introduce custom PM state dependency
>>>> between PM runtime and Net core, for example it took years to sync
>> properly System wide suspend and PM runtime which are separate framworks.
>>>>
>>>> By the way netif_device_detach() during System Wide suspend is looks
>>>> perfectly valid, because entering System wide Suspend should prohibit
>>>> any access to netdev at some stage. And that's what 99% of network
>>>> drivers are doing (actually I can find only ./realtek/r8169_main.c
>>>> which abuse netif_device_detach() function and, I assume, it is your
>>>> case)
>>>>
>>> Actually I was inspired by the Intel drivers, see e.g.
>>> __igc_shutdown(). They also detach the netdevice on runtime suspend.
>>> One reason is that several core functions check for device presence
>>> before e.g. calling a ndo callback. Example: dev_set_mtu_ext()
>>
>> right and also:
>> - netlink - which you've hacked already
>> - 8021q:
>> vlan_dev_ioctl/vlan_dev_neigh_setup/vlan_add_rx_filter_info/vlan_kill_rx_filte
>> r_info
> 
> Yes, there are many place need to do such check. I always face a problem that where I need to
> runtime-resume the device, is there any suggestion? I always add it when an issue came out.
> 
> What confuse me it that, is there any document describe that which .ndo callback should be called
> with interface up, instead .ndo callback _CAN_ be called with interface down? I think this can help
> us decide when we need runtime-resume device.

In general, you can assume that any ndo can be called which are not part of data path (xmit, watchdog, irq/napi),
so the only option is to put netif down and go through every ndo testing.

> 
> After leaning all your discussion, from my point of view, it seems not a good choice to add RPM
> to net core. It had better handled by driver itself.


-- 
Best regards,
grygorii
