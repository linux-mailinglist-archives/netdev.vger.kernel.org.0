Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A27A2605475
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 02:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiJTAXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 20:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJTAXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 20:23:14 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7B01AC1D6;
        Wed, 19 Oct 2022 17:23:12 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-136b5dd6655so22717500fac.3;
        Wed, 19 Oct 2022 17:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RcgBR9DwOSrBf/0ljr87AbnIU6+NrjI9Oo0c86WOxrU=;
        b=agMQLHLM5lTY2C6+kfgASeqc29WT1rDu0kBr1gEgYXxdIYnYORNzPwzbO2KRI1V976
         kef1lHPlbmSmqHrtgP+H6AcS4uoIJtWhHsMeNKQQpgQv19d9GbL27kNqQglqcuf3Y1e/
         rwACpfK/cRHm1YeTFThnyKrxzKDgZF1EbBAX7l2450iBZEf/re+BpxT9I5sPraovwjcK
         agPF2yF0Ia58t8ou5kP9OR3wUNaWVorWunpIiMRa3AEi6LWUjGv/NHE2LBDM5LBONm8N
         5QTY6Cr26aaQTURJaPY4B7tfB7Ww1aCPb3XYlfs8UkccVvo8XOLvga/9kUPPYUYsccLz
         o7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RcgBR9DwOSrBf/0ljr87AbnIU6+NrjI9Oo0c86WOxrU=;
        b=L+hvhiFQ6B2p1Dkbgt3YbRAhc3Tqragzl3ec+5nzNaUHawQ2hvVHNy6FjzelW9iYWs
         10lwG1OkBDkdXZHhq3eqmUwAZuwCx9Sob1NFchpqzwpWXcYlefkoXvFfFuWCRMYuybCa
         X6fNegF/JOpqAqN+xGkzRvhSIWAlaA3O2nSdRQU5RJkYbcxasL095i6G8/ZSuO2JN0gH
         HP7Cw59qRInZEvUa+cIlJe00CtZyopYtXJHvRYZjVnr5P/2lAAuX/uRmEatnNXHllMg1
         Tuy/utTKNfhpa4aFhDw3XdAoM4ZKbQp9KJ/t1xUicUZv8ZI2RA9RmwKaEHdbvSqLpB4K
         RRoA==
X-Gm-Message-State: ACrzQf39vTrnLfsDCTuhxgq+k36uG2HalCD0Qvv5kjyW++MENVQmSwQv
        X+4y2fjHf+a9+dsfjDOYUYU=
X-Google-Smtp-Source: AMsMyM6SsmLuTF5/sUvoPdUlq5roUWAgcLo8It0vZR8JpW500msOyZT6mZHBOkWtD31FWR8Y9iUARA==
X-Received: by 2002:a05:6870:c68b:b0:127:36e4:d437 with SMTP id cv11-20020a056870c68b00b0012736e4d437mr6926105oab.40.1666225391949;
        Wed, 19 Oct 2022 17:23:11 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id bj21-20020a056808199500b0035485b54caesm7372610oib.28.2022.10.19.17.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 17:23:11 -0700 (PDT)
Date:   Wed, 19 Oct 2022 17:21:01 -0700
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
Subject: Re: [PATCH v2 net-next 2/6] bitmap: add a couple more helpers to
 work with arrays of u32s
Message-ID: <Y1CUbRA6hC6PO3IH@yury-laptop>
References: <20221018140027.48086-1-alexandr.lobakin@intel.com>
 <20221018140027.48086-3-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018140027.48086-3-alexandr.lobakin@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 04:00:23PM +0200, Alexander Lobakin wrote:
> Add two new functions to work on arr32s:
> 
> * bitmap_arr32_size() - takes number of bits to be stored in arr32
>   and returns number of bytes required to store such arr32, can be
>   useful when allocating memory for arr32 containers;
> * bitmap_validate_arr32() - takes pointer to an arr32 and its size
>   in bytes, plus expected number of bits. Ensures that the size is
>   valid (must be a multiply of `sizeof(u32)`) and no bits past the
>   number is set.
> 
> Also add BITMAP_TO_U64() macro to help return a u64 from
> a DECLARE_BITMAP(1-64) (it may pick one or two longs depending
> on the platform).

Can you make BITMAP_TO_U64() a separate patch? Maybe fold it into a
first patch that uses it, but I think it worth to be a real commit.
 
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  include/linux/bitmap.h | 20 +++++++++++++++++++-
>  lib/bitmap.c           | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
> index 79d12e0f748b..c737b0fe2f41 100644
> --- a/include/linux/bitmap.h
> +++ b/include/linux/bitmap.h
> @@ -7,7 +7,7 @@
>  #include <linux/align.h>
>  #include <linux/bitops.h>
>  #include <linux/find.h>
> -#include <linux/limits.h>
> +#include <linux/overflow.h>
>  #include <linux/string.h>
>  #include <linux/types.h>
>  
> @@ -75,6 +75,8 @@ struct device;
>   *  bitmap_from_arr64(dst, buf, nbits)          Copy nbits from u64[] buf to dst
>   *  bitmap_to_arr32(buf, src, nbits)            Copy nbits from buf to u32[] dst
>   *  bitmap_to_arr64(buf, src, nbits)            Copy nbits from buf to u64[] dst
> + *  bitmap_validate_arr32(buf, len, nbits)      Validate u32[] buf of len bytes
> + *  bitmap_arr32_size(nbits)                    Get size of u32[] arr for nbits
>   *  bitmap_get_value8(map, start)               Get 8bit value from map at start
>   *  bitmap_set_value8(map, value, start)        Set 8bit value to map at start
>   *
> @@ -324,6 +326,20 @@ static inline void bitmap_to_arr32(u32 *buf, const unsigned long *bitmap,
>  		__bitmap_to_arr32(buf, bitmap, nbits);
>  }
>  
> +bool bitmap_validate_arr32(const u32 *arr, size_t len, size_t nbits);
> +
> +/**
> + * bitmap_arr32_size - determine the size of array of u32s for a number of bits
> + * @nbits: number of bits to store in the array
> + *
> + * Returns the size in bytes of a u32s-array needed to carry the specified
> + * number of bits.
> + */
> +static inline size_t bitmap_arr32_size(size_t nbits)
> +{
> +	return array_size(BITS_TO_U32(nbits), sizeof(u32));

To me this looks simpler: round_up(nbits, 32) / BITS_PER_BYTE.
Can you check which generates better code?

> +}

This is not specific to bitmaps in general. Can you put it somewhere in
include/linux/bitops.h next to BITS_TO_U32().

Regarding a name - maybe BITS_TO_U32_SIZE()? Not very elegant, but
assuming that size is always measured in bytes, it should be
understandable

>  /*
>   * On 64-bit systems bitmaps are represented as u64 arrays internally. On LE32
>   * machines the order of hi and lo parts of numbers match the bitmap structure.
> @@ -571,9 +587,11 @@ static inline void bitmap_next_set_region(unsigned long *bitmap,
>   */
>  #if __BITS_PER_LONG == 64
>  #define BITMAP_FROM_U64(n) (n)
> +#define BITMAP_TO_U64(map) ((u64)(map)[0])
>  #else
>  #define BITMAP_FROM_U64(n) ((unsigned long) ((u64)(n) & ULONG_MAX)), \
>  				((unsigned long) ((u64)(n) >> 32))
> +#define BITMAP_TO_U64(map) (((u64)(map)[1] << 32) | (u64)(map)[0])
>  #endif
>  
>  /**
> diff --git a/lib/bitmap.c b/lib/bitmap.c
> index e3eb12ff1637..e0045ecf34d6 100644
> --- a/lib/bitmap.c
> +++ b/lib/bitmap.c
> @@ -1495,6 +1495,46 @@ void __bitmap_to_arr32(u32 *buf, const unsigned long *bitmap, unsigned int nbits
>  EXPORT_SYMBOL(__bitmap_to_arr32);
>  #endif
>  
> +/**
> + * bitmap_validate_arr32 - perform validation of a u32-array bitmap
> + * @arr: array of u32s, the dest bitmap
> + * @len: length of the array, in bytes
> + * @nbits: expected/supported number of bits in the bitmap
> + *
> + * Returns true if the array passes the checks (see below), false otherwise.
> + */

In kernel-docs this would look completely useless. Can you explain
what it checks in the comment too?

> +bool bitmap_validate_arr32(const u32 *arr, size_t len, size_t nbits)
> +{
> +	size_t word = (nbits - 1) / BITS_PER_TYPE(u32);
> +	u32 pos = (nbits - 1) % BITS_PER_TYPE(u32);

What if nbits == 0? What if arr == NULL or unaligned? Assuming you don't
trust caller too much, you'd check arguments better. 

> +
> +	/* Must consist of 1...n full u32s */
> +	if (!len || len % sizeof(u32))
> +		return false;

Can you check this before calculating word and pos?

> +	/*
> +	 * If the array is shorter than expected, assume we support
> +	 * all of the bits set there.
> +	 */
> +	if (word >= len / sizeof(u32))
> +		return true;

If an array is shorter than expected, it usually means ENOMEM. Is
there a real use-case for this check?

> +	/* Last word must not contain any bits past the expected number */
> +	if (arr[word] & (u32)~GENMASK(pos, 0))
> +		return false;

We have BITMAP_LAST_WORD_MASK() macro for this.

> +	/*
> +	 * If the array is longer than expected, make sure all the bytes
> +	 * past the expected length are zeroed.
> +	 */
> +	len -= bitmap_arr32_size(nbits);
> +	if (memchr_inv(&arr[word + 1], 0, len))
> +		return false;

Instead of true/false, I would return a meaningful error or 0. In this
case, ERANGE or EDOM would seemingly fit well.

> +
> +	return true;
> +}
> +EXPORT_SYMBOL(bitmap_validate_arr32);
> +
>  #if (BITS_PER_LONG == 32) && defined(__BIG_ENDIAN)
>  /**
>   * bitmap_from_arr64 - copy the contents of u64 array of bits to bitmap
> -- 
> 2.37.3
