Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CB556BBC3
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 16:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbiGHO2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 10:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbiGHO2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 10:28:16 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F102F03C;
        Fri,  8 Jul 2022 07:28:15 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id l23so6209439ejr.5;
        Fri, 08 Jul 2022 07:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LngixNJX6TgG7N5xNVxJaVBarAufEAvWKBRlLibchAc=;
        b=niRheLaAYh4fLQ14XeZHNggN6GPSkHm6CvSeP9RhIsdv029EVf65gUur6uifV96fyg
         YxgCto7qBMQRXLbcXqImoowFxBL8QrNciG4fe41+S9MA9xPgsMXXCbCSHLQcLlOkxpRf
         fYTaJh1UGdfLPu7zbiA4K//nOhdM5V00ikhVC54VPIdDv+/BZb0PrexSD9ws4PZWueL4
         ErsxV29PxQ8saSjQ3r85PZ8L4pm9YZUDe21nA5Ji5JxvGvrzo1l8YN9YHAJAo0oCUASL
         5ZkOWDt7oZQsd470Izn4hvEwMownqZZP+nPKv7HZhiijLBpu94pGIunOSPKsTbd4P1/C
         hLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LngixNJX6TgG7N5xNVxJaVBarAufEAvWKBRlLibchAc=;
        b=vteaJ2eCU+dA6p/eeDdYk6rH3/LuTJXnzAXPJYdOn81HdUYVmuG8Us/v32J5jp/VdH
         Kq69ua8D9AhzqHF9VYtq9rtm5oTD886CoqmdbTanMXgyLvN24aPxoc3E0RN6lPQcod2Q
         IF+X9FuOI08lJvKrCKqtl/Sq+xGlGgfv8sxSgPSKj4rn0K+7tciGOQQmg8E0ZdWasspN
         2fSl88qXR9n5zP8Rh1eIHfddOpFhBQ8RC80sDJ7LJMooQaSZqt6w1DFLBg/sPMGsXDJn
         z1upU8tjXt4n6MDpqgV0Vob2eh9fZgtjLPRY4aQhdkV4yvPIrw1JKiz5W60AwG979Sae
         9c2w==
X-Gm-Message-State: AJIora84HtM2qe7spPJ0CA5M+lJ3iIljKDeNW8oPgD8n5w5rU1+OyApp
        YstLMGnRFg6Tw+QkhYedod0=
X-Google-Smtp-Source: AGRyM1sr5tm9eUjoEiYGRmWe/IQkAg2S4PQdNYXAarJ+OJ9zEa05D+JIy3e9sO4ddJTqEgt81sM29w==
X-Received: by 2002:a17:907:1608:b0:726:a7b7:cd7a with SMTP id hb8-20020a170907160800b00726a7b7cd7amr3765412ejc.682.1657290494311;
        Fri, 08 Jul 2022 07:28:14 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:676a])
        by smtp.gmail.com with ESMTPSA id h18-20020aa7c952000000b0043a6fde6e7bsm10019592edt.19.2022.07.08.07.28.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 07:28:13 -0700 (PDT)
Message-ID: <bd9960ab-c9d8-8e5d-c347-8049cdf5708a@gmail.com>
Date:   Fri, 8 Jul 2022 15:26:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2c49d634-bd8a-5a7f-0f66-65dba22bae0d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/22 05:10, David Ahern wrote:
> On 7/7/22 5:49 AM, Pavel Begunkov wrote:
>> NOTE: Not be picked directly. After getting necessary acks, I'll be working
>>        out merging with Jakub and Jens.
>>
>> The patchset implements io_uring zerocopy send. It works with both registered
>> and normal buffers, mixing is allowed but not recommended. Apart from usual
>> request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
>> the userspace when buffers are freed and can be reused (see API design below),
>> which is delivered into io_uring's Completion Queue. Those "buffer-free"
>> notifications are not necessarily per request, but the userspace has control
>> over it and should explicitly attaching a number of requests to a single
>> notification. The series also adds some internal optimisations when used with
>> registered buffers like removing page referencing.
>>
>>  From the kernel networking perspective there are two main changes. The first
>> one is passing ubuf_info into the network layer from io_uring (inside of an
>> in kernel struct msghdr). This allows extra optimisations, e.g. ubuf_info
>> caching on the io_uring side, but also helps to avoid cross-referencing
>> and synchronisation problems. The second part is an optional optimisation
>> removing page referencing for requests with registered buffers.
>>
>> Benchmarking with an optimised version of the selftest (see [1]), which sends
>> a bunch of requests, waits for completions and repeats. "+ flush" column posts
>> one additional "buffer-free" notification per request, and just "zc" doesn't
>> post buffer notifications at all.
>>
>> NIC (requests / second):
>> IO size | non-zc    | zc             | zc + flush
>> 4000    | 495134    | 606420 (+22%)  | 558971 (+12%)
>> 1500    | 551808    | 577116 (+4.5%) | 565803 (+2.5%)
>> 1000    | 584677    | 592088 (+1.2%) | 560885 (-4%)
>> 600     | 596292    | 598550 (+0.4%) | 555366 (-6.7%)
>>
>> dummy (requests / second):
>> IO size | non-zc    | zc             | zc + flush
>> 8000    | 1299916   | 2396600 (+84%) | 2224219 (+71%)
>> 4000    | 1869230   | 2344146 (+25%) | 2170069 (+16%)
>> 1200    | 2071617   | 2361960 (+14%) | 2203052 (+6%)
>> 600     | 2106794   | 2381527 (+13%) | 2195295 (+4%)
>>
>> Previously it also brought a massive performance speedup compared to the
>> msg_zerocopy tool (see [3]), which is probably not super interesting.
>>
> 
> can you add a comment that the above results are for UDP.

Oh, right, forgot to add it


> You dropped comments about TCP testing; any progress there? If not, can
> you relay any issues you are hitting?

Not really a problem, but for me it's bottle necked at NIC bandwidth
(~3GB/s) for both zc and non-zc and doesn't even nearly saturate a CPU.
Was actually benchmarked by my colleague quite a while ago, but can't
find numbers. Probably need to at least add localhost numbers or grab
a better server.

-- 
Pavel Begunkov
