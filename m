Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2A859654D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237371AbiHPWQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237954AbiHPWQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:16:03 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DEE90183;
        Tue, 16 Aug 2022 15:16:01 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id j5so13587421oih.6;
        Tue, 16 Aug 2022 15:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=PqaIhrTLHhxwKykVW2pZ7nldS1K5U0yYVC4ewlMZYzI=;
        b=KAoJnsVTrdv+pCFXXYGf1va+ODU21Q5ysXPG7/fLVg1xN5klEu9X+wJVL6IHnpnbUK
         nsmM+ib0/Ken+Hjom8BFo4AFUjWmTNBjx1CAqPA/sxEsth9A9Ykn0bsm1PJhtRaxNnpR
         Z8bSQ+l+Tzl/IehKBRNZqhbuSSCATDd0wDoLRD9vbgDzvwjoF6lZ29pvHgzmdX7S2non
         73nE2ekJ6hCGdl/y7z35Xst5zLX4U/Rhb24QmVIRskXFAKrpBYb4DAIPZwV8RXI/6IT2
         HenibAs/aArmrPLYsxgEdlF41en+9JZh3Nze3gC4I+Pn4ZRpX5aHliQpNx9HdQTzwkDA
         sDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=PqaIhrTLHhxwKykVW2pZ7nldS1K5U0yYVC4ewlMZYzI=;
        b=Crdsa4rgSusmbMFoYmtkHtIgnuzZvKKDCi3MzFIUO3evPKLPjdSoeKDlAwXhb1wh30
         UC6ljdGgvNzxBd9RraVl+yXu4k0fsg+EmLfwI9HIiENa0yLGhxvDdlSgIuih5ldac8gU
         DebU4ruy0OEYk4DCKvQU3COZ0l5ChZcQSJLRaqcqNfGQ5BWqHFA+IkfaarqrNO3/QYLn
         yFFzARA4xekRRIrkOtClLotK9KkodWw4B1LwZr210SofHmHiZ0YHMAUSgyJ+WGI1m63W
         A4O5EtCp6CgKtgniKOtIAS6yKkXNdonZjlodDFaDrkBBiaH9WGPEzxV68koamOlISrQ2
         PPMw==
X-Gm-Message-State: ACgBeo2JPsckprbiRd2fm7hLfV+S5nzzkPbpkIkby3I9G3RUg0+yCj27
        YuIZGkyLrrjj3tA785U4AnI=
X-Google-Smtp-Source: AA6agR7yMusVwGIrjr60neF/r9o76on6C8mLx2df69NoBGfOGTuAs/oDRMc1jZrsXvd9r4Lr+KorIw==
X-Received: by 2002:a05:6808:30a8:b0:343:538c:33ef with SMTP id bl40-20020a05680830a800b00343538c33efmr273010oib.91.1660688161048;
        Tue, 16 Aug 2022 15:16:01 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id l14-20020a056870218e00b0011c47d23707sm83350oae.54.2022.08.16.15.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 15:16:00 -0700 (PDT)
Date:   Tue, 16 Aug 2022 15:13:48 -0700
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
        Barry Song <song.bao.hua@hisilicon.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH 1/5] bitops: Introduce find_next_andnot_bit()
Message-ID: <YvwWnH/8dD1rYxpq@yury-laptop>
References: <20220816180727.387807-1-vschneid@redhat.com>
 <20220816180727.387807-2-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220816180727.387807-2-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 07:07:23PM +0100, Valentin Schneider wrote:
> In preparation of introducing for_each_cpu_andnot(), add a variant of
> find_next_bit() that negate the bits in @addr2 when ANDing them with the
> bits in @addr1.
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  include/linux/find.h | 44 ++++++++++++++++++++++++++++++++++++++------
>  lib/find_bit.c       | 16 +++++++++++-----
>  2 files changed, 49 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/find.h b/include/linux/find.h
> index 424ef67d4a42..454cde69b30b 100644
> --- a/include/linux/find.h
> +++ b/include/linux/find.h
> @@ -10,7 +10,8 @@
>  
>  extern unsigned long _find_next_bit(const unsigned long *addr1,
>  		const unsigned long *addr2, unsigned long nbits,
> -		unsigned long start, unsigned long invert, unsigned long le);
> +		unsigned long start, unsigned long invert, unsigned long le,
> +		bool negate);
>  extern unsigned long _find_first_bit(const unsigned long *addr, unsigned long size);
>  extern unsigned long _find_first_and_bit(const unsigned long *addr1,
>  					 const unsigned long *addr2, unsigned long size);
> @@ -41,7 +42,7 @@ unsigned long find_next_bit(const unsigned long *addr, unsigned long size,
>  		return val ? __ffs(val) : size;
>  	}
>  
> -	return _find_next_bit(addr, NULL, size, offset, 0UL, 0);
> +	return _find_next_bit(addr, NULL, size, offset, 0UL, 0, 0);
>  }
>  #endif
>  
> @@ -71,7 +72,38 @@ unsigned long find_next_and_bit(const unsigned long *addr1,
>  		return val ? __ffs(val) : size;
>  	}
>  
> -	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0);
> +	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0, 0);
> +}
> +#endif
> +
> +#ifndef find_next_andnot_bit
> +/**
> + * find_next_andnot_bit - find the next set bit in one memory region
> + *                        but not in the other
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
> +	return _find_next_bit(addr1, addr2, size, offset, 0UL, 0, 1);
>  }
>  #endif
>  
> @@ -99,7 +131,7 @@ unsigned long find_next_zero_bit(const unsigned long *addr, unsigned long size,
>  		return val == ~0UL ? size : ffz(val);
>  	}
>  
> -	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0);
> +	return _find_next_bit(addr, NULL, size, offset, ~0UL, 0, 0);
>  }
>  #endif
>  
> @@ -247,7 +279,7 @@ unsigned long find_next_zero_bit_le(const void *addr, unsigned
>  		return val == ~0UL ? size : ffz(val);
>  	}
>  
> -	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1);
> +	return _find_next_bit(addr, NULL, size, offset, ~0UL, 1, 0);
>  }
>  #endif
>  
> @@ -266,7 +298,7 @@ unsigned long find_next_bit_le(const void *addr, unsigned
>  		return val ? __ffs(val) : size;
>  	}
>  
> -	return _find_next_bit(addr, NULL, size, offset, 0UL, 1);
> +	return _find_next_bit(addr, NULL, size, offset, 0UL, 1, 0);
>  }
>  #endif
>  
> diff --git a/lib/find_bit.c b/lib/find_bit.c
> index 1b8e4b2a9cba..6e5f42c621a9 100644
> --- a/lib/find_bit.c
> +++ b/lib/find_bit.c
> @@ -21,17 +21,19 @@
>  
>  #if !defined(find_next_bit) || !defined(find_next_zero_bit) ||			\
>  	!defined(find_next_bit_le) || !defined(find_next_zero_bit_le) ||	\
> -	!defined(find_next_and_bit)
> +	!defined(find_next_and_bit) || !defined(find_next_andnot_bit)
>  /*
>   * This is a common helper function for find_next_bit, find_next_zero_bit, and
>   * find_next_and_bit. The differences are:
>   *  - The "invert" argument, which is XORed with each fetched word before
>   *    searching it for one bits.
> - *  - The optional "addr2", which is anded with "addr1" if present.
> + *  - The optional "addr2", negated if "negate" and ANDed with "addr1" if
> + *    present.
>   */
>  unsigned long _find_next_bit(const unsigned long *addr1,
>  		const unsigned long *addr2, unsigned long nbits,
> -		unsigned long start, unsigned long invert, unsigned long le)
> +		unsigned long start, unsigned long invert, unsigned long le,
> +		bool negate)
>  {
>  	unsigned long tmp, mask;
>  
> @@ -40,7 +42,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
>  
>  	tmp = addr1[start / BITS_PER_LONG];
>  	if (addr2)
> -		tmp &= addr2[start / BITS_PER_LONG];
> +		tmp &= negate ?
> +		       ~addr2[start / BITS_PER_LONG] :
> +			addr2[start / BITS_PER_LONG];
>  	tmp ^= invert;
>  
>  	/* Handle 1st word. */
> @@ -59,7 +63,9 @@ unsigned long _find_next_bit(const unsigned long *addr1,
>  
>  		tmp = addr1[start / BITS_PER_LONG];
>  		if (addr2)
> -			tmp &= addr2[start / BITS_PER_LONG];
> +			tmp &= negate ?
> +			       ~addr2[start / BITS_PER_LONG] :
> +				addr2[start / BITS_PER_LONG];
>  		tmp ^= invert;
>  	}

So it flips addr2 bits twice - first with new 'negate', and second
with the existing 'invert'. There is no such combination in the
existing code, but the pattern looks ugly, particularly because we use
different inverting approaches. Because of that, and because XOR trick
generates better code, I'd suggest something like this:

        tmp = addr1[start / BITS_PER_LONG] ^ invert1;
        if (addr2)
                tmp &= addr2[start / BITS_PER_LONG] ^ invert2;
