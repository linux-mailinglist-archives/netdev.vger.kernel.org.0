Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551476A1569
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjBXDdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBXDdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:33:41 -0500
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B061A4ECC5;
        Thu, 23 Feb 2023 19:33:36 -0800 (PST)
Received: by mail-qt1-x844.google.com with SMTP id s12so13471338qtq.11;
        Thu, 23 Feb 2023 19:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KnIcmPbufx/Eg74VQm53iu46gZIk4wBPQ48Df3prIiQ=;
        b=XfPRZw/xRxmDednv0MA0reuILbvR+ViF+tIuBGScZJ7QTOM84/LR3+RgP406eDF0K3
         b5d55viBPSS1rlFQ1Rze3FTr2kgI+r3pVhASgXyz9IqB2fNsdLpNaXqAi+s4xAcS4yta
         mztzx978gFUV9v85SdcwRw2eQH6ryXIBOTGoGZ9SV+kVXyguJkPihhcF5fxfX3TyX3KN
         FEKNLBoXwNRK5HrUv/eJvhcV7MZ4E/1NpNL9dbH69AT75mEU6F8NfYtYfZr4wzW03NDb
         SdrJJuloOb9ki+LNN0BR4pzAhqcNyLfu7yZ0o4Svi8CWjx6ams4kNiXU8k27Z+CnlWbR
         A54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KnIcmPbufx/Eg74VQm53iu46gZIk4wBPQ48Df3prIiQ=;
        b=BHtz6cuEC5gXs39bLgG+vxu/uVVsHlekLmmocHq96pWHvNyvosbymOMYuiskcNA2op
         ZgklZgh+ixxt8yU55/Y7Gb48i0sJrtpPCJSkjLGQulLdg1t0QefW+zHZyGP85/Z8Vrkq
         Zzqo3rY/0FPkgqjMLOetqX5lSxeRE9eSFf4/AjRPwTUAPI2tTo1ZxecgNB8OZHcTOnCT
         GNtPgCiRIyvOFOOLS7IDWfcpNLYvpr1t8toCnITXHRZCPJti2YEAZy8KXKOHxLhtUnKM
         ruhXzB8g70zNeGOC6tZY3omtAKMU2RvOveHA6uKFR4rzq+5lZvRiHib+iQCtYgewT0uU
         EJkQ==
X-Gm-Message-State: AO0yUKWDkVMTzsFkuG17qBMUCRmg1xdZqs41K0qXU8opKqPHhUbA7+QJ
        M154NGfQUGabtXp3XBoIb6M=
X-Google-Smtp-Source: AK7set/EB9C5pGBeupjSFP9ZWKtq1uIwkPYAd9pJtk5Y30J7QIaE8ts30bnSENwZr8AMV3AZ/pU44g==
X-Received: by 2002:a05:622a:48a:b0:3bf:b510:878d with SMTP id p10-20020a05622a048a00b003bfb510878dmr6870757qtx.4.1677209615896;
        Thu, 23 Feb 2023 19:33:35 -0800 (PST)
Received: from [127.0.0.1] ([103.152.220.17])
        by smtp.gmail.com with ESMTPSA id n129-20020a37bd87000000b0073b81e888bfsm5788107qkf.56.2023.02.23.19.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 19:33:35 -0800 (PST)
Message-ID: <04c4d6ee-f893-5248-26cf-2c6d1c9b3aa5@gmail.com>
Date:   Fri, 24 Feb 2023 11:33:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] net: tls: fix possible info leak in
 tls_set_device_offload()
From:   Hangyu Hua <hbh25y@gmail.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230223090508.443157-1-hbh25y@gmail.com> <Y/dK6OoNpYswIqrD@hog>
 <310391ea-7c71-395e-5dcb-b0a983e6fc93@gmail.com>
Content-Language: en-US
In-Reply-To: <310391ea-7c71-395e-5dcb-b0a983e6fc93@gmail.com>
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

On 24/2/2023 11:07, Hangyu Hua wrote:
> On 23/2/2023 19:15, Sabrina Dubroca wrote:
>> 2023-02-23, 17:05:08 +0800, Hangyu Hua wrote:
>>> After tls_set_device_offload() fails, we enter tls_set_sw_offload(). But
>>> tls_set_sw_offload can't set cctx->iv and cctx->rec_seq to NULL if it 
>>> fails
>>> before kmalloc cctx->iv. This may cause info leak when we call
>>> do_tls_getsockopt_conf().
>>
>> Is there really an issue here?
>>
>> If both tls_set_device_offload and tls_set_sw_offload fail,
>> do_tls_setsockopt_conf will clear crypto_{send,recv} from the context.
>> Then the TLS_CRYPTO_INFO_READY in do_tls_getsockopt_conf will fail, so
>> we won't try to access iv or rec_seq.
>>
> 
> My bad. I forget memzero_explicit. Then this is harmless. But I still 
> think it is better to set them to NULL like tls_set_sw_offload's error 
> path because we don't know there are another way to do this(I will 
> change the commit log). What do you think?

Like a rare case, there is a race condition between
do_tls_getsockopt_conf and do_tls_setsockopt_conf while the previous
condition is met. TLS_CRYPTO_INFO_READY(crypto_info) is not
protected by lock_sock in do_tls_getsockopt_conf. It's just too
difficult to satisfy both conditions at the same time.
