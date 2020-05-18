Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A241D7918
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 15:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgERNA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 09:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgERNA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 09:00:56 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A3CC061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 06:00:55 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s10so10439405iog.7
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 06:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b35Vbj50M8+qRFVBsMpEYXUCnoRlzoCIbZUKK58y0hY=;
        b=jtdPvIunauKG4T8epkU2aKaw8qU7ufyXl4ZhTHwx+qDZaToMcQhLqdeXiWRRAYZW5r
         f6NcrBMx21n+LAORhAGi/4TvMqhy1PlAhiZoOPhyNHJ6sSo0nLoTBQwPsy7rQfswihyP
         EkoiNTDT/hvnk6OuennC2tJ69f2Q3rBeayA61ZZU9FDX+Q/WZVu7W7gu5+Ev4L2/C0HB
         qCe9cWkZXdlxBVv1dX7AJ7q9VCXIvpp0595mwr51pdO5xWp9yGYlru3rDwXLE6sWOZvr
         cOn131MU5JgzM8ISYfQ0OK/RSLjE3VJ9xU0W8Ne/KSCVwQRnAkOzM3kTOx4GqqllDpj8
         c25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b35Vbj50M8+qRFVBsMpEYXUCnoRlzoCIbZUKK58y0hY=;
        b=QrI14aPuZ5wlS7wO4G6GCLLISgDtQKoZ1qL9kLKrPnZH09y6piH7Q2WN1uJbL+Q/FH
         dd3sIvMnWaUhkzRlzUKEY2JgVVZnRtx0WbEM16OPB9heHrx32EnfMsKUxVYL6ZBGTZpN
         Uu0lcm5RdlQ4k9dY4E4bFbhSXIdldvHw4rQb4JeuHx3CnZw31GxE4s/OKV6OYUHPVAZK
         glGM6Fx57RM/HJXzWLkcj+3KnMqdahc7tOeAhPyf06LL2DywQTdEZyYvPIyNtYTPd1LK
         DEv7FFIMePdBrgJcVy2R6qr8tyWV1MpuGG5HX4+Ze0fbVwz47IMat6zgAkzdTR8Q7Lyo
         835g==
X-Gm-Message-State: AOAM532m03vq3cZ2FnCEZjsUyVGapT4qs+/hXj+vVOkpGBQXm/G/zzuf
        85ABUsF5hikePC0hc/v+wZJ6xTG+YrAsWA==
X-Google-Smtp-Source: ABdhPJxYn2bewU1M09RySQsHhpVZ1NQpJ/wozRSl48MAFnIyxNvLTYw99mMBXeqLl1nrBduJ8UpSlw==
X-Received: by 2002:a02:77c7:: with SMTP id g190mr15089531jac.14.1589806854456;
        Mon, 18 May 2020 06:00:54 -0700 (PDT)
Received: from [10.0.0.248] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id f9sm3851797iow.47.2020.05.18.06.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 06:00:53 -0700 (PDT)
Subject: Re: [PATCH iproute2 v3 0/2] bpf: memory access fixes
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, asmadeus@codewreck.org
References: <20200423175857.20180-1-jhs@emojatatu.com>
 <125e68f2-2868-34c1-7c13-f3fcdf844835@mojatatu.com>
Message-ID: <1d1e025b-346b-d5f7-6c44-da5a64f31a2c@mojatatu.com>
Date:   Mon, 18 May 2020 09:00:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <125e68f2-2868-34c1-7c13-f3fcdf844835@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ping?

Note: these are trivial bug fixes.

cheers,
jamal

On 2020-04-28 12:15 p.m., Jamal Hadi Salim wrote:
> Stephen,
> What happened to this?
> 
> cheers,
> jamal
> 
> On 2020-04-23 1:58 p.m., Jamal Hadi Salim wrote:
>> From: Jamal Hadi Salim <jhs@mojatatu.com>
>>
>> Changes from V2:
>>   1) Dont initialize tmp on stack (Stephen)
>>   2) Dont look at the return code of snprintf (Dominique)
>>   3) Set errno to EINVAL instead of returning -EINVAL for consistency 
>> (Dominique)
>>
>> Changes from V1:
>>   1) use snprintf instead of sprintf and fix corresponding error message.
>>   Caught-by: Dominique Martinet <asmadeus@codewreck.org>
>>   2) Fix memory leak and extraneous free() in error path
>>
>> Jamal Hadi Salim (2):
>>    bpf: Fix segfault when custom pinning is used
>>    bpf: Fix mem leak and extraneous free() in error path
>>
>>   lib/bpf.c | 17 +++++++----------
>>   1 file changed, 7 insertions(+), 10 deletions(-)
>>
> 

