Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128436A1D7F
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 15:33:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjBXOdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 09:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBXOdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 09:33:01 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346CE688D6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 06:32:33 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id ay18so1893164pfb.2
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 06:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677249152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j3xiqVtEvTQrIgBk6Cp0cIIPR5mcG7GE8kATfHkdtes=;
        b=wmxYMfZ70oh/oxBll6bX35pHUrYpACarqOy8+M3ZTdCLzOVdoIrFi88leUvKgwJ3pM
         u+XKueOqXMkZ+nYvOCSbIfd79CE3DRNp9KV6Bwo8Y75nyJAEQQQV3cAHvg3etQpKaXz8
         k1L2Qw412DjNAfXExAS1ZrJbbazVCanwONnqZttCHWf6NT2vXxWMvuLRX8CvrCI65k2m
         qsZk4B/RZvPMswOG+QortxnLpo0a1U6qp+u7MImm3C3WSvmxFUvAbCowwElHzvSeyWjm
         4S0QvYDnMAr+raoboKtPyPHQK50bD2K15sb/dRj3Cs1dbo7UjxvX38mjaE57VPXwegNb
         94yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677249152;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j3xiqVtEvTQrIgBk6Cp0cIIPR5mcG7GE8kATfHkdtes=;
        b=Aaak4heHubiVI44l9X1pMgI+9F2ulNvUjIzmBGGULZXYGRWSVwmiv5N2vjIklaufyr
         qX9WkkAGh2M61L88tXD9TNSW29P/ETSDnAMy/IXQnRcL/C0v0I631obB9GFaqhDfKNHK
         cAnOEmMkxMIMjK4batRu1vU/oo7X9PGYvbHO4slUyY0YHINJeCf5lruZYz7BpnHa2xSI
         elIWcPl5rFhF9LusHj4rm/kdwvYXYH//YufnXZfpBKiUU2t1BMmkOxNtQmgMhelKcKRN
         4vixhB1r4vj4yy7V/ATwWyPrM+0Cm//3CL9vfAwfR7cjd8ST6XxKFUdHs1nTvZ4PAB8b
         JEJA==
X-Gm-Message-State: AO0yUKWG9+jOvM8Uzt2uQYI36GeIXn5zXKrc6n5PUDdhScQAZ+2a6NmA
        tDTt3CTDG5QOVMoqZWd15KsU1DZGzNww+EaV
X-Google-Smtp-Source: AK7set8Y1bHmVZkrCW7Ym1RhQMQPF3yTMG7OHyTlQi4r2GxY25UM7kXOfjrQvppfX0OsKkbXGyXwFg==
X-Received: by 2002:a05:6a00:2ca:b0:5de:a362:ecf1 with SMTP id b10-20020a056a0002ca00b005dea362ecf1mr4960205pft.0.1677249152281;
        Fri, 24 Feb 2023 06:32:32 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s23-20020aa78d57000000b005ad9e050512sm3307417pfe.121.2023.02.24.06.32.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 06:32:31 -0800 (PST)
Message-ID: <6a4ebf7b-63c9-34b8-cff3-5b2312762972@kernel.dk>
Date:   Fri, 24 Feb 2023 07:32:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH net-next] packet: allow MSG_NOSIGNAL in recvmsg
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        David Lamparter <equinox@diac24.net>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <20230224071745.20717-1-equinox@diac24.net>
 <CANn89iL5EEMwO0cvHkm+V5+qJjmWqmnD_0=G6q7TGW0RC_tkUg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CANn89iL5EEMwO0cvHkm+V5+qJjmWqmnD_0=G6q7TGW0RC_tkUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 3:26 AM, Eric Dumazet wrote:
> On Fri, Feb 24, 2023 at 8:18 AM David Lamparter <equinox@diac24.net> wrote:
>>
>> packet_recvmsg() whitelists a bunch of MSG_* flags, which notably does
>> not include MSG_NOSIGNAL.  Unfortunately, io_uring always sets
>> MSG_NOSIGNAL, meaning AF_PACKET sockets can't be used in io_uring
>> recvmsg().
>>
>> As AF_PACKET sockets never generate SIGPIPE to begin with, MSG_NOSIGNAL
>> is a no-op and can simply be ignored.
>>
>> Signed-off-by: David Lamparter <equinox@diac24.net>
>> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
>> ---
>>  net/packet/af_packet.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
> 
> This is odd... I think MSG_NOSIGNAL flag has a meaning for sendmsg()
> (or write sides in general)
> 
> EPIPE is not supposed to be generated at the receiving side ?
> 
> So I would rather make io_uring slightly faster :
> 
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index cbd4b725f58c98e5bc5bf88d5707db5c8302e071..b7f190ca528e6e259eb2b072d7a16aaba98848cb
> 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -567,7 +567,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const
> struct io_uring_sqe *sqe)
>         sr->flags = READ_ONCE(sqe->ioprio);
>         if (sr->flags & ~(RECVMSG_FLAGS))
>                 return -EINVAL;
> -       sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
> +       sr->msg_flags = READ_ONCE(sqe->msg_flags);
>         if (sr->msg_flags & MSG_DONTWAIT)
>                 req->flags |= REQ_F_NOWAIT;
>         if (sr->msg_flags & MSG_ERRQUEUE)

This looks fine to me. Do you want to send a "proper" patch for
this?

-- 
Jens Axboe


