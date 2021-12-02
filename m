Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7B9466720
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358916AbhLBPv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:51:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242293AbhLBPvx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 10:51:53 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD485C06174A;
        Thu,  2 Dec 2021 07:48:30 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l16so60532769wrp.11;
        Thu, 02 Dec 2021 07:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tGC3LpdEhf/azzucNhguXDxEcjakxGW5c1+cbDZrOzA=;
        b=Cuw4refrkxRuzxjplWfBvXRstEa1sCgXRTrB9M6vZZZutwu5bGygklfwcZMz9fqdh6
         brookoLg8n2YWE1FVC6QCBq7CNF2Ppwz9l/fbMpa2dz8XfJAgAUSbX+EuQ7epfRWIoQt
         1FF8AxIwKVVMloGmPgKtv9p6eZp2BHl1sDLB8oKQFcLZHF3SWZVsuxjO90HnRxmyPhti
         rAXK4AcQPan+6z066haa9Fbs2NutpEb+owuLl47tz8ZgzenuD65o/Kg7Wp1NcDTbwTs/
         TGkAQDEEkuHEEpmH7y7xeTZkn8aEK+FeEgXbxflO5hmFeLeVR8Jmo7/slBpUPGePdS5Q
         7dYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tGC3LpdEhf/azzucNhguXDxEcjakxGW5c1+cbDZrOzA=;
        b=VXH3hUnwUBdCWhwjtz2jgHTt1nOzWw918XSbkr1wbz6ysXagX6uG4FUL42wKEy2PwT
         zfgcVwHEYAwGCm13tvIeT5mX0lreqeKz82OP4byyz7OqWBTKAITkBPBHbqxsLsYZKhwC
         3PGHhYt2c3n9UTGtrE+9F8Ln8WT5Kz5afJw8yhDqyqO96wyP4Vm2NDv4bZtNSA8JoDJo
         blaY0OS3rFuNRzg9vgjQEXLdrQRu30/z5bwVAjbp6C+vb4sqDTQ4yteIxgz3Uj3LCACl
         UCDvajcFJok6ubM+5tnbv1DG9sfAFnCyzCtwZWlzhYA+f+0ws/kj70gbLF2yIx0dfSc4
         9gDA==
X-Gm-Message-State: AOAM531G1buqMcsVmbwE0RRgt8JWXStOMvehCi2eGikH9y7S4D+HdAK4
        fjuHB8T1N+AUq4BctIah59s=
X-Google-Smtp-Source: ABdhPJwNz5AmAptN2Wtm7R8RgB0gpQZvAJdTETPL6m07GjnXiWJS7juoQ03JqVsWEd/3n9Gm9uhRog==
X-Received: by 2002:a5d:588b:: with SMTP id n11mr15125945wrf.344.1638460109405;
        Thu, 02 Dec 2021 07:48:29 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.137])
        by smtp.gmail.com with ESMTPSA id d2sm41111wmb.31.2021.12.02.07.48.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 07:48:28 -0800 (PST)
Message-ID: <ffd25188-aa92-2d69-a749-3058d1d33bc1@gmail.com>
Date:   Thu, 2 Dec 2021 15:48:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     David Ahern <dsahern@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
 <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
 <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
 <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
 <974b266e-d224-97da-708f-c4a7e7050190@gmail.com>
 <20211201215157.kgqd5attj3dytfgs@kafai-mbp.dhcp.thefacebook.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211201215157.kgqd5attj3dytfgs@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 21:51, Martin KaFai Lau wrote:
> On Wed, Dec 01, 2021 at 08:15:28PM +0000, Pavel Begunkov wrote:
>> On 12/1/21 19:20, David Ahern wrote:
>>> On 12/1/21 12:11 PM, Pavel Begunkov wrote:
>>>> btw, why a dummy device would ever go through loopback? It doesn't
>>>> seem to make sense, though may be missing something.
>>>
>>> You are sending to a local ip address, so the fib_lookup returns
>>> RTN_LOCAL. The code makes dev_out the loopback:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/route.c#n2773
>>
>> I see, thanks. I still don't use the skb_orphan_frags_rx() hack
>> and it doesn't go through the loopback (for my dummy tests), just
>> dummy_xmit() and no mention of loopback in perf data, see the
>> flamegraph. Don't know what is the catch.
>>
>> I'm illiterate of the routing paths. Can it be related to
>> the "ip route add"? How do you get an ipv4 address for the device?
> I also bumped into the udp-connect() => ECONNREFUSED (111) error from send-zc.
> because I assumed no server is needed by using dummy.  Then realized
> the cover letter mentioned msg_zerocopy is used as the server.
> Mentioning just in case someone hits it also.
> 
> To tx out dummy, I did:
> #> ip a add 10.0.0.1/24 dev dummy0

Works well for me, IOW getting the same behaviour as with my
ip route add <ip> dev dummy0

I'm curious what is the difference bw them?


> #> ip -4 r
> 10.0.0.0/24 dev dummy0 proto kernel scope link src 10.0.0.1
> 
> #> ./send-zc -4 -D 10.0.0.(2) -t 10 udp
> ip -s link show dev dummy0
> 2: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 65535 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
>     link/ether 82:0f:e0:dc:f7:e6 brd ff:ff:ff:ff:ff:ff
>     RX:    bytes packets errors dropped  missed   mcast
>                0       0      0       0       0       0
>     TX:    bytes packets errors dropped carrier collsns
>     140800890299 2150397      0       0       0       0
> 

-- 
Pavel Begunkov
