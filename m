Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB5CC55FCBA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 11:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbiF2J5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 05:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiF2J5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 05:57:10 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A933DA4A;
        Wed, 29 Jun 2022 02:57:08 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id q6so31397131eji.13;
        Wed, 29 Jun 2022 02:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=I5MLR9GaHt+gcljbfrFjnCSWyn1j6/a5Hr7Xlh2aaN0=;
        b=buJxgv5Q73bxHOIBmNPHFEGhV8WPj3dtmmyuGDGyrfj60FcAPVugXG7vA6AMEP08TG
         BmCZ/AWtbXajkUKw8LFLaEzzNbJadQYgX10xDr+2Ts1QijKexaikeB3KzW/kvChGgvG6
         +8P60fkmFbHgI0KrY0qMP38wqEqXscApe4aLQhh+Rfl//YcZaa+cq2WuskIRQfbfcRzs
         oY0VlJDZs2K2y7ldi0s25g/HbvXoIKeakJIy9/qoKavN7mcbJdHORxtVacyT9pL01AjE
         txzLdLA7ja22x2BySScPzN0TccRkN2h/Nlrf9RhL3KKgjKn/HvY79N2oW9n9BzbgDuKd
         AHIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I5MLR9GaHt+gcljbfrFjnCSWyn1j6/a5Hr7Xlh2aaN0=;
        b=rwpKMjOvXLg0t7Kmy6nJJe5gxctW9ERMdD/n0mwiZwfca4Zg9wZtVJVFgys6ZrKmL2
         pWGdkfV5HtqYttJuqDlFqlL9zIXmPRhlpoR4SXVKWPCrhy3nF3VSlQ8Ht0riD1QFNGJ7
         QaerGSubOWKJ+Wgca768ODKe90yVtrNnDQ1PpouUgtMkSTNpt9pxmtOBqQ1tAoQFdtWt
         vNmsbv0UgcVNsU3W/n6uh2H7hvvOWnuwDe9Z2QsaQDhV9qBySJHs4lRhEOP4sTd974ly
         iDZBbCTA2YmDyOitoXTaBWZRaGbH0yznsPVloSVaV+HfCf9jL5xC1E8LStUuR4P2qTTE
         FIiA==
X-Gm-Message-State: AJIora8r7mZTU23KgcQ6l+gWwHKaPoj/2BdnVfY44MYpX7CbiRZrMEx0
        9eSBgaeMKpgAE2E3/WPecnU=
X-Google-Smtp-Source: AGRyM1sLHXMDnL3au3JQFE0erjRHq0Qa86eTDi9YJaFWZ6OgnuQ+sso80Ks6wPODn/9/SsTbaCI5+Q==
X-Received: by 2002:a17:906:f84:b0:711:eda5:db31 with SMTP id q4-20020a1709060f8400b00711eda5db31mr2395073ejj.397.1656496627005;
        Wed, 29 Jun 2022 02:57:07 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id i21-20020a17090639d500b006fe98fb9523sm7602335eje.129.2022.06.29.02.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 02:57:06 -0700 (PDT)
Message-ID: <56631a36-fec8-9c41-712b-195ad7e4cb9f@gmail.com>
Date:   Wed, 29 Jun 2022 10:53:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC net-next v3 23/29] io_uring: allow to pass addr into sendzc
Content-Language: en-US
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
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cccec667-d762-9bfd-f5a5-1c9fb46df5af@samba.org>
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

On 6/29/22 08:42, Stefan Metzmacher wrote:
> 
> Hi Pavel,
> 
>> +    if (zc->addr) {
>> +        ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
>> +        if (unlikely(ret < 0))
>> +            return ret;
>> +        msg.msg_name = (struct sockaddr *)&address;
>> +        msg.msg_namelen = zc->addr_len;
>> +    }
>> +
> 
> Given that this fills in msg almost completely can we also have
> a version of SENDMSGZC, it would be very useful to also allow
> msg_control to be passed and as well as an iovec.
> 
> Would that be possible?

Right, I left it to follow ups as the series is already too long.

fwiw, I'm going to also add addr to IORING_OP_SEND.


> Do I understand it correctly, that the reason for the new opcode is,
> that IO_OP_SEND would already work with existing MSG_ZEROCOPY behavior, together
> with the recvmsg based completion?

Right, it should work with MSG_ZEROCOPY, but with a different notification
semantics, would need recvmsg from error queues, and with performance
implications.


> In addition I wondering if a completion based on msg_iocb->ki_complete() (indicated by EIOCBQUEUED)
> what have also worked, just deferring the whole sendmsg operation until all buffers are no longer used.
> That way it would be possible to buffers are acked by the remote end when it comes back to the application
> layer.

There is msg_iocb, but it's mostly unused by protocols, IIRC apart
from crypto sockets. And then we'd need to repeat the path of
ubuf_info to handle stuff like skb splitting and perhaps also
changing rules for ->ki_complete


> I'm also wondering if the ki_complete() based approach should always be provided to sock_sendmsg()
> triggered by io_uring (independend of the new zerocopy stuff), it would basically work very simular to
> the uring_cmd() completions, which are able to handle both true async operation indicated by EIOCBQUEUED
> as well as EAGAIN triggered path via io-wq.

Would be even more similar to how we has always been doing
read/write, and rw requests do pass in a msg_iocb, but again,
it's largely ignored internally.

-- 
Pavel Begunkov
