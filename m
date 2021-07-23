Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8A93D3256
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 05:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbhGWDJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 23:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233459AbhGWDJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 23:09:07 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F58C061575;
        Thu, 22 Jul 2021 20:49:41 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id z18so303518ybg.8;
        Thu, 22 Jul 2021 20:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q6oeDXJS30Nc0KyAhg89slTGjzopcK93Rb8rREORG6Y=;
        b=HvQgREQDZ9lUbvnCtMpalHHKHUyq+gW6vH/2yViTJCShsRSOVfyrnO9jIQUCDLm/MT
         0IwLHXttwkgDYKMYnnNcQwYBTg6o1ZSr7Upmt+33GF4CF2XWHwWKueYvqku40JoRv9xm
         S6H49iJk3GC45PhaoH/Fmgi/G02GemSziwgLdcDm+SL53VheNpMbZs3umsoU6ueNqbOr
         c4EjBS1GunEONtO/LWeCxJR3+WbBCh+zeNxq92BTvdFn2ATkv2Np3uIf0RWAHIZerxaL
         aNJHpg8mhaytSXI/HvwNwLam+x/eRX4QGtji6eYnmxEJ3W3B5S1kbEAI7EuEmAqKsaov
         a2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q6oeDXJS30Nc0KyAhg89slTGjzopcK93Rb8rREORG6Y=;
        b=U4+dI66E8KuFek+RUlOArdrHjIHkTBAXY9Kd8pUzU+ZPKRSRt540xktTadiyQsf69F
         uBjPA630funHL4ZnSRiiKA9pMXirYMwGji7hOJhnfBqbQlw5AyjumPgbL9lPoCKEVsMa
         hDFkxDZohhK1kJV/TKCjrXvT0+aRjQOLKAief/BRV+ymtQiwo7+YlJzN8HjIhr32muGA
         onJmUxK4F4zqUN7BkBsKZYjo08OO9F4mdQwfsCrFfon3H1S/votoe2mL8OSJnGZAxdiG
         hEgRXl6KDecV58KXYvxxi58HMw7cgbBQTOcL4ho/ibAP4xUDJAnXwJdylZkOdX4629p3
         w0Cg==
X-Gm-Message-State: AOAM533SfyxsyIE0Y3OX+Y+7+L29SUBfdn5JuCnldVwfeXTQLc2EN3ZV
        1o1WRnHLtqIKLC8ROAmw/a3DjdzrcmU5w17n1Wo=
X-Google-Smtp-Source: ABdhPJyWVHKzirBZFD10X+glrf3RWkcK9q4oSXV5g3qtFxT/+dizuoaOCU1pXgDL76s30HnADn1pDJCTJ3q8xUNoZMA=
X-Received: by 2002:a25:1455:: with SMTP id 82mr3746952ybu.403.1627012180825;
 Thu, 22 Jul 2021 20:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210721212833.701342-1-memxor@gmail.com> <20210721212833.701342-6-memxor@gmail.com>
In-Reply-To: <20210721212833.701342-6-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 20:49:29 -0700
Message-ID: <CAEf4BzZjivA-ohnCXn1V7uXC-j_vNncT92+uba2A5z4YGRTTOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 5/8] samples: bpf: Convert xdp_redirect to use
 XDP samples helper
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 2:28 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> This change converts XDP redirect tool to use the XDP samples support
> introduced in previous changes.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  samples/bpf/Makefile            |  10 +-
>  samples/bpf/xdp_redirect.bpf.c  |  52 +++++++
>  samples/bpf/xdp_redirect_kern.c |  90 -----------
>  samples/bpf/xdp_redirect_user.c | 262 +++++++++++++-------------------
>  4 files changed, 160 insertions(+), 254 deletions(-)
>  create mode 100644 samples/bpf/xdp_redirect.bpf.c
>  delete mode 100644 samples/bpf/xdp_redirect_kern.c
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 1b4838b2beb0..b94b6dac09ff 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -39,7 +39,6 @@ tprogs-y += lwt_len_hist
>  tprogs-y += xdp_tx_iptunnel
>  tprogs-y += test_map_in_map
>  tprogs-y += per_socket_stats_example
> -tprogs-y += xdp_redirect
>  tprogs-y += xdp_redirect_map
>  tprogs-y += xdp_redirect_map_multi
>  tprogs-y += xdp_redirect_cpu
> @@ -56,6 +55,7 @@ tprogs-y += xdp_sample_pkts
>  tprogs-y += ibumad
>  tprogs-y += hbm
>
> +tprogs-y += xdp_redirect
>  tprogs-y += xdp_monitor
>
>  # Libbpf dependencies
> @@ -100,7 +100,6 @@ lwt_len_hist-objs := lwt_len_hist_user.o
>  xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
>  test_map_in_map-objs := test_map_in_map_user.o
>  per_socket_stats_example-objs := cookie_uid_helper_example.o
> -xdp_redirect-objs := xdp_redirect_user.o
>  xdp_redirect_map-objs := xdp_redirect_map_user.o
>  xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
>  xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
> @@ -118,6 +117,7 @@ ibumad-objs := ibumad_user.o
>  hbm-objs := hbm.o $(CGROUP_HELPERS)
>
>  xdp_sample_user-objs := xdp_sample_user.o $(LIBBPFDIR)/hashmap.o
> +xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
>  xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
>
>  # Tell kbuild to always build the programs
> @@ -164,7 +164,6 @@ always-y += tcp_clamp_kern.o
>  always-y += tcp_basertt_kern.o
>  always-y += tcp_tos_reflect_kern.o
>  always-y += tcp_dumpstats_kern.o
> -always-y += xdp_redirect_kern.o
>  always-y += xdp_redirect_map_kern.o
>  always-y += xdp_redirect_map_multi_kern.o
>  always-y += xdp_redirect_cpu_kern.o
> @@ -315,6 +314,7 @@ verify_target_bpf: verify_cmds
>  $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
>  $(src)/*.c: verify_target_bpf $(LIBBPF)
>
> +$(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
>  $(obj)/xdp_monitor_user.o: $(obj)/xdp_monitor.skel.h
>
>  $(obj)/tracex5_kern.o: $(obj)/syscall_nrs.h
> @@ -358,6 +358,7 @@ endef
>
>  CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
>
> +$(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
>  $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
>
>  $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/xdp_sample_shared.h
> @@ -368,9 +369,10 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
>                 -I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
>                 -c $(filter %.bpf.c,$^) -o $@
>
> -LINKED_SKELS := xdp_monitor.skel.h
> +LINKED_SKELS := xdp_redirect.skel.h xdp_monitor.skel.h
>  clean-files += $(LINKED_SKELS)
>
> +xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
>  xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
>
>  LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.bpf.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
> diff --git a/samples/bpf/xdp_redirect.bpf.c b/samples/bpf/xdp_redirect.bpf.c
> new file mode 100644
> index 000000000000..f5098812db36
> --- /dev/null
> +++ b/samples/bpf/xdp_redirect.bpf.c
> @@ -0,0 +1,52 @@
> +/* Copyright (c) 2016 John Fastabend <john.r.fastabend@intel.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of version 2 of the GNU General Public
> + * License as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
> + * General Public License for more details.
> + */
> +#define KBUILD_MODNAME "foo"
> +
> +#include "vmlinux.h"
> +#include "xdp_sample.bpf.h"
> +#include "xdp_sample_shared.h"
> +
> +const volatile int ifindex_out;
> +
> +SEC("xdp_redirect")

can you please use "canonical" SEC("xdp") everywhere and use function
names as unique BPF program identifiers. Section name is the program
type specification (plus extra type-specific argument where
applicable, like tracepoint name), not a unique identifier.

> +int xdp_redirect_prog(struct xdp_md *ctx)
> +{
> +       void *data_end = (void *)(long)ctx->data_end;
> +       void *data = (void *)(long)ctx->data;
> +       u32 key = bpf_get_smp_processor_id();
> +       struct ethhdr *eth = data;
> +       struct datarec *rec;
> +       u64 nh_off;
> +

[...]
