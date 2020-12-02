Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB02B2CCA40
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 00:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbgLBXGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 18:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgLBXF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 18:05:57 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32993C0613D6;
        Wed,  2 Dec 2020 15:05:11 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id k65so252208ybk.5;
        Wed, 02 Dec 2020 15:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D8WeVWwFaUIsopw64bVe93zZ6hwN9FHUOxH8CpzJ3iI=;
        b=h8NvGLF6K6IFxxK6uRj5Lb+QMGmr6wSHKN+PyDrfnwaq11tZslpwkLRHtVAh7SEq9Y
         oAsWKktfdbg9nTjP+E4SVRcZ7gZRVMexkE8wKUdrh/ZlO4lExrat0PAKYSMLVnNWyyo6
         ya7/wS5shGvx3SC+QPeRwaNbXfANX3dThv7ckQ4yuPRU/7gkRpZ81KErvmsdgOCO2egm
         u6EMJe6wggntrTu/m11aGJ5Rqx/0PpvM6YnEpEC3cLKF55SlrzOEC6nhfbEZb+R+TZRJ
         2VxPH+xJBYiJf9n62ShsbX9rVPMr+1zMweYbl6vI9JEh4i0Cs2NbqnJ5NQQc21vtlvR7
         FlGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D8WeVWwFaUIsopw64bVe93zZ6hwN9FHUOxH8CpzJ3iI=;
        b=LbxbJQV9Lx/7OBPZAv+/GA6epKPERAx3KPEbLIE56mJk+B09pZyxzv0ewQ/DUWqGCP
         vMOYWaBQeJ3uayqgDSz3In4sLMAoNNELEKMeKRNPmUIJIKEhz4iWBykUvJWKvcCvyMlQ
         XroL5d2aRUz18GJsF/U6pJXodeV2JwHBKAUbhizeeKeQhk3yKN2Zn87UGxFMC9YW3L6k
         hoORlkB+THH6ltFuBF72tKq8JmBrtrwE6cGX3iOGpmjXKMhACZ67dn2MioU6rcpRueuz
         ZwFTTUpKsIB+pijbFTux2pP0pjQ4ymZwfmuzIcYNIuh5zqAQcVROgal3cFbW8TdojoeD
         ty6w==
X-Gm-Message-State: AOAM533fF+Pi4tpeVWQm+MM9imP8OziNgZCufOVgx8DVKUa5ESdoDmh9
        o8qh454RO98MmbvP4EGoRMklt/KVHGizzEG0WXs=
X-Google-Smtp-Source: ABdhPJzSIFdOSG3reDi01d3cWiamKL4XL/XKENxhZfMw7i08thqBfg03USvKsG0LvZkZiMZOGbyj+iKf4H847RskNfU=
X-Received: by 2002:a25:c089:: with SMTP id c131mr638894ybf.510.1606950310515;
 Wed, 02 Dec 2020 15:05:10 -0800 (PST)
MIME-Version: 1.0
References: <20201202103923.12447-1-mariuszx.dudek@intel.com>
In-Reply-To: <20201202103923.12447-1-mariuszx.dudek@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Dec 2020 15:04:59 -0800
Message-ID: <CAEf4BzYdVeTZaC=ahzh=8chBmMZaw3o7ZXibZ1Y+=L5fagQA5g@mail.gmail.com>
Subject: Re: [PATCH v6 bpf-next 0/2] libbpf: add support for
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

On Wed, Dec 2, 2020 at 2:39 AM <mariusz.dudek@gmail.com> wrote:
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
> This patch set is based on bpf-next commit ba0581749fec
> (net, xdp, xsk: fix __sk_mark_napi_id_once napi_id error)
>
> Since v5
> - fixed sample/bpf/xdpsock_user.c to resolve merge conflicts
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
> --
> 2.20.1
>

Applied to bpf-next. For the future, please carry over Acked-by you
got, thanks. I've added Magnus's ones back.
