Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2411D444A90
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 23:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhKCWDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 18:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhKCWDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 18:03:46 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9234AC061714;
        Wed,  3 Nov 2021 15:01:09 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 5so13905430edw.7;
        Wed, 03 Nov 2021 15:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VLzRMQA56q0Jzh6O5E6OPxwCqlW4DyCFuZA/f518bL4=;
        b=YiY+jdAvUIfCnkUyXWuD+yMJZephc7xtaTRHzHBXvuUFE8LBXjdu2peh3Mu6dJMgNe
         cEz0Ryz2oW9Bz4F9BIzq/TWmM3slTsQ4o2sGxjuVu+Zaz8x3ZF6qUGmzMyz2ZDlyTx6v
         sdK9LcKdznTLDn420OY1pehVcZDbqQQC7fNonurjXdrJv486kY+SiVpRhB3nwSfqLIOs
         zwoYuCPBwAxHzPm0KPVDIXJM0ZBFvFBO54lNDrq4hlCakg7aIzQndSbgTIEVn5qG2G99
         l3gKDQVaL0Dc7so22FSVmVF1YjWq2OZvJJwO8334xo0UvCSzI3ICTobQMv+Q2XqceFrS
         cPFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VLzRMQA56q0Jzh6O5E6OPxwCqlW4DyCFuZA/f518bL4=;
        b=Zl2/WhQcYJF9Od8mwnKBsbpDO9EBr2SWmvsrzCzDa1vFyc3AI7gro6HEWT7bZIwbNM
         oBF1Pi2g62feV7GSlSu9BJd/P43hKFC6lWV0wq2YuTDus80jSjo9hZkuCNDJ21InsLXI
         kBoz29PNkvukArAxpisWUXTQGg6elwF6N/rZ4cUSpJeTByZN2iXK4Jxo7m7Q9wZ8M3PM
         4lRP61cj6+dWbIsxONhEFsqs3XnV23DZjbB76NNQZ4yNIPy907d/xmFfk8Aoe995esVn
         AFvgf0LzHTBOEd3IsnNXjrY2DNdYPF5odTGiaSsbZ7NXccKpKHeyImxsKbWWFVgX8j15
         5h0Q==
X-Gm-Message-State: AOAM531/0JoK7yQ9zPJhkthp0j0Ll/VzQdpYRTXAd7erSWQCWD5jxvGc
        4zoxw/65vIhdNgF3/R5y42wQmQ57lyx9jw==
X-Google-Smtp-Source: ABdhPJyc6kf1KHp9Muk/W/y8xe/zgDGvg6jgEZouXe0R3Fsxky09NDmdoL2EehD4GuWUgP3nplKSBA==
X-Received: by 2002:a17:906:181a:: with SMTP id v26mr58122345eje.478.1635976868084;
        Wed, 03 Nov 2021 15:01:08 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3800:dd98:1fb5:16b3:cb28? ([2a04:241e:501:3800:dd98:1fb5:16b3:cb28])
        by smtp.gmail.com with ESMTPSA id f22sm1926665edu.26.2021.11.03.15.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Nov 2021 15:01:07 -0700 (PDT)
Subject: Re: [PATCH v2 11/25] tcp: authopt: Implement Sequence Number
 Extension
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
 <6097ec24d87efc55962a1bfac9441132f0fc4206.1635784253.git.cdleonard@gmail.com>
 <CA+HUmGgMAU235hMtTgucVb1GX_Ru83bngHg8-Jvy2g6BA7djsg@mail.gmail.com>
 <876f0df1-894a-49bb-07dc-1b1137479f3f@gmail.com>
 <CA+HUmGguspEHZpH-WB4Qi9+xVpz3x3z3KqQVoQmhEJsn-w2q1w@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <cdcfb418-af7c-a701-9c68-b3f9b701390e@gmail.com>
Date:   Thu, 4 Nov 2021 00:01:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CA+HUmGguspEHZpH-WB4Qi9+xVpz3x3z3KqQVoQmhEJsn-w2q1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/21 9:21 PM, Francesco Ruggeri wrote:
> On Tue, Nov 2, 2021 at 3:03 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> On 11/1/21 9:22 PM, Francesco Ruggeri wrote:
>>>> +/* Compute SNE for a specific packet (by seq). */
>>>> +static int compute_packet_sne(struct sock *sk, struct tcp_authopt_info *info,
>>>> +                             u32 seq, bool input, __be32 *sne)
>>>> +{
>>>> +       u32 rcv_nxt, snd_nxt;
>>>> +
>>>> +       // We can't use normal SNE computation before reaching TCP_ESTABLISHED
>>>> +       // For TCP_SYN_SENT the dst_isn field is initialized only after we
>>>> +       // validate the remote SYN/ACK
>>>> +       // For TCP_NEW_SYN_RECV there is no tcp_authopt_info at all
>>>> +       if (sk->sk_state == TCP_SYN_SENT ||
>>>> +           sk->sk_state == TCP_NEW_SYN_RECV ||
>>>> +           sk->sk_state == TCP_LISTEN)
>>>> +               return 0;
>>>> +
>>>
>>> In case of TCP_NEW_SYN_RECV, if our SYNACK had sequence number
>>> 0xffffffff, we will receive an ACK sequence number of 0, which
>>> should have sne = 1.
>>>
>>> In a somewhat similar corner case, when we receive a SYNACK to
>>> our SYN in tcp_rcv_synsent_state_process, if the SYNACK has
>>> sequence number 0xffffffff, we set tp->rcv_nxt to 0, and we
>>> should set sne to 1.
>>>
>>> There may be more similar corner cases related to a wraparound
>>> during the handshake.
>>>
>>> Since as you pointed out all we need is "recent" valid <sne, seq>
>>> pairs as reference, rather than relying on rcv_sne being paired
>>> with tp->rcv_nxt (and similarly for snd_sne and tp->snd_nxt),
>>> would it be easier to maintain reference <sne, seq> pairs for send
>>> and receive in tcp_authopt_info, appropriately handle the different
>>> handshake cases and initialize the pairs, and only then track them
>>> in tcp_rcv_nxt_update and tcp_rcv_snd_update?
>>
>> For TCP_NEW_SYN_RECV there is no struct tcp_authopt_info, only a request
>> minisock. I think those are deliberately kept small save resources on
>> SYN floods so I'd rather not increase their size.
>>
>> For all the handshake cases we can just rely on SNE=0 for ISN and we
>> already need to keep track of ISNs because they're part of the signature.
>>
> 
> Exactly. But the current code, when setting rcv_sne and snd_sne,
> always compares the sequence number with the <info->rcv_sne, tp->rcv_nxt>
> (or <info->snd_sne, tp->snd_nxt>) pair, where info->rcv_sne and
> info->snd_sne are initialized to 0 at the time of info creation.
> In other words, the code assumes that rcv_sne always corresponds to
> tp->rcv_nxt, and snd_sne to tp->snd_nxt. But that may not be true
> when info is created, on account of rollovers during a handshake.
> So it is not just a matter of what to use for SNE before info is
> created and used, but also how SNEs are initialized in info.
> That is why I was suggesting of saving valid <sne, seq> pairs
> (initialized with <0, ISN>) in tcp_authopt_info rather than just SNEs,
> and then always compare seq to those pairs if info is available.
> The pairs could then be updated in tcp_rcv_nxt_update and
> tcp_snd_una_update.

You are correct that SNE will be initialized incorrectly if a rollover 
happens during the handshake. I think this can be solved by initializing 
SNE at the same time as ISN like this:

rcv_sne = compute_sne(0, disn, rcv_nxt);
snd_sne = compute_sne(0, sisn, snd_nxt);

This relies on initial sequence numbers having an extension of zero by 
definition. The actual implementation is a bit more complicated but it 
only needs to be done when transitioning into ESTABLISHED. I think this 
would even work for FASTOPEN where non-zero payload is present in 
handshake packets.

The SYN_SEND and SYN_RECV sockets are still special but they're also 
special because they have to determine ISNs from the packet itself. 
Since those sockets only compute signatures for packets with SYN bit ON 
and where SEQ=ISN then SNE is again zero by definition.

I will write tests with client and server-side SEQs equal to 0xFFFFFFFF 
to verify because this relies on actual initialization order details.

I think snd_nxt and rcv_nxt are good choices for SNE tracking because 
the rest of the TCP state machine controls their advancement. In theory 
it's possible to use any received SEQ value but then a very old or 
perhaps malicious packet could cause incorrect updates to SNE.

If separate fields were used to track rcv_sne_seq and snd_sne_seq then 
you would still need to only advance them for SEQ values which are known 
to be valid. Doing so in lockstep with snd_nxt and rcv_nxt would still 
make sense.

--
Regards,
Leonard
