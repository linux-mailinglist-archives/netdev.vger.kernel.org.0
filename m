Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAFD137823
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 21:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgAJUxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 15:53:34 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35227 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgAJUxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 15:53:33 -0500
Received: by mail-qk1-f196.google.com with SMTP id z76so3246332qka.2;
        Fri, 10 Jan 2020 12:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p0OVjw7QitRm9+hih1vwOpgccxzVYk1W5EJHuP7Vu9I=;
        b=QzGUzUb0cXrcrUMHjWHU3YYO0wbjeAdhYBLZgtaIE2pdmHZXiXkzVyPX0mkVVr09qz
         Ihw/cpyGVbk6gmX9yZTbGpijJyimlGQY2C8SVlnYJA4gwwE5xn7hgjbH2HvUtIpio9tK
         ugrPqlnE3ycAhNSUKNZcT9423gyRsJF/pS5GcmK7tNRgQnyaa/9uoL+OgBcSUBMU4rfK
         ybFYq2pHXBS65uvyd/L5P5Lle0WWfOJeaRebdnKYfeK+0jl9xQiwWQabsxtmkHU8aNao
         yvTM7W+V3GkgXNu1jAcFzk4N3YoiD++xJcGUHjllvQDfGfFSR1EBcD0b1CAzbIvUS+du
         C/2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p0OVjw7QitRm9+hih1vwOpgccxzVYk1W5EJHuP7Vu9I=;
        b=LlUGGWv4AmLU9P8TQeHJ2bYkA8B32ftOEkaMhXJH7BEjdEJWa9KepKTXVN2ihOTB2p
         e74/IAVNl/StQGIHXut52BnWVd0w1vgTFRWFUmXh2A68X92H16/soHWdOgdTbeHFz9ZU
         U0Rsm4r8cDxEKiirj9FjIAfAZadFZMrgulyNDdw+sNwk7mnIczn333KFuFEAi3akDOOD
         LS0rkWCfG52h3M+sw/hnljv7rVM7KYh5Cy4eXwzTfDO2NpP6LhT/TJvnhaAqe5hBHBYv
         GpM5btC4sgWPsnIlQg+ZKuO3EUDoDk9GyuZFTvAeDVqk3sKN+cI8FJyPKzC2U43YXwvQ
         WVkg==
X-Gm-Message-State: APjAAAXd/HBWmM5hkpghAVYjOjVnzuR/sTF+EfcBz5wvcARO9RwPleWQ
        tR8Xzl+DHCzQUxqRlCqUSfYGrtpGgaxR4bBlhnY=
X-Google-Smtp-Source: APXvYqzD6BQ06xQ1HzXtzXT+wQBYO1pgmZR3IS9/4XS4bHbn20N2Bxm99uaWJQv1gfiz40GqLbuq3x+rdyUXILv6NAA=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr497400qkq.437.1578689612612;
 Fri, 10 Jan 2020 12:53:32 -0800 (PST)
MIME-Version: 1.0
References: <20191229225103.311569-1-eric@sage.org>
In-Reply-To: <20191229225103.311569-1-eric@sage.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Jan 2020 12:53:21 -0800
Message-ID: <CAEf4BzbGvmy97q4RMyBSdK0zAyyCfkZaz5-ZZbTb18DX0vCcGQ@mail.gmail.com>
Subject: Re: [PATCH] samples/bpf: Add xdp_stat sample program
To:     Eric Sage <eric@sage.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 29, 2019 at 2:51 PM Eric Sage <eric@sage.org> wrote:
>
> At Facebook we use tail calls to jump between our firewall filters and
> our L4LB. This is a program I wrote to estimate per program performance
> by swapping out the entries in the program array with interceptors that
> take measurements and then jump to the original entries.
>
> I found the sample programs to be invaluable in understanding how to use
> the libbpf API (as well as the test env from the xdp-tutorial repo for
> testing), and want to return the favor. I am currently working on
> my next iteration that uses fentry/fexit to be less invasive,
> but I thought it was an interesting PoC of what you can do with program
> arrays.
>
> Signed-off-by: Eric Sage <eric@sage.org>
> ---

Hey Eric,

Thanks for contributing this to samples. Ideally this would use BPF
skeleton to simplify all the map and program look ups, but given
samples/bpf doesn't have a infrastructure set up for this, it might be
a bit too much effort at this point. So I think it's ok to do it this
way, even though it would be really nice to try.

But please update the old-style bpf_map_def to BTF-defined maps before
this gets merged (see below).

>  samples/bpf/Makefile          |   3 +
>  samples/bpf/xdp_stat_common.h |  28 ++
>  samples/bpf/xdp_stat_kern.c   | 169 ++++++++
>  samples/bpf/xdp_stat_user.c   | 746 ++++++++++++++++++++++++++++++++++
>  4 files changed, 946 insertions(+)
>  create mode 100644 samples/bpf/xdp_stat_common.h
>  create mode 100644 samples/bpf/xdp_stat_kern.c
>  create mode 100644 samples/bpf/xdp_stat_user.c
>

[...]

> +#include <uapi/linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +#include "xdp_stat_common.h"
> +
> +#define MAX_PROG_ARRAY 64
> +
> +/* NR is used to map interceptors to the programs that are being intercepted. */
> +#define INTERCEPTOR(INDEX)                                                     \
> +       SEC("xdp/interceptor_" #INDEX)                                         \
> +       int interceptor_##INDEX(struct xdp_md *ctx)                            \
> +       {                                                                      \
> +               return interceptor_impl(ctx, INDEX);                           \
> +       }
> +
> +       /* Required to use bpf_ktime_get_ns() */
> +       char _license[] SEC("license") = "GPL";

Wrong indentation?

> +
> +/* interception_info holds a single record per CPU to pass global state between
> + * interceptor programs.
> + */
> +struct bpf_map_def SEC("maps") interception_info = {
> +       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(struct interception_info_rec),
> +       .max_entries = 1,
> +};

With BTF-define maps this would be

struct {
    __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
    __uint(max_entries, 1);
    __type(key, __u32);
    __type(value, struct interception_info_rec);
} interception_info SEC(".maps");

Can you please switch all the maps to this new syntax?

> +
> +/* interceptor_stats maps interceptor indexes to measurements of an intercepted
> + * BPF program. Index 0 maps the interceptor entrypoint to measurements of the
> + * original entrypoint.
> + */
> +struct bpf_map_def SEC("maps") prog_stats = {
> +       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> +       .key_size = sizeof(__u32),
> +       .value_size = sizeof(struct prog_stats_rec),
> +       .max_entries = MAX_PROG_ARRAY,
> +};
> +

[...]

> +static struct intercept_ctx *intercept__setup(char *mappath, int ifindex)
> +{
> +       struct intercept_ctx *ctx = malloc(sizeof(struct intercept_ctx));
> +
> +       ctx->ifindex = ifindex;
> +
> +       ctx->stats_enabled_oldval =
> +               _update_sysctl("/proc/sys/kernel/bpf_stats_enabled", 1);
> +       if (ctx->stats_enabled_oldval < 0)
> +               perror("ERR: set bpf_stats_enabled sysctl failed\n");
> +
> +       if (bpf_prog_load(FILENAME_XDP_STAT_KERN, BPF_PROG_TYPE_XDP,
> +                         &ctx->bpf_obj, &ctx->entry_fd)) {

bpf_object__open() + bpf_object__load() is preferred over
bpf_prog_load() way to open and load BPF object files, would be nice
to use that instead.

Alternative is BPF skeleton, but as I said, it will require a bit more
set up in Makefile (you'd need to generate skeleton with `bpftool gen
skeleton <your-bpf-object>.o`). Few benefits of BPF skeleton, though:
  - you wouldn't need to look up maps and programs by name, they would
be accessible as struct fields of skeleton (e.g.,
skel->maps.interception_info);
  - BPF object file would be embedded into userspace program, so when
distributing this you wouldn't need to drag along a separate .o file.


> +               fprintf(stderr, "ERR: failed to load %s\n",
> +                       FILENAME_XDP_STAT_KERN);
> +               return NULL;
> +       }
> +

[...]
