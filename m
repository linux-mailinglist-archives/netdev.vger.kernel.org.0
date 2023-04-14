Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1A36E240B
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 15:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjDNNMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 09:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjDNNMq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 09:12:46 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4253A8D;
        Fri, 14 Apr 2023 06:12:43 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-5055141a8fdso1812377a12.3;
        Fri, 14 Apr 2023 06:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681477962; x=1684069962;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2Uom6lc4AWGfEj6FlZegDGpqslLO6mugP8+4t00eUbk=;
        b=BmZ8EPO4h0mM3Mt5eW1k3OTRWCZy0A/N0LVFa4nVRbMecDr8gUorPxktYnDsMBf9ap
         M+z08/XOuzDoDWoGD+4ef2zG8CCmQ41G4Rtru6xuXFpIhqspl+LrXyhGTW7r/AFlqqr+
         vXTzX4+ozGzo03KEqoH+vzjVzidVpjQd6yFbyEMmzNsPJPIKIFTItdPPhIoglZcY2kpP
         GDDYZLg9L5+DnthyY9kw98npLGsg8BXbynM/F8g2No5pQCovaN7N7obu95NQhLmL2bUo
         uelmdJevCMw0oVGEvY5BjDZRpdCPPwn7NCUMesY1+yPwg7YQCEpLrdCkhZx/6Rym1OBZ
         +MPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681477962; x=1684069962;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2Uom6lc4AWGfEj6FlZegDGpqslLO6mugP8+4t00eUbk=;
        b=MB3vVVVARGXP3kCQS+58vWX/P9qPfDqbp5IpMFPCpQtI2TCQFFsk6/81NKSnos5a92
         tmeaY4JMW4JRvzcm7gtF6Xst0pX3EgM7Hx6fhvOnhgTKk5QLbU+NkEUzBVcpbDNtutJk
         Ll7Ujs6IQCGy4qYaRpocBz8pEYl2hvf980OYyHKjRpe0/wOP4g7+AmhMghq7nLXcpl6L
         2u4xP6sGMD5+pf87sIgAhleyMKiGJGoSszm1gK9C9USwHpJCSXxQXGiRDYx2+MEw04rs
         hK8iVo4JPWLooIcZuFJc73K3+Bl9OYmDvcVZTgwvTh3lR/7x2PK3CQC3GDlWmbuebeoM
         VNJg==
X-Gm-Message-State: AAQBX9ecKHYWZEjgJHyO0RVnXbvtR+aYjUi5ixsJBn2yUjYviauOY5s8
        5sjWkv5Zsn0Z62f9KnXSItaqStRqg/c=
X-Google-Smtp-Source: AKy350bQ919IQYOcCLpYeV47FFJjr0wzWWGdFepcMolluF6PUo9O5lgrLH8PBiKun80jqf64z4Q3oQ==
X-Received: by 2002:aa7:cd56:0:b0:4fb:59bb:ce71 with SMTP id v22-20020aa7cd56000000b004fb59bbce71mr5550074edw.36.1681477962047;
        Fri, 14 Apr 2023 06:12:42 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:5dfa])
        by smtp.gmail.com with ESMTPSA id u11-20020aa7d98b000000b004ad601533a3sm2097486eds.55.2023.04.14.06.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 06:12:41 -0700 (PDT)
Message-ID: <44420e92-f629-f56e-f930-475be6f6a83a@gmail.com>
Date:   Fri, 14 Apr 2023 14:12:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH RFC] io_uring: Pass whole sqe to commands
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Breno Leitao <leitao@debian.org>
Cc:     axboe@kernel.dk, davem@davemloft.net, dccp@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com, io-uring@vger.kernel.org,
        kuba@kernel.org, leit@fb.com, linux-kernel@vger.kernel.org,
        marcelo.leitner@gmail.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, netdev@vger.kernel.org, pabeni@redhat.com,
        willemdebruijn.kernel@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <20230406165705.3161734-1-leitao@debian.org>
 <ZDdvcSKLa6ZEAhRW@ovpn-8-18.pek2.redhat.com> <ZDgyPL6UrX/MaBR4@gmail.com>
 <ZDi2pP4jgHwCvJRm@ovpn-8-21.pek2.redhat.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZDi2pP4jgHwCvJRm@ovpn-8-21.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/23 03:12, Ming Lei wrote:
> On Thu, Apr 13, 2023 at 09:47:56AM -0700, Breno Leitao wrote:
>> Hello Ming,
>>
>> On Thu, Apr 13, 2023 at 10:56:49AM +0800, Ming Lei wrote:
>>> On Thu, Apr 06, 2023 at 09:57:05AM -0700, Breno Leitao wrote:
>>>> Currently uring CMD operation relies on having large SQEs, but future
>>>> operations might want to use normal SQE.
>>>>
>>>> The io_uring_cmd currently only saves the payload (cmd) part of the SQE,
>>>> but, for commands that use normal SQE size, it might be necessary to
>>>> access the initial SQE fields outside of the payload/cmd block.  So,
>>>> saves the whole SQE other than just the pdu.
>>>>
>>>> This changes slighlty how the io_uring_cmd works, since the cmd
>>>> structures and callbacks are not opaque to io_uring anymore. I.e, the
>>>> callbacks can look at the SQE entries, not only, in the cmd structure.
>>>>
>>>> The main advantage is that we don't need to create custom structures for
>>>> simple commands.
>>>>
>>>> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>>> ---
>>>
>>> ...
>>>
>>>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>>>> index 2e4c483075d3..9648134ccae1 100644
>>>> --- a/io_uring/uring_cmd.c
>>>> +++ b/io_uring/uring_cmd.c
>>>> @@ -63,14 +63,15 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
>>>>   int io_uring_cmd_prep_async(struct io_kiocb *req)
>>>>   {
>>>>   	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>>>> -	size_t cmd_size;
>>>> +	size_t size = sizeof(struct io_uring_sqe);
>>>>   
>>>>   	BUILD_BUG_ON(uring_cmd_pdu_size(0) != 16);
>>>>   	BUILD_BUG_ON(uring_cmd_pdu_size(1) != 80);
>>>>   
>>>> -	cmd_size = uring_cmd_pdu_size(req->ctx->flags & IORING_SETUP_SQE128);
>>>> +	if (req->ctx->flags & IORING_SETUP_SQE128)
>>>> +		size <<= 1;
>>>>   
>>>> -	memcpy(req->async_data, ioucmd->cmd, cmd_size);
>>>> +	memcpy(req->async_data, ioucmd->sqe, size);
>>>
>>> The copy will make some fields of sqe become READ TWICE, and driver may see
>>> different sqe field value compared with the one observed in io_init_req().
>>
>> This copy only happens if the operation goes to the async path
>> (calling io_uring_cmd_prep_async()).  This only happens if
>> f_op->uring_cmd() returns -EAGAIN.
>>
>>            ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>>            if (ret == -EAGAIN) {
>>                    if (!req_has_async_data(req)) {
>>                            if (io_alloc_async_data(req))
>>                                    return -ENOMEM;
>>                            io_uring_cmd_prep_async(req);
>>                    }
>>                    return -EAGAIN;
>>            }
>>
>> Are you saying that after this copy, the operation is still reading from
>> sqe instead of req->async_data?
> 
> I meant that the 2nd read is on the sqe copy(req->aync_data), but same
> fields can become different between the two READs(first is done on original
> SQE during io_init_req(), and second is done on sqe copy in driver).
> 
> Will this kind of inconsistency cause trouble for driver? Cause READ
> TWICE becomes possible with this patch.

Right it might happen, and I was keeping that in mind, but it's not
specific to this patch. It won't reload core io_uring bits, and all
fields cmds use already have this problem.

Unless there is a better option, the direction we'll be moving in is
adding a preparation step that should read and stash parts of SQE
it cares about, which should also make full SQE copy not
needed / optional.

>> If you have an example of the two copes flow, that would be great.
> 
> Not any example yet, but also not see any access on cmd->sqe(except for cmd_op)
> in your patches too.

-- 
Pavel Begunkov
