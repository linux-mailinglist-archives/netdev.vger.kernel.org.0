Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AA21CB89C
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727815AbgEHTwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHTwL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:52:11 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF092C061A0C;
        Fri,  8 May 2020 12:52:10 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id h26so2403437qtu.8;
        Fri, 08 May 2020 12:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KWsc3qLdfyIdfQRdfJq6wUQZM+jp1CytRuZbpnEGJAQ=;
        b=J3zpykXKSUx9Px1Jq4f77PefwP2HzaFKtGHYfHdrNVjwBoKDv5vD+xQgvoK4mZgFSA
         +uLLGbyoMFD7IBVyRfyqTwkjiy+pOPhfltsNOdmrzvstDx0Xi93qG5lWwfyfyOUoQqX3
         aTkyDUIo+C6ZwIvGmVcwMdSN39VC9ahA4ISXRL3HF5CngtpGoh2arfcNho61Hd0KjGnW
         75Inc1hlHQhPE53Nad3Cjyc7Re4KMHY+ZI8ZhdrQfDLXv48heI3CzsB8pVM2AXR6/9Sa
         XjfBs+2ckDV37n8tOgvNTc0VLcC4zxKMwem54iGHP7dtK5l4aHTF1u39CuKqxPL4rFj/
         SPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KWsc3qLdfyIdfQRdfJq6wUQZM+jp1CytRuZbpnEGJAQ=;
        b=eb/wZoyCNsS+1hK1GFH64N8GEE4VYwe3iJ/EQcCV7Bh55OpvCkjNV+eGr94ViBqqTH
         etyYXLJkvlHTTAJAmrf+60o1MNuYU0UF+a0JlQe7+SEUA8iq/3MvUaCxLU4RwwMI89O7
         RBmV6AN0n0Kuc2ffCX5vteYdUk9AWiOgm++FrmWFD2TyT3PEU/tnw0WaV8UDRcWuHqqs
         51FjyGOE//qrLQ3SO7GeHPg1FPA8SKIVf8PQPNbGhwy7wHi8htdCuqGloAtZvU+Cpm2F
         CLURYn0iOXgZ46RQQXln5VtEccRY+ObRF12A70EridXbe3TxtDH13dhOpahlKNMlratS
         EGjg==
X-Gm-Message-State: AGi0PuYlaWFwHfoqJlAhQQjxTMiM6Ve+5bzg1plNwV36dJ6eKeD1X53B
        sEQBSiPRtHLzAIHbYEIWFmjMDkF7zyqNkXjQNgmpTy6I
X-Google-Smtp-Source: APiQypKrZhZG8T3TVSds4GTFlBuWfttFxwdbMCavACswRepjvkBRb+pdxLCzgaRyuLH66c7YMdZFLIOZr/rdxg33XAE=
X-Received: by 2002:ac8:51d3:: with SMTP id d19mr4623372qtn.141.1588967529889;
 Fri, 08 May 2020 12:52:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053936.1545284-1-yhs@fb.com>
In-Reply-To: <20200507053936.1545284-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 12:51:58 -0700
Message-ID: <CAEf4Bzb1VJj5gWvL0Jiip8P9KhSfT6seCRH8N7Q49Fw3_jNOGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 18/21] tools/bpftool: add bpf_iter support for bptool
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
>
> Currently, only one command is supported
>   bpftool iter pin <bpf_prog.o> <path>
>
> It will pin the trace/iter bpf program in
> the object file <bpf_prog.o> to the <path>
> where <path> should be on a bpffs mount.
>
> For example,
>   $ bpftool iter pin ./bpf_iter_ipv6_route.o \
>     /sys/fs/bpf/my_route
> User can then do a `cat` to print out the results:
>   $ cat /sys/fs/bpf/my_route
>     fe800000000000000000000000000000 40 00000000000000000000000000000000 ...
>     00000000000000000000000000000000 00 00000000000000000000000000000000 ...
>     00000000000000000000000000000001 80 00000000000000000000000000000000 ...
>     fe800000000000008c0162fffebdfd57 80 00000000000000000000000000000000 ...
>     ff000000000000000000000000000000 08 00000000000000000000000000000000 ...
>     00000000000000000000000000000000 00 00000000000000000000000000000000 ...
>
> The implementation for ipv6_route iterator is in one of subsequent
> patches.
>
> This patch also added BPF_LINK_TYPE_ITER to link query.
>
> In the future, we may add additional parameters to pin command
> by parameterizing the bpf iterator. For example, a map_id or pid
> may be added to let bpf program only traverses a single map or task,
> similar to kernel seq_file single_open().
>
> We may also add introspection command for targets/iterators by
> leveraging the bpf_iter itself.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  .../bpftool/Documentation/bpftool-iter.rst    | 83 ++++++++++++++++++
>  tools/bpf/bpftool/bash-completion/bpftool     | 13 +++
>  tools/bpf/bpftool/iter.c                      | 84 +++++++++++++++++++
>  tools/bpf/bpftool/link.c                      |  1 +
>  tools/bpf/bpftool/main.c                      |  3 +-
>  tools/bpf/bpftool/main.h                      |  1 +
>  6 files changed, 184 insertions(+), 1 deletion(-)
>  create mode 100644 tools/bpf/bpftool/Documentation/bpftool-iter.rst
>  create mode 100644 tools/bpf/bpftool/iter.c
>

[...]

> diff --git a/tools/bpf/bpftool/iter.c b/tools/bpf/bpftool/iter.c
> new file mode 100644
> index 000000000000..a8fb1349c103
> --- /dev/null
> +++ b/tools/bpf/bpftool/iter.c
> @@ -0,0 +1,84 @@
> +// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +// Copyright (C) 2020 Facebook
> +
> +#define _GNU_SOURCE
> +#include <linux/err.h>
> +#include <bpf/libbpf.h>
> +
> +#include "main.h"
> +
> +static int do_pin(int argc, char **argv)
> +{
> +       const char *objfile, *path;
> +       struct bpf_program *prog;
> +       struct bpf_object *obj;
> +       struct bpf_link *link;
> +       int err;
> +
> +       if (!REQ_ARGS(2))
> +               usage();
> +
> +       objfile = GET_ARG();
> +       path = GET_ARG();
> +
> +       obj = bpf_object__open(objfile);
> +       if (IS_ERR_OR_NULL(obj)) {

nit: can't be NULL

> +               p_err("can't open objfile %s", objfile);
> +               return -1;
> +       }
> +
> +       err = bpf_object__load(obj);
> +       if (err) {
> +               p_err("can't load objfile %s", objfile);
> +               goto close_obj;
> +       }
> +
> +       prog = bpf_program__next(NULL, obj);

check for null and printf error? Crashing is not good.

> +       link = bpf_program__attach_iter(prog, NULL);
> +       if (IS_ERR(link)) {
> +               err = PTR_ERR(link);
> +               p_err("attach_iter failed for program %s",
> +                     bpf_program__name(prog));
> +               goto close_obj;
> +       }
> +
> +       err = mount_bpffs_for_pin(path);
> +       if (err)
> +               goto close_link;
> +
> +       err = bpf_link__pin(link, path);
> +       if (err) {
> +               p_err("pin_iter failed for program %s to path %s",
> +                     bpf_program__name(prog), path);
> +               goto close_link;
> +       }
> +
> +close_link:
> +       bpf_link__disconnect(link);

this is wrong, just destroy()

> +       bpf_link__destroy(link);
> +close_obj:
> +       bpf_object__close(obj);
> +       return err;
> +}
> +

[...]
