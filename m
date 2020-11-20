Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E7E2BA133
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 04:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbgKTDcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 22:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgKTDcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 22:32:07 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0EC8C0613CF;
        Thu, 19 Nov 2020 19:32:06 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id l14so7313192ybq.3;
        Thu, 19 Nov 2020 19:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MDSChj7t8E0nOBelKAVeGIp649rp0iplARF6aGlNqvw=;
        b=ptmUv8f9Gl69JK7a/YBc7s3Z1+m6ERmOWBawdvXIGfuVBxXuz0mCMa4YaRflW91bmP
         5y22aLYYnjbT0dJjQRUXywl1sYFnERYUx+JICdTMWr7TzUZmq3SFnlSlmUMc+FdfJHUN
         u02PhjBlzPbJ612ArzowlZgz+0yZz/IY3ORjtGkNrKOfL6hJRKspw78uNeQLLkSd/60y
         2W3Izzol1JsRBV38OuQvwFufMoztGXdPk7ghcWKCIXfqjfDbkAOe/rW7n+p2qw+hjZkG
         zRAMNsTXbiKcQ2dU5D0oX1N5xqfFOT9DB9r5YZ5fxCnlCon+rPx1PvMSz3otF72KEfsm
         bMEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MDSChj7t8E0nOBelKAVeGIp649rp0iplARF6aGlNqvw=;
        b=lMA9OUhruR17Lqbne+unNySzVdzB68+l9al4MfTa9t4qLy3lzqvgOta1pIOScRz1B0
         HxJlxFShc1cGawMZvYs7s0QWb3CdM+scu3J0XM1Q1sIl/x7WZq0GQfKRunx/fU60yrUV
         TEP8fBYWpSB0DqOYeg+s2pWWv34X7yc2kNNG7WcGf77TekDaa5eVkvpgwHj6lv+3e833
         BLlUMOlnSXLx+/WE+FfT2whgOBuZrOSKzmtHicJiR0YwCBoMaaMkVGwF/xHhW9h34RPj
         yfs5aqH9W/qfgooyENtk40752bjdxIpRwgwz2X+dwyoDVnvZfi1Y7RPGOnGgr0eRLcDh
         3RTw==
X-Gm-Message-State: AOAM533pS/OkBGd2GpTmZN07YZwSSglznXm0yD6vBlAzVwXRKBu06EFp
        RINZCDvPTQ/MnGjYC1cspxxjC4TQDr+6fd+yAHk=
X-Google-Smtp-Source: ABdhPJzMG5f2CUvTuJkLQZrKh4JSphCj1EjRVb8WpOTydHpA5PzcqTUnK6mBuxsGnInTzvH9FsTNmvSZ2UlPrg1e0s4=
X-Received: by 2002:a25:7717:: with SMTP id s23mr23026247ybc.459.1605843125502;
 Thu, 19 Nov 2020 19:32:05 -0800 (PST)
MIME-Version: 1.0
References: <20201119232244.2776720-1-andrii@kernel.org> <20201119232244.2776720-5-andrii@kernel.org>
 <20201120004624.GA25728@ranger.igk.intel.com> <CAEf4BzbZihTe74R_mHU=6S0QcrXaKEFoubByP5HVRq6O-t6c-Q@mail.gmail.com>
 <20201120020527.GB26162@ranger.igk.intel.com>
In-Reply-To: <20201120020527.GB26162@ranger.igk.intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Nov 2020 19:31:54 -0800
Message-ID: <CAEf4BzbzcjjiqN=dReEp8xTcBHsFJmewKUyvU83S2sU+0_FTjg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/6] libbpf: add kernel module BTF support for
 CO-RE relocations
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 6:14 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Thu, Nov 19, 2020 at 05:24:43PM -0800, Andrii Nakryiko wrote:
> > On Thu, Nov 19, 2020 at 4:55 PM Maciej Fijalkowski
> > <maciej.fijalkowski@intel.com> wrote:
> > >
> > > On Thu, Nov 19, 2020 at 03:22:42PM -0800, Andrii Nakryiko wrote:
> > > > Teach libbpf to search for candidate types for CO-RE relocations across kernel
> > > > modules BTFs, in addition to vmlinux BTF. If at least one candidate type is
> > > > found in vmlinux BTF, kernel module BTFs are not iterated. If vmlinux BTF has
> > > > no matching candidates, then find all kernel module BTFs and search for all
> > > > matching candidates across all of them.
> > > >
> > > > Kernel's support for module BTFs are inferred from the support for BTF name
> > > > pointer in BPF UAPI.
> > > >
> > > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c | 185 ++++++++++++++++++++++++++++++++++++++---
> > > >  1 file changed, 172 insertions(+), 13 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > > +static int probe_module_btf(void)
> > > > +{
> > > > +     static const char strs[] = "\0int";
> > > > +     __u32 types[] = {
> > > > +             /* int */
> > > > +             BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),
> > > > +     };
> > > > +     struct bpf_btf_info info;
> > > > +     __u32 len = sizeof(info);
> > > > +     char name[16];
> > > > +     int fd, err;
> > > > +
> > > > +     fd = libbpf__load_raw_btf((char *)types, sizeof(types), strs, sizeof(strs));
> > > > +     if (fd < 0)
> > > > +             return 0; /* BTF not supported at all */
> > > > +
> > > > +     len = sizeof(info);
> > >
> > > nit: reinit of len
> > >
> >
> > oops, right, I'll remove it
> >
> >
> > > > +     memset(&info, 0, sizeof(info));
> > >
> > > use len in memset
> >
> > why?
>
> Hm, just to make use of local var? We might argue that current version is

I agree, I think sizeof(info) is more readable. But my point is that
if you suggest something, please provide at least some argument for
why you think it's better or why existing code is worse or wrong (if
you think it is).

> more readable, but then again I would question the len's existence.

len is passed to the kernel by reference and the kernel is updating it
with the actual length it has (which could be <, ==, or > than what
the program specified). So it has to be in a variable.

>
> Do whatever you want, these were just nits :)
>
> >
> > >
> > > > +     info.name = ptr_to_u64(name);
> > > > +     info.name_len = sizeof(name);
> > > > +
> > > > +     /* check that BPF_OBJ_GET_INFO_BY_FD supports specifying name pointer;
> > > > +      * kernel's module BTF support coincides with support for
> > > > +      * name/name_len fields in struct bpf_btf_info.
> > > > +      */
> > > > +     err = bpf_obj_get_info_by_fd(fd, &info, &len);

here -------------------------------------------------^^^^

> > > > +     close(fd);
> > > > +     return !err;
> > > > +}
> > >
> > > [...]
