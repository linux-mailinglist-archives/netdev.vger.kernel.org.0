Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00D0E2F3CD1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:43:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438056AbhALVhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436918AbhALU1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 15:27:48 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBE6C061786;
        Tue, 12 Jan 2021 12:27:07 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id b64so3369312ybg.7;
        Tue, 12 Jan 2021 12:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6oLfnMJxWX5gSzAwxFJanb7yERE7HbegYl23oJ22pcg=;
        b=fhp1julwoTuFfaiRw67CtcID4hTSSrRtPxVsjlaSQiTNmy15V0HfzDqDx1+0h0CifV
         +v35Ol3oqKgVT3VV+sfvvU9t8ZAnEFlASDxFitknNVVxXBlmym053dJVKgXiq3W6pg4O
         pgyx6Ekb6qyQV91NYKPwaYDqkYNdngDOQ0EZiFxXlpSEXP7egbBd9ExXjBRTrdOTzYvi
         xwKoTr8dnHyC/7bOp+zo4LXuYxa7Jpox3RmDXobBkKGnoJQ9xqhvTSFifD09VX5tHqBW
         l5JmF+YohJrxcs23DVony3rKgKeTH6eIuSM3OggYrCwywBZLCBkGtdei3GCXUvdRiBq4
         Y7wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6oLfnMJxWX5gSzAwxFJanb7yERE7HbegYl23oJ22pcg=;
        b=qngHMwAsh2Z5Ej3v+38ttyXeZntsRFgxqY7iyWxqiEj5wuUmoxM6etNxtTLyia2RIC
         c5W5BfpAOifTGDelkjy8gS60ACZvZh7mc3uj438Y5wXoAH0JaPEFHbr1f6r+CuUmq39A
         stXTvAK5IUcP34rFDShYFsReUQDlYEsrrmi08bFMCLZWlSEN8XcQ2ULNWWMsKok+79hL
         kwrT0VUPz+IVcwwuUyeljqsUchAWibcXRc7/cfMDuenCK116ZPpK0aM8642E0WrwTo/j
         4UEkOJTOeFporxaj//6A1pb3bYDdSPOhMLObFlyUI5L3h6Bq+l3c/Ipw4GP3OCgKgyw/
         ay8A==
X-Gm-Message-State: AOAM532cyg+bsLL8/dLeSR1DI+5D4B5y8LSJEXQRAId9jw9I1Rp1eWYL
        ZNHpzvKQaoKfphVL0JfkBSGd9ssPo40CAAn8P+Q=
X-Google-Smtp-Source: ABdhPJxm+sLqb5Oh7ldp4g5377mrjX4HZayTPuOLHF4kIk1r+tRBCtDrYT+4qgi5Ow7WU0wBiFcFYWp8JSezM7t6qIw=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr1703712ybg.27.1610483226826;
 Tue, 12 Jan 2021 12:27:06 -0800 (PST)
MIME-Version: 1.0
References: <20210110070341.1380086-1-andrii@kernel.org> <20210110070341.1380086-2-andrii@kernel.org>
 <e621981d-5c3d-6d92-871b-a98520778363@fb.com> <CAEf4BzZhFrHho-F+JyY6wQyWUZ+0cJJLkGv+=DHP4equkkm4iw@mail.gmail.com>
 <31ebd16f-8218-1457-b4e2-3728ab147747@fb.com> <CAEf4BzY0xwwH+yD3dvjSjDG1t_w4ktAeo_gM6WQWw676TghJpQ@mail.gmail.com>
 <717c1c8c-4194-0605-3aa3-eb33fdc17711@iogearbox.net>
In-Reply-To: <717c1c8c-4194-0605-3aa3-eb33fdc17711@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 12 Jan 2021 12:26:56 -0800
Message-ID: <CAEf4BzZMg9Ur=412xi4mQ7xkojLrUYszPF6xLmyJMRz4X+rbtg@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] libbpf: allow loading empty BTFs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Christopher William Snowhill <chris@kode54.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 12:17 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/12/21 7:41 AM, Andrii Nakryiko wrote:
> > On Mon, Jan 11, 2021 at 5:16 PM Yonghong Song <yhs@fb.com> wrote:
> >> On 1/11/21 12:51 PM, Andrii Nakryiko wrote:
> >>> On Mon, Jan 11, 2021 at 10:13 AM Yonghong Song <yhs@fb.com> wrote:
> >>>> On 1/9/21 11:03 PM, Andrii Nakryiko wrote:
> >>>>> Empty BTFs do come up (e.g., simple kernel modules with no new types and
> >>>>> strings, compared to the vmlinux BTF) and there is nothing technically wrong
> >>>>> with them. So remove unnecessary check preventing loading empty BTFs.
> >>>>>
> >>>>> Reported-by: Christopher William Snowhill <chris@kode54.net>
> >>>>> Fixes: ("d8123624506c libbpf: Fix BTF data layout checks and allow empty BTF")
>
> Fixed up Fixes tag ^^^^^ while applying. ;-)

Oh the irony, eh? :) Thanks, Daniel!

>
> >>>>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> >>>>> ---
> >>>>>     tools/lib/bpf/btf.c | 5 -----
> >>>>>     1 file changed, 5 deletions(-)
> >>>>>
> >>>>> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> >>>>> index 3c3f2bc6c652..9970a288dda5 100644
> >>>>> --- a/tools/lib/bpf/btf.c
> >>>>> +++ b/tools/lib/bpf/btf.c
> >>>>> @@ -240,11 +240,6 @@ static int btf_parse_hdr(struct btf *btf)
> >>>>>         }
> >>>>>
> >>>>>         meta_left = btf->raw_size - sizeof(*hdr);
> >>>>> -     if (!meta_left) {
> >>>>> -             pr_debug("BTF has no data\n");
> >>>>> -             return -EINVAL;
> >>>>> -     }
> >>>>
> >>>> Previous kernel patch allows empty btf only if that btf is module (not
> >>>> base/vmlinux) btf. Here it seems we allow any empty non-module btf to be
> >>>> loaded into the kernel. In such cases, loading may fail? Maybe we should
> >>>> detect such cases in libbpf and error out instead of going to kernel and
> >>>> get error back?
> >>>
> >>> I did this consciously. Kernel is more strict, because there is no
> >>> reasonable case when vmlinux BTF or BPF program's BTF can be empty (at
> >>> least not that now we have FUNCs in BTF). But allowing libbpf to load
> >>> empty BTF generically is helpful for bpftool, as one example, for
> >>> inspection. If you do `bpftool btf dump` on empty BTF, it will just
> >>> print nothing and you'll know that it's a valid (from BTF header
> >>> perspective) BTF, just doesn't have any types (besides VOID). If we
> >>> don't allow it, then we'll just get an error and then you'll have to
> >>> do painful hex dumping and decoding to see what's wrong.
> >>
> >> It is totally okay to allow empty btf in libbpf. I just want to check
> >> if this btf is going to be loaded into the kernel, right before it is
> >> loading whether libbpf could check whether it is a non-module empty btf
> >> or not, if it is, do not go to kernel.
> >
> > Ok, I see what you are proposing. We can do that, but it's definitely
> > separate from these bug fixes. But, to be honest, I wouldn't bother
> > because libbpf will return BTF verification log with a very readable
> > "No data" message in it.
>
> Right, seems okay to me for this particular case given the user will be
> able to make some sense of it from the log.
>
> Thanks,
> Daniel
