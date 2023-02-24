Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEE36A18E1
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 10:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjBXJfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 04:35:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjBXJfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 04:35:20 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E03265CD6;
        Fri, 24 Feb 2023 01:35:09 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id c18so358246qte.5;
        Fri, 24 Feb 2023 01:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8s6o4CkNEdFG6GmMR0ELLlfRZdxakWUBLhovBwvl3eY=;
        b=LUVLB0d+18NvWtkYDtpkdc6YZWqSjg+9mGVsbd57ILSRQ/tGIzOR8YaC7gZqbbU6Gz
         O+P68Sl1ccTMLo9jh/fKEDEdFiQ6CLbpOrWRGkTEo5gwJbhEulfYILn/UGy0YFYxCeMq
         Mq029BpRyIlVhGufGwXtKT96IHg7VcMgT12bxftUV2VY19JfnuomrzKCQQgBCwDeMGK0
         PyzGNSaIEW3/p/bhAYcA43BUDd++XZ37WPDa4S32ala4lTuvZ+hrLcepxWQauZ5t/5Sc
         y2hzKrASCKsN+HhuWArbgac/EZdr9UBPlX2uAXnLLH6RqigZ9Q/7DeknkNRSvek7UlHj
         f6dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8s6o4CkNEdFG6GmMR0ELLlfRZdxakWUBLhovBwvl3eY=;
        b=ZVAp/PTYKg9j24IKY+IU7R+ZcDCqjCwZQxYX8oGcApIm+rXkOAB4IOK0YrmB0/rd3v
         CCqHu396GqOmBs1cyBb8jko3FWnJv7ON5tKsNb/shx9LFrHqG0pPn03XS0UR7bQ2bL+Y
         fBFHx5uezMkSVH6LDpaNxipjMdzwP7kifLnlcX9dDz2Wbp1SrzamX0csN/wSv2/MZFzR
         EOvqqZiFwmDj4VhXr/UtV8/T1Ck6XaeVq+mR6GuxkUj9nEmnfYGO5eavbOeeFjZmxDYo
         FkQuMl2lMkPh9ckB2osCjKAOzTGIWLsu6jzwsCCtc3hBjfXPKzRn0lC/UG/LMnEshS+V
         eD6A==
X-Gm-Message-State: AO0yUKXd3g4ok8gpp382E0s4AsObRnKdAm+YZMefgyF8nYsPxduJAM5d
        44FtWLxszD0jm2tL4YTU0fA=
X-Google-Smtp-Source: AK7set9zwJ3jd7pkf4NjfrtUgcWrmJbWmuQrD6SmZV2krTqnjJ2WbrvwojVMNguHhoWdya2ov5xm2w==
X-Received: by 2002:ac8:7e94:0:b0:3b9:fc92:a6 with SMTP id w20-20020ac87e94000000b003b9fc9200a6mr32012483qtj.6.1677231308597;
        Fri, 24 Feb 2023 01:35:08 -0800 (PST)
Received: from [127.0.0.1] ([103.152.220.17])
        by smtp.gmail.com with ESMTPSA id t18-20020a37aa12000000b006bb82221013sm5719992qke.0.2023.02.24.01.35.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 01:35:07 -0800 (PST)
Message-ID: <22948c58-d9df-1326-a849-4278d14f76b5@gmail.com>
Date:   Fri, 24 Feb 2023 17:35:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: tls: fix possible info leak in
 tls_set_device_offload()
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230223090508.443157-1-hbh25y@gmail.com> <Y/dK6OoNpYswIqrD@hog>
 <310391ea-7c71-395e-5dcb-b0a983e6fc93@gmail.com>
 <04c4d6ee-f893-5248-26cf-2c6d1c9b3aa5@gmail.com> <Y/ht6gQL+u6fj3dG@hog>
Content-Language: en-US
From:   Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <Y/ht6gQL+u6fj3dG@hog>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/2/2023 15:57, Sabrina Dubroca wrote:
> 2023-02-24, 11:33:29 +0800, Hangyu Hua wrote:
>> On 24/2/2023 11:07, Hangyu Hua wrote:
>>> On 23/2/2023 19:15, Sabrina Dubroca wrote:
>>>> 2023-02-23, 17:05:08 +0800, Hangyu Hua wrote:
>>>>> After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
>>>>> tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL
>>>>> if it fails
>>>>> before kmalloc cctx->iv. This may cause info leak when we call
>>>>> do_tls_getsockopt_conf().
>>>>
>>>> Is there really an issue here?
>>>>
>>>> If both tls_set_device_offload and tls_set_sw_offload fail,
>>>> do_tls_setsockopt_conf will clear crypto_{send,recv} from the context.
>>>> Then the TLS_CRYPTO_INFO_READY in do_tls_getsockopt_conf will fail, so
>>>> we won't try to access iv or rec_seq.
>>>>
>>>
>>> My bad. I forget memzero_explicit. Then this is harmless. But I still
>>> think it is better to set them to NULL like tls_set_sw_offload's error
>>> path because we don't know there are another way to do this(I will
>>> change the commit log). What do you think?
> 
> Yes, I guess for consistency between functions it would be ok.
> 
>> Like a rare case, there is a race condition between
>> do_tls_getsockopt_conf and do_tls_setsockopt_conf while the previous
>> condition is met. TLS_CRYPTO_INFO_READY(crypto_info) is not
>> protected by lock_sock in do_tls_getsockopt_conf. It's just too
>> difficult to satisfy both conditions at the same time.
> 
> Ugh, thanks for noticing this. We should move the lock_sock in
> getsockopt before TLS_CRYPTO_INFO_READY. Do you want to write that
> patch?
> 
> Thanks.
> 

I see. I will make a new patch to fix the race and send v2 of this.

Thanks,
Hangyu
