Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38A12ABED2
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 15:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731363AbgKIOhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 09:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbgKIOhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 09:37:10 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB43C0613CF;
        Mon,  9 Nov 2020 06:37:10 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id p19so35750wmg.0;
        Mon, 09 Nov 2020 06:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=caIEYH7Eu5Xcnq+e7ySVcHnIwnQp8PB5zRJO0aE9sVM=;
        b=WE7W9+WZW2zEJ9SGPk0THFJtjIKY2AryBOzwd6VjZJsRHynfxhNuDZ93/pPzphwzTY
         yYX/NrenpziwuirAOgC7IlVVc0rni5qAWj8hkI11mfQExcsoUBk5k2IIyC+yFR1zfs+0
         t5stdQx44NZjKjmlE+lta+If+cNt42Av4NbWB6FrDCL/PM7DPeJXM7CG8ATmfByGculE
         GOkmcLabPXyuF2KyeUb7nWQQc6gGHXcxoOp/tnjIvxDmgFUrZPBBEHkAtd7fgPyBkeaE
         Cx3ERzKzN9kGQxTepVlz9DlL9Xb35o0gNdVmVFOuZR219aQ6sECO4UfPZyojOc8O4L3O
         76NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=caIEYH7Eu5Xcnq+e7ySVcHnIwnQp8PB5zRJO0aE9sVM=;
        b=A/0aTuDzTp+SgqepwiKPm8guP0ZUCI28QJt5Eceo8UN1PvUbQAB1CSIUE1X4Dt7ZHk
         EPRRkzP5ZVvlHTb//Dhsxi7GK7szJgoMfiG7Xhhz+DOJz47fbY0kJygK9lUZfPQWH9+n
         YivIwfJn0MwNOtbwm7swe0SXMCX1gHG0bRzzPL0u50gMfab0DKzGq4jFfL5MyyBY0CxO
         /pqUyuit4mcpLFlVL47M64yVH5R1z2KiLA7zIuFskuYzlktX5W4YhOnyvjQa/STg/y2z
         CInSk4spfgNfU3YBSllv6/WqWTwoCKaHjrHxY2kCSoMYbdkBh/wMmoWG2AdeysFSVYs8
         rNSA==
X-Gm-Message-State: AOAM532Zit9LBcE2kxAjjFzBfvm0YdC7n29Hva/WscKvpLBJWMJukS7d
        oJADSNcl56OhNbv6zWgMQWt3TSnaB7A=
X-Google-Smtp-Source: ABdhPJy/OBxtlwQcJigGkaOwAxFgOjBrd5Z4mXA8WovN3u1qXxRRSdaeFRXEbNx1H6w9Q2tCmjheGA==
X-Received: by 2002:a05:600c:210a:: with SMTP id u10mr14896062wml.98.1604932628611;
        Mon, 09 Nov 2020 06:37:08 -0800 (PST)
Received: from [192.168.8.114] ([37.170.121.171])
        by smtp.gmail.com with ESMTPSA id x18sm14661454wrg.4.2020.11.09.06.37.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 06:37:07 -0800 (PST)
Subject: Re: [PATCH] page_frag: Recover from memory pressure
To:     Matthew Wilcox <willy@infradead.org>
Cc:     linux-mm@kvack.org, netdev@vger.kernel.org,
        Dongli Zhang <dongli.zhang@oracle.com>,
        Aruna Ramakrishna <aruna.ramakrishna@oracle.com>,
        Bert Barbe <bert.barbe@oracle.com>,
        Rama Nichanamatlu <rama.nichanamatlu@oracle.com>,
        Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>,
        Manjunath Patil <manjunath.b.patil@oracle.com>,
        Joe Jin <joe.jin@oracle.com>,
        SRINIVAS <srinivas.eeda@oracle.com>, stable@vger.kernel.org
References: <20201105042140.5253-1-willy@infradead.org>
 <d673308e-c9a6-85a7-6c22-0377dd33c019@gmail.com>
 <20201105140224.GK17076@casper.infradead.org>
 <20201109143249.GB17076@casper.infradead.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a8dd751d-2777-6821-47d2-b3d11a569f70@gmail.com>
Date:   Mon, 9 Nov 2020 15:37:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201109143249.GB17076@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/9/20 3:32 PM, Matthew Wilcox wrote:
> On Thu, Nov 05, 2020 at 02:02:24PM +0000, Matthew Wilcox wrote:
>> On Thu, Nov 05, 2020 at 02:21:25PM +0100, Eric Dumazet wrote:
>>> On 11/5/20 5:21 AM, Matthew Wilcox (Oracle) wrote:
>>>> When the machine is under extreme memory pressure, the page_frag allocator
>>>> signals this to the networking stack by marking allocations with the
>>>> 'pfmemalloc' flag, which causes non-essential packets to be dropped.
>>>> Unfortunately, even after the machine recovers from the low memory
>>>> condition, the page continues to be used by the page_frag allocator,
>>>> so all allocations from this page will continue to be dropped.
>>>>
>>>> Fix this by freeing and re-allocating the page instead of recycling it.
>>>>
>>>> Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
>>>> Cc: Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
>>>> Cc: Bert Barbe <bert.barbe@oracle.com>
>>>> Cc: Rama Nichanamatlu <rama.nichanamatlu@oracle.com>
>>>> Cc: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
>>>> Cc: Manjunath Patil <manjunath.b.patil@oracle.com>
>>>> Cc: Joe Jin <joe.jin@oracle.com>
>>>> Cc: SRINIVAS <srinivas.eeda@oracle.com>
>>>> Cc: stable@vger.kernel.org
>>>> Fixes: 79930f5892e ("net: do not deplete pfmemalloc reserve")
>>>
>>> Your patch looks fine, although this Fixes: tag seems incorrect.
>>>
>>> 79930f5892e ("net: do not deplete pfmemalloc reserve") was propagating
>>> the page pfmemalloc status into the skb, and seems correct to me.
>>>
>>> The bug was the page_frag_alloc() was keeping a problematic page for
>>> an arbitrary period of time ?
>>
>> Isn't this the commit which unmasks the problem, though?  I don't think
>> it's the buggy commit, but if your tree doesn't have 79930f5892e, then
>> you don't need this patch.
>>
>> Or are you saying the problem dates back all the way to
>> c93bdd0e03e8 ("netvm: allow skb allocation to use PFMEMALLOC reserves")
>>
>>>> +		if (nc->pfmemalloc) {
>>>
>>>                 if (unlikely(nc->pfmemalloc)) {
>>
>> ACK.  Will make the change once we've settled on an appropriate Fixes tag.
> 
> Which commit should I claim this fixes?

Hmm, no big deal, lets not waste time on tracking precise bug origin.

