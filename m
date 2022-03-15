Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8C34D9176
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 01:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343932AbiCOA2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 20:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343873AbiCOA2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 20:28:11 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7661541986
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:27:00 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id fs4-20020a17090af28400b001bf5624c0aaso975291pjb.0
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 17:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=SLF1jfmmWC0pCdN9K6V94iAbp21VdLeSQ8eyzHL5nkI=;
        b=HKlD7JsUS3zEsm5v9/eJ70LyfrUawl9Tnx8JpFniT7Jh3wRmlwF/hJA4Er4Ga3hBUx
         3ph4YVVJftCPy60j4gA+M+He9/mP7Jr5LiCJ7AbOH8bRSHbNqR7ud6ooHzw66bEQuriN
         x6NWLNY7P04rtSBZrtrS0lNCAz8RpiQ2dKo3Li2yo4Ui+OQG2aEXd5daqFGdujbMZEKF
         acSGyyw9G4/IYC3/pqWhoOtja4R1bZsZctqVH0/2yNXBuc3gyn2AbS/+TJALcbm+xkg0
         PDS5bEdxN77kf3GOUR7HxIbyuLTje4C8TF8XdO4k5u6oniwG2cN80AaAV0K4UfSsfcvX
         vx5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SLF1jfmmWC0pCdN9K6V94iAbp21VdLeSQ8eyzHL5nkI=;
        b=jTwyP3qrOcG4V9zsaD3YbsAre86UB451iZU/9wFuuvw0ZrRHfFYyEpvja0UE4ibTJw
         1vz6GhvDbmWWs9VH8vCaHC8WTTWKMD5aOHRqmVnLwK63eiQK/B8y/Bh6srw6Xk+jhZ5J
         w6B1MSlS0MzeQzI86ongCrwI7gdoSrZiURXbdHLvZLUC7X7jY/l6Ef6NF39V2jXjS3nN
         0d9h42LPPIRWsPlsF3CFjNYbcLTl4mzzvvesZOLrgX7qzamGGZ0W4hh6fctl33lhZZSf
         HS7EBv265ffvBqoZM9eTDWsL1XjrVB1nTCo8ESira3iJf6B0+lpKuUYi1k3C6boCBWiP
         GkGg==
X-Gm-Message-State: AOAM533CsWzoPDjaIB9XtRqZmuwBFXzcbCKxS8U6xG6jdwkZhYz8/fnE
        dlpfTjaHPgNNEIhvLM0MS4E=
X-Google-Smtp-Source: ABdhPJwenSkLIFCmeG+TuPawB0FC00HX2nFEFvYYAAIVLRU2YXnD19EGp+XykXCDbVjBUdnhtQaZYQ==
X-Received: by 2002:a17:90b:4f44:b0:1bf:61b2:4560 with SMTP id pj4-20020a17090b4f4400b001bf61b24560mr1609256pjb.245.1647304019830;
        Mon, 14 Mar 2022 17:26:59 -0700 (PDT)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id g7-20020a656cc7000000b00375948e63d6sm16831416pgw.91.2022.03.14.17.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Mar 2022 17:26:59 -0700 (PDT)
Message-ID: <14f3c8e3-1b8f-7152-224b-6a4c9a0b6e61@gmail.com>
Date:   Mon, 14 Mar 2022 17:26:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH net] af_unix: Support POLLPRI for OOB.
Content-Language: en-US
To:     Shoaib Rao <rao.shoaib@oracle.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220314052110.53634-1-kuniyu@amazon.co.jp>
 <bb446581-6eaf-3b61-1e5d-07d629c77831@gmail.com>
 <141499fc-fb51-74be-32fd-a4e9008d7abf@oracle.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <141499fc-fb51-74be-32fd-a4e9008d7abf@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/14/22 11:10, Shoaib Rao wrote:
>
> On 3/14/22 10:42, Eric Dumazet wrote:
>>
>> On 3/13/22 22:21, Kuniyuki Iwashima wrote:
>>> The commit 314001f0bf92 ("af_unix: Add OOB support") introduced OOB for
>>> AF_UNIX, but it lacks some changes for POLLPRI.  Let's add the missing
>>> piece.
>>>
>>> In the selftest, normal datagrams are sent followed by OOB data, so 
>>> this
>>> commit replaces `POLLIN | POLLPRI` with just `POLLPRI` in the first 
>>> test
>>> case.
>>>
>>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>>> ---
>>>   net/unix/af_unix.c                                  | 2 ++
>>>   tools/testing/selftests/net/af_unix/test_unix_oob.c | 6 +++---
>>>   2 files changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>> index c19569819866..711d21b1c3e1 100644
>>> --- a/net/unix/af_unix.c
>>> +++ b/net/unix/af_unix.c
>>> @@ -3139,6 +3139,8 @@ static __poll_t unix_poll(struct file *file, 
>>> struct socket *sock, poll_table *wa
>>>           mask |= EPOLLIN | EPOLLRDNORM;
>>>       if (sk_is_readable(sk))
>>>           mask |= EPOLLIN | EPOLLRDNORM;
>>> +    if (unix_sk(sk)->oob_skb)
>>> +        mask |= EPOLLPRI;
>>
>>
>> This adds another data-race, maybe add something to avoid another 
>> syzbot report ?
>
> It's not obvious to me how there would be a race as it is just a check.
>

KCSAN will detect that whenever unix_poll() reads oob_skb,

its value can be changed by another cpu.


unix_poll() runs without holding a lock.



> Also this change should be under #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
>
> Thanks,
>
> Shoaib
>
>>
>>
>>>         /* Connection-based need to check for termination and 
>>> startup */
>>>       if ((sk->sk_type == SOCK_STREAM || sk->sk_type == 
>>> SOCK_SEQPACKET) &&
>>> diff --git a/tools/testing/selftests/net/af_unix/test_unix_oob.c 
>>> b/tools/testing/selftests/net/af_unix/test_unix_oob.c
>>> index 3dece8b29253..b57e91e1c3f2 100644
>>> --- a/tools/testing/selftests/net/af_unix/test_unix_oob.c
>>> +++ b/tools/testing/selftests/net/af_unix/test_unix_oob.c
>>> @@ -218,10 +218,10 @@ main(int argc, char **argv)
>>>         /* Test 1:
>>>        * veriyf that SIGURG is
>>> -     * delivered and 63 bytes are
>>> -     * read and oob is '@'
>>> +     * delivered, 63 bytes are
>>> +     * read, oob is '@', and POLLPRI works.
>>>        */
>>> -    wait_for_data(pfd, POLLIN | POLLPRI);
>>> +    wait_for_data(pfd, POLLPRI);
>>>       read_oob(pfd, &oob);
>>>       len = read_data(pfd, buf, 1024);
>>>       if (!signal_recvd || len != 63 || oob != '@') {
