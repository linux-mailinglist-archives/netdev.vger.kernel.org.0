Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0AB5EB1D7
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIZUKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbiIZUKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:10:06 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB3B82A710;
        Mon, 26 Sep 2022 13:10:05 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bk15so4155091wrb.13;
        Mon, 26 Sep 2022 13:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=XMnwPZnwThAE4Ka6hIcctD7xP5BaW3tuhFZmcRvzFlg=;
        b=SBIFR70zxURT+LWWLEfwvyZjuFngwXp2GYa6lKWsrtGexM9TlF58m6/Jbl3y/B+Qxc
         msi7ARatidnq/2cGdQuxJ2ZJhcjHeJyh+rRgx9hj+k6BtMigjYL82Cg/iO9tQhehtx9E
         CzTkB1+kI0PfnvL/jgvGf6Qlz6INcfxdn6Sm7jRM5mplxz1yF3GutcCzEPLS5jaKCrtu
         g1wMlSRlksSD3LK4Wl39GuVKUjBzONDieC7LdrdUjlOsK/BHZw/kqN5MvhUWlHZgzkbH
         YTMNpqlmN/15v197DAtYY45pkVqUjsXHDTSrV8LYK19VLSOc+GKkoqkb2MdwyStbkwui
         L7/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=XMnwPZnwThAE4Ka6hIcctD7xP5BaW3tuhFZmcRvzFlg=;
        b=ijrHnRWw7Ijkr2RjxRg07XMnJHByvdwwLeiLCTmNpxH52DApkmnK43J6MSlItUCxer
         7IV8vA6cy+PVB2JHidYFYd0YkSaAaSTNQlx9xcz7p131ROj4TbtWR1YKM+ij+YKAGOtT
         mZebKhmZR5bKKrpoZiqpuBAoGj0nrOCazTSAoEo8PswTT4lg7VC/O1EY5yV8JX0bVJt8
         GMupMOaFAzjxgioQgas+DBR9SmJWK8XXUGD3cLxuthbLQXCyXbZv5PbMWkIa1hq6ay0h
         2ayhoZjPM8z94fjklq8S/OkIm23eEPEbaMXlXf/vdXf/R8AwGZYZ+qBnxB3RlGttH0/O
         IjYw==
X-Gm-Message-State: ACrzQf3jp9pkcVHFkC6ICdjAXEyHNrJCBPtM2wbXw5BP+i559+gtQR4K
        aGrQT0HKa9qYeF5dXlUCjq0=
X-Google-Smtp-Source: AMsMyM51TxDI//YOTTSoB5oBl8N+Z/VqLtU/7S94TZ40JdoQgUEJMH2aE3v3p3yAooS6z9TWk4ISJw==
X-Received: by 2002:a5d:59ae:0:b0:22a:ff17:db96 with SMTP id p14-20020a5d59ae000000b0022aff17db96mr15109396wrr.299.1664223004343;
        Mon, 26 Sep 2022 13:10:04 -0700 (PDT)
Received: from [192.168.8.100] (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id r3-20020a5d4e43000000b00228dc1c7063sm15109742wrt.85.2022.09.26.13.10.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 13:10:03 -0700 (PDT)
Message-ID: <24b050e0-433f-dc97-7aab-15c9175f49fa@gmail.com>
Date:   Mon, 26 Sep 2022 21:08:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
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
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
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
> 
> liburing comes from your tree, zc_v4 branch. Upstream does not have
> support for notifications yet, so I can not move to it.
> 
> Changes to iperf3 are here:
>     https://github.com/dsahern/iperf mods-3.10-io_uring

Tried it out, the branch below fixes a small problem, adds a couple
of extra optimisations and now it actually uses registered buffers.

     https://github.com/isilence/iperf iou-sendzc

Still, the submission loop looked a bit weird, i.e. it submits I/O
to io_uring only when it exhausts sqes instead of sending right
away with some notion of QD and/or sending in batches. The approach
is good for batching (SQ size =16 here), but not so for latency.

I also see some CPU cycles being burnt in select(2). io_uring wait
would be more natural and perhaps more performant, but I didn't
spend enough time with iperf to say for sure.

-- 
Pavel Begunkov
