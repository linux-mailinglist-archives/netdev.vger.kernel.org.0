Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77440394EFE
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 05:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhE3DHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 23:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhE3DH3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 May 2021 23:07:29 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3327DC061574;
        Sat, 29 May 2021 20:05:51 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id e10so11418410ybb.7;
        Sat, 29 May 2021 20:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y1JaZFg5C1hpX0ZtLyonp+cqWwoqumNX2a4Bqds0knk=;
        b=scYZ94cg/jW+8x9NyEoCeKi59xI6YVxjWroUJeHAgiLJ1uitKx2+gE1p2zZmjmnwqE
         GLP08lTzW9O+vz6tL56RXC3YPUBRBJaV74aXgvROLhUN/edp17AWKQlTAXVQTbHNGSDh
         Exme0UEUzRcqv8h0GBifMmUO2QeG3JUXBvZY4VtQe1ND1/ysXjSfDWyWaOD3U1HtThEg
         RoZbz6KdCvBgrkCn67/YQQ6Cllh5npeZ5AHXOEurvg2v6ds3m8qhCBMK6Ik4AZ21WXOU
         M/26lf/Id75CeRBSV6TgHAqUkjedoahyhLpQ7rxJzn7v6M0gqltaOOOsFR2ipJOSalW1
         x8WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y1JaZFg5C1hpX0ZtLyonp+cqWwoqumNX2a4Bqds0knk=;
        b=ceK+uJCMiVq5FxOH2KL5tpqkJ6IqAFeSy8xy/3g1j6Kn+CjPnHo7sIU0DPLLCU23dF
         h2W5ABZKTO5lb8xrBVQi+sKWf5uW9wEsVz66RYy/cfEs19flUvNlaXoJ1S7wcDiYDXII
         jYe0ExLI8mgACKvBRWd6ECi8V6RZU29ZASkrPEV9esm7g0kpGLwbtYhpl+OEVDH6sA7U
         vWHBKfddG5bu4qVcehVr8yW08DnxnifNKWhRsCQ7ZG94C/8A40DTnaHhIGDs2KipAEbT
         XfSxh3YfwhA+U0OFyAi89HPvkvcLEOj60prSBb+tCjbE7lZYnJaJdmiHcD91y1PnMoi9
         sh8Q==
X-Gm-Message-State: AOAM532reDsd5AUFdF6JRoin9y3LhKl64QtCc+cPUfAbqVCR5CLsdNhu
        uXhbOhbGulYJBMcutNRBBzuELVnwy895v7kn86A=
X-Google-Smtp-Source: ABdhPJwAGVbtfBXLiP1uTbiJcc0nmgQSOtIOs+nJyuFDPnKWtX2a2qUvrhjJ9UhGjj4Zu4hmeCriWNHv96U5kG+Kc7c=
X-Received: by 2002:a5b:286:: with SMTP id x6mr23395041ybl.347.1622343950023;
 Sat, 29 May 2021 20:05:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210528235250.2635167-1-memxor@gmail.com> <20210528235250.2635167-4-memxor@gmail.com>
In-Reply-To: <20210528235250.2635167-4-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 29 May 2021 20:05:38 -0700
Message-ID: <CAEf4BzYWcg=--yocHgHvoaOs4Bq95Y6zMhGJCenVX0f2i_kP7w@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 03/15] samples: bpf: split out common bpf
 progs to its own file
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 28, 2021 at 4:53 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This is done to later reuse these in a way that can be shared
> among multiple samples.
>
> We are using xdp_redirect_cpu_kern.c as a base to build further support on
> top (mostly adding a few other things missing that xdp_monitor does in
> subsequent patches).
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  samples/bpf/xdp_sample_kern.h | 220 ++++++++++++++++++++++++++++++++++
>  1 file changed, 220 insertions(+)
>  create mode 100644 samples/bpf/xdp_sample_kern.h
>
> diff --git a/samples/bpf/xdp_sample_kern.h b/samples/bpf/xdp_sample_kern.h

instead of doing it as a header, can you please use BPF static linking
instead? I think that's a better approach and a good showcase for
anyone that would like to use static linking for their BPF programs

> new file mode 100644
> index 000000000000..bb809542ac20
> --- /dev/null
> +++ b/samples/bpf/xdp_sample_kern.h
> @@ -0,0 +1,220 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*  GPLv2, Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc. */
> +#pragma once
> +
> +#include <uapi/linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#define MAX_CPUS 64
> +
> +/* Common stats data record to keep userspace more simple */
> +struct datarec {
> +       __u64 processed;
> +       __u64 dropped;
> +       __u64 issue;
> +       __u64 xdp_pass;
> +       __u64 xdp_drop;
> +       __u64 xdp_redirect;
> +};
> +
> +/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
> + * feedback.  Redirect TX errors can be caught via a tracepoint.
> + */
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __type(key, u32);
> +       __type(value, struct datarec);
> +       __uint(max_entries, 1);
> +} rx_cnt SEC(".maps");
> +
> +/* Used by trace point */
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __type(key, u32);
> +       __type(value, struct datarec);
> +       __uint(max_entries, 2);
> +       /* TODO: have entries for all possible errno's */
> +} redirect_err_cnt SEC(".maps");
> +
> +/* Used by trace point */
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __type(key, u32);
> +       __type(value, struct datarec);
> +       __uint(max_entries, MAX_CPUS);
> +} cpumap_enqueue_cnt SEC(".maps");

One way to squeeze a bit more performance would be to instead use
global variables instead of maps:

struct datarec cpu_map_enqueue_cnts[MAX_CPUS][MAX_CPUS];

and other PERCPU_ARRAY arrays could be just one-dimensional arrays.

You'd need to ensure each value sits on its own cache-line, of course.

> +
> +/* Used by trace point */
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __type(key, u32);
> +       __type(value, struct datarec);
> +       __uint(max_entries, 1);
> +} cpumap_kthread_cnt SEC(".maps");
> +

[...]

> +
> +/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_enqueue/format
> + * Code in:         kernel/include/trace/events/xdp.h
> + */
> +struct cpumap_enqueue_ctx {
> +       u64 __pad;              // First 8 bytes are not accessible by bpf code
> +       int map_id;             //      offset:8;  size:4; signed:1;
> +       u32 act;                //      offset:12; size:4; signed:0;
> +       int cpu;                //      offset:16; size:4; signed:1;
> +       unsigned int drops;     //      offset:20; size:4; signed:0;
> +       unsigned int processed; //      offset:24; size:4; signed:0;
> +       int to_cpu;             //      offset:28; size:4; signed:1;
> +};

if you used vmlinux.h, this is already in there as struct
trace_event_raw_xdp_cpumap_enqueue, similarly for other tracepoints

> +
> +SEC("tracepoint/xdp/xdp_cpumap_enqueue")
> +int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
> +{
> +       u32 to_cpu = ctx->to_cpu;
> +       struct datarec *rec;
> +
> +       if (to_cpu >= MAX_CPUS)
> +               return 1;
> +
> +       rec = bpf_map_lookup_elem(&cpumap_enqueue_cnt, &to_cpu);
> +       if (!rec)
> +               return 0;
> +       rec->processed += ctx->processed;
> +       rec->dropped   += ctx->drops;
> +
> +       /* Record bulk events, then userspace can calc average bulk size */
> +       if (ctx->processed > 0)
> +               rec->issue += 1;
> +
> +       /* Inception: It's possible to detect overload situations, via
> +        * this tracepoint.  This can be used for creating a feedback
> +        * loop to XDP, which can take appropriate actions to mitigate
> +        * this overload situation.
> +        */
> +       return 0;
> +}
> +

[...]
