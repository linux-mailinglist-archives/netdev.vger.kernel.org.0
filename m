Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5052AFD6E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 03:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgKLBbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgKKWtP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 17:49:15 -0500
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4289BC0617A6;
        Wed, 11 Nov 2020 14:49:15 -0800 (PST)
Received: by mail-yb1-xb42.google.com with SMTP id 2so3413686ybc.12;
        Wed, 11 Nov 2020 14:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iT9LVQY64yMi5xFP1DjBGXVD91VoCfX8XC9RPtl6MQw=;
        b=TinW5gCjgqPdm79DEwztOlE/1o5QQcmNo6XCjRTXIAlHoTTR5hONT2UXGGLU4/4qoj
         qoWBpJpcFL2NOPTXBvAwUKlZ4NCxV+UYIhI0aZ0YQ84RsVXJqfiDJIcCWemPKIba3JXs
         /XLOvdSc+MeOIQozE/S8zn4gFCVyWcUIDxjmlv5E0RhMU23cPiHv12o4MPMNREasVlPf
         H/9BX5G4/mLpotBULP63+DohdJ++cCxvrYlEy/cElpH2+w9zkro0+3tM6i9q2wMNqfS4
         kCRimJSalYZvJjpRxsFfSKok6kOc5+wg/qKaDPIjoEBG3wnmoFun9hR5QY945xidP5zm
         fU0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iT9LVQY64yMi5xFP1DjBGXVD91VoCfX8XC9RPtl6MQw=;
        b=hDiRX6/mWW6vHNRBznMnz4fZGUqf9j9GbOfxZz5kLStC9TPYm1Dzmr67NPitK+uYis
         rY9aJAA6HCwvJr1+PMN9B9x0AJl9d0S32FDtRJRxDTCqB5KVoPvfWhLBMM7tzJHUwq75
         8HvXUHrl0HtIWxJvTa9KFUo4YnHJAr33bu/2/8RrbRFsxinR65Qf5Tv07RcMy3YXNAdT
         NiA3BxJdu6a3IKOk3WL7Pjmlbxpnb5I2nB4/U3+6Dru3Av8KtpvCjFwsT7MpDa4iftzt
         WRuVRRHrbPhOXAcZ6JYh0kkN7n1ra4oYMFnUoFGtk1lXRT94GZipPTfUGcoVgW/jDmuW
         95jA==
X-Gm-Message-State: AOAM531fUJIyWWNiarnOZX3b7srxoNh+VTZU6xI65hltoYIUh9YZJ8Qk
        MHceyLtzLlaO82pEDzJZyaFVfLR1Bexv9vjq1R4=
X-Google-Smtp-Source: ABdhPJybzGOG4dZc/+8+RiBirjH0VTcdmf7tKAszXCnfnhXBIcTXTLW4yMcDgmgABJVlkcJ4qcMkOd2CyVhcXqFpGVk=
X-Received: by 2002:a25:e701:: with SMTP id e1mr12113445ybh.510.1605134954486;
 Wed, 11 Nov 2020 14:49:14 -0800 (PST)
MIME-Version: 1.0
References: <20201111135425.56533-1-wanghai38@huawei.com> <6a589c0b-e2fb-5766-542b-62f40b16253a@iogearbox.net>
 <CAEf4BzZ_Fhzg=f437fS0rZANk5ZDAfTv_T3f9Hm6LCLO23pm-g@mail.gmail.com>
In-Reply-To: <CAEf4BzZ_Fhzg=f437fS0rZANk5ZDAfTv_T3f9Hm6LCLO23pm-g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Nov 2020 14:49:03 -0800
Message-ID: <CAEf4BzZ58Pf7--2YZuJqxTr59T3-nBuswASCX837UtnZ9B--PQ@mail.gmail.com>
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

On Wed, Nov 11, 2020 at 2:37 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Nov 11, 2020 at 1:24 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 11/11/20 2:54 PM, Wang Hai wrote:
> > > progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
> > > it should be closed.
> > >
> > > Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
> > > Signed-off-by: Wang Hai <wanghai38@huawei.com>
> > > ---
> > > v2->v3: add 'err = 0' before successful return
> > > v1->v2: use cleanup tag instead of repeated closes
> > >   tools/bpf/bpftool/net.c | 18 +++++++++++-------
> > >   1 file changed, 11 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > > index 910e7bac6e9e..f927392271cc 100644
> > > --- a/tools/bpf/bpftool/net.c
> > > +++ b/tools/bpf/bpftool/net.c
> > > @@ -578,8 +578,8 @@ static int do_attach(int argc, char **argv)
> > >
> > >       ifindex = net_parse_dev(&argc, &argv);
> > >       if (ifindex < 1) {
> > > -             close(progfd);
> > > -             return -EINVAL;
> > > +             err = -EINVAL;
> > > +             goto cleanup;
> > >       }
> > >
> > >       if (argc) {
> > > @@ -587,8 +587,8 @@ static int do_attach(int argc, char **argv)
> > >                       overwrite = true;
> > >               } else {
> > >                       p_err("expected 'overwrite', got: '%s'?", *argv);
> > > -                     close(progfd);
> > > -                     return -EINVAL;
> > > +                     err = -EINVAL;
> > > +                     goto cleanup;
> > >               }
> > >       }
> > >
> > > @@ -597,16 +597,20 @@ static int do_attach(int argc, char **argv)
> > >               err = do_attach_detach_xdp(progfd, attach_type, ifindex,
> > >                                          overwrite);
> > >
> > > -     if (err < 0) {
> > > +     if (err) {
> > >               p_err("interface %s attach failed: %s",
> > >                     attach_type_strings[attach_type], strerror(-err));
> > > -             return err;
> > > +             goto cleanup;
> > >       }
> > >
> > >       if (json_output)
> > >               jsonw_null(json_wtr);
> > >
> > > -     return 0;
> > > +     err = 0;
> >
> > Why is the 'err = 0' still needed here given we test for err != 0 earlier?
> > Would just remove it, otherwise looks good.
>
> This patch was already applied. Wang, can you please follow up with
> another patch to address Daniel's feedback?

Actually, the patch hasn't been applied yet, so please just respin, thanks.

>
> >
> > > +cleanup:
> > > +     close(progfd);
> > > +     return err;
> > >   }
> > >
> > >   static int do_detach(int argc, char **argv)
> > >
> >
