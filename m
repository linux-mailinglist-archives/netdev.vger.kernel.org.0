Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169713B6C13
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 03:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhF2BfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 21:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbhF2BfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 21:35:24 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D408C061574;
        Mon, 28 Jun 2021 18:32:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 21so15818248pfp.3;
        Mon, 28 Jun 2021 18:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=bPfatxmweNaLM9E6pLsgc1kmjx9CXPuyRz8301PKhZo=;
        b=JZPgzkIWrPk1BKp7NFhNavoAfu3dhhb+Y+x90Y8yJLjB/2jzJwJ7aW4x603/UWV8Qy
         lMT63OBXc0Fn1ITo3Yp+PGpeToqiONfMSlqPIIregW2pA/VdFpXQJ52I0F01t9m+40F5
         S8qZJrm0Bb6o/yZEHPaiIhoZbOH9ABHpPgjZczeJgHuO6yL8hSkEHquLq7MpTEMmdepk
         KZ927Gmq/3tUtwdYsLAjqRsAY2t3o7M+I5jxrVqaxWn80MXRt2hYluKZWZqjH0W8yPAv
         OPJcjHzMQFm+siC52gFohfhBoILx3kJH5dsHKizpNBFXdtOef6fBspix8tNmnDild1R+
         6jSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=bPfatxmweNaLM9E6pLsgc1kmjx9CXPuyRz8301PKhZo=;
        b=gNJnovCp26/a52FhpDuLG5fVyMui4cPsJZEYM19abZ2nxTAYGj4vEv7SNnx/x4Ys0c
         j2plgGxjbFtX1/gVWehMSLfm+Kni/rKUa5LGANcR+LDCfQlBrYMPmhpzPcSZe/Hro6HV
         DlTO6T1IvQ1w8AxygeTSGXL8EXdvy1PvO+0QE4BMk3rGqlMmxxE3T6cQZTg7vIuCCmI7
         +d/3yE8EsClcH2r2+uNVxaS4wswVkty05fXRZAmC/NeW8WhAO7ewHfkf3qg2Qxgj9IKE
         jh6S2aAiWioUrjXN8MLwi+6YjRXhaR6vxeGNWdJUW6Vd1i3okxRPB9i51o2H3oDqubbq
         bjzg==
X-Gm-Message-State: AOAM531hhHPiI+IkQJL+WhKOU2rdyAL1tnjXkIw50uRssKYLDUOMiOdz
        0oSES72AVL2zJQG370sXeOc=
X-Google-Smtp-Source: ABdhPJz7eS0yaL5OhGfJUqtPS/MojvoUJ7/7xFgyMQEpI4NU2A5hNNc5sF3kUT5a1bAMXPvBRNv8Pw==
X-Received: by 2002:a05:6a00:2283:b029:307:5484:dd10 with SMTP id f3-20020a056a002283b02903075484dd10mr28037768pfe.43.1624930376733;
        Mon, 28 Jun 2021 18:32:56 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:45ad])
        by smtp.gmail.com with ESMTPSA id j8sm14739622pfu.60.2021.06.28.18.32.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jun 2021 18:32:56 -0700 (PDT)
Date:   Mon, 28 Jun 2021 18:32:53 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     netdev@vger.kernel.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/5] bitops: add non-atomic bitops for
 pointers
Message-ID: <20210629013252.qxooyfkubq3l4s3v@ast-mbp.dhcp.thefacebook.com>
References: <20210628114746.129669-1-memxor@gmail.com>
 <20210628114746.129669-3-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210628114746.129669-3-memxor@gmail.com>
User-Agent: NeoMutt/20180223
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 28, 2021 at 05:17:43PM +0530, Kumar Kartikeya Dwivedi wrote:
> cpumap needs to set, clear, and test the lowest bit in skb pointer in
> various places. To make these checks less noisy, add pointer friendly
> bitop macros that also do some typechecking to sanitize the argument.
> 
> These wrap the non-atomic bitops __set_bit, __clear_bit, and test_bit
> but for pointer arguments. Pointer's address has to be passed in and it
> is treated as an unsigned long *, since width and representation of
> pointer and unsigned long match on targets Linux supports. They are
> prefixed with double underscore to indicate lack of atomicity.
> 
> Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bitops.h    | 19 +++++++++++++++++++
>  include/linux/typecheck.h | 10 ++++++++++
>  2 files changed, 29 insertions(+)
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index 26bf15e6cd35..a9e336b9fa4d 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -4,6 +4,7 @@
>  
>  #include <asm/types.h>
>  #include <linux/bits.h>
> +#include <linux/typecheck.h>
>  
>  #include <uapi/linux/kernel.h>
>  
> @@ -253,6 +254,24 @@ static __always_inline void __assign_bit(long nr, volatile unsigned long *addr,
>  		__clear_bit(nr, addr);
>  }
>  
> +#define __ptr_set_bit(nr, addr)                         \
> +	({                                              \
> +		typecheck_pointer(*(addr));             \
> +		__set_bit(nr, (unsigned long *)(addr)); \
> +	})
> +
> +#define __ptr_clear_bit(nr, addr)                         \
> +	({                                                \
> +		typecheck_pointer(*(addr));               \
> +		__clear_bit(nr, (unsigned long *)(addr)); \
> +	})
> +
> +#define __ptr_test_bit(nr, addr)                       \
> +	({                                             \
> +		typecheck_pointer(*(addr));            \
> +		test_bit(nr, (unsigned long *)(addr)); \
> +	})

The use case is to use lower bits of pointers to store extra data, right?
The kernel is full of such tricks, so it's nice to formalize
the accessors, but the new macros need a comment and example
in this file.

> +
>  #ifdef __KERNEL__
>  
>  #ifndef set_mask_bits
> diff --git a/include/linux/typecheck.h b/include/linux/typecheck.h
> index 20d310331eb5..33c78f27147a 100644
> --- a/include/linux/typecheck.h
> +++ b/include/linux/typecheck.h
> @@ -22,4 +22,14 @@
>  	(void)__tmp; \
>  })
>  
> +/*
> + * Check at compile that something is a pointer type.

'at compile time'.

> + * Always evaluates to 1 so you may use it easily in comparisons.

I would drop this sentence.
The copy-paste from typecheck() macro is making it too verbose. imo.
Kinda obvious what it does.

> + */
> +#define typecheck_pointer(x) \
> +({	typeof(x) __dummy; \
> +	(void)sizeof(*__dummy); \
> +	1; \
> +})
> +
>  #endif		/* TYPECHECK_H_INCLUDED */
> -- 
> 2.31.1
> 
