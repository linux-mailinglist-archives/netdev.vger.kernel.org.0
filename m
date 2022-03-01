Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 711A94C806E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 02:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiCABqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 20:46:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiCABqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 20:46:07 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9F360D9;
        Mon, 28 Feb 2022 17:45:27 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id d19so16888165ioc.8;
        Mon, 28 Feb 2022 17:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TR4SHhMCy3wCIj9Dqc/7VvQWliwWT1kyKKWHKA3sBy8=;
        b=BHlOaLwkGqItJ+SyMdmkqekTCICYZCctmwJqCdYVkbjyEmSCT9ad4SgQh7GiFycluG
         n3di8hgqOztKYQuolH2cRsmP1JFJlq0z7xj1TN+Rton0ApCB8hSjQvAdr76b5GT7n5RJ
         DCsKDthxd03epQjIsfVYLERy6M/VFGBdLUvlu6i7nJG4g9tYvALlyaMaMKAfO7eOsZVu
         5sKRgroGhtXIEEX7O2Rb5o2EcU8a73hvq7yLpOcNE5/ZvE8E+pCHnakDxAdFTaItN7YJ
         /w4WDaQD8X94oU22/STJzNHEwI+CLYsHh2Udv65P2gayGzSmEnWzGjdbdUJoQeAQQjxL
         jyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TR4SHhMCy3wCIj9Dqc/7VvQWliwWT1kyKKWHKA3sBy8=;
        b=IltSt5Ksh4NxPLWp6Q0AbO93gHzuX9mLc0Qk4UX3yCG+Md7p0J7VnvHvUpmsL+kPmw
         +XYdO1f0iva3zCjLnvNpf01YT7NDv6gEhlCQqf1L7CTAfYd0eIWjFqwUoPt5c48dZ7Hp
         pmZvqFAW+vUEwNE8SJshlBq0TCsr4Bu6vXssKVjXcuROVGXOthCUk5JAQfngKkxw2Qiv
         9oS4nHdbc4v3UtFBzc7Hqi+V0RIsUaMs1swrOtaI/gltBD/nCV6vnkHL8qLZPCTL62rX
         cQzBBEsoc+JIK8t1y4OM92EZwXv4NMcTZWexTDw2s6FdEOsvLN+KyhfrXxMxMq3mejk4
         CukQ==
X-Gm-Message-State: AOAM532/ngrmQBND1SB8A41R2FqCmNC+lb7Xy+YCyier6nKenIW2hxPc
        dcYXohZv50VsPSVdMlH2mj9akbWx2TSKNCqGrX0=
X-Google-Smtp-Source: ABdhPJw4oquVajESMZtu6+WwUAHEBWUDqMtlrN/VTyGGMfuMMBUPCyTzhuPMNuZodWnBiQWQWuB2BAX+mEDJtqjegtw=
X-Received: by 2002:a05:6638:1035:b0:306:e5bd:36da with SMTP id
 n21-20020a056638103500b00306e5bd36damr19947735jan.145.1646099126496; Mon, 28
 Feb 2022 17:45:26 -0800 (PST)
MIME-Version: 1.0
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com>
 <1643645554-28723-3-git-send-email-alan.maguire@oracle.com>
 <CAEf4Bzb9xhpn5asJo7cwhL61DawqtuL_MakdU0YZwOeWuaRq6A@mail.gmail.com>
 <alpine.LRH.2.23.451.2202230924001.26488@MyRouter.home> <CAEf4BzYzgc8GndgC9GKYaTLK-04BqNOrD3BjdKJ8ko+ShzUXvQ@mail.gmail.com>
 <alpine.LRH.2.23.451.2202241532540.26734@MyRouter>
In-Reply-To: <alpine.LRH.2.23.451.2202241532540.26734@MyRouter>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 28 Feb 2022 17:45:15 -0800
Message-ID: <CAEf4BzYfE0Jo7E4-Tadkgx1P=67H01E90zGJpFzFyuzXGy_PnQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/4] libbpf: add auto-attach for uprobes based
 on section name
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 7:40 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> On Thu, 24 Feb 2022, Andrii Nakryiko wrote:
>
> > On Wed, Feb 23, 2022 at 1:33 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > >
> > > On Fri, 4 Feb 2022, Andrii Nakryiko wrote:
> > >
> > > > On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
> > > > >
> > > > > Now that u[ret]probes can use name-based specification, it makes
> > > > > sense to add support for auto-attach based on SEC() definition.
> > > > > The format proposed is
> > > > >
> > > > >         SEC("u[ret]probe//path/to/prog:[raw_offset|[function_name[+offset]]")
> > > > >
> > > > > For example, to trace malloc() in libc:
> > > > >
> > > > >         SEC("uprobe//usr/lib64/libc.so.6:malloc")
> > > >
> > > > I assume that path to library can be relative path as well, right?
> > > >
> > > > Also, should be look at trying to locate library in the system if it's
> > > > specified as "libc"? Or if the binary is "bash", for example. Just
> > > > bringing this up, because I think it came up before in the context of
> > > > one of libbpf-tools.
> > > >
> > >
> > > This is a great suggestion for usability, but I'm trying to puzzle
> > > out how to carry out the location search for cases where the path
> > > specified is not a relative or absolute path.
> > >
> > > A few things we can can do - use search paths from PATH and
> > > LD_LIBRARY_PATH, with an appended set of standard locations
> > > such as /usr/bin, /usr/sbin for cases where those environment
> > > variables are missing or incomplete.
> > >
> > > However, when it comes to libraries, do we search in /usr/lib64 or
> > > /usr/lib? We could use whether the version of libbpf is 64-bit or not I
> > > suppose, but it's at least conceivable that the user might want to
> > > instrument a 32-bit library from a 64-bit libbpf.  Do you think that
> > > approach is sufficient, or are there other things we should do? Thanks!
> >
> > How does dynamic linker do this? When I specify "libbpf.so", is there
> > some documented algorithm for finding the library? If it's more or
> > less codified, we could implement something like that. If not, well,
> > too bad, we can do some useful heuristic, but ultimately there will be
> > cases that won't be supported. Worst case user will have to specify an
> > absolute path.
> >
>
> There's a nice description in [1]:
>
>        If filename is NULL, then the returned handle is for the main
>        program.  If filename contains a slash ("/"), then it is
>        interpreted as a (relative or absolute) pathname.  Otherwise, the
>        dynamic linker searches for the object as follows (see ld.so(8)
>        for further details):
>
>        o   (ELF only) If the calling object (i.e., the shared library or
>            executable from which dlopen() is called) contains a DT_RPATH
>            tag, and does not contain a DT_RUNPATH tag, then the
>            directories listed in the DT_RPATH tag are searched.
>
>        o   If, at the time that the program was started, the environment
>            variable LD_LIBRARY_PATH was defined to contain a colon-
>            separated list of directories, then these are searched.  (As
>            a security measure, this variable is ignored for set-user-ID
>            and set-group-ID programs.)
>
>        o   (ELF only) If the calling object contains a DT_RUNPATH tag,
>            then the directories listed in that tag are searched.
>
>        o   The cache file /etc/ld.so.cache (maintained by ldconfig(8))
>            is checked to see whether it contains an entry for filename.
>
>        o   The directories /lib and /usr/lib are searched (in that
>            order).
>
> Rather than re-inventing all of that however, we could use it
> by dlopen()ing the file when it is a library (contains .so) and
> is not a relative/absolute path, and then use dlinfo()'s
> RTLD_DI_ORIGIN command to extract the path discovered, and then
> dlclose() it. It would require linking libbpf with -ldl however.
> What do you think?

What do I think about dlopen()'ing some random library under root by
libbpf into the host process?.. I'd say that's a bad idea.

I'd probably start with just checking /lib, /usr/lib (and maybe those
32-bit and 64-bit specific ones, depending on host architecture; not
sure about all the details there, tbh). Or just say that the path to
the shared library has to be specified.

There is a similar problem with doing something like
SEC("uprobe/bash:readline"). Do we want to "search" for bash? I think
bpftrace is supporting that, but I haven't checked what it is doing.


>
> Alan
>
> [1] https://man7.org/linux/man-pages/man3/dlopen.3.html
>
> > >
> > > Alan
> >
