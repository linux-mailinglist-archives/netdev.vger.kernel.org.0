Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904AA41F766
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 00:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355872AbhJAWXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 18:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhJAWXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 18:23:50 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF3FC061775;
        Fri,  1 Oct 2021 15:22:05 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id v10so23513714ybq.7;
        Fri, 01 Oct 2021 15:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PplmTIqSV7QP1/ujjyXlvCRFs+BV1cV6K6VClSOmNZM=;
        b=TL7BYylGTbHjl3FAr+V9/KOE6T9ihwZvf9ut8bsIVJ2qkwJfHqnMD93dwRelLDxacl
         vq6ayJlvBc3WgfAzPogZ08g9pxhyu758QEyr/0eF7I5T/BAPtJNRKNEtuSj5VUcLCOTw
         BhoXEBQ6QF+7W8sZjfJHdlzNlKvd0/8SZDNtrYxuP9JCJ3pyi9LmvQ2EtRcuC0r03RDR
         w3Nw8G/Xlm6H3WkY3uzZniyDLm6U1zH6U7EX605AUpew+LR0n5oqkwvEvVvsSqq7Z/t4
         BanZGyWGO6Dq2SvLhIhWLd90Md3q63uJMraLFRAfoHyRJiTP4DQahAjS94cAb2bYlh9K
         oBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PplmTIqSV7QP1/ujjyXlvCRFs+BV1cV6K6VClSOmNZM=;
        b=zZnxLFAPQWdNX2CgswQv7hbe0C8ZwnNqs61BFRjD284jgTmNv4VS+SLZRYiCG1gE8Z
         ppfJuPuE6imWg7T64K2l3YPYrMbSistJEzLdQT7TNY0YrYC4F1crdaNF59kSo2vHmr+E
         xF+ZkW5/wQ9IpnG140UZaa52XE8ZvppLRq8W8OgVbE0dxlb/XQ6mcFPW8BRuQZDznAbI
         DBvcX1Xe0RsQqPr7gjfychFEuRzXbtR64GE+Py1rfGWFaNgE7R/EoGMT145WyOmXfZJ0
         UGowxQ6J9ylRbDTe6/J50hA8s5BnF7W+xQgNyVrd4tG+U/a/cHcgS8aAxakwqQzGTPKy
         nHfA==
X-Gm-Message-State: AOAM531ixGDWd/vzim9pGMZN12DYA1VTJHiCwkX1s56op2vL2vpzdQdB
        NpHR8mmLWnatBQScvQ5GTmBvvRIGiXJ3s27rNQQsr1YgTS0/rw==
X-Google-Smtp-Source: ABdhPJy44J+80rLa5Di31myaXlaWuAf/bZB+qQ9txJkDjAvVYg3YXpHcOu2tqHLqwlu/dz33QIM2gJx2sWi0kw1CGnc=
X-Received: by 2002:a25:7c42:: with SMTP id x63mr347313ybc.225.1633126920724;
 Fri, 01 Oct 2021 15:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210930091355.2794601-1-houtao1@huawei.com> <20210930091355.2794601-2-houtao1@huawei.com>
In-Reply-To: <20210930091355.2794601-2-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 Oct 2021 15:21:49 -0700
Message-ID: <CAEf4BzardNSbbbDkSJR9GTcpOvmJsYuFqT996dLkJiGHFXZkqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/3] bpf: support writable context for bare tracepoint
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 2:00 AM Hou Tao <houtao1@huawei.com> wrote:
>
> Commit 9df1c28bb752 ("bpf: add writable context for raw tracepoints")
> supports writable context for tracepoint, but it misses the support
> for bare tracepoint which has no associated trace event.
>
> Bare tracepoint is defined by DECLARE_TRACE(), so adding a corresponding
> DECLARE_TRACE_WRITABLE() macro to generate a definition in __bpf_raw_tp_map
> section for bare tracepoint in a similar way to DEFINE_TRACE_WRITABLE().
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/trace/bpf_probe.h | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/include/trace/bpf_probe.h b/include/trace/bpf_probe.h
> index a23be89119aa..a8e97f84b652 100644
> --- a/include/trace/bpf_probe.h
> +++ b/include/trace/bpf_probe.h
> @@ -93,8 +93,7 @@ __section("__bpf_raw_tp_map") = {                                     \
>
>  #define FIRST(x, ...) x
>
> -#undef DEFINE_EVENT_WRITABLE
> -#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size)       \
> +#define __CHECK_WRITABLE_BUF_SIZE(call, proto, args, size)             \
>  static inline void bpf_test_buffer_##call(void)                                \
>  {                                                                      \
>         /* BUILD_BUG_ON() is ignored if the code is completely eliminated, but \
> @@ -103,8 +102,12 @@ static inline void bpf_test_buffer_##call(void)                            \
>          */                                                             \
>         FIRST(proto);                                                   \
>         (void)BUILD_BUG_ON_ZERO(size != sizeof(*FIRST(args)));          \
> -}                                                                      \
> -__DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
> +}
> +
> +#undef DEFINE_EVENT_WRITABLE
> +#define DEFINE_EVENT_WRITABLE(template, call, proto, args, size) \
> +       __CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
> +       __DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>
>  #undef DEFINE_EVENT
>  #define DEFINE_EVENT(template, call, proto, args)                      \
> @@ -119,9 +122,17 @@ __DEFINE_EVENT(template, call, PARAMS(proto), PARAMS(args), size)
>         __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args))          \
>         __DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), 0)
>
> +#undef DECLARE_TRACE_WRITABLE
> +#define DECLARE_TRACE_WRITABLE(call, proto, args, size) \
> +       __CHECK_WRITABLE_BUF_SIZE(call, PARAMS(proto), PARAMS(args), size) \
> +       __BPF_DECLARE_TRACE(call, PARAMS(proto), PARAMS(args)) \
> +       __DEFINE_EVENT(call, call, PARAMS(proto), PARAMS(args), size)
> +
>  #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
>
> +#undef DECLARE_TRACE_WRITABLE
>  #undef DEFINE_EVENT_WRITABLE
> +#undef __CHECK_WRITABLE_BUF_SIZE
>  #undef __DEFINE_EVENT
>  #undef FIRST
>
> --
> 2.29.2
>
