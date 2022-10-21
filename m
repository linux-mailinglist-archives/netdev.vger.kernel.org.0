Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFB960740B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 11:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJUJ3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 05:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiJUJ3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 05:29:16 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A82256D07;
        Fri, 21 Oct 2022 02:29:14 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id fn7-20020a05600c688700b003b4fb113b86so1623122wmb.0;
        Fri, 21 Oct 2022 02:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rf1k8lYJgn57jYuLmMC2icxUs3x2enShBCfAlKAkR7A=;
        b=fm37/7vjefA8ysttRTGX83pDn4nNsTv4IsN5kCmkkphdNC+ERlF/8A2Bucq+fFfmr0
         6NF4C2yVuIeodUdAl4I516qfs5K0htYMuFKHtU9ucGIzii3+mHMYFZqbFX/WcAwjsWjl
         sjF7V5109M/UjVfCeu3h6mzgC63G5/Vs68ARZY4xhn90m1HB8WQRoLMYCZHSJSm3Gq/N
         Ta10yBYg6Zrfo3DWjloG17oIMuIxADgcjkD2vI7ofjhP7oeFtLjFHJm+GM6IrEx6Yenl
         0AAOj2MSxfKkqnk6UgjRb0JApiAjDIs2Osg71r9QO40ItwuS/AUeC0tQSuSgFuyrux/I
         WW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rf1k8lYJgn57jYuLmMC2icxUs3x2enShBCfAlKAkR7A=;
        b=J6EIY7upHSvwtU/fSzLEN4FgrrWqa5QZriI5jkVyHxKYbcUT4ePZ9gkbJyHiC6OMu/
         XZPXdjPE94M2gjwBr8JFz7b4i7IwGwBaOblEdWrwcsmn50MsrSuvqHwRTokDBDiOGgY/
         eMRjjnhyXroBq7QF0i5t4hgsk6HL8UNDLqCWAjG7eYKGwhtT94j7HIwrpMqXL1hTXFUF
         ucD20PMHqbFNK019mc2+JtS/27gkjQwkfuYV+G9QVuYcXNGYgeilxC5d3I9k3j6uTqxZ
         8TSW1qlMbnpDcLAQMPJDgNNSdF1ci96OJqyi0fE9DpaQkPnnWNq3RP9szVvIQussYxr9
         omsg==
X-Gm-Message-State: ACrzQf0/RSEZwOs0ObRYv1t8S9YUwLKqu0yCgMlrpCsSh1Cxr6mQJdUl
        cTBHj5qEdJjf4TcvCAsHQEU=
X-Google-Smtp-Source: AMsMyM7BURJrg9mwLvk3bnYDfRdOIvTvYg5kKqeBtre04hx5gAQH1I+RHsG+Tlt0UEeFwX1ttkFpvw==
X-Received: by 2002:a05:600c:3585:b0:3c7:9f:5f87 with SMTP id p5-20020a05600c358500b003c7009f5f87mr11731336wmq.76.1666344553259;
        Fri, 21 Oct 2022 02:29:13 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:f27e])
        by smtp.gmail.com with ESMTPSA id r12-20020adff10c000000b00225239d9265sm18691728wro.74.2022.10.21.02.29.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Oct 2022 02:29:12 -0700 (PDT)
Message-ID: <fc3967d3-ef72-7940-2436-3d8aa329151e@gmail.com>
Date:   Fri, 21 Oct 2022 10:27:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_SEND_NOTIF_USER_DATA (was Re: IORING_CQE_F_COPIED)
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <3e7b7606-c655-2d10-f2ae-12aba9abbc76@samba.org>
 <ae88cd67-906a-7c89-eaf8-7ae190c4674b@gmail.com>
 <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <86763cf2-72ed-2d05-99c3-237ce4905611@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/22 09:32, Stefan Metzmacher wrote:
> Hi Pavel,
> 
>>>>> Experimenting with this stuff lets me wish to have a way to
>>>>> have a different 'user_data' field for the notif cqe,
>>>>> maybe based on a IORING_RECVSEND_ flag, it may make my life
>>>>> easier and would avoid some complexity in userspace...
>>>>> As I need to handle retry on short writes even with MSG_WAITALL
>>>>> as EINTR and other errors could cause them.
>>>>>
>>>>> What do you think?
>>>
>>> Any comment on this?
>>>
>>> IORING_SEND_NOTIF_USER_DATA could let us use
>>> notif->cqe.user_data = sqe->addr3;
>>
>> I'd rather not use the last available u64, tbh, that was the
>> reason for not adding a second user_data in the first place.
> 
> As far as I can see io_send_zc_prep has this:
> 
>          if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>                  return -EINVAL;
> 
> both are u64...

Hah, true, completely forgot about that one

-- 
Pavel Begunkov
