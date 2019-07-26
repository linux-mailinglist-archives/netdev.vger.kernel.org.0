Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 421E3765C7
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 14:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727284AbfGZMbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 08:31:36 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39328 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726607AbfGZMbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 08:31:36 -0400
Received: by mail-wr1-f67.google.com with SMTP id x4so1114517wrt.6
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 05:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7X/GDvNX0iF/R7FDctdbttRhHplsgJEUlK8Fi5N6Q1M=;
        b=BTMLUrwTsxw6UCQOMrjbOXPoR44gS9ETaVLzAkiNCnQTndUDQSGnHyqaJniFxH0d/k
         0fzLDTskXXDROZcZGbEJQULRQUxYrXw76Llpt4lSJgYFbr60PIzLT/j2WAZkCfNa3NAm
         8N8kz7OxcHKsnaDixLcjPFo9PKDIyoFrISaek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7X/GDvNX0iF/R7FDctdbttRhHplsgJEUlK8Fi5N6Q1M=;
        b=O4dmVkKrhElmNPQHEuxSxWpbShQngxAEV+n9TFK3P3E2qSMDCp8ZNaO6Hn2ZH9AoFd
         LIb+uKVe7gsDcL1uSIDGVDDKPdPV6HpiHc2QXHaRtwGonco+CliBerGlOKHBf44kTP/I
         yo+1Ug1h+a70WinOr+I0txdYINoNyKDaeOkMWp2rVS4BwXlOTXdSdjTJ2UT0qXWtchf2
         BFlg2MDh2WUfE4ij7syyv/j3HpTfjOJ+Pgw7mSQQhz1oHryuUM/1JSs8gmA5ZH9pz66+
         LIY+prBe1gpAtIMZDPsx9Js2SWyBYx5/Upj+TVi4JB7Fa1v9xHeHuSB1ESB1lzIARdWT
         zFDA==
X-Gm-Message-State: APjAAAUtGtum8wsLhtqcnU2o/V2DtIMkQ9mD3gixO6g6VpdR6Kuma3IR
        ysrEys9jlvfOWHOQNv9y5XcY2A==
X-Google-Smtp-Source: APXvYqxtqAoQh86SU0E1zJMJ+G3PzvCIrYuLltqSTUF+XCpSjlhG3x+VWzhIehzBxjq7bcmwE8O4ZA==
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr235332wrx.82.1564144292496;
        Fri, 26 Jul 2019 05:31:32 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id n14sm96717498wra.75.2019.07.26.05.31.31
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 05:31:31 -0700 (PDT)
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, allan.nielsen@microchip.com
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <b755f613-e6d8-a2e6-16cd-6f13ec0a6ddc@cumulusnetworks.com>
Date:   Fri, 26 Jul 2019 15:31:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/07/2019 15:02, Horatiu Vultur wrote:
> Hi Nikolay,
> 
> The 07/26/2019 12:26, Nikolay Aleksandrov wrote:
>> External E-Mail
>>
>>
>> On 26/07/2019 11:41, Nikolay Aleksandrov wrote:
>>> On 25/07/2019 17:21, Horatiu Vultur wrote:
>>>> Hi Nikolay,
>>>>
>>>> The 07/25/2019 16:21, Nikolay Aleksandrov wrote:
>>>>> External E-Mail
>>>>>
>>>>>
>>>>> On 25/07/2019 16:06, Nikolay Aleksandrov wrote:
>>>>>> On 25/07/2019 14:44, Horatiu Vultur wrote:
>>>>>>> There is no way to configure the bridge, to receive only specific link
>>>>>>> layer multicast addresses. From the description of the command 'bridge
>>>>>>> fdb append' is supposed to do that, but there was no way to notify the
>>>>>>> network driver that the bridge joined a group, because LLADDR was added
>>>>>>> to the unicast netdev_hw_addr_list.
>>>>>>>
>>>>>>> Therefore update fdb_add_entry to check if the NLM_F_APPEND flag is set
>>>>>>> and if the source is NULL, which represent the bridge itself. Then add
>>>>>>> address to multicast netdev_hw_addr_list for each bridge interfaces.
>>>>>>> And then the .ndo_set_rx_mode function on the driver is called. To notify
>>>>>>> the driver that the list of multicast mac addresses changed.
>>>>>>>
>>>>>>> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
>>>>>>> ---
>>>>>>>  net/bridge/br_fdb.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
>>>>>>>  1 file changed, 46 insertions(+), 3 deletions(-)
>>>>>>>
>>>>>>
>>>>>> Hi,
>>>>>> I'm sorry but this patch is wrong on many levels, some notes below. In general
>>>>>> NLM_F_APPEND is only used in vxlan, the bridge does not handle that flag at all.
>>>>>> FDB is only for *unicast*, nothing is joined and no multicast should be used with fdbs.
>>>>>> MDB is used for multicast handling, but both of these are used for forwarding.
>>>>>> The reason the static fdbs are added to the filter is for non-promisc ports, so they can
>>>>>> receive traffic destined for these FDBs for forwarding.
>>>>>> If you'd like to join any multicast group please use the standard way, if you'd like to join
>>>>>> it only on a specific port - join it only on that port (or ports) and the bridge and you'll
>>>>>
>>>>> And obviously this is for the case where you're not enabling port promisc mode (non-default).
>>>>> In general you'll only need to join the group on the bridge to receive traffic for it
>>>>> or add it as an mdb entry to forward it.
>>>>>
>>>>>> have the effect that you're describing. What do you mean there's no way ?
>>>>
>>>> Thanks for the explanation.
>>>> There are few things that are not 100% clear to me and maybe you can
>>>> explain them, not to go totally in the wrong direction. Currently I am
>>>> writing a network driver on which I added switchdev support. Then I was
>>>> looking for a way to configure the network driver to copy link layer
>>>> multicast address to the CPU port.
>>>>
>>>> If I am using bridge mdb I can do it only for IP multicast addreses,
>>>> but how should I do it if I want non IP frames with link layer multicast
>>>> address to be copy to CPU? For example: all frames with multicast
>>>> address '01-21-6C-00-00-01' to be copy to CPU. What is the user space
>>>> command for that?
>>>>
>>>
>>> Check SIOCADDMULTI (ip maddr from iproute2), f.e. add that mac to the port
>>> which needs to receive it and the bridge will send it up automatically since
>>> it's unknown mcast (note that if there's a querier, you'll have to make the
>>> bridge mcast router if it is not the querier itself). It would also flood it to all
>>
>> Actually you mentioned non-IP traffic, so the querier stuff is not a problem. This
>> traffic will always be flooded by the bridge (and also a copy will be locally sent up).
>> Thus only the flooding may need to be controlled.
> 
> OK, I see, but the part which is not clear to me is, which bridge
> command(from iproute2) to use so the bridge would notify the network
> driver(using swichdev or not) to configure the HW to copy all the frames
> with dmac '01-21-6C-00-00-01' to CPU? So that the bridge can receive
> those frames and then just to pass them up.
> Definitly I would not like to set the front ports in promisc mode, to
> copy all the frames to CPU because I think that would overkill it.
> Thanks,
> 

For non-IP traffic there's no such command, if it was IP you could catch
switchdev mdb notifications, but just for a mac address you'll have to configure
the port yourself, e.g. via the ip maddr command if you don't want to put it in
promisc mode. You know that in order to not run in promisc mode you'll have to disable
port flooding and port learning, right ? Otherwise they're always put in promisc.
If you do that you could do a simple hack in your driver with the current situation:
$ bridge fdb add 01:21:6C:00:00:01 dev swpX master static
If swpX is not promisc you'll get dev_uc_add() which will call __dev_set_rx_mode()
and the notifier so you can catch that address being added to the device, traffic
for that mac will *not* be forwarded to swpX later because it's considered multicast
and unknown at that so it will be flooded to all who have the FLOOD flag and will be
sent up the bridge as well.
But this is very hacky, I'd prefer the ip maddr add command on the port where you wish
to receive that traffic, the bridge will pass it up always due to it being unknown.


>>
>>> other ports so you may want to control that. It really depends on the setup
>>> and the how the hardware is configured.
>>>
>>>>>>
>>>>>> In addition you're allowing a mix of mcast functions to be called with unicast addresses
>>>>>> and vice versa, it is not that big of a deal because the kernel will simply return an error
>>>>>> but still makes no sense.
>>>>>>
>>>>>> Nacked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>>>>>>
>>>>>>> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>>>>>>> index b1d3248..d93746d 100644
>>>>>>> --- a/net/bridge/br_fdb.c
>>>>>>> +++ b/net/bridge/br_fdb.c
>>>>>>> @@ -175,6 +175,29 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
>>>>>>>  	}
>>>>>>>  }
>>>>>>>  
>>>>>>> +static void fdb_add_hw_maddr(struct net_bridge *br, const unsigned char *addr)
>>>>>>> +{
>>>>>>> +	int err;
>>>>>>> +	struct net_bridge_port *p;
>>>>>>> +
>>>>>>> +	ASSERT_RTNL();
>>>>>>> +
>>>>>>> +	list_for_each_entry(p, &br->port_list, list) {
>>>>>>> +		if (!br_promisc_port(p)) {
>>>>>>> +			err = dev_mc_add(p->dev, addr);
>>>>>>> +			if (err)
>>>>>>> +				goto undo;
>>>>>>> +		}
>>>>>>> +	}
>>>>>>> +
>>>>>>> +	return;
>>>>>>> +undo:
>>>>>>> +	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
>>>>>>> +		if (!br_promisc_port(p))
>>>>>>> +			dev_mc_del(p->dev, addr);
>>>>>>> +	}
>>>>>>> +}
>>>>>>> +
>>>>>>>  /* When a static FDB entry is deleted, the HW address from that entry is
>>>>>>>   * also removed from the bridge private HW address list and updates all
>>>>>>>   * the ports with needed information.
>>>>>>> @@ -192,13 +215,27 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
>>>>>>>  	}
>>>>>>>  }
>>>>>>>  
>>>>>>> +static void fdb_del_hw_maddr(struct net_bridge *br, const unsigned char *addr)
>>>>>>> +{
>>>>>>> +	struct net_bridge_port *p;
>>>>>>> +
>>>>>>> +	ASSERT_RTNL();
>>>>>>> +
>>>>>>> +	list_for_each_entry(p, &br->port_list, list) {
>>>>>>> +		if (!br_promisc_port(p))
>>>>>>> +			dev_mc_del(p->dev, addr);
>>>>>>> +	}
>>>>>>> +}
>>>>>>> +
>>>>>>>  static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>>>>>  		       bool swdev_notify)
>>>>>>>  {
>>>>>>>  	trace_fdb_delete(br, f);
>>>>>>>  
>>>>>>> -	if (f->is_static)
>>>>>>> +	if (f->is_static) {
>>>>>>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>>>>>> +		fdb_del_hw_maddr(br, f->key.addr.addr);
>>>>>>
>>>>>> Walking over all ports again for each static delete is a no-go.
>>>>>>
>>>>>>> +	}
>>>>>>>  
>>>>>>>  	hlist_del_init_rcu(&f->fdb_node);
>>>>>>>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
>>>>>>> @@ -843,13 +880,19 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
>>>>>>>  			fdb->is_local = 1;
>>>>>>>  			if (!fdb->is_static) {
>>>>>>>  				fdb->is_static = 1;
>>>>>>> -				fdb_add_hw_addr(br, addr);
>>>>>>> +				if (flags & NLM_F_APPEND && !source)
>>>>>>> +					fdb_add_hw_maddr(br, addr);
>>>>>>> +				else
>>>>>>> +					fdb_add_hw_addr(br, addr);
>>>>>>>  			}
>>>>>>>  		} else if (state & NUD_NOARP) {
>>>>>>>  			fdb->is_local = 0;
>>>>>>>  			if (!fdb->is_static) {
>>>>>>>  				fdb->is_static = 1;
>>>>>>> -				fdb_add_hw_addr(br, addr);
>>>>>>> +				if (flags & NLM_F_APPEND && !source)
>>>>>>> +					fdb_add_hw_maddr(br, addr);
>>>>>>> +				else
>>>>>>> +					fdb_add_hw_addr(br, addr);
>>>>>>>  			}
>>>>>>>  		} else {
>>>>>>>  			fdb->is_local = 0;
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>
>>
> 

