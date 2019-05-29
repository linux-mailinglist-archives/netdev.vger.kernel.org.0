Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 608342E2E5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfE2RLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:11:08 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:35126 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfE2RLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:11:08 -0400
Received: by mail-qt1-f193.google.com with SMTP id w1so3538954qts.2;
        Wed, 29 May 2019 10:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hwn3k8TDsfzBge8qQ5QquPJrcc0EBlqU7SGf+037Awo=;
        b=sc6HmA12hd11sdBtXPYuZgbRKpVe19bXkUDGfVvk1sUQDORsdOra9ihPqxcyGXKfjt
         kBtYRieEnVxFoxJT/EXZ1p9YKV4YxLsaELimUiDeSdZ1lY7stbQ9OwFzpVhvRVZPhBeD
         HKhN0HBQYgOj9iujP712A+vr+i2/OtmDcGbkIPGtm1AuB3dIL7oJ9NMw3jN94kEgb2uf
         OodyAczJQ3ETxP3cIs3zlCMYd29suOAzuA9eKVWqnf/V3NRidDqv77FodnidEdjc2YYs
         FFSYwFFUmeBW8CydL7vG3trTPvgRXbHOCye6J5sAB3n9gIegW6SEM5uFIImBnwKkWXt1
         kbiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hwn3k8TDsfzBge8qQ5QquPJrcc0EBlqU7SGf+037Awo=;
        b=pxXmWlsqRs91yAFM9s9aumtcBJ3JafYcMSdJ4Bk6+1A6H8Csqqreje6whUpUkdhnex
         uYChyCAvKwxpTYmmtBngDnPs1O4TW0JyUjeEbDosHK4qvGT5mFPGvTDvgtLT0kGwDUUx
         W+as54Ar2P0iMRjKVuYN8d8jmJVSNiGBIziiwbFkGlKbeS4vrfA5mY7UEFtaxwitNrLh
         N4zkKTPfIYxQlDAIFGgGYJCb6wChGC7W+zHL3SKgNCDlQDNhyTuD/0mAo5uZEK5WXbkK
         qQABKT1IZRQnoG2OIUIhq55Cu2OjzEytC6uuj9petJ3BCMfUYAcHo26HzR48yz2ewrVD
         8WWQ==
X-Gm-Message-State: APjAAAWatQ0C9eHzhszQhUAykQMoHLKyXsmewCr+cQa/cNZEz8xeYOq6
        dpl3SbyPf3/xV3k+mspbWqsTQT9SXZPVI2Z7IWM=
X-Google-Smtp-Source: APXvYqxhRhzDbopqu1OEOYEodZhVbY3UaQFB7oyhh7Hq09SKn/L469jhQ0UcLzqeyg7/E93dG1OmvTLOqeb/qa7iR0U=
X-Received: by 2002:a0c:ec92:: with SMTP id u18mr35227634qvo.60.1559149866863;
 Wed, 29 May 2019 10:11:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-2-andriin@fb.com>
 <CAPhsuW7zZ=QQs2wpR46+0hydSzRYza2_7kSAr0a1nBChSHbu6Q@mail.gmail.com>
In-Reply-To: <CAPhsuW7zZ=QQs2wpR46+0hydSzRYza2_7kSAr0a1nBChSHbu6Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 May 2019 10:10:55 -0700
Message-ID: <CAEf4BzaEa0xQLvJbQTf9dE8DtjeetvqkUA=SbQHdjLHy+N04WQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/9] libbpf: fix detection of corrupted BPF
 instructions section
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 10:01 AM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Tue, May 28, 2019 at 6:14 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > Ensure that size of a section w/ BPF instruction is exactly a multiple
> > of BPF instruction size.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 12 +++++++-----
> >  1 file changed, 7 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index ca4432f5b067..05a73223e524 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -349,8 +349,11 @@ static int
> >  bpf_program__init(void *data, size_t size, char *section_name, int idx,
> >                   struct bpf_program *prog)
> >  {
> > -       if (size < sizeof(struct bpf_insn)) {
> > -               pr_warning("corrupted section '%s'\n", section_name);
> > +       const size_t bpf_insn_sz = sizeof(struct bpf_insn);
> > +
> > +       if (size < bpf_insn_sz || size % bpf_insn_sz) {
>
> how about
>            if (!size || size % bpf_insn_sz)

sure, why not.

>
> > +               pr_warning("corrupted section '%s', size: %zu\n",
> > +                          section_name, size);
> >                 return -EINVAL;
> >         }
> >
> > @@ -376,9 +379,8 @@ bpf_program__init(void *data, size_t size, char *section_name, int idx,
> >                            section_name);
> >                 goto errout;
> >         }
> > -       prog->insns_cnt = size / sizeof(struct bpf_insn);
> > -       memcpy(prog->insns, data,
> > -              prog->insns_cnt * sizeof(struct bpf_insn));
> > +       prog->insns_cnt = size / bpf_insn_sz;
> > +       memcpy(prog->insns, data, prog->insns_cnt * bpf_insn_sz);
>
> Given the check above, we can just use size in memcpy, right?

yep, good point, will update

>
> Thanks,
> Song
>
> >         prog->idx = idx;
> >         prog->instances.fds = NULL;
> >         prog->instances.nr = -1;
> > --
> > 2.17.1
> >
