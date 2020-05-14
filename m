Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFCF1D2567
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 05:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbgEND2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 23:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725932AbgEND2b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 23:28:31 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE8EC061A0C;
        Wed, 13 May 2020 20:28:31 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id z80so1750655qka.0;
        Wed, 13 May 2020 20:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U6W+r5c8ovMrF0z73K8Er6Wd4+8Nosbg+auclRIfIos=;
        b=o0iNI2Olf2IOyuGxWubB+iFpYCVvBJbk4a6mDyVyQmhznbHtTH653YfWBbT65GTw18
         YvSBTpDqauQMUKykr2/Z0WNtDU2P7Ivt6bFbGWUOkEYG8GZwfWQxPpJ457IAqETG/3eI
         D6P/Vx9vXApI7gVLteSZope7ihAYv3ybdp+pmWck7xkTT7vpmh78Wve2pTw3FOltsSiX
         N2cuJNZe9+mihoUr3Vgkn1sImHCjmKHbcpAnh5MJn4D203HHx93kDVPqvth6MjccU8vI
         wdYi0eOr2Vv13eEwB3kHyYWeTWXwQ8hDSSOrUSmG8b9pfE+fR8p2sN0pXsazK0QVjOuG
         Du3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U6W+r5c8ovMrF0z73K8Er6Wd4+8Nosbg+auclRIfIos=;
        b=aD2OyReAYamm5nQj+xO9hU9J3RV96ixeGlJC/JLgv3FKB6tXZdu/ipqG9nFcVo2LMz
         rNk09cYUCRiEo+AOyomcCnGWyxxenVenVRs2xVbjmfvixnXV37xFhbi5eCupJ0naP/Fb
         d53SCJzF+LysLKbBSNPsvMzeaaZMvTYeAOvIFyr4emQoxnfVRcpt8xFqsVHYQKmNgb8d
         YXhmRHqvwUOYnRdYBcY2CGviDnUqRsDxiCeVz80nBFe6Bmok92qu13/Q7XdGJciPAM1N
         3OdcIWmPTvIdgKpU3eNk7D8EIaMuuoWZlKoMN6FRYbmLcWPOvP99lsSpsr92+ikmlLJ4
         5QAA==
X-Gm-Message-State: AOAM531ovmO/MzY8mUvhK2Ysi9l7UaEIfctH0NoDLqflAVKd4KDEse8p
        cp1gSgUxJ/Cds5WS3d6DUaJQpu4B
X-Google-Smtp-Source: ABdhPJwbsyNyv9m94bu21XovkCUMko7nms7maiJte9nQ8zdbo0mUm+bJ016dPv+VLv/OLS+UjHNNVw==
X-Received: by 2002:ae9:efc1:: with SMTP id d184mr3056753qkg.437.1589426910015;
        Wed, 13 May 2020 20:28:30 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:3140:7ba:69e7:d3b1? ([2601:282:803:7700:3140:7ba:69e7:d3b1])
        by smtp.googlemail.com with ESMTPSA id m7sm1597579qti.6.2020.05.13.20.28.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 20:28:29 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 1/3] ss: introduce cgroup2 cache and
 helper functions
To:     =?UTF-8?B?0JTQvNC40YLRgNC40Lkg0K/QutGD0L3QuNC9?= 
        <zeil@yandex-team.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
References: <20200509165202.17959-1-zeil@yandex-team.ru>
 <42814b4f-dc95-d246-47a4-2b8c46dd607e@gmail.com>
 <25511589354341@mail.yandex-team.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c3221491-18e9-4de5-961c-38b9ac184601@gmail.com>
Date:   Wed, 13 May 2020 21:28:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <25511589354341@mail.yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/20 1:27 AM, Дмитрий Якунин wrote:
> 
> 
> 13.05.2020, 05:03, "David Ahern" <dsahern@gmail.com>:
>> On 5/9/20 10:52 AM, Dmitry Yakunin wrote:
>>>  This patch prepares infrastructure for matching sockets by cgroups.
>>>  Two helper functions are added for transformation between cgroup v2 ID
>>>  and pathname. Cgroup v2 cache is implemented as hash table indexed by ID.
>>>  This cache is needed for faster lookups of socket cgroup.
>>>
>>>  v2:
>>>    - style fixes (David Ahern)
>>
>> you missed my other comment about this set. Running this new command on
>> a kernel without support should give the user a better error message
>> than a string of Invalid arguments:
>>
>> $ uname -r
>> 5.3.0-51-generic
>>
>> $ ss -a cgroup /sys/fs/cgroup/unified
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
>> RTNETLINK answers: Invalid argument
> 
> No, i didn't miss your comment. This patchset was extended with the third patch which includes bytecode filter checking.
> 

ok. missed that. applied to iproute2-next.

in the future, please provide a cover letter
