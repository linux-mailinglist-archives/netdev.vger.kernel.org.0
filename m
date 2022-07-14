Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9515557557A
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240850AbiGNS4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240858AbiGNS4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:56:11 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67AFC52FDE;
        Thu, 14 Jul 2022 11:56:10 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id be14-20020a05600c1e8e00b003a04a458c54so1747564wmb.3;
        Thu, 14 Jul 2022 11:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RU9V2OgJ1oKx9BLdxLEkZw3yHrxXayfkCQ6BCQBuuFQ=;
        b=Ql4BH0HotX5MrQ/iK68GYF2HflniYai/4SZcESyRt8XH+ZImo4NFhsTQFpZoert2co
         JI4RXBOAYWBZNzaQmRHmOrvEh71Rce+C+sHHERcOGYh5BUVQa2ISVDhM145KO8yUeSeU
         tAf7CHYkoqUnt1LuLjx+1ndh7S30jF5xImOhJ0HxdDEEcaF0hi2LYzvbma++2zP+plLp
         4Nc8usF6qDbzbXm5h7QCD2wVjKdKBi4hUAU8sKkj/mERbu05DSCidfUWciP59Nyov9Dq
         WwNqKSg6CzC9MYpiVFYbPQAVevHOyQAja+470K5p/ZTeBS5x0F3syTXzGYxw/wRenq0j
         HoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RU9V2OgJ1oKx9BLdxLEkZw3yHrxXayfkCQ6BCQBuuFQ=;
        b=7TkNlVk9cwqHCCpbVOr7cDQPq6vOlhUMk1joJfSdrrdNX4oFkHJ6v/3mu2dRi734ph
         j9iAcx1jTRGYVNkIG9jaNWoLrPh9q+fHOKlsFXDINK3zM8XigIxQX558XK0gKpbQjCSn
         vuZPhyaTPN6kfGDlWOsDeynLpVGPnm7ZSkZfX+Kbi88e96klNnvgu/RsIYzBijFMaHn7
         yxetXTc3RtoxWWBdnYJ9X4f26nREcxhBKk5s3DwhxJFOV635MXDVJ0riD8dSQOk2HnqW
         AmEs59welN412bmxa4UqMCcVdFjsVBjBu+0Av6URTZitGEk9/ww1eNk0Vlc1kO3qryLU
         gawQ==
X-Gm-Message-State: AJIora9hjIvsKZje33GpbtcaChpiNdQe6bt9LB/+Tq50m+a+iPlDgYxk
        7GLaZ45k+axdLIPyZYVQv/M=
X-Google-Smtp-Source: AGRyM1stYIHHYPzAtR/QEj1Nohoiw7sHzHJsFkNZuEYIDCmhXdakpURNC4jOoTQY6oxeA9PHmVWPSw==
X-Received: by 2002:a05:600c:4ba9:b0:3a2:daf6:44f6 with SMTP id e41-20020a05600c4ba900b003a2daf644f6mr16695840wmp.52.1657824968834;
        Thu, 14 Jul 2022 11:56:08 -0700 (PDT)
Received: from [192.168.1.192] ([78.142.213.233])
        by smtp.gmail.com with ESMTPSA id j42-20020a05600c1c2a00b003a2e9bdfcf8sm6996104wms.5.2022.07.14.11.56.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jul 2022 11:56:08 -0700 (PDT)
Message-ID: <bc48e2bb-37ee-5b7c-5a97-01e026de2ba4@gmail.com>
Date:   Thu, 14 Jul 2022 19:55:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v4 00/27] io_uring zerocopy send
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
 <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
 <0f54508f-e819-e367-84c2-7aa0d7767097@gmail.com>
 <d10f20a9-851a-33be-2615-a57ab92aca90@kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d10f20a9-851a-33be-2615-a57ab92aca90@kernel.org>
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

On 7/14/22 00:45, David Ahern wrote:
> On 7/11/22 5:56 AM, Pavel Begunkov wrote:
>> On 7/8/22 15:26, Pavel Begunkov wrote:
>>> On 7/8/22 05:10, David Ahern wrote:
>>>> On 7/7/22 5:49 AM, Pavel Begunkov wrote:
>>>>> NOTE: Not be picked directly. After getting necessary acks, I'll be
>>>>> working
>>>>>         out merging with Jakub and Jens.
>>>>>
>>>>> The patchset implements io_uring zerocopy send. It works with both
>>>>> registered
>>>>> and normal buffers, mixing is allowed but not recommended. Apart
>>>>> from usual
>>>>> request completions, just as with MSG_ZEROCOPY, io_uring separately
>>>>> notifies
>>>>> the userspace when buffers are freed and can be reused (see API
>>>>> design below),
>>>>> which is delivered into io_uring's Completion Queue. Those
>>>>> "buffer-free"
>>>>> notifications are not necessarily per request, but the userspace has
>>>>> control
>>>>> over it and should explicitly attaching a number of requests to a
>>>>> single
>>>>> notification. The series also adds some internal optimisations when
>>>>> used with
>>>>> registered buffers like removing page referencing.
>>>>>
>>>>>   From the kernel networking perspective there are two main changes.
>>>>> The first
>>>>> one is passing ubuf_info into the network layer from io_uring
>>>>> (inside of an
>>>>> in kernel struct msghdr). This allows extra optimisations, e.g.
>>>>> ubuf_info
>>>>> caching on the io_uring side, but also helps to avoid cross-referencing
>>>>> and synchronisation problems. The second part is an optional
>>>>> optimisation
>>>>> removing page referencing for requests with registered buffers.
>>>>>
>>>>> Benchmarking with an optimised version of the selftest (see [1]),
>>>>> which sends
>>>>> a bunch of requests, waits for completions and repeats. "+ flush"
>>>>> column posts
>>>>> one additional "buffer-free" notification per request, and just "zc"
>>>>> doesn't
>>>>> post buffer notifications at all.
>>>>>
>>>>> NIC (requests / second):
>>>>> IO size | non-zc    | zc             | zc + flush
>>>>> 4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
>>>>> 1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
>>>>> 1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
>>>>> 600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)
>>>>>
>>>>> dummy (requests / second):
>>>>> IO size | non-zc    | zc             | zc + flush
>>>>> 8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
>>>>> 4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
>>>>> 1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
>>>>> 600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)
>>>>>
>>>>> Previously it also brought a massive performance speedup compared to
>>>>> the
>>>>> msg_zerocopy tool (see [3]), which is probably not super interesting.
>>>>>
>>>>
>>>> can you add a comment that the above results are for UDP.
>>>
>>> Oh, right, forgot to add it
>>>
>>>
>>>> You dropped comments about TCP testing; any progress there? If not, can
>>>> you relay any issues you are hitting?
>>>
>>> Not really a problem, but for me it's bottle necked at NIC bandwidth
>>> (~3GB/s) for both zc and non-zc and doesn't even nearly saturate a CPU.
>>> Was actually benchmarked by my colleague quite a while ago, but can't
>>> find numbers. Probably need to at least add localhost numbers or grab
>>> a better server.
>>
>> Testing localhost TCP with a hack (see below), it doesn't include
>> refcounting optimisations I was testing UDP with and that will be
>> sent afterwards. Numbers are in MB/s
>>
>> IO size | non-zc    | zc
>> 1200    | 4174      | 4148
>> 4096    | 7597      | 11228
> 
> I am surprised by the low numbers; you should be able to saturate a 100G
> link with TCP and ZC TX API.

It was a quick test with my laptop, not a super fast CPU, preemptible
kernel, etc., and considering that the fact that it processes receives
from in the same send syscall roughly doubles the overhead, 87Gb/s
looks ok. It's not like MSG_ZEROCOPY would look much different, even
more to that all sends here will be executed sequentially in io_uring,
so no extra parallelism or so. As for 1200, I think 4GB/s is reasonable,
it's just the kernel overhead per byte is too high, should be same with
just send(2).

>> Because it's localhost, we also spend cycles here for the recv side.
>> Using a real NIC 1200 bytes, zc is worse than non-zc ~5-10%, maybe the
>> omitted optimisations will somewhat help. I don't consider it to be a
>> blocker. but would be interesting to poke into later. One thing helping
>> non-zc is that it squeezes a number of requests into a single page
>> whenever zerocopy adds a new frag for every request.
>>
>> Can't say anything new for larger payloads, I'm still NIC-bound but
>> looking at CPU utilisation zc doesn't drain as much cycles as non-zc.
>> Also, I don't remember if mentioned before, but another catch is that
>> with TCP it expects users to not be flushing notifications too much,
>> because it forces it to allocate a new skb and lose a good chunk of
>> benefits from using TCP.
> 
> I had issues with TCP sockets and io_uring at the end of 2020:
> https://www.spinics.net/lists/io-uring/msg05125.html
> 
> have not tried anything recent (from 2022).

Haven't seen it back then. In general io_uring doesn't stop submitting
requests if one request fails, at least because we're trying to execute
requests asynchronously. And in general, requests can get executed
out of order, so most probably submitting a bunch of requests to a single
TCP sock without any ordering on io_uring side is likely a bug.

You can link io_uring requests, i.e. IOSQE_IO_LINK, guaranteeing
execution ordering. And if you meant links in the message, I agree
that it was not the best decision to consider len < sqe->len not
an error and not breaking links, but it was later added that
MSG_WAITALL would also change the success condition to
len==sqe->len. But all that is relevant if you was using linking.

-- 
Pavel Begunkov
