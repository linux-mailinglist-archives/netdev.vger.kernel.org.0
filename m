Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288202A8036
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730961AbgKEN6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 08:58:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727275AbgKEN6k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 08:58:40 -0500
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D534CC0613CF;
        Thu,  5 Nov 2020 05:58:39 -0800 (PST)
Received: by mail-oo1-xc41.google.com with SMTP id n16so444467ooj.2;
        Thu, 05 Nov 2020 05:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xg8iAob1rs15mwMHlhe0dunXTn8k6lqy3ajL1s6kKI8=;
        b=nuspwaHoxKoXZax0NolTi3e9gKAXkPs7jNuqoAGKfD0blKq/CnFKHqob7XW0/kgGqG
         xwrHcW5/LEPPaQgZrzt2azRmxs1mrb4oFWMLEc7rKIdxZNIu8HFqkhZ8LWhy3m9RJ1pc
         urPQBQVDZiQtK1L7FS2/0lxhqbOI+uvMVSciuUkcBysKGc7PI3rPZo+VgKR00Ai8dvph
         5WEiRw5PAK5aUyxomdU3Xbj5tCbkxS8EWkIWBy1pDebCxQYH+U8qxpw1ep6az4Cxg1xd
         UyRbWNbwlhBMwq5YFMZU2ETlPBYVY4nnNKk720s22a2tSvJk7AL9+vtsHqa1CmZM3ipD
         M7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xg8iAob1rs15mwMHlhe0dunXTn8k6lqy3ajL1s6kKI8=;
        b=Edt6BW4Lbjl5PWVt+2ycKE7H6ZSxWTBgvqSg9pjqhGZHXjOC3WT2+ZcM4webuY2BGH
         3qzSxnpF3uv8kBrkqUoYLvqzHuCZsyZ0MmbXTio0OSU6xB4uqrycs8OKU46fgwXz9WfE
         Z5AMSGOFt0/pzRMOAfQxsNpPBCF6oWbp/YAz2c6nM5h1hsDVoO6ItcGS4SV5AOOxNxb9
         hZeBxA6vX63m+ZF252V2v/wFMh+YEMy4ZIAewJIrffN3O2HC7mLaO1pd2qPeEDKjRCPQ
         yGYP+dOQiezr97bI54q2M/Ow/KIklkfJMk1S/qlaR+5XBe0xVQICr/FIGxCCBJrDZvmq
         /dMw==
X-Gm-Message-State: AOAM530Tk0i0d9WDsmNxw35u+2b6ojjRhwlFiKdGM6l1zZf/Ft9S0Mqx
        mk0G+B9X+jllL54N+wLJwyDd2xNrXfha82OCETA=
X-Google-Smtp-Source: ABdhPJzNbtYsk9ZNJlUKWoQiHEnxij1ZvvfSA6QRqtnpcGabJLt2bNM+qEf0n7skI6kc3jckztKfwNL1j3g6qqV2Skg=
X-Received: by 2002:a4a:be14:: with SMTP id l20mr1844911oop.27.1604584719243;
 Thu, 05 Nov 2020 05:58:39 -0800 (PST)
MIME-Version: 1.0
References: <20201104094626.3406-1-mariuszx.dudek@intel.com>
 <20201104094626.3406-2-mariuszx.dudek@intel.com> <CAEf4BzZMJV+Ko07DjXD-VxpX9dWtDhd_eGENiTSTHA5uiVLWLw@mail.gmail.com>
In-Reply-To: <CAEf4BzZMJV+Ko07DjXD-VxpX9dWtDhd_eGENiTSTHA5uiVLWLw@mail.gmail.com>
From:   Mariusz Dudek <mariusz.dudek@gmail.com>
Date:   Thu, 5 Nov 2020 14:58:27 +0100
Message-ID: <CADm5B_NEt14sqhi6V_cx48sOViweYi_GXO8GgrvpXJjYSueg3w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: separate XDP program load with xsk
 socket creation
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Mariusz Dudek <mariuszx.dudek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 10:07 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Nov 4, 2020 at 1:47 AM <mariusz.dudek@gmail.com> wrote:
> >
> > From: Mariusz Dudek <mariuszx.dudek@intel.com>
> >
> >         Add support for separation of eBPF program load and xsk socket
> >         creation.
> >
> >         This is needed for use-case when you want to privide as little
> >         privileges as possible to the data plane application that will
> >         handle xsk socket creation and incoming traffic.
> >
> >         With this patch the data entity container can be run with only
> >         CAP_NET_RAW capability to fulfill its purpose of creating xsk
> >         socket and handling packages. In case your umem is larger or
> >         equal process limit for MEMLOCK you need either increase the
> >         limit or CAP_IPC_LOCK capability.
> >
> >         To resolve privileges issue two APIs are introduced:
> >
> >         - xsk_setup_xdp_prog - prepares bpf program if given and
> >         loads it on a selected network interface or loads the built in
> >         XDP program, if no XDP program is supplied. It can also return
> >         xsks_map_fd which is needed by unprivileged process to update
> >         xsks_map with AF_XDP socket "fd"
> >
> >         - xsk_update_xskmap - inserts an AF_XDP socket into an xskmap
> >         for a particular xsk_socket
> >
>
> Your commit message seems to be heavily shifted right...
>
Will be fixed
>
> > Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
> > ---
> >  tools/lib/bpf/libbpf.map |   2 +
> >  tools/lib/bpf/xsk.c      | 157 ++++++++++++++++++++++++++++++++-------
> >  tools/lib/bpf/xsk.h      |  13 ++++
> >  3 files changed, 146 insertions(+), 26 deletions(-)
> >
>
> [...]
>
> > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > index 1069c46364ff..c42b91935d3c 100644
> > --- a/tools/lib/bpf/xsk.h
> > +++ b/tools/lib/bpf/xsk.h
> > @@ -201,6 +201,19 @@ struct xsk_umem_config {
> >         __u32 flags;
> >  };
> >
> > +struct bpf_prog_cfg {
> > +       struct bpf_insn *prog;
> > +       const char *license;
> > +       size_t insns_cnt;
> > +       int xsks_map_fd;
> > +};
>
> This config will have problems with backward/forward compatibility.
> Please check how xxx_opts are done and use them for extensible options
> structs.
>
I will add struct size as first parameter and #define for __last_field
to be inline with xxx_opts
>
> > +
> > +LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
> > +                                 struct bpf_prog_cfg *cfg,
> > +                                 int *xsks_map_fd);
> > +LIBBPF_API int xsk_update_xskmap(struct xsk_socket *xsk,
> > +                                int xsks_map_fd);
>
> this should be called xsk_socket__update_map? BTW, what's xskmap? Is
> that a special BPF map type?
>
I will change the API name as you suggested. XSKMAP is a special
BPF_MAP_TYPE_XSKMAP.
It defines how packets are being distributed from an XDP program to the XSKs.
> > +
> >  /* Flags for the libbpf_flags field. */
> >  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
> >
> > --
> > 2.20.1
> >
