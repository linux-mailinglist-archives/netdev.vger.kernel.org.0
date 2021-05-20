Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBC738A9F9
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 13:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbhETLIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 07:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239401AbhETLGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 07:06:06 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2CFC0612F3;
        Thu, 20 May 2021 02:58:15 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id h3-20020a05600c3503b0290176f13c7715so4831135wmq.5;
        Thu, 20 May 2021 02:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VSSStV1UVW9GUULFLbeRmm9wy52EiHMU0utlA/8pnvE=;
        b=JY2ZSVUWiwcKXQ8VUM4s6Y3HI2Ap+urjh71RlhmLq2jwlRVqBrIM6xYVqrJ5mRpqra
         ync2ycExhxsHg7qzUjjq5ufVaQ78lN6ZOtubNzY5v/hhZOSRcFobXKJoHntIE3+36P+9
         8hneODynDFY0zI7ps+cGp8sJbw1M4wMG1fK0bvSL3rTf03w0kezyD9cn0hEL10GKJC4d
         8tu5VvhGheh7pUCKSoMFjiz7GvWMt6Lk4Jfjv31j/Aq5teZMUZuUhY26Z98M41I/L5q8
         vkFTUwGDliR6wy8VOIeWeMbyzjSnq359mhF+1HkyH+obQ9wxp/Z8D0cr8RshMkCTpBKW
         hunw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VSSStV1UVW9GUULFLbeRmm9wy52EiHMU0utlA/8pnvE=;
        b=kfdcgnpPO6ifp63oFHmwmWEj9vak+UbhOkm1q0MWnXnYKzQAs51ggnVeU1mjfS8SmK
         NWbU/FheeDTnvKRDWplkASlv0VZPYGyUzYIgW8l9okXFLnQFtkQGl7xuReNT5qv+KFof
         8dxybcIY7+2QfCKHN16yumRKtKQZzs92WFsBLoFJRd4YsCCZqJ9tAwFF1wtcw7gwt1iC
         07JuJ8t9e72o6pxnwmjUXIEtSxTMiDs3V/TmaaPCswiNFz3T1o8FNZH7tzciwLDhI3HJ
         xN0DCtcZ5mBuo6xob7kZ4JgC3mGcHQNQU17z8+YRIQRroML5+Dq9jGrBnB9DrRCsS7fh
         H2sQ==
X-Gm-Message-State: AOAM532dmo057kM5J6wYDgqsaDxWn8rNjKblVnO5kP7oeCxqNOcVIYi6
        tn+6CC8Hd3NgviNup54J+VY=
X-Google-Smtp-Source: ABdhPJzP8kx3ScHOA9Pi7EFe9kLW2SonhDbJXpzAM/zltPv+hDcrDwtwWVokCY64iOMP4L5vne6BNA==
X-Received: by 2002:a1c:4601:: with SMTP id t1mr2789609wma.27.1621504693981;
        Thu, 20 May 2021 02:58:13 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2810? ([2620:10d:c093:600::2:130f])
        by smtp.gmail.com with ESMTPSA id x10sm2561652wrt.65.2021.05.20.02.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 May 2021 02:58:13 -0700 (PDT)
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     io-uring@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B . Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>,
        Christian Dietrich <stettberger@dokucode.de>
References: <cover.1621424513.git.asml.silence@gmail.com>
 <94134844a6f4be2e0da2c518cb0e2e9ebb1d71b0.1621424513.git.asml.silence@gmail.com>
 <CAEf4BzZU_QySZFHA1J0jr5Fi+gOFFKzTyxrvCUt1_Gn2H6hxLA@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 18/23] libbpf: support io_uring
Message-ID: <d86035d9-66f0-de37-42ef-8eaa4d849651@gmail.com>
Date:   Thu, 20 May 2021 10:58:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZU_QySZFHA1J0jr5Fi+gOFFKzTyxrvCUt1_Gn2H6hxLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/21 6:38 PM, Andrii Nakryiko wrote:
> On Wed, May 19, 2021 at 7:14 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  tools/lib/bpf/libbpf.c | 7 +++++++
>>  1 file changed, 7 insertions(+)
>>
>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> index 4181d178ee7b..de5d1508f58e 100644
>> --- a/tools/lib/bpf/libbpf.c
>> +++ b/tools/lib/bpf/libbpf.c
>> @@ -13,6 +13,10 @@
>>  #ifndef _GNU_SOURCE
>>  #define _GNU_SOURCE
>>  #endif
>> +
>> +/* hack, use local headers instead of system-wide */
>> +#include "../../../include/uapi/linux/bpf.h"
>> +
> 
> libbpf is already using the latest UAPI headers, so you don't need
> this hack. You just haven't synced include/uapi/linux/bpf.h into
> tools/include/uapi/linux/bpf.h

It's more convenient to keep it local to me while RFC, surely will
drop it later.

btw, I had a problem with find_sec_def() successfully matching
"iouring.s" string with "iouring", because section_defs[i].len
doesn't include final \0 and so does a sort of prefix comparison.
That's why "iouring/". Can we fix it? Are compatibility concerns?

> 
>>  #include <stdlib.h>
>>  #include <stdio.h>
>>  #include <stdarg.h>
>> @@ -8630,6 +8634,9 @@ static const struct bpf_sec_def section_defs[] = {
>>         BPF_PROG_SEC("struct_ops",              BPF_PROG_TYPE_STRUCT_OPS),
>>         BPF_EAPROG_SEC("sk_lookup/",            BPF_PROG_TYPE_SK_LOOKUP,
>>                                                 BPF_SK_LOOKUP),
>> +       SEC_DEF("iouring/",                     IOURING),
>> +       SEC_DEF("iouring.s/",                   IOURING,
>> +               .is_sleepable = true),
>>  };
>>
>>  #undef BPF_PROG_SEC_IMPL
>> --
>> 2.31.1
>>

-- 
Pavel Begunkov
