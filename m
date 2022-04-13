Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CB74FFF3B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 21:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238335AbiDMT3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 15:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238322AbiDMT3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 15:29:40 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA6A72E28
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 12:27:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso3340262pjh.3
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 12:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ulZD6zNnI3E2tVgbP2ay2zB6j2x9YR9+l3/69/Ua3pA=;
        b=JLd5puMQf6492ML/dyNY6TKWLx7/9ZIuCpo4/MdsTOmTLArTtUAHSBUUksMMpNsbUg
         JKoMefN2Xhc4AQ40Oj/ty6rADytP+hgT6kUGvT/+DME34D1YFAeq1NkGOZwC2LD/nH7A
         UROiFTo0esSJrW/PMu2+jyzk+RilmC4re7wIb6Zj+9vn95TEcRuBhlxaxDMhY3k2FK9Z
         JF9sAJzfofpZ9TQMjkyuueU/pkYZfnd4WssWZzBXW8PLxVwodjar5qU85Jw0zbjCixvV
         UNSLduY+bWJgbHcYb6l5xShpVPyjY5c/TLwd1mNzgdN8nvRmYBPxs/1Sb65pSM4TrGJT
         8Ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ulZD6zNnI3E2tVgbP2ay2zB6j2x9YR9+l3/69/Ua3pA=;
        b=rBf4o7A3aZyy9Y7zpS9FfGL5cfgGphw3idhjTmnIziP4hcIFJ3qreiyFQ/z/8T7kQY
         2SLqv+yB88VDpOsu0+2KIgNeX4/gFVEgECZEEME1KFMtZszktDpJVjRjwnauVxExW8z1
         C9jpy8HTuzIP9vx3teyvOos/vTjDQE5FakAUScuaU6sBPM6X3HPCrxuH1jrLcygfH5zn
         s6j54q6NSB1ELhTm7j1ZmFVKZJZ0B4FCO2thzCE7/R1xe46M6YIViADAAqqKPH2EM7HR
         Xr/fYWQVnyKlYiQOIeQZxMRLvwR5bdsmeKyPWj0JHaIsQSHUxR9uBe7ljYAxEbER3IwX
         xOJA==
X-Gm-Message-State: AOAM532NvgU0qyqNPM7qAf4h/8YzhiyuWjyHsfcChyTBN0XNZimOS5k+
        2x2GzwxYLSqj1HCvdBZSLtoQzQj3FUpcO2yC
X-Google-Smtp-Source: ABdhPJy2l1eOffJSFsfUgH2fvADP0aGuwJ8njCIdXBZ9pzOEzXCNNM+Oyp4lX76nDUJdDBeupVp7HA==
X-Received: by 2002:a17:90a:454a:b0:1ca:91c7:df66 with SMTP id r10-20020a17090a454a00b001ca91c7df66mr288235pjm.186.1649878036766;
        Wed, 13 Apr 2022 12:27:16 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id v16-20020aa78090000000b0050583cb0adbsm18978259pff.196.2022.04.13.12.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 12:27:16 -0700 (PDT)
Message-ID: <bb29d766-f837-195e-63cc-15d02f155f2c@linaro.org>
Date:   Wed, 13 Apr 2022 12:27:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
References: <20220405170356.43128-1-tadeusz.struk@linaro.org>
 <CAEf4BzaPmp5TzNM8U=SSyEp30wv335_ZxuAL-LLPQUZJ9OS74g@mail.gmail.com>
 <e7692d0b-e495-8d3e-4905-c4109bf5caa4@linaro.org>
 <CAEf4Bzbb+AmuABH2cw=48uuznz7bT=eEMc1V9mS3GSqgU664Tw@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <CAEf4Bzbb+AmuABH2cw=48uuznz7bT=eEMc1V9mS3GSqgU664Tw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/13/22 12:07, Andrii Nakryiko wrote:
>> it would be ideal if detach would never fail, but it would require some kind of
>> prealloc, on attach maybe? Another option would be to minimize the probability
> We allocate new arrays in update_effective_progs() under assumption
> that we might need to grow the array because we use
> update_effective_progs() for attachment. But for detachment we know
> that we definitely don't need to increase the size, we need to remove
> existing element only, thus shrinking the size.
> 
> Normally we'd reallocate the array to shrink it (and that's why we use
> update_effective_progs() and allocate memory), but we can also have a
> fallback path for detachment only to reuse existing effective arrays
> and just shift all the elements to the right from the element that's
> being removed. We'll leave NULL at the end, but that's much better
> than error out. Subsequent attachment or detachment will attempt to
> properly size and reallocate everything.
> 
> So I think that should be the fix, if you'd be willing to work on it.

That makes it much easier then. I will change it so that there is no
alloc needed on the detach path. Thanks for the clarification.

-- 
Thanks,
Tadeusz
