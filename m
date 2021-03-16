Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABCE33CD5C
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 06:35:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhCPFeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 01:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbhCPFeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 01:34:23 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1296CC06174A;
        Mon, 15 Mar 2021 22:34:23 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id m9so35607614ybk.8;
        Mon, 15 Mar 2021 22:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+5KqOXs20fdRGZrjgGCJUBoOnNIvhpri3NCX0Za/u7Y=;
        b=WeDl4kXGXjlNypzYUJMffuZyKlUNqw33UXhdRqYlhU/Sc2vPwjtOnPYwgEDhvJrj4f
         DwYnav8WpzCIPL+pBoF2S/tTo8OGxf8urqi+o4GmItSbFsuJ/4iaHhatNMP+iJeGvgBr
         GWwR1eQ5m6Nz4rCVa5khwkM6WAAiFlwfNsi+GCtfmgOzTzT5AdZgwrmmnQqUtF0NDJqQ
         cWY49GOdHrSOgtUXknYzjREdGjIAtIynVDIlC1mxVsNQ012bG5JQ/LRa+5SFOPNDqYdY
         ROqm+Cv1rudXEq0hm93nElMRqd9vOIcXgKO6aI4PzcMYyZkTGsqcXL1qVIAfO7uDQB3m
         acrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+5KqOXs20fdRGZrjgGCJUBoOnNIvhpri3NCX0Za/u7Y=;
        b=U6+P6JKogq6Jt1msEW6hrBsdxLHJfEded9OIVsyUK3cIxoEjmyEkKoMYTw90AMvE0k
         bNJJdn5NNaptVF00adR7ccqC+IteiNQwlru/DDw9fYJ9e0xRN+8jYGGYvyPMTlcdnhQ7
         JQKGsXjzxWE9WET/5StB4N9CwmsjcMRrA7YEZJ5BbFuSkMCY49mC86EAZtd9VDtH7Rrf
         Z5Um9jY/kkzAnhL6oQVUPzIl0Y67IHoa8LpVnkFztj4qFjBXsT2JkRXhcf+aR/HYccVB
         VG+F9+IUhtWAq/SofxYHsfxHYV5ceZ2NQzuzrXSPfxp5rbFTSpvsAlgHq4Bo5Gk32hlR
         evSg==
X-Gm-Message-State: AOAM532s1LvS0vCT/W/zMRCFQ15g23dXGjSr9sAPYGoIx3QEfPJm3gol
        Ymeqc2ELFRESlJ9Bw7SdncJR5MpiBuWCD9iZea8=
X-Google-Smtp-Source: ABdhPJy9bbXXb09trRxdDpBChU55oki0//b06hspN8oc7K73E4xHRq0S/8tSeIFrGguB3QAoPk+ge3rlTn25/caNDGY=
X-Received: by 2002:a25:3d46:: with SMTP id k67mr4343365yba.510.1615872862401;
 Mon, 15 Mar 2021 22:34:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com> <20210311152910.56760-7-maciej.fijalkowski@intel.com>
In-Reply-To: <20210311152910.56760-7-maciej.fijalkowski@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 15 Mar 2021 22:34:11 -0700
Message-ID: <CAEf4Bza-pGTS+vmE5SvuMtEptGxS5wSbW2d0K34nvt9StG3C8A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 06/17] libbpf: xsk: use bpf_link
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        ciara.loftus@intel.com, john fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 11, 2021 at 7:42 AM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Currently, if there are multiple xdpsock instances running on a single
> interface and in case one of the instances is terminated, the rest of
> them are left in an inoperable state due to the fact of unloaded XDP
> prog from interface.
>
> Consider the scenario below:
>
> // load xdp prog and xskmap and add entry to xskmap at idx 10
> $ sudo ./xdpsock -i ens801f0 -t -q 10
>
> // add entry to xskmap at idx 11
> $ sudo ./xdpsock -i ens801f0 -t -q 11
>
> terminate one of the processes and another one is unable to work due to
> the fact that the XDP prog was unloaded from interface.
>
> To address that, step away from setting bpf prog in favour of bpf_link.
> This means that refcounting of BPF resources will be done automatically
> by bpf_link itself.
>
> When setting up BPF resources during xsk socket creation, check whether
> bpf_link for a given ifindex already exists via set of calls to
> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> and comparing the ifindexes from bpf_link and xsk socket.
>
> If there's no bpf_link yet, create one for a given XDP prog. If bpf_link
> is already at a given ifindex and underlying program is not AF-XDP one,
> bail out or update the bpf_link's prog given the presence of
> XDP_FLAGS_UPDATE_IF_NOEXIST.
>
> If there's netlink-based XDP prog running on a interface, bail out and
> ask user to do removal by himself.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 139 ++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 120 insertions(+), 19 deletions(-)
>

[...]

> +static int xsk_link_lookup(struct xsk_ctx *ctx, __u32 *prog_id)
> +{
> +       struct bpf_link_info link_info;
> +       __u32 link_len;
> +       __u32 id = 0;
> +       int err;
> +       int fd;
> +
> +       while (true) {
> +               err = bpf_link_get_next_id(id, &id);
> +               if (err) {
> +                       if (errno == ENOENT) {
> +                               err = 0;
> +                               break;
> +                       }
> +                       pr_warn("can't get next link: %s\n", strerror(errno));
> +                       break;
> +               }
> +
> +               fd = bpf_link_get_fd_by_id(id);
> +               if (fd < 0) {
> +                       if (errno == ENOENT)
> +                               continue;
> +                       pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
> +                       err = -errno;
> +                       break;
> +               }
> +
> +               link_len = sizeof(struct bpf_link_info);
> +               memset(&link_info, 0, link_len);
> +               err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
> +               if (err) {
> +                       pr_warn("can't get link info: %s\n", strerror(errno));
> +                       close(fd);
> +                       break;
> +               }
> +               if (link_info.xdp.ifindex == ctx->ifindex) {

how do you know you are looking at XDP bpf_link? link_info.xdp.ifindex
might as well be attach_type for tracing bpf_linke, netns_ino for
netns bpf_link, and so on. Do check link_info.type before check other
per-link type properties.

> +                       ctx->link_fd = fd;
> +                       *prog_id = link_info.prog_id;
> +                       break;
> +               }
> +               close(fd);
> +       }
> +
> +       return err;
> +}
> +
>  static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
>                                 int *xsks_map_fd)
>  {
> @@ -675,8 +777,7 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
>         __u32 prog_id = 0;
>         int err;
>
> -       err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id,
> -                                 xsk->config.xdp_flags);
> +       err = xsk_link_lookup(ctx, &prog_id);
>         if (err)
>                 return err;
>
> @@ -686,9 +787,12 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
>                         return err;
>
>                 err = xsk_load_xdp_prog(xsk);
> -               if (err) {
> +               if (err)
>                         goto err_load_xdp_prog;
> -               }
> +
> +               err = xsk_create_bpf_link(xsk);
> +               if (err)
> +                       goto err_create_bpf_link;

what about the backwards compatibility with kernels that don't yet
support bpf_link?

>         } else {
>                 ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
>                 if (ctx->prog_fd < 0)

[...]
