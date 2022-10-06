Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8525F5DA6
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 02:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJFAWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 20:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJFAWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 20:22:42 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD5F7F108;
        Wed,  5 Oct 2022 17:22:40 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id u21so648474edi.9;
        Wed, 05 Oct 2022 17:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YrkLvKdrdMOrx+cpYZ6CCA8HBjDrdOZUKoe/NVUCeX8=;
        b=PQSC/5sXml0GmV4o0TCZ+lhd9SyG9zg2SOIiylfARmjl0WZZVWcwZVRX5xBcwjsYIR
         lzDnOPZd2N3D0ZtbQ54YQAzlv+eo7IcMFRf9o5NgTeCyurzUZkrtUXGFsuu+6Hw55HNI
         8KZVSmiuUuVB3hyoJRDBQxj0D9DKYAi29Qphs+UuX6gqojFFhGnf48okaKeAjn2+ixtK
         6++Ga0KglUFqTDKWsbZROwYM18W4rHpy9WwAMwsS4yauDGj4gV+gZXY7oyuw5ZIsxRvl
         mwtlm075a8lCcRaFvN1FZDEqqFeRHWlYbGiV9S/JySWMtpT3kboz7rGTKGNnFSbPXAsr
         SA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YrkLvKdrdMOrx+cpYZ6CCA8HBjDrdOZUKoe/NVUCeX8=;
        b=zs/XWlfJJFn0kiF7+ldwn9ZuuUnRR+KfrA8XZp16L1C6RnCJUZ8SIAjXboFgt0KpBX
         ggbwJwwk0qkZQG0nWhTlexF77fTgSBh2HtXshw4TSxTp2DrD1fAK55qrm7aN1/UikCG4
         KXtx7n1GXY28bi5OdjTb1VvOd3Ak8x1M2KWzPp01wAbLEFsADI0A4zIwGsllXonFg9ve
         nZpU+MBzG3RFBSnDhuyujif69bfdeUs9bq5yvkXJiz29vpZZ2FSt7H1eA0n1aOzCPYF/
         8xU23vCdQIEcHImR6lHmWwMl2pOibov9RZz/rxquxDqOqq2Q2KvSCAJpcvYrR0Ht/vv7
         jDTQ==
X-Gm-Message-State: ACrzQf3mUrqYibf9wda5+HOGd+qj4pyMVm9scZ1/hJpNQKXqDBRVHHHa
        tEKWSLl6DP4HlkB5bauz3ppWQfnZjmendBLeBuk=
X-Google-Smtp-Source: AMsMyM5MLJaB/37lbJo9y2m85z0H3Urw9XGP7TMXJoBuGaeFKG6ktkAPOYzHkLfx0huCG7yvGXrJG2pupXW/bPqkyCo=
X-Received: by 2002:a05:6402:518e:b0:452:49bc:179f with SMTP id
 q14-20020a056402518e00b0045249bc179fmr2159039edd.224.1665015759216; Wed, 05
 Oct 2022 17:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221004231143.19190-1-daniel@iogearbox.net> <20221004231143.19190-2-daniel@iogearbox.net>
In-Reply-To: <20221004231143.19190-2-daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Oct 2022 17:22:27 -0700
Message-ID: <CAEf4BzYo4um9WHCgJvNVwLPVS-vmEORPgKBBKN-Gmbe=fVgS+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 01/10] bpf: Add initial fd-based API to attach tc
 BPF programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, razor@blackwall.org, ast@kernel.org,
        andrii@kernel.org, martin.lau@linux.dev, john.fastabend@gmail.com,
        joannelkoong@gmail.com, memxor@gmail.com, toke@redhat.com,
        joe@cilium.io, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 4, 2022 at 4:12 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> This work refactors and adds a lightweight extension to the tc BPF ingress
> and egress data path side for allowing BPF programs via an fd-based attach /
> detach API. The main goal behind this work which we also presented at LPC [0]
> this year is to eventually add support for BPF links for tc BPF programs in
> a second step, thus this prep work is required for the latter which allows
> for a model of safe ownership and program detachment. Given the vast rise
> in tc BPF users in cloud native / Kubernetes environments, this becomes
> necessary to avoid hard to debug incidents either through stale leftover
> programs or 3rd party applications stepping on each others toes. Further
> details for BPF link rationale in next patch.
>
> For the current tc framework, there is no change in behavior with this change
> and neither does this change touch on tc core kernel APIs. The gist of this
> patch is that the ingress and egress hook gets a lightweight, qdisc-less
> extension for BPF to attach its tc BPF programs, in other words, a minimal
> tc-layer entry point for BPF. As part of the feedback from LPC, there was
> a suggestion to provide a name for this infrastructure to more easily differ
> between the classic cls_bpf attachment and the fd-based API. As for most,
> the XDP vs tc layer is already the default mental model for the pkt processing
> pipeline. We refactored this with an xtc internal prefix aka 'express traffic
> control' in order to avoid to deviate too far (and 'express' given its more
> lightweight/faster entry point).
>
> For the ingress and egress xtc points, the device holds a cache-friendly array
> with programs. Same as with classic tc, programs are attached with a prio that
> can be specified or auto-allocated through an idr, and the program return code
> determines whether to continue in the pipeline or to terminate processing.
> With TC_ACT_UNSPEC code, the processing continues (as the case today). The goal
> was to have maximum compatibility to existing tc BPF programs, so they don't
> need to be adapted. Compatibility to call into classic tcf_classify() is also
> provided in order to allow successive migration or both to cleanly co-exist
> where needed given its one logical layer. The fd-based API is behind a static
> key, so that when unused the code is also not entered. The struct xtc_entry's
> program array is currently static, but could be made dynamic if necessary at
> a point in future. Desire has also been expressed for future work to adapt
> similar framework for XDP to allow multi-attach from in-kernel side, too.
>
> Tested with tc-testing selftest suite which all passes, as well as the tc BPF
> tests from the BPF CI.
>
>   [0] https://lpc.events/event/16/contributions/1353/
>
> Co-developed-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  MAINTAINERS                    |   4 +-
>  include/linux/bpf.h            |   1 +
>  include/linux/netdevice.h      |  14 +-
>  include/linux/skbuff.h         |   4 +-
>  include/net/sch_generic.h      |   2 +-
>  include/net/xtc.h              | 181 ++++++++++++++++++++++
>  include/uapi/linux/bpf.h       |  35 ++++-
>  kernel/bpf/Kconfig             |   1 +
>  kernel/bpf/Makefile            |   1 +
>  kernel/bpf/net.c               | 274 +++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           |  24 ++-
>  net/Kconfig                    |   5 +
>  net/core/dev.c                 | 262 +++++++++++++++++++------------
>  net/core/filter.c              |   4 +-
>  net/sched/Kconfig              |   4 +-
>  net/sched/sch_ingress.c        |  48 +++++-
>  tools/include/uapi/linux/bpf.h |  35 ++++-
>  17 files changed, 769 insertions(+), 130 deletions(-)
>  create mode 100644 include/net/xtc.h
>  create mode 100644 kernel/bpf/net.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e55a4d47324c..bb63d8d000ea 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3850,13 +3850,15 @@ S:      Maintained
>  F:     kernel/trace/bpf_trace.c
>  F:     kernel/bpf/stackmap.c
>
> -BPF [NETWORKING] (tc BPF, sock_addr)
> +BPF [NETWORKING] (xtc & tc BPF, sock_addr)
>  M:     Martin KaFai Lau <martin.lau@linux.dev>
>  M:     Daniel Borkmann <daniel@iogearbox.net>
>  R:     John Fastabend <john.fastabend@gmail.com>
>  L:     bpf@vger.kernel.org
>  L:     netdev@vger.kernel.org
>  S:     Maintained
> +F:     include/net/xtc.h
> +F:     kernel/bpf/net.c
>  F:     net/core/filter.c
>  F:     net/sched/act_bpf.c
>  F:     net/sched/cls_bpf.c
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 9e7d46d16032..71e5f43db378 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1473,6 +1473,7 @@ struct bpf_prog_array_item {
>         union {
>                 struct bpf_cgroup_storage *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
>                 u64 bpf_cookie;
> +               u32 bpf_priority;

So this looks unfortunate and unnecessary. You are basically saying no
BPF cookie for this new TC/XTC/TCX thingy. But there is no need, we
already reserve 2 * 8 bytes for cgroup_storage, so make bpf_cookie and
bpf_prio co-exist with

union {
    struct bpf_cgroup_storage *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
    struct {
        u64 bpf_cookie;
        u32 bpf_priority;
    };
}

or is there some problem with that?

>         };
>  };
>

[...]

> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 51b9aa640ad2..de1f5546bcfe 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1025,6 +1025,8 @@ enum bpf_attach_type {
>         BPF_PERF_EVENT,
>         BPF_TRACE_KPROBE_MULTI,
>         BPF_LSM_CGROUP,
> +       BPF_NET_INGRESS,
> +       BPF_NET_EGRESS,

I can bikeshedding as well :) Shouldn't this be TC/TCX-specific attach
types? Wouldn't BPF_[X]TC[X]_INGRESS/BPF_[X]TC[X]_EGRESS be more
appropriate? Because when you think about it XDP is also NET, right,
so I find NET meaning really TC a bit confusing.

>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -1399,14 +1401,20 @@ union bpf_attr {
>         };
>
>         struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
> -               __u32           target_fd;      /* container object to attach to */
> +               union {
> +                       __u32   target_fd;      /* container object to attach to */
> +                       __u32   target_ifindex; /* target ifindex */
> +               };

this makes total sense (target can be FD or ifindex, we have that in
LINK_CREATE as well)

>                 __u32           attach_bpf_fd;  /* eBPF program to attach */
>                 __u32           attach_type;
>                 __u32           attach_flags;
> -               __u32           replace_bpf_fd; /* previously attached eBPF
> +               union {
> +                       __u32   attach_priority;
> +                       __u32   replace_bpf_fd; /* previously attached eBPF
>                                                  * program to replace if
>                                                  * BPF_F_REPLACE is used
>                                                  */
> +               };

But this union seems 1) unnecessary (we don't have to save those 4
bytes), but also 2) wouldn't it make sense to support replace_bpf_fd
with BPF_F_REPLACE (at given prio, if I understand correctly). It's
equivalent situation to what we had in cgroup programs land before we
got bpf_link. So staying consistent makes sense, unless I missed
something?

>         };
>
>         struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
> @@ -1452,7 +1460,10 @@ union bpf_attr {
>         } info;
>
>         struct { /* anonymous struct used by BPF_PROG_QUERY command */
> -               __u32           target_fd;      /* container object to query */
> +               union {
> +                       __u32   target_fd;      /* container object to query */
> +                       __u32   target_ifindex; /* target ifindex */
> +               };
>                 __u32           attach_type;
>                 __u32           query_flags;
>                 __u32           attach_flags;
> @@ -6038,6 +6049,19 @@ struct bpf_sock_tuple {
>         };
>  };
>
> +/* (Simplified) user return codes for tc prog type.
> + * A valid tc program must return one of these defined values. All other
> + * return codes are reserved for future use. Must remain compatible with
> + * their TC_ACT_* counter-parts. For compatibility in behavior, unknown
> + * return codes are mapped to TC_NEXT.
> + */
> +enum tc_action_base {
> +       TC_NEXT         = -1,
> +       TC_PASS         = 0,
> +       TC_DROP         = 2,
> +       TC_REDIRECT     = 7,
> +};
> +
>  struct bpf_xdp_sock {
>         __u32 queue_id;
>  };
> @@ -6804,6 +6828,11 @@ struct bpf_flow_keys {
>         __be32  flow_label;
>  };
>
> +struct bpf_query_info {

this is something that's returned from BPF_PROG_QUERY command, right?
Shouldn't it be called bpf_prog_query_info or something like that?
Just "query_info" is very generic, IMO, but if we are sure that there
will never be any other "QUERY" command, I guess it might be fine.

> +       __u32 prog_id;
> +       __u32 prio;
> +};
> +
>  struct bpf_func_info {
>         __u32   insn_off;
>         __u32   type_id;

[...]
