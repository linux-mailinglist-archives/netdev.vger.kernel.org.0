Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DA5266946
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 21:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725832AbgIKT6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 15:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgIKT6A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 15:58:00 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A8AC061573;
        Fri, 11 Sep 2020 12:58:00 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id k2so4569177ybp.7;
        Fri, 11 Sep 2020 12:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e89rzy2kz1sjc3Zo7u7dI9r9xHMFS2z6+tKDC5OH8lw=;
        b=j4eibdNmMeOkC3VIxjM0hNlU0psOSWj2WKUBTxMX+phGeXSG2nxMa5plBaQ1WP6Qm7
         C9EPhqxGKvm1f11I18YHrW1fPrPT85Ex9Rrtur1C6cZU+N0WBizqxSmnAE6aj1ND8fKY
         xY2p3Pe4a4g2Co2TSxfXip7lPwzwMsSxQETUIwmgXYVB4jT2TUDG31wP7s7O414OeI+s
         b4pDkHDue8WMqEoVmf90loVNFjPrG4Cr+lF/0E9ayc9uAH4YMOzQ90nJnmYz87AirXRx
         Au0AFwSenuxj9nxV+W6ofjdX1E8PusJ92L/k5wPljDTqk4caXOTjqX6U0IkVGEx2lfE7
         FbUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e89rzy2kz1sjc3Zo7u7dI9r9xHMFS2z6+tKDC5OH8lw=;
        b=IV48ToJkNik0/Vq4JC+4IglCGCVPiDze0X4pN5IrzbdZUXMr8mwxxprAbPNXLXeQ8a
         WnAYBcGmz9FxoHcFlzTRUVLKCugq39i9NKKj/4CndKOe/zfydTJNj68Jv+WaRkQea39F
         DEaMgksT+AKtIqkAlE+wY3GCrETNzx/ndQaN5eXa4ZrbwqdRdhTCn/szEXjyMIapKaOG
         GfRtq/HELVQ6x9XvFVUtRow+mvDcVH9ViKHZV9wsRnnqo33cdqIFemlLiMAS+xPMTebE
         +8+VgzNuXuun2m8emaODRpCnITxIFh3wR6AsGXfQxoyhFk2nhT1Nz/pqYKJ8iMTpU/l3
         xCWA==
X-Gm-Message-State: AOAM530b7zVJ6Om/vLEx+X56aO2bpTgh/TBp0cMvcxH2WS6JWahF4Mv9
        JPw7kqQ3QpRhxghUPyr0Vko7NzwoC3mHIQiW2Jw=
X-Google-Smtp-Source: ABdhPJwQZle1V7AWwRxWOaySdE6Cu+kPX1qT1bq/84iHy94ij83mvSQIVGw6BK+w2eajTzHLhdvl3D7nUIV5BLxb5Ts=
X-Received: by 2002:a25:7b81:: with SMTP id w123mr4983640ybc.260.1599854277955;
 Fri, 11 Sep 2020 12:57:57 -0700 (PDT)
MIME-Version: 1.0
References: <159981835466.134722.8652987144251743467.stgit@toke.dk> <159981835802.134722.18147008746583957688.stgit@toke.dk>
In-Reply-To: <159981835802.134722.18147008746583957688.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Sep 2020 12:57:46 -0700
Message-ID: <CAEf4Bzb=va0n3GMaYx-Kk7yCpsUK2iDMjVh2O2bm=9q-troH9A@mail.gmail.com>
Subject: Re: [PATCH RESEND bpf-next v3 3/9] bpf: wrap prog->aux->linked_prog
 in a bpf_tracing_link
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

On Fri, Sep 11, 2020 at 3:00 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The bpf_tracing_link structure is a convenient data structure to contain
> the reference to a linked program; in preparation for supporting multiple
> attachments for the same freplace program, move the linked_prog in
> prog->aux into a bpf_tracing_link wrapper.
>
> With this change, it is no longer possible to attach the same tracing
> program multiple times (detaching in-between), since the reference from t=
he
> tracing program to the target disappears on the first attach. However,
> since the next patch will let the caller supply an attach target, that wi=
ll
> also make it possible to attach to the same place multiple times.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  include/linux/bpf.h     |   21 +++++++++---
>  kernel/bpf/btf.c        |   13 +++++---
>  kernel/bpf/core.c       |    5 +--
>  kernel/bpf/syscall.c    |   81 +++++++++++++++++++++++++++++++++++++----=
------
>  kernel/bpf/trampoline.c |   12 ++-----
>  kernel/bpf/verifier.c   |   13 +++++---
>  6 files changed, 102 insertions(+), 43 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 7f19c3216370..722c60f1c1fc 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -26,6 +26,7 @@ struct bpf_verifier_log;
>  struct perf_event;
>  struct bpf_prog;
>  struct bpf_prog_aux;
> +struct bpf_tracing_link;
>  struct bpf_map;
>  struct sock;
>  struct seq_file;
> @@ -614,8 +615,8 @@ static __always_inline unsigned int bpf_dispatcher_no=
p_func(
>  }
>  #ifdef CONFIG_BPF_JIT
>  struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
> -int bpf_trampoline_link_prog(struct bpf_prog *prog);
> -int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
> +int bpf_trampoline_link_prog(struct bpf_prog *prog, struct bpf_trampolin=
e *tr);
> +int bpf_trampoline_unlink_prog(struct bpf_prog *prog, struct bpf_trampol=
ine *tr);
>  int bpf_trampoline_get(u64 key, void *addr,
>                        struct btf_func_model *fmodel,
>                        struct bpf_trampoline **trampoline);
> @@ -667,11 +668,13 @@ static inline struct bpf_trampoline *bpf_trampoline=
_lookup(u64 key)
>  {
>         return NULL;
>  }
> -static inline int bpf_trampoline_link_prog(struct bpf_prog *prog)
> +static inline int bpf_trampoline_link_prog(struct bpf_prog *prog,
> +                                          struct bpf_trampoline *tr)
>  {
>         return -ENOTSUPP;
>  }
> -static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
> +static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog,
> +                                            struct bpf_trampoline *tr)
>  {
>         return -ENOTSUPP;
>  }
> @@ -740,14 +743,13 @@ struct bpf_prog_aux {
>         u32 max_rdonly_access;
>         u32 max_rdwr_access;
>         const struct bpf_ctx_arg_aux *ctx_arg_info;
> -       struct bpf_prog *linked_prog;
> +       struct bpf_tracing_link *tgt_link;
>         bool verifier_zext; /* Zero extensions has been inserted by verif=
ier. */
>         bool offload_requested;
>         bool attach_btf_trace; /* true if attaching to BTF-enabled raw tp=
 */
>         bool func_proto_unreliable;
>         bool sleepable;
>         enum bpf_tramp_prog_type trampoline_prog_type;
> -       struct bpf_trampoline *trampoline;
>         struct hlist_node tramp_hlist;
>         /* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
>         const struct btf_type *attach_func_proto;
> @@ -827,6 +829,13 @@ struct bpf_link {
>         struct work_struct work;
>  };
>
> +struct bpf_tracing_link {
> +       struct bpf_link link;
> +       enum bpf_attach_type attach_type;
> +       struct bpf_trampoline *trampoline;
> +       struct bpf_prog *tgt_prog;
> +};
> +
>  struct bpf_link_ops {
>         void (*release)(struct bpf_link *link);
>         void (*dealloc)(struct bpf_link *link);
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 2ace56c99c36..e10f13f8251c 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3706,10 +3706,10 @@ struct btf *btf_parse_vmlinux(void)
>
>  struct btf *bpf_prog_get_target_btf(const struct bpf_prog *prog)
>  {
> -       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
> +       struct bpf_tracing_link *tgt_link =3D prog->aux->tgt_link;
>
> -       if (tgt_prog) {
> -               return tgt_prog->aux->btf;
> +       if (tgt_link && tgt_link->tgt_prog) {
> +               return tgt_link->tgt_prog->aux->btf;
>         } else {
>                 return btf_vmlinux;
>         }
> @@ -3733,14 +3733,17 @@ bool btf_ctx_access(int off, int size, enum bpf_a=
ccess_type type,
>                     struct bpf_insn_access_aux *info)
>  {
>         const struct btf_type *t =3D prog->aux->attach_func_proto;
> -       struct bpf_prog *tgt_prog =3D prog->aux->linked_prog;
>         struct btf *btf =3D bpf_prog_get_target_btf(prog);
>         const char *tname =3D prog->aux->attach_func_name;
>         struct bpf_verifier_log *log =3D info->log;
> +       struct bpf_prog *tgt_prog =3D NULL;
>         const struct btf_param *args;
>         u32 nr_args, arg;
>         int i, ret;
>
> +       if (prog->aux->tgt_link)
> +               tgt_prog =3D prog->aux->tgt_link->tgt_prog;
> +
>         if (off % 8) {
>                 bpf_log(log, "func '%s' offset %d is not multiple of 8\n"=
,
>                         tname, off);
> @@ -4572,7 +4575,7 @@ int btf_prepare_func_args(struct bpf_verifier_env *=
env, int subprog,
>                 return -EFAULT;
>         }
>         if (prog_type =3D=3D BPF_PROG_TYPE_EXT)
> -               prog_type =3D prog->aux->linked_prog->type;
> +               prog_type =3D prog->aux->tgt_link->tgt_prog->type;
>
>         t =3D btf_type_by_id(btf, t->type);
>         if (!t || !btf_type_is_func_proto(t)) {
> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> index ed0b3578867c..54c125cec218 100644
> --- a/kernel/bpf/core.c
> +++ b/kernel/bpf/core.c
> @@ -2130,7 +2130,6 @@ static void bpf_prog_free_deferred(struct work_stru=
ct *work)
>         if (aux->prog->has_callchain_buf)
>                 put_callchain_buffers();
>  #endif
> -       bpf_trampoline_put(aux->trampoline);
>         for (i =3D 0; i < aux->func_cnt; i++)
>                 bpf_jit_free(aux->func[i]);
>         if (aux->func_cnt) {
> @@ -2146,8 +2145,8 @@ void bpf_prog_free(struct bpf_prog *fp)
>  {
>         struct bpf_prog_aux *aux =3D fp->aux;
>
> -       if (aux->linked_prog)
> -               bpf_prog_put(aux->linked_prog);
> +       if (aux->tgt_link)
> +               bpf_link_put(&aux->tgt_link->link);

Until the link is primed, you shouldn't bpf_link_put() it. At this
stage the link itself is just a piece of memory that needs to be
kfree()'d. And your circular dependency problem doesn't exist anymore.
You'll have to put a trampoline and target prog manually here, though
(but you have a similar problem below as well, so might just have a
small helper to do this). But I think it's simpler that relying on an
artificial "defunct" state of not-yet-activated bpf_link, which you do
with the dance around link->prog =3D NULL.

>         INIT_WORK(&aux->work, bpf_prog_free_deferred);
>         schedule_work(&aux->work);
>  }
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 4108ef3b828b..2d238aa8962e 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2095,10 +2095,13 @@ static bool is_perfmon_prog_type(enum bpf_prog_ty=
pe prog_type)
>  /* last field in 'union bpf_attr' used by this command */
>  #define        BPF_PROG_LOAD_LAST_FIELD attach_prog_fd
>
> +static struct bpf_tracing_link *bpf_tracing_link_create(struct bpf_prog =
*prog,
> +                                                       struct bpf_prog *=
tgt_prog);
> +
>  static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *ua=
ttr)
>  {
>         enum bpf_prog_type type =3D attr->prog_type;
> -       struct bpf_prog *prog;
> +       struct bpf_prog *prog, *tgt_prog =3D NULL;
>         int err;
>         char license[128];
>         bool is_gpl;
> @@ -2154,14 +2157,27 @@ static int bpf_prog_load(union bpf_attr *attr, un=
ion bpf_attr __user *uattr)
>         prog->expected_attach_type =3D attr->expected_attach_type;
>         prog->aux->attach_btf_id =3D attr->attach_btf_id;
>         if (attr->attach_prog_fd) {
> -               struct bpf_prog *tgt_prog;
> -
>                 tgt_prog =3D bpf_prog_get(attr->attach_prog_fd);
>                 if (IS_ERR(tgt_prog)) {
>                         err =3D PTR_ERR(tgt_prog);
>                         goto free_prog_nouncharge;
>                 }
> -               prog->aux->linked_prog =3D tgt_prog;
> +       }
> +
> +       if (tgt_prog || prog->aux->attach_btf_id) {
> +               struct bpf_tracing_link *link;
> +
> +               link =3D bpf_tracing_link_create(prog, tgt_prog);
> +               if (IS_ERR(link)) {
> +                       err =3D PTR_ERR(link);
> +                       if (tgt_prog)
> +                               bpf_prog_put(tgt_prog);
> +                       goto free_prog_nouncharge;
> +               }
> +               prog->aux->tgt_link =3D link;
> +
> +               /* avoid circular ref - will be set on link activation */
> +               link->link.prog =3D NULL;

See above. I think this might work, but it's sort of an entire new
pattern for links and I'd like to avoid having to think about defunct
-> active -> defunct bpf_link state transitions. All you have to do is
clean up the not-yet-activated link appropriately, but otherwise no
unnecessary link internals manipulations are necessary.

>         }
>
>         prog->aux->offload_requested =3D !!attr->prog_ifindex;
> @@ -2495,14 +2511,21 @@ struct bpf_link *bpf_link_get_from_fd(u32 ufd)
>         return link;
>  }
>
> -struct bpf_tracing_link {
> -       struct bpf_link link;
> -       enum bpf_attach_type attach_type;
> -};
> -
>  static void bpf_tracing_link_release(struct bpf_link *link)
>  {
> -       WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog));
> +       struct bpf_tracing_link *tr_link =3D
> +               container_of(link, struct bpf_tracing_link, link);
> +
> +       if (tr_link->trampoline) {
> +               if (link->id)

this link->id check won't be necessary, as bpf_tracing_link_release
would be called only on fully constructed and activated link.

> +                       WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->pro=
g,
> +                                                               tr_link->=
trampoline));
> +
> +               bpf_trampoline_put(tr_link->trampoline);
> +       }
> +
> +       if (tr_link->tgt_prog)
> +               bpf_prog_put(tr_link->tgt_prog);
>  }
>
>  static void bpf_tracing_link_dealloc(struct bpf_link *link)
> @@ -2542,10 +2565,27 @@ static const struct bpf_link_ops bpf_tracing_link=
_lops =3D {
>         .fill_link_info =3D bpf_tracing_link_fill_link_info,
>  };
>
> +static struct bpf_tracing_link *bpf_tracing_link_create(struct bpf_prog =
*prog,
> +                                                       struct bpf_prog *=
tgt_prog)
> +{
> +       struct bpf_tracing_link *link;
> +
> +       link =3D kzalloc(sizeof(*link), GFP_USER);
> +       if (!link)
> +               return ERR_PTR(-ENOMEM);
> +
> +       bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING,
> +                     &bpf_tracing_link_lops, prog);
> +       link->attach_type =3D prog->expected_attach_type;
> +       link->tgt_prog =3D tgt_prog;
> +
> +       return link;
> +}
> +
>  static int bpf_tracing_prog_attach(struct bpf_prog *prog)
>  {
> +       struct bpf_tracing_link *link, *olink;
>         struct bpf_link_primer link_primer;
> -       struct bpf_tracing_link *link;
>         int err;
>
>         switch (prog->type) {
> @@ -2574,14 +2614,16 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog)
>                 goto out_put_prog;
>         }
>
> -       link =3D kzalloc(sizeof(*link), GFP_USER);
> +       link =3D READ_ONCE(prog->aux->tgt_link);
>         if (!link) {
> -               err =3D -ENOMEM;
> +               err =3D -ENOENT;
> +               goto out_put_prog;
> +       }
> +       olink =3D cmpxchg(&prog->aux->tgt_link, link, NULL);
> +       if (olink !=3D link) {
> +               err =3D -ENOENT;
>                 goto out_put_prog;
>         }

Wouldn't single xchg to NULL be sufficient to achieve the same?
READ_ONCE + cmpxchg seems unnecessary to me.

> -       bpf_link_init(&link->link, BPF_LINK_TYPE_TRACING,
> -                     &bpf_tracing_link_lops, prog);
> -       link->attach_type =3D prog->expected_attach_type;
>
>         err =3D bpf_link_prime(&link->link, &link_primer);
>         if (err) {

if priming errors out, you need to put target prog and trampoline,
kfree(link) won't do it (and calling bpf_link_cleanup() is not correct
before priming). See above as well.

BTW, one interesting side effect of all this is that if your initial
attach failed, you won't be able to try again, because
prog->aux->tgt_link is gone. If that's the problem, we'll need to
introduce locking and copy that link, try to attach, then clear out
prog->aug->tgt_link only if we succeeded. Just bringing this up, as it
might not be obvious (or I might be wrong :).

> @@ -2589,12 +2631,17 @@ static int bpf_tracing_prog_attach(struct bpf_pro=
g *prog)
>                 goto out_put_prog;
>         }
>
> -       err =3D bpf_trampoline_link_prog(prog);
> +       err =3D bpf_trampoline_link_prog(prog, link->trampoline);
>         if (err) {
>                 bpf_link_cleanup(&link_primer);
>                 goto out_put_prog;
>         }
>
> +       /* at this point the link is no longer referenced from struct bpf=
_prog,
> +        * so we can populate this without introducing a circular referen=
ce.
> +        */
> +       link->link.prog =3D prog;

this won't be necessary either, as per above discussion on circular depende=
ncies

> +
>         return bpf_link_settle(&link_primer);
>  out_put_prog:
>         bpf_prog_put(prog);

[...]
