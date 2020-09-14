Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6D7269475
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726135AbgINSJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgINSJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 14:09:17 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE046C06174A;
        Mon, 14 Sep 2020 11:09:16 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id k2so548966ybp.7;
        Mon, 14 Sep 2020 11:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=so1lhnXSV+Q1fNFA9pCNKDjNqWeQTG29k8KOhsDMenA=;
        b=bvpLQv9twuL9Gtw0qJYz+jdFfuSY431ujBeL6K/GmOBPujdG9xTSuwHAzT7nsIHCxR
         v17d7AenY6LZ9AeAPMiHb/mIxkkKyIgcQlubcLlvAd+RPh3PW18fy2MOoB0Iu5jBqsFJ
         KfK2ZPqqYtftwjPZ0f3Ro9zxFUTLs1EEGM0KQEeeueV98vnOxpQ1yDK9IC8eRAu9EOMB
         71cz6tHf9PV6PQOWDpg+WGM0bSsgGziNf82dq46SMdLGsA3R/Tl6Ugnx2vhJTirbNLIs
         IJHouAYaD8bvwfSWbaQdEWDhU3wr0Kg9v5v5WKumSEQq602r4ZFkx8jXLGjugHUDVXht
         RxIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=so1lhnXSV+Q1fNFA9pCNKDjNqWeQTG29k8KOhsDMenA=;
        b=sp5WM1/C349VuQ0o9afp71sA7p5IrZyzYipMQDFnGYs+Dfj7sw5/323z0ap7Q6iB2/
         p2ErMmxzyGldAuzWhmyquUG0uYnvpuhd8mVtJ0NfkARZw1Cdv8vz4ueM3kmnOxVHe6Yr
         /nvTPNRpuf63EOKvZp5//eBB6/6x5ZRhDxfYgjONkaJme7Exng3YruDxWKxdLRTY+peP
         uhDE+a9OwYuaBFo1tcqJbMkHd+8dLBCMPX2VkJ5amJG+Guk9w6g7zGyTbQDK2W5xahL4
         33RQdBbkvQUpdw8+sz1kp4wrPELFhSojiVGp/4ixjcVtnLVn3SR3SZs20qfwapT1uide
         ad2w==
X-Gm-Message-State: AOAM531mPrUWQ6j7ZEv160T5ciqag8T7lASXS4u6luxx6tZHwLf801Tf
        LSDo5ENMxOAfHSSdrA656AbfTQoKAXQvWdvei24=
X-Google-Smtp-Source: ABdhPJx3MHbiy5SPBwLNISkJzc2l7TGFXz9mJmllm5GTu0J7lQ6yohxOZy0fLOzI3ZwaLi8Icsvl3h06PJ20EwpEFcg=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr19690513ybm.230.1600106955983;
 Mon, 14 Sep 2020 11:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200903223332.881541-1-haoluo@google.com> <20200903223332.881541-5-haoluo@google.com>
 <CAEf4BzYbpp2jiODvN=GO4R4SNpw-w5shPMaR+=jssv7fNLA0oA@mail.gmail.com> <CA+khW7goxucH5dNcW5nU+9r7JgCHo=MkL1orDsju-OOv7u1UNw@mail.gmail.com>
In-Reply-To: <CA+khW7goxucH5dNcW5nU+9r7JgCHo=MkL1orDsju-OOv7u1UNw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Sep 2020 11:09:05 -0700
Message-ID: <CAEf4BzZWr7aw0D3d0Etmm=AVrLVsgDbY5W+1Aj9o8iBYkhJWew@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/6] bpf: Introduce bpf_per_cpu_ptr()
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Andrey Ignatov <rdna@fb.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 13, 2020 at 10:01 PM Hao Luo <haoluo@google.com> wrote:
>
> Thanks for review, Andrii.
>
> One question, should I add bpf_{per, this}_cpu_ptr() to the
> bpf_base_func_proto() in kernel/bpf/helpers.c?

Yes, probably, but given it allows poking at kernel memory, it
probably needs to be guarded by perfmon_capable() check, similar to
bpf_get_current_task_proto.

>
> On Fri, Sep 4, 2020 at 1:04 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Thu, Sep 3, 2020 at 3:35 PM Hao Luo <haoluo@google.com> wrote:
> > >
> > > Add bpf_per_cpu_ptr() to help bpf programs access percpu vars.
> > > bpf_per_cpu_ptr() has the same semantic as per_cpu_ptr() in the kernel
> > > except that it may return NULL. This happens when the cpu parameter is
> > > out of range. So the caller must check the returned value.
> > >
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > Signed-off-by: Hao Luo <haoluo@google.com>
> > > ---
> > >  include/linux/bpf.h            |  3 ++
> > >  include/linux/btf.h            | 11 ++++++
> > >  include/uapi/linux/bpf.h       | 17 +++++++++
> > >  kernel/bpf/btf.c               | 10 ------
> > >  kernel/bpf/verifier.c          | 66 +++++++++++++++++++++++++++++++---
> > >  kernel/trace/bpf_trace.c       | 18 ++++++++++
> > >  tools/include/uapi/linux/bpf.h | 17 +++++++++
> > >  7 files changed, 128 insertions(+), 14 deletions(-)
> > >

[...]

> > > @@ -5002,6 +5016,30 @@ static int check_helper_call(struct bpf_verifier_env *env, int func_id, int insn
> > >                 regs[BPF_REG_0].type = PTR_TO_MEM_OR_NULL;
> > >                 regs[BPF_REG_0].id = ++env->id_gen;
> > >                 regs[BPF_REG_0].mem_size = meta.mem_size;
> > > +       } else if (fn->ret_type == RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL) {
> >
> > Given this is internal implementation detail, this return type is
> > fine, but I'm wondering if it would be better to just make
> > PTR_TO_BTF_ID to allow not just structs? E.g., if we have an int, just
> > allow reading those 4 bytes.
> >
> > Not sure what the implications are in terms of implementation, but
> > conceptually that shouldn't be a problem, given we do have BTF type ID
> > describing size and all.
> >
>
> Yeah. Totally agree. I looked at it initially. My take is
> PTR_TO_BTF_ID is meant for struct types. It required some code
> refactoring to break this assumption. I can add it to my TODO list and
> investigate it if this makes more sense.

PTR_TO_BTF_ID was *implemented* for struct, but at least naming-wise
nothing suggests it has to be restricted to structs. But yeah, this
should be a separate change, don't block your patches on that.

>
> > > +               const struct btf_type *t;
> > > +

[...]
