Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0B26F0039
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 06:51:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242586AbjD0EvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 00:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjD0EvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 00:51:16 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE523A9A;
        Wed, 26 Apr 2023 21:51:15 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5066ce4f725so11644555a12.1;
        Wed, 26 Apr 2023 21:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682571073; x=1685163073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dv/T/W7pRAkc9VUSDCf9kjnSeM6SfBwY++UqlxaB4tE=;
        b=TU6qBvsraGr/PDh1DyTkTLg+/Xigjm+y5cJeHoVYUX3EUXez5s0I9jXvel/gT5YU4w
         eSXd/YJP53KfR7bFYNe9qFGr33zQddJAJpROkDrifvgTOBfnpL2RiDgFptcp8nm1S4i1
         2Ka/4/CSgkrXbL7yasmi9MiHcV7SXr59aaPq9cL/4OObYn8dI7WqyFyTslNYsM/669Nn
         1yHRpeNffQjFJ2sjBS/JLd3f1FchaOycy0SSivn5KUjcaadYgk5pXmBP7v/sOd0vpvXS
         XxOgyauBomaJdnYOZL6bQyB1yTNzwIMK9ABFSnkruCLZUZBpNfB5KB6btGyWy3O6QuTi
         JMpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682571073; x=1685163073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dv/T/W7pRAkc9VUSDCf9kjnSeM6SfBwY++UqlxaB4tE=;
        b=Fp6AMLgTxl+K84MDT28rMj03Qbl6GwcM1pruTwWevHyL/AUaG6mfQ+nEHXztCEpKss
         i6J8GBE70c/a6Chpxn76xXur5EXBKSzNPFNk9tGc6H7eEfoCJhMgT/UdfZIbyvI9vr5d
         JzdmpgnUSztAx8YJc5vPiv/zh/IuQ0TAXMGChXPTIviqhmfvxQt2xF5okvDmALvD1m/I
         1s7ASLRQBpgMw7/InyxY0Lz4+jTuKrDaf6z1X+G3KW4Et5J9jea90vc1+S4rbgzYi91M
         WVgsnCZ7iENQ4OcavHuR/pQbKg1lmMAwDOP3qLvvKnG8dt1zUiXCpEAD0FfSiuUAiVKY
         5QRQ==
X-Gm-Message-State: AC+VfDzFOjBJWmFPSM4SwgEPNO6mWtSfPsefQFWFXQ6w/RPiqm81DvHR
        jnWeLH8SD3fLFa+UAgUkSoqApnFiNRtYo64HXpQ=
X-Google-Smtp-Source: ACHHUZ7VomFwJpz3T51TO/fNw0h4O+/KuW4wIOZiQEghUGCmhk3QJTs1/yaTtfELL5yTcSgZuPaQGLHkiOUMf2QM838=
X-Received: by 2002:a50:fe91:0:b0:504:af14:132d with SMTP id
 d17-20020a50fe91000000b00504af14132dmr580571edt.13.1682571073362; Wed, 26 Apr
 2023 21:51:13 -0700 (PDT)
MIME-Version: 1.0
References: <20230421170300.24115-1-fw@strlen.de> <20230421170300.24115-2-fw@strlen.de>
In-Reply-To: <20230421170300.24115-2-fw@strlen.de>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 Apr 2023 21:51:01 -0700
Message-ID: <CAEf4Bzby3gwHmvz1cjcNHKFPA1LQdTq85TpCmOg=GB6=bQwjOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 1/7] bpf: add bpf_link support for
 BPF_NETFILTER programs
To:     Florian Westphal <fw@strlen.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dxu@dxuuu.xyz, qde@naccy.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 10:07=E2=80=AFAM Florian Westphal <fw@strlen.de> wr=
ote:
>
> Add bpf_link support skeleton.  To keep this reviewable, no bpf program
> can be invoked yet, if a program is attached only a c-stub is called and
> not the actual bpf program.
>
> Defaults to 'y' if both netfilter and bpf syscall are enabled in kconfig.
>
> Uapi example usage:
>         union bpf_attr attr =3D { };
>
>         attr.link_create.prog_fd =3D progfd;
>         attr.link_create.attach_type =3D 0; /* unused */
>         attr.link_create.netfilter.pf =3D PF_INET;
>         attr.link_create.netfilter.hooknum =3D NF_INET_LOCAL_IN;
>         attr.link_create.netfilter.priority =3D -128;
>
>         err =3D bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
>
> ... this would attach progfd to ipv4:input hook.
>
> Such hook gets removed automatically if the calling program exits.
>
> BPF_NETFILTER program invocation is added in followup change.
>
> NF_HOOK_OP_BPF enum will eventually be read from nfnetlink_hook, it
> allows to tell userspace which program is attached at the given hook
> when user runs 'nft hook list' command rather than just the priority
> and not-very-helpful 'this hook runs a bpf prog but I can't tell which
> one'.
>
> Will also be used to disallow registration of two bpf programs with
> same priority in a followup patch.
>
> v4: arm32 cmpxchg only supports 32bit operand
>     s/prio/priority/
> v3: restrict prog attachment to ip/ip6 for now, lets lift restrictions if
>     more use cases pop up (arptables, ebtables, netdev ingress/egress etc=
).
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  no changes since last version
>
>  include/linux/netfilter.h           |   1 +
>  include/net/netfilter/nf_bpf_link.h |  10 ++
>  include/uapi/linux/bpf.h            |  14 +++
>  kernel/bpf/syscall.c                |   6 ++
>  net/netfilter/Kconfig               |   3 +
>  net/netfilter/Makefile              |   1 +
>  net/netfilter/nf_bpf_link.c         | 159 ++++++++++++++++++++++++++++
>  7 files changed, 194 insertions(+)
>  create mode 100644 include/net/netfilter/nf_bpf_link.h
>  create mode 100644 net/netfilter/nf_bpf_link.c
>
> diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> index c8e03bcaecaa..0762444e3767 100644
> --- a/include/linux/netfilter.h
> +++ b/include/linux/netfilter.h
> @@ -80,6 +80,7 @@ typedef unsigned int nf_hookfn(void *priv,
>  enum nf_hook_ops_type {
>         NF_HOOK_OP_UNDEFINED,
>         NF_HOOK_OP_NF_TABLES,
> +       NF_HOOK_OP_BPF,
>  };
>
>  struct nf_hook_ops {
> diff --git a/include/net/netfilter/nf_bpf_link.h b/include/net/netfilter/=
nf_bpf_link.h
> new file mode 100644
> index 000000000000..eeaeaf3d15de
> --- /dev/null
> +++ b/include/net/netfilter/nf_bpf_link.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#if IS_ENABLED(CONFIG_NETFILTER_BPF_LINK)
> +int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog=
);
> +#else
> +static inline int bpf_nf_link_attach(const union bpf_attr *attr, struct =
bpf_prog *prog)
> +{
> +       return -EOPNOTSUPP;
> +}
> +#endif
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4b20a7269bee..1bb11a6ee667 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -986,6 +986,7 @@ enum bpf_prog_type {
>         BPF_PROG_TYPE_LSM,
>         BPF_PROG_TYPE_SK_LOOKUP,
>         BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
> +       BPF_PROG_TYPE_NETFILTER,
>  };
>
>  enum bpf_attach_type {
> @@ -1050,6 +1051,7 @@ enum bpf_link_type {
>         BPF_LINK_TYPE_PERF_EVENT =3D 7,
>         BPF_LINK_TYPE_KPROBE_MULTI =3D 8,
>         BPF_LINK_TYPE_STRUCT_OPS =3D 9,
> +       BPF_LINK_TYPE_NETFILTER =3D 10,
>
>         MAX_BPF_LINK_TYPE,
>  };
> @@ -1560,6 +1562,12 @@ union bpf_attr {
>                                  */
>                                 __u64           cookie;
>                         } tracing;
> +                       struct {
> +                               __u32           pf;
> +                               __u32           hooknum;

catching up on stuff a bit...

enum nf_inet_hooks {
        NF_INET_PRE_ROUTING,
        NF_INET_LOCAL_IN,
        NF_INET_FORWARD,
        NF_INET_LOCAL_OUT,
        NF_INET_POST_ROUTING,
        NF_INET_NUMHOOKS,
        NF_INET_INGRESS =3D NF_INET_NUMHOOKS,
};

So it seems like this "hook number" is more like "hook type", is my
understanding correct? If so, wouldn't it be cleaner and more uniform
with, say, cgroup network hooks to provide hook type as
expected_attach_type? It would also allow to have a nicer interface in
libbpf, by specifying that as part of SEC():

SEC("netfilter/pre_routing"), SEC("netfilter/local_in"), etc...

Also, it seems like you actually didn't wire NETFILTER link support in
libbpf completely. See bpf_link_create under tools/lib/bpf/bpf.c, it
has to handle this new type of link as well. Existing tests seem a bit
bare-bones for SEC("netfilter"), would it be possible to add something
that will demonstrate it a bit better and will be actually executed at
runtime and validated?


> +                               __s32           priority;
> +                               __u32           flags;
> +                       } netfilter;
>                 };
>         } link_create;
>

[...]
