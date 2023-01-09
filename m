Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04FCF663280
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 22:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbjAIVOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 16:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238168AbjAIVNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 16:13:39 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AC8FCE8
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 13:11:09 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m3so7290900wmq.0
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 13:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DlA17XMkRQ3G/hL7VKUijED0fsrDm5Yt+UT5dD35GJo=;
        b=LTHiQK5XMYshftFvzm9RMsuxogW9AYfXM1Q+tKsM5lPIm6QG5JdjGUEAEZtbv6ieX/
         ah9SwX7cuLzGSW5jATu6QmFkTuj5WzQH4GLCnQAkACy/D+1gKaxN3zr2+Jl7eonuuEfp
         hCKswKld/iGw4A2KXY3UyDv5lqUVZ8mhg47o1mcY00TQjZYvOEyI+HAAwqGqQA/GW6x5
         Rcx0SlCegOZ87Q6kOVpVdku+4m5n9uDw1UoSV+pF6Gn1vAjSsFhrK0GZyfb/wtVtXdFh
         ORmppBOSWyDXpJKfWK142PYbPlextM1YxXyXztdm7ZU4cRYn/Q1glrAzBgJha2LOw+OQ
         axUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DlA17XMkRQ3G/hL7VKUijED0fsrDm5Yt+UT5dD35GJo=;
        b=1G6tVrSnf/C7CX05JkpYUAdIdl8ikCp5WShXsEX25BoPLO1z30v5CKsOW4N6tHhHl+
         4/i02yGXfHAe25Qr2tt0UGcDhNA304lTPt9MtwiszwgswxJodheXG1QmlxdymZ87mN9f
         t6d0BZFt6BX5XOS9ZJQU2/rTBTMnf8IclOh5sjGuVEYyZbvVPhcDr9JkjaoojNzoroc4
         U2OjmyqKEC8Ti7SF+AtvbTORGQVaTR6JbPk2RUoA28Mbw68MR+hIXXR20eTBHNneiy4A
         +jGIJQ1KY+t2JvXndyKCDYNz0T/ffgr7Q7d3Edtsk8Hinw5jvRzvhdnI3lsu072xdKSn
         bPHA==
X-Gm-Message-State: AFqh2krqI8eP7lD+MBXWfTKKUjx3s3nuWTe9WKFaJCEK+UmWTGgpTMq2
        1al5099iaXn9fp9F7hAsdfIbWg==
X-Google-Smtp-Source: AMrXdXvXvVWh7v2Y+09IuHVn5r2jjGjJooZDIKTsfTB+CEZp1MoiD3i778lPZ9vlkKefpikM6Esi9Q==
X-Received: by 2002:a05:600c:5116:b0:3d9:f296:1adc with SMTP id o22-20020a05600c511600b003d9f2961adcmr2663076wms.33.1673298668398;
        Mon, 09 Jan 2023 13:11:08 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t19-20020a0560001a5300b002362f6fcaf5sm9403005wry.48.2023.01.09.13.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 13:11:07 -0800 (PST)
Message-ID: <a947f2fa-3de8-0e38-87fc-e5d80451ef90@arista.com>
Date:   Mon, 9 Jan 2023 21:11:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/5] crypto: Introduce crypto_pool
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Bob Gilligan <gilligan@arista.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20230103184257.118069-1-dima@arista.com>
 <20230103184257.118069-2-dima@arista.com>
 <20230106175326.2d6a4dcd@kernel.org>
 <00e43ac2-6238-79a2-d9cb-8c42208594d8@arista.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <00e43ac2-6238-79a2-d9cb-8c42208594d8@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/23 20:59, Dmitry Safonov wrote:
> Hi Jakub,
> 
> Thanks for taking a look and your review,
> 
> On 1/7/23 01:53, Jakub Kicinski wrote:
[..]
>>> +static int crypto_pool_scratch_alloc(void)
>>
>> This isn't called by anything in this patch..
>> crypto_pool_alloc_ahash() should call it I'm guessing?
> 
> Ah, this is little historical left-over: in the beginning, I used
> constant-sized area as "scratch" buffer, the way TCP-MD5 does it.
> Later, while converting users to crypto_pool, I found that it would be
> helpful to support simple resizing as users have different size
> requirement to the temporary buffer, i.e. looking at xfrm_ipcomp, if
> later it would be converted to use the same API, rather than its own:
> IPCOMP_SCRATCH_SIZE is huge (which may help to save quite some memory if
> shared with other crypto_pool users: as the buffer is as well protected
> by bh-disabled section, the usage pattern is quite the same).
> 
> In patch 2 I rewrote it for crypto_pool_reserve_scratch(). The purpose
> of patch 2 was to only add dynamic up-sizing of this buffer to make it
> easier to review the change. So, here are 2 options:
> - I can move scratch area allocation/resizing/freeing to patch2 for v3
> - Or I can keep patch 2 for only adding the resizing functionality, but
> in patch 1 make crypto_pool_scratch_alloc() non-static and to the header
> API.
> 
> What would you prefer?

Taking the question off: in v3 I'll provide "size" as another argument
in patch 2 (the way you suggested it in review for patch 2). That way
dynamic allocation would be still separated in patch 2.

Thanks,
          Dmitry
