Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7BF48CB77
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 20:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356377AbiALTEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 14:04:23 -0500
Received: from mga05.intel.com ([192.55.52.43]:40349 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356376AbiALTEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 14:04:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642014256; x=1673550256;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4UJ7xopN1K3IXaRFIey7BtjBtTlbyfPSxDlk+IOAAog=;
  b=GFdUheSKwPF1qxyktWOFACALlf96ktVRBYsxJASo+Q2HyQ5qeAWvrBXw
   6JUw4rvWSJoLqx5RY7elzFgbTjGEJSyur+tPRY8xTxwGIDzR2u4LlD0RL
   s3PU4Ac32cnPtCxq9zMA1I1c7iBV04GN1bsQ+Az/NaWmUhL5JDRcCoSMO
   JuG+HbkDsOhtXLlOPoewOEKbP6iiAr5miG6YMuNYJa/BEb3EpbaVZtDNF
   YgvboqyUKhJ0sPCLwB2R+lBWFOndJed40XxwOEu94JRk/OY9Cf1VdfZgN
   ZbtS3lruw/16300cXPmkVIZf6E5YU8h6IBAfNdA/k2TracFT8L8vC/oaR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10225"; a="330175999"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="330175999"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 11:03:08 -0800
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="515624819"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.104.69]) ([10.209.104.69])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 11:03:06 -0800
Message-ID: <2fd0756d-9ca1-b124-ed18-5ab0bda4c91f@linux.intel.com>
Date:   Wed, 12 Jan 2022 11:03:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH net-next v3 01/12] net: wwan: t7xx: Add control DMA
 interface
Content-Language: en-US
To:     =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, chandrashekar.devegowda@intel.com,
        linuxwwan@intel.com, chiranjeevi.rapolu@linux.intel.com,
        haijun.liu@mediatek.com, amir.hanania@intel.com,
        dinesh.sharma@intel.com, eliot.lee@intel.com,
        mika.westerberg@linux.intel.com, moises.veleta@intel.com,
        pierre-louis.bossart@intel.com, muralidharan.sethuraman@intel.com,
        Soumya.Prakash.Mishra@intel.com, sreehari.kancharla@intel.com
References: <20211207024711.2765-1-ricardo.martinez@linux.intel.com>
 <20211207024711.2765-2-ricardo.martinez@linux.intel.com>
 <a6325ef-e06e-c236-9d23-42fdb8b62747@linux.intel.com>
 <2b21bfa5-4b18-d615-b6ab-09ad97d73fe4@linux.intel.com>
 <Yd6+GjPLP2qCCEfv@smile.fi.intel.com>
 <b0cb18b-dc7b-9241-b21a-850d055d86@linux.intel.com>
 <Yd7/se+LD1c1wiBA@smile.fi.intel.com>
 <b638aa4-5a1c-e6ad-5a85-d4c3298c4daf@linux.intel.com>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <b638aa4-5a1c-e6ad-5a85-d4c3298c4daf@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/12/2022 10:16 AM, Ilpo Järvinen wrote:
> On Wed, 12 Jan 2022, Andy Shevchenko wrote:
>
>> On Wed, Jan 12, 2022 at 04:24:52PM +0200, Ilpo Järvinen wrote:
>>> On Wed, 12 Jan 2022, Andy Shevchenko wrote:
>>>> On Tue, Jan 11, 2022 at 08:55:58PM -0800, Martinez, Ricardo wrote:
>>>>> On 12/16/2021 3:08 AM, Ilpo Järvinen wrote:
>>>>>> On Mon, 6 Dec 2021, Ricardo Martinez wrote:
>>>>>>> +	if (req->entry.next == &ring->gpd_ring)
>>>>>>> +		return list_first_entry(&ring->gpd_ring, struct cldma_request, entry);
>>>>>>> +
>>>>>>> +	return list_next_entry(req, entry);
>>>> ...
>>>>
>>>>>>> +	if (req->entry.prev == &ring->gpd_ring)
>>>>>>> +		return list_last_entry(&ring->gpd_ring, struct cldma_request, entry);
>>>>>>> +
>>>>>>> +	return list_prev_entry(req, entry);
>>>> ...
>>>>
>>>>>> Wouldn't these two seems generic enough to warrant adding something like
>>>>>> list_next/prev_entry_circular(...) to list.h?
>>>>> Agree, in the upcoming version I'm planning to include something like this
>>>>> to list.h as suggested:
>>>> I think you mean for next and prev, i.o.w. two helpers, correct?
>>>>
>>>>> #define list_next_entry_circular(pos, ptr, member) \
> One thing I missed earlier, the sigrature should instead of ptr have head:
> #define list_next_entry_circular(pos, head, member)
>
>>>>>      ((pos)->member.next == (ptr) ? \
>>>> I believe this is list_entry_is_head().
>>> It takes .next so it's not the same as list_entry_is_head() and
>>> list_entry_is_last() doesn't exist.
>> But we have list_last_entry(). So, what about
>>
>> list_last_entry() == pos ? first : next;
>>
>> and counterpart
>>
>> list_first_entry() == pos ? last : prev;
>>
>> ?
> Yes, although now that I think it more, using them implies the head
> element has to be always accessed. It might be marginally cache friendlier
> to use list_entry_is_head you originally suggested but get the next entry
> first:
> ({
> 	typeof(pos) next__ = list_next_entry(pos, member); \
> 	!list_entry_is_head(next__, head, member) ? next__ : list_next_entry(next__, member);
> })
> (This was written directly to email, entirely untested).
>
> Here, the head element would only get accessed when we really need to walk
> through it.

I'm not sure if list_next_entry() will work for the last element, what 
about using list_is_last()?

This way we avoid accessing head if not needed and does not to use 
'container_of()' on (pos)->member.next.

     (list_is_last(&(pos)->member, head) ? \
     list_first_entry(head, typeof(*(pos)), member) : \
     list_next_entry(pos, member))

(untested)

>>>>>      list_first_entry(ptr, typeof(*(pos)), member) : \
>>>>>      list_next_entry(pos, member))
