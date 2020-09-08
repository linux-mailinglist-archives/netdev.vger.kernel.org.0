Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED547262386
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgIHXU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgIHXUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:20:54 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B13FC061573;
        Tue,  8 Sep 2020 16:20:53 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id c17so573894ybe.0;
        Tue, 08 Sep 2020 16:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lJG1i3EG0QFtZs8oLoRkWr41fA0fPNnDTLtp0CvkeBc=;
        b=T5f20tpGNbSOB0xx9CuqEIsit0MuSoU43lcZFkL3hgnH4/oq4kdivuIdbT5rzf6ZIK
         Yi1rfXAA5kBivcqtN+4x7XojnEjDLmJbCphSYS7Xn4WzloOSODcZUJRRDCmSDwx0KntD
         5KL9r3lSNzhqCpPJtRINnCl61AbRn7/H/+Ts2vwl4HmumWRErEA+D9tghjrRaGhsMScv
         iYiSY1NNWb5esA7GCaYhXQkz2b7xX3238Kdgigfzitkz6zeH5+ahyjoQ6RbggiT/wnei
         VDBlBMpvd48GkdLogbw4ROc0SqbgggcgRMzHyKwdefI+Ss4G3H6DSkCox3cRIX+DnGo7
         QsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lJG1i3EG0QFtZs8oLoRkWr41fA0fPNnDTLtp0CvkeBc=;
        b=fCFTVZ4Mo36jDQA2QtXa5pTzS9P0+mgWlMhsZbVu/vmjUKFFulYO51I2fC0ziymBj9
         NwpjCF+NsP1JOZvjz43Mdw2j+q8g2kkZ9mFAdLD2zyFamg/yfox7scQ6MJT4tgnsnmQZ
         qlizN31ZXJQtKha0u+JHaHvtkDQUMe+oCvmc6hHtGOQgOREda4ujCViR/zUBJMxNyOg6
         sRpcgwl+d4A93tW9w9s0FaeA3sHobIfDFqSN8YNY8iipQFVSBcUq20tF4PECslvaHKQ7
         LucT9bUuW533OqR9l7AOiEWCctbsNSlpHWLU094uPtQ8sFuGR9f5jw13Z5HRd+zypd18
         VcXg==
X-Gm-Message-State: AOAM531dPjfmrOUtoFAUTtUd5x41NAka07lE7C1QwyHpjI3mqfPTon7O
        7FTOKS3dutr+YjzxZ0y+Sn8cy2J44wA7FPnxkm0IpRr7
X-Google-Smtp-Source: ABdhPJxRmQ2pIdVJPGvNvnF230eyD4GzAJmX7eFpVYfeavq8P5R5zZ1V1sRB6d49Bg/Npe5oa7SUZBvkVLnZRvK7CYw=
X-Received: by 2002:a25:e655:: with SMTP id d82mr1998914ybh.347.1599607252119;
 Tue, 08 Sep 2020 16:20:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200904205657.27922-1-quentin@isovalent.com> <20200904205657.27922-2-quentin@isovalent.com>
 <CAEf4Bzbf_igYVP+NfrVV86AZGQT7+2NF1JR6GzcEOymV9_vgNA@mail.gmail.com> <05b0ff4c-cf69-a452-6c0e-187ec2961063@isovalent.com>
In-Reply-To: <05b0ff4c-cf69-a452-6c0e-187ec2961063@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 16:20:41 -0700
Message-ID: <CAEf4BzZwFsVPjR+cwvvuuhfAMy0AW=+=oe4bF-1fH8rxsOmeBw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] tools: bpftool: print optional built-in
 features along with version
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 7:50 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 04/09/2020 22:45, Andrii Nakryiko wrote:
> > On Fri, Sep 4, 2020 at 1:57 PM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> Bpftool has a number of features that can be included or left aside
> >> during compilation. This includes:
> >>
> >> - Support for libbfd, providing the disassembler for JIT-compiled
> >>   programs.
> >> - Support for BPF skeletons, used for profiling programs or iterating on
> >>   the PIDs of processes associated with BPF objects.
> >>
> >> In order to make it easy for users to understand what features were
> >> compiled for a given bpftool binary, print the status of the two
> >> features above when showing the version number for bpftool ("bpftool -V"
> >> or "bpftool version"). Document this in the main manual page. Example
> >> invocation:
> >>
> >>     $ bpftool -p version
> >>     {
> >>         "version": "5.9.0-rc1",
> >>         "features": [
> >>             "libbfd": true,
> >>             "skeletons": true
> >>         ]
> >
> > Is this a valid JSON? array of key/value pairs?
>
> No it's not, silly me :'(. I'll fix that, thanks for spotting it.
>
> >>     }
> >>
> >> Some other parameters are optional at compilation
> >> ("DISASM_FOUR_ARGS_SIGNATURE", LIBCAP support) but they do not impact
> >> significantly bpftool's behaviour from a user's point of view, so their
> >> status is not reported.
> >>
> >> Available commands and supported program types depend on the version
> >> number, and are therefore not reported either. Note that they are
> >> already available, albeit without JSON, via bpftool's help messages.
> >>
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> ---
> >>  tools/bpf/bpftool/Documentation/bpftool.rst |  8 +++++++-
> >>  tools/bpf/bpftool/main.c                    | 22 +++++++++++++++++++++
> >>  2 files changed, 29 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tools/bpf/bpftool/Documentation/bpftool.rst b/tools/bpf/bpftool/Documentation/bpftool.rst
> >> index 420d4d5df8b6..a3629a3f1175 100644
> >> --- a/tools/bpf/bpftool/Documentation/bpftool.rst
> >> +++ b/tools/bpf/bpftool/Documentation/bpftool.rst
> >> @@ -50,7 +50,13 @@ OPTIONS
> >>                   Print short help message (similar to **bpftool help**).
> >>
> >>         -V, --version
> >> -                 Print version number (similar to **bpftool version**).
> >> +                 Print version number (similar to **bpftool version**), and
> >> +                 optional features that were included when bpftool was
> >> +                 compiled. Optional features include linking against libbfd to
> >> +                 provide the disassembler for JIT-ted programs (**bpftool prog
> >> +                 dump jited**) and usage of BPF skeletons (some features like
> >> +                 **bpftool prog profile** or showing pids associated to BPF
> >> +                 objects may rely on it).
> >
> > nit: I'd emit it as a list, easier to see list of features visually
> >
> >>
> >>         -j, --json
> >>                   Generate JSON output. For commands that cannot produce JSON, this
> >> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> >> index 4a191fcbeb82..2ae8c0d82030 100644
> >> --- a/tools/bpf/bpftool/main.c
> >> +++ b/tools/bpf/bpftool/main.c
> >> @@ -70,13 +70,35 @@ static int do_help(int argc, char **argv)
> >>
> >>  static int do_version(int argc, char **argv)
> >>  {
> >> +#ifdef HAVE_LIBBFD_SUPPORT
> >> +       const bool has_libbfd = true;
> >> +#else
> >> +       const bool has_libbfd = false;
> >> +#endif
> >> +#ifdef BPFTOOL_WITHOUT_SKELETONS
> >> +       const bool has_skeletons = false;
> >> +#else
> >> +       const bool has_skeletons = true;
> >> +#endif
> >> +
> >>         if (json_output) {
> >>                 jsonw_start_object(json_wtr);
> >> +
> >>                 jsonw_name(json_wtr, "version");
> >>                 jsonw_printf(json_wtr, "\"%s\"", BPFTOOL_VERSION);
> >> +
> >> +               jsonw_name(json_wtr, "features");
> >> +               jsonw_start_array(json_wtr);
> >> +               jsonw_bool_field(json_wtr, "libbfd", has_libbfd);
> >> +               jsonw_bool_field(json_wtr, "skeletons", has_skeletons);
> >> +               jsonw_end_array(json_wtr);
> >> +
> >>                 jsonw_end_object(json_wtr);
> >>         } else {
> >>                 printf("%s v%s\n", bin_name, BPFTOOL_VERSION);
> >> +               printf("features: libbfd=%s, skeletons=%s\n",
> >> +                      has_libbfd ? "true" : "false",
> >> +                      has_skeletons ? "true" : "false");
> >
> > now imagine parsing this with CLI text tools, you'll have to find
> > "skeletons=(false|true)" and then parse "true" to know skeletons are
> > supported. Why not just print out features that are supported?
>
> You could just grep for "skeletons=true" (not too hard) (And generally
> speaking I'd recommend against parsing bpftool's plain output, JSON is
> more stable - Once you're parsing the JSON, checking the feature is
> present or checking whether it's at "true" does not make a great
> difference).
>
> Anyway, the reason I have those booleans is that if you just list the
> features and run "bpftool version | grep libbpfd" and get no result, you
> cannot tell if the binary has been compiled without the disassembler or
> if you are running an older version of bpftool that does not list
> built-in features. You could then parse the version number and double
> check, but you need to find in what version the change has been added.
> Besides libbfd and skeletons, this could happen again for future
> optional features if we add them to bpftool but forget to immediately
> add the related check for "bpftool version".

Now you are making this into a list of potential features that could
be supported if only they were built with proper dependencies, don't
you think?

I thought the idea is to detect if a given bpftool that you have
supports, say, skeleton feature. Whether it's too old to support it or
it doesn't support because it wasn't built with necessary dependencies
is immaterial -- it doesn't support the feature, if there is no
"skeleton" in a list of features.

Continuing your logic -- parse JSON if you want to know this. In JSON
having {"skeleton": false, "libbfd": true"} feels natural. In
human-oriented plain text output seeing "features: libbpf=false,
skeleton=true" looks weird, instead of just "features: skeleton", IMO.

>
> So I would be inclined to keep the booleans. Or do you still believe a
> list is preferable?
>

I still believe plain text should be minimal and simple, but won't
argue further :)

> Quentin
