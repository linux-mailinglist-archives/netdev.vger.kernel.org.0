Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEE157B791
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 15:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiGTNc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 09:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbiGTNc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 09:32:56 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260A5387;
        Wed, 20 Jul 2022 06:32:55 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id x23-20020a05600c179700b003a30e3e7989so1298374wmo.0;
        Wed, 20 Jul 2022 06:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LTrp5IVhgxS5/Vts16dXeU1eG7r/JSS7dSLwg4addVc=;
        b=YOnzwnMObQoZd4bRLNPRy3ko1Y7qeyqMYfbuE52CREJ9YJC5joq4C3UVIu9ZnUjToh
         i51c4crsQ46K/o5TYjiyieJghiXI+jqEmTVs7RERdyswU66ngyjxy0+eI3O99d716ATa
         mkcebZ4M47kvFV9Exb9IvBUqB3FP0e6ciwVn/o8nK9xiBntWUZiXFBlbGMQ5wfkSWfah
         /Yu+jHaOQ1ZQnxOY5lUaQt6i7IX8MfGoyVPJ+xK/tm7mtzhUfpVLNfLXekDmNPcEdzwL
         R6RIdGzE8rrpdhfFEa1MqQE4Ml4+jON0WqEYO5naLzWbRQR9xH4cwqG+M3lBbqKsI7S3
         6a2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LTrp5IVhgxS5/Vts16dXeU1eG7r/JSS7dSLwg4addVc=;
        b=fu7CXFlEFmXGGic5JYLGEk9b08OSjdOuJZTTZ2i+2r9TqG/dhSMLt0riZQFIRjC07U
         3IZPtqKxp4uIxc/Q8uFmEKv85uPks7QyTye9IKOXX9WaPRvV2cJvvxm9pY3B5s4dyof4
         6A19hD7ApHZOH+ukE3v93QjRH1UVwNOiIxz8ZOOAiRnKKKwM+EU7lknpACCRh03W+Odk
         fugG57NMHiNgz6TpGqr5ft9K35GwY4RUej1r+QeB/sLZv/ixfNINWtjfQesnulaNikOO
         Gf3d7xBcg3MzgZ4thhYoIpuzXnJMITOlsQS13z8SPWZcexX6OzjdSq7XWEuougKmkQd3
         Eyng==
X-Gm-Message-State: AJIora/LTPRfXqXElpimb7fKnNhcSUnUxBhLlwnhzf4srzoBJ1maUG/D
        JqhcQNRVQ21zfCS7cKmLIFx001VWan0=
X-Google-Smtp-Source: AGRyM1vCp3ZHQfdoRN3ahvoo+4U5LqV/NfvsUZDqbnkeXjbghbNWZRKFhPFLYoDmsIwVbjRoJuldYQ==
X-Received: by 2002:a05:600c:2d07:b0:3a3:585:5d96 with SMTP id x7-20020a05600c2d0700b003a305855d96mr3883166wmf.38.1658323973633;
        Wed, 20 Jul 2022 06:32:53 -0700 (PDT)
Received: from [192.168.8.198] (188.30.134.15.threembb.co.uk. [188.30.134.15])
        by smtp.gmail.com with ESMTPSA id y4-20020a5d4ac4000000b0021e47386eb8sm2482647wrs.2.2022.07.20.06.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jul 2022 06:32:52 -0700 (PDT)
Message-ID: <6ff5f766-61ef-ae40-aea3-a00c651f94a0@gmail.com>
Date:   Wed, 20 Jul 2022 14:32:12 +0100
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
 <bc48e2bb-37ee-5b7c-5a97-01e026de2ba4@gmail.com>
 <812c3233-1b64-8a0d-f820-26b98ff6642d@kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <812c3233-1b64-8a0d-f820-26b98ff6642d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/22 03:19, David Ahern wrote:
> On 7/14/22 12:55 PM, Pavel Begunkov wrote:
>>>>>> You dropped comments about TCP testing; any progress there? If not,
>>>>>> can
>>>>>> you relay any issues you are hitting?
>>>>>
>>>>> Not really a problem, but for me it's bottle necked at NIC bandwidth
>>>>> (~3GB/s) for both zc and non-zc and doesn't even nearly saturate a CPU.
>>>>> Was actually benchmarked by my colleague quite a while ago, but can't
>>>>> find numbers. Probably need to at least add localhost numbers or grab
>>>>> a better server.
>>>>
>>>> Testing localhost TCP with a hack (see below), it doesn't include
>>>> refcounting optimisations I was testing UDP with and that will be
>>>> sent afterwards. Numbers are in MB/s
>>>>
>>>> IO size | non-zc    | zc
>>>> 1200    | 4174      | 4148
>>>> 4096    | 7597      | 11228
>>>
>>> I am surprised by the low numbers; you should be able to saturate a 100G
>>> link with TCP and ZC TX API.
>>
>> It was a quick test with my laptop, not a super fast CPU, preemptible
>> kernel, etc., and considering that the fact that it processes receives
>> from in the same send syscall roughly doubles the overhead, 87Gb/s
>> looks ok. It's not like MSG_ZEROCOPY would look much different, even
>> more to that all sends here will be executed sequentially in io_uring,
>> so no extra parallelism or so. As for 1200, I think 4GB/s is reasonable,
>> it's just the kernel overhead per byte is too high, should be same with
>> just send(2).
> 
> ?
> It's a stream socket so those sends are coalesced into MTU sized packets.

That leaves syscall and io_uring overhead, locking the socket, etc.,
which still requires more cycles than just copying 1200 bytes. And
the used CPU is not blazingly fast, could be that a better CPU/setup
will saturate 100G

>>>> Because it's localhost, we also spend cycles here for the recv side.
>>>> Using a real NIC 1200 bytes, zc is worse than non-zc ~5-10%, maybe the
>>>> omitted optimisations will somewhat help. I don't consider it to be a
>>>> blocker. but would be interesting to poke into later. One thing helping
>>>> non-zc is that it squeezes a number of requests into a single page
>>>> whenever zerocopy adds a new frag for every request.
>>>>
>>>> Can't say anything new for larger payloads, I'm still NIC-bound but
>>>> looking at CPU utilisation zc doesn't drain as much cycles as non-zc.
>>>> Also, I don't remember if mentioned before, but another catch is that
>>>> with TCP it expects users to not be flushing notifications too much,
>>>> because it forces it to allocate a new skb and lose a good chunk of
>>>> benefits from using TCP.
>>>
>>> I had issues with TCP sockets and io_uring at the end of 2020:
>>> https://www.spinics.net/lists/io-uring/msg05125.html
>>>
>>> have not tried anything recent (from 2022).
>>
>> Haven't seen it back then. In general io_uring doesn't stop submitting
>> requests if one request fails, at least because we're trying to execute
>> requests asynchronously. And in general, requests can get executed
>> out of order, so most probably submitting a bunch of requests to a single
>> TCP sock without any ordering on io_uring side is likely a bug.
> 
> TCP socket buffer fills resulting in a partial send (i.e, for a given
> sqe submission only part of the write/send succeeded). io_uring was not
> handling that case.

Shouldn't have been different from send(2) with MSG_NOWAIT, can be short
and the user should handle it. Also I believe Jens pushed just recently
in-kernel retries on the io_uring side for TCP in such cases.

> I'll try to find some time to resurrect the iperf3 patch and try top of
> tree kernel.

Awesome


>> You can link io_uring requests, i.e. IOSQE_IO_LINK, guaranteeing
>> execution ordering. And if you meant links in the message, I agree
>> that it was not the best decision to consider len < sqe->len not
>> an error and not breaking links, but it was later added that
>> MSG_WAITALL would also change the success condition to
>> len==sqe->len. But all that is relevant if you was using linking.

-- 
Pavel Begunkov
