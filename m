Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A91442B48
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 11:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbhKBKFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 06:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhKBKFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 06:05:51 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC4AC061714;
        Tue,  2 Nov 2021 03:03:16 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g10so73679425edj.1;
        Tue, 02 Nov 2021 03:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6stZNR+N9UoFJ7wUFFhv365ZVdV0HcQUPxcYE0rMeh8=;
        b=dyCgkR/dlEMAM7uT9GuFEMR1amHp50THUKfdZjMtOrgLXXysnU16E9AcvvvlE4W67G
         fG4ys65dW4beqjYJT/0XFs1bs8KTaLaY2VzDVVseSGjVfK2QEp2m+3CMUQpu7lXzVD5i
         dhGFCc+z8HjQtCKoJj3LSU/29bQJsAdh7MuZzFa82g4MbWdlmJh0BcseB0yP/avGIcME
         xn75mL98NudZqZDKi5xYUY0P3DYrV8PYFKltsDG2UAKdAf4DHHa4wiQah2kdjhDeguDO
         bvqmpj7roh4xysfrzNu3yyVd0LI9RNOG2/yNB0jxSKQWHRxLAOk6SoDoP/IxGwO74LRi
         YfJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6stZNR+N9UoFJ7wUFFhv365ZVdV0HcQUPxcYE0rMeh8=;
        b=bqgcg3DliM02y1dju6vZjFMrEio5Bsf2iGJv2w6zxpmMWBuJoFklRAdzjAzgy2tFjC
         7bcA8tgSBTdoa1K0IkhGo91Luon/Yo4cvbRoL/rSRfx4NpE+PISfBnevPUw9laouiu+T
         iNI50oZEe6yWYxhabhvxE5lTD7MUJu1q5IlKo/hmVErCfVsTFV1FgGQtnPpQI7tylZw8
         aTVWY4RAtyeZIWehwHU+zqk590Mx3o+vi1D4lHLqXm1ILMYIT7coLSXSws/XkewGBgDd
         OWPfOhZ7IvNqadzRQgrqRQxPMr0NK9ZkbHrGFuitKvj01jyjSlmJkYJAsjXT/cAll956
         3tHQ==
X-Gm-Message-State: AOAM5333N7fbU7F5jfp0O4Di9lYCuc1ydgPcX1CuPSeLahoDn/2jvymW
        ntB2GD9ov2F5EIg+MLXc86mSeKmtjcEibQ4X
X-Google-Smtp-Source: ABdhPJwWSNrs/OWPcip1lXzSLr2dq0oxL7qdJ+WZ8BePveyBXGFsyxZBjF2ZXYNuzoVfxOqDCnGShQ==
X-Received: by 2002:a17:906:c186:: with SMTP id g6mr43095120ejz.259.1635847394748;
        Tue, 02 Nov 2021 03:03:14 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:88ff:d1a0:a1c6:4b6a? ([2a04:241e:501:3870:88ff:d1a0:a1c6:4b6a])
        by smtp.gmail.com with ESMTPSA id d3sm7927902ejb.35.2021.11.02.03.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 03:03:14 -0700 (PDT)
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
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <876f0df1-894a-49bb-07dc-1b1137479f3f@gmail.com>
Date:   Tue, 2 Nov 2021 12:03:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CA+HUmGgMAU235hMtTgucVb1GX_Ru83bngHg8-Jvy2g6BA7djsg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 9:22 PM, Francesco Ruggeri wrote:
>> +/* Compute SNE for a specific packet (by seq). */
>> +static int compute_packet_sne(struct sock *sk, struct tcp_authopt_info *info,
>> +                             u32 seq, bool input, __be32 *sne)
>> +{
>> +       u32 rcv_nxt, snd_nxt;
>> +
>> +       // We can't use normal SNE computation before reaching TCP_ESTABLISHED
>> +       // For TCP_SYN_SENT the dst_isn field is initialized only after we
>> +       // validate the remote SYN/ACK
>> +       // For TCP_NEW_SYN_RECV there is no tcp_authopt_info at all
>> +       if (sk->sk_state == TCP_SYN_SENT ||
>> +           sk->sk_state == TCP_NEW_SYN_RECV ||
>> +           sk->sk_state == TCP_LISTEN)
>> +               return 0;
>> +
> 
> In case of TCP_NEW_SYN_RECV, if our SYNACK had sequence number
> 0xffffffff, we will receive an ACK sequence number of 0, which
> should have sne = 1.
> 
> In a somewhat similar corner case, when we receive a SYNACK to
> our SYN in tcp_rcv_synsent_state_process, if the SYNACK has
> sequence number 0xffffffff, we set tp->rcv_nxt to 0, and we
> should set sne to 1.
> 
> There may be more similar corner cases related to a wraparound
> during the handshake.
> 
> Since as you pointed out all we need is "recent" valid <sne, seq>
> pairs as reference, rather than relying on rcv_sne being paired
> with tp->rcv_nxt (and similarly for snd_sne and tp->snd_nxt),
> would it be easier to maintain reference <sne, seq> pairs for send
> and receive in tcp_authopt_info, appropriately handle the different
> handshake cases and initialize the pairs, and only then track them
> in tcp_rcv_nxt_update and tcp_rcv_snd_update?

For TCP_NEW_SYN_RECV there is no struct tcp_authopt_info, only a request 
minisock. I think those are deliberately kept small save resources on 
SYN floods so I'd rather not increase their size.

For all the handshake cases we can just rely on SNE=0 for ISN and we 
already need to keep track of ISNs because they're part of the signature.

I'll need to test handshake seq 0xFFFFFFFF deliberately, you're right 
that it can fail.

>>   static void tcp_rcv_nxt_update(struct tcp_sock *tp, u32 seq)
>>   {
>>          u32 delta = seq - tp->rcv_nxt;
>>
>>          sock_owned_by_me((struct sock *)tp);
>> +       tcp_authopt_update_rcv_sne(tp, seq);
>>          tp->bytes_received += delta;
>>          WRITE_ONCE(tp->rcv_nxt, seq);
>>   }
>>
> 
> Since rcv_sne and tp->rcv_nxt are not updated atomically, could
> there ever be a case where a reader might use the new sne with
> the old rcv_nxt?

As far as I understand if all of the read and writes to SNE happen under 
the socket lock it should be fine. I don't know why WRITE_ONCE is used 
here, maybe somebody else wants to read rcv_nxt outside the socket lock? 
That doesn't matter for SNE.

I think the only case would be sending ipv4 RSTs outside the socket.

--
Regards,
Leonard
