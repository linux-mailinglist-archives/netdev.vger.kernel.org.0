Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA308218E4B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgGHRe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbgGHRe6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 13:34:58 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6613EC08C5CE
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 10:34:58 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id c16so47892965ioi.9
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 10:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zLKC9vCuP+0+ZHlPXvxcA1zETxTIZYeLA2rBbTPawr0=;
        b=nggXASSCBPnyKnKUY8T79x3qUvCZWBMwyq3Cmqc0AHy/yZZisnOVi8TdVZlPv9KfXv
         KNsSC5B9z+U/qmX8ayljVaZYCP9n+fggsJ7naeh4tVFYuI3f7aJpkLHUaqYo+PHyyWVD
         T09lT3/G2rljd9xYIwduBqdsOXUf7qzf039kcjk86ENDnL5d+MlZFxkPITAvDq4otK+t
         OUEobIEJRRX6PE6sIItdc+XTSpbKZI7QpB63uXdi0k17vF/B+Jjw6w2laZTA+t3umftj
         PG0wA5f2gHEJOqERB2+ykGYRcfVfC6p8qr1FKg1g0D7gl9FB90uhcqSPCLgBZYZlSP8Y
         1bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zLKC9vCuP+0+ZHlPXvxcA1zETxTIZYeLA2rBbTPawr0=;
        b=fLK1dfKYCTEP6jJzxsIGHby8mV1SfbU3u9Bt/f41yImAxodFMadrHaiQ1pgXTWsF3o
         Wkp+4kXxdBU4O/duLSBVzfiu/If2sk1Lx2EfI0Xl56RuJxEES8JeHQmHV0Bgezqs2qiQ
         v1x5XQHljcBSfJ0fClLGWp89GO9giqr36B5wVQpJOEbmyJhydTxbZC/lvz0MrQGEAj/N
         /w3NqSH784MmURMR4z+mqZUpnKBgSDNKmRiBUrh5xca0Tg/Vc0Bt8x0ylUH6ND48PFIp
         jG5SC0U2sgzL5TZRgPSZgR5O1NNmd5EN/KYHfu7oUW0USE6BpudG+UBXd8irNyY7bSK/
         DpgA==
X-Gm-Message-State: AOAM530KTZXKHs4W+2d7aW+Vjcz9P/gHtcXAJV1KuXtTpgE55GBzsCKL
        CKo4HK4p5IyPFxYp+f0EK1nIPA==
X-Google-Smtp-Source: ABdhPJy0iulJB16XXJAiaZwMv0YZkwCgg4LJ+sSh7yV54pdnKzVymyNPKH2g+EHuiK7ROEwCbWAcIA==
X-Received: by 2002:a05:6602:21c3:: with SMTP id c3mr35903915ioc.93.1594229697532;
        Wed, 08 Jul 2020 10:34:57 -0700 (PDT)
Received: from [172.22.22.26] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id z78sm240714ilk.72.2020.07.08.10.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 10:34:56 -0700 (PDT)
Subject: Re: [PATCH] bitfield.h: don't compile-time validate _val in FIELD_FIT
To:     Nick Desaulniers <ndesaulniers@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20200707211642.1106946-1-ndesaulniers@google.com>
 <bca8cff8-3ffe-e5ab-07a5-2ab29d5e394a@linaro.org>
 <CAKwvOdmtv2EdNQz+c_DZm_47EEibkaXfDW8dGPwNPA3OrcoC9g@mail.gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <20997cd9-91e5-ca83-218d-4fd5af128893@linaro.org>
Date:   Wed, 8 Jul 2020 12:34:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAKwvOdmtv2EdNQz+c_DZm_47EEibkaXfDW8dGPwNPA3OrcoC9g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/20 12:10 PM, Nick Desaulniers wrote:
> On Tue, Jul 7, 2020 at 3:43 PM Alex Elder <elder@linaro.org> wrote:
>>
>> On 7/7/20 4:16 PM, Nick Desaulniers wrote:
>>> From: Jakub Kicinski <kuba@kernel.org>
>>>
>>> When ur_load_imm_any() is inlined into jeq_imm(), it's possible for the
>>> compiler to deduce a case where _val can only have the value of -1 at
>>> compile time. Specifically,
>>>
>>> /* struct bpf_insn: _s32 imm */
>>> u64 imm = insn->imm; /* sign extend */
>>> if (imm >> 32) { /* non-zero only if insn->imm is negative */
>>>   /* inlined from ur_load_imm_any */
>>>   u32 __imm = imm >> 32; /* therefore, always 0xffffffff */
>>>   if (__builtin_constant_p(__imm) && __imm > 255)
>>>     compiletime_assert_XXX()
>>>
>>> This can result in tripping a BUILD_BUG_ON() in __BF_FIELD_CHECK() that
>>> checks that a given value is representable in one byte (interpreted as
>>> unsigned).
> 
> Hi Alex,
> Thanks for taking a look. They're good and fair questions.
> 
>>
>> Why does FIELD_FIT() pass an unsigned long long value as the second
>> argument to __BF_FIELD_CHECK()?
> 
> Was Jakub's suggestion; I don't feel strongly against it either way, though...
> 
>> Could it pass (typeof(_mask))0 instead?
> 
> ...might be nice to avoid implicit promotions and conversions if _mask
> is not the same sizeof _val.
> 
>> It wouldn't fix this particular case, because UR_REG_IMM_MAX is also
>> defined with that type.  But (without working through this in more
>> detail) it seems like there might be a solution that preserves the
>> compile-time checking.
> 
> I'd argue the point of the patch is to not check at compile time for
> FIELD_FIT, since we have a case in
> drivers/net/ethernet/netronome/nfp/bpf/jit.c (jeq_imm()) that will
> always pass -1 (unintentionally due to compiler optimization).

I understand why something needs to be done to handle that case.
There's fancy macro gymnastics in "bitfield.h" to add convenient
build-time checks for usage problems; I just thought there might
be something we could do to preserve the checking--even in this
case.  But figuring that out takes more time than I was willing
to spend on it yesterday...

>> A second comment about this is that it might be nice to break
>> __BF_FIELD_CHECK() into the parts that verify the mask (which
>> could be used by FIELD_FIT() here) and the parts that verify
>> other things.
> 
> Like so? Jakub, WDYT? Or do you prefer v1+Alex's suggestion about
> using `(typeof(_mask))0` in place of 0ULL?

Yes, very much like that!  But you could do that as a follow-on
instead, so as not to delay or confuse things.

Thanks.

					-Alex

> diff --git a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
> b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
> index 311a5be25acb..938fc733fccb 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c
> @@ -492,11 +492,12 @@ nfp_eth_set_bit_config(struct nfp_nsp *nsp,
> unsigned int raw_idx,
>         return 0;
>  }
> 
> -#define NFP_ETH_SET_BIT_CONFIG(nsp, raw_idx, mask, val, ctrl_bit)      \
> -       ({                                                              \
> -               __BF_FIELD_CHECK(mask, 0ULL, val, "NFP_ETH_SET_BIT_CONFIG: "); \
> -               nfp_eth_set_bit_config(nsp, raw_idx, mask, __bf_shf(mask), \
> -                                      val, ctrl_bit);                  \
> +#define NFP_ETH_SET_BIT_CONFIG(nsp, raw_idx, mask, val, ctrl_bit)
>          \
> +       ({
>          \
> +               __BF_FIELD_CHECK_MASK(mask, "NFP_ETH_SET_BIT_CONFIG:
> ");        \
> +               __BF_FIELD_CHECK_VAL(mask, val,
> "NFP_ETH_SET_BIT_CONFIG: ");    \
> +               nfp_eth_set_bit_config(nsp, raw_idx, mask,
> __bf_shf(mask),      \
> +                                      val, ctrl_bit);
>          \
>         })
> 
>  /**
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index 48ea093ff04c..79651867beb3 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -41,18 +41,26 @@
> 
>  #define __bf_shf(x) (__builtin_ffsll(x) - 1)
> 
> -#define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)                      \
> +#define __BF_FIELD_CHECK_MASK(_mask, _pfx)                             \
>         ({                                                              \
>                 BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),          \
>                                  _pfx "mask is not constant");          \
>                 BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");    \
> +               __BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +                 \
> +                                             (1ULL << __bf_shf(_mask))); \
> +       })
> +
> +#define __BF_FIELD_CHECK_VAL(_mask, _val, _pfx)
>          \
> +       ({                                                              \
>                 BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
>                                  ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
>                                  _pfx "value too large for the field"); \
> -               BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,         \
> +       })
> +
> +#define __BF_FIELD_CHECK_REG(_mask, _reg, _pfx)
>          \
> +       ({                                                              \
> +               BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ULL,         \
>                                  _pfx "type of reg too small for mask"); \
> -               __BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +                 \
> -                                             (1ULL << __bf_shf(_mask))); \
>         })
> 
>  /**
> @@ -64,7 +72,7 @@
>   */
>  #define FIELD_MAX(_mask)                                               \
>         ({                                                              \
> -               __BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_MAX: ");     \
> +               __BF_FIELD_CHECK_MASK(_mask, "FIELD_MAX: ");            \
>                 (typeof(_mask))((_mask) >> __bf_shf(_mask));            \
>         })
> 
> @@ -77,7 +85,7 @@
>   */
>  #define FIELD_FIT(_mask, _val)                                         \
>         ({                                                              \
> -               __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");     \
> +               __BF_FIELD_CHECK_MASK(_mask, "FIELD_FIT: ");            \
>                 !((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
>         })
>  @@ -91,7 +99,8 @@
>   */
>  #define FIELD_PREP(_mask, _val)
>          \
>         ({                                                              \
> -               __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");    \
> +               __BF_FIELD_CHECK_MASK(_mask, "FIELD_PREP: ");           \
> +               __BF_FIELD_CHECK_VAL(_mask, _val, "FIELD_PREP: ");      \
>                 ((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);   \
>         })
> 
> @@ -105,7 +114,8 @@
>   */
>  #define FIELD_GET(_mask, _reg)                                         \
>         ({                                                              \
> -               __BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");       \
> +               __BF_FIELD_CHECK_MASK(_mask, "FIELD_GET: ");            \
> +               __BF_FIELD_CHECK_REG(_mask, _reg,  "FIELD_GET: ");      \
>                 (typeof(_mask))(((_reg) & (_mask)) >> __bf_shf(_mask)); \
>         })
> 
> 
> 
>>
>> That's all--just questions, I have no problem with the patch...
>>
>>                                         -Alex
>>
>>
>>
>>
>>> FIELD_FIT() should return true or false at runtime for whether a value
>>> can fit for not. Don't break the build over a value that's too large for
>>> the mask. We'd prefer to keep the inlining and compiler optimizations
>>> though we know this case will always return false.
>>>
>>> Cc: stable@vger.kernel.org
>>> Link: https://lore.kernel.org/kernel-hardening/CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com/
>>> Reported-by: Masahiro Yamada <masahiroy@kernel.org>
>>> Debugged-by: Sami Tolvanen <samitolvanen@google.com>
>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
>>> ---
>>>  include/linux/bitfield.h | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
>>> index 48ea093ff04c..4e035aca6f7e 100644
>>> --- a/include/linux/bitfield.h
>>> +++ b/include/linux/bitfield.h
>>> @@ -77,7 +77,7 @@
>>>   */
>>>  #define FIELD_FIT(_mask, _val)                                               \
>>>       ({                                                              \
>>> -             __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_FIT: ");     \
>>> +             __BF_FIELD_CHECK(_mask, 0ULL, 0ULL, "FIELD_FIT: ");     \
>>>               !((((typeof(_mask))_val) << __bf_shf(_mask)) & ~(_mask)); \
>>>       })
>>>
>>>
>>
> 
> 
> --
> Thanks,
> ~Nick Desaulniers
> 

