Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B706D8175
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 23:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388490AbfJOVEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 17:04:54 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:45347 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbfJOVEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 17:04:54 -0400
Received: by mail-lj1-f195.google.com with SMTP id q64so21701365ljb.12;
        Tue, 15 Oct 2019 14:04:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mMBin2EGtKSHZbpPVK+JW5J0CFqnupXSzgXwGSycYCg=;
        b=g4tiStYdzxhvLJMQJJkXMZ03jvVudYSRL31JVqNXBqUxLCCC1KYEnThdbR5opx+Llr
         TO+hhXXJod7TicgMuR4rglQ+1XdbbV8ZLp5BueqQOBm6yZxJC5NTLrubKUQg4UpuCo5o
         8hRuVYLRKsy8cvl08Q/gWCHNDrTXh5fClS5uIe9dIydDJJKVoZiV0mtXYAD1pHb1tw+T
         HOmWn+llpU6IWb17qHeiyEA5FLfcRMKucQlkptg2Mfr3swyswGYNOyi1IZgfutdye2rM
         B9sKZEIqGwi9nWsa+4gW3KWmgjpazdViQJegrgXyllPawoQR8MwMS81V/8rOn9ASYtdu
         c+kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mMBin2EGtKSHZbpPVK+JW5J0CFqnupXSzgXwGSycYCg=;
        b=P0MyXDDC20WFw5UheUPobKf7GyHvB3MGuOIZZvNSefkhtd47iDPXalZz2S3KJ/EvDB
         PZrLHSUh0JTJJdP5yEuRtNRD3+NkcGwIB3OvobS3OGiM8ufDa4b+y3QlhAYJ3lVKo+wy
         yxt+QRB6lMKGeRPJzoi0FwyIBCwNt1GtRyPgsg3MBI6OVZ5pwDZGZFZfciL88iwirLm9
         Tu7Mgui2iB4aa7BjrLItVXiFj1jpDRB5gNQsHGxRHCpaUuXTvSytPLCiLwDLO2QqGcuM
         qixsH5YC7HVP95o6X3r8/mmWT64h72E38YbW2xdu3U9gF8roF1J3mYqcJHLViPUmHOdc
         I/2A==
X-Gm-Message-State: APjAAAVTRR6s6HYT6c6MDdAF7rUoP3aTrGdMLl9GCapr3xR+3mTRVtYR
        n3WrmVlj4wwyX/6NGX0OTUp4TKEMu8R5NIgAIqw=
X-Google-Smtp-Source: APXvYqyKzjQVj57ZbrsbnWyBxAXURB3UtzBd39o1PwxM6oJmlYyxNnkKYqRHha7SKEoCCpKN9iKzwEjft1BCrg8uPhQ=
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr24349207lji.142.1571173491828;
 Tue, 15 Oct 2019 14:04:51 -0700 (PDT)
MIME-Version: 1.0
References: <20191014122833.64908-1-houtao1@huawei.com> <20191014122833.64908-2-houtao1@huawei.com>
In-Reply-To: <20191014122833.64908-2-houtao1@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Oct 2019 14:04:40 -0700
Message-ID: <CAADnVQ+UJK41VL-epYGxrRzqL_UsC+X=J8EXEn2i8P+TPGA_jg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] block: add support for redirecting IO completion
 through eBPF
To:     Hou Tao <houtao1@huawei.com>
Cc:     linux-block@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Alexei Starovoitov <ast@kernel.org>, hare@suse.com,
        osandov@fb.com, ming.lei@redhat.com, damien.lemoal@wdc.com,
        bvanassche <bvanassche@acm.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 5:21 AM Hou Tao <houtao1@huawei.com> wrote:
>
> For network stack, RPS, namely Receive Packet Steering, is used to
> distribute network protocol processing from hardware-interrupted CPU
> to specific CPUs and alleviating soft-irq load of the interrupted CPU.
>
> For block layer, soft-irq (for single queue device) or hard-irq
> (for multiple queue device) is used to handle IO completion, so
> RPS will be useful when the soft-irq load or the hard-irq load
> of a specific CPU is too high, or a specific CPU set is required
> to handle IO completion.
>
> Instead of setting the CPU set used for handling IO completion
> through sysfs or procfs, we can attach an eBPF program to the
> request-queue, provide some useful info (e.g., the CPU
> which submits the request) to the program, and let the program
> decides the proper CPU for IO completion handling.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
...
>
> +       rcu_read_lock();
> +       prog = rcu_dereference_protected(q->prog, 1);
> +       if (prog)
> +               bpf_ccpu = BPF_PROG_RUN(q->prog, NULL);
> +       rcu_read_unlock();
> +
>         cpu = get_cpu();
> -       if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
> -               shared = cpus_share_cache(cpu, ctx->cpu);
> +       if (bpf_ccpu < 0 || !cpu_online(bpf_ccpu)) {
> +               ccpu = ctx->cpu;
> +               if (!test_bit(QUEUE_FLAG_SAME_FORCE, &q->queue_flags))
> +                       shared = cpus_share_cache(cpu, ctx->cpu);
> +       } else
> +               ccpu = bpf_ccpu;
>
> -       if (cpu != ctx->cpu && !shared && cpu_online(ctx->cpu)) {
> +       if (cpu != ccpu && !shared && cpu_online(ccpu)) {
>                 rq->csd.func = __blk_mq_complete_request_remote;
>                 rq->csd.info = rq;
>                 rq->csd.flags = 0;
> -               smp_call_function_single_async(ctx->cpu, &rq->csd);
> +               smp_call_function_single_async(ccpu, &rq->csd);

Interesting idea.
Not sure whether such programability makes sense from
block layer point of view.

From bpf side having a program with NULL input context is
a bit odd. We never had such things in the past, so this patchset
won't work as-is.
Also no-input means that the program choices are quite limited.
Other than round robin and random I cannot come up with other
cpu selection ideas.
I suggest to do writable tracepoint here instead.
Take a look at trace_nbd_send_request.
BPF prog can write into 'request'.
For your use case it will be able to write into 'bpf_ccpu' local variable.
If you keep it as raw tracepoint and don't add the actual tracepoint
with TP_STRUCT__entry and TP_fast_assign then it won't be abi
and you can change it later or remove it altogether.
