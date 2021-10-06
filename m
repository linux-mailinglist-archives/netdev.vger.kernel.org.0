Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF43424085
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbhJFOzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238205AbhJFOzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:55:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537BCC061746;
        Wed,  6 Oct 2021 07:53:43 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id pf6-20020a17090b1d8600b0019fa884ab85so4628803pjb.5;
        Wed, 06 Oct 2021 07:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jnJZeKgIptkk68YEHX3pQNflodspjjs/YieRerqVbnQ=;
        b=aL9VjuuHUNJaVNC9iLXknQyxlHAnJhm6LkmZGE53ljjZtVAwn701nzSehD0v8pOoIt
         PGZCAYHyVNfZuASyoe4sMKGG/Ct2bHF8/JZNlY8JQ3MUlks1IoI+qYTHdCQxoCTvG1Gw
         Gq8Cj2M94sejSt5WBLWmcd/vvqBfVz+mO+E+8jC9FYear58pQteEMvij+ePaC8V4Lvir
         dvNhG7JBEaRpkXuX89mfYoTheyFIthHisilLtV4FhVo7UpPCdrTdCWOlvNAKTBVNLRwc
         C7S0mIV68B9Tr91cXi1ih8UVPi3G7Ay38ZLNN28Ff2pMFReN0vWEC3kjHKqph6qh6UHe
         bUWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jnJZeKgIptkk68YEHX3pQNflodspjjs/YieRerqVbnQ=;
        b=GghviJOYTa90skkdH2zXjkZCks1b4h4DifPzexe3d+XYKhjuM3GNdftzLW1lIAJKBj
         xe8oYUWTNz27QPVbUqcApoKaWVoJZsTCxbLB9k4zM0yZ92o5VBzd9rbTx3D0eVqMLIPb
         C9D0mheGjdb5jKd0Wfd0l/RdKJEafz6ZtS210walcaU02ZVHG5XrhoQoTkvqFQ6HWW0a
         x6PdvwpPbSMzDbO42YWhIpoaJn6FxOnbk1BZbhS6kUqTn23PaIk1WnFNA5jyxXV0nEoW
         B2lMYBzpO8zIFuO7qbp9fWH3oC9pRHDvKN8m4oErq4e5J3HswxotCKto+I9c3XZRiNF8
         k3IQ==
X-Gm-Message-State: AOAM5307ho2iGEfRPhziJ1SU0iFuXUkhOKEhevuoRSbREnBCuwCUnSLw
        q+x+ELBN0q/wC6h3w5hOk6U/J1xBgTUURt8n+Bw=
X-Google-Smtp-Source: ABdhPJxnTjLckeUKrsJhPYBYaJTQA9JXAISCBEgPn3wXtpXroaz713aA3dWQUCSHhMP5Cj7Vh0p+5wBLXy/+cF09BCg=
X-Received: by 2002:a17:90a:19d2:: with SMTP id 18mr11424328pjj.122.1633532022824;
 Wed, 06 Oct 2021 07:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <YV1hRboJopUBLm3H@krava> <YV1h+cBxmYi2hrTM@krava>
In-Reply-To: <YV1h+cBxmYi2hrTM@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 Oct 2021 07:53:31 -0700
Message-ID: <CAADnVQLeHHBsG3751Ld3--w6KEM1a+8V4KY8MReexWo+bLgdmg@mail.gmail.com>
Subject: Re: [RFC] store function address in BTF
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 1:44 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Wed, Oct 06, 2021 at 10:41:41AM +0200, Jiri Olsa wrote:
> > hi,
> > I'm hitting performance issue and soft lock ups with the new version
> > of the patchset and the reason seems to be kallsyms lookup that we
> > need to do for each btf id we want to attach
>
> ugh, I meant to sent this as reply to the patchset mentioned above,
> nevermind, here's the patchset:
>   https://lore.kernel.org/bpf/20210605111034.1810858-1-jolsa@kernel.org/
>
> jirka
>
> >
> > I tried to change kallsyms_lookup_name linear search into rbtree search,
> > but it has its own pitfalls like duplicate function names and it still
> > seems not to be fast enough when you want to attach like 30k functions
> >
> > so I wonder we could 'fix this' by storing function address in BTF,
> > which would cut kallsyms lookup completely, because it'd be done in
> > compile time
> >
> > my first thought was to add extra BTF section for that, after discussion
> > with Arnaldo perhaps we could be able to store extra 8 bytes after
> > BTF_KIND_FUNC record, using one of the 'unused' bits in btf_type to
> > indicate that? or new BTF_KIND_FUNC2 type?
> >
> > thoughts?

That would be on top of your next patch set?
Please post it first.
