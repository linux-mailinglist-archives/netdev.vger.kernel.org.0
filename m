Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0625323E594
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 03:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgHGBoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 21:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgHGBoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 21:44:03 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16284C061574
        for <netdev@vger.kernel.org>; Thu,  6 Aug 2020 18:44:03 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id i92so5509549pje.0
        for <netdev@vger.kernel.org>; Thu, 06 Aug 2020 18:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X8jOKTGI8kqG1hpaKKhS1qz9JOVoxqtbyY41XPY3wpM=;
        b=ipv921erEMCUI9sdhH5z23q1pomQpKFCcXzJxZJQwayxjM5wysfsTSLUXeWolwe3Dw
         dOABe17mpwBz7BTsgZZWUD74lQbTmuILaw9trB8S3B5kG7pTO9II1N0YougnnpQNYHxl
         YiSFBpxSUxpR7z4XouaBNv0kZB7Tqo+mTb1fEuIsp3scrJkkUHqsmb4qwcq8Bkqo00rg
         9Cq+6vw/VvQ/4DJBi2qnRf/XFQvSe6ErhNKXyG5T6UveUCdj0R9hny2MyZJUC2HTNHub
         1UMlUa2mC+qjdVqbKUpAb48ZfrdDLwRCqFj/PrBTcIbzCtXEvPfhPnxCGZe5gm4Lw/im
         oXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=X8jOKTGI8kqG1hpaKKhS1qz9JOVoxqtbyY41XPY3wpM=;
        b=bpdTxrIJksJ4dHyrmjQ0pczUjxVcrHXi2auXAjMu7MONIOaTNNdPC2qZDkaa1HCLrV
         EDeErcuGcGWmZ/Rvbh4tWK5qgVpUtMEgZESMEGEErGXWSW7fi+vnGvYqLtxHrwoqt5fR
         dRpukI/MNYeqpgqRWgv/M/tHUzhq0lUkAB2YAjCGM4h8vUElv+xoYu1wxQDigPpRGUVs
         IaYuZlSxBCecmuYkvCB59KBnq9U0IPeDFDD9F53TVXagmTHD9l7RDyLUAQvHAYlmTlic
         Tlq/2UxMFXOZ/ID9xqwdLOuEYfHcY6uAwj7iTRF3FmQ+GOF5i3AkCf+4qfuxo+X8OHXY
         3FBg==
X-Gm-Message-State: AOAM532F1xRXaeYT0PlDHFHUk71qd4tcGdoV5pVcQ88X7l3/4pFKYJWD
        9JaXWv/ax2DUqlHb+gEut7jNgRjriPXmfQ==
X-Google-Smtp-Source: ABdhPJwIs9it+xD96L2HMRdvG8eyC5dJ8HbHIetEQAciA7TRfikfs52uIxVz6HkEdZ3h2YkBP7roNg==
X-Received: by 2002:a17:902:a50e:: with SMTP id s14mr9703382plq.164.1596764642133;
        Thu, 06 Aug 2020 18:44:02 -0700 (PDT)
Received: from [192.168.10.94] (124-171-83-152.dyn.iinet.net.au. [124.171.83.152])
        by smtp.gmail.com with ESMTPSA id fv23sm3245567pjb.35.2020.08.06.18.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 18:44:01 -0700 (PDT)
Subject: Re: 9p/trans_fd lockup
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     v9fs-developer@lists.sourceforge.net, Greg Kurz <groug@kaod.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <9d8a8abf-7968-2752-89e7-bac39ae91999@ozlabs.ru>
 <20200806123849.GA2640@nautica>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Autocrypt: addr=aik@ozlabs.ru; keydata=
 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
Message-ID: <b148ec48-0338-3549-7250-2b40d865d517@ozlabs.ru>
Date:   Fri, 7 Aug 2020 11:43:57 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200806123849.GA2640@nautica>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/08/2020 22:38, Dominique Martinet wrote:
> Alexey Kardashevskiy wrote on Thu, Aug 06, 2020:
>> I am seeing another bug in 9p under syzkaller, the reprocase is:
>>
>> r0 = open$dir(&(0x7f0000000040)='./file0\x00', 0x88142, 0x182)
>>
>> r1 = openat$null(0xffffffffffffff9c, &(0x7f0000000640)='/dev/null\x00',
>> 0x0, 0x0)
>> mount$9p_fd(0x0, &(0x7f0000000000)='./file0\x00',
>> &(0x7f00000000c0)='9p\x00', 0x0, &(0x7f0000000100)={'trans=fd,',
>> {'rfdno', 0x3d, r1}, 0x2$, {'wfdno', 0x3d, r0}})
>>
>>
>>
>> The default behaviour of syzkaller is to call syscalls concurrently (I
>> think), at least it forks by default and executes the same sequence in
>> both threads.
>>
>> In this example both threads makes it to:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/9p/client.c?h=v5.8#n757
>>
>> and sit there with the only difference which is thread#1 goes via
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/9p/client.c?h=v5.8#n767
>>
>> I am pretty sure things should not have gone that far but I cannot
>> clearly see what needs fixing. Ideas? Thanks,
> 
> Unkillable threads there happen with the current p9_client_rpc when
> there is no real server (or server bug etc); the code is really stupid.
> 
> Basically what happens is that when you send a first signal (^C or
> whatever), the function catches the signal, sends a flush, and
> indefinitely waits for the flush to come back.
> If you send another signal there no more flush comes but it goes back to
> waiting -- it's using wait_event_killable but it's a lie it's not really
> killable it just loops on that wait until the flush finally comes, which
> will never come in your case.
> (the rpc that came by the way is probably version or whatever is first
> done on mount)
> 
> 
> Dmitry reported that to me ages ago and I have a fix which is just to
> stop waiting for the flush -- just make it asynchronous, send and
> forget. That removes the whole signal handling logic and it won't hang
> there anymore.
> 
> I sent the patches to the list last year, but didn't get much feedback
> and didn't have time to run all the tests I wanted to run on it.
> 
> 
> I have some free time at the end of the month so I was planning to
> finish it for 5.10 (e.g. won't send it for 5.9 but once 5.9 initial
> merge window passed leave it in -next for a couple of months and push it
> for 5.10), so your timing is pretty good :)
> An extra pair of eyes would be more than appreciated.
> 
> You can find the original mails there:
> https://lore.kernel.org/lkml/1544532108-21689-3-git-send-email-asmadeus@codewreck.org/
> 
> They're also in my 9p-test branch on git://github.com/martinetd/linux

Thanks for the patches, they fix my case indeed and I'll continue with
them, let's see what else syzkaller finds :)


> 
> 
> Cheers & thanks for the attention,
> 

-- 
Alexey
