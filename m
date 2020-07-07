Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B71217B22
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 00:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbgGGWnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 18:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbgGGWnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 18:43:07 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D85BC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 15:43:07 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v8so44877310iox.2
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 15:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iDT2wQ6J4h+87qDBUhlp4TuMhMXrSWXEfWUyXKkkJng=;
        b=uhrH/HCtZSwkpWLUY/Df5afxBCSCudrmeuxMlf9H7haYNfkzvxC0Z+it2xpaI5ioWc
         rGYX5nCkVcFKtno6kYuGaw52mIgV9gw5R4UE1Ow0WkFVsznxzJNwPjmjz/PGGKSfjuRW
         gc7A4EmTabwcKvVbvozWLADmltK1cKUqf280/LPglIPA+Gq7sRKcRhnUpOD6ANNdowBP
         kFVHLbUhXjNYYmgoGYDHUlEwzo9ih0OMdwJryFc7f8/UK79qy0f+itHEx8CG38XZbxVz
         9b/wzypkxaq/S8rmBu9GkHrslCKBMJZwtB3sR6Un5Lw5YNPQYJ5/ZG1jX0ZyEVdL0RzW
         gRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iDT2wQ6J4h+87qDBUhlp4TuMhMXrSWXEfWUyXKkkJng=;
        b=OtWANSJzuVHyqqOOSOQ4V4/c74qGmuKAiFoXlYokazpQt05VbzMVGwknROEOansgGX
         ew87VDec/nhELafhp8dX9qO+rhQI23fFitC1TYpDYiMzjxv/4WHDyQ0kwRjbAgA6Vm6y
         VKUmPzSp2aePvxt5SUdknLlaEiTdFnfh09lK58YW+/bpBW1VlileDxsHjx5RSFdQLaDI
         qwlmAZQP4U5tjcCtVWGj4Hd6Ne/ZmqcHmco2seL89dPdxz+rW/tfSMP4YHx/CtbtsiXY
         s55TVK9MdP4966V3d2qYXPnTZ0Wtz+Brfq4Ct2NiIGqAigutNMRwQgTdhYWkv71xnjP4
         IxyA==
X-Gm-Message-State: AOAM530J4V1Lt7DwF5UQqofxZhqOWxhFREGGKpRaxtPW7S9E1Q3vWWjT
        AE3sftbIZrAC5hq6N1+wa+RI+g==
X-Google-Smtp-Source: ABdhPJzMRtkce+ggsdgfwSlBshSpV7Ueb655JwaMnFpFZEsNymVNcYYmcDwgllaQDUGKlyJf64kZOg==
X-Received: by 2002:a02:9182:: with SMTP id p2mr15366024jag.69.1594161786763;
        Tue, 07 Jul 2020 15:43:06 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id t83sm14076997ilb.47.2020.07.07.15.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 15:43:06 -0700 (PDT)
Subject: Re: [PATCH] bitfield.h: don't compile-time validate _val in FIELD_FIT
To:     Nick Desaulniers <ndesaulniers@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20200707211642.1106946-1-ndesaulniers@google.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <bca8cff8-3ffe-e5ab-07a5-2ab29d5e394a@linaro.org>
Date:   Tue, 7 Jul 2020 17:43:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200707211642.1106946-1-ndesaulniers@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/20 4:16 PM, Nick Desaulniers wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> When ur_load_imm_any() is inlined into jeq_imm(), it's possible for the
> compiler to deduce a case where _val can only have the value of -1 at
> compile time. Specifically,
> 
> /* struct bpf_insn: _s32 imm */
> u64 imm = insn->imm; /* sign extend */
> if (imm >> 32) { /* non-zero only if insn->imm is negative */
>   /* inlined from ur_load_imm_any */
>   u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
>   if (__builtin_constant_p(__imm) && __imm > 255)
>     compiletime_assert_XXX()
> 
> This can result in tripping a BUILD_BUG_ON() in __BF_FIELD_CHECK() that
> checks that a given value is representable in one byte (interpreted as
> unsigned).

Why does FIELD_FIT() pass an unsigned long long value as the second
argument to __BF_FIELD_CHECK()?  Could it pass (typeof(_mask))0 instead?
It wouldn't fix this particular case, because UR_REG_IMM_MAX is also
defined with that type.  But (without working through this in more
detail) it seems like there might be a solution that preserves the
compile-time checking.

A second comment about this is that it might be nice to break
__BF_FIELD_CHECK() into the parts that verify the mask (which
could be used by FIELD_FIT() here) and the parts that verify
other things.

That's all--just questions, I have no problem with the patch...

					-Alex




> FIELD_FIT() should return true or false at runtime for whether a value
> can fit for not. Don't break the build over a value that's too large for
> the mask. We'd prefer to keep the inlining and compiler optimizations
> though we know this case will always return false.
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/kernel-hardening/CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com/
> Reported-by: Masahiro Yamada <masahiroy@kernel.org>
> Debugged-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  include/linux/bitfield.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index 48ea093ff04c..4e035aca6f7e 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -77,7 +77,7 @@
>   */
>  #define FIELD_FIT(_mask, _val)						\
>  	({								\
> -		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");	\
> +		__BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");	\
>  		!((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
>  	})
>  
> 

