Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A06A4861B7
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 09:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbiAFI7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 03:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiAFI7R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 03:59:17 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBF8C061245;
        Thu,  6 Jan 2022 00:59:17 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 196so1967133pfw.10;
        Thu, 06 Jan 2022 00:59:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/x1jBnUoh/TQJus9KFQbr1QInsqNrjuVnzXHgZXexQQ=;
        b=WBMPPCw7FMZXg71SU2ZuGLYSgqOWbtYRK5JrNyGL6vTpvq1bzEGr4WtwjgjUoy66OV
         Lyhotv+7FvjKDyOIv4v1z9l7oIzEpWM5twQRGCa5U2v06CFoNFoCQc5I7mTA6I1o5WNt
         Zw6YnU1QuMy5s43BpKypXxd4scQAR/5nMoqfl8672NDDCFGEtuZ3N//03bm6YMHDT8xn
         ACW4zRUjUGnHABDhYx8VVvH0aDlGHB3Xr89eGlhuqQswrpm5k8kI4SXrY9Yb7CETzBa8
         Uj8PHFFCzgwOe733uDMFFp9suLvW4e70rGd+omztlQnKNXzVZKEgbUeaBkzO1q/nK/3D
         7dtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/x1jBnUoh/TQJus9KFQbr1QInsqNrjuVnzXHgZXexQQ=;
        b=QKWbgzcdjf3azqz7GHzAcnli9s1+uuldsJvjWe+N/wsgfNudwVDx/HiLCzcfbj5r3a
         th8ZvI54aUPqqGHRSzd2IACO+ufOLTZ/bc4URKGpnAHdKB0/+5ICHb/98ZBOjAwBs3TP
         0mKlJPz6Bi3qnO3MYEmBTHj8WTnGp90Uj0lPQ3ErysXAZvUJHmu1x0HbqgT8p+Bivel1
         hwQ9hTTUnUfc/8KazR2uRfco49EKJaINCBAngnX3FwRX7e/FunBFUoI9alqpwCuM22R9
         qX5fwU0/YStB5/qc8/C8mZPRErKtkuXgvCWfUSu8lfJQ2TIDnZXnfvhGt0hdYOMEr9js
         Mi/w==
X-Gm-Message-State: AOAM530SMGjOQEuiU0eyfF2Gh6kF8u9dSRr+B1YG7HCt9Hw/ZafsWVIt
        mtMZRPWEAyuF6UBDW0/onkk=
X-Google-Smtp-Source: ABdhPJy+Gfb3PBidkaUhwqIYYG+WyvDhYzxs1Ma8qGvnFN1PdyR8lsHwdBZvcQR8hNuXBU2f3F+YVA==
X-Received: by 2002:aa7:84cc:0:b0:4bc:54ec:d5e4 with SMTP id x12-20020aa784cc000000b004bc54ecd5e4mr32465024pfn.66.1641459556404;
        Thu, 06 Jan 2022 00:59:16 -0800 (PST)
Received: from localhost ([103.4.221.252])
        by smtp.gmail.com with ESMTPSA id rj1sm1674673pjb.36.2022.01.06.00.59.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 00:59:16 -0800 (PST)
Date:   Thu, 6 Jan 2022 14:29:06 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Message-ID: <20220106085906.3zeugweq3twnkwzh@apollo.legion>
References: <20220102162115.1506833-1-memxor@gmail.com>
 <20220102162115.1506833-4-memxor@gmail.com>
 <20220105061911.nzgzzvt2rpftcavi@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220105061911.nzgzzvt2rpftcavi@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 05, 2022 at 11:49:11AM IST, Alexei Starovoitov wrote:
> On Sun, Jan 02, 2022 at 09:51:07PM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > +enum btf_kfunc_hook {
> > +	BTF_KFUNC_HOOK_XDP,
> > +	BTF_KFUNC_HOOK_TC,
> > +	BTF_KFUNC_HOOK_STRUCT_OPS,
> > +	_BTF_KFUNC_HOOK_MAX,
>
> Why prefix with _ ?
>

Will fix.

> > +enum {
> > +	BTF_KFUNC_SET_MAX_CNT = 32,
> > +};
> ...
> > +	if (set_cnt + add_set->cnt > BTF_KFUNC_SET_MAX_CNT) {
> > +		ret = -E2BIG;
> > +		goto end;
> > +	}
>
> This artificial limit wouldn't be needed if you didn't insist on sorting.
> The later patches don't take advantage of this sorting feature and
> I don't see a test for sorting either.
>

I'm not insisting, but for vmlinux we will have multiple
register_btf_kfunc_id_set calls for same hook, so we have to concat multiple
sets into one, which may result in an unsorted set. It's ok to not sort for
modules where only one register call per hook is allowed.

Unless we switch to linear search for now (which is ok by me), we have to
re-sort for vmlinux BTF, to make btf_id_set_contains (in
btf_kfunc_id_set_contains) work.

> > +
> > +	/* Grow set */
> > +	set = krealloc(tab->sets[hook][type], offsetof(struct btf_id_set, ids[set_cnt + add_set->cnt]),
> > +		       GFP_KERNEL | __GFP_NOWARN);
> > +	if (!set) {
> > +		ret = -ENOMEM;
> > +		goto end;
> > +	}
> > +
> > +	/* For newly allocated set, initialize set->cnt to 0 */
> > +	if (!tab->sets[hook][type])
> > +		set->cnt = 0;
> > +	tab->sets[hook][type] = set;
> > +
> > +	/* Concatenate the two sets */
> > +	memcpy(set->ids + set->cnt, add_set->ids, add_set->cnt * sizeof(set->ids[0]));
> > +	set->cnt += add_set->cnt;
>
> Without sorting this function would just assign the pointer.
> No need for krealloc and memcpy.
>

Even if we didn't sort, we'd need to concat multiple sets for vmlinux case, so
krealloc and memcpy would still be needed for the vmlinux BTF case, right? For
modules I could certainly do a direct assignment, even if we keep sorting,
because only one set per hook is permitted.

> > +
> > +	if (sort_set)
> > +		sort(set->ids, set->cnt, sizeof(set->ids[0]), btf_id_cmp_func, NULL);
>
> All that looks like extra code for a dubious feature.
>

It's needed for the vmlinux case. I use WARN_ON_ONCE when modules try to
register more than one set for a certain hook.

> > +bool btf_kfunc_id_set_contains(const struct btf *btf,
> > +			       enum bpf_prog_type prog_type,
> > +			       enum btf_kfunc_type type, u32 kfunc_btf_id)
> > +{
> > +	enum btf_kfunc_hook hook;
> > +
> > +	switch (prog_type) {
> > +	case BPF_PROG_TYPE_XDP:
> > +		hook = BTF_KFUNC_HOOK_XDP;
> > +		break;
> > +	case BPF_PROG_TYPE_SCHED_CLS:
> > +		hook = BTF_KFUNC_HOOK_TC;
> > +		break;
> > +	case BPF_PROG_TYPE_STRUCT_OPS:
> > +		hook = BTF_KFUNC_HOOK_STRUCT_OPS;
> > +		break;
> > +	default:
> > +		return false;
> > +	}
>
> So this switch() is necessary only to compress prog_types into smaller hooks
> to save memory in the struct btf_kfunc_set_tab, right ?
> If so both kfunc_id_set_contains() and register_btf_kfunc() should
> probably use prog_type as an argument for symmetry.

Ok, will fix.

--
Kartikeya
