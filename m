Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2423821F829
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 19:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728942AbgGNR14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 13:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgGNR1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 13:27:55 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A32DC061755;
        Tue, 14 Jul 2020 10:27:55 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h22so24081103lji.9;
        Tue, 14 Jul 2020 10:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rJflZjiXOdQ2b9X0uINcJ4Ucju/qSppPTgvRYeR307M=;
        b=mrk8nP8ZaXDxwoSsyA8k3vVqLdKjX86zxjouhivf+G7iTeVFciVWjDwblY2qlwRa9V
         9emGm1OFwkHsv0RNh6k8KhURGH1D+FwH8FkT9vHm1WjxGSwkBcc7aO9Y48XsU2c2Ndfp
         ncNp8CUw5jw3N9JSVvpdTbpMguEDLfXGvNBMVwFLUb+lT15MUcBJEF7DDDa2ApoKe2px
         /yca6v25q5b+Ew54GU19aO3kaPD9/jBteoDRN5SWUr1u5ykP8GzprDDHxTAHJoLMATxH
         L2Itbr80hoTwWdfBBNrcSmyBVo7l9b1xeyICzyCQG5N5jUV/3HnVVjmUfM6PWg6pxsNZ
         6wcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rJflZjiXOdQ2b9X0uINcJ4Ucju/qSppPTgvRYeR307M=;
        b=ET10/RrCXX3P6owUfagMkf0F59cQkj4lMqorDfThTR08/3iHauj8+fW55m8TA/Vg88
         qLZFkJZGsi4KatUVHxXehJBsyv3utbjY7xrDh8BCimVCF+TKkVo/3H/lMeqeHHBeTSaz
         4+lRiHLYzrfPMf6NpDUnbXPfZCCIIYKfgGlaaHzDGUgwAqvvnKWAY121nd6itBt+DruG
         SswYVc6sJ8DLxpRsnFfK0F29Kox+ZgXz9meTTDPPKy5aH0INGdq0hShlxKZgsxOA5bG/
         DBIz3ogC8hg/7EmfPwEu0UY0LK0dpDHf4vQSXYZ3HchrZ+sTxr9f0khpbhNKhzLZORbL
         Ip1g==
X-Gm-Message-State: AOAM532BdN0pyMUdsKZOgY9jkGw8oBX6mDyl7p6M/TurDAcVc38mQSIp
        mIUyrGtXqPfVKmBkFmw4CRMPqcrrSmQDhAeLeGj17A==
X-Google-Smtp-Source: ABdhPJwXkCPdv8pEQTPBzV1xLgwG/Fk/yXhNz7NQyeZbo2FvwLmIalitSURyFPmgQdvxw6/FjTtTVnFu1TFItk7wtV8=
X-Received: by 2002:a2e:9a4d:: with SMTP id k13mr2946227ljj.283.1594747673686;
 Tue, 14 Jul 2020 10:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZRGOsTiW3uFWd1aY6K5Yi+QBrTeC5FNOo6uVXviXuX4g@mail.gmail.com>
 <20200714012732.195466-1-yepeilin.cs@gmail.com> <CAEf4Bzas-C7hKX=AutcV1fz-F_q2P8+OCnrA37h-nCytLHPn1g@mail.gmail.com>
In-Reply-To: <CAEf4Bzas-C7hKX=AutcV1fz-F_q2P8+OCnrA37h-nCytLHPn1g@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Jul 2020 10:27:42 -0700
Message-ID: <CAADnVQ+jUPGJapkvKW=AfXESD6Vz2iuONvJm8eJm5Yd+u9mJ+w@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH v2] bpf: Fix NULL pointer
 dereference in __btf_resolve_helper_id()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 9:38 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jul 13, 2020 at 6:29 PM Peilin Ye <yepeilin.cs@gmail.com> wrote:
> >
> > Prevent __btf_resolve_helper_id() from dereferencing `btf_vmlinux`
> > as NULL. This patch fixes the following syzbot bug:
> >
> >     https://syzkaller.appspot.com/bug?id=5edd146856fd513747c1992442732e5a0e9ba355

The link looks wrong?
Nothing in the stack trace indicates this issue.

> > Reported-by: syzbot+ee09bda7017345f1fbe6@syzkaller.appspotmail.com
> > Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
> > ---
> > Thank you for reviewing my patch! I am new to Linux kernel development; would
> > the log message and errno be appropriate for this case?
>
> I think it's good enough, thanks for the fix.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >
> > Change in v2:
> >     - Split NULL and IS_ERR cases.
> >
> >  kernel/bpf/btf.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
>
> [...]
