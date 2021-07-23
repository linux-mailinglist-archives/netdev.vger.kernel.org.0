Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED03D323F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 05:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233507AbhGWCyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 22:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233499AbhGWCyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 22:54:39 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FBDC061575;
        Thu, 22 Jul 2021 20:35:12 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id g76so321727ybf.4;
        Thu, 22 Jul 2021 20:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dSSbivAWwVkDbHCMNs/0W27BoRIzlO4EXyxi3ZNKhMM=;
        b=afiFIqqh/S/5bnnoITEv2Q9LChRu29LoFkMNy9OLrkNZjsU6HtkBSSF3qE0T15i3Ki
         Y4z4chCpVnz3VII57E6R8+CAwZ5QtMsh62/iEtWQYMppkwLkSahkW7utdAZ6i07U2QTj
         U9Iciwyoo/N8s03RYiI+kJ2DZMAZWBsf36J8Gme3Q/xXyk87mWB1GfBQAxk214ov4E4L
         FMq3HALbZhw1o4ERnFZBVjadPuB0klfrTBUSw3vdstA5WF+kwZrbgAVo1/qr1AJkSZRQ
         PH3FKm1SFXl3tmwPpCozWKckZtShzVUJVrreSb4mOciuYdj7kV1fl3Q3IEnXd0SEsnFK
         5ktA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dSSbivAWwVkDbHCMNs/0W27BoRIzlO4EXyxi3ZNKhMM=;
        b=oAEkrY6U7O3+CSgQFwcCLjKM/nRzUws0Ez/bB3SL9BP4IPcS2tHq6NR7josYZn/fa8
         RA5biVnBIgRVpZTzLHbKhozC3ldOHN4jihYA6VLMeMY7sLeh4PuQ1GDDIWqx+wcnuNCN
         7cZCUoSRPbwikmKuI0cvu7aqjg0m2cSvOuUgyQIXTirmSpPTOtqNku+SstmvfQvYHiDx
         EFMEoYtmtC/ki8F3LuFwm/n3JZIn+K2Yvq5PAb0cXPm0I+YWLYaaO8yDYdx+0lUgkXRF
         f590kLPX/FOQQ095zx6sBkoWigkcNOTPrJFbC4IiQv774HlisSKjKiCRus21Zlg0Uzas
         IS4A==
X-Gm-Message-State: AOAM5321KjtSVShSaSF8XCbjDsIBBw4N6dpEr1jW08APpHFdvTVdZZ7Y
        MdrDwvnuoFBIAoC6HoNO3OQXYZhUxwXJiQTl4Pg=
X-Google-Smtp-Source: ABdhPJydx2OHI4Yj+4fuub2k0MDMRyq4WW+qSd10Vkdzx8to/aGNN+aWC2kkowiVOiek48/0MXZed1rJdry0m09raiM=
X-Received: by 2002:a25:cdc7:: with SMTP id d190mr3574900ybf.425.1627011310764;
 Thu, 22 Jul 2021 20:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210721212833.701342-1-memxor@gmail.com> <20210721212833.701342-3-memxor@gmail.com>
In-Reply-To: <20210721212833.701342-3-memxor@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 20:34:59 -0700
Message-ID: <CAEf4BzaZa+0srsKKifF_Hanbojpu_GsbWc8rbzcfjb8ek49S7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/8] samples: bpf: Add common infrastructure
 for XDP samples
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
> This file implements some common helpers to consolidate differences in
> features and functionality between the various XDP samples and give them
> a consistent look, feel, and reporting capabilities.
>
> Some of the key features are:
>  * A concise output format accompanied by helpful text explaining its
>    fields.
>  * An elaborate output format building upon the concise one, and folding
>    out details in case of errors and staying out of view otherwise.
>  * Extended reporting of redirect errors by capturing hits for each
>    errno and displaying them inline (ENETDOWN, EINVAL, ENOSPC, etc.)
>    to aid debugging.
>  * Reporting of each xdp_exception action for all samples that use these
>    helpers (XDP_ABORTED, etc.) to aid debugging.
>  * Capturing per ifindex pair devmap_xmit counts for decomposing the
>    total TX count per devmap redirection.
>  * Ability to jump to source locations invoking tracepoints.
>  * Faster retrieval of stats per polling interval using mmap'd eBPF
>    array map (through .bss).
>  * Printing driver names for devices redirecting packets.
>  * Printing summarized total statistics for the entire session.
>  * Ability to dynamically switch between concise and verbose mode, using
>    SIGQUIT (Ctrl + \).
>
> The goal is sharing these helpers that most of the XDP samples implement
> in some form but differently for each, lacking in some respect compared
> to one another.
>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  samples/bpf/Makefile            |    6 +-
>  samples/bpf/xdp_sample_shared.h |   53 ++
>  samples/bpf/xdp_sample_user.c   | 1380 +++++++++++++++++++++++++++++++
>  samples/bpf/xdp_sample_user.h   |  202 +++++
>  4 files changed, 1640 insertions(+), 1 deletion(-)
>  create mode 100644 samples/bpf/xdp_sample_shared.h
>  create mode 100644 samples/bpf/xdp_sample_user.c
>  create mode 100644 samples/bpf/xdp_sample_user.h
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 036998d11ded..57ccff5ccac4 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -62,6 +62,7 @@ LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
>
>  CGROUP_HELPERS := ../../tools/testing/selftests/bpf/cgroup_helpers.o
>  TRACE_HELPERS := ../../tools/testing/selftests/bpf/trace_helpers.o
> +XDP_SAMPLE := xdp_sample_user.o
>
>  fds_example-objs := fds_example.o
>  sockex1-objs := sockex1_user.o
> @@ -116,6 +117,8 @@ xdp_sample_pkts-objs := xdp_sample_pkts_user.o
>  ibumad-objs := ibumad_user.o
>  hbm-objs := hbm.o $(CGROUP_HELPERS)
>
> +xdp_sample_user-objs := xdp_sample_user.o $(LIBBPFDIR)/hashmap.o
> +

nope, hashmap is an internal libbpf API, no using it from samples, please

>  # Tell kbuild to always build the programs
>  always-y := $(tprogs-y)
>  always-y += sockex1_kern.o
> @@ -201,6 +204,7 @@ TPROGS_CFLAGS += -Wstrict-prototypes
>  TPROGS_CFLAGS += -I$(objtree)/usr/include
>  TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
>  TPROGS_CFLAGS += -I$(srctree)/tools/lib/
> +TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf
>  TPROGS_CFLAGS += -I$(srctree)/tools/include
>  TPROGS_CFLAGS += -I$(srctree)/tools/perf
>  TPROGS_CFLAGS += -DHAVE_ATTR_TEST=0
> @@ -210,7 +214,7 @@ TPROGS_CFLAGS += --sysroot=$(SYSROOT)
>  TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
>  endif
>
> -TPROGS_LDLIBS                  += $(LIBBPF) -lelf -lz
> +TPROGS_LDLIBS                  += $(LIBBPF) -lelf -lz -lm
>  TPROGLDLIBS_tracex4            += -lrt
>  TPROGLDLIBS_trace_output       += -lrt
>  TPROGLDLIBS_map_perf_test      += -lrt
> diff --git a/samples/bpf/xdp_sample_shared.h b/samples/bpf/xdp_sample_shared.h
> new file mode 100644
> index 000000000000..b211dca233d9
> --- /dev/null
> +++ b/samples/bpf/xdp_sample_shared.h
> @@ -0,0 +1,53 @@
> +#ifndef _XDP_SAMPLE_SHARED_H
> +#define _XDP_SAMPLE_SHARED_H
> +
> +/*
> + * Best-effort relaxed load/store
> + * __atomic_load_n/__atomic_store_n built-in is not supported for BPF target
> + */
> +#define ATOMIC_LOAD(var) ({ (*(volatile typeof(var) *)&(var)); })
> +#define ATOMIC_STORE(var, val) ({ *((volatile typeof(var) *)&(var)) = (val); })
> +/* This does a load + store instead of the expensive atomic fetch add, but store
> + * is still atomic so that userspace reading the value reads the old or the new
> + * one, but not a partial store.
> + */
> +#define ATOMIC_ADD_NORMW(var, val)                                             \

it's rather some sort of NO_TEAR_ADD, but definitely not an atomic
add? Wouldn't this ATOMIC_ADD name be too misleading?

> +       ({                                                                     \
> +               typeof(val) __val = (val);                                     \
> +               if (__val)                                                     \
> +                       ATOMIC_STORE((var), (var) + __val);                    \
> +       })
> +
> +#define ATOMIC_INC_NORMW(var) ATOMIC_ADD_NORMW((var), 1)
> +
> +#define MAX_CPUS 64
> +
> +/* Values being read/stored must be word sized */
> +#if __LP64__
> +typedef __u64 datarec_t;
> +#else
> +typedef __u32 datarec_t;
> +#endif

why not use size_t instead of typedefs?

> +
> +struct datarec {
> +       datarec_t processed;
> +       datarec_t dropped;
> +       datarec_t issue;
> +       union {
> +               datarec_t xdp_pass;
> +               datarec_t info;
> +       };
> +       datarec_t xdp_drop;
> +       datarec_t xdp_redirect;
> +} __attribute__((aligned(64)));
> +

[...]

> +#define __attach_tp(name)                                                      \
> +       ({                                                                     \
> +               if (!bpf_program__is_tracing(skel->progs.name))                \
> +                       return -EINVAL;                                        \
> +               skel->links.name = bpf_program__attach(skel->progs.name);      \
> +               if (!skel->links.name)                                         \

you need to turn on libbpf 1.0 mode for errors to use NULL check, see
libbpf_set_strict_mode(); otherwise need to use libbpf_get_error() to
check

> +                       return -errno;                                         \
> +       })
> +

[...]
