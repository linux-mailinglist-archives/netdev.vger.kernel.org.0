Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7F942CB22A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbgLBBPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:15:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbgLBBPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 20:15:50 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F02C0613CF;
        Tue,  1 Dec 2020 17:15:09 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id o71so127256ybc.2;
        Tue, 01 Dec 2020 17:15:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qb0BEBlvT6IR+TOIOrHO5m+kaHkPSk41EwYlXeDyqbE=;
        b=lT/0F9aLFctTpNP9EiAre5Zt3iocuSP8aWZNYbVlCapzu4YlQj61XaGHyLZj3XBR9B
         H7mpVaPdQwxoFsyvcmlVSk2xl5DupuzsqAaRtlubMKrMbgBIGB5stuSwWyXTaSBERYJq
         9x6Zhxes3aobNakBmAx0TL/DZvsS3CZPVX59n6gy9QEBmOoQBbZbS4Tx+zYTSGnuS2UB
         PUrheW21Q00bi3vXSPkK9mS0F6taTZSS517jIuehlD1JQH6r7cYSMXw1V/q9JbkgLxji
         /jMZLi+Te18B8gnEB4+A02TSHPWVwZ1vO3JWWSU3J335AmvdLTumGHanxcutYjUvLr1Y
         VAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qb0BEBlvT6IR+TOIOrHO5m+kaHkPSk41EwYlXeDyqbE=;
        b=EtRuREsUcD6b0MneheH/jivp/W7I+o32r6ghPWDAE5QC/UfBVTDqlnn5d3CyummZol
         0DZT2j+dVMheSx29xWKobb5kNXoe6Yc8nPjKpbVoh82XopEzbl9ep8J4BM5LxzLiAFSw
         EXsJEwz9AV9VE0MbVPlDfw3YOGdb3yRAHvYsEDR86YMzJkk53Pi0rNoMP7iE+gqobOK3
         qMTJpR0wpTdTlF6gBcMCbFnXIrNoUxdFlzMGU3cS2V3E9GOew55yh4sT8lPByvEbPHxi
         B6E5Ujy9Yg2OnphyE4mC5ZSxvU9t65VTSK1rHVEYjF206lD7LkQJeOn3bVuBHZHcNntf
         TaCA==
X-Gm-Message-State: AOAM533sIQaP0IBkB6meWULdcd1xCJCuYidVCi/MdZTknnAVFVk8W008
        vymVLtT1XuRxVPRuO/vJGeMbfZLP8UaDUHoIYilcwyi6gxg=
X-Google-Smtp-Source: ABdhPJzQm84wAzlq7LJVPMHThf+WzPq7+jEJqHhlFSnAb4wFuTZWHajEOkifwbNDd2YP9a34K+qVTZvaqw3GnM6IyXI=
X-Received: by 2002:a25:df8e:: with SMTP id w136mr196172ybg.230.1606871709183;
 Tue, 01 Dec 2020 17:15:09 -0800 (PST)
MIME-Version: 1.0
References: <20201127082601.4762-1-mariuszx.dudek@intel.com>
In-Reply-To: <20201127082601.4762-1-mariuszx.dudek@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 17:14:58 -0800
Message-ID: <CAEf4Bzby86qiQWiC5T4uK4dL2dGG0nEaQx4L2Rcjm2ZD-LTcjw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 0/2] libbpf: add support for
 privileged/unprivileged control separation
To:     mariusz.dudek@gmail.com
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

On Fri, Nov 27, 2020 at 12:26 AM <mariusz.dudek@gmail.com> wrote:
>
> From: Mariusz Dudek <mariuszx.dudek@intel.com>
>
> This patch series adds support for separation of eBPF program
> load and xsk socket creation. In for example a Kubernetes
> environment you can have an AF_XDP CNI or daemonset that is
> responsible for launching pods that execute an application
> using AF_XDP sockets. It is desirable that the pod runs with
> as low privileges as possible, CAP_NET_RAW in this case,
> and that all operations that require privileges are contained
> in the CNI or daemonset.
>
> In this case, you have to be able separate ePBF program load from
> xsk socket creation.
>
> Currently, this will not work with the xsk_socket__create APIs
> because you need to have CAP_NET_ADMIN privileges to load eBPF
> program and CAP_SYS_ADMIN privileges to create update xsk_bpf_maps.
> To be exact xsk_set_bpf_maps does not need those privileges but
> it takes the prog_fd and xsks_map_fd and those are known only to
> process that was loading eBPF program. The api bpf_prog_get_fd_by_id
> that looks up the fd of the prog using an prog_id and
> bpf_map_get_fd_by_id that looks for xsks_map_fd usinb map_id both
> requires CAP_SYS_ADMIN.
>
> With this patch, the pod can be run with CAP_NET_RAW capability
> only. In case your umem is larger or equal process limit for
> MEMLOCK you need either increase the limit or CAP_IPC_LOCK capability.
> Without this patch in case of insufficient rights ENOPERM is
> returned by xsk_socket__create.
>
> To resolve this privileges issue two new APIs are introduced:
> - xsk_setup_xdp_prog - loads the built in XDP program. It can
> also return xsks_map_fd which is needed by unprivileged
> process to update xsks_map with AF_XDP socket "fd"
> - xsk_sokcet__update_xskmap - inserts an AF_XDP socket into an
> xskmap for a particular xsk_socket
>
> Usage example:
> int xsk_setup_xdp_prog(int ifindex, int *xsks_map_fd)
>
> int xsk_socket__update_xskmap(struct xsk_socket *xsk, int xsks_map_fd);
>
> Inserts AF_XDP socket "fd" into the xskmap.
>
> The first patch introduces the new APIs. The second patch provides
> a new sample applications working as control and modification to
> existing xdpsock application to work with less privileges.
>
> This patch set is based on bpf-next commit 830382e4ccb5
> (Merge branch 'bpf: remove bpf_load loader completely')
>
> Since v4
> - sample/bpf/Makefile issues fixed
>
> Since v3:
> - force_set_map flag removed
> - leaking of xsk struct fixed
> - unified function error returning policy implemented
>
> Since v2:
> - new APIs moved itto LIBBPF_0.3.0 section
> - struct bpf_prog_cfg_opts removed
> - loading own eBPF program via xsk_setup_xdp_prog functionality removed
>
> Since v1:
> - struct bpf_prog_cfg improved for backward/forward compatibility
> - API xsk_update_xskmap renamed to xsk_socket__update_xskmap
> - commit message formatting fixed
>
> Mariusz Dudek (2):
>   libbpf: separate XDP program load with xsk socket creation
>   samples/bpf: sample application for eBPF load and socket creation
>     split
>
>  samples/bpf/Makefile            |   4 +-
>  samples/bpf/xdpsock.h           |   8 ++
>  samples/bpf/xdpsock_ctrl_proc.c | 187 ++++++++++++++++++++++++++++++++
>  samples/bpf/xdpsock_user.c      | 146 +++++++++++++++++++++++--
>  tools/lib/bpf/libbpf.map        |   2 +
>  tools/lib/bpf/xsk.c             |  92 ++++++++++++++--
>  tools/lib/bpf/xsk.h             |   5 +
>  7 files changed, 425 insertions(+), 19 deletions(-)
>  create mode 100644 samples/bpf/xdpsock_ctrl_proc.c
>

This doesn't apply cleanly to bpf-next, can you please rebase and resend?


> --
> 2.20.1
>
