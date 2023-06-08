Return-Path: <netdev+bounces-9363-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2356E7289B3
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B8DF2817D9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853A831EEE;
	Thu,  8 Jun 2023 20:54:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6901528E7;
	Thu,  8 Jun 2023 20:54:02 +0000 (UTC)
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A6518C;
	Thu,  8 Jun 2023 13:53:57 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-977e0fbd742so163487466b.2;
        Thu, 08 Jun 2023 13:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686257636; x=1688849636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Af7CkhUCF1PhD28YUiu7wrXm5a2Ll9dTdve1phMIhik=;
        b=W68kJObHtEpnEM3hQIdqJf4/f8qAeeItY3+YQxu6NfYAwhScbpxpBBfug/Ma+GyJtk
         /AHcdx5dcEfV8osRHKBHu84sBP/bgjix6Ee9Sd3+qAqXVxqQI0Tz2xvnUf2wxTK+t+ux
         rXj6AF/MuINEtbQBGT60LvE+02M8aDweJhmXt9eaHr/SqBaNFhztx0qSb46fXLxCqrG0
         UmgF0lyQjez2hlCTC3p8HJY8vetnAFdUJ055fUbHm+S8+Q2KI/IphlM72mMIztJqg5K5
         uK4EX+VBJ7ZubLAvD3+2IOmXgxyMa5MRAc0juWhzqJIDsF80V3f2uxkTKqUXV6QSfNtZ
         Vv1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686257636; x=1688849636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Af7CkhUCF1PhD28YUiu7wrXm5a2Ll9dTdve1phMIhik=;
        b=FrRNE3qsJsimkWRGDpyizUDu9EytKh8NG6kupQHgA/W5AtlDMuxQZx/7mx9loaPkjK
         rm6EeX0BiELL80RsEYU97QZCuDuQ+8LrENB+0JvIP4YlpyIdJKwUPN9Nv+2Yqk/+d4VT
         v/c7/qOs0YUov/aiVzbBTH6dqHVYHXXimGe8nqHqJbIToD+n7Q7K6xc31mb3/RW5n2My
         HnSkMPOxHJTqyDUe010hjVKXfwr9uBvuLZ8e2h8UaPeVYS/59DydXdF5yd5c5woB6G3a
         WP11pYawLPtUQviUJQQsggNQ7cLRQ7tTxZYQ2jMiOULtXOzhYCfojKycAa+eUu2eHx7p
         5ygw==
X-Gm-Message-State: AC+VfDzyxvMYSeMOstLYErXYMcpJmwVg3bYaaFVEwChQmjUxk0L2Z3Gq
	5rzs7u+JnwUNGdpWbspXQDrFqUFfNcEirKbEUcA=
X-Google-Smtp-Source: ACHHUZ41M6MKZ7BnxKpJaEi0TCccU72oO4ubRVtwe2aV9ft2v8J/EejDotTP+OO/xiPHw1GyPCcCmYODc3ecXSsK8X4=
X-Received: by 2002:a17:907:971c:b0:974:6de:8a5e with SMTP id
 jg28-20020a170907971c00b0097406de8a5emr265487ejc.40.1686257635678; Thu, 08
 Jun 2023 13:53:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
In-Reply-To: <20230607192625.22641-2-daniel@iogearbox.net>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Thu, 8 Jun 2023 13:53:43 -0700
Message-ID: <CAEf4BzbsUMnP7WMm3OmJznvD2b03B1qASFRNiDoVAU6XvvTZNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
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

On Wed, Jun 7, 2023 at 12:27=E2=80=AFPM Daniel Borkmann <daniel@iogearbox.n=
et> wrote:
>
> This adds a generic layer called bpf_mprog which can be reused by differe=
nt
> attachment layers to enable multi-program attachment and dependency resol=
ution.
> In-kernel users of the bpf_mprog don't need to care about the dependency
> resolution internals, they can just consume it with few API calls.
>
> The initial idea of having a generic API sparked out of discussion [0] fr=
om an
> earlier revision of this work where tc's priority was reused and exposed =
via
> BPF uapi as a way to coordinate dependencies among tc BPF programs, simil=
ar
> as-is for classic tc BPF. The feedback was that priority provides a bad u=
ser
> experience and is hard to use [1], e.g.:
>
>   I cannot help but feel that priority logic copy-paste from old tc, netf=
ilter
>   and friends is done because "that's how things were done in the past". =
[...]
>   Priority gets exposed everywhere in uapi all the way to bpftool when it=
's
>   right there for users to understand. And that's the main problem with i=
t.
>
>   The user don't want to and don't need to be aware of it, but uapi force=
s them
>   to pick the priority. [...] Your cover letter [0] example proves that i=
n
>   real life different service pick the same priority. They simply don't k=
now
>   any better. Priority is an unnecessary magic that apps _have_ to pick, =
so
>   they just copy-paste and everyone ends up using the same.
>
> The course of the discussion showed more and more the need for a generic,
> reusable API where the "same look and feel" can be applied for various ot=
her
> program types beyond just tc BPF, for example XDP today does not have mul=
ti-
> program support in kernel, but also there was interest around this API fo=
r
> improving management of cgroup program types. Such common multi-program
> management concept is useful for BPF management daemons or user space BPF
> applications coordinating about their attachments.
>
> Both from Cilium and Meta side [2], we've collected the following require=
ments
> for a generic attach/detach/query API for multi-progs which has been impl=
emented
> as part of this work:
>
>   - Support prog-based attach/detach and link API
>   - Dependency directives (can also be combined):
>     - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {prog,link,=
none}
>       - BPF_F_ID flag as {fd,id} toggle
>       - BPF_F_LINK flag as {prog,link} toggle
>       - If relative_{fd,id} is none, then BPF_F_BEFORE will just prepend,=
 and
>         BPF_F_AFTER will just append for the case of attaching
>       - Enforced only at attach time
>     - BPF_F_{FIRST,LAST}
>       - Enforced throughout the bpf_mprog state's lifetime
>       - Admin override possible (e.g. link detach, prog-based BPF_F_REPLA=
CE)
>   - Internal revision counter and optionally being able to pass expected_=
revision
>   - User space daemon can query current state with revision, and pass it =
along
>     for attachment to assert current state before doing updates
>   - Query also gets extension for link_ids array and link_attach_flags:
>     - prog_ids are always filled with program IDs
>     - link_ids are filled with link IDs when link was used, otherwise 0
>     - {prog,link}_attach_flags for holding {prog,link}-specific flags
>   - Must be easy to integrate/reuse for in-kernel users
>
> The uapi-side changes needed for supporting bpf_mprog are rather minimal,
> consisting of the additions of the attachment flags, revision counter, an=
d
> expanding existing union with relative_{fd,id} member.
>
> The bpf_mprog framework consists of an bpf_mprog_entry object which holds
> an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp (control-=
path
> structure). Both have been separated, so that fast-path gets efficient pa=
cking
> of bpf_prog pointers for maximum cache efficieny. Also, array has been ch=
osen
> instead of linked list or other structures to remove unnecessary indirect=
ions
> for a fast point-to-entry in tc for BPF. The bpf_mprog_entry comes as a p=
air
> via bpf_mprog_bundle so that in case of updates the peer bpf_mprog_entry
> is populated and then just swapped which avoids additional allocations th=
at
> could otherwise fail, for example, in detach case. bpf_mprog_{fp,cp} arra=
ys are
> currently static, but they could be converted to dynamic allocation if ne=
cessary
> at a point in future. Locking is deferred to the in-kernel user of bpf_mp=
rog,
> for example, in case of tcx which uses this API in the next patch, it pig=
gy-
> backs on rtnl. The nitty-gritty details are in the bpf_mprog_{replace,hea=
d_tail,
> add,del} implementation and an extensive test suite for checking all aspe=
cts
> of this API for prog-based attach/detach and link API as BPF selftests in
> this series.
>
> Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF manageme=
nt daemon.
>
>   [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@iogearbox=
.net/
>   [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=3D+DmjDR4gp5bOYZUFJQXj=
4agKFHT9CQPZBw@mail.gmail.com
>   [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_borkman=
n.pdf
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  MAINTAINERS                    |   1 +
>  include/linux/bpf_mprog.h      | 245 +++++++++++++++++
>  include/uapi/linux/bpf.h       |  37 ++-
>  kernel/bpf/Makefile            |   2 +-
>  kernel/bpf/mprog.c             | 476 +++++++++++++++++++++++++++++++++
>  tools/include/uapi/linux/bpf.h |  37 ++-
>  6 files changed, 781 insertions(+), 17 deletions(-)
>  create mode 100644 include/linux/bpf_mprog.h
>  create mode 100644 kernel/bpf/mprog.c
>

I like the API itself, I think it strikes the right balance. My
questions and comments below are mostly about specific implementation
details only.

> diff --git a/MAINTAINERS b/MAINTAINERS
> index c904dba1733b..754a9eeca0a1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3733,6 +3733,7 @@ F:        include/linux/filter.h
>  F:     include/linux/tnum.h
>  F:     kernel/bpf/core.c
>  F:     kernel/bpf/dispatcher.c
> +F:     kernel/bpf/mprog.c
>  F:     kernel/bpf/syscall.c
>  F:     kernel/bpf/tnum.c
>  F:     kernel/bpf/trampoline.c
> diff --git a/include/linux/bpf_mprog.h b/include/linux/bpf_mprog.h
> new file mode 100644
> index 000000000000..7399181d8e6c
> --- /dev/null
> +++ b/include/linux/bpf_mprog.h
> @@ -0,0 +1,245 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2023 Isovalent */
> +#ifndef __BPF_MPROG_H
> +#define __BPF_MPROG_H
> +
> +#include <linux/bpf.h>
> +
> +#define BPF_MPROG_MAX  64
> +#define BPF_MPROG_SWAP 1
> +#define BPF_MPROG_FREE 2
> +
> +struct bpf_mprog_fp {
> +       struct bpf_prog *prog;
> +};
> +
> +struct bpf_mprog_cp {
> +       struct bpf_link *link;
> +       u32 flags;
> +};
> +
> +struct bpf_mprog_entry {
> +       struct bpf_mprog_fp fp_items[BPF_MPROG_MAX] ____cacheline_aligned=
;
> +       struct bpf_mprog_cp cp_items[BPF_MPROG_MAX] ____cacheline_aligned=
;
> +       struct bpf_mprog_bundle *parent;
> +};
> +
> +struct bpf_mprog_bundle {
> +       struct bpf_mprog_entry a;
> +       struct bpf_mprog_entry b;

I get why we want a and b for bpf_mprog_fd, as we don't want to modify
"effective" array while it might be read by bpf_prog_run(). But can't
we just modify bpf_mprog_cp items in place instead of having an entire
BPF_MPROG_MAX of copies?

> +       struct rcu_head rcu;
> +       struct bpf_prog *ref;
> +       atomic_t revision;
> +};
> +
> +struct bpf_tuple {
> +       struct bpf_prog *prog;
> +       struct bpf_link *link;
> +};
> +
> +static inline struct bpf_mprog_entry *
> +bpf_mprog_peer(const struct bpf_mprog_entry *entry)
> +{
> +       if (entry =3D=3D &entry->parent->a)
> +               return &entry->parent->b;
> +       else
> +               return &entry->parent->a;
> +}
> +
> +#define bpf_mprog_foreach_tuple(entry, fp, cp, t)                      \
> +       for (fp =3D &entry->fp_items[0], cp =3D &entry->cp_items[0];     =
   \
> +            ({                                                         \
> +               t.prog =3D READ_ONCE(fp->prog);                          =
 \
> +               t.link =3D cp->link;                                     =
 \
> +               t.prog;                                                 \
> +             });                                                       \
> +            fp++, cp++)
> +
> +#define bpf_mprog_foreach_prog(entry, fp, p)                           \
> +       for (fp =3D &entry->fp_items[0];                                 =
 \
> +            (p =3D READ_ONCE(fp->prog));                                =
 \
> +            fp++)
> +
> +static inline struct bpf_mprog_entry *bpf_mprog_create(size_t extra_size=
)
> +{
> +       struct bpf_mprog_bundle *bundle;
> +
> +       /* Fast-path items are not extensible, must only contain prog poi=
nter! */
> +       BUILD_BUG_ON(sizeof(bundle->a.fp_items[0]) > sizeof(u64));
> +       /* Control-path items can be extended w/o affecting fast-path. */
> +       BUILD_BUG_ON(ARRAY_SIZE(bundle->a.fp_items) !=3D ARRAY_SIZE(bundl=
e->a.cp_items));
> +
> +       bundle =3D kzalloc(sizeof(*bundle) + extra_size, GFP_KERNEL);
> +       if (bundle) {
> +               atomic_set(&bundle->revision, 1);
> +               bundle->a.parent =3D bundle;
> +               bundle->b.parent =3D bundle;
> +               return &bundle->a;
> +       }
> +       return NULL;
> +}
> +
> +static inline void bpf_mprog_free(struct bpf_mprog_entry *entry)
> +{
> +       kfree_rcu(entry->parent, rcu);
> +}
> +
> +static inline void bpf_mprog_mark_ref(struct bpf_mprog_entry *entry,
> +                                     struct bpf_prog *prog)
> +{
> +       WARN_ON_ONCE(entry->parent->ref);
> +       entry->parent->ref =3D prog;
> +}
> +
> +static inline u32 bpf_mprog_flags(u32 cur_flags, u32 req_flags, u32 flag=
)
> +{
> +       if (req_flags & flag)
> +               cur_flags |=3D flag;
> +       else
> +               cur_flags &=3D ~flag;
> +       return cur_flags;
> +}
> +
> +static inline u32 bpf_mprog_max(void)
> +{
> +       return ARRAY_SIZE(((struct bpf_mprog_entry *)NULL)->fp_items) - 1=
;
> +}
> +
> +static inline struct bpf_prog *bpf_mprog_first(struct bpf_mprog_entry *e=
ntry)
> +{
> +       return READ_ONCE(entry->fp_items[0].prog);
> +}
> +
> +static inline struct bpf_prog *bpf_mprog_last(struct bpf_mprog_entry *en=
try)
> +{
> +       struct bpf_prog *tmp, *prog =3D NULL;
> +       struct bpf_mprog_fp *fp;
> +
> +       bpf_mprog_foreach_prog(entry, fp, tmp)
> +               prog =3D tmp;
> +       return prog;
> +}
> +
> +static inline bool bpf_mprog_exists(struct bpf_mprog_entry *entry,
> +                                   struct bpf_prog *prog)
> +{
> +       const struct bpf_mprog_fp *fp;
> +       const struct bpf_prog *tmp;
> +
> +       bpf_mprog_foreach_prog(entry, fp, tmp) {
> +               if (tmp =3D=3D prog)
> +                       return true;
> +       }
> +       return false;
> +}
> +
> +static inline struct bpf_prog *bpf_mprog_first_reg(struct bpf_mprog_entr=
y *entry)
> +{
> +       struct bpf_tuple tuple =3D {};
> +       struct bpf_mprog_fp *fp;
> +       struct bpf_mprog_cp *cp;
> +
> +       bpf_mprog_foreach_tuple(entry, fp, cp, tuple) {
> +               if (cp->flags & BPF_F_FIRST)
> +                       continue;
> +               return tuple.prog;
> +       }
> +       return NULL;
> +}
> +
> +static inline struct bpf_prog *bpf_mprog_last_reg(struct bpf_mprog_entry=
 *entry)
> +{
> +       struct bpf_tuple tuple =3D {};
> +       struct bpf_prog *prog =3D NULL;
> +       struct bpf_mprog_fp *fp;
> +       struct bpf_mprog_cp *cp;
> +
> +       bpf_mprog_foreach_tuple(entry, fp, cp, tuple) {
> +               if (cp->flags & BPF_F_LAST)
> +                       break;
> +               prog =3D tuple.prog;
> +       }
> +       return prog;
> +}
> +
> +static inline void bpf_mprog_commit(struct bpf_mprog_entry *entry)
> +{
> +       do {
> +               atomic_inc(&entry->parent->revision);
> +       } while (atomic_read(&entry->parent->revision) =3D=3D 0);

why not just use atomic64_t and never care about zero wrap-around?

> +       synchronize_rcu();
> +       if (entry->parent->ref) {
> +               bpf_prog_put(entry->parent->ref);
> +               entry->parent->ref =3D NULL;
> +       }
> +}
> +
> +static inline void bpf_mprog_entry_clear(struct bpf_mprog_entry *entry)
> +{
> +       memset(entry->fp_items, 0, sizeof(entry->fp_items));
> +       memset(entry->cp_items, 0, sizeof(entry->cp_items));
> +}
> +
> +static inline u64 bpf_mprog_revision(struct bpf_mprog_entry *entry)
> +{
> +       return atomic_read(&entry->parent->revision);
> +}
> +
> +static inline void bpf_mprog_read(struct bpf_mprog_entry *entry, u32 whi=
ch,
> +                                 struct bpf_mprog_fp **fp_dst,
> +                                 struct bpf_mprog_cp **cp_dst)
> +{
> +       *fp_dst =3D &entry->fp_items[which];
> +       *cp_dst =3D &entry->cp_items[which];
> +}
> +
> +static inline void bpf_mprog_write(struct bpf_mprog_fp *fp_dst,
> +                                  struct bpf_mprog_cp *cp_dst,
> +                                  struct bpf_tuple *tuple, u32 flags)
> +{
> +       WRITE_ONCE(fp_dst->prog, tuple->prog);
> +       cp_dst->link  =3D tuple->link;
> +       cp_dst->flags =3D flags;
> +}
> +
> +static inline void bpf_mprog_copy(struct bpf_mprog_fp *fp_dst,
> +                                 struct bpf_mprog_cp *cp_dst,
> +                                 struct bpf_mprog_fp *fp_src,
> +                                 struct bpf_mprog_cp *cp_src)
> +{
> +       WRITE_ONCE(fp_dst->prog, READ_ONCE(fp_src->prog));
> +       memcpy(cp_dst, cp_src, sizeof(*cp_src));
> +}
> +
> +static inline void bpf_mprog_copy_range(struct bpf_mprog_entry *peer,
> +                                       struct bpf_mprog_entry *entry,

it's not clear what is source and what is destination, why not just
use "src" and "dst" naming?

> +                                       u32 idx_peer, u32 idx_entry, u32 =
num)
> +{
> +       memcpy(&peer->fp_items[idx_peer], &entry->fp_items[idx_entry],
> +              num * sizeof(peer->fp_items[0]));
> +       memcpy(&peer->cp_items[idx_peer], &entry->cp_items[idx_entry],
> +              num * sizeof(peer->cp_items[0]));
> +}
> +
> +static inline u32 bpf_mprog_total(struct bpf_mprog_entry *entry)
> +{
> +       const struct bpf_mprog_fp *fp;
> +       const struct bpf_prog *tmp;
> +       u32 num =3D 0;
> +
> +       bpf_mprog_foreach_prog(entry, fp, tmp)
> +               num++;
> +       return num;
> +}
> +
> +int bpf_mprog_attach(struct bpf_mprog_entry *entry, struct bpf_prog *pro=
g,
> +                    struct bpf_link *link, u32 flags, u32 object,
> +                    u32 expected_revision);
> +int bpf_mprog_detach(struct bpf_mprog_entry *entry, struct bpf_prog *pro=
g,
> +                    struct bpf_link *link, u32 flags, u32 object,
> +                    u32 expected_revision);
> +
> +int bpf_mprog_query(const union bpf_attr *attr, union bpf_attr __user *u=
attr,
> +                   struct bpf_mprog_entry *entry);
> +
> +#endif /* __BPF_MPROG_H */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a7b5e91dd768..207f8a37b327 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1102,7 +1102,14 @@ enum bpf_link_type {
>   */
>  #define BPF_F_ALLOW_OVERRIDE   (1U << 0)
>  #define BPF_F_ALLOW_MULTI      (1U << 1)
> +/* Generic attachment flags. */
>  #define BPF_F_REPLACE          (1U << 2)
> +#define BPF_F_BEFORE           (1U << 3)
> +#define BPF_F_AFTER            (1U << 4)
> +#define BPF_F_FIRST            (1U << 5)
> +#define BPF_F_LAST             (1U << 6)
> +#define BPF_F_ID               (1U << 7)
> +#define BPF_F_LINK             BPF_F_LINK /* 1 << 13 */
>
>  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
>   * verifier will perform strict alignment checking as if the kernel
> @@ -1433,14 +1440,19 @@ union bpf_attr {
>         };
>
>         struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH comma=
nds */
> -               __u32           target_fd;      /* container object to at=
tach to */
> -               __u32           attach_bpf_fd;  /* eBPF program to attach=
 */
> +               union {
> +                       __u32   target_fd;      /* target object to attac=
h to or ... */
> +                       __u32   target_ifindex; /* target ifindex */
> +               };
> +               __u32           attach_bpf_fd;
>                 __u32           attach_type;
>                 __u32           attach_flags;
> -               __u32           replace_bpf_fd; /* previously attached eB=
PF
> -                                                * program to replace if
> -                                                * BPF_F_REPLACE is used
> -                                                */
> +               union {
> +                       __u32   relative_fd;
> +                       __u32   relative_id;
> +                       __u32   replace_bpf_fd;
> +               };
> +               __u32           expected_revision;
>         };
>
>         struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
> @@ -1486,16 +1498,25 @@ union bpf_attr {
>         } info;
>
>         struct { /* anonymous struct used by BPF_PROG_QUERY command */
> -               __u32           target_fd;      /* container object to qu=
ery */
> +               union {
> +                       __u32   target_fd;      /* target object to query=
 or ... */
> +                       __u32   target_ifindex; /* target ifindex */
> +               };
>                 __u32           attach_type;
>                 __u32           query_flags;
>                 __u32           attach_flags;
>                 __aligned_u64   prog_ids;
> -               __u32           prog_cnt;
> +               union {
> +                       __u32   prog_cnt;
> +                       __u32   count;
> +               };
> +               __u32           revision;
>                 /* output: per-program attach_flags.
>                  * not allowed to be set during effective query.
>                  */
>                 __aligned_u64   prog_attach_flags;
> +               __aligned_u64   link_ids;
> +               __aligned_u64   link_attach_flags;

flags are 32-bit, no?

>         } query;
>
>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN comm=
and */
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 1d3892168d32..1bea2eb912cd 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -12,7 +12,7 @@ obj-$(CONFIG_BPF_SYSCALL) +=3D hashtab.o arraymap.o per=
cpu_freelist.o bpf_lru_list
>  obj-$(CONFIG_BPF_SYSCALL) +=3D local_storage.o queue_stack_maps.o ringbu=
f.o
>  obj-$(CONFIG_BPF_SYSCALL) +=3D bpf_local_storage.o bpf_task_storage.o
>  obj-${CONFIG_BPF_LSM}    +=3D bpf_inode_storage.o
> -obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o
> +obj-$(CONFIG_BPF_SYSCALL) +=3D disasm.o mprog.o
>  obj-$(CONFIG_BPF_JIT) +=3D trampoline.o
>  obj-$(CONFIG_BPF_SYSCALL) +=3D btf.o memalloc.o
>  obj-$(CONFIG_BPF_JIT) +=3D dispatcher.o
> diff --git a/kernel/bpf/mprog.c b/kernel/bpf/mprog.c
> new file mode 100644
> index 000000000000..efc3b73f8bf5
> --- /dev/null
> +++ b/kernel/bpf/mprog.c
> @@ -0,0 +1,476 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2023 Isovalent */
> +
> +#include <linux/bpf.h>
> +#include <linux/bpf_mprog.h>
> +#include <linux/filter.h>
> +
> +static int bpf_mprog_tuple_relative(struct bpf_tuple *tuple,
> +                                   u32 object, u32 flags,
> +                                   enum bpf_prog_type type)
> +{
> +       struct bpf_prog *prog;
> +       struct bpf_link *link;
> +
> +       memset(tuple, 0, sizeof(*tuple));
> +       if (!(flags & (BPF_F_REPLACE | BPF_F_BEFORE | BPF_F_AFTER)))
> +               return object || (flags & (BPF_F_ID | BPF_F_LINK)) ?
> +                      -EINVAL : 0;
> +       if (flags & BPF_F_LINK) {
> +               if (flags & BPF_F_ID)
> +                       link =3D bpf_link_by_id(object);
> +               else
> +                       link =3D bpf_link_get_from_fd(object);
> +               if (IS_ERR(link))
> +                       return PTR_ERR(link);
> +               if (type && link->prog->type !=3D type) {
> +                       bpf_link_put(link);
> +                       return -EINVAL;
> +               }
> +               tuple->link =3D link;
> +               tuple->prog =3D link->prog;
> +       } else {
> +               if (flags & BPF_F_ID)
> +                       prog =3D bpf_prog_by_id(object);
> +               else
> +                       prog =3D bpf_prog_get(object);
> +               if (IS_ERR(prog)) {
> +                       if (!object &&
> +                           !(flags & BPF_F_ID))
> +                               return 0;
> +                       return PTR_ERR(prog);
> +               }
> +               if (type && prog->type !=3D type) {
> +                       bpf_prog_put(prog);
> +                       return -EINVAL;
> +               }
> +               tuple->link =3D NULL;
> +               tuple->prog =3D prog;
> +       }
> +       return 0;
> +}
> +
> +static void bpf_mprog_tuple_put(struct bpf_tuple *tuple)
> +{
> +       if (tuple->link)
> +               bpf_link_put(tuple->link);
> +       else if (tuple->prog)
> +               bpf_prog_put(tuple->prog);
> +}
> +
> +static int bpf_mprog_replace(struct bpf_mprog_entry *entry,
> +                            struct bpf_tuple *ntuple,
> +                            struct bpf_tuple *rtuple, u32 rflags)
> +{
> +       struct bpf_mprog_fp *fp;
> +       struct bpf_mprog_cp *cp;
> +       struct bpf_prog *oprog;
> +       u32 iflags;
> +       int i;
> +
> +       if (rflags & (BPF_F_BEFORE | BPF_F_AFTER | BPF_F_LINK))
> +               return -EINVAL;
> +       if (rtuple->prog !=3D ntuple->prog &&
> +           bpf_mprog_exists(entry, ntuple->prog))
> +               return -EEXIST;
> +       for (i =3D 0; i < bpf_mprog_max(); i++) {

why not just keep track of actual count in bpf_mprob_bundle? that will
speed up bpf_mprog_last() as well

> +               bpf_mprog_read(entry, i, &fp, &cp);
> +               oprog =3D READ_ONCE(fp->prog);
> +               if (!oprog)
> +                       break;
> +               if (oprog !=3D rtuple->prog)
> +                       continue;
> +               if (cp->link !=3D ntuple->link)
> +                       return -EBUSY;
> +               iflags =3D cp->flags;
> +               if ((iflags & BPF_F_FIRST) !=3D
> +                   (rflags & BPF_F_FIRST)) {
> +                       iflags =3D bpf_mprog_flags(iflags, rflags,
> +                                                BPF_F_FIRST);
> +                       if ((iflags & BPF_F_FIRST) &&
> +                           rtuple->prog !=3D bpf_mprog_first(entry))
> +                               return -EACCES;
> +               }
> +               if ((iflags & BPF_F_LAST) !=3D
> +                   (rflags & BPF_F_LAST)) {
> +                       iflags =3D bpf_mprog_flags(iflags, rflags,
> +                                                BPF_F_LAST);
> +                       if ((iflags & BPF_F_LAST) &&
> +                           rtuple->prog !=3D bpf_mprog_last(entry))
> +                               return -EACCES;
> +               }
> +               bpf_mprog_write(fp, cp, ntuple, iflags);
> +               if (!ntuple->link)
> +                       bpf_prog_put(oprog);
> +               return 0;
> +       }
> +       return -ENOENT;
> +}
> +

[...]

> +
> +int bpf_mprog_attach(struct bpf_mprog_entry *entry, struct bpf_prog *pro=
g,
> +                    struct bpf_link *link, u32 flags, u32 object,
> +                    u32 expected_revision)
> +{
> +       struct bpf_tuple rtuple, ntuple =3D {
> +               .prog =3D prog,
> +               .link =3D link,
> +       };
> +       int ret;
> +
> +       if (expected_revision &&
> +           expected_revision !=3D bpf_mprog_revision(entry))
> +               return -ESTALE;
> +       ret =3D bpf_mprog_tuple_relative(&rtuple, object, flags, prog->ty=
pe);
> +       if (ret)
> +               return ret;
> +       if (flags & BPF_F_REPLACE)
> +               ret =3D bpf_mprog_replace(entry, &ntuple, &rtuple, flags)=
;
> +       else if (flags & (BPF_F_FIRST | BPF_F_LAST))
> +               ret =3D bpf_mprog_head_tail(entry, &ntuple, &rtuple, flag=
s);
> +       else
> +               ret =3D bpf_mprog_add(entry, &ntuple, &rtuple, flags);
> +       bpf_mprog_tuple_put(&rtuple);
> +       return ret;
> +}

We chatted about this a bit offline, but let me expand a bit on this
in writing. I still find the need to have mprog_add, mprog_head_tail
and mprog_replace variants a bit unnecessary. Especially that each of
them kind of reimplements all these BEFORE/AFTER and FIRST/LAST
constraints each time.

I was thinking if it would be more straightforward to evaluate target
position for the prog/link that needs to be replaced/inserted/deleted
for each "rule" independently. And if all rules agree on that position
or existing element, then enact replacement/addition/deletion.
Something like below, in very pseudo-code-like manner:

int idx =3D -1, tidx;

if (flag & BPF_F_REPLACE) {
    tidx =3D mprog_pos_exact(object, flags);
    if (tidx < 0 || (idx >=3D 0 && tidx !=3D idx))
        return -EINVAL;
    idx =3D tidx;
}
if (flag & BPF_F_BEFORE) {
    tidx =3D mprog_pos_before(object, flags);
    if (tidx < 0 || (idx >=3D 0 && tidx !=3D idx))
        return -EINVAL;
    idx =3D tidx;
}
if (flag & BPF_F_AFTER) {
    tidx =3D mprog_pos_after(object, flags);
    if (tidx < 0 || (idx >=3D 0 && tidx !=3D idx))
        return -EINVAL;
    idx =3D tidx;
}
if (flag & BPF_F_FIRST) {
    if (idx >=3D 0 && idx !=3D 0)
        return -EINVAL;
    idx =3D 0;
    if (idx < bpf_mprog_cnt() && (prog_flag_at(idx) & BPF_F_FIRST))
        return -EBUSY;
}
if (flag & BPF_F_LAST) {
    if (idx >=3D 0 && idx !=3D bpf_mprog_cnt())
        return -EINVAL;
    idx =3D bpf_mprog_cnt();
    if (idx < bpf_mprog_cnt() && (prog_flag_at(idx) & BPF_F_LAST))
        return -EBUSY;
}

if (flag & BPF_F_REPLACE)
   replace_in_place(idx, flags & (BPF_F_FIRST | BPF_F_LAST));
else /* if delete */
   delete_at_pos(idx);
else /* add new element */
   insert_at_pos(idx, flags & (BPF_F_FIRST | BPF_F_LAST));

Each of those mprog_pos_{exact,before,after} should be trivial to
implement (they will just find position that satisfies one of those
conditions). idx will mean either position at which we need to insert
new element (and so everything at that position and to the right
should be shifted), or if it's a replacement/deletion where we expect
to find existing prog/link, we'll have to find matching element there.

I guess REPLACE and BEFORE/AFTER are currently fundamentally
incompatible because they reuse the same field to specify FD/ID, so
we'd have to check that both are not specified at the same time. Or we
can choose to have separate replace_fd and relative_fd/id. And then
you could even express "replace prog if it's before another prog X",
similarly how you can express REPLACE + FIRST (replace if it's first).

You mentioned actual implementation gets hard, so I'm curious which
parts with such approach are becoming convoluted in actual
implementation?


> +
> +int bpf_mprog_detach(struct bpf_mprog_entry *entry, struct bpf_prog *pro=
g,
> +                    struct bpf_link *link, u32 flags, u32 object,
> +                    u32 expected_revision)
> +{
> +       struct bpf_tuple rtuple, dtuple =3D {
> +               .prog =3D prog,
> +               .link =3D link,
> +       };
> +       int ret;
> +
> +       if (expected_revision &&
> +           expected_revision !=3D bpf_mprog_revision(entry))
> +               return -ESTALE;
> +       ret =3D bpf_mprog_tuple_relative(&rtuple, object, flags,
> +                                      prog ? prog->type :
> +                                      BPF_PROG_TYPE_UNSPEC);
> +       if (ret)
> +               return ret;
> +       ret =3D bpf_mprog_del(entry, &dtuple, &rtuple, flags);
> +       bpf_mprog_tuple_put(&rtuple);
> +       return ret;
> +}
> +



[...]

