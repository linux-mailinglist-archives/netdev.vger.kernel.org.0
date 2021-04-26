Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B37136BBCA
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 00:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhDZWrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 18:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbhDZWrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 18:47:23 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2633BC061574;
        Mon, 26 Apr 2021 15:46:41 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id e8so7034010ybq.11;
        Mon, 26 Apr 2021 15:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZoP3h1mLOqV7AEOAza5caYoovSekocBBtoC/6WNGTI4=;
        b=fzBktLUDM/vNKKeTrurCMkELIZf93fIotp9f7PvACPy0sEylPBcQzLdglGUWdwO7iq
         ZUgzaFALlptDAKLTKmI+uPa4IATX2xjYldFh9D3I0uanLrJgq3o1otSf8hdvD+hUme3m
         MXINR4K9bagUpCv/KAK51I0yWooaBKMZ1bI0hg4iF0aNlaojIF6I7LGQr+u9FQbWqFGr
         mQJIKkviKiB42xb9lNOBwbskQ4xEqaYRr//zOgX6uuyNoqm7JTjuP3vg5ErxDAp7Mkwd
         SJMauS1I9Ze5j12jGws2wiscwfQUxC32QzJs1Jr97Er+b/rNHFbH5U4gN8joXkUFO4e4
         /WEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZoP3h1mLOqV7AEOAza5caYoovSekocBBtoC/6WNGTI4=;
        b=qFKluE22qcd3Y/GkJRYe60lURl7duLHESM5U9rjNBsbZ91YnQb76tJrh9uz/1VY4h4
         izBOaHyrEdjHnVlpdFVM575Yx5iS2Yv4TPtvHRq3JkyudMc4Ajl8WT7KGmR7qumMx+cD
         59qrjEOlgwjk2xaC8wc84paTkCXmXGmHos0o9LD9z02/D6icB6x+3GtAZMkB69FpK6OF
         bgOs5ouGiHSg7z7j5vsPHb91CFE9jRxZsFmFhdqh0VgG/dcClatL6qfnC/RKLmD+ltPc
         9muJopafuneLbabVCl8B7hqJJ9acKKkASfykbDjqNnr0UIcJYrwsg5TTCiZgBu3Ar456
         HErQ==
X-Gm-Message-State: AOAM532WS2W40Ewzicceo6ee2LTa4wtG/GkWPV9N5hOtvPfYQVZmlaro
        SPrjwFkzwTE2IKhMAG3jgH0KgxdspFWljxbNOkE=
X-Google-Smtp-Source: ABdhPJy2sXWYpZ2X2XRYTYYBlQbxU/z2boJtt4Ny2Qx6pTdxbGcJI5bq918+eiY6CIpwA7CXypmdVRy2jh0PCF4ylg0=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr26304531ybg.459.1619477200000;
 Mon, 26 Apr 2021 15:46:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com> <20210423002646.35043-11-alexei.starovoitov@gmail.com>
In-Reply-To: <20210423002646.35043-11-alexei.starovoitov@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Apr 2021 15:46:29 -0700
Message-ID: <CAEf4BzYkzzN=ZD2X1bOg8U39Whbe6oTPuUEMOpACw6NPEW69NA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind() helper.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> Add new helper:
>
> long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
>         Description
>                 Find given name with given type in BTF pointed to by btf_fd.
>                 If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
>         Return
>                 Returns btf_id and btf_obj_fd in lower and upper 32 bits.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/bpf.h       |  8 ++++
>  kernel/bpf/btf.c               | 68 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           |  2 +
>  tools/include/uapi/linux/bpf.h |  8 ++++
>  5 files changed, 87 insertions(+)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 0f841bd0cb85..4cf361eb6a80 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1972,6 +1972,7 @@ extern const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto;
>  extern const struct bpf_func_proto bpf_task_storage_get_proto;
>  extern const struct bpf_func_proto bpf_task_storage_delete_proto;
>  extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
> +extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
>
>  const struct bpf_func_proto *bpf_tracing_func_proto(
>         enum bpf_func_id func_id, const struct bpf_prog *prog);
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index de58a714ed36..253f5f031f08 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -4748,6 +4748,13 @@ union bpf_attr {
>   *             Execute bpf syscall with given arguments.
>   *     Return
>   *             A syscall result.
> + *
> + * long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
> + *     Description
> + *             Find given name with given type in BTF pointed to by btf_fd.

"Find BTF type with given name"? Should the limits on name length be
specified? KSYM_NAME_LEN is a pretty arbitrary restriction. Also,
would it still work fine if the caller provides a pointer to a much
shorter piece of memory?

Why not add name_sz right after name, as we do with a lot of other
arguments like this?

> + *             If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> + *     Return
> + *             Returns btf_id and btf_obj_fd in lower and upper 32 bits.

Mention that for vmlinux BTF btf_obj_fd will be zero? Also who "owns"
the FD? If the BPF program doesn't close it, when are they going to be
cleaned up?

>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -4917,6 +4924,7 @@ union bpf_attr {
>         FN(for_each_map_elem),          \
>         FN(snprintf),                   \
>         FN(sys_bpf),                    \
> +       FN(btf_find_by_name_kind),      \
>         /* */
>

[...]
