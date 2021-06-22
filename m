Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24CF3B1001
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 00:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhFVWXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 18:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41008 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229718AbhFVWXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 18:23:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624400452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=muXiI1t5kA6cK1rXHpxgihnBFeO1TBS1Tofk95h0PDc=;
        b=OJv5Hdh97y1SumnmKG6SpqS22GIDlrm4UN1454Sm8kjoTuUz0wqLZ9a5uL+A3nAt3dFQgt
        D7p029PTrSlqzAtP/ZGENIGwTY+BJrwx4MVNmi525h0xuyto4d5rHdNunaPMn2MtTjJYSA
        rYobG80ly+jbkmSGmK9VhiCu/UlPm20=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-562-XS0xp9OvN1GlX1jNlCixJA-1; Tue, 22 Jun 2021 18:20:51 -0400
X-MC-Unique: XS0xp9OvN1GlX1jNlCixJA-1
Received: by mail-lj1-f197.google.com with SMTP id m11-20020a2e580b0000b0290152246e1297so37323ljb.13
        for <netdev@vger.kernel.org>; Tue, 22 Jun 2021 15:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=muXiI1t5kA6cK1rXHpxgihnBFeO1TBS1Tofk95h0PDc=;
        b=nWZ5U5uP8AItaQrTAhua2uMFgohS1LxCoKmPf9G1lfIgjEDRoIyjlcLB0/aGFGNDtI
         vxWTqZBFMcrNPQ1PNGW42m2+LRPqOf5pZG3CPa/VcFUn00SwVsH6fB773Ul4+1Ri+pGA
         8fvpt43CCpT0AlHAgRNe9EnREJN+35IFy/GLbuPaoGogRibv0Cpsxhl+97ZTuTkdEJD9
         YI5EIqc+CccgFVRq1WfomHRLuPlNf2ZJfZfRPeOXXgZAoOJSdQ5Oc3LitvIEFW28GgbP
         xoVDlF04+6qtcYi9Xs7EXZS6ocEHTYnzJC7q4a9ul3xbBYtcLmjI2q2I89J/WmXEE+xO
         QLNg==
X-Gm-Message-State: AOAM5332bvnmdMApoAhva+0540s7GMPzuHvxxDxObPtC71wqJXG1fq3v
        JtF8Y5CCLqqjWpxqgIuxAPTluHErfHG3gZpYeNg6edWCHyrpldn+cNEY4TnwrVlsEoNBCVhs4hT
        NKHamzzQR8Pi+PYZb
X-Received: by 2002:a17:906:1318:: with SMTP id w24mr6134881ejb.222.1624398772554;
        Tue, 22 Jun 2021 14:52:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyYgXlU6eB4BDCEoFhNChY4tjZ+nDf+v/FSJVdCo814paMiu/xWxD483Me4Gunzl5gGglJMwA==
X-Received: by 2002:a17:906:1318:: with SMTP id w24mr6134867ejb.222.1624398772386;
        Tue, 22 Jun 2021 14:52:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id n11sm6630781ejg.43.2021.06.22.14.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 14:52:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 603CE180730; Tue, 22 Jun 2021 23:52:51 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/5] bitops: add non-atomic bitops for pointers
In-Reply-To: <20210622202835.1151230-3-memxor@gmail.com>
References: <20210622202835.1151230-1-memxor@gmail.com>
 <20210622202835.1151230-3-memxor@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Jun 2021 23:52:51 +0200
Message-ID: <871r8tpnws.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

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
> +

Before these were functions that returned the modified values, now they
are macros that modify in-place. Why the change? :)

-Toke

