Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1FF3DBE8A
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 20:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhG3Swb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 14:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhG3Swa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 14:52:30 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1F9C06175F;
        Fri, 30 Jul 2021 11:52:24 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id a201so1149088ybg.12;
        Fri, 30 Jul 2021 11:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EKUOYXr7ILztM14NrjPK3RVBnU9Hg9AaH2Hl3ieCPmg=;
        b=NkLhScx0nECmX7YC/gRSB7IxerDEIFvdpR0LyhlaYslt+HixGpnMQkIcIBRXj3WOt+
         RXyVekm9mgq0/VOsGeVt3ATaC9VapkwU+rl1x9HmVY/oQpcHzwUPQCiKiR4GuDlbh9Di
         cgp2c+8C1sB4zMKXPrLJGm8dAwBvSTD8XVkoP2zZWU/8Lhz6k09JW2WzsI6k8t9hfUEE
         VGw1EDH+PdIqEahLShIe3jPrGxag9xISkPcYb39ZYGtoP3NFuzPny9MYKUT4Ix1Oms74
         3/fRU9tCWSEUBeFYT+kudzTE4w0Wv8rGj1rC2r0Rah3AjMysDWpn6SLwsBzNU9xw+Edk
         qIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EKUOYXr7ILztM14NrjPK3RVBnU9Hg9AaH2Hl3ieCPmg=;
        b=g6R5eA3O87Mg3F6SZUXXVewySua5EBKfTzOphldm/63v5Vb8dyAUQg/OeQLfjpSHUq
         DAnM8qYgUd7LYneOJ00H5ITZM9L94I0kT/B7tewBXm8TT72LCbpQCJVLkcwwCw42UEnJ
         skPnke8MS9UQoSLdRDp8y91Ym13AQMMZQxZcyMqAs7la+tYH7AcDy/71f869U8fMbiXL
         zeXiD5nsYSxYVPjYLVB2Mn7dnOII+wKkEwihqnMA79d82a0iZXs22X2FNwXU0HRTUxWP
         ix5NfoKXqzfeS3AIDP6Jcm1KPyuBTE9rK2zO93BcSqScKf3vb+Zy3Ct8lMYA7YCqmhlX
         MQ6A==
X-Gm-Message-State: AOAM532+REObtuDBq3yUiAYJApVznJN11V3vzhkXdB/5H2X7+ArTcuxM
        pzcIsALImMioLGTKDRoEmcHYX0p/2svuJOyusQ0=
X-Google-Smtp-Source: ABdhPJxgH3Ruhw/jdl966Yh6t+vmLhd7rAn5ghEUIF9QBEA0Dwi82oG9/fVlhqcsXa9ri84sDQysC0hfxcZiTNegD2U=
X-Received: by 2002:a25:d691:: with SMTP id n139mr5041514ybg.27.1627671144148;
 Fri, 30 Jul 2021 11:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210729162932.30365-1-quentin@isovalent.com> <20210729162932.30365-4-quentin@isovalent.com>
In-Reply-To: <20210729162932.30365-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 30 Jul 2021 11:52:13 -0700
Message-ID: <CAEf4BzYp2QgaL9ORzs0sWk6KO63Q-9ixU-vOsFfLckE3-bPg6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/7] tools: bpftool: complete and synchronise
 attach or map types
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 9:29 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Update bpftool's list of attach type names to tell it about the latest
> attach types, or the "ringbuf" map. Also update the documentation, help
> messages, and bash completion when relevant.
>
> These missing items were reported by the newly added Python script used
> to help maintain consistency in bpftool.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  .../bpftool/Documentation/bpftool-prog.rst    |  2 +-
>  tools/bpf/bpftool/bash-completion/bpftool     |  5 +-
>  tools/bpf/bpftool/common.c                    | 76 ++++++++++---------
>  tools/bpf/bpftool/prog.c                      |  4 +-
>  4 files changed, 47 insertions(+), 40 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> index fe1b38e7e887..abf5f4cd7d3e 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
> @@ -48,7 +48,7 @@ PROG COMMANDS
>  |              **struct_ops** | **fentry** | **fexit** | **freplace** | **sk_lookup**
>  |      }
>  |       *ATTACH_TYPE* := {
> -|              **msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
> +|              **msg_verdict** | **skb_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
>  |      }
>  |      *METRICs* := {
>  |              **cycles** | **instructions** | **l1d_loads** | **llc_misses**
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index b2e33a2d8524..69d018474537 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -405,7 +405,8 @@ _bpftool()
>                              ;;
>                          5)
>                              local BPFTOOL_PROG_ATTACH_TYPES='msg_verdict \
> -                                stream_verdict stream_parser flow_dissector'
> +                                skb_verdict stream_verdict stream_parser \
> +                                flow_dissector'
>                              COMPREPLY=( $( compgen -W \
>                                  "$BPFTOOL_PROG_ATTACH_TYPES" -- "$cur" ) )
>                              return 0
> @@ -708,7 +709,7 @@ _bpftool()
>                                  hash_of_maps devmap devmap_hash sockmap cpumap \
>                                  xskmap sockhash cgroup_storage reuseport_sockarray \
>                                  percpu_cgroup_storage queue stack sk_storage \
> -                                struct_ops inode_storage task_storage'
> +                                struct_ops inode_storage task_storage ringbuf'
>                              COMPREPLY=( $( compgen -W \
>                                  "$BPFTOOL_MAP_CREATE_TYPES" -- "$cur" ) )
>                              return 0
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index 1828bba19020..b47797cac64f 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -31,42 +31,48 @@
>  #endif
>
>  const char * const attach_type_name[__MAX_BPF_ATTACH_TYPE] = {
> -       [BPF_CGROUP_INET_INGRESS]       = "ingress",
> -       [BPF_CGROUP_INET_EGRESS]        = "egress",
> -       [BPF_CGROUP_INET_SOCK_CREATE]   = "sock_create",
> -       [BPF_CGROUP_INET_SOCK_RELEASE]  = "sock_release",
> -       [BPF_CGROUP_SOCK_OPS]           = "sock_ops",
> -       [BPF_CGROUP_DEVICE]             = "device",
> -       [BPF_CGROUP_INET4_BIND]         = "bind4",
> -       [BPF_CGROUP_INET6_BIND]         = "bind6",
> -       [BPF_CGROUP_INET4_CONNECT]      = "connect4",
> -       [BPF_CGROUP_INET6_CONNECT]      = "connect6",
> -       [BPF_CGROUP_INET4_POST_BIND]    = "post_bind4",
> -       [BPF_CGROUP_INET6_POST_BIND]    = "post_bind6",
> -       [BPF_CGROUP_INET4_GETPEERNAME]  = "getpeername4",
> -       [BPF_CGROUP_INET6_GETPEERNAME]  = "getpeername6",
> -       [BPF_CGROUP_INET4_GETSOCKNAME]  = "getsockname4",
> -       [BPF_CGROUP_INET6_GETSOCKNAME]  = "getsockname6",
> -       [BPF_CGROUP_UDP4_SENDMSG]       = "sendmsg4",
> -       [BPF_CGROUP_UDP6_SENDMSG]       = "sendmsg6",
> -       [BPF_CGROUP_SYSCTL]             = "sysctl",
> -       [BPF_CGROUP_UDP4_RECVMSG]       = "recvmsg4",
> -       [BPF_CGROUP_UDP6_RECVMSG]       = "recvmsg6",
> -       [BPF_CGROUP_GETSOCKOPT]         = "getsockopt",
> -       [BPF_CGROUP_SETSOCKOPT]         = "setsockopt",
> +       [BPF_CGROUP_INET_INGRESS]               = "ingress",
> +       [BPF_CGROUP_INET_EGRESS]                = "egress",
> +       [BPF_CGROUP_INET_SOCK_CREATE]           = "sock_create",
> +       [BPF_CGROUP_INET_SOCK_RELEASE]          = "sock_release",
> +       [BPF_CGROUP_SOCK_OPS]                   = "sock_ops",
> +       [BPF_CGROUP_DEVICE]                     = "device",
> +       [BPF_CGROUP_INET4_BIND]                 = "bind4",
> +       [BPF_CGROUP_INET6_BIND]                 = "bind6",
> +       [BPF_CGROUP_INET4_CONNECT]              = "connect4",
> +       [BPF_CGROUP_INET6_CONNECT]              = "connect6",
> +       [BPF_CGROUP_INET4_POST_BIND]            = "post_bind4",
> +       [BPF_CGROUP_INET6_POST_BIND]            = "post_bind6",
> +       [BPF_CGROUP_INET4_GETPEERNAME]          = "getpeername4",
> +       [BPF_CGROUP_INET6_GETPEERNAME]          = "getpeername6",
> +       [BPF_CGROUP_INET4_GETSOCKNAME]          = "getsockname4",
> +       [BPF_CGROUP_INET6_GETSOCKNAME]          = "getsockname6",
> +       [BPF_CGROUP_UDP4_SENDMSG]               = "sendmsg4",
> +       [BPF_CGROUP_UDP6_SENDMSG]               = "sendmsg6",
> +       [BPF_CGROUP_SYSCTL]                     = "sysctl",
> +       [BPF_CGROUP_UDP4_RECVMSG]               = "recvmsg4",
> +       [BPF_CGROUP_UDP6_RECVMSG]               = "recvmsg6",
> +       [BPF_CGROUP_GETSOCKOPT]                 = "getsockopt",
> +       [BPF_CGROUP_SETSOCKOPT]                 = "setsockopt",
>
> -       [BPF_SK_SKB_STREAM_PARSER]      = "sk_skb_stream_parser",
> -       [BPF_SK_SKB_STREAM_VERDICT]     = "sk_skb_stream_verdict",
> -       [BPF_SK_SKB_VERDICT]            = "sk_skb_verdict",
> -       [BPF_SK_MSG_VERDICT]            = "sk_msg_verdict",
> -       [BPF_LIRC_MODE2]                = "lirc_mode2",
> -       [BPF_FLOW_DISSECTOR]            = "flow_dissector",
> -       [BPF_TRACE_RAW_TP]              = "raw_tp",
> -       [BPF_TRACE_FENTRY]              = "fentry",
> -       [BPF_TRACE_FEXIT]               = "fexit",
> -       [BPF_MODIFY_RETURN]             = "mod_ret",
> -       [BPF_LSM_MAC]                   = "lsm_mac",
> -       [BPF_SK_LOOKUP]                 = "sk_lookup",
> +       [BPF_SK_SKB_STREAM_PARSER]              = "sk_skb_stream_parser",
> +       [BPF_SK_SKB_STREAM_VERDICT]             = "sk_skb_stream_verdict",
> +       [BPF_SK_SKB_VERDICT]                    = "sk_skb_verdict",
> +       [BPF_SK_MSG_VERDICT]                    = "sk_msg_verdict",
> +       [BPF_LIRC_MODE2]                        = "lirc_mode2",
> +       [BPF_FLOW_DISSECTOR]                    = "flow_dissector",
> +       [BPF_TRACE_RAW_TP]                      = "raw_tp",
> +       [BPF_TRACE_FENTRY]                      = "fentry",
> +       [BPF_TRACE_FEXIT]                       = "fexit",
> +       [BPF_MODIFY_RETURN]                     = "mod_ret",
> +       [BPF_LSM_MAC]                           = "lsm_mac",
> +       [BPF_SK_LOOKUP]                         = "sk_lookup",
> +       [BPF_TRACE_ITER]                        = "trace_iter",
> +       [BPF_XDP_DEVMAP]                        = "xdp_devmap",
> +       [BPF_XDP_CPUMAP]                        = "xdp_cpumap",
> +       [BPF_XDP]                               = "xdp",
> +       [BPF_SK_REUSEPORT_SELECT]               = "sk_skb_reuseport_select",
> +       [BPF_SK_REUSEPORT_SELECT_OR_MIGRATE]    = "sk_skb_reuseport_select_or_migrate",
>  };
>

you are ruining Git blaming abilities for purely aesthetic reasons,
which are not good enough reasons, IMO. Please don't do this, this
nice alignment is nice, but definitely not necessary. So whatever is
longer then the "default indentation", just add another tab or two and
be done with it. That way we can actually see what was added in this
patch, btw.

>  void p_err(const char *fmt, ...)
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index cc48726740ad..1ee87225543b 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -2245,8 +2245,8 @@ static int do_help(int argc, char **argv)
>                 "                 cgroup/sendmsg6 | cgroup/recvmsg4 | cgroup/recvmsg6 |\n"
>                 "                 cgroup/getsockopt | cgroup/setsockopt | cgroup/sock_release |\n"
>                 "                 struct_ops | fentry | fexit | freplace | sk_lookup }\n"
> -               "       ATTACH_TYPE := { msg_verdict | stream_verdict | stream_parser |\n"
> -               "                        flow_dissector }\n"
> +               "       ATTACH_TYPE := { msg_verdict | skb_verdict | stream_verdict |\n"
> +               "                        stream_parser | flow_dissector }\n"
>                 "       METRIC := { cycles | instructions | l1d_loads | llc_misses | itlb_misses | dtlb_misses }\n"
>                 "       " HELP_SPEC_OPTIONS "\n"
>                 "",
> --
> 2.30.2
>
