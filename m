Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8012A8E41
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 05:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgKFEUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 23:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKFEUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 23:20:01 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0EDC0613CF;
        Thu,  5 Nov 2020 20:20:00 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id s30so54681lfc.4;
        Thu, 05 Nov 2020 20:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=emTZ5dm6R54nPEIw1yWZRbyxgTfu03dS6dBWRdBwoy4=;
        b=PshLDMqb7GgU+1dzAGBlJ/mTWgW8WouF1iavk4FAeuISPid3N5Utrxtxb83CDFrItM
         tOh1hQeQHaJfwJDvEZi7SgSOG2ly415cUhNBb/ObhjZ6YfwYERXDDsVY0zjHVFDa01cZ
         6gH4TOe/FRizTLmrwpkxUTzJ1lG9ml8cbT7fubnhKASPBagesTU9dPN4hpb77MyxYhsy
         TKKgqEmNqB5JQiJ4JwD7cQ2iMYrwMc72ypFEoxqDlwZWOQFa+IYniSNWGs1OO8qUmXHc
         fjyHpoBAoUh95PS0+cWHFyjFeb29URVUKNrWKYSrrfmk8uHFSoNLTWit8zA03jVHcp1Q
         lGpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=emTZ5dm6R54nPEIw1yWZRbyxgTfu03dS6dBWRdBwoy4=;
        b=MOzazSQ7kK4zP1tNnQD5dr37nyqffgjIxqjz2vm2pI8SBc+1U9AAo+ZheMlDnXg7Xv
         swd9n7q6WOVoz/WROL+eeBLg/OPIKQ/+dPm9JrGnKa8p5kQBHAheHLrW2EKpIe9eirF6
         D6ZFFOihMBblovkIitL/w+ZblDiuSV9/SLkU1Z16RbF9pwTjSPEuJjI6oXBgf6vNS6NU
         4ZyeA14/SVQqYfo9wHpEcKJ82OmGjk4n3eWnsGcgoQCCKzUhfnxi4Z6/1NKa3/KGrsYT
         hJNfHBRW/yOEBpYGcpAYTaUPc03la2XtFf3wXVczQsDRkOk4WATFLkUDFB/G1Kinp03T
         Vlvw==
X-Gm-Message-State: AOAM531TrkI0RyXvLmwrdIrYOK31+H2gzGDZSq53ofxSJGCRnlT89DYK
        M9RvORlq6hXqpgIC0lJ4QZ4PPHunqzCGkgHXGRQ=
X-Google-Smtp-Source: ABdhPJwdcvq8r/YeBlu3V8Sg7c/xde69dtH3nUm+feujc6eRKwbtAbp4fIGu71dXm2iohUDQJ5NTJBr9Dfn9fiOdjnE=
X-Received: by 2002:a05:6512:32a4:: with SMTP id q4mr104067lfe.477.1604636399357;
 Thu, 05 Nov 2020 20:19:59 -0800 (PST)
MIME-Version: 1.0
References: <VI1PR8303MB00802FE5D289E0D7BA95B7DDFBEE0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
In-Reply-To: <VI1PR8303MB00802FE5D289E0D7BA95B7DDFBEE0@VI1PR8303MB0080.EURPRD83.prod.outlook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 5 Nov 2020 20:19:47 -0800
Message-ID: <CAADnVQLNdDn1jfyEAeKO17vXQiN+VKAvq+VFkY2G_pvSbaPjFA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] Update perf ring buffer to prevent corruption
To:     Kevin Sheldrake <Kevin.Sheldrake@microsoft.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        KP Singh <kpsingh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 7:18 AM Kevin Sheldrake
<Kevin.Sheldrake@microsoft.com> wrote:
>
> Resent due to some failure at my end.  Apologies if it arrives twice.
>
> From 63e34d4106b4dd767f9bfce951f8a35f14b52072 Mon Sep 17 00:00:00 2001
> From: Kevin Sheldrake <kevin.sheldrake@microsoft.com>
> Date: Thu, 5 Nov 2020 12:18:53 +0000
> Subject: [PATCH] Update perf ring buffer to prevent corruption from
>  bpf_perf_output_event()
>
> The bpf_perf_output_event() helper takes a sample size parameter of u64, but
> the underlying perf ring buffer uses a u16 internally. This 64KB maximum size
> has to also accommodate a variable sized header. Failure to observe this
> restriction can result in corruption of the perf ring buffer as samples
> overlap.
>
> Track the sample size and return -E2BIG if too big to fit into the u16
> size parameter.
>
> Signed-off-by: Kevin Sheldrake <kevin.sheldrake@microsoft.com>

The fix makes sense to me.
Peter, Ingo,
should I take it through the bpf tree or you want to route via tip?

> ---
>  include/linux/perf_event.h |  2 +-
>  kernel/events/core.c       | 40 ++++++++++++++++++++++++++--------------
>  2 files changed, 27 insertions(+), 15 deletions(-)
>
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 0c19d27..b9802e5 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -1060,7 +1060,7 @@ extern void perf_output_sample(struct perf_output_handle *handle,
>                                struct perf_event_header *header,
>                                struct perf_sample_data *data,
>                                struct perf_event *event);
> -extern void perf_prepare_sample(struct perf_event_header *header,
> +extern int perf_prepare_sample(struct perf_event_header *header,
>                                 struct perf_sample_data *data,
>                                 struct perf_event *event,
>                                 struct pt_regs *regs);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index da467e1..c6c4a3c 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7016,15 +7016,17 @@ perf_callchain(struct perf_event *event, struct pt_regs *regs)
>         return callchain ?: &__empty_callchain;
>  }
>
> -void perf_prepare_sample(struct perf_event_header *header,
> +int perf_prepare_sample(struct perf_event_header *header,
>                          struct perf_sample_data *data,
>                          struct perf_event *event,
>                          struct pt_regs *regs)
>  {
>         u64 sample_type = event->attr.sample_type;
> +       u32 header_size = header->size;
> +
>
>         header->type = PERF_RECORD_SAMPLE;
> -       header->size = sizeof(*header) + event->header_size;
> +       header_size = sizeof(*header) + event->header_size;
>
>         header->misc = 0;
>         header->misc |= perf_misc_flags(regs);
> @@ -7042,7 +7044,7 @@ void perf_prepare_sample(struct perf_event_header *header,
>
>                 size += data->callchain->nr;
>
> -               header->size += size * sizeof(u64);
> +               header_size += size * sizeof(u64);
>         }
>
>         if (sample_type & PERF_SAMPLE_RAW) {
> @@ -7067,7 +7069,7 @@ void perf_prepare_sample(struct perf_event_header *header,
>                         size = sizeof(u64);
>                 }
>
> -               header->size += size;
> +               header_size += size;
>         }
>
>         if (sample_type & PERF_SAMPLE_BRANCH_STACK) {
> @@ -7079,7 +7081,7 @@ void perf_prepare_sample(struct perf_event_header *header,
>                         size += data->br_stack->nr
>                               * sizeof(struct perf_branch_entry);
>                 }
> -               header->size += size;
> +               header_size += size;
>         }
>
>         if (sample_type & (PERF_SAMPLE_REGS_USER | PERF_SAMPLE_STACK_USER))
> @@ -7095,7 +7097,7 @@ void perf_prepare_sample(struct perf_event_header *header,
>                         size += hweight64(mask) * sizeof(u64);
>                 }
>
> -               header->size += size;
> +               header_size += size;
>         }
>
>         if (sample_type & PERF_SAMPLE_STACK_USER) {
> @@ -7108,7 +7110,7 @@ void perf_prepare_sample(struct perf_event_header *header,
>                 u16 stack_size = event->attr.sample_stack_user;
>                 u16 size = sizeof(u64);
>
> -               stack_size = perf_sample_ustack_size(stack_size, header->size,
> +               stack_size = perf_sample_ustack_size(stack_size, header_size,
>                                                      data->regs_user.regs);
>
>                 /*
> @@ -7120,7 +7122,7 @@ void perf_prepare_sample(struct perf_event_header *header,
>                         size += sizeof(u64) + stack_size;
>
>                 data->stack_user_size = stack_size;
> -               header->size += size;
> +               header_size += size;
>         }
>
>         if (sample_type & PERF_SAMPLE_REGS_INTR) {
> @@ -7135,7 +7137,7 @@ void perf_prepare_sample(struct perf_event_header *header,
>                         size += hweight64(mask) * sizeof(u64);
>                 }
>
> -               header->size += size;
> +               header_size += size;
>         }
>
>         if (sample_type & PERF_SAMPLE_PHYS_ADDR)
> @@ -7154,7 +7156,7 @@ void perf_prepare_sample(struct perf_event_header *header,
>         if (sample_type & PERF_SAMPLE_AUX) {
>                 u64 size;
>
> -               header->size += sizeof(u64); /* size */
> +               header_size += sizeof(u64); /* size */
>
>                 /*
>                  * Given the 16bit nature of header::size, an AUX sample can
> @@ -7162,14 +7164,20 @@ void perf_prepare_sample(struct perf_event_header *header,
>                  * Make sure this doesn't happen by using up to U16_MAX bytes
>                  * per sample in total (rounded down to 8 byte boundary).
>                  */
> -               size = min_t(size_t, U16_MAX - header->size,
> +               size = min_t(size_t, U16_MAX - header_size,
>                              event->attr.aux_sample_size);
>                 size = rounddown(size, 8);
>                 size = perf_prepare_sample_aux(event, data, size);
>
> -               WARN_ON_ONCE(size + header->size > U16_MAX);
> -               header->size += size;
> +               WARN_ON_ONCE(size + header_size > U16_MAX);
> +               header_size += size;
>         }
> +
> +       if (header_size > U16_MAX)
> +               return -E2BIG;
> +
> +       header->size = header_size;
> +
>         /*
>          * If you're adding more sample types here, you likely need to do
>          * something about the overflowing header::size, like repurpose the
> @@ -7179,6 +7187,8 @@ void perf_prepare_sample(struct perf_event_header *header,
>          * do here next.
>          */
>         WARN_ON_ONCE(header->size & 7);
> +
> +       return 0;
>  }
>
>  static __always_inline int
> @@ -7196,7 +7206,9 @@ __perf_event_output(struct perf_event *event,
>         /* protect the callchain buffers */
>         rcu_read_lock();
>
> -       perf_prepare_sample(&header, data, event, regs);
> +       err = perf_prepare_sample(&header, data, event, regs);
> +       if (err)
> +               goto exit;
>
>         err = output_begin(&handle, event, header.size);
>         if (err)
> --
> 2.7.4
>
