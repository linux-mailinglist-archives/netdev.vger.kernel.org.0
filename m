Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA3382D23B5
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbgLHGjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgLHGjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 01:39:36 -0500
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BA7C0613D6;
        Mon,  7 Dec 2020 22:38:56 -0800 (PST)
Received: by mail-yb1-xb43.google.com with SMTP id a16so10151128ybh.5;
        Mon, 07 Dec 2020 22:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n+DomqOo2PhT6ykuvOU2eB7Z2/mQ2l0eQHy8iuDLKV4=;
        b=SJJauJb1pLbD5glsSvQcPwoH6cG5a2cEFvOVhJnMLedik26ozqAJL2ts6WYZMYSZvx
         p4GvCeEn7T0yHVhKucSezvYCH+qGX7raKZwoUgnHf7YvZ5yeuVCLbvJocL3DUOS5q6Yw
         YBd/4gu22ExVHzSfPok64amPLKUt0niYVmT9yDTtgqh58e1MJoQggmQv4DAb5jn5vgna
         D9lhfZOGGuhez6jC3TZaSMhzdnNGHofygvzQc1R71WmIixOki0edKmtTCNBUmHAy+0ri
         xpKbHb47JmCcindsHk1slH69xnBx+5i9LdK+DvAoTP8rs+InHzAm5XjaXR76Rau8bzUe
         cg/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n+DomqOo2PhT6ykuvOU2eB7Z2/mQ2l0eQHy8iuDLKV4=;
        b=W+5dosFyeNI9GPNuHcEYtBRVcvFLyutAQqGqtzFuRgzCpAB/pFcmU0VKcgnT5GnXJ2
         dOuX9nrYbx++iZRdkAfDucgQ3wzSTGR6s/OueOpYllOb78RHsLCW5pmMJt4OSqIDGb7t
         DV1xzFEIeiflyVEEdVaujwwNclfkA965OVR1nD48j1vPWSPLUBLSrIbyP7CrKPLDBE8l
         /sSYSyi6UPiyklimKU6rX+UkXJsGLQYspoYlUJkz3aAObNqKdblZLBXn6OWg3U7BeoP6
         UC0OzgTdY9S9PREfCkbZ+XAQmW2vvJpVYBOFM4jRmIHyR8oAi4vSBtjSkcX4KU/7JVgo
         LxwA==
X-Gm-Message-State: AOAM5321D7qvzaYc07vYrtSEGwH9t8QYoGNJvE0QZ5zzwxX0P5O35L30
        +ctHvqccUeUKllVpkI4Y2jD/1y45gcJ9LkgRuDTQ63vR4254Kg==
X-Google-Smtp-Source: ABdhPJwISyhwAhl/kvoznjUoicbLOLCug5cAjOdzMRgrGTXU2ExaeOi24/UCox4URHYmKEe+m3lvivB2FtluuE8LSyg=
X-Received: by 2002:a25:d44:: with SMTP id 65mr15958804ybn.260.1607409535674;
 Mon, 07 Dec 2020 22:38:55 -0800 (PST)
MIME-Version: 1.0
References: <20201207052057.397223-1-saeed@kernel.org> <CAEf4BzZe2162nMsamMKkGRpR_9hUnaATWocE=XjgZd+2cJk5Jw@mail.gmail.com>
 <76aa0d16e3d03cf12496184c848f60069bf71872.camel@kernel.org>
In-Reply-To: <76aa0d16e3d03cf12496184c848f60069bf71872.camel@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Dec 2020 22:38:44 -0800
Message-ID: <CAEf4BzYzJuPt8Fct2pOTPjHLiiyGPQw05rFNK4d+MAJTC_itkw@mail.gmail.com>
Subject: Re: [PATCH bpf] tools/bpftool: Add/Fix support for modules btf dump
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 7, 2020 at 10:26 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Mon, 2020-12-07 at 19:14 -0800, Andrii Nakryiko wrote:
> > On Sun, Dec 6, 2020 at 9:21 PM <saeed@kernel.org> wrote:
> > > From: Saeed Mahameed <saeedm@nvidia.com>
> > >
> > > While playing with BTF for modules, i noticed that executing the
> > > command:
> > > $ bpftool btf dump id <module's btf id>
> > >
> > > Fails due to lack of information in the BTF data.
> > >
> > > Maybe I am missing a step but actually adding the support for this
> > > is
> > > very simple.
> >
> > yes, bpftool takes -B <path> argument for specifying base BTF. So if
> > you added -B /sys/kernel/btf/vmlinux, it should have worked. I've
> > added auto-detection logic for the case of `btf dump file
> > /sys/kernel/btf/<module>` (see [0]), and we can also add it for when
> > ID corresponds to a module BTF. But I think it's simplest to re-use
> > the logic and just open /sys/kernel/btf/vmlinux, instead of adding
> > narrowly-focused libbpf API for that.
> >
>
> When dumping with a file it works even without the -B since you lookup
> the vmlinux file, but the issue is not dumping from a file source, we
> need it by id..
>
> > > To completely parse modules BTF data, we need the vmlinux BTF as
> > > their
> > > "base btf", which can be easily found by iterating through the btf
> > > ids and
> > > looking for btf.name == "vmlinux".
> > >
> > > I am not sure why this hasn't been added by the original patchset
> >
> > because I never though of dumping module BTF by id, given there is
> > nicely named /sys/kernel/btf/<module> :)
> >
>
> What if i didn't compile my kernel with SYSFS ? a user experience is a
> user experience, there is no reason to not support dump a module btf by
> id or to have different behavior for different BTF sources.

Hm... I didn't claim otherwise and didn't oppose the feature, why the
lecture about user experience?

Not having sysfs is a valid point. In such cases, if BTF dumping is
from ID and we see that it's a module BTF, finding vmlinux BTF from ID
makes sense.

>
> I can revise this patch to support -B option and lookup vmlinux file if
> not provided for module btf dump by ids.

yep

>
> but we  still need to pass base_btf to btf__get_from_id() in order to
> support that, as was done for btf__parse_split() ... :/

btf__get_from_id_split() might be needed, yes.

>
> Are you sure you don't like the current patch/libbpf API ? it is pretty
> straight forward and correct.

I definitely don't like adding btf_get_kernel_id() API to libbpf.
There is nothing special about it to warrant adding it as a public
API. Everything we discussed can be done by bpftool.

>
> > > "Integrate kernel module BTF support", as adding the support for
> > > this is very trivial. Unless i am missing something, CCing Andrii..
> > >
> > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > > CC: Andrii Nakryiko <andrii@kernel.org>
> > > ---
> > >  tools/lib/bpf/btf.c      | 57
> > > ++++++++++++++++++++++++++++++++++++++++
> > >  tools/lib/bpf/btf.h      |  2 ++
> > >  tools/lib/bpf/libbpf.map |  1 +
> > >  3 files changed, 60 insertions(+)
> > >
> >
> > [...]
>
