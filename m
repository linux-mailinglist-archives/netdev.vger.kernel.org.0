Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5330D5A1AD0
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234084AbiHYVHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiHYVHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:07:31 -0400
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0572A1A7D;
        Thu, 25 Aug 2022 14:07:28 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-11c9af8dd3eso26161927fac.10;
        Thu, 25 Aug 2022 14:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1fSFLJV4Gh2PNLH705N+2oHQoK4YOhY8BnTb+mghw2w=;
        b=eCk3b6xOrEtsPaZU6XKEEU4P7w5oK6VCvNqDrudLOd3nxfWFUsbyusdRp4ksho2d0n
         jyVoCiWlbM6D/kyNwH7VdLq+ojgPTzAx/b1ulzPVICZkx2s1wy6z97wl22wplu2K/zTo
         NkzriMHLHX3l3wKIRHUGsyhwmlGLnk4OiU+EUGriGhLyhqr2ILDpc7F8ua9fOtIOqx18
         yDlvcTwWrRAnMFu3BzgYMGTUuK7GTbmPpLuNPjFCs+PNErpFkhYsWQ1NVjVVfNBPfxQB
         1fEEMS1X0G0SZtvQ8vbjGr5DePGg5en3QuaGSiF8PJBGNpn9iC2GNMe7Fsn70aMyTVmB
         3ogw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1fSFLJV4Gh2PNLH705N+2oHQoK4YOhY8BnTb+mghw2w=;
        b=fYo5aJvKXyPYPjZIghbkbsAFwJ6i+h4CvAcquXXG0asXRu+EdEuC3GZt4mKdHwciKF
         TOK8wZNHiTkCpzY1Hi2gwMAdnw0JutqL1qhirZWbMQZTB+C5quwx+Sktn26nVN4Yns/T
         p2a/umx7E/QrClkNiHftK4ri0GMIEekWeLzIRV9/5QkNpnqfAcmFph/gA4f+hLIrCgNE
         0JJkyVmBn423+lgDFh1Tpu0d5iUqpFoC5Z6s69NFGev5CaHl+Ydhn8yZHPzYTC0GxpPD
         7dpVRe/uVmRSHCv5T+Xyrfqd0gr9o7V1DWRIN19WVXHpnUF0aoNBlEbD+CFDFyaG8sBB
         b1+Q==
X-Gm-Message-State: ACgBeo1NoO/6EZSa/beekwjUyaVPtf2Vf3+pqm21vKfu3DU/mc7f5joE
        r90Iik1gBlVBSdYkY4c7pvg=
X-Google-Smtp-Source: AA6agR74ie5W9jV7mLm3DUa6Cs1VlyS9CdCWwj24VM90OFOFiAspOxyDbOlVV7s7ptQSFnsOiWd3WA==
X-Received: by 2002:a05:6870:b405:b0:10d:7e26:8e8c with SMTP id x5-20020a056870b40500b0010d7e268e8cmr453459oap.78.1661461647990;
        Thu, 25 Aug 2022 14:07:27 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id x3-20020a4aaa03000000b0044b46c639easm195018oom.18.2022.08.25.14.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:07:27 -0700 (PDT)
Date:   Thu, 25 Aug 2022 14:05:16 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v3 3/9] bitops: Introduce find_next_andnot_bit()
Message-ID: <YwfkDBl6DD+9Zjmk@yury-laptop>
References: <20220825181210.284283-1-vschneid@redhat.com>
 <20220825181210.284283-4-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825181210.284283-4-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 07:12:04PM +0100, Valentin Schneider wrote:
> In preparation of introducing for_each_cpu_andnot(), add a variant of
> find_next_bit() that negate the bits in @addr2 when ANDing them with the
> bits in @addr1.
> 
> Note that the _find_next_bit() @invert argument now gets split into two:
> @invert1 for words in @addr1, @invert2 for words in @addr2. The only
> current users of _find_next_bit() with @invert set are:
>   o find_next_zero_bit()
>   o find_next_zero_bit_le()
> and neither of these pass an @addr2, so the conversion is straightforward.
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>

Have you seen this series?
https://lore.kernel.org/lkml/YwaXvphVpy5A7fSs@yury-laptop/t/

It will significantly simplify your work for adding the
find_next_andnot_bit(). If you wait a week or so, you'll most likely
find it in -next.

Thanks,
Yury

> ---
>  include/linux/find.h | 44 ++++++++++++++++++++++++++++++++++++++------
>  lib/find_bit.c       | 23 ++++++++++++-----------
>  2 files changed, 50 insertions(+), 17 deletions(-)
> 
> diff --git a/include/linux/find.h b/include/linux/find.h
> index 424ef67d4a42..a195cf0a8bab 100644
> --- a/include/linux/find.h
> +++ b/include/linux/find.h
> @@ -10,7 +10,8 @@
>  
>  extern unsigned long _find_next_bit(const unsigned long *addr1,
>  		const unsigned long *addr2, unsigned long nbits,
> -		unsigned long start, unsigned long invert, unsigned long le);
> +		unsigned long start, unsigned long invert1, unsigned long invert2,
> +		unsigned long le);
>  extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
>  extern unsigned long _find_first_and_bit(const unsigned long *addr1,
>  					 const unsigned long *addr2, unsigned long size);
> @@ -41,7 +42,7 @@ unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
>  		return val ? __ffs(val) : size;
>  	}
>  
> -	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
> +	return _find_next_bit(addr, NULL, size, offset, 0UL, 0UL, 0);
>  }
>  #endif
>  
> @@ -71,7 +72,38 @@ unsigned long find_next_and_bit(const unsigned long *addr1,
>  		return val ? __ffs(val) : size;
>  	}
>  
> -	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
> +	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0UL, 0);
> +}
> +#endif
> +
> +#ifndef find_next_andnot_bit
> +/**
> + * find_next_andnot_bit - find the next bit in *addr1 excluding all the bits
> + *                        in *addr2
> + * @addr1: The first address to base the search on
> + * @addr2: The second address to base the search on
> + * @size: The bitmap size in bits
> + * @offset: The bitnumber to start searching at
> + *
> + * Returns the bit number for the next set bit
> + * If no bits are set, returns @size.
> + */
> +static inline
> +unsigned long find_next_andnot_bit(const unsigned long *addr1,
> +		const unsigned long *addr2, unsigned long size,
> +		unsigned long offset)
> +{
> +	if (small_const_nbits(size)) {
> +		unsigned long val;
> +
> +		if (unlikely(offset >= size))
> +			return size;
> +
> +		val = *addr1 & ~*addr2 & GENMASK(size - 1, offset);
> +		return val ? __ffs(val) : size;
> +	}
> +
> +	return _find_next_bit(addr1, addr2, size, offset, 0UL, ~0UL, 0);
>  }
>  #endif
>  
> @@ -99,7 +131,7 @@ unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
>  		return val == ~0UL ? size : ffz(val);
>  	}
>  
> -	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
> +	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0UL, 0);
>  }
>  #endif
>  
> @@ -247,7 +279,7 @@ unsigned long find_next_zero_bit_le(const void *addr, unsigned
>  		return val == ~0UL ? size : ffz(val);
>  	}
>  
> -	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
> +	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0UL, 1);
>  }
>  #endif
>  
> @@ -266,7 +298,7 @@ unsigned long find_next_bit_le(const void *addr, unsigned
>  		return val ? __ffs(val) : size;
>  	}
>  
> -	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
> +	return _find_next_bit(addr, NULL, size, offset, 0UL, 0UL, 1);
>  }
>  #endif
>  
> diff --git a/lib/find_bit.c b/lib/find_bit.c
> index 1b8e4b2a9cba..c46b66d7d2b4 100644
> --- a/lib/find_bit.c
> +++ b/lib/find_bit.c
> @@ -21,27 +21,29 @@
>  
>  #if !defined(find_next_bit) || !defined(find_next_zero_bit) ||			\
>  	!defined(find_next_bit_le) || !defined(find_next_zero_bit_le) ||	\
> -	!defined(find_next_and_bit)
> +	!defined(find_next_and_bit) || !defined(find_next_andnot_bit)
>  /*
>   * This is a common helper function for find_next_bit, find_next_zero_bit, and
>   * find_next_and_bit. The differences are:
> - *  - The "invert" argument, which is XORed with each fetched word before
> - *    searching it for one bits.
>   *  - The optional "addr2", which is anded with "addr1" if present.
> + *  - The "invert" arguments, which are XORed with each fetched word (invert1
> + *    for words in addr1, invert2 for those in addr2) before searching it for
> + *    one bits.
>   */
>  unsigned long _find_next_bit(const unsigned long *addr1,
> -		const unsigned long *addr2, unsigned long nbits,
> -		unsigned long start, unsigned long invert, unsigned long le)
> +			     const unsigned long *addr2,
> +			     unsigned long nbits, unsigned long start,
> +			     unsigned long invert1, unsigned long invert2,
> +			     unsigned long le)
>  {
>  	unsigned long tmp, mask;
>  
>  	if (unlikely(start >= nbits))
>  		return nbits;
>  
> -	tmp = addr1[start / BITS_PER_LONG];
> +	tmp = addr1[start / BITS_PER_LONG] ^ invert1;
>  	if (addr2)
> -		tmp &= addr2[start / BITS_PER_LONG];
> -	tmp ^= invert;
> +		tmp &= addr2[start / BITS_PER_LONG] ^ invert2;
>  
>  	/* Handle 1st word. */
>  	mask = BITMAP_FIRST_WORD_MASK(start);
> @@ -57,10 +59,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
>  		if (start >= nbits)
>  			return nbits;
>  
> -		tmp = addr1[start / BITS_PER_LONG];
> +		tmp = addr1[start / BITS_PER_LONG] ^ invert1;
>  		if (addr2)
> -			tmp &= addr2[start / BITS_PER_LONG];
> -		tmp ^= invert;
> +			tmp &= addr2[start / BITS_PER_LONG] ^ invert2;
>  	}
>  
>  	if (le)
> -- 
> 2.31.1
