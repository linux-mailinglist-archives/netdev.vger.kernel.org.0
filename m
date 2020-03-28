Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19EA31962B5
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 01:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgC1Atl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 20:49:41 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33992 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgC1Atl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 20:49:41 -0400
Received: by mail-qk1-f193.google.com with SMTP id i6so12907984qke.1;
        Fri, 27 Mar 2020 17:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fUsVlLOzWvFzKLSezuaI6/778RM8NO5AshSNhOavGPs=;
        b=lVCE0P3Tiz3xjOLRcgqEm+ue/KGSBrLZYg6lFKRp3sNTdv8J/2PlTHgo89YGpU5RlH
         bfMbBuYhvUp8oF/5TCKTv9xTmkU3sVTms9yXH5oQlMsg4UgAXDxU7NqRPYUk9laHDYU3
         /yTtXBmcPberA0UTflf4nPZe29/jLQUiYDxydxlwdD2UAnODJAqrTJN45Kmh5cqZv2Te
         33bn2w4b7BxCjcTFqIBmXqHgEccGQOg+Rh+sFx0Lb9sU83Za5PDUMPa73jtkziW59XfI
         8/mucXD1+SIoKmhc5aGy/9iSVIR7+Q95WIjR6FSQ4/eo57GYICdh5PLmyEojwEdT2p+g
         lWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fUsVlLOzWvFzKLSezuaI6/778RM8NO5AshSNhOavGPs=;
        b=ER1DI4eRd5/CpN3KE/6cnn6Hl48qagpO5g6QvY7tpxE8iAdrNoHwMnP4U9nmXyWMVU
         FU1Z5sNpBFQvRKiHsrQalzNkdr5uLbpX26g40ZKVclQbUhYztm/L9n+i7dM6Pyb13VQK
         J3uP8nGSN8uq5ALTVafaLpoFdAuu6+w2VAPkFzJsvLZHWqks2My8pEswbfRiqQ0XOgSK
         XlKvbf2sPFAgvx+uDeszckVbr0hzT7+kWgY5S1lzOtzEYDeN+/x+GhJia0Oxxp/wcO8k
         LXyKgP1J+8OBb1q++QlMTMo3+z1uYv+NgfvjGM8rC4lMcFl54uSTHayKmjij1QHEY7Ao
         vMCg==
X-Gm-Message-State: ANhLgQ3CR6zc3QzWV73f6s4gC4BAJuh7bph6VjXxYAevfwI0a/Ya3UI5
        Erzf8HX34nvFx0hVSlqbZLfapFCPe8vvWQV6u5k=
X-Google-Smtp-Source: ADFU+vv1Cl5LyJX0Az9Qt7zRDZYc2GrLOGaE7lWcSAGq2GDRSu2k96I3v0/9SYU+0X2o0O+Us709D2CGDUYilpO2QJc=
X-Received: by 2002:a37:454c:: with SMTP id s73mr2043478qka.92.1585356580390;
 Fri, 27 Mar 2020 17:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1585323121.git.daniel@iogearbox.net> <18744744ed93c06343be8b41edcfd858706f39d7.1585323121.git.daniel@iogearbox.net>
In-Reply-To: <18744744ed93c06343be8b41edcfd858706f39d7.1585323121.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 27 Mar 2020 17:49:29 -0700
Message-ID: <CAEf4BzYjh++aorwBzgjdcWmRiw7GV4p=2avWqZu8S2Jdv3A3tQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/7] bpf: enable retrival of pid/tgid/comm from
 bpf cgroup hooks
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martynas Pumputis <m@lambda.lt>,
        Joe Stringer <joe@wand.net.nz>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 8:59 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> We already have the bpf_get_current_uid_gid() helper enabled, and
> given we now have perf event RB output available for connect(),
> sendmsg(), recvmsg() and bind-related hooks, add a trivial change
> to enable bpf_get_current_pid_tgid() and bpf_get_current_comm()
> as well.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

LGTM, there was probably never a good reason this wasn't available
from the very beginning :)

Might as well add bpf_get_current_uid_gid() if it's not there yet.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  net/core/filter.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 5cec3ac9e3dd..bb4a196c8809 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -6018,6 +6018,10 @@ sock_filter_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_get_netns_cookie_sock_proto;
>         case BPF_FUNC_perf_event_output:
>                 return &bpf_event_output_data_proto;
> +       case BPF_FUNC_get_current_pid_tgid:
> +               return &bpf_get_current_pid_tgid_proto;
> +       case BPF_FUNC_get_current_comm:
> +               return &bpf_get_current_comm_proto;

So you are not adding it to bpf_base_func_proto() instead, because
that one can be used in BPF programs that don't have a valid current,
is that right? If yes, would it make sense to have a common
bpf_base_process_ctx_func_proto() function for cases where there is a
valid current and add all the functions there (including uid_gid and
whatever else makes sense?)

>  #ifdef CONFIG_CGROUPS
>         case BPF_FUNC_get_current_cgroup_id:
>                 return &bpf_get_current_cgroup_id_proto;
> @@ -6058,6 +6062,10 @@ sock_addr_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_get_local_storage_proto;
>         case BPF_FUNC_perf_event_output:
>                 return &bpf_event_output_data_proto;
> +       case BPF_FUNC_get_current_pid_tgid:
> +               return &bpf_get_current_pid_tgid_proto;
> +       case BPF_FUNC_get_current_comm:
> +               return &bpf_get_current_comm_proto;
>  #ifdef CONFIG_CGROUPS
>         case BPF_FUNC_get_current_cgroup_id:
>                 return &bpf_get_current_cgroup_id_proto;
> --
> 2.21.0
>
