Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07F333A167
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 22:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbhCMV1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 16:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbhCMV1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 16:27:43 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792DAC061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:27:43 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so12437343pjh.1
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 13:27:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+H/EnRfTuQufmbXBvgGLKjo/TESfoU/w3UbxirRTiA4=;
        b=qnUebNFOkaIaRMhkX474bguQwMHUv1WBiMUcAmZU/shjo6N+zpKYmeJUDIJnQDXfHc
         9dwM2uzR+BVjKQLMhFoFhUSU+yJW0SyaatAOUnAP1vdGmsi2L+hPcolta0UwN4YmHnyk
         XgRixaJkg9DiCFp5bq2oEiBdjFmqhZCVvrznqkMaHurn3TYXONtL7tImjFnRVtrrCHkV
         ShKh903j4iApYA5RsV5YJxy8VFmsOrywUBS7QJrt0IiSZWBNZJqy1um7aTKzZjVk12PR
         6ayj1PSC5k1qJ4v1/enMLQCH7fBXLny7IN08ea0977HRrDgnmDnM21Se7jqxGoc5RAA9
         G3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+H/EnRfTuQufmbXBvgGLKjo/TESfoU/w3UbxirRTiA4=;
        b=nGd2s0bk8YD5Kgv+G4zlpj3umCLc3AXZxryWlxsWeZweqmI2OQtqUqe5435OYtc68L
         /pVgxCQzvEOivnjRNb34UMy58fVb6UbMnvJSOiJPp0J3rJdAKdBvNR0zmNOi2V/eat7C
         IPzao2/1L4BSsQpiqiI85bS7uz71bVmG1FQxWpMCtJUX60Xh1d1QXQTV/yvSnU135+TJ
         V2wZk82OzoeByTmPwq0yQcatUdTget/nBW9AbOC4JDqfWgwBuy7Bk8o8F/HV04sKCzsI
         fJvQf1Uqni0psC1CggE+VOOkl6gekEcfe7roDTIlu90pOV/512295GqHgWvdtzWRLEkD
         pD4w==
X-Gm-Message-State: AOAM530xl8K0sK5A+Jr+7ypY+mbElbk952bJW/knbKeyrg1HgWaXfH0Z
        k4spAB9k1uU4KlNXq8uY3laHrRc9A33qLGHjWp7Ocw==
X-Google-Smtp-Source: ABdhPJyADDUPTrdAV18cewno2JnELwNElxuW7/wdQYGdWOVnh62k1XLskCaVxv8rGG+2MkMdZxnEAQqkLnwWz5S1J+c=
X-Received: by 2002:a17:902:10a:b029:e2:e8f7:2988 with SMTP id
 10-20020a170902010ab02900e2e8f72988mr4754802plb.4.1615670862500; Sat, 13 Mar
 2021 13:27:42 -0800 (PST)
MIME-Version: 1.0
References: <20210310040431.916483-1-andrii@kernel.org> <20210310040431.916483-8-andrii@kernel.org>
 <9f44eedf-79a3-0025-0f31-ee70f2f7d98b@isovalent.com> <CAEf4BzZKFKQQSQmNPkoSW8b3NEvRXirkqx-Hewt1cmRE9tPmHw@mail.gmail.com>
 <7c78ba67-03ff-fd84-339e-08628716abdf@isovalent.com> <CAEf4BzZGYdTVWf3dp6FvBu+ogd491CXky5v708OzQG8oyYoCOQ@mail.gmail.com>
In-Reply-To: <CAEf4BzZGYdTVWf3dp6FvBu+ogd491CXky5v708OzQG8oyYoCOQ@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Sat, 13 Mar 2021 21:27:31 +0000
Message-ID: <CACdoK4Kv19M10sOSoDo5veDE0xu3C1Rd3TM-7bQ2i9a_3=_r1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] bpftool: add `gen bpfo` command to perform
 BPF static linking
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 13 Mar 2021 at 18:37, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Mar 12, 2021 at 10:07 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >
> > 2021-03-11 10:45 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > > On Thu, Mar 11, 2021 at 3:31 AM Quentin Monnet <quentin@isovalent.com> wrote:
> > >>
> > >> 2021-03-09 20:04 UTC-0800 ~ Andrii Nakryiko <andrii@kernel.org>
> > >>> Add `bpftool gen bpfo <output-file> <input_file>...` command to statically
> > >>> link multiple BPF object files into a single output BPF object file.
> > >>>
> > >>> Similarly to existing '*.o' convention, bpftool is establishing a '*.bpfo'
> > >>> convention for statically-linked BPF object files. Both .o and .bpfo suffixes
> > >>> will be stripped out during BPF skeleton generation to infer BPF object name.
> > >>>
> > >>> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > >>> ---
> > >>>  tools/bpf/bpftool/gen.c | 46 ++++++++++++++++++++++++++++++++++++++++-
> > >>>  1 file changed, 45 insertions(+), 1 deletion(-)
> > >>>
> > >>> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> > >>> index 4033c46d83e7..8b1ed6c0a62f 100644
> > >>> --- a/tools/bpf/bpftool/gen.c
> > >>> +++ b/tools/bpf/bpftool/gen.c

> > >>> @@ -611,6 +654,7 @@ static int do_help(int argc, char **argv)
> > >>>
> > >>>  static const struct cmd cmds[] = {
> > >>>       { "skeleton",   do_skeleton },
> > >>> +     { "bpfo",       do_bpfo },
> > >>>       { "help",       do_help },
> > >>>       { 0 }
> > >>>  };
> > >>>
> > >>
> > >> Please update the usage help message, man page, and bash completion,
> > >> thanks. Especially because what "bpftool gen bpfo" does is not intuitive
> > >> (but I don't have a better name suggestion at the moment).
> > >
> > > Yeah, forgot about manpage and bash completions, as usual.
> > >
> > > re: "gen bpfo". I don't have much better naming as well. `bpftool
> > > link` is already taken for bpf_link-related commands. It felt like
> > > keeping this under "gen" command makes sense. But maybe `bpftool
> > > linker link <out> <in1> <in2> ...` would be a bit less confusing
> > > convention?
> >
> > "bpftool linker" would have been nice, but having "bpftool link", I
> > think it would be even more confusing. We can pass commands by their
> > prefixes, so is "bpftool link" the command "link" or a prefix for
> > "linker"? (I know it would be easy to sort out from our point of view,
> > but for regular users I'm sure that would be confusing).
>
> right
>
> >
> > I don't mind leaving it under "bpftool gen", it's probably the most
> > relevant command we have. As for replacing the "bpfo" keyword, I've
> > thought of "combined", "static_linked", "archive", "concat". I write
> > them in case it's any inspiration, but I find none of them ideal :/.
>
> How about "bpftool gen object", which can be shortened in typing to
> just `bpftool gen obj`. It seems complementary to `gen skeleton`. You
> first generate object (from other objects generated by compiler, which
> might be a bit confusing at first), then you generate skeleton from
> the object. WDYT?

Sounds good, better than "bpfo" I think.

Quentin
