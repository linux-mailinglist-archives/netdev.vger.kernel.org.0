Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66FD3F0BAA
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbhHRTTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhHRTTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:19:22 -0400
X-Greylist: delayed 567 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 Aug 2021 12:18:44 PDT
Received: from confino.investici.org (confino.investici.org [IPv6:2a00:c38:11e:ffff::a020])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC70C061764;
        Wed, 18 Aug 2021 12:18:44 -0700 (PDT)
Received: from mx1.investici.org (unknown [127.0.0.1])
        by confino.investici.org (Postfix) with ESMTP id 4Gqcrh08nxz10yG;
        Wed, 18 Aug 2021 19:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=privacyrequired.com;
        s=stigmate; t=1629313748;
        bh=zZRv+nXoCrBil3F5oNtg2nOIZFdUyNScEfpQhHkWs20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuNyCGrF4TFImYa8YkqQMbYM79KtRR5mjYpqhKJM6XXrw3sAON1jt+Y/v45iEN+cy
         Nbzj3fNcPYxB8NOjFzB0xdXNDXJvqNY6iamhJ9vb6u8qWPeDiUAbgsciFPC3g7lCn0
         bKt0uIxCi4lHr8vwhgUg7zZ7PXj3VH8B7+AkRuxE=
Received: from [212.103.72.250] (mx1.investici.org [212.103.72.250]) (Authenticated sender: laniel_francis@privacyrequired.com) by localhost (Postfix) with ESMTPSA id 4Gqcrf3wsYz10y6;
        Wed, 18 Aug 2021 19:09:06 +0000 (UTC)
From:   Francis Laniel <laniel_francis@privacyrequired.com>
To:     linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Axtens <dja@axtens.net>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-staging@lists.linux.dev,
        linux-block@vger.kernel.org, linux-kbuild@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2 27/63] fortify: Move remaining fortify helpers into fortify-string.h
Date:   Wed, 18 Aug 2021 21:05:58 +0200
Message-ID: <77588349.MC4sUV1sfq@machine>
In-Reply-To: <20210818060533.3569517-28-keescook@chromium.org>
References: <20210818060533.3569517-1-keescook@chromium.org> <20210818060533.3569517-28-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi.


Le mercredi 18 ao=FBt 2021, 08:04:57 CEST Kees Cook a =E9crit :
> When commit a28a6e860c6c ("string.h: move fortified functions definitions
> in a dedicated header.") moved the fortify-specific code, some helpers
> were left behind. Moves the remaining fortify-specific helpers into
> fortify-string.h so they're together where they're used. This requires
> that any FORTIFY helper function prototypes be conditionally built to
> avoid "no prototype" warnings. Additionally removes unused helpers.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Francis Laniel <laniel_francis@privacyrequired.com>
> Cc: Daniel Axtens <dja@axtens.net>
> Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
> Cc: Andrey Konovalov <andreyknvl@google.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/fortify-string.h | 7 +++++++
>  include/linux/string.h         | 9 ---------
>  lib/string_helpers.c           | 2 ++
>  3 files changed, 9 insertions(+), 9 deletions(-)
>=20
> diff --git a/include/linux/fortify-string.h b/include/linux/fortify-strin=
g.h
> index c1be37437e77..7e67d02764db 100644
> --- a/include/linux/fortify-string.h
> +++ b/include/linux/fortify-string.h
> @@ -2,6 +2,13 @@
>  #ifndef _LINUX_FORTIFY_STRING_H_
>  #define _LINUX_FORTIFY_STRING_H_
>=20
> +#define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inlin=
e))
> +#define __RENAME(x) __asm__(#x)
> +
> +void fortify_panic(const char *name) __noreturn __cold;
> +void __read_overflow(void) __compiletime_error("detected read beyond size
> of object (1st parameter)"); +void __read_overflow2(void)
> __compiletime_error("detected read beyond size of object (2nd parameter)"=
);
> +void __write_overflow(void) __compiletime_error("detected write beyond
> size of object (1st parameter)");
>=20
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>  extern void *__underlying_memchr(const void *p, int c, __kernel_size_t
> size) __RENAME(memchr); diff --git a/include/linux/string.h
> b/include/linux/string.h
> index b48d2d28e0b1..9473f81b9db2 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -249,15 +249,6 @@ static inline const char *kbasename(const char *path)
>  	return tail ? tail + 1 : path;
>  }
>=20
> -#define __FORTIFY_INLINE extern __always_inline __attribute__((gnu_inlin=
e))
> -#define __RENAME(x) __asm__(#x)
> -
> -void fortify_panic(const char *name) __noreturn __cold;
> -void __read_overflow(void) __compiletime_error("detected read beyond size
> of object passed as 1st parameter"); -void __read_overflow2(void)
> __compiletime_error("detected read beyond size of object passed as 2nd
> parameter"); -void __read_overflow3(void) __compiletime_error("detected
> read beyond size of object passed as 3rd parameter"); -void
> __write_overflow(void) __compiletime_error("detected write beyond size of
> object passed as 1st parameter"); -
>  #if !defined(__NO_FORTIFY) && defined(__OPTIMIZE__) &&
> defined(CONFIG_FORTIFY_SOURCE) #include <linux/fortify-string.h>
>  #endif
> diff --git a/lib/string_helpers.c b/lib/string_helpers.c
> index bde13612c25d..faa9d8e4e2c5 100644
> --- a/lib/string_helpers.c
> +++ b/lib/string_helpers.c
> @@ -883,9 +883,11 @@ char *strreplace(char *s, char old, char new)
>  }
>  EXPORT_SYMBOL(strreplace);
>=20
> +#ifdef CONFIG_FORTIFY_SOURCE
>  void fortify_panic(const char *name)
>  {
>  	pr_emerg("detected buffer overflow in %s\n", name);
>  	BUG();
>  }
>  EXPORT_SYMBOL(fortify_panic);
> +#endif /* CONFIG_FORTIFY_SOURCE */

If I remember correctly, I let these helpers in string.h because I thought=
=20
they could be used by code not related to fortify-string.h.

But you are right and I think it is better to have all the code related to =
one=20
feature in the same place.
I am happy to see the kernel is fortifying, and this contribution is good, =
so=20
here is what I can give:
Acked-by: Francis Laniel <laniel_francis@privacyrequired.com>


Best regards.


