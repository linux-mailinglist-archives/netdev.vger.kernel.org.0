Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACE3603629
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 00:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiJRWoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 18:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiJRWoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 18:44:00 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D13E8A7E8;
        Tue, 18 Oct 2022 15:43:59 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id o64so17255950oib.12;
        Tue, 18 Oct 2022 15:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bKOW1QdWpDeYUyEm9qOMdRQfQU4SuEssfuGJ8DkV72Q=;
        b=mGz6EJf+N70NcuyS56qAbClsakah+wEUUowM6J+x5Lb8OKglZOTpkfcV8614Rlufy+
         bnaqbnroYJzpnjfhNTiRaDm46rtqCv6vUxIEgou3GM1Hk6N3T7avmWCP8exkmTtyhNzG
         C/6ND0GneTqlU4r+oGen8BRGd5UIu6XS1JHP8pSjIqaM0dR99NerHlHfaWYO8bthXCwr
         ZMc5LqQf2aq/QrMKyERF86nPD3BC+Fy1fhG8cNsHqc1CMVj2EQHDBwQihFPqHe5+6cIf
         f6UURjFLwtEWucrn9z55SLgUWQezItcPIm/6WHWFRIvLcpfMwwbg2QNvFgoqz+97SuQM
         md3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bKOW1QdWpDeYUyEm9qOMdRQfQU4SuEssfuGJ8DkV72Q=;
        b=yJYvb3/0FY7gP/jpfoLBSN0M/IbsSmYkZb9Q/Z14aLAPWp7odeqk106G3IJf/0iYRZ
         nTo9Vttc+gN+zdXeBYFpk6v4vgjXy/nHAj4ITF6wcM7qj3eip7TN3jLlvSeZh8/00IY8
         XtcSIEOHQ4UxLJx9HXBBEsEdwjXc8xxV5AWGbtWImjgReXQLEp6AwhWwcsy5ttGEEyMp
         jd+nxXuSPBR0TNI3kmKuHGE/ZmyrLyNc5qJmHctgEZXnf58cIoltTNxLr4rPmE7VLsqW
         xoiFiDQEjYxlddHARHypOv6mF8HMNVkOQOR66oLtrvfb+t4cROHKNEdcetsgGwM/4LyM
         D5PQ==
X-Gm-Message-State: ACrzQf3Pt6+xKBtukzchhvno21/Ik2hTqNMYXYbPoWdl8wjAK8Px8c6R
        HiQL+p3j6ze6hWjzW9wrLi4=
X-Google-Smtp-Source: AMsMyM5ZR/g6sZnfn2VHCfz27SdOCJChEAW0ySisXoy7K4E0uCegu9fScJTQhQqCuP6n1TUXu7U/wg==
X-Received: by 2002:a05:6808:1b22:b0:355:2980:2ac8 with SMTP id bx34-20020a0568081b2200b0035529802ac8mr2533494oib.1.1666133038596;
        Tue, 18 Oct 2022 15:43:58 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id v6-20020a9d69c6000000b006618586b850sm6586758oto.46.2022.10.18.15.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 15:43:57 -0700 (PDT)
Date:   Tue, 18 Oct 2022 15:41:46 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/6] bitmap: try to optimize arr32 <-> bitmap
 on 64-bit LEs
Message-ID: <Y08rqtdiTDbIm0EJ@yury-laptop>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
 <20221018140027.48086-2-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018140027.48086-2-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 04:00:22PM +0200, Alexander Lobakin wrote:
> Unlike bitmap_{from,to}_arr64(), when there can be no out-of-bounds
> accesses (due to u64 always being no shorter than unsigned long),
> it can't be guaranteed with arr32s due to that on 64-bit platforms:
> 
> bits     BITS_TO_U32 * sizeof(u32)    BITS_TO_LONGS * sizeof(long)
> 1-32     4                            8
> 33-64    8                            8
> 95-96    12                           16
> 97-128   16                           16
> 
> and so on.
> That is why bitmap_{from,to}_arr32() are always defined there as
> externs. But quite often @nbits is a compile-time constant, which
> means we could suggest whether it can be inlined or not at
> compile-time basing on the number of bits (above).
> 
> So, try to determine that at compile time and, in case of both
> containers having the same size in bytes, resolve it to
> bitmap_copy_clear_tail() on Little Endian. No changes here for
> Big Endian or when the number of bits *really* is variable.

You're saying 'try to optimize', but don't show any numbers. What's
the target for your optimization? Can you demonstrate how it performs
in test or in real work?
 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  include/linux/bitmap.h | 51 ++++++++++++++++++++++++++++++------------
>  lib/bitmap.c           | 12 +++++-----
>  2 files changed, 43 insertions(+), 20 deletions(-)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 7d6d73b78147..79d12e0f748b 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -283,24 +283,47 @@ static inline void bitmap_copy_clear_tail(unsigned long *dst,
>   * On 32-bit systems bitmaps are represented as u32 arrays internally. On LE64
>   * machines the order of hi and lo parts of numbers match the bitmap structure.
>   * In both cases conversion is not needed when copying data from/to arrays of
> - * u32. But in LE64 case, typecast in bitmap_copy_clear_tail() may lead
> - * to out-of-bound access. To avoid that, both LE and BE variants of 64-bit
> - * architectures are not using bitmap_copy_clear_tail().
> + * u32. But in LE64 case, typecast in bitmap_copy_clear_tail() may lead to
> + * out-of-bound access. To avoid that, LE variant of 64-bit architectures uses
> + * bitmap_copy_clear_tail() only when @bitmap and @buf containers have the same
> + * size in memory (known at compile time), and 64-bit BEs never use it.
>   */
> -#if BITS_PER_LONG == 64
> -void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
> -							unsigned int nbits);
> -void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
> -							unsigned int nbits);
> +#if BITS_PER_LONG == 32
> +#define bitmap_arr32_compat(nbits)		true
> +#elif defined(__LITTLE_ENDIAN)
> +#define bitmap_arr32_compat(nbits)		\

'Compat' is reserved for a compatibility layer between kernel and
user spaces running different ABIs. Can you pick some other word?

> +	(__builtin_constant_p(nbits) &&		\
> +	 BITS_TO_U32(nbits) * sizeof(u32) ==	\
> +	 BITS_TO_LONGS(nbits) * sizeof(long))

I think it should be:
        round_up(nbits, 32) == round_up(nbits, 64)

>  #else
> -#define bitmap_from_arr32(bitmap, buf, nbits)			\
> -	bitmap_copy_clear_tail((unsigned long *) (bitmap),	\
> -			(const unsigned long *) (buf), (nbits))
> -#define bitmap_to_arr32(buf, bitmap, nbits)			\
> -	bitmap_copy_clear_tail((unsigned long *) (buf),		\
> -			(const unsigned long *) (bitmap), (nbits))

Can you keep this part untouched? I'd like to have a clear meaning -
on 32-bit arch, bitmap_to_arr32 is a simple copy.

> +#define bitmap_arr32_compat(nbits)		false
>  #endif
>  
> +void __bitmap_from_arr32(unsigned long *bitmap, const u32 *buf, unsigned int nbits);
> +void __bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits);
> +
> +static inline void bitmap_from_arr32(unsigned long *bitmap, const u32 *buf,
> +				     unsigned int nbits)
> +{
> +	const unsigned long *src = (const unsigned long *)buf;
> +
> +	if (bitmap_arr32_compat(nbits))
> +		bitmap_copy_clear_tail(bitmap, src, nbits);
> +	else
> +		__bitmap_from_arr32(bitmap, buf, nbits);

If you would really want to optimize it, I'd suggest something like
this:
    #ifdef __LITTLE_ENDIAN
        /*copy as many full 64-bit words as we can */
        bitmap_copy(bitmap, src, round_down(nbits, BITS_PER_LONG)); 

        /* now copy part of last word per-byte */
        ...
    #else
	__bitmap_from_arr32(bitmap, buf, nbits);
    #endif

This should be better because it uses fast bitmap_copy() regardless
the number of bits. Assuming bitmap_copy() is significantly faster
than bitmap_from_arr(), people will be surprised by the difference of
speed of copying, say, 2048 and 2049-bit bitmaps. Right?

But unless we'll see real numbers, it's questionable to me if that's
worth the effort.

Thanks,
Yury
