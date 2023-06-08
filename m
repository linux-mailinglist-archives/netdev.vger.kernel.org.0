Return-Path: <netdev+bounces-9385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37D28728A5F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:46:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E29422817D8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C192734D68;
	Thu,  8 Jun 2023 21:46:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD90734CC5;
	Thu,  8 Jun 2023 21:46:05 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B352D6A;
	Thu,  8 Jun 2023 14:46:02 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-516af4a6d65so2201098a12.0;
        Thu, 08 Jun 2023 14:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686260761; x=1688852761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0gBdEd5KK0cMDIEfPtMEnHOk1BAg7LXAVSfnfgoMtw=;
        b=NdSMKPisWaZE0nPsClLb5viDPO4q1Wsmf0rnWA+5t7+FSnlKBY1Xtra69k6xCPCz/4
         no8uF38I+w7+R8IHJkoqXAGoha4yExR1aQ3J5SO1A1EVC7bmpqk3qsIAYWeSNNJYLhwU
         Wm9C1zLrC5zPFQ1JBboJroMWXoZzJjuIBPmHr2hLT3P3Ge21Xz3hqIGguPArWEBaGQ8q
         LqBBK41LUoOoPBK4fADJVfAH7w1NZ7qcRYcJVmKviCfMSfl6A9mg4RpdRoCnq+UnNoaz
         BjRvHAHyVU/ln4eJAkOZBaaypQoxhJJgE2KTuHwtju7ej07rEjq2WjS1MoTZETBO0CCZ
         eyKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686260761; x=1688852761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x0gBdEd5KK0cMDIEfPtMEnHOk1BAg7LXAVSfnfgoMtw=;
        b=L2qENSi7AMdRqMq6nasMuYdes4GMpRLNG8tdku180M4uccWT2JGofKamiPo2Ar0LLf
         y1kkahWVjIJPmOz3QF+6tl5XmUp9nz3Ce97th8vVP4WGuD6Fluh1ra3fF9et/BUHtwxX
         cqTihciy0wfjnZWv5foZRbE3jdyHcmYcV19LtOpnhphu4IvOjrlG9FHmp70GGEYrNWEm
         76cE6VnTkPYpoC0VnWQ8PN+wi/d81rSDyd7CvcZ5/cvMyhN/IHGvbocJCpOh1ir6GHu0
         nGaXV4Ww05/iZayG4eJoZwYwnMN7R2hGjSPNdhvpHQtl42O8NsvOzljOoyChFgGluIR7
         KLqw==
X-Gm-Message-State: AC+VfDz/uerNnJt0md/0Jr70KRRbUAxjO7mQ3Qi8Y3g4jyf5a6cJ7dNX
	5ouFvCSfsK3vPVDLhAD6W4NRERYHvklpeQqgDE8=
X-Google-Smtp-Source: ACHHUZ4gAi4Kf/fzB7ty7Kk8nwwEFAGJgjegy9+shEAu471QdCl2t0u6TEtNUDf6BYgRMTFZQHl2hZvuWoQZVDcBjRY=
X-Received: by 2002:a17:907:868c:b0:977:cc28:d974 with SMTP id
 qa12-20020a170907868c00b00977cc28d974mr316786ejc.14.1686260760473; Thu, 08
 Jun 2023 14:46:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-5-daniel@iogearbox.net>
In-Reply-To: <20230607192625.22641-5-daniel@iogearbox.net>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 14:45:48 -0700
Message-ID: <CAEf4Bzaey8c86vLh8sMfvU5KepbYOuej0cKXb88ANp8kZnpCQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/7] libbpf: Add link-based API for tcx
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev, 
	razor@blackwall.org, sdf@google.com, john.fastabend@gmail.com, 
	kuba@kernel.org, dxu@dxuuu.xyz, joe@cilium.io, toke@kernel.org, 
	davem@davemloft.net, bpf@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 7, 2023 at 12:26=E2=80=AFPM Daniel Borkmann <daniel@iogearbox.n=
et> wrote:
>
> Implement tcx BPF link support for libbpf.
>
> The bpf_program__attach_fd_opts() API has been refactored slightly in ord=
er to
> pass bpf_link_create_opts pointer as input.
>
> A new bpf_program__attach_tcx_opts() has been added on top of this which =
allows
> for passing all relevant data via extensible struct bpf_tcx_opts.
>
> The program sections tcx/ingress and tcx/egress correspond to the hook lo=
cations
> for tc ingress and egress, respectively.
>
> For concrete usage examples, see the extensive selftests that have been
> developed as part of this series.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/lib/bpf/bpf.c      |  5 +++++
>  tools/lib/bpf/bpf.h      |  7 +++++++
>  tools/lib/bpf/libbpf.c   | 44 +++++++++++++++++++++++++++++++++++-----
>  tools/lib/bpf/libbpf.h   | 17 ++++++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  5 files changed, 69 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index a3d1b7ebe224..c340d3cbc6bd 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -746,6 +746,11 @@ int bpf_link_create(int prog_fd, int target_fd,
>                 if (!OPTS_ZEROED(opts, tracing))
>                         return libbpf_err(-EINVAL);
>                 break;
> +       case BPF_TCX_INGRESS:
> +       case BPF_TCX_EGRESS:
> +               attr.link_create.tcx.relative_fd =3D OPTS_GET(opts, tcx.r=
elative_fd, 0);
> +               attr.link_create.tcx.expected_revision =3D OPTS_GET(opts,=
 tcx.expected_revision, 0);

can you also add an OPTS_ZEROED check like for other types of links?

> +               break;
>         default:
>                 if (!OPTS_ZEROED(opts, flags))
>                         return libbpf_err(-EINVAL);
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 480c584a6f7f..12591516dca0 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -370,6 +370,13 @@ struct bpf_link_create_opts {
>                 struct {
>                         __u64 cookie;
>                 } tracing;
> +               struct {
> +                       union {
> +                               __u32 relative_fd;
> +                               __u32 relative_id;
> +                       };

same comment about union, let's not add it and have two separate fields


> +                       __u32 expected_revision;
> +               } tcx;
>         };
>         size_t :0;
>  };
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b89127471c6a..d7b6ff49f02e 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -133,6 +133,7 @@ static const char * const link_type_name[] =3D {
>         [BPF_LINK_TYPE_KPROBE_MULTI]            =3D "kprobe_multi",
>         [BPF_LINK_TYPE_STRUCT_OPS]              =3D "struct_ops",
>         [BPF_LINK_TYPE_NETFILTER]               =3D "netfilter",
> +       [BPF_LINK_TYPE_TCX]                     =3D "tcx",
>  };
>
>  static const char * const map_type_name[] =3D {
> @@ -11685,11 +11686,10 @@ static int attach_lsm(const struct bpf_program =
*prog, long cookie, struct bpf_li
>  }
>
>  static struct bpf_link *
> -bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, in=
t btf_id,
> -                      const char *target_name)
> +bpf_program__attach_fd_opts(const struct bpf_program *prog,
> +                           const struct bpf_link_create_opts *opts,
> +                           int target_fd, const char *target_name)

nit: please keep opts as the last argument

>  {
> -       DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> -                           .target_btf_id =3D btf_id);
>         enum bpf_attach_type attach_type;
>         char errmsg[STRERR_BUFSIZE];
>         struct bpf_link *link;
> @@ -11707,7 +11707,7 @@ bpf_program__attach_fd(const struct bpf_program *=
prog, int target_fd, int btf_id
>         link->detach =3D &bpf_link__detach_fd;
>
>         attach_type =3D bpf_program__expected_attach_type(prog);
> -       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type, &opt=
s);
> +       link_fd =3D bpf_link_create(prog_fd, target_fd, attach_type, opts=
);
>         if (link_fd < 0) {
>                 link_fd =3D -errno;
>                 free(link);
> @@ -11720,6 +11720,17 @@ bpf_program__attach_fd(const struct bpf_program =
*prog, int target_fd, int btf_id
>         return link;
>  }
>
> +static struct bpf_link *
> +bpf_program__attach_fd(const struct bpf_program *prog, int target_fd, in=
t btf_id,
> +                      const char *target_name)
> +{
> +       LIBBPF_OPTS(bpf_link_create_opts, opts,
> +               .target_btf_id =3D btf_id,
> +       );
> +
> +       return bpf_program__attach_fd_opts(prog, &opts, target_fd, target=
_name);

it seems like the only user of btf_id is bpf_program__attach_freplace,
so I'd just inline this there, and for all other 4 cases let's just
pass NULL as options?

That means we don't really need bpf_program__attach_fd_opts() and can
just add opts to bpf_program__attach_fd(). We'll have shorter name.
BTW, given it's not exposed API, let's drop double underscore and call
it just bpf_program_attach_fd()?

> +}
> +
>  struct bpf_link *
>  bpf_program__attach_cgroup(const struct bpf_program *prog, int cgroup_fd=
)
>  {
> @@ -11738,6 +11749,29 @@ struct bpf_link *bpf_program__attach_xdp(const s=
truct bpf_program *prog, int ifi
>         return bpf_program__attach_fd(prog, ifindex, 0, "xdp");
>  }
>
> +struct bpf_link *
> +bpf_program__attach_tcx_opts(const struct bpf_program *prog,
> +                            const struct bpf_tcx_opts *opts)

we don't have non-opts variant, so let's keep the name short (like we
did with bpf_program__attach_netlink): bpf_program__attach_tcx().

> +{
> +       LIBBPF_OPTS(bpf_link_create_opts, link_create_opts);
> +       int ifindex =3D OPTS_GET(opts, ifindex, 0);

let's not do OPTS_GET before we checked OPTS_VALID

> +
> +       if (!OPTS_VALID(opts, bpf_tcx_opts))
> +               return libbpf_err_ptr(-EINVAL);
> +       if (!ifindex) {
> +               pr_warn("prog '%s': target netdevice ifindex cannot be ze=
ro\n",
> +                       prog->name);
> +               return libbpf_err_ptr(-EINVAL);
> +       }
> +
> +       link_create_opts.tcx.expected_revision =3D OPTS_GET(opts, expecte=
d_revision, 0);
> +       link_create_opts.tcx.relative_fd =3D OPTS_GET(opts, relative_fd, =
0);
> +       link_create_opts.flags =3D OPTS_GET(opts, flags, 0);
> +
> +       /* target_fd/target_ifindex use the same field in LINK_CREATE */
> +       return bpf_program__attach_fd_opts(prog, &link_create_opts, ifind=
ex, "tc");
> +}
> +
>  struct bpf_link *bpf_program__attach_freplace(const struct bpf_program *=
prog,
>                                               int target_fd,
>                                               const char *attach_func_nam=
e)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 754da73c643b..8ffba0f67c60 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -718,6 +718,23 @@ LIBBPF_API struct bpf_link *
>  bpf_program__attach_freplace(const struct bpf_program *prog,
>                              int target_fd, const char *attach_func_name)=
;
>
> +struct bpf_tcx_opts {
> +       /* size of this struct, for forward/backward compatibility */
> +       size_t sz;
> +       int ifindex;
> +       __u32 flags;
> +       union {
> +               __u32 relative_fd;
> +               __u32 relative_id;
> +       };

same thing about not using unions here :)

> +       __u32 expected_revision;

and let's add `size_t :0;` to prevent compiler from leaving garbage
values in a padding at the end of the struct (once you drop union
there will be padding)

> +};
> +#define bpf_tcx_opts__last_field expected_revision
> +
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_tcx_opts(const struct bpf_program *prog,
> +                            const struct bpf_tcx_opts *opts);
> +
>  struct bpf_map;
>
>  LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(const struct bpf_=
map *map);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index a29b90e9713c..f66b714512c2 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -396,4 +396,5 @@ LIBBPF_1.3.0 {
>         global:
>                 bpf_obj_pin_opts;
>                 bpf_prog_detach_opts;
> +               bpf_program__attach_tcx_opts;
>  } LIBBPF_1.2.0;
> --
> 2.34.1
>

