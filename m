Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2821F4AC91D
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 20:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbiBGTDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 14:03:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiBGS71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 13:59:27 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83DAC0401DC;
        Mon,  7 Feb 2022 10:59:26 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id 15so11898797ilg.8;
        Mon, 07 Feb 2022 10:59:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jqSMes7om4oZ/PPBldNZ/pl7IhGQnaogvb59orgvrqw=;
        b=RK21RcvV3O/hEx8semKTCTx+TC2JmjjdPYe2me6oP/jE3B5cDbsl6nzj7tuNbBpWml
         +GOubejJyMsoD2w1mWXdG39m6oYIFOjkN6IPnj3rN/iz8IUeiq4wmNBN2q/eemoeniCJ
         JqXUwif6q6Rju4HJdwfm8Cui7H3sHhHVw+BaN+GFcemisc0LOPdpu/QC+QS0Wo71uWJF
         lsUVDJP+3GWL908onek9cV3ftwkFZrCskTzDyD8ie5WDhwXelMIIuAitlY+rCQxHiX3Z
         nqVO7kIvrL7DmkNCq3Wz8H6wndRGmYhqN7E9ngu+gJBeZRwf9dKchkh+ozVaFCiDZX7p
         FZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jqSMes7om4oZ/PPBldNZ/pl7IhGQnaogvb59orgvrqw=;
        b=xyoVrJLRVtgKTS4qeAeJqHJ5ycpI6QCQXJNzYdZx6j3NFPSnALtDWMNWTeuEvwyNTo
         qN2mnvxYbfsVj6SlWPo0WHZUG8q4hFCLI/okpXsRq50ztWpgBF6EV3vwu78um7C2iL3r
         Am4b6WhEhnEyMlMtAfOG3jTVF9CHHCASlf8zLMwn0fSIoCSFJDibLBK2Z91lzC2issn0
         daJvCA+l8uH7iGwWgvwPJUiR+m/yY/J/mb+o0/xQMcR9j3r3ixo5NwUqnxbLv2Mo4e5f
         VzXzfkP57qd0NjOUsdCmZN5d9minm6QU834ionohNMG5WzYXpeuoXFC07IQw5OlWZBPg
         CUbA==
X-Gm-Message-State: AOAM530CSXJlWAw3loq9ETQBmQzvjWTRn8/WeI50j2Z6W7RFCPwQRRT1
        e7TIXgLbpoAtnrjNiAEHW+JEiptjJ6BW4GDCacY=
X-Google-Smtp-Source: ABdhPJx9p3vUREUKxxDF6V5E2+AJkr5z9QkVtc0gKpjN95hpnHbx2hskfuYk6uLmu0wPRNs66c5YS8SWoZMqwPLmLgY=
X-Received: by 2002:a05:6e02:1bcd:: with SMTP id x13mr456145ilv.98.1644260366146;
 Mon, 07 Feb 2022 10:59:26 -0800 (PST)
MIME-Version: 1.0
References: <20220202135333.190761-1-jolsa@kernel.org> <20220202135333.190761-2-jolsa@kernel.org>
In-Reply-To: <20220202135333.190761-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Feb 2022 10:59:14 -0800
Message-ID: <CAEf4BzZYepTYLN6LrPAAaOXUtCBv07bQQJzgarntu03L+cj2GQ@mail.gmail.com>
Subject: Re: [PATCH 1/8] bpf: Add support to attach kprobe program with fprobe
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <olsajiri@gmail.com>
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

On Wed, Feb 2, 2022 at 5:53 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Adding new link type BPF_LINK_TYPE_FPROBE that attaches kprobe program
> through fprobe API.
>
> The fprobe API allows to attach probe on multiple functions at once very
> fast, because it works on top of ftrace. On the other hand this limits
> the probe point to the function entry or return.
>
> The kprobe program gets the same pt_regs input ctx as when it's attached
> through the perf API.
>
> Adding new attach type BPF_TRACE_FPROBE that enables such link for kprobe
> program.
>
> User provides array of addresses or symbols with count to attach the kprobe
> program to. The new link_create uapi interface looks like:
>
>   struct {
>           __aligned_u64   syms;
>           __aligned_u64   addrs;
>           __u32           cnt;
>           __u32           flags;
>   } fprobe;
>
> The flags field allows single BPF_F_FPROBE_RETURN bit to create return fprobe.
>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf_types.h      |   1 +
>  include/uapi/linux/bpf.h       |  13 ++
>  kernel/bpf/syscall.c           | 248 ++++++++++++++++++++++++++++++++-
>  tools/include/uapi/linux/bpf.h |  13 ++
>  4 files changed, 270 insertions(+), 5 deletions(-)
>

[...]

>
> +#ifdef CONFIG_FPROBE
> +
> +struct bpf_fprobe_link {
> +       struct bpf_link link;
> +       struct fprobe fp;
> +       unsigned long *addrs;
> +};
> +
> +static void bpf_fprobe_link_release(struct bpf_link *link)
> +{
> +       struct bpf_fprobe_link *fprobe_link;
> +
> +       fprobe_link = container_of(link, struct bpf_fprobe_link, link);
> +       unregister_fprobe(&fprobe_link->fp);
> +}
> +
> +static void bpf_fprobe_link_dealloc(struct bpf_link *link)
> +{
> +       struct bpf_fprobe_link *fprobe_link;
> +
> +       fprobe_link = container_of(link, struct bpf_fprobe_link, link);
> +       kfree(fprobe_link->addrs);
> +       kfree(fprobe_link);
> +}
> +
> +static const struct bpf_link_ops bpf_fprobe_link_lops = {
> +       .release = bpf_fprobe_link_release,
> +       .dealloc = bpf_fprobe_link_dealloc,
> +};
> +

should this whole new link implementation (including
fprobe_link_prog_run() below) maybe live in kernel/trace/bpf_trace.c?
Seems a bit more fitting than kernel/bpf/syscall.c

> +static int fprobe_link_prog_run(struct bpf_fprobe_link *fprobe_link,
> +                               struct pt_regs *regs)
> +{
> +       int err;
> +
> +       if (unlikely(__this_cpu_inc_return(bpf_prog_active) != 1)) {
> +               err = 0;
> +               goto out;
> +       }
> +
> +       rcu_read_lock();
> +       migrate_disable();
> +       err = bpf_prog_run(fprobe_link->link.prog, regs);
> +       migrate_enable();
> +       rcu_read_unlock();
> +
> + out:
> +       __this_cpu_dec(bpf_prog_active);
> +       return err;
> +}
> +
> +static void fprobe_link_entry_handler(struct fprobe *fp, unsigned long entry_ip,
> +                                     struct pt_regs *regs)
> +{
> +       unsigned long saved_ip = instruction_pointer(regs);
> +       struct bpf_fprobe_link *fprobe_link;
> +
> +       /*
> +        * Because fprobe's regs->ip is set to the next instruction of
> +        * dynamic-ftrace insturction, correct entry ip must be set, so
> +        * that the bpf program can access entry address via regs as same
> +        * as kprobes.
> +        */
> +       instruction_pointer_set(regs, entry_ip);
> +
> +       fprobe_link = container_of(fp, struct bpf_fprobe_link, fp);
> +       fprobe_link_prog_run(fprobe_link, regs);
> +
> +       instruction_pointer_set(regs, saved_ip);
> +}
> +
> +static void fprobe_link_exit_handler(struct fprobe *fp, unsigned long entry_ip,
> +                                    struct pt_regs *regs)

isn't it identical to fprobe_lnk_entry_handler? Maybe use one callback
for both entry and exit?

> +{
> +       unsigned long saved_ip = instruction_pointer(regs);
> +       struct bpf_fprobe_link *fprobe_link;
> +
> +       instruction_pointer_set(regs, entry_ip);
> +
> +       fprobe_link = container_of(fp, struct bpf_fprobe_link, fp);
> +       fprobe_link_prog_run(fprobe_link, regs);
> +
> +       instruction_pointer_set(regs, saved_ip);
> +}
> +
> +static int fprobe_resolve_syms(const void *usyms, u32 cnt,
> +                              unsigned long *addrs)
> +{
> +       unsigned long addr, size;
> +       const char **syms;
> +       int err = -ENOMEM;
> +       unsigned int i;
> +       char *func;
> +
> +       size = cnt * sizeof(*syms);
> +       syms = kzalloc(size, GFP_KERNEL);

any reason not to use kvzalloc() here?

> +       if (!syms)
> +               return -ENOMEM;
> +

[...]

> +
> +static int bpf_fprobe_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> +{
> +       struct bpf_fprobe_link *link = NULL;
> +       struct bpf_link_primer link_primer;
> +       unsigned long *addrs;
> +       u32 flags, cnt, size;
> +       void __user *uaddrs;
> +       void __user *usyms;
> +       int err;
> +
> +       /* no support for 32bit archs yet */
> +       if (sizeof(u64) != sizeof(void *))
> +               return -EINVAL;

-EOPNOTSUPP?

> +
> +       if (prog->expected_attach_type != BPF_TRACE_FPROBE)
> +               return -EINVAL;
> +
> +       flags = attr->link_create.fprobe.flags;
> +       if (flags & ~BPF_F_FPROBE_RETURN)
> +               return -EINVAL;
> +
> +       uaddrs = u64_to_user_ptr(attr->link_create.fprobe.addrs);
> +       usyms = u64_to_user_ptr(attr->link_create.fprobe.syms);
> +       if ((!uaddrs && !usyms) || (uaddrs && usyms))
> +               return -EINVAL;

!!uaddrs == !!usyms ?

> +
> +       cnt = attr->link_create.fprobe.cnt;
> +       if (!cnt)
> +               return -EINVAL;
> +
> +       size = cnt * sizeof(*addrs);
> +       addrs = kzalloc(size, GFP_KERNEL);

same, why not kvzalloc? Also, aren't you overwriting each addrs entry
anyway, so "z" is not necessary, right?

> +       if (!addrs)
> +               return -ENOMEM;
> +

[...]
