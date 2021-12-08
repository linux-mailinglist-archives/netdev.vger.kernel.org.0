Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7017A46D950
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 18:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbhLHRQF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 12:16:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234605AbhLHRQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 12:16:04 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83264C061746;
        Wed,  8 Dec 2021 09:12:32 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id z5so10751787edd.3;
        Wed, 08 Dec 2021 09:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zi8oo1PZizw8wEpDiOLL07lx2GDHOYXRbCD0oQdOBv4=;
        b=BvbrsObi+qT4Kh60LTdhZFPxy4nsurH4Zpy3l+ppSrSEFTInp/yHeMSoXY5b6lc/M9
         J+R4VBjZy3DGBwwhXWPUZCQPIMr0oLsjZxdMxWUfHqrES8d2Dh2GnkDqOahaHPHhBeDl
         UTZaSehEDXK8f+wG8PdThQ/f9/dCJQ0zTk6xRJka+IuAnfMYWpxuZIICvB8qYuvR4R0n
         Kn63nmBw2CxgM9fJZNWBRwghp5A9FG/Kkrh/ZNSyz1T0Z1LLY5XLpNoO02AHAuj5bO4p
         00YiP9tvZCkc2g4dxbYZ2r3X+05+MMMgxdNXs4+4CJUsAckaGSg+sSOAyvrNLSHdcFLD
         ExuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zi8oo1PZizw8wEpDiOLL07lx2GDHOYXRbCD0oQdOBv4=;
        b=tQD3mfXj5cwvRGWVNAOM+1MBr5QVpGZKCkEb3ecwqJfCZg9fwKdSEijH3UsAVgqkdh
         1PAi+vy/1iF5uIa3qlZ1aTuTMq6EZLRzt4BFXVnXXRa8jag557tKNbXe1aR8EgGNmyqH
         D6RzizxY7r2Eerw6nRT/p2mc6TdY8bDD6mq2aA4vtjdmfNFXhPoJbGgiAXD2Lg7KDoTc
         GkvEEEkvDkwMbFOKBvNG4M5j0vISIbOHEURgNWsyeHmqJpnHpIZ0OMZCWvnhYxOGMoOf
         R2/+M/3UgkfKQ9bswCe6j7MC7fH6vyELZBHZpNzpyiyDIS0vmVyCvoHmjGffBt61M5kz
         iqFA==
X-Gm-Message-State: AOAM5333BqImqm1HbokChaFNOgfhaCNLR9+epqoO5ryLceAKATrJwExj
        3DFkksaA/btLcS1IZypORA==
X-Google-Smtp-Source: ABdhPJxNH6F6yUOi+QCXoRNyaMIvWKHl4u8joVLBEhadTge3/FhO3F9gYXEejNUNqaDm2hD7Xi9IWQ==
X-Received: by 2002:a17:907:6291:: with SMTP id nd17mr8993126ejc.194.1638983550551;
        Wed, 08 Dec 2021 09:12:30 -0800 (PST)
Received: from localhost.localdomain ([46.53.251.178])
        by smtp.gmail.com with ESMTPSA id hx14sm1725391ejc.92.2021.12.08.09.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 09:12:30 -0800 (PST)
Date:   Wed, 8 Dec 2021 20:12:27 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     akpm@linux-foundation.org, keescook@chromium.org,
        laniel_francis@privacyrequired.com,
        andriy.shevchenko@linux.intel.com, linux@roeck-us.net,
        andreyknvl@gmail.com, dja@axtens.net, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH -next 1/2] string.h: Introduce memset_range() for wiping
 members
Message-ID: <YbDne/nYsVai5pCV@localhost.localdomain>
References: <20211208030451.219751-1-xiujianfeng@huawei.com>
 <20211208030451.219751-2-xiujianfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211208030451.219751-2-xiujianfeng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 11:04:50AM +0800, Xiu Jianfeng wrote:
> Motivated by memset_after() and memset_startat(), introduce a new helper,
> memset_range() that takes the target struct instance, the byte to write,
> and two member names where zeroing should start and end.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  include/linux/string.h | 20 ++++++++++++++++++++
>  lib/memcpy_kunit.c     | 12 ++++++++++++
>  2 files changed, 32 insertions(+)
> 
> diff --git a/include/linux/string.h b/include/linux/string.h
> index b6572aeca2f5..7f19863253f2 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -291,6 +291,26 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
>  	       sizeof(*(obj)) - offsetof(typeof(*(obj)), member));	\
>  })
>  
> +/**
> + * memset_range - Set a value ranging from member1 to member2, boundary included.
> + *
> + * @obj: Address of target struct instance
> + * @v: Byte value to repeatedly write
> + * @member1: struct member to start writing at
> + * @member2: struct member where writing should stop
> + *
> + */
> +#define memset_range(obj, v, member_1, member_2)			\
> +({									\
> +	u8 *__ptr = (u8 *)(obj);					\
> +	typeof(v) __val = (v);						\
> +	BUILD_BUG_ON(offsetof(typeof(*(obj)), member_1) >		\
> +		     offsetof(typeof(*(obj)), member_2));		\
> +	memset(__ptr + offsetof(typeof(*(obj)), member_1), __val,	\
> +	       offsetofend(typeof(*(obj)), member_2) -			\
> +	       offsetof(typeof(*(obj)), member_1));			\
> +})

"u8*" should be "void*" as kernel legitimises pointer arithmetic on void*
and there is no dereference.

__val is redundant, just toss "v" into memset(), it will do the right
thing. In fact, toss "__ptr" as well, it is simply unnecessary.

All previous memsets are the same...
