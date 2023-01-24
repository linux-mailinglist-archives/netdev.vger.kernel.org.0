Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9F6678FF5
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbjAXFeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjAXFef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:34:35 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673F42FCD4
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:34:25 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id n7so12757612wrx.5
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 21:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0H72fnE1wFGB9utxr+x+fby/FXo/3v8BOrVavLLOguQ=;
        b=PvwpR4se/L7IBSxiZWaHIFNuetYNB2aURUy3DtCh8BO10szZ0h1cCAZFLZ4MiVxGTO
         y4EnaAPHtcK6VJPHal9bpddd1Awts7jBdOgBS2R1LFhU60xs0feOz/9neKnsQ9Dpnw3u
         p5kqmTFXzqE5FAG1lt2wr155GuvhTTFq8R8mnAYZZ7wCsRQ9VtztPGZab4F/4xLFR761
         GmTBLCWolC3920IxNLVq9lqcOi3FfRQ6t4HkpmXkujuhStw5+lVFUsjtteTa0ugYy6L6
         yyYQBG12jq/RGWZb2FqZRs8igCMNmK3DY8JNivw0b6kwDZ2jH0oEd1JpEX8RnsTMALrM
         q/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0H72fnE1wFGB9utxr+x+fby/FXo/3v8BOrVavLLOguQ=;
        b=svwgUl4zKH/mMJuGlWAKu72fYa7p/9zXtRwJMAgQmOpawVwuFdQn/RNEdJeQUYvpGO
         WEnROUfhjQ6AmWHGisT+gzhx29b0bKh0wgFklEnxg1wII90lMwauvDAufrs9EK3gFqPh
         d5N9o9Y3m11pt2lQUQti/fguDOBEkEatP1seilmwPvu4eSlS8gvjZrsE7Qt2RC9RY3Hi
         lYYSO6Wbnm1lpPsVKCeBREyFzraleDQEFnnuN52jZUucU77gIfdS9kINbHg2L2LDYDtm
         5oHhnVSvFc602K6QIZexmmfjEz6LtcLbC95pnMm5IF3jrnUt9yvpKfAluv2pnssV68er
         7vpg==
X-Gm-Message-State: AFqh2koIQ3qKlB5siR4/8TAbZPhC+fsfqFd+g0yrrrHH5NIRL2q6+MT5
        JzO1x2DLF1tWo+4a52+eVNgGHbDC8rc=
X-Google-Smtp-Source: AMrXdXvnBNJ+Qu2GjSFmISpUREM1CJP+p4fR9cgFT/IrKNLosR/UAfb8qMHOwj3HIPbFkkaKeEVG7Q==
X-Received: by 2002:a5d:65d2:0:b0:2bb:6c04:4598 with SMTP id e18-20020a5d65d2000000b002bb6c044598mr23953512wrw.67.1674538463536;
        Mon, 23 Jan 2023 21:34:23 -0800 (PST)
Received: from ?IPV6:2001:778:e27f:a23:36c4:e19f:3c1:8a8? ([2001:778:e27f:a23:36c4:e19f:3c1:8a8])
        by smtp.gmail.com with ESMTPSA id j26-20020a5d453a000000b002bdf3809f59sm953076wra.38.2023.01.23.21.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 21:34:23 -0800 (PST)
Message-ID: <b2ecff1c-91ad-4217-7fd5-d7bbd5704abe@gmail.com>
Date:   Tue, 24 Jan 2023 07:34:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: traceroute failure in kernel 6.1 and 6.2
Content-Language: en-US, lt-LT
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
 <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
 <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com>
 <CANn89iLQeHsf9=ZqUvU0Y_CVsHbzvd07sdFfOH-poFmGqtn0cA@mail.gmail.com>
 <168aa9cf-d80a-9c1b-887f-97015a0473dc@gmail.com>
 <CANn89iK7nn6tdQg9QZO_Gudx1BvLxhoLaNYmnOLb6ccYQnLGwg@mail.gmail.com>
From:   =?UTF-8?Q?Mantas_Mikul=c4=97nas?= <grawity@gmail.com>
In-Reply-To: <CANn89iK7nn6tdQg9QZO_Gudx1BvLxhoLaNYmnOLb6ccYQnLGwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/01/2023 00.26, Eric Dumazet wrote:
> On Mon, Jan 23, 2023 at 10:45 PM Mantas Mikulėnas <grawity@gmail.com> wrote:
>>
>> On 23/01/2023 22.56, Eric Dumazet wrote:
>>> On Mon, Jan 23, 2023 at 8:25 PM Mantas Mikulėnas <grawity@gmail.com> wrote:
>>>>
>>>> On 2023-01-23 17:21, Eric Dumazet wrote:
>>>>> On Sat, Jan 21, 2023 at 7:09 PM Mantas Mikulėnas <grawity@gmail.com> wrote:
>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> Not sure whether this has been reported, but:
>>>>>>
>>>>>> After upgrading from kernel 6.0.7 to 6.1.6 on Arch Linux, unprivileged
>>>>>> ICMP traceroute using the `traceroute -I` tool stopped working – it very
>>>>>> reliably fails with a "No route to host" at some point:
>>>>>>
>>>>>>            myth> traceroute -I 83.171.33.188
>>>>>>            traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
>>>>>>            byte packets
>>>>>>             1  _gateway (192.168.1.1)  0.819 ms
>>>>>>            send: No route to host
>>>>>>            [exited with 1]
>>>>>>
>>>>>> while it still works for root:
>>>>>>
>>>>>>            myth> sudo traceroute -I 83.171.33.188
>>>>>>            traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
>>>>>>            byte packets
>>>>>>             1  _gateway (192.168.1.1)  0.771 ms
>>>>>>             2  * * *
>>>>>>             3  10.69.21.145 (10.69.21.145)  47.194 ms
>>>>>>             4  82-135-179-168.static.zebra.lt (82.135.179.168)  49.124 ms
>>>>>>             5  213-190-41-3.static.telecom.lt (213.190.41.3)  44.211 ms
>>>>>>             6  193.219.153.25 (193.219.153.25)  77.171 ms
>>>>>>             7  83.171.33.188 (83.171.33.188)  78.198 ms
>>>>>>
>>>>>> According to `git bisect`, this started with:
>>>>>>
>>>>>>            commit 0d24148bd276ead5708ef56a4725580555bb48a3
>>>>>>            Author: Eric Dumazet <edumazet@google.com>
>>>>>>            Date:   Tue Oct 11 14:27:29 2022 -0700
>>>>>>
>>>>>>                inet: ping: fix recent breakage
>>>>>>
>>>>>>
>>>>>>
>>>>>>
>>>>>> It still happens with a fresh 6.2rc build, unless I revert that commit.
>>>>>>
>>>>>> The /bin/traceroute is the one that calls itself "Modern traceroute for
>>>>>> Linux, version 2.1.1", on Arch Linux. It seems to use socket(AF_INET,
>>>>>> SOCK_DGRAM, IPPROTO_ICMP), has neither setuid nor file capabilities.
>>>>>> (The problem does not occur if I run it as root.)
>>>>>>
>>>>>> This version of `traceroute` sends multiple probes at once (with TTLs
>>>>>> 1..16); according to strace, the first approx. 8-12 probes are sent
>>>>>> successfully, but eventually sendto() fails with EHOSTUNREACH. (Though
>>>>>> if I run it on local tty as opposed to SSH, it fails earlier.) If I use
>>>>>> -N1 to have it only send one probe at a time, the problem doesn't seem
>>>>>> to occur.
>>>>>
>>>>>
>>>>>
>>>>> I was not able to reproduce the issue (downloading
>>>>> https://sourceforge.net/projects/traceroute/files/latest/download)
>>>>>
>>>>> I suspect some kind of bug in this traceroute, when/if some ICMP error
>>>>> comes back.
>>>>>
>>>>> Double check by
>>>>>
>>>>> tcpdump -i ethXXXX icmp
>>>>>
>>>>> While you run traceroute -I ....
>>>>
>>>> Hmm, no, the only ICMP errors I see in tcpdump are "Time exceeded in
>>>> transit", which is expected for traceroute. Nothing else shows up.
>>>>
>>>> (But when I test against an address that causes *real* ICMP "Host
>>>> unreachable" errors, it seems to handle those correctly and prints "!H"
>>>> as usual -- that is, if it reaches that point without dying.)
>>>>
>>>> I was able to reproduce this on a fresh Linode 1G instance (starting
>>>> with their Arch image), where it also happens immediately:
>>>>
>>>>           # pacman -Sy archlinux-keyring
>>>>           # pacman -Syu
>>>>           # pacman -Sy traceroute strace
>>>>           # reboot
>>>>           # uname -r
>>>>           6.1.7-arch1-1
>>>>           # useradd foo
>>>>           # su -c "traceroute -I 8.8.8.8" foo
>>>>           traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
>>>>            1  10.210.1.195 (10.210.1.195)  0.209 ms
>>>>           send: No route to host
>>>>
>>>> So now I'm fairly sure it is not something caused by my own network, either.
>>>>
>>>> On one system, it seems to work properly about half the time, if I keep
>>>> re-running the same command.
>>>>
>>>
>>> Here, running the latest  upstream tree and latest traceroute, I have no issue.
>>>
>>> Send us :
>>>
>>> 1) strace output
>>> 2) icmp packet capture.
>>>
>>> Thanks.
>>
>> Attached both.
> 
> Thanks.
> 
> I think it is a bug in this traceroute version, pushing too many
> sendmsg() at once and hitting socket SNDBUF limit
> 
> If the sendmsg() is blocked in sock_alloc_send_pskb, it might abort
> because an incoming ICMP message sets sk->sk_err
> 
> It might have worked in the past, by pure luck.
> 
> Try to increase /proc/sys/net/core/wmem_default
> 
> If this solves the issue, I would advise sending a patch to traceroute to :
> 
> 1) attempt to increase SO_SNDBUF accordingly
> 2) use non blocking sendmsg() api to sense how many packets can be
> queued in qdisc/NIC queues
> 3) reduce number of parallel messages (current traceroute behavior
> looks like a flood to me)

It doesn't solve the issue; I tried bumping it from the default of 
212992 to 4096-times-that, with exactly the same results.

The amount of packets it's able to send is variable, For example, right 
now, on my regular VM (which is smaller than the PC that yesterday's 
trace was done on), the program very consistently fails on the *second* 
sendto() call -- I don't think two packets is an unreasonable amount.

The program has -q and -N options to reduce the number of simultaneous 
probes, but the only effect it has is if I reduce the packets all the 
way down to just one at a time.
