Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4A204A21
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 08:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730684AbgFWGqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 02:46:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730489AbgFWGqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 02:46:08 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D069C061573;
        Mon, 22 Jun 2020 23:46:08 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id l17so17848094qki.9;
        Mon, 22 Jun 2020 23:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z37O1JhZblGRR9XyeVvzQt8v1tfzmZa9sqvhTNuDXR0=;
        b=a4dXtCMUKhjvq82EQaksXpU9Olew8u4YngTHDwdGwu2Bf8dUHli+wBECGT0PObT5xg
         xBb+CW4Oykt2C6fCl+LDq15KWMqg7NuchoPFD/simFayiK+L8LNRKn+6//mT1sPSL5D2
         r8g3+LMmPqsVFEx0gAghFPq74uSh35+y5SOA+cWioJpHLPtkUhjEQOynQgP4R+vtRDh7
         yGkIO3t36kD/F3xQaQAWK6vqerh4M07RyxOYSWXQErwSmRHg0XHGPyUWpJz0TpA4WptE
         cN4MWPLPZACP96accfU/kcouzbp3+xgO0c1PxRNH2Wp7gvH8/NEGnXRd74RyXNakjR0q
         776A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z37O1JhZblGRR9XyeVvzQt8v1tfzmZa9sqvhTNuDXR0=;
        b=Ul3NhH6IJXM392SRxvUOpdWtntwTQ4+5FOLxFPOA4MRHaDdb4r33CCpcHw5Z+YfoT9
         oyvvZUgn5lzMA999ZrRS41vAqjptuLFEFVXjQgdaMbr9uEieO1EiWkLeJYbaqEt0Jzr8
         f/0db2s077oBiRaO9sOcvRnjPeZ5CEoUJHtRygFtH+etUBNhUXx6RLcOX4mCBYMljmE1
         CafQupzmDycz4CFCJLc35n8E1te4VKKYPPxzvde3PyfmlXdkT+EkNI0HUED7LI0ALqpk
         v6LMe4VXCAK/KQWZ0uuM2aicSRiMJ/8oUu4O1/BmNbSNR3gBi8JYc73Zp5YMVd7LEdOU
         7kpw==
X-Gm-Message-State: AOAM531+D9NWrO4tXtFWPq+HF0A8fAUrcM8thsjcNReQsAgeDbEAjCdJ
        fhn48hNGFlVXq3Pie0O7aSKILhmkRUFWDJbBstk=
X-Google-Smtp-Source: ABdhPJz0F6jCPxfp8XsJiy3z3Sw3QXB2x2H0kZHBbkyaZF3Ze5Yf6PeKkacGoWpGoigXM2H+9N8u+NJej+BhDipo2LM=
X-Received: by 2002:a05:620a:b84:: with SMTP id k4mr19217297qkh.39.1592894767726;
 Mon, 22 Jun 2020 23:46:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200623003626.3072825-1-yhs@fb.com> <20200623003638.3074707-1-yhs@fb.com>
In-Reply-To: <20200623003638.3074707-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 23:45:56 -0700
Message-ID: <CAEf4BzYaEb+2uhQ4MaLAttibTE8HCAbRqFaQjSs-yyx8kxROuA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 11/15] tools/bpf: refactor some net macros to
 libbpf bpf_tracing_net.h
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 5:38 PM Yonghong Song <yhs@fb.com> wrote:
>
> Refactor bpf_iter_ipv6_route.c and bpf_iter_netlink.c
> so net macros, originally from various include/linux header
> files, are moved to a new libbpf installable header file
> bpf_tracing_net.h. The goal is to improve reuse so
> networking tracing programs do not need to
> copy these macros every time they use them.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  tools/lib/bpf/Makefile                           |  1 +
>  tools/lib/bpf/bpf_tracing_net.h                  | 16 ++++++++++++++++
>  .../selftests/bpf/progs/bpf_iter_ipv6_route.c    |  7 +------
>  .../selftests/bpf/progs/bpf_iter_netlink.c       |  4 +---
>  4 files changed, 19 insertions(+), 9 deletions(-)
>  create mode 100644 tools/lib/bpf/bpf_tracing_net.h
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index bf8ed134cb8a..3d766c80eb78 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -257,6 +257,7 @@ install_headers: $(BPF_HELPER_DEFS)
>                 $(call do_install,bpf_helpers.h,$(prefix)/include/bpf,644); \
>                 $(call do_install,$(BPF_HELPER_DEFS),$(prefix)/include/bpf,644); \
>                 $(call do_install,bpf_tracing.h,$(prefix)/include/bpf,644); \
> +               $(call do_install,bpf_tracing_net.h,$(prefix)/include/bpf,644); \
>                 $(call do_install,bpf_endian.h,$(prefix)/include/bpf,644); \
>                 $(call do_install,bpf_core_read.h,$(prefix)/include/bpf,644);
>
> diff --git a/tools/lib/bpf/bpf_tracing_net.h b/tools/lib/bpf/bpf_tracing_net.h
> new file mode 100644
> index 000000000000..1f38a1098727
> --- /dev/null
> +++ b/tools/lib/bpf/bpf_tracing_net.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
> +#ifndef __BPF_TRACING_NET_H__
> +#define __BPF_TRACING_NET_H__
> +
> +#define IFNAMSIZ               16
> +
> +#define RTF_GATEWAY            0x0002
> +
> +#define fib_nh_dev             nh_common.nhc_dev
> +#define fib_nh_gw_family       nh_common.nhc_gw_family
> +#define fib_nh_gw6             nh_common.nhc_gw.ipv6
> +
> +#define sk_rmem_alloc          sk_backlog.rmem_alloc
> +#define sk_refcnt              __sk_common.skc_refcnt

Question to networking guys. How probable it is for these and similar
definitions to ever be changed?

I'm a bit hesitant to make any stability guarantees (which is implied
by libbpf-provided headers). I don't want us to get into the game of
trying to maintain this across multiple kernel versions, if they are
going to be changed.

Let's for now keep bpf_tracing_net.h under selftests/bpf? It's still
good to have these definitions, because we can point people to it.

> +
> +#endif

[...]
