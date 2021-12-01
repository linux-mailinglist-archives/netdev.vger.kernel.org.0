Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1690A4656CF
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 20:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbhLAUCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:02:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352739AbhLAUC3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:02:29 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B254EC061574;
        Wed,  1 Dec 2021 11:59:06 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id l16so54778053wrp.11;
        Wed, 01 Dec 2021 11:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eBzFPvXsnl0PWl/qQRoBt7zd2fQQiSK0790Spm1vPuU=;
        b=e5zgUC1MwKZrjDzWQKvKHRyhyexQQawLcDDPtwBX2GViAy7EmAjvAveyqzSA8L8uVM
         zQ+Ttwg3ycFaVRgmGUI/LIESOJhILNdB7vwyOGjuOSGoklbtV14alTmKDmHaJ6FadEih
         XRNyZOuF+P8I5jvmO9IWTGwg3fV6jDM1yKRikFrL+YnEkhJs7mJEmTuOTyvB3NhqQ5rl
         SrqeqsVBb6jPXHsh3+ErNTxUrLroOYCqBCL46PA8B63kbwClqKk8QGExmvJ24GG3D2t9
         pskd1CRvEztu/+NwZYjLMTFCq5irWHhSrR0sTJtYX0yiNO0ScIuv+lVklaI9hRAS3zcz
         yEUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eBzFPvXsnl0PWl/qQRoBt7zd2fQQiSK0790Spm1vPuU=;
        b=ejjBMRLe7Ft11L3cwV3ZZQMtMNStjD3MK6woeeKZML7wna70EN/A7GAs4tKNbtDjaX
         A21ARHvndronAPI4ARLIvn9P8uRInVw8AyiLc70qYWkwZLSP7iUzLl3A7OhJnBoR+pgi
         ShkYKqQsXRjx07zwvS7xMblU3UcclTZX1+vaA9Beox3NJxxIpscUHBGCEtsSMYbMYsTb
         75jjApKnHr3jveKyyQee2tiUqS3zvJWKYmgRb3l5zNhbuUtbrYby8Ch6hjC3ocC/0Tcg
         /CXlTqfdIITNLG5KuAm/WVOe9Dpl3L4e1yUGD8snO8M3GNJLNYSeuu+gz2XHHWsaoJ6S
         8lJg==
X-Gm-Message-State: AOAM530UPgvtHyRqQY9JHH9sZAQom+9WFv2DzCDHLThc1BRi9l/qhMYH
        u1wxoBLbEUbc0YrJzX1JIidJbbV6qPQ=
X-Google-Smtp-Source: ABdhPJwwsyx8LJcAfk1LKU8LdXM37VTlxi5NgzhBEq+mG1a4iAqNaQoCyT5QEKzCf3M/loHesNxhrQ==
X-Received: by 2002:a5d:4bc9:: with SMTP id l9mr9196010wrt.503.1638388745297;
        Wed, 01 Dec 2021 11:59:05 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.129])
        by smtp.gmail.com with ESMTPSA id e18sm620020wrs.48.2021.12.01.11.59.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 11:59:04 -0800 (PST)
Message-ID: <0d82f4e2-730f-4888-ec82-2354ffa9c2d8@gmail.com>
Date:   Wed, 1 Dec 2021 19:59:00 +0000
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CA+FuTSf-N08d6pcbie2=zFcQJf3_e2dBJRUZuop4pOhNfSANUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 18:10, Willem de Bruijn wrote:
>> # performance:
>>
>> The worst case for io_uring is (4), still 1.88 times faster than
>> msg_zerocopy (2), and there are a couple of "easy" optimisations left
>> out from the patchset. For 4096 bytes payload zc is only slightly
>> outperforms non-zc version, the larger payload the wider gap.
>> I'll get more numbers next time.
> 
>> Comparing (3) and (4), and (5) vs (6), @flush doesn't affect it too
>> much. Notification posting is not a big problem for now, but need
>> to compare the performance for when io_uring_tx_zerocopy_callback()
>> is called from IRQ context, and possible rework it to use task_work.
>>
>> It supports both, regular buffers and fixed ones, but there is a bunch of
>> optimisations exclusively for io_uring's fixed buffers. For comparison,
>> normal vs fixed buffers (@nr_reqs=8, @flush=0): 75677 vs 116079 MB/s
>>
>> 1) we pass a bvec, so no page table walks.
>> 2) zerocopy_sg_from_iter() is just slow, adding a bvec optimised version
>>     still doing page get/put (see 4/12) slashed 4-5%.
>> 3) avoiding get_page/put_page in 5/12
>> 4) completion events are posted into io_uring's CQ, so no
>>     extra recvmsg for getting events
>> 5) no poll(2) in the code because of io_uring
>> 6) lot of time is spent in sock_omalloc()/free allocating ubuf_info.
>>     io_uring caches the structures reducing it to nearly zero-overhead.
> 
> Nice set of complementary optimizations.
> 
> We have looked at adding some of those as independent additions to
> msg_zerocopy before, such as long-term pinned regions. One issue with
> that is that the pages must remain until the request completes,
> regardless of whether the calling process is alive. So it cannot rely
> on a pinned range held by a process only.
> 
> If feasible, it would be preferable if the optimizations can be added
> to msg_zerocopy directly, rather than adding a dependency on io_uring
> to make use of them. But not sure how feasible that is. For some, like
> 4 and 5, the answer is clearly it isn't.  6, it probably is?

And for 3), io_uring has a complex infra for keeping pages alive,
the additional overhead is one almost percpu_ref_put() per
request/notification, or even better in common cases. Not sure it's
feasible/possible with current msg_zerocopy. Also, io_uring's
ubufs are kept as a part of a larger structure, which may complicate
things.


>> # discussion / questions
>>
>> I haven't got a grasp on many aspects of the net stack yet, so would
>> appreciate feedback in general and there are a couple of questions
>> thoughts.
>>
>> 1) What are initialisation rules for adding a new field into
>> struct mshdr? E.g. many users (mainly LLD) hand code initialisation not
>> filling all the fields.
>>
>> 2) I don't like too much ubuf_info propagation from udp_sendmsg() into
>> __ip_append_data() (see 3/12). Ideas how to do it better?
> 
> Agreed that both of these are less than ideal.
> 
> I can't comment too much on the io_uring aspect of the patch series.
> But msg_zerocopy is probably used in a small fraction of traffic (even
> if a high fraction for users who care about its benefits). We have to
> try to minimize the cost incurred on the general hot path.

One thing, I can hide the initial ubuf check in the beginning of
__ip_append_data() under a common

if (sock_flag(sk, SOCK_ZEROCOPY)) {}

But as SOCK_ZEROCOPY is more of a design problem workaround,
tbh not sure I like from the API perspective. Thoughts? I hope
I can also shuffle some of the stuff in 5/12 out of the
hot path, need to dig a bit deeper.

> I was going to suggest using the standard msg_zerocopy ubuf_info
> alloc/free mechanism. But you explicitly mention seeing omalloc/ofree
> in the cycle profile.
> 
> It might still be possible to somehow signal to msg_zerocopy_alloc
> that this is being called from within an io_uring request, and
> therefore should use a pre-existing uarg with different
> uarg->callback. If nothing else, some info can be passed as a cmsg.
> But perhaps there is a more direct pointer path to follow from struct
> sk, say? Here my limited knowledge of io_uring forces me to hand wave.

One thing I consider important though is to be able to specify a
ubuf per request, but not somehow registering it in a socket. It's
more flexible from the userspace API perspective. It would also need
constant register/unregister, and there are concerns with
referencing/cancellations, that's where it came from in the first
place.

IOW, I'd really prefer to pass it down on a per request basis.

> Probably also want to see how all this would integrate with TCP. In
> some ways, that might be easier, as it does not have the indirection
> through ip_make_skb, etc.

Worked well in general, but patches I used should be a broken for
some input after adding 5/12, so need some work. will send next time.

-- 
Pavel Begunkov
