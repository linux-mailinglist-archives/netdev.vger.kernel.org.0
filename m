Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2202542D0
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 11:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728220AbgH0Jzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 05:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbgH0Jzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 05:55:32 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B5CC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 02:55:32 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k15so967307wrn.10
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 02:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/iBQyfCjXeFcHt8UV/9VYuK1WqvffGKunV7DN7u2MJo=;
        b=qp4SCZqHSIt1531gZcS/H357kUwf+TN8tuqP0FQX0Y95EeoNRhsEJWDgXqeZhnwgZL
         iHE/tn/eoLHBJcNLLW0DcVJSkqUDvE3l8XiK4IcsMcbD/N9z9+n4dKyq9Wy9fkWJxEat
         0Q4DCKhsL5VCgCLLXEDTR3U4VFGJIimzN9uAKAQ7vDa7cqXuDmTecQcWIfKq7nbPDM9t
         kYGqeXAg6B4HqH+a5ohNgO44ijJbGbAof+XyvF/cQrdK1mrwrWVSjRmOn4yCOK1cVlB7
         Q/0jSLxT+R++Qah5Pjd6DcUY4On68PsMYNBVSgrTKZCsbLeAlHNpmtpjCwpeWZS6wB6y
         j6hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/iBQyfCjXeFcHt8UV/9VYuK1WqvffGKunV7DN7u2MJo=;
        b=E1hsS5b1dKusWMvDq7VceQcdAUUzw/4a4UKAcFaVWE+CynwdGHALN4UhZMm6sIFsWr
         3P0elUqzU9JIUgxOyiHn6P/NMZCchJrxOO8H0xTS0RZy16sIQIaUMOOwPQTteC8ESnZT
         Jmjz9NBn/1FVIOQnEQ9dYaDw//8EVmRiPO2I3pgUDvz5LtMXx772AYpl8WiG/q+h3wRU
         RGMNR0X8ZwLdoHXk1gLS4Jds2e4cr6d5bTACexqG499GhTnyWuclmD9JoNn2SCncE7Is
         frYYCt3R346oJJEjWMSWZDDsHAif8ukwWm/zYOWz1sJM9rPGUjSTTYMEdCaovIMjLOpq
         +Idw==
X-Gm-Message-State: AOAM531r1FnaYNrsUZ31/Q27+v5cPTxnXr0+YtJi1cEoc3UohXQhJ7bd
        oGx0Okw4WR/8/vsW8L8xySFiU+5RFMQ=
X-Google-Smtp-Source: ABdhPJyfsrJmex1l40Kit+0ShFs4PVduIjcwRq1kWX6oY2uOg/ti6tZnMxpZRBscchbVNRLjjuLZcA==
X-Received: by 2002:adf:f691:: with SMTP id v17mr8467946wrp.344.1598522130890;
        Thu, 27 Aug 2020 02:55:30 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.26.29])
        by smtp.gmail.com with ESMTPSA id 8sm5025215wrl.7.2020.08.27.02.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 02:55:30 -0700 (PDT)
Subject: Re: [PATCH] iavf: use kvzalloc instead of kzalloc for rx/tx_bi buffer
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
References: <1598514788-31039-1-git-send-email-lirongqing@baidu.com>
 <6d89955c-78a2-fa00-9f39-78648d3558a0@gmail.com>
 <4557d3ad541b4272bc1286480af5e562@baidu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <cadd738c-b7a3-fd68-4883-2f23a07fb0ae@gmail.com>
Date:   Thu, 27 Aug 2020 02:55:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <4557d3ad541b4272bc1286480af5e562@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/20 1:53 AM, Li,Rongqing wrote:
> 
> 
>> -----Original Message-----
>> From: Eric Dumazet [mailto:eric.dumazet@gmail.com]
>> Sent: Thursday, August 27, 2020 4:26 PM
>> To: Li,Rongqing <lirongqing@baidu.com>; netdev@vger.kernel.org;
>> intel-wired-lan@lists.osuosl.org
>> Subject: Re: [PATCH] iavf: use kvzalloc instead of kzalloc for rx/tx_bi buffer
>>
>>
>>
>> On 8/27/20 12:53 AM, Li RongQing wrote:
>>> when changes the rx/tx ring to 4096, kzalloc may fail due to a
>>> temporary shortage on slab entries.
>>>
>>> kvmalloc is used to allocate this memory as there is no need to have
>>> this memory area physical continuously.
>>>
>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>> ---
>>
>>
>> Well, fallback to vmalloc() overhead because order-1 pages are not readily
>> available when the NIC is setup (usually one time per boot) is adding TLB cost
>> at run time, for billions of packets to come, maybe for months.
>>
>> Surely trying a bit harder to get order-1 pages is desirable.
>>
>>  __GFP_RETRY_MAYFAIL is supposed to help here.
> 
> Could we add __GFP_RETRY_MAYFAIL to kvmalloc, to ensure the allocation success ?

__GFP_RETRY_MAYFAIL does not _ensure_ the allocation success.

The idea here is that for large allocations (bigger than PAGE_SIZE),
kvmalloc_node() will not force __GFP_NORETRY, meaning that page allocator
will not bailout immediately in case of memory pressure.

This gives a chance for page reclaims to happen, and eventually the high order page
allocation will succeed under normal circumstances.

It is a trade-off, and only worth it for long living allocations.
