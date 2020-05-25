Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4B51E1541
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 22:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390437AbgEYUeU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 16:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389950AbgEYUeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 16:34:20 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB95C061A0E;
        Mon, 25 May 2020 13:34:18 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id p12so14552391qtn.13;
        Mon, 25 May 2020 13:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KZZ4cyf2D7Nph4LGicpQpQCPZg8i4pMLDvE8Rtnb0xg=;
        b=GNqpoFjmVY9xYL51/sr3io05Wcdu2tcoaCljwMsX8PgXgthylwo5vUpdPirlevl2Kb
         P4OIVl741ZNDlMKPgmUB/ApaSZ03jaDh2Y3ACUkyTWKQIKgdqP8oMIftBfnYew6ElsJZ
         AKj0Bou0vdKuXv8kU+G/7gdTpyJ7jc+d6kswHYWeUf+sLg5cn3br8MYDkcGWqaxfrFwS
         9MuSQqtzCineuH63j/Qd60KOmuUbx+9mbik4QDYZq6x2OAxH6oDR1RpA1rPUfakKu7Mn
         ETbIzrmDbptQ+idQA0bq9cAXiTNsBljn1TqTeAtopoLBS/i8yD0MCLXEbkKNdcytXA9r
         Bs+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KZZ4cyf2D7Nph4LGicpQpQCPZg8i4pMLDvE8Rtnb0xg=;
        b=Z4yoD1ieOpouEy6hNbmcvO3BeVKgL4SAG7Qvw2ep3vG6RDBbkaVr6jt/qpwULbCz85
         ewI8blkibhpaJzaWoB+Uh7D3eQecroInq11vgbwOen1Kze7bla1VT2/F+e1h1FDI31Sj
         NvvXtSKrfv9+rq7FjN38dhHYEVCVHGoi0VJ1dHRz9Taux6Ol9zIlPBl4dE7fka7+fDmC
         GIfVX0cRx4zNm7BPSh56QvIEKk2XORrybfibebxwG3GQ3RceNcSog/w3hNP3rw8XeLsy
         6WajdTElYny7aR9JhBFyJ5CDOweMXefjUlxvKsjJpG1wMMR9CgytCnVxvR8430L/5lsm
         nriA==
X-Gm-Message-State: AOAM531wn4nmcoAnYyMvZr6xlAXeRwCkBOsCJDwQDpJQWO4nbb1bWE1c
        GLijkVQB6nSfnOMQt9X2v38NHUJHSqLyxiPMnvI=
X-Google-Smtp-Source: ABdhPJxCV0Z7YrTta1N00A6FQJ1WZVKimxPFbv15yzqpsZCw4xjv8m8IlrNgECsyStL69pvLlhCZy3bWoYSwiQpaRdQ=
X-Received: by 2002:ac8:71cd:: with SMTP id i13mr13100703qtp.93.1590438857855;
 Mon, 25 May 2020 13:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-2-andriin@fb.com>
 <20200522010722.2lgagrt6cmw6dzmm@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200522010722.2lgagrt6cmw6dzmm@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 May 2020 13:34:06 -0700
Message-ID: <CAEf4BzZ7Yhc8Lt2X9_cMkBHBsxj+G8qnpORG3sT-p6HbjYftVA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/7] bpf: implement BPF ring buffer and
 verifier support for it
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 6:07 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, May 17, 2020 at 12:57:21PM -0700, Andrii Nakryiko wrote:
> > -     if (off < 0 || size < 0 || (size == 0 && !zero_size_allowed) ||
> > -         off + size > map->value_size) {
> > -             verbose(env, "invalid access to map value, value_size=%d off=%d size=%d\n",
> > -                     map->value_size, off, size);
> > -             return -EACCES;
> > -     }
> > -     return 0;
> > +     if (off >= 0 && size_ok && off + size <= mem_size)
> > +             return 0;
> > +
> > +     verbose(env, "invalid access to memory, mem_size=%u off=%d size=%d\n",
> > +             mem_size, off, size);
> > +     return -EACCES;
>
> iirc invalid access to map value is one of most common verifier errors that
> people see when they're use unbounded access. Generalizing it to memory is
> technically correct, but it makes the message harder to decipher.
> What is 'mem_size' ? Without context it is difficult to guess that
> it's actually size of map value element.
> Could you make this error message more human friendly depending on
> type of pointer?

I realized that __check_pkt_access is essentially identical and
unified map value, packet, and memory access checks, with custom log
per type of register.

>
> >       if (err) {
> > -             verbose(env, "R%d min value is outside of the array range\n",
> > +             verbose(env, "R%d min value is outside of the memory region\n",
> >                       regno);
> >               return err;
> >       }
> > @@ -2518,18 +2527,38 @@ static int check_map_access(struct bpf_verifier_env *env, u32 regno,
> >        * If reg->umax_value + off could overflow, treat that as unbounded too.
> >        */
> >       if (reg->umax_value >= BPF_MAX_VAR_OFF) {
> > -             verbose(env, "R%d unbounded memory access, make sure to bounds check any array access into a map\n",
> > +             verbose(env, "R%d unbounded memory access, make sure to bounds check any memory region access\n",
> >                       regno);
> >               return -EACCES;
> >       }
> > -     err = __check_map_access(env, regno, reg->umax_value + off, size,
> > +     err = __check_mem_access(env, reg->umax_value + off, size, mem_size,
> >                                zero_size_allowed);
> > -     if (err)
> > -             verbose(env, "R%d max value is outside of the array range\n",
> > +     if (err) {
> > +             verbose(env, "R%d max value is outside of the memory region\n",
> >                       regno);
>
> I'm not that worried about above three generalizations of errors,
> but if you can make it friendly by describing type of memory region
> I think it will be a plus.

These I left as is (i.e., generic "memory region"), because they were
wrong before (it's more general than just array access), but also
didn't want to clutter code with extra switches or mappings to string,
given that these messages will go right after custom message from
__check_mem_access. Hope that's fine.
