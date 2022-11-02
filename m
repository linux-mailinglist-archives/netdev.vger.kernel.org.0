Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC20616B3E
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 18:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiKBRyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 13:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiKBRyu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 13:54:50 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDBE2EF10
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 10:54:49 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id r81so6975542iod.2
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 10:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lXvclno+jyQQctV09xCPun3dWMxNCv1weH6yrqWHinI=;
        b=zqZlL+Fvk1hgljzOk+cKOdGfyG5s6UgWQ0R2uYP7f1zx7xWSL9LqPAEdPfc/MoNEQZ
         t054ZJmE3YLCIwo+8p0hAnYOL0hwOK9fsdwzzC6AARht0XYURR4MXZvDqEttNbMyzmtb
         gyrUrw6TsdndnWktcASaBz66fG8BEzm5U1SfxulWpjOpclRyOtQmgKXjtH5ZGvU3/w5A
         Mr+ceiXmV6543B+HaGTxVYYxXFGJZ0TfE0BCtd5n5/xz7vai4DohQCtD0gZtPbSzJDna
         2CcaXgOE05XJ5sOwJdLdg+S3f4RAx8vMnCvTEiPpR+g0pGJ3fWdnmCs/+8ztBZ2i3H9e
         +c2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lXvclno+jyQQctV09xCPun3dWMxNCv1weH6yrqWHinI=;
        b=rjZ/JRSYU2ThGA6ll69alrN8EMDanY0M9GhwEMbx17jNrLujH/IWLFGXHLUGupJMRa
         rMIogPgrkWhUu57KsGtq3pM0Pw0TOPfQKv0CpIFISgpe7b6yJaAQ0zFepvMc+I4RNpSW
         UfP02t/7NXV0DeBPfp9wXrMQ9glAazwAXxgK7niPK4lbsKytwxS3h32Yis7XWhIsi83a
         wGKhLSu6Ed7PRQL5RmmetdJHHLa4aXILDZSuEkMm0u0U7lQ759uZ/LNtWtjirmHtmRPh
         Q3qOSGKBKhIs8O1vL9wBsARL/gz3p13JeIVcimi3rJsclTSExGUcpcltRwYElaae3iFx
         Te8A==
X-Gm-Message-State: ACrzQf0ucMj5rnvuq6f4UJF3V0igKntH5o55jaV7AnH560/9hwgLdOLQ
        qajHF4blcWjXzhcx/EDFsQXtzuuZS9MKwX2t
X-Google-Smtp-Source: AMsMyM7Uz7kyuV0u+yZfyJ0xx7p9CVYMaoTXa62eyRLqMmmQztWTvwWsKufxMYOeg7ol0y68bD+2iA==
X-Received: by 2002:a6b:5d11:0:b0:6c7:46be:4719 with SMTP id r17-20020a6b5d11000000b006c746be4719mr17248097iob.190.1667411688572;
        Wed, 02 Nov 2022 10:54:48 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b6-20020a05660214c600b006a129b10229sm3496263iow.31.2022.11.02.10.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:54:48 -0700 (PDT)
Message-ID: <02e5bf45-f877-719b-6bf8-c4ac577187a8@kernel.dk>
Date:   Wed, 2 Nov 2022 11:54:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20221030220203.31210-1-axboe@kernel.dk>
 <CA+FuTSfj5jn8Wui+az2BrcpDFYF5m5ehwLiswwHMPJ2MK+S_Jw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+FuTSfj5jn8Wui+az2BrcpDFYF5m5ehwLiswwHMPJ2MK+S_Jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/22 11:46 AM, Willem de Bruijn wrote:
> On Sun, Oct 30, 2022 at 6:02 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Hi,
>>
>> tldr - we saw a 6-7% CPU reduction with this patch. See patch 6 for
>> full numbers.
>>
>> This adds support for EPOLL_CTL_MIN_WAIT, which allows setting a minimum
>> time that epoll_wait() should wait for events on a given epoll context.
>> Some justification and numbers are in patch 6, patches 1-5 are really
>> just prep patches or cleanups.
>>
>> Sending this out to get some input on the API, basically. This is
>> obviously a per-context type of operation in this patchset, which isn't
>> necessarily ideal for any use case. Questions to be debated:
>>
>> 1) Would we want this to be available through epoll_wait() directly?
>>    That would allow this to be done on a per-epoll_wait() basis, rather
>>    than be tied to the specific context.
>>
>> 2) If the answer to #1 is yes, would we still want EPOLL_CTL_MIN_WAIT?
>>
>> I think there are pros and cons to both, and perhaps the answer to both is
>> "yes". There are some benefits to doing this at epoll setup time, for
>> example - it nicely isolates it to that part rather than needing to be
>> done dynamically everytime epoll_wait() is called. This also helps the
>> application code, as it can turn off any busy'ness tracking based on if
>> the setup accepted EPOLL_CTL_MIN_WAIT or not.
>>
>> Anyway, tossing this out there as it yielded quite good results in some
>> initial testing, we're running more of it. Sending out a v3 now since
>> someone reported that nonblock issue which is annoying. Hoping to get some
>> more discussion this time around, or at least some...
> 
> My main question is whether the cycle gains justify the code
> complexity and runtime cost in all other epoll paths.
> 
> Syscall overhead is quite dependent on architecture and things like KPTI.

Definitely interested in experiences from other folks, but what other
runtime costs do you see compared to the baseline?

> Indeed, I was also wondering whether an extra timeout arg to
> epoll_wait would give the same feature with less side effects. Then no
> need for that new ctrl API.

That was my main question in this posting - what's the best api? The
current one, epoll_wait() addition, or both? The nice thing about the
current one is that it's easy to integrate into existing use cases, as
the decision to do batching on the userspace side or by utilizing this
feature can be kept in the setup path. If you do epoll_wait() and get
-1/EINVAL or false success on older kernels, then that's either a loss
because of thinking it worked, or a fast path need to check for this
specifically every time you call epoll_wait() rather than just at
init/setup time.

But this is very much the question I already posed and wanted to
discuss...

-- 
Jens Axboe
