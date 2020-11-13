Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A89F2B1F79
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgKMQCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:02:31 -0500
Received: from mga07.intel.com ([134.134.136.100]:1880 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726439AbgKMQCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 11:02:30 -0500
IronPort-SDR: nQ15CELw5vxNnpH8LCCwHHCAYksYtn54Ib+Z5xwjeOTF7NY2Xz4AcWkFQQV6Bq8GVkNZQWHrno
 UHHgSxnI7Hvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="234649333"
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="234649333"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:02:29 -0800
IronPort-SDR: 6Q5SZdXA/W4VXopOfyKrwctpRkaa01eGzX+3ypJ27APftuKv7DrH/f7e1o2Vb0UeNkOnr9eIG4
 ARJ6K3chFN2g==
X-IronPort-AV: E=Sophos;i="5.77,475,1596524400"; 
   d="scan'208";a="542700124"
Received: from pkawatra-mobl1.amr.corp.intel.com (HELO [10.209.51.49]) ([10.209.51.49])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 08:02:29 -0800
Subject: Re: [PATCH v6] lib: optimize cpumask_local_spread()
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Yuqi Jin <jinyuqi@huawei.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juergen Gross <jgross@suse.com>,
        Paul Burton <paul.burton@mips.com>,
        Michal Hocko <mhocko@suse.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
References: <1604410767-55947-1-git-send-email-zhangshaokun@hisilicon.com>
 <3e2e760d-e4b9-8bd0-a279-b23bd7841ae7@intel.com>
 <eec4c1b6-8dad-9d07-7ef4-f0fbdcff1785@hisilicon.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <5e8b0304-4de1-4bdc-41d2-79fa5464fbc7@intel.com>
Date:   Fri, 13 Nov 2020 08:02:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <eec4c1b6-8dad-9d07-7ef4-f0fbdcff1785@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/20 6:06 PM, Shaokun Zhang wrote:
>>> On Huawei Kunpeng 920 server, there are 4 NUMA node(0 - 3) in the 2-cpu
>>> system(0 - 1). The topology of this server is followed:
>>
>> This is with a feature enabled that Intel calls sub-NUMA-clustering
>> (SNC), right?  Explaining *that* feature would also be great context for
> 
> Correct,
> 
>> why this gets triggered on your system and not normally on others and
>> why nobody noticed this until now.
> 
> This is on intel 6248 platform:

I have no idea what a "6248 platform" is.

>>> +static void calc_node_distance(int *node_dist, int node)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < nr_node_ids; i++)
>>> +		node_dist[i] = node_distance(node, i);
>>> +}
>>
>> This appears to be the only place node_dist[] is written.  That means it
>> always contains a one-dimensional slice of the two-dimensional data
>> represented by node_distance().
>>
>> Why is a copy of this data needed?
> 
> It is used to store the distance with the @node for later, apologies that I
> can't follow your question correctly.

Right, the data that you store is useful.  *But*, it's also a verbatim
copy of the data from node_distance().  Why not just use node_distance()
directly in your code rather than creating a partial copy of it in the
local node_dist[] array?


>>>  unsigned int cpumask_local_spread(unsigned int i, int node)
>>>  {
>>> -	int cpu, hk_flags;
>>> +	static DEFINE_SPINLOCK(spread_lock);
>>> +	static int node_dist[MAX_NUMNODES];
>>> +	static bool used[MAX_NUMNODES];
>>
>> Not to be *too* picky, but there is a reason we declare nodemask_t as a
>> bitmap and not an array of bools.  Isn't this just wasteful?
>>
>>> +	unsigned long flags;
>>> +	int cpu, hk_flags, j, id;
>>>  	const struct cpumask *mask;
>>>  
>>>  	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
>>> @@ -220,20 +256,28 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>>>  				return cpu;
>>>  		}
>>>  	} else {
>>> -		/* NUMA first. */
>>> -		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
>>> -			if (i-- == 0)
>>> -				return cpu;
>>> -		}
>>> +		spin_lock_irqsave(&spread_lock, flags);
>>> +		memset(used, 0, nr_node_ids * sizeof(bool));
>>> +		calc_node_distance(node_dist, node);
>>> +		/* Local node first then the nearest node is used */
>>
>> Is this comment really correct?  This makes it sound like there is only
> 
> I think it is correct, that's what we want to choose the nearest node.
> 
>> fallback to a single node.  Doesn't the _code_ fall back basically
>> without limit?
> 
> If I follow your question correctly, without this patch, if the local
> node is used up, one random node will be choosed, right? Now we firstly
> choose the nearest node by the distance, if all nodes has been choosen,
> it will return the initial solution.

The comment makes it sound like the code does:
	1. Do the local node
	2. Do the next nearest node
	3. Stop

In reality, I *think* it's more of a loop where it search
ever-increasing distances away from the local node.

I just think the comment needs to be made more precise.

>>> +		for (j = 0; j < nr_node_ids; j++) {
>>> +			id = find_nearest_node(node_dist, used);
>>> +			if (id < 0)
>>> +				break;
>>>  
>>> -		for_each_cpu(cpu, mask) {
>>> -			/* Skip NUMA nodes, done above. */
>>> -			if (cpumask_test_cpu(cpu, cpumask_of_node(node)))
>>> -				continue;
>>> +			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
>>> +				if (i-- == 0) {
>>> +					spin_unlock_irqrestore(&spread_lock,
>>> +							       flags);
>>> +					return cpu;
>>> +				}
>>> +			used[id] = 1;
>>> +		}
>>> +		spin_unlock_irqrestore(&spread_lock, flags);
>>
>> The existing code was pretty sparsely commented.  This looks to me to
>> make it more complicated and *less* commented.  Not the best combo.
> 
> Apologies for the bad comments, hopefully I describe it clearly by the above
> explantion.

Do you want to take another pass at submitting this patch?
