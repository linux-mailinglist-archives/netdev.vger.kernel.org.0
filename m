Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83392B6D73
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 19:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731224AbgKQSeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 13:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731155AbgKQSeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 13:34:00 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1390CC0617A7
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 10:33:59 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 35so6540930ple.12
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 10:33:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fQkJ2Lw7TUY5jWjGmBKfeemBsnDuv9nUetOaxVaTDb4=;
        b=FOpWOWZ05TYauQMbSdTxp0fgyN9Bein9v/GU3nUJ5GbChz7CnzuqeS4AxmICA14vVB
         Eg1e//DorMxa8cAepNKfB05i3vkADKgfBkiZetCrhH16tZe79b4aWMVQ6rbqC+YtP+SH
         wiS91r7s8pvIgGrM113tDg7IweEGe4s3NnTIgpgXCag5rjfthlPzHTqa91+Q4FaoaFu8
         GQgr2x1TCknG4pdsc3NzOkdKNAFrONNCPyt+1rlSaShH1+lDJKM7rErQgFGeDaQvaeqj
         SD+cxw1GSSr6HtDJedL+lcR+FLXwo9TxdDurB5R1As0YAPMDE64jyqqMBykdsw7iaUBO
         0omA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fQkJ2Lw7TUY5jWjGmBKfeemBsnDuv9nUetOaxVaTDb4=;
        b=HpXxUrdD/14RRFLkr7qGa/QoOvtnE4bzIfTZL7a1EqyPNQNJRi2ngxIBLo4rCegRJ1
         1uGt5RD9/tlsyE7ZozWkLE4LrhyJ5S4PzNc7fUD7k6lcr8GarrPfRUQx/VO/RxFt3Aag
         0Lvf5esTWlS/velusnDauNGDzWgnVeWgeG8rsmqYVLljRTDI5i9plMH5atKyvifBwgZS
         /Iq8l8Wi3OYZ0SSH30Lg72GIsKmnJDQzVhG8KDxmLohLNPgBnicp4LqRlN6aZLYSjZ3g
         iGxpGpNSyTk6nOnQ9YHXoa3JMsUDLen5ycc5h0h6eraVjodNTMZcTI5oGEo3RbccGd/T
         7ctw==
X-Gm-Message-State: AOAM533Efb/s0ftSRwjZCpcUcws21guC6S5EsoewNkBr6xhhUTaVmWLI
        DEOXllB/BRiVSHwxNlCL4ujdZgFZxNAUo82oiKp1Tg==
X-Google-Smtp-Source: ABdhPJxNrdUEUn6Bg/zpvhCGebQOUEHrL65JPRKGEY7t8WkM5jEzW+ALEFSGPs8xKrHjziq/MVHQETJ1L5RnNaPJ1gs=
X-Received: by 2002:a17:902:e901:b029:d8:e727:2595 with SMTP id
 k1-20020a170902e901b02900d8e7272595mr749648pld.56.1605638038233; Tue, 17 Nov
 2020 10:33:58 -0800 (PST)
MIME-Version: 1.0
References: <20201117173828.27292-1-info@metux.net>
In-Reply-To: <20201117173828.27292-1-info@metux.net>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 17 Nov 2020 10:33:47 -0800
Message-ID: <CAKwvOd=OsYyPYDg=CU5cHGNxYj6UKcwUKTmrweeERJLkiVwekw@mail.gmail.com>
Subject: Re: [PATCH] lib: compile memcat_p only when needed
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 9:38 AM Enrico Weigelt, metux IT consult
<info@metux.net> wrote:
>
> The library function memcat_p() is currently used only once.
> (drivers/hwtracing/stm). So, often completely unused.

Any harm in just moving the definition into drivers/hwtracing/stm?
Then we don't need any Kconfig additions.  There never were many users
of this function, and there probably never will be.

>
> Reducing the kernel size by about 4k by compiling it
> conditionally, only when needed.
>
> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---
>  drivers/hwtracing/stm/Kconfig | 1 +
>  lib/Kconfig                   | 3 +++
>  lib/Kconfig.debug             | 1 +
>  lib/Makefile                  | 4 +++-
>  4 files changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/hwtracing/stm/Kconfig b/drivers/hwtracing/stm/Kconfig
> index aad594fe79cc..8ce5cfd759d1 100644
> --- a/drivers/hwtracing/stm/Kconfig
> +++ b/drivers/hwtracing/stm/Kconfig
> @@ -3,6 +3,7 @@ config STM
>         tristate "System Trace Module devices"
>         select CONFIGFS_FS
>         select SRCU
> +       select GENERIC_LIB_MEMCAT_P
>         help
>           A System Trace Module (STM) is a device exporting data in System
>           Trace Protocol (STP) format as defined by MIPI STP standards.
> diff --git a/lib/Kconfig b/lib/Kconfig
> index b46a9fd122c8..b42ed8d68937 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -686,6 +686,9 @@ config GENERIC_LIB_CMPDI2
>  config GENERIC_LIB_UCMPDI2
>         bool
>
> +config GENERIC_LIB_MEMCAT_P
> +       tristate
> +
>  config PLDMFW
>         bool
>         default n
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index c789b39ed527..beb5adb2f0b7 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2334,6 +2334,7 @@ config TEST_DEBUG_VIRTUAL
>
>  config TEST_MEMCAT_P
>         tristate "Test memcat_p() helper function"
> +       select GENERIC_LIB_MEMCAT_P
>         help
>           Test the memcat_p() helper for correctly merging two
>           pointer arrays together.
> diff --git a/lib/Makefile b/lib/Makefile
> index ce45af50983a..18fd6630be0b 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -36,7 +36,9 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
>          flex_proportions.o ratelimit.o show_mem.o \
>          is_single_threaded.o plist.o decompress.o kobject_uevent.o \
>          earlycpio.o seq_buf.o siphash.o dec_and_lock.o \
> -        nmi_backtrace.o nodemask.o win_minmax.o memcat_p.o
> +        nmi_backtrace.o nodemask.o win_minmax.o
> +
> +obj-$(CONFIG_GENERIC_LIB_MEMCAT_P) += memcat_p.o
>
>  lib-$(CONFIG_PRINTK) += dump_stack.o
>  lib-$(CONFIG_SMP) += cpumask.o
> --
> 2.11.0
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20201117173828.27292-1-info%40metux.net.



-- 
Thanks,
~Nick Desaulniers
