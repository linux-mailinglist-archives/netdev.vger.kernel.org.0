Return-Path: <netdev+bounces-9383-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E56D728A4E
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 740DB1C21051
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07E6034CFB;
	Thu,  8 Jun 2023 21:37:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC63F7464;
	Thu,  8 Jun 2023 21:37:26 +0000 (UTC)
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04C82D75;
	Thu,  8 Jun 2023 14:37:24 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-5149e65c244so1590272a12.3;
        Thu, 08 Jun 2023 14:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686260243; x=1688852243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LNgbnOE8JQSxHSY90Rbs24V81VgXzudXeZ7AH3950hI=;
        b=DWteEuISvZDMGQEnLEbkv4WarsSQ1+4urfKy277GgNke43FCx4JBG78NpEyXvXKV2j
         kRXsz9MdVnwp/4E13ETHqTs/li7L87set/vJUaKw3O2SUn9TZgFlzN3d6DG542Ivyd1+
         CcA9cs/9UxcleR0D89zCtUQWMgncw6Ym7URErr+HPg8LdrcUU8zGDYtubWBOe7MUI624
         296DJ8rsDLenU+wtsRbkVa65wAmUdctnfFWAL2o3sc/N3XhCSQCLuOU+kU6oK4hHpIRd
         NgVr5QOhZrlK/7ep6Kp5kb49N4kT7MC/hs4pjzuGdKM+6X7h7JApXm5n7MjLMObbH7IB
         73Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686260243; x=1688852243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LNgbnOE8JQSxHSY90Rbs24V81VgXzudXeZ7AH3950hI=;
        b=gK0HIvi6H8KfrptDGUPDaIJ2kcGsSuOwLMgp6ZWJcEF28VrXdpH4iNXhd/XUkeT0Lg
         AMen39PnhF8aploipf8TcbWnlwS+nzAAS+ON9iBDpP2pIM++NI11nduHOubxRrl7vron
         YBL23PBwWJwzcbGaWVUOH8K+TUKuGTQxbopP2zNRKlJhCo64SvWQGJ+sEYlooTsw/2kB
         2Zn0kR3msQGNKuE59J2OsSIlRppWH/rvoC4lo22UlS4iqzlQWp7gvchr7+EhGHMWk0Vv
         D1yYX17jvOogczbgR4aZr/mVbGguS7hjzRIuCUivCFQMhpeQcigQ9ctUz15KCFjp4cgd
         EVUw==
X-Gm-Message-State: AC+VfDzmxEM08lKcdr4nmcz9CJTDL5g4Rta4WjtwiGtOCyyq3MUQzXlX
	SOlJESU/P1/mdGRrQ6hexswL6cMaeXrTzVAfssU=
X-Google-Smtp-Source: ACHHUZ4+QQF28c/Ac319K/7GB9wG/ts8+xRb4N48axyTEUvfB3EezW1aHA28EVQP4GzIiq++Ke99mEREMHG2AFbOAKo=
X-Received: by 2002:a17:907:1c24:b0:974:52e6:93cb with SMTP id
 nc36-20020a1709071c2400b0097452e693cbmr409557ejc.50.1686260242754; Thu, 08
 Jun 2023 14:37:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-4-daniel@iogearbox.net>
In-Reply-To: <20230607192625.22641-4-daniel@iogearbox.net>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 14:37:11 -0700
Message-ID: <CAEf4BzbMG5rugdOQyWJH2Ac7kAta8LPEhMbYUH2Bu9JOJU0P9w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/7] libbpf: Add opts-based
 attach/detach/query API for tcx
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
> Extend libbpf attach opts and add a new detach opts API so this can be us=
ed
> to add/remove fd-based tcx BPF programs. The old-style bpf_prog_detach an=
d
> bpf_prog_detach2 APIs are refactored to reuse the detach opts internally.
>
> The bpf_prog_query_opts API got extended to be able to handle the new lin=
k_ids,
> link_attach_flags and revision fields.
>
> For concrete usage examples, see the extensive selftests that have been
> developed as part of this series.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  tools/lib/bpf/bpf.c      | 78 ++++++++++++++++++++++------------------
>  tools/lib/bpf/bpf.h      | 54 +++++++++++++++++++++-------
>  tools/lib/bpf/libbpf.c   |  6 ++++
>  tools/lib/bpf/libbpf.map |  1 +
>  4 files changed, 91 insertions(+), 48 deletions(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index ed86b37d8024..a3d1b7ebe224 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -629,11 +629,21 @@ int bpf_prog_attach(int prog_fd, int target_fd, enu=
m bpf_attach_type type,
>         return bpf_prog_attach_opts(prog_fd, target_fd, type, &opts);
>  }
>
> -int bpf_prog_attach_opts(int prog_fd, int target_fd,
> -                         enum bpf_attach_type type,
> -                         const struct bpf_prog_attach_opts *opts)
> +int bpf_prog_detach(int target_fd, enum bpf_attach_type type)
> +{
> +       return bpf_prog_detach_opts(0, target_fd, type, NULL);
> +}
> +
> +int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type ty=
pe)
>  {
> -       const size_t attr_sz =3D offsetofend(union bpf_attr, replace_bpf_=
fd);
> +       return bpf_prog_detach_opts(prog_fd, target_fd, type, NULL);
> +}

Please put these wrappers after bpf_prog_detach_ops(), it will make
the diff cleaner and will keep them closer to full version of
bpf_prog_detach_opts().

> +
> +int bpf_prog_attach_opts(int prog_fd, int target,
> +                        enum bpf_attach_type type,
> +                        const struct bpf_prog_attach_opts *opts)
> +{
> +       const size_t attr_sz =3D offsetofend(union bpf_attr, expected_rev=
ision);
>         union bpf_attr attr;
>         int ret;
>

[...]

> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 9aa0ee473754..480c584a6f7f 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -312,22 +312,43 @@ LIBBPF_API int bpf_obj_get(const char *pathname);
>  LIBBPF_API int bpf_obj_get_opts(const char *pathname,
>                                 const struct bpf_obj_get_opts *opts);
>
> -struct bpf_prog_attach_opts {
> -       size_t sz; /* size of this struct for forward/backward compatibil=
ity */
> -       unsigned int flags;
> -       int replace_prog_fd;
> -};
> -#define bpf_prog_attach_opts__last_field replace_prog_fd
> -
>  LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
>                                enum bpf_attach_type type, unsigned int fl=
ags);
> -LIBBPF_API int bpf_prog_attach_opts(int prog_fd, int attachable_fd,
> -                                    enum bpf_attach_type type,
> -                                    const struct bpf_prog_attach_opts *o=
pts);
>  LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type t=
ype);
>  LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
>                                 enum bpf_attach_type type);
>
> +struct bpf_prog_attach_opts {
> +       size_t sz; /* size of this struct for forward/backward compatibil=
ity */
> +       __u32 flags;
> +       union {
> +               int     replace_prog_fd;
> +               int     replace_fd;
> +               int     relative_fd;
> +               __u32   relative_id;
> +       };

I tried to not use union for such cases in OPTS-based interfaces, see
bpf_link_create(). Let's keep them all as separate fields and then
return error if, say, both relative_fd and relative_id is specified at
the same time.

It's fine to have replace_prog_fd and replace_fd as a union, as they
are basically just synonyms.


> +       __u32 expected_revision;
> +};
> +#define bpf_prog_attach_opts__last_field expected_revision
> +
> +struct bpf_prog_detach_opts {
> +       size_t sz; /* size of this struct for forward/backward compatibil=
ity */
> +       __u32 flags;
> +       union {
> +               int     relative_fd;
> +               __u32   relative_id;
> +       };

same as above

> +       __u32 expected_revision;
> +};
> +#define bpf_prog_detach_opts__last_field expected_revision
> +
> +LIBBPF_API int bpf_prog_attach_opts(int prog_fd, int target,

let's add doc comments to both these APIs, where `target` is
explained. Right now because it doesn't have "_fd" suffix it's not
very clear what sort of value it is (I know why it's not target_fd
anymore due to target_ifindex)

> +                                   enum bpf_attach_type type,
> +                                   const struct bpf_prog_attach_opts *op=
ts);
> +LIBBPF_API int bpf_prog_detach_opts(int prog_fd, int target,
> +                                   enum bpf_attach_type type,
> +                                   const struct bpf_prog_detach_opts *op=
ts);
> +
>  union bpf_iter_link_info; /* defined in up-to-date linux/bpf.h */
>  struct bpf_link_create_opts {
>         size_t sz; /* size of this struct for forward/backward compatibil=
ity */
> @@ -489,14 +510,21 @@ struct bpf_prog_query_opts {
>         __u32 query_flags;
>         __u32 attach_flags; /* output argument */
>         __u32 *prog_ids;
> -       __u32 prog_cnt; /* input+output argument */
> +       union {
> +               __u32 prog_cnt; /* input+output argument */
> +               __u32 count;
> +       };
>         __u32 *prog_attach_flags;
> +       __u32 *link_ids;
> +       __u32 *link_attach_flags;
> +       __u32 revision;
>  };
> -#define bpf_prog_query_opts__last_field prog_attach_flags
> +#define bpf_prog_query_opts__last_field revision
>
> -LIBBPF_API int bpf_prog_query_opts(int target_fd,
> +LIBBPF_API int bpf_prog_query_opts(int target,

same here for doc comment

>                                    enum bpf_attach_type type,
>                                    struct bpf_prog_query_opts *opts);
> +
>  LIBBPF_API int bpf_prog_query(int target_fd, enum bpf_attach_type type,
>                               __u32 query_flags, __u32 *attach_flags,
>                               __u32 *prog_ids, __u32 *prog_cnt);
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 47632606b06d..b89127471c6a 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -117,6 +117,8 @@ static const char * const attach_type_name[] =3D {
>         [BPF_PERF_EVENT]                =3D "perf_event",
>         [BPF_TRACE_KPROBE_MULTI]        =3D "trace_kprobe_multi",
>         [BPF_STRUCT_OPS]                =3D "struct_ops",
> +       [BPF_TCX_INGRESS]               =3D "tcx_ingress",
> +       [BPF_TCX_EGRESS]                =3D "tcx_egress",
>  };
>
>  static const char * const link_type_name[] =3D {
> @@ -8669,6 +8671,10 @@ static const struct bpf_sec_def section_defs[] =3D=
 {
>         SEC_DEF("kretsyscall+",         KPROBE, 0, SEC_NONE, attach_ksysc=
all),
>         SEC_DEF("usdt+",                KPROBE, 0, SEC_NONE, attach_usdt)=
,
>         SEC_DEF("tc",                   SCHED_CLS, 0, SEC_NONE),
> +       SEC_DEF("tc/ingress",           SCHED_CLS, BPF_TCX_INGRESS, SEC_A=
TTACHABLE_OPT),
> +       SEC_DEF("tc/egress",            SCHED_CLS, BPF_TCX_EGRESS, SEC_AT=
TACHABLE_OPT),

for tc/ingress and tc/egress, is it intentional that libbpf should set
expected_attach_type to zero if kernel doesn't support BPF_TCX_INGRESS
or BPF_TCX_EGRESS? Or is it just an alias to tcx/ingress and
tcx/egress?

If it's an alias, why do we need it?

If not, let's replace SEC_ATTACHABLE_OPT with just SEC_EXP_ATTACH_OPT ?

> +       SEC_DEF("tcx/ingress",          SCHED_CLS, BPF_TCX_INGRESS, SEC_A=
TTACHABLE_OPT),
> +       SEC_DEF("tcx/egress",           SCHED_CLS, BPF_TCX_EGRESS, SEC_AT=
TACHABLE_OPT),

at least for tcx attach_type is not optional, right? So I'd drop
SEC_ATTACHABLE_OPT.

>         SEC_DEF("classifier",           SCHED_CLS, 0, SEC_NONE),
>         SEC_DEF("action",               SCHED_ACT, 0, SEC_NONE),
>         SEC_DEF("tracepoint+",          TRACEPOINT, 0, SEC_NONE, attach_t=
p),
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 7521a2fb7626..a29b90e9713c 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -395,4 +395,5 @@ LIBBPF_1.2.0 {
>  LIBBPF_1.3.0 {
>         global:
>                 bpf_obj_pin_opts;
> +               bpf_prog_detach_opts;
>  } LIBBPF_1.2.0;
> --
> 2.34.1
>

