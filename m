Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5B920FD6D
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgF3UHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgF3UHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:07:31 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A0EC061755;
        Tue, 30 Jun 2020 13:07:29 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id k18so19889925qke.4;
        Tue, 30 Jun 2020 13:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=og6sLVyAe8SkB1hiNqx+v/XAj5FzSDOWWpD1F/qTjYM=;
        b=c2rcBuTgmxLgRY3oT+k3oTlM9Lt832ZECTb/z5VyvJXsrhh5ghRtonASPrHdVLKsdC
         CqFLWUp86X42HX8XsA951E297eEQmBvUmq8UgSy4v1AnET+OiihRZG47fe4wEn1VAOLn
         eguW2PsB/WhdgpluBr6hYSv+CfmRw4TFCW+nzA04PDHINRgsc+oEGQb4oiXb+Uds1rxj
         DPnMOVV0+YIl14q2h4qfXaEBV7gBSG2RDDmvuoji3HgzYkfLvH7ehNAnzvDH1/8uYXl8
         uNExwmCE7P27jd3vVkH0KigAR4jTCxjFvJ2m/cycGi1tSMDH5IJ8tppAM95LOUvgQhns
         Nmng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=og6sLVyAe8SkB1hiNqx+v/XAj5FzSDOWWpD1F/qTjYM=;
        b=gqVZ+ubAN2qcZksilFBSmC1yq+qKYiHNG0ooTL8C3soZoYl8dGUrKSPcoSk8Zlv1Sv
         ZcWP3debUKHKDHg3dccYApGVPSbqerEFzoUQvWbQUQc9C2ed6a9blMhsC9fWQCOQgo1s
         8mOkvRz8EOVTo9WtqA9kHR+RPrr4t5P1bQavwUtKTScoJCu1J9gXXTbkz3JW4h8K9C+B
         gdVnvytWAfq+2XQE12ljdheSR734MN+4izgywxtFLZJ4CmcmPmH3tkOiv5qyhRzQqlzj
         5IJot56JabDyukNGp8yMdHsvhlzRqhPCkOUXWPskHIEzQdA/brEqNfbdKmD3Nyzvi4fs
         xcDA==
X-Gm-Message-State: AOAM531w7vz47LopIUhMj5gsGZhpHPTI0soA6UyS+npegQjgFoNWHdAF
        ksRFVFOY1hxbdP72Q1/quhW64dEj6/SWfpC/VIU=
X-Google-Smtp-Source: ABdhPJwHKbtFRjdEH7yiBiIYkOIM1d4Vp0HgBxaTBPzk3RUzU0FGB7K+wvVItTyJ5AJaYZL3njInZX/yX2T29PECdO4=
X-Received: by 2002:a37:7683:: with SMTP id r125mr19275856qkc.39.1593547648700;
 Tue, 30 Jun 2020 13:07:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-8-jolsa@kernel.org>
 <CAEf4BzZA3QqA=f_E8CUASVajxEsThq+Ww2Ax6az82wibx1dgOg@mail.gmail.com>
In-Reply-To: <CAEf4BzZA3QqA=f_E8CUASVajxEsThq+Ww2Ax6az82wibx1dgOg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 13:07:17 -0700
Message-ID: <CAEf4BzYh7s8=F4FeXQfxUFQiSN-KSDw1N3k7fMWA0AeLSPu-GQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 07/14] bpf: Allow nested BTF object to be
 refferenced by BTF object + offset
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 1:05 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding btf_struct_address function that takes 2 BTF objects
> > and offset as arguments and checks whether object A is nested
> > in object B on given offset.
> >
> > This function will be used when checking the helper function
> > PTR_TO_BTF_ID arguments. If the argument has an offset value,
> > the btf_struct_address will check if the final address is
> > the expected BTF ID.
> >
> > This way we can access nested BTF objects under PTR_TO_BTF_ID
> > pointer type and pass them to helpers, while they still point
> > to valid kernel BTF objects.
> >
> > Using btf_struct_access to implement new btf_struct_address
> > function, because it already walks down the given BTF object.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h   |  3 ++
> >  kernel/bpf/btf.c      | 67 ++++++++++++++++++++++++++++++++++++++-----
> >  kernel/bpf/verifier.c | 37 +++++++++++++++---------
> >  3 files changed, 87 insertions(+), 20 deletions(-)
> >

[...]

> >
> >  error:
> >                 bpf_log(log, "access beyond struct %s at off %u size %u\n",
> > @@ -4043,9 +4054,21 @@ int btf_struct_access(struct bpf_verifier_log *log,
> >
> >                         /* adjust offset we're looking for */
> >                         off -= moff;
> > +
> > +                       /* We are nexting into another struct,
> > +                        * check if we are crossing expected ID.
> > +                        */
> > +                       if (data->op == ACCESS_EXPECT && !off && t == data->exp_type)
>
> before you can do this type check, you need to btf_type_skip_modifiers() first.
>

Ignore this part, btf_resolve_size() (somewhat unexpectedly) already does that.

> > +                               return 0;
> >                         goto again;
> >                 }
> >
> > +               /* We are interested only in structs for expected ID,
> > +                * bail out.
> > +                */
> > +               if (data->op == ACCESS_EXPECT)
> > +                       return -EINVAL;
> > +
> >                 if (btf_type_is_ptr(mtype)) {
> >                         const struct btf_type *stype;
> >                         u32 id;

[...]
