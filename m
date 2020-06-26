Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5588D20BC5B
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726005AbgFZWTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFZWTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:19:30 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6BCC03E979;
        Fri, 26 Jun 2020 15:19:30 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id el4so1112433qvb.13;
        Fri, 26 Jun 2020 15:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QuKsH+pZSiaKgslDtVHe8fsKj/4i/bzfzea0Gy27Fq0=;
        b=ttNDmaj2ozht9hmyX0oCyxIWAtN+h/AXU/Ye3VW10Qg/aIbJHAHizDCKQ+CJ+ozhAr
         J4klm6p8H9sYtccz0IE/56Bfge/u1X6sRIWvV3EWNDSFmqdsx7KyTqn5rs+GQT//tEJU
         gzd6zide4Tper2lrtOpvid3/eSaBxnAPU28FbH0x16OBmWLHxhRcFmy73SbOsj4wD5Mh
         qzOhpPLdxoaB85/wfsjy08TZNtF8a16n/1ycULSmFwePRvV4TcRA4IeSb4GP4q4Y0/Lo
         pbFuNjD1Yhtw8lOSSyeKvX5hAGE71UuQ43FYt39kTmzJnMcR9Ez6QRFHrFyMxoQnb0h6
         hsCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QuKsH+pZSiaKgslDtVHe8fsKj/4i/bzfzea0Gy27Fq0=;
        b=fx/+Sj6oEIVZNvCRZ6JjBbNnByY53vKT9axHIUl/5T7P2/mynAEDyRTWp07AMiqjeI
         vqqVj21sNtm+qzREMJHWXWiT7EVE/cpoU/vY2r9bpGnxkZKe0aPleArPrughpVbFSEsM
         4wcG9JQg7mHzdR5JbXxaETiF0U/1Vl0W67SuQDF+P1j8GIr8WSGs+ouncYG3LRXU+dnv
         4VIo9stuGLVaU8TVmuKe9sHM1zoTxYd8Jd6HVKNE5XDKv8HEWdAI4Bg3ui6mdgzjZN3L
         9O6yvWLbS/FkkcJf4QjSXXxUgeis0Gu5NJ7bLnvcOAYzzjQD6ShpauH//l1pbbZUGr9O
         Bakw==
X-Gm-Message-State: AOAM53374tDTq6VEUYebBEdN0DWCKFkX2/Rm8za5ToKTk5RxwQUVisGX
        auZTMbtGZS2koWcljM8qjvyY32+K5+MGOqplyX4=
X-Google-Smtp-Source: ABdhPJwhkM7O+HhWyB4abQ92K5Liq5lkGw1Wt0cOtk9X9k9p9iMgq6w3qj35A6mBqgVU5eFGvboQkgwWJjEjEWJGFS0=
X-Received: by 2002:ad4:4645:: with SMTP id y5mr5457481qvv.163.1593209969441;
 Fri, 26 Jun 2020 15:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200626081720.5546-1-danieltimlee@gmail.com> <20200626081720.5546-3-danieltimlee@gmail.com>
 <CAEf4BzbGk2xSGAkLEXKSg3NhrL28o+cmW9jTq2=EhggJEYT=5Q@mail.gmail.com> <CAEKGpziJWYDhnq=DWvcFdSAA-jnGk=Vrci2A-9ktY6g5_4Ki8Q@mail.gmail.com>
In-Reply-To: <CAEKGpziJWYDhnq=DWvcFdSAA-jnGk=Vrci2A-9ktY6g5_4Ki8Q@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 15:19:18 -0700
Message-ID: <CAEf4BzZZxQr4QzTyL-6n0XE=aSBQFhLSNXU=aBxzu5tofgiVRA@mail.gmail.com>
Subject: Re: [PATCH 3/3] samples: bpf: refactor BPF map in map test with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:14 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> On Sat, Jun 27, 2020 at 5:30 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Fri, Jun 26, 2020 at 1:18 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > >
> > > From commit 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map
> > > support"), a way to define internal map in BTF-defined map has been
> > > added.
> > >
> > > Instead of using previous 'inner_map_idx' definition, the structure to
> > > be used for the inner map can be directly defined using array directive.
> > >
> > >     __array(values, struct inner_map)
> > >
> > > This commit refactors map in map test program with libbpf by explicitly
> > > defining inner map with BTF-defined format.
> > >
> > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > ---
> >
> > Thanks for the clean up, looks good except that prog NULL check.
> >
>
> I'll fix this NULL check as well too.
>
> > It also seems like this is the last use of bpf_map_def_legacy, do you
> > mind removing it as well?
> >
>
> Actually, there is one more place that uses bpf_map_def_legacy.
> map_perf_test_kern.c is the one, and I'm currently working on it, but
> I'm having difficulty with refactoring this file at the moment.
>
> It has a hash_map map definition named inner_lru_hash_map with
> BPF_F_NUMA_NODE flag and '.numa_node = 0'.
>
> The bpf_map_def in libbpf has the attribute name map_flags but
> it does not have the numa_node attribute. Because the numa node

It does since 1 or 2 days ago ([0])

  [0] https://patchwork.ozlabs.org/project/netdev/patch/20200621062112.3006313-1-andriin@fb.com/


> for bpf_map_def cannot be explicitly specified, this means that there
> is no way to set the numa node where the map will be placed at the
> time of bpf_object__load.
>
> The only approach currently available is not to use libbbpf to handle
> everything (bpf_object_load), but instead to create a map directly with
> specifying numa node (bpf_load approach).
>
>     bpf_create_map_in_map_node
>     bpf_create_map_node
>
> I'm trying to stick with the libbpf implementation only, and I'm wondering
> If I have to create bpf maps manually at _user.c program.
>
> Any advice and suggestions will be greatly appreciated.
>

It should be super straightforward now with a BTF-defined map
supporting numa_node attribute.

> Thanks for your time and effort for the review.
> Daniel.
>
> >
> > >  samples/bpf/Makefile               |  2 +-
> > >  samples/bpf/test_map_in_map_kern.c | 85 +++++++++++++++---------------
> > >  samples/bpf/test_map_in_map_user.c | 53 +++++++++++++++++--
> > >  3 files changed, 91 insertions(+), 49 deletions(-)
> > >
> >
> > [...]
> >
> > >
> > >         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > > +       obj = bpf_object__open_file(filename, NULL);
> > > +       if (libbpf_get_error(obj)) {
> >
> > this is right, but...
> >
> > > +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > > +               return 0;
> > > +       }
> > >
> > > -       if (load_bpf_file(filename)) {
> > > -               printf("%s", bpf_log_buf);
> > > -               return 1;
> > > +       prog = bpf_object__find_program_by_name(obj, "trace_sys_connect");
> > > +       if (libbpf_get_error(prog)) {
> >
> > this is wrong. Just NULL check. libbpf APIs are not very consistent
> > with what they return, unfortunately.
> >
> > > +               printf("finding a prog in obj file failed\n");
> > > +               goto cleanup;
> > > +       }
> > > +
> >
> > [...]
