Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B6A2B7409
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 02:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbgKRB6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 20:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgKRB6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 20:58:35 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C76C061A48;
        Tue, 17 Nov 2020 17:58:35 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id l14so188821ybq.3;
        Tue, 17 Nov 2020 17:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i95B+mcKwKcEEFXnIfJJSp56iC1ORoijGOfO3BXCsac=;
        b=A+v4rQPbqcF4+Kqaetq1y22nkQtpMI9hKC4Nu2KUVJhwnVYZCJCko2LwlrzkwQQzn7
         ezWFc4VrvdF0yJ2i9jx1vBxaJjH+7HzKVVBSEo/xcIQpEj6nVkii2IQduVTz4caJxWDS
         eVIv3YhW0ys3VtQT/FPAPY7Bw72Tw82o9NjN6jt+2vIdGKQMYov4TNUPLZu92Z9PG/Ky
         JmsWbeh+YkQpmHjJnjemyDNO0Xyj2bTaZxC3oVPQV2aZkGaqQ/6oTvMKT3g62OYypCJK
         k3GlRN9BYCI3/V9sVUg3tz2rlDqBiI5KUFVdXZcTDZT1m1DF+0dyWfEH+RiAD8bqrVqs
         T2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i95B+mcKwKcEEFXnIfJJSp56iC1ORoijGOfO3BXCsac=;
        b=Os7nnqW2r4ywefVyryH5IxyD3anG/+714XMNPXBZqhJ0NYoS5t+7hGeHhoLzQa0w+h
         Rskprz0w05hs8Mxz62v9Dp1hoVXDz8Gym9oPKwIiytPfUwuE7Z7C/0ZIQNmVgoIWLKBS
         eiu2WC7267hjJ4MEknnR61SMNM884mRV5Im+HYeL7Ucp03KupqThZBDRGNIODk/4CaEs
         3F0EBHnd3ZmcJsZDOAjkb5xtD7vJqu0LDluHmFsJB/LrI8bkJkqXYjZk+KpC/EbkdYXQ
         TfCm7IxOxfCOK6PUpURufu1B6hcVaqcxhlncLXotWE0tqnvUtXCcxzmW4OLixfXTDp3U
         dfKA==
X-Gm-Message-State: AOAM531JyOxv2/N/VAB2hvp9L/QJivNp3YgPTxT/Zrm8wcGi9GsH+lus
        50RbrtsG79P/zhLwUumjAqEqaxwFs4AQplgmUuM=
X-Google-Smtp-Source: ABdhPJz6gkSRtuwtVrhHeY4jdhDED9ojz3+uBYSrOJOcNAH50SfDVucHd4OO9rk6QrxzwmDxuWhUQWy/7Xh4oNjvQg0=
X-Received: by 2002:a25:3d7:: with SMTP id 206mr3669464ybd.27.1605664714910;
 Tue, 17 Nov 2020 17:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20201117145644.1166255-1-danieltimlee@gmail.com> <20201117145644.1166255-2-danieltimlee@gmail.com>
In-Reply-To: <20201117145644.1166255-2-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Nov 2020 17:58:24 -0800
Message-ID: <CAEf4BzZ9Sr0PXvZAa74phnwm7um9AoN4ELGkNBMvyzvh7vYzRQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] selftests: bpf: move tracing helpers to trace_helper
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo <brakmo@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Yonghong Song <yhs@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>, Thomas Graf <tgraf@suug.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 6:57 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Under the samples/bpf directory, similar tracing helpers are
> fragmented around. To keep consistent of tracing programs, this commit
> moves the helper and define locations to increase the reuse of each
> helper function.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
>
> ---
>  samples/bpf/Makefile                        |  2 +-
>  samples/bpf/hbm.c                           | 51 ++++-----------------
>  tools/testing/selftests/bpf/trace_helpers.c | 33 ++++++++++++-
>  tools/testing/selftests/bpf/trace_helpers.h |  3 ++
>  4 files changed, 45 insertions(+), 44 deletions(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index aeebf5d12f32..3e83cd5ca1c2 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -110,7 +110,7 @@ xdp_fwd-objs := xdp_fwd_user.o
>  task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
>  xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
>  ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
> -hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
> +hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS) $(TRACE_HELPERS)
>
>  # Tell kbuild to always build the programs
>  always-y := $(tprogs-y)
> diff --git a/samples/bpf/hbm.c b/samples/bpf/hbm.c
> index 400e741a56eb..b9f9f771dd81 100644
> --- a/samples/bpf/hbm.c
> +++ b/samples/bpf/hbm.c
> @@ -48,6 +48,7 @@
>
>  #include "bpf_load.h"
>  #include "bpf_rlimit.h"
> +#include "trace_helpers.h"
>  #include "cgroup_helpers.h"
>  #include "hbm.h"
>  #include "bpf_util.h"
> @@ -65,51 +66,12 @@ bool no_cn_flag;
>  bool edt_flag;
>
>  static void Usage(void);
> -static void read_trace_pipe2(void);
>  static void do_error(char *msg, bool errno_flag);
>
> -#define DEBUGFS "/sys/kernel/debug/tracing/"
> -
>  struct bpf_object *obj;
>  int bpfprog_fd;
>  int cgroup_storage_fd;
>
> -static void read_trace_pipe2(void)

This is used only in hbm.c, why move it into trace_helpers.c?

> -{
> -       int trace_fd;
> -       FILE *outf;
> -       char *outFname = "hbm_out.log";
> -

[...]
