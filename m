Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F366479197
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 17:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239109AbhLQQkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 11:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhLQQku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 11:40:50 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9462CC061574;
        Fri, 17 Dec 2021 08:40:50 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id e136so8134552ybc.4;
        Fri, 17 Dec 2021 08:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VuKy97n+pvrEyUjjZtn/z+TPlDe4v1Gy7paYi8bS/OU=;
        b=jGDSmYtynlqbfI6TP8Mmls1coEQw7yJ3JaKCbgoeinwDynTv09pmZGJne2SMbiT1N8
         oLE6ne/9pf0INlQhXo/1pVCFC3hyFaAPFFzmNbgtE2l2Lrs/Df50zS/XpbayFQAplQ/l
         s0OhPIQ4dGYBLMhgzGsBc7FqV2U8i0F3qfT0vKmRR3cL2GdmtlHHMO4KWlCbP9qxL66i
         2dJIwWmatqouSWHHj6E/Gof3WCE1ITfV9BEwn2o5Niz2BPmNRlY+jQlxShXmtwhMjWOH
         lQSNiu7Pu1aeJZcFF63ZfxO3o1UgXI01qfq/fxb+r8dkyce7KR33JxrMKZAR43OE2t8V
         jyJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VuKy97n+pvrEyUjjZtn/z+TPlDe4v1Gy7paYi8bS/OU=;
        b=AMMFklos2YJz08DHyr62rLN2neR0j0kv8ZrMU8HjAQujgAqZQgl57+X7Ugq/rvbWaB
         ouTbuwGyCpXdR+FXtw17TbTP9qVnjiJE1ANJnxXghYPPYDPm0m/Chdv3gWCJQgbY3pBQ
         QQEkS3x951pKOEIjglZjhkLblfBdBMAo/LYRp3aDPe6ivLo2LlUGk2jIckZC+RhDxRjw
         3EtKfb8QZ+AJOPM5RY/4nAVwI9SWmvytXpVBeXGz1ewW8xI7wTQ8NqVuCmGObOMlubfV
         M+al33Vr3IN+e0p0S8jbMQOqlYYbwUNd5cb6HWOqAnUvGE1A3lt63W4kqEETXwloX/1D
         YiDw==
X-Gm-Message-State: AOAM532FLrsHqZoTLWlDLlf3On8TPnu4VCq6Jx7Gr4odiSRjVVSQmLEa
        BvCVbVhuamREWxQ+LQX8YCwYe13dkBcGvjoRMzHVEDAjxMISEA==
X-Google-Smtp-Source: ABdhPJzXsLZIbf31G51Rgfg9SNwXjGvtFAEG48ip1lMq18fCEY79SBz7u0Jv9fZfDGPkw4LyFFUUtFnQgOFH4QJZ858=
X-Received: by 2002:a25:4cc5:: with SMTP id z188mr5492967yba.248.1639759249767;
 Fri, 17 Dec 2021 08:40:49 -0800 (PST)
MIME-Version: 1.0
References: <20211217015031.1278167-1-memxor@gmail.com> <20211217093612.wfsftv4kuqzotkmn@apollo.legion>
In-Reply-To: <20211217093612.wfsftv4kuqzotkmn@apollo.legion>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Dec 2021 08:40:38 -0800
Message-ID: <CAEf4BzZzd7gzky1CJAFgG4m_VQ0nS05J_kSgEkcnBQiY0uuNOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/10] Introduce unstable CT lookup helpers
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
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
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 1:36 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> On Fri, Dec 17, 2021 at 07:20:21AM IST, Kumar Kartikeya Dwivedi wrote:
> > This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
> > patch adding the lookup helper is based off of Maxim's recent patch to aid in
> > rebasing their series on top of this, all adjusted to work with module kfuncs [0].
> >
> >   [0]: https://lore.kernel.org/bpf/20211019144655.3483197-8-maximmi@nvidia.com
> >
> > To enable returning a reference to struct nf_conn, the verifier is extended to
> > support reference tracking for PTR_TO_BTF_ID, and kfunc is extended with support
> > for working as acquire/release functions, similar to existing BPF helpers. kfunc
> > returning pointer (limited to PTR_TO_BTF_ID in the kernel) can also return a
> > PTR_TO_BTF_ID_OR_NULL now, typically needed when acquiring a resource can fail.
> > kfunc can also receive PTR_TO_CTX and PTR_TO_MEM (with some limitations) as
> > arguments now. There is also support for passing a mem, len pair as argument
> > to kfunc now. In such cases, passing pointer to unsized type (void) is also
> > permitted.
> >
> > Please see individual commits for details.
> >
> > Note: BPF CI needs to add the following to config to test the set. I did update
> > the selftests config in patch 8, but not sure if that is enough.
> >
> >       CONFIG_NETFILTER=y
> >       CONFIG_NF_DEFRAG_IPV4=y
> >       CONFIG_NF_DEFRAG_IPV6=y
> >       CONFIG_NF_CONNTRACK=y
> >
>
> Hm, so this is not showing up in BPF CI, is it some mistake from my side? The
> last couple of versions produced build time warnings in Patchwork, that I fixed,
> which I suspected was the main cause.

Not a mistake, for BPF CI there are separate configs that need to be
updated manually:
  - https://github.com/kernel-patches/vmtest/blob/master/.github/actions/vmtest/latest.config
for kernel patches CI
  - https://github.com/libbpf/libbpf/tree/master/travis-ci/vmtest/configs
(there is x86-64 and s390x configs) for libbpf CI

>
> There's still one coming from the last patch, but based on [0], I am not sure
> whether I should be doing things any differently (and if I do fix it, it also
> needs to be done for the functions added before). The warnings are from the 11
> new kfuncs I added in net/bpf/test_run.c, for their missing declarations.
>
> Comments?
>
> [0]: https://lore.kernel.org/bpf/20200326235426.ei6ae2z5ek6uq3tt@ast-mbp
>
> > [...]
>
> --
> Kartikeya
