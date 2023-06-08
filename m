Return-Path: <netdev+bounces-9305-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FA9972863F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:24:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFD0728175C
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DD8219E42;
	Thu,  8 Jun 2023 17:24:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1DE1990B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:24:07 +0000 (UTC)
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669C52D48
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:24:02 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53f6f7d1881so635825a12.3
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 10:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686245042; x=1688837042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jM+prdx+FqUuxV0QwSaQztLjuLHXcG8jiQSKLwXQIeo=;
        b=og3bzgoP72xMu4VhmDWkXBusaYF+ODBoz61cBfluFP/EYXyysfu23dfvtL+oSelbZ5
         dAoVRHf/LOEqR/87h+OEEM7QEaEU5FTnmjPUhcU/rqaAm8gg3xkRtNVl62PScznQXfDw
         H7PBfF0LHO2iNU4weTsnqczcGRUHLVHshYiq7z6UkD6pFj9QDFMbRF++ERpVsZemEYO/
         3WCnalo822IwxS6Be4EpV9u71I9xFE9Ig6QZe5n+8syiiJpIIE2GAAEDhjltu7d9SBaq
         3BkM5qEF90qXUKxpWxNWINDjEQQd+rRuDlvUiQbAHGxGosirs5AyyU2w4AtSKLGcf4nS
         KYHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686245042; x=1688837042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jM+prdx+FqUuxV0QwSaQztLjuLHXcG8jiQSKLwXQIeo=;
        b=FIjfI79/Rdn2E5GqqWVCkmgJEHnG6q0d3iT9BXq5fcOYG0VXoQ62kKpFXk19jHCTBG
         L0P5NPiVQ8FyBmx2xRKMEwAWVEnaAzS5MlROajdwKNIcJr/MT5HXSRnxGYVqopIe5L87
         dAbN8x18Dgq7jlXz8O6q8Dvr3/dvAlp3rnAQ1zat3CAdjZXYpQ9480ah4P9uvLvgTtSP
         OIROCfJkaTZZF4Fcj8N3CoJLKUfwHpNfBcAt2/8x0q1kN3YSyUyxbp60BBThw4hTBxuo
         RpQ6NL5Qxmkjm5glypwgcglxLg8x6r4ktkHQJFSXjZb3GzOR/mfhGU2cNRq5pr3UO4oS
         rL3g==
X-Gm-Message-State: AC+VfDyWjrlij4Zmzo0Bm6X4/uzmUH5fopo0wyVrOJDGpO9rfT9H8RH5
	6WhfwSraFxat4qzNwBXHy0ra/Tw=
X-Google-Smtp-Source: ACHHUZ7vN9JNknY+a/jsZk8WKQGiGdzU9eU51SdN5Ki+ApAVIuTGcMT9Svt4FyQABcG62d6zwcGLyCY=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a63:d113:0:b0:53f:2d21:5a16 with SMTP id
 k19-20020a63d113000000b0053f2d215a16mr28429pgg.10.1686245041718; Thu, 08 Jun
 2023 10:24:01 -0700 (PDT)
Date: Thu, 8 Jun 2023 10:23:59 -0700
In-Reply-To: <20230607192625.22641-2-daniel@iogearbox.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230607192625.22641-1-daniel@iogearbox.net> <20230607192625.22641-2-daniel@iogearbox.net>
Message-ID: <ZIIOr1zvdRNTFKR7@google.com>
Subject: Re: [PATCH bpf-next v2 1/7] bpf: Add generic attach/detach/query API
 for multi-progs
From: Stanislav Fomichev <sdf@google.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: ast@kernel.org, andrii@kernel.org, martin.lau@linux.dev, 
	razor@blackwall.org, john.fastabend@gmail.com, kuba@kernel.org, dxu@dxuuu.xyz, 
	joe@cilium.io, toke@kernel.org, davem@davemloft.net, bpf@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/07, Daniel Borkmann wrote:
> This adds a generic layer called bpf_mprog which can be reused by different
> attachment layers to enable multi-program attachment and dependency resolution.
> In-kernel users of the bpf_mprog don't need to care about the dependency
> resolution internals, they can just consume it with few API calls.
> 
> The initial idea of having a generic API sparked out of discussion [0] from an
> earlier revision of this work where tc's priority was reused and exposed via
> BPF uapi as a way to coordinate dependencies among tc BPF programs, similar
> as-is for classic tc BPF. The feedback was that priority provides a bad user
> experience and is hard to use [1], e.g.:
> 
>   I cannot help but feel that priority logic copy-paste from old tc, netfilter
>   and friends is done because "that's how things were done in the past". [...]
>   Priority gets exposed everywhere in uapi all the way to bpftool when it's
>   right there for users to understand. And that's the main problem with it.
> 
>   The user don't want to and don't need to be aware of it, but uapi forces them
>   to pick the priority. [...] Your cover letter [0] example proves that in
>   real life different service pick the same priority. They simply don't know
>   any better. Priority is an unnecessary magic that apps _have_ to pick, so
>   they just copy-paste and everyone ends up using the same.
> 
> The course of the discussion showed more and more the need for a generic,
> reusable API where the "same look and feel" can be applied for various other
> program types beyond just tc BPF, for example XDP today does not have multi-
> program support in kernel, but also there was interest around this API for
> improving management of cgroup program types. Such common multi-program
> management concept is useful for BPF management daemons or user space BPF
> applications coordinating about their attachments.
> 
> Both from Cilium and Meta side [2], we've collected the following requirements
> for a generic attach/detach/query API for multi-progs which has been implemented
> as part of this work:
> 
>   - Support prog-based attach/detach and link API
>   - Dependency directives (can also be combined):
>     - BPF_F_{BEFORE,AFTER} with relative_{fd,id} which can be {prog,link,none}
>       - BPF_F_ID flag as {fd,id} toggle
>       - BPF_F_LINK flag as {prog,link} toggle
>       - If relative_{fd,id} is none, then BPF_F_BEFORE will just prepend, and
>         BPF_F_AFTER will just append for the case of attaching
>       - Enforced only at attach time
>     - BPF_F_{FIRST,LAST}
>       - Enforced throughout the bpf_mprog state's lifetime
>       - Admin override possible (e.g. link detach, prog-based BPF_F_REPLACE)
>   - Internal revision counter and optionally being able to pass expected_revision
>   - User space daemon can query current state with revision, and pass it along
>     for attachment to assert current state before doing updates
>   - Query also gets extension for link_ids array and link_attach_flags:
>     - prog_ids are always filled with program IDs
>     - link_ids are filled with link IDs when link was used, otherwise 0
>     - {prog,link}_attach_flags for holding {prog,link}-specific flags
>   - Must be easy to integrate/reuse for in-kernel users
> 
> The uapi-side changes needed for supporting bpf_mprog are rather minimal,
> consisting of the additions of the attachment flags, revision counter, and
> expanding existing union with relative_{fd,id} member.
> 
> The bpf_mprog framework consists of an bpf_mprog_entry object which holds
> an array of bpf_mprog_fp (fast-path structure) and bpf_mprog_cp (control-path
> structure). Both have been separated, so that fast-path gets efficient packing
> of bpf_prog pointers for maximum cache efficieny. Also, array has been chosen
> instead of linked list or other structures to remove unnecessary indirections
> for a fast point-to-entry in tc for BPF. The bpf_mprog_entry comes as a pair
> via bpf_mprog_bundle so that in case of updates the peer bpf_mprog_entry
> is populated and then just swapped which avoids additional allocations that
> could otherwise fail, for example, in detach case. bpf_mprog_{fp,cp} arrays are
> currently static, but they could be converted to dynamic allocation if necessary
> at a point in future. Locking is deferred to the in-kernel user of bpf_mprog,
> for example, in case of tcx which uses this API in the next patch, it piggy-
> backs on rtnl. The nitty-gritty details are in the bpf_mprog_{replace,head_tail,
> add,del} implementation and an extensive test suite for checking all aspects
> of this API for prog-based attach/detach and link API as BPF selftests in
> this series.
> 
> Kudos also to Andrii Nakryiko for API discussions wrt Meta's BPF management daemon.
> 
>   [0] https://lore.kernel.org/bpf/20221004231143.19190-1-daniel@iogearbox.net/
>   [1] https://lore.kernel.org/bpf/CAADnVQ+gEY3FjCR=+DmjDR4gp5bOYZUFJQXj4agKFHT9CQPZBw@mail.gmail.com
>   [2] http://vger.kernel.org/bpfconf2023_material/tcx_meta_netdev_borkmann.pdf
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
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c904dba1733b..754a9eeca0a1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3733,6 +3733,7 @@ F:	include/linux/filter.h
>  F:	include/linux/tnum.h
>  F:	kernel/bpf/core.c
>  F:	kernel/bpf/dispatcher.c
> +F:	kernel/bpf/mprog.c
>  F:	kernel/bpf/syscall.c
>  F:	kernel/bpf/tnum.c
>  F:	kernel/bpf/trampoline.c
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
> +#define BPF_MPROG_MAX	64
> +#define BPF_MPROG_SWAP	1
> +#define BPF_MPROG_FREE	2
> +
> +struct bpf_mprog_fp {
> +	struct bpf_prog *prog;
> +};
> +
> +struct bpf_mprog_cp {
> +	struct bpf_link *link;
> +	u32 flags;
> +};
> +
> +struct bpf_mprog_entry {
> +	struct bpf_mprog_fp fp_items[BPF_MPROG_MAX] ____cacheline_aligned;
> +	struct bpf_mprog_cp cp_items[BPF_MPROG_MAX] ____cacheline_aligned;
> +	struct bpf_mprog_bundle *parent;
> +};
> +
> +struct bpf_mprog_bundle {
> +	struct bpf_mprog_entry a;
> +	struct bpf_mprog_entry b;
> +	struct rcu_head rcu;
> +	struct bpf_prog *ref;
> +	atomic_t revision;
> +};
> +
> +struct bpf_tuple {
> +	struct bpf_prog *prog;
> +	struct bpf_link *link;
> +};
> +
> +static inline struct bpf_mprog_entry *
> +bpf_mprog_peer(const struct bpf_mprog_entry *entry)
> +{
> +	if (entry == &entry->parent->a)
> +		return &entry->parent->b;
> +	else
> +		return &entry->parent->a;
> +}
> +
> +#define bpf_mprog_foreach_tuple(entry, fp, cp, t)			\
> +	for (fp = &entry->fp_items[0], cp = &entry->cp_items[0];	\
> +	     ({								\
> +		t.prog = READ_ONCE(fp->prog);				\
> +		t.link = cp->link;					\
> +		t.prog;							\
> +	      });							\
> +	     fp++, cp++)
> +
> +#define bpf_mprog_foreach_prog(entry, fp, p)				\
> +	for (fp = &entry->fp_items[0];					\
> +	     (p = READ_ONCE(fp->prog));					\
> +	     fp++)
> +
> +static inline struct bpf_mprog_entry *bpf_mprog_create(size_t extra_size)
> +{
> +	struct bpf_mprog_bundle *bundle;
> +
> +	/* Fast-path items are not extensible, must only contain prog pointer! */
> +	BUILD_BUG_ON(sizeof(bundle->a.fp_items[0]) > sizeof(u64));
> +	/* Control-path items can be extended w/o affecting fast-path. */
> +	BUILD_BUG_ON(ARRAY_SIZE(bundle->a.fp_items) != ARRAY_SIZE(bundle->a.cp_items));
> +
> +	bundle = kzalloc(sizeof(*bundle) + extra_size, GFP_KERNEL);
> +	if (bundle) {
> +		atomic_set(&bundle->revision, 1);
> +		bundle->a.parent = bundle;
> +		bundle->b.parent = bundle;
> +		return &bundle->a;
> +	}
> +	return NULL;
> +}
> +
> +static inline void bpf_mprog_free(struct bpf_mprog_entry *entry)
> +{
> +	kfree_rcu(entry->parent, rcu);
> +}
> +
> +static inline void bpf_mprog_mark_ref(struct bpf_mprog_entry *entry,
> +				      struct bpf_prog *prog)
> +{
> +	WARN_ON_ONCE(entry->parent->ref);
> +	entry->parent->ref = prog;
> +}
> +
> +static inline u32 bpf_mprog_flags(u32 cur_flags, u32 req_flags, u32 flag)
> +{
> +	if (req_flags & flag)
> +		cur_flags |= flag;
> +	else
> +		cur_flags &= ~flag;
> +	return cur_flags;
> +}
> +
> +static inline u32 bpf_mprog_max(void)
> +{
> +	return ARRAY_SIZE(((struct bpf_mprog_entry *)NULL)->fp_items) - 1;
> +}
> +
> +static inline struct bpf_prog *bpf_mprog_first(struct bpf_mprog_entry *entry)
> +{
> +	return READ_ONCE(entry->fp_items[0].prog);
> +}
> +
> +static inline struct bpf_prog *bpf_mprog_last(struct bpf_mprog_entry *entry)
> +{
> +	struct bpf_prog *tmp, *prog = NULL;
> +	struct bpf_mprog_fp *fp;
> +
> +	bpf_mprog_foreach_prog(entry, fp, tmp)
> +		prog = tmp;
> +	return prog;
> +}
> +
> +static inline bool bpf_mprog_exists(struct bpf_mprog_entry *entry,
> +				    struct bpf_prog *prog)
> +{
> +	const struct bpf_mprog_fp *fp;
> +	const struct bpf_prog *tmp;
> +
> +	bpf_mprog_foreach_prog(entry, fp, tmp) {
> +		if (tmp == prog)
> +			return true;
> +	}
> +	return false;
> +}
> +
> +static inline struct bpf_prog *bpf_mprog_first_reg(struct bpf_mprog_entry *entry)
> +{
> +	struct bpf_tuple tuple = {};
> +	struct bpf_mprog_fp *fp;
> +	struct bpf_mprog_cp *cp;
> +
> +	bpf_mprog_foreach_tuple(entry, fp, cp, tuple) {
> +		if (cp->flags & BPF_F_FIRST)
> +			continue;
> +		return tuple.prog;
> +	}
> +	return NULL;
> +}
> +
> +static inline struct bpf_prog *bpf_mprog_last_reg(struct bpf_mprog_entry *entry)
> +{
> +	struct bpf_tuple tuple = {};
> +	struct bpf_prog *prog = NULL;
> +	struct bpf_mprog_fp *fp;
> +	struct bpf_mprog_cp *cp;
> +
> +	bpf_mprog_foreach_tuple(entry, fp, cp, tuple) {
> +		if (cp->flags & BPF_F_LAST)
> +			break;
> +		prog = tuple.prog;
> +	}
> +	return prog;
> +}
> +
> +static inline void bpf_mprog_commit(struct bpf_mprog_entry *entry)
> +{

[..]

> +	do {
> +		atomic_inc(&entry->parent->revision);
> +	} while (atomic_read(&entry->parent->revision) == 0);

Can you explain more what's going on here? Maybe with a comment?

> +	synchronize_rcu();
> +	if (entry->parent->ref) {
> +		bpf_prog_put(entry->parent->ref);
> +		entry->parent->ref = NULL;
> +	}

I'm assuming this is to guard the detach path? But isn't bpf_prog_put
already doing the deferred dealloc? So calling it without synchronize_rcu
here should be ok?

> +}
> +
> +static inline void bpf_mprog_entry_clear(struct bpf_mprog_entry *entry)
> +{
> +	memset(entry->fp_items, 0, sizeof(entry->fp_items));
> +	memset(entry->cp_items, 0, sizeof(entry->cp_items));
> +}
> +
> +static inline u64 bpf_mprog_revision(struct bpf_mprog_entry *entry)
> +{
> +	return atomic_read(&entry->parent->revision);
> +}
> +
> +static inline void bpf_mprog_read(struct bpf_mprog_entry *entry, u32 which,
> +				  struct bpf_mprog_fp **fp_dst,
> +				  struct bpf_mprog_cp **cp_dst)
> +{
> +	*fp_dst = &entry->fp_items[which];
> +	*cp_dst = &entry->cp_items[which];
> +}
> +
> +static inline void bpf_mprog_write(struct bpf_mprog_fp *fp_dst,
> +				   struct bpf_mprog_cp *cp_dst,
> +				   struct bpf_tuple *tuple, u32 flags)
> +{
> +	WRITE_ONCE(fp_dst->prog, tuple->prog);
> +	cp_dst->link  = tuple->link;
> +	cp_dst->flags = flags;
> +}
> +
> +static inline void bpf_mprog_copy(struct bpf_mprog_fp *fp_dst,
> +				  struct bpf_mprog_cp *cp_dst,
> +				  struct bpf_mprog_fp *fp_src,
> +				  struct bpf_mprog_cp *cp_src)
> +{
> +	WRITE_ONCE(fp_dst->prog, READ_ONCE(fp_src->prog));
> +	memcpy(cp_dst, cp_src, sizeof(*cp_src));

nit: why not simply *cp_dst = *cp_src? memcpy somewhat implies (in my
mind) that we are copying several entries..

> +}
> +
> +static inline void bpf_mprog_copy_range(struct bpf_mprog_entry *peer,
> +					struct bpf_mprog_entry *entry,
> +					u32 idx_peer, u32 idx_entry, u32 num)
> +{
> +	memcpy(&peer->fp_items[idx_peer], &entry->fp_items[idx_entry],
> +	       num * sizeof(peer->fp_items[0]));
> +	memcpy(&peer->cp_items[idx_peer], &entry->cp_items[idx_entry],
> +	       num * sizeof(peer->cp_items[0]));
> +}
> +
> +static inline u32 bpf_mprog_total(struct bpf_mprog_entry *entry)
> +{
> +	const struct bpf_mprog_fp *fp;
> +	const struct bpf_prog *tmp;
> +	u32 num = 0;
> +
> +	bpf_mprog_foreach_prog(entry, fp, tmp)
> +		num++;
> +	return num;
> +}
> +
> +int bpf_mprog_attach(struct bpf_mprog_entry *entry, struct bpf_prog *prog,
> +		     struct bpf_link *link, u32 flags, u32 object,
> +		     u32 expected_revision);
> +int bpf_mprog_detach(struct bpf_mprog_entry *entry, struct bpf_prog *prog,
> +		     struct bpf_link *link, u32 flags, u32 object,
> +		     u32 expected_revision);
> +
> +int bpf_mprog_query(const union bpf_attr *attr, union bpf_attr __user *uattr,
> +		    struct bpf_mprog_entry *entry);
> +
> +#endif /* __BPF_MPROG_H */
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index a7b5e91dd768..207f8a37b327 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1102,7 +1102,14 @@ enum bpf_link_type {
>   */
>  #define BPF_F_ALLOW_OVERRIDE	(1U << 0)
>  #define BPF_F_ALLOW_MULTI	(1U << 1)
> +/* Generic attachment flags. */
>  #define BPF_F_REPLACE		(1U << 2)
> +#define BPF_F_BEFORE		(1U << 3)
> +#define BPF_F_AFTER		(1U << 4)
> +#define BPF_F_FIRST		(1U << 5)
> +#define BPF_F_LAST		(1U << 6)
> +#define BPF_F_ID		(1U << 7)
> +#define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
>  
>  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
>   * verifier will perform strict alignment checking as if the kernel
> @@ -1433,14 +1440,19 @@ union bpf_attr {
>  	};
>  
>  	struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
> -		__u32		target_fd;	/* container object to attach to */
> -		__u32		attach_bpf_fd;	/* eBPF program to attach */
> +		union {
> +			__u32	target_fd;	/* target object to attach to or ... */
> +			__u32	target_ifindex;	/* target ifindex */
> +		};
> +		__u32		attach_bpf_fd;
>  		__u32		attach_type;
>  		__u32		attach_flags;
> -		__u32		replace_bpf_fd;	/* previously attached eBPF
> -						 * program to replace if
> -						 * BPF_F_REPLACE is used
> -						 */
> +		union {
> +			__u32	relative_fd;
> +			__u32	relative_id;
> +			__u32	replace_bpf_fd;
> +		};
> +		__u32		expected_revision;
>  	};
>  
>  	struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
> @@ -1486,16 +1498,25 @@ union bpf_attr {
>  	} info;
>  
>  	struct { /* anonymous struct used by BPF_PROG_QUERY command */
> -		__u32		target_fd;	/* container object to query */
> +		union {
> +			__u32	target_fd;	/* target object to query or ... */
> +			__u32	target_ifindex;	/* target ifindex */
> +		};
>  		__u32		attach_type;
>  		__u32		query_flags;
>  		__u32		attach_flags;
>  		__aligned_u64	prog_ids;
> -		__u32		prog_cnt;
> +		union {
> +			__u32	prog_cnt;
> +			__u32	count;
> +		};
> +		__u32		revision;
>  		/* output: per-program attach_flags.
>  		 * not allowed to be set during effective query.
>  		 */
>  		__aligned_u64	prog_attach_flags;
> +		__aligned_u64	link_ids;
> +		__aligned_u64	link_attach_flags;
>  	} query;
>  
>  	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 1d3892168d32..1bea2eb912cd 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -12,7 +12,7 @@ obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list
>  obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o ringbuf.o
>  obj-$(CONFIG_BPF_SYSCALL) += bpf_local_storage.o bpf_task_storage.o
>  obj-${CONFIG_BPF_LSM}	  += bpf_inode_storage.o
> -obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> +obj-$(CONFIG_BPF_SYSCALL) += disasm.o mprog.o
>  obj-$(CONFIG_BPF_JIT) += trampoline.o
>  obj-$(CONFIG_BPF_SYSCALL) += btf.o memalloc.o
>  obj-$(CONFIG_BPF_JIT) += dispatcher.o
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
> +				    u32 object, u32 flags,
> +				    enum bpf_prog_type type)
> +{
> +	struct bpf_prog *prog;
> +	struct bpf_link *link;
> +
> +	memset(tuple, 0, sizeof(*tuple));
> +	if (!(flags & (BPF_F_REPLACE | BPF_F_BEFORE | BPF_F_AFTER)))
> +		return object || (flags & (BPF_F_ID | BPF_F_LINK)) ?
> +		       -EINVAL : 0;
> +	if (flags & BPF_F_LINK) {
> +		if (flags & BPF_F_ID)
> +			link = bpf_link_by_id(object);
> +		else
> +			link = bpf_link_get_from_fd(object);
> +		if (IS_ERR(link))
> +			return PTR_ERR(link);
> +		if (type && link->prog->type != type) {
> +			bpf_link_put(link);
> +			return -EINVAL;
> +		}
> +		tuple->link = link;
> +		tuple->prog = link->prog;
> +	} else {
> +		if (flags & BPF_F_ID)
> +			prog = bpf_prog_by_id(object);
> +		else
> +			prog = bpf_prog_get(object);
> +		if (IS_ERR(prog)) {
> +			if (!object &&
> +			    !(flags & BPF_F_ID))
> +				return 0;
> +			return PTR_ERR(prog);
> +		}
> +		if (type && prog->type != type) {
> +			bpf_prog_put(prog);
> +			return -EINVAL;
> +		}
> +		tuple->link = NULL;
> +		tuple->prog = prog;
> +	}
> +	return 0;
> +}
> +
> +static void bpf_mprog_tuple_put(struct bpf_tuple *tuple)
> +{
> +	if (tuple->link)
> +		bpf_link_put(tuple->link);
> +	else if (tuple->prog)
> +		bpf_prog_put(tuple->prog);
> +}
> +
> +static int bpf_mprog_replace(struct bpf_mprog_entry *entry,
> +			     struct bpf_tuple *ntuple,
> +			     struct bpf_tuple *rtuple, u32 rflags)
> +{
> +	struct bpf_mprog_fp *fp;
> +	struct bpf_mprog_cp *cp;
> +	struct bpf_prog *oprog;
> +	u32 iflags;
> +	int i;
> +
> +	if (rflags & (BPF_F_BEFORE | BPF_F_AFTER | BPF_F_LINK))
> +		return -EINVAL;
> +	if (rtuple->prog != ntuple->prog &&
> +	    bpf_mprog_exists(entry, ntuple->prog))
> +		return -EEXIST;
> +	for (i = 0; i < bpf_mprog_max(); i++) {
> +		bpf_mprog_read(entry, i, &fp, &cp);
> +		oprog = READ_ONCE(fp->prog);
> +		if (!oprog)
> +			break;
> +		if (oprog != rtuple->prog)
> +			continue;
> +		if (cp->link != ntuple->link)
> +			return -EBUSY;
> +		iflags = cp->flags;
> +		if ((iflags & BPF_F_FIRST) !=
> +		    (rflags & BPF_F_FIRST)) {
> +			iflags = bpf_mprog_flags(iflags, rflags,
> +						 BPF_F_FIRST);
> +			if ((iflags & BPF_F_FIRST) &&
> +			    rtuple->prog != bpf_mprog_first(entry))
> +				return -EACCES;
> +		}
> +		if ((iflags & BPF_F_LAST) !=
> +		    (rflags & BPF_F_LAST)) {
> +			iflags = bpf_mprog_flags(iflags, rflags,
> +						 BPF_F_LAST);
> +			if ((iflags & BPF_F_LAST) &&
> +			    rtuple->prog != bpf_mprog_last(entry))
> +				return -EACCES;
> +		}
> +		bpf_mprog_write(fp, cp, ntuple, iflags);
> +		if (!ntuple->link)
> +			bpf_prog_put(oprog);
> +		return 0;
> +	}
> +	return -ENOENT;
> +}
> +
> +static int bpf_mprog_head_tail(struct bpf_mprog_entry *entry,
> +			       struct bpf_tuple *ntuple,
> +			       struct bpf_tuple *rtuple, u32 aflags)
> +{
> +	struct bpf_mprog_entry *peer;
> +	struct bpf_mprog_fp *fp;
> +	struct bpf_mprog_cp *cp;
> +	struct bpf_prog *oprog;
> +	u32 iflags, items;
> +
> +	if (bpf_mprog_exists(entry, ntuple->prog))
> +		return -EEXIST;
> +	items = bpf_mprog_total(entry);
> +	peer = bpf_mprog_peer(entry);
> +	bpf_mprog_entry_clear(peer);
> +	if (aflags & BPF_F_FIRST) {
> +		if (aflags & BPF_F_AFTER)
> +			return -EINVAL;
> +		bpf_mprog_read(entry, 0, &fp, &cp);
> +		iflags = cp->flags;
> +		if (iflags & BPF_F_FIRST)
> +			return -EBUSY;
> +		if (aflags & BPF_F_LAST) {
> +			if (aflags & BPF_F_BEFORE)
> +				return -EINVAL;
> +			if (items)
> +				return -EBUSY;
> +			bpf_mprog_read(peer, 0, &fp, &cp);
> +			bpf_mprog_write(fp, cp, ntuple,
> +					BPF_F_FIRST | BPF_F_LAST);
> +			return BPF_MPROG_SWAP;
> +		}
> +		if (aflags & BPF_F_BEFORE) {
> +			oprog = READ_ONCE(fp->prog);
> +			if (oprog != rtuple->prog ||
> +			    (rtuple->link &&
> +			     rtuple->link != cp->link))
> +				return -EBUSY;
> +		}
> +		if (items >= bpf_mprog_max())
> +			return -ENOSPC;
> +		bpf_mprog_read(peer, 0, &fp, &cp);
> +		bpf_mprog_write(fp, cp, ntuple, BPF_F_FIRST);
> +		bpf_mprog_copy_range(peer, entry, 1, 0, items);
> +		return BPF_MPROG_SWAP;
> +	}
> +	if (aflags & BPF_F_LAST) {
> +		if (aflags & BPF_F_BEFORE)
> +			return -EINVAL;
> +		if (items) {
> +			bpf_mprog_read(entry, items - 1, &fp, &cp);
> +			iflags = cp->flags;
> +			if (iflags & BPF_F_LAST)
> +				return -EBUSY;
> +			if (aflags & BPF_F_AFTER) {
> +				oprog = READ_ONCE(fp->prog);
> +				if (oprog != rtuple->prog ||
> +				    (rtuple->link &&
> +				     rtuple->link != cp->link))
> +					return -EBUSY;
> +			}
> +			if (items >= bpf_mprog_max())
> +				return -ENOSPC;
> +		} else {
> +			if (aflags & BPF_F_AFTER)
> +				return -EBUSY;
> +		}
> +		bpf_mprog_read(peer, items, &fp, &cp);
> +		bpf_mprog_write(fp, cp, ntuple, BPF_F_LAST);
> +		bpf_mprog_copy_range(peer, entry, 0, 0, items);
> +		return BPF_MPROG_SWAP;
> +	}
> +	return -ENOENT;
> +}
> +
> +static int bpf_mprog_add(struct bpf_mprog_entry *entry,
> +			 struct bpf_tuple *ntuple,
> +			 struct bpf_tuple *rtuple, u32 aflags)
> +{
> +	struct bpf_mprog_fp *fp_dst, *fp_src;
> +	struct bpf_mprog_cp *cp_dst, *cp_src;
> +	struct bpf_mprog_entry *peer;
> +	struct bpf_prog *oprog;
> +	bool found = false;
> +	u32 items;
> +	int i, j;
> +
> +	items = bpf_mprog_total(entry);
> +	if (items >= bpf_mprog_max())
> +		return -ENOSPC;
> +	if ((aflags & (BPF_F_BEFORE | BPF_F_AFTER)) ==
> +	    (BPF_F_BEFORE | BPF_F_AFTER))
> +		return -EINVAL;
> +	if (bpf_mprog_exists(entry, ntuple->prog))
> +		return -EEXIST;
> +	if (!rtuple->prog && (aflags & (BPF_F_BEFORE | BPF_F_AFTER))) {
> +		if (!items)
> +			aflags &= ~(BPF_F_AFTER | BPF_F_BEFORE);
> +		if (aflags & BPF_F_BEFORE)
> +			rtuple->prog = bpf_mprog_first_reg(entry);
> +		if (aflags & BPF_F_AFTER)
> +			rtuple->prog = bpf_mprog_last_reg(entry);
> +		if (!rtuple->prog)
> +			aflags &= ~(BPF_F_AFTER | BPF_F_BEFORE);
> +		else
> +			bpf_prog_inc(rtuple->prog);
> +	}
> +	peer = bpf_mprog_peer(entry);
> +	bpf_mprog_entry_clear(peer);
> +	for (i = 0, j = 0; i < bpf_mprog_max(); i++, j++) {
> +		bpf_mprog_read(entry, i, &fp_src, &cp_src);
> +		bpf_mprog_read(peer,  j, &fp_dst, &cp_dst);
> +		oprog = READ_ONCE(fp_src->prog);
> +		if (!oprog) {
> +			if (i != j)
> +				break;
> +			if (i > 0) {
> +				bpf_mprog_read(entry, i - 1,
> +					       &fp_src, &cp_src);
> +				if (cp_src->flags & BPF_F_LAST) {
> +					if (cp_src->flags & BPF_F_FIRST)
> +						return -EBUSY;
> +					bpf_mprog_copy(fp_dst, cp_dst,
> +						       fp_src, cp_src);
> +					bpf_mprog_read(peer, --j,
> +						       &fp_dst, &cp_dst);
> +				}
> +			}
> +			bpf_mprog_write(fp_dst, cp_dst, ntuple, 0);
> +			break;
> +		}
> +		if (aflags & (BPF_F_BEFORE | BPF_F_AFTER)) {
> +			if (rtuple->prog != oprog ||
> +			    (rtuple->link &&
> +			     rtuple->link != cp_src->link))
> +				goto next;
> +			found = true;
> +			if (aflags & BPF_F_BEFORE) {
> +				if (cp_src->flags & BPF_F_FIRST)
> +					return -EBUSY;
> +				bpf_mprog_write(fp_dst, cp_dst, ntuple, 0);
> +				bpf_mprog_read(peer, ++j, &fp_dst, &cp_dst);
> +				goto next;
> +			}
> +			if (aflags & BPF_F_AFTER) {
> +				if (cp_src->flags & BPF_F_LAST)
> +					return -EBUSY;
> +				bpf_mprog_copy(fp_dst, cp_dst,
> +					       fp_src, cp_src);
> +				bpf_mprog_read(peer, ++j, &fp_dst, &cp_dst);
> +				bpf_mprog_write(fp_dst, cp_dst, ntuple, 0);
> +				continue;
> +			}
> +		}
> +next:
> +		bpf_mprog_copy(fp_dst, cp_dst,
> +			       fp_src, cp_src);
> +	}
> +	if (rtuple->prog && !found)
> +		return -ENOENT;
> +	return BPF_MPROG_SWAP;
> +}
> +
> +static int bpf_mprog_del(struct bpf_mprog_entry *entry,
> +			 struct bpf_tuple *dtuple,
> +			 struct bpf_tuple *rtuple, u32 dflags)
> +{
> +	struct bpf_mprog_fp *fp_dst, *fp_src;
> +	struct bpf_mprog_cp *cp_dst, *cp_src;
> +	struct bpf_mprog_entry *peer;
> +	struct bpf_prog *oprog;
> +	bool found = false;
> +	int i, j, ret;
> +
> +	if (dflags & BPF_F_REPLACE)
> +		return -EINVAL;
> +	if (dflags & BPF_F_FIRST) {
> +		oprog = bpf_mprog_first(entry);
> +		if (dtuple->prog &&
> +		    dtuple->prog != oprog)
> +			return -ENOENT;
> +		dtuple->prog = oprog;
> +	}
> +	if (dflags & BPF_F_LAST) {
> +		oprog = bpf_mprog_last(entry);
> +		if (dtuple->prog &&
> +		    dtuple->prog != oprog)
> +			return -ENOENT;
> +		dtuple->prog = oprog;
> +	}
> +	if (!rtuple->prog && (dflags & (BPF_F_BEFORE | BPF_F_AFTER))) {
> +		if (dtuple->prog)
> +			return -EINVAL;
> +		if (dflags & BPF_F_BEFORE)
> +			dtuple->prog = bpf_mprog_first_reg(entry);
> +		if (dflags & BPF_F_AFTER)
> +			dtuple->prog = bpf_mprog_last_reg(entry);
> +		if (dtuple->prog)
> +			dflags &= ~(BPF_F_AFTER | BPF_F_BEFORE);
> +	}
> +	for (i = 0; i < bpf_mprog_max(); i++) {
> +		bpf_mprog_read(entry, i, &fp_src, &cp_src);
> +		oprog = READ_ONCE(fp_src->prog);
> +		if (!oprog)
> +			break;
> +		if (dflags & (BPF_F_BEFORE | BPF_F_AFTER)) {
> +			if (rtuple->prog != oprog ||
> +			    (rtuple->link &&
> +			     rtuple->link != cp_src->link))
> +				continue;
> +			found = true;
> +			if (dflags & BPF_F_BEFORE) {
> +				if (!i)
> +					return -ENOENT;
> +				bpf_mprog_read(entry, i - 1,
> +					       &fp_src, &cp_src);
> +				oprog = READ_ONCE(fp_src->prog);
> +				if (dtuple->prog &&
> +				    dtuple->prog != oprog)
> +					return -ENOENT;
> +				dtuple->prog = oprog;
> +				break;
> +			}
> +			if (dflags & BPF_F_AFTER) {
> +				bpf_mprog_read(entry, i + 1,
> +					       &fp_src, &cp_src);
> +				oprog = READ_ONCE(fp_src->prog);
> +				if (dtuple->prog &&
> +				    dtuple->prog != oprog)
> +					return -ENOENT;
> +				dtuple->prog = oprog;
> +				break;
> +			}
> +		}
> +	}
> +	if (!dtuple->prog || (rtuple->prog && !found))
> +		return -ENOENT;
> +	peer = bpf_mprog_peer(entry);
> +	bpf_mprog_entry_clear(peer);
> +	ret = -ENOENT;
> +	for (i = 0, j = 0; i < bpf_mprog_max(); i++) {
> +		bpf_mprog_read(entry, i, &fp_src, &cp_src);
> +		bpf_mprog_read(peer,  j, &fp_dst, &cp_dst);
> +		oprog = READ_ONCE(fp_src->prog);
> +		if (!oprog)
> +			break;
> +		if (oprog != dtuple->prog) {
> +			bpf_mprog_copy(fp_dst, cp_dst,
> +				       fp_src, cp_src);
> +			j++;
> +		} else {
> +			if (cp_src->link != dtuple->link)
> +				return -EBUSY;
> +			if (!cp_src->link)
> +				bpf_mprog_mark_ref(entry, dtuple->prog);
> +			ret = BPF_MPROG_SWAP;
> +		}
> +	}
> +	if (!bpf_mprog_total(peer))
> +		ret = BPF_MPROG_FREE;
> +	return ret;
> +}
> +
> +int bpf_mprog_attach(struct bpf_mprog_entry *entry, struct bpf_prog *prog,
> +		     struct bpf_link *link, u32 flags, u32 object,
> +		     u32 expected_revision)
> +{
> +	struct bpf_tuple rtuple, ntuple = {
> +		.prog = prog,
> +		.link = link,
> +	};
> +	int ret;
> +
> +	if (expected_revision &&
> +	    expected_revision != bpf_mprog_revision(entry))
> +		return -ESTALE;
> +	ret = bpf_mprog_tuple_relative(&rtuple, object, flags, prog->type);
> +	if (ret)
> +		return ret;
> +	if (flags & BPF_F_REPLACE)
> +		ret = bpf_mprog_replace(entry, &ntuple, &rtuple, flags);
> +	else if (flags & (BPF_F_FIRST | BPF_F_LAST))
> +		ret = bpf_mprog_head_tail(entry, &ntuple, &rtuple, flags);
> +	else
> +		ret = bpf_mprog_add(entry, &ntuple, &rtuple, flags);
> +	bpf_mprog_tuple_put(&rtuple);
> +	return ret;
> +}
> +
> +int bpf_mprog_detach(struct bpf_mprog_entry *entry, struct bpf_prog *prog,
> +		     struct bpf_link *link, u32 flags, u32 object,
> +		     u32 expected_revision)
> +{
> +	struct bpf_tuple rtuple, dtuple = {
> +		.prog = prog,
> +		.link = link,
> +	};
> +	int ret;
> +
> +	if (expected_revision &&
> +	    expected_revision != bpf_mprog_revision(entry))
> +		return -ESTALE;
> +	ret = bpf_mprog_tuple_relative(&rtuple, object, flags,
> +				       prog ? prog->type :
> +				       BPF_PROG_TYPE_UNSPEC);
> +	if (ret)
> +		return ret;
> +	ret = bpf_mprog_del(entry, &dtuple, &rtuple, flags);
> +	bpf_mprog_tuple_put(&rtuple);
> +	return ret;
> +}
> +
> +int bpf_mprog_query(const union bpf_attr *attr, union bpf_attr __user *uattr,
> +		    struct bpf_mprog_entry *entry)
> +{
> +	u32 i, id, flags = 0, count, revision;
> +	u32 __user *uprog_id, *uprog_af;
> +	u32 __user *ulink_id, *ulink_af;
> +	struct bpf_mprog_fp *fp;
> +	struct bpf_mprog_cp *cp;
> +	struct bpf_prog *prog;
> +	int ret = 0;
> +
> +	if (attr->query.query_flags || attr->query.attach_flags)
> +		return -EINVAL;
> +	revision = bpf_mprog_revision(entry);
> +	count = bpf_mprog_total(entry);
> +	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
> +		return -EFAULT;
> +	if (copy_to_user(&uattr->query.revision, &revision, sizeof(revision)))
> +		return -EFAULT;
> +	if (copy_to_user(&uattr->query.count, &count, sizeof(count)))
> +		return -EFAULT;
> +	uprog_id = u64_to_user_ptr(attr->query.prog_ids);
> +	if (attr->query.count == 0 || !uprog_id || !count)
> +		return 0;
> +	if (attr->query.count < count) {
> +		count = attr->query.count;
> +		ret = -ENOSPC;
> +	}
> +	uprog_af = u64_to_user_ptr(attr->query.prog_attach_flags);
> +	ulink_id = u64_to_user_ptr(attr->query.link_ids);
> +	ulink_af = u64_to_user_ptr(attr->query.link_attach_flags);
> +	for (i = 0; i < ARRAY_SIZE(entry->fp_items); i++) {
> +		bpf_mprog_read(entry, i, &fp, &cp);
> +		prog = READ_ONCE(fp->prog);
> +		if (!prog)
> +			break;
> +		id = prog->aux->id;
> +		if (copy_to_user(uprog_id + i, &id, sizeof(id)))
> +			return -EFAULT;
> +		id = cp->link ? cp->link->id : 0;
> +		if (ulink_id &&
> +		    copy_to_user(ulink_id + i, &id, sizeof(id)))
> +			return -EFAULT;
> +		flags = cp->flags;
> +		if (uprog_af && !id &&
> +		    copy_to_user(uprog_af + i, &flags, sizeof(flags)))
> +			return -EFAULT;
> +		if (ulink_af && id &&
> +		    copy_to_user(ulink_af + i, &flags, sizeof(flags)))
> +			return -EFAULT;
> +		if (i + 1 == count)
> +			break;
> +	}
> +	return ret;
> +}
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index a7b5e91dd768..207f8a37b327 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1102,7 +1102,14 @@ enum bpf_link_type {
>   */
>  #define BPF_F_ALLOW_OVERRIDE	(1U << 0)
>  #define BPF_F_ALLOW_MULTI	(1U << 1)
> +/* Generic attachment flags. */
>  #define BPF_F_REPLACE		(1U << 2)
> +#define BPF_F_BEFORE		(1U << 3)
> +#define BPF_F_AFTER		(1U << 4)

[..]

> +#define BPF_F_FIRST		(1U << 5)
> +#define BPF_F_LAST		(1U << 6)

I'm still not sure whether the hard semantics of first/last is really
useful. My worry is that some prog will just use BPF_F_FIRST which
would prevent the rest of the users.. (starting with only
F_BEFORE/F_AFTER feels 'safer'; we can iterate later on if we really
need first/laste).

But if everyone besides myself is on board with first/last, maybe at least
put a comment here saying that only a single program can be first/last?
And the users are advised not to use these unless they really really really
need to be first/last. (IOW, feels like first/last should be reserved
for observability tools/etc).

> +#define BPF_F_ID		(1U << 7)
> +#define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
>  
>  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
>   * verifier will perform strict alignment checking as if the kernel
> @@ -1433,14 +1440,19 @@ union bpf_attr {
>  	};
>  
>  	struct { /* anonymous struct used by BPF_PROG_ATTACH/DETACH commands */
> -		__u32		target_fd;	/* container object to attach to */
> -		__u32		attach_bpf_fd;	/* eBPF program to attach */
> +		union {
> +			__u32	target_fd;	/* target object to attach to or ... */
> +			__u32	target_ifindex;	/* target ifindex */
> +		};
> +		__u32		attach_bpf_fd;
>  		__u32		attach_type;
>  		__u32		attach_flags;
> -		__u32		replace_bpf_fd;	/* previously attached eBPF
> -						 * program to replace if
> -						 * BPF_F_REPLACE is used
> -						 */
> +		union {
> +			__u32	relative_fd;
> +			__u32	relative_id;
> +			__u32	replace_bpf_fd;
> +		};
> +		__u32		expected_revision;
>  	};
>  
>  	struct { /* anonymous struct used by BPF_PROG_TEST_RUN command */
> @@ -1486,16 +1498,25 @@ union bpf_attr {
>  	} info;
>  
>  	struct { /* anonymous struct used by BPF_PROG_QUERY command */
> -		__u32		target_fd;	/* container object to query */
> +		union {
> +			__u32	target_fd;	/* target object to query or ... */
> +			__u32	target_ifindex;	/* target ifindex */
> +		};
>  		__u32		attach_type;
>  		__u32		query_flags;
>  		__u32		attach_flags;
>  		__aligned_u64	prog_ids;
> -		__u32		prog_cnt;
> +		union {
> +			__u32	prog_cnt;
> +			__u32	count;
> +		};
> +		__u32		revision;
>  		/* output: per-program attach_flags.
>  		 * not allowed to be set during effective query.
>  		 */
>  		__aligned_u64	prog_attach_flags;
> +		__aligned_u64	link_ids;
> +		__aligned_u64	link_attach_flags;
>  	} query;
>  
>  	struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN command */
> -- 
> 2.34.1
> 

