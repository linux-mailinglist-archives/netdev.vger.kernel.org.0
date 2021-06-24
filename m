Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585F53B37BD
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 22:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhFXU0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 16:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhFXU0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 16:26:40 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D640EC061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 13:24:19 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id w26so5805634qto.13
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 13:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fcBxkntzXcaAcFv+ZnIDE6jdKLSvgGnJUB7u52LtlVk=;
        b=RzsPHB+++J4V3keyQie3JZZoH5XNhISaxOV55zi/JQBXMazI9r9O0Jp55ZsdUqURAr
         gaYkEyJGqcNdNib0JxOjskhs2AQLjjFGTwgYKhhWCRRdFLzko/Bd5cqbwR7Nxb70NhoF
         vyu1VVYcohsHycTzf7djMBWYpabxmXAdVuh8JyfPCI37m5ne18WAgCzJ5OandDRLMrtB
         OPC6vkhJpQhA5D8zg7C04pAgMRC/v8Haps3eaA4bcDWrnfDghw0jZBgAmruZ4m8REP3n
         hUaB6/+9bwQP7h8HHSSdEDyETYbec72L84UjBaS/WvqRxduIDb2zg7J0YrGC7ISciDQE
         XVTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fcBxkntzXcaAcFv+ZnIDE6jdKLSvgGnJUB7u52LtlVk=;
        b=OXqYujsHkfwzL5/g8lu0TBsbmT7s1psytoHLKyOBSJxRMp4rhCmEEpcTz3w73o4Th1
         8fCfB/H7+zPVWMcCg1gFQEzMp42YlLG+dDexJz+BVQra+s9QmsJXDWkTGxWzQyOUBy/K
         MSFU2cADwWhdtE5GOARuFnTcmfWF2GEGGhEFFymvvhXEMPRILPhQ7L3p6PzFOb6RjZaR
         +nmjlHbkC7GY9OWVYjx1Q++fitCJgyDnevqUOH0xCk0TxUoA8MPa13nQoCzyyk3kfzFQ
         aat09omkZuTIRXbi9Dwt7qMyN/9JSDUpMyjE/wIFGvW86jjRXOOJIV3R7mcF7nZgbbbj
         oXqQ==
X-Gm-Message-State: AOAM532x8THSfZ3g9dHAk5J4otydiQMas8xujU/FnX40x8VFT8padR5B
        QgHLEJgdS7En5cllxSvoZKdyvg==
X-Google-Smtp-Source: ABdhPJzPKxJA0trCuVAQf+tGwRau+c+qjDT8nO2ygQfVDvEQbnLR/CnB4/X2T1oIVtf8cr+aS23A/Q==
X-Received: by 2002:a05:622a:138e:: with SMTP id o14mr6495952qtk.93.1624566259059;
        Thu, 24 Jun 2021 13:24:19 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-24-174-92-115-23.dsl.bell.ca. [174.92.115.23])
        by smtp.googlemail.com with ESMTPSA id e3sm2582512qts.34.2021.06.24.13.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Jun 2021 13:24:18 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3 2/2] tc: pedit: add decrement operation
To:     David Ahern <dsahern@gmail.com>,
        =?UTF-8?Q?Asbj=c3=b8rn_Sloth_T=c3=b8nnesen?= <asbjorn@asbjorn.st>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@nvidia.com>
References: <20210618160635.703845-1-asbjorn@asbjorn.st>
 <20210618160635.703845-2-asbjorn@asbjorn.st>
 <7b5d610b-0fd6-d466-cd6d-bb2725397cdd@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <74b620dd-3552-b20d-ba5c-b681e7eabca7@mojatatu.com>
Date:   Thu, 24 Jun 2021 16:24:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <7b5d610b-0fd6-d466-cd6d-bb2725397cdd@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Asbjørn,


On 2021-06-22 11:39 a.m., David Ahern wrote:
> [ looks fine to me; adding tc folks to make sure they see it ]
> 
> On 6/18/21 10:06 AM, Asbjørn Sloth Tønnesen wrote:
>> Implement a decrement operation for ttl and hoplimit.
>>
>> Since this is just syntactic sugar, it goes that:
>>
>>    tc filter add ... action pedit ex munge ip ttl dec ...
>>    tc filter add ... action pedit ex munge ip6 hoplimit dec ...
>>
>> is just a more readable version of this:
>>
>>    tc filter add ... action pedit ex munge ip ttl add 0xff ...
>>    tc filter add ... action pedit ex munge ip6 hoplimit add 0xff ...
>>

So you "add" essentially one's complement of the value you are trying to
decrement with?

>> This feature was suggested by some pseudo tc examples in Mellanox's
>> documentation[1], but wasn't present in neither their mlnx-iproute2
>> nor iproute2.
>>
>> Tested with skip_sw on Mellanox ConnectX-6 Dx.
>>
>> [1] https://docs.mellanox.com/pages/viewpage.action?pageId=47033989


I didnt see an example which showed using "dec" but what you described
above makes sense. And the changes below look sane. So:

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
