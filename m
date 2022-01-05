Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AD0484E4E
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 07:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbiAEGTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 01:19:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiAEGTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 01:19:20 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8676C061395;
        Tue,  4 Jan 2022 22:19:14 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso2512653pje.0;
        Tue, 04 Jan 2022 22:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Rsuq8U75Y7DnzY2eBcjcdz6eXja5MIiZ/3OfqerurIE=;
        b=Poh7IMLqJE0mM1seq7nUsy7wj/54PzY5qP8pMco0HDrGXwpelwhNvXkBIb4HHvHgkz
         qjhSitDfDoMbdMG7Tebw/ahw/SZvkkv+aTOw7jR5/eVf7rFnGWW8271c7t5Sv4TPPLsx
         JNfVoOIyOMkUtexxIG8PTKjaqh4hnznDXPCejf/QaL02DIGGkvZG2z1CFmGTF/L8uqhU
         dQiQZcTnbM7TSdShcdaH4swHeRuhWtQMJO9kNZtNrJMH6dQrJrnQqW4yBuK4mJJ/XO6l
         TGeacJgT5xn60BxvSOjMVtr/ekxh3Yz++wFVGh4sDLApLVx8+LpOtH36nkgkpFuwjtRd
         Gn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Rsuq8U75Y7DnzY2eBcjcdz6eXja5MIiZ/3OfqerurIE=;
        b=UgB5yDUrEyu+FG9w2kNed+nm2q2Wf169Fq+FTh+mM65qNgznLSb/Ql+uWxtpzK6Elv
         OorfYXXZhKbVwjDapELxxjJPbGMj/nC112eghfOvYX1F583ZmUkMRGb5p8CgpHmswe4p
         XA5C4m3+bjxt5HNVHH7J2ZkC2F0ea+J9NtWYdRAPzQ2XZ/MDRYjPLE5lH9y4CKsynIES
         w8Gro3bJXbBV6OxpROJfMYOOUz+SRslmOkmfZmSJVE9dbMSoHq5pFQ9VAtrSjcAwa8Hc
         kg83PxuEMU+pJtDYxyPCp9z3tOoKrrD9PjlHJioPB/x2bxaryyuwidSkqt57SdplcX/v
         lWXw==
X-Gm-Message-State: AOAM532QOfZ/y9uS5T0fToq6ueggM/Y5jJDVo5DnGq24/NXK/NtJ39nT
        euxBRFNT+5jqVETpQDGxO9c=
X-Google-Smtp-Source: ABdhPJxbhYqz6y2CTqHZV654Y9VGDisZF+Bh3OAPQSskdvzDWG7d7Sc45Fa7IWM+D3OW2zLqmyo2rg==
X-Received: by 2002:a17:902:76c3:b0:149:ac0a:1662 with SMTP id j3-20020a17090276c300b00149ac0a1662mr21650753plt.92.1641363554429;
        Tue, 04 Jan 2022 22:19:14 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1a5b])
        by smtp.gmail.com with ESMTPSA id n14sm35836381pgd.80.2022.01.04.22.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 22:19:14 -0800 (PST)
Date:   Tue, 4 Jan 2022 22:19:11 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v6 03/11] bpf: Populate kfunc BTF ID sets in
 struct btf
Message-ID: <20220105061911.nzgzzvt2rpftcavi@ast-mbp.dhcp.thefacebook.com>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-4-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220102162115.1506833-4-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 09:51:07PM +0530, Kumar Kartikeya Dwivedi wrote:
>  
> +enum btf_kfunc_hook {
> +	BTF_KFUNC_HOOK_XDP,
> +	BTF_KFUNC_HOOK_TC,
> +	BTF_KFUNC_HOOK_STRUCT_OPS,
> +	_BTF_KFUNC_HOOK_MAX,

Why prefix with _ ?

> +enum {
> +	BTF_KFUNC_SET_MAX_CNT = 32,
> +};
...
> +	if (set_cnt + add_set->cnt > BTF_KFUNC_SET_MAX_CNT) {
> +		ret = -E2BIG;
> +		goto end;
> +	}

This artificial limit wouldn't be needed if you didn't insist on sorting.
The later patches don't take advantage of this sorting feature and
I don't see a test for sorting either.

> +
> +	/* Grow set */
> +	set = krealloc(tab->sets[hook][type], offsetof(struct btf_id_set, ids[set_cnt + add_set->cnt]),
> +		       GFP_KERNEL | __GFP_NOWARN);
> +	if (!set) {
> +		ret = -ENOMEM;
> +		goto end;
> +	}
> +
> +	/* For newly allocated set, initialize set->cnt to 0 */
> +	if (!tab->sets[hook][type])
> +		set->cnt = 0;
> +	tab->sets[hook][type] = set;
> +
> +	/* Concatenate the two sets */
> +	memcpy(set->ids + set->cnt, add_set->ids, add_set->cnt * sizeof(set->ids[0]));
> +	set->cnt += add_set->cnt;

Without sorting this function would just assign the pointer.
No need for krealloc and memcpy.

> +
> +	if (sort_set)
> +		sort(set->ids, set->cnt, sizeof(set->ids[0]), btf_id_cmp_func, NULL);

All that looks like extra code for a dubious feature.

> +bool btf_kfunc_id_set_contains(const struct btf *btf,
> +			       enum bpf_prog_type prog_type,
> +			       enum btf_kfunc_type type, u32 kfunc_btf_id)
> +{
> +	enum btf_kfunc_hook hook;
> +
> +	switch (prog_type) {
> +	case BPF_PROG_TYPE_XDP:
> +		hook = BTF_KFUNC_HOOK_XDP;
> +		break;
> +	case BPF_PROG_TYPE_SCHED_CLS:
> +		hook = BTF_KFUNC_HOOK_TC;
> +		break;
> +	case BPF_PROG_TYPE_STRUCT_OPS:
> +		hook = BTF_KFUNC_HOOK_STRUCT_OPS;
> +		break;
> +	default:
> +		return false;
> +	}

So this switch() is necessary only to compress prog_types into smaller hooks
to save memory in the struct btf_kfunc_set_tab, right ?
If so both kfunc_id_set_contains() and register_btf_kfunc() should
probably use prog_type as an argument for symmetry.
