Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BEF20BC73
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgFZWZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZWZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:25:46 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B65DC03E979;
        Fri, 26 Jun 2020 15:25:46 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id j202so5177075ybg.6;
        Fri, 26 Jun 2020 15:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Y8XpZ0jbwDFlmqM0FO43fJzaMOOVAAU8FbN4RXs5fU=;
        b=EuciXvnScOAUVvFcLhdCZOekUOuDt+qd9z4q0Yf3183aw7BrXiOxfl0g0nhN7BGk+J
         WlDJjUTUSeni19mm1BSfvlFT9bQawCoh39DtKsHCkQKScTTYHYRbgPcLKDX1+yzrsA2A
         rvcHkM6Xq7u5zzajeol7NSDj/nNn7xSeuksDSQIfyM1Pic92lZ4amAhlPZDIG4ObafAg
         /SNasZs5yUgn3pXQcodt5HrGk2LHVzPOgxI3WZ7eV4AaJ54fWPOsVigXGs4Ag4PAI00r
         +cME624hQublo79BJmHfahaq2dXcV/b5xGjXlTN2yDbLckbDnnRjkJreJqmZ+6Yv00Q/
         Xkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Y8XpZ0jbwDFlmqM0FO43fJzaMOOVAAU8FbN4RXs5fU=;
        b=UwX8ol508qjg9++HDOCx8LguboeSoZ+UxGm3IPgAx52yv16UZ50q2x2l/BO2ixJafp
         Lgi+F/lim16P9jT83+FcDP90DVI5/sHjhCn7cCuHsd3yTsgfwG3xLQG5bXeX5DACrMJn
         IYYkWY0Buwat/tiFQ6cWKr4CfMaOy78fAXjiYjOG3PSHwuBB04UoSX6ndbG1cNVm6/Iu
         E75ND1MxK8i4YXqBMJQy8o5kf2muUx5yyfffRWopTTvEFRF22AFkilc8Xe2LkbbLyse6
         7zPnaU2sdU7MArSvjdF5lLqDly9+qWhIpe4WsmMiD04uQeuGC6CdrFO7q+vI3455I4lI
         l3mw==
X-Gm-Message-State: AOAM532KPBmfl0qqKsWQ4vo75+BXZ3XTbP4Q/kUVbn3WunPA46XirW4P
        tWPIrzpqGOq0i+fjah9A/DzMZwxZ0xVdtVfDsA==
X-Google-Smtp-Source: ABdhPJwUvw0EQwlSeaP8j9GelrzN3KUA76z+jpBzZQI7H4n+z7M8GILQyBiBg0irhBeAlgDTwFfl/fdNh7IVTI24SKw=
X-Received: by 2002:a25:bc47:: with SMTP id d7mr8775647ybk.180.1593210345655;
 Fri, 26 Jun 2020 15:25:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200626081720.5546-1-danieltimlee@gmail.com> <20200626081720.5546-3-danieltimlee@gmail.com>
 <CAEf4BzbGk2xSGAkLEXKSg3NhrL28o+cmW9jTq2=EhggJEYT=5Q@mail.gmail.com>
 <CAEKGpziJWYDhnq=DWvcFdSAA-jnGk=Vrci2A-9ktY6g5_4Ki8Q@mail.gmail.com> <CAEf4BzZZxQr4QzTyL-6n0XE=aSBQFhLSNXU=aBxzu5tofgiVRA@mail.gmail.com>
In-Reply-To: <CAEf4BzZZxQr4QzTyL-6n0XE=aSBQFhLSNXU=aBxzu5tofgiVRA@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 27 Jun 2020 07:25:30 +0900
Message-ID: <CAEKGpzjF==ULpZKnaD4viKdbh4a=m_B2Z7-5adk4pRByNF5iXA@mail.gmail.com>
Subject: Re: [PATCH 3/3] samples: bpf: refactor BPF map in map test with libbpf
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Sat, Jun 27, 2020 at 7:19 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jun 26, 2020 at 3:14 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > On Sat, Jun 27, 2020 at 5:30 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Fri, Jun 26, 2020 at 1:18 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> > > >
> > > > From commit 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map
> > > > support"), a way to define internal map in BTF-defined map has been
> > > > added.
> > > >
> > > > Instead of using previous 'inner_map_idx' definition, the structure to
> > > > be used for the inner map can be directly defined using array directive.
> > > >
> > > >     __array(values, struct inner_map)
> > > >
> > > > This commit refactors map in map test program with libbpf by explicitly
> > > > defining inner map with BTF-defined format.
> > > >
> > > > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > > > ---
> > >
> > > Thanks for the clean up, looks good except that prog NULL check.
> > >
> >
> > I'll fix this NULL check as well too.
> >
> > > It also seems like this is the last use of bpf_map_def_legacy, do you
> > > mind removing it as well?
> > >
> >
> > Actually, there is one more place that uses bpf_map_def_legacy.
> > map_perf_test_kern.c is the one, and I'm currently working on it, but
> > I'm having difficulty with refactoring this file at the moment.
> >
> > It has a hash_map map definition named inner_lru_hash_map with
> > BPF_F_NUMA_NODE flag and '.numa_node = 0'.
> >
> > The bpf_map_def in libbpf has the attribute name map_flags but
> > it does not have the numa_node attribute. Because the numa node
>
> It does since 1 or 2 days ago ([0])
>
>   [0] https://patchwork.ozlabs.org/project/netdev/patch/20200621062112.3006313-1-andriin@fb.com/
>
>
> > for bpf_map_def cannot be explicitly specified, this means that there
> > is no way to set the numa node where the map will be placed at the
> > time of bpf_object__load.
> >
> > The only approach currently available is not to use libbbpf to handle
> > everything (bpf_object_load), but instead to create a map directly with
> > specifying numa node (bpf_load approach).
> >
> >     bpf_create_map_in_map_node
> >     bpf_create_map_node
> >
> > I'm trying to stick with the libbpf implementation only, and I'm wondering
> > If I have to create bpf maps manually at _user.c program.
> >
> > Any advice and suggestions will be greatly appreciated.
> >
>
> It should be super straightforward now with a BTF-defined map
> supporting numa_node attribute.
>

Awesome, thanks for letting me know!

I will use this new attribute for the map_perf_test refactoring.
Problem Solved!

Thanks.

> > Thanks for your time and effort for the review.
> > Daniel.
> >
> > >
> > > >  samples/bpf/Makefile               |  2 +-
> > > >  samples/bpf/test_map_in_map_kern.c | 85 +++++++++++++++---------------
> > > >  samples/bpf/test_map_in_map_user.c | 53 +++++++++++++++++--
> > > >  3 files changed, 91 insertions(+), 49 deletions(-)
> > > >
> > >
> > > [...]
> > >
> > > >
> > > >         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> > > > +       obj = bpf_object__open_file(filename, NULL);
> > > > +       if (libbpf_get_error(obj)) {
> > >
> > > this is right, but...
> > >
> > > > +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> > > > +               return 0;
> > > > +       }
> > > >
> > > > -       if (load_bpf_file(filename)) {
> > > > -               printf("%s", bpf_log_buf);
> > > > -               return 1;
> > > > +       prog = bpf_object__find_program_by_name(obj, "trace_sys_connect");
> > > > +       if (libbpf_get_error(prog)) {
> > >
> > > this is wrong. Just NULL check. libbpf APIs are not very consistent
> > > with what they return, unfortunately.
> > >
> > > > +               printf("finding a prog in obj file failed\n");
> > > > +               goto cleanup;
> > > > +       }
> > > > +
> > >
> > > [...]
