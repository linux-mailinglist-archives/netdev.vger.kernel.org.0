Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB46467B2A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:19:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239880AbhLCQXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:23:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhLCQXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 11:23:03 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C19CC061751;
        Fri,  3 Dec 2021 08:19:39 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id s13so6836063wrb.3;
        Fri, 03 Dec 2021 08:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dovUWMhc8iLSxV4DTywS+Z9IqkQs7jpjMMPxMzM/ne4=;
        b=qmIxIrsszvkl51bEYKltkR+wUFL+rzEr1U4GWzFf9HEcU87iWTfLUQSDGrNjKGt3+t
         tsXm5RLe/o4OA+mKrT9T6PEV7eDMgBlXSihvzVTyhF20ZsKO5C1If8fHX+aMxRWd9gOd
         RCZLkNNfXFRC3wDPsv+ASNo2988QxxIkrefEoWOUczsxQ7a2AQIV6ne0fpwKwJ6obQtJ
         VGy0Z2Fqyw8yDG/M3Cjl7QZdG2we2c/Xl/DSFE0pBi6VicFTjFXoJ0c2YIEdtPwzB/d+
         f1aEzxogGICCPIawxYD1h1eI0mj+BBgwbRjDSwu1/JuRXGXLxxiwPZyrT/dhSxD+XZvf
         RLlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dovUWMhc8iLSxV4DTywS+Z9IqkQs7jpjMMPxMzM/ne4=;
        b=d0vV8NUnyIMFYe0uRt43MRuc51hcvlAaeqcgDiuzmPG8GB8UTgIPHr30oQgSaRJo9d
         4uBwq76zgmKcvm4UmmL8XhptWssAqHsQNVZFz+AKgPWkfPtm7lQKv+rjJJ4UnQw4Cozi
         X901Ze2pv2Sv3dkb5eFQZMHlfqracf5h1vP13AeR4/M5Cys/kvow1HmebNPzy+xPVJQY
         VBCA4I7agw6BjCAAceCydQtkn6f6ZeqoRTqXCO/2yWThriTmoLuJpM1uMiGaliSxmoM9
         xhJD8uw6Ww9gDzK/n9VzS0XTBt4zFisw3AV+F5Y5XecrN0e99uLz6AlLoJQCR78/Kh/4
         Oq+Q==
X-Gm-Message-State: AOAM530FvxHl82ldJNatxg13hDXVfdZiz2Rl3uLX8FkeT8QABOiEACfb
        jbpB0Ro0OGLIm+vXsQXsPWV/ryFsgT0=
X-Google-Smtp-Source: ABdhPJx/hiHUyLq+zhoi3n/Luw4f2qjNt7CfWMGTxEkh/nqWvG4M5n1so+Wl/iha5efn5MtifQbbeg==
X-Received: by 2002:adf:fb09:: with SMTP id c9mr22301710wrr.223.1638548378262;
        Fri, 03 Dec 2021 08:19:38 -0800 (PST)
Received: from [192.168.43.77] (82-132-231-141.dab.02.net. [82.132.231.141])
        by smtp.gmail.com with ESMTPSA id q8sm2946833wrx.71.2021.12.03.08.19.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 08:19:37 -0800 (PST)
Message-ID: <e79a9cf6-b315-d4a5-a4a8-1071b5046c6e@gmail.com>
Date:   Fri, 3 Dec 2021 16:19:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
 <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com>
 <CA+FuTSf1dk-ZCN_=oFcYo31XdkLLAaHJHHNfHwJKe01CVq3X+A@mail.gmail.com>
 <6e07fb0c-075b-4072-273b-f9d55ba1e1dd@gmail.com>
 <CA+FuTSfe63=SuuZeC=eZPLWstgOL6oFUrsL4o+J8=3BwHJSTVg@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CA+FuTSfe63=SuuZeC=eZPLWstgOL6oFUrsL4o+J8=3BwHJSTVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/21 21:25, Willem de Bruijn wrote:
>>> What if the ubuf pool can be found from the sk, and the index in that
>>> pool is passed as a cmsg?
>>
>> It looks to me that ubufs are by nature is something that is not
>> tightly bound to a socket (at least for io_uring API in the patchset),
>> it'll be pretty ugly:
>>
>> 1) io_uring'd need to care to register the pool in the socket. Having
>> multiple rings using the same socket would be horrible. It may be that
>> it doesn't make much sense to send in parallel from multiple rings, but
>> a per thread io_uring is a popular solution, and then someone would
>> want to pass a socket from one thread to another and we'd need to support
>> it.
>>
>> 2) And io_uring would also need to unregister it, so the pool would
>> store a list of sockets where it's used, and so referencing sockets
>> and then we need to bind it somehow to io_uring fixed files or
>> register all that for tracking referencing circular dependencies.
>>
>> 3) IIRC, we can't add a cmsg entry from the kernel, right? May be wrong,
>> but if so I don't like exposing basically io_uring's referencing through
>> cmsg. And it sounds io_uring would need to parse cmsg then.
>>
>>
>> A lot of nuances :) I'd really prefer to pass it on per-request basis,
> 
> Ok
> 
>> it's much cleaner, but still haven't got what's up with msghdr
>> initialisation...
> 
> And passing the struct through multiple layers of functions.

If you refer to ip_make_skb(ubuf) -> __ip_append_data(ubuf), I agree
it's a bit messier, will see what can be done. If you're about
msghdr::msg_ubuf, for me it's more like passing a callback,
which sounds like a normal thing to do.


>> Maybe, it's better to add a flags field, which would include
>> "msg_control_is_user : 1" and whether msghdr includes msg_iocb, msg_ubuf,
>> and everything else that may be optional. Does it sound sane?
> 
> If sendmsg takes the argument, it will just have to be initialized, I think.
> 
> Other functions are not aware of its existence so it can remain
> uninitialized there.

Got it, need to double check, but looks something like 1/12 should
be as you outlined.

And if there will be multiple optional fields that have to be
initialised, we would be able to hide all the zeroing under a
single bitmask. E.g. instead of

msg->field1 = NULL;
...
msg->fieldN = NULL;

It may look like

msg->mask = 0; // HAS_FIELD1 | HAS_FIELDN;

-- 
Pavel Begunkov
