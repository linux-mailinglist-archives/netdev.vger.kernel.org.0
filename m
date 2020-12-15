Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962132DB1A3
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgLOQiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgLOQhx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 11:37:53 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A99C06179C
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 08:37:13 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id h19so14999437qtq.13
        for <netdev@vger.kernel.org>; Tue, 15 Dec 2020 08:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zpoHeAPijqT7N3GAjDs6XJKY+a1+RE1dx/CrsQNBDlg=;
        b=eTSRmvQZYKWqJQvuoKqJ9TB/tIV8unaGdL8bIjY0lxsbsOiIap6KigIrD9VSL4Q7J6
         1oSSS0o9a2CuSgtiFSyT8F0wY5dFcAivcpLdYlxbYm84Uxu3rEV8Qkuc+g68PN0EqP3P
         CZvIbX/lhs+mqt4/9EFmmXgUflWZwPf1X/1BjK1sbpBynPL6fTDeBWL79LlPrGmZAqsi
         YdcdPUivJrwtUiaWha0HOY7ZAhLvKar7wFzffbgUDtskOr2v68mgSvmhzpjd0wPb2Baa
         Ujgsu/hsPSuFpsazUSWdsXhv6hz4RP9LAgItf73xIY5uUc16ku0dTC0RMxAzr8vWkx4p
         cCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zpoHeAPijqT7N3GAjDs6XJKY+a1+RE1dx/CrsQNBDlg=;
        b=dzyp3SSGB0f3Rcul0RgN53V08eQQoctP3/aj2ToyaHehNFX05z7y0VQvq/ZlxAo8zG
         tz2nLnhVVlJyPzLhkZ6rPL/6IHAzQDmqVAVyQFdVGURavA/jLvCzrkOXgb9C8AJx1tX7
         uevK/+9vqSeN/p+gbozQD6b6DBNsrsW1IxJmYpDm6bkCF+46sJgUpyQlAHgW0ExhzU3w
         QDLK3V4gZEhQe51DuPn9bu6O9d+8RuyFO4Dxy0TYR7vxl4mJFihEOOTbAH5+iXneVh3Q
         W6kMdT0iCZ0dD0ifurO1Gcs7fNa8OY2M6k0eAXP/8Su1B8CkDXIIiQmbKVsc1/c8GIi1
         EFjg==
X-Gm-Message-State: AOAM531e+96gQbLfJHYJQYbb4HzetRVIslK2+uu09YQ9uumGr1byhWyL
        GQgTY+aLvHxgNmXtO7pboHc8rA==
X-Google-Smtp-Source: ABdhPJwWV4x4ZvPhz9tW8+m7COQhsNur/dRAStf2Zt6K0pSKV5fu4zK5TtBk6Kd7ImoaQPh0pRD5MQ==
X-Received: by 2002:ac8:6bc9:: with SMTP id b9mr39008165qtt.51.1608050232190;
        Tue, 15 Dec 2020 08:37:12 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id a77sm6462632qkg.77.2020.12.15.08.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Dec 2020 08:37:11 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/4] sch_htb: Hierarchical QoS hardware
 offload
To:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
References: <20201211152649.12123-1-maximmi@mellanox.com>
 <20201211152649.12123-3-maximmi@mellanox.com>
 <CAM_iQpUS_71R7wujqhUnF41dtVtNj=5kXcdAHea1euhESbeJrg@mail.gmail.com>
 <7f4b1039-b1be-b8a4-2659-a2b848120f67@nvidia.com>
 <CAM_iQpVrQAT2frpiVYj4eevSO4jFPY8v2moJdorCe3apF7p6mA@mail.gmail.com>
 <bee0d31e-bd3e-b96a-dd98-7b7bf5b087dc@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <845d2678-b679-b2a8-cf00-d4c7791cd540@mojatatu.com>
Date:   Tue, 15 Dec 2020 11:37:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <bee0d31e-bd3e-b96a-dd98-7b7bf5b087dc@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-14 3:30 p.m., Maxim Mikityanskiy wrote:
> On 2020-12-14 21:35, Cong Wang wrote:
>> On Mon, Dec 14, 2020 at 7:13 AM Maxim Mikityanskiy 
>> <maximmi@nvidia.com> wrote:
>>>
>>> On 2020-12-11 21:16, Cong Wang wrote:
>>>> On Fri, Dec 11, 2020 at 7:26 AM Maxim Mikityanskiy 
>>>> <maximmi@mellanox.com> wrote:
>>>>>


>>
>> Interesting, please explain how your HTB offload still has a global rate
>> limit and borrowing across queues?
> 
> Sure, I will explain that.
> 
>> I simply can't see it, all I can see
>> is you offload HTB into each queue in ->attach(),
> 
> In the non-offload mode, the same HTB instance would be attached to all 
> queues. In the offload mode, HTB behaves like MQ: there is a root 
> instance of HTB, but each queue gets a separate simple qdisc (pfifo). 
> Only the root qdisc (HTB) gets offloaded, and when that happens, the NIC 
> creates an object for the QoS root.
> 
> Then all configuration changes are sent to the driver, and it issues the 
> corresponding firmware commands to replicate the whole hierarchy in the 
> NIC. Leaf classes correspond to queue groups (in this implementation 
> queue groups contain only one queue, but it can be extended),


FWIW, it is very valuable to be able to abstract HTB if the hardware
can emulate it (users dont have to learn about new abstracts).
Since you are expressing a limitation above:
How does the user discover if they over-provisioned i.e single
queue example above? If there are too many corner cases it may
make sense to just create a new qdisc.

> and inner 
> classes correspond to entities called TSARs.
> 
> The information about rate limits is stored inside TSARs and queue 
> groups. Queues know what groups they belong to, and groups and TSARs 
> know what TSAR is their parent. A queue is picked in ndo_select_queue by 
> looking at the classification result of clsact. So, when a packet is put 
> onto a queue, the NIC can track the whole hierarchy and do the HTB 
> algorithm.
> 

Same question above:
Is there a limit to the number of classes that can be created?
IOW, if someone just created an arbitrary number of queues do they
get errored-out if it doesnt make sense for the hardware?
If such limits exist, it may make sense to provide a knob to query
(maybe ethtool) and if such limits can be adjusted it may be worth
looking at providing interfaces via devlink.

cheers,
jamal


cheers,
jamal
