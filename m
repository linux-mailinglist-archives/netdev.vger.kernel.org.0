Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 350EC35342A
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 15:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbhDCNeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 09:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhDCNeV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 09:34:21 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA0DCC0613E6;
        Sat,  3 Apr 2021 06:34:17 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id t14so6681900ilu.3;
        Sat, 03 Apr 2021 06:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VJp4D6U+YVHcyZ2m4PpfXIZzUzuqJ6Sl/X10+bQZIBc=;
        b=a3TBbUvFzns2MCsfROJI0NUhmSQTS5MUQ6OpuFtBvkq1yKPFOLcnS9qTkHdqXrWm7l
         Ug1yBU1UkyeNkIn10LHJQpJRvQ3xrKQCpZMkvgAPrSTn08bfPg0Uj7SaFgK04gxNZTWf
         agTafj/dY7Kv+zyZM39BVmVaVDCEhg7xXeOmyZDswqN0h87V/iuCHQ7Tq2eczAqUJkv7
         WjrRrf2f+iQ/+sc0INQW9BMlsUASkPhTrjNjLLUvosMBpfRwMYYII/77TzGCeyqOLZaQ
         mX+68Pt8nSY356gPO3l2lvBpta1SoT9iYHvRFR5IvWgM0AcwtOi8/B0lAh+cqkzI5f6/
         gHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VJp4D6U+YVHcyZ2m4PpfXIZzUzuqJ6Sl/X10+bQZIBc=;
        b=iM6xeGjtLeQDohiMR9wRtTXxVB8875fNs+WyYMiVDUwjYGD54Df+vFK53+2FeZGrYV
         sGaLJZwp/8mbwUrB71oJFf/3jXxEGMuPfB1n3rI6d8TYWN/QodvOPvPUmVM0nhuHT27Y
         Ew+UdlFqjbNUUSxyNMP/aStWLxUaR2VJV1Z9jRdESl7JcgApcZZDuL7xmzbXGI6NJJEq
         4uj1lk3On7wqcvkVnqwPlC1RzmhwqYLan0eaIm745xI7XzipyUgN9XwU2Dng7HfRycek
         3Qo7cd2JC9ARZaNu9AWDU+PF96Jnp8M5HoxrNu+vSNDfNFemTb0UR84dtZM1aAlYmm0n
         S4ew==
X-Gm-Message-State: AOAM532NnruJZnmrQ08lYbvZVbdwg4xY1pOKcU0M+GFSbXigUT7TByRl
        ybuUXyhd88Av1Cuer0Lru3dU+LzYd9RRvtn+GjE=
X-Google-Smtp-Source: ABdhPJydjLs7rBGgKGAm12yIF25CeQ48+Ys+nKLxtS9Gz/hpaVxDb3wIsNYdLAqZbijKnK/eqdn6bIcMNWEb9n4MWF4=
X-Received: by 2002:a05:6e02:e10:: with SMTP id a16mr795805ilk.118.1617456857309;
 Sat, 03 Apr 2021 06:34:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210328161055.257504-1-pctammela@mojatatu.com> <CAEf4BzZ+O3x9AksV6MGuicDQO+gObFCQQR7t6UK=RBhuSbOiZg@mail.gmail.com>
In-Reply-To: <CAEf4BzZ+O3x9AksV6MGuicDQO+gObFCQQR7t6UK=RBhuSbOiZg@mail.gmail.com>
From:   Pedro Tammela <pctammela@gmail.com>
Date:   Sat, 3 Apr 2021 10:34:06 -0300
Message-ID: <CAKY_9u0CQHmzA3YMWw24w-NbH8CK3d7Nt-jaB4EoyN7pK_fJUA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add 'BPF_RB_MAY_WAKEUP' flag
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Pedro Tammela <pctammela@mojatatu.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em qua., 31 de mar. de 2021 =C3=A0s 03:54, Andrii Nakryiko
<andrii.nakryiko@gmail.com> escreveu:
>
> On Sun, Mar 28, 2021 at 9:11 AM Pedro Tammela <pctammela@gmail.com> wrote=
:
> >
> > The current way to provide a no-op flag to 'bpf_ringbuf_submit()',
> > 'bpf_ringbuf_discard()' and 'bpf_ringbuf_output()' is to provide a '0'
> > value.
> >
> > A '0' value might notify the consumer if it already caught up in proces=
sing,
> > so let's provide a more descriptive notation for this value.
> >
> > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > ---
>
> flags =3D=3D 0 means "no extra modifiers of behavior". That's default
> adaptive notification. If you want to adjust default behavior, only
> then you specify non-zero flags. I don't think anyone will bother
> typing BPF_RB_MAY_WAKEUP for this, nor I think it's really needed. The
> documentation update is nice (if no flags are specified notification
> will be sent if needed), but the new "pseudo-flag" seems like an
> overkill to me.

My intention here is to make '0' more descriptive.
But if you think just the documentation update is enough, then I will
remove the flag.

>
> >  include/uapi/linux/bpf.h                               | 8 ++++++++
> >  tools/include/uapi/linux/bpf.h                         | 8 ++++++++
> >  tools/testing/selftests/bpf/progs/ima.c                | 2 +-
> >  tools/testing/selftests/bpf/progs/ringbuf_bench.c      | 2 +-
> >  tools/testing/selftests/bpf/progs/test_ringbuf.c       | 2 +-
> >  tools/testing/selftests/bpf/progs/test_ringbuf_multi.c | 2 +-
> >  6 files changed, 20 insertions(+), 4 deletions(-)
> >
>
> [...]
