Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880F81C0438
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbgD3R4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3R4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:56:45 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F452C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:56:45 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id b18so2227898ilf.2
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BwbahxsG+KHenJmfi2a6APaEYz00sv2G+e/c6gcXcGc=;
        b=PIp6isw19iqdbNct2t+9cMW9Q1X3yRTqff60dZAz7YXay2aGf8t7PSnzI+jB8qj3G5
         oaUWs5Bkq5IBLo0XYiVUuZVxU/sg64rkgskJSWfSEu99HfIDamu+pmjDOb7JQ+n2rUBg
         o1inOLvowJswfb/1ra3EN94/Z3k7o8ClYo4u18hECvHhYP0HfhMmxa043FizNdBGsJ+1
         nB+0hjTG574RPet6fxByS/IOexKRjLY3KQfbNfKYULEcrJ2asXyjzU7hvGo1LC9M6JLY
         jxHDJNBm3n3WWpXCj77nEk5v8NVfek12XakY2odxJhKUdMC/7ZXYkfQnNOES960oiYf5
         ppiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BwbahxsG+KHenJmfi2a6APaEYz00sv2G+e/c6gcXcGc=;
        b=eIevlC908T0JcSamAyLe/6zuvbnjLb4dTHy1bOh7nTx1yCyI7P4LN4Jsh0Wr/GX+oK
         HTxu3J7DrJ31sesQKpX4eTExsiRZKtTT92QDFmUbWN6qsbLn6553/bqueXLM8AB0jN6C
         fBfRHAXQqsf0HjXzXmRXlpUF+tj3TlkIblcixFNgTPILPIVfNzPkvQOFtT9n3aSyU8iE
         jTppjD8sKHZtMrz+0x0939reQkM7KViu7fvE8gP9nKO3PG4LUdcE73fPIZ18Jto9o3sE
         ycF9zk1j3nWwpjoz7unP7VR6lZK5+wmksPNXTUeXII2wkPf4Z1M69YLInvhsl24qYnuH
         uNOg==
X-Gm-Message-State: AGi0PuYwJVRVUGbHppzJYVkSvKUOx/zWPnzysq8ro080AdVfyHVd9keS
        FrrRXIDlVGZt2hBpVM4c1Uc=
X-Google-Smtp-Source: APiQypJlKh31yypp91YWhoo1veQbXJf5NvqUSQfVZLTe3+e2SmMvn+XmcVfN+sr4I4nJr1DzD1ZwLA==
X-Received: by 2002:a92:2912:: with SMTP id l18mr3270967ilg.28.1588269404501;
        Thu, 30 Apr 2020 10:56:44 -0700 (PDT)
Received: from [10.67.49.116] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id n64sm167556ild.85.2020.04.30.10.56.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 10:56:43 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] bridge: Allow enslaving DSA master network
 devices
To:     Vladimir Oltean <olteanv@gmail.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <804c28dc-8c7b-db88-6422-cca72da6abe4@gmail.com>
Date:   Thu, 30 Apr 2020 10:56:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hpAJDomzqTh2UBkefzWOnVbEa+EXmx9k8LXbUwhoURVZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 10:50 AM, Vladimir Oltean wrote:
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
> Actually a plain old revert of 8db0a2ee2c63 works just fine for what I
> need it to, not sure if there's any point in making this any more
> complicated than that.
> What do you think?

We would still be leaving single switch fabric with no nested tagging
non functional if we allow a DSA master to be enslaved into the bridge I
believe, unless something changed in how handlers are processed between
8db0a2ee2c63 and now.

From what you described to me, your Ocelot/Felix interfaces are DSA
slaves from one side, and DSA master for the sja1105 network devices. We
could change the netdev_uses_dsa() into something slightly more
elaborate, which is reflective of whether there is nested tagging being
used.
-- 
Florian
