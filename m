Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0812D194D57
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbgCZXfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:35:39 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39197 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbgCZXfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 19:35:39 -0400
Received: by mail-pj1-f65.google.com with SMTP id z3so2540924pjr.4;
        Thu, 26 Mar 2020 16:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9FN11s9scCK5qgibF6L3+4gVIyRgF1RL7ZAsxAIHQYU=;
        b=tROQqu9vsFezeCvouq8Ox+xw4j8OmZ4owdM4vSJyIeYuzhgVhYWdO+o1RzIHyry238
         npm/FdH2U4MV8yx2e1t4KMafuikciN+QcILLZaryEukz6QNjXPRVhi0Y0u+8emkdNH8S
         78hSUjb29qMdPd7s6fxu+EJ7cukvC2yX2YJiHekovPp8hqLXsbrh7GDWJI1vr9y4xgo8
         rKjMZKHfqk3kpDIWsP4/abseY4x207pZRtgRS22UkgJ0dQRHJhhUw1PrViXhHXg/IYTc
         JNd6buRT/osnBJMO22jeoHASYAOoxS8XtHSbM6hC1eypLnKBOevHRA187VaeVI3gAsAc
         wuww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9FN11s9scCK5qgibF6L3+4gVIyRgF1RL7ZAsxAIHQYU=;
        b=opy2sFTr1zHF9jC3jCRG30d1jP33p5Pe4S9HlIf0YqQp4kNFnQei69FXAoxj8rFHWd
         NH2UTEkQUdS10cPxtxnxcKa4l/TOTnh4Ez/Q9qpqqtI0jlZeiZHKTx+SegmZofXvkdB/
         mnGg5KdxlcAHL0CxYMltFEQ3cKm4HoQk34g55gIa05nKdRRR1g248NfoW1tpfQsPYVaW
         EWlAb/A2kZlRJk2me3d00trb4kt2ab+G6lFK2rTh4NUUm+E32yRvBSeiGC6jb0lgfThY
         vcy1Bj2rotpjzLZyTgJoyyIyKnZUdfh4cz1N20Uxxd2WNk1gYk5hPEZ+UxwPWDmRZMdW
         C3rQ==
X-Gm-Message-State: ANhLgQ31BFwEFRlb56dg0Mre8m/DSUp2wGBRz1XaAjITQ3uQxF37DUoE
        2YFrKgSmu+sNphGdiGFmMaN8fUlr
X-Google-Smtp-Source: ADFU+vsAmL+vckTNYYDEr9VrDYlcPKeUajTRABrIAo9X6/7JXLQRBz7XM7DovD5IXDnQdd5peGTDSA==
X-Received: by 2002:a17:90a:628a:: with SMTP id d10mr2709112pjj.25.1585265737424;
        Thu, 26 Mar 2020 16:35:37 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:c7d9])
        by smtp.gmail.com with ESMTPSA id 185sm2561957pfz.119.2020.03.26.16.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 16:35:36 -0700 (PDT)
Date:   Thu, 26 Mar 2020 16:35:33 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, rdna@fb.com, andrii.nakryiko@gmail.com,
        kernel-team@fb.com
Subject: Re: [PATCH v2 bpf-next 4/6] bpf: implement bpf_prog replacement for
 an active bpf_cgroup_link
Message-ID: <20200326233533.gbyogvi57xufe34d@ast-mbp>
References: <20200325065746.640559-1-andriin@fb.com>
 <20200325065746.640559-5-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325065746.640559-5-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 11:57:44PM -0700, Andrii Nakryiko wrote:
>  
> +/* Swap updated BPF program for given link in effective program arrays across
> + * all descendant cgroups. This function is guaranteed to succeed.
> + */
> +static void replace_effective_prog(struct cgroup *cgrp,
> +				   enum bpf_attach_type type,
> +				   struct bpf_cgroup_link *link)
> +{
> +	struct bpf_prog_array_item *item;
> +	struct cgroup_subsys_state *css;
> +	struct bpf_prog_array *progs;
> +	struct bpf_prog_list *pl;
> +	struct list_head *head;
> +	struct cgroup *cg;
> +	int pos;
> +
> +	css_for_each_descendant_pre(css, &cgrp->self) {
> +		struct cgroup *desc = container_of(css, struct cgroup, self);
> +
> +		if (percpu_ref_is_zero(&desc->bpf.refcnt))
> +			continue;
> +
> +		/* found position of link in effective progs array */
> +		for (pos = 0, cg = desc; cg; cg = cgroup_parent(cg)) {
> +			if (pos && !(cg->bpf.flags[type] & BPF_F_ALLOW_MULTI))
> +				continue;
> +
> +			head = &cg->bpf.progs[type];
> +			list_for_each_entry(pl, head, node) {
> +				if (!prog_list_prog(pl))
> +					continue;
> +				if (pl->link == link)
> +					goto found;
> +				pos++;
> +			}
> +		}
> +found:
> +		BUG_ON(!cg);
> +		progs = rcu_dereference_protected(
> +				desc->bpf.effective[type],
> +				lockdep_is_held(&cgroup_mutex));
> +		item = &progs->items[pos];
> +		WRITE_ONCE(item->prog, link->link.prog);
> +	}
> +}
> +
> +/**
> + * __cgroup_bpf_replace() - Replace link's program and propagate the change
> + *                          to descendants
> + * @cgrp: The cgroup which descendants to traverse
> + * @link: A link for which to replace BPF program
> + * @type: Type of attach operation
> + *
> + * Must be called with cgroup_mutex held.
> + */
> +int __cgroup_bpf_replace(struct cgroup *cgrp, struct bpf_cgroup_link *link,
> +			 struct bpf_prog *new_prog)
> +{
> +	struct list_head *progs = &cgrp->bpf.progs[link->type];
> +	struct bpf_prog *old_prog;
> +	struct bpf_prog_list *pl;
> +	bool found = false;
> +
> +	if (link->link.prog->type != new_prog->type)
> +		return -EINVAL;
> +
> +	list_for_each_entry(pl, progs, node) {
> +		if (pl->link == link) {
> +			found = true;
> +			break;
> +		}
> +	}
> +	if (!found)
> +		return -ENOENT;
> +
> +	old_prog = xchg(&link->link.prog, new_prog);
> +	replace_effective_prog(cgrp, link->type, link);

I think with 'found = true' in this function you're assuming that it will be
found in replace_effective_prog() ? I don't think that's the case.
Try to create bpf_link with BPF_F_ALLOW_OVERRIDE, override it in a child cgroup
with another link and then try to LINK_UPDATE the former. The link is there,
but the prog is not executing and it's not in effective array. What LINK_UPDATE
suppose to do? I guess it should succeed?
Even trickier that the prog will be in effective array in some of
css_for_each_descendant_pre() and not in others. This cgroup attach semantics
were convoluted from the day one. Apparently people use all three variants now,
but I wouldn't bet that everyone understands it.
Hence my proposal to support F_ALLOW_MULTI for links only. At least initially.
It's so much simpler to explain. And owning bpf_link will guarantee that the
prog is executing (unless cgroup is removed and sockets are closed). I guess
default (no-override) is acceptable to bpf_link as well and in that sense it
will be very similar to XDP with single prog attached. So I think I can live
with default and ALLOW_MULTI for now. But we should probably redesign
overriding capabilities. Folks need to attach multiple progs to a given cgroup
and disallow all progs in children. Currently it's not possible to do, since
MULTI in the parent allows at least one (default, override or multi) in the
children. bpf_link inheriting this logic won't help to solve this use case. It
feels that link should stay as multi only and override or not in the children
should be a separate property. Probably not related to link at all. It fits
better as a cgroup permission.

Anyhow I'm going to apply patches 1 and 2, since they are good cleanup
regardless of what we decide here.
