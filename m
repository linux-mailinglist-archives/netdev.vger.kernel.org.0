Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BF5479EE9
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 03:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhLSCx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 21:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhLSCx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 21:53:57 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0607C061574;
        Sat, 18 Dec 2021 18:53:56 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so980565pjb.5;
        Sat, 18 Dec 2021 18:53:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gbrmeFBoFbrrn63omNp3qbJEqmTy+45r2+/WHgmZII0=;
        b=QdNCn79QRPHzFBTgiiYochOEebVSr+CnKy7rQNdVMD8+YLaOJEbO5Opk6cyqqRvDRZ
         wvSu37KX8fSdeHff2+msg6r59fOJQJQSsNUlOzPqChf3HkxIfpfcCLbXs6nkmDFLXAO6
         15LWl9LNjJ+/xUWko3zDsDj6uFBo++CsmMkNJ2hXEddGCcHvK3bEeyLrNCFQ7yqdaC/L
         bXi0ZgFvh8HTyWEIL1uGdPgk05YuhIAotSvR0584EXwxCNDKFM+zQzGSZ6FNYIYCKtaj
         2EFoIWnTGPKTCFigpPpKK2vouqW0tJABD022vn/PjCHUOar8Tfe1Qx6H07A5RFyrUN4r
         +20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gbrmeFBoFbrrn63omNp3qbJEqmTy+45r2+/WHgmZII0=;
        b=I2Nb/NfGoRZnh+qN4Uiv0ekG0PLvyr01GSyPem2EvgT+YRQz1GEVB9QMDaO94OjZn8
         fajJC3gjfUcwxvldDT8QTUcOBOcn8HKzWPUJfEKZcF6CDUHUUl7wX7dle8stIgS0PdFe
         bHXrR6aIkMkfPjTxhceZLnLTcapxnslkLtQXCzEPAGmJV5hu9/xfvcRrjRi2r5iCcYSO
         Tf94Tzhy17UwCq92Mz9Dzf8fKl7WmtC4senjKLqPJBjiATHit8HyJAwDMFPPfY/VplKg
         jsxYhADeM7YDgB0uOWPbLYyQP8G5EBdwnoPmw3ILCuOx1vrjwJmqlAWGYWb3E8H+o/vG
         +tqA==
X-Gm-Message-State: AOAM532H8/BSbJf9wYR/cz7ryIdc5S8j+fNKvq88sUCxN+zCbIdN2/NY
        6UR6lE9c0Ntcd8kOs2nuUc4=
X-Google-Smtp-Source: ABdhPJzSnTvg2yG+PiK1ktDEMTWLhiL3N3cZuvlg32zMFftsuszCC0+oOG/R2Z6CRfHiH4MtrrgwSg==
X-Received: by 2002:a17:90b:f0b:: with SMTP id br11mr8422927pjb.39.1639882436418;
        Sat, 18 Dec 2021 18:53:56 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id np1sm18146680pjb.22.2021.12.18.18.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 18:53:55 -0800 (PST)
Date:   Sun, 19 Dec 2021 08:23:53 +0530
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
Subject: Re: [PATCH bpf-next v4 04/10] bpf: Introduce mem, size argument pair
 support for kfunc
Message-ID: <20211219025353.57iaosx5zrjqjtuo@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-5-memxor@gmail.com>
 <20211219021922.2jhnvuhcg4zzcp32@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219021922.2jhnvuhcg4zzcp32@ast-mbp>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 07:49:22AM IST, Alexei Starovoitov wrote:
> On Fri, Dec 17, 2021 at 07:20:25AM +0530, Kumar Kartikeya Dwivedi wrote:
> > +static bool is_kfunc_arg_mem_size(const struct btf *btf,
> > +				  const struct btf_param *arg,
> > +				  const struct bpf_reg_state *reg)
> > +{
> > +	const struct btf_type *t;
> > +	const char *param_name;
> > +
> > +	t = btf_type_skip_modifiers(btf, arg->type, NULL);
> > +	if (!btf_type_is_scalar(t) || reg->type != SCALAR_VALUE)
> > +		return false;
> > +
> > +	/* In the future, this can be ported to use BTF tagging */
> > +	param_name = btf_name_by_offset(btf, arg->name_off);
> > +	if (strncmp(param_name, "len__", sizeof("len__") - 1))
> > +		return false;
>
> I like the feature and approach, but have a suggestion:
> The "__sz" suffix would be shorter and more readable.
> wdyt?

Sounds good, I'll change this in v5.

--
Kartikeya
