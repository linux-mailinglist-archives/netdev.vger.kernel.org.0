Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFCB82C3087
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 20:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390970AbgKXTLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 14:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389340AbgKXTLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 14:11:45 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88000C0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:11:45 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id 23so23432124wrc.8
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 11:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4ndO1xvogRtr2zNXkCqf7Eua99uQYb3bNeFB8uv4np0=;
        b=Goy/5E8CdtOpJfXFI5tVTWTOLeMDQF8q7sIZID1i+mIeCxGTbSv/K+E1ClsAcmewbh
         GkCq2FJ9gl4L/P5W+HQWYrinBFxhoxP8XGctTXyP0igp6u5zWkBc2RBYCIjNSucaXqGK
         C7t59PYC7qA3sxcd7xIlfnuD+fWylzhegzFQtMagyZ8+jIqm8yCzry80N0ELBOOLcaw5
         9u2cUCvEOQ+FtXG0tkx9Qg8GGcYLppeh3NFFCJrj/ca8ezWHSa2uTpV0QWPJ7WX9hflZ
         D5lR3YPQrLZykZYBxFOH8w2cvBmKYdcdxS4Axhzq2jUBh7QjyLDUW13LT0sX5W2BGfQB
         jvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4ndO1xvogRtr2zNXkCqf7Eua99uQYb3bNeFB8uv4np0=;
        b=OXiZvTTFmxJECyf1OEGl/yUXkm5S1fM9PwMbAUJIZe5idKxxWPP05wLY4NJg9rk9li
         r+O3UEBWSnyCZYPQSq7nLHtVAQ4ONZjUnSVN76L6jo1L3r3izMt2sakCGXRwV9w7xzTL
         nI8dUwka9D2p+LaSLLMWTInOmmyLzqj+K67sO+elamAQY4eMSzjEZYDBD3NyzPkF0usF
         GjsHookoRMtgjX+bYRcgNJ3FLXLnUYnXAkVC7PIzCndvX9V6NmogqpiamQcMuyGlutR4
         V3i6V5XAzzlpfFIDOyC9iFp/reJUYEY/1g27IUHAQSJXsHk6fYcgcVLlX7l12+/ZyzuP
         BEfQ==
X-Gm-Message-State: AOAM533xWlBk4NVJvvV7gcJJF52XKIZsLDDpkqPptuS9EDGAxC6+RhyF
        Cjm2n1mBnXth2MDjBDxkyK8=
X-Google-Smtp-Source: ABdhPJzzgv8i3HRFZ2dJ3NIDGtWwsN53VCi3lgkyHD7oS0VApfLg9f/3ndT+yRzYs3xn49MRiwaMyw==
X-Received: by 2002:adf:e44d:: with SMTP id t13mr7256738wrm.144.1606245104305;
        Tue, 24 Nov 2020 11:11:44 -0800 (PST)
Received: from [192.168.8.114] ([37.166.80.220])
        by smtp.gmail.com with ESMTPSA id h4sm27769890wrq.3.2020.11.24.11.11.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 11:11:43 -0800 (PST)
Subject: Re: [PATCH net-next 1/3] net: remove napi_hash_del() from
 driver-facing API
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com
References: <20200909173753.229124-1-kuba@kernel.org>
 <20200909173753.229124-2-kuba@kernel.org>
 <8735d11e-e734-2ba9-7ced-d047682f9f3e@gmail.com>
 <20201124105413.0406e879@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a9ab432f-6d3c-aa8e-66bd-a82fac5d1098@gmail.com>
Date:   Tue, 24 Nov 2020 20:11:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124105413.0406e879@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/24/20 7:54 PM, Jakub Kicinski wrote:
> On Tue, 24 Nov 2020 19:00:50 +0100 Eric Dumazet wrote:
>> On 9/9/20 7:37 PM, Jakub Kicinski wrote:
>>> We allow drivers to call napi_hash_del() before calling
>>> netif_napi_del() to batch RCU grace periods. This makes
>>> the API asymmetric and leaks internal implementation details.
>>> Soon we will want the grace period to protect more than just
>>> the NAPI hash table.
>>>
>>> Restructure the API and have drivers call a new function -
>>> __netif_napi_del() if they want to take care of RCU waits.
>>>
>>> Note that only core was checking the return status from
>>> napi_hash_del() so the new helper does not report if the
>>> NAPI was actually deleted.
>>>
>>> Some notes on driver oddness:
>>>  - veth observed the grace period before calling netif_napi_del()
>>>    but that should not matter
>>>  - myri10ge observed normal RCU flavor
>>>  - bnx2x and enic did not actually observe the grace period
>>>    (unless they did so implicitly)
>>>  - virtio_net and enic only unhashed Rx NAPIs
>>>
>>> The last two points seem to indicate that the calls to
>>> napi_hash_del() were a left over rather than an optimization.
>>> Regardless, it's easy enough to correct them.
>>>
>>> This patch may introduce extra synchronize_net() calls for
>>> interfaces which set NAPI_STATE_NO_BUSY_POLL and depend on
>>> free_netdev() to call netif_napi_del(). This seems inevitable
>>> since we want to use RCU for netpoll dev->napi_list traversal,
>>> and almost no drivers set IFF_DISABLE_NETPOLL.
>>>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>  
>>
>> After this patch, gro_cells_destroy() became damn slow
>> on hosts with a lot of cores.
>>
>> After your change, we have one additional synchronize_net() per cpu as
>> you stated in your changelog.
> 
> Sorry :S  I hope it didn't waste too much of your time..

Do not worry ;)

> 
>> gro_cells_init() is setting NAPI_STATE_NO_BUSY_POLL, and this was enough
>> to not have one synchronize_net() call per netif_napi_del()
>>
>> I will test something like :
>> I am not yet convinced the synchronize_net() is needed, since these
>> NAPI structs are not involved in busy polling.
> 
> IDK how this squares against netpoll, though?
> 

Can we actually attach netpoll to a virtual device using gro_cells ?

