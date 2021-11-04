Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16730445365
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 13:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhKDM5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 08:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhKDM5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 08:57:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039A2C061714;
        Thu,  4 Nov 2021 05:55:07 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id q126so1383309pgq.13;
        Thu, 04 Nov 2021 05:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1EGh8Ks1kwTPl4HlYk/VIkwHYF+RXVJORjfcoMxNQ0k=;
        b=f8KeiW+0BHpKBKZg+GrvwjpWomrDRt0dipQqdvJIZocIqKsozCFr33jctWptn5H8Ny
         bag//weyAbkPOWmnACA2qFj6HLHdOnF2YS+zX1gsjCQOQolJwuZ8OhzlWmH0cmCJYWiF
         4BY75Z0/7A3pwZ2tBNSDJDe3lT8+X7OMUYgPSkHTb8lM44ST5BQRIQb+B1WMvAZx/pIZ
         8Iqb+jsDpO9PVCsGxGMRnRacXIAvjjcwKjIQI40mOj2i4CxLHFpA15agpt2BKmUAx+iH
         BSqxfPgRUvXo4Gdp0N+WQYUYJ1krlyDbxzRnnySiKa1nbD0r+MBMFtAyU9sCCMoeqcWD
         3FEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1EGh8Ks1kwTPl4HlYk/VIkwHYF+RXVJORjfcoMxNQ0k=;
        b=A22j/xZUEl3psNEPQzDaUz2/VK1oqrSsbj4Xew/YbwuOr5oVSOv0YNud6Z/evYBGsG
         8fIfEyEGJdLP0DI4oJyyPqy/SliU/PaXZXZLX6TCNHhJERMjFr7i43DLl0T44CxcU+w5
         EKfdSHavxqCHuixuoCzDdJpxaZ9TDBouRj1sf7PMX1P4kTe7AbNbx40v5OCU9z7qu+4R
         8nw9PVa4WdqC8q9zyh4d2BLORafwH9EL99VfAOghx2fZf7IrM7gXUTIZX3v2Kk29QhV3
         bN9xcAthr1wZLTYxGAZIyMfRnIn7uVvH2a0aduIA5Hal55EKZuwLhmuKMEz1y1H80WjL
         F8tw==
X-Gm-Message-State: AOAM531BZqjUhWcYgL1+xQPDvx51AebKTdTEahprW0TWG+6dw6Evk+Oj
        VB2BEzggUNNz26uJDSf/MegbtkHIJk5EYw==
X-Google-Smtp-Source: ABdhPJxirrIAw747a1+mWlD8z94haanRuiMYlL3nnbvTxRw6UeuKjFsU9H58klDOigBnF4yidY3tmQ==
X-Received: by 2002:aa7:888d:0:b0:46b:72b2:5d61 with SMTP id z13-20020aa7888d000000b0046b72b25d61mr51337250pfe.73.1636030506511;
        Thu, 04 Nov 2021 05:55:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d916:31fc:9e49:a605:b093])
        by smtp.gmail.com with ESMTPSA id j12sm5009703pfu.33.2021.11.04.05.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 05:55:06 -0700 (PDT)
Date:   Thu, 4 Nov 2021 18:25:03 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
Subject: Re: [PATCH RFC bpf-next v1 0/6] Introduce unstable CT lookup helpers
Message-ID: <20211104125503.smxxptjqri6jujke@apollo.localdomain>
References: <20211030144609.263572-1-memxor@gmail.com>
 <20211102231642.yqgocduxcoladqne@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211102231642.yqgocduxcoladqne@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 04:46:42AM IST, Alexei Starovoitov wrote:
> On Sat, Oct 30, 2021 at 08:16:03PM +0530, Kumar Kartikeya Dwivedi wrote:
> > This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
> > patch adding the lookup helper is based off of Maxim's recent patch to aid in
> > rebasing their series on top of this, all adjusted to work with kfunc support
> > [0].
> >
> > This is an RFC series, as I'm unsure whether the reference tracking for
> > PTR_TO_BTF_ID will be accepted.
>
> Yes. The patches look good overall.
> Please don't do __BPF_RET_TYPE_MAX signalling. It's an ambiguous name.
> _MAX is typically used for a different purpose. Just give it an explicit name.
> I don't fully understand why that skip is needed though.

I needed a sentinel to skip return type checking (otherwise check that return
type and prototype match) since existing kfunc don't have a
get_kfunc_return_type callback, but if we add bpf_func_proto support to kfunc
then we can probably convert existing kfuncs to that as well and skip all this
logic. Mostly needed it for RET_PTR_TO_BTF_ID_OR_NULL.

Extending to support bpf_func_proto seemed like a bit of work so I wanted to get
some feedback first on all this, before working on it.

> Why it's not one of existing RET_*. Duplication of return and
> being lazy to propagate the correct ret value into get_kfunc_return_type ?
>
> > If not, we can go back to doing it the typical
> > way with PTR_TO_NF_CONN type, guarded with #if IS_ENABLED(CONFIG_NF_CONNTRACK).
>
> Please don't. We already have a ton of special and custom types in the verifier.
> refcnted PTR_TO_BTF_ID sounds as good way to scale it.
>

Understood.

> > Also, I want to understand whether it would make sense to introduce
> > check_helper_call style bpf_func_proto based argument checking for kfuncs, or
> > continue with how it is right now, since it doesn't seem correct that PTR_TO_MEM
> > can be passed where PTR_TO_BTF_ID may be expected. Only PTR_TO_CTX is enforced.
>
> Do we really allow to pass PTR_TO_MEM argument into a function that expects PTR_TO_BTF_ID ?

Sorry, that's poorly phrased. Current kfunc doesn't support PTR_TO_MEM. I meant
it would be allowed now, with the way I implemented things, but there also isn't
a way to signal whether PTR_TO_BTF_ID is expected (hence the question about
bpf_func_proto). I did not understand why that was not done originally (maybe it
was lack of usecase). PTR_TO_CTX works because the type is matched with prog
type, so you can't pass something else there. For other cases the type of
register is considered.

> That sounds like a bug that we need to fix.

--
Kartikeya
