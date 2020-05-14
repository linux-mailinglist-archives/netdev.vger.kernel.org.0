Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81EAA1D4138
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbgENWjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728313AbgENWjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:39:09 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944BEC061A0C;
        Thu, 14 May 2020 15:39:09 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id f13so654302qkh.2;
        Thu, 14 May 2020 15:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bMinuAL0on0nEeytk+i1ggyxgzF85qPQb/U8FR8LWVQ=;
        b=OtYpqw0SaZPRpgQP54ehPSSFRBhvbbbmn7mU6PHBGKa+fjGihS8tUdxt1SYlrSXqCz
         0X6jfeipBVIFzshe1u7BhsFxBndmkLW1TFGhnIbIl9wdpLQedMBcuSf7YLlkepFR4vDk
         AlQ2dy8wF0aub5JKZyLUuwMV1gF2dFyo9EJzGTL1rIMsfpA3uuILxXgZOlHKOBBleCxM
         GemDb8Y9SGXMbU0Mk9cZGUnpo54yw5ksODLqtsJ+wVUmLEwWlPCZ4qsC4AiV6hUk/IUh
         /MaYIHS/Ja4SSix/WmgODfY33pYSqmJ9ityhzMo8GowpGlhB/EWPgtDl3l1yffPB5UtE
         N3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bMinuAL0on0nEeytk+i1ggyxgzF85qPQb/U8FR8LWVQ=;
        b=kXpQv2qi7U3iEFpFZba6boJkBe0m0e3Y83QsQ0XdBxFTt7cxM3EXwHBj/JL/EwFsvv
         F3quiUm9BHg3On0GztkCj2lVra4WbEPgQR/xa/RUv9n3wxmUqqdmBUuIrmDARWTiLNLk
         +4Hs8yMw2yAvMgCDIKfpzNrOjhV12Cwjn7kHcyrfgowmYhez6R/hrDv1ScMy4gqEG9x2
         a2eTwlbP1drI90h1U/s49tzTFzLGNkcmr8tfLimHhfyTJ8uZVGHa8Hm2857VS/9GvUAV
         CizUB7NOiufu4CInST9LBQ4SAJZNBMuXnNp11rk2oIDSNWtgX+KN8XtjsShnggIKmi8r
         RP/Q==
X-Gm-Message-State: AOAM530zPZAO/Kx23zeuP3Nlizf1ch3IV29eJhsg3xHzn4GHRas8mDHx
        C1dTGC5XXQetL2pVm1gxUSETdC1h7E3zFlmQPn8=
X-Google-Smtp-Source: ABdhPJzT8OcpGZTjqDvpZ5/1Ff56Ml4TXmvp7rsHiEnfhhSIhVgSoFTQwY3GyycouLKplC8FKbIfi+EN1jy/KRMQB2M=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr665162qka.449.1589495948678;
 Thu, 14 May 2020 15:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200506132946.2164578-1-jolsa@kernel.org> <20200506132946.2164578-7-jolsa@kernel.org>
In-Reply-To: <20200506132946.2164578-7-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 15:38:57 -0700
Message-ID: <CAEf4BzYQyWAGtJtv=fvS3PRXjL66L0OJdjGf1t92a65S9pJQvg@mail.gmail.com>
Subject: Re: [PATCH 6/9] bpf: Compile bpfwl tool at kernel compilation start
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 6:31 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> The bpfwl tool will be used during the vmlinux linking,
> so it's necessary it's ready.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Makefile           | 21 +++++++++++++++++----
>  tools/Makefile     |  3 +++
>  tools/bpf/Makefile |  5 ++++-
>  3 files changed, 24 insertions(+), 5 deletions(-)
>

[...]

>
> +prepare-bpfwl: $(bpfwl_target)
> +ifeq ($(SKIP_BTF_WHITELIST_GENERATION),1)
> +       @echo "warning: Cannot use BTF whitelist checks, please install libelf-dev, libelf-devel or elfutils-libelf-devel" >&2
> +endif

When we added BTF dedup and generation first time, we also made pahole
unavailability or any error during deduplication process an error. It
actually was very confusing to users and they often missed that BTF
generation didn't happen, but they would notice it only at runtime
(after a confusing debugging session).

So I wonder if it's better to make this an error instead? Just guard
whitelist generation on whether CONFIG_DEBUG_INFO_BTF is enabled or
not?

>  # Generate some files
>  # ---------------------------------------------------------------------------
>
> diff --git a/tools/Makefile b/tools/Makefile
> index bd778812e915..85af6ebbce91 100644
> --- a/tools/Makefile
> +++ b/tools/Makefile
> @@ -67,6 +67,9 @@ cpupower: FORCE
>  cgroup firewire hv guest bootconfig spi usb virtio vm bpf iio gpio objtool leds wmi pci firmware debugging: FORCE
>         $(call descend,$@)
>
> +bpf/%: FORCE
> +       $(call descend,$@)
> +
>  liblockdep: FORCE
>         $(call descend,lib/lockdep)
>
> diff --git a/tools/bpf/Makefile b/tools/bpf/Makefile
> index f897eeeb0b4f..d4ea2b5a2e58 100644
> --- a/tools/bpf/Makefile
> +++ b/tools/bpf/Makefile
> @@ -124,5 +124,8 @@ runqslower_install:
>  runqslower_clean:
>         $(call descend,runqslower,clean)
>
> +bpfwl:
> +       $(call descend,bpfwl)
> +
>  .PHONY: all install clean bpftool bpftool_install bpftool_clean \
> -       runqslower runqslower_install runqslower_clean
> +       runqslower runqslower_install runqslower_clean bpfwl

what about install/clean subcommands? At least clean seems like a good idea?

> --
> 2.25.4
>
