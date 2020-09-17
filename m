Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C3726D449
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 09:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgIQHKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 03:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgIQHK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 03:10:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A083AC06174A;
        Thu, 17 Sep 2020 00:10:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id m6so838906wrn.0;
        Thu, 17 Sep 2020 00:10:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A31FuXoR1fQi2PzgN3S9/yzmUsIB4Q6KUIbYTBZoMUg=;
        b=WO6I9dBUgrgvztEMZwkfHNMPP/CKACvZCioIJaptH8xoBI6jJujARKF/odQGVTV2dP
         nDWKqH13Nq62i9fWlpCqtsiS8LqxeJKkMGA29wdqudKfCSG1jaRapBKTY4O+TuuambpR
         oK55fMREyHLZ2jNwyCuQLSfRBPw42sCrnovx85TfTSVmkxDZ4ti/mGlR8pBcM/eoTR9e
         DfT2hD5j9wutP7lU0b2dhd6qB06L1XL0pNZgMGu4O6RIIfjDiMN1AQtrSdlhoef/YuVI
         EHBni56clsLw3JOdJYAzCqQfbEerCL4EXO8b8bIiwOiZDro/N5w5oKEIrtb1+XaAE/BH
         RKYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A31FuXoR1fQi2PzgN3S9/yzmUsIB4Q6KUIbYTBZoMUg=;
        b=nZMRPEZBz78xo7sJz9F/56ECdb62vNOhnL6ZNBbfLUcenUb5mR/whUVdZQDDcDxJ2g
         oRiCmD9goQTf9Pd2ieS2gNJmByqzXZwxMSGle3UugSF+aJng3pXaLqrAyebUzU+war0l
         ZMJP3CMoyll1b4FmaYhEz7URM9f2gGgkiaUOqb0BFQzr/mjNKc9OJOU1sXQV+36JX18+
         NhYEUMSarxLBiGqfHi6IEDHCAFedtnncNn5TAogTfnOF/5+r5bledalUNSktxGsF+USw
         MJ++B0JqrUteKmrDj5yJflElF0QkKDcrbYDs3zH95O+GdxrVcRqQdphmH6h0isrs1hzt
         teqQ==
X-Gm-Message-State: AOAM531FHCKj6lFaysVq3pgQM6K48eiAhpBLgtmlD3L5QfNsV2q9PRDU
        9nS37qY0BsSFUUSU1/jUzgk=
X-Google-Smtp-Source: ABdhPJxG2Ct8Tj/O6+K1c9CT4v8cdLErCg7r24QQV1rlVen0F9dx2EeyYaxRf3gDiMJlsTrSDWHQrQ==
X-Received: by 2002:adf:c404:: with SMTP id v4mr29923632wrf.17.1600326620779;
        Thu, 17 Sep 2020 00:10:20 -0700 (PDT)
Received: from ?IPv6:2001:a61:2479:6801:d8fe:4132:9f23:7e8f? ([2001:a61:2479:6801:d8fe:4132:9f23:7e8f])
        by smtp.gmail.com with ESMTPSA id i15sm2842919wrb.91.2020.09.17.00.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2020 00:10:20 -0700 (PDT)
Cc:     mtk.manpages@gmail.com, linux-man <linux-man@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, beej@beej.us
Subject: Re: [patch] freeaddrinfo.3: memory leaks in freeaddrinfo examples
To:     Marko Hrastovec <marko.hrastovec@gmail.com>
References: <CAA+iEG_gYH0Em5Ff+xwFkcuph32AKvAu=CQvREEy1q8c8C7Tvg@mail.gmail.com>
 <CAKgNAkgQO+Spi=g6sC8dXdEGkJDOLziBYaxa7phdT9tQL=BuVA@mail.gmail.com>
 <CAA+iEG9eAwkmYiVoUTxSptVsijeD8NqRTR6tRHuboo8MdB9jqg@mail.gmail.com>
From:   "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Message-ID: <41a3c0be-56fc-cbe2-523b-2719cdcb7264@gmail.com>
Date:   Thu, 17 Sep 2020 09:10:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAA+iEG9eAwkmYiVoUTxSptVsijeD8NqRTR6tRHuboo8MdB9jqg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[CC += beej, to alert the author about the memory leaks 
in the network programming guide]

Hello Marko,

> On Thu, Sep 17, 2020 at 7:42 AM Michael Kerrisk (man-pages) <
> mtk.manpages@gmail.com> wrote:
> 
>> Hi Marko,
>>
>> On Thu, 17 Sep 2020 at 07:34, Marko Hrastovec <marko.hrastovec@gmail.com>
>> wrote:
>>>
>>> Hi,
>>>
>>> examples in freeaddrinfo.3 have a memory leak, which is replicated in
>> many real world programs copying an example from manual pages. The two
>> examples should have different order of lines, which is done in the
>> following patch.
>>>
>>> diff --git a/man3/getaddrinfo.3 b/man3/getaddrinfo.3
>>> index c9a4b3e43..4d383bea0 100644
>>> --- a/man3/getaddrinfo.3
>>> +++ b/man3/getaddrinfo.3
>>> @@ -711,13 +711,13 @@ main(int argc, char *argv[])
>>>          close(sfd);
>>>      }
>>>
>>> +    freeaddrinfo(result);           /* No longer needed */
>>> +
>>>      if (rp == NULL) {               /* No address succeeded */
>>>          fprintf(stderr, "Could not bind\en");
>>>          exit(EXIT_FAILURE);
>>>      }
>>>
>>> -    freeaddrinfo(result);           /* No longer needed */
>>> -
>>>      /* Read datagrams and echo them back to sender */
>>>
>>>      for (;;) {
>>> @@ -804,13 +804,13 @@ main(int argc, char *argv[])
>>>          close(sfd);
>>>      }
>>>
>>> +    freeaddrinfo(result);           /* No longer needed */
>>> +
>>>      if (rp == NULL) {               /* No address succeeded */
>>>          fprintf(stderr, "Could not connect\en");
>>>          exit(EXIT_FAILURE);
>>>      }
>>>
>>> -    freeaddrinfo(result);           /* No longer needed */
>>> -
>>>      /* Send remaining command\-line arguments as separate
>>>         datagrams, and read responses from server */
>>>
>>
>> When you say "memory leak", do you mean that something like valgrind
>> complains? I mean, strictly speaking, there is no memory leak that I
>> can see that is fixed by that patch, since the if-branches that the
>> freeaddrinfo() calls are shifted above terminates the process in each
>> case.
>
> you are right about terminating the process. However, people copy that
> example and put the code in function changing "exit" to "return". There are
> a bunch of examples like that here https://beej.us/guide/bgnet/html/#poll,
> for instance.

Oh -- I see what you mean.

> That error bothered me when reading the network programming
> guide https://beej.us/guide/bgnet/html/. Than I looked for information
> elsewhere:
> -
> https://stackoverflow.com/questions/6712740/valgrind-reporting-that-getaddrinfo-is-leaking-memory
> -
> https://stackoverflow.com/questions/15690303/server-client-sockets-freeaddrinfo3-placement
> And finally, I checked manual pages and saw where these errors come from.
> 
> When you change that to a function and return without doing freeaddrinfo,
> that is a memory leak. I believe an example should show good programming
> practices. Relying on exiting and clearing the memory in that case is not
> such a case. In my opinion, these examples lead people to make mistakes in
> their programs.

Yes, I can buy that argument. I've applied your patch.

Thanks,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
