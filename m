Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B77842377B
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 07:25:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbhJFF0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 01:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbhJFF0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 01:26:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66631C06174E;
        Tue,  5 Oct 2021 22:24:58 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id j15so928069plh.7;
        Tue, 05 Oct 2021 22:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kE8tUjRehAH/LvwAEmkueguVaxADrwLNnCg94hHiJMg=;
        b=V1812K/3SleAXnVptIpdu6iNE2S6cJg9vJZASBZT36es7F2PaoMbv60MuwrXyhZZzB
         aaE9ftlDTX9t1l1gva+i2xnENkTr43/vocAnDsTUWOYAEZNPh6wkKPIiRc5vLG6G/a7H
         RvyPplZHvwUK1VN9mNXAyps56r+yhVInCUkgJ9soVH6tP/hqWU4IVi0uNVnYvZ2FE9bh
         iTzCxIz7kZmuKyEQ+wdrqTzdqWo5ATg44M7L2DMClKsCWq0/P+UOxo63L2sMpvwljvPX
         wT4q2tS+jF0tzrN0T6qEs6tokIomxLk+P6MepXEEHVM6swWKDWsVkaKELXEgLjT82EnU
         ZT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kE8tUjRehAH/LvwAEmkueguVaxADrwLNnCg94hHiJMg=;
        b=JnZChr99ppLZfE4gKjpKq8Niv1MkGBSbkqQ2eapU9AytP4+V18l1VPGtsy/SRa/KfY
         pFdmJqn4lgrx65pNMiHQcy3j8ozs3vewpFhNlLYkJbjO8p8qAgPgytDWAE/bCVD5bTUg
         XsB0Z4bPac0sV6+8K7KgGuJn0JEMOKBywf7RQeIQ4AdVDGmcVcEqzz/0pwqLwa5Sbw3b
         snYYrz9MVOzIgS+vbQk5dEhgDrAYIq9c+/bMU/pDlypvOnwOCLJMjvZLPGly6nz8NHdB
         hrKkJ8VW0LChlz60bAB+W5JFgrmk4iwakJi3kzCiL7l37FreW2ER7YqtC5yBbxhxGEbp
         1BKQ==
X-Gm-Message-State: AOAM530NeAuFn5XV8GWKlA9/yc8PzsF+PMcK9H+AtJDL+lnWjp8ozDYU
        /BmvorOPhT1UJTvNopkyxDqPYaP24wE=
X-Google-Smtp-Source: ABdhPJzou3CopLA7zz227KVxoXXKW6zbghyZEb5kwkFo8zyDyPIeOJyZtnyPh0gUr0g5IJZ+VUXMAA==
X-Received: by 2002:a17:902:9a04:b0:13a:1b2d:8a5c with SMTP id v4-20020a1709029a0400b0013a1b2d8a5cmr9009835plp.47.1633497897737;
        Tue, 05 Oct 2021 22:24:57 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id o1sm3495760pjs.52.2021.10.05.22.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 22:24:57 -0700 (PDT)
Date:   Wed, 6 Oct 2021 10:54:55 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is
 never 0
Message-ID: <20211006052455.st3f7m3q5fb27bs7@apollo.localdomain>
References: <20211006002853.308945-1-memxor@gmail.com>
 <20211006002853.308945-4-memxor@gmail.com>
 <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 10:11:29AM IST, Andrii Nakryiko wrote:
> On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> >
> > Since the code assumes in various places that BTF fd for modules is
> > never 0, if we end up getting fd as 0, obtain a new fd > 0. Even though
> > fd 0 being free for allocation is usually an application error, it is
> > still possible that we end up getting fd 0 if the application explicitly
> > closes its stdin. Deal with this by getting a new fd using dup and
> > closing fd 0.
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index d286dec73b5f..3e5e460fe63e 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bpf_object *obj)
> >                         pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
> >                         return err;
> >                 }
> > +               /* Make sure module BTF fd is never 0, as kernel depends on it
> > +                * being > 0 to distinguish between vmlinux and module BTFs,
> > +                * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns (ksyms).
> > +                */
> > +               if (!fd) {
> > +                       fd = dup(0);
>
> This is not the only place where we make assumptions that fd > 0 but
> technically can get fd == 0. Instead of doing such a check in every
> such place, would it be possible to open (cheaply) some FD (/dev/null
> or whatever, don't know what's the best file to open), if we detect
> that FD == 0 is not allocated? Can we detect that fd 0 is not
> allocated?
>

We can, e.g. using access("/proc/self/fd/0", F_OK), but I think just calling
open unconditonally and doing if (ret > 0) close(ret) is better. Also, do I
leave it lingering, or should I close(0) if we created it on destroy?

> Doing something like that in bpf_object__open() or bpf_object__load()
> would make everything much simpler and we'll have a guarantee that fd
> == 0 is not going to be allocated (unless someone accidentally or not
> accidentally does close(0), but that's entirely different story).
>
> > +                       if (fd < 0) {
> > +                               err = -errno;
> > +                               pr_warn("failed to dup BTF object #%d FD 0 to FD > 0: %d\n", id, err);
> > +                               close(0);
> > +                               return err;
> > +                       }
> > +                       close(0);
> > +               }
> >
> >                 len = sizeof(info);
> >                 memset(&info, 0, sizeof(info));
> > --
> > 2.33.0
> >

--
Kartikeya
