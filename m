Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDADD06E6
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 07:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbfJIF3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 01:29:20 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39024 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729627AbfJIF3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 01:29:20 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so1663526qtb.6;
        Tue, 08 Oct 2019 22:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gd85LvKq8QjIKRX02d72pLTk9rw5MGjzEzH1UF/6ldE=;
        b=Xmpz2+azvNPpQVJ/2g4CalF+KPNZqc7FmBLGkwNReXSr4PhdapktOYc5FlmRvDSKqW
         WcAtuzDJlahdjQookOas0MklZB8IMTJKLHuGXXwMYPFUd3vk9OIjsp3O4K234flUpt/W
         fuPA1Ohgmk2jutGlOO4NIt05INu8Bn90gMokowv+6wn6E/p86qYRByDYLlDE7Nm2Anp+
         GREsR605dwv4ht9M6ip7spVCjg5CVYoHolN/vkrr1/Ol3I64gwNqIeWS7U7DmGjf5sn8
         zSJYv+9EXdqzbnj/r1HcgG+/4LrvyhCar3yNPh80xSnuCnAKy5EF2neQGhag7Z93CaOZ
         VePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gd85LvKq8QjIKRX02d72pLTk9rw5MGjzEzH1UF/6ldE=;
        b=pcD1nnGMFQex0mlbo7wNlNaxJqEYtIEkIeqV2Hq7CrUXqfsCaETsXzdippisO/qQHQ
         o3u/JzsK3/zdZbFB/9ZnuCi5SCpN0Hk9YXT76xyKqCj+QQ1PHWAxWlfCfIDldbWhrQ36
         Aa5d8lUakJY9HUTY2gwsIumW+ArBiPxV/69icZYgVt8A3v9Ni4/L6UpRTypjFVkfix+P
         2lJ71k2t2JRwf8QEJf2qm5usVQvvrzSplvWEtkMKqkqdNPPMFhcY1qBSw28r/9dyI/Cf
         GS++EE5/ZZsqj/dqE81wP93g79eNo8QcddXOo5yfnPN8RHQHJO9RzWoSIKNQ9BPk1tN0
         n0zQ==
X-Gm-Message-State: APjAAAW6iNxrezk4rUHk/FPhqdrSZ9nfWcpXzCDBsHUYyQmU9EbzNPzH
        t2ukX3SPOUmsk68XhNl4YSo1Jms4iHEglnFOa4o=
X-Google-Smtp-Source: APXvYqwboH94Z2UtyWYihlyv2FC+oSP8MK/jQrskf10ABeh2sqclBb3jMWXZjtBtIZHDM7jN6WlG9FEndLYuOY6Ksl4=
X-Received: by 2002:a0c:f885:: with SMTP id u5mr1855381qvn.247.1570598958931;
 Tue, 08 Oct 2019 22:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191005050314.1114330-1-ast@kernel.org> <20191005050314.1114330-10-ast@kernel.org>
In-Reply-To: <20191005050314.1114330-10-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Oct 2019 22:29:08 -0700
Message-ID: <CAEf4Bzb2XEp2H26RonyPjvUqXB4qx6sc6KN_i74hu4bhPhhc4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/10] bpf: disallow bpf_probe_read[_str] helpers
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 10:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Disallow bpf_probe_read() and bpf_probe_read_str() helpers in
> raw_tracepoint bpf programs that use in-kernel BTF to track
> types of memory accesses.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  kernel/trace/bpf_trace.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index 52f7e9d8c29b..7c607f79f1bb 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -700,6 +700,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_map_peek_elem:
>                 return &bpf_map_peek_elem_proto;
>         case BPF_FUNC_probe_read:
> +               if (prog->expected_attach_type)
> +                       return NULL;

This can unintentionally disable bpf_probe_read/bpf_probe_read_str for
non-raw_tp programs that happened to specify non-zero
expected_attach_type, which we don't really validate for
kprobe/tp/perf_event/etc. So how about passing program type into
tracing_func_proto() so that we can have more granular control?

>                 return &bpf_probe_read_proto;
>         case BPF_FUNC_ktime_get_ns:
>                 return &bpf_ktime_get_ns_proto;
> @@ -728,6 +730,8 @@ tracing_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>         case BPF_FUNC_get_prandom_u32:
>                 return &bpf_get_prandom_u32_proto;
>         case BPF_FUNC_probe_read_str:
> +               if (prog->expected_attach_type)
> +                       return NULL;
>                 return &bpf_probe_read_str_proto;
>  #ifdef CONFIG_CGROUPS
>         case BPF_FUNC_get_current_cgroup_id:
> --
> 2.20.0
>
