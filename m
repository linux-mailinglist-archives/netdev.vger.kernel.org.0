Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDDF2C8C7A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388054AbgK3SRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388042AbgK3SRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:17:12 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBBE1C0613D4
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:16:31 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id v21so6911705plo.12
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 10:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GNY/70CAQC3eXUNKhqPKEV6KDBxfhoyyaZSVMFjGEY8=;
        b=IYOlgdTZd++fVWTYletOkoUT3ndMy448aAtQuAIXDNftZRVE+GdVf3fPiPCMKskPDE
         sEktxLJpNMGGz7Oxbfz18HSeFME8OUGXj8f6WRq3b9UI9lgCYn9U8IaSQuJt8MrwQvtz
         dJIi93LLvWtJlbJZPKnlStHRhPV1Jxs+vthk1vqmGEkhG1mnbfkMWVrMj9B+m/1akesX
         D0rJ2Nl4fQ/uZ6C4E2nQ+G2pxRRwj5RgM0mIvCQAAKh0oJpQyPk3xPaTi1nWLR+9/cUX
         2Ww78lpiLdcwg+xLAvUSMXCQ736Yu435e9wGr9Vy77yHpB0TSBBHjKlKvcfqoOrPlhxS
         7XKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GNY/70CAQC3eXUNKhqPKEV6KDBxfhoyyaZSVMFjGEY8=;
        b=fXhDrD9ty2AEnGMkFfyE9+foqwA2tEhTdjlouDHVgrY7JMxdtCSlAHYXfVoofC+3wR
         Sf8Dv9bfsFM9fKZh4q3YSTCN7mlAfAoQvDQw4HiGqU6N0TEobJ6Bupnt4t2QtJ8Ako9R
         VayF4l10rO90l6bh61y/Y4i6/F7YIKd0iJekAf58lrG2fjsWBEqJljp52VeeUuoNSaqy
         XtYTlbqU9xNoqqUNrikuvs9H3CRsjl2lguAzzOZ5u/ZOm7NF0UAykkWG9zqaov+H4IdB
         IbRpJyZZ98NX8LGsmWOohzXW0YQNO/ydtD2xTXZha8d7RxkRQxBnhRNxMdx3Hd7TRR9v
         JRZA==
X-Gm-Message-State: AOAM5325S5yPFUsMP8h6oKjoNHKYXHYdJ0klsH/Z+PzQcWk52ZxSORT7
        pRDhF61aKbJOsL3KTEQsF0dxeB5HkVLTKpKidKtoxg==
X-Google-Smtp-Source: ABdhPJy8erv8/hCViVdBtcoO2Edpvc+flTtuVg1A4WD1itTSnPNxQkMkIAmbHOrLQ7mMhIFOJtuWXXvXhR/xwXw3JDY=
X-Received: by 2002:a17:902:e901:b029:d8:e727:2595 with SMTP id
 k1-20020a170902e901b02900d8e7272595mr19843120pld.56.1606760191169; Mon, 30
 Nov 2020 10:16:31 -0800 (PST)
MIME-Version: 1.0
References: <20201128193335.219395-1-masahiroy@kernel.org>
In-Reply-To: <20201128193335.219395-1-masahiroy@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 30 Nov 2020 10:16:20 -0800
Message-ID: <CAKwvOd=azwa6m84Nyu+EVksmTRnQfd3PRe8gDBmx9vYVs1D_hQ@mail.gmail.com>
Subject: Re: [PATCH v3] Compiler Attributes: remove CONFIG_ENABLE_MUST_CHECK
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 11:34 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Revert commit cebc04ba9aeb ("add CONFIG_ENABLE_MUST_CHECK").
>
> A lot of warn_unused_result warnings existed in 2006, but until now
> they have been fixed thanks to people doing allmodconfig tests.
>
> Our goal is to always enable __must_check where appropriate, so this
> CONFIG option is no longer needed.
>
> I see a lot of defconfig (arch/*/configs/*_defconfig) files having:
>
>     # CONFIG_ENABLE_MUST_CHECK is not set
>
> I did not touch them for now since it would be a big churn. If arch
> maintainers want to clean them up, please go ahead.
>
> While I was here, I also moved __must_check to compiler_attributes.h
> from compiler_types.h
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>
> Changes in v3:
>   - Fix a typo
>
> Changes in v2:
>   - Move __must_check to compiler_attributes.h
>
>  include/linux/compiler_attributes.h                 | 7 +++++++
>  include/linux/compiler_types.h                      | 6 ------
>  lib/Kconfig.debug                                   | 8 --------
>  tools/testing/selftests/wireguard/qemu/debug.config | 1 -
>  4 files changed, 7 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index b2a3f4f641a7..5f3b7edad1a7 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -171,6 +171,13 @@
>   */
>  #define __mode(x)                       __attribute__((__mode__(x)))
>
> +/*
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warn_005funused_005fresult-function-attribute
> + * clang: https://clang.llvm.org/docs/AttributeReference.html#nodiscard-warn-unused-result
> + *
> + */
> +#define __must_check                    __attribute__((__warn_unused_result__))
> +
>  /*
>   * Optional: only supported since gcc >= 7
>   *
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index ac3fa37a84f9..7ef20d1a6c28 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -110,12 +110,6 @@ struct ftrace_likely_data {
>         unsigned long                   constant;
>  };
>
> -#ifdef CONFIG_ENABLE_MUST_CHECK
> -#define __must_check           __attribute__((__warn_unused_result__))
> -#else
> -#define __must_check
> -#endif
> -
>  #if defined(CC_USING_HOTPATCH)
>  #define notrace                        __attribute__((hotpatch(0, 0)))
>  #elif defined(CC_USING_PATCHABLE_FUNCTION_ENTRY)
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index c789b39ed527..cb8ef4fd0d02 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -286,14 +286,6 @@ config GDB_SCRIPTS
>
>  endif # DEBUG_INFO
>
> -config ENABLE_MUST_CHECK
> -       bool "Enable __must_check logic"
> -       default y
> -       help
> -         Enable the __must_check logic in the kernel build.  Disable this to
> -         suppress the "warning: ignoring return value of 'foo', declared with
> -         attribute warn_unused_result" messages.
> -
>  config FRAME_WARN
>         int "Warn for stack frames larger than"
>         range 0 8192
> diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
> index b50c2085c1ac..fe07d97df9fa 100644
> --- a/tools/testing/selftests/wireguard/qemu/debug.config
> +++ b/tools/testing/selftests/wireguard/qemu/debug.config
> @@ -1,5 +1,4 @@
>  CONFIG_LOCALVERSION="-debug"
> -CONFIG_ENABLE_MUST_CHECK=y
>  CONFIG_FRAME_POINTER=y
>  CONFIG_STACK_VALIDATION=y
>  CONFIG_DEBUG_KERNEL=y
> --
> 2.27.0
>


-- 
Thanks,
~Nick Desaulniers
