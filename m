Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4311F2DD3CD
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 16:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbgLQPKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 10:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726999AbgLQPJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 10:09:59 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9479EC061794
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 07:09:19 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id a6so20276033qtw.6
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 07:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z+HU1A1CfNBB5s8iUKNq885NV9i9+6DVlfrugeeWORY=;
        b=QdGN7u3R7zMGrnv/TZ+egYPw4m6D7qt6DxHTxVuVx2x04XIaElvQNDjrdgF7H7/OPU
         LJJpAFfdHNirREdj9isTZeOl2R5ZLFONZXtbcQWWYkMxcgP9YrIwxjWVEfWShHOJEAG1
         XdX+FPv0GQfbp7aBPTm6eBBaCXGpoBFYpwOV+piNWL+WVaEY2JbqD5Udb4qAIIBOAlUb
         y7VZLDFYVbwxcvzBjs7fCD904XzGd3/T+1YM29BpnaxUn5dmVsqhHZwcvnVwYj91+Obq
         w+6CTPf6vpb0qnqx7/S6ZWdnOM6WENcD4QCZlqBqNZExuoNkRHaztvW5FnsN2oy5PZln
         HvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z+HU1A1CfNBB5s8iUKNq885NV9i9+6DVlfrugeeWORY=;
        b=Ea3OfccWlBmCebVgrRDwLN2cbAnzUgQfnS4bj9/JB2sr4a6Mbsmy/w+1pzuMWiJnWB
         gtXQ2EBDk0Jk3hlaWsKz0ABFhNWdduaLIv7+e2IkEWb7jZH3lEK3fWYtOjq1yAp/aDPu
         KMrtNzwtaWiy0WdolkQysVW2FgOr7XZpydytzCuHlmYfgZXWpfeJavaXaVmN43eLZWkr
         mJ19oc0SIQN9EkRPNj4Gp2wO0cpVO/0+WArlObtK6M3vM2vwOZtglt6QPEQM9zdtN4Lr
         TjalAvUAcwBRYRe3XIt29eC+cNxQVerkADPuG3+dUcsmTZhwLoIEFY1yyfmwz7eKwSoy
         9ZnA==
X-Gm-Message-State: AOAM530qwV/7vzOlWl3kZcvyzAV1yNGbcIMQ6EsJrXOxIISg5mSYDnvk
        jdjic23wKZTNG4lyJHhd8jjFPQ==
X-Google-Smtp-Source: ABdhPJzdREe+cjn9lKo93zDJdVjyhrXUfAYqeAayQC62Dqetci0Uw1EYyZr4cq+ubxo5GEhpHYYiqw==
X-Received: by 2002:ac8:c2:: with SMTP id d2mr48516055qtg.207.1608217758903;
        Thu, 17 Dec 2020 07:09:18 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 74sm3446672qko.59.2020.12.17.07.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 07:09:18 -0800 (PST)
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
 <845d2678-b679-b2a8-cf00-d4c7791cd540@mojatatu.com>
 <5f4f0785-54cb-debc-1f16-b817b83fbd96@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <f15342fb-714b-32d9-ef95-07b2e13bbc9b@mojatatu.com>
Date:   Thu, 17 Dec 2020 10:09:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <5f4f0785-54cb-debc-1f16-b817b83fbd96@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-16 6:47 a.m., Maxim Mikityanskiy wrote:
> On 2020-12-15 18:37, Jamal Hadi Salim wrote:

[..]

>>
>> Same question above:
>> Is there a limit to the number of classes that can be created?
> 
> Yes, the commit message of the mlx5 patch lists the limitations of our 
> NICs. Basically, it's 256 leaf classes and 3 levels of hierarchy.
>

Ok, thats what i was looking for.


>> IOW, if someone just created an arbitrary number of queues do they
>> get errored-out if it doesnt make sense for the hardware?
> 
> The current implementation starts failing gracefully if the limits are 
> exceeded. The tc command won't succeed, and everything will roll back to 
> the stable state, which was just before the tc command.
>

Does the user gets notified somehow or it fails silently?
An extack message would help.


>> If such limits exist, it may make sense to provide a knob to query
>> (maybe ethtool)
> 
> Sounds legit, but I'm not sure what would be the best interface for 
> that. Ethtool is not involved at all in this implementation, and AFAIK 
> it doesn't contain any existing command for similar stuff. We could hook 
> into set-channels and add new type of channels for HTB, but the 
> semantics isn't very clear, because HTB queues != HTB leaf classes, and 
> I don't know if it's allowed to extend this interface (if so, I have 
> more thoughts of extending it for other purposes).
> 

More looking to make sure no suprise to the user. Either the user can
discover what the constraints are or when they provision they get a
a message like "cannot offload more than 3 hierarchies" or "use devlink
if you want to use more than 256 classes", etc.

cheers,
jamal
