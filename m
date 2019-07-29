Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026F0786D9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 09:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfG2H7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 03:59:10 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36378 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfG2H7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 03:59:10 -0400
Received: by mail-pg1-f194.google.com with SMTP id l21so27819898pgm.3;
        Mon, 29 Jul 2019 00:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=hVKgxo5+thjjaYk/Yk8B+iRVEVZJZX4gP0vhIOS+Azg=;
        b=oW8HPCyUnG1G/qh/ZqyOf9Ly2icn+RPHi2u12IJ/fvZobqYLhRsssp3H7PvztqcjqH
         zAG2TjavnJ1sc3XqkhiVefYerpgzkhBvl2qhnTNooGfa7sDzJsAU9O0xnuL4Zi2XAc8K
         csMPOd0lCNfCfjzIJ+yi3kvT4OXLcFKH7MUzse12adZl9HdT4jVT6vCi3pzcqwcf1bLi
         k8q5DvdP57+ECchTl3TPeNGAFLxUaUsjDCoqNj2r0kAuB/6PWCD40QzPYjwOOeTZAFCN
         u/HgWPdblFJBVWUFU3ORK0l43dy3gwIhDB3ngHWJERMyLeQU1Cpto5P0NcU1xl/8Kmta
         XWnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hVKgxo5+thjjaYk/Yk8B+iRVEVZJZX4gP0vhIOS+Azg=;
        b=hUF+nDK6jhKKynzUz/cR3ovFVWKalTAwVVc2xUWWDYMfXdHNTfQ+tkJDpxOE+yeYZ2
         pTodXTYS+66CPmTzEKVJ8w4ddXPZ2f5Kb/AitlbCizTCG++nxn2HgC905GOhrZRHPvDW
         ubuyq2NLobv2k/iUu2FUUJUMeekBxTOOBp+d2UBdO6IGBNXWxJFxqYa58RV8B0C12lYL
         21dk0nszXi130V4IVIkJfhm5Jvrc0/1HRpambWbwhZShorFLGpCxl95El3N2JvUy9VDP
         A9JiCb7Of1ueoKoK/DDxo5K4d8D30Q0LyTMZIG0una/XYB+jZsLxBi97Vq8L1waTxcd/
         uqmw==
X-Gm-Message-State: APjAAAWcKTvJsQdETU8wbpSpBOET6ytNYmxeE+rfg1M7tis0RKNc/c+w
        Ou7FAWDYp4X2s1/O2P7jQmzRWbgI
X-Google-Smtp-Source: APXvYqzn3O2Dk8BApNuBZD/9i95kddDTvXEdWbGxdEwDCpAipJhJ2NdRtyT/CuJnzdgCGVpi/MDT6A==
X-Received: by 2002:a65:6152:: with SMTP id o18mr99380023pgv.279.1564387149516;
        Mon, 29 Jul 2019 00:59:09 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id k3sm45597854pgq.92.2019.07.29.00.59.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 00:59:09 -0700 (PDT)
Subject: Re: [PATCH] net: sched: Fix a possible null-pointer dereference in
 dequeue_func()
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190729022157.18090-1-baijiaju1990@gmail.com>
 <20190729065653.GA2211@nanopsycho>
 <4752bf67-7a0c-7bc9-3d54-f18361085ba2@gmail.com>
 <20190729074125.GB2211@nanopsycho>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <5a8fc4cb-4ee8-b2be-2b14-90e8285fef07@gmail.com>
Date:   Mon, 29 Jul 2019 15:59:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729074125.GB2211@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/29 15:41, Jiri Pirko wrote:
> Mon, Jul 29, 2019 at 09:32:00AM CEST, baijiaju1990@gmail.com wrote:
>>
>> On 2019/7/29 14:56, Jiri Pirko wrote:
>>> Mon, Jul 29, 2019 at 04:21:57AM CEST, baijiaju1990@gmail.com wrote:
>>>> In dequeue_func(), there is an if statement on line 74 to check whether
>>>> skb is NULL:
>>>>      if (skb)
>>>>
>>>> When skb is NULL, it is used on line 77:
>>>>      prefetch(&skb->end);
>>>>
>>>> Thus, a possible null-pointer dereference may occur.
>>>>
>>>> To fix this bug, skb->end is used when skb is not NULL.
>>>>
>>>> This bug is found by a static analysis tool STCheck written by us.
>>>>
>>>> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
>>> Fixes tag, please?
>> Sorry, I do not know what "fixes tag" means...
>> I just find a possible bug and fix it in this patch.
> git log |grep Fixes:
>
> If A fix goes to -net tree, it most probably fixes some bug introduced
> by some commit in the past. So this tag is to put a reference.

Thanks for the explanation.
I will add it and submit a v2 patch.


Best wishes,
Jia-Ju Bai
