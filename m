Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC1CB48C1C9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 10:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbiALJ7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 04:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352317AbiALJ7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 04:59:40 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0804C06173F;
        Wed, 12 Jan 2022 01:59:39 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id k30so3147224wrd.9;
        Wed, 12 Jan 2022 01:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Ut4XOU7A/03qnRMeHsMB3uFSgPcs5evwpF8EjvHosi8=;
        b=dNp8JYbEWnmIYGrO7X9jxS6njJPxOC+R7VskhDd5eqwmBjlPkv8cBfNTwgYuKv4Nkq
         ROJMfg4PM7nHbwgqcUECmLcA3lNUfw6+45gFWXBqG3n52LG36ORu915Fs4gvjcSKEMNR
         WLIT61EOD4QuRGCaPqGQn1FFIQh6CUfS/SSADKLVEAb9DTq+XAxbWk5FuXHF2vQzHIU7
         Gcyr9WlDHd/3kxLTUpyOSspcP/F66IEGHRbUqYgEDz7NubRpUOdM1p8Rlk7lpKuaupTI
         DCPY81WwW/bYQZ1uGkstByYZjuBHmXBj9matdgWCRzvQMgyLCHmokC9utxygTIBcVusC
         EAtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Ut4XOU7A/03qnRMeHsMB3uFSgPcs5evwpF8EjvHosi8=;
        b=WVf8H9P/w/hfuLS38M+RNx1LLwOBIoKXbssbDvkIEW/Di9JOwPhhFpFiGngeUB+2cx
         LnRBkACGi1qEx+ABbpKCTCdQTI0RDMTQPlnOU2vJMA1I2DqU85f4O7t35ciH7qllj7kP
         HmGGNP7+ANO0J+6k2G0nMq0ZDA/Uiry8nIxbtGIH+EuPJcSZJyOwV1FQWdLEfCaOaouU
         YRmNkBQhk0Uwk4tz1I36Y2RV8qRKIPNlrmpmz08P5ylx4WLLptCgiPno3CQJlSvb+Wdr
         RmtqkMaVGIVq/k6fur8naoJFS/fHEDZR9/ixQvpg+fRKsNk3e7oeeB9hM+ypP30DKRJ+
         cBYA==
X-Gm-Message-State: AOAM530d3PsffkWACAxUhKgiby2gs+l2RPFZFLV3pbzZ5Yh8boBdXYb+
        naVD2EJwwiau8tUdDOZhxow=
X-Google-Smtp-Source: ABdhPJykJDPMEXOibXX6KVqykVjgMXjjzUz08whjSlSO0lZzpMIdPiQvLX5gB1bV7mEX3e5EPvfuqg==
X-Received: by 2002:a05:6000:1548:: with SMTP id 8mr6980634wry.489.1641981578289;
        Wed, 12 Jan 2022 01:59:38 -0800 (PST)
Received: from [10.0.0.5] ([37.165.119.129])
        by smtp.gmail.com with ESMTPSA id c3sm3851637wrd.54.2022.01.12.01.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 01:59:37 -0800 (PST)
Message-ID: <571c72e8-2111-6aa0-1bd7-e0af7fc50539@gmail.com>
Date:   Wed, 12 Jan 2022 01:59:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net] ax25: use after free in ax25_connect
Content-Language: en-US
To:     Hangyu Hua <hbh25y@gmail.com>, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220111042048.43532-1-hbh25y@gmail.com>
 <f35292c0-621f-3f07-87ed-2533bfd1496e@gmail.com>
 <f48850cb-8e26-afa0-576c-691bb4be5587@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <f48850cb-8e26-afa0-576c-691bb4be5587@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/11/22 18:13, Hangyu Hua wrote:
> I try to use ax25_release to trigger this bug like this:
> ax25_release                 ax25_connect
> lock_sock(sk);
> -----------------------------sk = sock->sk;
> -----------------------------ax25 = sk_to_ax25(sk);
> ax25_destroy_socket(ax25);
> release_sock(sk);
> -----------------------------lock_sock(sk);
> -----------------------------use ax25 again
>
> But i failed beacause their have large speed difference. And i
> don't have a physical device to test other function in ax25.
> Anyway, i still think there will have a function to trigger this
> race condition like ax25_destroy_timer. Beacause Any ohter
> functions in ax25_proto_ops like ax25_bind protect ax25_sock by 
> lock_sock(sk).


For a given sk pointer, sk_to_ax25(sk) is always returning the same value,

regardless of sk lock being held or not.

ax25_sk(sk)->cb  is set only from ax25_create() or ax25_make_new()

ax25_connect can not be called until these operations have completed ?



>
> Thanks.
>
>
>
>
> On 2022/1/12 上午4:56, Eric Dumazet wrote:
>>
>> On 1/10/22 20:20, Hangyu Hua wrote:
>>> sk_to_ax25(sk) needs to be called after lock_sock(sk) to avoid UAF
>>> caused by a race condition.
>>
>> Can you describe what race condition you have found exactly ?
>>
>> sk pointer can not change.
>>
>>
>>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>>> ---
>>>   net/ax25/af_ax25.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
>>> index cfca99e295b8..c5d62420a2a8 100644
>>> --- a/net/ax25/af_ax25.c
>>> +++ b/net/ax25/af_ax25.c
>>> @@ -1127,7 +1127,7 @@ static int __must_check ax25_connect(struct 
>>> socket *sock,
>>>       struct sockaddr *uaddr, int addr_len, int flags)
>>>   {
>>>       struct sock *sk = sock->sk;
>>> -    ax25_cb *ax25 = sk_to_ax25(sk), *ax25t;
>>> +    ax25_cb *ax25, *ax25t;
>>>       struct full_sockaddr_ax25 *fsa = (struct full_sockaddr_ax25 
>>> *)uaddr;
>>>       ax25_digi *digi = NULL;
>>>       int ct = 0, err = 0;
>>> @@ -1155,6 +1155,8 @@ static int __must_check ax25_connect(struct 
>>> socket *sock,
>>>       lock_sock(sk);
>>> +    ax25 = sk_to_ax25(sk);
>>> +
>>>       /* deal with restarts */
>>>       if (sock->state == SS_CONNECTING) {
>>>           switch (sk->sk_state) {
