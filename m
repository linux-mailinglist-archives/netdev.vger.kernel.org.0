Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E01A27A542
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732128AbfG3Jzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:55:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42877 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730901AbfG3Jzh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:55:37 -0400
Received: by mail-wr1-f65.google.com with SMTP id x1so15147364wrr.9
        for <netdev@vger.kernel.org>; Tue, 30 Jul 2019 02:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oKSCZ6T5Xj6cZ96439FhC8GBroIR0+9hOTVNRh+0ivQ=;
        b=ZSo3homp3hD/KSVrvsHcyRrQlY2YfxXPGxTb+2ahzMeL4wE+bKt38iLXzntGYzPKqb
         x6FXLk8/v6ZQnZDx1vG8kUTdnNEyIbCE+59wWdKg6U5/+ZJwDHYAVoXqIIR9eWK/xDp/
         nkYiIqgSeD1fL4alfAJXH+G1GM0YnyxO0BftY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oKSCZ6T5Xj6cZ96439FhC8GBroIR0+9hOTVNRh+0ivQ=;
        b=I3FZzulC7z1bTaDnwHEoUV+f92aJnnLXRFvmWVnbp7kYQ1fC7+DoMIKqWDgSSnnbWM
         M1wfgwgMltDkrMKxIdKg/uYJts1V+pGvQPW1z+7kyT/OflaMkEB/AN4yxQh4x8pVLLCz
         ri2f4zIPdMAcEK6ehXmTfmOlkl+X5FbD+EIEJHNeoIFdhi3aAbMyzbm9TXgReO+g+Pna
         LPATbVZi5JBZwFVEhVpdPt9LGbsEzSae/2l0pUrKvstQgziNcip63KeU6CNByhOEbp+Q
         oC27bApUrPTTDnIh9Ta5rFaM2Lz8ygMQ0KwcjZCGFRALHCzPzB3b98H5NWxKtwiQV94h
         MF4g==
X-Gm-Message-State: APjAAAXawqwMqXTI1JcdXFXLfRmDLu9I53x6FSbAmhWLHgub8HFuPL+i
        p+pq9ppEvdqXcgKgEGt1/fPP/tRphQs=
X-Google-Smtp-Source: APXvYqwHq+6FXfBTo3HKilEqnD5CV1eCXlqR2RKWW+cTifU9XrR1zMBLyWYXc0XMW+aqWW/ndRFZsg==
X-Received: by 2002:a5d:53c1:: with SMTP id a1mr24741435wrw.185.1564480533587;
        Tue, 30 Jul 2019 02:55:33 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id d16sm57015674wrv.55.2019.07.30.02.55.32
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Jul 2019 02:55:32 -0700 (PDT)
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190729131420.tqukz55tz26jkg73@lx-anielsen.microsemi.net>
 <3cc69103-d194-2eca-e7dd-e2fa6a730223@cumulusnetworks.com>
 <20190729135205.oiuthcyesal4b4ct@lx-anielsen.microsemi.net>
 <e4cd0db9-695a-82a7-7dc0-623ded66a4e5@cumulusnetworks.com>
 <20190729143508.tcyebbvleppa242d@lx-anielsen.microsemi.net>
 <20190729175136.GA28572@splinter>
 <20190730062721.p4vrxo5sxbtulkrx@lx-anielsen.microsemi.net>
 <20190730070626.GA508@splinter>
 <20190730083027.biuzy7h5dbq7pik3@lx-anielsen.microsemi.net>
 <13f66ebe-4173-82d7-604b-08e9d33d9aff@cumulusnetworks.com>
 <20190730092118.key2ygh3ggpd3tkq@lx-anielsen.microsemi.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <5b0c92cd-f78a-a504-4730-c07268366e21@cumulusnetworks.com>
Date:   Tue, 30 Jul 2019 12:55:31 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190730092118.key2ygh3ggpd3tkq@lx-anielsen.microsemi.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2019 12:21, Allan W. Nielsen wrote:
> The 07/30/2019 11:58, Nikolay Aleksandrov wrote:
>> On 30/07/2019 11:30, Allan W. Nielsen wrote:
>>> The 07/30/2019 10:06, Ido Schimmel wrote:
>>>> On Tue, Jul 30, 2019 at 08:27:22AM +0200, Allan W. Nielsen wrote:
>>>>> The 07/29/2019 20:51, Ido Schimmel wrote:
>>>>>> Can you please clarify what you're trying to achieve? I just read the
>>>>>> thread again and my impression is that you're trying to locally receive
>>>>>> packets with a certain link layer multicast address.
>>>>> Yes. The thread is also a bit confusing because we half way through realized
>>>>> that we misunderstood how the multicast packets should be handled (sorry about
>>>>> that). To begin with we had a driver where multicast packets was only copied to
>>>>> the CPU if someone needed it. Andrew and Nikolay made us aware that this is not
>>>>> how other drivers are doing it, so we changed the driver to include the CPU in
>>>>> the default multicast flood-mask.
>>>> OK, so what prevents you from removing all other ports from the
>>>> flood-mask and letting the CPU handle the flooding? Then you can install
>>>> software tc filters to limit the flooding.
>>> I do not have the bandwidth to forward the multicast traffic in the CPU.
>>>
>>> It will also cause enormous latency on the forwarding of L2 multicast packets.
>>>
>>>>> This changes the objective a bit. To begin with we needed to get more packets to
>>>>> the CPU (which could have been done using tc ingress rules and a trap action).
>>>>>
>>>>> Now after we changed the driver, we realized that we need something to limit the
>>>>> flooding of certain L2 multicast packets. This is the new problem we are trying
>>>>> to solve!
>>>>>
>>>>> Example: Say we have a bridge with 4 slave interfaces, then we want to install a
>>>>> forwarding rule saying that packets to a given L2-multicast MAC address, should
>>>>> only be flooded to 2 of the 4 ports.
>>>>>
>>>>> (instead of adding rules to get certain packets to the CPU, we are now adding
>>>>> other rules to prevent other packets from going to the CPU and other ports where
>>>>> they are not needed/wanted).
>>>>>
>>>>> This is exactly the same thing as IGMP snooping does dynamically, but only for
>>>>> IP multicast.
>>>>>
>>>>> The "bridge mdb" allow users to manually/static add/del a port to a multicast
>>>>> group, but still it operates on IP multicast address (not L2 multicast
>>>>> addresses).
>>>>>
>>>>>> Nik suggested SIOCADDMULTI.
>>>>> It is not clear to me how this should be used to limit the flooding, maybe we
>>>>> can make some hacks, but as far as I understand the intend of this is maintain
>>>>> the list of addresses an interface should receive. I'm not sure this should
>>>>> influence how for forwarding decisions are being made.
>>>>>
>>>>>> and I suggested a tc filter to get the packet to the CPU.
>>>>> The TC solution is a good solution to the original problem where wanted to copy
>>>>> more frames to the CPU. But we were convinced that this is not the right
>>>>> approach, and that the CPU by default should receive all multicast packets, and
>>>>> we should instead try to find a way to limit the flooding of certain frames as
>>>>> an optimization.
>>>>
>>>> This can still work. In Linux, ingress tc filters are executed before the
>>>> bridge's Rx handler. The same happens in every sane HW. Ingress ACL is
>>>> performed before L2 forwarding. Assuming you have eth0-eth3 bridged and
>>>> you want to prevent packets with DMAC 01:21:6C:00:00:01 from egressing
>>>> eth2:
>>>>
>>>> # tc filter add dev eth0 ingress pref 1 flower skip_sw \
>>>> 	dst_mac 01:21:6C:00:00:01 action trap
>>>> # tc filter add dev eth2 egress pref 1 flower skip_hw \
>>>> 	dst_mac 01:21:6C:00:00:01 action drop
>>>>
>>>> The first filter is only present in HW ('skip_sw') and should result in
>>>> your HW passing you the sole copy of the packet.
>>> Agree.
>>>
>>>> The second filter is only present in SW ('skip_hw', not using HW egress
>>>> ACL that you don't have) and drops the packet after it was flooded by
>>>> the SW bridge.
>>> Agree.
>>>
>>>> As I mentioned earlier, you can install the filter once in your HW and
>>>> share it between different ports using a shared block. This means you
>>>> only consume one TCAM entry.
>>>>
>>>> Note that this allows you to keep flooding all other multicast packets
>>>> in HW.
>>> Yes, but the frames we want to limit the flood-mask on are the exact frames
>>> which occurs at a very high rate, and where latency is important.
>>>
>>> I really do not consider it as an option to forward this in SW, when it is
>>> something that can easily be offloaded in HW.
>>>
>>>>>> If you now want to limit the ports to which this packet is flooded, then
>>>>>> you can use tc filters in *software*:
>>>>>>
>>>>>> # tc qdisc add dev eth2 clsact
>>>>>> # tc filter add dev eth2 egress pref 1 flower skip_hw \
>>>>>> 	dst_mac 01:21:6C:00:00:01 action drop
>>>>> Yes. This can work in the SW bridge.
>>>>>
>>>>>> If you want to forward the packet in hardware and locally receive it,
>>>>>> you can chain several mirred action and then a trap action.
>>>>> I'm not I fully understand how this should be done, but it does sound like it
>>>>> becomes quite complicated. Also, as far as I understand it will mean that we
>>>>> will be using TCAM/ACL resources to do something that could have been done with
>>>>> a simple MAC entry.
>>>>>
>>>>>> Both options avoid HW egress ACLs which your design does not support.
>>>>> True, but what is wrong with expanding the functionality of the normal
>>>>> forwarding/MAC operations to allow multiple destinations?
>>>>>
>>>>> It is not an uncommon feature (I just browsed the manual of some common L2
>>>>> switches and they all has this feature).
>>>>>
>>>>> It seems to fit nicely into the existing user-interface:
>>>>>
>>>>> bridge fdb add    01:21:6C:00:00:01 port eth0
>>>>> bridge fdb append 01:21:6C:00:00:01 port eth1
>>>>
>>>> Wouldn't it be better to instead extend the MDB entries so that they are
>>>> either keyed by IP or MAC? I believe FDB should remain as unicast-only.
>>>
>>> You might be right, it was not clear to me which of the two would fit the
>>> purpose best.
>>>
>>> From a user-space iproute2 perspective I prefer using the "bridge fdb" command
>>> as it already supports the needed syntax, and I do not think it will be too
>>> pretty if we squeeze this into the "bridge mdb" command syntax.
>>>
>>
>> MDB is a much better fit as Ido already suggested. FDB should remain unicast
>> and mixing them is not a good idea, we already have a good ucast/mcast separation
>> and we'd like to keep it that way.
> Okay. We will explore that option.
> 
> 
Great, thanks.

>>> But that does not mean that it need to go into the FDB database in the
>>> implementation.
>>>
>>> Last evening when I looked at it again, I was considering keeping the
>>> net_bridge_fdb_entry structure as is, and add a new hashtable with the
>>> following:
>>>
>>> struct net_bridge_fdbmc_entry {
>>> 	struct rhash_head		rhnode;
>>> 	struct net_bridge_fdbmc_ports   *dst;
>>>
>>> 	struct net_bridge_fdb_key	key;
>>> 	struct hlist_node		fdb_node;
>>> 	unsigned char			offloaded:1;
>>>
>>> 	struct rcu_head			rcu;
>>> };
>>>
>>
>> What would the notification for this look like ?
> Not sure. But we will change the direction and use the MDB structures instead.
> 

Ack

>>> If we go with this approach then we can look at the MAC address and see if it is
>>> a unicast which will cause a lookup in the fdb, l3-multicast (33:33:* or
>>> 01:00:5e:*) which will cause a lookup in the mdb, or finally a fdbmc which will
>>> need to do a lookup in this new hashtable.
>>
>> That sounds wrong, you will change the current default behaviour of flooding these
>> packets. This will have to be well hidden behind a new option and enabled only on user
>> request.
> It will only affect users who install a static L2-multicast entry. If no entry
> is found, it will default to flooding, which will be the same as before.
> 

Ack

>>> Alternative it would be like this:
>>>
>>> struct net_bridge_fdb_entry {
>>> 	struct rhash_head		rhnode;
>>> 	union net_bridge_port_or_list	*dst;
>>>
>>> 	struct net_bridge_fdb_key	key;
>>> 	struct hlist_node		fdb_node;
>>> 	unsigned char			is_local:1,
>>> 					is_static:1,
>>> 					is_sticky:1,
>>> 					added_by_user:1,
>>> 					added_by_external_learn:1,
>>> 					offloaded:1;
>>> 					multi_dst:1;
>>>
>>> 	/* write-heavy members should not affect lookups */
>>> 	unsigned long			updated ____cacheline_aligned_in_smp;
>>> 	unsigned long			used;
>>>
>>> 	struct rcu_head			rcu;
>>> };
>>>
>>> Both solutions should require fairly few changes, and should not cause any
>>> measurable performance hit.
>>>
>>
>> You'll have to convert these bits to use the proper atomic bitops if you go with
>> the second solution. That has to be done even today, but the second case would
>> make it a must.
> Good to know.
> 
> Just for my understanding, is this because this is the "current" guide lines on
> how things should be done, or is this because the multi_dst as a special need.
> 
> The multi_dst flag will never be changed in the life-cycle of the structure, and
> the structure is protected by rcu. If this is causeing a raise, then I do not
> see it.
> 

These flags are changed from different contexts without any locking and you can end
up with wrong values since these are not atomic ops. We need to move to atomic ops
to guarantee consistent results. It is not only multi_dst issue, it's a problem
for all of them, it's just not critical today since you'll end up with wrong
flag values in such cases, but with multi_dst it will be important because the union
pointer will have to be treated different based on the multi_dst value.

>>> Making it fit into the net_bridge_mdb_entry seems to be harder.
>>>
>>
>> But it is the correct abstraction from bridge POV, so please stop trying to change
>> the FDB code and try to keep to the multicast code.
> We are planning on letting the net_bridge_port_or_list union use the
> net_bridge_port_group structure, which will mean that we can re-use the
> br_multicast_flood function (if we change the signatire to accept the ports
> instead of the entry).
> 

That sounds great, definitely a step in the right direction.

>>>> As a bonus, existing drivers could benefit from it, as MDB entries are already
>>>> notified by MAC.
>>> Not sure I follow. When FDB entries are added, it also generates notification
>>> events.
>>>
>>
>> Could you please show fdb event with multiple ports ?
> We will get to that. Maybe this is an argument for converting to mdb. We have
> not looked into the details of this yet.
> 

I can see a few potential problems, the important thing here would be to keep
backwards compatibility.

>>>>> It seems that it can be added to the existing implementation with out adding
>>>>> significant complexity.
>>>>>
>>>>> It will be easy to offload in HW.
>>>>>
>>>>> I do not believe that it will be a performance issue, if this is a concern then
>>>>> we may have to do a bit of benchmarking, or we can make it a configuration
>>>>> option.
>>>>>
>>>>> Long story short, we (Horatiu and I) learned a lot from the discussion here, and
>>>>> I think we should try do a new patch with the learning we got. Then it is easier
>>>>> to see what it actually means to the exiting code, complexity, exiting drivers,
>>>>> performance, default behavioral, backwards compatibly, and other valid concerns.
>>>>>
>>>>> If the patch is no good, and cannot be fixed, then we will go back and look
>>>>> further into alternative solutions.
>>>> Overall, I tend to agree with Nik. I think your use case is too specific
>>>> to justify the amount of changes you want to make in the bridge driver.
>>>> We also provided other alternatives. That being said, you're more than
>>>> welcome to send the patches and we can continue the discussion then.
>>> Okay, good to know. I'm not sure I agree that the alternative solutions really
>>> solves the issue this is trying to solve, nor do I agree that this is specific
>>> to our needs.
>>>
>>> But lets take a look at a new patch, and see what is the amount of changes we
>>> are talking about. Without having the patch it is really hard to know for sure.
>> Please keep in mind that this case is the exception, not the norm, thus it should
>> not under any circumstance affect the standard deployments.
> Understood - no surprises.
> 

Great, thanks again. Will continue discussing when the new patch arrives.

Cheers,
 Nik
