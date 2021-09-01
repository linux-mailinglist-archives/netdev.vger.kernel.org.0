Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B9D3FD14F
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241528AbhIAC2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241128AbhIAC2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:28:01 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F89C061575;
        Tue, 31 Aug 2021 19:27:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 17so1244443pgp.4;
        Tue, 31 Aug 2021 19:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l6zBUmZjaaF8MBlLbuRS4Hw7hGtyVs5W6eya6EoO5NM=;
        b=oxTddWFobnGeD9LakGnfuiqB8UOOWNQWQnsgnvgj9poIqpzlTyl0PDSRQlT4yYnoML
         FQeh1GNoA4ZF+omc+jIaAQH51XaZz+0t3p6r6cusvKqESznk03TgQiVgaOnV89Pc856w
         iqpsa3uetBYFET8L0KJRgJTdS/U3TYyDMCbTekhE5LL6Cb8Of0xX2SVdPWdNkYud8WIM
         1mAtIIdDKvf1yyZQnsOd6tNqxQrSgzi7CJca3QqkdE4feWAc+DwpDZmu6xCSswqhvWzZ
         0hF/TKow9ABPyBLfvf27YvUfaHknUurfwtK6ot6zhpZKH6AyFB2B2/7uDDOyUh+ABjUT
         KcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l6zBUmZjaaF8MBlLbuRS4Hw7hGtyVs5W6eya6EoO5NM=;
        b=NVlAK4BksGKqzoJYU7cdqq7ZpAaIj1HmaEmQYrGvoOeu6L0zWd2gBoVlGW2yrubHH7
         ljEzjkIWYImwnCbGhtDfGB+gUWQLgHKujoa8o96UPXefUc+Q/g1H5HMKLnuhHedGtdJU
         XX75o9AGAw6nD0/RDuXVEhCXU+uFOfb4T7UaCFSflQToTQiOVAch3MlH+nks/WuK9HvG
         E7FYC96DynOYNlgXW+hilPEYiW7G1zyLjDjT4UZ9aW4GgIu+8vESkaGGCgjw46zmOi2X
         4lEPW7Wei1dDKZmenTuTcex5lJ7f94tU84a0pyU483wqwHL4CHrDt9wV+2vGHBhhF+X5
         cukA==
X-Gm-Message-State: AOAM533r5jywg6h9fJqeLbdSlqqyduBf3U2yE4t0DZU7qC5s0fMC6gge
        EWSx8EuWwYs1FH+OlW4pDv0=
X-Google-Smtp-Source: ABdhPJxMb9FiJp7kHy9eF+GXAHCd3jHzKU4Ueh73o+ewkR1nHQ66FzoZM4NRGO7ku5TCLC8iDlgIwQ==
X-Received: by 2002:a65:5845:: with SMTP id s5mr28836470pgr.227.1630463224993;
        Tue, 31 Aug 2021 19:27:04 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id y64sm22435936pgy.32.2021.08.31.19.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 19:27:04 -0700 (PDT)
Date:   Wed, 1 Sep 2021 07:57:01 +0530
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
Subject: Re: [PATCH bpf-next RFC v1 3/8] libbpf: Support kernel module
 function calls
Message-ID: <20210901022701.g7nzkmm6lo7jf3wd@apollo.localdomain>
References: <20210830173424.1385796-1-memxor@gmail.com>
 <20210830173424.1385796-4-memxor@gmail.com>
 <CAEf4Bza11W+NPt1guXj87fy_xcsWLHeFLNK0OkzL9A+TfcYhog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza11W+NPt1guXj87fy_xcsWLHeFLNK0OkzL9A+TfcYhog@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 01, 2021 at 06:25:14AM IST, Andrii Nakryiko wrote:
> On Mon, Aug 30, 2021 at 10:34 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
>
> -ENOCOMMITMESSAGE?
>
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  tools/lib/bpf/bpf.c             |  3 ++
> >  tools/lib/bpf/libbpf.c          | 71 +++++++++++++++++++++++++++++++--
> >  tools/lib/bpf/libbpf_internal.h |  2 +
> >  3 files changed, 73 insertions(+), 3 deletions(-)
> >
>
> [...]
>
> > @@ -515,6 +521,13 @@ struct bpf_object {
> >         void *priv;
> >         bpf_object_clear_priv_t clear_priv;
> >
> > +       struct {
> > +               struct hashmap *map;
> > +               int *fds;
> > +               size_t cap_cnt;
> > +               __u32 n_fds;
> > +       } kfunc_btf_fds;
> > +
> >         char path[];
> >  };
> >  #define obj_elf_valid(o)       ((o)->efile.elf)
> > @@ -5327,6 +5340,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
> >                         ext = &obj->externs[relo->sym_off];
> >                         insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
> >                         insn[0].imm = ext->ksym.kernel_btf_id;
> > +                       insn[0].off = ext->ksym.offset;
>
> Just a few lines above we use insn[1].imm =
> ext->ksym.kernel_btf_obj_fd; for EXT_KSYM (for variables). Why are you
> inventing a new form if we already have a pretty consistent pattern?
>

That makes sense. This is all new to me, so I went with what was described in
e6ac2450d6de (bpf: Support bpf program calling kernel function), but I'll rework
it to encode the btf fd like that in the next spin. It also makes the everything
far simpler.

> >                         break;
> >                 case RELO_SUBPROG_ADDR:
> >                         if (insn[0].src_reg != BPF_PSEUDO_FUNC) {
>
> [...]

--
Kartikeya
