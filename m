Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A39D4872DF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 06:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiAGFtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 00:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAGFtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 00:49:07 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0CBC061245;
        Thu,  6 Jan 2022 21:49:07 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id b85so5013567qkc.1;
        Thu, 06 Jan 2022 21:49:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSOYS1cQrOxrJJD6EezjWdSAfqPl17nNeLPnfViysOY=;
        b=Q1WEVwIiqD3njselrT4zIYLoQBTMnh50oU+F4e7o4mzJxyWbaMaQA++59UmE40FN4D
         pY537kG0psQ6R195IksJZvOJ5CrU9SlL4wJ2NLtco11N/6NJPkR8wkIrjX7Sl3fOnVDj
         zbdRRPA41mpuESC++VLmBNh7CIY8ci3BXvIupPro9Dl6cSx1tThOjdt2EVE/ye2pO4oZ
         4yqVOVITtd3c+eGEajtqDnAjGujm7fq+8FFzUczLhUgwAlucLy2qWK5Ibv7xpbtgUeAH
         2s4raHmSJWt1MRN7zbTsQDI1xxCVqZSab0REq++Sdmtu9SxypkVnl6wB3XcBmb2WIMnC
         iKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSOYS1cQrOxrJJD6EezjWdSAfqPl17nNeLPnfViysOY=;
        b=MKX2oH7nKgHISN24A6XBHrg638BxxHbI4uJ+hYr//mWzsveuakvD3edKRKKn0k12AK
         BXCNDci8fMbGwXPkAVxgUql/RmMjzNNP9HY5VkHTbUNdhtuvj9AWa/hHU6PuI2SBBOPK
         JsSoFeFTQPlFqGn/dzkVEFwAxt8ht5B8LR5RsLhsfBsTYBAcanT5iIXdVxeQyHmWyVJS
         1+wMA/DmSNgDagz2plz2EqTZGPMhDGEOn4zbRctlc3M6mFRfVkcWbqeFZkk2jSmm4Nhb
         7TVCnorVFBMq0N0s26llarLHiYZi8+s4mAonWGU2+id1IgggZnzwx2dLk97QBbK76mFb
         8NMQ==
X-Gm-Message-State: AOAM530DhrQ6SheonJ34gK1rBUJpqFRmesZOabrMJm5wcPaiQApEVzQF
        LyUUEaD2blJRiuAvzSZLHKgFEU7UWo0t8KTTDSU=
X-Google-Smtp-Source: ABdhPJxeWxqwixnCkAf18/cGCTkrFt3FiNGYiP9c0+RMJ6Q1uqx2wDcIXjV+X0PQlfhFNNXjtMI3h21D4nm/MhyBX0g=
X-Received: by 2002:a05:620a:4410:: with SMTP id v16mr2238692qkp.160.1641534546262;
 Thu, 06 Jan 2022 21:49:06 -0800 (PST)
MIME-Version: 1.0
References: <20211226165649.7178-1-laoar.shao@gmail.com> <616eab60-0f56-7309-4f0f-c0f96719b688@iogearbox.net>
In-Reply-To: <616eab60-0f56-7309-4f0f-c0f96719b688@iogearbox.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Fri, 7 Jan 2022 13:48:30 +0800
Message-ID: <CALOAHbBi4HYUd+AD+F8DrCUPrh8-E3HJC=RPMTw3dNLKHAHczg@mail.gmail.com>
Subject: Re: [PATCH] bpf: allow setting mount device for bpffs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Howells <dhowells@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 9:24 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/26/21 5:56 PM, Yafang Shao wrote:
> > We noticed our tc ebpf tools can't start after we upgrade our in-house
> > kernel version from 4.19 to 5.10. That is because of the behaviour change
> > in bpffs caused by commit
> > d2935de7e4fd ("vfs: Convert bpf to use the new mount API").
> >
> > In our tc ebpf tools, we do strict environment check. If the enrioment is
> > not match, we won't allow to start the ebpf progs. One of the check is
> > whether bpffs is properly mounted. The mount information of bpffs in
> > kernel-4.19 and kernel-5.10 are as follows,
> >
> > - kenrel 4.19
> > $ mount -t bpf bpffs /sys/fs/bpf
> > $ mount -t bpf
> > bpffs on /sys/fs/bpf type bpf (rw,relatime)
> >
> > - kernel 5.10
> > $ mount -t bpf bpffs /sys/fs/bpf
> > $ mount -t bpf
> > none on /sys/fs/bpf type bpf (rw,relatime)
> >
> > The device name in kernel-5.10 is displayed as none instead of bpffs,
> > then our environment check fails. Currently we modify the tools to adopt to
> > the kernel behaviour change, but I think we'd better change the kernel code
> > to keep the behavior consistent.
> >
> > After this change, the mount information will be displayed the same with
> > the behavior in kernel-4.19, for example,
> >
> > $ mount -t bpf bpffs /sys/fs/bpf
> > $ mount -t bpf
> > bpffs on /sys/fs/bpf type bpf (rw,relatime)
> >
> > Fixes: d2935de7e4fd ("vfs: Convert bpf to use the new mount API")
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > Cc: David Howells <dhowells@redhat.com>
> > ---
> >   kernel/bpf/inode.c | 18 ++++++++++++++++--
> >   1 file changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> > index 80da1db47c68..5a8b729afa91 100644
> > --- a/kernel/bpf/inode.c
> > +++ b/kernel/bpf/inode.c
> > @@ -648,12 +648,26 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
> >       int opt;
> >
> >       opt = fs_parse(fc, bpf_fs_parameters, param, &result);
> > -     if (opt < 0)
> > +     if (opt < 0) {
> >               /* We might like to report bad mount options here, but
> >                * traditionally we've ignored all mount options, so we'd
> >                * better continue to ignore non-existing options for bpf.
> >                */
> > -             return opt == -ENOPARAM ? 0 : opt;
> > +             if (opt == -ENOPARAM) {
> > +                     if (strcmp(param->key, "source") == 0) {
> > +                             if (param->type != fs_value_is_string)
> > +                                     return 0;
> > +                             if (fc->source)
> > +                                     return 0;
> > +                             fc->source = param->string;
> > +                             param->string = NULL;
> > +                     }
> > +
> > +                     return 0;
> > +             }
> > +
> > +             return opt;
> > +     }
>
> I don't think we need to open code this? Couldn't we just do something like:
>
>          [...]
>
>          opt = fs_parse(fc, bpf_fs_parameters, param, &result);
>          if (opt == -ENOPARAM) {
>                  opt = vfs_parse_fs_param_source(fc, param);
>                  if (opt != -ENOPARAM)
>                          return opt;
>                  return 0;
>          }
>          if (opt < 0)
>                  return opt;
>
>          [...]
>
> See also 0858d7da8a09 ("ramfs: fix mount source show for ramfs") where they
> had a similar issue.
>

Thanks for the suggestion. I will update it.

nit:  vfs_parse_fs_param_source() is introduced in commit d1d488d81370
("fs: add vfs_parse_fs_param_source() helper"), so the updated one
can't be directly backported to 5.10.

-- 
Thanks
Yafang
