Return-Path: <netdev+bounces-2994-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B29FF704E85
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:01:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B10741C20E5A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAF92261FE;
	Tue, 16 May 2023 13:01:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5B934CD9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:01:39 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A504B59DB;
	Tue, 16 May 2023 06:01:36 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3093a6311dcso255684f8f.1;
        Tue, 16 May 2023 06:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684242095; x=1686834095;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4jkk9Ab256FKvAvzem14Z/0IMSkDuOPSlqpomQirp8Y=;
        b=PIPnW4K915+KUQ+GLXLMVFR13n+tTnehDgyNrIpWd3A9o4Of2gB0oSaV6mvk2EBXMp
         gbjeujC1t2ygNSiwBzczwOi02JdK7eWWmQLk/sCnQ147zA2QVynfTRvntT/LlJ+oLR3q
         Sf4OdeNK07w+cHfPimVH6/3gffrUWSiDD1Z2i/SN7y/TlwHcMuXNi4pbt7ShEW42x+RQ
         U5v4e/9Unm0zo7TObixjhxwyxnsiAZ5cSNqR9VBSowHTncyNQNyqUboosLQYVLquV4MA
         vYVTbYCz1kjuHsFzQWpmlv6/hiM9psi9RkdO9lhlVwvZCtyB/YXQ6uM9kc+jLjW0ePHO
         yFpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684242095; x=1686834095;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4jkk9Ab256FKvAvzem14Z/0IMSkDuOPSlqpomQirp8Y=;
        b=SyTlEyQJlrfKeK24y/KzsA7LN6m98bux05y7yQa2mleSax7RS6QfzvRHw49TLB2Clb
         YTbpiiqqB8O9MQO/xlpL7PS6BkEXH39ZMkiRB46V67H29I2GnsL9IFNXDRqKFHD0u/eM
         DGc5RhW3O9G/3CJBzGhW+YHx+BHUs503DLAHSXFPftrfJTBOyEpeGHdhqMcDkFBIUpC5
         WoWdqbOCDSa/v51pLZwpbZZFtttM6puJRR2SqmQTLQhiZzryyHwnGgoJZ5rviLZF4Rer
         A+TvO9DQ/YWh7OnJrWwpsPlEIv1jHzjy6oqbbg+JiN6roP/CCgKh4o2cORK2du9Twsrc
         BvIw==
X-Gm-Message-State: AC+VfDyr9YIrh9vhgu+S+KPPWabhaS4w7cJYtkyWq+JnVuaEGC9CVNRc
	fQfQ4qgF4B3DxCB74tiYmUxBnFZ+0S8=
X-Google-Smtp-Source: ACHHUZ4SLX8BumFp5hDSOThV+7EuX130cI9sE46zRY0lROopnYjpJH65lHDl30SFJCQ9vZa2/fYNnw==
X-Received: by 2002:a5d:698b:0:b0:309:268c:73de with SMTP id g11-20020a5d698b000000b00309268c73demr4087532wru.0.1684242094687;
        Tue, 16 May 2023 06:01:34 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.10])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d5341000000b002ff2c39d072sm2560504wrv.104.2023.05.16.06.01.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 06:01:34 -0700 (PDT)
Message-ID: <ee609e87-0515-c1f8-8b27-78572c81b1b4@gmail.com>
Date: Tue, 16 May 2023 13:59:11 +0100
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/2] net/tcp: optimise io_uring zc ubuf
 refcounting
Content-Language: en-US
To: David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com
References: <cover.1684166247.git.asml.silence@gmail.com>
 <bdbbff06f20c100c00e59932ffecbd18ad699f57.1684166247.git.asml.silence@gmail.com>
 <99faed2d-8ea6-fc85-7f21-e15b24d041f1@kernel.org>
 <CANn89i+Bb7g9uDPVmomNDJivK7CZBYD1UXryxq2VEU77sajqEg@mail.gmail.com>
 <d7edb614-3758-1df6-91b8-a0cb601137a4@kernel.org>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d7edb614-3758-1df6-91b8-a0cb601137a4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/15/23 19:40, David Ahern wrote:
> On 5/15/23 12:14 PM, Eric Dumazet wrote:
>> On Mon, May 15, 2023 at 7:29 PM David Ahern <dsahern@kernel.org> wrote:
>>>
>>> On 5/15/23 10:06 AM, Pavel Begunkov wrote:
>>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>>> index 40f591f7fce1..3d18e295bb2f 100644
>>>> --- a/net/ipv4/tcp.c
>>>> +++ b/net/ipv4/tcp.c
>>>> @@ -1231,7 +1231,6 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>>>        if ((flags & MSG_ZEROCOPY) && size) {
>>>>                if (msg->msg_ubuf) {
>>>>                        uarg = msg->msg_ubuf;
>>>> -                     net_zcopy_get(uarg);
>>>>                        zc = sk->sk_route_caps & NETIF_F_SG;
>>>>                } else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>>>>                        skb = tcp_write_queue_tail(sk);
>>>> @@ -1458,7 +1457,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>>>                tcp_push(sk, flags, mss_now, tp->nonagle, size_goal);
>>>>        }
>>>>   out_nopush:
>>>> -     net_zcopy_put(uarg);
>>>> +     /* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
>>>> +     if (uarg && !msg->msg_ubuf)
>>>> +             net_zcopy_put(uarg);
>>>>        return copied + copied_syn;
>>>>
>>>>   do_error:
>>>> @@ -1467,7 +1468,9 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>>>        if (copied + copied_syn)
>>>>                goto out;
>>>>   out_err:
>>>> -     net_zcopy_put_abort(uarg, true);
>>>> +     /* msg->msg_ubuf is pinned by the caller so we don't take extra refs */
>>>> +     if (uarg && !msg->msg_ubuf)
>>>> +             net_zcopy_put_abort(uarg, true);
>>>>        err = sk_stream_error(sk, flags, err);
>>>>        /* make sure we wake any epoll edge trigger waiter */
>>>>        if (unlikely(tcp_rtx_and_write_queues_empty(sk) && err == -EAGAIN)) {
>>>
>>> Both net_zcopy_put_abort and net_zcopy_put have an `if (uarg)` check.
>>
>> Right, but here this might avoid a read of msg->msg_ubuf, which might
>> be more expensive to fetch.
> 
> agreed.

I put it there to avoid one extra check in the non-zerocopy path.
msg->msg_ubuf is null there, the conditional will pass and it'll
still have to test uarg.


>> Compiler will probably remove the second test (uarg) from net_zcopy_put()
>>
>> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thank you for reviews!


> The one in net_zcopy_put can be removed with the above change. It's
> other caller is net_zcopy_put_abort which has already checked uarg is set.

Ah yes, do you want me to fold it in?

-- 
Pavel Begunkov

