Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB3F3FD1DD
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 05:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241819AbhIADjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 23:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241811AbhIADjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 23:39:07 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C55C061575;
        Tue, 31 Aug 2021 20:38:11 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id f15so2512840ybg.3;
        Tue, 31 Aug 2021 20:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nvD84ugqQhro2PABRBkxd/oqt9jOPsun4IafVjYuMAo=;
        b=o6ijO5e6ux1f1tC8Z5VjaI/1QJ9tDBeUvEY8lPIWKyzZx+xNlRTZ7DgxhIkWHbZUEP
         erUKuC4Kvm/f0eAWFzB8FqJLPZj2rstzf1Nlf7WrI7ao74JIXrY+kqnquZs0kqQ+fON2
         MtQpZgcFyoSoy2CwA9n0cKwnXXzh0mfj8ojgUBTSTxxHF+5lEva2u5mEZzfLcszFAlg0
         RxMTjXaTHRHcGM+L0+CEcp/tTR6oJqgTPCZwqIwKT5YmtSMXcvtIQbrJwgEYvUsNh3HU
         0I2Cucb0wp2E92PyQvIuc/z+6fKSOxwmDmq053csePt2KGqY1uJrltRNEyTeOs3vN4yW
         48kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nvD84ugqQhro2PABRBkxd/oqt9jOPsun4IafVjYuMAo=;
        b=N5BWzzCgK9jdKk1f5awCPQ+8O2K6jvD8vpkZCB/lx6sVx34oFltA+g6uoZ5m9jqIaw
         TaETE9ay5GPDUNZFZ+g5St3f4bY5wBQsIlfHSDUWGOnfK2hfPnHNhRdxCImuQkAPe1cm
         ganASYyLG+G2HG0qCy2g7DxzrGaF4NSbBFwCT4tVCjokGHUTm7oMc9MH+M5T8tEZbqae
         2kzpbBtVyxamudcZKTeyyBpEnWQ/dEDBKfis2l9NLHcqos2V2iPXtm4QLgnihWcxoq3Y
         lfriISEAoO4KCBBLgctv/iZP25Vvt6omDVmRp6ARn/5z1lqUTLKC9+gss5aT7/vcgrou
         JILQ==
X-Gm-Message-State: AOAM530Rb9DajuXExpG01Q7vJa5unmsZNMTPqJNT2ITeT9JqtDxmdhVf
        vbf8z+liBBq74fZoejHWxRIK6d4QHMD9VBKFi6E=
X-Google-Smtp-Source: ABdhPJxvjgan2QF6MzekFlP5IW4JeqbpUT1xrImBZG2OUF19EfUCuOtl3tThOt005xgprmBtIhKzAZ8AcquBeQooR8o=
X-Received: by 2002:a25:16c6:: with SMTP id 189mr34949672ybw.27.1630467490997;
 Tue, 31 Aug 2021 20:38:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210830173424.1385796-1-memxor@gmail.com> <20210830173424.1385796-4-memxor@gmail.com>
 <CAEf4Bza11W+NPt1guXj87fy_xcsWLHeFLNK0OkzL9A+TfcYhog@mail.gmail.com>
 <20210901022701.g7nzkmm6lo7jf3wd@apollo.localdomain> <CAADnVQ+yCv14f6=yCgqZJJxqjC+J18ex32j03q6N_JL_ohovzA@mail.gmail.com>
In-Reply-To: <CAADnVQ+yCv14f6=yCgqZJJxqjC+J18ex32j03q6N_JL_ohovzA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Aug 2021 20:38:00 -0700
Message-ID: <CAEf4Bza_drPotcErp6=zpZ705BbJ4QFf2bYYpcX5UuF_+7b3Eg@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC v1 3/8] libbpf: Support kernel module
 function calls
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 7:59 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Aug 31, 2021 at 7:27 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> > > > @@ -5327,6 +5340,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
> > > >                         ext = &obj->externs[relo->sym_off];
> > > >                         insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
> > > >                         insn[0].imm = ext->ksym.kernel_btf_id;
> > > > +                       insn[0].off = ext->ksym.offset;
> > >
> > > Just a few lines above we use insn[1].imm =
> > > ext->ksym.kernel_btf_obj_fd; for EXT_KSYM (for variables). Why are you
> > > inventing a new form if we already have a pretty consistent pattern?
> > >
> >
> > That makes sense. This is all new to me, so I went with what was described in
> > e6ac2450d6de (bpf: Support bpf program calling kernel function), but I'll rework
> > it to encode the btf fd like that in the next spin. It also makes the everything
> > far simpler.
>
> Hmm. kfunc call is a call insn. There is no imm[1].

Doh, right :( Never mind, we'll need to use fd_array for this.

Either way, I don't think hashmap use is warranted here to find a BTF
slot. Let's just do linear search, it's not like we are going to have
thousands of module BTFs used by any single BPF program, right?
