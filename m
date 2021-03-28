Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D634BB83
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 09:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhC1HYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 03:24:05 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:37779 "EHLO
        outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhC1HXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 03:23:52 -0400
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.94)
          with esmtps (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1lQPlz-001GNn-2X; Sun, 28 Mar 2021 09:23:47 +0200
Received: from dynamic-078-054-150-182.78.54.pool.telefonica.de ([78.54.150.182] helo=[192.168.1.10])
          by inpost2.zedat.fu-berlin.de (Exim 4.94)
          with esmtpsa (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1lQPly-00416X-RZ; Sun, 28 Mar 2021 09:23:47 +0200
Subject: Re: [PATCH, v2] tools: Remove inclusion of ia64-specific version of
 errno.h header
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20210323180428.855488-1-glaubitz@physik.fu-berlin.de>
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Message-ID: <23d37c94-b1ab-803e-a397-b62e846e03cd@physik.fu-berlin.de>
Date:   Sun, 28 Mar 2021 09:23:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210323180428.855488-1-glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 78.54.150.182
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 3/23/21 7:04 PM, John Paul Adrian Glaubitz wrote:
> There is no longer an ia64-specific version of the errno.h header
> below arch/ia64/include/uapi/asm/, so trying to build tools/bpf
> fails with:
> 
>   CC       /usr/src/linux/tools/bpf/bpftool/btf_dumper.o
> In file included from /usr/src/linux/tools/include/linux/err.h:8,
>                  from btf_dumper.c:11:
> /usr/src/linux/tools/include/uapi/asm/errno.h:13:10: fatal error: ../../../arch/ia64/include/uapi/asm/errno.h: No such file or directory
>    13 | #include "../../../arch/ia64/include/uapi/asm/errno.h"
>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> compilation terminated.
> 
> Thus, just remove the inclusion of the ia64-specific errno.h so that
> the build will use the generic errno.h header on this target which was
> used there anyway as the ia64-specific errno.h was just a wrapper for
> the generic header.
> 
> Fixes: c25f867ddd00 ("ia64: remove unneeded uapi asm-generic wrappers")
> Signed-off-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> ---
>  tools/include/uapi/asm/errno.h | 2 --
>  1 file changed, 2 deletions(-)
> 
>  v2:
>  - Rephrase summary
> 
> diff --git a/tools/include/uapi/asm/errno.h b/tools/include/uapi/asm/errno.h
> index 637189ec1ab9..d30439b4b8ab 100644
> --- a/tools/include/uapi/asm/errno.h
> +++ b/tools/include/uapi/asm/errno.h
> @@ -9,8 +9,6 @@
>  #include "../../../arch/alpha/include/uapi/asm/errno.h"
>  #elif defined(__mips__)
>  #include "../../../arch/mips/include/uapi/asm/errno.h"
> -#elif defined(__ia64__)
> -#include "../../../arch/ia64/include/uapi/asm/errno.h"
>  #elif defined(__xtensa__)
>  #include "../../../arch/xtensa/include/uapi/asm/errno.h"
>  #else
> 

Shall I ask Andrew Morton to pick up this patch? It's needed to fix the Debian
kernel build on ia64 and it would be great if it could be included for 5.12.

Adrian

-- 
 .''`.  John Paul Adrian Glaubitz
: :' :  Debian Developer - glaubitz@debian.org
`. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
  `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

