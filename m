Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E8A3FD19B
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241725AbhIADAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 23:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241485AbhIADAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 23:00:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E1BC061575;
        Tue, 31 Aug 2021 19:59:43 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u11-20020a17090adb4b00b00181668a56d6so974089pjx.5;
        Tue, 31 Aug 2021 19:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VTjVcypWJa/qIQt0f4cHIV4FOUj2CTtbQpLJ+HpNPaA=;
        b=eQhe1CLrF7nNjoBL5jZy3V7u6gf7zJ8/GYsl92AyuOFGV3MhcJdjp/cRzP5CJRkAXe
         YefeN2xWNx0Cr3PEOxrW4ymkL9ojy0t7NOZlXJUtImqb3uBDusq37Gc4Ov+zkT0EdAZA
         Qe2PlHX6602fK77Cfh4iY4mzfAp4fQckGuZUuUb3oQCitEAf0rmVKsGdU0NKrPrl+iLZ
         sP2ZYwAnQr4jQncN1d5BXK1X9pZBU+2rl3nn85C8MkM87QRgb7f1mwtq4KPXRW1MIbcA
         DqJU/QHISgiTeE8Jm8/7Egb8CqKgUKxL0ulKeaiDWIdNX1/LoFrNxAmiMnVPlKy42AC3
         PSWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VTjVcypWJa/qIQt0f4cHIV4FOUj2CTtbQpLJ+HpNPaA=;
        b=CDRGlPOFHl9kVBxzaBz4hwvJWNjpr1Fwv2Xj+hqwfXI4+IbQV60RoUnHtIHWzEY3WD
         ofLNZfgZGRIgFfF2+0b/50zIvr6mRE89QYnYhn5vqdZViZmWc5J9/Ff9HmlmCvnfIo1t
         z2N73oderUfrJTyepx7Pa9cMq3EZxJvwdDPb2xhc0p3GzdqojjKWz2zW3T3DSvHUC5Hp
         ZBTG1C+JqidPzaDw2tfsvznm8/HEGsmla+6U7vgAeR7j2jSTGb2vr0982kh4G1FCe0Bk
         WP1ry5sdWPbwMBgCxMLzHcL3zuRLIeYFTlbemrBS0zvxw+Hncx6PUYNrrSuEQzFhaKff
         dsFA==
X-Gm-Message-State: AOAM530LyD5fHiojOV9Yb1XaaY6JSFkMvi8c8ko9zB1o3ix7Lb8W08il
        KSUm9FzBoL/MlFbjDYkTo85KA4eqpdEb0oqMXRY=
X-Google-Smtp-Source: ABdhPJwekO0E/y18VQ3HRo4IJbbRE65IDSuew/SBg5vdvh7wM7H6GzH5MS8RcTwAmMXtsk6C4ra6RVzwVjyRPR/4W1k=
X-Received: by 2002:a17:90b:513:: with SMTP id r19mr8976518pjz.93.1630465182706;
 Tue, 31 Aug 2021 19:59:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210830173424.1385796-1-memxor@gmail.com> <20210830173424.1385796-4-memxor@gmail.com>
 <CAEf4Bza11W+NPt1guXj87fy_xcsWLHeFLNK0OkzL9A+TfcYhog@mail.gmail.com> <20210901022701.g7nzkmm6lo7jf3wd@apollo.localdomain>
In-Reply-To: <20210901022701.g7nzkmm6lo7jf3wd@apollo.localdomain>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 31 Aug 2021 19:59:31 -0700
Message-ID: <CAADnVQ+yCv14f6=yCgqZJJxqjC+J18ex32j03q6N_JL_ohovzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC v1 3/8] libbpf: Support kernel module
 function calls
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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

On Tue, Aug 31, 2021 at 7:27 PM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
> > > @@ -5327,6 +5340,7 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
> > >                         ext = &obj->externs[relo->sym_off];
> > >                         insn[0].src_reg = BPF_PSEUDO_KFUNC_CALL;
> > >                         insn[0].imm = ext->ksym.kernel_btf_id;
> > > +                       insn[0].off = ext->ksym.offset;
> >
> > Just a few lines above we use insn[1].imm =
> > ext->ksym.kernel_btf_obj_fd; for EXT_KSYM (for variables). Why are you
> > inventing a new form if we already have a pretty consistent pattern?
> >
>
> That makes sense. This is all new to me, so I went with what was described in
> e6ac2450d6de (bpf: Support bpf program calling kernel function), but I'll rework
> it to encode the btf fd like that in the next spin. It also makes the everything
> far simpler.

Hmm. kfunc call is a call insn. There is no imm[1].
