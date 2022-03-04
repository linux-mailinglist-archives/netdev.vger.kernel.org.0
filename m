Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2514CE0A3
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiCDXME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiCDXMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:03 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E9627B910;
        Fri,  4 Mar 2022 15:11:13 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id t11so11184122ioi.7;
        Fri, 04 Mar 2022 15:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=chHeuZ1R7R/9uOv3Rs78kwXYW7yBarP0NUqAPf9mrfY=;
        b=JKeClCV8G5dtSF7wXwZibhtsoEBI6/azOjJHA0/NbS8hsVfk4Axky+dKi4a+OgA80J
         QI4EyEU4/0KnrOEfu6AFqTnJ8OHr/uaAlBixro73IvrT8z0yNUS2k9SOESgqojnBpxFi
         tFr6gUIRWxTh6c7NY8T2dG7t714Jgkgaf6ZZ9YxmPdFMVFADdTULEZEuCh+KW9QlnUko
         BoJsXmfwk4OVyePsT1pAxB71eGj5tT7RFB/p4FVNHVW2Adr66qFZYkOxfd8BFrmHMAhE
         PofdWGd8HlV6LmhsYuxuus39Cz0XA4s7/atp/e8H/tHZQJDPfmwxzyAeL6gqGW64eGhu
         hcOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=chHeuZ1R7R/9uOv3Rs78kwXYW7yBarP0NUqAPf9mrfY=;
        b=DoLBjP2LWF29W2xUOnAuoj2/OasaLAgByMrFioX/prK3zceXQszjj3nMn5WWSvGjru
         8DfDuB9yBK8FOgssKUQLweD0P3XwxnLu/HMUnLvzwjYyEhBo4rBt93KK2mO0HZOFRN/t
         k4Ti4+QZguCbuK+KhEJxJHDNkItYmduM3tMvuSwR1aFBqeRAtQTnPi+8XQ5T5R0ZJ+5N
         HQ0S4V+K9Ja71xqzVw/wClxAHT+4jzp6LLD8OMNPfvpZkMwYh7yh1teMpOVlSw1z+TT3
         M4k/MYnyEUCJIhBfM0NIYCYCrUirsaDslcYJ7YwUg9xIykXGgfBAd4m1VLURzz+kvgeH
         pwiA==
X-Gm-Message-State: AOAM531egiRCD9pP3eb1pfumTXuPAgLzbYEdfNuhWh9gKa3uRTVyZYEh
        YszksIAaZOYtZ/fALn45NOYcVJ1YCxc/JWpFwN4=
X-Google-Smtp-Source: ABdhPJz++wUa1f5WtNUSm8fZE4DOvfTuvtqKTm+Mqcbo9eEqHtCLirllUKo16v60Ttq902Rwn9Jem+qZogW+nuHxX3M=
X-Received: by 2002:a02:aa85:0:b0:314:c152:4c89 with SMTP id
 u5-20020a02aa85000000b00314c1524c89mr704604jai.93.1646435473134; Fri, 04 Mar
 2022 15:11:13 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-3-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:01 -0800
Message-ID: <CAEf4BzadsmOTas7BdF-J+de7AqsoccY1o6e0pUBkRuWH+53DiQ@mail.gmail.com>
Subject: Re: [PATCH 02/10] bpf: Add multi kprobe link
To:     Jiri Olsa <jolsa@kernel.org>
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
        Steven Rostedt <rostedt@goodmis.org>
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

On Tue, Feb 22, 2022 at 9:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding new link type BPF_LINK_TYPE_KPROBE_MULTI that attaches kprobe
> program through fprobe API.
>
> The fprobe API allows to attach probe on multiple functions at once
> very fast, because it works on top of ftrace. On the other hand this
> limits the probe point to the function entry or return.
>
> The kprobe program gets the same pt_regs input ctx as when it's attached
> through the perf API.
>
> Adding new attach type BPF_TRACE_KPROBE_MULTI that allows attachment
> kprobe to multiple function with new link.
>
> User provides array of addresses or symbols with count to attach the
> kprobe program to. The new link_create uapi interface looks like:
>
>   struct {
>           __aligned_u64   syms;
>           __aligned_u64   addrs;
>           __u32           cnt;
>           __u32           flags;
>   } kprobe_multi;
>
> The flags field allows single BPF_TRACE_KPROBE_MULTI bit to create
> return multi kprobe.
>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/bpf_types.h      |   1 +
>  include/linux/trace_events.h   |   6 +
>  include/uapi/linux/bpf.h       |  13 ++
>  kernel/bpf/syscall.c           |  26 +++-
>  kernel/trace/bpf_trace.c       | 211 +++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  13 ++
>  6 files changed, 265 insertions(+), 5 deletions(-)
>

[...]

> +
> +static int
> +kprobe_multi_resolve_syms(const void *usyms, u32 cnt,
> +                         unsigned long *addrs)
> +{
> +       unsigned long addr, size;
> +       const char **syms;
> +       int err = -ENOMEM;
> +       unsigned int i;
> +       char *func;
> +
> +       size = cnt * sizeof(*syms);
> +       syms = kvzalloc(size, GFP_KERNEL);
> +       if (!syms)
> +               return -ENOMEM;
> +
> +       func = kmalloc(KSYM_NAME_LEN, GFP_KERNEL);
> +       if (!func)
> +               goto error;
> +
> +       if (copy_from_user(syms, usyms, size)) {
> +               err = -EFAULT;
> +               goto error;
> +       }
> +
> +       for (i = 0; i < cnt; i++) {
> +               err = strncpy_from_user(func, syms[i], KSYM_NAME_LEN);
> +               if (err == KSYM_NAME_LEN)
> +                       err = -E2BIG;
> +               if (err < 0)
> +                       goto error;
> +
> +               err = -EINVAL;
> +               if (func[0] == '\0')
> +                       goto error;

wouldn't empty string be handled by kallsyms_lookup_name?

> +               addr = kallsyms_lookup_name(func);
> +               if (!addr)
> +                       goto error;
> +               if (!kallsyms_lookup_size_offset(addr, &size, NULL))
> +                       size = MCOUNT_INSN_SIZE;
> +               addr = ftrace_location_range(addr, addr + size - 1);
> +               if (!addr)
> +                       goto error;
> +               addrs[i] = addr;
> +       }
> +
> +       err = 0;
> +error:
> +       kvfree(syms);
> +       kfree(func);
> +       return err;
> +}
> +

[...]
