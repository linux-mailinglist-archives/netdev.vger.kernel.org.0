Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 927BF2AFBF7
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:31:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgKLBbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgKKWqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:46:45 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B2CC040208;
        Wed, 11 Nov 2020 14:37:53 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id o71so3116040ybc.2;
        Wed, 11 Nov 2020 14:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N5VYtEHc8PJh6B9Pxwlx+Xskau4NMSgJa2pe+N/+0hQ=;
        b=mIC6jicwNMDMYFiuiMuBACCgPbD4hSINY8bHnJF3OU19jk/QMCYS7pM4BqBYavjA0W
         pHxyF+5JWJ8hwLLq8P+ss5fOJeI9XR3Ao4i+1Qehu4nmX3b2R4SR6OlZatgHcBT+Z1MD
         gAhYz1nodwBBFDlSTR5wkXAbX3s2h30wOkMt0Nl3Gx5gN0WuFqgPKmdajV5Fqp5EkdKL
         DbkVkXX2DJ82y3plY4hdjt4ShFcoj1g7LOgV7GjgWklZ0FHTLCtzaDaFqkMlvVsFwSKF
         Cam5QJUDpkf0ccxOJVmYz5OL0RQ4cnwrBEG8pgOLj+kmKXOEy1qW9ZMcrkguIMBBkY95
         YbjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N5VYtEHc8PJh6B9Pxwlx+Xskau4NMSgJa2pe+N/+0hQ=;
        b=WgQ+XSsYE2loy5eJGekzcKizIxnNM0HHKr9TlsT4HbEGtLLMPhFLh8FtVSVSNx2/cu
         3QbVq5XwDGglodZVtn27r5EVXlOPtEFvhkwMEsk+sQ6POun/tuZUwSqFcGi6KKgThoPo
         HbyEkFD4gGCXZUgCRM3JXcDpwi0SVDt1qS5ZGGcR2M43uGr91HSwfeRXvOOPtZyMkrwH
         9NHmUZFdxOLGAcrm91VlWaJig9NCSuLZ7ZcEV0Z+8QscmTZ/eSCzL028Wez30jByJIM6
         04uJx/HX6e/5ax/I2bApE1kDm5afAmqvaAl/F1eUx3Mcz82Jg1cPNwUr51NQcTKcL7kA
         PVLA==
X-Gm-Message-State: AOAM533FnOHm0GxSX+6EvwB6TYOdna3KBFNimIEFubyJzQLcuJEOZbJ4
        0XItsjKKwKx9LrLoEJl2fQuc6oLRUI1z3N9lXgk=
X-Google-Smtp-Source: ABdhPJzceVMSitP9WEByfMfPlKfV3tIMI46eRigsyjAZap2rw9WtaR+Alr/UeVY1x+3FV4YmkQ5rHafJEb0fbziZqJQ=
X-Received: by 2002:a25:e701:: with SMTP id e1mr12067008ybh.510.1605134272385;
 Wed, 11 Nov 2020 14:37:52 -0800 (PST)
MIME-Version: 1.0
References: <20201111135425.56533-1-wanghai38@huawei.com> <6a589c0b-e2fb-5766-542b-62f40b16253a@iogearbox.net>
In-Reply-To: <6a589c0b-e2fb-5766-542b-62f40b16253a@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Nov 2020 14:37:41 -0800
Message-ID: <CAEf4BzZ_Fhzg=f437fS0rZANk5ZDAfTv_T3f9Hm6LCLO23pm-g@mail.gmail.com>
Subject: Re: [PATCH v3 bpf] tools: bpftool: Add missing close before bpftool
 net attach exit
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Wang Hai <wanghai38@huawei.com>,
        john fastabend <john.fastabend@gmail.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Daniel T. Lee" <danieltimlee@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 1:24 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 11/11/20 2:54 PM, Wang Hai wrote:
> > progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
> > it should be closed.
> >
> > Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
> > Signed-off-by: Wang Hai <wanghai38@huawei.com>
> > ---
> > v2->v3: add 'err = 0' before successful return
> > v1->v2: use cleanup tag instead of repeated closes
> >   tools/bpf/bpftool/net.c | 18 +++++++++++-------
> >   1 file changed, 11 insertions(+), 7 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index 910e7bac6e9e..f927392271cc 100644
> > --- a/tools/bpf/bpftool/net.c
> > +++ b/tools/bpf/bpftool/net.c
> > @@ -578,8 +578,8 @@ static int do_attach(int argc, char **argv)
> >
> >       ifindex = net_parse_dev(&argc, &argv);
> >       if (ifindex < 1) {
> > -             close(progfd);
> > -             return -EINVAL;
> > +             err = -EINVAL;
> > +             goto cleanup;
> >       }
> >
> >       if (argc) {
> > @@ -587,8 +587,8 @@ static int do_attach(int argc, char **argv)
> >                       overwrite = true;
> >               } else {
> >                       p_err("expected 'overwrite', got: '%s'?", *argv);
> > -                     close(progfd);
> > -                     return -EINVAL;
> > +                     err = -EINVAL;
> > +                     goto cleanup;
> >               }
> >       }
> >
> > @@ -597,16 +597,20 @@ static int do_attach(int argc, char **argv)
> >               err = do_attach_detach_xdp(progfd, attach_type, ifindex,
> >                                          overwrite);
> >
> > -     if (err < 0) {
> > +     if (err) {
> >               p_err("interface %s attach failed: %s",
> >                     attach_type_strings[attach_type], strerror(-err));
> > -             return err;
> > +             goto cleanup;
> >       }
> >
> >       if (json_output)
> >               jsonw_null(json_wtr);
> >
> > -     return 0;
> > +     err = 0;
>
> Why is the 'err = 0' still needed here given we test for err != 0 earlier?
> Would just remove it, otherwise looks good.

This patch was already applied. Wang, can you please follow up with
another patch to address Daniel's feedback?

>
> > +cleanup:
> > +     close(progfd);
> > +     return err;
> >   }
> >
> >   static int do_detach(int argc, char **argv)
> >
>
