Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E4E2C8A79
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgK3RJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:09:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:10587 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729190AbgK3RJU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 12:09:20 -0500
IronPort-SDR: Kl/21Xf0wH+qIaDwbetMtwNIuuApHBpvvHLhnTmCDlv+aQ8Mb2Ir7/daeIcha0KSu6DQ8D1EPz
 45G2ZAeJsU4A==
X-IronPort-AV: E=McAfee;i="6000,8403,9821"; a="236796477"
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="236796477"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 09:08:39 -0800
IronPort-SDR: z+19WSYRyCVS3YN602uKGC/foyljDkSiAOhz8SUYne73fPyoNf96Ygq0/tQfar/Y5hEm0roBX4
 KyWFXLy66SEA==
X-IronPort-AV: E=Sophos;i="5.78,382,1599548400"; 
   d="scan'208";a="549180107"
Received: from ggudukba-mobl.amr.corp.intel.com (HELO [10.209.42.187]) ([10.209.42.187])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2020 09:08:38 -0800
Subject: Re: [PATCH v7] lib: optimize cpumask_local_spread()
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
References: <1605668072-44780-1-git-send-email-zhangshaokun@hisilicon.com>
 <6a6e6d37-a3dc-94ed-bc8c-62c50ea1dff5@intel.com>
 <a3b8ab12-604b-1efe-f091-de782c3c8ed5@hisilicon.com>
From:   Dave Hansen <dave.hansen@intel.com>
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
 z5cecg==
Message-ID: <b3122c82-e0fc-5bb8-82ec-43ae785f381f@intel.com>
Date:   Mon, 30 Nov 2020 09:08:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <a3b8ab12-604b-1efe-f091-de782c3c8ed5@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>  {
>>> -	int cpu, hk_flags;
>>> +	static DEFINE_SPINLOCK(spread_lock);
>>> +	static bool used[MAX_NUMNODES];
>>
>> I thought I mentioned this last time.  How large is this array?  How
>> large would it be if it were a nodemask_t?  Would this be less code if
> 
> Apologies that I forgot to do it.
> 
>> you just dynamically allocated and freed the node mask instead of having
>> a spinlock and a memset?
> 
> Ok, but I think the spinlock is also needed, do I miss something?

There was no spinlock there before your patch.  You just need it to
protect the structures you declared static.  If you didn't have static
structures, you wouldn't need a lock.

>>> +	unsigned long flags;
>>> +	int cpu, hk_flags, j, id;
>>>  	const struct cpumask *mask;
>>>  
>>>  	hk_flags = HK_FLAG_DOMAIN | HK_FLAG_MANAGED_IRQ;
>>> @@ -352,20 +379,27 @@ unsigned int cpumask_local_spread(unsigned int i, int node)
>>>  				return cpu;
>>>  		}
>>>  	} else {
>>> -		/* NUMA first. */
>>> -		for_each_cpu_and(cpu, cpumask_of_node(node), mask) {
>>> -			if (i-- == 0)
>>> -				return cpu;
>>> +		spin_lock_irqsave(&spread_lock, flags);
>>> +		memset(used, 0, nr_node_ids * sizeof(bool));
>>> +		/* select node according to the distance from local node */
>>> +		for (j = 0; j < nr_node_ids; j++) {
>>> +			id = find_nearest_node(node, used);
>>> +			if (id < 0)
>>> +				break;
>>
>> There's presumably an outer loop in a driver which is trying to bind a
>> bunch of interrupts to a bunch of CPUs.  We know there are on the order
>> of dozens of these interrupts.
>>
>> 	for_each_interrupt() // in the driver
>> 		for (j=0;j<nr_node_ids;j++) // cpumask_local_spread()
>> 			// find_nearest_node():
>> 			for (i = 0; i < nr_node_ids; i++) {
>> 			for (i = 0; i < nr_node_ids; i++) {
>>
>> Does this worry anybody else?  It thought our upper limits on the number
>> of NUMA nodes was 1024.  Doesn't that make our loop O(N^3) where the
>> worst case is hundreds of millions of loops?
> 
> If the NUMA nodes is 1024 in real system, it is more worthy to find the
> earest node, rather than choose a random one, And it is only called in
> I/O device initialization. Comments also are given to this interface.

This doesn't really make me feel better.  An end user booting this on a
big system with a bunch of cards could see a minutes-long delay.  I can
also see funky stuff happening like if we have a ton of NUMA nodes and
few CPUs.

>> I don't want to prematurely optimize this, but that seems like something
>> that might just fall over on bigger systems.
>>
>> This also seems really wasteful if we have a bunch of memory-only nodes.
>>  Each of those will be found via find_nearest_node(), but then this loop:
> 
> Got it, all effort is used to choose the nearest node for performance. If
> we don't it, I think some one will also debug this in future.

If we're going to kick the can down the road for some poor sod to debug,
can we at least help them out with a warning?

Maybe we WARN_ONCE() after we fall back for more than 2 or 3 nodes.

But, I still don't think you've addressed my main concern: This is
horrifically inefficient searching for CPUs inside nodes that are known
to have no CPUs.

>>> +			for_each_cpu_and(cpu, cpumask_of_node(id), mask)
>>> +				if (i-- == 0) {
>>> +					spin_unlock_irqrestore(&spread_lock,
>>> +							       flags);
>>> +					return cpu;
>>> +				}
>>> +			used[id] = true;
>>>  		}
>>
>> Will just exit immediately because cpumask_of_node() is empty.
> 
> Yes, and this node used[id] became true.
> 
>>
>> 'used', for instance, should start by setting 'true' for all nodes which
>> are not in N_CPUS.
> 
> No, because I used 'nr_node_ids' which is possible node ids to check.

I'm saying that it's wasteful to loop over and search in all the nodes.
