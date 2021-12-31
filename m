Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82774821E7
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 04:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241140AbhLaDpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 22:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbhLaDpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 22:45:11 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259B0C061574;
        Thu, 30 Dec 2021 19:45:11 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id v11so22786256pfu.2;
        Thu, 30 Dec 2021 19:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C7ghpTVGQ7CvRO+Ru+/AN44xGVXt0lr2YMADI04bRlQ=;
        b=q3nV3Rd19b3M9n7TkidOfw9B+/OXahNv3kjA3y5SW30rwkNGu+hx98GEmr4MueWPP/
         lWO8mOMz2it9IojVVxc5vka9qoGhQqrpBlhBSOMvI/r3bKKw7li4lSGyugbTb8DQaW3F
         /FfadOSAF7JxHt20yWoYYe+eLTAgVeOE5i09q/LIgGRiXWhIbGfec98hi61/9pIIkb4Q
         ad1Z/k4Axmsil1WbXUnFAlkBL6O/pobTXNnEvkMN5fDhp+lDItVhM5xpPWQn2QifMvZS
         5lE1jt4E3OnQExhC49m+PooCPCozaCni89VZEFGLt1Q7WNARvOYMhz4inl7M+z53nHw+
         iFrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C7ghpTVGQ7CvRO+Ru+/AN44xGVXt0lr2YMADI04bRlQ=;
        b=bdsFhJLZ//j3E7lDrDWpobrDCj8wqdABnyzRhBCszpVUQqRMulO7RWhvTh/i52mhtA
         R4FaTYJcg9M8b7PO+juAGoQeRETCw1i+GCquFn5BdWmYdCdxR7Kk6G0sAcjDvdGktqlu
         dsYDSfC0K8upJAws4msf+cZs5oz6/PTW/cfLYigiwzbOWQNjZflpz5+ZOhTH9j6RTIQk
         /xQ2Jw8mEGYO2Uwu0C5rodUMob3rWz7qmQjFbJrTLIRP6hlUD/L+VTgrq0jyVKN5a0ZG
         beBJ8cl/ySre4f+XAI+h2jx6kMynAqJII03qWmzh9nufjLJu/7fRXYZmExo0EntR7lFn
         b2WA==
X-Gm-Message-State: AOAM532oHovsg5bVOXOphkdOFOtOfbtMPrCeuwbdN1P5f0r4UiLAY9xE
        goGoPeT5bGlaRcuxvhZsCiBFotVWvuo=
X-Google-Smtp-Source: ABdhPJyF85LEN3S+XKVPU3pUEdIY5qXIpETHW9mS2RJ+ByjNN5aMJ83wWStpTpB2NqtIfYiaedk0tg==
X-Received: by 2002:a63:9d8a:: with SMTP id i132mr15328825pgd.329.1640922310547;
        Thu, 30 Dec 2021 19:45:10 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id i185sm28212861pfe.199.2021.12.30.19.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 19:45:10 -0800 (PST)
Date:   Fri, 31 Dec 2021 09:15:07 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v5 2/9] bpf: Prepare kfunc BTF ID sets when
 parsing kernel BTF
Message-ID: <20211231034507.6iqa7nxwe27o77fw@apollo.legion>
References: <20211230023705.3860970-1-memxor@gmail.com>
 <20211230023705.3860970-3-memxor@gmail.com>
 <20211231022307.3cwff3suzemuiiqk@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231022307.3cwff3suzemuiiqk@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 31, 2021 at 07:53:07AM IST, Alexei Starovoitov wrote:
> On Thu, Dec 30, 2021 at 08:06:58AM +0530, Kumar Kartikeya Dwivedi wrote:
> > [...]
> > +
> > +	/* Identify type */
> > +	symbol_name += pfx_size;
> > +	if (!*symbol_name) {
> > +		bpf_log(bdata->log, "incomplete kfunc btf_id_set specification: %s\n", orig_name);
> > +		return -EINVAL;
> > +	}
> > +	for (i = 0; i < ARRAY_SIZE(kfunc_type_str); i++) {
> > +		pfx_size = strlen(kfunc_type_str[i]);
> > +		if (strncmp(symbol_name, kfunc_type_str[i], pfx_size))
> > +			continue;
> > +		break;
> > +	}
> > +	if (i == ARRAY_SIZE(kfunc_type_str)) {
> > +		bpf_log(bdata->log, "invalid type '%s' for kfunc_btf_id_set %s\n", symbol_name,
> > +			orig_name);
> > +		return -EINVAL;
> > +	}
> > +	type = i;
> > +
> > +	return btf_populate_kfunc_sets(bdata->btf, bdata->log, hook, type, set);
>
> I really like the direction taken by patches 2 and 3.
> I think we can save the module_kallsyms_on_each_symbol loop though.
> The registration mechanism, like:
>   register_kfunc_btf_id_set(&prog_test_kfunc_list, &bpf_testmod_kfunc_btf_set);
> doesn't have to be complete removed.
> It can replaced with a sequence of calls:
>   btf_populate_kfunc_sets(btf, hook, type, set);
> from __init of the module.
> The module knows its 'hook' and 'type' and set==&bpf_testmod_kfunc_btf_set.
> The bpf_testmod_init() can call btf_populate_kfunc_sets() multiple
> times to popualte sets into different hooks and types.
> There is no need to 'unregister' any more.
> And the patch 1 will no longer be necessary, since we don't need to iterate
> every symbol of the module with module_kallsyms_on_each_symbol().
> No need to standardize on the prefix and kfunc_[hook|type]_str,
> though it's probably good idea anyway across module BTF sets.
> The main disadvantage is that we lose 'log' in btf_populate_kfunc_sets(),
> since __init of the module cannot have verifier log at that point.
> But it can stay as 'ret = -E2BIG;' without bpf_log() and module registration
> will fail in such case or we just warn inside __init if btf_populate_kfunc_sets
> fails in the rare case.
> wdyt?
>

Sounds good, I'll make this change in the next version. Should I also drop
kallsyms_on_each_symbol for vmlinux BTF? I think we can use initcall for it too,
right?

> > +}
> > +
> > +static int btf_parse_kfunc_sets(struct btf *btf, struct module *mod,
> > +				struct bpf_verifier_log *log)
> > +{
> > +	struct btf_parse_kfunc_data data = { .btf = btf, .log = log, };
> > +	struct btf_kfunc_set_tab *tab;
> > +	int hook, type, ret;
> > +
> > +	if (!btf_is_kernel(btf))
> > +		return -EINVAL;
> > +	if (WARN_ON_ONCE(btf_is_module(btf) && !mod)) {
> > +		bpf_log(log, "btf internal error: no module for module BTF %s\n", btf->name);
> > +		return -EFAULT;
> > +	}
> > +	if (mod)
> > +		ret = module_kallsyms_on_each_symbol(mod, btf_parse_kfunc_sets_cb, &data);
> > +	else
> > +		ret = kallsyms_on_each_symbol(btf_parse_kfunc_sets_cb, &data);
> > +
> > +	tab = btf->kfunc_set_tab;
> > +	if (!ret && tab) {
> > +		/* Sort all populated sets */
> > +		for (hook = 0; hook < ARRAY_SIZE(tab->sets); hook++) {
> > +			for (type = 0; type < ARRAY_SIZE(tab->sets[0]); type++) {
> > +				struct btf_id_set *set = tab->sets[hook][type];
> > +
> > +				/* Not all sets may be populated */
> > +				if (!set)
> > +					continue;
> > +				sort(set->ids, set->cnt, sizeof(set->ids[0]), btf_kfunc_ids_cmp,
> > +				     NULL);
>
> Didn't resolve_btfid store ids already sorted?
> Why another sort is needed?

Because it might be possible while iterating over symbols (be it vmlinux or
module), we combine sets like [1, 4, 6] and [2, 3, 5] into [1, 4, 6, 2, 3, 5],
into the set for a certain hook, type, so to enable bsearch we do one final sort
after possible sets have been populated.

> Because btf_populate_kfunc_sets() can concatenate the sets?
> But if we let __init call it directly the module shouldn't use
> the same hook/type combination multiple times with different sets.
> So no secondary sorting will be necessary?
>

Yes, if we make it that only one call per hook/type can be done, then this
shouldn't be needed, but e.g. if each file has a set for some hook and uses late
initcall to do registration, then it will be needed again for the same reason.

We can surely catch the second call (see if tab->[hook][type] != NULL).

> > This commit prepares the BTF parsing functions for vmlinux and module
> > BTFs to find all kfunc BTF ID sets from the vmlinux and module symbols
> > and concatentate all sets into single unified set which is sorted and
> > keyed by the 'hook' it is meant for, and 'type' of set.
>
> 'sorted by hook' ?
> The btf_id_set_contains() need to search it by 'id', so it's sorted by 'id'.

Yeah, it needs a comma after 'sorted' :).

> Is it because you're adding mod's IDs to vmlinux IDs and re-sorting them?

No, I'm not mixing them. We only add same module's/vmlinux's IDs to its struct
btf, then sort each set (for hook,type pair). find_kfunc_desc_btf gives us the
BTF, then we can directly do what is essentially a single btf_id_set_contains
call, so it is not required to research in vmlinux BTF. The BTF associated with
the kfunc call is known.

> I think that's not worth optimizing. The patch 5 is doing:
> btf_kfunc_id_set_contains(btf, prog_type, BTF_KFUNC_TYPE_RELEASE|ACQUIRE|RET_NULL, id)
> but btf_kfunc_id_set_contains doesn't have to do it in a single bsearch.
> The struct btf of the module has base_btf.
> So btf_kfunc_id_set_contains() can do bsearch twice. Once in mod's btf sets[type][hook]
> and once in vmlinux btf sets[type][hook]
> and no secondary sorting will be necessary.
> wdyt?

--
Kartikeya
