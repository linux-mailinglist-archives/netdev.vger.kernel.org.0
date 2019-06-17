Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0085D48B4A
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 20:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfFQSGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 14:06:33 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34066 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbfFQSGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 14:06:33 -0400
Received: by mail-qt1-f193.google.com with SMTP id m29so11890757qtu.1;
        Mon, 17 Jun 2019 11:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x/k8eKYiIdf0sFnvjjeqBqcsktW5rmY6n4/4xjkC5T8=;
        b=UmBJUuY0JIN00jivRTr0brZhUquHn7WW8tnA3ufQpXx7EEalv5yboJgNkCBIQkoatr
         k28Q22yx8WiBAUmjxUEQwGu8fuakuPy5YOZ05ooYzDZSBCJoTbK1zQqoAjWf0ku0n9h5
         MjnGtiDPFuJ0Gkpl0T6RD1vmBnX+FLYFcPvpZLK8DmpLQ/YUNvtEJFevacIYQv/TKUYu
         BILw2TnI1UDQpNbBWV+fALPwx9yfVhjOzYG8lwh10g6HCvde1d78L81kkNXrH+zry08Y
         joO6dEmJekNaAKCAyAOyPL/awFWLFLhWiIb6PMxWIZMOaQxnmA77izE86wJ1BvRFGMu2
         vC0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x/k8eKYiIdf0sFnvjjeqBqcsktW5rmY6n4/4xjkC5T8=;
        b=KbaVxJsw7LnWVnDPHYVo6H1TLBbWMg0USZ8OzjHFc1Gp+CGfleHfMzuEawtJQ+3RXp
         04/iKGpQqFRMQAVbixM8BIi4hTV2klDrLWvsY/gF+Ulvmaf/blHMljU1RANBTIIQ295Z
         QDApyUGdGaDpD1jjI/j0mL7+m0RQ35Y3ytldPiZqUIDX437kHegDkrrkuzlLNCZ9JIDy
         DvdlgO/cXQLTcIWUWps3VTKcinUx2qw+T9xdOyCdAicQo6ZIUEoDoh5KGf88ue+7Cf8K
         Bwy1o5bqXXaLBcC70ILyvSKQyvg1g+GxTKp4yrn2Rz/0pTG4YIbIeJYNBgSZhoH+OLpZ
         EgxQ==
X-Gm-Message-State: APjAAAUA59qUdDszwl0+BAgUSR4PguJRA8CfbHKRuFRgs+52rqbYl4ts
        3mO9ye/2NvbTvjyw7DQs16ZWL9zS+XQTQ48+MFQ=
X-Google-Smtp-Source: APXvYqwpOGlK/Owzn+XZLyF7qTeY8QUv7Xok1nVDr+7fRt8LSB7aiUVEvVwdvaUep16QtpM82UBOJPk3pl+t7N1/dOM=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr76571921qty.59.1560794792326;
 Mon, 17 Jun 2019 11:06:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190611043505.14664-1-andriin@fb.com> <20190611043505.14664-5-andriin@fb.com>
 <CAPhsuW6iicoRN3Sk6Uv-ten4xjjmqG1qmfmXyKngqVSYC9qbEQ@mail.gmail.com>
In-Reply-To: <CAPhsuW6iicoRN3Sk6Uv-ten4xjjmqG1qmfmXyKngqVSYC9qbEQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 11:06:21 -0700
Message-ID: <CAEf4BzYKtA9Hk5oswZVD_pZ-VxjXXd_OV_bRs+42cfgf8dqodw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/8] libbpf: identify maps by section index
 in addition to offset
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 15, 2019 at 2:08 PM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Mon, Jun 10, 2019 at 9:37 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > To support maps to be defined in multiple sections, it's important to
> > identify map not just by offset within its section, but section index as
> > well. This patch adds tracking of section index.
> >
> > For global data, we record section index of corresponding
> > .data/.bss/.rodata ELF section for uniformity, and thus don't need
> > a special value of offset for those maps.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c | 42 ++++++++++++++++++++++++++----------------
> >  1 file changed, 26 insertions(+), 16 deletions(-)
> >

<snip>

> > @@ -3472,13 +3488,7 @@ bpf_object__find_map_fd_by_name(struct bpf_object *obj, const char *name)
> >  struct bpf_map *
> >  bpf_object__find_map_by_offset(struct bpf_object *obj, size_t offset)
> >  {
> > -       int i;
> > -
> > -       for (i = 0; i < obj->nr_maps; i++) {
> > -               if (obj->maps[i].offset == offset)
> > -                       return &obj->maps[i];
> > -       }
> > -       return ERR_PTR(-ENOENT);
> > +       return ERR_PTR(-ENOTSUP);
>
> I probably missed some discussion. But is it OK to stop supporting
> this function?

This function was added long time ago for some perf (the tool)
specific use case. But I haven't found any uses of that in kernel
code, as well as anywhere on github/internal FB code base. It appears
it's not used anywhere.

Also, this function makes bad assumption that map can be identified by
single offset, while we are going to support maps in two (or more, if
necessary) different ELF sections, so offset is not unique anymore.
It's not clear what's the intended use case for this API is, looking
up by name should be the way to do this. Given it's not used, but we
still need to preserve ABI, I switched it to return -ENOTSUP.

>
> Thanks,
> Song
>
> >  }
> >
> >  long libbpf_get_error(const void *ptr)
> > --
> > 2.17.1
> >
