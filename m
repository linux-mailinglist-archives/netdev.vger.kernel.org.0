Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C86F6A61
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfKJQ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:56:52 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40786 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfKJQ4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 11:56:52 -0500
Received: by mail-qt1-f195.google.com with SMTP id o49so13002291qta.7;
        Sun, 10 Nov 2019 08:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xVYwZddW2uQrv1wJIe3JywKXsEgtkCno1xUXOY49qNw=;
        b=FRNBroMJ5xyl+PhMMl1AA5TkaRZXQo5VzQjL1oJFOY4jK39KLiNJWgJUuTF4YNmYbr
         3pMumk4/oPeEgG4wwyzRPJivl+fKlK63G/Z0wNp7jiXnFmsEdowlTZhaAP/iY7QnyjPT
         Kf2mLMXKRV5LIAYNUj7KgLmM0zfoJbbUaiBtOYXS1c8jsLcKk6XA//ChtX0LUE0ejMlN
         1PbobQuoG3mFihm//WkfJ9FmvUyxaSpKXPZKsq+WKntAST99mHFsYc0z3bmCjpDso/02
         AZcZtV2jQxfzskJ2qlE6kubKUp/iZVG4/1lUz6zITC8yVWm/Hq2g+K0WTOAZRrKzsQ7Y
         Rs6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xVYwZddW2uQrv1wJIe3JywKXsEgtkCno1xUXOY49qNw=;
        b=c9BBsZ3fVUWDK7H8lAGO2N7nDaPzc6uwxa4KE1r41XG7peOJBm1GzpRn3h/3AoJYaH
         X+jZ7oI7z4uHt52cZ4IXOaHZSMHKDoF804iFLblqNRGEcOnO35VWSswTMG5yPnuEuwCh
         bMey6yaKqtdBBZgCHN4sDtPwh/x7/HH7+C/iA75UPIlis0BDYsTPAFa+6JFMxSVp2LQ7
         qezFT51LD1GxkrLtHPPCLa3cMzKpyRD2D9oYdN5MT9i4xZyRxgGtAS2QEQ6HTyqeX4lI
         1qigxjbUFOMiRRe3THlfwF56sxb9Dm0W4CuGunGXV4x4aMb9XVB802pda4tgLwr11Xen
         USFQ==
X-Gm-Message-State: APjAAAUyDDImVOYNsuquxQ95esF3CLdZuw6TxV40eny45MxTAJkuU1uN
        YAduNNw0uo1yRxB1L4qNOHCKfCGkXiWd4nxQwu8=
X-Google-Smtp-Source: APXvYqyXQOTSsiEvVB/ipLtj9q8qguN04P8k40irGmlTAME7baKhfd5yZcSJU8fNDnNfGSbsoknNWSdhvR/YUekeeEI=
X-Received: by 2002:ac8:3fed:: with SMTP id v42mr21677051qtk.171.1573405009448;
 Sun, 10 Nov 2019 08:56:49 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-17-ast@kernel.org>
In-Reply-To: <20191108064039.2041889-17-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 10 Nov 2019 08:56:38 -0800
Message-ID: <CAEf4BzY1iEAM8K+iD1KO-s31VTD82C8H9t5g4wRMin+LajKryQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 16/18] libbpf: Add support for attaching BPF
 programs to other BPF programs
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>, x86@kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 10:41 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Extend libbpf api to pass attach_prog_fd into bpf_object__open.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  tools/include/uapi/linux/bpf.h |  1 +
>  tools/lib/bpf/bpf.c            |  9 +++--
>  tools/lib/bpf/bpf.h            |  5 ++-
>  tools/lib/bpf/libbpf.c         | 65 +++++++++++++++++++++++++++++-----
>  tools/lib/bpf/libbpf.h         |  3 +-
>  5 files changed, 69 insertions(+), 14 deletions(-)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 69c200e6e696..4842a134b202 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -425,6 +425,7 @@ union bpf_attr {
>                 __aligned_u64   line_info;      /* line info */
>                 __u32           line_info_cnt;  /* number of bpf_line_info records */
>                 __u32           attach_btf_id;  /* in-kernel BTF type id to attach to */
> +               __u32           attach_prog_fd; /* 0 to attach to vmlinux */
>         };
>
>         struct { /* anonymous struct used by BPF_OBJ_* commands */
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index b3e3e99a0f28..f805787c8efd 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -228,10 +228,14 @@ int bpf_load_program_xattr(const struct bpf_load_program_attr *load_attr,
>         memset(&attr, 0, sizeof(attr));
>         attr.prog_type = load_attr->prog_type;
>         attr.expected_attach_type = load_attr->expected_attach_type;
> -       if (attr.prog_type == BPF_PROG_TYPE_TRACING)
> +       if (attr.prog_type == BPF_PROG_TYPE_TRACING) {
>                 attr.attach_btf_id = load_attr->attach_btf_id;
> -       else
> +               if (load_attr->attach_prog_fd)
> +                       attr.attach_prog_fd = load_attr->attach_prog_fd;

why the if? if it's zero, attr.attach_prog_fd will stay zero.

> +       } else {
>                 attr.prog_ifindex = load_attr->prog_ifindex;
> +               attr.kern_version = load_attr->kern_version;
> +       }
>         attr.insn_cnt = (__u32)load_attr->insns_cnt;
>         attr.insns = ptr_to_u64(load_attr->insns);
>         attr.license = ptr_to_u64(load_attr->license);

[...]

>         CHECK_ERR(bpf_object__elf_init(obj), err, out);
>         CHECK_ERR(bpf_object__check_endianness(obj), err, out);
> @@ -3927,10 +3934,12 @@ __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
>                 bpf_program__set_expected_attach_type(prog, attach_type);
>                 if (prog_type == BPF_PROG_TYPE_TRACING) {
>                         err = libbpf_attach_btf_id_by_name(prog->section_name,
> -                                                          attach_type);
> +                                                          attach_type,
> +                                                          attach_prog_fd);

libbpf_find_attach_btf_id seems like a better name at this point

>                         if (err <= 0)
>                                 goto out;
>                         prog->attach_btf_id = err;
> +                       prog->attach_prog_fd = attach_prog_fd;
>                 }
>         }
>

[...]
