Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E309679D74
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 16:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbjAXP2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 10:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbjAXP2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 10:28:15 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C82E41B6B
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 07:28:10 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v10so18645308edi.8
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 07:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EDj3bqARuwz4Z/vVlemegTPp3GDiSkBOCoGElPtje4g=;
        b=PzjReetj9Bi291tGa/y9Z1Y6ojdVibwsjeboJYud0ZZWVpV7/867EK1IIEdPN6Li+O
         jYNzcMZ5zHVqztgjfMk9FCIpybyuUsiSbTQvokCDgfOd9Jm1lT5NGVI2bWhroPhf+ja+
         ghzn0Jn/sCaUcwsIuBqzOKcL6RTn6+UTN5AZhaQmYD1scCSkO48H+wyCsygZj+sAz/Ck
         s9QrFKP9if5722oQJkt45IRCGg8i0b0agUAoA7FGp+ZNloU2brxY6ORGdGokPXBi37Ej
         0LGrc3ABFmTQg1WRnaApeH4xvuuj1Wb9WFYgoBfIl80k/kXrRlt+58ko4hzWLT+vrcCv
         DISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EDj3bqARuwz4Z/vVlemegTPp3GDiSkBOCoGElPtje4g=;
        b=x/OTO5MZB8jO37Qe6krX1QRIY6wcG4vrf2et27Dzs1z0auY1lRmMeZMa0SRr8dwixC
         /Trl4ffP6PdPnczDjDt3Mo7qY6SVdQokjOj+xwiq9DjSD356W1z377uYfc8/3GibCmIU
         LN2wLwVPgiXYF9MlZu6VC2dJoPmI/aYioqzb7vXnf7w144sDNz2uAt20acycHgOhIyii
         WtSI65KLs8g+qMzfT7jF0ofS20Ejn9/4gkw4HsLuDZFbPKp0LOMBFeBhcRZKzcQftm40
         H4cTxmAXNIeNPcXfUs58ZAnQJiIdLca+UzOiR4/fLYQabu1oRCA0rS3AlOUhbWtX1xyx
         +huA==
X-Gm-Message-State: AFqh2koZNnrcgwpqtEhm8wAytzfRaOksRtCYXb0Pa3hj0XN8Kh6DdEBs
        29jNyd6rIz0Be0osVXrQjR8GV0wakIE=
X-Google-Smtp-Source: AMrXdXvuPk0Vsqp9XxfG2gw4iKtqY2KTWMY9a+hjmigKSOOMzMSMz4AL0FkEwfCpCmo8cJYByh8dJw==
X-Received: by 2002:a50:c31e:0:b0:49e:f750:84f1 with SMTP id a30-20020a50c31e000000b0049ef75084f1mr13343963edb.38.1674574088836;
        Tue, 24 Jan 2023 07:28:08 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::206f? ([2620:10d:c092:600::2:74e0])
        by smtp.gmail.com with ESMTPSA id cy5-20020a0564021c8500b0049ef56c01d0sm1157392edb.79.2023.01.24.07.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 07:28:08 -0800 (PST)
Message-ID: <71a0050a-2656-1d5b-0302-65000cf854cb@gmail.com>
Date:   Tue, 24 Jan 2023 15:27:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: traceroute failure in kernel 6.1 and 6.2
To:     Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Mantas_Mikul=c4=97nas?= <grawity@gmail.com>
Cc:     netdev@vger.kernel.org
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
 <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
 <eaab7495-53d5-0026-842c-acb420408cd0@gmail.com>
 <CANn89iLQeHsf9=ZqUvU0Y_CVsHbzvd07sdFfOH-poFmGqtn0cA@mail.gmail.com>
 <168aa9cf-d80a-9c1b-887f-97015a0473dc@gmail.com>
 <CANn89iK7nn6tdQg9QZO_Gudx1BvLxhoLaNYmnOLb6ccYQnLGwg@mail.gmail.com>
 <b2ecff1c-91ad-4217-7fd5-d7bbd5704abe@gmail.com>
 <CANn89iLV3NDiEA4tPWUxjqoHNx1pv=SEpXd1b38NXU=TK13=tg@mail.gmail.com>
 <CANn89iLKQB=9rYyKXVH=hd2aBUjzhhjXA0FOdSvN3reH+k9cMQ@mail.gmail.com>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CANn89iLKQB=9rYyKXVH=hd2aBUjzhhjXA0FOdSvN3reH+k9cMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/24/23 08:57, Eric Dumazet wrote:
> On Tue, Jan 24, 2023 at 7:03 AM Eric Dumazet <edumazet@google.com> wrote:
[...]
>>> It doesn't solve the issue; I tried bumping it from the default of
>>> 212992 to 4096-times-that, with exactly the same results.
>>>
>>> The amount of packets it's able to send is variable, For example, right
>>> now, on my regular VM (which is smaller than the PC that yesterday's
>>> trace was done on), the program very consistently fails on the *second*
>>> sendto() call -- I don't think two packets is an unreasonable amount.
>>>
>>> The program has -q and -N options to reduce the number of simultaneous
>>> probes, but the only effect it has is if I reduce the packets all the
>>> way down to just one at a time.
>>
>> Problem is : if we revert the patch, unpriv users can trivially crash a host.
>>
>> Also, sent ICMP packets  look just fine to me, and the patch is
>> changing tx path.
>>
>> The reported issue seems more like rx path related to me.
>> Like IP_RECVERR being not handled correctly.
>>
>> I think more investigations are needed. Maybe contact Pavel Begunkov
>> <asml.silence@gmail.com>
>> because the initial crash issue came with
>> 47cf88993c91 ("net: unify alloclen calculation for paged requests")
> 
> I am reasonably confident this is a bug in this traceroute binary.
> 
> It sets
>   setsockopt(3, SOL_IP, IP_RECVERR, [1], 4) = 0
> 
> So a sendto() can absolutely return the error set by last received
> ICMP (cf ping_err()) on the socket,
> as per RFC1122 4.1.3.3
> 
>   4.1.3.3  ICMP Messages
> 
>              UDP MUST pass to the application layer all ICMP error
>              messages that it receives from the IP layer.  Conceptually
>              at least, this may be accomplished with an upcall to the
>              ERROR_REPORT routine (see Section 4.2.4.1).
> 
>              DISCUSSION:
>                   Note that ICMP error messages resulting from sending a
>                   UDP datagram are received asynchronously.  A UDP-based
>                   application that wants to receive ICMP error messages
>                   is responsible for maintaining the state necessary to
>                   demultiplex these messages when they arrive; for
>                   example, the application may keep a pending receive
>                   operation for this purpose.  The application is also
>                   responsible to avoid confusion from a delayed ICMP
>                   error message resulting from an earlier use of the same
> 
> 
> Fix would be
> 
> diff traceroute/traceroute.c.orig traceroute/traceroute.c
> 1657c1657
> <     if (errno == EMSGSIZE)
> ---
>>      if (errno == EMSGSIZE || errno == EHOSTUNREACH)
> 
> or to collect a pending socket error (but that would be racy), using
> SO_ERROR getsockopt()

If it doesn't help I'll take a look, perfectly reproducible for me.

-- 
Pavel Begunkov
