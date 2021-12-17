Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2B4787D8
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 10:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbhLQJgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 04:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbhLQJgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 04:36:16 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B2FFC061574;
        Fri, 17 Dec 2021 01:36:16 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so1694431pjp.0;
        Fri, 17 Dec 2021 01:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yt5Brr199FpmnQF/fDrtbYXhOKy80d72KAvMetFE6Xk=;
        b=SVtRRi3VilPuBBmWHf4mX8Saz8QCRJaWGZqE1niaAUiWcyKL76VwCrGqsfwf8EmRBw
         QrcuyYzdE1qAngWXV4BR39tjCOG1nI2ufW8oTblWBNj1iLuQZs9+iDa1hBL5zGHHmkpb
         qaqSt7jX4BPDR3EDfOlrb6U8ATXeB6FCCp1s0q83iwaky0zz1x+0Ww6DcoQllVgQt2RC
         7PXQt8N2QGzPg/6mWpMp7a/2nUpy+mntD+Xviy6HSXUM6e5V4pkwh2/cz2pEO5QGuOba
         K45jzM6jdVRyvALY+nBNEwyfo8L9wmBEDGbXgTVION1C6RAnqnX9om9VodUXCQk2C/p6
         MSpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yt5Brr199FpmnQF/fDrtbYXhOKy80d72KAvMetFE6Xk=;
        b=YgP4ukQYitF+DsjZIhKhzyNpLRFkF+F9F6iNtnzlzeK4OqYvkd6EZdLyi3DFw99cPE
         sA8peapRg0Cf128+dojrcjVhM5UYe7yxNttVF4s/7Bhgy+Dyj4UOWhWvX+/+L3/m9CQk
         /TMuCPLnxgCeleK7ncRXtbNytE+VNHItyAEf0YqBJYeGLEL4rQ8hjoipOt/ADW9uSwl/
         spFiPTLh74jM8rizPvwiqZYNTyk5TSX5LCcQeqZJuT0i2ePvvp2sEdSObvnctIgDf4lg
         lcEZNAuMdJ4fEr/wcf4Y2EKeWpGckFMeBbKmTV4FXf3DRyvb+EVI448T3csDbwvxybiT
         dHjA==
X-Gm-Message-State: AOAM5313O9Sunr3OX0V9jHZb3pPs6R/ztKRaQjbCEG6t+HPvCyzjz/ST
        On9b7aMuLQEbS7Db86KbWnjHrrkNcVw=
X-Google-Smtp-Source: ABdhPJwLETfil0C9sup17AezSTmMKiPT3O4k5lcwTWXjfAz2AfY70W7lOJ0SgFHLH/Ljk+tB51EMsQ==
X-Received: by 2002:a17:90b:33c6:: with SMTP id lk6mr640041pjb.134.1639733775549;
        Fri, 17 Dec 2021 01:36:15 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id f2sm9650213pfe.132.2021.12.17.01.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 01:36:15 -0800 (PST)
Date:   Fri, 17 Dec 2021 15:06:12 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
Subject: Re: [PATCH bpf-next v4 00/10] Introduce unstable CT lookup helpers
Message-ID: <20211217093612.wfsftv4kuqzotkmn@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211217015031.1278167-1-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 07:20:21AM IST, Kumar Kartikeya Dwivedi wrote:
> This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
> patch adding the lookup helper is based off of Maxim's recent patch to aid in
> rebasing their series on top of this, all adjusted to work with module kfuncs [0].
>
>   [0]: https://lore.kernel.org/bpf/20211019144655.3483197-8-maximmi@nvidia.com
>
> To enable returning a reference to struct nf_conn, the verifier is extended to
> support reference tracking for PTR_TO_BTF_ID, and kfunc is extended with support
> for working as acquire/release functions, similar to existing BPF helpers. kfunc
> returning pointer (limited to PTR_TO_BTF_ID in the kernel) can also return a
> PTR_TO_BTF_ID_OR_NULL now, typically needed when acquiring a resource can fail.
> kfunc can also receive PTR_TO_CTX and PTR_TO_MEM (with some limitations) as
> arguments now. There is also support for passing a mem, len pair as argument
> to kfunc now. In such cases, passing pointer to unsized type (void) is also
> permitted.
>
> Please see individual commits for details.
>
> Note: BPF CI needs to add the following to config to test the set. I did update
> the selftests config in patch 8, but not sure if that is enough.
>
> 	CONFIG_NETFILTER=y
> 	CONFIG_NF_DEFRAG_IPV4=y
> 	CONFIG_NF_DEFRAG_IPV6=y
> 	CONFIG_NF_CONNTRACK=y
>

Hm, so this is not showing up in BPF CI, is it some mistake from my side? The
last couple of versions produced build time warnings in Patchwork, that I fixed,
which I suspected was the main cause.

There's still one coming from the last patch, but based on [0], I am not sure
whether I should be doing things any differently (and if I do fix it, it also
needs to be done for the functions added before). The warnings are from the 11
new kfuncs I added in net/bpf/test_run.c, for their missing declarations.

Comments?

[0]: https://lore.kernel.org/bpf/20200326235426.ei6ae2z5ek6uq3tt@ast-mbp

> [...]

--
Kartikeya
