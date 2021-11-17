Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21ADC4550AF
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 23:43:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241420AbhKQWq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 17:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241317AbhKQWqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 17:46:25 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F07C061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 14:43:26 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gt5so3524344pjb.1
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 14:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w92BPw+JYD1+cyHeq4g7llgJ1M5JbiDVw55lB6Aq+E0=;
        b=nlWVO3R9c+har3uYmf2cTskMbVSx+5qwwlNK/lzrSOV4DS+aJyM7vAaOXTCAbVkuPq
         +hsqutLHk64+OlqGK3ezc2mpusYxZ0/v+dwM/QXcRheKd2BlDAAm9WvtqMTTFBIZ20Gm
         LLP0NeEtd818vTQuuO2Ph02wYiwK+LjOA/VjwS3n4Ca3fgmU3px0Gr9pkTEuLIUfTIFu
         po0c3Jw8NQfO2vZiOdWutJ/3yqkAQ3z4spDAv+LKODiRjlmTdeV/ZHY+jyGtJEoYbB+V
         erQ6FeWIL+UlZs9ocrA8RovRHlyxHxbOE3D2oBRXh0DqMcUKKBRdA+mOzeexH2NdrKS/
         X3RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w92BPw+JYD1+cyHeq4g7llgJ1M5JbiDVw55lB6Aq+E0=;
        b=Trt1jjlhnVSkOQCgQUQ+/JLPNbb7/fw9ENpy4iOhEndCXUh6+Y689aRMDDRi/in98L
         r58WeBl+5t37BLkjuEhigayw9yjfbsaPw/mUfCNvjchj2SH6UqfZ+NZRDbAPurnhDJL4
         MT6qz0UDKvod5jtkAYyDwyhQNSDC94aZ6UdHe9owa3qjlj6HQAVd2n03WuEyn+IVfMVS
         Ox8Ssg/vs1nD4ObDLraZcviCnbgX3Xe0Ng7l5CzuZkwmdKKon1SG/hfy0Dg+hdfOMLIO
         Lg6kzhtACOHdKqaUaAH0nHO3PfzSs+7/0Dyi/U99TSsodLyGq9UVydg7/5oJpvO7sIx9
         p3LQ==
X-Gm-Message-State: AOAM533yPFU7+Ir9HBpeGCJA1E0pxZejFjq3syLxDKAQJ6SNos/GMmoP
        d9J0L8cirn4mSocdluek/QRb4TVGFjo=
X-Google-Smtp-Source: ABdhPJwpyT7kNYeXnskV/6lny/kiQkLMFVvE6Ws6mxU44mDDdovxCV0gD0+3akPyIaSI0VCBZN5khQ==
X-Received: by 2002:a17:90a:df01:: with SMTP id gp1mr4202757pjb.28.1637189005726;
        Wed, 17 Nov 2021 14:43:25 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f15sm681073pfe.171.2021.11.17.14.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 14:43:25 -0800 (PST)
Subject: Re: [RFC -next 1/2] lib: add reference counting infrastructure
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
References: <20211117192031.3906502-1-eric.dumazet@gmail.com>
 <20211117192031.3906502-2-eric.dumazet@gmail.com>
 <20211117120347.5176b96f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJ8HLjjpBPyFOn3xTXSnOJCbOGq5gORgPnsws-+sB8ipA@mail.gmail.com>
 <20211117124706.79fd08c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b7c0fed4-bb30-e905-aae2-5e380b582f4c@gmail.com>
Date:   Wed, 17 Nov 2021 14:43:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211117124706.79fd08c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/17/21 12:47 PM, Jakub Kicinski wrote:
> On Wed, 17 Nov 2021 12:16:15 -0800 Eric Dumazet wrote:
>> On Wed, Nov 17, 2021 at 12:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>>> Looks great, this is what I had in mind when I said:
>>>
>>> | In the future we can extend this structure to also catch those
>>> | who fail to release the ref on unregistering notification.
>>>
>>> I realized today we can get quite a lot of coverage by just plugging
>>> in object debug infra.
>>>
>>> The main differences I see:
>>>  - do we ever want to use this in prod? - if not why allocate the
>>>    tracker itself dynamically? The double pointer interface seems
>>>    harder to compile out completely  
>>
>> I think that maintaining the tracking state in separate storage would
>> detect cases where the object has been freed, without the help of KASAN.
> 
> Makes sense, I guess we can hang more of the information of a secondary
> object?
> 
> Maybe I'm missing a trick on how to make the feature consume no space
> when disabled via Kconfig.

If not enabled in Kconfig, the structures are empty, so consume no space.

Basically this should a nop.

