Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B3D2C6157
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 10:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgK0JG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 04:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbgK0JG5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 04:06:57 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23515C0613D1;
        Fri, 27 Nov 2020 01:06:57 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id o4so1578343pgj.0;
        Fri, 27 Nov 2020 01:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WHCTE/jKabwXI80tqWfQMEJnwOXap2U+zyhTat35ngQ=;
        b=ZSndZbVnqyKRA014LUScDyTak7vi2SePTI/ppGDafe2/jMyd8fj7kf0VK6Omp9pQwc
         6eG7N5zwqb50jrdMroP4YCU+bf0vmYY2kGoSFK2YKiOJoB1jzwDh8IT5r8md6rLRmXs/
         Iv7O0mjMUKa+06vGwYQTb+QTdBd6S2FYKHQVvGbDh08S2Ii2+3tO9SXCDbcIO4x4GEMj
         UuEvLaZxdDVBojDRBsAFAjZoXT7KKTHYDZ04qo6gR9PZdREIvbO8LI5sUlGPynlc7f1o
         K17j+Cwyu4W2Pwu0Cq1jd/76MU7xWZ249Tpi56Ff2tSAdI4qIZOEuLvZDP/GCcmiU3bU
         PuMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WHCTE/jKabwXI80tqWfQMEJnwOXap2U+zyhTat35ngQ=;
        b=YrhvBK2B3zzz3Md0PTEguzDBeD6G+SpTYLIRPZt+7rjl2ylazbXm46sx+FFts4G+3l
         34arMl8Xmvj6YJ4bnD3WqU/VxSIZ/zOLo2vO3RbqhiJGrMgQP4UT4ycxOke/HPCGMgaC
         /uhg4AT9N3QZlKUDFhLf0pxvHLNkm4ec2xQwoGMRTtH8yBgeQV7Ecd3E6WZjcPZIhKi8
         VcvUYuOEMX9qPzx/vqKVTa0ZaHRTdwUjR6Y3A7NZVYKrLf8h9qxlYiyehHE44kL0Zr2M
         3/SWubsIAahVaiR681qW6ARyFvoBIupxAzJAhq32SDmH2iD0CCp/pdZC3euVOFJt+s6x
         TrCA==
X-Gm-Message-State: AOAM531C63N0c8+NgDyR5Jn6EmJf6+3PRjZkACNl6CHPwXpfPJ9pQ9eH
        wGqiS7SZMeBWJmeYgBY1Q4QBmO5WyIzWdXZOIbo=
X-Google-Smtp-Source: ABdhPJxI2lG3B7mdWPbWL5kavMBRUBat8kcbXpk4PQAi/ex6yNwq8q9KfRvUyV3wP6/v6RRrpwxqWjAhQbFWj5Un/pI=
X-Received: by 2002:a17:90a:4687:: with SMTP id z7mr8440756pjf.168.1606468016651;
 Fri, 27 Nov 2020 01:06:56 -0800 (PST)
MIME-Version: 1.0
References: <20201127082601.4762-1-mariuszx.dudek@intel.com> <20201127082601.4762-2-mariuszx.dudek@intel.com>
In-Reply-To: <20201127082601.4762-2-mariuszx.dudek@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 27 Nov 2020 10:06:45 +0100
Message-ID: <CAJ8uoz1TkEQ0-YJmqHaOULKvTGKbvfuMNB9c71vE-39RM6YvJw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 1/2] libbpf: separate XDP program load with
 xsk socket creation
To:     Mariusz Dudek <mariusz.dudek@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Mariusz Dudek <mariuszx.dudek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 9:52 AM <mariusz.dudek@gmail.com> wrote:
>
> From: Mariusz Dudek <mariuszx.dudek@intel.com>
>
> Add support for separation of eBPF program load and xsk socket
> creation.
>
> This is needed for use-case when you want to privide as little
> privileges as possible to the data plane application that will
> handle xsk socket creation and incoming traffic.
>
> With this patch the data entity container can be run with only
> CAP_NET_RAW capability to fulfill its purpose of creating xsk
> socket and handling packages. In case your umem is larger or
> equal process limit for MEMLOCK you need either increase the
> limit or CAP_IPC_LOCK capability.
>
> To resolve privileges issue two APIs are introduced:
>
> - xsk_setup_xdp_prog - loads the built in XDP program. It can
> also return xsks_map_fd which is needed by unprivileged process
> to update xsks_map with AF_XDP socket "fd"
>
> - xsk_socket__update_xskmap - inserts an AF_XDP socket into an xskmap
> for a particular xsk_socket
>
> Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
> ---
>  tools/lib/bpf/libbpf.map |  2 +
>  tools/lib/bpf/xsk.c      | 92 ++++++++++++++++++++++++++++++++++++----
>  tools/lib/bpf/xsk.h      |  5 +++
>  3 files changed, 90 insertions(+), 9 deletions(-)

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 29ff4807b909..d939d5ac092e 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -345,4 +345,6 @@ LIBBPF_0.3.0 {
>                 btf__parse_split;
>                 btf__new_empty_split;
>                 btf__new_split;
> +               xsk_setup_xdp_prog;
> +               xsk_socket__update_xskmap;
>  } LIBBPF_0.2.0;
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 9bc537d0b92d..4b051ec7cfbb 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -566,8 +566,35 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
>                                    &xsk->fd, 0);
>  }
>
> -static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> +static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
>  {
> +       char ifname[IFNAMSIZ];
> +       struct xsk_ctx *ctx;
> +       char *interface;
> +
> +       ctx = calloc(1, sizeof(*ctx));
> +       if (!ctx)
> +               return -ENOMEM;
> +
> +       interface = if_indextoname(ifindex, &ifname[0]);
> +       if (!interface) {
> +               free(ctx);
> +               return -errno;
> +       }
> +
> +       ctx->ifindex = ifindex;
> +       strncpy(ctx->ifname, ifname, IFNAMSIZ - 1);
> +       ctx->ifname[IFNAMSIZ - 1] = 0;
> +
> +       xsk->ctx = ctx;
> +
> +       return 0;
> +}
> +
> +static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> +                               int *xsks_map_fd)
> +{
> +       struct xsk_socket *xsk = _xdp;
>         struct xsk_ctx *ctx = xsk->ctx;
>         __u32 prog_id = 0;
>         int err;
> @@ -584,8 +611,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>
>                 err = xsk_load_xdp_prog(xsk);
>                 if (err) {
> -                       xsk_delete_bpf_maps(xsk);
> -                       return err;
> +                       goto err_load_xdp_prog;
>                 }
>         } else {
>                 ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
> @@ -598,15 +624,29 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>                 }
>         }
>
> -       if (xsk->rx)
> +       if (xsk->rx) {
>                 err = xsk_set_bpf_maps(xsk);
> -       if (err) {
> -               xsk_delete_bpf_maps(xsk);
> -               close(ctx->prog_fd);
> -               return err;
> +               if (err) {
> +                       if (!prog_id) {
> +                               goto err_set_bpf_maps;
> +                       } else {
> +                               close(ctx->prog_fd);
> +                               return err;
> +                       }
> +               }
>         }
> +       if (xsks_map_fd)
> +               *xsks_map_fd = ctx->xsks_map_fd;
>
>         return 0;
> +
> +err_set_bpf_maps:
> +       close(ctx->prog_fd);
> +       bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
> +err_load_xdp_prog:
> +       xsk_delete_bpf_maps(xsk);
> +
> +       return err;
>  }
>
>  static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
> @@ -689,6 +729,40 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
>         return ctx;
>  }
>
> +static void xsk_destroy_xsk_struct(struct xsk_socket *xsk)
> +{
> +       free(xsk->ctx);
> +       free(xsk);
> +}
> +
> +int xsk_socket__update_xskmap(struct xsk_socket *xsk, int fd)
> +{
> +       xsk->ctx->xsks_map_fd = fd;
> +       return xsk_set_bpf_maps(xsk);
> +}
> +
> +int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)
> +{
> +       struct xsk_socket *xsk;
> +       int res;
> +
> +       xsk = calloc(1, sizeof(*xsk));
> +       if (!xsk)
> +               return -ENOMEM;
> +
> +       res = xsk_create_xsk_struct(ifindex, xsk);
> +       if (res) {
> +               free(xsk);
> +               return -EINVAL;
> +       }
> +
> +       res = __xsk_setup_xdp_prog(xsk, xsks_map_fd);
> +
> +       xsk_destroy_xsk_struct(xsk);
> +
> +       return res;
> +}
> +
>  int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>                               const char *ifname,
>                               __u32 queue_id, struct xsk_umem *umem,
> @@ -838,7 +912,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>         ctx->prog_fd = -1;
>
>         if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> -               err = xsk_setup_xdp_prog(xsk);
> +               err = __xsk_setup_xdp_prog(xsk, NULL);
>                 if (err)
>                         goto out_mmap_tx;
>         }
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 1719a327e5f9..10b4259f8875 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -207,6 +207,11 @@ struct xsk_umem_config {
>         __u32 flags;
>  };
>
> +LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
> +                                 int *xsks_map_fd);
> +LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
> +                                        int xsks_map_fd);
> +
>  /* Flags for the libbpf_flags field. */
>  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
>
> --
> 2.20.1
>
