Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0686A2AA1F5
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbgKGBO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbgKGBO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 20:14:27 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE2CC0613CF;
        Fri,  6 Nov 2020 17:14:25 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id a12so2742400ybg.9;
        Fri, 06 Nov 2020 17:14:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KgcSZrLLiNnLdzlKpUep9GqNy0eCFir7HzXKMNzKr54=;
        b=VgMPit4LTtlNs5ZCRHMWDmZZnp8tjz3fWTMPFJrPdlTuWzeXFVQ/qj/++t6df+67jD
         TLqqxJngnQBp1QxHIbH5k5i0Dg1UEtbCkwg1umjLuXovcbWkCosDyPEk5CE4e+0aFQgB
         4B5Yt41c4cpJ1AjriWDYIozwLRLSH0roaeQ7aZbNIFCyRchtZ+d6knF4HhgjlHTBUAOY
         3VYTdMJKi9qiNvwzzuii/pBxUGNanr3h3y5/F/TRUFFh4KlGzLsqHyLPMYKw8z0yX4Mr
         KM1HrA1YsAlLEYL+SbDuxMRhPNgqSWO4QWCGAvsFbXNdJHS8QzTmjTRgbSXKEFV0LLiP
         /5Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KgcSZrLLiNnLdzlKpUep9GqNy0eCFir7HzXKMNzKr54=;
        b=UX+IE8dD4cdVgDCcQeN84vls45kRj8oCFqKpBGvoU5WuX6JJWEIJM33DKt7ReB+nsK
         CfVAoTQ4wsaRRohJ3JXCTGi9ly84KqQCIQz7AtuxF7lasSJH2lsIr2Yr13dBALqjT7yW
         WL1bmFkXmz47boyYEqqEvNbh4os+vVINrVrpPNZGjjUTwHyW6mQ3hbAkMbjrBq86yc/2
         4SHIF5QIrMuc1m7trSRbPGBTKxJMoLV0LhFvcBb8rWo7ktp5u9EULyWrFWftDbUEWmS0
         7K0PA2Mti7UzRyKtuu8EEeW5hjtYhLV5CDjlhWXT4Yc+7Xx1p5LCa+WIxKhMqO8iDa6L
         a6ow==
X-Gm-Message-State: AOAM530t2skdltuVy/cAs6/vDh+qmyOgwrOHgr63TxHq5lhdHqFibr8r
        bc0FeIfpvLZHmROJl2AfvE39vtjVQKStza6dwPs=
X-Google-Smtp-Source: ABdhPJwxq74uDpc0OlsH7CexHJp09TiigipgD+5YwG2Xrn3MFOeQXKgxSZQ9BCXB9HocAi+3H5y7IlFIHNYPB8Owj/Q=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr6535194ybl.347.1604711664888;
 Fri, 06 Nov 2020 17:14:24 -0800 (PST)
MIME-Version: 1.0
References: <20201106220750.3949423-1-kafai@fb.com> <20201106220803.3950648-1-kafai@fb.com>
In-Reply-To: <20201106220803.3950648-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 6 Nov 2020 17:14:14 -0800
Message-ID: <CAEf4BzaQMcnALQ3rPErQJxVjL-Mi8zB8aSBkL8bkR8mtivro+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Allow using bpf_sk_storage in FENTRY/FEXIT/RAW_TP
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 6, 2020 at 2:08 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch enables the FENTRY/FEXIT/RAW_TP tracing program to use
> the bpf_sk_storage_(get|delete) helper, so those tracing programs
> can access the sk's bpf_local_storage and the later selftest
> will show some examples.
>
> The bpf_sk_storage is currently used in bpf-tcp-cc, tc,
> cg sockops...etc which is running either in softirq or
> task context.
>
> This patch adds bpf_sk_storage_get_tracing_proto and
> bpf_sk_storage_delete_tracing_proto.  They will check
> in runtime that the helpers can only be called when serving
> softirq or running in a task context.  That should enable
> most common tracing use cases on sk.
>
> During the load time, the new tracing_allowed() function
> will ensure the tracing prog using the bpf_sk_storage_(get|delete)
> helper is not tracing any *sk_storage*() function itself.
> The sk is passed as "void *" when calling into bpf_local_storage.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/net/bpf_sk_storage.h |  2 +
>  kernel/trace/bpf_trace.c     |  5 +++
>  net/core/bpf_sk_storage.c    | 73 ++++++++++++++++++++++++++++++++++++
>  3 files changed, 80 insertions(+)
>

[...]

> +       switch (prog->expected_attach_type) {
> +       case BPF_TRACE_RAW_TP:
> +               /* bpf_sk_storage has no trace point */
> +               return true;
> +       case BPF_TRACE_FENTRY:
> +       case BPF_TRACE_FEXIT:
> +               btf_vmlinux = bpf_get_btf_vmlinux();
> +               btf_id = prog->aux->attach_btf_id;
> +               t = btf_type_by_id(btf_vmlinux, btf_id);
> +               tname = btf_name_by_offset(btf_vmlinux, t->name_off);
> +               return !strstr(tname, "sk_storage");

I'm always feeling uneasy about substring checks... Also, KP just
fixed the issue with string-based checks for LSM. Can we use a
BTF_ID_SET of blacklisted functions instead?

> +       default:
> +               return false;
> +       }
> +
> +       return false;
> +}
> +

[...]
