Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1808D25B8CE
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 04:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgICCbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 22:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgICCbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 22:31:45 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA16C061244;
        Wed,  2 Sep 2020 19:31:45 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id 195so1040514ybl.9;
        Wed, 02 Sep 2020 19:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=atdcOErK6cxrFEvbn73lG43RctLnARy1ThuebI0BN0E=;
        b=uthNZ6AGad7YzETHZaivxJZB9KhxMtuBuCelborCHY7OrcMZGf4AiPc+D8tHIbdBwD
         /fjUP0e5u78Uc2wwVClC3zIQ0BJCVpbvUSbbBT5ftxFNsBvjHuBxYSKaAFoQxdJkd43C
         bDRsbepZ1WEhgyEyl2+XSvFNXszzDNS7a35zzxQmRyBu36PLcDW4+8fXz+XO70XgAFM4
         QLNKGdIEyMP8DTi+Ot24zvcc9RFnAE3qu5B9ofJnf9UBgk/W4X+NsSPyforXkZajceXu
         6YhJ2CfcA2lMrmV0OgNWTz1pkMhbfpge486vdNXL6QQ10PaAKPgnmQlkerZNqFgyAedL
         xX9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=atdcOErK6cxrFEvbn73lG43RctLnARy1ThuebI0BN0E=;
        b=olxMqQ7xzy0Pd2VDvXAOOg+Wy2gxuhefoi2GKagYSArBA9OV/h22jHVLzxaHFxrbej
         JOg+iPE2ulj5RbfPiyYlrCBqjL/FeHk5EbJjGnveg/WXSxMQYubjQs+MTnZm6G9ntkn6
         gE6KXBAQMoZ0GpZYOEuTP8L3HksZAWiGQvFB92DmnimQg0bpVXECQcoiwQL4hsbS8+hH
         hzB6VZkSnyI7hjoluuJBGL+bxIoEFDkBH+R5gW72HPKAElPS2VSqkFIM9mVnUCmwUE0b
         wqYQkjj3SG9+9Ks1zIBk3DmAxJKerZrPWq/sXbEMa3X4MoT0uIWQXV/A7ExI9qeuMFYG
         fdyA==
X-Gm-Message-State: AOAM5336iktqi21jXfD15Qw5HI3mNbSGpMAWw+u1YXf0t/zRUSd5dOJN
        1Xz3c1Xh2bfv1tCjZeTVk5/03gcOr5U+jJgodEM=
X-Google-Smtp-Source: ABdhPJzh/CMS7BuyGFnGCvI6R1UkhweVLB3EBxJvgkB2xv4O2jpgkHdpl9Xj86wnBtqe7wAzTVJSK4IJdxDY83/P7Mk=
X-Received: by 2002:a25:cb57:: with SMTP id b84mr974024ybg.425.1599100304411;
 Wed, 02 Sep 2020 19:31:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200828193603.335512-1-sdf@google.com> <20200828193603.335512-4-sdf@google.com>
In-Reply-To: <20200828193603.335512-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Sep 2020 19:31:33 -0700
Message-ID: <CAEf4BzZtYTyBT=jURkF4RQLHXORooVwXrRRRkoSWDqCemyGQeA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/8] libbpf: Add BPF_PROG_BIND_MAP syscall and
 use it on .metadata section
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        YiFei Zhu <zhuyifei@google.com>,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 28, 2020 at 12:37 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> From: YiFei Zhu <zhuyifei@google.com>
>
> The patch adds a simple wrapper bpf_prog_bind_map around the syscall.
> And when using libbpf to load a program, it will probe the kernel for
> the support of this syscall, and scan for the .metadata ELF section
> and load it as an internal map like a .data section.
>
> In the case that kernel supports the BPF_PROG_BIND_MAP syscall and
> a .metadata section exists, the map will be explicitly bound to
> the program via the syscall immediately after program is loaded.
> -EEXIST is ignored for this syscall.

Here is the question I have. How important is it that all this
metadata is in a separate map? What if libbpf just PROG_BIND_MAP all
the maps inside a single BPF .o file to all BPF programs in that file?
Including ARRAY maps created for .data, .rodata and .bss, even if the
BPF program doesn't use any of the global variables? If it's too
extreme, we could do it only for global data maps, leaving explicit
map definitions in SEC(".maps") alone. Would that be terrible?
Conceptually it makes sense, because when you program in user-space,
you expect global variables to be there, even if you don't reference
it directly, right? The only downside is that you won't have a special
".metadata" map, rather it will be part of ".rodata" one.


>
> Cc: YiFei Zhu <zhuyifei1999@gmail.com>
> Signed-off-by: YiFei Zhu <zhuyifei@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/bpf.c      |  13 ++++
>  tools/lib/bpf/bpf.h      |   8 +++
>  tools/lib/bpf/libbpf.c   | 130 ++++++++++++++++++++++++++++++++-------
>  tools/lib/bpf/libbpf.map |   1 +
>  4 files changed, 131 insertions(+), 21 deletions(-)
>

[...]

> @@ -3592,18 +3619,13 @@ static int probe_kern_prog_name(void)
>         return probe_fd(ret);
>  }
>
> -static int probe_kern_global_data(void)
> +static void __probe_create_global_data(int *prog, int *map,
> +                                      struct bpf_insn *insns, size_t insns_cnt)

all those static functions are internal, no need for double underscore in names

>  {
>         struct bpf_load_program_attr prg_attr;
>         struct bpf_create_map_attr map_attr;
>         char *cp, errmsg[STRERR_BUFSIZE];
> -       struct bpf_insn insns[] = {
> -               BPF_LD_MAP_VALUE(BPF_REG_1, 0, 16),
> -               BPF_ST_MEM(BPF_DW, BPF_REG_1, 0, 42),
> -               BPF_MOV64_IMM(BPF_REG_0, 0),
> -               BPF_EXIT_INSN(),
> -       };
> -       int ret, map;
> +       int err;
>
>         memset(&map_attr, 0, sizeof(map_attr));
>         map_attr.map_type = BPF_MAP_TYPE_ARRAY;
> @@ -3611,26 +3633,40 @@ static int probe_kern_global_data(void)
>         map_attr.value_size = 32;
>         map_attr.max_entries = 1;
>
> -       map = bpf_create_map_xattr(&map_attr);
> -       if (map < 0) {
> -               ret = -errno;
> -               cp = libbpf_strerror_r(ret, errmsg, sizeof(errmsg));
> +       *map = bpf_create_map_xattr(&map_attr);
> +       if (*map < 0) {
> +               err = errno;
> +               cp = libbpf_strerror_r(err, errmsg, sizeof(errmsg));
>                 pr_warn("Error in %s():%s(%d). Couldn't create simple array map.\n",
> -                       __func__, cp, -ret);
> -               return ret;
> +                       __func__, cp, -err);
> +               return;
>         }
>
> -       insns[0].imm = map;
> +       insns[0].imm = *map;

you are making confusing and error prone assumptions about the first
instruction passed in, I really-really don't like this, super easy to
miss and super easy to screw up.

>
>         memset(&prg_attr, 0, sizeof(prg_attr));
>         prg_attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
>         prg_attr.insns = insns;
> -       prg_attr.insns_cnt = ARRAY_SIZE(insns);
> +       prg_attr.insns_cnt = insns_cnt;
>         prg_attr.license = "GPL";
>
> -       ret = bpf_load_program_xattr(&prg_attr, NULL, 0);
> +       *prog = bpf_load_program_xattr(&prg_attr, NULL, 0);
> +}
> +

[...]
