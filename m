Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399B726CA2E
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 21:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgIPTuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 15:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727529AbgIPTuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 15:50:11 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B38AC06174A;
        Wed, 16 Sep 2020 12:50:11 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id x10so6233956ybj.13;
        Wed, 16 Sep 2020 12:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YnSmatLGhcEhyRp68fTzveCNhARxM7IKzZ+gMOB0rSs=;
        b=RFz/8p1g80KGCYcUzcrZG7V1O941I2t0d8Wd5X3sisqm6a2NwuyLEocLZtcSbP/e4c
         r1L3LP3zfY45H38eRdDl6TAXJXBAMTYafW3ER8FDC/9PvUtS7IRlRGxAXm566cfeuJQ4
         VolsNYzx2GQy87dP2WA7c50Oz5EvlXKbiQZYbm61F98ThjeR3b4k9YmkoS6csnB+QGlP
         J7jrQWneenxk5jcGPSDgrFhPw6ovB/5tci+4HFH+OeE0jn1wtHu9C/ecVkjAnNTJyxxT
         KRtBm2MmTDo4MdejY9tMDPc0m7wsaTPRDtVM7QYvNQt8IvCqstkEcUq6dWjqu99oeZ1A
         vrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YnSmatLGhcEhyRp68fTzveCNhARxM7IKzZ+gMOB0rSs=;
        b=I18txPDBX/NlRNqgKnm6lSnija2xxM7X9Mu2+mEAtlXMJrxoasENsSJBpyc191nB+M
         LUwBqo1BnaHiKdxl4+J2oCwoiRlbRyHimy6u5/ZTgq279CIYqrl265DhzkxHiYo4l7e2
         UttLX6/FlR90x3in3+03JMaKikpjMtw9CxdFuI+tAXdmKTTezlughC8QdIoi+/ctjWJD
         ylvQEmYM1ZQ1H9aREuntkjR3qNY+YSbJ0yt5sW1KsJnGFwBQYWpN4PCfbl/5dLtRZeps
         pGb2eU0r7QdLTbRgIdUTItQ6cXeXbUWK/WYAZBoubedI4bXMemf6J5+As4P5gKch7OU3
         8ugg==
X-Gm-Message-State: AOAM5332ETX+9dp+OK/FcIxIV9tRQ8cQlpVLxHN5fKSgayL4wcqcdXbp
        INJX/05IpPLLarzYIIF1FvupX4No+VqvqGFVEVP7I3Tig6GTww==
X-Google-Smtp-Source: ABdhPJzjYzMTHT1uPEnOkBsCEDavek+7qz/RcFbO6iDqBlfTdHzS0Si13JUOGZoGQTgLHndK+3H1QwC6hLva4ERr9q4=
X-Received: by 2002:a25:da90:: with SMTP id n138mr17551317ybf.260.1600285808824;
 Wed, 16 Sep 2020 12:50:08 -0700 (PDT)
MIME-Version: 1.0
References: <160017005691.98230.13648200635390228683.stgit@toke.dk> <160017006133.98230.8867570651560085505.stgit@toke.dk>
In-Reply-To: <160017006133.98230.8867570651560085505.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Sep 2020 12:49:57 -0700
Message-ID: <CAEf4BzYP6MpVEqJ1TVW6rcfqJjkBi9x9U9F8MZPQdGMmoaUX_A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 4/8] bpf: support attaching freplace programs
 to multiple attach points
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 5:50 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This enables support for attaching freplace programs to multiple attach
> points. It does this by amending the UAPI for bpf_link_Create with a targ=
et
> btf ID that can be used to supply the new attachment point along with the
> target program fd. The target must be compatible with the target that was
> supplied at program load time.
>
> The implementation reuses the checks that were factored out of
> check_attach_btf_id() to ensure compatibility between the BTF types of th=
e
> old and new attachment. If these match, a new bpf_tracing_link will be
> created for the new attach target, allowing multiple attachments to
> co-exist simultaneously.
>
> The code could theoretically support multiple-attach of other types of
> tracing programs as well, but since I don't have a use case for any of
> those, there is no API support for doing so.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/bpf.h            |    2 +
>  include/uapi/linux/bpf.h       |    2 +
>  kernel/bpf/syscall.c           |   92 ++++++++++++++++++++++++++++++++++=
------
>  kernel/bpf/verifier.c          |    9 ++++
>  tools/include/uapi/linux/bpf.h |    2 +
>  5 files changed, 94 insertions(+), 13 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 939b37c78d55..360e8291e6bb 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -743,6 +743,8 @@ struct bpf_prog_aux {
>         struct mutex tgt_mutex; /* protects writing of tgt_* pointers bel=
ow */
>         struct bpf_prog *tgt_prog;
>         struct bpf_trampoline *tgt_trampoline;
> +       enum bpf_prog_type tgt_prog_type;
> +       enum bpf_attach_type tgt_attach_type;
>         bool verifier_zext; /* Zero extensions has been inserted by verif=
ier. */
>         bool offload_requested;
>         bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp=
 */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 7dd314176df7..46eaa3024dc3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -239,6 +239,7 @@ enum bpf_attach_type {
>         BPF_XDP_CPUMAP,
>         BPF_SK_LOOKUP,
>         BPF_XDP,
> +       BPF_TRACE_FREPLACE,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -633,6 +634,7 @@ union bpf_attr {
>                 __u32           flags;          /* extra flags */
>                 __aligned_u64   iter_info;      /* extra bpf_iter_link_in=
fo */
>                 __u32           iter_info_len;  /* iter_info length */
> +               __u32           target_btf_id;  /* btf_id of target to at=
tach to */

iter_info + iter_info_len are mutually exclusive with target_btf_id,
they should be inside a union with each other

>         } link_create;
>
>         struct { /* struct used by BPF_LINK_UPDATE command */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index fc2bca2d9f05..429afa820c6f 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -4,6 +4,7 @@
>  #include <linux/bpf.h>
>  #include <linux/bpf_trace.h>
>  #include <linux/bpf_lirc.h>
> +#include <linux/bpf_verifier.h>
>  #include <linux/btf.h>
>  #include <linux/syscalls.h>
>  #include <linux/slab.h>
> @@ -2555,12 +2556,18 @@ static const struct bpf_link_ops bpf_tracing_link=
_lops =3D {
>         .fill_link_info =3D bpf_tracing_link_fill_link_info,
>  };
>
> -static int bpf_tracing_prog_attach(struct bpf_prog *prog)
> +static int bpf_tracing_prog_attach(struct bpf_prog *prog,
> +                                  int tgt_prog_fd,
> +                                  u32 btf_id)
>  {
>         struct bpf_link_primer link_primer;
>         struct bpf_prog *tgt_prog =3D NULL;
>         struct bpf_tracing_link *link;
> +       struct btf_func_model fmodel;
> +       bool new_trampoline =3D false;
>         struct bpf_trampoline *tr;
> +       long addr;
> +       u64 key;
>         int err;
>
>         switch (prog->type) {
> @@ -2588,6 +2595,24 @@ static int bpf_tracing_prog_attach(struct bpf_prog=
 *prog)
>                 err =3D -EINVAL;
>                 goto out_put_prog;
>         }
> +       if (tgt_prog_fd) {
> +               /* For now we only allow new targets for BPF_PROG_TYPE_EX=
T */
> +               if (prog->type !=3D BPF_PROG_TYPE_EXT || !btf_id) {
> +                       err =3D -EINVAL;
> +                       goto out_put_prog;
> +               }
> +
> +               tgt_prog =3D bpf_prog_get(tgt_prog_fd);
> +               if (IS_ERR(tgt_prog)) {
> +                       err =3D PTR_ERR(tgt_prog);
> +                       goto out_put_prog;
> +               }
> +
> +               key =3D ((u64)tgt_prog->aux->id) << 32 | btf_id;
> +       } else if (btf_id) {
> +               err =3D -EINVAL;
> +               goto out_put_prog;
> +       }

These changes are unnecessarily tangled with this if/else and
double-checking of btf_id. btf_id is required iff tgt_prog_fd is
specified, right? So just check that explicitly:

if (!!btf_id !=3D !!targ_prog_fd)
  ...

bpf_iter code uses ^ instead of !=3D, but does same checks


if (targ_prog_fd) {
  if (prog->type !=3D BPF_PROG_TYPE_EXT)
    ...
} /* no else here */

More straightforward, IMO.

>
>         link =3D kzalloc(sizeof(*link), GFP_USER);
>         if (!link) {

here you are leaking tgt_prog

> @@ -2600,33 +2625,65 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog)
>
>         mutex_lock(&prog->aux->tgt_mutex);
>
> -       if (!prog->aux->tgt_trampoline) {
> -               err =3D -ENOENT;
> -               goto out_unlock;
> +       if (!prog->aux->tgt_trampoline ||
> +           (tgt_prog && prog->aux->tgt_trampoline->key !=3D key)) {
> +               new_trampoline =3D true;
> +       } else {
> +               if (tgt_prog) {
> +                       /* re-using ref to tgt_prog, don't take another *=
/
> +                       bpf_prog_put(tgt_prog);

this is just another complication to keep in mind, I propose to drop
it and handle at the very end, see below

> +               }
> +               tr =3D prog->aux->tgt_trampoline;
> +               tgt_prog =3D prog->aux->tgt_prog;
> +       }

this also seems too convoluted with this new_trampoline flag. Tell me
where I'm missing something.

0. get the *incorrectly* missing trampoline case (i.e., we already
attached to it and we don't specify explicit target) right out of the
way, without having nested checks:

if (!prog->aux->tgt_trampoline && !tgt_prog)
  err =3D -ENOENT, goto;

1. Now we know that everything has to work out. new_trampoline
detection at the end is very trivial as well, so there is no need to
have this extra new_trampoline flag and split new trampoline handling
into two ifs.

if (!prog->aux->tgt_trampoline || key !=3D tgt_trampoline->key) {
  /* gotta be a new trampoline */
  bpf_check_attach_target()
  tr =3D bpf_trampoline_get()
} else {
  /* reuse trampoline */
  tr =3D ...;
  tgt_prog =3D prog->aux->tgt_prog; /* we'll deal with refcount later */
}

> +
> +       if (new_trampoline) {
> +               if (!tgt_prog) {
> +                       err =3D -ENOENT;
> +                       goto out_unlock;
> +               }
> +
> +               err =3D bpf_check_attach_target(NULL, prog, tgt_prog, btf=
_id,
> +                                             &fmodel, &addr, NULL, NULL)=
;
> +               if (err) {
> +                       bpf_prog_put(tgt_prog);
> +                       goto out_unlock;
> +               }
> +
> +               tr =3D bpf_trampoline_get(key, (void *)addr, &fmodel);
> +               if (IS_ERR(tr)) {
> +                       err =3D PTR_ERR(tr);
> +                       bpf_prog_put(tgt_prog);
> +                       goto out_unlock;
> +               }
>         }

this got rolled into a check above

> -       tr =3D prog->aux->tgt_trampoline;
> -       tgt_prog =3D prog->aux->tgt_prog;
>
>         err =3D bpf_link_prime(&link->link, &link_primer);
>         if (err) {
> -               goto out_unlock;
> +               goto out_put_tgt;
>         }
>
>         err =3D bpf_trampoline_link_prog(prog, tr);
>         if (err) {
>                 bpf_link_cleanup(&link_primer);
>                 link =3D NULL;
> -               goto out_unlock;
> +               goto out_put_tgt;
>         }
>
>         link->tgt_prog =3D tgt_prog;
>         link->trampoline =3D tr;
> -
> -       prog->aux->tgt_prog =3D NULL;
> -       prog->aux->tgt_trampoline =3D NULL;
> +       if (!new_trampoline) {
> +               prog->aux->tgt_trampoline =3D NULL;
> +               prog->aux->tgt_prog =3D NULL;
> +       }

this is just:

if (tr =3D=3D prog->aux->tgt_trampoline) {
  /* drop ref held by prog itself, we've already got tgt_prog ref from
syscall */
  bpf_prog_put(prog->aux->tgt_prog);
  prog->aux->tgt_prog =3D NULL;
  prog->aux->tgt_trampoline =3D NULL;
}

>         mutex_unlock(&prog->aux->tgt_mutex);
>
>         return bpf_link_settle(&link_primer);
> +out_put_tgt:

see above, in some cases you are not putting tgt_prog where you
should. If you initialize tr to NULL, then you can do this
unconditionally on any error (no need to have different goto labels):

if (tgt_prog_fd && tgt_prog)
    bpf_prog_put(tgt_prog);
if (tr && tr !=3D prog->aux->tgt_trampoline)
    bpf_trampoline_put(tr);


> +       if (new_trampoline) {
> +               bpf_prog_put(tgt_prog);
> +               bpf_trampoline_put(tr);
> +       }
>  out_unlock:
>         mutex_unlock(&prog->aux->tgt_mutex);
>         kfree(link);
> @@ -2744,7 +2801,7 @@ static int bpf_raw_tracepoint_open(const union bpf_=
attr *attr)
>                         tp_name =3D prog->aux->attach_func_name;
>                         break;
>                 }
> -               return bpf_tracing_prog_attach(prog);
> +               return bpf_tracing_prog_attach(prog, 0, 0);
>         case BPF_PROG_TYPE_RAW_TRACEPOINT:
>         case BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE:
>                 if (strncpy_from_user(buf,
> @@ -2864,6 +2921,8 @@ attach_type_to_prog_type(enum bpf_attach_type attac=
h_type)
>         case BPF_CGROUP_GETSOCKOPT:
>         case BPF_CGROUP_SETSOCKOPT:
>                 return BPF_PROG_TYPE_CGROUP_SOCKOPT;
> +       case BPF_TRACE_FREPLACE:
> +               return BPF_PROG_TYPE_EXT;
>         case BPF_TRACE_ITER:
>                 return BPF_PROG_TYPE_TRACING;
>         case BPF_SK_LOOKUP:
> @@ -3924,10 +3983,16 @@ static int tracing_bpf_link_attach(const union bp=
f_attr *attr, struct bpf_prog *
>             prog->expected_attach_type =3D=3D BPF_TRACE_ITER)
>                 return bpf_iter_link_attach(attr, prog);
>
> +       if (attr->link_create.attach_type =3D=3D BPF_TRACE_FREPLACE &&
> +           !prog->expected_attach_type)
> +               return bpf_tracing_prog_attach(prog,
> +                                              attr->link_create.target_f=
d,
> +                                              attr->link_create.target_b=
tf_id);

Hm.. so you added a "fake" BPF_TRACE_FREPLACE attach_type, which is
not really set with BPF_PROG_TYPE_EXT and is only specified for the
LINK_CREATE command. Are you just trying to satisfy the link_create
flow of going from attach_type to program type? If that's the only
reason, I think we can adjust link_create code to handle this more
flexibly.

I need to think a bit more whether we want BPF_TRACE_FREPLACE at all,
but if we do, whether we should make it an expected_attach_type for
BPF_PROG_TYPE_EXT then...

> +
>         return -EINVAL;
>  }
>
> -#define BPF_LINK_CREATE_LAST_FIELD link_create.iter_info_len
> +#define BPF_LINK_CREATE_LAST_FIELD link_create.target_btf_id
>  static int link_create(union bpf_attr *attr)
>  {
>         enum bpf_prog_type ptype;
> @@ -3961,6 +4026,7 @@ static int link_create(union bpf_attr *attr)
>                 ret =3D cgroup_bpf_link_attach(attr, prog);
>                 break;
>         case BPF_PROG_TYPE_TRACING:
> +       case BPF_PROG_TYPE_EXT:
>                 ret =3D tracing_bpf_link_attach(attr, prog);
>                 break;
>         case BPF_PROG_TYPE_FLOW_DISSECTOR:
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 02f704367014..2dd5e2ad7f31 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -11202,6 +11202,12 @@ int bpf_check_attach_target(struct bpf_verifier_=
log *log,
>                 if (!btf_type_is_func_proto(t))
>                         return -EINVAL;
>
> +               if ((prog->aux->tgt_prog_type &&
> +                    prog->aux->tgt_prog_type !=3D tgt_prog->type) ||
> +                   (prog->aux->tgt_attach_type &&
> +                    prog->aux->tgt_attach_type !=3D tgt_prog->expected_a=
ttach_type))
> +                       return -EINVAL;
> +
>                 if (tgt_prog && conservative)
>                         t =3D NULL;
>
> @@ -11300,6 +11306,9 @@ static int check_attach_btf_id(struct bpf_verifie=
r_env *env)
>                 return ret;
>
>         if (tgt_prog) {
> +               prog->aux->tgt_prog_type =3D tgt_prog->type;
> +               prog->aux->tgt_attach_type =3D tgt_prog->expected_attach_=
type;
> +
>                 if (prog->type =3D=3D BPF_PROG_TYPE_EXT) {
>                         env->ops =3D bpf_verifier_ops[tgt_prog->type];
>                         prog->expected_attach_type =3D
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bp=
f.h
> index 7dd314176df7..46eaa3024dc3 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -239,6 +239,7 @@ enum bpf_attach_type {
>         BPF_XDP_CPUMAP,
>         BPF_SK_LOOKUP,
>         BPF_XDP,
> +       BPF_TRACE_FREPLACE,
>         __MAX_BPF_ATTACH_TYPE
>  };
>
> @@ -633,6 +634,7 @@ union bpf_attr {
>                 __u32           flags;          /* extra flags */
>                 __aligned_u64   iter_info;      /* extra bpf_iter_link_in=
fo */
>                 __u32           iter_info_len;  /* iter_info length */
> +               __u32           target_btf_id;  /* btf_id of target to at=
tach to */
>         } link_create;
>
>         struct { /* struct used by BPF_LINK_UPDATE command */
>
