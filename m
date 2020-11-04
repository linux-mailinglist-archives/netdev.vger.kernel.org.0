Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759572A6F5E
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731553AbgKDVHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729141AbgKDVHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 16:07:35 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06DEC0613D3;
        Wed,  4 Nov 2020 13:07:35 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id e16so6238924ile.0;
        Wed, 04 Nov 2020 13:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xRTJTm16MzYFc6tnTNpETymG3CnUlFu2YFwP/lSugCA=;
        b=D208ziDiiog9+MFdIphsHicrFFSO9yFaD3FtCzHShTVB1pHFcb/vV3JjjbejHOWzVS
         JbLdsVbiBpK+XlxlJDnob5Q7v66NA0Fn9iMiRsxNeMhbskPNkH63MP64CVkRW25vIud8
         9AfPjupPp4RDQzYJcgIsiTmZ0B91vCU8Gx1svLsrOAlmsDCCu8OaPwBX0utVLLpsmS60
         uTDCXGkrH99sG2U6O8y6faJl5+J8B6s0GVgVgd6NQc6jMvqLZz+OXIK6gVKAhotm5mOi
         ZjOLVS8fWZTAIp32rsbk2Hv9QO0KJP8iI7iJ/IM3/CLLo1f7bwv5WWI6WEXFIk303ZyE
         Zl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xRTJTm16MzYFc6tnTNpETymG3CnUlFu2YFwP/lSugCA=;
        b=TXdck47TVykbMzOZZy2YioXWpb0tr/0lAIlsBfMgqAoDxlDdBSI0IxzWaakkrPvmr4
         9mMM5TdLlFZX+dUJoHVs8xvmy8Kgq5aZCShqxU7F6HTeHwuJYVEQma6U/2jeLcOo0uzs
         OwsSP4ozKwQSuAtK+X0NKhCyfrwgU3c5CQyMens0s/DEkRr7SSsAHA479ltGDhuzri3v
         DB2GWqkxlkzsCtGA0e4bmqNBdKBvUgIOlkYDC+yTOODW4jfNtS6Rw3YmGc2jrgfzaRZW
         sXNM5d+V1GrR5OtrcJegIZN8g5yK7TvH6kXRtytfvkHck/HxJG74kQIwFgZSn+OBOUrA
         EGEA==
X-Gm-Message-State: AOAM531jx7npO7pJ9SEyRcQiTd4FhDizTcrjCKKhkaXBsORgMWKPGZ/E
        BkWFQsMuQJPN7C+KhlrOtNfDnES1ANWcesbYPek=
X-Google-Smtp-Source: ABdhPJw/ikUIhtOj9IL+5w64h9P9tx2Kxr15oTQ7fXew5nveFTwTnu+cN3dP55LXsDfmS6Bb83w7VlP1jgWkkeWh+KU=
X-Received: by 2002:a92:850f:: with SMTP id f15mr7917725ilh.286.1604524054961;
 Wed, 04 Nov 2020 13:07:34 -0800 (PST)
MIME-Version: 1.0
References: <20201104094626.3406-1-mariuszx.dudek@intel.com> <20201104094626.3406-2-mariuszx.dudek@intel.com>
In-Reply-To: <20201104094626.3406-2-mariuszx.dudek@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Nov 2020 13:07:24 -0800
Message-ID: <CAEf4BzZMJV+Ko07DjXD-VxpX9dWtDhd_eGENiTSTHA5uiVLWLw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: separate XDP program load with xsk
 socket creation
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

On Wed, Nov 4, 2020 at 1:47 AM <mariusz.dudek@gmail.com> wrote:
>
> From: Mariusz Dudek <mariuszx.dudek@intel.com>
>
>         Add support for separation of eBPF program load and xsk socket
>         creation.
>
>         This is needed for use-case when you want to privide as little
>         privileges as possible to the data plane application that will
>         handle xsk socket creation and incoming traffic.
>
>         With this patch the data entity container can be run with only
>         CAP_NET_RAW capability to fulfill its purpose of creating xsk
>         socket and handling packages. In case your umem is larger or
>         equal process limit for MEMLOCK you need either increase the
>         limit or CAP_IPC_LOCK capability.
>
>         To resolve privileges issue two APIs are introduced:
>
>         - xsk_setup_xdp_prog - prepares bpf program if given and
>         loads it on a selected network interface or loads the built in
>         XDP program, if no XDP program is supplied. It can also return
>         xsks_map_fd which is needed by unprivileged process to update
>         xsks_map with AF_XDP socket "fd"
>
>         - xsk_update_xskmap - inserts an AF_XDP socket into an xskmap
>         for a particular xsk_socket
>

Your commit message seems to be heavily shifted right...


> Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
> ---
>  tools/lib/bpf/libbpf.map |   2 +
>  tools/lib/bpf/xsk.c      | 157 ++++++++++++++++++++++++++++++++-------
>  tools/lib/bpf/xsk.h      |  13 ++++
>  3 files changed, 146 insertions(+), 26 deletions(-)
>

[...]

> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 1069c46364ff..c42b91935d3c 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -201,6 +201,19 @@ struct xsk_umem_config {
>         __u32 flags;
>  };
>
> +struct bpf_prog_cfg {
> +       struct bpf_insn *prog;
> +       const char *license;
> +       size_t insns_cnt;
> +       int xsks_map_fd;
> +};

This config will have problems with backward/forward compatibility.
Please check how xxx_opts are done and use them for extensible options
structs.


> +
> +LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
> +                                 struct bpf_prog_cfg *cfg,
> +                                 int *xsks_map_fd);
> +LIBBPF_API int xsk_update_xskmap(struct xsk_socket *xsk,
> +                                int xsks_map_fd);

this should be called xsk_socket__update_map? BTW, what's xskmap? Is
that a special BPF map type?

> +
>  /* Flags for the libbpf_flags field. */
>  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
>
> --
> 2.20.1
>
