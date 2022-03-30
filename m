Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544374EB74C
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 02:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241354AbiC3ACO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 20:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241229AbiC3ACN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 20:02:13 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C2F31DF6;
        Tue, 29 Mar 2022 17:00:28 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id h18so8949398ila.12;
        Tue, 29 Mar 2022 17:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E1v5f1E9kvbnqUPclDJ+akYUY/vb4yMCVQhMsqWJs1c=;
        b=bWWd75gWJ5E8DO17wGle5WOjbDzx7V3zlVD5csBF2nW3SOWZaYdjy2JUZzYC9aSl5c
         1OFldu8MD0ETKjaa9qZuVdNWSLScfiKdEImGV288rnWArBTD7KkeD3RTyipoRuShO/l9
         9BbnFy451kzzjq+R9UY6bYjhufasNOEusVKxwiZerBWN+K8FySnw6Kt+iYbeERtEeHLw
         jt7/OxUys0CEGMTtg4Q4DJozsC1Z1E+ploJH5XhHa/zX0W1vh/ewRC2pK7yGikdVq88b
         mI+SnjqKUCC13tw/ND7YvaQPX8cLGpTHpcjnxwBaTdFae3YewRNQ/VgexjBKGxhjoCw5
         00ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E1v5f1E9kvbnqUPclDJ+akYUY/vb4yMCVQhMsqWJs1c=;
        b=xo4uUD4/B9e0zM85nassuDCw2+35Hy/eIK8Y+ZlItS9ZrSvcKx/ENANh69ASYciXbe
         U/bZxOZNO+La0R6jKT3SUWEJYrX/ej5/k8NzGDXZ1TXxwN/Glxi6QvxN39CV+t2kdjQA
         dg+az3nAOI5cyaDC3kFGIwnUNTsE76vtZ+2C2AsCmGDeIxZZ4nmYZwLaydfn5zM43CyD
         Mzmwp/kCxQqduDzYLrlNa5YpwbELjnT6X+2npCHeLTJadtEN6/b3wBsQrqxybyWXB0VY
         raR/lNSnM2cNrBl6hamwAPftGuGfj9AgxsOnw++bgwBqugK5Rw5LKghDmP811/xIxmTV
         FtoA==
X-Gm-Message-State: AOAM532pkwQ9RzWqx2amxhEkR4a4e+3dAxDRXEQA6k2qqz7flhn7JHdq
        xG4rDx9DCJlS5Ex0PoOdly+A9YegRut9pggdnlQ=
X-Google-Smtp-Source: ABdhPJz1dDQaqFlJ/u1RxLgl6EXdzIECRfFWeX47SxiJp8S3wQiTd7fF7rwxu7aNyUx8VLewyhvpSDEa9B+V/XADzGk=
X-Received: by 2002:a05:6e02:1a8f:b0:2c9:da3d:e970 with SMTP id
 k15-20020a056e021a8f00b002c9da3de970mr1979386ilv.239.1648598427044; Tue, 29
 Mar 2022 17:00:27 -0700 (PDT)
MIME-Version: 1.0
References: <20220329231854.3188647-1-song@kernel.org>
In-Reply-To: <20220329231854.3188647-1-song@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 29 Mar 2022 17:00:16 -0700
Message-ID: <CAEf4BzZCLwzrZPTOBEg88i1Tki6uPL73ujSE-SCSSU16HENUHA@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/runqslower: fix handle__sched_switch for
 updated tp sched_switch
To:     Song Liu <song@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 4:19 PM Song Liu <song@kernel.org> wrote:
>
> TP_PROTO of sched_switch is updated with a new arg prev_state, which
> causes runqslower load failure:
>
> libbpf: prog 'handle__sched_switch': BPF program load failed: Permission denied
> libbpf: prog 'handle__sched_switch': -- BEGIN PROG LOAD LOG --
> R1 type=ctx expected=fp
> 0: R1=ctx(off=0,imm=0) R10=fp0
> ; int handle__sched_switch(u64 *ctx)
> 0: (bf) r7 = r1                       ; R1=ctx(off=0,imm=0) R7_w=ctx(off=0,imm=0)
> ; struct task_struct *next = (struct task_struct *)ctx[2];
> 1: (79) r6 = *(u64 *)(r7 +16)
> func 'sched_switch' arg2 has btf_id 186 type STRUCT 'task_struct'
> 2: R6_w=ptr_task_struct(off=0,imm=0) R7_w=ctx(off=0,imm=0)
> ; struct task_struct *prev = (struct task_struct *)ctx[1];
> 2: (79) r2 = *(u64 *)(r7 +8)          ; R2_w=scalar() R7_w=ctx(off=0,imm=0)
> 3: (b7) r1 = 0                        ; R1_w=0
> ; struct runq_event event = {};
> 4: (7b) *(u64 *)(r10 -8) = r1         ; R1_w=P0 R10=fp0 fp-8_w=00000000
> 5: (7b) *(u64 *)(r10 -16) = r1        ; R1_w=P0 R10=fp0 fp-16_w=00000000
> 6: (7b) *(u64 *)(r10 -24) = r1        ; R1_w=P0 R10=fp0 fp-24_w=00000000
> 7: (7b) *(u64 *)(r10 -32) = r1        ; R1_w=P0 R10=fp0 fp-32_w=00000000
> ; if (prev->__state == TASK_RUNNING)
> 8: (61) r1 = *(u32 *)(r2 +24)
> R2 invalid mem access 'scalar'
> processed 9 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
> -- END PROG LOAD LOG --
> libbpf: failed to load program 'handle__sched_switch'
> libbpf: failed to load object 'runqslower_bpf'
> libbpf: failed to load BPF skeleton 'runqslower_bpf': -13
> failed to load BPF object: -13
>
> Update runqslower to fix this issue. Also, as we are on this, use BPF_PROG
> in runqslower for cleaner code.
>
> Fixes: fa2c3254d7cf ("sched/tracing: Don't re-read p->state when emitting sched_switch event")
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  tools/bpf/runqslower/runqslower.bpf.c | 19 +++++--------------
>  1 file changed, 5 insertions(+), 14 deletions(-)
>

It would be much less disruptive if that prev_state was added after
"next", but oh well...

But anyways, let's handle this in a way that can handle both old
kernels and new ones and do the same change in libbpf-tool's
runqslower ([0]). Can you please follow up there as well?


We can use BPF CO-RE to detect which order of arguments running kernel
has by checking prev_state field existence in struct
trace_event_raw_sched_switch. Can you please try that? Use
bpf_core_field_exists() for that.


  [0] https://github.com/iovisor/bcc/blob/master/libbpf-tools/runqslower.bpf.c


> diff --git a/tools/bpf/runqslower/runqslower.bpf.c b/tools/bpf/runqslower/runqslower.bpf.c
> index 9a5c1f008fe6..30e491d8308f 100644
> --- a/tools/bpf/runqslower/runqslower.bpf.c
> +++ b/tools/bpf/runqslower/runqslower.bpf.c
> @@ -2,6 +2,7 @@
>  // Copyright (c) 2019 Facebook
>  #include "vmlinux.h"
>  #include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
>  #include "runqslower.h"
>
>  #define TASK_RUNNING 0
> @@ -43,31 +44,21 @@ static int trace_enqueue(struct task_struct *t)
>  }
>
>  SEC("tp_btf/sched_wakeup")
> -int handle__sched_wakeup(u64 *ctx)
> +int BPF_PROG(handle__sched_wakeup, struct task_struct *p)
>  {
> -       /* TP_PROTO(struct task_struct *p) */
> -       struct task_struct *p = (void *)ctx[0];
> -
>         return trace_enqueue(p);
>  }
>
>  SEC("tp_btf/sched_wakeup_new")
> -int handle__sched_wakeup_new(u64 *ctx)
> +int BPF_PROG(handle__sched_wakeup_new, struct task_struct *p)
>  {
> -       /* TP_PROTO(struct task_struct *p) */
> -       struct task_struct *p = (void *)ctx[0];
> -
>         return trace_enqueue(p);
>  }
>
>  SEC("tp_btf/sched_switch")
> -int handle__sched_switch(u64 *ctx)
> +int BPF_PROG(handle__sched_switch, bool preempt, unsigned long prev_state,
> +            struct task_struct *prev, struct task_struct *next)
>  {
> -       /* TP_PROTO(bool preempt, struct task_struct *prev,
> -        *          struct task_struct *next)
> -        */
> -       struct task_struct *prev = (struct task_struct *)ctx[1];
> -       struct task_struct *next = (struct task_struct *)ctx[2];
>         struct runq_event event = {};
>         u64 *tsp, delta_us;
>         long state;
> --
> 2.30.2
>
