Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 620CC2C422B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 15:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgKYOaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 09:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgKYOaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 09:30:24 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63E58C0613D4;
        Wed, 25 Nov 2020 06:30:24 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id t18so1209427plo.0;
        Wed, 25 Nov 2020 06:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bVZx9JtB7ArKtBF19YyrB0CCuUdYX9wMR+PdB5bCW1o=;
        b=QeTa3i2ol1dv1S3GCCqsbhEaGz9fEDK5R2jnn/dF5dfYB5k5Wd8s+lRL4XfXajY/8a
         6E0RHD0WZSwZh/8shRWMf8qcIPYlFNGdiP+TM4jgSw+WWf+SVZgSTmRkE7MBFnmOIHvS
         +iU5OGNiCbAhcsjv6Bw57yi1XOpcwaBbqX4nzqXiuX0W+4QCTJO8OcD1lzTEud8DRId4
         Jd9zfCAN6OC3BmPY0YM7rKJImg03C2WTea0Z+sbAM8dz2BgZZhILhBq3vrroYdiR4rMn
         BEvl3K1YIpjYRFEhuHBycq/PLc2gJsm8Rm3Z7NRIWmZ7MdYTFDGiwL1IVMPL0TkVmxCq
         JROg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bVZx9JtB7ArKtBF19YyrB0CCuUdYX9wMR+PdB5bCW1o=;
        b=DaROyb/Kw0ed/WRcE1LPccv4az3InX6rkGDGV9LQEt15WSl9ZDe9s6fMQx3XBBXndl
         5LoBMziwBn7nK+lsUJFzi4baQtCve70ddVwGxTML89ZjQgsa2g0K+QDlA1NXF3HPohEk
         wucOCZMDF38Ac63qVp+F8whH0tyxlxbeyG5rgX0jyy+NbkF5a7WnOBJwUlPQ7W94OV67
         U4g4B13n96Syxd1l4ftA0mkqQPxFlCosOdcdBFJ2HZJyn0O3EdQ2mz23UC1W5SIvRKxb
         lIi3jr3rRTfmYwaNLdKxpC1u4bWYr/nJ/Z38LT5nd0FoIx006M6XLQ1ipBQ/Di0leouq
         4wSg==
X-Gm-Message-State: AOAM530yn1wBu1Q6nQup17TMnnciY+o+DlkIgsBVx49wAFoowJqegAjy
        XaFrXF2s+dQi4/3DomFSv2+tsRPkWSR3pUayLg0=
X-Google-Smtp-Source: ABdhPJzEEiOKScPHGJaCx+/gc035SDTTtxKNwFUB9MWoQRSamu8aklSnhR/PYJSRVj0rKRNXZ2Txd7cYzJtmb/IXNIs=
X-Received: by 2002:a17:902:c392:b029:da:121e:295d with SMTP id
 g18-20020a170902c392b02900da121e295dmr3214857plg.49.1606314623739; Wed, 25
 Nov 2020 06:30:23 -0800 (PST)
MIME-Version: 1.0
References: <20201118083253.4150-1-mariuszx.dudek@intel.com> <20201118083253.4150-2-mariuszx.dudek@intel.com>
In-Reply-To: <20201118083253.4150-2-mariuszx.dudek@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 25 Nov 2020 15:30:12 +0100
Message-ID: <CAJ8uoz11E305_g7gy=aM2ijGND-UEJpge6_Ve5cw+CYBjNaHRw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/2] libbpf: separate XDP program load with
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

On Wed, Nov 18, 2020 at 9:34 AM <mariusz.dudek@gmail.com> wrote:
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
>  tools/lib/bpf/xsk.c      | 97 ++++++++++++++++++++++++++++++++++++----
>  tools/lib/bpf/xsk.h      |  5 +++
>  3 files changed, 95 insertions(+), 9 deletions(-)
>
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
> index 9bc537d0b92d..e16f920d2ef9 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -566,8 +566,42 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
>                                    &xsk->fd, 0);
>  }
>
> -static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> +static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
>  {
> +       char ifname[IFNAMSIZ];
> +       struct xsk_ctx *ctx;
> +       char *interface;
> +       int res = -1;

No need to set it to -1 anymore, due to the below.

> +
> +       ctx = calloc(1, sizeof(*ctx));
> +       if (!ctx)
> +               goto error_ctx;

return an -ENOMEM here directly.

> +
> +       interface = if_indextoname(ifindex, &ifname[0]);
> +       if (!interface) {
> +               res = -errno;
> +               goto error_ifindex;
> +       }
> +
> +       ctx->ifindex = ifindex;
> +       strncpy(ctx->ifname, ifname, IFNAMSIZ - 1);
> +       ctx->ifname[IFNAMSIZ - 1] = 0;
> +
> +       xsk->ctx = ctx;
> +
> +       return 0;
> +
> +error_ifindex:
> +       free(ctx);
> +error_ctx:

And you can get rid of this label.

> +       return res;
> +}
> +
> +static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> +                               bool force_set_map,

force_set_map always seems to be false now. Correct? If it is, then it
is not needed anymore. What was the original use case of this boolean?

> +                               int *xsks_map_fd)
> +{
> +       struct xsk_socket *xsk = _xdp;
>         struct xsk_ctx *ctx = xsk->ctx;
>         __u32 prog_id = 0;
>         int err;
> @@ -584,8 +618,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>
>                 err = xsk_load_xdp_prog(xsk);
>                 if (err) {
> -                       xsk_delete_bpf_maps(xsk);
> -                       return err;
> +                       goto err_load_xdp_prog;
>                 }
>         } else {
>                 ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
> @@ -598,15 +631,29 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
>                 }
>         }
>
> -       if (xsk->rx)
> +       if (xsk->rx || force_set_map) {
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
> @@ -689,6 +736,38 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
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
> +       int res = -1;
> +
> +       xsk = calloc(1, sizeof(*xsk));
> +       if (!xsk)
> +               return res;
> +
> +       res = xsk_create_xsk_struct(ifindex, xsk);
> +       if (res)
> +               return -EINVAL;

Here you can now return the error from the function, i.e. return res,
as we returned -ENOMEM in that function. You are however leaking the
xsk struct you just allocated in case of error. Needs to be
deallocated.

> +
> +       res = __xsk_setup_xdp_prog(xsk, false, xsks_map_fd);
> +
> +       xsk_destroy_xsk_struct(xsk);
> +
> +       return res;
> +}
> +
>  int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>                               const char *ifname,
>                               __u32 queue_id, struct xsk_umem *umem,
> @@ -838,7 +917,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>         ctx->prog_fd = -1;
>
>         if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> -               err = xsk_setup_xdp_prog(xsk);
> +               err = __xsk_setup_xdp_prog(xsk, false, NULL);
>                 if (err)
>                         goto out_mmap_tx;
>         }
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 1069c46364ff..5b74c17ed3d4 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -201,6 +201,11 @@ struct xsk_umem_config {
>         __u32 flags;
>  };
>
> +LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
> +                                 int *xsks_map_fd);
> +LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
> +                                int xsks_map_fd);
> +
>  /* Flags for the libbpf_flags field. */
>  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
>
> --
> 2.20.1
>
