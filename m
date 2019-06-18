Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B97497AA
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 05:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbfFRDCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 23:02:07 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40646 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfFRDCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 23:02:07 -0400
Received: by mail-lj1-f193.google.com with SMTP id a21so11442410ljh.7;
        Mon, 17 Jun 2019 20:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yDn5xMPXHFGcl2badmhD83jM1IwEhBvIcXU77fl289c=;
        b=MJ1Y2+NWKGyn6timkXov6EhCzRib6XdPLQu8GC/Rf6kduQ+hdMmJBYngWGn5aYHnEu
         8szaMsw0Sce6ZVj78znJ2YYgItgW9drLGDYuM2EmFU0r/4dtPWkbUYcDfQtL6/OPLNeK
         dmP/2WE6spq40riFAVzBdy6hnpqB8qA51f55iSrOaBe5t8bZ1wRP2dj3K3Ss5jdAKWc8
         J39Z2/NgAIte0QsfIzYmwwhHdJh5F5ORlPbCypNJVMcvQl4gEae/aePDk0/9Cg3ShC9h
         4fXoZNxflMcMewmlu2rdIjdm2ZnBRxTzIh02Zmzxe9n4aiFuWbCJgXShgJinWDyz6EcO
         WjbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yDn5xMPXHFGcl2badmhD83jM1IwEhBvIcXU77fl289c=;
        b=TKnw0KCDcC6hTUe939qQ9DjUcvVQ1oC8gSHnjZsw6bN5/3wCzDIOrKxSTGYAgRrTnw
         jx5P32K2VU22T33KfWoKkRHA4N1YHjuCFSLUKnZICeAa7jExlPNn7qzbRYt5TcJ+ROf6
         FZY+6KAfzgs8lTjbZxk2m5FA2q/8GNUUvW2FxukUuiyJGmxFU5v3f17cCXKiifUlIbLI
         8Rf+yD/nbheNxmCLHLLqMITpACdY1l6JEBLHmHCcpXr5+h7tujgnHo5a89mz9ZA0wzZM
         Uoi04L26MrSFrNGrM9tMty3hrjwzdi08TSvQvKbp1gQPJ64CnKbWFshf+CACLT8wQSBv
         aFOQ==
X-Gm-Message-State: APjAAAX8GFkt81OG0UyHANsctL+MYzqlcnTotOvpav/UPfT98f1zPwqh
        mgMlHhIMJv14l2v6C2n80kEi5S/564EAQaJEyuc=
X-Google-Smtp-Source: APXvYqykxYn2h7BHvGt5WniRN1+QJUJk2wsHHao2z8XHcHmk3SK91BvK7PTtwsNleuGyGFRsmF2KDgEttifH5igEyAo=
X-Received: by 2002:a2e:9dca:: with SMTP id x10mr29785188ljj.17.1560826925180;
 Mon, 17 Jun 2019 20:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190521184137.GH2422@oracle.com> <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com> <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com> <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
 <20190523051608.GP2422@oracle.com> <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
 <20190618012509.GF8794@oracle.com> <CAADnVQJoH4WOQ0t7ZhLgh4kh2obxkFs0UGDRas0y4QSqh1EMsg@mail.gmail.com>
 <20190618015442.GG8794@oracle.com>
In-Reply-To: <20190618015442.GG8794@oracle.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 17 Jun 2019 20:01:52 -0700
Message-ID: <CAADnVQ+zAwoH_mjJLhfEgXHHz+3WYkzhEm-mEObP0koLiSvknw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, dtrace-devel@oss.oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 6:54 PM Kris Van Hees <kris.van.hees@oracle.com> wrote:
>
> It is not hypothetical.  The folowing example works fine:
>
> static int noinline bpf_action(void *ctx, long fd, long buf, long count)
> {
>         int                     cpu = bpf_get_smp_processor_id();
>         struct data {
>                 u64     arg0;
>                 u64     arg1;
>                 u64     arg2;
>         }                       rec;
>
>         memset(&rec, 0, sizeof(rec));
>
>         rec.arg0 = fd;
>         rec.arg1 = buf;
>         rec.arg2 = count;
>
>         bpf_perf_event_output(ctx, &buffers, cpu, &rec, sizeof(rec));
>
>         return 0;
> }
>
> SEC("kprobe/ksys_write")
> int bpf_kprobe(struct pt_regs *ctx)
> {
>         return bpf_action(ctx, ctx->di, ctx->si, ctx->dx);
> }
>
> SEC("tracepoint/syscalls/sys_enter_write")
> int bpf_tp(struct syscalls_enter_write_args *ctx)
> {
>         return bpf_action(ctx, ctx->fd, ctx->buf, ctx->count);
> }
>
> char _license[] SEC("license") = "GPL";
> u32 _version SEC("version") = LINUX_VERSION_CODE;

Great. Then you're all set to proceed with user space dtrace tooling, right?

What you'll discover thought that it works only for simplest things
like above. libbpf assumes that everything in single elf will be used
and passes the whole thing to the kernel.
The verifer removes dead code only from single program.
It disallows unused functions. Hence libbpf needs to start doing
more "linker work" than it does today.
When it loads .o it needs to pass to the kernel only the functions
that are used by the program.
This work should be straightforward to implement.
Unfortunately no one had time to do it.
It's also going to be the first step to multi-elf support.
libbpf would need to do the same "linker work" across .o-s.
