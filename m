Return-Path: <netdev+bounces-11889-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 906FB735031
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA9AF1C2098E
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:30:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F173C8E1;
	Mon, 19 Jun 2023 09:28:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1C8C8D6
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:28:07 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6958535BB
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:27:49 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f9002a1a39so16703065e9.2
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687166868; x=1689758868;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wu8/ZiEpyGAPwhhj0SnCYP8UmFOJYM33vPmFMYzLHsA=;
        b=gX3NLSc8j/yurPOOINJgvslTMxi5A2DVTzKBrd4na/yhSeB5BNSW+J6K/oa18T/y/R
         1UMetc9aRUXuK1Yvo1oQOuBccAMBhADWf8DE5+NubRCW70bD/L6pAMuyZLXV4UlFHBV9
         D3rRWHmphDW+cF6hhvMzHpSJlsPOiIWProxoRBp4cWcbtPoThrT2MJLlzf9d8X7+LN0E
         8+S+ObGgD+EAOLmqPsqzzlNd9aW+zkuaLynHgKrOX/CdFj2NuGWpAhm2Ig+0R1D74qdv
         sYqceNBjE/cid5+HEpE30mgxcJWoIrLeUJeMz4Cx4TGQTelQYWN591fUfdAxwhLsvVXA
         Lxmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687166868; x=1689758868;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wu8/ZiEpyGAPwhhj0SnCYP8UmFOJYM33vPmFMYzLHsA=;
        b=VlA13QKpTGUdiA8jjHJZOcOaVuTuGulH6sbV/v8WlMFXNcaVaaoeTUpfNL6jdVfR9O
         nlMVMt3QHjoYKrUe5u9DUWODTkab9yveR7JNSbiXEm2Lobd1OiMvN0toM2F34AX9IK3V
         smEkUqA2UttpfKLkcJlYpP/7sUr/INfx3/DQB5f0ACNhdRMRD85c5MIZZVLcMSqVk5T/
         IH/MOLXZY1HStXhRBkP2nZwIEzidrTRVDVeaHTvPy6WRZ5B/qRgNq/tg2p/bZxsOIFYf
         OqZs+jq/444U2NssqVxJAh7WuGmTsSc2Yj0qcTHYF40PYl8Wl8mWtYEE0JnXFhrAOqIU
         bfTA==
X-Gm-Message-State: AC+VfDzTYtRvyxucLfj+Ze8Am3cZ0yObZIXTKXmk8w0mej6b90KThouy
	Lz/0BKuh/3mptFWlTUFVa5o=
X-Google-Smtp-Source: ACHHUZ6wpPvgxvEjUa5T1md/7VHLgYQJwOG6hxsW3DeFJifteVjLMAlep65GQhYd0LIvqLoH1jZbcQ==
X-Received: by 2002:a7b:c7ca:0:b0:3f9:b2db:88eb with SMTP id z10-20020a7bc7ca000000b003f9b2db88ebmr615731wmk.28.1687166867598;
        Mon, 19 Jun 2023 02:27:47 -0700 (PDT)
Received: from [192.168.43.77] (82-132-229-146.dab.02.net. [82.132.229.146])
        by smtp.gmail.com with ESMTPSA id n2-20020a05600c294200b003f8f8fc3c32sm9273990wmd.31.2023.06.19.02.27.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 02:27:47 -0700 (PDT)
Message-ID: <e972fc86-b884-3600-4e16-c9dbb53c6464@gmail.com>
Date: Mon, 19 Jun 2023 10:27:38 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] net/tcp: optimise locking for blocking
 splice
From: Pavel Begunkov <asml.silence@gmail.com>
To: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 edumazet@google.com, davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org
References: <cover.1684501922.git.asml.silence@gmail.com>
 <a6838ca891ccff2c2407d9232ccd2a46fa3f8989.1684501922.git.asml.silence@gmail.com>
 <c025952ddc527f0b60b2c476bb30bd45e9863d41.camel@redhat.com>
 <5b93b626-df9a-6f8f-edc3-32a4478b8f00@gmail.com>
Content-Language: en-US
In-Reply-To: <5b93b626-df9a-6f8f-edc3-32a4478b8f00@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/24/23 13:51, Pavel Begunkov wrote:
> On 5/23/23 14:52, Paolo Abeni wrote:
>> On Fri, 2023-05-19 at 14:33 +0100, Pavel Begunkov wrote:
>>> Even when tcp_splice_read() reads all it was asked for, for blocking
>>> sockets it'll release and immediately regrab the socket lock, loop
>>> around and break on the while check.
>>>
>>> Check tss.len right after we adjust it, and return if we're done.
>>> That saves us one release_sock(); lock_sock(); pair per successful
>>> blocking splice read.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   net/ipv4/tcp.c | 8 +++++---
>>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>> index 4d6392c16b7a..bf7627f37e69 100644
>>> --- a/net/ipv4/tcp.c
>>> +++ b/net/ipv4/tcp.c
>>> @@ -789,13 +789,15 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
>>>        */
>>>       if (unlikely(*ppos))
>>>           return -ESPIPE;
>>> +    if (unlikely(!tss.len))
>>> +        return 0;
>>>       ret = spliced = 0;
>>>       lock_sock(sk);
>>>       timeo = sock_rcvtimeo(sk, sock->file->f_flags & O_NONBLOCK);
>>> -    while (tss.len) {
>>> +    while (true) {
>>>           ret = __tcp_splice_read(sk, &tss);
>>>           if (ret < 0)
>>>               break;
>>> @@ -835,10 +837,10 @@ ssize_t tcp_splice_read(struct socket *sock, loff_t *ppos,
>>>               }
>>>               continue;
>>>           }
>>> -        tss.len -= ret;
>>>           spliced += ret;
>>> +        tss.len -= ret;
>>
>> The patch LGTM. The only minor thing that I note is that the above
>> chunk is not needed. Perhaps avoiding unneeded delta could be worthy.
> 
> It keeps it closer to the tss.len test, so I'd leave it for that reason,
> but on the other hand the compiler should be perfectly able to optimise it
> regardless (i.e. sub;cmp;jcc; vs sub;jcc;). I don't have a hard feeling
> on that, can change if you want.

Is there anything I can do to help here? I think the patch is
fine, but can amend the change per Paolo's suggestion if required.

-- 
Pavel Begunkov

