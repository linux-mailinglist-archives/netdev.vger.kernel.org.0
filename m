Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E915676288
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfGZJ01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 05:26:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33839 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfGZJ01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:26:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id w9so37572709wmd.1
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 02:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yAlmetSau4JpsYsOXgnMOz5VqkVT3TgR1F5e1YGklgc=;
        b=H4UbmT7qC9fZxoMDpNMUzt+GXicV51GrqaAEqaxzQSfGvVM7UDEvLPRlCztVDWssXI
         fURLW8T8DOeAEy2YdtprPkjzVDlyTKxhVxSkc2Cp1K5Pdh95/5figTrOdQkxD7o922Jh
         dJNLMH7rt7i8cfmlKpnSg5TwooNRjwxX43jG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yAlmetSau4JpsYsOXgnMOz5VqkVT3TgR1F5e1YGklgc=;
        b=QUqonnc8C3Cem4Ymr2aPPfoxnHvVR2H2fkIdDsvcu+WbCtnGFnJzOCT6BD1wck4UI7
         wPU1CsVmIX6ltiwyuDe4CuTEzE3kjVxkUTDELwG3gvw0k2HvoowNDgPJDUtnYPUQeE1S
         oiZ6Y5tAfMTFD/56/bIgHF0J+HgkrYGFqFlfyfoIoNv18DMhNFzVnQBXHyZhIKWnVR81
         5pdO2JptxheZspLIPXMIXXU1A5l57xHEpMImgzinyaesHBX44FV2qrDiYjaJ+57ELmoP
         jssWM034XzVfhLle9CzElT8NiGF4pZg5H6c5IYRuvnyj38bYBMcnEfj/NyYCxtsCdBd3
         k+Fg==
X-Gm-Message-State: APjAAAX9ptbaKmZXmRlxIqmUxXdXEEIlsCQynAPpL6N55M3oSMIyXekA
        x32Bwg5XTJGchAUw1B28KJ8pEQ==
X-Google-Smtp-Source: APXvYqyskWqXyumKsOoVMV5Xd5XnvR0IWtK4g9S4QSM8XY/CZ7l7B6rqLJslxVZvgMHH0NWBaksV0A==
X-Received: by 2002:a1c:630a:: with SMTP id x10mr88654134wmb.113.1564133184533;
        Fri, 26 Jul 2019 02:26:24 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t140sm47111096wmt.0.2019.07.26.02.26.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 02:26:23 -0700 (PDT)
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
Message-ID: <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
Date:   Fri, 26 Jul 2019 12:26:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/07/2019 11:41, Nikolay Aleksandrov wrote:
> On 25/07/2019 17:21, Horatiu Vultur wrote:
>> Hi Nikolay,
>>
>> The 07/25/2019 16:21, Nikolay Aleksandrov wrote:
>>> External E-Mail
>>>
>>>
>>> On 25/07/2019 16:06, Nikolay Aleksandrov wrote:
>>>> On 25/07/2019 14:44, Horatiu Vultur wrote:
>>>>> There is no way to configure the bridge, to receive only specific link
>>>>> layer multicast addresses. From the description of the command 'bridge
>>>>> fdb append' is supposed to do that, but there was no way to notify the
>>>>> network driver that the bridge joined a group, because LLADDR was added
>>>>> to the unicast netdev_hw_addr_list.
>>>>>
>>>>> Therefore update fdb_add_entry to check if the NLM_F_APPEND flag is set
>>>>> and if the source is NULL, which represent the bridge itself. Then add
>>>>> address to multicast netdev_hw_addr_list for each bridge interfaces.
>>>>> And then the .ndo_set_rx_mode function on the driver is called. To notify
>>>>> the driver that the list of multicast mac addresses changed.
>>>>>
>>>>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>>>>> ---
>>>>>  net/bridge/br_fdb.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
>>>>>  1 file changed, 46 insertions(+), 3 deletions(-)
>>>>>
>>>>
>>>> Hi,
>>>> I'm sorry but this patch is wrong on many levels, some notes below. In general
>>>> NLM_F_APPEND is only used in vxlan, the bridge does not handle that flag at all.
>>>> FDB is only for *unicast*, nothing is joined and no multicast should be used with fdbs.
>>>> MDB is used for multicast handling, but both of these are used for forwarding.
>>>> The reason the static fdbs are added to the filter is for non-promisc ports, so they can
>>>> receive traffic destined for these FDBs for forwarding.
>>>> If you'd like to join any multicast group please use the standard way, if you'd like to join
>>>> it only on a specific port - join it only on that port (or ports) and the bridge and you'll
>>>
>>> And obviously this is for the case where you're not enabling port promisc mode (non-default).
>>> In general you'll only need to join the group on the bridge to receive traffic for it
>>> or add it as an mdb entry to forward it.
>>>
>>>> have the effect that you're describing. What do you mean there's no way ?
>>
>> Thanks for the explanation.
>> There are few things that are not 100% clear to me and maybe you can
>> explain them, not to go totally in the wrong direction. Currently I am
>> writing a network driver on which I added switchdev support. Then I was
>> looking for a way to configure the network driver to copy link layer
>> multicast address to the CPU port.
>>
>> If I am using bridge mdb I can do it only for IP multicast addreses,
>> but how should I do it if I want non IP frames with link layer multicast
>> address to be copy to CPU? For example: all frames with multicast
>> address '01-21-6C-00-00-01' to be copy to CPU. What is the user space
>> command for that?
>>
> 
> Check SIOCADDMULTI (ip maddr from iproute2), f.e. add that mac to the port
> which needs to receive it and the bridge will send it up automatically since
> it's unknown mcast (note that if there's a querier, you'll have to make the
> bridge mcast router if it is not the querier itself). It would also flood it to all

Actually you mentioned non-IP traffic, so the querier stuff is not a problem. This
traffic will always be flooded by the bridge (and also a copy will be locally sent up).
Thus only the flooding may need to be controlled.

> other ports so you may want to control that. It really depends on the setup
> and the how the hardware is configured.
> 
>>>>
>>>> In addition you're allowing a mix of mcast functions to be called with unicast addresses
>>>> and vice versa, it is not that big of a deal because the kernel will simply return an error
>>>> but still makes no sense.
>>>>
>>>> Nacked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>>>
>>>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>>>> index b1d3248..d93746d 100644
>>>>> --- a/net/bridge/br_fdb.c
>>>>> +++ b/net/bridge/br_fdb.c
>>>>> @@ -175,6 +175,29 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
>>>>>  	}
>>>>>  }
>>>>>  
>>>>> +static void fdb_add_hw_maddr(struct net_bridge *br, const unsigned char *addr)
>>>>> +{
>>>>> +	int err;
>>>>> +	struct net_bridge_port *p;
>>>>> +
>>>>> +	ASSERT_RTNL();
>>>>> +
>>>>> +	list_for_each_entry(p, &br->port_list, list) {
>>>>> +		if (!br_promisc_port(p)) {
>>>>> +			err = dev_mc_add(p->dev, addr);
>>>>> +			if (err)
>>>>> +				goto undo;
>>>>> +		}
>>>>> +	}
>>>>> +
>>>>> +	return;
>>>>> +undo:
>>>>> +	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
>>>>> +		if (!br_promisc_port(p))
>>>>> +			dev_mc_del(p->dev, addr);
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>  /* When a static FDB entry is deleted, the HW address from that entry is
>>>>>   * also removed from the bridge private HW address list and updates all
>>>>>   * the ports with needed information.
>>>>> @@ -192,13 +215,27 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
>>>>>  	}
>>>>>  }
>>>>>  
>>>>> +static void fdb_del_hw_maddr(struct net_bridge *br, const unsigned char *addr)
>>>>> +{
>>>>> +	struct net_bridge_port *p;
>>>>> +
>>>>> +	ASSERT_RTNL();
>>>>> +
>>>>> +	list_for_each_entry(p, &br->port_list, list) {
>>>>> +		if (!br_promisc_port(p))
>>>>> +			dev_mc_del(p->dev, addr);
>>>>> +	}
>>>>> +}
>>>>> +
>>>>>  static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>>>  		       bool swdev_notify)
>>>>>  {
>>>>>  	trace_fdb_delete(br, f);
>>>>>  
>>>>> -	if (f->is_static)
>>>>> +	if (f->is_static) {
>>>>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>>>> +		fdb_del_hw_maddr(br, f->key.addr.addr);
>>>>
>>>> Walking over all ports again for each static delete is a no-go.
>>>>
>>>>> +	}
>>>>>  
>>>>>  	hlist_del_init_rcu(&f->fdb_node);
>>>>>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
>>>>> @@ -843,13 +880,19 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>>>>>  			fdb->is_local = 1;
>>>>>  			if (!fdb->is_static) {
>>>>>  				fdb->is_static = 1;
>>>>> -				fdb_add_hw_addr(br, addr);
>>>>> +				if (flags & NLM_F_APPEND && !source)
>>>>> +					fdb_add_hw_maddr(br, addr);
>>>>> +				else
>>>>> +					fdb_add_hw_addr(br, addr);
>>>>>  			}
>>>>>  		} else if (state & NUD_NOARP) {
>>>>>  			fdb->is_local = 0;
>>>>>  			if (!fdb->is_static) {
>>>>>  				fdb->is_static = 1;
>>>>> -				fdb_add_hw_addr(br, addr);
>>>>> +				if (flags & NLM_F_APPEND && !source)
>>>>> +					fdb_add_hw_maddr(br, addr);
>>>>> +				else
>>>>> +					fdb_add_hw_addr(br, addr);
>>>>>  			}
>>>>>  		} else {
>>>>>  			fdb->is_local = 0;
>>>>>
>>>>
>>>
>>
> 

