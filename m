Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989B635E676
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347868AbhDMScC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347867AbhDMSb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 14:31:56 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F42C061756;
        Tue, 13 Apr 2021 11:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=XP6l9LC35zlSRcgyw9ArkdNdfp0UGRE5eRXDdTgRX9I=; b=hjwq/wn42x/fiJU0w/vu1jWDCz
        OzQg5hnMUSXioRKxj19EH096hAVLL1mTQIz8jiukxzqOPFnzMbmmEA5bCpK8uDFqRbHEan8qv0Bgb
        phq252w28ZrkJLfuI8A8CldLcLNiXZYbBeix37BIz407imves7nYz49j5QGY/oreHR4/+29oPk7HS
        u8Mo4nOJCH98yVbHa+uvh5gEb8Kpa6TZ0wSKBX7erSHgyY40D1J79x1uGEuyoEZR0+B7el0EOCWiG
        IOE0vgRbsbg26ie1GqYDemSIj8NKEPiQh3F4Cnca/lk1zBm87oIGA2CjzKlfyFpDpOxqJGm6NlYRw
        6Y5QvJTw==;
Received: from [2601:1c0:6280:3f0::e0e1]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lWNov-00A9B5-MU; Tue, 13 Apr 2021 18:31:30 +0000
Subject: Re: [PATCH] lib: remove "expecting prototype" kernel-doc warnings
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        drbd-dev@tron.linbit.com, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
References: <20210411221756.15461-1-rdunlap@infradead.org>
 <20210413111828.365dcbcb2e24bfaa91e855ff@linux-foundation.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <02166180-2ffe-ed4b-91dc-cde198004fcc@infradead.org>
Date:   Tue, 13 Apr 2021 11:31:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210413111828.365dcbcb2e24bfaa91e855ff@linux-foundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/21 11:18 AM, Andrew Morton wrote:
> On Sun, 11 Apr 2021 15:17:56 -0700 Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> Fix various kernel-doc warnings in lib/ due to missing or
>> erroneous function names.
>> Add kernel-doc for some function parameters that was missing.
>> Use kernel-doc "Return:" notation in earlycpio.c.
>>
>> Quietens the following warnings:
>>
>> ../lib/earlycpio.c:61: warning: expecting prototype for cpio_data find_cpio_data(). Prototype was for find_cpio_data() instead
>>
>> ../lib/lru_cache.c:640: warning: expecting prototype for lc_dump(). Prototype was for lc_seq_dump_details() instead
>> lru_cache.c:90: warning: Function parameter or member 'cache' not described in 'lc_create'
> 
> I'm still seeing this.
> 

Weird. I can't reproduce it.

>> lru_cache.c:90: warning: Function parameter or member 'cache' not described in 'lc_create'
> 
> But it looks OK:
> 

Yes.

> /**
>  * lc_create - prepares to track objects in an active set
>  * @name: descriptive name only used in lc_seq_printf_stats and lc_seq_dump_details
>  * @cache: cache root pointer
>  * @max_pending_changes: maximum changes to accumulate until a transaction is required
>  * @e_count: number of elements allowed to be active simultaneously
>  * @e_size: size of the tracked objects
>  * @e_off: offset to the &struct lc_element member in a tracked object
>  *
>  * Returns a pointer to a newly initialized struct lru_cache on success,
>  * or NULL on (allocation) failure.
>  */
> struct lru_cache *lc_create(const char *name, struct kmem_cache *cache,
> 		unsigned max_pending_changes,
> 		unsigned e_count, size_t e_size, size_t e_off)
> {
> 

I'll keep looking...

-- 
~Randy

