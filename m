Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C39592C82
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 12:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242173AbiHOJug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 05:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbiHOJuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 05:50:35 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659D51027;
        Mon, 15 Aug 2022 02:50:34 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n4so8433526wrp.10;
        Mon, 15 Aug 2022 02:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc;
        bh=psPpKOGAtOeEDOvtXs+apIVxxYFLedxYJn8rDYeTSCI=;
        b=PK2DQ3jN1k0ul0I4lNJsvoX8D8d/pWB4v4UqceK+ww+/lTWvd5YcI87PHTTT6XpZf4
         bZiM4SGEDS5n6XS9YdXFl9ukYqIblFl17u/dEz1nikjXlzp4YuGzlElxqNKL5zIFzqX+
         HGWkJI5Nk6+9yRgPza14UwKBsixMsAWVwUyCKlyotUwLV3xAgWOU+LcmUL58YMxqNMjL
         EnGhB+Sx4eBQ1kMqCweDdN0oH+l2/+vJDDabgdE3451oiXitxmjVAqYo821OT1pjumJo
         bao1AF5HusRVbeQeLr6cbydIwHkxgG43Lpg1jp6OigsHyfBxYbm95vUZuUjEZrktqv3b
         r8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=psPpKOGAtOeEDOvtXs+apIVxxYFLedxYJn8rDYeTSCI=;
        b=F7ycitHfvkZeQrmJBHncTp4jq7yvzi2JoE8XAX1Dp7ckH6lTLoqNtgksU5h8ocYAe1
         WUtEfgtJ9hOiMCDtDgcBfwlJj/2h/nVLAw+IKOqb2JdRK1wqSGbk8dE1cL/opUJnEiFd
         p3p0xx7tZuPL8+E69R/EutpFlltttu4DeUA8rQp0qQNBuH7z4cSvMUanl6WA4cDYOB2r
         G0EYV5ma2f8PyKNzWAI7jEjO8r6v4hBzxO0BgEdP+UzG7KTLqOrcGzUMz6lZwdniAoa6
         ZnH0/0qDgv8MTTb9UxXwGilm2kQjw+SPnTcnsCQNuiTKceoqWH82egVBPN5YWKe0nPyA
         VOHg==
X-Gm-Message-State: ACgBeo3ajksAjYLNqblxwRXZ5EjqlAbiKhzLSsAv5nGMnRO/YiA7ZTOU
        s8qPQkaESrTejJNlyoqPqD4=
X-Google-Smtp-Source: AA6agR7Fll0IsHCmnqegeErvjOXbjZ88G3w3Re6FoaI23BQ+MWnCi0Ef8ldTP5VOGG2rxRelJEthrw==
X-Received: by 2002:a05:6000:18a2:b0:221:7d32:e6a5 with SMTP id b2-20020a05600018a200b002217d32e6a5mr8282027wri.278.1660557032800;
        Mon, 15 Aug 2022 02:50:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:5fc6])
        by smtp.gmail.com with ESMTPSA id j3-20020a5d5643000000b0021f138e07acsm6832311wrw.35.2022.08.15.02.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Aug 2022 02:50:32 -0700 (PDT)
Message-ID: <db7bbfcd-fdd0-ed8e-3d8e-78d76f278af8@gmail.com>
Date:   Mon, 15 Aug 2022 10:46:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1653992701.git.asml.silence@gmail.com>
 <228d4841af5eeb9a4b73955136559f18cb7e43a0.1653992701.git.asml.silence@gmail.com>
 <cccec667-d762-9bfd-f5a5-1c9fb46df5af@samba.org>
 <56631a36-fec8-9c41-712b-195ad7e4cb9f@gmail.com>
 <4eb0adae-660a-3582-df27-d6c254b97adb@samba.org>
Content-Language: en-US
In-Reply-To: <4eb0adae-660a-3582-df27-d6c254b97adb@samba.org>
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

On 8/13/22 09:45, Stefan Metzmacher wrote:
> Hi Pavel,

Hi Stefan,

Thanks for giving a thought about the API, are you trying
to use it in samba?

>>> Given that this fills in msg almost completely can we also have
>>> a version of SENDMSGZC, it would be very useful to also allow
>>> msg_control to be passed and as well as an iovec.
>>>
>>> Would that be possible?
>>
>> Right, I left it to follow ups as the series is already too long.
>>
>> fwiw, I'm going to also add addr to IORING_OP_SEND.
> 
> 
> Given the minimal differences, which were left between
> IORING_OP_SENDZC and IORING_OP_SEND, wouldn't it be better
> to merge things to IORING_OP_SEND using a IORING_RECVSEND_ZC_NOTIF
> as indication to use the notif slot.

And will be even more similar in for-next, but with notifications
I'd still prefer different opcodes to get a little bit more
flexibility and not making the normal io_uring send path messier.

> It would means we don't need to waste two opcodes for
> IORING_OP_SENDZC and IORING_OP_SENDMSGZC (and maybe more)
> 
> 
> I also noticed a problem in io_notif_update()
> 
>          for (; idx < idx_end; idx++) {
>                  struct io_notif_slot *slot = &ctx->notif_slots[idx];
> 
>                  if (!slot->notif)
>                          continue;
>                  if (up->arg)
>                          slot->tag = up->arg;
>                  io_notif_slot_flush_submit(slot, issue_flags);
>          }
> 
>   slot->tag = up->arg is skipped if there is no notif already.
> 
> So you can't just use a 2 linked sqe's with
> 
> IORING_RSRC_UPDATE_NOTIF followed by IORING_OP_SENDZC(with IORING_RECVSEND_NOTIF_FLUSH)

slot->notif is lazily initialised with the first send attached to it,
so in your example IORING_OP_SENDZC will first create a notification
to execute the send and then will flush it.

This "if" is there is only to have a more reliable API. We can
go over the range and allocate all empty slots and then flush
all of them, but allocation failures should be propagated to the
userspace when currently the function it can't fail.

> I think the if (!slot->notif) should be moved down a bit.

Not sure what you mean

> It would somehow be nice to avoid the notif slots at all and somehow
> use some kind of multishot request in order to generate two qces.

It is there first to ammortise overhead of zerocopy infra and bits
for second CQE posting. But more importantly, without it for TCP
the send payload size would need to be large enough or performance
would suffer, but all depends on the use case. TL;DR; it would be
forced to create a new SKB for each new send.

For something simpler, I'll push another zc variant that doesn't
have notifiers and posts only one CQE and only after the buffers
are no more in use by the kernel. This works well for UDP and for
some TCP scenarios, but doesn't cover all cases.
> I'm also wondering what will happen if a notif will be referenced by the net layer
> but the io_uring instance is already closed, wouldn't
> io_uring_tx_zerocopy_callback() or __io_notif_complete_tw() crash
> because notif->ctx is a stale pointer, of notif itself is already gone...

io_uring will flush all slots and wait for all notifications
to fire, i.e. io_uring_tx_zerocopy_callback(), so it's not a
problem.

-- 
Pavel Begunkov
