Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4BDC5206B9
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 23:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbiEIVlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiEIVlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 17:41:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3ED5AAB5C;
        Mon,  9 May 2022 14:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652132247; x=1683668247;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bpwLLLksaAjmFbrWqexTl9pq/J50D/MrBAfquLBNJVw=;
  b=STMUFLYXPv8yXx4vzIdxwVZX4F1yb8qfACH60whZaLa5rsuvAEgELmC6
   fvVn1UEdHBd/E5Bb49r3SxKglMrPIt1+UgL6BjoAYc6nHPNj32iCxqLEV
   4tej7smh9Z+uUJZkwU0EOJes+PZuAA9XPrK6N2WSLvNf/hJB8B5o16WM/
   AIBR4bEbauIuGJvWIrsxrsB5cXkwEB2xnAv+qb0HOGFMcAVRrFnQw8Ms9
   GjVMD/Dm/SrHQdXpckYPtus7aOoiM2wmM7EH9uuA3OcJ2ffjxYawOnu9R
   faoDxmA6EF4gSYeFQTisD3ZL3AHOnvB6mVduGRWlS/soYsqzWXP6ktaBt
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="294402865"
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="294402865"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:37:27 -0700
X-IronPort-AV: E=Sophos;i="5.91,212,1647327600"; 
   d="scan'208";a="602152507"
Received: from rmarti10-mobl2.amr.corp.intel.com (HELO [10.209.126.63]) ([10.209.126.63])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 14:37:26 -0700
Message-ID: <c4892d58-9d97-8fd7-800d-8433181cbda5@linux.intel.com>
Date:   Mon, 9 May 2022 14:37:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v8 02/14] net: skb: introduce
 skb_data_area_size()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        Intel Corporation <linuxwwan@intel.com>,
        chiranjeevi.rapolu@linux.intel.com,
        =?UTF-8?B?SGFpanVuIExpdSAoIOWImOa1t+WGmyk=?= 
        <haijun.liu@mediatek.com>,
        "Hanania, Amir" <amir.hanania@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>,
        "Lee, Eliot" <eliot.lee@intel.com>,
        "Jarvinen, Ilpo Johannes" <ilpo.johannes.jarvinen@intel.com>,
        "Veleta, Moises" <moises.veleta@intel.com>,
        "Bossart, Pierre-louis" <pierre-louis.bossart@intel.com>,
        "Sethuraman, Muralidharan" <muralidharan.sethuraman@intel.com>,
        "Mishra, Soumya Prakash" <Soumya.Prakash.Mishra@intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sahu, Madhusmita" <madhusmita.sahu@intel.com>
References: <20220506181310.2183829-1-ricardo.martinez@linux.intel.com>
 <20220506181310.2183829-3-ricardo.martinez@linux.intel.com>
 <20220509094930.6d5db0f8@kernel.org>
 <CAHNKnsSZ-Sf=5f3puLUiRRysz80b2CS3tVMXds_Ugur-Dga2aQ@mail.gmail.com>
 <20220509125008.6d1c3b9b@kernel.org>
From:   "Martinez, Ricardo" <ricardo.martinez@linux.intel.com>
In-Reply-To: <20220509125008.6d1c3b9b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/9/2022 12:50 PM, Jakub Kicinski wrote:
> On Mon, 9 May 2022 21:34:58 +0300 Sergey Ryazanov wrote:
>>>> +static inline unsigned int skb_data_area_size(struct sk_buff *skb)
>>>> +{
>>>> +     return skb_end_pointer(skb) - skb->data;
>>>> +}
>>> Not a great name, skb->data_len is the length of paged data.
>>> There is no such thing as "data area", data is just a pointer
>>> somewhere into skb->head.
>> What name would you recommend for this helper?
> We are assuming that skb->data is where we want to start to write
> to so we own the skb. If it's a fresh skb skb->data == skb->tail.
> If it's not fresh but recycled - skb->data is presumably reset
> correctly, and then skb_reset_tail_pointer() has to be called. Either
> way we give HW empty skbs, tailroom is an existing concept we can use.
>
>>> Why do you need this? Why can't you use the size you passed
>>> to the dev_alloc_skb() like everyone else?
>> It was I who suggested to Ricardo to make this helper a common
>> function [1]. So let me begin the discussion, perhaps Ricardo will add
>> to my thoughts as the driver author.
>>
>> There are many other places where authors do the same but without a
>> helper function:
>>
>> [...]
>>
>> There are at least two reasons to evaluate the linear data size from skb:
>> 1) it is difficult to access the same variable that contains a size
>> during skb allocation (consider skb in a queue);
> Usually all the Rx skbs on the queue are equally sized so no need to
> save the length per buffer, but perhaps that's not universally true.
>
>> 2) you may not have access to an allocation size because a driver does
>> not allocate that skb (consider a xmit path).
> On Tx you should only map the data that's actually populated, for that
> we have skb_headlen().
>
>> Eventually you found themself in a position where you need to carry
>> additional info along with skb. But, on the other hand, you can simply
>> calculate this value from the skb pointers themselves.
>>
>> 1. https://lore.kernel.org/netdev/CAHNKnsTr3aq1sgHnZQFL7-0uHMp3Wt4PMhVgTMSAiiXT=8p35A@mail.gmail.com/
> Fair enough, I didn't know more drivers are doing this.
>
> We have two cases:
>   - for Tx - drivers should use skb_headlen();
>   - for Rx - I presume we are either dealing with fresh or correctly
>     reset skbs, so we can use skb_tailroom().
Thanks for the information, looks like indeed we can avoid the helper in 
t7xx driver by following those guidelines.
