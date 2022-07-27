Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77A15824D7
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 12:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiG0Kwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 06:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbiG0Kwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 06:52:43 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33E8E3F33C;
        Wed, 27 Jul 2022 03:52:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id b6so10271034wmq.5;
        Wed, 27 Jul 2022 03:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0kts4MJ4BN+E+a58r7nYbDkrBR4jxQA8muMjzr80HKA=;
        b=qp5aMdDHfuSOtsbe172qq3FNRbcD2aeiQTli/1L8TmKl03UxaaBKBA5awN7PG35sLZ
         81ycK/xzc1CHbJnR4hJca5SsBzwwbIn+dwfDGTBE4GOD71q9up/NBnCjhvq5i/HdoQRg
         y7Ob1mVNc7+ZAUaUUqdJ5NDuqF2tZGYf8pMNNtQqtyUnLn5Mo46UNCQ/Sfrkd31d2kD+
         m9FEC5j6Fa9NUSqEEJjGf3GA8vUqUUF/YEy3XfMAVAPCK/o73yHCOmvyAD4EkpSkz0Ss
         PQgyQKnxg7JeCS8gjSKBlQr9Siyisma3p0DAD75f9wgKQqSLR8ZmTQDTA0HhSO4qDOX+
         k82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0kts4MJ4BN+E+a58r7nYbDkrBR4jxQA8muMjzr80HKA=;
        b=514n7vGh1QieUOpeUChgXOh+AytUSscHNvILChUQ50f7vi23N/gcfbTLX/KSZsV/fM
         TXLt4TZwHYHj6qS2KxhA0160g9mJJ0KKdRL2Zo1TXKmB3HHktfQWKTZw7HJj9BkACvAC
         PsLL788Xh4B8y5v8MqZuaNYl1sVjbHloJ/7NCVmLw/xBkY3IKAYD8ImCwLNt8C1R6y3p
         NwuvMLcBPuNIUe01yfmraHtcQitM0U4sKVdagpRLa8G8R3Bfc/48GlDMASCVhUStk/Gb
         Z9LLbnntZ5FMghTR1vX932WRVsmeh9P7fR7wpINsVh/SEtTBAV76NgvoCkgYXltl6PSE
         jS2A==
X-Gm-Message-State: AJIora/VmM1IzgeWjRD5fp8YvLN44q59OxX3OpSm0KS1hSIFmeu16Btz
        G+7bajEx4Kq3GBAORGarRN1j+EyHMOpdRw==
X-Google-Smtp-Source: AGRyM1u1nDQue+kFgwa04M6Tv3vO9euHL8yDa1xbmqN8GBUOO087IQYJmN2aOvVjbifOiOW+AFUFnw==
X-Received: by 2002:a05:600c:6014:b0:3a3:7308:6a4b with SMTP id az20-20020a05600c601400b003a373086a4bmr2639465wmb.122.1658919160472;
        Wed, 27 Jul 2022 03:52:40 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:b252])
        by smtp.gmail.com with ESMTPSA id h130-20020a1c2188000000b003a3211112f8sm1883550wmh.46.2022.07.27.03.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 03:52:39 -0700 (PDT)
Message-ID: <0a3b7166-5f86-f808-e26d-67966bd521fe@gmail.com>
Date:   Wed, 27 Jul 2022 11:51:25 +0100
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
 <3b81b3e1-2810-5125-f4a0-d6ba45c1fbd3@kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3b81b3e1-2810-5125-f4a0-d6ba45c1fbd3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/22 19:28, David Ahern wrote:
> On 7/17/22 8:19 PM, David Ahern wrote:
>>>
>>> Haven't seen it back then. In general io_uring doesn't stop submitting
>>> requests if one request fails, at least because we're trying to execute
>>> requests asynchronously. And in general, requests can get executed
>>> out of order, so most probably submitting a bunch of requests to a single
>>> TCP sock without any ordering on io_uring side is likely a bug.
>>
>> TCP socket buffer fills resulting in a partial send (i.e, for a given
>> sqe submission only part of the write/send succeeded). io_uring was not
>> handling that case.
>>
>> I'll try to find some time to resurrect the iperf3 patch and try top of
>> tree kernel.
> 
> With your zc_v5 branch (plus the init fix on using msg->sg_from_iter),
> iperf3 with io_uring support (non-ZC case) no longer shows completions
> with incomplete sends. So that is good improvement over the last time I
> tried it.
> 
> However, adding in the ZC support and that problem resurfaces - a lot of
> completions are for an incomplete size.

Makes sense, it explicitly retries with normal sends but I didn't
implement it for zc. Might be a good thing to add.

> liburing comes from your tree, zc_v4 branch. Upstream does not have
> support for notifications yet, so I can not move to it.

Upstreamed it

> Changes to iperf3 are here:
>     https://github.com/dsahern/iperf mods-3.10-io_uring

-- 
Pavel Begunkov
