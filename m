Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E3A479EFF
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 04:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhLSDVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 22:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhLSDVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 22:21:32 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E29C061574;
        Sat, 18 Dec 2021 19:21:32 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id 8so5657795pfo.4;
        Sat, 18 Dec 2021 19:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EyEKJq5v/rbw5tDKJvy6J6L6dJJmf/6d66RygYQe82U=;
        b=Lg4N8fKFKJBQ+/0yfepVLcpxpTERHqL3HeLDTKGqs6N7Yt9ANwm8iHlcYvU4eK9mL/
         WC6O0QKx5Uku1NDyYSApgjzfjJ1F0MHPVMgqSdSGByEfzsbW7DtkMfQkP7c9LlSQ2idj
         fePrPW38ktfK6wd/Piiy79mgDtVQ6Hm+bQrlFBBOav69gPetrLDyYlX677N5d72XeThf
         0iL/5rxme5LkagQo/Av//5BjqSZgWvlY2JYpb8ljmQ4PSXlRvski5r8V3YUzApPHEIV/
         T2M1lasrraaIOkBpbYF3Hgg9SRDCl/BEBrsEf+iRIh2ERpEzyqtBIOocvu5EEt6OGfNg
         MDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EyEKJq5v/rbw5tDKJvy6J6L6dJJmf/6d66RygYQe82U=;
        b=LFSKPZL2m+ZQYcrv5NJyClYqiOhYg82P+Cm98GCivQUID2kLXKGPJvpFaOZxQkuyVU
         DdlYl3BZv0cZm9RVCmZpqDaPLw1ZrW+OUKR5dHqb+GiDzSXqJQS6d7uebcpqMTLIuf6Q
         PhNC4AgyfrOa8piQkf+nmwRav6QJyaIQMl/cAvi1KDmXATLGlpIvdIDVmp+8HQjXGMBD
         4uZkrsbKytwGbIxnLOe42bzyKiA0ULw16wbJHTixtOCsReuAmuu/f2WZulZOkcuxqEB6
         cmaE8aiSK/0Rbg4YhSt1XZB973dIUt4MKvPAV6elwog+4NeZ5Aio8Di9zOO20MTS4Ebl
         IJCg==
X-Gm-Message-State: AOAM533cgQdWG619uehgLWc8W4hGB9pylbzPnjntRylTJd1uO0EHCToB
        pDDe86+11QOAdpNPqpQcBg8=
X-Google-Smtp-Source: ABdhPJwv6+Kr7Z5H7DzdolpaJkhO3R/u0l2X1l7+S8hqyW/26xkWhi28E2lQP5lSG2r4o7+ZDVsRZQ==
X-Received: by 2002:a63:6806:: with SMTP id d6mr9428367pgc.68.1639884092092;
        Sat, 18 Dec 2021 19:21:32 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id s30sm12962574pfw.57.2021.12.18.19.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 19:21:31 -0800 (PST)
Date:   Sun, 19 Dec 2021 08:51:29 +0530
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
Subject: Re: [PATCH bpf-next v4 03/10] bpf: Extend kfunc with PTR_TO_CTX,
 PTR_TO_MEM argument support
Message-ID: <20211219032129.e6sv73ycalnuvabv@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-4-memxor@gmail.com>
 <20211219021722.yf4cnmar33lrpcje@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219021722.yf4cnmar33lrpcje@ast-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 07:47:22AM IST, Alexei Starovoitov wrote:
> On Fri, Dec 17, 2021 at 07:20:24AM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > +/* Returns true if struct is composed of scalars, 4 levels of nesting allowed */
> > +static bool __btf_type_is_scalar_struct(struct bpf_verifier_log *log,
> > +					const struct btf *btf,
> > +					const struct btf_type *t, int rec)
> > +{
> > +	const struct btf_type *member_type;
> > +	const struct btf_member *member;
> > +	u16 i;
> > +
> > +	if (rec == 4) {
> > +		bpf_log(log, "max struct nesting depth 4 exceeded\n");
> > +		return false;
> > +	}
>
> As Matteo found out that saves stack with gcc only,
> so I moved this check few lines below, just before recursive call.
>
> > +			if (is_kfunc) {
> > +				/* Permit pointer to mem, but only when argument
> > +				 * type is pointer to scalar, or struct composed
> > +				 * (recursively) of scalars.
> > +				 */
> > +				if (!btf_type_is_scalar(ref_t) && !__btf_type_is_scalar_struct(log, btf, ref_t, 0)) {
>
> ... and reformatted this line to fit screen width.
>
> ... and applied.
>

Thanks.

> Please add individual selftest for this feature
> (not tied into refcnted kfuncs and CT).

Ok, I'll add more in v5, but the second one in calls.c in patch 10/10 does check
it.

--
Kartikeya
