Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD29243A51
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 14:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgHMMwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 08:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgHMMwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 08:52:14 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19D0C061757
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 05:52:13 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id b25so4204590qto.2
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 05:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M0qhVcuIij3FC/5VeGaQG8Qi8nRWr/JKqAlZ8e0hPjI=;
        b=z0HIQ1QuBqi+asb9kLsQej00wHOTfALzyiQ2rj9I+UWs8VUWAkAeNuS0nqCxm6li/s
         +ZnlYFWgsoFg93oQRjDyAeLGKVPUOd+Hk+244PpS4yF6GDdEsTHAKHRmr8YfNGHWTYXN
         0MGn1E5fciPFp9B20i+Vx6MgJ4OQHETz2YNPpm9vBfzBl37J53eWEozrLOr9sAjyLuSh
         nwlgJ7TWcQNXa1jVdTmzaq/Q3fUI931+oAONDNBKDIlVLdq19Hfhfx85bslFYF3fHHB5
         8IfoAycBiQfR9XdKMIibQB/D7Y6AYoAB+ZStjZUsxYUl9j0emOoDPmU/9c8qeevt+XQ1
         qLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M0qhVcuIij3FC/5VeGaQG8Qi8nRWr/JKqAlZ8e0hPjI=;
        b=F4eGarXTQMbxse9YBwgigZY1Higp8TVy5aMHwU5zb1c5TCc2TgyyZQMl9HUWTIop2Y
         QWpoYVq3r4YG5PeUSIO5LW/f1oGBwv7mfgUApffnzCBEVAUpMxp1jjdrePPNjNXiA6Mr
         z998H7XJI9Ags2Tm1SGZtYtZPe7wtpUWE6/yiUL14noAS4s16yjHblfXfJ2DeezO4PDy
         JV5Ph6msVaWFWZx9wcm46ZLbv2TmFPaLo6GK2m5Pn+2zGTzNeVwRTv70r7a/t3uap4cT
         TAcFHGPLQoG7q2/ShUUeuEDh37hf0Q8IaY/uiTY3mqXHn7fjVcvEQ28N2D1thx4GxIYA
         EuEw==
X-Gm-Message-State: AOAM531IdF1mOcpk7yCmwHCbRCoZ6RvCtI875eGStYfnFbxo3UGVGgT7
        3ZQHdGQOJO1LSksIBQkJr2W+0Q==
X-Google-Smtp-Source: ABdhPJxA4NcgmRMXFH9RBub8nnR0FagM5msbEYrjoAMrIFVa0t+bDTD0d5ghVFGYvv+ZF6oDE38eLQ==
X-Received: by 2002:ac8:1948:: with SMTP id g8mr5247250qtk.354.1597323133044;
        Thu, 13 Aug 2020 05:52:13 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-06-184-148-45-213.dsl.bell.ca. [184.148.45.213])
        by smtp.googlemail.com with ESMTPSA id c42sm7274302qte.5.2020.08.13.05.52.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 05:52:12 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
References: <20200807222816.18026-1-jhs@emojatatu.com>
 <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
 <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com>
 <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
Message-ID: <64844778-a3d5-7552-df45-bf663d6498b6@mojatatu.com>
Date:   Thu, 13 Aug 2020 08:52:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-11 7:25 p.m., Cong Wang wrote:
> On Sun, Aug 9, 2020 at 4:41 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:

[..]
> 
> Not sure if I get you correctly, but with a combined implementation
> you can do above too, right? Something like:
> 
> (AND case)
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 1
> skb hash Y mark X flowid 1:12 action ok
> 
> (OR case)
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 1
> skb hash Y flowid 1:12 action ok
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 4 handle 2
> skb mark X flowid 1:12 action ok
> 

It will work but what i was tring to say is it is tricky to implement.
More below


> Side note: you don't have to use handle as the value of hash/mark,
> which gives people freedom to choose different handles.
>

Same comment here as above. More below.

> 
>>
>> Then the question is how to implement? is it one hash table for
>> both or two(one for mark and one for hash), etc.
>>
> 
> Good question. I am not sure, maybe no hash table at all?
> Unless there are a lot of filters, we do not have to organize
> them in a hash table, do we?
>

The _main_ requirement is to scale to a large number of filters
(a million is a good handwave number). Scale means
1) fast datapath lookup time + 2) fast insertion/deletion/get/dump
from control/user space.
fwmark is good at all these goals today for #2. It is good for #1 for
maybe 1K rules (limitation is the 256 buckets, constrained by rcu
trickery). Then you start having collisions in a bucket and your
lookup requires long linked list walks.

Generally something like a hash table with sufficient number of buckets
will work out ok.
There maybe other approaches (IDR in the kernel looks interesting,
but i didnt look closely).

So to the implementation issue:
Major issue is removing ambiguity while at the same time trying
to get good performance.

Lets say we decided to classify skbmark and skbhash at this point.
For a hash table, one simple approach is to set
lookupkey = hash<<32|mark

the key is used as input to the hash algo to find the bucket.

There are two outstanding challenges in my mind:

1)  To use the policy like you describe above
as an example:

$TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 1
skb hash Y flowid 1:12 action ok

and say you receive a packet with both skb->hash and skb->mark set
Then there is ambiguity

How do you know whether to use hash or mark or both
for that specific key?
You can probably do some trick but I cant think of a cheap way to 
achieve this goal. Of course this issue doesnt exist if you have
separate classifiers.

2) If you decide tomorrow to add tcindex/prio etc, you will have to
rework this as well.

#2 is not as a big deal as #1.

cheers,
jamal
