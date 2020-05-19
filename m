Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79FED1D92FB
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 11:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgESJJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 05:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgESJJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 05:09:07 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73807C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 02:09:06 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x12so10507459qts.9
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 02:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hXWeyFmd3luOSRif7RPJAa2Grpy/uijbKad9S3QDMRA=;
        b=u1Ru63fUF7eYQzqRlS7ypWnLHB6Bgsv2IZjlfAPkJ6+//KF3Gg8cQwNJlvrIMG8iha
         O85kcVEf5mQGaWTGoJOyyHFWko/7vXxP4qNV4oArgzOQnKWyaO0cC4hEW/FlHDhCpSi/
         187iTSwEISAbl6UTzTZ8vCq/2O3KCplEFCzcXRRChiiQsPfDjQW6+wMvIWBdjIZ2jE29
         C0Bn/sb0v5OA7bvATS0ZD+RKfOxmVg5nTv/YwwHVJPLlDqMpGAwbj0zsMD3h04li1b+H
         HHJ1pzSCqwyaGMgRY2I6xBTBz5XNv0URFn1PZwuaOYGG8ZdyPMMm2TeGtnylIVlIJ4tZ
         BTig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hXWeyFmd3luOSRif7RPJAa2Grpy/uijbKad9S3QDMRA=;
        b=RszHoK1r6OLvuAsq2hncX+ShZ4s6wGy5rF0sBu3wgGw1kDEktq0tfakbU3xlJwpoHL
         PNy56dTmmjwnjeJ19hVG+qfDCea59d73GmRzqg1j9RgJczjAyXCZU9fG/A+CkAbpOaxR
         AizB+xpc+YT8bXtG10Qbn19Ko9omqFWaqPpj7UvM2trdmV+qbD6DtNZdnThgYJ1XS3xx
         MXuLkZj3h0Z4vkiXu7G7HPT0E1NhD1af7vrPJfhryXIdHUEEgc+8OwXWA2KTFnTpf+Pq
         AFqs6t++LkOKSZXEREKmOr6SP2PdX4Mj/Wijz6/sWPAfv12PeC1xR0FlNVCORk7Gt/Me
         gZsA==
X-Gm-Message-State: AOAM5302/drBaf6oKGSGxmW6YL1wEUzLuyC5A/me7kSGWHHYa5tYySxe
        TJy09iB2mSPvVKeaspSJPo0Xsg==
X-Google-Smtp-Source: ABdhPJyq6Qq/IPfhVDXuFgj0e+dADOXDCBlJTnPCAQ994SLmbfPRdlm+LYon3pGpQxTCwDSyEnrFzg==
X-Received: by 2002:ac8:6bda:: with SMTP id b26mr2740322qtt.230.1589879345640;
        Tue, 19 May 2020 02:09:05 -0700 (PDT)
Received: from [10.0.0.248] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id c3sm8340521qtp.24.2020.05.19.02.09.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 02:09:04 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 1/1] tc: report time an action was first
 used
To:     David Ahern <dsahern@gmail.com>, Roman Mashak <mrv@mojatatu.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        kernel@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <1589722125-21710-1-git-send-email-mrv@mojatatu.com>
 <1a7ed71e-a169-a583-8e8b-f700d3413a08@mojatatu.com>
 <e62b0766-3764-3cab-256c-1b5a0ca75d66@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <96851268-982b-6f1a-6e56-4967591810c5@mojatatu.com>
Date:   Tue, 19 May 2020 05:09:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <e62b0766-3764-3cab-256c-1b5a0ca75d66@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-18 11:38 a.m., David Ahern wrote:
> On 5/18/20 7:10 AM, Jamal Hadi Salim wrote:
>> On 2020-05-17 9:28 a.m., Roman Mashak wrote:
>>> Have print_tm() dump firstuse value along with install, lastuse
>>> and expires.
>>>
>>> Signed-off-by: Roman Mashak <mrv@mojatatu.com>
>>> ---
>>>    tc/tc_util.c | 5 +++++
>>>    1 file changed, 5 insertions(+)
>>>
>>> diff --git a/tc/tc_util.c b/tc/tc_util.c
>>> index 12f865cc71bf..f6aa2ed552a9 100644
>>> --- a/tc/tc_util.c
>>> +++ b/tc/tc_util.c
>>> @@ -760,6 +760,11 @@ void print_tm(FILE *f, const struct tcf_t *tm)
>>>            print_uint(PRINT_FP, NULL, " used %u sec",
>>>                   (unsigned int)(tm->lastuse/hz));
>>>        }
>>> +    if (tm->firstuse != 0) {
>>> +        print_uint(PRINT_JSON, "first_used", NULL, tm->firstuse);
>>> +        print_uint(PRINT_FP, NULL, " firstused %u sec",
>>> +               (unsigned int)(tm->firstuse/hz));
>>> +    }
>>
>> Maybe an else as well to print something like "firstused NEVER"
>> or alternatively just print 0 (to be backward compatible on old
>> kernels it will never be zero).
>>
> 
> existing times do not, so shouldn't this be consistent?
> 

Good point..

cheers,
jamal
