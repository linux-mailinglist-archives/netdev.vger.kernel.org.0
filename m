Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4CD2C508C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 09:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388982AbgKZIcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 03:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKZIcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 03:32:00 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44897C0613D4;
        Thu, 26 Nov 2020 00:32:00 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id d9so1489537oib.3;
        Thu, 26 Nov 2020 00:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gikNeojVbHWjmZoNdWXhbnSJ6otffUxqHhKhTVzj1qE=;
        b=Cle4p/OS2/RhsLoY7kSakvNSxfv9Uk6QMO8c+7GoVSnS4V4JpocW+qtQ0+Z+R93Q30
         xoVX9z6d6ArAetsIpZg4LaXjlxoJ7tbiW+c04h4+19TM8Jlz+i1LuM8fAhKONiz16ulH
         F3HBCnklhHdruknCRR55bqLXr5SBgTcV+3GuSIe7jZTVjq0ZC1s00M+OFxjm3GLsQsm6
         8Q3IByoUr118wysHXpyLQ9hj5wsrprjeruvA1QCNY57JPf9gZ1iyeSY99zIHLg2nlLQf
         5krhQiHotu82/UowmryAywH66woJ64awSi/ZAEhM/37Fdprc/PXJcy5UM58jT4l93pfi
         BsDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gikNeojVbHWjmZoNdWXhbnSJ6otffUxqHhKhTVzj1qE=;
        b=DyixesCE2n7TC8qFM8LehSU3DnXHyxCHcd9obHIPPTtdd2S0hvSehS6M/1LgqdfDIs
         6IKuLwbwj4ruSd0cc0srg8Q21dhgnOeNzQet6aH/DSR1oIiHjbYPg42b4FRcJwhg0X+j
         QwvIHTPBR+fXizD0z3Li487VeFFXECEBHTNix3PNjY+mGwHqutesElCJ/uxGv4A1ThnJ
         LZ2WTlpjZTIbx+PBYrBEZdhDn81TA6oZarcgloQ2tsg+oIjQsE9Ss1Lv2DK5GDXv8PP6
         eOpQ7gfElS2RZpFBFHLFcXHK5ymjeoAFnMWKir6GSK45SUSyrHoLFQPozILokOJEnsbj
         3jug==
X-Gm-Message-State: AOAM532Ty2ARkDXgvHT+KkksFs4JSfbCEWIbYzWXg+bZBQ2V7DXuNZlM
        XwdBAh2YX7dvfnK9M19gvrg1sa5RDfhyusaf7jA=
X-Google-Smtp-Source: ABdhPJxZ8fV2GNfU7+ja3gIkgVaMEkpCfArhBCl1lBpPrLJ1r4iAehF1iFDC+M4MfOZ9Y1gbwByuzI2Rj0Hk9ZUGzRU=
X-Received: by 2002:aca:dfc2:: with SMTP id w185mr1420507oig.50.1606379519637;
 Thu, 26 Nov 2020 00:31:59 -0800 (PST)
MIME-Version: 1.0
References: <20201118083253.4150-1-mariuszx.dudek@intel.com>
 <20201118083253.4150-2-mariuszx.dudek@intel.com> <CAJ8uoz11E305_g7gy=aM2ijGND-UEJpge6_Ve5cw+CYBjNaHRw@mail.gmail.com>
In-Reply-To: <CAJ8uoz11E305_g7gy=aM2ijGND-UEJpge6_Ve5cw+CYBjNaHRw@mail.gmail.com>
From:   Mariusz Dudek <mariusz.dudek@gmail.com>
Date:   Thu, 26 Nov 2020 09:31:48 +0100
Message-ID: <CADm5B_MzbKKmXf7wRKKHf6FWL_Ye4yYhjwY7txdoTmdDS_f1QQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/2] libbpf: separate XDP program load with
 xsk socket creation
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
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

On Wed, Nov 25, 2020 at 3:30 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Nov 18, 2020 at 9:34 AM <mariusz.dudek@gmail.com> wrote:
> >
> > From: Mariusz Dudek <mariuszx.dudek@intel.com>
> >
> > Add support for separation of eBPF program load and xsk socket
> > creation.
> >
> > This is needed for use-case when you want to privide as little
> > privileges as possible to the data plane application that will
> > handle xsk socket creation and incoming traffic.
> >
> > With this patch the data entity container can be run with only
> > CAP_NET_RAW capability to fulfill its purpose of creating xsk
> > socket and handling packages. In case your umem is larger or
> > equal process limit for MEMLOCK you need either increase the
> > limit or CAP_IPC_LOCK capability.
> >
> > To resolve privileges issue two APIs are introduced:
> >
> > - xsk_setup_xdp_prog - loads the built in XDP program. It can
> > also return xsks_map_fd which is needed by unprivileged process
> > to update xsks_map with AF_XDP socket "fd"
> >
> > - xsk_socket__update_xskmap - inserts an AF_XDP socket into an xskmap
> > for a particular xsk_socket
> >
> > Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
> > ---
> >  tools/lib/bpf/libbpf.map |  2 +
> >  tools/lib/bpf/xsk.c      | 97 ++++++++++++++++++++++++++++++++++++----
> >  tools/lib/bpf/xsk.h      |  5 +++
> >  3 files changed, 95 insertions(+), 9 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > index 29ff4807b909..d939d5ac092e 100644
> > --- a/tools/lib/bpf/libbpf.map
> > +++ b/tools/lib/bpf/libbpf.map
> > @@ -345,4 +345,6 @@ LIBBPF_0.3.0 {
> >                 btf__parse_split;
> >                 btf__new_empty_split;
> >                 btf__new_split;
> > +               xsk_setup_xdp_prog;
> > +               xsk_socket__update_xskmap;
> >  } LIBBPF_0.2.0;
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 9bc537d0b92d..e16f920d2ef9 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -566,8 +566,42 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
> >                                    &xsk->fd, 0);
> >  }
> >
> > -static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> > +static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
> >  {
> > +       char ifname[IFNAMSIZ];
> > +       struct xsk_ctx *ctx;
> > +       char *interface;
> > +       int res = -1;
>
> No need to set it to -1 anymore, due to the below.
Will fix this
>
> > +
> > +       ctx = calloc(1, sizeof(*ctx));
> > +       if (!ctx)
> > +               goto error_ctx;
>
> return an -ENOMEM here directly.
-ENOMEM will be returned
>
> > +
> > +       interface = if_indextoname(ifindex, &ifname[0]);
> > +       if (!interface) {
> > +               res = -errno;
> > +               goto error_ifindex;
> > +       }
> > +
> > +       ctx->ifindex = ifindex;
> > +       strncpy(ctx->ifname, ifname, IFNAMSIZ - 1);
> > +       ctx->ifname[IFNAMSIZ - 1] = 0;
> > +
> > +       xsk->ctx = ctx;
> > +
> > +       return 0;
> > +
> > +error_ifindex:
> > +       free(ctx);
> > +error_ctx:
>
> And you can get rid of this label.
I will get rid of both labels as I can return either -ENOMEM or -errno
from both places directly
>
> > +       return res;
> > +}
> > +
> > +static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> > +                               bool force_set_map,
>
> force_set_map always seems to be false now. Correct? If it is, then it
> is not needed anymore. What was the original use case of this boolean?
>
force_set_map was used before for setting xsk bpf maps, but after code
change it is no longer needed. I will remove it.
> > +                               int *xsks_map_fd)
> > +{
> > +       struct xsk_socket *xsk = _xdp;
> >         struct xsk_ctx *ctx = xsk->ctx;
> >         __u32 prog_id = 0;
> >         int err;
> > @@ -584,8 +618,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> >
> >                 err = xsk_load_xdp_prog(xsk);
> >                 if (err) {
> > -                       xsk_delete_bpf_maps(xsk);
> > -                       return err;
> > +                       goto err_load_xdp_prog;
> >                 }
> >         } else {
> >                 ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
> > @@ -598,15 +631,29 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> >                 }
> >         }
> >
> > -       if (xsk->rx)
> > +       if (xsk->rx || force_set_map) {
> >                 err = xsk_set_bpf_maps(xsk);
> > -       if (err) {
> > -               xsk_delete_bpf_maps(xsk);
> > -               close(ctx->prog_fd);
> > -               return err;
> > +               if (err) {
> > +                       if (!prog_id) {
> > +                               goto err_set_bpf_maps;
> > +                       } else {
> > +                               close(ctx->prog_fd);
> > +                               return err;
> > +                       }
> > +               }
> >         }
> > +       if (xsks_map_fd)
> > +               *xsks_map_fd = ctx->xsks_map_fd;
> >
> >         return 0;
> > +
> > +err_set_bpf_maps:
> > +       close(ctx->prog_fd);
> > +       bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
> > +err_load_xdp_prog:
> > +       xsk_delete_bpf_maps(xsk);
> > +
> > +       return err;
> >  }
> >
> >  static struct xsk_ctx *xsk_get_ctx(struct xsk_umem *umem, int ifindex,
> > @@ -689,6 +736,38 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
> >         return ctx;
> >  }
> >
> > +static void xsk_destroy_xsk_struct(struct xsk_socket *xsk)
> > +{
> > +       free(xsk->ctx);
> > +       free(xsk);
> > +}
> > +
> > +int xsk_socket__update_xskmap(struct xsk_socket *xsk, int fd)
> > +{
> > +       xsk->ctx->xsks_map_fd = fd;
> > +       return xsk_set_bpf_maps(xsk);
> > +}
> > +
> > +int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)
> > +{
> > +       struct xsk_socket *xsk;
> > +       int res = -1;
> > +
> > +       xsk = calloc(1, sizeof(*xsk));
> > +       if (!xsk)
> > +               return res;
> > +
> > +       res = xsk_create_xsk_struct(ifindex, xsk);
> > +       if (res)
> > +               return -EINVAL;
>
> Here you can now return the error from the function, i.e. return res,
> as we returned -ENOMEM in that function. You are however leaking the
> xsk struct you just allocated in case of error. Needs to be
> deallocated.
>
xsk struct deallocated. -ENOMEM returned in case calloc fails.
> > +
> > +       res = __xsk_setup_xdp_prog(xsk, false, xsks_map_fd);
> > +
> > +       xsk_destroy_xsk_struct(xsk);
> > +
> > +       return res;
> > +}
> > +
> >  int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
> >                               const char *ifname,
> >                               __u32 queue_id, struct xsk_umem *umem,
> > @@ -838,7 +917,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
> >         ctx->prog_fd = -1;
> >
> >         if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)) {
> > -               err = xsk_setup_xdp_prog(xsk);
> > +               err = __xsk_setup_xdp_prog(xsk, false, NULL);
> >                 if (err)
> >                         goto out_mmap_tx;
> >         }
> > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > index 1069c46364ff..5b74c17ed3d4 100644
> > --- a/tools/lib/bpf/xsk.h
> > +++ b/tools/lib/bpf/xsk.h
> > @@ -201,6 +201,11 @@ struct xsk_umem_config {
> >         __u32 flags;
> >  };
> >
> > +LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
> > +                                 int *xsks_map_fd);
> > +LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
> > +                                int xsks_map_fd);
> > +
> >  /* Flags for the libbpf_flags field. */
> >  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
> >
> > --
> > 2.20.1
> >
