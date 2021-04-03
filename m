Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5B4353499
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 17:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236835AbhDCPvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 11:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhDCPvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 11:51:32 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745C1C0613E6;
        Sat,  3 Apr 2021 08:51:28 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id g38so8001448ybi.12;
        Sat, 03 Apr 2021 08:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OfErCopIK0BJqU88sz3SKSqCy8reeHsH6ge4J7+5k7w=;
        b=Ib5uPpGWPjL03OJ/5nJeiKTJ54af8RI0wzcFewMsSILhRG5KEDF1ctOUvdbCU/5p8u
         6woAGNRb13rVYvCxw8dmcbcmw6yUuLZ1m+E4skYjwifJVxTidpPccDYrQ9F8R9tqbFEo
         0QdfRhVk1ueGUSNwOj9DgD2dgTHKTs/iGgfkmd7tN08vTeHgIV3PBVwsEtvTzY9LoK/D
         4grzLp5eK3EwLpgdHKnXKOVlIhX943nY3dczWjq5alap+GmY03UmFe6ODocK/C3L01H1
         rmSjIiY9jfAlv537uQzekyEyriCos+t91LQLhbTC62ndO9UfYqV1oSr9ige987YAyaIh
         e2Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OfErCopIK0BJqU88sz3SKSqCy8reeHsH6ge4J7+5k7w=;
        b=CoBaDnjxi06HleT1yawiwOFH1GNLuLj8SuPYsP6/gGv8ZAJiiuDeOmbr374fMsux8U
         99ZwJAgr4pRDGKIUOlIo+fiIhhGLJ++W43myvFMGoqQN4yFyHKMcR76L9t1d5eDO+4JV
         +V6daiOCghUa4cNiZVur/jZQWIi7e4ICWPDAlbVfYwSkPgYyyYefWKnRZ7TWav8yEgft
         3EJgeFUuNxI9MpbdhGeppZT1M0HMNQisGU+NVaEOo1Mu6A8eaPthOmMC2VrskyROjWsa
         VnET2S3MFFyYNRk1H/CG5ZGbNTsL2cxLa7PhwE4SBZctn9x06c4L0+DMHL/Gv7AdDw2G
         v77Q==
X-Gm-Message-State: AOAM530WsRmoG0mukAaJ3C1o1K7/WJFDfJxiEAF8lNLbt1L6AA0zbfuH
        inrboDOkJHqtyr3oiGldvl2lKZa/B18MLqMCnTEumkIc
X-Google-Smtp-Source: ABdhPJyZweu52SW1LCJRDgu3q31N9mgwGFOZUwrrb8n6v9MbAWvmJUZGV58v4O/dP93BejMMVYXt2pe9h8xEVM/ZETU=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr25227703ybf.425.1617465087696;
 Sat, 03 Apr 2021 08:51:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210328161055.257504-1-pctammela@mojatatu.com>
 <CAEf4BzZ+O3x9AksV6MGuicDQO+gObFCQQR7t6UK=RBhuSbOiZg@mail.gmail.com> <CAKY_9u0CQHmzA3YMWw24w-NbH8CK3d7Nt-jaB4EoyN7pK_fJUA@mail.gmail.com>
In-Reply-To: <CAKY_9u0CQHmzA3YMWw24w-NbH8CK3d7Nt-jaB4EoyN7pK_fJUA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 3 Apr 2021 08:51:16 -0700
Message-ID: <CAEf4BzYp+y_FqSpvdmskuWipJLX=Bp1rUEAnB0vsV-5sYXv8ww@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: add 'BPF_RB_MAY_WAKEUP' flag
To:     Pedro Tammela <pctammela@gmail.com>
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

On Sat, Apr 3, 2021 at 6:34 AM Pedro Tammela <pctammela@gmail.com> wrote:
>
> Em qua., 31 de mar. de 2021 =C3=A0s 03:54, Andrii Nakryiko
> <andrii.nakryiko@gmail.com> escreveu:
> >
> > On Sun, Mar 28, 2021 at 9:11 AM Pedro Tammela <pctammela@gmail.com> wro=
te:
> > >
> > > The current way to provide a no-op flag to 'bpf_ringbuf_submit()',
> > > 'bpf_ringbuf_discard()' and 'bpf_ringbuf_output()' is to provide a '0=
'
> > > value.
> > >
> > > A '0' value might notify the consumer if it already caught up in proc=
essing,
> > > so let's provide a more descriptive notation for this value.
> > >
> > > Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> > > ---
> >
> > flags =3D=3D 0 means "no extra modifiers of behavior". That's default
> > adaptive notification. If you want to adjust default behavior, only
> > then you specify non-zero flags. I don't think anyone will bother
> > typing BPF_RB_MAY_WAKEUP for this, nor I think it's really needed. The
> > documentation update is nice (if no flags are specified notification
> > will be sent if needed), but the new "pseudo-flag" seems like an
> > overkill to me.
>
> My intention here is to make '0' more descriptive.
> But if you think just the documentation update is enough, then I will
> remove the flag.

flags =3D=3D 0 means "default behavior", I don't think you have to
remember which verbose flag you need to specify for that, so I think
just expanding documentation is sufficient and better. Thanks!

>
> >
> > >  include/uapi/linux/bpf.h                               | 8 ++++++++
> > >  tools/include/uapi/linux/bpf.h                         | 8 ++++++++
> > >  tools/testing/selftests/bpf/progs/ima.c                | 2 +-
> > >  tools/testing/selftests/bpf/progs/ringbuf_bench.c      | 2 +-
> > >  tools/testing/selftests/bpf/progs/test_ringbuf.c       | 2 +-
> > >  tools/testing/selftests/bpf/progs/test_ringbuf_multi.c | 2 +-
> > >  6 files changed, 20 insertions(+), 4 deletions(-)
> > >
> >
> > [...]
