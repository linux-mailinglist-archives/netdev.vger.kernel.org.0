Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B3778752
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 10:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfG2IZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 04:25:42 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46374 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727241AbfG2IZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 04:25:42 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so27187099plz.13;
        Mon, 29 Jul 2019 01:25:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NH4lN7mu8BOKkfv6t88t7ZhBrCg11QlAHHEp1XAW710=;
        b=qwWgHodvvihYWDb0UOMMmCxPqDWo3t6/8zVyQ7tP749NrTsPt5HMs7KWdu3nXGkmj8
         SpQS8XhQBvxpZ0KOv/qBD8tdrtdMesvjtq/kvBfQotUqqq0TTbqcj0j/mZ/BIPPD2p4P
         cnfYdlJtNcQSWyAb6CsaWUZmTCnFfwiAE7nHfUaDL5a/w7xg/c05bfZxccDpI3CLzTt5
         T5spntzFBadJb4y9sC8zVNI2mgHz94lOWLcGEp0OfLvP2I2oCvAdipuyXkTeDam+Cgz8
         hwjXLE8f4UNj+b7HKD6dqt9QU/n4gZ/9/nxLj8HFtL0StrgZzw/RuJuz+s6TE54KFUKV
         seWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NH4lN7mu8BOKkfv6t88t7ZhBrCg11QlAHHEp1XAW710=;
        b=YB5OgKzkD4oEuFuObguYmJCVssZC7TGuE8dHY6AncFEDwPXUKYdstvlxjqaFIS2uVM
         2MFFpMEJ7TbOxG2CUz0rWCmhiog8js02/w+iquhRPHy+48ODdOtm8I9evDI6JVrJg9+H
         xOUXzC7fg9/oUo810kgEszxikavxG2ZGAj2bjDnxBJS/1HfJd6koU5XzV10L0xN17Aqx
         Nr8Syapf5DZrM14mONxGcJnrcAiRJTpqlh37Ik/gl63gnzCHFW7EiZXSVN4MyOsnYaTy
         ei8Yl/dNkave5+JS5KiP5n/ss5Wue2unEvBuaaH00sirAaqbCtLOjOtjHsfOqRA5tPYB
         UovQ==
X-Gm-Message-State: APjAAAWzIFbyoclVgejxHKf9Hfr0C4C9siPM1eeWJqm+awV4nh5QUn8n
        Gbk9Ys02gv3utOC9SF/RxJOVLsh+AKc=
X-Google-Smtp-Source: APXvYqzUL8MoUKRpHICLcWOcctUAGjZsDzWU9jLkSmVyIZRBrM4Kv24LNMtcqZFN1hX61REQ3ly6Cw==
X-Received: by 2002:a17:902:7887:: with SMTP id q7mr110530731pll.129.1564388741261;
        Mon, 29 Jul 2019 01:25:41 -0700 (PDT)
Received: from ?IPv6:2402:f000:4:72:808::177e? ([2402:f000:4:72:808::177e])
        by smtp.gmail.com with ESMTPSA id w132sm62425631pfd.78.2019.07.29.01.25.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 01:25:40 -0700 (PDT)
Subject: Re: [PATCH v2] net: sched: Fix a possible null-pointer dereference in
 dequeue_func()
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190729080018.28678-1-baijiaju1990@gmail.com>
 <20190729081854.GC2211@nanopsycho>
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Message-ID: <4619ec69-b800-1a61-7082-85ef4fa9af74@gmail.com>
Date:   Mon, 29 Jul 2019 16:25:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729081854.GC2211@nanopsycho>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/7/29 16:18, Jiri Pirko wrote:
> Mon, Jul 29, 2019 at 10:00:18AM CEST, baijiaju1990@gmail.com wrote:
>> In dequeue_func(), there is an if statement on line 74 to check whether
>> skb is NULL:
>>     if (skb)
>>
>> When skb is NULL, it is used on line 77:
>>     prefetch(&skb->end);
>>
>> Thus, a possible null-pointer dereference may occur.
>>
>> To fix this bug, skb->end is used when skb is not NULL.
>>
>> This bug is found by a static analysis tool STCheck written by us.
>>
>> Fixes: 79bdc4c862af ("codel: generalize the implementation")
> Looks like this is something being there since the beginning:
> commit 76e3cc126bb223013a6b9a0e2a51238d1ef2e409
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Thu May 10 07:51:25 2012 +0000
>
>      codel: Controlled Delay AQM
>
>
> Please adjust "Fixes:".

Thanks for the advice :)
I have sent a v3 patch.


Best wishes,
Jia-Ju Bai
