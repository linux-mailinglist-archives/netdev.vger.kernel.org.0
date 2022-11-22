Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F616348FF
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234738AbiKVVPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234721AbiKVVPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:15:12 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB9E7ECBC
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:15:09 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ft34so38515272ejc.12
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=61JqF5d+7+dTLDUDG/R6nmdQVS+wlcZWOGVBUq1+qvM=;
        b=hps2iygfkd1nHt3muzPJwDRZvqZC3BoUZ3q9wU1uFCB7NeG/yiHXK/jiKDAMKHBwMs
         hXd8/SjlLOYS/y2/pjEAsUOVeokcC0NztFRsnmdYxK6mCvlQ2qejG01QNrLxAeCW2MSF
         v5vG28IJ66uA3ea7roBwawMJ9EqJLvfTtzhqQoHiTrK56lobKGtU+cm30Fkq5/HSpBdR
         BNHExdUhaohiq9UKufykn5Xe0JNe4ZwQDWdlRcEoTNWjZD0heC/hcQ9tdi9Sfd+3U0ve
         EzG9iQUukHJqWOmtq1iGly8nY/xwbWkSKeMD9d9zRIJJJacgGQbHudN16hOjws8vXS4m
         DPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=61JqF5d+7+dTLDUDG/R6nmdQVS+wlcZWOGVBUq1+qvM=;
        b=h1iGUudWF/8OnU40j0LmDD+sMLV+EKR0gjLbsG9+IFPU4zU5XPh2euykX5U8GH872+
         w4YKOZfqosmvatTE5ds2dz83o1MeSAUd8Tx+fsiZsc3wcXA1XmSlt+38ni7aNcWoU/7L
         1VGDD8VYWsfx9FTYXpU2+PtWTLIlBURNmSqsAd8vNqhepDXDKJlKWsTZRzg+gCFNtnhC
         PCZbkqolmCB+2+cIKfnxhD6kqudAlm1W9a0U6YVj0k0VXzdAg89bQQewhPeq8fEtqovS
         6XO26nEQjN9OG1YVFJbg+DacfwBYYjcldf+xmfhMUrS7k0+ZGlIM1CT8aEzllS4j2SYR
         Ci6Q==
X-Gm-Message-State: ANoB5pnr8FUBVD7fGP784LdGdAyA4VL3HN50x2Y49BgmjxGh3r7HGuuB
        ixnM1eGLzM7V4lIh8q8HAYZrowATTdRSbCw/
X-Google-Smtp-Source: AA0mqf7v57zSC46AnC4u69lZL0+fqfUDKTuWXGXf7YBfKZk4SuG93TuTxHsO4Tb6/zbHZJVkfczxzg==
X-Received: by 2002:a17:906:b80d:b0:78d:314e:b0fa with SMTP id dv13-20020a170906b80d00b0078d314eb0famr10404821ejb.370.1669151707886;
        Tue, 22 Nov 2022 13:15:07 -0800 (PST)
Received: from [192.168.0.161] (79-100-144-200.ip.btc-net.bg. [79.100.144.200])
        by smtp.gmail.com with ESMTPSA id kv9-20020a17090778c900b0078b03d57fa7sm6406432ejc.34.2022.11.22.13.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 13:15:07 -0800 (PST)
Message-ID: <840d6f2a-abc9-c5d3-d1d3-3862e479509a@blackwall.org>
Date:   Tue, 22 Nov 2022 23:15:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH net-next 2/2] bonding: fix link recovery in mode 2 when
 updelay is nonzero
Content-Language: en-US
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <cover.1668800711.git.jtoppins@redhat.com>
 <cb89b92af89973ee049a696c362b4a2abfdd9b82.1668800711.git.jtoppins@redhat.com>
 <38fbc36783d583f805f30fb3a55a8a87f67b59ac.camel@redhat.com>
 <1fe036eb-5207-eccd-0cb3-aa22f5d130ce@redhat.com>
 <5718ba71a8755040f61ed7b2f688b1067ca56594.camel@redhat.com>
 <e1150971-ec16-0421-a13a-d6d2a0a66348@redhat.com>
 <0e7bb31c-ca92-dac2-4d29-5eb2d3327b26@blackwall.org>
In-Reply-To: <0e7bb31c-ca92-dac2-4d29-5eb2d3327b26@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/11/2022 23:12, Nikolay Aleksandrov wrote:
> On 22/11/2022 17:37, Jonathan Toppins wrote:
>> On 11/22/22 09:45, Paolo Abeni wrote:
>>> On Tue, 2022-11-22 at 08:36 -0500, Jonathan Toppins wrote:
>>>> On 11/22/22 05:59, Paolo Abeni wrote:
>>>>> Hello,
>>>>>
>>>>> On Fri, 2022-11-18 at 15:30 -0500, Jonathan Toppins wrote:
>>>>>> Before this change when a bond in mode 2 lost link, all of its slaves
>>>>>> lost link, the bonding device would never recover even after the
>>>>>> expiration of updelay. This change removes the updelay when the bond
>>>>>> currently has no usable links. Conforming to bonding.txt section 13.1
>>>>>> paragraph 4.
>>>>>>
>>>>>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>>>>>
>>>>> Why are you targeting net-next? This looks like something suitable to
>>>>> the -net tree to me. If, so could you please include a Fixes tag?
>>>>>
>>>>> Note that we can add new self-tests even via the -net tree.
>>>>>
>>>>
>>>> I could not find a reasonable fixes tag for this, hence why I targeted
>>>> the net-next tree.
>>>
>>> When in doubt I think it's preferrable to point out a commit surely
>>> affected by the issue - even if that is possibly not the one
>>> introducing the issue - than no Fixes as all. The lack of tag will make
>>> more difficult the work for stable teams.
>>>
>>> In this specific case I think that:
>>>
>>> Fixes: 41f891004063 ("bonding: ignore updelay param when there is no active slave")
>>>
>>> should be ok, WDYT? if you agree would you mind repost for -net?
>>>
>>> Thanks,
>>>
>>> Paolo
>>>
>>
>> Yes that looks like a good one. I will repost to -net a v2 that includes changes to reduce the number of icmp echos sent before failing the test.
>>
>> Thanks,
>> -Jon
>>
> 
> One minor nit - could you please change "mode 2" to "mode balance-xor" ?
> It saves reviewers some grepping around the code to see what is mode 2.
> Obviously one has to dig in the code to see how it's affected, but still
> it is a bit more understandable. It'd be nice to add more as to why the link is not recovered,
> I get it after reading the code, but it would be nice to include a more detailed explanation in the
> commit message as well.
> 
> Thanks,
>  Nik
> 

Ah, I just noticed I'm late to the party. :)
Nevermind my comments, no need for a v3.

