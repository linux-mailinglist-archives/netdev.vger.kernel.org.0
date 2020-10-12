Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4938728B14B
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387400AbgJLJR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgJLJR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:17:56 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BDBC0613CE;
        Mon, 12 Oct 2020 02:17:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o3so3650881pgr.11;
        Mon, 12 Oct 2020 02:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Ov3FUKrNTHLpkrGh5RLsSQkZzOmYXtgceijebKP/orE=;
        b=Pxf91ZADA3kHjPOTZCRMhqikUJb6PIBg3jJeAbwA/Hf8O18uGy2b0oXYhxlV/BTduC
         n/djlhrL8iuzGzI7fyqZRmsCzqHugC0fvDI6OpfiJFg7FdKqYnTdmoeIF/AlzDZ5fUEA
         cBaj2zgLb7ITgxsXWhbRAPzZnTFP+3UHN2w9KWALiaD2FJ2TbDn2oT4W3M8DfHtf1FkF
         Nx7OVH7Z4k3RDHxutTwnSsOZ18/lCgUUtzsjLalW1qCDcBlrMHA60QSMgpW29f0Yhhdx
         Z8VjKTKEySkDlq43+F+xVpHzakF9ZASwJtHFB/iKmb1BZkItovGokmMJMfOIrigkWNRN
         Xe3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ov3FUKrNTHLpkrGh5RLsSQkZzOmYXtgceijebKP/orE=;
        b=UYfe6YDZoYUa0OFuRBTHYaEMEOvnDLCkwxbpzGlxRAlCEAHvXwToqRjUMqTlj8/2hA
         /vZJmD6EkwV2rupOzJTkEx8AlJ1+Gd8er5mcgCyKPN2w2sd8k5L1aTj95YqLoOxZozSz
         j0eoGeep00WgaWSxbIPNaCzbxQr04jBXfRHaPJRXg+tcdWOpVuuFFaA0EQnHdONbal4O
         WlpnCz7R/z7I2e88chip8Btg0oKdI/YbNqQBvCLyvDglaf2+HEK9SWGGxWm6ThvJgpno
         uoXCLbotKWPlMYcU9dFEG5Wl631L83iYUBvqFbeyTfpkcLZOn0Q26eAu7n1ORUx8Abyx
         Vilg==
X-Gm-Message-State: AOAM530lMFzJe5h+UTW5cYJfVj2jOK2vEjbqLUkjhM8xwyb3vaxiZxme
        HrYhOeqobmevIM4slwftz8s=
X-Google-Smtp-Source: ABdhPJxxXGtyhYKNPjMn5KenHZwRXjmQMFBS4Ovr6doT1BbITKj2ygbJJBvg7ch/3u6iFxAfxHNPgg==
X-Received: by 2002:a17:90b:4d05:: with SMTP id mw5mr9039646pjb.9.1602494275069;
        Mon, 12 Oct 2020 02:17:55 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.200.2])
        by smtp.gmail.com with ESMTPSA id w205sm19514691pfc.78.2020.10.12.02.17.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 02:17:54 -0700 (PDT)
Subject: Re: [PATCH net] net: 9p: initialize sun_server.sun_path to have
 addr's value only when addr is valid
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        kuba@kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
References: <20201012042404.2508-1-anant.thazhemadam@gmail.com>
 <20201012075910.GA17745@nautica>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <147004bd-5cff-6240-218d-ebd80a9b48a1@gmail.com>
Date:   Mon, 12 Oct 2020 14:47:50 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201012075910.GA17745@nautica>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12-10-2020 13:29, Dominique Martinet wrote:
> Anant Thazhemadam wrote on Mon, Oct 12, 2020:
>> In p9_fd_create_unix, checking is performed to see if the addr (passed
>> as an argument) is NULL or not.
>> However, no check is performed to see if addr is a valid address, i.e.,
>> it doesn't entirely consist of only 0's.
>> The initialization of sun_server.sun_path to be equal to this faulty
>> addr value leads to an uninitialized variable, as detected by KMSAN.
>> Checking for this (faulty addr) and returning a negative error number
>> appropriately, resolves this issue.
> I'm not sure I agree a fully zeroed address is faulty but I agree we can
> probably refuse it given userspace can't pass useful abstract addresses
> here.


Understood. It's  probably a better that I modify the commit message a little and
send a v2 so it becomes more accurate.

> Just one nitpick but this is otherwise fine - good catch!

Thank you!

>
>> Reported-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
>> Tested-by: syzbot+75d51fe5bf4ebe988518@syzkaller.appspotmail.com
>> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
>> ---
>>  net/9p/trans_fd.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
>> index c0762a302162..8f528e783a6c 100644
>> --- a/net/9p/trans_fd.c
>> +++ b/net/9p/trans_fd.c
>> @@ -1023,7 +1023,7 @@ p9_fd_create_unix(struct p9_client *client, const char *addr, char *args)
>>  
>>  	csocket = NULL;
>>  
>> -	if (addr == NULL)
>> +	if (!addr || !strlen(addr))
> Since we don't care about the actual length here, how about checking for
> addr[0] directly?
> That'll spare a strlen() call in the valid case.
>
You mentioned how a fully zeroed address isn't exactly faulty. By extension, wouldn't that
mean that an address that simply begins with a 0 isn't faulty as well?
This is an interesting point, because if the condition is modified to checking for addr[0] directly,
addresses that simply begin with 0 (but have more non-zero content following) wouldn't be
copied over either, right?
In the end, it comes down to what you define as a "valid" value that sun_path can have.
We've already agreed that a fully zeroed address wouldn't qualify as a valid value for sun_path.
Are addresses that aren't fully zeroed, but only begin with a 0 also to be considered as an
unacceptable value for sun_path?

Thanks,
Anant




