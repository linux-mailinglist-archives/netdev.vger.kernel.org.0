Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5D2269BE4
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 04:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbgIOCas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 22:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbgIOCar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 22:30:47 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D18C06174A;
        Mon, 14 Sep 2020 19:30:46 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id u21so1404044ljl.6;
        Mon, 14 Sep 2020 19:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tro46/xaKYQul4UpNCk3ZfYD8WxwQ4bYSoftiw8oIUk=;
        b=YAeHOF5ilSn66lgtL1kLOIil95CmPcUskd8Bi8IkLw7pKLT/ZMntsYqfI1hVIMqPYt
         4teKuOpTVuyEIox1km5nCsaW0Fv0WX5+HS27v5MtMnERiX5wcitDubsFR0ywTQmdW/qU
         lSzv2Eolb349WNE/0cNCQYcO2M3LXPi1ahdO3u60ftSvAdKnxr0WlSsnp9DLOOsiNQpF
         OXWDpZs7gl8cvKadoFOCJDZLHqn18cCw/pMms1MJvl/f5LYLhfca/B1za3RindBs2kpL
         yfaEVUVfNA28POaIuylmcy3/OZ7arI4fO5M/fGmXSo+60lnzW97nt/32n0zngS7Wh4c0
         g3Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Tro46/xaKYQul4UpNCk3ZfYD8WxwQ4bYSoftiw8oIUk=;
        b=qSx/OHvizaUMYv0LtBQiU4eysr19FmlyBtJpvf7nH9mjduwbwDVMxb9z7HoEDAj423
         x2e8rknd8Z8N9bQfLtODoh+6EHnavf4xTgH0WHaS0N2/UHEM5RzlzPDFeoTwCjdKUc80
         iscKIsr9R3O8WlfPX6lyZ3+9Cke8EDboLq6A80PUg5//KFa04XbuF43XIDPsz2e4+7eX
         lfVaprvfqPzcQg92d7sY1WkcUAoFhixczV4/k6jMnJZjmLXXEdmsz3YQql7yHM/7YYPm
         hNTqeaorFttmdFNofBTfII+L3aTGyW1bSm8aFiYOSTroWWcFIkd93iCtD+vDTYYmPHuI
         /Y+w==
X-Gm-Message-State: AOAM5309UjlKddjq+PySdlF7WxB7xzu15zWjqUDODJ6sFbOma+dRfVvc
        y9HTkWDmvs4Mn3PdnJpVTAWHPUTtB/6zD9vKeWQ=
X-Google-Smtp-Source: ABdhPJzq5XRJsdExj8Rf6oQ9vmxms1fR6dDy8zoTK19Rgse4w/739pplr9MP8t8INJZhjutWvUc1QwMdc5FpJpf7330=
X-Received: by 2002:a2e:9dcb:: with SMTP id x11mr6319462ljj.450.1600137045158;
 Mon, 14 Sep 2020 19:30:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200910122224.1683258-1-jolsa@kernel.org> <CAADnVQJ0FchoPqNWm+dEppyij-MOvvEG_trEfyrHdabtcEuZGg@mail.gmail.com>
 <20200911131558.GD1714160@krava>
In-Reply-To: <20200911131558.GD1714160@krava>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 14 Sep 2020 19:30:33 -0700
Message-ID: <CAADnVQKhf8X0zxcx5B9VsXM3Wesayk_Hbtu-zobqaZU09jNv7Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Check trampoline execution in
 d_path test
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 6:16 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Sep 10, 2020 at 05:46:21PM -0700, Alexei Starovoitov wrote:
> > On Thu, Sep 10, 2020 at 5:22 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Some kernels builds might inline vfs_getattr call within
> > > fstat syscall code path, so fentry/vfs_getattr trampoline
> > > is not called.
> > >
> > > I'm not sure how to handle this in some generic way other
> > > than use some other function, but that might get inlined at
> > > some point as well.
> >
> > It's great that we had the test and it failed.
> > Doing the test skipping will only hide the problem.
> > Please don't do it here and in the future.
> > Instead let's figure out the real solution.
> > Assuming that vfs_getattr was added to btf_allowlist_d_path
> > for a reason we have to make this introspection place
> > reliable regardless of compiler inlining decisions.
> > We can mark it as 'noinline', but that's undesirable.
> > I suggest we remove it from the allowlist and replace it with
> > security_inode_getattr.
> > I think that is a better long term fix.
>
> in my case vfs_getattr got inlined in vfs_statx_fd and both
> of them are defined in fs/stat.c
>
> so the idea is that inlining will not happen if the function
> is defined in another object? or less likely..?

when it's in a different .o file. yes.
Very few folks build LTO kernels, so I propose to cross that bridge when
we get there.
Eventually we can replace security_inode_getattr
with bpf_lsm_inode_getattr or simply add noinline to security_inode_getattr.

> we should be safe when it's called from module

what do you mean?

> > While at it I would apply the same critical thinking to other
> > functions in the allowlist. They might suffer the same issue.
> > So s/vfs_truncate/security_path_truncate/ and so on?
> > Things won't work when CONFIG_SECURITY is off, but that is a rare kernel config?
> > Or add both security_* and vfs_* variants and switch tests to use security_* ?
> > but it feels fragile to allow inline-able funcs in allowlist.
>
> hm, what's the difference between vfs_getattr and security_inode_getattr
> in this regard? I'd expect compiler could inline it same way as for vfs_getattr

not really because they're in different files and LTO is not on.
Even with LTO the chances of inlining are small. The compiler will
consider profitability of it. Since there is a loop inside, it's unlikely.
