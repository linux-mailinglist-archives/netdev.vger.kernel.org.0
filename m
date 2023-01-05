Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1240D65E5F4
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 08:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjAEHU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 02:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbjAEHUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 02:20:23 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB018544C4;
        Wed,  4 Jan 2023 23:20:22 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id x22so88067696ejs.11;
        Wed, 04 Jan 2023 23:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uj/YHpeXmpr5U4bNQbKjO/1rSkHOf2b65/VLrm9lhoM=;
        b=R61BOHXtBC9bU7YhPxPgZSRl6zDuw+FfWe5ebK6rqW7+zerEp5BPcUCjppv9SqCTVU
         Yfh4KVtX0pb1hQeK3T9HkJmMEd+x4QckJr4CF8V6Qz7EfsfrghlGzL6p9TA/KzKRwlHx
         bAEXz5iT5gwavBsIvZ7fcIlL/DHyr+H1x6aDcDWda+MUYLVJIc55oy/8+INQxOYvkrCF
         PZAw4703Doo5iCllvAtX4dEZw/IRtEg2KcJ6t25CPIjGf7Wp/V4XsMqkDMS+6qFscm7v
         W2cTnEV8WQ3jBOA8QD4gOEBoIywHOI7McxXU8ayq1cnrfUWjTPHe3Gr1i+shOXfM2qcy
         va9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uj/YHpeXmpr5U4bNQbKjO/1rSkHOf2b65/VLrm9lhoM=;
        b=vcg7Zi2CEdqN0E892EviprsuDo6D7GAbjSy1AZR+3bI17H+b1t7Qxa3Q1N8h4HoTIZ
         Lypt6N/1zpjyXp11DUzEezRqcf2dwRhaEhiM+/aoRKWaGO0aPYIQ7vW/kjElHuzXgbKP
         GQg2r/DCbQ5BgfTbWvTVDqM2qOpCHi6Rd2a2c8aXzku5yM4Yh6ahFaUXQmt8F0C6mbsC
         GwYv/YMq23NexvULbsipcCE7TFhdXvBJomCn+qVOcOSUpjdNusC8s2botpd1YBQpbEB7
         YtTHl/0AgvawQerAmBnUF7yXtErJQOQhME7h7GLzTlVh2QOFOrQXKwPpE1iBpBAOHINI
         5AXw==
X-Gm-Message-State: AFqh2krY73PLS8N0xFLcbLFqiBRC97r0TmiyvDGznFhyAJFxb7HK38ZS
        sHQHHkz/FNmbHk9dayxVbzE=
X-Google-Smtp-Source: AMrXdXs3pBUmilz6nGHLSkHQDczibNEyEzw2ZtKSCZQRJjPYwmvN15lWrOlZ2D51GlTsfZY1txo1pw==
X-Received: by 2002:a17:906:6bc7:b0:7c1:1bc:7fd4 with SMTP id t7-20020a1709066bc700b007c101bc7fd4mr45549524ejs.42.1672903221197;
        Wed, 04 Jan 2023 23:20:21 -0800 (PST)
Received: from [192.168.0.105] ([77.126.9.245])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906211100b0084cb4d37b8csm6034236ejt.141.2023.01.04.23.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jan 2023 23:20:20 -0800 (PST)
Message-ID: <a12de9d9-c022-3b57-0a15-e22cdae210fa@gmail.com>
Date:   Thu, 5 Jan 2023 09:20:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Gospodarek <andrew.gospodarek@broadcom.com>, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        lorenzo.bianconi@redhat.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com> <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org> <Y7U8aAhdE3TuhtxH@lore-desk>
 <87bkne32ly.fsf@toke.dk>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <87bkne32ly.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/01/2023 14:28, Toke Høiland-Jørgensen wrote:
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
> 
>>> On Tue, 03 Jan 2023 16:19:49 +0100 Toke Høiland-Jørgensen wrote:
>>>> Hmm, good question! I don't think we've ever explicitly documented any
>>>> assumptions one way or the other. My own mental model has certainly
>>>> always assumed the first frag would continue to be the same size as in
>>>> non-multi-buf packets.
>>>
>>> Interesting! :) My mental model was closer to GRO by frags
>>> so the linear part would have no data, just headers.
>>
>> That is assumption as well.
> 
> Right, okay, so how many headers? Only Ethernet, or all the way up to
> L4 (TCP/UDP)?
> 
> I do seem to recall a discussion around the header/data split for TCP
> specifically, but I think I mentally put that down as "something people
> may way to do at some point in the future", which is why it hasn't made
> it into my own mental model (yet?) :)
> 
> -Toke
> 

I don't think that all the different GRO layers assume having their 
headers/data in the linear part. IMO they will just perform better if 
these parts are already there. Otherwise, the GRO flow manages, and 
pulls the needed amount into the linear part.
As examples, see calls to gro_pull_from_frag0 in net/core/gro.c, and the 
call to pskb_may_pull() from skb_gro_header_slow().

This resembles the bpf_xdp_load_bytes() API used here in the xdp prog.

The context of my questions is that I'm looking for the right memory 
scheme for adding xdp-mb support to mlx5e striding RQ.
In striding RQ, the RX buffer consists of "strides" of a fixed size set 
by the driver. An incoming packet is written to the buffer starting from 
the beginning of the next available stride, consuming as much strides as 
needed.

Due to the need for headroom and tailroom, there's no easy way of 
building the xdp_buf in place (around the packet), so it should go to a 
side buffer.

By using 0-length linear part in a side buffer, I can address two 
challenging issues: (1) save the in-driver headers memcpy (copy might 
still exist in the xdp program though), and (2) conform to the 
"fragments of the same size" requirement/assumption in xdp-mb. 
Otherwise, if we pull from frag[0] into the linear part, frag[0] becomes 
smaller than the next fragments.

Regards,
Tariq
