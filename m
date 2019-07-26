Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E797E7610C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 10:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfGZIly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 04:41:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43213 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfGZIlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 04:41:53 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so53479838wru.10
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 01:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOD0eDKBsadwb7rlX8HF+mccHVvV9gEzay7E0Ugbx38=;
        b=cRId55vCURnCQyjkMaZBGu534NbuKZjsGnQbo+iX/eDhPS0W/boJ/goq7si1NpIBWy
         zjJ0C52SH+lGdUIap36KH3tRIQzexS/XPN4SpHFVGR9IOJOKYygCyvaa6jCqjHjESKAB
         izZO6PKVjGnIX8fvUTfAl4t+PF6x8llandO+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOD0eDKBsadwb7rlX8HF+mccHVvV9gEzay7E0Ugbx38=;
        b=P8Tnu7EkkfjAP+hv6n/mtUuFxfEnioPn1WeOLKSZZKy0LYDd8Ix1jUzM4V83nyfh4u
         w9cWQRWbvboma06RTu3l+FhkTQZbMpwaBFDKwRXvfxBUeqF7JyWRdcvgktexv+YocBTA
         EpUGfd9uwKWyvtoDPNDEcwORt9u6psAfirSR3WUpTDoOMX1L2KoAKhEhsPE0T4M2BM1B
         kWHmz10mLpidzWLokw5FjUwXIddSEcYM1dsfoR9SSa2iPz2vGjCsWDUXtW8mR9sLQbL2
         erh6gY+TVYUsXxFlsr2pJcCTABodm246xyI14kxoPzCOGCJEw3ZqdHjDsEKW2pOYuMlN
         KatA==
X-Gm-Message-State: APjAAAUnQgCrJ2zw1q4rBmdUqsZ3p4V9JjU5EEGjBWSQlPiw3MazXWBm
        eAqQ943mzSzzpeHPNg4DZN1XHPOj50I=
X-Google-Smtp-Source: APXvYqwf/SeeoTCPYynnjDIqO+6/ZI+Jt2TvRu9zwVbRCD9L3D5FXc1ctvPMlW2s29wsamCrsef5nw==
X-Received: by 2002:adf:ed11:: with SMTP id a17mr12163393wro.112.1564130510627;
        Fri, 26 Jul 2019 01:41:50 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id c7sm46218730wro.70.2019.07.26.01.41.49
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 01:41:50 -0700 (PDT)
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
Date:   Fri, 26 Jul 2019 11:41:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/07/2019 17:21, Horatiu Vultur wrote:
> Hi Nikolay,
> 
> The 07/25/2019 16:21, Nikolay Aleksandrov wrote:
>> External E-Mail
>>
>>
>> On 25/07/2019 16:06, Nikolay Aleksandrov wrote:
>>> On 25/07/2019 14:44, Horatiu Vultur wrote:
>>>> There is no way to configure the bridge, to receive only specific link
>>>> layer multicast addresses. From the description of the command 'bridge
>>>> fdb append' is supposed to do that, but there was no way to notify the
>>>> network driver that the bridge joined a group, because LLADDR was added
>>>> to the unicast netdev_hw_addr_list.
>>>>
>>>> Therefore update fdb_add_entry to check if the NLM_F_APPEND flag is set
>>>> and if the source is NULL, which represent the bridge itself. Then add
>>>> address to multicast netdev_hw_addr_list for each bridge interfaces.
>>>> And then the .ndo_set_rx_mode function on the driver is called. To notify
>>>> the driver that the list of multicast mac addresses changed.
>>>>
>>>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>>>> ---
>>>>  net/bridge/br_fdb.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
>>>>  1 file changed, 46 insertions(+), 3 deletions(-)
>>>>
>>>
>>> Hi,
>>> I'm sorry but this patch is wrong on many levels, some notes below. In general
>>> NLM_F_APPEND is only used in vxlan, the bridge does not handle that flag at all.
>>> FDB is only for *unicast*, nothing is joined and no multicast should be used with fdbs.
>>> MDB is used for multicast handling, but both of these are used for forwarding.
>>> The reason the static fdbs are added to the filter is for non-promisc ports, so they can
>>> receive traffic destined for these FDBs for forwarding.
>>> If you'd like to join any multicast group please use the standard way, if you'd like to join
>>> it only on a specific port - join it only on that port (or ports) and the bridge and you'll
>>
>> And obviously this is for the case where you're not enabling port promisc mode (non-default).
>> In general you'll only need to join the group on the bridge to receive traffic for it
>> or add it as an mdb entry to forward it.
>>
>>> have the effect that you're describing. What do you mean there's no way ?
> 
> Thanks for the explanation.
> There are few things that are not 100% clear to me and maybe you can
> explain them, not to go totally in the wrong direction. Currently I am
> writing a network driver on which I added switchdev support. Then I was
> looking for a way to configure the network driver to copy link layer
> multicast address to the CPU port.
> 
> If I am using bridge mdb I can do it only for IP multicast addreses,
> but how should I do it if I want non IP frames with link layer multicast
> address to be copy to CPU? For example: all frames with multicast
> address '01-21-6C-00-00-01' to be copy to CPU. What is the user space
> command for that?
> 

Check SIOCADDMULTI (ip maddr from iproute2), f.e. add that mac to the port
which needs to receive it and the bridge will send it up automatically since
it's unknown mcast (note that if there's a querier, you'll have to make the
bridge mcast router if it is not the querier itself). It would also flood it to all
other ports so you may want to control that. It really depends on the setup
and the how the hardware is configured.

>>>
>>> In addition you're allowing a mix of mcast functions to be called with unicast addresses
>>> and vice versa, it is not that big of a deal because the kernel will simply return an error
>>> but still makes no sense.
>>>
>>> Nacked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>>
>>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>>> index b1d3248..d93746d 100644
>>>> --- a/net/bridge/br_fdb.c
>>>> +++ b/net/bridge/br_fdb.c
>>>> @@ -175,6 +175,29 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
>>>>  	}
>>>>  }
>>>>  
>>>> +static void fdb_add_hw_maddr(struct net_bridge *br, const unsigned char *addr)
>>>> +{
>>>> +	int err;
>>>> +	struct net_bridge_port *p;
>>>> +
>>>> +	ASSERT_RTNL();
>>>> +
>>>> +	list_for_each_entry(p, &br->port_list, list) {
>>>> +		if (!br_promisc_port(p)) {
>>>> +			err = dev_mc_add(p->dev, addr);
>>>> +			if (err)
>>>> +				goto undo;
>>>> +		}
>>>> +	}
>>>> +
>>>> +	return;
>>>> +undo:
>>>> +	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
>>>> +		if (!br_promisc_port(p))
>>>> +			dev_mc_del(p->dev, addr);
>>>> +	}
>>>> +}
>>>> +
>>>>  /* When a static FDB entry is deleted, the HW address from that entry is
>>>>   * also removed from the bridge private HW address list and updates all
>>>>   * the ports with needed information.
>>>> @@ -192,13 +215,27 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
>>>>  	}
>>>>  }
>>>>  
>>>> +static void fdb_del_hw_maddr(struct net_bridge *br, const unsigned char *addr)
>>>> +{
>>>> +	struct net_bridge_port *p;
>>>> +
>>>> +	ASSERT_RTNL();
>>>> +
>>>> +	list_for_each_entry(p, &br->port_list, list) {
>>>> +		if (!br_promisc_port(p))
>>>> +			dev_mc_del(p->dev, addr);
>>>> +	}
>>>> +}
>>>> +
>>>>  static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>>  		       bool swdev_notify)
>>>>  {
>>>>  	trace_fdb_delete(br, f);
>>>>  
>>>> -	if (f->is_static)
>>>> +	if (f->is_static) {
>>>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>>> +		fdb_del_hw_maddr(br, f->key.addr.addr);
>>>
>>> Walking over all ports again for each static delete is a no-go.
>>>
>>>> +	}
>>>>  
>>>>  	hlist_del_init_rcu(&f->fdb_node);
>>>>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
>>>> @@ -843,13 +880,19 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>>>>  			fdb->is_local = 1;
>>>>  			if (!fdb->is_static) {
>>>>  				fdb->is_static = 1;
>>>> -				fdb_add_hw_addr(br, addr);
>>>> +				if (flags & NLM_F_APPEND && !source)
>>>> +					fdb_add_hw_maddr(br, addr);
>>>> +				else
>>>> +					fdb_add_hw_addr(br, addr);
>>>>  			}
>>>>  		} else if (state & NUD_NOARP) {
>>>>  			fdb->is_local = 0;
>>>>  			if (!fdb->is_static) {
>>>>  				fdb->is_static = 1;
>>>> -				fdb_add_hw_addr(br, addr);
>>>> +				if (flags & NLM_F_APPEND && !source)
>>>> +					fdb_add_hw_maddr(br, addr);
>>>> +				else
>>>> +					fdb_add_hw_addr(br, addr);
>>>>  			}
>>>>  		} else {
>>>>  			fdb->is_local = 0;
>>>>
>>>
>>
> 

