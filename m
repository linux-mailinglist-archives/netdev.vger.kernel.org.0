Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6711B1C0437
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgD3Rzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3Rzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:55:35 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9589C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:55:34 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b20so1708367lff.2
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YAwfX35UFzd6AAyv2YXpwGNndjhBXbsHCYcXi8pKaz8=;
        b=dzq2UkrzkJGvJE1iqEPv9BjOdtMs4tJpwP92ceQC5W5yz5QubHL3rYXDsnAV0ZhrLs
         TjzkKl3+gZ/p39zs0ndp4U2z3hmWg5ozPHt2wJhyeURdoPGIbjK0N79quLKLRAHCJu9N
         +tR78zimlcAmXB1uRKdh2UvYpxo3kKhmX9OW8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YAwfX35UFzd6AAyv2YXpwGNndjhBXbsHCYcXi8pKaz8=;
        b=cy9BTS0+h/f0U93jB84GD/eba7ELukifTgylLBooswCSbm8W+eFj2GHNf1m3CFsWJL
         EH2YWVjBNiQLDefXbnosndSxLZJbqP2aJKEVgAvaTyhgXm0OgGtR3UltHy+L/meZbYxJ
         JTkDZvAuvyJ5zC2cF06gF9JhDuKP51j0nSdHaCwUolkzd50Osyk3FLoPTd+JvirQXQHg
         7272XQUyag4su5tiRIFDq1eokLX255kgQVW6wzACIa0s++9dIsyPrRuA7SE9/cJo769F
         fDUx7p4uvH1v8E7AlA/644FyfdOa+1rwhFTMvjH0RbYhHbD3zstwHlyK5uj9q54mbciK
         uJWg==
X-Gm-Message-State: AGi0Pua+i1iJ3aoe+R8XqBtSLoSKi9GwQNFqNPBsJ+KHj7q62QTNBD86
        CBgoiVKk89kJlY49X0rdg4DY7vBedW0CArQI
X-Google-Smtp-Source: APiQypLWqd1DVPn0LSQMSL3Oty3e+5YHIlb2J+n2JW4jv2vmSj+yVEvwb3r51afFuMJ4AtzWT5LtoQ==
X-Received: by 2002:ac2:4d12:: with SMTP id r18mr2970088lfi.181.1588269333265;
        Thu, 30 Apr 2020 10:55:33 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id z9sm341276lfd.9.2020.04.30.10.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 10:55:31 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] bridge: Allow enslaving DSA master network
 devices
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
References: <20200429161952.17769-1-olteanv@gmail.com>
 <20200429161952.17769-2-olteanv@gmail.com>
 <6b1681a7-13e1-9aaa-f765-2a327fb27555@cumulusnetworks.com>
 <147e0ee1-75f9-4dba-aff5-f7b4a078cbae@cumulusnetworks.com>
 <CA+h21hpAJDomzqTh2UBkefzWOnVbEa+EXmx9k8LXbUwhoURVZg@mail.gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <d9ce7400-2356-1304-d50d-3b54d912f065@cumulusnetworks.com>
Date:   Thu, 30 Apr 2020 20:55:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpAJDomzqTh2UBkefzWOnVbEa+EXmx9k8LXbUwhoURVZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/04/2020 20:50, Vladimir Oltean wrote:
> Hi Nikolay, Roopa,
> 
> On Wed, 29 Apr 2020 at 19:33, Nikolay Aleksandrov
> <nikolay@cumulusnetworks.com> wrote:
>>
>> +CC Roopa
>>
>> On 29/04/2020 19:27, Nikolay Aleksandrov wrote:
>>> On 29/04/2020 19:19, Vladimir Oltean wrote:
>>>> From: Florian Fainelli <f.fainelli@gmail.com>
>>>>
>>>> Commit 8db0a2ee2c63 ("net: bridge: reject DSA-enabled master netdevices
>>>> as bridge members") added a special check in br_if.c in order to check
>>>> for a DSA master network device with a tagging protocol configured. This
>>>> was done because back then, such devices, once enslaved in a bridge
>>>> would become inoperative and would not pass DSA tagged traffic anymore
>>>> due to br_handle_frame returning RX_HANDLER_CONSUMED.
>>>>
>>>> But right now we have valid use cases which do require bridging of DSA
>>>> masters. One such example is when the DSA master ports are DSA switch
>>>> ports themselves (in a disjoint tree setup). This should be completely
>>>> equivalent, functionally speaking, from having multiple DSA switches
>>>> hanging off of the ports of a switchdev driver. So we should allow the
>>>> enslaving of DSA tagged master network devices.
>>>>
>>>> Make br_handle_frame() return RX_HANDLER_PASS in order to call into the
>>>> DSA specific tagging protocol handlers, and lift the restriction from
>>>> br_add_if.
>>>>
>>>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>>>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>> ---
>>>>  net/bridge/br_if.c    | 4 +---
>>>>  net/bridge/br_input.c | 4 +++-
>>>>  2 files changed, 4 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
>>>> index ca685c0cdf95..e0fbdb855664 100644
>>>> --- a/net/bridge/br_if.c
>>>> +++ b/net/bridge/br_if.c
>>>> @@ -18,7 +18,6 @@
>>>>  #include <linux/rtnetlink.h>
>>>>  #include <linux/if_ether.h>
>>>>  #include <linux/slab.h>
>>>> -#include <net/dsa.h>
>>>>  #include <net/sock.h>
>>>>  #include <linux/if_vlan.h>
>>>>  #include <net/switchdev.h>
>>>> @@ -571,8 +570,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>>>>       */
>>>>      if ((dev->flags & IFF_LOOPBACK) ||
>>>>          dev->type != ARPHRD_ETHER || dev->addr_len != ETH_ALEN ||
>>>> -        !is_valid_ether_addr(dev->dev_addr) ||
>>>> -        netdev_uses_dsa(dev))
>>>> +        !is_valid_ether_addr(dev->dev_addr))
>>>>              return -EINVAL;
>>>>
>>>>      /* No bridging of bridges */
>>>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
>>>> index d5c34f36f0f4..396bc0c18cb5 100644
>>>> --- a/net/bridge/br_input.c
>>>> +++ b/net/bridge/br_input.c
>>>> @@ -17,6 +17,7 @@
>>>>  #endif
>>>>  #include <linux/neighbour.h>
>>>>  #include <net/arp.h>
>>>> +#include <net/dsa.h>
>>>>  #include <linux/export.h>
>>>>  #include <linux/rculist.h>
>>>>  #include "br_private.h"
>>>> @@ -263,7 +264,8 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
>>>>      struct sk_buff *skb = *pskb;
>>>>      const unsigned char *dest = eth_hdr(skb)->h_dest;
>>>>
>>>> -    if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
>>>> +    if (unlikely(skb->pkt_type == PACKET_LOOPBACK) ||
>>>> +        netdev_uses_dsa(skb->dev))
>>>>              return RX_HANDLER_PASS;
>>>>
>>>>      if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
>>>>
>>>
>>> Yet another test in fast-path for all packets.
>>> Since br_handle_frame will not be executed at all for such devices I'd suggest
>>> to look into a scheme that avoid installing rx_handler and thus prevents br_handle_frame
>>> to be called in the frist place. In case that is not possible then we can discuss adding
>>> one more test in fast-path.
>>>
>>> Actually you can just add a dummy rx_handler that simply returns RX_HANDLER_PASS for
>>> these devices and keep rx_handler_data so all br_port_get_* will continue working.
>>>
>>> Thanks,
>>>  Nik
>>>
> 
> Actually both of those are problematic, since br_port_get_check_rcu
> and br_port_get_check_rtnl check for the rx_handler pointer against
> br_handle_frame.

Right, but they can be changed to use a different validation.

> Actually a plain old revert of 8db0a2ee2c63 works just fine for what I
> need it to, not sure if there's any point in making this any more
> complicated than that.
> What do you think?
> 

Sounds much better to me if it works for you.

Thanks!

> Thanks,
> -Vladimir
> 

