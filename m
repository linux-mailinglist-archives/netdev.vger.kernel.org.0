Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 547C24703E4
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 16:31:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242870AbhLJPfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhLJPfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 10:35:07 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF10C061746;
        Fri, 10 Dec 2021 07:31:32 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso7800115pjl.3;
        Fri, 10 Dec 2021 07:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GmMgSJl49zzsKmujGBq1/GKCheREG+aHuBZn5X9zec8=;
        b=OInQHPsFh8QlZ3nsvgVAWVIUzWiqT4ACnBqvELU1Ie8Gyc4L/9Fp5aSoZgxRxz+qdJ
         Kgb+FhrdHydpVVji2anqr5M7zKaENoath1ZiJErNtlU71KkJolopTZwNztxFU+pEdI95
         AACUhq75T9traKSaSOOGrl3xQV9vfWZkn823zSvGwRrlZPmRCmG2aS4cXJmVnoITUawR
         XHoZ62hudq5GUdC329VUKZQTy8a4M+R2GmV1rpIsICyNwdHkYVydy5i/KYsxAp4soqm2
         0KeEoGylEwDwXca1SI3ddXodQO9bTgDx4JmYKFao1igJCJYK0q1yv4hAW+76X/SfEOfL
         /tMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GmMgSJl49zzsKmujGBq1/GKCheREG+aHuBZn5X9zec8=;
        b=YfxD4CclW13s62lIStcORdF62wGvI0Pu+tQ3Vg+n8XkUGajY9ZhPT3Tu5dbGHso4nz
         daByEFbXLLExtJSeLOY/1u+OLiFoxC+b6x9CbjEch43UxSzQs/tKxk3zrx2XLWnLQG34
         ezHKa5g749haxa/KuLT+G71W2Sdy/bjHBdDWQAXX6ash77ShzzOHpKI0pPpCJGgohzrR
         xNG80VgLk/TQhza0XHU8rj5sfJbhMNzCDcOH2mUMWSI9eQyNyZKDnqmmRiaYdPYWPmxa
         rrXRv2B6hRJ5iPECgD768J8raQSHlMmP2NZSPTXtRvUcwOUhuY6Yd1IAJV4ngnvMLC1m
         gSww==
X-Gm-Message-State: AOAM5337RRKjaGVB0OGNiskFwQz8sGWd8seJltXZhsH7JlidwrjsxNAJ
        9vlnl/O4MtArGURIN7nrEHc=
X-Google-Smtp-Source: ABdhPJwUOu1SkB7OR8mR0uykpCWAfXNZZW+m0ex7PRT6nTzcK4o/C1QlpAHyHZR2CAyz4nCZ05Xc/w==
X-Received: by 2002:a17:902:bd06:b0:143:aa76:faf0 with SMTP id p6-20020a170902bd0600b00143aa76faf0mr75794437pls.88.1639150292405;
        Fri, 10 Dec 2021 07:31:32 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id f21sm3969562pfc.191.2021.12.10.07.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 07:31:32 -0800 (PST)
Date:   Fri, 10 Dec 2021 21:01:29 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 7/9] net/netfilter: Add unstable CT lookup
 helpers for XDP and TC-BPF
Message-ID: <20211210153129.srb6p2ebzhl5yyzh@apollo.legion>
References: <20211210130230.4128676-1-memxor@gmail.com>
 <20211210130230.4128676-8-memxor@gmail.com>
 <YbNtmlaeqPuHHRgl@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbNtmlaeqPuHHRgl@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 08:39:14PM IST, Pablo Neira Ayuso wrote:
> On Fri, Dec 10, 2021 at 06:32:28PM +0530, Kumar Kartikeya Dwivedi wrote:
> [...]
> >  net/netfilter/nf_conntrack_core.c | 252 ++++++++++++++++++++++++++++++
> >  7 files changed, 497 insertions(+), 1 deletion(-)
> >
> [...]
> > diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> > index 770a63103c7a..85042cb6f82e 100644
> > --- a/net/netfilter/nf_conntrack_core.c
> > +++ b/net/netfilter/nf_conntrack_core.c
>
> Please, keep this new code away from net/netfilter/nf_conntrack_core.c

Ok. Can it be a new file under net/netfilter, or should it live elsewhere?

--
Kartikeya
