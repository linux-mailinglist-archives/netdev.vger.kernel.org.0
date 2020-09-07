Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A07B25FDD8
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 17:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730260AbgIGP7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 11:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730007AbgIGOtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:49:41 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B697C061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 07:49:37 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z1so16131599wrt.3
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 07:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=i3X9AwHqV2PdCwhnBEigdjE7qNVl8KxFfSqLBkYYfwk=;
        b=WSD0N0SPm2DeLiNtK22+aF8jRobUtyHJupJjOeLc1JeDDiQvZzD1LoeOofiviya2cd
         W3fFJQrEUF+FQiXKhbZRvX7LnweOFeau6H/YNoB5uQuvtoGqckaHwwcTaJx2u1sDtNVd
         jbM+EE/7rh1GTdjWLF6zHyBskOAv085ui2x9dbFKcF1fnKsa/ZDyvRdTG9ahVsl/rg2E
         kIc5nR54M6zsH/8Ut6F6oxoqB/Ue5KLZzk+9Y2lpdZrAyUCZFDBQFANU/JxPnH0rCZDA
         Bk25h5bp8wwNVXQUyr7OM0gVsjXdg33UZkMwiaET6pCYGGA6wFEKPWdHeJHZijE3wTwe
         rGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i3X9AwHqV2PdCwhnBEigdjE7qNVl8KxFfSqLBkYYfwk=;
        b=jQbSI0wervS2yGGCUnJg1I8bduFGhTccHnPKkBmvXDiirAnxIQpChpsxxUETSWdUSo
         yBjOV3nIt+Zn1Zexo6w6n7RwNbwTLCk7/gPgARjE9E9Ud0njeB96VL1zXRxLV2ZU9X9t
         nGN9EkDRqP1XeDThxy5nf8MDUzOmKR279w0Z2925j2BBxGTCEht2OCFcrWEO2BgNy2op
         agGPjHxM6rejDNxF5kaY0Iqi859RkQPz6MQfWLdO/LrDSd1z/s4UaT3v12U8foU36T7E
         JIYdVHB6+sfTFzkm0UoTbeWIEua5TL5Y8LR0WhAQypfZyb36W0CwO+4XPBkzvb3gdiRa
         tJFg==
X-Gm-Message-State: AOAM531VQCX+SHL+QUCLGhog7iwE3zLkHfGep/Txcb1MTLhDDWvreR7c
        0ozDCVwcvHrYJIbTrSLPocZIFA==
X-Google-Smtp-Source: ABdhPJzEjMlQEAU9vmXm11Dv7SHOUnxf+aY52t89xTXJboKX/jo5zvlCBEQvarUW8UK5NAijkC7DcQ==
X-Received: by 2002:adf:f903:: with SMTP id b3mr22690308wrr.142.1599490176092;
        Mon, 07 Sep 2020 07:49:36 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.119.8])
        by smtp.gmail.com with ESMTPSA id z9sm27921046wmg.46.2020.09.07.07.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 07:49:35 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/2] tools: bpftool: dump outer maps content
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Martynas Pumputis <m@lambda.lt>
References: <20200904161313.29535-1-quentin@isovalent.com>
 <20200904161313.29535-2-quentin@isovalent.com>
 <CAEf4BzbEE9sGp=z6MUuFoR=1_Ma27p-nH5BkEN+p2j20mhJ3mQ@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <4db0675f-ddc3-188f-f1ab-cc6d85010955@isovalent.com>
Date:   Mon, 7 Sep 2020 15:49:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbEE9sGp=z6MUuFoR=1_Ma27p-nH5BkEN+p2j20mhJ3mQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/09/2020 23:03, Andrii Nakryiko wrote:
> On Fri, Sep 4, 2020 at 9:14 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Although user space can lookup and dump the content of an outer map
>> (hash-of-maps or array-of-maps), bpftool does not allow to do so.
>>
>> It seems that the only reason for that is historical. Lookups for outer
>> maps was added in commit 14dc6f04f49d ("bpf: Add syscall lookup support
>> for fd array and htab"), and although the relevant code in bpftool had
>> not been merged yet, I suspect it had already been written with the
>> assumption that user space could not read outer maps.
>>
>> Let's remove the restriction, dump for outer maps works with no further
>> change.
>>
>> Reported-by: Martynas Pumputis <m@lambda.lt>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
>>  tools/bpf/bpftool/map.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
>> index bc0071228f88..cb3a75eb5531 100644
>> --- a/tools/bpf/bpftool/map.c
>> +++ b/tools/bpf/bpftool/map.c
>> @@ -739,10 +739,6 @@ static int dump_map_elem(int fd, void *key, void *value,
>>         /* lookup error handling */
>>         lookup_errno = errno;
>>
>> -       if (map_is_map_of_maps(map_info->type) ||
>> -           map_is_map_of_progs(map_info->type))
>> -               return 0;
>> -
> 
> this code path handles the error case when lookup fails, or am I
> misreading it? It's fine to remove this restriction, but the commit
> message is completely misleading. That whole dump_map_elem() code is a
> bit confusing. E.g., what's the purpose of num_elems there?..
> 
> Also, can you please update the commit message with how the output
> looks like for map-of-maps with your change?

Ok, the function _is_ confusing and _I_ totally got confused. Dumping
outer maps is already supported and this patch is not needed (and as you
mentioned, it does not do what I expected and wrote). Sorry about that.

I'll send a clean-up for that function instead in v2, to avoid confusion
in the future. Thanks for the review!

Quentin
