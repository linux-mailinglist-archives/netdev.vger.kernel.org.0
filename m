Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BEA52688E
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 19:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383103AbiEMRfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 13:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382503AbiEMRfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 13:35:33 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D42E101E8
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 10:35:30 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id kq17so17598438ejb.4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 10:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nTo5a1qzILSs2tUTVdEbD8cMd32HtmbVAy2twi+tY2g=;
        b=wyGXeKd5vFxJFmNmWMgUWHs3cEZS8Kg4bF0+IR8AbWqFQY4GEi21K0zGDcF5HN38lE
         7ybsFCqEi++lcDS3GCIrDwadEr1lnxYEQFzg3XIGXBV0LzpB6C+TahCHFzQ+SKsw2zOt
         cryQBoPOtmuaMWe5s6amsiIC6z/+6Hfr9e3OPNaMSYgPI5GhnVMrkKvNuXfGlSXZxTY/
         AppF7KWPRWnu7YozvL3M/DZXzBpldT27YyaV4whhJRU6HG7XgCMk0DpwUhnnpgTYC3L5
         TbA2BBcjZ9xdnxFcf2peaAR5RsbMI+jTa4BTNBsMTVOF6ohiPwxey0g6BQT/jPCYBOt5
         Cnsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nTo5a1qzILSs2tUTVdEbD8cMd32HtmbVAy2twi+tY2g=;
        b=KTCwR6SrNcT0arNwEjPaEWKhIepdFKO4duzsghxXJGoz7s9JRDUvT2jdqQhXzM/PeV
         ydZTctH9N4W8xa5s6jjawrfIk3wn7K3cX2OPDuUKW1kneSknmw+q91tTqH0KUFMHLfXm
         c+yLXB5agjo//Wtm6DgZO4GduZ13AAA+Okupqsz35bQycLUOOlzES+2sTALBK+0OhavR
         2lAAln+VF3AECpVJkA+hg98IuOjE+NBoJBfDpYwGe1DtBxu7XFleNGEoUE0ZGosixLin
         A6CIWZ72FztOkoh4OdIqhElAF7yee7E1wNMI7eSuOzBhG10zmGKh6OSFMhblKG/NDn6Y
         EdhA==
X-Gm-Message-State: AOAM531Jq855QbgTU4fnoKQURiCA5nR96CZlQXHL5W9AZ+KsrFl6c3R/
        A/W6SudxtG9B4xajEjqRBcktLA==
X-Google-Smtp-Source: ABdhPJww3Yj+YAZ/eqDldY5Y51sDi47Oot+amidiOz36hs9wfa6hA7pDEU71nn9lT89hJcZ+kyUSUQ==
X-Received: by 2002:a17:907:98cf:b0:6f3:9901:bc0c with SMTP id kd15-20020a17090798cf00b006f39901bc0cmr5012679ejc.315.1652463328534;
        Fri, 13 May 2022 10:35:28 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id eb8-20020a170907280800b006f39ffe23fdsm987447ejc.0.2022.05.13.10.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 10:35:28 -0700 (PDT)
Message-ID: <5476acfe-3016-6788-89bd-01ec5556f18a@blackwall.org>
Date:   Fri, 13 May 2022 20:35:26 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next v2] bond: add mac filter option for balance-xor
Content-Language: en-US
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jonathan Toppins <jtoppins@redhat.com>, netdev@vger.kernel.org,
        Long Xin <lxin@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
References: <6227427ef3b57d7de6d4d95e9dd7c9b222a37bf6.1651689665.git.jtoppins@redhat.com>
 <f85a0a66-d3b8-9d20-9abb-fc9fa5e84eab@blackwall.org>
 <d2696dab-2490-feb5-ccb2-96906fc652f0@redhat.com>
 <e29f8d2a-f9b3-36d3-13aa-d5bec16cf61b@blackwall.org>
 <28753.1652461186@famine>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <28753.1652461186@famine>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2022 19:59, Jay Vosburgh wrote:
> Nikolay Aleksandrov <razor@blackwall.org> wrote:
> 
>> On 13/05/2022 18:42, Jonathan Toppins wrote:
>>> Hi Nik, thanks for the review. Responses below.
>>>
>>> On 5/5/22 08:14, Nikolay Aleksandrov wrote:
>>>> On 04/05/2022 21:47, Jonathan Toppins wrote:
>>>>> Implement a MAC filter that prevents duplicate frame delivery when
>>>>> handling BUM traffic. This attempts to partially replicate OvS SLB
>>>>> Bonding[1] like functionality without requiring significant change
>>>>> in the Linux bridging code.
>>>>>
>>>>> A typical network setup for this feature would be:
>>>>>
>>>>>              .--------------------------------------------.
>>>>>              |         .--------------------.             |
>>>>>              |         |                    |             |
>>>>>         .-------------------.               |             |
>>>>>         |    | Bond 0  |    |               |             |
>>>>>         | .--'---. .---'--. |               |             |
>>>>>    .----|-| eth0 |-| eth1 |-|----.    .-----+----.   .----+------.
>>>>>    |    | '------' '------' |    |    | Switch 1 |   | Switch 2  |
>>>>>    |    '---,---------------'    |    |          +---+           |
>>>>>    |       /                     |    '----+-----'   '----+------'
>>>>>    |  .---'---.    .------.      |         |              |
>>>>>    |  |  br0  |----| VM 1 |      |      ~~~~~~~~~~~~~~~~~~~~~
>>>>>    |  '-------'    '------'      |     (                     )
>>>>>    |      |        .------.      |     ( Rest of Network     )
>>>>>    |      '--------| VM # |      |     (_____________________)
>>>>>    |               '------'      |
>>>>>    |  Host 1                     |
>>>>>    '-----------------------------'
>>>>>
>>>>> Where 'VM1' and 'VM#' are hosts connected to a Linux bridge, br0, with
>>>>> bond0 and its associated links, eth0 & eth1, provide ingress/egress. One
>>>>> can assume bond0, br1, and hosts VM1 to VM# are all contained in a
>>>>> single box, as depicted. Interfaces eth0 and eth1 provide redundant
>>>>> connections to the data center with the requirement to use all bandwidth
>>>>> when the system is functioning normally. Switch 1 and Switch 2 are
>>>>> physical switches that do not implement any advanced L2 management
>>>>> features such as MLAG, Cisco's VPC, or LACP.
>>>>>
>>>>> Combining this feature with vlan+srcmac hash policy allows a user to
>>>>> create an access network without the need to use expensive switches that
>>>>> support features like Cisco's VCP.
>>>>>
>>>>> [1] https://docs.openvswitch.org/en/latest/topics/bonding/#slb-bonding
>>>>>
>>>>> Co-developed-by: Long Xin <lxin@redhat.com>
>>>>> Signed-off-by: Long Xin <lxin@redhat.com>
>>>>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>>>>> ---
>>>>>
>>>>> Notes:
>>>>>      v2:
>>>>>       * dropped needless abstraction functions and put code in module init
>>>>>       * renamed variable "rc" to "ret" to stay consistent with most of the
>>>>>         code
>>>>>       * fixed parameter setting management, when arp-monitor is turned on
>>>>>         this feature will be turned off similar to how miimon and arp-monitor
>>>>>         interact
>>>>>       * renamed bond_xor_recv to bond_mac_filter_recv for a little more
>>>>>         clarity
>>>>>       * it appears the implied default return code for any bonding recv probe
>>>>>         must be `RX_HANDLER_ANOTHER`. Changed the default return code of
>>>>>         bond_mac_filter_recv to use this return value to not break skb
>>>>>         processing when the skb dev is switched to the bond dev:
>>>>>           `skb->dev = bond->dev`
>>>>>
>>>>>   Documentation/networking/bonding.rst  |  19 +++
>>>>>   drivers/net/bonding/Makefile          |   2 +-
>>>>>   drivers/net/bonding/bond_mac_filter.c | 201 ++++++++++++++++++++++++++
>>>>>   drivers/net/bonding/bond_mac_filter.h |  39 +++++
>>>>>   drivers/net/bonding/bond_main.c       |  27 ++++
>>>>>   drivers/net/bonding/bond_netlink.c    |  13 ++
>>>>>   drivers/net/bonding/bond_options.c    |  86 ++++++++++-
>>>>>   drivers/net/bonding/bonding_priv.h    |   1 +
>>>>>   include/net/bond_options.h            |   1 +
>>>>>   include/net/bonding.h                 |   3 +
>>>>>   include/uapi/linux/if_link.h          |   1 +
>>>>>   11 files changed, 390 insertions(+), 3 deletions(-)
>>>>>   create mode 100644 drivers/net/bonding/bond_mac_filter.c
>>>>>   create mode 100644 drivers/net/bonding/bond_mac_filter.h
>>>>>
>>>>
>>>> Hi Jonathan,
>>>> I must mention that this is easily solvable with two very simple ebpf programs, one on egress
>>>> to track source macs and one on ingress to filter them, it can also easily be solved by a
>>>> user-space agent that adds macs for filtering in many different ways, after all these VMs
>>>> run on the host and you don't need bond-specific knowledge to do this. Also you have no visibility
>>>> into what is currently being filtered, so it will be difficult to debug. With the above solutions
>>>> you already have that. I don't think the bond should be doing any learning or filtering, this is
>>>> deviating a lot from its purpose and adds unnecessary complexity.
>>>> That being said, if you decide to continue with the set, comments are below...
>>>
>>> This is an excellent observation, it does appear this could likely be done with eBPF. However, the delivery of such a solution to a user would be the difficult part. There appears to be no standard way for attaching a program to an interface, it still seems customary to write your own custom loader. Where would the user run this loader? In Debian likely in a post up hook with ifupdown, in Fedora one would have to write a locally custom dispatcher script (assuming Network Manager) that only ran the loader for a given interface. In short I do not see a reasonably appropriate way to deploy an eBPF program to users with the current infrastructure. Also, I am not aware of the bpf syscall supporting signed program loading. Signing kernel modules seems popular with some distros to identify limits of support and authentication of an unmodified system. I suspect similar bpf support might be needed to identify support and authentication for deployed programs.
>>>
>>
>> A great deal of the distributions (almost all major ones) out there
>> already use eBPF for various tasks, so I can't see how any of these
>> arguments apply nowadays. There are standard ways to load eBPF programs
>> that have been around for quite some time and most of the different
>> software needed to achieve that is already packaged for all major
>> distributions (and has been for a long time). Anyway getting into the
>> details of "how" the user would load the program is not really
>> pertinent to the discussion, that doesn't warrant adding so much new
>> complexity in the bonding driver which will have to be maintained
>> forever.
> 
> 	While I agree in principle that various bonding things could and
> perhaps should be done with eBPF, I think the "how" is pertinent; you
> (Nik) say that there are "standard ways" that are "packaged for all
> major distributions"; what exactly are those?
> 

All distributions have iproute2 packages (tc can be used to load the programs).
Many of them already have bpftool as well.

>> [...] Honestly, I don't like the idea of adding learning to the
>> bonding at all, I think it's the wrong place for it, especially when
>> the solution can easily be achieved with already available means.  It
>> might not even be eBPF, you can do it with a user-space agent that uses
>> nftables or some other filtering mechanism, I'm sure you can think of
>> many other ways to solve it which don't require this new
>> infrastructure. All of these ways to solve it have many advantages over
>> this (e.g. visibility into the current entries being filtered, control
>> over them and so on).
> 
> 	What user-space agent would that be?  You're proposing that
> someone would need to create the infrastructure for this themselves,
> correct?
> 

I meant it as a new solution, not an existing one. The problem could easily
be solved either with a new user-space agent that adds those filtering entries dynamically,
or through an eBPF program loaded on the interface. Point was that it doesn't require
anything bonding-specific to solve it or even anything new to be added to the kernel which
will have to be maintained forever. Also, as I already mentioned, there is no visibility or
control (except on/off) over the entries which you'll get "for free" with any of the other
solutions.

> 	I'm not really a huge fan of adding random functionality to
> bonding that is a copy of something easily available elsewhere.  This is
> basically a feature copy from OVS, and my concern is more along the
> lines of this ending up like the alb mode, which is overly complex and
> usually not the best choice.  I'll caveat that by saying that I've not
> studied the implementation here in detail, and will look for the v3 for
> review.
> 
> 	-J
> 
>> That's my opinion of course, it'd be nice to get feedback from others as well.
>>
>> Cheers,
>> Nik
>>
>>> [...]
>>>
>>>>> diff --git a/drivers/net/bonding/bond_mac_filter.c b/drivers/net/bonding/bond_mac_filter.c
>>>>> new file mode 100644
>>>>> index 000000000000..e86b2b475df3
>>>>> --- /dev/null
>>>>> +++ b/drivers/net/bonding/bond_mac_filter.c
>>>>> @@ -0,0 +1,201 @@
>>>>> +// SPDX-License-Identifier: GPL-2.0-only
>>>>> +/*
>>>>> + * Filter received frames based on MAC addresses "behind" the bond.
>>>>> + */
>>>>> +
>>>>> +#include "bonding_priv.h"
>>>>> +
>>>>> +static const struct rhashtable_params bond_rht_params = {
>>>>> +    .head_offset         = offsetof(struct bond_mac_cache_entry, rhnode),
>>>>> +    .key_offset          = offsetof(struct bond_mac_cache_entry, key),
>>>>> +    .key_len             = sizeof(struct mac_addr),
>>>>> +    .automatic_shrinking = true,
>>>>> +};
>>>>> +
>>>>> +static inline unsigned long hold_time(const struct bonding *bond)
>>>>
>>>> no inlines in .c files, let the compiler do its job
>>>>
>>>>> +{
>>>>> +    return msecs_to_jiffies(5000);
>>>>> +}
>>>>> +
>>>>> +static bool has_expired(const struct bonding *bond,
>>>>> +            struct bond_mac_cache_entry *mac)
>>>>> +{
>>>>> +    return time_before_eq(mac->used + hold_time(bond), jiffies);
>>>>> +}
>>>>> +
>>>>> +static void mac_delete_rcu(struct callback_head *head)
>>>>> +{
>>>>> +    kmem_cache_free(bond_mac_cache,
>>>>> +            container_of(head, struct bond_mac_cache_entry, rcu));
>>>>> +}
>>>>> +
>>>>> +static int mac_delete(struct bonding *bond,
>>>>> +              struct bond_mac_cache_entry *entry)
>>>>> +{
>>>>> +    int ret;
>>>>> +
>>>>> +    ret = rhashtable_remove_fast(bond->mac_filter_tbl,
>>>>> +                     &entry->rhnode,
>>>>> +                     bond->mac_filter_tbl->p);
>>>>> +    set_bit(BOND_MAC_DEAD, &entry->flags);
>>>>
>>>> you don't need the atomic bitops, these flags are all modified and checked
>>>> under the entry lock
>>>
>>> I need to keep the atomic set_bit if I remove the [use-after-free] idiomatic issue later in the file.
>>>
>>>>
>>>>> +    call_rcu(&entry->rcu, mac_delete_rcu);
>>>>
>>>> all of these entries are queued to be freed, what happens if we unload the bonding
>>>> driver before that?
>>>
>>> [...]
>>>
>>>>
>>>>> +
>>>>> +    rhashtable_walk_enter(bond->mac_filter_tbl, &iter);
>>>>> +    rhashtable_walk_start(&iter);
>>>>> +    while ((entry = rhashtable_walk_next(&iter)) != NULL) {
>>>>> +        if (IS_ERR(entry))
>>>>> +            continue;
>>>>> +
>>>>> +        spin_lock_irqsave(&entry->lock, flags);
>>>>> +        if (has_expired(bond, entry))
>>>>> +            mac_delete(bond, entry);
>>>>> +        spin_unlock_irqrestore(&entry->lock, flags);
>>>>
>>>> deleting entries while holding their own lock is not very idiomatic
>>>
>>> [use-after-free] To fix this I made has_expired take the lock, making has_expired atomic. Now there is no need to have the critical section above and mac_delete can be outside the critical section. This also removed the use-after-free bug that would appear if the code were not using RCU and cache malloc.
>>>
>>>>
>>>>> +    bond->mac_filter_tbl = kzalloc(sizeof(*bond->mac_filter_tbl),
>>>>> +                       GFP_KERNEL);
>>>>> +    if (!bond->mac_filter_tbl)
>>>>> +        return -ENOMEM;
>>>>> +
>>>>> +    ret = rhashtable_init(bond->mac_filter_tbl, &bond_rht_params);
>>>>> +    if (ret)
>>>>> +        kfree(bond->mac_filter_tbl);
>>>>
>>>> on error this is freed, but the pointer is stale and on bond destruction
>>>> will be accessed and potentially freed again
>>>
>>> set to NULL.
>>>
>>> [...]
>>>
>>>>> +static int mac_create(struct bonding *bond, const u8 *addr)
>>>>> +{
>>>>> +    struct bond_mac_cache_entry *entry;
>>>>> +    int ret;
>>>>> +
>>>>> +    entry = kmem_cache_alloc(bond_mac_cache, GFP_ATOMIC);
>>>>> +    if (!entry)
>>>>> +        return -ENOMEM;
>>>>> +    spin_lock_init(&entry->lock);
>>>>> +    memcpy(&entry->key, addr, sizeof(entry->key));
>>>>> +    entry->used = jiffies;
>>>>
>>>> you must zero the old fields, otherwise you can find stale values from old
>>>> structs which were freed
>>>
>>> good point, have done.
>>>
>>> [...]
>>>
>>>>> diff --git a/drivers/net/bonding/bond_mac_filter.h b/drivers/net/bonding/bond_mac_filter.h
>>>>> new file mode 100644
>>>>> index 000000000000..7c968d41b456
>>>>> --- /dev/null
>>>>> +++ b/drivers/net/bonding/bond_mac_filter.h
>>>>> @@ -0,0 +1,39 @@
>>>>> +/* SPDX-License-Identifier: GPL-2.0-only
>>>>> + *
>>>>> + * Filter received frames based on MAC addresses "behind" the bond.
>>>>> + */
>>>>> +
>>>>> +#ifndef _BOND_MAC_FILTER_H
>>>>> +#define _BOND_MAC_FILTER_H
>>>>> +#include <net/bonding.h>
>>>>> +#include <linux/spinlock.h>
>>>>> +#include <linux/rhashtable.h>
>>>>> +
>>>>> +enum {
>>>>> +    BOND_MAC_DEAD,
>>>>> +    BOND_MAC_LOCKED,
>>>>> +    BOND_MAC_STATIC,
>>>>
>>>> What are BOND_MAC_LOCKED or STATIC ? I didn't see them used anywhere.
>>>
>>> Stale, was going to use them to allow the user to manually add entries but never got around to it. Removed.
>>>
>>> [...]
>>>
>>>>> diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
>>>>> index 64f7db2627ce..d295903a525b 100644
>>>>> --- a/drivers/net/bonding/bond_options.c
>>>>> +++ b/drivers/net/bonding/bond_options.c
>>>
>>> [...]
>>>
>>>>> @@ -1035,6 +1075,44 @@ static int bond_option_use_carrier_set(struct bonding *bond,
>>>>>       return 0;
>>>>>   }
>>>>>   +static int bond_option_mac_filter_set(struct bonding *bond,
>>>>> +                      const struct bond_opt_value *newval)
>>>>> +{
>>>>> +    int rc = 0;
>>>>> +    u8 prev = bond->params.mac_filter;
>>>>
>>>> reverse xmas tree
>>>>
>>>>> +
>>>>> +    if (newval->value && bond->params.arp_interval) {
>>>>
>>>> what happens if we set arp_interval after enabling this, the table will be
>>>> freed while the bond is up and is using it, also the queued work is still enabled
>>>
>>> This is a good observation. To simplify the option setting I moved the init/destroy of the hash table to bond_open/close respectively. This allowed me to simply set the value of mac_filter. The only catch is in bond_option_arp_interval_set() if mac_filter is set and the interface is up, the user will receive an -EBUSY. This was the minimal amount of configuration behavioral change I could think of.
>>>
>>> Thanks,
>>> -Jon
>>>
>>
> 
> ---
> 	-Jay Vosburgh, jay.vosburgh@canonical.com

